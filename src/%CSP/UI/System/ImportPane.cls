/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
Class %CSP.UI.System.ImportPane Extends %CSP.Util.ExpPane [ System = 4 ]
{

/// If greater than this size and user is importing Sequential file (%GO) then show content 
/// will not be available.
Parameter CheckMaxSize = 10000000;

/// Overwritten by subclasses to draw anything this pane needs for the BODY section.
Method DrawBODY(pInstance As PageInstance) As %Status
{
	Set BrowsePage = ##class(%CSP.Page).Link("/csp/sys/UtilFileSelect.csp",,1)
	Set ImportLocalPage = ##class(%CSP.Page).Link("UtilExpImportLocal.csp",,1)
	Set msgPage1 = $$$TextJS("Please enter a file name")
	// try and determine if user is on *same* machine as server
	// if so, do not provide local upload option
	Set tClientAddr = $G(%request.CgiEnvs("REMOTE_ADDR"))
	Set tIsLocal = ((tClientAddr = "127.0.0.1") ! (tClientAddr = "::1"))
	&html<<div class="Text1">#(..GetDescriptiveText())#</div>>
	Set tIsImpliedNS = ($E($ZU(5),1,1)="^")
	If tIsImpliedNS,..GetPageType()="Classes" {
		&html<<h1>#($$$TextHTML("Importing classes into Database is not allowed. Please import to Namespaces."))#</h1> >	
		Quit 1
	}
	&html<
	<script language="javascript">
function gotoBrowse(number,param)
{
	if (number == 1) var remotefile = document.getElementById("RemoteFileName").value;
	else var remotefile = document.getElementById("LocalFileName").value;
	var url = "#(BrowsePage)#Dir=" + cspEncodeUTF8(remotefile) + "&" + param;
	return launchPopupWindow(url);

}
function legacyFormat(thisForm)
{
	var legacy = document.getElementById("LegacyFormat");
	if (thisForm.ExportFormat.options[thisForm.ExportFormat.selectedIndex].value == "GO") {
		legacy.style.display = "block";	
	} else {
		legacy.style.display = "none";
	}
}
// make sure user has entered a file name
function validate(pagename)
{
	var filename;
	if (document.getElementById("InputType2").checked == true) {
		filename = document.expform.LocalFileName.value;
		if (filename == "") {
			alert("#(msgPage1)#" + "!");
			document.expform.LocalFileName.focus();
			return false;
		}
	} else {
		filename = document.getElementById("RemoteFileName").value;		
		if (filename == "") {
			alert("#(msgPage1)#" + "!");
			document.getElementById("RemoteFileName").focus();
			return false;
		}
	}
	if (document.getElementById("submitok").value != "true") {
		//if user not confirm load dir then uncheck the checkbox
		document.getElementById("chkLoadAll").checked = false;
		changeLoadAll(false);
		return false;
	}
	var expires = '; expires=Thursday, 31-Dec-2020 23:59:59 GMT';
	document.cookie = "LastFile" + pagename + "=" + cspEncodeUTF8(filename) + expires;
	return true;
}
// generic function called from /csp/sys/UtilFileSelect.csp
function update(remotefile)
{
	document.getElementById("RemoteFileName").value = remotefile;
}
function locationchange(islocal)
{
	var namespace = document.getElementById("$NAMESPACE").value;
	var linkPageName = document.getElementById("linkPageName").value;
	var ImportLocalPage = document.getElementById("ImportLocalPage").value;	
	if (islocal == 0) {
		document.getElementById("id_remote").style.display = "block";
		document.getElementById("id_local").style.display = "none";	
		document.expform.target = "";	
		document.expform.action = linkPageName+"NAMESPACE="+cspEncodeUTF8(namespace);	
		document.getElementById("id_loadAll").style.display = "block";
	} else {
		document.getElementById("id_remote").style.display = "none";
		document.getElementById("id_local").style.display = "block";
		document.expform.target = "new";		
		document.expform.action = ImportLocalPage+"NAMESPACE="+cspEncodeUTF8(namespace);	
		if (document.getElementById("id_loadAll")) {
			document.getElementById("id_loadAll").style.display = "none";
		}
	}
}
function changeLoadAll(ischecked)
{
	if (ischecked) {
		document.getElementById("idLoadAll").style.display = "block";
		document.getElementById("SHOWCONTENT").disabled = true;		
	} else {
		document.getElementById("idLoadAll").style.display = "none";
		document.getElementById("SHOWCONTENT").disabled = false;	
	}	
}
function confirmAll()
{
	var ok = confirm('#($$$TextJS("Are you sure you want to import all classes from the directory? Make sure you have entered a directory."))#');
	if (ok != true) document.getElementById("submitok").value = "false";
	else document.getElementById("submitok").value = "true";
}
</script>	
	
	>
	Set tSC = $$$OK
	#;Do ..DrawCommandForm(pInstance)
	Set InputType = $G(%request.Data("InputType",1),"Remote")
	Set FileControlName = $S(InputType="Remote":"RemoteFileName",1:"FileName")
	Set FileName = $G(%request.Data(FileControlName,1))
	Set FileName = $zstrip(FileName,"<>W")
	Set fileflag = $S(%request.PageName["Global":"*.go;*.gsa;*.gbl;*.gof",%request.PageName["Routine":"*.ro;*.rsa;*.rtn;*.mac",%request.PageName["Class":"*.xml",1:"")
	Set LastSaveFile = $ZCVT($ZCVT(%request.GetCookie("LastFile"_%request.PageName),"I","URL"),"I","UTF8")
	If LastSaveFile = "" Set LastSaveFile = $G(^CacheTemp.MgtPortalSettings($UserName,"LastFile",%request.PageName))
	If LastSaveFile = "",FileName = "" Set FileName = ##class(%File).NormalizeFilename("import"_$P(fileflag,"*",2))
	If LastSaveFile '= "",FileName = "" Set FileName = LastSaveFile
	Set ^CacheTemp.MgtPortalSettings($UserName,"LastFile",%request.PageName) = FileName
	Set ServerName = $zu(110)
	Set lblCharSet = $$$TextHTML("Character set")
	Set lblDefaultCharset = $$$TextHTML("<Device Default>")
	Set CharList = $$GetIONames^%SYS.NLS(.DefCharList,1),tLen = $L(CharList,",")
	Set CharDef = $G(%request.Data("Charset",1))
	Set CompileFlags = $G(%request.Data("CompileFlags",1),"cuko1")
	Set linkPageName = ##class(%CSP.Page).Link(%request.PageName,,1)
	&html<<form name="expform" method="post" target="" action="#(linkPageName)#$NAMESPACE=#($ZU(5))#" enctype="multipart/form-data" onsubmit="return validate('#(%request.PageName)#');">
	<input type="hidden" name="PageName" id="PageName" value="#(%request.PageName)#">
	<input type="hidden" name="linkPageName" id="linkPageName" value="#(linkPageName)#">
	<input type="hidden" name="ImportLocalPage" id="ImportLocalPage" value="#(ImportLocalPage)#">
	>
	#; if confirm = Cancel for class LoadDir then submitok is set to "false" so validate will return false to abort submit
	&html<<input type="hidden" name="submitok" id="submitok" value="true">>
	If (tIsLocal) {
		// no option for local upload
		&html<<input type="hidden" name="InputType" id="InputType2" value="Remote">>
	}
	Else {
		// prompt for local / remote load
		&html<<p class="ltcaption">#($$$Text("The import file resides on "))#>
		&html<<input type="radio" name="InputType" id="InputType1" value="Remote" #($S(InputType="Remote":"checked",1:""))# onclick="locationchange(0);">#(ServerName)#
		<input type="radio" name="InputType" id="InputType2" value="Local" #($S(InputType="Local":"checked",1:""))# onclick="locationchange(1);">#($$$TextHTML("My Local machine"))#>
	}
	&html<<p class="ltcaption">#($$$Text("Enter the path and name of the import file:"))#</p>>

	Set hlpBrowse = $$$TextHTML("Display file selection dialog")
	Set hlpOpen = $$$TextHTML("Display contents of import file")
	Set hlpAll = $$$TextHTML("Import all files in a directory")

	&html<<div id="id_remote" style="display:block" nowrap><input type="text" name="RemoteFileName" id="RemoteFileName" size="60" value="#($ZCVT(FileName,"O","HTML"))#">>
	&html<<input title="#(hlpBrowse)#" type="button" name="RemoteBrowse" value='#($$$Text("Browse..."))#' onclick="return gotoBrowse('1','Wizard=Open&Wild=#(fileflag)#');"></div>>
	&html<<div id="id_local" style="display:none" nowrap><input title="#(hlpBrowse)#" type="file" name="LocalFileName" id="LocalFileName" size="60" value=""></div>>
	If %request.PageName'["Class" {
		&html<<p class="ltcaption">#(lblCharSet)#:&nbsp;<select name="Charset"><option value="" #($S(CharDef="":"selected",1:""))#>#(lblDefaultCharset)#</option>>
		For tc = 1:1:tLen Set tint = $P(CharList,",",tc) Quit:tint=""  &html<<option value="#(tint)#" #($S(tint=CharDef:"selected",1:""))#>#(tint)#</option>>
		&html<</select></p>>
	} Else {
		If InputType="Remote" {
			Set msgLoadAll = $$$TextHTML("Load all classes from directory")
			Set msgCompile = $$$TextHTML("Compile imported items")
			Set msgCompileFlag = $$$TextHTML("Compile flags")
			Set msgRecurse = $$$TextHTML("Include subdirectories")
			&html<<div id="id_loadAll" class="note" style="margin-right:20px; margin-top:10px; border:1px gray solid;">>
			&html<<input type="checkbox" name="chkLoadAll" onclick="changeLoadAll(this.checked)">#(msgLoadAll)#>
			&html<<div id="idLoadAll" style="display:none">>
			&html<<input type="checkbox" name="chkRecurse">#(msgRecurse)#>
			&html<<input type="checkbox" name="chkCompileAll" checked>#(msgCompile)#>
			&html<&nbsp;&nbsp;-&nbsp;&nbsp;#(msgCompileFlag)#:&nbsp;<input type="textbox" name="CompileFlagsAll" value="#($zconvert(CompileFlags,"O","HTML"))#" size="10">>
			&html<<input title="#(hlpAll)#" type="submit" name="LOADDIR" value='#($$$Text("Import All"))#' onclick="confirmAll();">>
			&html<</div></div>>
		} 
	
	}
	&html<<br><p class="ltcaption">#($$$Text("After selecting a file, press Open to view the contents of the file:"))#</p>>
	&html<<input title="#(hlpOpen)#" type="submit" name="SHOWCONTENT" id="SHOWCONTENT" value='#($$$Text("Open"))#'>>
	&html<
	<p class="ltcaption">
	<input type="hidden" name="$NAMESPACE" id="$NAMESPACE" value="#($ZU(5))#">
	>
	If $G(%request.Data("OK",1)) '= "" {
		Set tSC = ..DrawResult(FileName,CompileFlags,CharDef)
	} ElseIf $G(%request.Data("SHOWCONTENT",1)) '= "" {
		Do ..DrawContent(FileName,CompileFlags,CharDef)
	} ElseIf $G(%request.Data("LOADDIR",1)) '= "" {
		Do ..DrawLoadDir(FileName,CompileFlags)
	}

	&html<</form>>
	Use 0
	If ($$$ISERR(tSC)) {
		Do ..DrawStatusError(tSC)
	}
	Quit tSC
}

/// Overwritten by subclasses to draw anything this pane needs for the HEAD section.
Method DrawHEAD(pInstance As PageInstance) As %Status
{
	
	&html<<script language="JavaScript">
// set all the checkboxes true or false
function toggleCheckboxes(cbState)
{
	var cb;
	var TotalRows = document.getElementById("TotalRows").value;
	for (var i = 1; i <= TotalRows; i++) {
		cb = self.document.getElementById("cb_"+i);
		cb.checked = cbState;
	}
}

	</script>
	<style type="text/css">
.ltcaption {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 0.8em;
	color: darkblue;
	text-align: left;
	font-weight: bold;
}
.note {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 0.8em;
	text-align: left;
	font-weight: normal;
}
</style>
	>
	Quit $$$OK
}

Method DrawResult(FileName, CompileFlags, Charset) As %Status
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		&html<<pre>>
		Set TotalRows = +$G(%request.Data("TotalRows",1))
		Set chkBackground = $G(%request.Data("chkBackground",1))
		Set ImportAll = $G(%request.Data("LOADDIR",1)) '= ""
		If FileName = "" Write !,$$$Text("File name is empty!"),"</pre>" Quit
		If ##class(%File).Exists(FileName) = 0 {
			Write !,$$$Text("File does not exist!") 
			&html<</pre>> 
			Quit
		}
		Kill err,tItems
		Set (tName,tParms("Columns")) = ""
		Set (tRow,tTotal,tIndex,tCol) = 0
		Write !,$$$Text("Import from file: "),$zconvert(FileName,"O","HTML")
		While tRow < TotalRows {
			Set tRow = tRow + 1
			Set tId = "cb_"_tRow
			If $G(%request.Data(tId,1))'="" {
				Set tTotal = tTotal + 1
				Set tItems(%request.Data(tId,1))=""
			}
		}
		#; YSD2430: handle special case for large sequential file
		If $G(%request.Data("LOADDIR",1))="",$G(%request.Data("SelectAll",1))="",ImportAll=0 Set ImportAll=1
		Else  If tTotal = 0,'ImportAll Write !,$$$Text("Nothing selected."),"</pre>" Quit
		Set tParms("TotalColumns") = tTotal
		Set qspec = ""
		If $G(%request.Data("chkCompile",1))'="" {
			If $G(%request.Data("CompileFlags",1)) '= "" Set qspec = %request.Data("CompileFlags",1)
			Else  Set qspec = "c"
		}
		#;YSD2203
		Do ..SetAlarmTimeout()
		If chkBackground = "" {
			Set tSC = $System.OBJ.Load(FileName,qspec,.err,.loadlist,0,.tItems,,Charset)
			Write !!,$$$Text("Completed at "),$ZDT($h,3)
		} Else {
			Set msg1 = $$$TextHTML("This task will be run in the background.")
			Set msg2 = $$$TextHTML("Click here to view the background tasks page.")
			Set linkpage = ##class(%CSP.Page).Link("/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen")
			Set tParms("ImportAll") = ImportAll
			Set tParms("FileName") = FileName
			Set tParms("qspec") = qspec
			Set tParms("Charset") = Charset
		 	Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("Import",$zu(5),.tParms,.tItems,.tJob)
			If $$$ISERR(status) Do ..LogMsg($System.Status.GetErrorText(status))
		 	&html<<h2>#(msg1)#&nbsp;<a href="#(linkpage)#">#(msg2)#</a></h2>>
		}
		If $G(err) > 0 {
			Do ..DrawErrorLog()
		} 
		&html<</pre>>
	} While(0)
	If $$$ISERR(tSC) Goto Trap
Done
	Do $System.Alarm.Clear()
	Quit tSC
Trap
	Set $ZT=""
	If ($ZE["<ALARM>") {
		Set tText = $ZCVT($$$FormatText($$$Text("Import did not finish within %1 seconds. Please use background import for large files."), ..GetAlarmTimeout()),"O","HTML")
		Set tSC=$$$ERROR($$$GeneralError,tText)
	} ElseIf $ZE["<PROTECT>" {
		Set tSC = $$$ERROR(940)
	} Else {
		Set tSC = $$$ERROR($$$GeneralError,$ZE)
	}
	Goto Done
}

/// Draw what items are in the importing file
Method DrawContent(FileName As %String, CompileFlags As %String, Charset As %String) As %Integer
{
	If FileName = "" Quit
	If ##class(%File).Exists(FileName) = 0 {
		Write !,$$$Text("File does not exist!") 
		&html<</pre>>
		Quit
	}
	Set msgNothing = $$$TextHTML("Nothing found.")
	Set msgContent = $ZCVT($$$FormatText($$$Text("Select items you wish to import from %1:"),FileName),"O","HTML")
	Set msgOver = $$$TextHTML("If an item already exists and you elect to import, then the import will overwrite the existing item.")
	Set msgCompile = $$$TextHTML("Check here to compile imported items")
	Set msgCompileFlag = $$$TextHTML("Compile flags")
	Set msgNo = $$$TextHTML("No")
	Set msgYes = $$$TextHTML("Yes")
	Set msgBackground = $$$TextHTML("Check here to run import in the background - recommended for importing large files")
	Set Column(1) = $$$TextHTML("Item")
	Set Column(2) = $$$TextHTML("Exists")
	Set Column(3) = $$$TextHTML("Last Modified")
	Set ShowContent = 1
	Set Filesize = ##class(%File).GetFileSize(FileName)
	If %request.PageName["Global" {
		// Find out if this is GO or GOF format file
		Set format = $$filefmt^%SYS.Wgr(FileName)
		If '($Piece(format,".")=7||($Piece(format,".")="Object")) {
			If Filesize > ..#CheckMaxSize {
				Set ShowContent = 0
				Set msgContent = $$$TextHTML("The content list is not available for Sequential file with file size greater than 10MB.")
			}
		}
	}
	&html<<p class="ltcaption">#(msgContent)#</p>>
	Do ..DrawButtons(ShowContent)
	Set tRow = 0
	If ShowContent = 1 {
		&html<<table class="DetailTable" border="1" cellpadding="2" cellspacing="0" bgcolor="#c4d6d6">>
		&html<<tr><th nowrap>#(Column(1))#</th><th nowrap>#(Column(2))#</th><th nowrap>#(Column(3))#</th>>
		Set tRS = ##class(%ResultSet).%New("%RoutineMgr:ImportItemList")
		Set tSC = tRS.Execute(FileName,Charset)
		If $$$ISERR(tSC) Set msgNothing = $ZCVT($System.Status.GetErrorText(tSC),"o","HTML")
		While tRS.Next() {
			Set tRow = tRow + 1
			Set tId = "cb_"_tRow
			Set tName = tRS.GetData(1)
			Set tTime = tRS.GetData(2)
			Set tExist = $S(tTime=-1:msgNo,1:msgYes)
			If tTime = -1!(tTime="") Set tTime = "&nbsp;"
			&html<<tr class="#($S(tExist=msgNo:"OddRow",1:"EvenRow"))#"><td nowrap><input type="checkbox" name="#(tId)#" id="#(tId)#" value='#($ZCVT(tName,"O","HTML"))#' checked>#($ZCVT(tName,"O","HTML"))#</td>>
			&html<<td class="DetailValue" valign="bottom">#($ZCVT(tExist,"O","HTML"))#</td>>
			&html<<td class="DetailValue" nowrap valign="bottom">#(tTime)#</td></tr>>
		}
		If tRow = 0 &html<<tr><td colspan="3">#(msgNothing)#</td></tr>>
		Else  &html<<tr><td colspan="3">#($$$FormatText($$$Text("Total: %1"),tRow))#</td></tr>>
		&html<</table>>
	}
	If tRow > 1 Do ..DrawButtons(ShowContent)
	Set chkBack = $S($G(%request.Data("chkBackground",1))'="":"checked",Filesize>..#CheckMaxSize:"checked",1:"")
	&html<<p class="ltcaption"><input type="hidden" name="TotalRows" id="TotalRows" value="#(tRow)#">>
	If %request.PageName'["Global" {
		&html<<input type="checkbox" name="chkCompile" checked>#(msgCompile)#>
		If %request.PageName["Class" &html<&nbsp;&nbsp;-&nbsp;&nbsp;#(msgCompileFlag)#:&nbsp;<input type="textbox" name="CompileFlags" value="#($zconvert(CompileFlags,"O","HTML"))#" size="10">>
		&html<<br>>
	}
	&html<<input type="checkbox" name="chkBackground" #(chkBack)#>#(msgBackground)#</p>>
	&html<<div class="note">(#(msgOver)#)</div>>
}

/// Process LoadDir - always run in the background
Method DrawLoadDir(FileName As %String, CompileFlags As %String) As %Integer
{
	Set $ZT = "TrapDir"
	Do {
		&html<<pre>>
		If FileName = "" Write !,$$$TextHTML("Directory name is empty!"),"</pre>" Quit
		If ##class(%File).DirectoryExists(FileName) = 0 {
			Write !,$$$TextHTML("Directory does not exist!") 
			&html<</pre>> 
			Quit
		}
		Kill err,tItems
		Set (tName,tParms("Columns")) = ""
		Set (tRow,tTotal,tIndex,tCol) = 0
		Write !,$$$TextHTML("Import from directory: "),$zconvert(FileName,"O","HTML")
		Set tParms("TotalColumns") = tTotal
		Set qspec = ""
		If $G(%request.Data("chkCompileAll",1))'="" {
			If $G(%request.Data("CompileFlagsAll",1)) '= "" Set qspec = %request.Data("CompileFlagsAll",1)
			Else  Set qspec = "c"
		}
		Set msg1 = $$$TextHTML("This task will be run in the background.")
		Set msg2 = $$$TextHTML("Click here to view the background tasks page.")
		Set linkpage = ##class(%CSP.Page).Link("/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen")
		Set tParms("ImportAll") = "LoadDir"
		Set tParms("FileName") = FileName
		Set tParms("qspec") = qspec
		Set tParms("Recurse") = $G(%request.Data("chkRecurse",1)) '= ""
		Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("Import",$zu(5),.tParms,.tItems,.tJob)
		If $$$ISERR(status) Do ..LogMsg($System.Status.GetErrorText(status))
		&html<<h2>#(msg1)#&nbsp;<a href="#(linkpage)#">#(msg2)#</a></h2>>

		If $G(err) > 0 {
			Do ..DrawErrorLog()
		} 
		&html<</pre>>
	} While(0)
	Quit	
TrapDir
	Set $ZT=""
	Write !,$$$Text("Error drawing result: "),$zconvert($ZE,"O","HTML"),!
	Quit
}

Method DrawButtons(ShowContent As %Integer)
{
	If ShowContent {
		&html<<p><input type="button" name="SelectAll" value='#($$$Text("Select All"))#' onclick="toggleCheckboxes(true);">>
		&html<<input type="button" name="UnselectAll" value='#($$$Text("Unselect All"))#' onclick="toggleCheckboxes(false);">>
		&html<<input type="submit" name="OK" id="OK" value='#($$$Text("Import"))#'></p>>
	} Else {
		&html<<p><input type="submit" name="OK" id="OK" value='#($$$Text("Import All"))#'></p>>
	}
}

/// Method to Import in the background
ClassMethod Import(FileName As %String, ByRef pParms As %String, ByRef tItems As %String) As %Status
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		If $G(pParms("NAMESPACE")) '= "",pParms("NAMESPACE") '= $ZU(5) Set $Namespace = pParms("NAMESPACE")
		//YSD1368 If $G(pParms("Columns")) '= "" {
		//	For tRow = 1:1:pParms("TotalColumns") Set tItem = $li(pParms("Columns"),tRow) Quit:tItem=""  Set tItems(tItem) = ""
		//}
		Set qspec = pParms("qspec")_"-d"
		Set Charset = $G(pParms("Charset"))
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		If $G(pParms("ImportAll")) = 1 {
			Set tSC = $System.OBJ.Load(FileName,qspec,.err,,,,,Charset)
		} Else {
			If $G(pParms("ImportAll")) = "LoadDir" {
				Set tSC = $System.OBJ.LoadDir(FileName,qspec,.err,1)
			} Else {
				Set Recurse = $S($G(pParms("IMPORTTYPE"))="FILE":0,1:+$G(pParms("Recurse")))
				Set tSC = $System.OBJ.Load(FileName,qspec,.err,.loadlist,Recurse,.tItems,,Charset)
			}
		}
		Kill EscapeObj
		If $$$ISERR(tSC) Do ..LogMsg($System.Status.GetErrorText(tSC))
		Else  Do ..LogMsg($$$FormatText($$$Text("Completed at %1"),$ZDT($H)),$$$Text("Done"))
		If $G(pParms("ImportLocal")) = 1 Set tSC = ##class(%File).Delete(FileName)  // delete temp file
	} While(0)
Done
	Quit tSC
Trap
	Set $ZT=""
	Do ..LogMsg($ZE)
	Goto Done
}

/// Log error into ^|"%SYS"|CacheTemp.MgtPortalTask($J,"Status") and ^|"%SYS"|CacheTemp.MgtPortalTask($J,"Details")
ClassMethod LogMsg(ErrMsg As %String = "", Status As %String = "ERROR")
{
	Set ^|"%SYS"|CacheTemp.MgtPortalTask($J,"Details") = $G(^|"%SYS"|CacheTemp.MgtPortalTask($J,"Details")) _" " _ ErrMsg
	Set ^|"%SYS"|CacheTemp.MgtPortalTask($J,"Status") = Status
}

/// Return (localized) text message displayed near top of page.
Method GetDescriptiveText()
{
	Set tType = ..GetPageType()
	Set msg = ""
	// see if we are in a namespace or an implied namespace
	Set svr = ""
	Set tIsImpliedNS = ($E($ZU(5),1,1)="^")
	If (tIsImpliedNS) {
		Set tContainer = "database"
		Set t = $E($ZU(5),2,*)
		Set tNS = $P(t,"^",$L(t,"^"))
		Set tServer = $P(t,"^",$L(t,"^")-1)
		If tType = "Routines" {
			If tServer = "" {
				Set msg = $$$FormatText($$$Text("Import routines into database %1"),tNS)
			} Else {
				Set msg = $$$FormatText($$$Text("Import routines into database %1 on server %2"),tNS, tServer)
			}
		} ElseIf tType = "Classes" {
			If tServer = "" {
				Set msg = $$$FormatText($$$Text("Import classes into database %1"),tNS)
			} Else {
				Set msg = $$$FormatText($$$Text("Import classes into database %1 on server %2"),tNS, tServer)
			}
		} ElseIf tType = "Globals" {
			If tServer = "" {
				Set msg = $$$FormatText($$$Text("Import globals into database %1"),tNS)
			} Else {
				Set msg = $$$FormatText($$$Text("Import globals into database %1 on server %2"),tNS, tServer)
			}
		}
	}
	Else {
		Set tNS = $ZU(5)
		If tType = "Routines" {
			Set msg = $$$FormatText($$$Text("Import routines into namespace %1"),tNS)	
		} ElseIf tType = "Classes" {
			Set msg = $$$FormatText($$$Text("Import classes into namespace %1"),tNS)
		} ElseIf tType = "Globals" {
			Set msg = $$$FormatText($$$Text("Import globals into namespace %1"),tNS)			
		}
	}
		
	Quit $ZCVT(msg,"O","HTML")_":"
}

}
