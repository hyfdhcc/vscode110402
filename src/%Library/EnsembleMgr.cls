Include (%occInclude, %occErrors, %cspInclude, %syConfig, %sySecurity, %syNLS)

Class %Library.EnsembleMgr [ System = 4 ]
{

/// Portal homepage for this version of Ensemble
Parameter PORTALHOMEPAGE As %String = "%25CSP.Portal.Home.zen";

/// Default CSP authentication methods
Parameter DEFAULTCSPAUTHMETHODS As %Integer = 32;

/// Default database resource name
Parameter DEFAULTDBRESOURCE As %String = "%DB_%DEFAULT";

// 32=$$$AutheCache

/// Remove ENSLIB namespace if it already exists AND doesn't reference
/// any data or routines mapped from other databases.
Parameter REMOVEEENSLIBNAMESPACE As BOOLEAN = 1;

/// Create the ENSLIB namespace during upgrades/installs.
Parameter CREATEENSLIBNAMESPACE As BOOLEAN = 0;

/// Flag to control whether the legacy CSP portal should be created.
Parameter CREATELEGACYPORTAL As BOOLEAN = 0;

/// Flag to control whether old CSP pages and files should be removed.
Parameter REMOVELEGACYPORTAL As BOOLEAN = 1;

/// Default ENSLIB
Parameter ENSLIB As %String = "ENSLIB";

/// Default HSLIB
Parameter HSLIB As %String = "HSLIB";

/// where the viewer will get installed
Parameter VIEWERLIB As %String = "VIEWERLIB";

/// Suffix for temporary global database
Parameter TEMPSUFFIX As %String = "ENSTEMP";

/// Suffix for secondary global database
Parameter SECONDARYSUFFIX As %String = "SECONDARY";

/// Checks for Ensemble installation
ClassMethod IsEnsembleInstalled() As %Boolean [ CodeMode = expression ]
{
''$D(^%SYS("Ensemble","InstalledNamespace"))
}

/// Checks if DICOM is installed
ClassMethod IsDICOMInstalled() As %Boolean [ CodeMode = expression ]
{
..IsEnsembleInstalled()&&(''$Data(^|..GetENSLIB(1)|EnsDICOM.Dictionary))
}

/// Checks for HealthShare installation
ClassMethod IsHealthShareInstalled() As %Boolean [ Internal ]
{
	Set tInstalled=0
	try {
		Set tInstalled=##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstalled()
	} Catch ex {
	}
	Quit tInstalled
}

/// Deprecated, retained for backward compatibility
ClassMethod IsFoundationInstalled() As %Boolean [ Internal ]
{
	Set tInstalled=0
	try {
		Set tInstalled=##class(%ZHSLIB.HealthShareMgr).IsFoundationInstalled()
	} Catch ex {
	}
	Quit tInstalled
}

/// Checks if current namespace is Ensemble-enabled
ClassMethod IsEnsembleNamespace(pNamespace = {$namespace}) As %Boolean
{
	#dim tIsEnsNS As %Boolean = 0
	Try {
		Set tIsEnsNS = $select(pNamespace = "%SYS": 0, 1: ''$Data(^|pNamespace|oddCOM("Ens.StudioManager")))
	}	
	Catch { 
		#; If the above check fails, the user doesn't have permission for the Ensemble ^oddCOM nodes
	}
	Quit tIsEnsNS
}

/// Checks if current namespace is HealthShare-enabled
ClassMethod IsHealthShareNamespace(pNamespace = {$namespace}) As %Boolean
{
	Set tIsNS=0
	try {
		Set tIsNS=##class(%ZHSLIB.HealthShareMgr).IsHealthShareNamespace(pNamespace)
	} Catch ex {
	}
	Quit tIsNS
}

/// Get the directory or implicit namespace for the ENSLIB database.
/// <var>pImplicit</var> indicates whether the full implicit namespace should be returned,
/// and <var>pNormalized</var> indicates whether the directory should be normalized.
ClassMethod GetENSLIB(pImplicit As %Boolean = 0, pNormalized As %Boolean = 1) As %String [ CodeMode = expression ]
{
$select(pImplicit: "^^", 1: "")_##class(%Library.File).SubDirectoryName($system.Util.ManagerDirectory(), "enslib", pNormalized)
}

/// Returns the "path" portion of the Ensemble management URL for a given namespace.  If the namespace
/// is *not* Ensemble enabled, then it will return empty string or the default CSP app for the namespace.
/// If <var>pAppendHomePage</var> is false, it will only return the CSP application path.
ClassMethod DetermineMgmtURLForNamespace(pNamespace As %String = {$namespace}, pAppendHomePage As %Boolean = 1) As %String
{
	#dim tUrl As %String
	#dim tDefaultUrl As %String
	Set pNamespace = $ZCVT(pNamespace,"U")
	#; Use EnsPortal.EventLog because %CSP.Portal.Home is always mapped to /csp/sys/
	Set tDefaultUrl = $system.CSP.GetPortalApp(pNamespace,"EnsPortal.EventLog.zen")
	If tDefaultUrl = "" Quit ""
	If ..IsHealthShareNamespace(pNamespace) {
		Set tUrl="/csp/healthshare/"_$TR($ZCVT(pNamespace,"L"),"%")_"/"_$S(pAppendHomePage=0:"",1:..#PORTALHOMEPAGE)
	} ElseIf $DATA(^%SYS("Ensemble","InstalledNamespace",pNamespace)) {
		// Grab the URL from the global (if present)
		Set tUrl = ^%SYS("Ensemble","InstalledNamespace",pNamespace)
		
		// Ensure it isn't just a suffix (or "")
		If tUrl = "" {
			Set tUrl = tDefaultUrl
		}
		ElseIf $extract(tUrl,1) '= "/" {
			Set tUrl = tDefaultUrl _ $select($extract(tDefaultUrl,*) = "/": "", 1: "/") _ tUrl
		}
		
		// And add the page part
		If $P(tUrl,"/",$L(tUrl,"/"))'["." {
			Set:$E(tUrl,$L(tUrl))'="/" tUrl = tUrl_"/"
			If pAppendHomePage {
				Set tUrl = tUrl _ ..#PORTALHOMEPAGE
			}
		}
	} Else {
		// Use the default App/URL for this namespace
		Set tUrl = tDefaultUrl
		//If there's no end /, then if this gets called by DeleteNamespace, it can delete the wrong app,
		//since that removes the last / piece
		Set:$E(tUrl,$L(tUrl))'="/" tUrl = tUrl_"/"
	}
	
	Quit tUrl
}

ClassMethod OnSystemStartup(Output pConsoleLog As %String, pIsStartup As %Boolean = 0) As %Boolean
{
	New $namespace
	Try {
		Kill pConsoleLog
		Set pConsoleLog=0
		Try {Do ##class(%ZHSLIB.HealthShareMgr).OnStartHealthShare(pIsStartup)} Catch ex {}
		
		If pIsStartup Kill ^%SYS("Ensemble","RunningNamespace")
		
		// Installation checking is now done via an explicit call from ^STU earlier in the install/upgrade process.
		
		If $DATA(^%SYS("Ensemble")) {
			If +$get(^CONFIG("Startup","EnsembleAutoStart")) {
				Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Initializing Ensemble during "_$select(pIsStartup: "system startup", 1: "mirror initialization"))
				If $System.License.GetFeature(1)=0 {
					Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Not licensed for Ensemble, auto-start skipped.")
					Quit
				}
				
				Set tIsPrimary = 1
				Set tIsMirrorMember = $system.Mirror.IsMember()
				If (tIsMirrorMember) {
					Set tIsPrimary = $system.Mirror.IsPrimary()
					Set $namespace = "%SYS"
					Set tSC = ..findMirroredNamespaces(.tMirNamespaces)
					If $$$ISERR(tSC) {
						Set pConsoleLog($increment(pConsoleLog))=$lb(1,"EnsembleAutoStart: Unable to determine which Ensemble namespaces contain mirrored data due to error: "_$system.Status.GetErrorText(tSC)_"; NOT auto-starting productions")
						Quit
					}
					If 'pIsStartup {
						#;Find any Ensemble jobs that are already running on the system
						Set tSC = ..findEnsembleJobs(.tRunningNamespaces)
						If $$$ISERR(tSC) {
							Set pConsoleLog($increment(pConsoleLog))=$lb(1,"EnsembleAutoStart: Unable to determine which Ensemble namespaces contain running Ensemble jobs due to error: "_$system.Status.GetErrorText(tSC)_"; NOT auto-starting productions")
							Quit
						}
						Set tMirNS = ""
						For {
							Set tMirNS = $order(tMirNamespaces(tMirNS))
							Quit:(tMirNS = "")
							If $data(tRunningNamespaces(tMirNS)) Continue
							Kill ^%SYS("Ensemble","RunningNamespace",tMirNS)
						}
					}
				}
				
				Set tNameSpace="" For {
					Set tNameSpace=$o(^%SYS("Ensemble","InstalledNamespace",tNameSpace)) Quit:tNameSpace=""
					#; Ignore mirrored namespaces if we are not the primary
					If ('tIsPrimary) && $data(tMirNamespaces(tNameSpace)) {
						Continue
					}
					#; Don't process non-mirrored namespaces if this node is becoming the primary
					If ('pIsStartup) && '$data(tMirNamespaces(tNameSpace)) {
						Continue
					}
					#; Don't attempt autostart if namespace contains running Ensemble jobs
					If ('pIsStartup) && $data(tRunningNamespaces(tNameSpace)) {
						Set pConsoleLog($increment(pConsoleLog))=$lb(1,"EnsembleAutoStart: Ensemble jobs are running in namespace '"_tNameSpace_"'; NOT attempting to auto-start production in this namespace")
						Continue
					}
					try {
						Set $namespace = tNameSpace
						Set tSC=##class(Ens.Director).SystemStart()
						If $$$ISERR(tSC) {
							Set pConsoleLog($increment(pConsoleLog))=$lb(1,"EnsembleAutoStart: ERROR in namespace '"_$Namespace_"': '"_$system.Status.GetErrorText(tSC)_"' $ZU(56,2)='"_$ZU(56,2)_"'")
						} ElseIf $G(^Ens.AutoStart)'="" {
							Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Ensemble: Starting production '" _ ^Ens.AutoStart _ "' in namespace '"_tNameSpace_"'.")
						}
					} catch {
						Set pConsoleLog($increment(pConsoleLog))=$lb(1,"EnsembleAutoStart: ERROR in namespace '"_$Namespace_"': "_$ZE_" tNameSpace='"_$G(tNameSpace)_"' $ZU(56,2)='"_$ZU(56,2)_"'")
					}
				}
			} Else {
				Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Ensemble auto-start is disabled.")
			}
		}
	}
	Catch ex {
		Set pConsoleLog($increment(pConsoleLog))=$lb(1,"EnsembleAutoStart: ERROR in namespace '"_$Namespace_"': "_$ZE_" tNameSpace='"_$G(tNameSpace)_"' $ZU(56,2)='"_$ZU(56,2)_"'")
	}
	Quit 1
}

ClassMethod OnSystemShutdown(Output pConsoleLog As %String, Output pCancelShutdown As %Boolean) As %Boolean
{
	Set $ZT="Trap"
	do {
		Kill pConsoleLog
		Set pConsoleLog=0
		Set pCancelShutdown=0
		Set tEnsembleRunning=0,tEnsembleTimedOut=0
		Kill ^%SYS("Ensemble","StoppingProduction")
		If $system.Mirror.IsMember() && '$system.Mirror.IsPrimary() {
			Do ..findMirroredNamespaces(.tMirNamespaces)
		}
		; spawn backgroun job to stop productions
		New $NAMESPACE
		Set tNameSpace="" For {
			Set tNameSpace=$o(^%SYS("Ensemble","RunningNamespace",tNameSpace)) Quit:tNameSpace=""
			Continue:$data(tMirNamespaces(tNameSpace))  ; don't do anything if data is in mirrored namespace
			Try {
				Set $NAMESPACE = tNameSpace
				Set ^%SYS("Ensemble","StoppingProduction",tNameSpace,"timeout")=$zh+(##class(Ens.Director).GetRunningProductionShutdownTimeout()*2)+5
				Job ##class(Ens.Director).SystemStop()
				Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Stopping Ensemble production in namespace '"_tNameSpace_" initiated at "_$ZTIME($PIECE($HOROLOG,",",2),1))
				Set tEnsembleRunning=1
			}
			Catch {
				Set pConsoleLog($increment(pConsoleLog))=$lb(1,"ERROR stopping production in namespace "_tNameSpace_": "_$ZE)
			}
		}
		; wait for background jobs to kill ^%SYS("Ensemble","StoppingProduction",tNameSpace)
		For  {
			If $d(^%SYS("Ensemble","StoppingProduction"))=0 Quit
			Set tNameSpace="" For  {
				Set tNameSpace=$o(^%SYS("Ensemble","StoppingProduction",tNameSpace)) Quit:tNameSpace=""
				If $zh>$g(^%SYS("Ensemble","StoppingProduction",tNameSpace,"timeout")) {
					Kill ^%SYS("Ensemble","StoppingProduction",tNameSpace)
					Set tEnsembleTimedOut=1
					Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Stop Ensemble production in namespace '"_tNameSpace_" timed out at "_$ZTIME($PIECE($HOROLOG,",",2),1))
				}
			}
			Hang 1
		}
		If tEnsembleRunning {
			If 'tEnsembleTimedOut {
				Set pConsoleLog($increment(pConsoleLog))=$lb(0,"All Ensemble productions stopped.")
			} Else {
				Set pConsoleLog($increment(pConsoleLog))=$lb(0,"Not all Ensemble productions might be stopped due to time out.")	
			}
		}
	} while (0)
Exit
	Quit
Trap
	Set $ZT="",pConsoleLog($increment(pConsoleLog))=$lb(1,$ZE),pCancelShutdown=0
	Goto Exit
}

/// Helper method which provides a quick heuristic to determine whether any Ensemble jobs
/// are running on a system. If more than two jobs are running in a namespace under the _Ensemble
/// user, then the namespace is considered to contain running Ensemble jobs.
ClassMethod findEnsembleJobs(Output pNamespaces As %String) As %Status [ Internal, Private ]
{
	Try {
		Set tSC = $$$OK
		Kill pNamespaces
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC = tStatement.%Prepare("SELECT Namespace, COUNT(*) As Jobs FROM %SYS.ProcessQuery WHERE UserName = '_Ensemble' AND UserName IS NOT NULL GROUP BY Namespace")
		If $$$ISERR(tSC) Quit
		#dim tRS As %SQL.StatementResult
		Set tRS = tStatement.%Execute()
		While tRS.%Next(.tSC) && $$$ISOK(tSC) {
			If (tRS.Jobs > 2) && (tRS.Namespace '= "") Set pNamespaces(tRS.Namespace) = ""
		}
		If $$$ISERR(tSC) Quit
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Called by ^STU during an installation, update or when becoming primary (which can happen during installation/update or failover).
ClassMethod CheckForInstall(ByRef pConsoleLog As %String, pIsPrimary As %Boolean = {($system.Mirror.IsMember() = 0)||($system.Mirror.IsPrimary())}, pVerbose As %Boolean = 1) [ Internal ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Set $ZT="Trap"
	/*
		This could be called from:
			1) First restart following installation during Manifest^STU
			2) From BecomePrimary^MIRRORMGR via Ensemble^STU. BecomePrimary can be called during installation or during failover.
			3) From normal STU procedure via D Ensemble^STU
	*/
	Set $Test = 0,tWaited=-10
	While '$Test {
		Set tWaited = tWaited+10
		If tWaited Do ##class(%SYS.System).WriteToConsoleLog("CheckForInstall waiting on lock to proceed")
		Lock +^%SYS("Ensemble","RunOnce","InitializeEnsemble"):10
	}
	Set tLockedInitialize=1
	do {
		// Check for Ensemble install/upgrade
		If $DATA(^%SYS("Ensemble","RunOnce","InitializeEnsemble")) {
			Set tProduct = $GET(^%SYS("Ensemble","RunOnce","InitializeEnsemble"))
			Set pConsoleLog($I(pConsoleLog))=$lb(0,"Ensemble: Installing "_tProduct)
			
			// Open a log file
			Set tIO = $IO
			Set tFilenameRoot = "ensinstall"
			Set tFileExtension = ".log"
			Set tCounter = 0
			Set tManagerDir = $system.Util.ManagerDirectory()
			Set tExists = 1
			While tExists {
				Set tCurrFilename = tFilenameRoot _ $select(tCounter > 0: "_"_tCounter, 1: "") _ tFileExtension
				Set tLog = ##class(%File).NormalizeFilename(tCurrFilename,tManagerDir)
				Set tExists = ##class(%Library.File).Exists(tLog)
				Set tCounter = tCounter + 1
			}
			Open tLog:"WNS"
			Use tLog

			// During install, make sure we're in UTF-8 mode so that localized messages don't get corrupted
			$$$SETIO("UTF8")

			$$$REPORT(0,"")
			$$$REPORT(0,"*************************************************************************************")
			$$$REPORT(0,"Installation/upgrade of "_tProduct_" started at "_$zdatetime($zdatetimeh($ztimestamp,-3),3,,3))
			$$$REPORT(0,"*************************************************************************************")
			$$$REPORT(0,"")

	 		// Check whether Ensemble AutoStart is enabled at a system level if we are upgrading from Cache
	 		If '..IsEnsembleInstalled() {
		 		Try {
			 		$$$REPORT(0,"Checking EnsembleAutoStart setting in CPF file.")
			 		Set tToggleCPFAutoStart = 0
			 		Kill tPrevProps
			 		Set tSC = ##class(Config.Startup).Get(.tPrevProps)
			 		If $$$ISERR(tSC) {
				 		$$$REPORT(1,"Error getting properties from Config.Startup: "_$system.Status.GetErrorText(tSC))
			 		}
			 		Else {
				 		Set tToggleCPFAutoStart = (0 = $get(tPrevProps("EnsembleAutoStart"),-1))
			 		}
			 		
			 		If tToggleCPFAutoStart {
				 		$$$REPORT(1,"Enabling EnsembleAutoStart setting in CPF file.")
				 		Kill tProps
				 		Set tProps("EnsembleAutoStart") = 1
				 		Set tSC = ##class(Config.Startup).Modify(.tProps)
				 		If $$$ISERR(tSC) {
				 			$$$REPORT(1,"Error updating Config.Startup: "_$system.Status.GetErrorText(tSC))
			 			}
			 		}
		 		}
		 		Catch ex {
			 		$$$REPORT(1,"Error checking EnsembleAutoStart setting in CPF: "_$system.Status.GetErrorText(ex.AsStatus()))
			 	}
	 		}

	 		Set tSC = $$$OK
	 		If 'pIsPrimary {
		 		Set tSC = ..findMirroredNamespaces(.tMirNamespaces)
		 		If $$$ISOK(tSC) {
			 		Merge pIsPrimary("MirrorNS") = tMirNamespaces
		 		}
	 		}

			// Now let's install
			If $$$ISOK(tSC) {
				Set tSC = ..InitializeEnsemble(1, .pIsPrimary)
			}
		
			If $$$ISOK(tSC) {
				// Check for HealthShare initialization
				If $ZCVT(tProduct,"L")="healthshare" {
					Set tSC = ..InitializeHealthShare(1,, .pIsPrimary)
				}
			}
			
			If $$$ISERR(tSC) {
				// Report this error so it appears in the log
				$$$REPORT(0,"Installation failed: "_$system.Status.GetErrorText(tSC))
			}
			ElseIf 'pIsPrimary {
				Set pConsoleLog($i(pConsoleLog))=$lb(0, "Completed non-primary installation for "_tProduct_"; setting flag for primary upgrade steps")
				$$$REPORT(0,"Installation completed for non-primary instance; setting flag to confirm primary upgrade steps are completed on the next primary startup")
				Set ^%SYS("Ensemble","Mirror","UpdateCheck") = 1
			}
		
			// Close the log file
			Use tIO
			Close tLog
			
			If $$$ISERR(tSC) {
				Set pConsoleLog($I(pConsoleLog))=$lb(1,"Ensemble: install failed, check log "_tLog_": "_$system.Status.GetErrorText(tSC))
			}
		}
		ElseIf pIsPrimary && $data(^%SYS("Ensemble","Mirror","UpdateCheck")) {
			Try {
				Set tIO = $IO
				Do ##class(%Device).Broadcast("", "Confirming completion of Ensemble Mirror upgrade...")
				Set tStartNS = $namespace
				Set tCurrentVersion = ..getVersion()
				
				// Open a log file
				Set tLog = ##class(%File).NormalizeFilename($System.Util.ManagerDirectory()_"ensinstall.log")
				Set tFile = ##class(%IO.FileStream).%New()
				Do tFile.Open(tLog, "RWAES",,"UTF-8",.tSC)
				If $$$ISERR(tSC) Quit
				Use tLog
				$$$REPORT(0,!)
				$$$REPORT(0,"Confirming completion of Ensemble Mirror upgrade...")
				
				$$$REPORT(2,"+ Finding namespaces with mirrored data")
				Set tSC = ..findMirroredNamespaces(.tMirNamespaces)
				If $$$ISERR(tSC) Quit
				
				Set tNS = ""
				For {
					Set tNS = $order(tMirNamespaces(tNS))
					Quit:(tNS = "")
					Set $namespace = tNS
					$$$REPORT(2,"+ Checking upgrade status for namespace "_tNS)
					Set tStoredVersion = $get(^Ens.Mirror("Version"))
					If '$ListSame(tStoredVersion, tCurrentVersion) {
						$$$REPORT(2, "+ Completing Ensemble Mirror upgrade for namespace "_tNS)
						Do ##class(%Device).Broadcast("", "Completing Ensemble Mirror upgrade for namespace "_tNS)
						Set tSC = ..dataUpgradeSteps(tNS,1,..#CREATELEGACYPORTAL)
						If $$$ISERR(tSC) Quit
						$$$REPORT(2, "+ Upgrade completed for namespace "_tNS)
					}
				}
				If $$$ISERR(tSC) Quit
				
				$$$REPORT(0, "Ensemble Mirror upgrade confirmed as complete")
				Do ##class(%Device).Broadcast("", "Ensemble Mirror upgrade confirmed as complete")
				Kill ^%SYS("Ensemble","Mirror","UpdateCheck")
			}
			Catch ex {
				Set tSC = ex.AsStatus()
			}
			Use tIO
			Kill tFile
			Set $namespace = tStartNS
			If $$$ISERR(tSC) {
				Do ##class(%Device).Broadcast("", "Ensemble: install failed, check log "_tLog_": "_$system.Status.GetErrorText(tSC),1)
			}
		}
	} while (0)
Exit
	// Clean this up so we don't do it again
	If $G(tCleanExit,1) Kill ^%SYS("Ensemble","RunOnce","InitializeEnsemble")
	If $G(tLockedInitialize,0) Lock -^%SYS("Ensemble","RunOnce","InitializeEnsemble")
	Quit
Trap
	Set $ZT="",pConsoleLog($increment(pConsoleLog))=$lb(1,$ZE)
	Set tCleanExit = 0
	Goto Exit
}

/// Deprecated method. Use dataUpgradeSteps() instead.
ClassMethod mirrorUpgradeSteps(pTargetNS As %String, pVerbose As %Boolean = 0, pCompileCSPPages As %Boolean = 0) As %Status [ CodeMode = call, Internal ]
{
..dataUpgradeSteps(pTargetNS,pVerbose,pCompileCSPPages)
}

/// Perform Ensemble upgrade steps that modify data and thus need to occur when the instance
/// has write access to the data. The separation is used for mirrors where the primary mirror
/// member needs to complete the upgrade for the mirror set.
ClassMethod dataUpgradeSteps(pTargetNS As %String, pVerbose As %Boolean = 0, pCompileCSPPages As %Boolean = 0) As %Status [ Internal ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Set tSC = $$$OK
	Try {
		New $namespace
		// Change namespace before all upgrade work to try and avoid multiple namespace switches
		Set $namespace = pTargetNS

		Set tOldVersion = $get(^Ens.Mirror("Version"))
		Set tMajorVersion = $listget(tOldVersion,1)
		Set tMinorVersion = $listget(tOldVersion,2)
		Set tMaintVersion = $listget(tOldVersion,3)

		// Upgrade and recompile any rules
		$$$REPORT(4,"* Upgrading Business Rules")
		Set tSC = ..upgradeRules(pTargetNS,pVerbose)
		If $$$ISERR(tSC) Quit
		
		$$$REPORT(4,"* Adding Ensemble SearchTables")
 		Set tSC = ..deploySearchTables(pTargetNS, pVerbose)
 		Quit:$$$ISERR(tSC)
		
		$$$REPORT(4,"* Checking for existing named message searches")
		Set tSC = ..convertCSPXSearches(pTargetNS, pVerbose)
		If $$$ISERR(tSC) Quit
		
		$$$REPORT(4,"* Checking DocClassMap")
		Set tSC = ..upgradeDocClassMap(pTargetNS, pVerbose)
		If $$$ISERR(tSC) Quit
		
		$$$REPORT(4,"* Checking for incorrect Timestamp indices")
		Set tSC = ..CheckUTCIndices(pTargetNS,pVerbose,1)
		If $$$ISERR(tSC) Quit

		If $D(^Ens.Configuration("bp","RetainCompletedInstances")) {
			$$$REPORT(4,"* Moving deprecated ^Ens.Configuration bp settings to ^Ens.Config")
			Merge ^Ens.Config("bp","RetainCompletedInstances") = ^Ens.Configuration("bp","RetainCompletedInstances")
			Kill ^Ens.Configuration("bp","RetainCompletedInstances")
		}

		#; Ensure Ens.Config.Item::Name index added in 2013.1.3 is built on upgrades from older versions.
		#; Note that this also occurs during initial installation, but this should have no negative effects.
		If (tMajorVersion < 2013) || ((tMajorVersion = 2013) && ((tMinorVersion < 2) && (tMaintVersion < 3))) {
			$$$REPORT(4,"* Building Name index for Ens.Config.Item")
			Set tSC = ##class(Ens.Config.Item).%BuildIndices($LB("Name"),1,1)
			If $$$ISERR(tSC) Quit
		}

		Set tCSPApp = ..DetermineMgmtURLForNamespace(pTargetNS,0)
		// Only remove CSP pages if upgrading from a release before 2013.x due to pages missed prior to DDP772
		If (tMajorVersion < 2013) && ..#REMOVELEGACYPORTAL {
			$$$REPORT(4,"* Deleting classes generated from legacy CSP pages")
			Set tPortalDir = $System.Util.InstallDirectory()
			For i=2:1:$L(tCSPApp,"/") {
				Set tPortalDir = ##class(%Library.File).SubDirectoryName(tPortalDir,$piece(tCSPApp,"/",i))
			}
			Set tSC = ..RemoveLegacyPortal(pTargetNS,tPortalDir,tCSPApp,0,1,pVerbose)
			If $$$ISERR(tSC) Quit
		}
		ElseIf pCompileCSPPages {
			Set tFlags = "c"_$select(pVerbose: "+", 1:"-")_"d"
			$$$REPORT(4,"* Compiling portal '"_tCSPApp_"' for namespace "_pTargetNS)
			Set tSC = $system.CSP.LoadPageDir(tCSPApp, tFlags)
			If $$$ISERR(tSC) Quit
		}
		ElseIf ..#CREATELEGACYPORTAL {
			$$$REPORT(4,"* CSP compilation skipped as it should already have occurred in namespace "_pTargetNS)
		}
		Else {
			$$$REPORT(4,"* Legacy CSP Portal not installed, so no legacy CSP pages recompiled.")
		}
		
		$$$REPORT(4,"* Compiling dashboards and other DeepSee items")
		Set tSC = $system.OBJ.CompilePackage("Ens.DeepSee","csk"_$S(pVerbose:"d",1:"-d"))
		If $$$ISERR(tSC) Quit
		
		Set ^Ens.Mirror("Version") = ..getVersion()
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod findMirroredNamespaces(Output pMirNamespaces As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Kill pMirNamespaces
		Set pMirNamespaces = ""
		If $namespace '= "%SYS" {
			Set tSC = $$$ERROR($$$GeneralError,"Must be in %SYS")
			Quit
		}
		
		Set tStmt = ##class(%SQL.Statement).%New()
		Set tSC = tStmt.%PrepareClassQuery("SYS.Database","List")
		If $$$ISERR(tSC) Quit
		Set tRS = tStmt.%Execute("*")
		
		Set tDatabases = 0
		While tRS.%Next(.tSC) {
			If 'tRS.%Get("Mirrored") Continue
			Set tDatabases($i(tDatabases)) = tRS.%Get("Directory")
		}
		If $$$ISERR(tSC) Quit
		
		For i=1:1:tDatabases {
			Set tSC = ##class(Config.Databases).DatabasesByDirectory("",tDatabases(i), .tDBNames)
			If $$$ISERR(tSC) Quit
			For j=1:1:$listlength($get(tDBNames)) {
				Set tDB = $listget(tDBNames, j)
				If tDB '= "" { Set tMirrored(tDB) = "" }
			}
		}
		If $$$ISERR(tSC) Quit
		
		Set tDBName = ""
		For {
			Set tDBName = $order(tMirrored(tDBName))
			Quit:(tDBName = "")
			Set tSC = ##class(Config.Namespaces).NamespacesByDB(tDBName, .tNamespaces)
			If $$$ISERR(tSC) Quit
			For i=1:1:$length($get(tNamespaces),",") {
				Set tNS = $piece(tNamespaces, ",", i)
				If ("" '= tNS) && $data(^%SYS("Ensemble","InstalledNamespace", tNS)) Set pMirNamespaces(tNS) = ""	
			}
		}
		If $$$ISERR(tSC) Quit
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod Install(pUpgrade As %Boolean = 0, pProduct As %String = "", pSrcDir As %String = "") As %Status
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		#;These 2 cleaned up at the end of CheckForInstall()
		Set ^%SYS("Ensemble","RunOnce","InitializeEnsemble")=pProduct
		Set ^%SYS("Ensemble","RunOnce","InitializeEnsemble","Upgrade")=pUpgrade
	
		 // Set ^%SYS("Ensemble","CSPAppSec") at installation time
		Set CSPAppSec = ..DetermineCSPAppSec()
	
		// Define Ensemble auditing events at installation or upgrade time
		Do ..CreateEnsembleAuditingEvents()
	
		If 'pUpgrade {
			// Enable EnsembleAutoStart for a new Ensemble/HS installation
			Set tSC = ..configureEnsembleAutoStart(1)
		}
		If $ZCVT(pProduct,"L")="healthshare"  {
			// HealthShare pre-setup
			Set ^%SYS("HealthShare")=pUpgrade_"^"_pProduct
			If ##class(%File).Exists(pSrcDir_"hsutil.xml") Do $system.OBJ.Load(pSrcDir_"hsutil.xml","ckd")
			//bump routine cache for new installs
			If 'pUpgrade { Do ##class(%ZHSLIB.HealthShareMgr).PreInstallSetup() }
		}
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod configureEnsembleAutoStart(pValue As %Boolean = 1) As %Status
{
	#dim tSC As %Status
	#dim tProperties
	Set tProperties("EnsembleAutoStart") = ''pValue
	Set tSC = ##class(Config.Startup).Modify(.tProperties,,$$$CPFSave+$$$CPFWrite)
	Quit tSC
}

/// Initialize HealthShare
ClassMethod InitializeHealthShare(pVerbose As %Boolean = 0, pHSLib As %String = {..#HSLIB}, ByRef pIsPrimary As %Boolean = 1) As %Status
{
	try {
		Set tSC=##class(%ZHSLIB.HealthShareMgr).InitializeHealthShare(pVerbose,pHSLib,.pIsPrimary)
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod getVersion() As %List
{
	Quit $LB(+$system.Version.GetMajor(), +$system.Version.GetMinor(), +$system.Version.GetPoint(), +$system.Version.GetBuildNumber(), +$system.Version.IsUnicode(), $e($p($p($p($zv,"Build ",2),")",1),"U",1),$l($system.Version.GetBuildNumber())+1,*))
}

ClassMethod getVersionIdentifier() As %String [ Internal, Private ]
{
	#dim tVersion As %String
	
	Set tVersion = $system.Version.GetNumber()
	Set:$P(tVersion,".",3)="" $P(tVersion,".",3)=0
	
	Set tVersion = tVersion_"."_$system.Version.GetBuildNumber()
	Set:$system.Version.IsUnicode() tVersion = tVersion_"U"
	
	Quit tVersion
}

ClassMethod InitializeEnsemble(pVerbose As %Boolean = 0, ByRef pIsPrimary As %Boolean = 1) As %Status [ PublicList = InstallBootStrap ]
{
	New InstallBootStrap
	;
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
#define CHKCFG(%c,%m) ;If pVerbose,'%c.CanBeReactivated(.array) Write !!,"!!! RESTART NEEDED: ",%m,! ZWrite array Write !!
	;
	;
	; We need to add the library database and two database/namespace pairs to the system:
	; 	ENSLIB	- Main Ensemble Library (database only)
	; 	ENSDEMO	- Ensemble Sample code
	;	ENSEMBLE - Ensemble namespace which may contain user code - database only created if not present.
	; 	
	; In addition, we need to make sure that all Ensemble code and localised 
	; data are mapped to all namespaces.
	; 
	; Finally, we create a CSP application for the Ensemble Management Portal in each namespace.
	;
	Set tEnsLib = ..#ENSLIB
	;
	Set $ZT="Trap",tSC=$$$OK,%Log=$G(%Log,$IO)
	Do {
		; We can only run this in %SYS
		If $NAMESPACE'="%SYS" {
			Use:$G(%Log)'="" %Log
			$$$REPORT(0,"InitializeEnsemble: Must be in %SYS (currently in "_$NAMESPACE_")")	
			Set tSC = $$$ERROR($$$GeneralError,"Must be in %SYS")
			Quit
		}
		;
 		Do $zu(9,"","Updating for Ensemble installation")
		;
	 	Set tCfgName = $p($zu(86),"*",2)
	 	Set tCfgFile = $p($zu(86),"*")
	 	Set tCfgDir  = $System.Util.InstallDirectory()
		Set tMgrDir  = $ZU(12)
		
		// Normalize the config file for VMS
		Set tCfgFile = ##class(%File).NormalizeFilename(tCfgFile)
		
		$$$REPORT(0,"Updating for Ensemble installation:")
		
		Try {
			Set tReportVersion = ##class(%ZHSLIB.HealthShareMgr).VersionInfo()
		} Catch {
			Set tReportVersion = $System.Version.GetVersion()
		}
		
		$$$REPORT(4,"* Configuration:")
		$$$REPORT(6,"- Manager Dir:   "_tMgrDir)
		$$$REPORT(6,"- Configuration: "_tCfgName)
		$$$REPORT(6,"- Config. Dir:   "_tCfgDir)
		$$$REPORT(6,"- Version:       "_tReportVersion)
		
		Set tSC = ##class(Config.CPF).Read(,$$$CPFImport)
		Use %Log  // HACK

		If $$$ISERR(tSC) $$$REPORT(0,"ERROR: Import of '"_tCfgFile_"' failed: "_$system.Status.GetErrorText(tSC))
		
		$$$REPORT(4,"* Storage:")
		
		Set tIncludeENSDEMO = 1
		
		For tItem = tEnsLib, "ENSDEMO", "ENSEMBLE" {
			$$$REPORT(6,"- "_tItem)
			
			If '##Class(Config.Databases).Exists(tItem) {
				Set tDir = ##class(%File).SubDirectoryName(tMgrDir,$ZCVT(tItem,"l"))
				
				// For ENSEMBLE, if the DB doesn't exist, let's create it
				If tItem = "ENSEMBLE" {
					#dim tCreateEnsCACHEDAT As %Boolean = 0
					If '##class(%File).DirectoryExists(tDir) {
						// Make sure the directory exists first
						$$$REPORT(8,"+ Creating Directory "_tDir)
						Do ##class(%File).CreateDirectory(tDir)
						Set tCreateEnsCACHEDAT = 1
					} Else {
						#dim tEnsCACHEDAT As %String = ##class(%File).NormalizeFilename("CACHE.DAT",tDir)
						Set tCreateEnsCACHEDAT = '##class(%File).Exists(tEnsCACHEDAT)
					}
					If tCreateEnsCACHEDAT {
						$$$REPORT(8,"+ Creating Database: "_tItem_" in "_tDir)
						Set tSC = $$CreateDatabase^%SYS.DATABASE(tDir)
						If $$$ISERR(tSC) $$$REPORT(0,"ERROR: Failed to create database: "_$system.Status.GetErrorText(tSC))
					}
				}
				If tItem = "ENSDEMO",'##class(%File).DirectoryExists(tDir) {
					Set tIncludeENSDEMO = 0
					$$$REPORT(8,"+ Skipping ENSDEMO setup since not installed")
					Continue
				}
				
				$$$REPORT(8,"+ Adding Database: "_tItem_" in "_tDir)
				k p
				s p("Directory")=tDir
				s tSC=##Class(Config.Databases).Create(tItem,.p)
				If $$$ISERR(tSC) {
					$$$REPORT(0,"ERROR: Failed to add database: "_$system.Status.GetErrorText(tSC))
					Continue
				}
			} Else {
				$$$REPORT(8,"+ Database "_tItem_" already exists ... skipping")
			}
			
			$$$CHKCFG(tCfg,"CreateDatabase: "_tItem)
			
			If '..#CREATEENSLIBNAMESPACE && (tItem = tEnsLib) {
				#; Remove ENSLIB namespace if it already exists and no mappings exist
				If ..#REMOVEEENSLIBNAMESPACE && ##class(Config.Namespaces).Exists(tItem, .tEnsLibNS) {
					#dim tEnsLibNS As Config.Namespaces
					Set tHasMaps = 0
					For tProp = "Globals", "Routines" {
						If $property(tEnsLibNS, tProp) '= tEnsLib {
							Set tHasMaps = 1
							Quit
						}
					}
					If 'tHasMaps {
						For tMapType = "Config.MapGlobals", "Config.MapPackages", "Config.MapRoutines" {
							Set tRS = ##class(%ResultSet).%New(tMapType_":List")
							Set tSC = tRS.Execute(tItem,"*")
							If $$$ISOK(tSC) && tRS.Next() {
								Set tHasMaps = 1
								Quit
							}
						}
						If 'tHasMaps { // no mappings exist for ENSLIB namespace
							$$$REPORT(8,"+ Removing unnecessary namespace: "_tItem)
							Set tSC = ##class(Config.Namespaces).Delete(tItem)
							If $$$ISERR(tSC) { // Not critical if we can't remove ENSLIB namespace
								$$$REPORT(0,"ERROR: Failed to delete namespace: "_$system.Status.GetErrorText(tSC))
							}
						}
					}
					
				}
			}
			ElseIf '##Class(Config.Namespaces).Exists(tItem) {
				$$$REPORT(8,"+ Creating Namespace: "_tItem)
				k p
				s p("Globals")=tItem
				s tSC=##Class(Config.Namespaces).Create(tItem,.p)
				If $$$ISERR(tSC) {
					$$$REPORT(0,"ERROR: Failed to create namespace: "_$system.Status.GetErrorText(tSC))
					Continue
				}
			} Else {
				$$$REPORT(8,"+ Namespace "_tItem_" already exists ... skipping")
			}
 
			$$$CHKCFG(tCfg,"CreateNamespace: "_tItem)
		}
		
		// Create a database resource for ENSLIB et. al.
		$$$REPORT(4,"* Security:")
		
		For tDB = tEnsLib, "ENSDEMO", "ENSEMBLE" {
			If (tDB="ENSDEMO"),'tIncludeENSDEMO Continue
			If pIsPrimary || '$data(pIsPrimary("MirrorNS", tDB)) {
				$$$REPORT(6,"- Creating resource %DB_"_tDB_", assigning to "_tDB)
				Set tDBPermissions = $select(tDB = tEnsLib: "R", 1: "")
				Set tSC = ..assignResourceToDB("%DB_"_tDB,##class(%File).SubDirectoryName(tMgrDir, $ZCVT(tDB,"l")),tDBPermissions)
				Use %Log  // HACK
				If $$$ISERR(tSC) {
					$$$REPORT(8,"ERROR: "_$system.Status.GetErrorText(tSC))
				}
			}
			Else {
				$$$REPORT(6,"- Skipping resource creation for namespace "_tDB_" as it contains mirrored data")
			}
		}
		
		Set tUsername="_Ensemble"
		If ##class(Security.Users).Exists(tUsername,.tEnsUser) {
			$$$REPORT(6,"- Username '"_tUsername_"' already exists.")
			Try {
				For tEnsUserProperty = "AccountNeverExpires","PasswordNeverExpires" {
					If $PROPERTY(tEnsUser,tEnsUserProperty) = 0 {
						Set $PROPERTY(tEnsUser,tEnsUserProperty) = 1
						Set tSC = tEnsUser.%Save()
						If $$$ISOK(tSC) {
							$$$REPORT(8,"- Set property '"_tEnsUserProperty_"' to True.")
						} Else {
							$$$REPORT(8,"- Failed to set property '"_tEnsUserProperty_"' to True.")
							Do $system.OBJ.DisplayError(tSC)
						}
					} Else {
						$$$REPORT(8,"- Property '"_tEnsUserProperty_"' already set to True.")
					}
				}
			} Catch ex {
				$$$REPORT(8,"- Errored setting properties 'AccountNeverExpires' and 'PasswordNeverExpires' to True.")
				Do $system.OBJ.DisplayError(ex.AsStatus())
			}
		} Else {
			// Create with AccountNeverExpires and PasswordNeverExpires set to True
			Set tSC=##Class(Security.Users).Create(tUsername,"%All",$c(0,0),"Ensemble Manager",/*NameSpace*/,/*Routine*/,/*ExpirationDate*/,/*ChangePassword*/,/*Enabled*/,/*Comment*/,/*Flags*/,/*PhoneNumber*/,/*PhoneProvider*/,/*Attributes*/,1 /*AccountNeverExpires*/,1 /*PasswordNeverExpires*/)
			If $$$ISOK(tSC) {
				$$$REPORT(6,"- Username '"_tUsername_"' created successfully with properties 'AccountNeverExpires' and 'PasswordNeverExpires' set to True.")
			} Else {
				$$$REPORT(6,"- Username '"_tUsername_"' failed to be created.")
			}
		}
		
		// Add Resources, Roles, and upgrade existing users if necessary
		Set tSC = ..InstallEnsembleSecurity(pIsPrimary, pVerbose)
		Quit:$$$ISERR(tSC)
		
		$$$REPORT(6,"- Configuration "_tCfgName_" updated.")

		// And upgrade any existing Ensemble namespaces
		Set tSC = ..Upgrade(pVerbose, .pIsPrimary)
		
		// Ensure the new namespaces are registered
		Set ^%SYS("Ensemble","InstalledNamespace","ENSEMBLE")=""
		If tIncludeENSDEMO Set ^%SYS("Ensemble","InstalledNamespace","ENSDEMO")=""

 		// Now, walk the list of known namespaces and make sure they are all Ensemblized
		$$$REPORT(4,"* Ensemble enabling namespaces")
		Set tNS = "", tIsUpgrade = $G(^%SYS("Ensemble","RunOnce","InitializeEnsemble","Upgrade"),0)
		For {
			Set tNS = $O(^%SYS("Ensemble","InstalledNamespace",tNS)) Quit:tNS=""
			
			$$$REPORT(6,"- Enabling namespace: "_tNS)
			
			// Enable each namespace
			Set tSC = ##class(%EnsembleMgr).EnableNamespace(tNS,1,.pIsPrimary,1,tIsUpgrade)
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		}

		$$$REPORT(4,"* Loading Ensemble Studio templates")
		
		// Determine the template app directory
		$$$REPORT(6,"- Determining template directory")
		Set tTemplateApp = "/isc/studio/templates"
		Set tSC = ##class(Security.Applications).Get(tTemplateApp,.tTemplateAppProperties)
		Set tTemplateDir = $G(tTemplateAppProperties("Path"))
		If $$$ISOK(tSC) && (tTemplateDir'="") {
			Set tTemplateDir = ##class(%File).NormalizeDirectory(tTemplateDir)
			$$$REPORT(8,"+ Found "_tTemplateApp_" in "_tTemplateDir)
		} Else {
			$$$REPORT(0,"ERROR: Unable to determine directory for "_tTemplateApp)
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		}

 		// %CACHELIB must be read/write otherwise LoadPage fails with a <PROTECT> error
		Set tCacheLibDir = ##class(%File).SubDirectoryName($zu(12),"cachelib")
		Set tSC = ..getDBRWFlag(tCacheLibDir,.tCacheLibRW)
		$$$REPORT(6,"- Marking %CACHELIB as ReadOnly=0 (was previously ReadOnly="_'tCacheLibRW_")")
		Set tSC = ..setDBRWFlag(tCacheLibDir,1)
		Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		
		// Load localized messages into database ENSLIB
		$$$REPORT(6,"- Loading localized messages into database ENSLIB")
		Set tSC = ..loadMessages(..GetENSLIB(1),pVerbose)
		Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)		

		$$$REPORT(6,"- Loading Studio templates")

		Try {
			If '##class(Config.Databases).Exists(tEnsLib, .tEnsLibDB) {
				Set tSC = $$$ERROR($$$DatabaseDoesNotExist, tEnsLib)
				Quit
			}
			Set $namespace = "^^" _ tEnsLibDB.Directory
			
			// Load only the Ensemble Studio wizards described in the manifest (created at ^build time)
			Merge tManifestPages = ^Ens.Manifest("studio-templates")
			
			Set $namespace = "%SYS"
			Set tCSP=""
			For {
				Set tCSP=$ORDER(tManifestPages(tCSP))
				Quit:tCSP=""
			
				Set tSC = $$LoadPage^%apiCSP(tTemplateApp_"/"_tCSP,"c"_$S(pVerbose:"+",1:"-")_"d")
				Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
			}
		}
		Catch ex {
			Set tSC = ex.AsStatus()
		}
		Set $namespace = "%SYS"
		If $$$ISERR(tSC) Quit
		
 		// Set cachelib back to read only
		$$$REPORT(6,"- Setting %CACHELIB back to ReadOnly="_('tCacheLibRW))
		Set tSC = ..setDBRWFlag(tCacheLibDir,tCacheLibRW)
		Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		
		If tIncludeENSDEMO {
			$$$REPORT(6,"* Enabling DeepSee for ENSDEMO")
			Try {
				Set app = $system.CSP.GetDefaultApp("ENSDEMO")
				If app="" {
					$$$REPORT(6,"Unable to get default CSP app for ENSDEMO")
				}
				Else {
					If $E(app,$L(app))'="/" {
						Set app = app_"/"
					}
					Do EnableDeepSee^%SYS.cspServer(app)
				}
			} Catch ex {
				$$$REPORT(6,ex.AsStatus())
			}
		}

		$$$REPORT(0,"Update Complete.")

		// Mark when we last did an InitializeEnsemble()
		Set ^%SYS("Ensemble") = $ZDT($H,3)
		
	} While(0)
Exit
	If $$$ISERR(tSC) {
		// Report any errors
		Do $zu(9,"","Ensemble update failed: "_$system.Status.GetErrorText($G(tSC,$$$OK)))
		Use %Log $$$REPORT(0,"ERROR: EnsUpdate failed: "_$system.Status.GetErrorText(tSC))
		Do $system.OBJ.DisplayError(tSC)
	}
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)	
	Goto Exit
}

/// Validate an Ensemble installation in ENSLIB
ClassMethod ValidateEnsemble(pEnsLib As %String = {..#ENSLIB}, pVerbose As %Boolean = 0) As %Status
{
	// Make sure that ENSLIB is valid
	Set tCheck("Ens.Director")=""
	Set tCheck("Ens.StudioManager")=""
	Set tCheck("Ens.MessageBody")=""
	Set tCheck("EnsLib.HL7.Message")=""
	
	Quit ..validateInstallation(pEnsLib, .tCheck, pVerbose)
}

/// Validate an installation by checking for specific classes in a namespace
ClassMethod validateInstallation(pNS As %String, ByRef pCheck, pVerbose As %Boolean = 0) As %Status [ Internal, Private ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set $ZT="Trap",tSC=$$$OK
	New $namespace
	Do {
		$$$REPORT(4,"* Validating Installation in '"_pNS_"'")
		
		Set $namespace = pNS
		
		Set tClass = ""
		For {
			Set tClass = $O(pCheck(tClass))
			Quit:tClass=""
			
			$$$REPORT(6,"- Checking class '"_tClass_"' ...")
		
			// Check to see if the class exists ...
			If '##class(%Dictionary.CompiledClass).%ExistsId(tClass) {
				// It's missing
				$$$REPORT(8,"- CLASS IS MISSING!")
				Set tSC2 = $$$ERROR($$$ClassDoesNotExist,tClass)
				Set tSC = $$$ADDSC(tSC, tSC2)
				Continue
			}
			
			// Check for the class descriptor
			If '##class(%Library.RoutineMgr).Exists(tClass_".0.OBJ") {
				// It's missing
				$$$REPORT(8,"- CLASS DESCRIPTOR IS MISSING!")
				Set tSC2 = $$$ERROR($$$RoutineDoesNotExist,tClass_"0.OBJ")
				Set tSC = $$$ADDSC(tSC, tSC2)
				Continue
			}
			
			// This one looks good ...
		}
		
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)	
	Goto Exit
}

ClassMethod Upgrade(pVerbose As %Boolean = 0, ByRef pIsPrimary As %Boolean = 1) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set $ZT="Trap",tSC=$$$OK
	Do {
		$$$REPORT(4,"* Upgrading existing namespaces")

		// Recover list of pre-4.0 namespaces to upgrade		
		Merge tNSList = ^|"%SYS"|SYS("Ensemble","InstalledNamespace")
		Merge tNSList = ^%SYS("Ensemble","InstalledNamespace")
		
		Set tNS = ""
		For {
			Set tNS = $O(tNSList(tNS)) Quit:tNS=""
			
			// Upgrade this namespace		
			Set tSC = ..UpgradeNamespace(tNS,pVerbose,.pIsPrimary)
			If $$$ISERR(tSC) {			
				Do $system.OBJ.DisplayError(tSC)
			}
		}
		
	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod UpgradeNamespace(pNS As %String, pVerbose As %Boolean = 0, ByRef pIsPrimary As %Boolean = 1) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	// Check for namespace validity
	Quit:'..validateNamespace(.pNS,0,.tSC) tSC

	// We don't "upgrade" ENSLIB ever
	If (pNS = ..#ENSLIB) Quit $$$OK

	Set $ZT="Trap",tSC=$$$OK
	Do {
		$$$REPORT(6,"- Upgrading namespace: "_pNS)
		New $NAMESPACE
		Set $NAMESPACE = pNS
		
		If (pIsPrimary)||('$data(pIsPrimary("MirrorNS",pNS))) {
			// Build the qualifiers: Note we must do this in a real namespace and also we can't
			// display anything since there is no access to ^%qCacheMsg, hence we use -d.
			Set tSC = $$$qualifierParse("Compiler","-d",.qstruct)
			Quit:$$$ISERR(tSC)
		
			// Upgrade the namespace
			$$$REPORT(8,"+ Upgrading class dictionary")
			Set tSC = $$Upgrade^%occConvert(.qstruct)
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		
			If $D(^|"%SYS"|SYS("Ensemble","InstalledNamespace",pNS)) {
				Set tSC = ..cleanupOldNamespace(pNS,pVerbose)
				Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
			}
			/* 
				Flags that need to be set during upgrade can be set here. 
				Check version upgrading from by looking at Ens.Mirror("Version")
					Set tOldVersion = $get(^Ens.Mirror("Version"))
					Set tMajorVersion = $listget(tOldVersion,1)
					Set tMinorVersion = $listget(tOldVersion,2)
					If (tOldVersion="")||(tMajorVersion<2014) {
						$$$REPORT(8,"+ Setting XXXX flag for existing namespace")
						Set ^Ens.Config("Example")=1
					}
			*/
		}
		Else {
			$$$REPORT(8,"+ Skipping class dictionary upgrade for namespace "_pNS_" as it contains mirrored data")
		}
		
		// Remove any current mappings to ENSLIB
		Set tSC = ..unmap2enslib(pNS,pVerbose)
		Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		
		// Note, once we're done, we'll reactivate this namespace and apply the current mappings
		
	} While(0)
Exit
	// Make sure we switch back to the original namespace
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod cleanupOldNamespace(pNS As %String, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set tSC=$$$OK,$ZT="Trap"
	New $NAMESPACE
	Do {
		$$$REPORT(4,"* Cleaning up "_pNS)
	
		// Build up a list of databases for this namespace
		// TODO: make finddatabases^%occConvert public so we can call that
		Do finddatabases(pNS,.tDBList,pVerbose)

		// For each mapped database, go clean it up		
		Set tDB="" For {
			set tDB=$o(tDBList(tDB),1,pNS) Quit:tDB=""
				
			// For each database, switch to the implied namespace so we avoid any mappings
			$$$REPORT(8,"+ Cleaning database: "_tDB)
			
			// Switch to the database (using $NAMESPACE seems to set up default system mappings properly)
			Set $NAMESPACE = tDB
			
			// Now, delete the old Ensemble packages
			$$$REPORT(10,"* Deleting obsolete packages:")
			Set tCount=0
			For tPkg = "Ens", "EnsLib", "CSPX", "Demo" {
				
				// Check for the package
				If $$$qualifierParse("Export","d-",.qstruct)
				Set qstruct("includesubpackages")=0
				Do GetPackageList^%occLibrary(.tPkgList,tPkg,.qstruct)
				
				If $D(tPkgList)'<10 {
				
					$$$REPORT(12,"- "_tPkg_".*")
					Set tSC = $system.OBJ.DeletePackage(tPkg,.qstruct)
					If $$$ISERR(tSC) {
						Do $system.OBJ.DisplayError(tSC)
					} Else {
						Set tCount = tCount + 1
					}
				}
			}
			
			$$$REPORT(12,"  [Removed "_tCount_" obsolete package(s)]")
			
			$$$REPORT(10,"* Deleting obsolete routines:")
			
			// And the routines
			Set tRtn="",tCount=0
			For {
				Set tRtn = $O(^rINDEX(tRtn))
				Quit:tRtn=""
				
				If tRtn'[".",tRtn?1"Ens"1.E {
					
					Set tExt = ""
					For {
						Set tExt = $O(^rINDEX(tRtn,tExt))
						Quit:tExt=""
						
						// Delete these
						$$$REPORT(12,"- "_tRtn_"."_tExt)
						Set tSC = $$Delete^%apiRTN(tRtn_"."_$S(tExt="OBJ":"INT",1:tExt),0,0)
						If $$$ISERR(tSC) {
							Do $system.OBJ.DisplayError(tSC)
						} Else {
							Set tCount = tCount + 1
						}
					}
				}
			}
			
			$$$REPORT(12,"  [Removed "_tCount_" obsolete routines(s)]")

			// And the globals
			$$$REPORT(10,"* Deleting obsolete globals:")
			
			// We assume that any globals we now map from ENSLIB that exist in this database are obsolete
			// and should be purged.
			Do ..getMappedGlobals(.tGblMap)
			Set tGblMap = "", tCount = 0
			For {
				Set tGblMap = $O(tGblMap(tGblMap))
				Quit:tGblMap=""
				
				Set tSubStart = $P(tGblMap,":",2)
				Set tSubEnd = $P(tGblMap,":",3)
				
				Set tGbl = $P(tGblMap,":")
				
				Set tBeginRef = "^"_tGbl_tSubStart
				Set tEndRef = "^"_tGbl_tSubEnd
				
				Set tRef = tBeginRef
			
				// Walk the subscript range (if given) and remove any matching globals
				Do {
					// If the global exists, remove it
					If $D(@tRef) {
						// Delete this
						$$$REPORT(12,"- "_tRef)
						Kill @tRef
						Set tCount = tCount + 1
					}
					
					// Advance the subscript (if given)
					Set tRef = $Q(@tRef)
					
					// Keep going as long as:
					//	1) We don't run off the end
					//	2) The we hit the end ref
				} While ((tRef '= "") && (tRef '] tEndRef))
			}
			
			$$$REPORT(12,"  [Removed "_tCount_" obsolete global(s)]")
		}

		// Mark this in the list of ensemble namespaces, this will have to be separately "enabled"
		Set ^%SYS("Ensemble","InstalledNamespace",pNS)=""
	
		// Clean up the old namespace list
		Kill ^|"%SYS"|SYS("Ensemble","InstalledNamespace",pNS)
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
	
finddatabases(nsp,dblist,pVerbose=0)
	$$$REPORT(8,"+ Analysing mappings")
	#;SML1565+
	Set nspinfo=$zu(90,28,2,nsp)
	If nspinfo="" quit
	Kill gxlatinfo
	#; Argument flags 1 - NoSLM, 2 - exact match for global name.
	Do getgxlatarray^%SYS.GXLINFO(.nspinfo,"oddDEF",.gxlatinfo,2)
	If '$Data(gxlatinfo) {
		#; quit if the namespace has been removed.
		If nspinfo="" Quit
		#; The oddDEF does mapping does not exist in the namespace.
		Set dblist("^^"_$zu(90,7,$p(nspinfo,"|",2)))=nsp
		Quit
	}
	Set slm=$List(gxlatinfo,3)
	If slm="" {
		#; No SLM mapping for this globa entry. Set it with the global mapping.
		Set dblist("^^"_$zu(90,7,$p(nspinfo,"|",2)))=nsp
		#; The id is the ^oddDEF mapped to in thw namespace.
		Set id=$Piece($List(gxlatinfo,2),"|",3)
		If id {
			Set db=$zutil(90,7,id)
			If db'="" Set dblist("^^"_db)=nsp
		} else {
			#; The ^oddDEF is not mapped to any DB then set it with default DB.
			Set dblist("^^"_$zu(90,7,$p(nspinfo,"|",2)))=nsp
		}
		Quit
	}
	For k=0:1:($piece($List(slm,1),"|")-1) {
		Set id=$piece($List(slm,k*2+3),"|",1)
		If id {
			Set db=$zutil(90,7,id)
			If db'="" Set dblist("^^"_db)=nsp
		} else {
			Set id=$Piece($List(gxlatinfo,2),"|",3)
			If id s dblist("^^"_$zu(90,7,id))=nsp
		}
	}
	#;SML1565-
	
	// Ignore any databases belonging to these namespaces, since they are mapped by us
	For prune = "%SYS","%CACHELIB",..#ENSLIB,..#HSLIB {
		Set dbid = $zu(90,3,1,prune)
		If +dbid {		
			Set db = $zu(90,7,dbid)
			Kill dblist("^^"_db)
		
			$$$REPORT(10,"* Ignoring mappings from: "_prune_$S('dbid:" (not present)",1:""))
		}
	}
	
	Quit
}

/// The following parameters are for internal use:<br/>
/// <li> pIsPrimary can be an array and will be calculated if not passed in</li>
/// Top node is whether this is a primary node or not. It is true if not in a mirror.<br/>
/// Subscripts are namespaces that have one or more mirrored databases.<br/>
/// <li> pFromInstall indicates it is enabling all the existing Ensemble namespaces.</li>
/// Items like HSLIB are Ensemble but we don't want it to be Foundation<br/>
/// Don't automatically upgrade a previously Ensemble enabled namespace to be Healthshare Foundation<br/>
/// <li> pUpgrade only has meaning when pFromInstall is true.</li>
ClassMethod EnableNamespace(pTargetNS As %String, pVerbose As %Boolean = 0, ByRef pIsPrimary, pFromInstall = 0, pUpgrade = 0) As %Status
{
	// Check for namespace validity
	Quit:'..validateNamespace(.pTargetNS,0,.tSC) tSC
	;

	Set $ZT="Trap",tSC=$$$OK,%Log=$G(%Log,$IO)

	; Change namespace to "%SYS"
	New $NAMESPACE
	Set $NAMESPACE = "%SYS"
	
	;
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	;
	; Here, we need to make sure that Ens.* and EnsLib.* classes
	; and Ens*.INC includes are mapped to the target namespace
	; 
	; Finally, we create a CSP application for the Ensemble
	; Management Portal.
	;
	Set tEnsLib = ..#ENSLIB
	Set pTargetNS = $zcvt(pTargetNS,"U")
	;
	Do {
		// Remember the existing portal suffix (if any)
		Set tPortalSuffix = $G(^%SYS("Ensemble","InstalledNamespace",pTargetNS))
		Set tHealthShareInstalled = ..IsHealthShareInstalled()
		Set tPortalPrefix = ""
		Set tCookiePath = ""
		If pFromInstall {
			If ..IsHealthShareNamespace(pTargetNS) {
				Set tPortalPrefix = "healthshare"
				Set tCookiePath = "/csp/healthshare/"
			}
		} ElseIf tHealthShareInstalled {
			Set tPortalPrefix = "healthshare"
			Set tCookiePath = "/csp/healthshare/"
		}
 		Do $zu(9,"","Enabling namespace '"_pTargetNS_"' for Ensemble")
		$$$REPORT(0,"Enabling namespace '"_pTargetNS_"' for Ensemble:")
	
 		Set tIsNewNamespace = '$D(^%SYS("Ensemble","InstalledNamespace",pTargetNS))
		// Mark this namespace as Ensemble enabled. This needs to be set before calling findMirroredNamespaces which called from populatePrimary
		Set ^%SYS("Ensemble","InstalledNamespace",pTargetNS)=tPortalSuffix
	
		/* 
			Complete pIsPrimary based on what is passed in 
			Top node is whether this is a primary node or not.
			It is set to true if not in a mirror
			If it is in a mirror and not primary then find mirrored namespaces.
		*/
		Set tSC = ..populateIsPrimary(.pIsPrimary)
		Quit:$$$ISERR(tSC)
		Set tIsMirrorMember = $system.Mirror.IsMember()
		If tIsMirrorMember {
			$$$REPORT(2,"* This instance is "_$S(pIsPrimary:"a primary mirror",1:"not a primary mirror"))
			If $D(pIsPrimary("MirrorNS",pTargetNS)) $$$REPORT(2,"+ This namespace has one or more mirrored databases.")
		} Else {
			$$$REPORT(2,"* This instance is not in a mirror")
		}
		
		$$$REPORT(4,"* Mappings")
		Set tSC = ..createMappings(pTargetNS,tEnsLib,pVerbose,.pIsPrimary)
		Quit:$$$ISERR(tSC)
 
		// Validate the mappings
		Set tSC = ..ValidateEnsemble(pTargetNS,pVerbose)
		Quit:$$$ISERR(tSC)

		/// Mark as healthshare namespace when HealthShare is installed and this is not currently a healthshare namespace
		If tHealthShareInstalled && ('pFromInstall && '..IsHealthShareNamespace(pTargetNS)) {
			try {
				Set tSC=##class(%ZHSLIB.HealthShareMgr).EnableHealthShareNamespace(pTargetNS,pVerbose,pIsPrimary,1)
			} catch ex {
				Do $system.OBJ.DisplayError(tSC)
			}
		}
 	
 		$$$REPORT(4,"* Creating Ensemble Management Portal")
 		Set tSC = ..createPortal(pTargetNS,pVerbose,tPortalSuffix,tPortalPrefix,,tCookiePath,,tEnsLib,.pIsPrimary)
 		Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
 		
 		$$$REPORT(4,"* Adding explicit SQL privileges to Ensemble Roles")
 		Set tSC = ..addEnsembleSQLPrivileges(pTargetNS, pVerbose)
 		Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC) 		
		
 		If pIsPrimary || '$data(pIsPrimary("MirrorNS",pTargetNS)) {
			Set tSC = ..dataUpgradeSteps(pTargetNS, pVerbose)
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
			If tSC,(pTargetNS'="ENSDEMO"),((pFromInstall&&'pUpgrade)||tIsNewNamespace) {
				Kill tFlagsSet
				Set tSC = ..setConfigFlags(.tFlagsSet, pTargetNS, pVerbose)
				Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
			}
 		}
 		Else {
	 		$$$REPORT(4,"* Skipping primary-only upgrade and creation steps, as namespace "_pTargetNS_" contains mirrored data and is not primary.")
 		}
 		/* 
 			Need to create the temporary database whether in a mirror or not and whether primary or not if in a mirror.
 		 	This DB is not journalled 
 		*/
		If tSC,(pTargetNS'="ENSDEMO") {
			Set tSC=..createNewDBForEnsTemp(pTargetNS,pVerbose)
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		}
 		/* 
 			Need to create the secondary database whether in a mirror or not and whether primary or not if in a mirror.
 		 	This DB is journalled. MirrorDBName will be from one copying with SECONDARY appended. MirrorSetName will be the same.
 		*/
		If 'tHealthShareInstalled,tSC,(pTargetNS'="ENSDEMO"),((pFromInstall&&'pUpgrade)||tIsNewNamespace) {
			Set tSC=..CreateNewDBForSecondary(pTargetNS,pVerbose,0)
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		}
		$$$REPORT(0,"Update Complete.")
		
	} While(0)
Exit
	kill tCfg
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	
	Do $zu(9,"","Ensemble update failed: "_$ZE)
	
	Use %Log $$$REPORT(0,"ERROR: EnsUpdate failed: "_$system.Status.GetErrorText(tSC))
	Do $system.OBJ.DisplayError(tSC)
	Goto Exit
}

/// This method is called after a namespace is deleted for Ensemble and HealthShare
ClassMethod DisableNamespace(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		// NOTE: We DO NOT remove the mappings etc. here.  We might want to at some point
		//       but the aim of this method is to simply remove the namespace from the
		//		 list of Enabled Namespaces.
		
		// Unmark this namespace as Ensemble enabled
		Kill ^%SYS("Ensemble","InstalledNamespace",$ZCVT(pTargetNS,"U"))
		Kill ^%SYS("Ensemble","CSPApp",$ZCVT(pTargetNS,"U"))
		
		// Unmark this namespace for HealthShare
		Kill ^%SYS("Ens",pTargetNS)
		Kill ^%SYS("HealthShare","Instances",pTargetNS)

	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod SetAutoStart(pTargetNS As %String, pProductionName As %String) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		// Check for namespace validity
		Quit:'..validateNamespace(.pTargetNS,1,.tSC)
		
		// Switch namespace
		If $NAMESPACE'=pTargetNS {
			New $NAMESPACE
			Set $NAMESPACE = pTargetNS
		}
		
		// Delegate to the Ens.Director
		Set tSC = ##class(Ens.Director).SetAutoStart(pProductionName)

	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod ApplySettings(pTargetNS As %String, pProductionName As %String, ByRef pSettings) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		// Check for namespace validity
		Quit:'..validateNamespace(.pTargetNS,1,.tSC)
		
		// Switch namespace
		If $NAMESPACE'=pTargetNS {
			New $NAMESPACE
			Set $NAMESPACE = pTargetNS
		}
		
		
		// Delegate to the Ens.Production
		Set tSC = ##class(Ens.Production).ApplySettings(pProductionName,.pSettings)

	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod SetCredential(pTargetNS As %String, pName As %String, pUsername As %String, pPassword As %String, pOverwrite As %Boolean = 0) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		// Check for namespace validity
		Quit:'..validateNamespace(.pTargetNS,1,.tSC)
		
		// Switch namespace
		If $NAMESPACE'=pTargetNS {
			New $NAMESPACE
			Set $NAMESPACE = pTargetNS
		}
		
		// Delegate to the credential class
		Set tSC = ##class(Ens.Config.Credentials).SetCredential(pName, pUsername, pPassword, pOverwrite)

	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

/// Remove all rule cache routines and recompile all business rules.
ClassMethod upgradeRules(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set $ZT="Trap",tSC=$$$OK
	Do {
		// Check for namespace validity
		Quit:'..validateNamespace(.pTargetNS,1,.tSC)
		
		// Switch namespace
		If $NAMESPACE'=pTargetNS {
			New $NAMESPACE	
			Set $NAMESPACE = pTargetNS
		}
		
		// Check for duplicate definitions of custom functions
		Set s = ##class(Ens.Rule.Utils).GetAllFunctions(.v)
		If $$$ISOK(s) {
			$$$REPORT(5,"+ Checking for duplicate names in function class definitions ... OK")
		}
		Else {
			$$$REPORT(5,"+ Duplicate function names were found in custom function classes:")
			Do $system.OBJ.DisplayError(s)
		}
		// Convert storage globals from pre-MC680 format
		$$$REPORT(5,"+ Updating storage for rule definitions from early Ensemble versions")
		Set tSC=##class(Ens.Rule.RuleDefinition).ConvertStorageGlobal()
		If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC)

		// Ensure FunctionSet Cache is clean before upgrade
		Kill ^Ens.FunctionSet

		#; Ensure all FunctionSet classes are compiled as the Rule classes may need them to compile successfully.
		$$$REPORT(5,"+ Checking for any FunctionSet classes that need to be compiled")
		Set tRS = ##class(%Library.ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
		Set tSC = tRS.Execute("Ens.Rule.FunctionSet")
		If $$$ISERR(tSC) {
			$$$REPORT(8,"- Error finding subclasses: "_$system.Status.GetErrorText(tSC))
		}
		Else {
			Kill tFunctions
			While tRS.%Next() {
				Set tFuncName = tRS.%Get("Name")
				If ("" '= tFuncName) && ("Ens." '= $extract(tFuncName,1,4)) && ("EnsLib." '= $extract(tFuncName,1,7)) && '$data(^oddCOM(tFuncName,$$$cCLASSmethod)) {
					Set tFunctions(tFuncName) = ""
				}
			}
			If '$data(tFunctions) {
				$$$REPORT(8,"- No FunctionSet classes need to be compiled.")
			}
			Else {
				$$$REPORT(8,"- Compiling FunctionSet classes" _ $select(pVerbose: ":", 1: ""))
				#; Ensure we try to (re)compile all FunctionSet classes to ensure that they are available for the rule upgrade and compile
				Set qspec = "/mapped=1/predecessorclasses=1/checkuptodate=all/display="_$select(pVerbose:"all", 1:"none")
				Set tSC = $system.OBJ.Compile(.tFunctions,qspec)
				If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC)
			}
		}

		// Upgrading rule definition
		$$$REPORT(5,"+ Upgrading rule definition")
		set tSC=##class(Ens.Rule.Upgrade).ConvertAll("/display="_$s(pVerbose:"all",1:"none"))
		If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC)

	} While(0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod validateNamespace(ByRef pTargetNS As %String, pIsEnabled As %Boolean = 0, ByRef pSC As %Status) As %Boolean
{
	// Force uppercase
	Set pTargetNS = $ZCVT($G(pTargetNS),"U")

	// Validate name
	If (pTargetNS="") || (pTargetNS="%SYS") || (pTargetNS="%CACHELIB") {
		Set pSC = $$$ERROR($$$GeneralError,"Namespace '"_pTargetNS_"' is not valid for Ensemble")
		Quit 0
	}

	// Check to see if it actually exists at the system level
	If '$ZU(90,3,1,pTargetNS) {
		Set pSC = $$$ERROR($$$NamespaceDoesNotExist,pTargetNS)
		Quit 0
	}

	// Check for an Ensemble enabled namespace if pIsEnabled was specified
	If (pIsEnabled && '$D(^%SYS("Ensemble","InstalledNamespace",pTargetNS))) {
		Set pSC = $$$ERROR($$$NamespaceDoesNotExist,pTargetNS)
		Quit 0
	}

	Quit 1
}

ClassMethod UpdateAndReloadCPF(pVerbose, pTargetNS) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Try {
		Set %Log=$G(%Log,$IO)
		Set tOldNamespace=$namespace
		Set $namespace="%SYS"
		$$$REPORT(6,"- Updating CPF")
		Set tSC = ##class(Config.CPF).Write()
	 	If $$$ISERR(tSC) {
		 	$$$REPORT(6,"ERROR: Failed to update CPF with new mappings: "_$system.Status.GetErrorText(tSC))
		 	Quit
	 	}
 	
	 	$$$REPORT(6,"- Moving changes to active configuration")
	 	Set tSC = ##class(Config.Map).MoveToActive()
	 	If $$$ISERR(tSC) {
		 	$$$REPORT(6,"ERROR: Failed to move changes to active configuration: "_$system.Status.GetErrorText(tSC))
		 	Quit 
	 	}
 	
	 	$$$REPORT(6," - Loading new mappings for namespace '"_pTargetNS_"'")
		Set tSC = ##class(Config.Namespaces).Load(pTargetNS)
	 	If $$$ISERR(tSC) {
		 	$$$REPORT(6,"ERROR: Failed to load updated mappings for namespace '"_pTargetNS_"': "_$system.Status.GetErrorText(tSC))
		 	Quit 
	 	}
	} Catch ex {
		Set tSC=ex.AsStatus()
		Use %Log $$$REPORT(0,"ERROR: EnsUpdate failed: "_$system.Status.GetErrorText(tSC))
	}
	Set $Namespace=tOldNamespace
	Quit tSC
}

ClassMethod map2enslib(pTargetNS As %String = {$NAMESPACE}, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Quit:'..validateNamespace(.pTargetNS,0,.tSC) tSC
	
	; Change namespace to "%SYS"
	If $NAMESPACE'="%SYS" {
		New $NAMESPACE
		Set $NAMESPACE = "%SYS"
	}
	;
	Set %Log=$G(%Log,$IO),$ZT="Trap",tSC=$$$OK
	Do {	
		$$$REPORT(4,"* Mappings:")
		Set tSC = ..createMappings(pTargetNS,,pVerbose)
		Quit:$$$ISERR(tSC)
		
		// Done!
		$$$REPORT(4,"* Complete!")
		
	} While(0)
Exit
	kill tCfg
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Use %Log $$$REPORT(0,"ERROR: EnsUpdate failed: "_$system.Status.GetErrorText(tSC))
	Goto Exit
}

ClassMethod unmap2enslib(pTargetNS As %String = {$NAMESPACE}, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Quit:'..validateNamespace(.pTargetNS,0,.tSC) tSC
	
	; Change namespace to "%SYS"
	If $NAMESPACE'="%SYS" {
		New $NAMESPACE
		Set $NAMESPACE = "%SYS"
	}
	;
	Set %Log=$G(%Log,$IO),$ZT="Trap",tSC=$$$OK
	Do {	
		
		$$$REPORT(4,"* Mappings:")
		Set tSC = ..deleteMappings(pTargetNS,,pVerbose)
		Quit:$$$ISERR(tSC)
		
		// Done!
		$$$REPORT(4,"* Complete!")
		
	} While(0)
Exit
	kill tCfg
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Use %Log $$$REPORT(0,"ERROR: EnsUpdate failed: "_$system.Status.GetErrorText(tSC))
	Goto Exit
}

/// Private helper method to create Ensemble mappings for a particular namespace
ClassMethod createMappings(pTargetNS As %String, pEnsLib As %String = {..#ENSLIB}, pVerbose As %Boolean = 0, ByRef pIsPrimary) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set tSC = $$$OK
	
	; Note: For all mappings below, changes are made with only the $$$CPFSave flag.
	; This method must both write the changes to the CPF and activate the changes for them to take effect.
	Set pTargetNS = $zcvt(pTargetNS,"U")
	; Add class mappings ...
	$$$REPORT(6,"- Class:")
	
	For tPackage = "Ens", "EnsLib", "EnsPortal", "CSPX.Dashboard" {
		
		If '##Class(Config.MapPackages).Exists(pTargetNS,tPackage) {
			$$$REPORT(8,"+ Adding class mapping "_tPackage_" -> "_pEnsLib)
			k p
			s p("Database")=pEnsLib
			s tSC=##Class(Config.MapPackages).Create(pTargetNS,tPackage,.p,,$$$CPFSave)
			If $$$ISERR(tSC) {
				$$$REPORT(0,"ERROR: Failed to create class mapping "_tPackage_": "_$system.Status.GetErrorText(tSC))
				Continue
			}
		} Else {
			$$$REPORT(8,"+ Class mapping "_tPackage_" already exists ... skipping")
		}
	}
	
	; Add a routine mapping for Ens*.
	$$$REPORT(6,"- Routine:")
	For tRtn = "Ens*" {
		$$$REPORT(8,"+ Adding routine mapping "_tRtn_" -> "_pEnsLib)
		If '##Class(Config.MapRoutines).Exists(pTargetNS,tRtn) {
			k p
			s p("Database")=pEnsLib
			Set tSC = ##Class(Config.MapRoutines).Create(pTargetNS,tRtn,.p,,$$$CPFSave)
			If $$$ISERR(tSC) {
				$$$REPORT(0,"ERROR: Failed to create routine mapping for "_tRtn_" -> "_pEnsLib_": "_$system.Status.GetErrorText(tSC))
				Continue
			}
		} Else {
			$$$REPORT(8,"+ Routine mapping "_tRtn_" already exists ... skipping")
		}
	}

	; Add/fix global mappings
	$$$REPORT(6,"- Global:")
	Kill tGlbMap, tGlbName
	// Get array of all global mappings to be created
	Do ..getMappedGlobals(.tGblMap, pEnsLib)
	// Get array of all global *names* to be mapped
	Set tGblMap = ""
	For {
		Set tGblMap = $O(tGblMap(tGblMap))
		Quit:tGblMap=""
		Set tGlbName($P(tGblMap,":",1)) = ""
	}
	// Create a global directory entry for each global to be mapped, with same collation as ENSLIB (Cache Standard)
	// Note 1: This is only possible for local databases
	// Note 2: We don't do this for ENSDEMO
	// Note 3: We do not do if this is a mirrored NS and not primary
	If '$D(pIsPrimary) Set tSC = ..populateIsPrimary(.pIsPrimary)
	If pTargetNS'="ENSDEMO",(pIsPrimary||'$data(pIsPrimary("MirrorNS",pTargetNS))) {
		Try {
			Set tSC = ##Class(Config.Namespaces).Get(pTargetNS, .tP)
			If $$$ISOK(tSC) Set tSC = ##Class(Config.Databases).Get(tP("Globals"), .tDB)
			If $$$ISOK(tSC) Set:tDB("Server")'="" tSC = $$$ERROR($$$GeneralError,"Database server '"_$G(tDB("Server"))_"' not local, can't set global directory entry")
			If $$$ISOK(tSC) {
				Set tDir = tDB("Directory") // Local default directory for globals
				Set tGlbName = ""
				For {
					Set tGlbName = $O(tGlbName(tGlbName))
					Quit:tGlbName=""
					Set tGlobal = ##Class(%GlobalEdit).Open(tGlbName, tDir, , , .tSC)
					If $$$ISOK(tSC) && $IsObject(tGlobal) {
						// Existing global
						$$$REPORT(8,"+ Checking/fixing global directory settings for existing global ^"_tGlbName)
						If tGlobal.IsKeep'=1 {
							$$$REPORT(10,"+ Modifying property IsKeep = [1]")
							Set tGlobal.IsKeep = 1
							Set tSC = tGlobal.%Save()
							If $$$ISERR(tSC) {
								$$$REPORT(12,"Error when saving modified global entry: "_$system.Status.GetErrorText(tSC))
							}
						}
						If tGlobal.Collation'=5 {
							// If there is global data (unmapped) in the database then save a copy to a temp location so it can be restored later
							Set tNSP =  "^^"_tDir, tDataMoved = 0
							Set tSC = ..moveToFromInstallTemp("To",tNSP,tGlbName,.tDataMoved)
							If $$$ISERR(tSC) {
								$$$REPORT(12,"Error merging global prior to collation change: "_$system.Status.GetErrorText(tSC))
							}
							$$$REPORT(10,"+ Modifying property Collation = [5] (Cache Standard)")
							Set tGlobal.Collation = 5
							Set tSC = tGlobal.%Save()
							If $$$ISERR(tSC) {
								$$$REPORT(12,"Error when saving modified global entry: "_$system.Status.GetErrorText(tSC))
							}
							If tDataMoved {
								$$$REPORT(10,"+ Restoring previously existing (unmapped) local global data")
								Set tSC = ..moveToFromInstallTemp("From",tNSP,tGlbName)
								If $$$ISERR(tSC) {
									$$$REPORT(12,"Error merging global back after collation change: "_$system.Status.GetErrorText(tSC))
								}
							}
						}
					}
					Else {
						// New global
						Kill %objlasterror
						Set tGlobal = ##Class(%GlobalEdit).%New(tDir)
						If $IsObject(tGlobal) {
							$$$REPORT(8,"+ Creating new global directory entry for ^"_tGlbName)
							Set tGlobal.Name = tGlbName
							Set tGlobal.IsKeep = 1
							Set tGlobal.Collation = 5
							Set tSC = tGlobal.%Save()
							If $$$ISERR(tSC) {
								$$$REPORT(10,"Error when saving global entry: "_$system.Status.GetErrorText(tSC))
							}
						}
						Else {
							Set tSC = $G(%objlasterror, $$$ERROR($$$GeneralError,"Undetermined error when creating new instance of %GlobalEdit"))
							$$$REPORT(8,"+ Error when creating new global directory entry for ^"_tGlbName_": "_$system.Status.GetErrorText(tSC))
						}
					}
				}
			}
			Else {
				$$$REPORT(8,"+ Can't create global directory entries: "_$system.Status.GetErrorText(tSC))
			}
		}
		Catch {
			Set tSC = $$$ERROR($$$CacheError, $ZE)
			$$$REPORT(8,"+ Error while creating global directory entries: "_$system.Status.GetErrorText(tSC))
		}
	} Else {
		$$$REPORT(8,"* Skipping creating global directory entries for each global to be mapped, as namespace "_pTargetNS_" contains mirrored data and is not primary.")
 	}

	// Now add the global mappings
	Set tGblMap = ""
	For {
		Set tGblMap = $O(tGblMap(tGblMap))
		Quit:tGblMap=""
		
		Set tSubscript = $P(tGblMap,":",2,$L(tGblMap,":"))
		Set tGbl = $P(tGblMap,":")
		$$$REPORT(8,"+ Adding global mapping ^"_tGbl_tSubscript_" -> "_pEnsLib)
		
		If '##Class(Config.MapGlobals).Exists(pTargetNS,tGbl_tSubscript) {
			k p
			s p("Database")=pEnsLib
			Set tSC = ##Class(Config.MapGlobals).Create(pTargetNS,tGbl_tSubscript,.p,,$$$CPFSave)
			If $$$ISERR(tSC) {
				$$$REPORT(0,"ERROR: Failed to create global mapping "_tGbl_": "_$system.Status.GetErrorText(tSC))
				Continue
			}
		} Else {
			$$$REPORT(8,"+ Global mapping "_tGbl_" already exists ... skipping")
		}
	}
	
	Set tSC=..UpdateAndReloadCPF(pVerbose,pTargetNS)
 	
 	Quit tSC
}

/// Private helper method to create Ensemble mappings for a particular namespace
ClassMethod deleteMappings(pTargetNS As %String, pEnsLib As %String = {..#ENSLIB}, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set tSC = $$$OK
	
	; Remove global mappings
	$$$REPORT(6,"- Global:")
	
	// Now, enumerate the mappings for this namespace
	s Rset=##Class(%Library.ResultSet).%New("Config.MapGlobals:List")
	s Status=Rset.Execute(pTargetNS)
	While Rset.Next() {
		s Name=Rset.Get("Name")
		s Database=Rset.Get("Database")
		i Database'=pEnsLib continue
		s tList(Name)=""
	}
		
	s Index=""
	f  {
		s Index=$o(tList(Index)) q:Index=""
		$$$REPORT(8,"+ Removing global mapping ^"_Index_" -> "_pEnsLib)
		Set tSC = ##Class(Config.MapGlobals).Delete(pTargetNS,Index,,$$$CPFSave)
		If $$$ISERR(tSC) {
			$$$REPORT(0,"ERROR: Failed to remove global mapping "_Name_": "_$system.Status.GetErrorText(tSC))
			Continue
		}
	}
	Set tSC=..UpdateAndReloadCPF(pVerbose,pTargetNS)
  	Quit tSC
}

ClassMethod createPortal(pTargetNS As %String, pVerbose As %Boolean = 0, ByRef pPortalSuffix As %String = "", ByRef pPortalPrefix As %String = "", pGrant As %String = "", pCookiePath As %String = "", pAuthMethods As %String = "", pEnslib As %String = {..#ENSLIB}, ByRef pIsPrimary As %Boolean = 1, pGroupById As %String = {$$$IscMgtPortalId}) As %Status [ Internal ]
{
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		// Validate the namespace
		Quit:'..validateNamespace(.pTargetNS,0,.tSC)
		
		If $E(pPortalSuffix,1,5)'="/csp/" {
			If pPortalSuffix'="" {
				Set:$E(pPortalSuffix,1)'="/" pPortalSuffix="/"_pPortalSuffix
			}
			
			Set:$E(pPortalPrefix,1)'="/" pPortalPrefix="/csp/"_pPortalPrefix
			Set:$E(pPortalPrefix,$L(pPortalPrefix))'="/" pPortalPrefix=pPortalPrefix_"/"

	 		// Create a portal in the specified namespace, and copy in the portal from /csp/enslib
			Set tPortal = pPortalPrefix_$tr($ZCVT(pTargetNS,"L"),"%")_pPortalSuffix
		} Else {
			// Entire URL was specified
			Set tPortal = pPortalSuffix
		}
		
		Set tPortalNS=pTargetNS
		Set (tPortalDir,tPortalSrc) = $System.Util.InstallDirectory()
		For i=2:1:$L(tPortal,"/") {
			Set tPortalDir = ##class(%File).SubDirectoryName(tPortalDir,$P(tPortal,"/",i))
		}
		For tDir="csp",$ZCVT(pEnslib,"L") {
			Set tPortalSrc = ##class(%File).SubDirectoryName(tPortalSrc,tDir)
		}
		
		If ('..#CREATELEGACYPORTAL) || ..#REMOVELEGACYPORTAL {
			$$$REPORT(6,"- Not copying legacy CSP pages for portal application")
			Set tCSPFilesCopied = 0
		}
		Else {
			$$$REPORT(6,"- Copying portal application ("_tPortalSrc_" --> "_tPortalDir_")")
			Set tCSPFilesCopied = 1
			If ##class(%File).CopyDir(tPortalSrc,tPortalDir,1,.tCopied,1) {
				$$$REPORT(8,"+ Copied "_tCopied_" file/dir(s)")
				If $$$isUNIX {
					// Attempt to give cacheusr group access to these files for upgrades
					Set tCmd = "chmod -R g+w "_tPortalDir
					$$$REPORT(8,"+ Making portal files group writable: "_tCmd)
					Do $ZF(-1,tCmd)
				}
			} Else {
				Set tSC=$G(%objlasterror)
				Set:tSC="" tSC=$$$ERROR($$$GeneralError,"Failed to copy "_tPortalSrc_" to "_tPortalDir)
		
				// Treat this as a warning in case of permission problems during upgrade
				$$$REPORT(0,"WARNING: "_$system.Status.GetErrorText(tSC))
			}
		}
 		
 		$$$REPORT(6,"- Configuring portal: "_tPortal_" ["_tPortalNS_"] using "_tPortalDir)
		Set tSC = ..createPortalApp(tPortal,tPortalNS,tPortalDir,"Ensemble Management Portal","%Ens_Portal",1,,pGrant,pCookiePath,pAuthMethods,,pVerbose,pGroupById)
		Quit:$$$ISERR(tSC)
		
		If ..#REMOVELEGACYPORTAL {
			Set tPortalDir = ##class(%Library.File).NormalizeDirectory(tPortalDir)
			If $extract(tPortal,*)'="/" Set tPortal = tPortal _ "/"
			$$$REPORT(6,"- Removing legacy CSP pages and files from directory '"_tPortalDir_"'")
			Set tSC = ..RemoveLegacyPortal(pTargetNS,tPortalDir,tPortal,1,,pVerbose)
			If $$$ISERR(tSC) Quit
		}
		
		If (pIsPrimary || '$data(pIsPrimary("MirrorNS",pTargetNS))) && tCSPFilesCopied {
	 		// %CACHELIB must be read/write otherwise $$$Text fails to update ^%qCacheMsg with a <PROTECT> error
			Set tCacheLibDir = ##class(%File).SubDirectoryName($zu(12),"cachelib")
			Set tSC = ..getDBRWFlag(tCacheLibDir,.tCacheLibRW)
			Quit:$$$ISERR(tSC)
			
			$$$REPORT(6,"- Marking %CACHELIB as ReadOnly=0 (was previously ReadOnly="_'tCacheLibRW_")")
			Set tSC = ..setDBRWFlag(tCacheLibDir,1)
			Quit:$$$ISERR(tSC)

			$$$REPORT(6,"- Compiling portal ("_tPortal_") in "_tPortalNS)
			Set tSC = $$compilePortal(tPortal,tPortalNS,pVerbose)
			Quit:$$$ISERR(tSC)

	 		// Set cachelib back to read only
			$$$REPORT(6,"- Setting %CACHELIB back to ReadOnly="_('tCacheLibRW))
			Set tSC = ..setDBRWFlag(tCacheLibDir,tCacheLibRW)
			Quit:$$$ISERR(tSC)
		}
		Else {
			If tCSPFilesCopied {
				$$$REPORT(6,"- Not compiling portal '"_tPortal_"' in "_tPortalNS_" as the namespace contains mirrored data")
			}
			Else {
				$$$REPORT(6,"- Not compiling portal '"_tPortal_"' in "_tPortalNS_" as no CSP files were copied")
			}
		}
	} While(0)
Exit
	// Report any errors in verbose mode
	If pVerbose,$$$ISERR(tSC) {
		$$$REPORT(0,"ERROR: Failed to create portal: "_$system.Status.GetErrorText(tSC))
	}
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
	
compilePortal(pPortal,pPortalNS,pVerbose=0)
	Set tSC=$$$OK,$ZT="compileTrap"
	If $NAMESPACE'=pPortalNS {
		New $NAMESPACE
		Set $NAMESPACE = pPortalNS
	}
	Set tFlags = "c"_$S(pVerbose:"+",1:"-")_"d"
	Write:pVerbose !,?8,"+ Compiling "_pPortal_" in ",$ZU(5)
	For tDir=pPortal {
		Set tSC = $$LoadPageDir^%apiCSP(tDir,tFlags)
		Do:pVerbose $system.OBJ.DisplayError(tSC)
	}
compileExit
	Quit tSC
compileTrap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto compileExit
}

/// Helper to create a CSP portal application
ClassMethod createPortalApp(pPortal As %String, pNS As %String, pPortalDir As %String, pDescription As %String, pResource As %String = "", pRecursive As %Boolean = 1, pLoginPage As %String = "", pGrant As %String = "", pCookiePath As %String = "", pAuthMethods As %String = "", pLockCSPName As %Boolean = 1, pVerbose As %Boolean = 0, pGroupById As %String = "", pCspZenEnabled As %Boolean = 1, pInboundWebServicesEnabled As %Boolean = 1, pTwoFactorEnabled As %Boolean = 0, pIsNameSpaceDefault As %Boolean = 0, pPermittedClasses As %String = "") As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

#ifndef REPORTPROP
#define REPORTPROP(%l,%x,%y) Write:pVerbose !,?%l,%x,$J("",20-$L(%x))," = ["_%y,"]"
#endif

	If ($G(pPortal)="") || ($G(pNS)="") || ($G(pPortalDir)="") {
		Set msg = "- ERROR when creating Portal application: Application name, namespace and directory must not be null"
		Set tSC = $$$ERROR($$$GeneralError,msg)
		$$$REPORT(6,msg)
		Quit tSC
	}

	Try {
	 	If '##class(%File).DirectoryExists(pPortalDir) {
		 	$$$REPORT(6,"- Creating directory: "_pPortalDir)
			Do ##class(%File).CreateDirectory(pPortalDir)
	 	}
 
	 	// Ensure the cookie path is reasonable and ends in a /
	 	Set:$G(pCookiePath)="" pCookiePath = pPortal
	 	Set:$E(pCookiePath,$L(pCookiePath))'="/" pCookiePath = pCookiePath_"/"

		// Check if we are creating or udating the Portal CSP application 
	 	Set Exists = ##class(Security.Applications).Exists(pPortal, .tApp, .tSC)
 
	 	If Exists {
		 	$$$REPORT(6,"- Updating CSP Application: "_pPortal)
		 	If tApp.Resource = "%Admin_Manage" {
				Set tApp.Resource = pResource
				$$$REPORTPROP(10,"Resource", pResource)
			}
	 	}
	 	Else {
			$$$REPORT(6,"- Creating CSP Application: "_pPortal)
			Set tApp = ##class(Security.Applications).%New()
			 // Use pAuthMethods if a value is passed, otherwise use default security (HCR152)
			If pAuthMethods {
				Set CSPAppSec = +pAuthMethods
			}
			Else {
				Set CSPAppSec = ..DetermineCSPAppSec()
			}
			// For HealthShare, add delegated authentication
			IF ..IsHealthShareInstalled()&&'$zb(CSPAppSec,$$$AutheDelegated,1) {
				Set tSC=##Class(Security.System).Get(,.tProp) Quit:$$$ISERR(tSC)
				If $zb(+tProp("AutheEnabled"),$$$AutheDelegated,1) { Set CSPAppSec=CSPAppSec+$$$AutheDelegated}
			}
			Set tApp.Name = pPortal $$$REPORTPROP(10,"Name",pPortal)
			Set tApp.AutheEnabled = CSPAppSec $$$REPORTPROP(10,"AutheEnabled",CSPAppSec)
			Set tApp.Enabled = 1 $$$REPORTPROP(10,"Enabled",1)
			Set tApp.Description = pDescription $$$REPORTPROP(10,"Description",pDescription)
			Set tApp.Resource = pResource $$$REPORTPROP(10,"Resource",pResource)
			Set tApp.AutoCompile = 0 $$$REPORTPROP(10,"AutoCompile",0)
			Set tApp.Timeout= 900 $$$REPORTPROP(10,"Timeout",900)
			Set tApp.Path = pPortalDir $$$REPORTPROP(10,"Path",pPortalDir)
			Set tApp.Recurse = pRecursive $$$REPORTPROP(10,"Recurse",pRecursive)
			Set tApp.LoginPage = pLoginPage $$$REPORTPROP(10,"LoginPage",pLoginPage)
			Set tApp.InbndWebServicesEnabled = pInboundWebServicesEnabled $$$REPORTPROP(10,"InbndWebServicesEnabled",pInboundWebServicesEnabled)
			Set tApp.TwoFactorEnabled = pTwoFactorEnabled $$$REPORTPROP(10,"TwoFactorEnabled",pTwoFactorEnabled)
			Set tApp.IsNameSpaceDefault = pIsNameSpaceDefault $$$REPORTPROP(10,"IsNameSpaceDefault",pIsNameSpaceDefault)
			Set tApp.PermittedClasses = pPermittedClasses $$$REPORTPROP(10,"PermittedClasses",pPermittedClasses)
			If pGrant'="" {
				Set tGrant=""
				For i = 1:1:$L(pGrant,",") {
					Set r = $P(pGrant,",",i)
					Set:r'="" tGrant=tGrant_":"_r
				}
				//tGrant must be of format :grant1:grant2 etc
				Do:tGrant'="" tApp.MatchRoles.Insert(tGrant)
			 }
			$$$REPORTPROP(10,"MatchRoles",pGrant)
		}

		// Set properties that are required for the Ensemble Portal to work properly
		Set tApp.Type = $$$AppTypeCSP $$$REPORTPROP(10,"Type",$$$AppTypeCSP)
		Set tApp.CookiePath = pCookiePath $$$REPORTPROP(10,"CookiePath",pCookiePath)
		Set tApp.LockCSPName = pLockCSPName $$$REPORTPROP(10,"LockCSPName",pLockCSPName)
		Set tApp.NameSpace = pNS $$$REPORTPROP(10,"NameSpace",pNS)
		Set tApp.CSPZENEnabled = pCspZenEnabled $$$REPORTPROP(10,"CSPZENEnabled",pCspZenEnabled)
		Set tDoGroupById = 1
		// Only change GroupById once after upgrading
		If (pGroupById = $$$IscMgtPortalId) && (tApp.GroupById = "") && ..IsEnsembleInstalled() {
			If (Exists) && $DATA(^%SYS("Ensemble","CSPApp",$zcvt(pNS,"U"),"GroupById",pPortal)) {
				Set tDoGroupById = 0
			}
			Else {
				Set ^%SYS("Ensemble","CSPApp",$zcvt(pNS,"U"),"GroupById",pPortal) = ""
			}
		}
		If tDoGroupById Set tApp.GroupById = pGroupById $$$REPORTPROP(10,"GroupById",pGroupById)
		Set tApp.ServeFiles = 2 $$$REPORTPROP(10,"ServeFiles",2) // Always and Cached
		Set tApp.UseCookies = 2 $$$REPORTPROP(10,"UseCookies",2) // Set UseCookies to Always
		
		// Save Portal's CSP application
		Set tSC = tApp.%Save()
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	
	Quit tSC
}

/// Helper method to identify which authentication methods we will enable for the CSP app
ClassMethod DetermineCSPAppSec() As %Integer [ Internal, Private ]
{
	Set CSPAppSec = 0
	
	Try {
		// Default security for CSP applications based on initial security type is stored in ^%SYS("CSPAppSec")
		// for Ensemble and Cache.
	
		If $D(^%SYS("Ensemble","CSPAppSec")) {
			// Move CSPAppSec subscript one level up in case it's still in its old location. (HCR152)
			Merge ^%SYS("CSPAppSec") = ^%SYS("Ensemble","CSPAppSec")
			Kill ^%SYS("Ensemble","CSPAppSec")
		}
	
		Set CSPAppSec = +$G(^%SYS("CSPAppSec"))
		If 'CSPAppSec {
			// Determine and save default settings, depending on initial security type
			Try {
				Set s = ##class(Security.System).GetInstallationInfo(.Info)
				Set Type = $G(Info("InitialSecuritySettings"))
				If Type'="" {
					// This information is only available at installation time!
					If Type="None" {
						Set CSPAppSec = $$$AutheUnauthenticated
					}
					ElseIf Type="Normal" {
						Set CSPAppSec = $$$AutheCache
					}
					Else {
						Set CSPAppSec = $$$AutheLDAP+$$$AutheLDAPCache+$$$AutheCache+$$$AutheK5API
					}
					If CSPAppSec Set ^%SYS("CSPAppSec") = CSPAppSec
				}
			}
			Catch {
			}
		}
		If 'CSPAppSec {
			Try {
				// Can't determine based on type, use whatever is set for ENSDEMO if it exists
				Set tApp = "/csp/ensdemo"
				Set s = ##class(Security.Applications).Get(tApp, .tProperties)
				If s Set CSPAppSec = +$G(tProperties("AutheEnabled"))
			}
			Catch {
			}
		}
		If 'CSPAppSec {
			Try {
				// Can't determine based on type or ENSDEMO, use whatever is set for SAMPLES if it exists
				Set tApp = "/csp/samples"
				Set s = ##class(Security.Applications).Get(tApp, .tProperties)
				If s Set CSPAppSec = +$G(tProperties("AutheEnabled"))
			}
			Catch {
			}
		}
		If 'CSPAppSec {
			// Couldn't identify, will use our general default
			Set CSPAppSec = ..#DEFAULTCSPAUTHMETHODS
		}
	}
	Catch {
	}
	
	Quit CSPAppSec
}

ClassMethod RemoveLegacyPortal(pTargetNS As %String = "", pPortalDir As %String = "", pPortalApp As %String = "", pFiles As %Boolean = 1, pClasses As %Boolean = 0, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	If (pTargetNS = "") || (pPortalDir = "") || (pPortalApp = "") || ('##class(%Library.File).DirectoryExists(pPortalDir)) {
		Quit $$$OK
	}
	If '##class(%SYS.Namespace).Exists(pTargetNS) {
		Quit $$$ERROR($$$NamespaceDoesNotExist,pTargetNS)
	}
	Set tSC = $$$OK
	New $namespace
	Set tInitNS = $namespace
	Try {
		Set $namespace = "%SYS"
		// Actively remove CSPX package mapping
		If ##class(Config.MapPackages).Exists(pTargetNS,"CSPX",.tCSPXMap) {
			If $IsObject($get(tCSPXMap)) && (tCSPXMap.Database = ..#ENSLIB) {
				$$$REPORT(6,"- Removing CSPX package mapping for namespace '"_pTargetNS_"'")
				Set tSC = ##class(Config.MapPackages).Delete(pTargetNS,"CSPX")
				If $$$ISERR(tSC) Quit
			}
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Set $namespace = tInitNS
	If $$$ISERR(tSC) Quit tSC
	
	Set tTargetApp = ..DetermineMgmtURLForNamespace(pTargetNS,0)
	If tTargetApp = "" {
		// We don't know about this application, so we shouldn't remove any class in it!
		Quit $$$OK
	}
		
	Set tExpectedPortal = (tTargetApp = pPortalApp)
	If ('tExpectedPortal) && ..IsHealthShareNamespace(pTargetNS) {
		// check for ensemble/ application
		Set tExpectedPortal = ((tTargetApp _ $select($extract(tTargetApp,*) = "/":  "", 1: "/") _ "ensemble/")  = pPortalApp)
	}
	If 'tExpectedPortal {
		$$$REPORT(6,"WARNING: '"_pPortalApp_"' is not the expected Ensemble portal for namespace '"_pTargetNS_"'. Not removing legacy CSP files.")
		Quit $$$OK
	}
	
	Set tSC = $$$OK
	Set tEnsLib = ..GetENSLIB(1)
	Set tMerged = 0
	Try {
		Merge tPageList = ^|tEnsLib|Ens.LegacyPortal("Files")
		Set tMerged = 1
	}
	Catch ex {
		If ex.Name '[ "NAMESPACE" {
			Set tSC = ex.AsStatus()
		}
	}
	If $$$ISERR(tSC) Quit tSC
	If 'tMerged Quit $$$OK
	
	Set tFileSC = $$$OK
	If pFiles {
		For tType = "CSP","OTHER" {
			Set tSub = ""
			For {
				Set tSub = $order(tPageList(tType,tSub))
				Quit:(tSub = "")
				// We only go one level deep
				If $data(tPageList(tType,tSub))\10 {
					Set tFullDir = ##class(%Library.File).SubDirectoryName(pPortalDir,tSub,1)
					If ##class(%Library.File).DirectoryExists(tFullDir) {
						Set tFileKey = ""
						For {
							Set tFileKey = $order(tPageList(tType,tSub,tFileKey))
							Quit:(tFileKey = "")
							Set tFilename = ##class(%Library.File).NormalizeFilename(tFileKey, tFullDir)
							If ##class(%Library.File).Exists(tFilename) {
								Set tResult = ##class(%Library.File).Delete(tFilename)
								If 'tResult {
									Set tSC1 = $$$ERROR($$$FileCanNotDelete,tFilename)
									Set tFileSC = $$$ADDSC(tFileSC,tSC1)
								}
							}
						}
						Set tRS = ##class(%Library.ResultSet).%New("%Library.File:FileSet")
						If $$$ISOK(tRS.Execute(tFullDir)) && 'tRS.Next() && '##class(%Library.File).RemoveDirectory(tFullDir) {
							Set tSC1 = $$$ERROR($$$FileCanNotDelete,tFullDir)
							Set tFileSC = $$$ADDSC(tFileSC,tSC1)
						}
					}
				}
				Else {
					Set tFilename = ##class(%Library.File).NormalizeFilename(tSub, pPortalDir)
					If ##class(%Library.File).Exists(tFilename) {
						Set tResult = ##class(%Library.File).Delete(tFilename)
						If 'tResult {
							Set tSC1 = $$$ERROR($$$FileCanNotDelete,tFilename)
							Set tFileSC = $$$ADDSC(tFileSC,tSC1)
						}
					}
				}
			}
		}
	}
	Set tClassSC = $$$OK
	If pClasses {
		Set tInitNS = $namespace
		Try {
			Set $namespace = pTargetNS
			Set tPage = ""
			For {
				Set tPage = $order(tPageList("CSP",tPage))
				Quit:(tPage = "")
				If $data(tPageList("CSP",tPage)) \ 10 {
					Set tPageKey = ""
					For {
						Set tPageKey = $order(tPageList("CSP",tPage,tPageKey))
						Quit:(tPageKey = "")
						Set tClass = $system.CSP.GetClassName(pPortalApp_tPage_"/"_tPageKey)
						If (tClass '= "") && ##class(%Dictionary.ClassDefinition).%ExistsId(tClass) {
							Set tSC1 = $system.OBJ.Delete(tClass)
							If $$$ISERR(tSC1) {
								Set tClassSC = $$$ADDSC(tClassSC,tSC1)
							}
						}
					}
				}
				Else {
					Set tClass = $system.CSP.GetClassName(tPage,pPortalApp)
					If (tClass '= "") && ##class(%Dictionary.ClassDefinition).%ExistsId(tClass) {
						Set tSC1 = $system.OBJ.Delete(tClass)
						If $$$ISERR(tSC1) {
							Set tClassSC = $$$ADDSC(tClassSC,tSC1)
						}
					}
				}
			}
		}
		Catch ex {
			Set tClassSC = ex.AsStatus()
		}
		If $namespace '= tInitNS {
			Set $namespace = tInitNS
		}
	}
	Quit $$$ADDSC(tClassSC,tFileSC)
}

ClassMethod setDBRWFlag(dir As %String, flag As %Integer) As %Status [ Internal, Private ]
{
	Set flag='flag, tSC = $$$OK
	For  {
		Set db = ##class(SYS.Database).%OpenId(dir)
		If $IsObject(db) && db.Expanding hang 2 Set db="" Continue
		Quit
	}
	If $IsObject(db) {
		If (db.ReadOnly '= flag) {
			Set db.ReadOnly = flag
			Set tSC = db.%Save()
		}
	} Else {
		Set tSC = %objlasterror
	}
	Kill db
	Quit tSC
}

ClassMethod assignResourceToDB(pResource As %String, pDatabase As %String, pPublicPermissions As %String = "RW") As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set tDescription = "The "_$P(pResource,"%DB_",2)_" database"

	// If the resource already exists, and its description is in old format, convert the description directly in the global
	Set tNode = $G(^SYS("Security","ResourcesD",$ZCVT(pResource,"l")))
	If $LV(tNode) && ($LG(tNode,2)[" Database resource") {
		Set $LI(tNode,2) = tDescription
		Set ^SYS("Security","ResourcesD",$ZCVT(pResource,"l")) = tNode
	}

	// Create a new resource if it doesn't exist already (as long as it's not %DB_%DEFAULT)
	If (pResource '= ..#DEFAULTDBRESOURCE), '##class(Security.Resources).Exists(pResource,.tObjResource,.tSC) || '$IsObject($G(tObjResource)) {
		Set tSC = ##class(Security.Resources).Create(pResource,tDescription,pPublicPermissions,3)
	}

	If $$$ISOK(tSC) {
		// Update the database with the resource
		Set tSC = ..setDBattributes(pDatabase,2,pResource)
	}

	Quit tSC
}

ClassMethod setDBattributes(dir As %String, mode As %String, rnam As %String) [ PublicList = rc ]
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		#dim arg As %String
		
		New rc
		Set rc=$zu(49,dir) If rc<0 {
			Set tSC = $$$ERROR($$$DatabaseDoesNotExist,dir)
			Quit
		}
		Set:$G(rnam)="" rnam=$p(rc,",",25) Set:rnam="" rnam=..#DEFAULTDBRESOURCE
		
		// Check that the resource is valid, otherwise $ZU(1) gives a <FUNCTION> error
		If ((rnam[",")||(rnam[":")||(rnam["/"))||((rnam '= ..#DEFAULTDBRESOURCE) && ($EXTRACT(rnam,$FIND(rnam,"_"))="%")) {
			// Resource name cannot contain ,:/ nor can there be a % right after the _ unless it's %DB_%DEFAULT
			Set tSC = $$$ERROR($$$ResourceInvalidName,rnam)
			Quit
		}
		
		Set arg="rc=$zu(1,"""_dir_""","_$p(rc,",",2,12)_","_mode_",0,0,0,0,"""_rnam_""")"
		Set @arg
		If +rc'>0 Set tSC=$$$ERROR(-rc)  // $ZU(1) returns -ve error codes from dkio.c that map to $$$ERROR numbers
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod getDBRWFlag(dir As %String, ByRef flag As %Integer) As %Status [ Internal, Private ]
{
	Set flag=0,tSC = $$$OK
	Set db = ##class(SYS.Database).%OpenId(dir)
	If $IsObject(db) {
		// flag == 1 means r/w
		Set flag = 'db.ReadOnly
	} Else {
		Set tSC = %objlasterror
	}
	Kill db
	Quit tSC
}

ClassMethod getMappedGlobals(ByRef pGlobals, pEnsLib As %String = {..#ENSLIB}) [ Internal, Private ]
{
	Kill pGlobals
	Set tIO = $IO
	Try {
	
		// We build the list of global subscripts to be mapped from the contents of ^CacheMsg
		// in the ENSLIB database.  Thus, it will dynamically adapt as new domains are added.
	
		If '##class(Config.Databases).Exists(pEnsLib, .tDB) {
			Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$DatabaseDoesNotExist, pEnsLib))
		}
		New $namespace
		Set $namespace = "^^"_tDB.Directory
	
		Set tItem=""
		For {
			Set tItem=$ORDER(^CacheMsg(tItem))
			Quit:tItem=""
		
			Set pGlobals("CacheMsg:("""_tItem_""")")=""
			Set pGlobals("CacheMsgNames:("""_tItem_""")")=""
		}

		// Also, we build the list of mappings for HL7 schemas from ENSLIB
		Set tItem=""
		For {
			Set tItem=$ORDER(^EnsHL7.Schema(tItem))
			Quit:tItem=""
		
			Set tQuotedItem = $SELECT(tItem?1.n1"."1.n:tItem,1:""""_tItem_"""")
		
			Set pGlobals("EnsHL7.Schema:("_tQuotedItem_")")=""
			Set pGlobals("EnsHL7.Description:("_tQuotedItem_")")=""
		}
	
		// Also, we build the list of mappings for ASTM schemas from ENSLIB
		Set tItem=""
		For {
			Set tItem=$ORDER(^EnsEDI.ASTM.Schema(tItem))
			Quit:tItem=""
		
			Set tQuotedItem = $SELECT(tItem?1.n1"."1.n:tItem,1:""""_tItem_"""")
		
			Set pGlobals("EnsEDI.ASTM.Schema:("_tQuotedItem_")")=""
			Set pGlobals("EnsEDI.ASTM.Description:("_tQuotedItem_")")=""
		}
		
		// Also, we build the list of mappings for X12 schemas from ENSLIB
		Set tItem=""
		For {
			Set tItem=$ORDER(^EnsEDI.X12.Schema(tItem))
			Quit:tItem=""
		
			Set tQuotedItem = $SELECT(tItem?1.n1"."1.n:tItem,1:""""_tItem_"""")
		
			Set pGlobals("EnsEDI.X12.Schema:("_tQuotedItem_")")=""
			Set pGlobals("EnsEDI.X12.Description:("_tQuotedItem_")")=""
		}

		// And, we build the list of mappings for EDI schemas from ENSLIB
		Set tItem=""
		For {
			Set tItem=$ORDER(^EnsEDI.Schema(tItem))
			Quit:tItem=""
		
			Set pGlobals("EnsEDI.Schema:("""_tItem_""")")=""
		}
		Set pGlobals("EnsEDI.Description:(""X"",""X12"")")=""
	
		// Other globals ... No longer mapped as of DDP102
		//Set pGlobals("Ens.Config.SearchTablePropD")=""
		//Set pGlobals("Ens.Config.SearchTablePropI")=""
	
		Set pGlobals("EnsDICOM.Dictionary")=""
		Use tIO
	}
	Catch ex {
		Use tIO
		Throw ex
	}
	Quit
}

ClassMethod loadMessages(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status [ Internal ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	Set tSC = $$$OK
	Set tOldNamespace = $Namespace
	Set $ZT="Trap"
	
	Set $Namespace = pTargetNS
	
	Do {
		
		// Find any matching CSP files
		Set tRS = ##class(%ResultSet).%New("%File:FileSet")
		If '$IsObject(tRS) Set tSC = %objlasterror Quit
		
		Set tLocaleDir = $$$LOCALEPATH
		Set tSC = tRS.Execute(tLocaleDir,"allmessages_*.xml")
		If $$$ISERR(tSC) Quit
		
		// Now, traverse the matching XML files
		While (tRS.Next()) {
			Set tFile = tRS.Data("Name")
			
			// Sanity checking on the filename (incl. ignoring the version separator ';' on VMS)
			If (tRS.Data("Type")'="F") || ($ZCVT($P($P(tFile,".",$L(tFile,".")),";"),"l")'="xml") Continue
			
			$$$REPORT(8,"+ Loading: "_tFile)
			
			// Load the messages
			Set tSC = $$Import^%occMsgXML(tFile)
			// Remove HealthShare domains if not in HSLIB
			// - note invoking this method for HSLIB will redundantly reload all messages into the appropriately mapped namespaces
			IF pTargetNS'=..#HSLIB {
				for tDomain="HS","HSErr" {kill ^CacheMsg(tDomain),^CacheMsgNames(tDomain)}
			}
			Do:$$$ISERR(tSC) $system.OBJ.DisplayError(tSC)
		}
		
		// We ignore any errors during loading, other than to report them.
		Set tSC = $$$OK
	} While(0)
	
Exit
	Set $Namespace = tOldNamespace
	Quit tSC

Trap
	Set $ZT = ""
	Set tSC = $$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod MultiEnsembleInstalled() As %Boolean
{
	Quit $o(^%SYS("Ensemble","InstalledNamespace",$o(^%SYS("Ensemble","InstalledNamespace",""))))'=""
}

/// Called by HealthShare, can't be private. This is an internal method for internal use only. It deletes databases.
/// pDBsToDelete - CORECGLOBALS (default), MAINGLOBALONLY, ALL
/// 		COREGLOBALS means delete main global database and Ensemble Temporary and Secondary DB if they exist and only if no other namespace references them.
/// 		MAINGLOBALONLY means delete main global database only and only if no other namespace references them.
/// 		ALL means delete all databases used by the namespace and only if no other namespace references them.
/// pRemoveResources 0 (default) or 1. If 1 then delete resources/roles named %DB_<NameOfDatabaseBeingDeleted>
/// 
ClassMethod deleteNamespace(pTargetNS As %String, pPurgeFiles As %Boolean = 0, pVerbose As %Boolean = 0, pDBsToDelete As %String = "COREGLOBALS", pRemoveResources As %Boolean = 0) As %Status [ Internal ]
{
	#define LOGERR(%a,%b) If $$$ISERR(%b) Set %a=$$$ADDSC(%a,%b) Do:pVerbose $system.OBJ.DisplayError(%b)
	
	Set (tSC,tSC2)=$$$OK
	Try {
		// Check for namespace validity
		Quit:'..validateNamespace(.pTargetNS,0,.tSC)
		
		// Now, let's switch to %SYS and go delete this namespace
		New $NAMESPACE
		Set $NAMESPACE ="%SYS"
		
		$$$REPORT(0,"Deleting Ensemble namespace: "_pTargetNS)

		// First, delete the CSP application
		Set tPortal = ..DetermineMgmtURLForNamespace(pTargetNS)
		Set tPortal = $P(tPortal,"/",1,$L(tPortal,"/")-1)
		Set tSC2 = ..deletePortal(tPortal,pPurgeFiles,pVerbose)
		If $$$ISERR(tSC2) Quit
		
		// Next, let's delete the namespace and get Namespace properties
		Set tSC2=##Class(Config.Namespaces).Get(pTargetNS,.p)
		If $$$ISERR(tSC2) Quit
		
		//Find databases and their directories.
	
		If (pDBsToDelete="MAINGLOBALONLY") {
			Set tSC2=##Class(Config.Databases).Get(p("Globals"),.p1)
			If $$$ISERR(tSC2) Quit
			Set tDBs(p("Globals"))=p1("Directory")
			Set tCoreDBs = ","_p("Globals")_","
		} Else {
		 	Set tStmnt = ##class(%SQL.Statement).%New()
		 	Set tSC2 = tStmnt.%PrepareClassQuery("SYS.Database","List")
		 	If $$$ISERR(tSC2) Quit
		 	Set tRS = tStmnt.%Execute("*")
		 	While tRS.%Next(.tSC2) {
				Set tDatabases($i(tDatabases)) = tRS.%Get("Directory")
		 	}
		 	If $$$ISERR(tSC2) Quit
		 	For i=1:1:tDatabases {
		 		Set tSC2 = ##class(Config.Databases).DatabasesByDirectory("",tDatabases(i), .tDBNames)
		 		If $$$ISERR(tSC2) Quit
				For j=1:1:$listlength($get(tDBNames)) {
					Set tDB = $listget(tDBNames, j)
					If tDB '= "" { Set tDBs(tDB) = tDatabases(i) }
				}
		 	}
		 	If $$$ISERR(tSC2) Quit
		 	Set tCoreDBs = ","_p("Globals")_","_p("Globals")_..#TEMPSUFFIX_","_p("Globals")_..#SECONDARYSUFFIX_","
		}
		
		// Refine list to include only those used by the namespace and only that namespace
		Set tDBName = ""
		Set tDBName = $order(tDBs(tDBName))
		While (tDBName '=""){
			Set tSC2 = ##class(Config.Namespaces).NamespacesByDB(tDBName, .tNamespaces)
			If $$$ISERR(tSC2) Quit
			Set tNumberNamespaces = $length($get(tNamespaces),",")
			If ((tNumberNamespaces'=1))||(($piece(tNamespaces, ",", 1))'=pTargetNS) {
				Kill tDBs(tDBName)
			} ElseIf (pDBsToDelete'="ALL"){
				If tCoreDBs'[(","_tDBName_",") Kill tDBs(tDBName)
			}
			Set tDBName = $order(tDBs(tDBName))
		}
		If $$$ISERR(tSC2) Quit
		
		// Remove the namespace from the config
		$$$REPORT(4,"* Removing namespace: "_pTargetNS)
		Set tSC2 = ##Class(Config.Namespaces).Delete(pTargetNS)
		If $$$ISERR(tSC2) Quit

		// Delete all databases and associated resources (if required) used only by the namespace
		Set tDBName = ""
 		Set tDBName = $order(tDBs(tDBName),1,tDBDir)
 		While (tDBName '=""){
	 		$$$REPORT(4,"* Removing Database "_tDBName)
			Set tSC2 = ##class(Config.Databases).Delete(tDBName)
			Quit:($$$ISERR(tSC2))
			If pPurgeFiles {
				$$$REPORT(6,"- Deleting Database "_tDBDir)
				Set tSC2 = ##class(SYS.Database).DeleteDatabase(tDBDir)
				Quit:($$$ISERR(tSC2))
				Set tDirectoriesToRemove(tDBDir)=""
			}
			If pRemoveResources && ##class(Security.Roles).%ExistsId($ZCVT("%DB_"_tDBName,"L")) {
				Set tSC2 = ##class(Security.Roles).Delete("%DB_"_tDBName)
				Quit:($$$ISERR(tSC2))
	 		}
	 		If pRemoveResources && ##class(Security.Resources).%ExistsId($ZCVT("%DB_"_tDBName,"L")) {
				Set tSC2 = ##class(Security.Resources).Delete("%DB_"_tDBName)
				Quit:($$$ISERR(tSC2))
	 		}
			Set tDBName = $order(tDBs(tDBName),1,tDBDir)
		}
		If $$$ISERR(tSC2) Quit

		If pPurgeFiles {	
			// Remove directories. Loop backwards so remove lower branches first but check if exists as well.
	 		$$$REPORT(4,"* Removing directories used by deleted databases")
			Set tDBDir = ""
 			Set tDBDir = $order(tDirectoriesToRemove(tDBDir),-1)
 			While (tDBDir '=""){
				// Delete the database directory
				$$$REPORT(6,"- Deleting Database Directory "_tDBDir)
				If ##class(%File).DirectoryExists(tDBDir) && '##class(%File).RemoveDirectoryTree(tDBDir) {
					$$$LOGERR(tSC,%objlasterror)
				}
				Set tDBDir = $order(tDirectoriesToRemove(tDBDir),-1)
			}
		}

		// Done!
		$$$REPORT(4,"* Complete!")
		
		// Any accumulated errors will be in tSC

	} Catch ex { Set tSC2 = ex.AsStatus()}

	$$$LOGERR(tSC,tSC2)
Exit
	Quit tSC
}

/// Remove a CSP application
/// Called by HealthShare, can't be private
ClassMethod deletePortal(pPortal As %String, pPurgeFiles As %String, pVerbose As %Boolean = 0) As %Status [ Internal ]
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		If $NAMESPACE'="%SYS" {
			New $NAMESPACE
			Set $NAMESPACE = "%SYS"
		}
		
		Set:$E(pPortal,$L(pPortal))="/" pPortal = $E(pPortal,1,$L(pPortal)-1)
		Set tSC = ##class(Security.Applications).Get(pPortal,.tProperties)
		If $$$ISOK(tSC) {
			$$$REPORT(4,"* Removing management portal: "_pPortal)
			Set tSC = ##class(Security.Applications).Delete(pPortal)
			If $$$ISOK(tSC),pPurgeFiles {
				// Delete any CSP files
				Set tPortalDir = tProperties("Path")
				$$$REPORT(6,"- Deleting files in "_tPortalDir)
				If '##class(%File).RemoveDirectoryTree(tPortalDir) {
					Set tSC = %objlasterror
				}
			}
		}
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

/// Classmethod to ensure SearchTable classes are correctly deployed to each Ensemble namespace.
ClassMethod deploySearchTables(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Set tStatus = $$$OK
	New $namespace
	Try {
		If $data(^%SYS("Ensemble", "Upgrade", "SearchTable")) {
			$$$REPORT(6,"- Converting existing SearchTable definitions")
			Set tStatus = ..upgradeSearchTables(pTargetNS, pVerbose)
			If $$$ISERR(tStatus) Quit
		}
		$$$REPORT(6,"- Validating all SearchTable metadata")
		Set $namespace = pTargetNS
		Set tClasses = ##class(%Library.ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
		Set tStatus = tClasses.Execute("Ens.VDoc.SearchTable")
		If $$$ISERR(tStatus) Quit
		#; Find all searchtables
		While tClasses.%Next() {
			Set tClassname = tClasses.%Get("Name")
			// Exclude Ens.VDoc.*, which should be superclasses, like Ens.VDoc.XMLSearchTable
			If $extract(tClassname, 1, 9) = "Ens.VDoc." Continue

			If '##class(%Dictionary.CompiledClass).%ExistsId(tClassname) {
				$$$REPORT(8,"- Skipping class '"_tClassname_"' as it has not been compiled")
			}
			Else {
				$$$REPORT(8, "- Regenerating metadata for " _ tClassname)
				Set tStatus = ##class(Ens.VDoc.SearchTableGenerator).ValidateSearchTableProperties(tClassname)
				If $$$ISERR(tStatus) Quit
			}
		}
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Classmethod to upgrade SearchTable metadata which was mapped to ENSLIB in versions prior to 2010.2.
ClassMethod upgradeSearchTables(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status
{
	#ifndef REPORT
	#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
	#endif
	#define DataLocation		^%SYS("Ensemble", "Upgrade", "SearchTable", "Data")
	#def1arg DataGlobal(%args)	^%SYS("Ensemble", "Upgrade", "SearchTable", "Data", %args)
	#define NSList				^%SYS("Ensemble", "Upgrade", "SearchTable", "Namespaces")
	#define PropStorageLocation(%base, %propName)	^Ens.Config.SearchTablePropD(%base, %propName)
	#define getProp(%list, %pos) $listget(%list, %pos)
	#define propClassname		 1
	#define propDerivation		 2
	#define propIndexType		 3
	#define propIsImplicit		 4			
	#define propPropId			 5
	#define propPropType		 6
	#define propStoreNulls		 7
	
	New %dataLoc
	Set tStatus = $$$OK
	Set tStartNS = $namespace
	Try {
		Set tUpgraded = $listfind($get($$$NSList), pTargetNS)
		If tUpgraded {
			$$$REPORT(8,"+ Skipping SearchTable upgrade for namespace '"_pTargetNS_"' as it has already been upgraded")
		}
		Else {
			Set $namespace = pTargetNS
			Set tBaseClass = ""
			For {
				Set tBaseClass = $order($$$DataGlobal(tBaseClass))
				Quit:(tBaseClass = "")
				Set tPropName = ""
				For {
					Set tPropName = $order($$$DataGlobal(tBaseClass, tPropName))
					Quit:(tPropName = "")
					Set tPropData = $get($$$DataGlobal(tBaseClass, tPropName))
					Set tPropId = +$$$getProp(tPropData, $$$propPropId)
					Set tSeenIDs(tBaseClass, tPropId) = ""
					Set tExists = ##class(Ens.Config.SearchTableProp).indexClassPropExists(tBaseClass, tPropName)
					If 'tExists { // We can replicate the old metadata safely, as there is no metadata present
						Set tDerivation = $$$getProp(tPropData, $$$propDerivation)
					
						Set tGenClass = $piece(tDerivation, "~", 1)
						Set tUpGenClass = $zconvert(tGenClass, "U")
						// Check that the class which created the SearchTable exists in this namespace
						Set tSourceClassExists = $data(^rINDEXCLASS(tUpGenClass))#2
						If tSourceClassExists { // should create the entry
							Set tProp = ##class(Ens.Config.SearchTableProp).%New()
							Set tProp.ClassExtent = tBaseClass
							Set tProp.ClassDerivation = tDerivation
							Set tProp.IndexType = $$$getProp(tPropData, $$$propIndexType)
							Set tProp.IsImplicit = $$$getProp(tPropData, $$$propIsImplicit)
							Set tProp.PropId = $$$getProp(tPropData, $$$propPropId)
							Set tProp.PropType = $$$getProp(tPropData, $$$propPropType)
							Set tProp.StoreNulls = $$$getProp(tPropData, $$$propStoreNulls)
							Set tProp.Name = tPropName
							$$$REPORT(8, "+ Adding SearchTable property '"_tProp.Name_"' in class '"_$piece(tProp.ClassDerivation, "~",1)_"' with PropId '"_tProp.PropId_"'")
							Set tStatus = tProp.%Save() 
							If $$$ISERR(tStatus) $$$ThrowStatus(tStatus)
						}
					}
					Else { // The metadata already exists locally... how would this be possible...?
						// We need to confirm that the values are the same, especially the derivation,
						// as the previous behaviour didn't always report this well
						Set tOldPropData = $get($$$PropStorageLocation(tBaseClass, tPropName))
						$$$REPORT(8, "+ Checking [%SYS] SearchTable property '"_tPropName_"' in class '"_$piece($$$getProp(tPropData, $$$propDerivation), "~")_"' with PropId '"_$$$getProp(tPropData, $$$propPropId)_"' against local property from class '"_$piece($$$getProp(tOldPropData, $$$propDerivation),"~")_"' with PropId '"_$$$getProp(tOldPropData,$$$propPropId)_"'")
						For i=1:1:7 {
							If $$$getProp(tOldPropData, i) '= $$$getProp(tPropData, i) {
								Set tStatus = $$$ERROR($$$GeneralError, "Conflict between existing and stored SearchTable data for property '"_tBaseClass_":"_tPropName_"' in namespace '"_pTargetNS_"'; Contact the WRC to resolve the issue")
								$$$ThrowStatus(tStatus)
							}
						}
						// All properties match
					}
				}
			}
			
			Set $$$NSList = $get($$$NSList)_$listbuild(pTargetNS)
		}
		
		Set tEnsNS = ""
		Set tAllDone = 1
		For {
			Set tEnsNS = $order(^%SYS("Ensemble", "InstalledNamespace", tEnsNS))
			Quit:(tEnsNS = "")
			If '$listfind($get($$$NSList), tEnsNS) {
				Set tAllDone = 0
				Quit
			}
		}
		If tAllDone {
			$$$REPORT(8, "+ All Ensemble namespaces have upgraded SearchTables, upgrade data will be cleared")
			Kill $$$DataLocation
		}
		Set $namespace = tStartNS
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
		Set $namespace = tStartNS
	}
	Quit tStatus
}

/// Ensure that the ^Ens.DocClassMap global has valid data during upgrades from versions where
/// the DocClassMap wasn't used.
ClassMethod upgradeDocClassMap(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status
{
	#ifndef REPORT
	#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
	#endif
	
	Set tStatus = $$$OK
	Try {
		New $namespace
		Set $namespace = pTargetNS
		If $data(^Ens.DocClassMap) {
			$$$REPORT(8, "+ DocClassMap already present in namespace '"_$namespace_"'; no upgrade steps needed")
		}
		Else {
			#; Ensure we localise changes to the %Ensemble global variable in the DocClassMap code
			New %Ensemble
			Set %Ensemble = ""
			Set tRS = ##class(%Library.ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
			Set tStatus = tRS.Execute("Ens.VDoc.SearchTable")
			If $$$ISERR(tStatus) Quit
			While tRS.Next() {
				Set tClass = tRS.Get("Name")
				If $$$comClassKeyGet(tClass,$$$cCLASSabstract) Continue
				If $$$comClassKeyGet(tClass,$$$cCLASSnoextent) Continue
				#; Not using $parameter
				Set tDocClass = $$$comMemberKeyGet(tClass,$$$cCLASSparameter,"DOCCLASS",$$$cPARAMdefault)
				If tDocClass = "" Continue
				Set tSTList = ""
				If $$$comClassKeyGet(tDocClass,$$$cCLASSclasstype) = $$$cCLASSCLASSTYPESTREAM {
					Set tSTList = tSTList _ $listbuild("%Stream.Object")
				}
				Else {
					Set tSearchTableRoot = ##class(Ens.VDoc.SearchTableGenerator).GetExtentSuperclass(tClass)
					If tSearchTableRoot '= "" { Set tSTList = tSTList _ $listbuild(tSearchTableRoot) }
					If tClass '= tSearchTableRoot { Set tSTList = tSTList _ $listbuild(tClass) }
				}
				For i=1:1:$listlength(tSTList) {
					Set tSTClass = $listget(tSTList,i)
					Set tSC1 = ##class(Ens.DocClassMap).AddSearchTable(tDocClass,tSTClass,1)
					If $$$ISERR(tSC1) { $$$REPORT(10,"- Error DocClassMap for class '"_tSTClass_"' with DOCCLASS '"_tDocClass_"': "_$system.Status.GetErrorText(tSC1)) }
					Else { $$$REPORT(10,"- Added DocClassMap for class '"_tSTClass_"' with DOCCLASS '"_tDocClass_"'") }
				}
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Check whether any Ensemble UTC indices in a given namespace are in need of repair.
/// If <var>pLogToConsole</var> is true, we will also log a message to cconsole.log to indicate that
/// the <method>UpgradeUTCIndices</method>() method in this class should be run for this namespace.
ClassMethod CheckUTCIndices(pTargetNS As %String = "", pVerbose As %Boolean = 1, pLogToConsole As %Boolean = 0) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

	If (pTargetNS = "") {
		Quit $$$ERROR($$$GeneralError,"Target namespace required")
	}
	Set tStatus = $$$OK
	New $namespace
	Try {
		Set $namespace = pTargetNS
		// Indices to repair
		Set tList = ..getUTCIndexGlobals()
		Set tNeedRepair = 0
		For i=1:1:$listlength(tList) {
			Set tIndexGlobal = $listget(tList,i)
			If ..indexNeedsRepair(tIndexGlobal) {
				$$$REPORT(6,"- UTC Index global "_tIndexGlobal_" in namespace "_pTargetNS_" needs to be repaired")
				Set tNeedRepair = 1
			}
		}
		If 'tNeedRepair {
			$$$REPORT(6,"- No UTC index globals need to be repaired.")
		}
		ElseIf pLogToConsole {
			$$$WarnMsg("Ensemble: ##class(%Library.EnsembleMgr).UpgradeUTCIndices() must be run for namespace '"_pTargetNS_"' as it contains UTC index data that needs to be repaired.")
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Get a list of the index globals containing UTC data that needs to be 
/// checked for incorrectly normalized values.
ClassMethod getUTCIndexGlobals() As %List [ Private ]
{
	Quit $lb("^Ens.MessageHeaderI(""TimeCreated"")") _
	$lb("^Ens.BusinessProcessI(""TimeCreated"")") _
	$lb("^Ens.Util.LogI(""TimeLogged"")") _
	$lb("^Ens.Util.IOLogI(""TimeReceived"")") _
	$lb("^Ens.Rule.RuleLogI(""TimeExecuted"")") _
	$lb("^Ens.EntMsgBank.MessageHeaderI(""TimeBanked"")") _
	$lb("^Ens.EntMsgBank.MessageHeaderI(""TimeCreated"")") _
	$lb("^Ens.EntMsgBank.LogI(""TimeLogged"")")
}

/// Ensure that timestamps of type Ens.DataType.UTC are correctly stored in various classes.
/// <var>pVerbose</var> controls whether output is written to the current device.
/// <var>pUseBatchMode</var> controls whether the operation should run in batch mode. This ensures
/// that the process uses a limited number of global buffers, which is likely to be crucial on a running system.
ClassMethod UpgradeUTCIndices(pTargetNS As %String = "", pVerbose As %Boolean = 1, pUseBatchMode As %Boolean = 1) As %Status
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif

#define IndexExtentGlobal(%i)	($extract($piece(%i,"("),1,*-1)_"D")
#define IndexClassname(%i)		$replace($extract($piece(%i,"("),2,*-1),".EntMsgBank.",".Enterprise.MsgBank.")
#define ClassSQLTable(%c)		($$$comClassKeyGet(%c,$$$cCLASSsqlschemaname)_"."_$$$comClassKeyGet(%c,$$$cCLASSsqltablename))

	If (pTargetNS = "") {
		Quit $$$ERROR($$$GeneralError,"Target namespace required")
	}
	Set tStatus = $$$OK
	New $namespace
	Try {
		Set $namespace = pTargetNS
		$$$REPORT(1,"- Running Ensemble UTC index upgrade in namespace '"_pTargetNS_"'")

		If pUseBatchMode {
			$$$REPORT(3,"Setting Batch Mode for process to 1")
			Set tOldBatchMode = ##class(%SYSTEM.Process).BatchFlag(1)
		}
		// Indices to repair
		Set tList = ..getUTCIndexGlobals()

		$$$REPORT(3,"Checking index globals...")

		For i=1:1:$listlength(tList) {
			Set tIndexGlobal = $listget(tList,i)
			// Add newline for readability
			$$$REPORT(0,"")
			If '..indexNeedsRepair(tIndexGlobal) {
				$$$REPORT(5,"- Index global "_tIndexGlobal_" does not need to be repaired; skipping conversion")
				Continue
			}
			Set tIsRuleLog = (tIndexGlobal = "^Ens.Rule.RuleLogI(""TimeExecuted"")")
			Set tExtentGlobal = $$$IndexExtentGlobal(tIndexGlobal)
			Set tLastTimestamp = $order(@tIndexGlobal@(""),-1)
			If tLastTimestamp = "" {
				$$$REPORT(5,"- Index global "_tIndexGlobal_" has no entries; skipping conversion")
				Continue
			}
			Set tFirstTimestamp = $order(@tIndexGlobal@(""))

			Set tLastID = $select(tIsRuleLog: $get(^Ens.Rule.RuleLogC("ExecutionId")), 1: $get(@tExtentGlobal))
			Set tFirstID = ""
			If (tFirstTimestamp '= "") {
				Set tFirstID = $order(@tExtentGlobal@(tFirstTimestamp,""))
			}
			Set tIDMsg = $select(tFirstID && tLastID: " and between IDs '"_tFirstID_"' and '"_tLastID_"'", tLastID: " with ID less than '"_tLastID_"'", 1: "")
			// Even if tLastID = "", there may be orphaned data in the index
			$$$REPORT(5,"- Performing conversion for index global "_tIndexGlobal_" between timestamps '"_tFirstTimestamp_"' and '"_tLastTimestamp_"'"_ tIDMsg)
			
			Set tNumFixed = 0
			Set tNumOrphans = 0
			Set tCount = 0
			Set tTS = tLastTimestamp
			For {
				Set tCount = tCount + 1
				If ((tCount # 20000) = 0) {
					Set tLoggingID = $order(@tIndexGlobal@(tTS,""))
					$$$REPORT(7,tCount _ " timestamps checked; Currently checking time '"_tTS_"' and ID '"_tLoggingID_"'...")
				}
				Set tMilliseconds = $piece(tTS,".",2)
				If "0" = $extract(tMilliseconds,*) {
					#; tTS has milliseconds with a trailing 0
					Set tMilliseconds = $reverse(+$reverse(tMilliseconds))
					Set tNewTS = $piece(tTS,".",1) _ $select(tMilliseconds = "0": "", 1: "." _ tMilliseconds)
					Set tID = ""
					For {
						Set tID = $order(@tIndexGlobal@(tTS,tID),1,tVal)
						Quit:("" = tID)
						If tIsRuleLog {
							Set tExecID = ""
							For {
								Set tExecID = $order(@tIndexGlobal@(tTS,tID,tExecID),1,tVal)
								Quit:("" = tExecID)
								If $data(@tExtentGlobal@(tID,tExecID)) {
									Set @tIndexGlobal@(tNewTS,tID,tExecID) = tVal
									Set tNumFixed = tNumFixed + 1
								}
								Else {
									Set tNumOrphans = tNumOrphans + 1
								}
							}
						}
						Else {
							If $data(@tExtentGlobal@(tID)) {
								Set @tIndexGlobal@(tNewTS,tID) = tVal
								Set tNumFixed = tNumFixed + 1
							}
							Else {
								Set tNumOrphans = tNumOrphans + 1
							}
						}
					}
					Kill @tIndexGlobal@(tTS)
				}
				Set tTS = $order(@tIndexGlobal@(tTS),-1)
				Quit:("" = tTS)
			}
			$$$REPORT(5,"+ Index conversion for global "_tIndexGlobal_" complete; fixed "_tNumFixed_" entries and removed "_tNumOrphans_" orphaned index entries")
		}
		$$$REPORT(1,"- Completed UTC index upgrade in namespace '"_pTargetNS_"'")
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
		$$$REPORT(1,"ERROR: Failed to complete upgrade due to error: " _ $system.Status.GetErrorText(tStatus))
	}
	If $data(tOldBatchMode)#2 Do ##class(%SYSTEM.Process).BatchFlag(tOldBatchMode)
	Quit tStatus
}

/// Helper method that uses a simple heuristic to loop over the index global supplied
/// in <var>pIndexGlobal</var> and check whether any entries include trailing zeroes.
/// By default, we only look at a thousand nodes, as the probability of encountering such a timestamp
/// is 10%, so 1000 should be more than enough entries to check.
ClassMethod indexNeedsRepair(pIndexGlobal As %String = "", pCount As %Integer = 1000) As %Boolean
{
	If (pIndexGlobal = "") || (pCount <= 0) Quit 0

	Set tNeedsRepair = 0
	Set tTS = ""
	For i=1:1:pCount {
		Set tTS = $order(@pIndexGlobal@(tTS))
		Quit:(tTS = "")
		If ("0" = $extract($piece(tTS,".",2),*)) {
			Set tNeedsRepair = 1
			Quit
		}
	}
	Quit tNeedsRepair
}

/// Convert searches saved as instances of CSPX.EnsMsgFilterForm to instances of EnsPortal.MsgFilter.SavedSearch.
ClassMethod convertCSPXSearches(pTargetNS As %String, pVerbose As %Boolean = 0) As %Status
{
	#ifndef REPORT
	#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
	#endif
	
	Set tStatus = $$$OK
	New $namespace
	Try {
		Set $namespace = pTargetNS
		Set tIndent = $select(pVerbose: 6, 1: 0)
		Set tStatus = ##class(EnsPortal.MsgFilter.SavedSearch).ConvertAllCSPXSearches(,,tIndent)
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Create the auditing events used by Ensemble.
ClassMethod CreateEnsembleAuditingEvents() As %Status
{
	Set tSC = $$$OK

	// Must be in namespace %SYS
	New $Namespace
	Set $Namespace = "%SYS"

	Try {
		// Define event: View contents of a message - enabled, system-defined, can be disabled
		Set Event = ..defineAuditViewMessageContents()
		If '(##class(Security.Events).Exists(Event)) {
			Set Descr = $$$GetMsg($$$EventsMsg, "EnsViewMsgContents")
			Set tSC = ##class(Security.Events).Create(Event, , , Descr, 1, 1)
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError, $ZE)
	}

	Try {
		// Define event: Modify Production configuration - enabled, system-defined, can be disabled
		Set Event = ..defineAuditModifyProductionConfiguration()
		If '(##class(Security.Events).Exists(Event)) {
			Set Descr = $$$GetMsg($$$EventsMsg, "EnsModifyProductionConfig")
			Set tSC = ##class(Security.Events).Create(Event, , , Descr, 1, 1)
		}
	}
	Catch {
		Set tSC = $system.Status.AppendStatus(tSC, $$$ERROR($$$CacheError, $ZE))
	}

	Try {
		// Define event: Start or stop Production - enabled, system-defined, can be disabled
		Set Event = ..defineAuditStartStopProduction()
		If '(##class(Security.Events).Exists(Event)) {
			Set Descr = $$$GetMsg($$$EventsMsg, "EnsStartStopProduction")
			Set tSC = ##class(Security.Events).Create(Event, , , Descr, 1, 1)
		}
	}
	Catch {
		Set tSC = $system.Status.AppendStatus(tSC, $$$ERROR($$$CacheError, $ZE))
	}

	Try {
		// Define event: Modify Schema - enabled, system-defined, can be disabled
		Set Event = ..defineAuditModifySchema()
		If '(##class(Security.Events).Exists(Event)) {
			Set Descr = $$$GetMsg($$$EventsMsg, "EnsModifySchema")
			Set tSC = ##class(Security.Events).Create(Event, , , Descr, 1, 1)
		}
	}
	Catch {
		Set tSC = $system.Status.AppendStatus(tSC, $$$ERROR($$$CacheError, $ZE))
	}

	Quit tSC
}

/// The defineAudit* methods below return literals with the names for the Ensemble auditing events 
/// with the format of a single string containing Source/Type/Name.
/// They return the values to be used when creating the audit events at installation/upgrade time by this class, 
/// and also to define macros by routine EnsConstants.inc in ENSLIB.
ClassMethod defineAuditModifyProductionConfiguration() As %String
{
	Quit "%Ensemble/%Production/ModifyConfiguration"
}

/// The defineAudit* methods below return literals with the names for the Ensemble auditing events 
/// with the format of a single string containing Source/Type/Name.
/// They return the values to be used when creating the audit events at installation/upgrade time by this class, 
/// and also to define macros by routine EnsConstants.inc in ENSLIB.
ClassMethod defineAuditStartStopProduction() As %String
{
	Quit "%Ensemble/%Production/StartStop"
}

/// The defineAudit* methods below return literals with the names for the Ensemble auditing events 
/// with the format of a single string containing Source/Type/Name.
/// They return the values to be used when creating the audit events at installation/upgrade time by this class, 
/// and also to define macros by routine EnsConstants.inc in ENSLIB.
ClassMethod defineAuditModifySchema() As %String
{
	Quit "%Ensemble/%Schema/Modify"
}

/// The defineAudit* methods below return literals with the names for the Ensemble auditing events 
/// with the format of a single string containing Source/Type/Name.
/// They return the values to be used when creating the audit events at installation/upgrade time by this class, 
/// and also to define macros by routine EnsConstants.inc in ENSLIB.
ClassMethod defineAuditViewMessageContents() As %String
{
	Quit "%Ensemble/%Message/ViewContents"
}

/// Method to create Ensemble Resources and Roles, in addition to
/// upgrading existing users with access to the legacy portal through the
/// %Admin_Manage resource so that they retain full access to the new portal
/// after the installation completes.
ClassMethod InstallEnsembleSecurity(pIsPrimary As %Boolean = 1, pVerbose As %Boolean = 0) As %Status
{
	#ifndef REPORT
	#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
	#endif
	Try {
	
		Set tStatus = $$$OK
		Set tNS = $namespace
		Set $namespace = "%SYS"
		
		$$$REPORT(6, "- Creating Ensemble Resources")
		// Add newline before %Installer output starts
		$$$REPORT(0,"")
		
		Set tStatus = ..CreateEnsembleResources(,pVerbose)
		If $$$ISERR(tStatus) Quit
		
		// Check whether a new resource has been assigned to any roles
		Set tStatus = ##class(Security.Resources).InUse("%Ens_ProductionRun",.tResourcesUsed)
		If $$$ISERR(tStatus) Quit
		
		Set tInstalledFlag = ..IsEnsembleInstalled()
		If 'tInstalledFlag {
			Set ^%SYS("Ensemble","InstalledNamespace","ENSEMBLE")=""
		}
		
		$$$REPORT(6, "- Creating Ensemble Roles")
		// Add newline before %Installer output starts
		$$$REPORT(0,"")
		
		Set tStatus = ..CreateEnsembleRoles(, pVerbose)
		If $$$ISERR(tStatus) Quit
		
		If 'tInstalledFlag {
			Kill ^%SYS("Ensemble","InstalledNamespace","ENSEMBLE")
		}
		If 'tResourcesUsed { // Upgrade from system without Ensemble security
			$$$REPORT(6, "- Starting Ensemble Security Upgrade")
			$$$REPORT(6, "- Adding '%EnsRole_Administrator' and '%EnsRole_Developer' roles to users with permissions on the '%Admin_Manage' resource")
			
			Set tStatus = ##class(Security.Resources).InUse("%Admin_Manage",.tInUse,.tRoles)
			If $$$ISERR(tStatus) Quit
		
			If tInUse {
				For i=1:1:$listlength(tRoles) {
					Set tRole = $listget(tRoles, i)
					Set tStatus = ..findUsersForRole(tRole, .tUsers,pVerbose)
					If $$$ISERR(tStatus) Quit
				}
				If $$$ISERR(tStatus) Quit
				Set tUsername = ""
				For {
					Set tUsername = $order(tUsers(tUsername))
					Quit:(tUsername = "")
					Kill tProperties
					Set tProperties = 1
					$$$REPORT(8, "+ Adding '%EnsRole_Administrator' and '%EnsRole_Developer' roles to user '"_tUsername_"'")
					Set tUserLow = $zcvt(tUsername,"L")
					Set tUser = ##class(Security.Users).%OpenId(tUserLow,,.tStatus)
					If $$$ISERR(tStatus) Quit
					Set tStatus = tUser.Roles.Insert("%EnsRole_Administrator")
					If $$$ISERR(tStatus) Quit
					Set tStatus = tUser.Roles.Insert("%EnsRole_Developer")
					If $$$ISERR(tStatus) Quit
					Set tStatus = tUser.%Save()
					If $$$ISERR(tStatus) Quit
				}
				If $$$ISERR(tStatus) Quit
			}
			$$$REPORT(6, "- Completed addition of '%EnsRole_Administrator' and '%EnsRole_Developer' roles to users with permissions on the '%Admin_Manage' resource")
		}
		Set $namespace = tNS
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If tNS '= $namespace {
		Set $namespace = tNS
	}
	Quit tStatus
}

/// Helper method to recursively locate all users who are assigned a role
/// directly and indirectly.
ClassMethod findUsersForRole(pRole As %String, ByRef pUsers, pVerbose As %Boolean = 0, pRoles As %List) As %String [ Internal, Private ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Try {
        Set pRoles = $G(pRoles)_$lb(pRole)		
        Set tDone = 0
		While 'tDone {
			Set tStatus = ##class(Security.Roles).InUse(pRole, .tInUse, .tUsers, .tMoreUsers, .tRoles, .tMoreRoles)
			If $$$ISERR(tStatus) Quit
			If tInUse {
				For i=1:1:$listlength(tUsers) {
					Set tUser = $listget(tUsers, i)
					If tUser '= "" Set pUsers(tUser) = ""
				}
				For i=1:1:$listlength(tRoles) {
					Set tRole = $listget(tRoles, i)
					Set foundAt = $listfind(pRoles,tRole)
					If foundAt>0 {
						Set str=tRole_" -> "_$listget(pRoles,*)
						For j=($listlength(pRoles)-1):-1:foundAt {
							Set str = str_" -> "_$listget(pRoles,j)
						}
						$$$REPORT(8,"WARNING: Circular role assignment detected. "_str)
						CONTINUE
					}
					If tRole '= "" {
						Set tStatus = ..findUsersForRole(tRole, .pUsers, pVerbose, pRoles)
						If $$$ISERR(tStatus) Quit
					}
				}
				If $$$ISERR(tStatus) Quit
				If ('tMoreUsers && 'tMoreRoles) Set tDone = 1
			}
			Else {
				Set tDone = 1
			}
		}
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Add SQL privileges on Ensemble tables to the base Ensemble Roles.
/// When possible, this should use %Installer-generated code.
ClassMethod addEnsembleSQLPrivileges(pNamespace As %String = "", pVerbose As %Boolean = 0) As %Status [ Internal ]
{
	/*	Role:						Tables:
		%EnsRole_Monitor			Ens_Util.Log
									Ens_Enterprise.MonitorClient
		%EnsRole_RulesDeveloper		Ens_Rule.RuleLog
									Ens_Rule.Log
		%EnsRole_Operator			Ens_Util.Log
									Ens_Rule.RuleLog
									Ens_Rule.Log
									Ens_Rule.DebugLog
									Ens.MessageHeader
									Ens_Config.Credentials
									Ens.BusinessProcess
									Ens.BusinessProcessBPL
									Ens_Util.Calendar
									Ens_Enterprise.MonitorClient
									Ens_Enterprise_MsgBank.MessageHeader
									Ens_Enterprise_MsgBank.Log
									Ens_Enterprise_MsgBank.Node
									Ens_Util.Schedule
									Ens_Alerting.ManagedAlert
									EnsLib_Agent.Interface
									Ens_ServiceRegistry_External.Service
									Ens_ServiceRegistry_External.Attribute
		%EnsRole_WebDeveloper
			and
		%EnsRole_Administrator
									Message Contents
										EnsLib_HL7.Message
										EnsLib_HL7.SearchTable
										EnsLib_EDI_ASTM.Document
										EnsLib_EDI_ASTM.SearchTable
										EnsLib_EDI_EDIFACT.Document
										EnsLib_EDI_EDIFACT.SearchTable
										EnsLib_EDI_X12.Document
										EnsLib_EDI_X12.SearchTable
										EnsLib_EDI_XML.Document
										EnsLib_XML.SearchTable
										Ens.MessageBody
										EnsLib_RecordMap.Batch
										EnsLib_DICOM.Document
										EnsLib_ebXML.Message
										EnsLib_ebXML.MessageWithPayload
										EnsLib_ebXML.MessageTracking
										EnsLib_Printing.PrintJob
										EnsLib_Printing.PrintRequest
										EnsLib_SQL.Snapshot
										Ens.StreamContainer
										Ens.StringContainer
									Ens_Util.IOLog
		%EnsRole_AlertOperator		Ens_Alerting.ManagedAlert
		%EnsRole_RegistrySelect		Ens_ServiceRegistry_Public.Action
									Ens_ServiceRegistry_Public.Attribute
									Ens_ServiceRegistry_Public.Contact
									Ens_ServiceRegistry_Public.FileStore
									Ens_ServiceRegistry_Public.Service
		%EnsRole_RegistryManager	Ens_ServiceRegistry_Public.Internal		
	%EnsRole_WebDeveloper and %EnsRole_Administrator are also granted EXECUTE privileges on the Ens.IsASub stored procedure to allow for SearchTable searches.
	*/
	Try {
		Set tStatus = $$$OK
		Set tInitNS = $namespace
		If pNamespace = "" Quit
		Set $namespace = "%SYS"
	
		// tExtendedSearches contains the list of tables needed to perform basic extended searches.
		// SELECT privileges are assigned to roles which may view message content.
		Set tExtendedSearches = $lb("EnsLib_HL7.Message", "EnsLib_HL7.SearchTable", "EnsLib_EDI_ASTM.Document") _
										$lb("EnsLib_EDI_ASTM.SearchTable", "EnsLib_EDI_EDIFACT.Document", "EnsLib_EDI_EDIFACT.SearchTable") _
										$lb("EnsLib_EDI_X12.Document", "EnsLib_EDI_X12.SearchTable","EnsLib_EDI_XML.Document") _
										$lb("EnsLib_XML.SearchTable", "EnsLib_EDI_XML.SearchTable", "Ens.MessageBody", "EnsLib_RecordMap.Batch") _
										$lb("EnsLib_DICOM.Document", "EnsLib_ebXML.Message", "EnsLib_ebXML.MessageWithPayload") _
										$lb("EnsLib_ebXML.MessageTracking", "EnsLib_Printing.PrintJob", "EnsLib_Printing.PrintRequest") _
										$lb("EnsLib_SQL.Snapshot", "Ens.StreamContainer", "Ens.StringContainer") _
										$lb("Ens_Util.IOLog", $lb("EnsLib_Agent.Interface",0,"u"))
		// tDeployTables contains the list of tables needed for the Deployment Changes pages
		Set tDeployTables = $lb("Ens_Deployment.Token","Ens_Deployment.Invocations")
		Set tRoles("%EnsRole_Monitor") = $lb("Ens_Util.Log", "Ens_Enterprise.MonitorClient")
		Set tRoles("%EnsRole_RulesDeveloper") = $lb("Ens_Rule.RuleLog", "Ens_Rule.Log")
		Set tRoles("%EnsRole_Operator") = $lb("Ens_Util.Log", "Ens.MessageHeader", "Ens_Config.Credentials", "Ens_Rule.RuleLog", "Ens_Rule.Log", "Ens_Rule.DebugLog") _ 
												$lb("Ens_Util.Calendar", "Ens.BusinessProcess", "Ens.BusinessProcessBPL", "Ens_Enterprise_MsgBank.MessageHeader") _
												$lb("Ens_Enterprise_MsgBank.Log", "Ens_Enterprise_MsgBank.Node", "Ens_Util.Schedule", "Ens_Enterprise.MonitorClient") _
												$lb("EnsLib_ITK_DTS_Framework.TransferLog", "EnsLib_ITK_Framework.FaultCode", "EnsLib_ITK_Framework.FaultVocabulary") _
												$lb("EnsLib_ITK_Framework.FaultVocabularyMap", "EnsLib_ITK_Setup.ConsumerServiceRegistry", "EnsLib_ITK_Setup.DistributionRules") _
												$lb("EnsLib_ITK_Setup.SenderRegistry", "EnsLib_ITK_Setup.ServiceDefinition", "EnsLib_ITK_Setup.SubscriptionRules") _
												$lb("EnsLib_ITK_Setup.SystemDefinition", "Ens_Alerting.ManagedAlert","EnsLib_Agent.Interface") _
												$lb("Ens_ServiceRegistry_External.Service","Ens_ServiceRegistry_External.Attribute")
		Set tRoles("%EnsRole_WebDeveloper") = tExtendedSearches
		Set tRoles("%EnsRole_Administrator") = tExtendedSearches_tDeployTables
		Set tRoles("%EnsRole_AlertOperator") = $lb("Ens_Alerting.ManagedAlert")
		Set tRoles("%EnsRole_RegistrySelect")=$lb("Ens_ServiceRegistry_Public.Action","Ens_ServiceRegistry_Public.Attribute","Ens_ServiceRegistry_Public.Contact","Ens_ServiceRegistry_Public.FileStore","Ens_ServiceRegistry_Public.Service")
		Set tRoles("%EnsRole_RegistryManager")=$lb($lb("Ens_ServiceRegistry_Public.Action",0,"siud"),$lb("Ens_ServiceRegistry_Public.Attribute",0,"siud"),$lb("Ens_ServiceRegistry_Public.Contact",0,"siud"),$lb("Ens_ServiceRegistry_Public.FileStore",0,"siud"),$lb("Ens_ServiceRegistry_Public.Internal",0,"siud"),$lb("Ens_ServiceRegistry_Public.Service",0,"siud"))
		// Procedures
		// tSearchProcs contains the stored procedures needed to execute SearchTable searches.
		Set tSearchProcs = $lb("Ens.IsASub")
		Set tProcedures("%EnsRole_WebDeveloper") = tSearchProcs
		Set tProcedures("%EnsRole_Administrator") = tSearchProcs
		
		Set tRole = ""
		For {
			Set tRole = $order(tRoles(tRole))
			Quit:(tRole = "")
			If '##class(Security.Roles).Exists(tRole,, .tStatus) Continue
			If $$$ISERR(tStatus) Quit
			$$$REPORT(6, "- Adding SQL privileges for role '"_tRole_"'")
			// Note that _Ensemble system user is used to grant privileges
			For i=1:1:$ll(tRoles(tRole)) {
				Set tTable = $lg(tRoles(tRole), i)
				If $ListValid(tTable) {
					Set tGrantable = +$lg(tTable, 2)
					Set tPriv = $lg(tTable, 3, "s")
					Set tTable = $lg(tTable, 1)
				}
				Else {
					Set tGrantable = 0
					Set tPriv = "s"
				}
				Set tSQLObject = "1,"_tTable
				Set tStatus = ..addSQLPrivilege(pNamespace, tSQLObject, tPriv, tRole, tGrantable)
			}
			If $$$ISERR(tStatus) Quit
			// Check for procedures
			If $data(tProcedures(tRole)) {
				Set tPriv = "e"
				For i=1:1:$ll(tProcedures(tRole)) {
					Set tProc = $lg(tProcedures(tRole),i)
					Set tSQLObject ="9,"_tProc
					Set tStatus = ..addSQLPrivilege(pNamespace, tSQLObject, tPriv, tRole)
					If $$$ISERR(tStatus) Quit
				}
				If $$$ISERR(tStatus) Quit
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $get(tInitNS) '= $namespace {
		Set $namespace = tInitNS
	}
	Quit tStatus
}

/// Helper method to add privileges to users. Note that the default behaviour is to have
/// the _Ensemble system user grant privileges, and the GRANT option is false.
ClassMethod addSQLPrivilege(pNamespace As %String, pSQLObject As %String, pPrivilege As %String, pGrantee As %String, pGrantable As %Boolean = 0, pGrantor As %String = "_Ensemble") As %Status [ Private ]
{
	Set tStatus = $$$OK
	For i=1:1:$l(pPrivilege) {
		Set tPrivilege = $e(pPrivilege,i)
		If '##class(Security.SQLPrivileges).IDKeyExists(pNamespace, pSQLObject, tPrivilege, pGrantee, pGrantor) {
			Set tSQLPriv = ##class(Security.SQLPrivileges).%New()
			Set tSQLPriv.Namespace = pNamespace
			Set tSQLPriv.SQLObject = pSQLObject
			Set tSQLPriv.Grantable = pGrantable
			Set tSQLPriv.Grantee = pGrantee
			Set tSQLPriv.Privilege = tPrivilege
			Set tSQLPriv.Grantor = pGrantor
			Set tStatus = tSQLPriv.%Save()
			If $$$ISERR(tStatus) Quit
		}
	}
	Quit tStatus
}

ClassMethod CreateEnsembleResources(ByRef pVars, pLogLevel As %Integer, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator ]
{
	Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "EnsembleResources")
}

ClassMethod CreateEnsembleRoles(ByRef pVars, pLogLevel As %Integer, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator ]
{
	Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "EnsembleRoles")
}

XData EnsembleResources [ XMLNamespace = INSTALLER ]
{
<Manifest>
		<!-- Activities - protect with USE -->
	<Resource Name="%Ens_Deploy" Description="Grants access to deployment activities" />
	<Resource Name="%Ens_DeploymentPkg" Description="Controls the construction of deployment packages" />
	<Resource Name="%Ens_TestingService" Description="Grants access to the Testing Service" />
	<Resource Name="%Ens_DTLTest" Description="Grants access to the DTL Testing utility" />
	<Resource Name="%Ens_ProductionRun" Description="Controls starting and stopping productions" />
	<Resource Name="%Ens_ConfigItemRun" Description="Controls starting and stopping configuration items" />
	<Resource Name="%Ens_MessageResend" Description="Grants access to Message Resend" />
	<Resource Name="%Ens_MessageEditResend" Description="Grants access to Message Edit and Resend" />
	<Resource Name="%Ens_MessageSuspend" Description="Controls the manual suspension of messages" />  
	<Resource Name="%Ens_MessageResubmit" Description="Controls resubmission of suspended messages" />
	<Resource Name="%Ens_MessageDiscard" Description="Controls discarding of queued and suspended messages" />
	<Resource Name="%Ens_MessageTrace" Description="Grants access to Message Trace" />
	<Resource Name="%Ens_MessageHeader" Description="Grants access to Message Header data" />
	<Resource Name="%Ens_MessageContent" Description="Grants access to the contents of messages" />
	<Resource Name="%Ens_Purge" Description="Controls purging of Ensemble data" />
	<Resource Name="%Ens_Dashboard" Description="Grants access to the Ensemble Dashboard" />
	<Resource Name="%Ens_EventLog" Description="Grants access to the Event Log" />
	<Resource Name="%Ens_RuleLog" Description="Grants access to the Rule Log" />
	<Resource Name="%Ens_ProductionDocumentation" Description="Controls the creation of production documentation" />
	<Resource Name="%Ens_Portal" Description="Grants access to the Ensemble Management Portal" />
	<Resource Name="%Ens_ViewFileSystem" Description="Grants access to the fileSelect dialog which allows the user to view the file system" />
	<Resource Name="%Ens_MsgBank_MessageHeader" Description="Grants access to Message Bank Header data" />
	<Resource Name="%Ens_MsgBank_MessageContent" Description="Grants access to the contents of messages in the Message Bank" />
	<Resource Name="%Ens_MsgBank_MessageResend" Description="Grants permission to resend messages from the Message Bank" />
	<Resource Name="%Ens_MsgBank_MessageEditResend" Description="Grants permission to edit and resend messages from the Message Bank" />
	<Resource Name="%Ens_MsgBank_MessageTrace" Description="Grants access to the Message Bank Visual Trace" />
	<Resource Name="%Ens_MsgBank_Dashboard" Description="Grants access to the Enterprise Monitor Page" />
	<Resource Name="%Ens_MsgBank_EventLog" Description="Grants access to the Message Bank Event Log" />
	<Resource Name="%Ens_AlertAdministration" Description="Grants access to administrative functions for Managed Alerts via USE" />
		<!-- Data - protect with READ, WRITE -->
	<Resource Name="%Ens_Agents" Description="Grants access to Agent browser page"/>
	<Resource Name="%Ens_Code" Description="Grants access to all Ensemble classes and routines" />
	<Resource Name="%Ens_BPL" Description="Grants access to BPL" />
	<Resource Name="%Ens_DTL" Description="Grants access to DTL" />
	<Resource Name="%Ens_Rules" Description="Grants access to all Ensemble Rules" />
	<Resource Name="%Ens_RoutingRules" Description="Grants access to Routing Rules" />
	<Resource Name="%Ens_BusinessRules" Description="Grants access to Business Rules" />
	<Resource Name="%Ens_RecordMap" Description="Grants access to Ensemble RecordMaps" />
	<Resource Name="%Ens_ProductionConfig" Description="Grants access to production configuration activities" />
	<Resource Name="%Ens_EDISchema" Description="Grants access to EDI Schemas" />
	<Resource Name="%Ens_EDISchemaAnnotations" Description="Grants access to EDI Schema Annotations" />
	<Resource Name="%Ens_Queues" Description="Grants access to Queue data" />
	<Resource Name="%Ens_Jobs" Description="Grants access to Job data" />
	<Resource Name="%Ens_PurgeSchedule" Description="Grants access to scheduling of Ensemble purge tasks" />
	<Resource Name="%Ens_SystemDefaultConfig" Description="Grants access to System Default settings" />
	<Resource Name="%Ens_Credentials" Description="Grants access to Ensemble Credentials" />
	<Resource Name="%Ens_ArchiveManager" Description="Grants access to the Archive Manager" />
	<Resource Name="%Ens_LookupTables" Description="Grants access to Lookup Tables" />
	<Resource Name="%Ens_SequenceManager" Description="Grants access to the Sequence Manager" />
	<Resource Name="%Ens_MsgBankConfig" Description="Grants access to Message Bank configuration" />
	<Resource Name="%Ens_MsgBank" Description="Grants access to Message Bank status information" />
	<Resource Name="%Ens_WorkflowConfig" Description="Grants access to Workflow roles and users" />
	<Resource Name="%Ens_Alerts" Description="Grants access to view and edit Managed Alerts" />
	<Resource Name="%Ens_ITK" Description="Grants access to the ITK" />
	<Resource Name="%Ens_PubSub" Description="Grants access to the Ensemble PubSub management pages" />
</Manifest>
}

XData EnsembleRoles [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<!-- Roles -->
	<!-- %EnsRole_Operator -->
	<Var Name="CurrentRole" Value="%EnsRole_Operator" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists." />
	<!-- Add Ens_ITK READ to %EnsRole_Operator -->
	<Var Name="CheckResources" Value="%Ens_ITK:R" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_Alerts WRITE to %EnsRole_Operator -->
	<Var Name="CheckResources" Value="%Ens_Alerts:W" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_Agents READ to %EnsRole_Operator -->
	<Var Name="CheckResources" Value="%Ens_Agents:R" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_Operator" 
		Description="Ensemble Operator" 
		Resources="%Ens_Portal:U,%Ens_ProductionRun:U,%Ens_ConfigItemRun:U,%Ens_MessageResend:U,%Ens_Dashboard:U,%Ens_ProductionConfig:R,%Ens_EventLog:U,%Ens_RuleLog:U,%Ens_MessageTrace:U,%Ens_MessageHeader:U,%Ens_Queues:R,%Ens_Jobs:R,%Ens_PurgeSchedule:R,%Ens_SystemDefaultConfig:R,%Ens_Credentials:R,%Ens_LookupTables:R,%Ens_MsgBank:R,%Ens_WorkflowConfig:R,%Ens_Alerts:RW,%Ens_MsgBank_MessageHeader:U,%Ens_MsgBank_MessageResend:U,%Ens_MsgBank_MessageTrace:U,%Ens_MsgBank_Dashboard:U,%Ens_MsgBank_EventLog:U,%Ens_ITK:R,%Ens_Agents:R"
	/>
	</If>
	<!-- %EnsRole_RuleDeveloper -->
	<Var Name="CurrentRole" Value="%EnsRole_RulesDeveloper" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_RulesDeveloper"
		Description="Ensemble Rules Developer"
		Resources="%Ens_Portal:U,%Ens_Rules:RW,%Ens_RuleLog:U" 
	/>
	</If>
	<!-- %EnsRole_WebDeveloper -->
	<Var Name="CurrentRole" Value="%EnsRole_WebDeveloper" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists." />
	<!-- Add Ens_ITK WRITE to %EnsRole_WebDeveloper -->
	<Var Name="CheckResources" Value="%Ens_ITK:W" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_EDISchemaAnnotations READ and WRITE to %EnsRole_WebDeveloper -->
	<Var Name="CheckResources" Value="%Ens_EDISchemaAnnotations:RW" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_PubSub READ and WRITE to %EnsRole_WebDeveloper -->
	<Var Name="CheckResources" Value="%Ens_PubSub:RW" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_WebDeveloper"
		Description="Ensemble Web Developer" 
		RolesGranted="%EnsRole_Operator,%EnsRole_RulesDeveloper,%DB_ENSLIB"
		Resources="%Ens_DeploymentPkg:U,%Ens_TestingService:U,%Ens_DTLTest:U,%Ens_MessageEditResend:U,%Ens_MessageSuspend:U,%Ens_MessageResubmit:U,%Ens_MessageDiscard:U,%Ens_MessageContent:U,%Ens_Purge:U,%Ens_ProductionDocumentation:U,%Ens_Code:RW,%Ens_ProductionConfig:W,%Ens_EDISchema:RW,%Ens_EDISchemaAnnotations:RW,%Ens_Queues:W,%Ens_Jobs:W,%Ens_LookupTables:W,%Ens_SequenceManager:RW,%Ens_MsgBankConfig:RW,%Ens_WorkflowConfig:W,%Ens_Alerts:W,%Ens_MsgBank_MessageEditResend:U,%Ens_MsgBank_MessageContent:U,%Ens_ViewFileSystem:U,%Ens_ITK:W,%Ens_PubSub:RW"
	/>
	</If>
	<!-- %EnsRole_Developer -->
	<Var Name="CurrentRole" Value="%EnsRole_Developer" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_Developer" 
		Description="Ensemble Developer" 
		RolesGranted="%Developer,%EnsRole_WebDeveloper"
	/>
	</If>
	<!-- %EnsRole_Administrator -->
	<Var Name="CurrentRole" Value="%EnsRole_Administrator" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists." />
	<!-- Add %Ens_ITK WRITE to %EnsRole_Administrator -->
	<Var Name="CheckResources" Value="%Ens_ITK:W" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_EDISchemaAnnotations READ to %EnsRole_Administrator -->
	<Var Name="CheckResources" Value="%Ens_EDISchemaAnnotations:R" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_PubSub READ to %EnsRole_Administrator -->
	<Var Name="CheckResources" Value="%Ens_PubSub:R" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_AlertAdministration USE to %EnsRole_Administrator -->
	<Var Name="CheckResources" Value="%Ens_AlertAdministration:U" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	<!-- Add %Ens_Agents WRITE to %EnsRole_Administrator -->
	<Var Name="CheckResources" Value="%Ens_Agents:W" />
	<Invoke Class="%Library.EnsembleMgr" Method="addResourcesToRole" Return="AddResourcesReturn">
	<Arg Value="${CurrentRole}" />
	<Arg Value="${CheckResources}" />
	</Invoke>
	<Var Name="ErrorMessage" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),1)}" />
	<Var Name="ResourcesAdded" Value="#{$piece(&quot;${AddResourcesReturn}&quot;,$char(0),2)}" />
	<If Condition="&quot;${ErrorMessage}&quot; '= &quot;&quot;">
	<Log Level="0" Text="Error updating role '${CurrentRole}'; failed to add resources '${ResourcesAdded}' due to error: ${ErrorMessage}" />
	</If>
	<If Condition="#{(&quot;${ErrorMessage}&quot; = &quot;&quot;) &amp;&amp; (&quot;${ResourcesAdded}&quot; '= &quot;&quot;)}">
	<Log Level="0" Text="Added resource '${ResourcesAdded}' to role '${CurrentRole}'." />
	</If>
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_Administrator"
		Description="Ensemble Administrator"
		RolesGranted="%EnsRole_Operator,%DB_ENSLIB"
		Resources="%Ens_DeploymentPkg:U,%Ens_Deploy:U,%Ens_TestingService:U,%Ens_DTLTest:U,%Ens_MessageEditResend:U,%Ens_MessageSuspend:U,%Ens_MessageResubmit:U,%Ens_MessageDiscard:U,%Ens_MessageContent:U,%Ens_Purge:U,%Ens_ProductionDocumentation:U,%Ens_Code:R,%Ens_ProductionConfig:W,%Ens_EDISchema:R,%Ens_EDISchemaAnnotations:R,%Ens_Queues:W,%Ens_Jobs:W,%Ens_PurgeSchedule:W,%Ens_SystemDefaultConfig:W,%Ens_Credentials:W,%Ens_ArchiveManager:RW,%Ens_LookupTables:W,%Ens_SequenceManager:RW,%Ens_MsgBankConfig:RW,%Ens_MsgBank:W,%Ens_WorkflowConfig:W,%Ens_Alerts:W,%Ens_MsgBank_MessageEditResend:U,%Ens_MsgBank_MessageContent:U,%Ens_ViewFileSystem:U,%Ens_ITK:W,%Ens_PubSub:R,%Ens_AlertAdministration:U,%Ens_Agents:W"
	/>
	</If>
	<!-- %EnsRole_Monitor -->
	<Var Name="CurrentRole" Value="%EnsRole_Monitor" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_Monitor"
		Description="Ensemble Monitor"
		Resources="%Ens_Portal:U,%Ens_Dashboard:U,%Ens_MsgBank_Dashboard:U"
	/>
	</If>
	<!-- %EnsRole_PubSubDeveloper -->
	<Var Name="CurrentRole" Value="%EnsRole_PubSubDeveloper" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_PubSubDeveloper"
		Description="Ensemble PubSub Developer"
		Resources="%Ens_Portal:U,%Ens_PubSub:RW" 
	/>
	</If>
	<!-- %EnsRole_AlertOperator -->
	<Var Name="CurrentRole" Value="%EnsRole_AlertOperator" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_AlertOperator"
		Description="Ensemble user with Alert access"
		Resources="%Ens_Portal:U,%Ens_Alerts:RW" 
	/>
	</If>
	<!-- %EnsRole_AlertAdministrator -->
	<Var Name="CurrentRole" Value="%EnsRole_AlertAdministrator" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_AlertAdministrator"
		Description="Ensemble user with administrative Alert access"
		Resources="%Ens_AlertAdministration:U"
		RolesGranted="%EnsRole_AlertOperator"
	/>
	</If>
	<!-- Public Registry Roles -->
	<Var Name="CurrentRole" Value="%EnsRole_RegistryManager" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_RegistryManager"
		Description="Administrator of the Public Registry"
	/>
	</If>
	<Var Name="CurrentRole" Value="%EnsRole_RegistrySelect" />
	<Invoke Class="Security.Roles" Method="Exists" Return="RoleExists">
	<Arg Value="${CurrentRole}" />
	</Invoke>
	<If Condition="${RoleExists}">
	<Log Level="0" Text="Role '${CurrentRole}' already exists; not updating." />
	</If>
	<If Condition="'${RoleExists}">
	<Role Name="%EnsRole_RegistrySelect"
		Description="Role for viewing Public Registry tables"
	/>
	</If>
</Manifest>
}

/// Helper method to check whether <var>pRole</var> already has the resource/permission pairs
/// in <var>pResources</var>, and adds them if not. Note that <var>pResources</var> should have the following format:
/// [Resource]:[Permissions]. Multiple pairs should be separated by commas.
/// The return value is in the format: [Error Message]_$char(0)_[Resources Added]
ClassMethod addResourcesToRole(pRole As %String = "", pResources As %String = "", Output pStatus As %Status) As %String [ Private ]
{
	Set pStatus = $$$OK
	Set tResourcesAdded = pResources
	Set tErrorMessage = ""
	Try {
		If (pRole = "") || '##class(Security.Roles).Exists(pRole,.tRoleObj,.pStatus) {
			Quit
		}
		Set pStatus = ..getExistingResources(pRole,.tExistingResources)
		If $$$ISERR(pStatus) Quit
		Merge tNewResources = tExistingResources
		Set tAddList = ""
		For i=$length(pResources,","):-1:1 {
			Set tPair = $piece(pResources,",",i)
			Set tResource = $piece(tPair,":",1)
			If (tResource = "") || '##class(Security.Resources).Exists(tResource,,.pStatus) {
				If $$$ISERR(pStatus) Quit
				Continue
			}
			Set tPermission = $piece(tPair,":",2)
			Set tPermissionExists = $data(tExistingResources(tResource),tOldPermissions)#2
			If tPermissionExists && (tOldPermissions '= "") && (tPermission = tOldPermissions) {
				Continue
			}

			Set tPermissionsInt = ##class(Security.Datatype.Permission).ExternalToInternal(tPermission) 
			If 'tPermissionsInt {
				Continue
			}
			If (tPermissionExists) {
				Set tOldPermissionsInt = ##class(Security.Datatype.Permission).ExternalToInternal(tOldPermissions)
				Set tNewPermissionsInt = $zboolean(tPermissionsInt,tOldPermissionsInt,7)
				If tNewPermissionsInt '= tOldPermissionsInt {
					Set tNewResources(tResource) =  ##class(Security.Datatype.Permission).InternalToExternal(tNewPermissionsInt)
					Set tAddList = tAddList _ $lb(tResource_":"_##class(Security.Datatype.Permission).InternalToExternal($zboolean(tPermissionsInt,tOldPermissionsInt,2)))
				}
			}
			Else {
				Set tNewResources(tResource) = tPermission
				Set tAddList = tAddList _ $lb(tPair)
			}
		}
		If $$$ISERR(pStatus) Quit
		If ($listlength(tAddList) = 0) {
			Set tResourcesAdded = ""
		}
		Else {
			Set tResourcesAdded = $listtostring(tAddList)
			Set tNewResString = ""
			Set tRes = ""
			For {
				Set tRes = $order(tNewResources(tRes),1,tPerm)
				Quit:(tRes = "")
				Set tNewResString = tNewResString _ "," _ tRes _ ":" _ tPerm
			}
			Set tProps("Resources") = $extract(tNewResString,2,*)
			Set pStatus = ##class(Security.Roles).Modify(pRole,.tProps)
		}
	}
	Catch ex {
		Set pStatus = ex.AsStatus()
	}
	If $$$ISERR(pStatus) {
		Set tErrorMessage = $system.Status.GetErrorText(pStatus)
	}
	Quit tErrorMessage _ $char(0) _ tResourcesAdded
}

/// Helper method to get the resources and permissions assigned to the role specified in <var>pRole</var>.
ClassMethod getExistingResources(pRole As %String = "", Output pExistingResources) As %Status [ Private ]
{
	Set tStatus = $$$OK
	Kill pExistingResources
	Try {
		If (pRole = "") || '##class(Security.Roles).Exists(pRole) Quit
		Set tRS = ##class(%Library.ResultSet).%New("Security.Roles:ListResources")
		Set tStatus = tRS.Execute(pRole)
		If $$$ISERR(tStatus) Quit
		While tRS.Next() {
			If (tRS.Get("Name") = pRole) {
				Set tResource = tRS.Get("Resource")
				Set tPermission = tRS.Get("Permission")
				If (tResource '= "") && (tPermission '= "") {
					Set pExistingResources(tResource) = tPermission
				}
			}
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Set configuration flags in namespace pTargetNS,<br>
/// pVerbose report <br>
/// pFlagsSet is an array returned with flags set or it can be passed in to say which flags to set.<br>
/// This is called when a new namespace is made. Flags that need to be set during upgrade are set in UpgradeNamespace()<br>
ClassMethod setConfigFlags(ByRef pFlagsSet As %String, pTargetNS As %String = "", pVerbose As %Boolean = 0) As %Status [ Internal ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Set tSC = $$$OK
	Try {
		If (pTargetNS '="") {
			New $namespace
			Set $namespace = pTargetNS
		}
		If $D(pFlagsSet) {
			$$$REPORT(4,"* Setting flags from information passed in")
		} Else {
			#; Set upgrade related flags in UpgradeNamespace
			$$$REPORT(4,"* Setting new namespace flags")
			/* 
				It may be that this is a new namespace but its a mirror and has become the primary after previous primary set
			*/
			If $D(^Ens.Config("SyncCommit")) {
				$$$REPORT(4,"- Ens.Config SyncCommit already exists")
			} Else {
				$$$REPORT(4,"- Enabling SyncCommit for Business Services")
		 		Set pFlagsSet("SyncCommit")=1
			}
		}
		Merge ^Ens.Config = pFlagsSet
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Creates new database and maps ^Ens.SecondaryData* to it.
ClassMethod CreateNewDBForSecondary(pNamespace As %String = "", pVerbose As %Boolean = 0, pCheckValidNSP As %Boolean = 1) As %Status [ Internal ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Set tSC = $$$OK
	Set tGbl="Ens.SecondaryData*"
	
	$$$REPORT(4,"* Examining if secondary global mapping already configured")
	If '$$$IOwnAllRole {
		Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation) 
		If $$$ISERR(tSC) {$$$REPORT(4,$system.Status.GetErrorText(tSC)) Quit tSC}
	}
	If pCheckValidNSP,'..validateNamespace(.pNamespace,1,.tSC) {$$$REPORT(4,$system.Status.GetErrorText(tSC)) Quit tSC}
	Try {
		New $NAMESPACE
		Set $NAMESPACE=pNamespace
		Set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.tState)
		If $$$ISOK(tSC) {
			If (tState'=2),(tState'=3),(tState'=5),(tState>0) { /* If tState is <0 then mirror backup */
				Set tText="Cannot examine and change secondary global mapping for namespace '"_pNamespace_"' when production "_tProductionName_" is not stopped or suspended."
				$$$REPORT(6,"- "_tText)
				Set tSC = $$$ERROR($$$GeneralError,tText)
				Quit
			}
		} Else { 
			Quit
		}
		Set $NAMESPACE="%SYS"

/// Check if global already mapped and target database already exists, 

		If ##Class(Config.MapGlobals).Exists(pNamespace,tGbl) {
			$$$REPORT(6,"- Mapping for Seconday Data already exists")
			$$$REPORT(6,"- Not changing")
			Set tSC = $$$OK
			Quit
		} Else {
			$$$REPORT(6,"- Creating Seconday Data location")
		}
		
		If '##Class(Config.Namespaces).Exists(pNamespace,.tNamespaceObj) {
			Set tText = "- Failed to open Namespace definition "_pNamespace
			Set tSC = $$$ERROR($$$GeneralError,tText)
			$$$REPORT(6,tText)
			Quit
		}

		If '##Class(Config.Databases).Exists(tNamespaceObj.Globals,.tGlobalsObj) {
			Set tText = "Failed to access configuration for "_tNamespaceObj.Globals
			$$$REPORT(6,"- "_tText)
			Set tSC = $$$ERROR($$$GeneralError,tText)
			Quit
		}
		Set tGlobalsdbOBJ = ##class(SYS.Database).%OpenId(tGlobalsObj.Directory)
		Set tTargetDBName = tNamespaceObj.Globals_..#SECONDARYSUFFIX
		If tGlobalsdbOBJ.Mirrored {
			Set tTargetMirrorDBName = tGlobalsdbOBJ.MirrorDBName_..#SECONDARYSUFFIX
			Set tTargetMirrorSetName = tGlobalsdbOBJ.MirrorSetName
		} Else {
			Set tTargetMirrorDBName = ""
			Set tTargetMirrorSetName = ""			
		}
		Set tGlobalsdbOBJ = ""
		Set tEndFailureMessage="- Failed to setup Secondary Data mapping for namespace "_pNamespace_" to "_tTargetDBName

/// If database already defined then accept as OK and proceed to mapping else create

		If ##Class(Config.Databases).Exists(tTargetDBName,.tTargetDBOBJ) {
			Set tTargetDirectory = tTargetDBOBJ.Directory
			Set tText = "Will use existing Secondary Data database "_tTargetDBName_" using directory "_tTargetDirectory
			$$$REPORT(6,"- "_tText)
		} Else {
			Set tTargetDirectory=##class(%Library.File).SubDirectoryName(tGlobalsObj.Directory, $ZCVT(tTargetDBName,"L"), 1)
			If '##class(%File).DirectoryExists(tTargetDirectory) {
				$$$REPORT(6,"- Creating directory for new Secondary database "_tTargetDirectory)
				If '##class(%File).CreateDirectory(tTargetDirectory) {
					Set tText = "Failed to create directory "_tTargetDirectory
					$$$REPORT(6,"- "_tText)
					$$$REPORT(6,tEndFailureMessage)
					Set tSC = $$$ERROR($$$GeneralError,tText)
					Quit
				}
			}
			
/// If Database file already exist use it
			
			If ##class(%File).Exists(tTargetDirectory_"CACHE.DAT") {
				Set tText = "CACHE.DAT already exists in "_tTargetDirectory
				$$$REPORT(6,"- "_tText)
				Set tSC = ##class(SYS.Database).MountDatabase(tTargetDirectory)
				Set:($P($SYSTEM.Status.GetErrorCodes(tSC),",")=$$$ERRORCODE($$$AlreadyMounted)) tSC=$$$OK
				If $$$ISERR(tSC) {
					$$$REPORT(6,"- Failed to mount existing database for Secondary Data database "_tTargetDirectory)
					$$$REPORT(6,tEndFailureMessage)
					Quit
				}
			} Else {

/// Create the database

				$$$REPORT(6,"- Creating database for new Secondary Data database "_tTargetDirectory)
				If (tTargetMirrorDBName'="") {
					Set tText = "Will mark Secondary Data database "_tTargetDBName_" as mirrored with name "_tTargetMirrorDBName_" in mirror set "_tTargetMirrorSetName
					$$$REPORT(6,"- "_tText)
				}
				Set tSC = ##class(SYS.Database).CreateDatabase(tTargetDirectory,,,,,,tTargetMirrorDBName,tTargetMirrorSetName)
				If $$$ISERR(tSC) {
					$$$REPORT(6,"- Failed to create database for new Secondary Data database "_tTargetDirectory)
					$$$REPORT(6,tEndFailureMessage)
					Quit
				}
			}
			Set p("Directory")=tTargetDirectory
			Set tSC=##Class(Config.Databases).Create(tTargetDBName,.p)
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- Failed to set configuration file for database "_tTargetDirectory)
				$$$REPORT(6,tEndFailureMessage)
				Quit		
			}
		}

/// Create/Assign resource here since DB definition may already exist if not mirrored or mirrored and primary

		If (tTargetMirrorDBName="")||($system.Mirror.IsMember()&&$system.Mirror.IsPrimary()) {
			Set tDBPermissions = ""
			Set tSC = ..assignResourceToDB("%DB_"_tTargetDBName,tTargetDirectory,tDBPermissions)
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- Failed to assign resource "_"%DB_"_tTargetDBName_" to database "_tTargetDBName)
				$$$REPORT(6,tEndFailureMessage)
				Quit		
			} Else {
				$$$REPORT(6,"- Assigned resource "_"%DB_"_tTargetDBName_" to database "_tTargetDBName)
			}
			
/// Before creating the mapping see if any data in the globals covered by tGbl pattern and move over to new DB. Only if not mirrored or if primary
			
			Set tStatement = ##class(%SQL.Statement).%New(2)
	 		Set tSC = tStatement.%PrepareClassQuery("%SYS.GlobalQuery","NameSpaceList")
	 		If $$$ISERR(tSC) {
				$$$REPORT(6,"- Failed to run query to look for globals "_tGbl_" to move: "_$system.Status.GetErrorText(tSC))
				$$$REPORT(6,tEndFailureMessage)
				Quit		
			}

	 		Set tRSet = tStatement.%Execute(pNamespace,tGbl), tGblsToMoveAsString = ""
			While tRSet.%Next() {
				Set:'$D(tDefaultGlobalDirectory) tDefaultGlobalDirectory = ##class(%SYS.Namespace).GetGlobalDest(pNamespace)
				Set tOneGblToMove = tRSet.%Get("Name")
				If (tDefaultGlobalDirectory'=##class(%SYS.Namespace).GetGlobalDest(pNamespace,"^"_tOneGblToMove)) {
					Set tText = tOneGblToMove_" not in default globals database and not moving."
					Set tSC = $$$ERROR($$$GeneralError,tText)
				} Else {
					Set:($L(tGblsToMoveAsString)<30000) tGblsToMoveAsString = tGblsToMoveAsString_tOneGblToMove_" "
				}
				Set tMoveToGbl = "^|"_$C(34)_"^^"_tTargetDirectory_$C(34)_"|"_tOneGblToMove
				Set tGblToMove = "^|"_$C(34)_pNamespace_$C(34)_"|"_tOneGblToMove
				Set tSC = $$$OK
				Try {
					Set tLevel = $TLEVEL
					TSTART
						Merge @tMoveToGbl = @tGblToMove
						Kill @tGblToMove
					TCOMMIT
					$$$REPORT(6,"- Moved global "_tRSet.%Get("Name")_" to new database "_tTargetDirectory_" so that it will be accessible after the mapping change.")
				} Catch e { 
					If ($TLEVEL '= tLevel) TROLLBACK
					Set tSC = e.AsStatus()
				}
				Quit:$$$ISERR(tSC)
			}
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- Failed to move global(s) matching "_tGbl_" : "_$system.Status.GetErrorText(tSC))
				$$$REPORT(6,tEndFailureMessage)
				Quit
			}
		}
		
/// Make overall mapping

		Kill p
		Set p("Database")=tTargetDBName
		Set tSC = ##Class(Config.MapGlobals).Create(pNamespace,tGbl,.p,,$$$CPFSave)
		If $$$ISERR(tSC) {
			$$$REPORT(6,"- ERROR: Failed to create global mapping "_tGbl_": "_$system.Status.GetErrorText(tSC))
			$$$REPORT(6,"- Failed to create global mapping "_tGbl_": "_$system.Status.GetErrorText(tSC)_" to database "_tTargetDBName_" in namespace "_pNamespace)
			$$$REPORT(6,tEndFailureMessage)
			Quit		
		} Else {
			$$$REPORT(6,"- Created global mapping "_tGbl_" for namespace "_pNamespace)
			Set tSC=..UpdateAndReloadCPF(pVerbose,pNamespace)
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- ERROR: Failed to actiavte CPF change: "_$system.Status.GetErrorText(tSC))
				$$$REPORT(6,tEndFailureMessage)
				Quit
			}
			$$$REPORT(6,"- Activated CPF change")
		}
	} Catch e {Set tSC=e.AsStatus()}
	Quit tSC
}

/// Creates new non journalled database and maps ^CacheTemp.Ens* to it
ClassMethod createNewDBForEnsTemp(pNamespace As %String = "", pVerbose As %Boolean = 0) As %Status [ Internal ]
{
#ifndef REPORT
#define REPORT(%l,%x) Write:pVerbose !,?%l,%x
#endif
	Set tSC = $$$OK
	Quit:(pNamespace="") tSC
	#;The public ones are preferences that use PUBLIC R/W of CACHETEMP and mapped before new catchall
	Set tGblsPublic("CacheTemp.EnsPortal*")=""
	Set tGblsPublic("CacheTemp.EnsHostTotals")=""
	#;Added for future use:
	Set tGblsPublic("CacheTemp.EnsPublic*")=""
	#;Data mapped to new Temporary database
	Set tGbl="CacheTemp.Ens*"
	$$$REPORT(4,"* Examining if Ensemble temporary global mapping already configured")
	If '$$$IOwnAllRole {
		Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation) 
		If $$$ISERR(tSC) {$$$REPORT(4,$system.Status.GetErrorText(tSC)) Quit tSC}
	}
	Try {
		New $NAMESPACE
		Set $NAMESPACE=pNamespace				
		Set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.tState)
		If $$$ISOK(tSC) {
			If (tState'=2),(tState'=3),(tState'=5),(tState>0) { /* If tState is <0 then mirror backup */
				Set tText="Cannot examine and change Ensemble temporary global mapping for namespace '"_pNamespace_"' when production "_tProductionName_" is not stopped or suspended."
				$$$REPORT(6,"- "_tText)
				Set tSC = $$$ERROR($$$GeneralError,tText)
				Quit
			}
		} Else { 
			Quit
		}
		Set $NAMESPACE="%SYS"

/// Check if temporary global database is not CACHETEMP, globals already mapped and target database already exists

		If '##Class(Config.Namespaces).Exists(pNamespace,.tNamespaceObj) {
			Set tText = "- Failed to open Namespace definition "_pNamespace
			Set tSC = $$$ERROR($$$GeneralError,tText)
			$$$REPORT(6,tText)
			Quit
		}
		
		If tNamespaceObj.TempGlobals'="CACHETEMP" {
			$$$REPORT(6,"- Temporary Global location is: "_tNamespaceObj.TempGlobals)
			$$$REPORT(6,"- Not changing")
			Set tSC = $$$OK
			Quit
		}		
		Set tGblPublic = $O(tGblsPublic("")), tAlreadyMapped = 0
		While tGblPublic '= "" {
			If ##Class(Config.MapGlobals).Exists(pNamespace,tGblPublic) {
				$$$REPORT(6,"- Mapping for Ensemble temporary Data already exists"_ " - "_tGblPublic)
				$$$REPORT(6,"- Not changing")
				Set tSC = $$$OK, tAlreadyMapped = 1
				Quit
			}
			Set tGblPublic = $O(tGblsPublic(tGblPublic))
		}
		Quit:tAlreadyMapped
		If ##Class(Config.MapGlobals).Exists(pNamespace,tGbl) {
			$$$REPORT(6,"- Mapping for Ensemble temporary Data already exists")
			$$$REPORT(6,"- Not changing")
			Set tSC = $$$OK
			Quit
		} Else {
			$$$REPORT(6,"- Creating Ensemble temporary Data location")
		}

		If '##Class(Config.Databases).Exists(tNamespaceObj.Globals,.tGlobalsObj) {
			Set tText = "Failed to access configuration for "_tNamespaceObj.Globals
			$$$REPORT(6,"- "_tText)
			Set tSC = $$$ERROR($$$GeneralError,tText)
			Quit
		}
		Set tGlobalsdbOBJ = ##class(SYS.Database).%OpenId(tGlobalsObj.Directory)
		Set tTargetDBName = tNamespaceObj.Globals_..#TEMPSUFFIX
		Set tTargetResourceName=tGlobalsdbOBJ.ResourceName
		Set tGlobalsdbOBJ = ""
		Set tEndFailureMessage="- Failed to setup Ensemble temporary Data mapping for namespace "_pNamespace_" to "_tTargetDBName
		
/// If database already defined then accept as OK and proceed to mapping else create

		If ##Class(Config.Databases).Exists(tTargetDBName,.tTargetDBOBJ) {
			Set tTargetDirectory = tTargetDBOBJ.Directory
			Set tText = "New Ensemble temporary database already exists "_tTargetDBName_" using directory "_tTargetDirectory
			$$$REPORT(6,"- "_tText)
		} Else {
			Set tTargetDirectory=##class(%Library.File).SubDirectoryName(tGlobalsObj.Directory, $ZCVT(tTargetDBName,"L"), 1)
			If '##class(%File).DirectoryExists(tTargetDirectory) {
				$$$REPORT(6,"- Creating directory for new Ensemble temporary database "_tTargetDirectory)
				If '##class(%File).CreateDirectory(tTargetDirectory) {
					Set tText = "Failed to create directory "_tTargetDirectory
					$$$REPORT(6,"- "_tText)
					$$$REPORT(6,tEndFailureMessage)
					Set tSC = $$$ERROR($$$GeneralError,tText)
					Quit	
				}
			}

/// If Database file already exist use it

			If ##class(%File).Exists(tTargetDirectory_"CACHE.DAT") {
				Set tText = "CACHE.DAT already exists in "_tTargetDirectory
				$$$REPORT(6,"- "_tText)
				Set tSC = ##class(SYS.Database).MountDatabase(tTargetDirectory)
				Set:($P($SYSTEM.Status.GetErrorCodes(tSC),",")=$$$ERRORCODE($$$AlreadyMounted)) tSC=$$$OK
				If $$$ISERR(tSC) {
					$$$REPORT(6,"- Failed to mount existing database for Temporary Data database "_tTargetDirectory)
					$$$REPORT(6,tEndFailureMessage)
					Quit
				}
				Set tSC = $$$OK
			} Else {

/// Create the database non journalled and assign resource the same as the default global database.

				$$$REPORT(6,"- Creating database for new Ensemble Temporary Data database "_tTargetDirectory_". Protected by resource "_tTargetResourceName)
				Set tSC = ##class(SYS.Database).CreateDatabase(tTargetDirectory,,,,tTargetResourceName,2)
				If $$$ISERR(tSC) {
					$$$REPORT(6,"- Failed to create database for new Ensemble temporary database "_tTargetDirectory)
					$$$REPORT(6,tEndFailureMessage)
					Quit
				}
			}
			Set p("Directory")=tTargetDirectory
			Set tSC=##Class(Config.Databases).Create(tTargetDBName,.p)
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- Failed to set configuration file for database "_tTargetDirectory)
				$$$REPORT(6,tEndFailureMessage)
				Quit		
			}
		}
/// Make overall mapping. Keep Public in CACHETEMP first
		Kill p
		Set p("Database")="CACHETEMP"
		Set tGblPublic = $O(tGblsPublic("")), tMapError = 0
		While tGblPublic '= "" {
			Set tSC = ##Class(Config.MapGlobals).Create(pNamespace,tGblPublic,.p,,$$$CPFSave)
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- ERROR: Failed to create global mapping "_tGblPublic_": "_$system.Status.GetErrorText(tSC))
				$$$REPORT(6,"- Failed to create global mapping "_tGblPublic_": "_$system.Status.GetErrorText(tSC)_" to database "_tTargetDBName_" in namespace "_pNamespace)
				$$$REPORT(6,tEndFailureMessage)
				Set tMapError = 1
				Quit
			} Else {
				$$$REPORT(6,"- Created global mapping "_tGblPublic_" for namespace "_pNamespace_" to remain in CACHETEMP")
			}
			Set tGblPublic = $O(tGblsPublic(tGblPublic))
		}
		Quit:tMapError
		If tSC {
			Set p("Database")=tTargetDBName
			Set tSC = ##Class(Config.MapGlobals).Create(pNamespace,tGbl,.p,,$$$CPFSave)	
		}
		If $$$ISERR(tSC) {
			$$$REPORT(6,"- ERROR: Failed to create global mapping "_tGbl_": "_$system.Status.GetErrorText(tSC))
			$$$REPORT(6,"- Failed to create global mapping "_tGbl_": "_$system.Status.GetErrorText(tSC)_" to database "_tTargetDBName_" in namespace "_pNamespace)
			$$$REPORT(6,tEndFailureMessage)
			Quit		
		} Else {
			$$$REPORT(6,"- Created global mapping "_tGbl_" for namespace "_pNamespace_" to new temporary database")
			Set tSC=..UpdateAndReloadCPF(pVerbose,pNamespace)
			If $$$ISERR(tSC) {
				$$$REPORT(6,"- ERROR: Failed to actiavte CPF change: "_$system.Status.GetErrorText(tSC))
				$$$REPORT(6,tEndFailureMessage)
				Quit
			}
			$$$REPORT(6,"- Activated CPF change")
		}
	} Catch e {Set tSC=e.AsStatus()}
	Quit tSC
}

/// Helper method to populate pIsPrimary.<br>
/// <li> pIsPrimary can be an array and will be calculated if not passed in</li>
/// Top node is whether this is a primary node or not. It is true if not in a mirror.<br/>
/// Subscripts are namespaces that have one or more mirrored databases.<br/>
ClassMethod populateIsPrimary(ByRef pIsPrimary) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tIsMirrorMember = $system.Mirror.IsMember()
		/* Calculate if top node not set */
		If (($D(pIsPrimary)#10)=0) {
			Set pIsPrimary = $S(tIsMirrorMember:$system.Mirror.IsPrimary(),1:1)
		}
		If tIsMirrorMember,'pIsPrimary,($D(pIsPrimary)=1) {
			Set tSC = ..findMirroredNamespaces(.tMirNamespaces)
			If $$$ISOK(tSC) {
				Merge pIsPrimary("MirrorNS") = tMirNamespaces
		 	}
		}
	} Catch err {
		Set tSC = err.AsStatus()	
	}	
	Quit tSC
}

ClassMethod moveToFromInstallTemp(pDirection As %String = "To", pNSP As %String = "", pGlbName As %String = "", Output pDataMoved As %Boolean = 0) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		If pNSP '= $NAMESPACE {
			New $NAMESPACE
			Set $NAMESPACE = pNSP
		}
		If pDirection = "To" {
			If $D(@pGlbName) {
				Set pDataMoved = 1
				Merge ^CacheTemp.EnsInstallTemp("%EnsembleMgr",pGlbName) = @pGlbName
				Kill @pGlbName
			}
		} ElseIf pDirection = "From" {
			If $D(^CacheTemp.EnsInstallTemp("%EnsembleMgr",pGlbName)) {
				Merge @pGlbName = ^CacheTemp.EnsInstallTemp("%EnsembleMgr",pGlbName)
				Kill ^CacheTemp.EnsInstallTemp("%EnsembleMgr",pGlbName)
			}
		}
	} Catch err {
		Set tSC = err.AsStatus()
	}						
	Quit tSC
}

}
