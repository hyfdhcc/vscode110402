Include %occInclude

Class %SYS.Ensemble [ Abstract, System = 4 ]
{

/// Secure wrapper for the StartProduction API in <class>Ens.Director</class>.
ClassMethod StartProduction(pProductionName As %String) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..BasicChecks("%Ens_ProductionRun:USE")
		If $$$ISERR(tSC) Quit

		$$$AddAllRoleTemporaryInTry ;verified 9/26/16 STC
		Set tSC = ..LoginAsEnsembleUser("StartProduction")
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(Ens.Director).StartProduction(.pProductionName)
	}
	Catch ex {
		Set tSC = ##class(Ens.Util.Error).ExceptionStatus()
	}
	Quit tSC
}

/// Secure wrapper for the UpdateProduction API in <class>Ens.Director</class>.
ClassMethod UpdateProduction(pTimeout As %Numeric = 10, pForce As %Boolean = 0, pCalledByScheduleHandler As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..BasicChecks("%Ens_ProductionRun:USE,%Ens_ConfigItemRun:USE")
		If $$$ISERR(tSC) Quit
		
		$$$AddAllRoleTemporaryInTry ; verified 9/26/16 STC
		Set tSC = ..LoginAsEnsembleUser("UpdateProduction")
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(Ens.Director).UpdateProduction(pTimeout,pForce,pCalledByScheduleHandler)
	}
	Catch ex {
		Set tSC = ##class(Ens.Util.Error).ExceptionStatus()
	}
	Quit tSC
}

/// Secure wrapper for the StopProduction API in <class>Ens.Director</class>.
ClassMethod StopProduction(pTimeout As %Numeric = 10, pForce As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..BasicChecks("%Ens_ProductionRun:USE")
		If $$$ISERR(tSC) Quit
		
		$$$AddAllRoleTemporaryInTry ; verified 9/26/16 STC
		Set tSC = ..LoginAsEnsembleUser("StopProduction")
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(Ens.Director).StopProduction(pTimeout, pForce)
	}
	Catch ex {
		Set tSC = ##class(Ens.Util.Error).ExceptionStatus()
	}
	Quit tSC
}

/// Method to get the status of productions in all known Ensemble namespaces on this system.<br>
/// Note that data is NOT retrieved from remote databases. <br>
/// This list will not include namespaces if the default global database for the namespace is not mounted.<br>
/// The output status array is subscripted by namespace and with a value for each namespace that is a $List with 5 components:
/// <ol><li>Production Name of last used Production if any</li>
/// <li>Localized Status text</li>
/// <li>1 if the Production is Running, Stopped or Suspended, 0 otherwise, indicating 'not known to be OK'</li>
/// <li>'HS' if the namespace is HealthShare enabled, otherwise empty</li>
/// <li>The numeric state value representing the production's status</li></ol>
ClassMethod GetStatusAll(Output nsStatus) As %Status [ Internal ]
{
	Set tStatus = $$$OK
	Try {
		Kill nsStatus
		If '##class(%Library.EnsembleMgr).IsEnsembleInstalled() {
			Quit
		}
		Set tStatus = ..BasicChecks("%Ens_Portal:USE",0,0)
		If $$$ISERR(tStatus) Quit
		Merge tNspList = ^%SYS("Ensemble","InstalledNamespace")
		/* Get list of all local namespaces that have main db mounted */
		Do List^%SYS.NAMESPACE(.tNspList,4,0,1,1)
		$$$AddAllRoleTemporaryInTry ;verfied 9/26/16 STC
		Set tInitNS = $namespace
		Set ns = ""
		For {
			Set ns = $order(tNspList(ns),1,tNspInfo)
			Quit:(ns = "")
			If '$List(tNspInfo) Continue
			Set tProd = $get(^|ns|Ens.Configuration("csp","LastProduction"))
			If (tProd '= "") && $get(^|ns|Ens.MessageHeaderD) {
				Try {
					Set $namespace = ns
					If '##class(%Library.EnsembleMgr).IsEnsembleNamespace() Continue
					Kill tState
					Set tStatus1 = ##class(Ens.Director).GetProductionStatus(.tCurrProd,.tState,0)
					If '$system.Status.Equals(tStatus1, "<Ens>ErrCanNotAcquireRuntimeLock") {
						Set tStatus = $$$ADDSC(tStatus, tStatus1)
					}
					If '$data(tState) { Set tState = 0 }
				}
				Catch ex {
					Set tState = 0
					Set tStatus1 = ex.AsStatus()
					Set tStatus = $$$ADDSC(tStatus, tStatus1)
				}
				Set tStateText = ##class(Ens.Config.Production).ProductionStateToText(tState)
				Set nsStatus(ns) = $listbuild(tProd, tStateText, $case($zabs(tState), 1:1, 2:1, 3:1, :0), $select($data(^%SYS("HealthShare","Instances",ns)):"HS",1:""), tState)
			}
		}
		
		// Now check ^%SYS("Ensemble","RunningNamespace")
		Set ns = ""
		For {
			Set ns = $order(^%SYS("Ensemble","RunningNamespace",ns))
			Quit:(ns = "")
			If $data(tNspList(ns))&&'$data(nsStatus(ns)) { //Only show if allowed to see.
				Set nsStatus(ns) = $listbuild("", ##class(Ens.Config.Production).ProductionStateToText(0), 0, $select($data(^%SYS("HealthShare","Instances",ns)):"HS",1:""), 0)
			}
		}
	}
	Catch ex {
		Set tStatus1 = ex.AsStatus()
		Set tStatus = $$$ADDSC(tStatus, tStatus1)
	}
	If $data(tInitNS)#10 && ($namespace '= tInitNS) { // restore user to original namespace before $roles is reset
		Set $namespace = tInitNS
	}
	Quit tStatus
}

/// Wrapper around the SYS.EnsMetrics::GetMainMetrics() API to ensure that all users with
/// USE permissions on %Ens_Dashboard can get this information even if they aren't permitted to
/// directly run code in the CACHESYS database.
ClassMethod GetEnsMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg, pInterval As %Numeric = 10) As %Status
{
		Set tSC = $$$OK
		Try {
			Set tSC = ..BasicChecks("%Ens_Dashboard:USE",0,0)
			If $$$ISERR(tSC) Quit
			If $namespace '= "%SYS" {
				Set tSC = $$$ERROR($$$GeneralError,"Must be in %SYS")
				Quit
			}
			$$$AddAllRoleTemporaryInTry ; verified 9/26/16 STC
			Set tSC = ##class(SYS.EnsMetrics).GetMainMetrics(pID,pCount,.pValues,.pStatus,.pMsg,pInterval)
		}
		Catch ex {
			Set tSC = ex.AsStatus()
		}
		Quit tSC
}

/// Wrapper around the Ens.Util.Documentation::CreateDoc() API to ensure that users have sufficient privileges to
/// add the resulting material to the documentation.
ClassMethod CreateDocumentation(pProduction As %String = "", pIntro As %Boolean = 1, pFormat As %String, Output LogFileName As %String, Output URL As %String, Output BookName As %String, PDFFileName As %String, PDFRenderer As %String, ByRef Params As %String) As %Status
{
		Set tSC = $$$OK
		Try {
			Set tSC = ..BasicChecks("%Ens_ProductionDocumentation:USE",0,1)
			If $$$ISERR(tSC) Quit
			$$$AddAllRoleTemporaryInTry ;verified 9/26/16 STC
			Set tSC = ##class(Ens.Util.Documentation).CreateDoc(pProduction, pIntro, .pFormat, .LogFileName, .URL, .BookName, .PDFFileName, .PDFRenderer,.Params)
		}
		Catch ex {
			Set tSC = ex.AsStatus()
		}
		Quit tSC
}

ClassMethod GlobalInMirroredDB(pGlobal As %String = "", Output pMirrored As %Boolean) As %Status
{
	Set tSC = $$$OK
	Set pMirrored = 0
	Try {
		New $namespace
		Set tSC = ..BasicChecks("",0,1)
		If $$$ISERR(tSC) Quit
		#; Only allow Ensemble globals to start with
		If (pGlobal '= "") {
			Set tFirstFour = $zconvert($extract(pGlobal,1,4),"U")
			If (tFirstFour '= "^ENS") {
				Set tSC = $$$ERROR($$$GeneralError,"Non-Ensemble global '"_pGlobal_"' not supported.")
				Quit
			}
		}
		If '$system.Mirror.IsMember() {
			Set pMirrored = 0
			Quit
		}
		$$$AddAllRoleTemporaryInTry ; verified 9/26/16 STC
		Set tGlobalRef = $select(pGlobal = "": "^", 1: pGlobal)
		Set tDBRef = ##class(%SYS.Namespace).GetGlobalDest($namespace,tGlobalRef)
		If ($piece(tDBRef,"^",1) '= "") {
			#; The database is remote. Assume not in a mirror.
			Set pMirrored = 0
			Quit
		}
		Set $namespace = "%SYS"
		Set tDBDir = $piece(tDBRef,"^",2)
		Set tDB = ##class(SYS.Database).%OpenId(tDBDir,,.tSC)
		If $$$ISERR(tSC) Quit
		Set pMirrored = (tDB.Mirrored || tDB.MirrorNoWrite || tDB.InActiveMirror)
		#; Kill tDB before stack gets popped
		Kill tDB
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Common method to ensure that the public methods of this class are correctly invoked.
ClassMethod BasicChecks(pResources As %String = "", pCheckLicense As %Boolean = 1, pCheckNamespace As %Boolean = 1) As %Status [ Internal, Private ]
{
	Set tSC = $$$OK
	Try {
		Set tIsEnsNamespace = ##class(%Library.EnsembleMgr).IsEnsembleNamespace()
		If pCheckNamespace && ('tIsEnsNamespace) {
			Set tSC = $$$ERROR($$$GeneralError,"Must be invoked from an Ensemble-enabled namespace")
			Quit
		}
		
		#; The resource checks can be skipped if the user has the %All role
		If (pResources '= "") && '$$$IOwnAllRole {
			Set tCanUse = 0
			For i=1:1:$length(pResources,",") {
				Set tPair = $piece(pResources,",",i)
				Set tResource = $piece(tPair,":",1)
				If tResource = "" Continue
				Set tPermission = $piece(tPair,":",2)
				If tPermission = "" Set tPermission = "USE"
				If $system.Security.Check(tResource, tPermission) {
					Set tCanUse = 1
					Quit
				}
			}
			If 'tCanUse {
				Set tSC = $$$ERROR($$$InsufficientPrivilegeForOperation)
				Quit
			}
		}
		If pCheckLicense && ($system.License.GetFeature(1) = 0) {
			If tIsEnsNamespace {
				Set tSC=##class(Ens.Util.Error).EnsError($this,"StartProduction","<Ens>ErrNoEnsembleLicense")
			}
			Else {
				Set tSC=$$$ERROR($$$GeneralError,"No Ensemble license")
			}
			Quit
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Helper method to ensure that we can log in as the _Ensemble user AND that this user has the %All role.
/// Note that the calling code should escalate privileges to ensure the user may call $system.Security.Login().
/// We use "_Ensemble" as the login name instead of <method>EnsembleUsername</method>() as the return value from the method is a fully qualified username.
ClassMethod LoginAsEnsembleUser(pMethod As %String = "Unknown") As %Status [ Internal, Private ]
{
	Set tSC = $$$OK
	Try {
		If ('$system.Security.Login("_Ensemble")) || ('$$$IOwnAllRole) || ($username '= ..EnsembleUsername()) {
			$$$AddAllRoleTemporaryInTry  ; verfied 9/26/16 STC // Ensure we have privileges to get and log this error!
			Set tSC = ##class(Ens.Util.Error).EnsError($this,pMethod,"<Ens>ErrNoEnsembleManager")
			Quit
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Correctly determine the expanded Ensemble username if the system is using multiple domains.
/// If multiple domains are in use, then the Ensemble username should be present in the default domain.
ClassMethod EnsembleUsername() As %String
{
	$$$AddAllRoleTemporary ; verfied 9/26/16 STC
	Set tSuffix = ""
	If $$$SecuritySystemExists($$$SystemSecurityName,tSecuritySettings) && $$$GetSecuritySystemSecurityDomains(tSecuritySettings) {
		Set tDefDomain = $$$GetSecuritySystemDefaultSecurityDomain(tSecuritySettings)
		If tDefDomain '= "" Set tSuffix = "@"_tDefDomain
	}
	Quit "_Ensemble"_tSuffix
}

/// Return a list of users who are members of the %EnsRole_AlertManager role.
/// A user must be permitted to edit alerts to call this API.
ClassMethod ListAlertingUsers(Output pUsers As %String) As %Status
{
	Set tStatus = $$$OK
	New $namespace
	Try {
		Kill pUsers
		Set tStatus = ..BasicChecks("%Ens_Alerts:WRITE",0)
		If $$$ISERR(tStatus) Quit

		$$$AddAllRoleTemporaryInTry
		Set $namespace = "%SYS"

		Set tAlertRoles = "%EnsRole_AlertOperator,%EnsRole_Alert,%EnsRole_AlertAdministrator"
		#; Check whether %EnsRole_Administrator has USE permissions on %Ens_AlertAdministration; if so, include users from this role
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode = 2
		Set tStatus = tStatement.%Prepare("SELECT Permission FROM Security.Resource WHERE TheRole = LOWER('%EnsRole_Administrator') AND Name = '%Ens_AlertAdministration'")
		If $$$ISERR(tStatus) Quit
		Set tAdminRS = tStatement.%Execute()
		If tAdminRS.%Next() && (tAdminRS.Permission [ "U") {
			Set tAlertRoles = tAlertRoles _ ",%EnsRole_Administrator"
		}

		Set tRS = ##class(%Library.ResultSet).%New("Security.Users:List")
		Set tStatus = tRS.Execute("*",tAlertRoles)
		If $$$ISERR(tStatus) Quit
		While tRS.Next(.tStatus) {
			Set tUser = tRS.Get("Name")
			If (tUser '= "") {
				Set pUsers(tUser) = ""
			}
		}
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	#; Ensure we kill the result sets before we pop the namespace
	Kill tAdminRS
	Kill tRS
	Quit tStatus
}

/// Wrapper for getting secondary data. User needs Read access to the DB for 'Password'. Only support Password.
ClassMethod SecondaryGet(pKey As %String = "", pProperty As %String = "", ByRef pSC As %Status) As %String [ Internal ]
{
	Set pSC = $$$OK, tValue = ""
	Try {
		Quit:(pProperty'="Password")
		Set tValue = $G(^Ens.SecondaryData.Password(pKey))
	}
	Catch ex {
		Set pSC = ##class(Ens.Util.Error).ExceptionStatus(),tValue=""
	}
	Quit tValue
}

/// Secure wrapper for writing secondary data. Only support Password.
ClassMethod SecondarySet(pValue As %String = "", pKey As %String = "", pProperty As %String = "") As %Status [ Internal ]
{
	Set tSC = $$$OK
	Quit:(pKey="") tSC
	Quit:(pProperty'="Password") tSC
	Try {
		Set tResourceRequired = "%Ens_Credentials:W"
		Set tSC = ..BasicChecks(tResourceRequired,0,0)
		If $$$ISERR(tSC) Quit
		$$$AddAllRoleTemporaryInTry ; verified 9/26/16 STC
		Set ^Ens.SecondaryData.Password(pKey) = pValue
	}
	Catch ex {
		Set tSC = ##class(Ens.Util.Error).ExceptionStatus()
	}
	Quit tSC
}

/// Secure wrapper for deleting secondary data.  Only support Password.
ClassMethod SecondaryDelete(pKey As %String = "", pProperty As %String = "") As %Status [ Internal ]
{
	Set tSC=$$$OK
	Quit:(pKey="") tSC
	Quit:(pProperty'="Password") tSC
	Try {
		Set tResourceRequired = "%Ens_Credentials:W"
		Set tSC = ..BasicChecks(tResourceRequired)
		If $$$ISERR(tSC) Quit
		$$$AddAllRoleTemporaryInTry ;verified 9/26/16 STC
		Kill ^Ens.SecondaryData.Password(pKey)
	} Catch ex {
		Set tSC = ##class(Ens.Util.Error).ExceptionStatus()
	}	
	Quit tSC
}

}
