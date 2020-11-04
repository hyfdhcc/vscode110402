/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>This pane handles displaying, selecting, and exporting classes/routines/globals.
Class %CSP.UI.System.ExportPane Extends %CSP.Util.ExpPane [ System = 4 ]
{

/// Create resultset for Export
Method CreateResultSet(ByRef pRS As %ResultSet) As %Status
{
	Set tSC = $$$OK
	Set Query = "%RoutineMgr:StudioOpenDialog"
	If %request.PageName [ "Routine" {
		Set SEARCHMASK = ..GetSearchMask()
		#;YSD1759 If SEARCHMASK '[ ";" Set Query = "%Routine:RoutineList"
	} Else {
		If %request.PageName [ "Global" {
			Set Query = "%SYS.GlobalQuery:NameSpaceList"
			If ($E($zu(5))="^") Set Query = "%SYS.GlobalQuery:DirectoryList"
		}
	}
	Set pRS = ##class(%ResultSet).%New(Query)
	If ('pRS.QueryIsValid()) {
		Quit $$$ERROR($$$GeneralError,"Invalid Query: " _ Query)
	}
	Quit tSC
}

/// Execute query for Export
Method ExecuteResultSet(pRS As %ResultSet, SEARCHMASK As %String) As %Status
{
	Set tSC = $$$OK
	Set $ZT="Trap"
	
	Set showSystemItems = $G(%request.Data("showSystemItems",1))
	Set showSystemItems = $S(showSystemItems="on":1,1:0)
	#;YSD2203
	Do ..SetAlarmTimeout()

	If %request.PageName [ "Class" {
		If $E(SEARCHMASK,$L(SEARCHMASK)-3,$L(SEARCHMASK))'=".cls" Set SEARCHMASK = SEARCHMASK_".cls"
		Set tSC = pRS.Execute(SEARCHMASK,,,showSystemItems,1,1)  //flat is set to 1,NotStudio is set to 1
	} ElseIf %request.PageName [ "Routine" {
		#;YSD1759 Set tSC = pRS.Execute(SEARCHMASK,1,1)
		Set tNewSpec = ..GetMask(SEARCHMASK)
		Set tSC = pRS.Execute(tNewSpec,,,showSystemItems,1,1)
	} ElseIf %request.PageName [ "Global" {
		#; if implied namespace use directory
		If ($E($zu(5))="^") {
			Set Dir = $P($zu(5),"^",3)
			Set tSC = pRS.Execute(Dir,,SEARCHMASK,showSystemItems)
		} Else {
			Set tSC = pRS.Execute($ZU(5),SEARCHMASK,showSystemItems)
		}
	} Else {
		Set tSC = pRS.Execute($ZU(5),SEARCHMASK,0)
	}
	Do $System.Alarm.Clear()
	If $$$ISERR(tSC) Goto Trap
Done
	Quit tSC
Trap
	Set $ZT=""
	Do $System.Alarm.Clear()
	If ($ZE["<ALARM>") {
		Set tText = $ZCVT($$$FormatText($$$Text("Query did not execute within %1 seconds."), %request.GatewayTimeout-5),"O","HTML")
		Set tSC=$$$ERROR($$$GeneralError,tText)
	} ElseIf $ZE["<PROTECT>" {
		Set tSC = $$$ERROR(940)
	} Else {
		Set tSC=$$$ERROR($$$GeneralError,$ZE)
	}
	Goto Done
}

/// Overwritten by subclasses to draw anything this pane needs for the BODY section.
Method DrawBODY(pInstance As PageInstance) As %Status
{

	&html<<div class="Text1">#(..GetDescriptiveText())#</div>>

	Set BrowsePage = ##class(%CSP.Page).Link("/csp/sys/UtilFileSelect.csp",,1)
	Set msgConfirm = $$$Text("File already exists. Overwrite the existing file?")
	Set Yesterday = $ZDT(+$H-1,3)
	Set Today = $ZDT(+$H,3)
	&html<
	<style type="text/css">
	table.ParaForm	{ 
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size:0.9em;
	}

	</style>
	>
	&html<
	<script language="javascript">
	var yesterday = "#(Yesterday)#";
	var today = "#(Today)#";
function loadDate(day)
{
	if (day == "T") {
		document.getElementById("txtEndDate").value = today;
	} else {
		document.getElementById("txtBeginDate").value = yesterday;
	}
}
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
// generic function called from /csp/sys/UtilFileSelect.csp
function update(remotefile)
{
	document.getElementById("RemoteFileName").value = remotefile;
}
// validate if the file already exists
function validate()
{
	var exists = document.getElementById("FileExists").value;
	if (exists == 1) {
		if (confirm("#(msgConfirm)#")) {
			return true;
		} else {
			return false;
		}
	} else {
		return true;	
	}
}
// for export routines, update ExportFormat when user clicked the export OBJ checkbox
function exportOBJ(value)
{
	if (value == true) {
		document.getElementById("ExportFormat").value = "XML";
		document.getElementById("chkBackground").checked = true;
	} else {
		document.getElementById("ExportFormat").value = "RO";
	}	
}
function savetocookie(form,pagename)
{
	var expires = '; expires=Thursday, 31-Dec-2020 23:59:59 GMT';
	var filename = form.RemoteFileName.value;
	document.cookie = "LastFile" + pagename + "=" + cspEncodeUTF8(filename) + expires;
}
function hint()
{
	var style = document.getElementById("id_hint").style;
	if (style.display == "none") style.display = "block";
	else style.display = "none";
}
</script>>
		// write out methods that perform the hyper-calls
	Write "<script language=""javascript"">",!

	// server-side function
	Write "function fileExists(remotefile)",!
	Write "{",!
	Write ##class(%CSP.Page).HyperEventCall($classname()_".FileExists","remotefile",0)
 	Write ";",!
	Write "}",!
	Write "</script>",!
	Do ..DrawCommandForm(pInstance)
	If %request.PageName["Global",$$isrem^%SYS.GLO {
	 	Set tmsg = $$$TextHTML("Can't output: global directory is on a remote system.")
		&html<<p class="ltcaption">#(tmsg)#</p>>
		Quit $$$OK
	}
	Set SEARCHMASK = ..GetSearchMask()
	Set FileName = $G(%request.Data("RemoteFileName",1))
	Set ServerName = $zu(110)
	Set lblEnter = $ZCVT($$$FormatText($$$Text("Enter the path and name of the export on server %1"),ServerName),"O","HTML")
	Set fileflag = $S(%request.PageName["Global":"*.gof",%request.PageName["Routine":"*.ro",%request.PageName["Class":"*.xml",1:"")
	If %request.PageName["Global" {
		Set blksiz=$$$dirblksiz("")
		//%GOF can not be used on 64KB databases.
		If blksiz>$$$32k Set fileflag = "*.go"
	}
	Set LastSaveFile = $ZCVT($ZCVT(%request.GetCookie("LastFile"_%request.PageName),"I","URL"),"I","UTF8")
	If LastSaveFile = "" Set LastSaveFile = $G(^CacheTemp.MgtPortalSettings($UserName,"LastFile",%request.PageName))
	If LastSaveFile = "",FileName = "" Set FileName = ##class(%File).NormalizeFilename("export"_$P(fileflag,"*",2))
	If LastSaveFile '= "",FileName = "" Set FileName = LastSaveFile

	Set lblCharSet = $$$TextHTML("Character set")
	Set lblDefaultCharset = $$$TextHTML("<Device Default>")
	Set CharList = $$GetIONames^%SYS.NLS(.DefCharList,1),tLen = $L(CharList,",")
	Set CharDef = $G(%request.Data("Charset",1))
	Set PageName = ##class(%CSP.Page).Link(%request.PageName,,1)
	&html<<form name="expform" method="post" action="#(PageName)#$NAMESPACE=#($ZU(5))#" onsubmit="savetocookie(this,'#(%request.PageName)#');">>
	&html<<p class="ltcaption">#(lblEnter)#:<br>>
	&html<<input type="hidden" name="FileExists" id="FileExists" value="">>
	&html<<input type="text" name="RemoteFileName" id="RemoteFileName" size="60" value="#(FileName)#">>
	&html<<input type="button" name="RemoteBrowse" value='#($$$Text("Browse..."))#' onclick="return gotoBrowse('1','Wizard=Save&Wild=#(fileflag)#');">>
	&html<&nbsp;&nbsp;#(lblCharSet)#:&nbsp;<select name="Charset"><option value="" #($S(CharDef="":"selected",1:""))#>#(lblDefaultCharset)#</option>>
	For tc = 1:1:tLen Set tint = $P(CharList,",",tc) Quit:tint=""  &html<<option value="#(tint)#" #($S(tint=CharDef:"selected",1:""))#>#(tint)#</option>>
	&html<</select>>
	&html<</p>>
	
	Do ..DrawParameters()
		
	&html<<input type="hidden" name="$NAMESPACE" value="#($ZU(5))#">>

	Set SEARCHMASK = ..DrawSearchField("Exp")
	
	If $G(%request.Data("OK",1)) '= "" {
		Set tSC = ..DrawResult(FileName,CharDef)
	} Else {
		Set tSC = ..CreateResultSet(.pRS)
		If $$$ISOK(tSC) {
			Set tSC = ..ExecuteResultSet(.pRS,SEARCHMASK)
			Do ..DrawTable(pRS)
			Do ##class(%CSP.Util.ExpPane).WriteBackupMsg(SEARCHMASK)
		}
	}
	Use 0
	If ($$$ISERR(tSC)) {
		Do ..DrawStatusError(tSC)
	}
	Quit tSC
}

/// Charset passed in is the internal charset name, e.g. Unicode,UTF8,RAW,CP1250...,Latin2,Latin9,LatinC,LatinG,LatinH,LatinT
Method DrawResult(FileName, Charset) As %Status
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		#;YSD2203
		Do ..SetAlarmTimeout()
		Set TotalRows = +$G(%request.Data("TotalRows",1))
		If TotalRows = 0 &html<<p nowrap>#($$$Text("No match found."))#</p>>
		If FileName = "" &html<<p nowrap>#($$$Text("File name is empty!"))#</p>>
		Set msgComplete = $$$Text("Completed at ")
		Set ExportFormat = $G(%request.Data("ExportFormat",1))
		Set FileName = ..GetExpExt(ExportFormat,FileName)
		#;YSD2222
		Set ^CacheTemp.MgtPortalSettings($UserName,"LastFile",%request.PageName) = FileName
		Set chkBackground = $G(%request.Data("chkBackground",1))
		Set ExtCharset = ""
		If Charset '= "" Set ExtCharset = $$MapExtCharset^%SYS.NLS(Charset)
		Set tName = ""
		Set (tRow,tTotal) = 0
		Set tag = $S(%request.PageName["Global":".gbl",1:"")
		Kill err,tItems
		While tRow < TotalRows {
			Set tRow = tRow + 1
			Set tId = "cb_"_tRow
			If $G(%request.Data(tId,1))'="" {
				Set tTotal = tTotal + 1
				Set tItems(%request.Data(tId,1)_tag)=""
				//YSD1368 If chkBackground = "" Set tItems(%request.Data(tId,1)_tag)=""
				//Else  Set $li(tParms("Columns"),tTotal) = %request.Data(tId,1)_tag
			}
		}
		Set tParms("TotalColumns") = tTotal
		If tTotal > 0 {
			&html<<pre>>
			Write !,$$$TextHTML("Export to file: "),$zconvert(FileName,"O","HTML")
			Set msg1 = $$$TextHTML("This task will be run in the background.")
			Set msg2 = $$$TextHTML("Click here to view the background tasks page.")
			Set linkpage = ##class(%CSP.Page).Link("/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen")
			Set tParms("FileName") = FileName
			Set tParms("ExportFormat") = ExportFormat
			If ExportFormat = "XML" {
				If chkBackground = "" {
					Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
					Do $System.OBJ.Export(.tItems,.FileName,,.err,ExtCharset)
					Kill EscapeObj ; To remove the oref and turn off redirection.
					If $O(err("")) '="" {
						Set errno = ""
						For  Set errno = $O(err(errno)) Quit:errno=""  Write $ZCVT(err(errno),"O","HTML"),"<br/>"
					}
				} Else {
		 			Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("Export",$zu(5),.tParms,.tItems,.tJob)
					If $$$ISERR(status) Do ..LogMsg($System.Status.GetErrorText(status))
		 			&html<<h2>#(msg1)#&nbsp;<a href="#(linkpage)#">#(msg2)#</a></h2>>					
				}
			} ElseIf ExportFormat = "RO" {
				Set Parameter = "WNS" 
				If Charset '= "" Set Parameter = "WNSk\"_Charset_"\"
				If chkBackground = "" {
					Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
					Do Export^%apiRTN(.tItems,FileName,,Parameter,,.err)
					Kill EscapeObj
					Write !!,msgComplete,$ZDT($h,3)
				} Else {
					Set tParms("Parameter") = Parameter
		 			Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("Export",$zu(5),.tParms,.tItems,.tJob)
					If $$$ISERR(status) Do ..LogMsg($System.Status.GetErrorText(status))
		 			&html<<h2>#(msg1)#&nbsp;<a href="#(linkpage)#">#(msg2)#</a></h2>>					
				}
			} ElseIf ExportFormat = "GO" {
				Set OutputFormat = $G(%request.Data("OutputFormat",1),7)
				Set RecordFormat = $G(%request.Data("RecordFormat",1),"V")
				If chkBackground = "" {
					Write !,$$$TextHTML("Output Format: "),$S(OutputFormat=5:$$$Text("Sequential file"),1:$$$Text("Block format"))
					Write !,$$$TextHTML("Record Format: "),$S(RecordFormat="V":$$$Text("Variable Length Records"),1:$$$Text("Stream Data"))
					Write !,$$$TextHTML("Character Set: "),$S(Charset="":$$$TextHTML("Device Default"),1:$zconvert(Charset,"O","HTML"))
					Set Skipped = 0
					Set EscapeObj = ##class(%CSP.HTMLEscape).%New()	
					Set tSC = ##class(%Global).Export($namespace, .tItems, FileName, OutputFormat, RecordFormat, "d", Charset, .Skipped)
					Kill EscapeObj
					If $$$ISERR(tSC) Write !,$zconvert($System.Status.GetErrorText(tSC),"O","HTML")
					If $O(Skipped(0)) '= "" {
						Write !,$$$TextHTML("The following mapped globals are skipped for the export"),":"
						Set skipped = 0
						For  Set skipped = $O(Skipped(skipped)) Quit:skipped=""  Write !,skipped,". ^",$ZCVT(Skipped(skipped),"O","HTML")
					}
					If $$$ISOK(tSC)  Write !!,msgComplete,$ZDT($h,3)

				} Else {
					Set tParms("ExportFormat") = ExportFormat
					Set tParms("OutputFormat") = OutputFormat
					Set tParms("RecordFormat") = RecordFormat
					Set tParms("Charset") = Charset
		 			Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("Export",$zu(5),.tParms,.tItems,.tJob)
					If $$$ISERR(status) Do ..LogMsg($System.Status.GetErrorText(status))
		 			&html<<h2>#(msg1)#&nbsp;<a href="#(linkpage)#">#(msg2)#</a></h2>>
				}
			}
			&html<</pre>>
		} Else {
			&html<<p nowrap>#($$$Text("Nothing selected."))#</p>>
		}
	} While(0)
	If $$$ISERR(tSC) Goto Trap
Done
	Do $System.Alarm.Clear()
	Quit tSC
Trap
	Set $ZT=""	
	If ($ZE["<ALARM>") {
		Set tText = $ZCVT($$$FormatText($$$Text("Export did not finish within %1 seconds. Please use background export for large files."), ..GetAlarmTimeout()),"O","HTML")
		Set tSC=$$$ERROR($$$GeneralError,tText)
	} ElseIf $ZE["<PROTECT>" {
		Set tSC = $$$ERROR(940)
	} Else {
		If $ZE '= "" Set tSC = $$$ERROR($$$GeneralError,$ZE)
		Else  Set tSC = 1
	}
	Goto Done
}

/// Validate export extension. Append correct extension if not valid.
ClassMethod GetExpExt(ExportFormat As %String, FileName As %String) As %String
{
	If ExportFormat = "XML" {
		If $E(FileName,$L(FileName)) = "." Quit FileName_"xml"
		If $ZCVT($E(FileName,$L(FileName)-3,$L(FileName)),"l") '= ".xml" Quit FileName _ ".xml"
	}
	If ExportFormat = "RO" {
		If FileName '[ "." Quit FileName_".ro"
		If $E(FileName,$L(FileName)) = "." Quit FileName_"ro"
		If $ZCVT($E(FileName,$L(FileName)-3,$L(FileName)),"l") = ".xml" Quit FileName _ ".ro"
	}
	If ExportFormat = "GO" {
		If FileName '[ "." Quit FileName_".gof"	
		If $E(FileName,$L(FileName)) = "." Quit FileName_"gof"
		If $ZCVT($E(FileName,$L(FileName)-3,$L(FileName)),"l") = ".xml" Quit FileName _ ".gof"

	}
	Quit FileName
}

/// Draw specific parameters for Classes/Routines/Globals
Method DrawParameters()
{
	Set ExportFormat = $G(%request.Data("ExportFormat",1))
	Set msgBackground = $$$TextHTML("Check here to run export in the background - recommended for exporting large files")
	Set msgExportOBJ = $$$TextHTML("Check here for exporting OBJ code")

	&html<<div class="note" style="margin-right:20px; margin-top:10px; border:1px gray solid;">>
	&html<<div style="padding-left:1px;"><input type="checkbox" name="chkBackground" id="chkBackground" #($S($G(%request.Data("chkBackground",1))'="":"checked",1:""))#>#(msgBackground)#</div>>
	If %request.PageName [ "Global" {
		Set OutputFormat = $G(%request.Data("OutputFormat",1),"7")
		Set RecordFormat = $G(%request.Data("RecordFormat",1),"V")
		Set ExportFormat = "GO"
		Set lblOutput = $$$Text("Output format")
		Set lblRecord = $$$Text("Record format")
		Set lblOutput1 = $$$Text("Sequential file")
		Set lblOutput2 = $$$Text("Block format (recommended for speed)")
		Set lblRecord1 = $$$Text("Variable Length Records")
		Set lblRecord2 = $$$Text("Stream Data")
		&html<
			<div id="LegacyFormat" style="display:#($S(ExportFormat="XML":"none",1:"block"))#">
			<table class="ParaForm" cellpadding="0" cellpadding="0"><tr><td>
			#(lblOutput)#: <select name="OutputFormat" id="OutputFormat">
			<option value="7" #($S(OutputFormat="7":"selected",1:""))#>#(lblOutput2)#</option>
			<option value="5" #($S(OutputFormat="5":"selected",1:""))#>#(lblOutput1)#</option>
			</select></td></tr>
			<tr><td>
			#(lblRecord)#: <select name="RecordFormat" id="RecordFormat">
			<option value="V" #($S(RecordFormat="V":"selected",1:""))#>#(lblRecord1)#</option>
			<option value="S" #($S(RecordFormat="S":"selected",1:""))#>#(lblRecord2)#</option>
			</select>
			</td></tr>
			</table>
			</div>
			>

		} ElseIf %request.PageName [ "Routine" {
			If ExportFormat = "" Set ExportFormat = "RO"  //YSD1411
			/* YSD1166 
			&html<
			<p class="ltcaption">
			Export Format: 
			<select name="ExportFormat" id="ExportFormat">
				<option value="RO" #($S(ExportFormat="RO":"selected",1:""))#>Routine Output Format (RO)</option>
				<option value="XML" #($S(ExportFormat="XML":"selected",1:""))#>XML</option>
			</select></p>>
			*/
		} Else {
			Set ExportFormat = "XML"
		}
		#;YSD2094
		If %request.PageName [ "Routine"!(%request.PageName [ "Class") {
			Set lblBeginDate = $$$Text("Begin date")
			Set lblEndDate = $$$Text("End date")
			Set tBeginDate = $G(%request.Data("txtBeginDate",1),$G(^CacheTemp.MgtPortalSettings($UserName,"EXPORTBEGINDATE")))
			Set tEndDate = $G(%request.Data("txtEndDate",1),$G(^CacheTemp.MgtPortalSettings($UserName,"EXPORTENDDATE")))
			&html<<div><table class="ParaForm" cellpadding="0" cellpadding="0">>
			&html<<tr><td>&nbsp;#(lblBeginDate)#:</td><td><input type="textbox" name="txtBeginDate" id="txtBeginDate" value='#(tBeginDate)#' size="12"></td>>
			&html<<td class="back-to-top"><a href="javascript:loadDate('T-1');" title='#($$$Text("Set Begin date to be yesterday"))#'>#($$$TextHTML("yesterday"))#</a></td>>
			&html<<td>&nbsp;#(lblEndDate)#:</td><td><input type="textbox" name="txtEndDate" id="txtEndDate" value='#(tEndDate)#' size="12"></td>>
			&html<<td class="back-to-top"><a href="javascript:loadDate('T');" title='#($$$Text("Set End date to be today"))#'>#($$$TextHTML("today"))#</a></td>>
			&html<</tr>>
			&html<<tr><td>&nbsp;</td>>
			&html<<td class="back-to-top">(YYYY-MM-DD)</td>>
			&html<<td>&nbsp;</td><td>&nbsp;</td>>
			&html<<td class="back-to-top">(YYYY-MM-DD)</td></tr>>				
			If %request.PageName [ "Routine" {
				&html<<tr><td colspan="6"><input type="checkbox" name="ExportOBJ" id="ExportOBJ" #($S($G(%request.Data("ExportOBJ",1))'="":"checked",1:""))# onclick="exportOBJ(this.checked);">#(msgExportOBJ)#</td></tr>>
			}
			&html<</table></div>>
		}
		&html<</div>>

		&html<</div>>
		&html<<input type="hidden" name="ExportFormat" id="ExportFormat" value='#($zconvert(ExportFormat,"O","HTML"))#'>>
}

Method DrawButtons(ColMax As %Integer)
{
	&html<<tr><td colspan="#(ColMax)#" align="left"><input type="button" name="SelectAll" value='#($$$Text("Select All"))#' onclick="toggleCheckboxes(true);">>
	&html<<input type="button" name="UnselectAll" value='#($$$Text("Unselect All"))#' onclick="toggleCheckboxes(false);">>
	&html<<input type="submit" name="OK" id="OK" value='#($$$Text("Export"))#' onclick="fileExists(form.RemoteFileName.value);return validate();"></td></tr>>
}

/// Method to Export in the background 
ClassMethod Export(FileName As %String, ExportFormat As %String, ByRef pParms As %String, ByRef tItems As %String) As %Status
{
#define LogError If $O(err("")) '="" Set errno = "" For  Set errno = $O(err(errno)) Quit:errno=""  Do ##class(%CSP.UI.SQL.LinkWizardResultPage).LogMsg(err(errno),msgError)
#define LogDone  Else  Do ..LogMsg($$$FormatText($$$Text("Completed at %1"),$ZDT($H)),msgDone)
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Set msgDone = $$$Text("Done")
	Set msgError = $$$Text("ERROR")
	Do {
		If ExportFormat = "GO" {
			Set tSC = ##class(%Global).Export($ZU(5), .tItems, FileName, $G(pParms("OutputFormat"),7), $G(pParms("RecordFormat"),"V"), "-d", $G(pParms("Charset")))
			If $$$ISERR(tSC) Do ..LogMsg($System.Status.GetErrorText(tSC))
			$$$LogDone
		} ElseIf ExportFormat = "XML" {
			Do $System.OBJ.Export(.tItems,.FileName,"-d",.err,$G(pParms("Charset")))
			$$$LogError
			$$$LogDone
		} ElseIf ExportFormat = "RO" {
			Do Export^%apiRTN(.tItems,FileName,,$G(pParms("Parameter")),"-d",.err)
			$$$LogError
			$$$LogDone
		}
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

/// Check to see if file exists
ClassMethod FileExists(filename)
{
	Set exists = ##class(%File).Exists(filename)
	&javascript<
	document.getElementById("FileExists").value = #(exists)#;
	>
}

Method DrawTable(ByRef pRS As %String)
{
	&html<<table class="DetailTable" border="0" cellpadding="2" cellspacing="0" bgcolor="#c4d6d6">>
	Set ColMax = 3
	Set tRow = 0
	Set tCol = 1
	Set tTotalRows = 1
	Set Filter = (%request.PageName [ "Routine"!(%request.PageName [ "Class"))
	If Filter {
		Set BeginDate = $G(%request.Data("txtBeginDate",1))
		Set EndDate = $G(%request.Data("txtEndDate",1))
		#; If this is the first time enter Export screen, use the defaults saved.
		If $G(%request.Data("Search",1)) = "" {
			Set BeginDate = $G(^CacheTemp.MgtPortalSettings($UserName,"EXPORTBEGINDATE"))
			Set EndDate = $G(^CacheTemp.MgtPortalSettings($UserName,"EXPORTENDDATE"))
		}
		Set DateError = 0, (pBeginDate,pEndDate) = ""
		If BeginDate '="" {
			If BeginDate'?4N1"-"1.2N1"-"1.2N Set BeginDate = "", DateError = 1
			Else  Set pBeginDate = ..GetDate(BeginDate) If 'pBeginDate Set DateError = 1
		}
		If EndDate '="" {
			If EndDate'?4N1"-"1.2N1"-"1.2N Set EndDate = "", DateError = 1
			Else  Set pEndDate = ..GetDate(EndDate) If 'pEndDate Set DateError = 1
		}
		If DateError &html<<tr><td nowrap>#($$$Text("Invalid date or date format. Please correct and try again."))#</td></tr></table>> Quit
		If pBeginDate > pEndDate &html<<tr><td nowrap>#($$$Text("End date is earlier than Begin date. Please correct and try again."))#</td></tr></table>> Quit
		Set ^CacheTemp.MgtPortalSettings($UserName,"EXPORTBEGINDATE")=BeginDate
		Set ^CacheTemp.MgtPortalSettings($UserName,"EXPORTENDDATE")=EndDate		
	}
	While pRS.Next() {
		Set DateTime = ""
		If Filter {
			Set DateTime = pRS.Data("Date")
			Set tDate = $S(DateTime'="":+$zdatetimeh(DateTime,3),1:0)
			If pBeginDate '= "",tDate<pBeginDate Continue
			If pEndDate '= "",tDate>pEndDate Continue
			If DateTime '= "" Set DateTime = $S(DateTime'="":"("_$P(DateTime," ",1)_")",1:"")
		}
		Set tRow = tRow + 1
		If tRow = 1 Do ..DrawButtons(ColMax) &html<<tr class="OddRow">>
		Set tId = "cb_"_tRow
		Set tName = pRS.GetData(1)
		&html<<td nowrap><input type="checkbox" name="#(tId)#" id="#(tId)#" value='#($zconvert(tName,"O","HTML"))#'>#($ZCVT(tName,"O","HTML"))# #($zconvert(DateTime,"O","HTML"))#</td>>
		If tCol < ColMax {
			Set tCol = tCol + 1
		} Else {
			Set tCol = 1
			Set tTotalRows = tTotalRows + 1
			&html<</tr>>
			&html<<tr class="#($S(tTotalRows#2:"OddRow",1:"EvenRow"))#">>
		}
	}
	For t = tCol:1:ColMax &html<<td>&#032;</td>>
	&html<<input type="hidden" name="TotalRows" id="TotalRows" value="#(tRow)#">>
	If tRow = 0 {
		&html<<td nowrap>#($$$Text("No match found."))#</td>>
	} Else {
		&html<<tr><td cols="3" nowrap>#($$$Text("Total: "))##(tRow)#</td>>
		If tRow > 1 {
			Do ..DrawButtons(ColMax)
		}

		&html<</table>>
	}
	&html<</form>>
}

/// Return date in $H format.
/// If invalid date is passed in, return 0.
Method GetDate(pDate) As %String
{
	Set $ZT = "Trap"
	Quit $zdatetimeh(pDate,3)
Trap
	Set $ZT=""
	Quit 0
}

}
