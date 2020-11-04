/// This class is used internally by InterSystems. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.<p>
Class %Studio.SourceControl.ISC Extends %Studio.SourceControl.Base [ System = 4 ]
{

/// This Parameter should be updated when synced from Perforce
Parameter SrcVer = "$Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/cls/Studio/SourceControl/ISC.xml#1 $";

/// Revision number of this class when compiled as part of the //custom_ccrs/_common/config/... branch.  
/// This version will not be updated (by design) when the class is integrated to other branches.
/// This allows the user to tell what version of the Studio client tools are in use. 
Parameter Version = 165;

XData Menu
{
<MenuBase>
<Menu Name="%SourceMenu" Type="0">
<MenuItem Name="%CheckOut"/>
<MenuItem Name="%UndoCheckout"/>
<MenuItem Name="%CheckIn" Save="100"/> 
<MenuItem Name="%GetLatest"/>
<MenuItem Name="%AddToSourceControl" Save="100"/>
<MenuItem Name="%DisconnectItem" Save="100"/>
<MenuItem Name="%ReconnectItem"/>
<MenuItem Name="Diff"/>
<MenuItem Separator="1"/>
<MenuItem Name="%Disconnect"/>
<MenuItem Name="%Reconnect"/>
<MenuItem Separator="1"/>
<MenuItem Name="CCRControls"/>
</Menu>
<Menu Name="%SourceContext" Type="1">
<MenuItem Name="%CheckOut"/>
<MenuItem Name="%UndoCheckout"/>
<MenuItem Name="%CheckIn" Save="100"/>
<MenuItem Name="%GetLatest"/>
<MenuItem Name="%AddToSourceControl" Save="100"/>
<MenuItem Name="%DisconnectItem"/>
<MenuItem Name="%ReconnectItem"/>
</Menu>
</MenuBase>
}

/// Display connection information in the Output display
Method Login(Name As %String, Password As %String) As %Status
{
	Set output=(..MainJob=0)
	If 'output Quit $$$OK
	Write !,"-----------------------------------------------------------------------------"
	Write !,"Source Control class "_$classname()_" is enabled for '"_$namespace_"'"
	Set disconnected=..Disconnected()
	Write !,"This namespace is "_$select(disconnected=2:"Permanently Disconnected from", disconnected=1:"Disconnected from",1:"Connected to")_" Perforce"
	If (disconnected <=1) {
		Set ret=..GetCredentials(.p4user, .p4passwd, .p4workspace, .p4dir, .p4port)
		If p4user'=""||(p4passwd'="")||(p4workspace'="")||(p4dir'="")||(p4port'="") Write !,"Perforce credentials explicitly defined:"
		If p4user'=""      Write !,"   p4user:      "_$get(p4user)
		If p4passwd'=""    Write !,"   p4password:  <defined>"
		If p4workspace'="" Write !,"   p4workspace: "_$get(p4workspace)
		If p4dir'=""       Write !,"   p4directory: "_$get(p4dir)
		If p4port'=""      Write !,"   p4port:      "_$get(p4port)
	}	
	If $get(^SYS("SourceControl","ItemSetConfig","Enabled")) {
		Write !,"Current CCR Configuration"
		Write !,"   Organization: "_$get(^SYS("SourceControl","ItemSetConfig","Org"))
		Write !,"   System:       "_$get(^SYS("SourceControl","ItemSetConfig","System"))
		Write !,"   Environment:  "_$get(^SYS("SourceControl","ItemSetConfig","Environment"))
	}
	Set locked=##class(%Studio.SourceControl.ISC).Locked()
	If (locked) {
		Write !,"NOTE - Source Control for this namespace is "_$select(locked=2:"ADMINLOCKED",1:"LOCKED")
		Write !,"       All items within this namespace will be treated as Readonly"
		If (locked<2) { Write !,"       Do ##class(%Studio.SourceControl.ISC).Unlock() to change Locked state" }
	}
	If ($get(^SYS("SourceControl","Misc","LockMapped"))){
		Write !,"NOTE - Source Control for this namespace is configured to lock MAPPED items"
		Write !,"       All items mapped from other databases will be treated as Readonly"
	}
	Write !,"^Sources = "_$get(^Sources)
	Do ..CheckIndexes()
	Write !
	Quit $$$OK
}

/// Called before the item is saved to the Cache database it is passed
/// a reference to the current temporary storage of this item so that it
/// can be modified before the save completes. If you quit with an error
/// value then it will abort the save.
Method OnBeforeSave(InternalName As %String, Location As %String = "", Object As %RegisteredObject = {$$$NULLOREF}) As %Status
{
	Set sc = $$$OK
	If ..Locked() Set sc = $$$ERROR($$$GeneralError,"Cannot save item as Source Control is LOCKED for this namespace")
	Quit sc
}

Method OnBeforeLoad(InternalName As %String, display As %Boolean = 1) As %Status
{
	Quit ..Load(InternalName,.display)
}

ClassMethod Load(InternalName As %String, display As %Boolean = 1) As %Status
{
	#; the Tools -> Import and Tools -> Export GUIs do not always return InternalName of a csp file with a leading '/'; it must be added for other code to work
	If (InternalName["/")&&($E(InternalName)'="/") Set InternalName="/"_InternalName
	Set filename=..ExtName(InternalName)
	#; File not mapped so nothing to do
	If filename="" Quit $$$OK
	#; If no file then skip the import
	If '##class(%File).Exists(filename) Write:display !,"File ",filename," not found, skipping import" Quit $$$OK
	If ##class(%File).GetFileSize(filename)=0 Quit $$$OK
	Set oldts=##class(%RoutineMgr).TS(InternalName)
	Set filets=##class(%File).GetFileDateModified(filename,1)
	#; If time already matches then no work to do
	If filets=$get(^Sources(0,"FileTimeStamp",InternalName)) {
		New %SourceControl
		If oldts=$get(^Sources(0,"ItemTimeStamp",InternalName)) Quit $$$OK
		Write:display !,"ERROR: Item '"_InternalName_"' has been modified in Cache outside of Studio so the copy in Cache no longer matches the version in the file '"_filename_"'. If you are sure the version in Cache is the copy you want to keep making a dummy modification and saving this item will export the Cache version to the external file" 
		Quit $$$OK
	}
	Set loaded=1
	If InternalName["/" {
		Set sc=..ImportCSPFile(InternalName)
	} Else {
		#; See if the file contains the correct item
		Set sc=$$Load^%apiOBJ(filename,"fv-d-l",,.imported,1)
		If $$$ISOK(sc) {
			Set name=##class(%Studio.SourceControl.Interface).normalizeName($order(imported("")))
			If name'=InternalName {
				Set loaded=0
			} Else {
				Set sc=$$Load^%apiOBJ(filename,"fv-d-l")
			}
		}
	}
	If loaded {
		Set newts=##class(%RoutineMgr).TS(InternalName)
		If newts'=oldts||($$$ISOK(sc))||($$$GETERRORCODE(sc)=$$$ERRORCODE($$$SAXError)) {
			Set ^Sources(0,"FileTimeStamp",InternalName)=filets
			Set ^Sources(0,"ItemTimeStamp",InternalName)=newts
		}
	}
	If $$$ISERR(sc) Do DecomposeStatus^%apiOBJ(sc,.errors,"d")
	If $$$ISOK(sc),loaded {
		Write !,"Imported '",InternalName,"' from file '",filename,"'"
	}
	Quit sc
}

Method OnBeforeTimestamp(InternalName As %String)
{
	If '$get(^SYS("SourceControl","Misc","NoAutoLoad")) {
		Do ..OnBeforeLoad(InternalName,0)
	}
}

Method OnAfterSave(InternalName As %String, Object As %RegisteredObject) As %Status
{
	#; the Tools -> Import and Tools -> Export GUIs do not always return InternalName of a csp file with a leading '/'; it must be added for other code to work
	If (InternalName["/")&&($E(InternalName)'="/") Set InternalName="/"_InternalName

	Set haschange=$system.CLS.IsMthd("%Studio.SourceControl.Change","IsUncommitted")
	Set filename=..ExternalName(InternalName)
	#; File not mapped so nothing to do
	If filename="" Quit $$$OK
	Set name=$Piece(InternalName,".",1,*-1)
	Set ext=$ZConvert($Piece(InternalName,".",*),"U")
	#; Do not export the default projects
	If ext="PRJ",$zconvert($extract(name,1,$length("default_")),"l")="default_" Quit $$$OK
	#; By convention items starting with Z,z,%z,%Z are not exported
	If ext'="PRJ",'$$$FileExists(filename) Write !,"File ",filename," not found, skipping export" Quit $$$OK

	If ($get(^SYS("SourceControl","Misc","InsertSrcVer")))&&(ext="CLS") {
		Set cnt=0
		&SQL(SELECT Count(id) INTO :cnt FROM %Dictionary.ParameterDefinition WHERE parent = :name AND Name='SrcVer')
		If ('(SQLCODE < 0))&&(cnt=0) {
			Write !,"Inserting SrcVer parameter into "_InternalName
			Set p=##class(%Dictionary.ParameterDefinition).%New()
			Set p.Name="SrcVer" 
			Do p.parentSetObjectId(name) 
			Set p.Default = "$"_"Id"_"$"	; separate out the string to keep Perforce RCS replacement from happening on this line
			Set p.Description = "Location and Revision of this file in Perforce (Auto-updating)"
			Set sc = p.%Save()
			If $$$ISERR(sc) { Write !,"Error inserting SrcVer Parameter - "_$system.Status.GetErrorText(sc) }
		}
	}

	If haschange,##class(%Studio.SourceControl.Change).IsUncommitted(filename) {
		Set sc=##class(%Studio.SourceControl.Change).GetUncommitted(filename,.tAction,.tInternalName,.UncommittedUser,.tSource,.UncommittedLastUpdated)
		If ($USERNAME=UncommittedUser) {
			#; update performed by file owner; update the timestamp in the Change table
			Set sc=##class(%Studio.SourceControl.Change).UpdateUncommitted(filename,,,$USERNAME)	
		} Else {
			#; most likely, OnAfterSave() called by OnAfterCompile, which was triggered by a non-owner of the file
		}
		If $$$ISERR(sc) { Write !,$system.Status.GetErrorText(sc) }
	} 

	#; If time already matches and this is not a newly created file (no TimeStamp), then there is nothing to do
	If haschange,##class(%RoutineMgr).TS(InternalName)=$get(^Sources(0,"ItemTimeStamp",InternalName)),$get(^Sources(0,"ItemTimeStamp",InternalName))'="" Quit $$$OK 
	If ..ReadOnly(filename) Write !,"File ",filename," is read only, not exporting" Quit $$$OK
	If name["/" {
		#; we copy out CSP files
		Set sc = ..ExportCSPFile(InternalName)
	} ElseIf ext="CLS"||(ext="PRJ")||($zconvert($extract(filename,$length(filename)-2,*),"l")="xml")||(##class(%RoutineMgr).UserType(InternalName)) {
		If '$$$FileExists(filename) Do ##class(%File).CreateDirectoryChain(##class(%File).GetDirectory(filename))
		Set qspec = $g(^SYS("SourceControl","Misc","ExportFlags"),"/diffexport")
		Set sc=$$Export^%occXMLExport(filename,"-d "_qspec,InternalName)
	} Else {
		If $get(^SYS("SourceControl","Misc","RtnExportUTF8"),1) {
			Set parms="WNSK\UTF8\"
		} Else {
			Kill parms	; make variable undefined to force default behavior
		}
		Set sc=$$Export^%apiRTN(InternalName,filename,"Save for Source Control",.parms,"-d /diffexport")
	}
	If $$$ISOK(sc) {
		Write !,"Exported '",InternalName,"' to file '",filename,"'"
		Set ^Sources(0,"FileTimeStamp",InternalName)=$$$FileDateModified(filename,1)
		Set ^Sources(0,"ItemTimeStamp",InternalName)=##class(%RoutineMgr).TS(InternalName)
	} Else {
		Do DecomposeStatus^%apiOBJ(sc,,"d")
		Quit sc
	}
	Quit $$$OK
}

Method OnAfterCompile(InternalName As %String) As %Status
{
	Set sc=$$$OK
	Set other=$get(^Sources(0,"ExtraItems",InternalName))
	For i=1:1:$length(other,",") {
		Set item=$piece(other,",",i)
		If item'="" Set sc=..OnAfterSave(item) If $$$ISERR(sc) Quit
	}
	Quit sc
}

ClassMethod ExportCSPFile(InternalName As %String) As %Status
{
	Set cspFile = $System.CSP.GetFileName(InternalName)
	Set srcFile = ..ExtName(InternalName)
	// Quit if the csp application is defined within the source root
	If (cspFile=srcFile)||($$$isWINDOWS&&($ZCVT(cspFile,"l")=$ZCVT(srcFile,"l"))) Quit $$$OK
	If '(##class(%File).Exists(srcFile)&&..ReadOnly(srcFile)) {
		Do ##class(%File).CreateDirectoryChain(##class(%File).GetDirectory(srcFile))
		If '##class(%File).CopyFile(cspFile, srcFile) {
			Quit $$$ERROR($$$GeneralError,"Unable to export '"_srcFile_"'")
		}
	}
	Quit $$$OK
}

ClassMethod ImportCSPFile(InternalName As %String) As %Status
{
	; Changed to ClassMethod because of MAK2849 change moving calling code to ClassMethod; changes ExportCSPFile as well to match
	Set cspFile = $System.CSP.GetFileName(InternalName)
	Set srcFile = ..ExtName(InternalName)
	// Quit if the csp application is defined within the source root
	If (cspFile=srcFile)||($$$isWINDOWS&&($ZCVT(cspFile,"l")=$ZCVT(srcFile,"l"))) Quit $$$OK
	If ##class(%File).Delete(cspFile) && ##class(%File).CopyFile(srcFile, cspFile) {
		Set rc=##class(%File).SetWriteable(cspFile,0)
		Set sc=$select(rc:$$$OK,1:$$$ERROR($$$GeneralError,"Unable to make file '"_cspFile_"' writable"))
	} Else {
		Set sc = $$$ERROR($$$GeneralError, "Unable to import '"_srcFile_"'")
	}
	Quit sc
}

/// Return information about this entity
/// <p>
/// This method checks the current status of the item, seeing whether or not it is in source control (based on an exported
/// copy of the item on disk), and if it is in source control, whether it is currently checked out (based on whether the file
/// is Readonly or not).  
/// <p>
/// If the file is checked out, this method will check to find the value of 
/// $USERNAME for whomever performed <method>CheckOut</method>.  If the current $USERNAME does not match, then the user 
/// will not be permitted to edit the file as it has been checked out by another user
Method GetStatus(InternalName As %String, ByRef IsInSourceControl As %Boolean, ByRef Editable As %Boolean, ByRef IsCheckedOut As %Boolean, ByRef UserCheckedOut As %String) As %Status
{
	Set Editable=1,IsCheckedOut=1,UserCheckedOut=""
	Set filename=..ExternalName(InternalName)
	Set IsInSourceControl=(filename'=""&&($$$FileExists(filename)))
	If filename="" Quit $$$OK
	Set backupFile=..BackupName(InternalName)
	#; If the file does not exist then it must be a new item so it is editable.
	If '$$$FileExists(filename) {
		Set IsCheckedOut=0
	} ElseIf ..ReadOnly(filename) {
		Set Editable=0,IsCheckedOut=0
	}
	If ('IsCheckedOut)&&($$$FileExists(backupFile)) {
		Set ret=$$$FileDelete(backupFile)
		If 'ret Write !,"Error deleting unnecessary local backup copy: "_backupFile
	}

	Set haschange=$system.CLS.IsMthd("%Studio.SourceControl.Change","IsUncommitted")
	#; If it is a CSP file stored in the Perforce root, then the IsInSourceControl might be set improperly and it needs to be confirmed
	If (IsInSourceControl)&&(IsCheckedOut)&&(filename=$$GetFilename^%apiCSP(InternalName)) {
		#; If it is truely IsInSourceControl&&IsCheckedOut then it will be in the uncommitted queue; if not, then correct the flags
		If haschange,'##class(%Studio.SourceControl.Change).IsUncommitted(filename) Set IsInSourceControl=0,IsCheckedOut=0
	}
	
	#; Kill any outdated user edit information, but not deletes or reverts since they may be pending commit from a Disconnected instance
	If haschange,('IsCheckedOut)&&(##class(%Studio.SourceControl.Change).IsUncommitted(filename)) {
		If ('$listfind($listbuild("revert","delete"),##class(%Studio.SourceControl.Change).OpenUncommitted(filename).Action)) Set sc=##class(%Studio.SourceControl.Change).RemoveUncommitted(filename,0,0,0)
	}

	#; Ensure that it isn't locked for editing by someone else
	Set sc=$$$OK
	If haschange,##class(%Studio.SourceControl.Change).IsUncommitted(filename) {
		Set sc=##class(%Studio.SourceControl.Change).GetUncommitted(filename,.tAction,.tInternalName,.UncommittedUser,.tSource,.UncommittedLastUpdated)
		If ('sc) {
			Write !,$SYSTEM.Status.GetErrorText(sc)
			Write !,"Removing from uncommitted queue..."
			Set sc=..UndoCheckout(InternalName)
			Set IsCheckedOut=0
		} ElseIf $D(tAction)&&(UncommittedUser'=$USERNAME)&&..IsSharedDevInstance() {
			Set msg="NOTICE: "_InternalName_" is currently checked out by user '"_UncommittedUser_"', and was last updated at "_UncommittedLastUpdated
			Write !,msg
			Set Editable=0
			Set IsInSourceControl=0		;set this to 0 to prevent user from being prompted to Check Out file
			Set UserCheckedOut=UncommittedUser
		}
	}
	#; Ensure that the namespace isn't under Source Control Lock
	If ..Locked() {
		Set Editable=0
		Set IsInSourceControl=0		;set this to 0 to prevent user from being prompted to Check Out file
	}
	#; Ensure that this isn't a mapped item if Lock Mapped is enabled
	If ($get(^SYS("SourceControl","Misc","LockMapped"))) {
		If (..IsMapped(InternalName)) {		; only required until minimum supported version is 2013.1, then replace with %RoutineMgr:IsMapped()
			Set msg="NOTICE: "_InternalName_" is mapped from another database and will be treated as Readonly"
			Write !,msg
			Set Editable=0
			Set IsInSourceControl=0		; set this to 0 to prevent user from being prompted to Check Out file
		}
	}
	Quit sc
}

Method IsInSourceControl(InternalName As %String) As %Boolean [ CodeMode = expression ]
{
..ExtName(InternalName)'=""
}

Method ExternalName(InternalName As %String) As %String [ CodeMode = expression ]
{
..ExtName(InternalName)
}

/// Check this routine/class/csp file into source control.
Method CheckIn(InternalName As %String, Description As %String) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

/// ** DEPRECATED - Use more secure <method>SecureRunCmd</method> instead<p>
/// Run a shell command and report any error message, return <var>output</var> with 
/// lines as subscripts of the array if <var>stream</var> is false (the default) but if
/// <var>stream</var> is true then we will return the output as a stream to be read by the caller.
ClassMethod RunCmd(cmd As %String, ByRef output As %String, display As %Boolean = 1, stream As %Boolean = 0) As %Status
{
	Set sc=$$$OK,text=cmd
	Kill output
	
	// Make sure that any p4 commands have login/client information, if known
	If $P(cmd," ")="p4" {
		Set p4="p4"	
		
		Set ret=..GetCredentials(.p4user, .p4passwd, .p4workspace, .p4dir, .p4port)
		If 'ret Write !,"NOTICE: Source Control Credentials are not set for '"_$USERNAME_"'"
		 
		If p4user'="" Set p4=p4_" -u "_p4user
		If p4passwd'="" Set p4=p4_" -P "_$$$QuoteName(p4passwd)
		If p4workspace'="" Set p4=p4_" -c "_p4workspace
		If p4dir'="" Set p4=p4_" -d "_$$$QuoteName(p4dir)
		If p4port'="" Set p4=p4_" -p "_$$$QuoteName(p4port)
		
		Set cmd = p4_" "_$P(cmd," ",2,$L(cmd," "))
	}
	
	If display Write !,"CMD: ",text
	Set errorfile=##class(%File).TempFilename("err"), outputfile=##class(%File).TempFilename("out")
	Set rc=$zf(-1,cmd_" 2> """_errorfile_""" > """_outputfile_"""")
	Set errorstream=##class(%FileCharacterStream).%New(),outputstream=##class(%FileCharacterStream).%New()
	Set errorstream.Filename=errorfile,outputstream.Filename=outputfile
	If errorstream.Size>0 {
		Do errorstream.Rewind()
		Set error=errorstream.Read()
		Set sc=$$$ERROR($$$GeneralError,"Error: "_error)
	}
	Do errorstream.Clear()
	If stream {
		Set output=outputstream,outputstream.RemoveOnClose=1
	} Else {
		If outputstream.Size>0 {
			Do outputstream.Rewind()
			While 'outputstream.AtEnd {
				Set line=outputstream.ReadLine()
				Set output($increment(output))=line
			}
		}
		Do outputstream.Clear()
	}
	Quit sc
}

/// Run a command and report any error message, return <var>output</var> with 
/// lines as subscripts of the array if <var>stream</var> is false (the default) but if
/// <var>stream</var> is true then we will return the output as a stream to be read by the caller.
/// Passed the executable name in <var>cmd</var> and the list of arguments as an integer subscripted
/// local array passed in by reference in <var>args</var>.
ClassMethod SecureRunCmd(cmd As %String, ByRef args, ByRef output As %String, display As %Boolean = 1, stream As %Boolean = 0, input As %String = "") As %Status
{
	Set sc=$$$OK,args=+$get(args)
	Kill output
	
	If display {
		Write !,"CMD: ",cmd
		For i=1:1:args Write " ",args(i)
	}
	// Make sure that any p4 commands have login/client information, if known
	If cmd="p4" {
		Set ret=..GetCredentials(.p4user, .p4passwd, .p4workspace, .p4dir, .p4port)
		If 'ret Write !,"NOTICE: Source Control Credentials are not set for '"_$USERNAME_"'"

		If p4user'="" Set newargs($i(newargs))="-u",newargs($i(newargs))=p4user
		If p4passwd'="" Set newargs($i(newargs))="-P",newargs($i(newargs))=p4passwd
		If p4workspace'="" Set newargs($i(newargs))="-c",newargs($i(newargs))=p4workspace
		If p4dir'="" {
			Set newargs($i(newargs))="-d",newargs($i(newargs))=$zstrip(p4dir,">","\")
		}
		If p4port'="" Set newargs($i(newargs))="-p",newargs($i(newargs))=p4port
		#; Insert original args after these settings
		For i=1:1:args Set newargs($i(newargs))=args(i)
	} Else {
		Merge newargs=args
	}
	
	Set errorfile=##class(%File).TempFilename("err"), outputfile=##class(%File).TempFilename("out")
	Try {
		Set rc=$zf(-100,"/stdout="""_outputfile_""" /stderr="""_errorfile_""""_$s(input'="":" /stdin="""_input_"""",1:""),cmd,.newargs)
	} Catch {
		RETURN $$$ERROR($$$FileDoesNotExist,cmd)
	}
	Set errorstream=##class(%FileCharacterStream).%New(),outputstream=##class(%FileCharacterStream).%New()
	Set errorstream.Filename=errorfile,outputstream.Filename=outputfile
	If errorstream.Size>0 {
		Do errorstream.Rewind()
		Set error=errorstream.Read()
		Set sc=$$$ERROR($$$GeneralError,"Error: "_error)
	}
	Do errorstream.Clear()
	If stream {
		Set output=outputstream,outputstream.RemoveOnClose=1
	} Else {
		If outputstream.Size>0 {
			Do outputstream.Rewind()
			While 'outputstream.AtEnd {
				Set line=outputstream.ReadLine()
				Set output($increment(output))=line
			}
		}
		Do outputstream.Clear()
	}
	Quit sc
}

/// Check this routine/class/csp file out of source control.<br/>
/// Following successful checkout, the copy of the file on disk is loaded into the Namespace, unless <var>Load</var> is false.
Method CheckOut(InternalName As %String, Description As %String, Load As %Boolean = 1) As %Status
{
	Set sc=$$$OK
	If ('..Disconnected())&&($get(^SYS("SourceControl","Misc","AutoSync"))) {
		Set sc=..GetLatest(InternalName)
		If ($$$ISERR(sc))&&($system.Status.GetErrorText(sc)'["up-to-date") { Quit sc }
	}
	Set filename=..ExternalName(InternalName)
	If filename="" Quit $$$OK
	Set backupFile=..BackupName(InternalName)
	If $$$FileExists(backupFile) If '$$$FileDelete(backupFile) Write !,"Error deleting backup copy: "_backupFile
	Set ret=$$$FileCopy(filename,backupFile)
	If 'ret Write !,"Error making local backup copy: "_backupFile
	If ..Disconnected() {
		Set rc=##class(%File).SetWriteable(filename,0)
	} Else {
		Set args($i(args))="edit",args($i(args))=filename
		Set p4Issued=1
		Set sc=..SecureRunCmd("p4",.args) If $$$ISERR(sc) Quit sc
	}
	Set haschange=$system.CLS.IsMthd("%Studio.SourceControl.Change","IsUncommitted")
	If haschange {
		Set sc=##class(%Studio.SourceControl.Change).SetUncommitted(filename, "edit", InternalName,,,$G(p4Issued),,,0)
		If $$$ISERR(sc) Write "Error adding to Uncommitted queue - "_$System.OBJ.DisplayError(sc)
	}
	#; If the file still does not exist or it is not writable then checkout failed
	If ('$$$FileExists(filename))||(..ReadOnly(filename)) Quit $$$ERROR($$$GeneralError,"Checkout failed to make file '"_InternalName_"' writeable in filesystem")
	If (Load) { Set sc=..OnBeforeLoad(InternalName) If $$$ISERR(sc) Quit sc }
	Set other=$get(^Sources(0,"ExtraItems",InternalName))
	For i=1:1:$length(other,",") {
		Set item=$piece(other,",",i)
		If item'="" Set sc=..CheckOut(item,.Description) If $$$ISERR(sc) Quit
	}
	Quit sc
}

Method UndoCheckout(InternalName As %String) As %Status
{
	Set filename=..ExternalName(InternalName)
	If filename="" Quit $$$OK
	Set backupFile=..BackupName(InternalName)
	Set sc=##class(%Studio.SourceControl.Change).GetUncommitted(filename,.tAction,.tInternalName,.UncommittedUser,.tSource,.UncommittedLastUpdated,.P4Issued)
	If ($G(tAction)="add")&&(filename'=$System.CSP.GetFileName(InternalName)) {
		#; item wasn't previously in Source Control, and it is not a CSP file stored in the Perforce root, so delete it from the OS
		Set ret=##class(%File).Delete(filename) If 'ret Write !,"Unable to delete file for newly added item - "_filename
	}
	If ..Disconnected() {
		If '##class(%File).Exists(backupFile)  Quit $$$ERROR($$$GeneralError,"Disconnected Revert Failed: Local backup file does not exist")
		If $G(tAction)'="add" {
			Set ret=##class(%File).Delete(filename) If 'ret Quit $$$ERROR($$$GeneralError,"Revert Failed: Unable to delete current file")
			Set ret=##class(%File).CopyFile(backupFile,filename) If 'ret Quit $$$ERROR($$$GeneralError,"Revert Failed: Unable to replace current file with backup copy")
			#; change file back to Readonly
			Set rc=##class(%File).SetReadOnly(filename)
			If 'rc Quit $$$ERROR($$$GeneralError,"Unable to make '"_filename_"' read only")
		}
	} Else {
		Set args($i(args))="revert",args($i(args))=filename
		Set sc=..SecureRunCmd("p4",.args) If $$$ISERR(sc) Quit sc
	}
	If ((..Disconnected()=1)&&(P4Issued'="")) {
		#; Change to an uncommitted 'revert' because previous command was issues to Perforce and this is a temporarily Disconnected instance
		Set sc=##class(%Studio.SourceControl.Change).UpdateUncommitted(filename, "revert")
		If $$$ISERR(sc) Write "Error changing uncommitted to 'revert' - "_$System.OBJ.DisplayError(sc)
	} Else {
		#; Remove the item from the list of uncommitted changes; 
		Set sc=##class(%Studio.SourceControl.Change).RemoveUncommitted(filename,1,1)
		If $$$ISERR(sc) Write "Error removing uncommitted file "_filename_" - "_$System.OBJ.DisplayError(sc)
	}
	Set sc=..OnBeforeLoad(InternalName) If $$$ISERR(sc) Quit sc
	If (##class(%File).Exists(backupFile)) {
		Set ret=##class(%File).Delete(backupFile) If 'ret Write !,"Error deleting unnecessary local backup copy: "_backupFile
	}
	Set other=$get(^Sources(0,"ExtraItems",InternalName))
	For i=1:1:$length(other,",") {
		Set item=$piece(other,",",i)
		If item'="" Set sc=..UndoCheckout(item) If $$$ISERR(sc) Quit
	}
	#; Delete from file system if Perforce did not mark it back to ReadOnly as a result of the Revert and it is not a CSP file stored in the Perforce root
	If ('..ReadOnly(filename))&&(filename'=$System.CSP.GetFileName(InternalName))  {
		Set sc=##class(%File).Delete(filename)
		If $$$ISERR(sc) Quit sc	
	}
	#; If the file no longer exists on the file system (due to this being a revert of an "Add") then kill the ^Sources nodes
	If '##class(%File).Exists(filename) {
		Kill ^Sources(0,"FileTimeStamp",InternalName)
		Kill ^Sources(0,"ItemTimeStamp",InternalName)
	}
	Quit sc
}

Method GetLatest(InternalName As %String) As %Status
{
	Set file=..ExternalName(InternalName)
	If file="" Quit $$$OK
	If ..Disconnected() Quit $$$ERROR($$$GeneralError,"Unable to get the latest version of a file while disconnected")
	Set args($i(args))="sync",args($i(args))=file
	Set sc=..SecureRunCmd("p4",.args) If $$$ISERR(sc) Quit sc
	Set sc=..OnBeforeLoad(InternalName) If $$$ISERR(sc) Quit sc
	Set other=$get(^Sources(0,"ExtraItems",InternalName))
	For i=1:1:$length(other,",") {
		Set item=$piece(other,",",i)
		If item'="" Set sc=..GetLatest(item) If $$$ISERR(sc) Quit
	}
	Quit sc
}

/// Update the ^Sources information with the file dates after a build
ClassMethod UpdateSources() As %Status
{
	Set sc=$$$qualifierParse("Compiler","asp"_$select($namespace="%SYS":" /mapped=1",1:""),.qstruct) Quit:$$$ISERR(sc) sc
	Do GetClassFullList^%occLibrary(.list,.qstruct)
	Set class=""
	For  {
		Set class=$order(list(class)) Quit:class=""
		Set filename=..ExtName(class_".CLS")
		#; If no file then skip the import
		If filename=""||('##class(%File).Exists(filename)) Continue
		Set ^Sources(0,"FileTimeStamp",class_".CLS")=##class(%File).GetFileDateModified(filename,1)
		Set ^Sources(0,"ItemTimeStamp",class_".CLS")=##class(%RoutineMgr).TS(class_".CLS")
	}
	Set routine=""
	If $extract($namespace)'="^",$namespace'="%SYS" {
		Set ns=$$GetGlobalSourceDatabase^%SYS.SECURITY($name(^ROUTINE))
	} Else {
		Set ns=""
	}

	For  {
		Set routine=$order(^|ns|rINDEX(routine)) Quit:routine=""
		Set type=""
		For  {
			Set type=$order(^|ns|rINDEX(routine,type)) Quit:type=""
			Set filename=..ExtName(routine_"."_type)
			If filename=""||('##class(%File).Exists(filename)) Continue
			Set ^Sources(0,"FileTimeStamp",routine_"."_type)=##class(%File).GetFileDateModified(filename,1)
			Set ^Sources(0,"ItemTimeStamp",routine_"."_type)=##class(%RoutineMgr).TS(routine_"."_type)
		}
	}
	Quit $$$OK
}

/// Job off a background job to update the sources information.
/// It returns -1 if it could not start the job or the $job number if successful
ClassMethod JobUpdateSources() As %String [ ProcedureBlock = 0 ]
{
	Quit $zutil(66,"USR","JobEntry^"_$zname,10,0,0)=-1
JobEntry()	Do ##class(%Studio.SourceControl.ISC).UpdateSources()
	Quit
}

/// Called to add this item to source control
Method AddToSourceControl(InternalName As %String, Description As %String = "") As %Status
{
	Set sc=$$$OK
	Set filename=..ExternalName(InternalName)
	If filename="" Quit $$$ERROR($$$GeneralError,"Unable to find mapping where item '"_InternalName_"' should go")
	#; If file not there create a blank file now
	Do ##class(%File).CreateDirectoryChain(##class(%File).GetDirectory(filename))
	If '##class(%File).Exists(filename) {
		Open filename:"NW":0 Close filename
		If '##class(%File).Exists(filename) Quit $$$ERROR($$$GeneralError,"Unable to create file '"_filename_"'")
		#; If the document is present then export it
		Kill ^Sources(0,"FileTimeStamp",InternalName)
		Kill ^Sources(0,"ItemTimeStamp",InternalName)
		#; Only export if the class or routine has been saved (check by removing the trailing '.CLS')
		If $zcvt($piece(InternalName,".",*),"l")="cls" {
			Set class=$piece(InternalName,".",1,*-1)
			If ##class(%Dictionary.ClassDefinition).%ExistsId(class) {	
				 Do ..OnAfterSave(InternalName)
			} Else {
				#; Need dummy blank class
				Set cls=##class(%Dictionary.ClassDefinition).%New(class,$$$CLASSDEFINITIONVERSION)
				Do cls.%Save()
				Kill cls
				Do ..OnAfterSave(InternalName)
				Do ##class(%Dictionary.ClassDefinition).%DeleteId(class)
			}
		} ElseIf ##class(%RoutineMgr).Exists(InternalName) {	
			 Do ..OnAfterSave(InternalName)
		}
	}
	Set sc=##class(%Studio.SourceControl.Change).SetUncommitted(filename, "add", InternalName,,,('..Disconnected()),,,0)
	If $$$ISERR(sc) Write "Error adding to Uncommitted queue - "_$System.OBJ.DisplayError(sc)

	If '..Disconnected() {
		Set args($i(args))="add",args($i(args))=filename
		Set sc=..SecureRunCmd("p4",.args)
		If $$$ISERR(sc) {
			Set sc2=##class(%Studio.SourceControl.Change).RemoveUncommitted(filename,0,1)
			If $$$ISERR(sc2) Set sc=$SYSTEM.Status.AppendStatus(sc,sc2)
			#; if the file is not ReadOnly and it's not a csp file under the perforce root, then it was created for the first time and should be deleted because p4 threw an error
			If ('..ReadOnly(filename))&&(filename'=$SYSTEM.CSP.GetFileName(InternalName)) Do ##class(%File).Delete(filename)
			Quit sc
		}
	}
	#; create backup file that is identical to the file, to allow UndoCheckout logic to work 
	Set fileBackup=..BackupName(InternalName)
	Set ret=##class(%File).CopyFile(filename,fileBackup) If 'ret Write !,"Error creating backup file - "_fileBackup
	Set other=$get(^Sources(0,"ExtraItems",InternalName))
	For i=1:1:$length(other,",") {
		Set item=$piece(other,",",i)
		If item'="" Set sc=..AddToSourceControl(item,.Description) If $$$ISERR(sc) Quit
	}
	Quit sc
}

/// Called to delete this item from source control
Method RemoveFromSourceControl(InternalName As %String, Description As %String = "") As %Status
{
	Set sc=$$$OK
	Set filename=..ExternalName(InternalName)
	If filename="" Quit $$$ERROR($$$GeneralError,"Unable to find mapping where item '"_InternalName_"' was")
	If '##class(%File).Exists(filename) Quit $$$OK
	If ..Disconnected() {
		Set sc=##class(%Studio.SourceControl.Change).SetUncommitted(filename, "delete", InternalName,,,,,,0)
		If $$$ISERR(sc) Write "Error adding to Uncommitted queue - "_$System.OBJ.DisplayError(sc)
		Set rc=##class(%File).Delete(filename)
		If 'rc Quit $$$ERROR($$$GeneralError,"Unable to delete file '"_filename_"'")
	} Else {
		Set sc=..GetStatus(InternalName,.isinsourcecontrol,.editable,.ischeckedout) If $$$ISERR(sc) Quit sc
		#; If we wish to delete this we must revert the checkout first
		If ischeckedout {
			Kill args Set args($i(args))="revert",args($i(args))=filename
			Set sc=..SecureRunCmd("p4",.args) If $$$ISERR(sc) Quit sc
		}
		#; Check if the file is still present in Perforce, if it is not then we are done and we must have reverted a new file set for 'add', so just delete the local file
		Kill args Set args($i(args))="files",args($i(args))=filename
		Set sc=..SecureRunCmd("p4",.args,,0)
		If $$$ISOK(sc) {
			Kill args Set args($i(args))="delete",args($i(args))=filename
			Set sc=..SecureRunCmd("p4",.args) If $$$ISERR(sc) Quit sc
		} Else {
			Set rc=##class(%File).Delete(filename)
			If 'rc Quit $$$ERROR($$$GeneralError,"Unable to delete file '"_filename_"'")
		}
	}
	If ##class(%RoutineMgr).Exists(InternalName) {
		Set sc=##class(%RoutineMgr).Delete(InternalName) If $$$ISERR(sc) Quit sc
	}
	Set other=$get(^Sources(0,"ExtraItems",InternalName))
	For i=1:1:$length(other,",") {
		Set item=$piece(other,",",i)
		If item'="" Set sc=..RemoveFromSourceControl(item,.Description) If $$$ISERR(sc) Quit
		If ##class(%RoutineMgr).Exists(InternalName) {
			Set sc=##class(%RoutineMgr).Delete(InternalName) If $$$ISERR(sc) Quit
		}
	}
	Quit sc
}

/// Return filename of this item
ClassMethod ExtName(InternalName As %String) As %String
{
	Set name=..Name(InternalName)
	Quit $select(name="":"",1:$$$FileNormalizeFilename(^Sources_name))
}

/// Return filename of backup file of this item
/// <p>
/// At the time of <method>CheckOut</method>, a local backup of the item in its existing state is backed up to the 
/// file system with a .bak extension.  This file will be used on Disconnected systems to restore to the previous
/// state when <method>UndoCheckout</method> is called.  It can also be used for diffs from the original file state.
ClassMethod BackupName(InternalName As %String) As %String
{
	Quit ..ExtName(InternalName)_".bak"
}

/// Return the name of this item without the prefix to be added by ExtName
ClassMethod Name(InternalName As %String) As %String
{
	If $data(^Sources)'=11 Write !,"^Sources is not set up so hooks will not work; namespace: "_$namespace Quit ""
	Set InternalName=##class(%Studio.SourceControl.Interface).normalizeName(InternalName)
	#; Disconnected items do not have an external name
	If InternalName'="",$get(^Sources(0,"Disconnected",InternalName)) Quit ""
	Set usertype=$system.CLS.IsMthd("%Library.RoutineMgr","UserType")
		
	// For an abstract document, use the GetOther() method to try to determine its "real" class
	If usertype,##class(%RoutineMgr).UserType(InternalName,.docclass,.doctype) {
		// Check for a real abstract document subclass (or GetOther() may not work)
		If $classmethod(docclass,"%IsA","%Studio.AbstractDocument") {
			// Grab the actual name
			Set actualName = $classmethod(docclass,"GetOther",InternalName)
			// The actualName is only valid if we get a single .cls as a result
			If actualName'[",",$ZCVT($P(actualName,".",$L(actualName,".")),"U")="CLS" {
				// We use what GetOther() gives us, thus Demo.Loan.FindRateProcess.bpl becomes Demo.Loan.FindRateProcess.cls
				Set InternalName = actualName
			}
		}
	}	
	
	If $$CheckProtect^%qccServer(InternalName) Quit ""
	Set nam=$p(InternalName,".",1,*-1),ext=$p(InternalName,".",*),ext=$zcvt(ext,"u")
	If nam=""||(ext="") Quit ""
	// Any CSP items should be matched against the "/CSP/" mapping in ^Sources
	If InternalName["/" {
		Set filename=$$GetFilename^%apiCSP(InternalName)
		If $$$isWINDOWS {
			If $zcvt($extract(filename,1,$length(^Sources)),"l")=$zcvt(^Sources,"l") Quit $extract(filename,$length(^Sources)+1,*)
		} Else {
			If $extract(filename,1,$length(^Sources))=^Sources Quit $extract(filename,$length(^Sources)+1,*)
		}
		// Any CSP items should be matched against the "/CSP/" mapping if the file is not stored in the ^Sources tree
		Set ext="/CSP/"	
	}
	If ext="PRJ",nam["Default_" Quit ""
	If ext="CLS",$$$defClassKeyGet(nam,$$$cCLASSgeneratedby)'="" Quit ""
	Set default=0
	Set p=$order(^Sources(ext,nam)) For  s p=$order(^Sources(ext,p),-1) Quit:p=""  If $extract(nam,1,$length(p))=p,$data(^Sources(ext,p),found) Quit
	If $data(found)=0,$data(^Sources(ext,"*"),found),'$get(^Sources(ext,"*","NoFolders")) Set default=1
	If $data(found)=0 Quit ""
	If InternalName["/" {
		// If no specific mapping was specified (p=""), then return the whole csp filename; otherwise return the name without the mapped piece
		Set InternalName=$extract(InternalName,$length(p)+2,*)
		Quit $translate(found_$translate(InternalName,"%","_"),"\","/")
	}
	If (ext="DFI") {
		// expected format is <folderName>-<itemName>.<itemType>.DFI; will map to an external file named <folderName>/<itemName>.<itemType>.xml 
		// replace the first '-' with '/' to translate Item Folder into subfolder on disk and leave the other dashes as dashes; converts spaces to '_'
		Quit $translate(found_$replace($translate(nam,"% ","__"),"-","/",1,1)_".xml","\","/")	
	}
	If $get(^Sources(ext,"*","NoFolders")) {
		If ext="CLS"||(ext="PRJ")||(usertype&&(##class(%RoutineMgr).UserType(InternalName))) Quit $translate(found_$translate(nam,"%","")_".xml","\","/")
	} Else {
		If ext="CLS"||(ext="PRJ")||(usertype&&(##class(%RoutineMgr).UserType(InternalName))) Quit $translate(found_$translate(nam,".%","/")_".xml","\","/")
	}
	If found["`" {
		Set found=$piece(found,"`")
		Quit $translate($g(found)_$zconvert($tr(nam,"%","_"),"l")_"."_$zconvert(ext,"l"),"\","/")
	}
	If default Quit $translate($g(found)_$tr(nam,"%.","_/")_"."_$s(ext="INC":"inc",ext="INT":"int",1:"rtn"),"\","/")
	Quit $translate($g(found)_$tr(nam,"%","_")_"."_$s(ext="INC":"inc",ext="INT":"int",1:"rtn"),"\","/")
}

/// Takes a filename within the local Perforce workspace and returns a best guess as to the InternalName.
/// If the file exists then Caché will attempt to open it to find the item name.  If it does not exist (or if it can't open it) then it will try to 
/// determine the item name based on the location in directory tree and the structure of the mappings in ^Sources.<p>
/// If no item in the database can be found to map to the external filename, then "" will be returned by the method.<p>
/// Unless <var>IgnorePercent</var> argument is set to 0, any %-items to return ""<p>
/// Unless <var>IgnoreNonexistent</var> argument is set to 0, if the item isn't found in the database, then "" will be returned<p>
/// Known Limitations (if the physical file doesn't exist):
/// <ul>
/// <li>Due to this historical act of stripping '%' from the beginning of package names, if there exists both a %-item and a non-%-item which map to the same
/// location, then "" will be returned as the result is indeterminate without having access to the source file.</li>
/// <li>The method currently does not return internal names for CSP files that don't exist as source on the file system</li>
/// <li>The method currently will not find matches for multi-tier mappings in ^Sources (e.g. <code>^Sources("HL7","*")="schema/hl7/"</code>)</li>
/// </ul>
ClassMethod InternalNameFromExtName(ExtName, IgnorePercent = 1, IgnoreNonexistent = 1) As %String
{
	If $data(^Sources)'=11 Write !,"^Sources is not set up so hooks will not work namespace: "_$namespace Quit ""
	Set InternalName=""
	If (##class(%File).Exists(ExtName)) {
		Set sc=$system.OBJ.Load(ExtName,"-d",,.Name,1)
		Set InternalName=$get(Name)
	}
	If (InternalName="") {
		If ($ZCVT(ExtName,"U")'[$ZCVT($G(^Sources),"U")) {
			Quit ""	; file is not in ^Sources so translation cannot occur
		}
		Set name=$extract(ExtName,$length(^Sources)+1,*)
		Set name=$replace(name,"\","/")	; standardize slash direction
		Set nam=$piece(name,"/",2,$length(name,"/")),extDir=$piece(name,"/")_"/"
		If nam=""||(extDir="") Quit ""
	
		Set found=0, queryary=$query(^Sources(""),-1,dir), subscript=$replace($piece($piece(queryary,"(",2),","),"""","")
		While (queryary'="")&&(subscript'=0) {
			If (dir["/")&&(dir=extDir) {
				Set ext=subscript
				Quit
			}
			Set queryary=$query(@queryary,-1,dir), subscript=$replace($piece($piece(queryary,"(",2),","),"""","")
		}
		If $data(ext)=0 Quit ""
		If (ext="/CSP/") Quit ""	; TODO: add retrieval logic for csp internal names
	
		Set nam=$piece(nam,".",1,$length(nam,".")-1)
		Set nam=$translate(nam,"_/","%.")
		Set InternalName=nam_"."_ext
		If (ext="CLS") {	; special handling for possible collissions between % and non-% classes of the same name
			Set alternateInternalName="%"_InternalName
			Set primaryExists=##class(%RoutineMgr).Exists(InternalName), alternateExists=##class(%RoutineMgr).Exists(alternateInternalName)
			If ('primaryExists)&&(alternateExists) { Set InternalName=alternateInternalName }	; it must have been a %-class as one by that name exists
			If (primaryExists)&&(alternateExists) { Quit "" }	;indeterminate as the class exists in % and non-% form in the DB
		}
	}
	If ((IgnorePercent)&&($extract(InternalName)="%")) { Set InternalName = "" }	; don't return a result for % items if instructed to ignore them
	If ((IgnoreNonexistent)&&('##class(%RoutineMgr).Exists(InternalName))) { Set InternalName = "" }	; only return item names which exist in the DB
	Quit InternalName
}

/// Disconnect from Perforce depot
/// <p>Values for 'Level' parameter are:
/// <ul>
/// <li> 1: Instance is Disconnected but could connect at a future time (default) </li>
/// <li> 2: Instance is Permanently Disconnected (no plans of ever connecting to Perforce) </li> 
/// </ul>
ClassMethod Disconnect(Level As %Integer = 1) As %Status
{
	If (..Disconnected()=Level) Set err="Already disconnected" Write !,err Quit $$$ERROR($$$GeneralError,err)
	If $data(^Sources)'=11 Set err="^Sources is not set up so hooks will not work" Write !,err Quit $$$ERROR($$$GeneralError,err)
	If (Level'=1)&&(Level'=2) Set err="Illegal Value" Write !,err Quit $$$ERROR($$$GeneralError,err)
	Set ^SYS("SourceControl","Disconnected")=Level
	Set sc=##class(%Studio.SourceControl.Change).RefreshUncommitted(0,1)
	Write !,"Disconnected from source control now, changes will be remembered but no p4 commands issues"
	Quit $$$OK
}

/// Reconnect to the Perforce depot and mark all edited as edited.
ClassMethod Reconnect() As %Status
{
	If '..Disconnected() {
		Write !,"Already connected, nothing to do" 
		Set ^SYS("SourceControl","Disconnected")=0 ; ensure that Disconnected state is explicitly set to 0 as "" is interpretted as uninitialized
		Quit $$$ERROR($$$GeneralError,"Already connected")
	}
	If $data(^Sources)'=11 Write !,"^Sources is not set up so hooks will not work" Quit $$$ERROR($$$GeneralError,"^Sources is not set up so hooks will not work")
	Write !,"Reconnecting to source control"
	Kill args Set args($i(args))="info"
	Set sc=..SecureRunCmd("p4",.args) If $$$ISERR(sc) Write !,"Unable to contact Perforce, can not reconnect" Quit $$$ERROR($$$GeneralError,"Unable to contact Perforce, can not reconnect")
	Set rc=$$$OK
	Set query = ##class(%Library.ResultSet).%New("%DynamicQuery.SQL")
    Set qtext = "SELECT ItemFile From %Studio_SourceControl.Change Where P4Issued IS NULL AND Committed='0'"         
    Set sc = query.Prepare(qtext)
    Set sc = query.Execute()
    While (query.Next()) {
		Set filename=query.Get("ItemFile")
		Kill action, InternalName, user, source, updated, p4Issued
		Set sc=##class(%Studio.SourceControl.Change).GetUncommitted(filename, .action, .InternalName, .user, .source, .updated, .p4Issued)		
		Set file=..ExtName($G(InternalName))
		If file="" Continue
		Kill args Set args($i(args))=action,args($i(args))=filename
		Set sc=..SecureRunCmd("p4",.args)
		If $$$ISERR(sc) {
			Write !,"Problem with p4 "_action_" command for ",InternalName
			Do DisplayError^%apiOBJ(sc)
			If $length(rc)<8000 Set rc=$$$ADDSC(rc,sc)
			Continue
		}
		#; Connected mode is now storing record of Uncommitted Changes (except "delete" or "revert"), but marking the commands as having been issued to Perforce
		If (action="delete") {
			Set sc=##class(%Studio.SourceControl.Change).RemoveUncommitted(filename,0,0,1) 
		} ElseIf (action="revert") { 
			#; revert the change from the uncommitted queue
			Set sc=##class(%Studio.SourceControl.Change).RemoveUncommitted(filename,0,1) 
		} Else {
			#; mark that this uncommitted item has had its p4 command issued
			Set sc=##class(%Studio.SourceControl.Change).UpdateUncommitted(filename,,,,,,1)						
		}
	}
	Set sc=##class(%Studio.SourceControl.Change).RefreshUncommitted(0,1)
	Set ^SYS("SourceControl","Disconnected")=0
	Write !,"Reconnected, changes to source files will cause p4 commands to be issued"
	Quit rc
}

Method UserAction(Type As %Integer, Name As %String, InternalName As %String, SelectedText As %String, ByRef Action As %String, ByRef Target As %String, ByRef Msg As %String, ByRef Reload As %Boolean) As %Status
{
	Set Action=0,Target="",Msg="",Reload=0
	If Type=0 {
		Set menu=$piece(Name,",")
		If menu'="%SourceMenu",menu'="%SourceContext" Quit $$$OK
		Set name=$piece(Name,",",2)
		Set action=$case(name,"%CheckIn":-1,"%CheckOut":0,"%AddToSourceControl":1,"%GetLatest":3,"%UndoCheckout":4,"%Disconnect":5,"%Reconnect":6,"%DisconnectItem":-3,"%ReconnectItem":-4,"CCRControls":-5,"Diff":-6,:-2)
		If action=-2 Quit $$$OK
	} ElseIf Type=1 {
		Set action=Name
	}
	#; Do not need source control when deleting an item that is not in source control
	If action=2 {
		Set insource=0
		For i=1:1:$length(InternalName,",") {
			Set item=$zstrip($piece(InternalName,",",i),"<>W") If item="" Continue
			If ..IsInSourceControl(item) Set insource=1
		}
		If 'insource Quit $$$OK
	}
	#; Default to displaying dialog if no Flags parameter defined as this is what previous source control did
	Set ret=..GetCredentials(.p4user,.p4pass)
	If '..Disconnected(),'..DefaultCredentialsDefined(),'$data(%stP),(p4pass="") {
		If 'ret Write !,"NOTICE: There is no Perforce user currently defined"
		Set Msg="<Enter Perforce password for Perforce user '"_p4user_"' if you wish to proceed>"	
	}
	If action=-1 {
		Set Action=2
		Set Item=..Name(InternalName)
		Set Target="/isc/studio/templates/%25Studio.SourceControl.UI.cls?action=Checkin&item="_##class(%CSP.Page).EscapeURL(Item)_"&"
	} ElseIf action=-5 {
		Set Action=2
		Set Target="/isc/studio/templates/%25Studio.SourceControl.UI.cls"
	} ElseIf action=-6 {
		Set Action=2
		Set Target="/isc/studio/templates/%25Studio.SourceControl.UI.cls?action=Diff&file="_##class(%CSP.Page).EscapeURL(..ExtName(InternalName))_"&"
	} ElseIf (action<3&&(action>-2))||(action=-3)||(action=-4) {
		Set Action=$S(Msg'="":7,1:1)
		Set Target=$$$FormatMessage(,"%Studio",$case(action,-1:"CheckInDialog",0:"CheckOutDialog",1:"AddDialog",2:"RemoveDialog",-3:"DisconnectItemDialog",-4:"ReconnectItemDialog"),,InternalName)
		///for field systems, add additoinal warning on CheckOut if this is any environment other than TEXT
		Set env=$G(^SYS("SourceControl","ItemSetConfig","Environment"))
		If (action=0)&&((env="TEST")||(env="UAT")||(env="LIVE")) {
			Set warning="WARNING:  Changes to '"_env_"' should only be made for critical debug purposes and then reverted"_$C(13,10)
			Set warning=warning_$C(9)_"All permanent changes must originate in 'BASE' and be progressed via Perforce"_$C(13,10,13,10)
			Set Target=warning_Target			
		}
	} ElseIf Msg'="",Type=0,(action=3)||(action=4)||(action=6) {
		// selected action requires p4 password to be set, so prompt
		Set Action=7
		Set Target="Perforce password required to proceed"
	} ElseIf (Type=1)&&(action=6){
		set nl = $l(InternalName,",")
		for il=1:1:nl {
			set sName = $p(InternalName,",",il)
			do ..CheckOut(sName,"Import")
		}		
	} Else {
		Quit ..AfterUserAction(0,Name,InternalName,1,,.Reload)
	}
	Quit $$$OK
}

Method AfterUserAction(Type As %Integer, Name As %String, InternalName As %String, Answer As %Integer, Msg As %String = "", ByRef Reload As %Boolean) As %Status
{
	Set Reload=0
	#; Note if you implement this method yourself you can remove all the code below, this is just included
	#; for backward compatibility with previous versions of the source control hooks.
	If Type=0 {
		Set menu=$piece(Name,",")
		If menu'="%SourceMenu",menu'="%SourceContext" Quit $$$OK
		Set name=$piece(Name,",",2)
		Set action=$case(name,"%CheckIn":-1,"%CheckOut":0,"%AddToSourceControl":1,"%GetLatest":3,"%UndoCheckout":4,"%Disconnect":5,"%Reconnect":6,"%DisconnectItem":-3,"%ReconnectItem":-4,"CCRControls":-5,"Diff":-6,:-2)
		If action=-2 Quit $$$ERROR($$$StudioSourceActionInvalid,Name,InternalName)
	} ElseIf Type=1 {
		Set action=Name
	}
	If Answer'=1 Quit $$$OK
	If Msg'="" {
		Set password=$piece(Msg,$char(13,10))
		Set sc=..GeneratePerforceTicket(password,.ticket)
		If ($$$ISOK(sc)) {
			Write !,"Perforce Ticket created and stored: "_ticket
		} Else {
			Write !,"NOTICE: There was a problem retrieving a Perforce Ticket:"
			Write !,$system.Error.GetErrorText(sc)	
		}
	}
	If action=5 Quit ..Disconnect()
	If action=6 Quit ..Reconnect()
	Set sc=$$$OK
	For i=1:1:$length(InternalName,",") {
		Set item=$zstrip($piece(InternalName,",",i),"<>W") If item="" Continue
		If action=-1 Set rc=..CheckIn(item,Msg)
		If action=0 Set rc=..CheckOut(item,Msg)
		If action=1 Set rc=..AddToSourceControl(item,Msg)
		If action=2 Set rc=..RemoveFromSourceControl(item,Msg)
		If action=3 Set rc=..GetLatest(item)
		If action=4 Set Reload=1,rc=..UndoCheckout(item)
		If action=-3 Set Reload=1,rc=..DisconnectItem(item)
		If action=-4 Set Reload=1,rc=..ReconnectItem(item)
		If $$$ISERR(rc) {
			//if it was a password related error, kill session variable and clear out the stored ticket
			If (rc["P4PASSWD")||(rc["was logged out") {
				Kill %stP
				Do ..ClearPerforceTicket()
			}
			Set sc=$$$ADDSC(sc,rc)
		}
	}
	Quit sc
}

Method OnMenuItem(MenuName As %String, InternalName As %String, SelectedText As %String, ByRef Enabled As %Boolean, ByRef DisplayName As %String) As %Status
{
	Set menu=$piece(MenuName,","),name=$piece(MenuName,",",2)
	If menu'="%SourceMenu",menu'="%SourceContext" Quit $$$OK
	If InternalName'="" {
		Set sc=..GetStatus(InternalName,.isinsourcecontrol,.editable,.ischeckedout)
		If $$$ISERR(sc) Quit sc
	}
	Set isinsourcecontrol=+$get(isinsourcecontrol),editable=+$get(editable),ischeckedout=+$get(ischeckedout)
	If name="%CheckOut" {
		If ('editable)&&(ischeckedout) Set Enabled=0	; InternalName is checked out by a different user
		If ischeckedout||('isinsourcecontrol) Set Enabled=0
		If InternalName="" Set Enabled=0
		If ..Locked() Set Enabled=0
	} ElseIf name="%CheckIn" {
		If ('editable)&&(ischeckedout) Set Enabled=0	; InternalName is checked out by a different user
		If 'isinsourcecontrol||('ischeckedout) Set Enabled=0
		If InternalName="" Set Enabled=0
		If ..Disconnected() Set Enabled=0
		If ..Locked() Set Enabled=0
	} ElseIf name="%UndoCheckout" {
		Set filename=..ExternalName(InternalName)
		If ##class(%Studio.SourceControl.Change).IsUncommitted(filename) {
			Set sc=##class(%Studio.SourceControl.Change).GetUncommitted(filename,.tAction,.tInternalName,.UncommittedUser,.tSource,.UncommittedLastUpdated)
			If tAction="add" { Set DisplayName=$$FormatMessage^%occMessages(,"%Studio","%UndoAdd","Undo Add") }
		}	
		If ('editable)&&(ischeckedout) Set Enabled=0	; InternalName is checked out by a different user
		If 'isinsourcecontrol||('ischeckedout) Set Enabled=0
		If InternalName="" Set Enabled=0
		If ..Locked() Set Enabled=0
	} ElseIf name="%GetLatest" {
		If ('editable)&&(ischeckedout) Set Enabled=0	; InternalName is checked out by a different user
		If ischeckedout||('isinsourcecontrol) Set Enabled=0
		If InternalName="" Set Enabled=0
		If ..Disconnected() Set Enabled=0
		If ..Locked() Set Enabled=0
	} ElseIf name="%AddToSourceControl" {
		If ('editable)&&(ischeckedout) Set Enabled=0	; InternalName is checked out by a different user
		If isinsourcecontrol||(InternalName="")||(..Name(InternalName)="") Set Enabled=0
		If InternalName="" Set Enabled=0
		If ..Locked() Set Enabled=0
		If ($get(^SYS("SourceControl","Misc","LockMapped")))&&(..IsMapped(InternalName)) { Set Enabled = 0 }
	} ElseIf name="%Disconnect" {
		If (..Disconnected())||(..IsSharedDevInstance())  Set Enabled=0
		If (..InstanceVersion()>2010.1)&&(..Disconnected()=2) Set Enabled=-1	; don't show the menu item for a Permanently Disconnected instance on Caché versions with MAK2784
	} ElseIf name="%Reconnect" {
		If ('..Disconnected()||(..Disconnected()=2)||(..IsSharedDevInstance())) Set Enabled=0
		If (..InstanceVersion()>2010.1)&&(..Disconnected()=2) Set Enabled=-1	; don't show the menu item for a Permanently Disconnected instance on Caché versions with MAK2784
	} ElseIf name="%DisconnectItem" {
		If InternalName="" {
			Set Enabled=-1
		} ElseIf $get(^Sources(0,"Disconnected",InternalName)) {
			Set Enabled=0
		} ElseIf 'isinsourcecontrol {
			Set Enabled=-1
		}
	} ElseIf name="%ReconnectItem" {
		Set Enabled=0
		If InternalName="" {
			Set Enabled=-1
		} ElseIf $get(^Sources(0,"Disconnected",InternalName)) {
			Set Enabled=1
		} ElseIf 'isinsourcecontrol {
			Set Enabled=-1
		}
	} ElseIf name="CCRControls" {
		Set DisplayName="Show CCR Controls"
		If '$get(^SYS("SourceControl","ItemSetConfig","Enabled")) {
			Set Enabled=0
			If (..InstanceVersion()>2010.1) Set Enabled=-1		; don't show the menu item on Caché versions with MAK2784
		}
	} ElseIf name="Diff" {
		Set DisplayName="Diff Against Last Version"
		If ('ischeckedout) Set Enabled=0
		If (('isinsourcecontrol)&&('ischeckedout))||(InternalName="")||(..Name(InternalName)="") Set Enabled=0	; if isinsourcecontrol=0 and ischeckedout=1 then it is checked out by another person (so diff should be allowed) 
	}
	Quit $$$OK
}

/// ** DEPRECATED - Use the more secure <method>SecureP4Cmd</method>.
/// Passed a 'p4' command, it runs it with '-ztag' and returns the parsed output
ClassMethod P4Cmd(cmd As %String, Output output As %String) As %Status
{
	Kill out
	Set sc=..RunCmd("p4 -ztag "_cmd,.in,0,1)
	If $$$ISERR(sc) Quit sc
	Set output=1,sc=$$$OK,lastLineWasNonField=0
	
	If in.Size>0 {
		Do in.Rewind()
		While 'in.AtEnd {
			Set line=in.ReadLine()
			If ($extract(line,1,4)'="... ") {
				Set lastLineWasNonField=1
				Continue
			} ElseIf (lastLineWasNonField) {
				Set lastLineWasNonField=0
				//ztag record separators are newline characters, which can also be contained in a multiline field (like Changelist Description)
				//If the current field is already filled for the current record, assume we're now processing the next record
				If $data(output(output,$piece($extract(line,5,*)," "))) Set output=output+1
			} 
			Set line=$extract(line,5,*)
			Set key=$piece(line," ")
			Set value=$piece(line," ",2,$$$MaxStringLength)
			Set output(output,key)=value
		}
	}
	If '$data(output(output)) Set output=output-1
	Quit sc
}

/// Passed a 'p4' by reference list of arguments in <var>args</var>, it runs 'p4' with '-ztag' and returns the parsed output
ClassMethod SecureP4Cmd(ByRef args, Output output As %String) As %Status
{
	Kill out
	Set newargs($i(newargs))="-ztag"
	For i=1:1:args Set newargs($i(newargs))=args(i)
	Set sc=..SecureRunCmd("p4",.newargs,.in,0,1)
	If $$$ISERR(sc) Quit sc
	Set output=1,sc=$$$OK,lastLineWasNonField=0
	
	If in.Size>0 {
		Do in.Rewind()
		While 'in.AtEnd {
			Set line=in.ReadLine()
			If ($extract(line,1,4)'="... ") {
				Set lastLineWasNonField=1
				Continue
			} ElseIf (lastLineWasNonField) {
				Set lastLineWasNonField=0
				//ztag record separators are newline characters, which can also be contained in a multiline field (like Changelist Description)
				//If the current field is already filled for the current record, assume we're now processing the next record
				If $data(output(output,$piece($extract(line,5,*)," "))) Set output=output+1
			} 
			Set line=$extract(line,5,*)
			Set key=$piece(line," ")
			Set value=$piece(line," ",2,$$$MaxStringLength)
			Set output(output,key)=value
		}
	}
	If '$data(output(output)) Set output=output-1
	Quit sc
}

/// This method will accept a Perforce password and will attempt to generate a Perforce ticket tied to this server for use within the hooks.  
/// In the process it will validate a ticket which may already be set, and if it is valid it will keep that ticket.
ClassMethod GeneratePerforceTicket(p4pass As %String = "", ByRef p4ticket As %String) As %Status
{
	//Validate ticket. This tries to log in without a password.
	Set sc = ..ValidatePerforceTicket()
	//If invalid, try to log in with p4pass
	If ($$$ISERR(sc)) {	
		//If not valid, try to get a new one.
		Set file=##class(%Library.FileCharacterStream).%New()
		Set sc=file.WriteLine(p4pass)
		Set args($i(args))="-s",args($i(args))="login",args($i(args))="-p"
		Set sc=..SecureRunCmd("p4",.args,.out,0,,file.Filename)	//don't display the output since it includes the password in plain text
		/* expected output of 'out' for correct login (incorrect returns sc as an error):
			out=3
			out(1)="Enter password: "
			out(2)="info: 1F312B20CBC503C72DDA242EB267D2AE"
			out(3)="exit: 0"	
		*/
		If ($$$ISOK(sc))&&($get(out)>0) {
			Set i="", i=$order(out(i),1,line)
			While ((line'["info: ")&&(line'["error: ")) {
				Set i=$order(out(i),1,line)
			}
			if (line["info: ") {
				Set ticket=$piece(line,"info: ",2)
				If (..StorePerforceTicket(ticket)) {
					Set sc=..ValidatePerforceTicket()
					Set p4ticket = ticket
				}
			} elseif (line ["error: ") {
				Set:..ClearPerforceTicket() sc=$$$ERROR($$$GeneralError,$piece(line,"error: ",2))
			}
		} Else {
			Set:..ClearPerforceTicket() sc=$$$ERROR($$$GeneralError,"Error: Perforce username and/or password is incorrect")
		}
	}
	Quit sc
}

/// Validate a ticket and return the amount of time remaining for that ticket.
/// If the ticket is not valid it will clear it from the credential store since it is of no use
ClassMethod ValidatePerforceTicket(ByRef timeRemaining As %String) As %Status
{
	//Determine expiration date/time.
	Set args($i(args))="login",args($i(args))="-s"
	Set sc = ..SecureRunCmd("p4",.args,.out,0)
	If ($$$ISOK(sc)) {
		Set ret=..GetCredentials(.p4User)
		If ($g(out(1)) [ "User "_p4User_" ticket ") {
			Set timeRemaining = $piece(out(1),"expires in ",2)
		} Else {
			//Didn't get expected response...
			Set sc = $$$ERROR($$$GeneralError,"Ticket didn't have expiration date, or something else unexpected happened.")
		}
	} Else {
		Do ..ClearPerforceTicket()
	}
	Quit sc
}

/// Stores a Perforce ticket for future use by the current user
ClassMethod StorePerforceTicket(ticket As %String = "") As %Boolean
{
	If (..GetCredentials(.p4user)) {
		Quit ..SetCredentials($listbuild($USERNAME,p4user),ticket)
	} Else {
		Quit 0
	}
}

/// Clears out a stored Perforce ticket which may be stored for the current user
ClassMethod ClearPerforceTicket() As %Boolean
{
	Kill %stP
	If (..GetCredentials(.p4user)) {
		Quit ..SetCredentials($listbuild($USERNAME,p4user),"")
	} Else {
		Quit 0
	}
}

/// Add the specified items to source control
ClassMethod AddItemsToSourceControl(ByRef items) As %Status
{
	Set sc = $$$OK

	// If any items were specified in list for, add those
	If $L($G(items)) {	
		For i=1:1:$L(items,",") {
			Set item = $P(items,",",i)
			Set items(item)=""
		}
	}
	
	Set isc = ..%New("")
	Set item = ""
	For {
		Set item = $O(items(item))
		Quit:item=""
		
		// This will do an Export/P4 Add for any items that are NOT already in source control
		Set sc2=isc.AddToSourceControl(item)
		
		// Build up a list of errors for the caller
		Set:$$$ISERR(sc2) sc=$$$ADDSC(sc,sc2)
	}
	
	Quit sc
}

/// Add the specified classes to source control
ClassMethod AddClassesToSourceControl(classes As %String) As %Status
{
	For i=1:1:$L(classes,",") {
		Set cls = $P(classes,",",i)
		Set classes(cls_".cls")=""
	}
	
	Quit ..AddItemsToSourceControl(.items)
}

/// Add the specified package(s) to source control
ClassMethod AddPackagesToSourceControl(packages As %String) As %Status
{
	For i=1:1:$L(packages,",") {
		Set package=$P(packages,",",i)
		Do $system.OBJ.GetPackageList(.classes,package,"ars")
		
		Set cls=""
		For {
			Set cls = $O(classes(cls))
			Quit:cls=""
			
			Set items(cls_".cls")=""
		}
	}
	
	Quit ..AddItemsToSourceControl(.items)
}

/// Returns value that shows whether or not this instance is "Disconnected" from Studio
/// <p>Return values are:
/// <ul>
/// <li> 0: Instance is Connected</li>
/// <li> 1: Instance is Disconnected but could connect at a future time</li>
/// <li> 2: Instance is Permanently Disconnected (no plans of ever connecting to Perforce) </li> 
/// </ul>
ClassMethod Disconnected() As %Integer [ CodeMode = expression ]
{
$get(^SYS("SourceControl","Disconnected"))
}

/// Returns value that shows whether or not this instance is "Locked"
/// <p>Return values are:
/// <ul>
/// <li> "": Instance has never been Locked or Unlocked (default)</li>
/// <li> 0: Instance is Unlocked</li>
/// <li> 1: Instance is Locked</li>
/// <li> 2: Instance is AdminLocked</li> 
/// </ul>
/// <p>When the instance is Locked or AdminLocked, no changes can be made via Studio.  It is possible to change from Locked to NotLocked via different UIs.
/// When an instance is AdminLocked it should only be possible to unlock it via the <method>Unlock</method> method.
ClassMethod Locked() As %String [ CodeMode = expression ]
{
$get(^SYS("SourceControl","Locked"))
}

/// Lock the source control hooks for this instance.
/// <p>The default setting will be "Locked".  Passing a '1' for the Admin parameter will set the instance to AdminLocked. 
/// <p>See <method>Locked</method> for more details.
ClassMethod Lock(Admin As %Boolean = 0) As %Status
{
	Set ^SYS("SourceControl","Locked")=$select(Admin:2,1:1)
	Quit $$$OK
}

/// Unlock the source control hooks for this instance.
ClassMethod Unlock() As %Status
{
	Set ^SYS("SourceControl","Locked")=0
	Quit $$$OK
}

/// Accessor method for accessing Perforce Credentials for current $USERNAME; returns false if no credentials were available
/// <ul>
/// <li>If there is a user-specific set of credentials defined for the current $USERNAME, these credentials will be returned</li>
/// <li>If a SharedWorkspace has been defined but there are no credentials for the current $USERSAME, then $USERNAME is returned as p4user assuming it's not a shipped Caché username
/// <li>If a SharedWorkspace has been defined, then it will be returned in the p4workspace parameter; otherwise the workspace for the credential set will be returned</li>
/// <li>If credentials exist for this specific $USERNAME, then p4passwd is returned from the the current studio process (the password stored in credentials is ignored)</li>
/// <li>If there is no data at all in ^%SYS("SourceControl","Credentials"), then the method returns 'true', assuming the Environment variables are used to store the credentials</li>
/// </ul>
ClassMethod GetCredentials(ByRef p4user As %String, ByRef p4passwd As %String, ByRef p4workspace As %String, ByRef p4dir As %String, ByRef p4port As %String) As %Boolean
{
	Set defaultUsernames=$listbuild("_SYSTEM","cacheusr","_system","Admin","CSPSystem","SuperUser","UnknownUser")
	Set login=$G(^%SYS("SourceControl","Credentials", $USERNAME),$G(^%SYS("SourceControl","Credentials"),$G(^%SYS("SourceRoot",0))))

	// Add login information, if given
	Set p4user = $LG(login,1)
	If ((p4user = "")&&(..GetSharedWorkspace())&&('$listfind(defaultUsernames,$USERNAME))) {
		// user not explicitly defined and this is a Multi-Developer environment; assuming $USERNAME is also Perforce username and password is coming from Studio prompt
		Set p4user = $USERNAME
		Set p4passwd = $System.Encryption.Base64Decode($G(%stP))
	}
	If $get(p4passwd) = "" {
		Set p4passwd = $select($listget(login,2)'="":$listget(login,2),
						$data(%stP):$System.Encryption.Base64Decode($G(%stP)),1:"")
	}
	Set p4workspace = $select(..GetSharedWorkspace(.p4workspace):p4workspace,$listget(login,3)'="":$LG(login,3),1:"")
	Set p4dir = $select(..GetSharedWorkspace("",.p4dir):p4dir,$listget(login,4)'="":$listget(login,4),1:"")
	Set p4port = $LG(login,5)
	
	#; in check for returning valid credentials, set to true if no credential global nodes are set
	Set ret=(p4user'="")||('$D(^%SYS("SourceControl","Credentials")))
	Quit ret
}

/// Accessor method for setting Perforce Credentials, returns false if credentials could not be set
/// <ul>
/// <li>If p4user is passed as a string, then it (along with the other arguments) will be the default for this instance</li>
/// <li>If p4user is of the form $LB(cacheUser, p4user), then p4user only be used when $USERNAME=cacheUser, and all other arguments will be ignored.  
///   The workspace details should be set via SetSharedWorkspace(), and the user will be prompted for the p4passwd value at runtime</li>
/// <li>If p4user is "" , then the default credentials will be cleared</li>
/// <li>If p4user is of the form $LB(cacheUser,""), then the perforce username for cacheUser will be cleared</li>
/// </ul>
ClassMethod SetCredentials(p4user As %String = "", p4passwd As %String = "", p4workspace As %String = "", p4dir As %String = "", p4port As %String = "") As %Boolean
{
	If $listvalid(p4user)&&($listlength(p4user)=2) {
		#; set up a perforce username assigned to this $USERNAME
		Set cacheuser=$listget(p4user,1), p4user=$listget(p4user,2)
		If p4user="" {
			Kill ^%SYS("SourceControl","Credentials", cacheuser)
		} Else {
			Set ^%SYS("SourceControl","Credentials", cacheuser)=$LB(p4user,p4passwd)
		}
	} Else {
		#; set default login (used most often in non-shared development environments)
		Set login=$S(p4user="":"",1:$LB(p4user,p4passwd,p4workspace,p4dir,p4port))
		If (login="") {
			ZKill ^%SYS("SourceControl","Credentials")		//just kill this node but not its subordinates
		} Else {
			Set ^%SYS("SourceControl","Credentials")=login	
		}
	}
	Quit 1
}

/// Method returns true if there are default perforce credentials defined, and false otherwise<p>
/// NOTE - if there is no credentials data stored at all, the the assumption is made that this is a 
/// single-user system that relies on environment variable for Perforce access, and 'true' will be returned
/// so that the user will not be prompted for credentials or told that none are defined.  Credentials
/// must be stored entirely in environment variables, or entirely in the DB for a given instance.
ClassMethod DefaultCredentialsDefined() As %Boolean [ CodeMode = expression ]
{
($get(^%SYS("SourceControl","Credentials"),$get(^%SYS("SourceRoot",0)))'="")||('$D(^%SYS("SourceControl","Credentials")))
}

/// Accessor method to get the Perforce Shared Workspace if it is defined; if it is not defined, the method returns false.
/// If this method returns false, then the assumption should be made that this is a single-developer instance (not shared by multiple developers).
/// <P>The method will check for the existance of a namespace-specific workspace, and will use that if it exists.  If a namespace
/// specific workspace is not defined, then it will look for an instance-wide Shared Workspace.
/// <P>This also allows a user to retrieve the stored alternate workspace directory root (-d flag in P4)
ClassMethod GetSharedWorkspace(ByRef p4workspace As %String, ByRef p4directory As %String) As %Boolean
{
	Set p4workspace=$get(^%SYS("SourceControl","SharedWorkspace",$Namespace),$Get(^%SYS("SourceControl","SharedWorkspace")))
	Set p4directory=$get(^%SYS("SourceControl","SharedWorkspace","AlternateDirectory",$Namespace),$Get(^%SYS("SourceControl","SharedWorkspace","AlternateDirectory")))
	Quit ''$data(^%SYS("SourceControl","SharedWorkspace"))
}

/// Accessor method for setting Perforce Shared Workspace; returns false if credentials could not be set
/// <P>If the <var>namespace</var> argument is not passed, then the values will be set for the entire instance.  
/// If it is passed, then the workspace and alternate workspaace directory root will be used just for that specified workspace. 
/// <P>This also allows a user to set the alternate workspace directory root (-d flag in P4)
/// <P><Strong>Important Note:</Strong> Passing <var>p4workspace</var> as "" will clear out all of the shared worspace settings, and will merge them
/// into <code>^%SYS("SourceControl","PriorSharedWorkspace")</code> for future reference.
ClassMethod SetSharedWorkspace(p4workspace As %String = "", p4directory As %String = "", namespace As %String = "") As %Boolean
{
	If p4workspace="" {
		Merge ^%SYS("SourceControl","PriorSharedWorkspace") = ^%SYS("SourceControl","SharedWorkspace")
		Kill ^%SYS("SourceControl","SharedWorkspace")
	} Else {
		//NOTE - it is not supported to define a namespace-specific Perforce workspace for a namespace called "AlternateDirectory" 
		If (namespace = "") {
			Set ^%SYS("SourceControl","SharedWorkspace")=p4workspace
			Set ^%SYS("SourceControl","SharedWorkspace","AlternateDirectory")=p4directory
		} Else {
			Set ^%SYS("SourceControl","SharedWorkspace",namespace)=p4workspace
			Set ^%SYS("SourceControl","SharedWorkspace","AlternateDirectory",namespace)=p4directory
		}
	} 
	Quit 1
}

/// Indicates whether or not this instance is configured to accomodate multiple concurrent developers
ClassMethod IsSharedDevInstance() As %Boolean [ CodeMode = expression ]
{
..GetSharedWorkspace()
}

/// Disconnect this document from source control
ClassMethod DisconnectItem(InternalName As %String) As %Status
{
	If $get(^Sources(0,"Disconnected",InternalName)) {
		Quit $$$ERROR($$$GeneralError,"Unable to disconnect an item that is already disconnected from source control")
	}
	Set filename=..ExtName(InternalName)
	If filename="" Quit $$$ERROR($$$GeneralError,"No external file found for '"_InternalName_"' so can not disconnect")
	If '##class(%File).Exists(filename) Quit $$$ERROR($$$GeneralError,"File "_filename_" not found, so nothing to disconnect")
	Kill ^Sources(0,"FileTimeStamp",InternalName)
	Kill ^Sources(0,"ItemTimeStamp",InternalName)
	Set ^Sources(0,"Disconnected",InternalName)=1
	Write !,"Item '",InternalName,"' disconnected from source control file '",filename,"'"
	Quit $$$OK
}

/// Reconnect this document from source control
ClassMethod ReconnectItem(InternalName As %String) As %Status
{
	If '$get(^Sources(0,"Disconnected",InternalName)) {
		Quit $$$ERROR($$$GeneralError,"Unable to reconnect an item that is not disconnected from source control")
	}
	Kill ^Sources(0,"Disconnected",InternalName)
	Set filename=..ExtName(InternalName)
	If filename="" Quit $$$ERROR($$$GeneralError,"No external file found for '"_InternalName_"' so can not reconnect")
	If '##class(%File).Exists(filename) Quit $$$ERROR($$$GeneralError,"File "_filename_" not found, so nothing to reconnect")
	Write !,"Item '",InternalName,"' reconnected to source control file '",filename,"'"
	Quit ..Load(InternalName)
}

ClassMethod IsGenerated(InternalName As %String) As %String
{
	If $get(^Sources(0,"Disconnected",InternalName)) Quit 1
	Quit ""
}

/// Return true if this item is mapped from a database other than the default routine database.
/// Also return the source database in <var>sourcedb</var>.
/// <p>NOTE: This is available as %RoutineMgr::IsMapped() in 2013.1 and later; it is included in this class to support the source hooks working on earlier versions
ClassMethod IsMapped(name As %String, ByRef sourcedb As %String)
{
	If (..InstanceVersion()>=2013.1) {
		Quit ##class(%RoutineMgr).IsMapped(name,.sourcedb)
	}
	Set name=##class(%RoutineMgr).NormalizeName(name),nm=$piece(name,".",1,$length(name,".")-1)
	Set sourcedb=$namespace
	If nm="" Quit 0
	Set ext=$zconvert($piece(name,".",$length(name,".")),"U")
	If ##class(%RoutineMgr).IsCSPName(name) {
		Quit 0
	} ElseIf $$$rtnIsMAC(ext) {
		Set sourcedb=$$getdest^%SYS.GXLINF1($namespace,"rMAC","("""_nm_""")")	
		Quit sourcedb'=$$getdest^%SYS.GXLINF1($namespace,"rMAC")				
	} ElseIf $$$rtnIsINT(ext) {
		Set sourcedb=$$getdest^%SYS.GXLINF1($namespace,"ROUTINE","("""_nm_""")")
		Quit sourcedb'=$$getdest^%SYS.GXLINF1($namespace,"ROUTINE")				
	} ElseIf $$$rtnIsINC(ext) {
		Set sourcedb=$$getdest^%SYS.GXLINF1($namespace,"rINC","("""_nm_""")")	
		Quit sourcedb'=$$getdest^%SYS.GXLINF1($namespace,"rINC")				
	} ElseIf ext="CLS" {
		Set sourcedb=$$getdest^%SYS.GXLINF1($namespace,"oddDEF","("""_nm_""")")	
		Quit sourcedb'=$$getdest^%SYS.GXLINF1($namespace,"oddDEF")				
	} ElseIf ext="PRJ" {
		Quit 0
	}
	Quit 0
}

/// This method exports all Classes, Routines, Include files, CSP Application files, and Projects files from a namespace into a file structure that can then be added to Source Control<P>
/// This should be run from the terminal, and the user will be prompted as to whether they want to export to the current ^Sources location or an alternate location (alternate is recommended).<P>
/// The method will then iterate through all Classes, Routines, Include files, CSP Application files and Projects and will export them to ^Sources based on the mappings in the ^Sources global.<P>
/// NOTE - this does not export "Generated" classes <p>
/// Passing <var>classesOnly</var> as '1' will export only the baseline of the classes.  This is useful for exporting all updated XML after changing to a new class compiler version.<p>
/// Pass <var>interactive</var> as 0 in order to call this programmatically<p>
/// Pass <var>targetDirectory</var> to specify the directory for export (NOTE - this cannot equal ^Sources for TrakCare exports)<p>
/// Pass boolean <var>changeToReadOnly</var> to control whether the files should be changed to read-only after export (defaults to true)<p>
/// Pass boolean <var>includeMapped</var> to control whether items mapped from other databases should be included in the export (defaults to true)
/// The default value for this argument will be the inverse of the source hooks LockMapped setting for this namespace (so if nothing is set, then Mapped will be included by default) <p>
ClassMethod BaselineExport(classesOnly As %Boolean = 0, interactive = 1, targetDirectory = {$get(^Sources)}, changeToReadonly As %Boolean = 1, includeMapped As %Boolean = {'$get(^SYS("SourceControl","Misc","LockMapped"))}) As %Status
{
	Set name="", keepSources=0, answer="", err=""
	If ('$Data(^Sources))&&($length(targetDirectory)=0) {
		If ('interactive) {
			Set msg="Aborting - ^Sources must be defined or 'targetDirectory' must be passed to run this non-interactively"
			Write !,msg
			Quit $$$ERROR($$$GeneralError,msg)
		}
		While ((name="")||('##class(%File).DirectoryExists(name))) {
			Read !,"Enter full directory to export files to: ", name
			Do ##class(%File).CreateDirectoryChain(name)
		}
		Set name=##class(%File).NormalizeDirectory(name)
		Set ^Sources=name
		Set ^Sources("/CSP/","*")="cspapp/"
		Set ^Sources("CLS","*")="cls/"
		Set ^Sources("MAC","*")="rtn/"
		Set ^Sources("INC","*")="inc/"
		Set ^Sources("PRJ","*")="prj/"
		Set ^Sources("RUL","*")="rul/"
		Set ^Sources("DFI","*")="ds/"
	} Else {
		#; Save existing ^Sources global and restore it afterwards
		Write !,"Exporting current ^Sources global so it can be later restored",!
		Set sc=$system.OBJ.Export("Sources.GBL","sources.xml",,.err), keepSources=1
		If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
		If err'="" Write !,err
		Quit:('sc)||(err'="") sc
		#; Clear timestamp information so that all exports succeed
		Kill ^Sources(0,"FileTimeStamp")
		Kill ^Sources(0,"ItemTimeStamp")
		Write !,"Current export directory: "_targetDirectory
		Write !,"NOTE: Export of files will fail if Readonly files already exist"
		If (..IsTrakCare()){
			Write !,!,$c(27,91,55,109),"WARNING:",$c(27,91,109)," This appears to be a TrakCare namespace.  You must ensure TrakCare"
			Write !,"product classes are properly removed from the export structure before you"
			Write !,"submit anything to Perforce.  A different export directory will be used."
			Set answer="NO"
			If ('interactive)&&(targetDirectory=^Sources) {
				Set msg="Aborting - you must pass in a targetDirectory that is not equal to ^Sources for TrakCare instances."
				Write !,msg
				Quit $$$ERROR($$$GeneralError,msg)
			}
		}
		If (interactive) {
			While ((answer="")||("YyNnQq"'[$extract(answer,1,1))) {Read !,"Use this directory for export? (Y/N) ",answer}
			If "QUIT"[$zconvert(answer,"U") {
				Quit $$$OK
			} ElseIf "NO"[$zconvert(answer,"U") {
				Set sc=0, err=""
				While (name=""||'##class(%File).DirectoryExists(name)) {
					Read !,"Enter full directory path to export files to: ", name
					Do ##class(%File).CreateDirectoryChain(name)
				}
				Set name=##class(%File).NormalizeDirectory(name)
				Set ^Sources=name
			} Else {
				Set ^Sources=targetDirectory	
			}
		} Else {
			Set name=targetDirectory
			Do ##class(%File).CreateDirectoryChain(name)
			Set name=##class(%File).NormalizeDirectory(name)
			Set ^Sources=name
		}
	}
	If (interactive) {
		Set answer=""
		If ($get(^SYS("SourceControl","Misc","LockMapped"))) { Write !,"NOTE: Mapped items are configured as Locked in source control in this namespace" }
		While((answer="")||("YyNn"'[$extract(answer,1,1))) { Read !,"Include items mapped from other databases in Export? (Y/N) ",answer }
		If ("NO"[$zconvert(answer,"U")) { 
			Set includeMapped=0
		} Else {
			Set includeMapped=1
		}
	}
	Set includeMapped=''includeMapped		;# ensure includeMapped is 1 or 0

	If (interactive) {
		Set answer=""
		While((answer="")||("YyNn"'[$extract(answer,1,1))) { Read !,"Change files to Readonly after Export? (Y/N) ",answer }
		If ("NO"[$zconvert(answer,"U")) { 
			Set changeToReadonly=0
		} Else {
			Set changeToReadonly=1
		}
	}
	Set changeToReadonly=''changeToReadonly		;# ensure changeToReadOnly is 1 or 0

	If (interactive) {
		Set answer=""
		While((answer="")||("YyNn"'[$extract(answer,1,1))) { Read !,"Start Export? (Y/N) ",answer }
		If ("NO"[$zconvert(answer,"U")) { 
			If keepSources=1 Set sc=$system.OBJ.Load("sources.xml")
			Quit sc
		}
	}
	#; turn off SrcVer additions to it doesn't make the classes out of date
	If ($data(^SYS("SourceControl","Misc","InsertSrcVer"))#2) {
		Set oldInsertSrcVer=^SYS("SourceControl","Misc","InsertSrcVer")
		Kill ^SYS("SourceControl","Misc","InsertSrcVer")
	}

	If $isobject($get(%SourceControl)) {
		Write !,"Using existing Source Control object",!
	} Else {
		Write !,"Creating Source Control Object..."
		Set sc=##class(%Studio.SourceControl.Interface).SourceControlCreate("","",.created)
		If created {
			Write "Success!",!
		} Else {
			Do $system.OBJ.DisplayError(sc)
			Write !,"Failed!  Quiting BaselineExport().",! Quit $$$ERROR($$$GeneralError,"Could not create Source Control Object")
		}
	}
	Write !,"Exporting Classes..."
	Set sc = $$$OK
	Set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sql="SELECT ID FROM %Dictionary.ClassDefinition "
	Set excludeClasses = "ID %STARTSWITH 'csr.csp.' OR ID %STARTSWITH '%' OR ID %STARTSWITH 'CSPX.' OR ID %STARTSWITH 'Ens.' OR ID %STARTSWITH 'EnsLib.' OR ID %STARTSWITH 'EnsPortal.'"
	If (..IsTrakCare()) {
		Write !,"TrakCare Namespace detected. Skipping the following Packages:"
		Write !,"    Report.*"
		Write !,"    TC.*"
		Write !,"    websys.*"
		Write !,"    questionnaire.*"
		Write !,"    Custom.Report.ZEN.questionnaire.* (see LogTrak 83604)"
		Set excludeClasses = excludeClasses_" OR ID %STARTSWITH 'Report.' OR ID %STARTSWITH 'TC.' OR ID %STARTSWITH 'websys.' OR ID %STARTSWITH 'questionnaire.' OR ID %STARTSWITH 'Custom.Report.ZEN.questionnaire.'"
	}
	Set sql=sql_"WHERE NOT ("_excludeClasses_") "
	Set sql=sql_"AND GeneratedBy IS Null AND Deployed = 0"
	Do rs.Prepare(sql)
	If (rs.%SQLCODE<0) {
		Write !,"Cannot query Class Dictionary: "_$system.SQL.SQLCODE(rs.%SQLCODE)_" ("_rs.%SQLCODE_")"
	}
	Do rs.Execute()
	While rs.Next() {
		Set item = rs.Data("ID") _ ".CLS"
		Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
		If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
	}
	Do rs.Close()
	Set rs=""
	
	If (classesOnly) {
		Write !,!,"classesOnly argument was 1 (true).  Export of the following was skipped:"
		Write !,"  Routines"
		Write !,"  Include Files"
		Write !,"  Ensemble Rules"
		Write !,"  Ensemble Lookup Tables"
		Write !,"  Ensemble HL7 Schemas"
		Write !,"  DeepSee Folder Items"
		Write !,"  CSP Applications"
		Write !,"  Projects"
	} Else {
		Write !,!,"Exporting Routines..."
		Write !,"NOTE - Ens* routines are skipped by default."
		Set sc = $$$OK
		Set rs = ##class(%ResultSet).%New("%Routine.RoutineList")
		Do rs.Execute("*.MAC")
		While rs.Next() {
			Continue:rs.Data("Size")=0
			Set item=rs.Data("Name")
			#; ignore auto-generated code generators
			Continue:((item[".G1.MAC")||(item[".G2.MAC"))
			#; ignore auto-generated object/SQL filers
			Continue:((item[".T1.MAC")||(item[".T2.MAC"))
			#; ignore auto-generated SQL routines
			Continue:(item["CacheSql")
			#; ignore auto-generated SQL export routines
			Continue:(item["SQLExport")
			#; ignore mapped Ens* routines
			Continue:($extract(item,1,3)="Ens")
			#; ignore auto-generated Ensemble Routing Rule routines
			Continue:(item["RuleCache.R")
			#; ignore auto-generated TrakCare Component routines
			Continue:($extract(item,1,4)="GCOM")
			Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
			If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
		}
		Do rs.Close()
		Set rs=""
		Write !,!,"Exporting Include Files..."
		Write !,"NOTE - Ens* include files are skipped by default."
		Set sc = $$$OK
		Set rs = ##class(%ResultSet).%New("%RoutineMgr:StudioOpenDialog")
		Do rs.Execute("*.INC",,,,1,,0)
		While rs.Next() {
			#; skip directories
			Continue:rs.Data("Type")=9
			Continue:rs.Data("Size")=0
			Set item=rs.Data("Name")
			#; ignore mapped Ens* include files
			Continue:($extract(item,1,3)="Ens")
			#; if TrakCare instance, ignore list of standard TrakCare include files (until they become Generated and all can be automatically ignored)
			If (..IsTrakCare()) {
				Set trakINCs=$listbuild("aUTIL1.inc","CHARPAD.inc","SSSYSTEM.inc","SSTP.inc","tkimport.inc","TRAK.inc","webgen.inc","webimport.inc","webSSUserDefWindow.inc","webtrace.inc","webutils.inc","ZCDL.inc","External.hic.OnlineClaim.inc","External.hic.OnlineClaimLogging.inc","External.hic.OnlineClaimUtils.inc","External.hic.OnlineClaimWrapper.inc","web.CDA.inc","websys.SNMP.inc","websys.DataDict.Abstract.inc","Studio.SourceControl.IST.inc","XML.Element.inc")
				Continue:($listfind(trakINCs,item))
			}
			Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
			If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
		}
		Do rs.Close()
		Set rs=""
		If ##class(%Dictionary.CompiledClass).%ExistsId("Ens.Rule.RuleDefinition") {
			Write !,!,"Exporting Ensemble Rules..."
			Set sc = $$$OK
			Set rs = ##class(%ResultSet).%New("Ens.Rule.RuleDefinition:EnumerateRules")
			Do rs.Execute()
			While rs.Next() {
				Set package=rs.Data("Package")
				Set name=rs.Data("Name")
				Set item=package_"."_name_".RUL"
				Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
				If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
			}
			Do rs.Close()
			Set rs=""
		}
		Set rs=""
		If ##class(%Dictionary.CompiledClass).%ExistsId("Ens.Util.LookupTableDocument") {
			// only supported in Ensemble 2012.1+
			Write !,!,"Exporting Ensemble Lookup Tables..."
			Set sc = $$$OK
			Set rs = ##class(%ResultSet).%New("Ens.Util.LookupTableDocument:List")
			Do rs.Execute()
			While rs.Next() {
				Set item=rs.Data("name")
				Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
				If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
			}
			Do rs.Close()
			Set rs=""
		}
		If ##class(%Dictionary.CompiledClass).%ExistsId("EnsLib.HL7.SchemaDocument") {
			Write !,!,"Exporting Ensemble HL7 Schemas..."
			Set sc = $$$OK
			Set rs = ##class(%ResultSet).%New("EnsLib.HL7.SchemaDocument:List")
			Do rs.Execute()
			While rs.Next() {
				Set item=rs.Data("name")
				Continue:$listfind($lb("2.1.HL7","2.2.HL7","2.3.HL7","2.4.HL7","2.5.HL7","2.6.HL7","2.7.HL7","2.3.1.HL7","2.5.1.HL7","2.7.1.HL7","ITK.HL7")
									,item)
				Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
				If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
			}
			Do rs.Close()
			Set rs=""
		}
		If ##class(%Dictionary.CompiledClass).%ExistsId("%DeepSee.UserLibrary.Utils") {
			Write !,!,"Exporting DeepSee Folder Items..."
			Set sc=##class(%DeepSee.UserLibrary.Utils).%GetFolderItemList(.itemList,,1)
			Set pointer=$order(itemList(""),1,itemID)
			While (pointer'="") {
				Set tItem=##class(%DeepSee.UserLibrary.FolderItem).%OpenId(itemID)
				If $isobject(tItem) {
					If ##class(%Dictionary.CompiledClass).%ExistsId("%DeepSee.UI.FolderItemDocument") {
						Try {
							Set item=tItem.documentName
						} Catch err {
							If err.Name="<PROPERTY DOES NOT EXIST>" {
								// no calculated translation available so hardcode the applicable document name
								Set item=$TR(tItem.fullName,"/","-")_".DFI"
							} Else {
								Do $system.OBJ.DisplayError(err.AsStatus()) Quit 
							}
						}
						If (item["$TRASH") {
							; Exclude pivots deleted via the User Portal
							Write !,"Skipping item in $TRASH: '"_item_"'"
							Set pointer=$order(itemList(pointer),1,itemID)
							Continue	
						}
						If ((..IsTrakCare())&&(%SourceControl.Name(item)["/Trak_")) {
							; Exclude core Trak dashboards
							Write !,"Skipping core TrakCare Dashboard '"_item_"'"
							Set pointer=$order(itemList(pointer),1,itemID)
							Continue
						}
						Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
						If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
					} Else {
						//earlier version of DSII which could not be exported via $system.OBJ APIs; export in custom %DeepSee format
						Set item=tItem.fullName
						Set tShortName = $translate(item,"/ .","-_-")
						Set subdir = ##class(%File).NormalizeDirectory(^Sources_"dsi")
						Do ##class(%File).CreateDirectoryChain(subdir)
						Set tFile = ##class(%File).NormalizeFilename(subdir_tShortName_".xml") 
						Write !,"Exporting '"_item_"' to file '"_tFile
						Set sc=##class(%DeepSee.UserLibrary.Utils).%Export(item,tFile)
					}
				}
				Set pointer=$order(itemList(pointer),1,itemID)
			}
		}
		Write !,!,"Exporting CSP Applications..."
		Set sc = $$$OK
		Set rs = ##class(%ResultSet).%New("%CSP.Apps:CSPAppList")
		Do rs.Execute()
		Set cspPaths=""
		While rs.Next() {
			Set app = rs.Data("AppUrl")
			Continue:app["itemsetsourcelink"
			Set curns=$ZU(5)
			#; Query %SYS to find the physical path for this csp application
			zn "%SYS"
			Set rsc=##class(%ResultSet).%New("Security.Applications:Detail")
			Do rsc.Execute(app)
			Do rsc.Next()
			Set path=rsc.Data("Path")
			If (path="") {
				Write !,!,"CSP Application "_app_" has a NULL CSP Files Physical Path; skipping export",!
				Do rsc.Close()
				Set rsc=""
				zn curns
				Continue
			}
			Set path=##class(%File).NormalizeDirectory(path)
			Do rsc.Close()
			Set rsc=""
			zn curns
			If $data(cspPaths(path)) {
				Write !,!,"Skipping export of CSP Application: "_app,!
				Write "Directory: "_path,!,"Has already been exported as part of "_cspPaths(path),!
			} Else {
				Set cspPaths(path)=app
				Write !,!,"Exporting CSP Application: "_app,!,"From directory: "_path
				Set excludeEnsemble=1
				Do %SourceControl.BaselineCSPDir(path,path,app,changeToReadonly,excludeEnsemble)
			}
		}
		Do rs.Close()
		Set rs=""
		Write !,!,"Exporting Projects (skipping ItemSet Projects)..."
		Set sc = $$$OK
		Set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		Set sql="SELECT ID FROM %Studio.Project WHERE NOT (ID %STARTSWITH 'Default_')"
		Do rs.Prepare(sql)
		Do rs.Execute()
		While rs.Next() {
			Set item = rs.Data("ID") _ ".PRJ"
			Continue:(($length(item,"_")=4)&&($piece(item,"_")?4A4.6N))		; skip if of the form AAAA####_foo_foo_foo
			Set sc=%SourceControl.BaselineExportItem(item,changeToReadonly,,includeMapped)
			If $$$ISERR(sc) Do $System.Status.DisplayError(sc) Quit
		}
		Do rs.Close()
	}
	Set exportDir=^Sources
	If keepSources=1 {
		Kill ^Sources 
		Write !,!,"Restoring original ^Sources global"
		If ..Locked() Set lockflag = (..Locked()-1) 		; capture flag to use when resetting Source Control log; 0 will indicate regular lock and 1 is AdminLocked
		Do ..Unlock()
		Set sc=$system.OBJ.Load("sources.xml")
		If $data(lockflag) Do ..Lock(lockflag)			; will pass 0 for regular or 1 for AdminLock
	}
	If $data(oldInsertSrcVer) {
		Set ^SYS("SourceControl","Misc","InsertSrcVer")=oldInsertSrcVer
	}
	Write !,"BaselineExport is complete and the namespace contents have been exported to:"
	Write !,"   ",exportDir
	Write !,"Please move these files to a p4 client and check them into Perforce to populate"
	Write !,"your branch."
	Quit sc
}

/// Export the contents of a CSP directory
Method BaselineCSPDir(dir As %String, appDir As %String, app As %String, ToReadOnly As %Boolean = 0, useEnsembleExclusionlist As %Boolean = 0)
{
	Set rso=##class(%ResultSet).%New("%File:FileSet")
	If (useEnsembleExclusionlist) { Set excludeList=..BaselineExportEnsembleExclude() }
	Do rso.Execute(dir,,,1,)
	While rso.Next() {
		Set name=rso.Data("Name")
		If (rso.Data("Type")="D") {
			Do ..BaselineCSPDir(name,appDir,app,ToReadOnly,useEnsembleExclusionlist)
		} Else {	
			#; Export csp where internal name like "/csp/namespace/filname.csp" or "/cspapplication/filename.csp"
			Set name=$translate(name,"\","/")
			Set file=$extract(name,$length(appDir),$length(name))
			If (useEnsembleExclusionlist) {
				If $listfind(excludeList,file) {
					// this is on the 'blacklist' for Ensemble, so skip it
					Continue
				}
			}
			If (..IsTrakCare()) {
				Set excludeTrakFolders = $listbuild("/trakcare/web/addins/",
													"/trakcare/web/csp/",
													"/trakcare/web/images/",
													"/trakcare/web/reports/",
													"/trakcare/web/scripts/",
													"/trakcare/web/scripts_gen/",
													"/trakcare/web/styles/")
				Set ptr=0, folderValue="", trakMatch=0
				While $listnext(excludeTrakFolders,ptr,folderValue) {
					If (app_file[folderValue) {
						Write !,"Skipping core TrakCare file "_app_file
						Set trakMatch=1
						Quit	; quit out of this While loop because a match has been found
					}
				}
				If (trakMatch) { Continue }
			}
			Set name=app_file
			Do ..BaselineExportItem(name,ToReadOnly)
		}
	}
	Do rso.Close()
	Set rso=""
	Quit
}

/// Exports a specific item<br/>
/// If <var>ToReadOnly</var> is true, then the files will be manually changed to ReadOnly afterwards (for use when exporting from LIVE and leaving items uneditable afterwards)<br/>
/// If <var>CheckOut</var> is true, then the Source Control CheckOut/AddToSourceControl logic is used
/// If <var>includeMapped</var> is true, then items mapped from other DBs will be exported, otherwise they will be skipped.  
/// The default value for this argument will be the inverse of the source hooks LockMapped setting for this namespace (so if nothing is set, then Mapped will be included by default)
Method BaselineExportItem(InternalName As %String, ToReadOnly As %Boolean = 0, CheckOut As %Boolean = 0, includeMapped As %Boolean = {'$get(^SYS("SourceControl","Misc","LockMapped"))}) As %Status
{
	New %SourceControl
	Set sc=$$$OK
	If ($get(InternalName)="") { Quit $$$ERROR($$$GeneralError,"InternalName is a required field") }
	If ('includeMapped)&&(..IsMapped(InternalName)) {				; in 2013.1 and later, replace with ##class(%RoutineMgr).IsMapped(InternalName)
		Write !,"'"_InternalName_"' is mapped from another database; skipping this item"
		Quit $$$OK
	}
	If (CheckOut) {
		Set (CheckOutEnabled, AddEnabled, UndoEnabled) = 1
		Set sc=..OnMenuItem("%SourceMenu,%CheckOut", InternalName, , .CheckOutEnabled) 
		If $$$ISERR(sc) Quit sc
		Set sc=..OnMenuItem("%SourceMenu,%AddToSourceControl", InternalName, , .AddEnabled) 
		If $$$ISERR(sc) Quit sc
		Set sc=..OnMenuItem("%SourceMenu,%UndoCheckout", InternalName, , .UndoEnabled) 
		If $$$ISERR(sc) Quit sc
		If (CheckOutEnabled) {
			Set sc=..CheckOut(InternalName,,0)
			Set sc=..OnAfterSave(InternalName)
		} ElseIf (AddEnabled) {
			Set sc=..AddToSourceControl(InternalName)	
		} ElseIf (UndoEnabled) {
			Set sc=..OnAfterSave(InternalName)	//since Undo is enabled, it is already checked out so just try to export it again
		} Else {
			Set sc=$$$ERROR($$$GeneralError,"Cannot find any valid checkout options for "_InternalName)
		}
	} Else {
		Set filename = ..ExtName(InternalName)
		If filename="" Quit $$$ERROR($$$GeneralError,"Unable to find mapping where item '"_InternalName_"' should go")
	    #; If file not there create a blank file now
	    Do ##class(%File).CreateDirectoryChain(##class(%File).GetDirectory(filename))
	    If '##class(%File).Exists(filename) {
		    Open filename:"NW":0 Close filename
	        If '##class(%File).Exists(filename) Quit $$$ERROR($$$GeneralError,"Unable to create file '"_filename_"'")
		}
	    #; export document
		Set sc=..OnAfterSave(InternalName)
	    If $$$ISERR(sc) Quit sc
	    If ToReadOnly {
		    Set sc=##class(%File).SetReadOnly(filename)
	    }
	}
    Quit sc
}

/// Earlier versions of Ensemble physically copied files into newly created csp applications; these need to be enumerated so they can be skipped by BaselineExport()
Method BaselineExportEnsembleExclude() As %String [ CodeMode = expression ]
{
$listbuild(
				"/ASTM/ASTMSchemaCodeTable.csp",
				"/ASTM/ASTMSchemaComponentStructure.csp",
				"/ASTM/ASTMSchemaDocumentStructure.csp",
				"/ASTM/ASTMSchemaList.csp",
				"/ASTM/ASTMSchemaMain.csp",
				"/ASTM/ASTMSchemaPath.csp",
				"/ASTM/ASTMSchemaRawStructure.csp",
				"/ASTM/ASTMSchemaSegmentStructure.csp",
				"/EDIDocumentView.csp",
				"/EnsEntHL7Search.csp",
				"/EnsEntLog.csp",
				"/EnsEntMessages.csp",
				"/EnsEntMsgDetails.csp",
				"/EnsEntMsgEditResend.csp",
				"/EnsEntMsgResend.csp",
				"/EnsEntMsgTrace.csp",
				"/HL7/HL7SchemaCodeTable.csp",
				"/HL7/HL7SchemaDataStructure.csp",
				"/HL7/HL7SchemaList.csp",
				"/HL7/HL7SchemaMain.csp",
				"/HL7/HL7SchemaMessageStructure.csp",
				"/HL7/HL7SchemaMessageType.csp",
				"/HL7/HL7SchemaPath.csp",
				"/HL7/HL7SchemaRawStructure.csp",
				"/HL7/HL7SchemaSegmentStructure.csp",
				"/SEF/EDISchemaMain.csp",
				"/UtilEnsAbort.csp",
				"/UtilEnsActivityGraph.csp",
				"/UtilEnsBPDefinition.csp",
				"/UtilEnsBPInstances.csp",
				"/UtilEnsBPList.csp",
				"/UtilEnsBPPurge.csp",
				"/UtilEnsBPViewer.csp",
				"/UtilEnsBusinessMetricProperties.csp",
				"/UtilEnsBusinessMetrics.csp",
				"/UtilEnsConfig.csp",
				"/UtilEnsCounters.csp",
				"/UtilEnsCredentials.csp",
				"/UtilEnsCredentialsEditor.csp",
				"/UtilEnsDTLDefinition.csp",
				"/UtilEnsDTLList.csp",
				"/UtilEnsDashboard.csp",
				"/UtilEnsDashboardList.csp",
				"/UtilEnsDashboardView.csp",
				"/UtilEnsDebug.csp",
				"/UtilEnsEDIMain.csp",
				"/UtilEnsEntHL7Search.csp",
				"/UtilEnsFindMsgBank.csp",
				"/UtilEnsHome.csp",
				"/UtilEnsHostWizard.csp",
				"/UtilEnsJobs.csp",
				"/UtilEnsLog.csp",
				"/UtilEnsLogPurge.csp",
				"/UtilEnsLogout.csp",
				"/UtilEnsMA.csp",
				"/UtilEnsMAPurge.csp",
				"/UtilEnsMessages.csp",
				"/UtilEnsMonitor.csp",
				"/UtilEnsMsgCompare.csp",
				"/UtilEnsMsgDetails.csp",
				"/UtilEnsMsgEdit.csp",
				"/UtilEnsMsgEditResend.csp",
				"/UtilEnsMsgPurge.csp",
				"/UtilEnsMsgResend.csp",
				"/UtilEnsMsgSearch.csp",
				"/UtilEnsMsgTrace.csp",
				"/UtilEnsProductionDelete.csp",
				"/UtilEnsProductionModel.csp",
				"/UtilEnsProductionWizard.csp",
				"/UtilEnsProductions.csp",
				"/UtilEnsPubSubDomainEdit.csp",
				"/UtilEnsPubSubDomains.csp",
				"/UtilEnsQList.csp",
				"/UtilEnsQueues.csp",
				"/UtilEnsRoutingRuleEditor.csp",
				"/UtilEnsRoutingRuleList.csp",
				"/UtilEnsRoutingRulePopup.csp",
				"/UtilEnsRuleEditor.csp",
				"/UtilEnsRuleList.csp",
				"/UtilEnsRuleLog.csp",
				"/UtilEnsRuleLogPurge.csp",
				"/UtilEnsRuleOpEdit.csp",
				"/UtilEnsRuleSameNameList.csp",
				"/UtilEnsSesSuspended.csp",
				"/UtilEnsSubscriberEdit.csp",
				"/UtilEnsSubscribers.csp",
				"/UtilEnsSubscriptionEdit.csp",
				"/UtilEnsSubscriptions.csp",
				"/UtilEnsTestingService.csp",
				"/UtilEnsTestingService1.csp",
				"/UtilEnsTestingService2.csp",
				"/UtilEnsTestingService3.csp",
				"/UtilEnsTooltipPopup.csp",
				"/UtilHome.csp",
				"/UtilLogin.csp",
				"/WFHome.csp",
				"/WFRoleBrowser.csp",
				"/WFRoleEditor.csp",
				"/WFRoleMembers.csp",
				"/WFRoles.csp",
				"/WFRolesForUser.csp",
				"/WFTaskAssign.csp",
				"/WFTasklist.csp",
				"/WFTasks.csp",
				"/WFTasksForRole.csp",
				"/WFTasksForUser.csp",
				"/WFUserEditor.csp",
				"/WFUsers.csp",
				"/WFUsersForRole.csp",
				"/WFWorklist.csp",
				"/cspchart.js",
				"/cspgraph.svg",
				"/csputilcookie.js",
				"/csputils.css",
				"/csputilsplain.css",
				"/ensbpl.js",
				"/ensbplcanvas.svg",
				"/ensbpleditor.html",
				"/ensbplshapes.js",
				"/ensdtl.js",
				"/ensdtlcanvas.svg",
				"/ensdtleditor.html",
				"/ensdtlparser.js",
				"/ensrules.js",
				"/enssvg.js",
				"/enstracelegend.html",
				"/enstracelegend.svg",
				"/ensxml.js",
				"/images/InspectorWater256.jpg",
				"/images/add_24.gif",
				"/images/arrow_down.gif",
				"/images/arrow_left.gif",
				"/images/arrow_left2.gif",
				"/images/arrow_right.gif",
				"/images/arrow_right2.gif",
				"/images/arrow_up.gif",
				"/images/back_24.gif",
				"/images/backtriangle.gif",
				"/images/binoculars_24.gif",
				"/images/browse.gif",
				"/images/browse_gray.gif",
				"/images/browse_grayhi.gif",
				"/images/browsehi.gif",
				"/images/clock_24.gif",
				"/images/close_a_24.gif",
				"/images/delete_24.gif",
				"/images/diskette_24.gif",
				"/images/down_24.gif",
				"/images/hidehi.gif",
				"/images/intersys_ensemble.jpg",
				"/images/minus.gif",
				"/images/next_24.gif",
				"/images/nexttriangle.gif",
				"/images/offer_a_add_24.gif",
				"/images/ok_24.gif",
				"/images/plus.gif",
				"/images/spacer.gif",
				"/images/trash_24.gif",
				"/images/up_24.gif",
				"/images/write_24.gif",
				"/productionModel.svg",
				"/svgcheck.js",
				"/svgcheck.vbs",
				"/svggrid.js",
				"/wizard.css",
				"/xsl/DocBookPDFSimple.xsl",
				"/xsl/Ensemble.jpg",
				"/xsl/InterSystems.jpg",
				"/xsl/ProductionDocBookCommon.xsl",
				"/xsl/ProductionDocBookHTML.xsl",
				"/xsl/ProductionDocBookPDF.xsl",
				"/xsl/winansi.entities"
				)
}

/// The initial implementation of DS II did not include source control hooks in the UI, so it is necessary 
/// to do check-out / export DSII classes and Folder Items just prior to submitting the changes to Perforce.<br/>
/// DSCheckpointExport() will check for the last time that DSCheckpointExport() was run, and will check out and export
/// all changes DS II items since that timestamp.  This should work for both Connected and Disconnected instances.</br>
/// If <var>ListOnly</var> is true, then a list will be displayed but nothing will actually be checked out.<br/>
/// If <var>AddNew</var> is true, then all items which are not yet on disk in the local workspace will be marked for 'add'
/// and exported, otherwise, only those already on disk will be exported.<br/>
/// If <var>ExportAll</var> is true, then the timestamp from the previous export will be ignored and all DeepSee work 
/// that is in Source Control will be checked out.<br/>
/// If <var>Interactive</var> is true, then the user will be prompted for their Perforce password if it is a Connected instance<br/>
ClassMethod DSCheckpointExport(ListOnly As %Boolean = 0, AddNew As %Boolean = 1, ExportAll As %Boolean = 0, Interactive As %Boolean = 1) As %Status
{
	Set sc=$$$OK
	If ('##class(%Dictionary.CompiledClass).%ExistsId("%DeepSee.UserLibrary.Utils")) {
		Write "Error - DeepSee packages not found; exiting method",!
		Quit $$$ERROR($$$GeneralError,"DeepSee not installed")
	}
	Write "This method will check out and export DeepSee II items for source control.",!
	Set beginTime=$get(^SYS("SourceControl","Misc","LastDSCheckpoint"),0)
	Set newTime=$h
	If (ExportAll) Set beginTime=0
	If (beginTime=0) {
		Write "Exporting all DeepSee II classes and Folder Items in the namespace",!
	} Else {
		Write "Exporting any DeepSee II classes and Folder Items which have changed since:",!
		Write "   "_$zdatetime(beginTime,3)_" (from ^SYS(""SourceControl"",""Misc"",""LastDSCheckpoint""))",!
	}
	Set itemList=""
	
	For superClass="%DeepSee.CubeDefinition","%DeepSee.SubjectArea" {
		Write !,"Finding all subclasses of "_superClass_"...",!
		Set rset = ##class(%ResultSet).%New("%Dictionary.ClassDefinitionQuery:SubclassOf")
		Set sc=rset.Execute(superClass)
		While (rset.Next()) {
			Set subclass=rset.Data("Name")
			Set classObj=##class(%Dictionary.ClassDefinition).%OpenId(subclass,,.sc)
			If $$$ISOK(sc) {
				Set timeChanged=classObj.TimeChanged
				If $system.SQL.DATEDIFF("s",beginTime,timeChanged) > 0 {
					Set subclass=subclass_".CLS"
					Write "   "_subclass_" (changed "_$zdatetime(timeChanged,3)_")",!
					Set itemList=itemList_$listbuild(subclass)
				}
			} Else {
				Write "Error when trying to open Object Definition '"_subclass_"' (skipping this item): "_$system.Status.GetErrorText(sc),!
			}
		}
	}
	
	Write !,"Finding all DeepSee Folder Items...",!
	Set sc=##class(%DeepSee.UserLibrary.Utils).%GetFolderItemList(.itemList,,1)
	Set pointer=$order(itemList(""),1,itemID)
	While (pointer'="") {
		Set tItem=##class(%DeepSee.UserLibrary.FolderItem).%OpenId(itemID)
		If $isobject(tItem) {
			Set timeChangedUTC=$zdatetimeh(tItem.timeModified,3)
			Set timeChanged=$zdatetimeh(timeChangedUTC,-3)
			If $system.SQL.DATEDIFF("s",beginTime,timeChanged) > 0 {
				If (tItem.fullName["$TRASH/") {
					Set skippedList=$get(skippedList)_$listbuild("   SKIPPED: "_tItem.fullName_" (changed "_$zdatetime(timeChanged,3)_")")
				} Else {
					Write "   "_tItem.fullName_" (changed "_$zdatetime(timeChanged,3)_")",!
					If ##class(%Dictionary.CompiledClass).%ExistsId("%DeepSee.UI.FolderItemDocument") {
						Try {
							Set item=tItem.documentName
						} Catch err {
							If err.Name="<PROPERTY DOES NOT EXIST>" {
								// no calculated translation available so hardcode the applicable document name
								Set item=$TR(tItem.fullName,"/","-")_".DFI"
							} Else {
								Do $system.OBJ.DisplayError(err.AsStatus()) Quit 
							}
						}
						Set itemList=itemList_$listbuild(item)
					} Else {
						//earlier version of DSII which could not be exported via $system.OBJ APIs; export in custom %DeepSee format
						Set item=tItem.fullName
						Set tShortName = $translate(item,"/ .","-_-")
						Set subdir = ##class(%File).NormalizeDirectory(^Sources_"dsi")
						Do ##class(%File).CreateDirectoryChain(subdir)
						Set tFile = ##class(%File).NormalizeFilename(subdir_tShortName_".xml") 
						Set legacyDSList=$get(legacyDSList)_$listbuild($listbuild(item,tFile))
					}
				}
			}
		}
		Set pointer=$order(itemList(pointer),1,itemID)
	}
	
	If $data(skippedList) {
		Write !,"The following changed DeepSee Folder Items are excluded from export...",!
		Set ptr=0
		While ($listnext(skippedList,ptr,line)) {
			Write line,!
		}
		Write "   You must manually delete the original items from your Perforce branch.",!
	}

	If (Interactive) {
		Set default="yes" Write "Do you wish check-out and export of these items? ["_default_"] "
		Read ans Write ! If ans="" Set ans=default 
		If $zconvert($extract(ans),"U")="Y" {
			Set ListOnly=0	
		} Else {
			Quit $$$OK
		}
	}
	If ('ListOnly) {
		Write !,"Attempting Checkout and Export....",!
		If ($listlength(itemList)=0)&&('$data(legacyDSList)) {
			Write !,"No updated DeepSee items were found for export",!
		} Else {
			If '##class(%Studio.SourceControl.ISC).Disconnected() {
				Write "This namespace is 'Connected' to Perforce."
				Write "Current branch is stored in:",!
				Write "    "_^Sources,!
				If (Interactive) {
					Set ret=##class(%Studio.SourceControl.ISC).GetCredentials(.pP4user, .pP4pass)
					If (ret)&&($get(pP4pass)="") {
						Write "Please enter password for Perforce user '"_$get(pP4user)_"': "
						Use $p:(:"+S")
						Read pP4pass 
						Use $p:(:"-S")
						Write !
						Set %stP=$System.Encryption.Base64Encode($G(pP4pass))
					} ElseIf ('ret) {
						Write "NOTICE: Source Control Credentials are not set for '"_$USERNAME_"'",!
					}
				}
			}
			If $isobject($get(%SourceControl)) {
				Write !,"Using existing Source Control object",!
			} Else {
				Write !,"Creating Source Control Object..."
				Set sc=##class(%Studio.SourceControl.Interface).SourceControlCreate("","",.created)
				If 'created {
					Write "Failed!  Quiting DSCheckpointExport().",! Quit $$$ERROR($$$GeneralError,"Could not create Source Control Object")
				}
			}
			For itemIndex=1:1:$listlength(itemList) {
				Set item = $listget(itemList,itemIndex)
				Set sc=%SourceControl.BaselineExportItem(item,0,1)
				If $$$ISERR(sc) Do $System.Status.DisplayError(sc)
			}
			If $data(legacyDSList) {
				Write "DSCheckpointExport for DS II items in versions prior to 2012.1 is NOT IMPLEMENTED",!
				/*For itemIndex=1:1:$listlength(legacyDSList) {
					Set itemDetails=$listget(legacyDSList,itemIndex)
					Set item=$listget(itemDetails,1)
					Set tFile=$listget(itemDetails,2)
		
					Write !,"Exporting '"_item_"' to file '"_tFile
					;Set sc=##class(%DeepSee.UserLibrary.Utils).%Export(item,tFile)
				}*/
			}
		}
		If $$$ISOK(sc) {
			Set ^SYS("SourceControl","Misc","LastDSCheckpoint")=newTime
		}
	}
	Quit sc
}

/// Readonly method which will show files marked for User Readonly as readonly even if process is running as root
ClassMethod ReadOnly(filename) As %Boolean
{
	Set readonly=$$$FileReadOnly(filename)
	If ($$$isUNIX) {
		Set sc=..SecureRunCmd("whoami",,.out,0)
		; processes running as root do not get ReadOnly=1 returned even if the 'write' bit is not set.
		; check the user-write bit, and if it is not set, then indicate that the file is readonly
		If ($get(out(1))="root")&&($zboolean($$$FileAttributes(filename),128,1)=0) { Set readonly=1 }
	}
	Quit readonly
}

/// Handles all compile-time logic for this class
ClassMethod OnToolsCompile() [ CodeMode = objectgenerator, Internal ]
{
 	For i = 1:1:%class.Parameters.Count() {
        If %class.Parameters.GetAt(i).Name = "SrcVer" Set valSrcVer = %class.Parameters.GetAt(i).Default
        If %class.Parameters.GetAt(i).Name = "Version" Set indexVersion=i
    }
    If $D(indexVersion)&&($G(valSrcVer)["//custom_ccrs/_common/config/") {
	    Set %class.Parameters.GetAt(indexVersion).Default = $P($G(valSrcVer),"#",2)+1
	    Do %class.Parameters.GetAt(indexVersion).%Save()
    }
    Quit $$$OK
}

/// Returns true if this namespace is a TrakCare namespace (note - this will also catch a HealthShare VIEWERLIB, but we shouldn't be changing any data in there anyway)
ClassMethod IsTrakCare() As %Boolean [ CodeMode = expression ]
{
##class(%Dictionary.ClassDefinition).%ExistsId("websys.Configuration")
}

/// Returns value the Major.Minor version for this instance, so it can be used in comparison code which makes sure certain features are used in appropriate versions
ClassMethod InstanceVersion() As %Numeric [ CodeMode = expression ]
{
$P($SYSTEM.Version.GetNumber(),".",1,2)
}

/// Deprecated, do not use; use ..InstanceVersion() instead
ClassMethod Version() As %Numeric [ CodeMode = call, Internal ]
{
..InstanceVersion()
}

/// Called if compilation of the class has modified the storage (or another part of the class)
/// so we need to write out the new version and if the file is not already checked out we need
/// to check it out automatically.
Method OnAfterStorage(InternalName As %String, Location As %String = "") As %Status
{
	Set sc=..GetStatus(InternalName,.IsInSourceControl,.Editable,.IsCheckedOut)
	If $$$ISERR(sc) Quit sc
	Write !,"Item '"_InternalName_"' changed during compile so exporting new version. This should be checked in."
	If IsInSourceControl,'IsCheckedOut {
		Set sc=..CheckOut(InternalName,"Document automatically changed by compile",0)
		If $$$ISERR(sc) Quit sc
	}
	Quit ..OnAfterSave(InternalName)
}

ClassMethod CheckIndexes()
{
	Set tInterupt=0
	Try {
		Do ##class(Change).BuildNewIndexes()
		Do ##class(ItemSet).BuildNewIndexes()
	} Catch (tExc) {
		If tExc.Name="<METHOD DOES NOT EXIST>" {
			Set tMethod=$Piece(tExc.Data,",",1),tClass=$Piece(tExc.Data,",",2)
			Write !,"Unable to check indexes. Please upgrade your client tools. The version of ",tClass," installed on this system does not have a valid ",tMethod,"() method." 
		} Else {
			Write !,"Could not complete operation: ",!
			Do tExc.OutputToDevice()
			If (tExc.Name="<INTERRUPT>")||(tExc.Name="<DISCONNECT>")||tExc.Name="<ALARM>" {
				Write tExc.Name_" Detected!",!
				Set tInterupt=1
			}
		}
	}
	If tInterupt=1 {
		Throw tExc
	}
}

}
