Include (%sqlui, %syAudit)

/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>This is the pane to prepare for action result. Display what user selected, with additional
/// parameter prompts if needed, and prompt the user to proceed or cancle.
Class %CSP.UI.System.ExpResultPane Extends %CSP.Page [ System = 4 ]
{

/// Default domain for the Portal's localization.
Parameter DOMAIN = "%Utility";

/// Ensure user has either %Admin_Manage:USE or %Admin_Operate:USE.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	Quit ($system.Security.Check($$$AdminManageResourceName,"USE") || $system.Security.Check($$$AdminOperateResourceName,"USE"))
}

ClassMethod OnPage() As %Status
{
	Set tMode = $G(%request.Data("cbAction",1))
	Set tNamespace = $G(%request.Data("$ID1",1))
	If tNamespace = "" Set tNamespace = $G(%request.Data("$NAMESPACE",1))
	If tMode["Audit"!(tMode["Application") Set tNamespace="%SYS"
	Set ID2 = $G(%request.Data("$ID2",1))
	Set cbState = $G(%request.Data("cbState",1))
	If $E(cbState) = "," Set cbState = $E(cbState,2,$L(cbState))
	Set IsDb = $G(%request.Data("cbSpace",1),0)
	If IsDb {
		If $E(tNamespace,1,2) '= "^^" Set tNamespace = "^^"_tNamespace
		If tMode["Global" For cnt=1:1 Set tName = $P(cbState,",",cnt) Quit:tName=""  If $E(tName'="^") Set $P(cbState,",",cnt)="^"_tName
	}
	Do ..LocalizePage(.msgPage)
	Set msgPage1 = $$$Text("Please enter a file name!")
	Set header = $G(msgPage(tMode),"UNKNOWN")
	Set BrowsePage = ..Link("/csp/sys/UtilFileSelect.csp",,1)
	//Set RefererPage = ..UnescapeURL(%request.CgiEnvs("HTTP_REFERER"))
	&html<<html>
	<head>
	<title>#(header)#</title>
	#($$$cspBrokerInsertJS)#
	<link rel="stylesheet" type="text/css" href='#(..Link("/csp/sys/intersystems.css"))#' title="Standard Style" >
	<style type="text/css">
.sd {
	border-bottom: white solid 1px;
	border-right: white solid 1px;
}
.caption1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 1.2em;
	color: black;
	text-align: left;
	font-weight: bold;
}
.caption2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 1.0em;
	color: black;
	text-align: left;
	font-weight: bold;
}

</style>
	<script language="javascript">
// set all the checkboxes true or false
function toggleCheckboxes(cbState)
{
	var cb;
	var TotalRows = document.getElementById("TotalRows").value;
	for (var i = 1; i <= TotalRows; i++) {
		cb = self.document.getElementById("cb_"+i);
		cb.checked = cbState;
	}
}//  gather state of check boxes and update cbState
function updateCBValues()
{
	var form = self.document.expform;
	if (form) {
		form.cbState.value = getCBValues();
	}
	//form.submit();
}
// Returns a csv list of values for selected checkboxes
// (with leading and trailing comma)
function getCBValues()
{
	var state = '';
	var cb;
	var TotalRows = document.getElementById("TotalRows").value;
	for (var i = 1; i <= TotalRows; i++) {
			cb = self.document.getElementById("cb_"+i);
			if (cb && cb.checked) {
				state += "," + cb.value;
			}
	}

	if (state != '') {
		state += ',';
	}
	return state;
}
/// For Integrity check, if user selected more than one database, then disable the Global button
function enableGlobalButton()
{
	var checked = getCBValues();
	if (checked != "") {
		var dirs = checked.split(",");
		if (dirs.length > 3) {
			document.getElementById("GlobalInteg").disabled = true;
		} else {
			document.getElementById("Directory").value = dirs[1];
			document.getElementById("GlobalInteg").disabled = false;
		}
	} else {
		var TotalRows = document.getElementById("TotalRows").value;
		var cb;
		for (var i = 1; i <= TotalRows; i++) {
			cb = self.document.getElementById("cb_"+i);
			if (cb) {
				cb.disabled = false;
			}
		}
		document.getElementById("Directory").value = "";
		document.getElementById("GlobalInteg").disabled = false;
		updateGlobals(0);			
	}
}
/// Disable or enable db checkboxes. If globals selected, then disable other DB checkboxes.
/// If user unchecked the only DB they have globals selected, then enable all and lose global selections.
function disableCheckboxes()
{
	var TotalRows = document.getElementById("TotalRows").value;
	var cb;
	for (var i = 1; i <= TotalRows; i++) {
		cb = self.document.getElementById("cb_"+i);
		if (cb && cb.checked == false) {
			cb.disabled = true;
		}
	}	
}
/// For Integrity check, user clicked the "Select Globals" button. Show the global selection 
function doGlobal()
{
	var dir = document.getElementById("Directory").value;
	if (dir == "") {
		alert('#($$$TextJS("Please select a database first."))#');
		return;	
	}
	var wid = 400;
	var hgt = 600;
	var top = self.screen.height * 0.1;
	var left = self.screen.width * 0.4;
	var url = '#(..Link("UtilSysSelGlobals.csp",,1))#dir=' + cspEncodeUTF8(dir);
	self.pagePopupWindow = window.open(url,'pagePopup','left='+left+',top='+top+',width='+wid+',height='+hgt+',scrollbars,resizable');
	self.pagePopupWindow.focus();			
}
/// returning from select globals page. Update the total for the database.
function updateGlobals(total)
{
	if (total > 0) {
		document.getElementById("idGlobals").innerHTML = '#($$$TextHTML("Total globals selected: "))#' + total;
		disableCheckboxes();
	} else {
		document.getElementById("idGlobals").innerHTML = '#($$$TextHTML("You may select specific globals for one selected database."))#';
	}
}
function gotoBrowse(number,param)
{
	if (number == 1) var remotefile = document.getElementById("RemoteFileName").value;
	else var remotefile = document.getElementById("LocalFileName").value;
	var url = "#(BrowsePage)#Dir=" + cspEncodeUTF8(remotefile) + "&" + param;
	return launchPopupWindow(url);

}
	function launchPopupWindow(page)
	{
		var wid = self.screen.width * 0.7;
		var hgt = self.screen.height * 0.5;
		var top = self.screen.height * 0.1;
		var left = self.screen.width * 0.1;
	  	var id = '$ID1=' + document.getElementById("$ID1").value;
	  	var questionmark = page.split("?");
	  	var url;
	  	if (questionmark.length > 1) url = page + "&" + id;
	  	else url = page + "?" + id;
		window.open(url,'browsepagePopup','left='+left+',top='+top+',width='+wid+',height='+hgt+',status,scrollbars,resizable');
		return false;
	}
  	// close button for end of popup
  	// If delete occurred then rebuild link because
  	// we cannot just reload the calling page especially
  	// if it's coming from a page link (ScrollID is not null)
  	// We must reload the whole page from server otherwise the
  	// delete routines will still be there on the page.
  	// 
	function popupClose()
	{
		if (opener) {
		opener.browsepagePopupWindow = null;
		} 
		var action = document.getElementById("Mode").value.substring(0,6)
		if ((action == "Delete") || (action == "Import") || (action == "Change") || (action == "Reset ")) {
			var openerlink = opener.document.location.href;
			var linkarr = openerlink.split("&");
			var len = linkarr.length;
			if (len > 3) len = 3;
			var link = linkarr[0];
			for(var i=1; i<(len); i++) {
				var link = link + "&" + linkarr[i];
			}
			opener.document.location.href = link;
		} else {
			// do not need to refresh unless it is Delete.
			//opener.document.location.reload();			
		}
		window.close();
		return true;
	}
	// If this is export, then set focus to cursor to LocalFilename
	function IsExport()
	{
		var mode = document.getElementById("Mode").value;
		mode = mode.substring(0,6);
		if ((mode == "Export") || (mode == "Import")) {
			document.expform.RemoteFileName.focus();	
		}
	}
// make sure user has entered a file name
function validate()
{
	var tMode = document.getElementById("Mode").value;
	var option = tMode.substring(0,3);
	if ((option == "Imp") || (option == "Exp")) {
		var filename = document.getElementById("RemoteFileName").value;
		if (document.getElementById("SaveToRemote").checked) {
			islocal = 0;
		} else {
			// set Local file name into FileName for submit because of the problems with type=file 
			var filename = document.getElementById("LocalFileName").value;
			document.getElementById("FileName").value = filename;
			islocal = 1;
		}
		if (filename == "") {
			alert("#(msgPage1)#");
			if (islocal) document.getElementById("LocalFileName").focus();
			else document.getElementById("RemoteFileName").focus();
			return false;
		}
	} 
	updateCBValues();
	return true;
	}
	
// generic function called from /csp/sys/UtilFileSelect.csp
function update(remotefile)
{
	document.getElementById("RemoteFileName").value = remotefile;
}

	</script>
	<style>
	div.div {
	margin: 20px;
	}
	</style></head>
	<body onLoad="self.focus();" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	>
	Set image1 = ..Link("/csp/sys/images/title-cache-ctech_01.jpg")
	Set refreshpage = ##class(%CSP.Portal.Utils).GetValidatedLink($G(%request.CgiEnvs("HTTP_REFERER")))
	If refreshpage = "",tMode = "DeleteQuery" Set refreshpage = ..Link("/csp/sys/exp/UtilSqlSchemas.csp")_"?$ID1="_$G(%request.Data("$NAMESPACE",1))_"&$NAMESPACE="_$G(%request.Data("$NAMESPACE",1))
	Do ##class(%CSP.Util.AutoPage).DrawTitle(header)
	#;YSD1696 - for Safari, you need to set the target otherwise you can't close the window afterwards
	Set target = $S(%session.BrowserName'["Safari":"",1:"_blank")
	&html<
	<form name="expform" action="%25CSP.UI.System.ExpResultPage.cls" method="post" target="#(target)#" enctype="multipart/form-data" onsubmit="return validate();">
		<input type="hidden" name="$ID1" id="$ID1" value="#($ZCVT(tNamespace,"O","HTML"))#">
		<input type="hidden" name="$ID2" id="$ID2" value="#($ZCVT(ID2,"O","HTML"))#">
		<input type="hidden" name="cbSpace" id="cbSpace" value="#($ZCVT(IsDb,"O","HTML"))#">
		<input type="hidden" name="Mode" id="Mode" value="#($ZCVT(tMode,"O","HTML"))#">
		<input type="hidden" name="cbState" id="cbState" value="#($ZCVT(cbState,"O","HTML"))#">
		<input type="hidden" name="numRows" id="numRows" value="#($L(cbState,",")-1)#">
		<input type="hidden" name="$NAMESPACE" id="$NAMESPACE" value="#($ZCVT($G(%request.Data("$NAMESPACE",1)),"O","HTML"))#">
		<input type="hidden" name="FileName" id="FileName" value="">
		<input type="hidden" name="refreshpage" id="refreshpage" value="#($ZCVT(refreshpage,"O","HTML"))#">
		<input type="hidden" name="Directory" id="Directory" value="">
	>
	If (tMode [ "Compile") {
		Set tSelected = ..DrawCompileSelections(tNamespace, tMode, cbState)	
	} ElseIf (tMode [ "Delete") {
		Set tSelected = ..DrawDeleteSelections(tNamespace, tMode, cbState)
	} ElseIf (tMode [ "Export") {
		Set tSelected = ..DrawExportSelections(tNamespace, tMode, cbState)
	} ElseIf (tMode [ "Import") {
		Set tSelected = ..DrawImportSelections(tNamespace, tMode, cbState)
	} ElseIf (tMode = "LanguageMode") {
		Set tSelected = ..DrawLangSelections(tNamespace, tMode, cbState)
	} ElseIf (tMode [ "IntegrityCheck - Databases") {
		Set tSelected = ..DrawDatabaseIntegrity(tMode, cbState)
	} ElseIf (tMode [ "Change Status AuditEvent") {
		Set tSelected = ..DrawChangeStatusAuditEvent(tMode, cbState)
	} Else {
		&html<<div class="div" id="idHeader"><h2>#(msgPage("PleaseReview"))#&nbsp;<b>#($ZCVT(tNamespace,"O","HTML"))#</b>:</h2></div>>
		//YSD1085 Do ..DrawProgressImg()

		// Defaults for other non-specific options, such as Compact Globals
		Set tSelected = ..DrawSelectedTable(cbState)
		If tSelected = 0 {
			&html<<tr class="EvenRow"><td colspan="2" class="DetailValue">#($$$Text("None selected."))#</td></tr>>
		} Else {
			&html<<tr class="EvenRow"><td colspan="2" class="DetailValue"><center>>
			&html<<input type="submit" name="OK" id="OK" value='#($$$Text(" OK "))#'></center></td></tr>>
			Do ..HelpTextCancel()
		}
		&html<</table></form>>
	}
			&html<<hr>>

	Do ..DrawCloseButton()
	&html<<br>
	>

	&html<</body>
	</html>>
	Quit $$$OK
}

/// Write common message after action is commited.
ClassMethod DoneMsg(tSC)
{
	Write " "
	If tSC = 1 Write $$$Text("Done")
	Else  Write ..EscapeHTML($System.Status.ErrorText(tSC))
}

ClassMethod DrawCloseButton()
{
	&html<<div class="div" align="left"><input type="button" value='#($$$Text("Close"))#' onclick="popupClose();"></div>>
}

ClassMethod DrawProgressImg()
{
	&html<
		<div id="idProcess" style="display:none" align="center"><img src="#(..Link("/csp/sys/images/aniclock0.gif"))#" width="100" height="100" border="0"></div>
	>
}

/// Write out error log
ClassMethod DrawErrorLog(err)
{
	If $G(err) > 0 {
		Write !,"Error Log: "
		Set errcnt = $o(err(""))
		While errcnt '= "" {
			Write !,errcnt,?10,$g(err(errcnt))
			Set errname = ""
			For  Set errname = $O(err(errcnt,errname)) Quit:errname=""  Write !,?5,..EscapeHTML(errname),?25,..EscapeHTML($G(err(errcnt,errname)))
			Set errcnt = $o(err(errcnt))	
		}
		Write !
	}
}

ClassMethod DrawChangeStatusAuditEvent(tMode As %String, cbState As %String) As %Integer
{
		&html<<h2>#($$$Text(" You have selected to change status of the following audit event:"))#</h2>>
		&html<<div class="div" id="idHeader"><h2>#($$$Text("Please review."))#</h2></div>>
		
		&html<<table class="DetailTable" border="0" cols="2" cellspacing="0" cellpadding="3">>
		&html<<tr><th>#($$$Text("Selected Items"))#</th><th>#($$$Text("Old Status"))#</th><th>#($$$Text("New Status"))#</th>>
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		While tName '= "" {
			set cbName = "cb_"_tRow
			If ##Class(Security.Events).Exists(tName,,,.Event,.Status) {
				Set Man = $zb(+Event.Flags,$$$EventFlagSystem+$$$EventFlagMandatory,1)=($$$EventFlagSystem+$$$EventFlagMandatory)
				Set Old = $S(Event.Enabled=1:$$$Text("Enabled = Yes"),1:$$$Text("Enabled = No"))
				Set New = $S(Event.Enabled=1:$$$Text("Enabled = No"),1:$$$Text("Enabled = Yes"))
			&html<<tr class="EvenRow"><td class="sd" nowrap>>
				If Man {
					Set New = $$$Text("Event is Mandatory. Status cannot be changed.")
					&html<#(..EscapeHTML(tName))#>
				} Else {
				&html<<input type="checkbox" value="#(..EscapeHTML(tName))#" id="#(cbName)#" checked>
				#(..EscapeHTML(tName))#>
				}
				&html<<td class="sd" nowrap>#(Old)#</td><td class="sd" nowrap>#(New)#</td></tr>>
				Kill Event
			} Else {
				&html<<tr class="OddRow" colspan="3"><td nowrap>#(..EscapeHTML(tName))# #($$$Text("no longer exists."))#</td></tr>>		
			}
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
		Set tSelected = $L(cbState,",")-1
		If tSelected = 0 {
		&html<
			<tr class="EvenRow"><td colspan="3" class="DetailValue">#($$$TextHTML("None selected."))#</td></tr>>
		} 
		Else {
			&html<<tr class="EvenRow"><td colspan="3" class="DetailValue"><center><input type="submit" name="OK" id="OK" value='#($$$Text(" OK "))#'></center></td></tr>>
		}
		&html<</table></form>>
		Do ..HelpTextCancel()
		Quit tSelected
}

ClassMethod DrawExportSelections(tNamespace As %String, tMode As %String, cbState As %String) As %Integer
{
		&html<<div class="div" id="idHeader"><h2>#($$$Text("Please review what you have selected from "))#<b>#(..EscapeHTML(tNamespace))#</b> #($$$Text("and enter file/directory name:"))#</h2>>
		

		Set tSelected = ..DrawSelectedTable(cbState)
		Set OkDraw = $S(tSelected > 0:1,1:0)
		If tSelected = 0 {
			&html<<tr class="EvenRow"><td colspan="2" class="DetailValue">#($$$Text("None selected."))#</td></tr>>
		} 

		/*If tSelected = 0 {
			&html<<tr class="EvenRow"><td colspan="2" class="DetailValue">None selected.</td></tr>>
			If tMode = "Export" {
				&html<
				<tr><th colspan="2">Other Export Choices:</th></tr>
				<tr class="EvenRow"><td colspan="2" class="DetailValue">
				<input type="radio" name="ExportAll" value="ExportAll" checked>Export all the classes in this namespace as one large XML file
				<br><input type="radio" name="ExportAll" value="ExportAllInd">Export all the classes as individual XML files to a directory
				</td></tr>
				>
				Set OkDraw = 1
			}
		} */
		If OkDraw = 1 {
		&html<
			<tr class="EvenRow" nowrap><th colspan="2">
			#($$$TextHTML("Export Format: XML"))#<input type="hidden" name="ExportFormat" id="ExportFormat" value="XML">
			>			
		}
		
			&html<
			</th></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue" nowrap><input type="radio" name="SaveTo" id="SaveToRemote" value="Remote" checked>#($$$TextHTML("Export to remote file/directory"))#:<br>&nbsp;&nbsp;
			<input type="text" name="RemoteFileName" id="RemoteFileName" size="40">
			<input type="button" name="RemoteBrowse" value='#($$$Text("Browse..."))#' onclick="return gotoBrowse('1','Wizard=Save&Wild=*.xml');">
			>
			// Export cannot have Local File because unless they have Cache installed, we cannot export to local file.
			If tMode '[ "Export" {
			&html<
			<br><input type="radio" name="SaveTo" id="SaveToLocal" value="Local">#($$$TextHTML("Export to local file/directory"))#:<br>&nbsp;&nbsp;
			<input type="file" name="LocalFileName" id="LocalFileName" size="40"></td></tr>
			>
			}
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue"><center>
			<input type="submit" name="OK" id="OK" value=#($$$Text(" OK "))#></center>
			</td></tr>
			>
			
		 // end of OkDraw = 1
		&html<</table></form>>
		//Do ..HelpTextCancel()
		Quit tSelected
}

ClassMethod DrawImportSelections(tNamespace As %String, tMode As %String, cbState As %String) As %Integer
{
	//Set ImportWhat = $S(tMode["Global":"G",tMode["Routine":"R",1:"C")
	
		&html<<div class="div" id="idHeader">>
		/*
		<h2>Import 
		<select name="ImportWhat" id="ImportWhat">
		<option value="Import" #($S(ImportWhat="C":"selected",1:""))#>Class</option>
		<option value="ImportRoutine" #($S(ImportWhat="R":"selected",1:""))#>Routine</option>
		<option value="ImportGlobal" #($S(ImportWhat="G":"selected",1:""))#>Global</option>
		</select></h2>
		*/
		If tMode ["Audit"!(tMode ["Application") Set hideNamesapce = "none"
		Else  Set hideNamesapce = "block"
		&html<<div id="ImportToNamespace" style="display:#(hideNamesapce)#">>
		&html<<h2>#($$$Text("Import to Namespace: "))#<select name="Namespace" id="Namespace">>
			Set tCnt = ##class(%CSP.Util.SMNavigatorPane).GetAllNamespaces(.Namespaces)
		// make list of namespaces
		If tNamespace = "" Set tNamespace = $G(%Session.Data("$NAMESPACE"))
		For i=1:1:tCnt {
			Set sel = $S(Namespaces(i) = tNamespace:"selected",1:"")
			&html<<option value="#(..EscapeHTML(Namespaces(i)))#" #(sel)#>#(..EscapeHTML(Namespaces(i)))#> 
		}
		&html<</select></h2></div>>

		&html<
		</div>>
		
		Set lblImport1 = $$$Text("Import from remote file/directory:")
		Set lblImport2 = $$$Text("Import from local file/directory:")
		Set lblBrowse = $$$Text("Browse...")
		If %request.Get("ShowFile") '= "" Set tSelected = ..DrawImportTable()
		Else  &html<<table class="DetailTable" border="0" cols="2" cellspacing="0" cellpadding="3">>
			&html<
			</th></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue" nowrap>
			<input type="radio" name="SaveTo" id="SaveToRemote" value="Remote" checked>#(lblImport1)#<br>&nbsp;&nbsp;
			<input type="text" name="RemoteFileName" id="RemoteFileName" size="40">
			<input type="button" name="RemoteBrowse" value="#(lblBrowse)#" onclick="return gotoBrowse('1','Wizard=Open&Wild=*.xml');">
			<br><input type="radio" name="SaveTo" id="SaveToLocal" value="Local">#(lblImport2)#<br>&nbsp;&nbsp;
			<input type="file" name="LocalFileName" id="LocalFileName" size="40"></td></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue"><center>>
			&html<<input type="submit" name="OK" id="OK" value='#($$$Text(" OK "))#'></center>
			</td></tr>
			>

		&html<</table></form>>
		Do ..HelpTextCancel()
		Quit $$$OK
}

ClassMethod DrawCompileSelections(tNamespace As %String, tMode As %String, cbState As %String) As %Integer
{
		If tMode = "CompileAll" &html<<h2>#($$$TextHTML("You are about to compile ALL CLASSES in this namespace!"))#</h2>>
		&html<<div class="div" id="idHeader"><h2>#($$$TextHTML("Please review what you have selected from namespace"))# <b>#(..EscapeHTML(tNamespace))#</b> #($$$TextHTML("to compile:"))#</h2></div>>
		

		Set tSelected = 1
		If tMode '= "CompileAll" {
			Set tSelected = ..DrawSelectedTable(cbState)
			If tSelected = 0 {
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue">#($$$TextHTML("None selected."))#</td></tr>>
			} 
		} Else {
			&html<
			<table class="DetailTable" border="0" cols="2" cellspacing="0" cellpadding="3">
			<tr><th>#($$$TextHTML("Selected Items"))#</th>
			<tr class="EvenRow"><td colspan="2" class="DetailValue">#($$$TextHTML("All Items!"))#</td></tr>>
		}
		If tSelected > 0 {
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue"><center>
			<input type="submit" name="OK" id="OK" value=" OK "></center>
			</td></tr>
			>
		}
		&html<</table></form>>
		Do ..HelpTextCancel()
		Quit tSelected
}

// Let user select options for deleting routines

ClassMethod DrawDeleteSelections(tNamespace As %String, tMode As %String, cbState As %String) As %Integer
{
	If tMode = "DeleteRoutine" Set header = $ZCVT($$$FormatText($$$Text("Please review what you have selected from namespace %1 and select delete options"),tNamespace),"O","HTML")
	Else  Set header = $$$TextHTML("Please review what you have selected to delete")
		&html<<div class="div" id="idHeader"><h2>#(header)#:</h2></div>>
	If tMode [ "DeleteError" {
		If tMode [ "ByNamespace" Set header = $$$TextHTML("Delete errors from selected namespaces")
		Else  Set header = $$$TextHTML("Delete errors from Namespace")_": "_$ZCVT(tNamespace,"O","HTML")
		If tMode [ "ByError",tMode'["ODBC" Set header = header_" "_$$$TextHTML("Date")_": "_$ZCVT($G(%request.Data("$ID2",1)),"O","HTML")
		&html<<div class="div" id="idHeader"><h2>#(header)#</h2></div>>	
	}
		

		Set tSelected = ..DrawSelectedTable(cbState)
		If tSelected = 0 {
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue">#($$$TextHTML("None selected."))#</td></tr>>
		} Else {
			/*
			If tMode = "DeleteRoutine" {
			&html<
			<tr><th colspan="2">Please specify what to delete:</th></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue">
			<input type="radio" name="dflag" value="0" checked>Delete entire routine, for a MAC routine this will delete MAC, INT, OBJ. For an INT routine it will delete INT and OBJ, for a INC routine it will only delete the INC, for a BAS routine it will delete the BAS and the OBJ code, for a MVB routine it will delete the MVB and the OBJ code. 
			</td></tr><tr class="EvenRow"><td colspan="2" class="DetailValue"><input type="radio" name="dflag" value="1">Delete just the named routine, for example for a MAC routine it will only delete the MAC and it will leave the INT and OBJ if present.
			</td></tr><tr class="EvenRow"><td colspan="2" class="DetailValue"><input type="radio" name="dflag" value="2">Delete all the source code but leave any OBJ code.
			 </td></tr>>
			} 
			*/
			If tMode '= "DeleteQuery" {
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue"><center>
			<input type="submit" name="OK" id="OK" value=#($$$TextHTML(" OK "))#></center>
			</td></tr>
			>
			}
		}
		If tMode = "DeleteQuery" {
			Set defaultNS = $G(%request.Data("$NAMESPACE",1))
			Set TableName = $G(%request.Data("$ID2",1))
			Set SchemaName = tNamespace
			&html<
				<input type="hidden" name="SchemaName" id="SchemaName" value="#(..EscapeHTML(SchemaName))#">
				<input type="hidden" name="TableName" id="TableName" value="#(..EscapeHTML(TableName))#">
				<input type="hidden" name="Namespace" id="Namespace" value="#(..EscapeHTML(defaultNS))#">
			>
			&html<
			<tr><th colspan="2">#($$$TextHTML("Delete Options"))#:</th></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue" nowrap>
			<input type="radio" name="dflag" value="0" #($S(tSelected'=0:"checked",1:""))#>#($$$TextHTML("Delete selected items only"))#
			</td></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue" nowrap>
			<input type="radio" name="dflag" value="1" #($S(tSelected=0:"checked",1:""))#>#($ZCVT($$$FormatText($$$Text("Delete ALL cached queries in namespace %1 "),defaultNS),"O","HTML"))#
			</td></tr>
			>
			If TableName '= "" {
				Set tTbl = SchemaName_"."_TableName
			&html<<tr class="EvenRow"><td colspan="2" class="DetailValue" nowrap><input type="radio" name="dflag" value="3" checked>#($ZCVT($$$FormatText($$$TextHTML("Delete all queries for table %1 "),tTbl),"O","HTML"))#
			</td></tr>>
		    }	
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue"><center>
			<input type="submit" name="OK" id="OK" value='#($$$TextHTML(" OK "))#'></center>
			</td></tr>
			>
		}
		&html<</table></form>>
		Do ..HelpTextCancel()
		Quit tSelected
}

/// Let user select options for setting Language Mode for routines
/// This method is not being used because the language mode has been commented out per Joe.
ClassMethod DrawLangSelections(tNamespace As %String, tMode As %String, cbState As %String) As %Integer
{
		&html<<div class="div" id="idHeader"><h2>#($$$TextHTML("Please review what you have selected from namespace"))# <b>#(..EscapeHTML(tNamespace))#</b> and select a language mode:</h2></div>>
		

		Set tSelected = ..DrawSelectedTable(cbState)
		If tSelected = 0 {
			&html<
			<tr class="EvenRow"><td colspan="2" class="DetailValue">#($$$TextHTML("None selected."))#</td></tr>>
		} Else {
			&html<
			<tr><th colspan="2">#($$$TextHTML("Please specify Language Mode:"))#</th></tr>
			<tr class="EvenRow"><td colspan="2" class="DetailValue">
			<select name="langmode">
			    <option value="0" selected>Cache</option>
    			<option value="1">DSM-11
    			<option value="2">DTM
    			<option value="3">Ipsum
    			<option value="4">Cobra
    			<option value="5">DSM-VMS
    			<option value="6">DSM-J
    			<option value="7">DTM-J
    			<option value="8">MSM
			</select>
			 </td></tr>
			 <tr class="EvenRow"><td colspan="2" class="DetailValue"><center>
			<input type="submit" name="OK" id="OK" value=" OK "></center>
			</td></tr>
			>
		}
		&html<</table></form>>
		//&html<</table></form>>
		Do ..HelpTextCancel()
		Quit tSelected
}

/// Draw what user has selected
ClassMethod DrawSelectedTable(cbState) As %Integer
{
	&html<<table class="DetailTable" border="0" cols="2" cellspacing="0" cellpadding="3"><tr><th>#($$$Text("Selected Items"))#</th>>
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		While tName '= "" {
			set cbName = "cb_"_tRow
			&html<
				<tr class="EvenRow"><td class="sd" nowrap>
				<input type="checkbox" value="#(..EscapeHTML(tName))#" id="#(cbName)#" checked>
				#(..EscapeHTML(tName))#</tr>>
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
	&html<<input type="hidden" name="TotalRows" id="TotalRows" value="#(tRow-1)#">>
	Quit $L(cbState,",")-1
}

/// Draw what items are in the importing file
ClassMethod DrawImportTable() As %Integer
{
	&html<<table class="DetailTable" border="0" cols="2" cellspacing="0" cellpadding="3"><tr><th>#($$$Text("Import File Contains"))#</th>>
	Set FileName = ..GetFileName()
	If FileName = "" Quit
	Set loadlist = ""
	Set listonly = 1
	Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
	Do $System.OBJ.Load(FileName,,.err,.loadlist,listonly)
	Kill EscapeObj
	If $G(err) Do ..DrawErrorLog()
	If loadlist = "" Quit
	Set tName = $P(loadlist,",",1)
	Set tRow = 1
	While tName '= "" {
		//Set checked="checked"
		//If %request.Get("OK")'="",%request.Get(tName) = "" Set checked=""
		&html<
			<tr class='EvenRow'><td class="DetailValue" nowrap>
			<input type="checkbox" name="#(..EscapeHTML(tName))#" #(checked)#>
			#(..EscapeHTML(tName))#</tr>>
			Set tRow = tRow + 1
			Set tName = $P(loadlist,",",tRow)			
	}
	Quit tRow
}

ClassMethod DrawDatabaseIntegrity(tMode, cbState) As %Integer
{
	If tMode [ "background" {
		Set header = $$$Text("This Integrity Check will be run in the background and the result will be saved in a file you designate below.")
	} Else {
		Set header = $$$Text("This Integrity Check will be run in the forground and the result will be shown momentarily.")
	}
	Set msg1 = $$$Text("Please check the databases that you want to perform the Integrity Check:")
	Set msg2 = $$$Text("Please enter a file name for saving the result:")
	Set lblSelect = $$$Text("Select All")
	Set lblUnSelect = $$$Text("Unselect All")
	Set lblBrowse = $$$Text("Browse...")
	Set lblStopAfterError = $$$Text("Stop after any error")
	Set lblWhen = $$$Text("When ready, click the OK button:")
	Set cmdOK = $$$Text("OK")
	Set lblName = $$$TextHTML("Name")
	Set lblDirectory = $$$TextHTML("Directory")
	Set lblGlobalInteg = $$$TextHTML("Select Globals")
	Set lblSelectGlobal = $$$TextHTML("You may select specific globals for one selected database.")

		&html<<div class="div" id="idHeader"><h2>#(header)#</h2></div>
		<table class="DetailTable" border="1" cols="2" cellspacing="0" cellpadding="3">
		<tr><td colspan="2" nowrap class="caption1">#(msg1)#</td></tr>
		<tr><th nowrap>#(lblName)#</th><th nowrap>#(lblDirectory)#</th>>
		Set tRS = ##class(%ResultSet).%New("Config.Databases:CompactLocalDBList")
		Do tRS.Execute()
		Set tRow = 0
		While tRS.Next() {
			Set tRow = tRow + 1
			Set cbName = "cb_"_tRow
			Set cls = $S(tRow#2:"EvenRow",1:"OddRow")
			&html<
				<tr class="#(cls)#"><td class="sd" nowrap>
				<input type="checkbox" value="#(tRS.Get("Directory"))#" name="#(cbName)#" id="#(cbName)#" onclick="enableGlobalButton();">#(..EscapeHTML(tRS.Get("Name")))#</td>
				<td class="sd" nowrap>#(..EscapeHTML(tRS.Get("Directory")))#</td></tr>>
				
		}
		&html<
			<input type="hidden" name="TotalRows" id="TotalRows" value="#(tRow)#">
			<tr><td colspan="2"><input type="button" name="SelectAll" value="#(lblSelect)#" onclick="toggleCheckboxes(true);">
			<input type="button" name="UnselectAll" value="#(lblUnSelect)#" onclick="toggleCheckboxes(false);">
			<input type="button" name="GlobalInteg" value="#(lblGlobalInteg)#" id="GlobalInteg" onclick="doGlobal();">
			<div id="idGlobals">#(lblSelectGlobal)#</div></td></tr>
			<tr><td colspan="2" nowrap class="caption2">#(msg2)#<br>&nbsp;&nbsp;
			<input type="text" name="RemoteFileName" id="RemoteFileName" size="40" value="#($zu(12))#integ.txt">
			<input type="button" name="RemoteBrowse" value="#(lblBrowse)#" onclick="return gotoBrowse('1','Wizard=Save&Wild=*.log');">
			<tr><td colspan="2" class="caption2"><input type="checkbox" name="StopAfterError">#(lblStopAfterError)#</td></tr>
			<tr class="EvenRow"><td colspan="2" class="caption2">#(lblWhen)#
			<input type="submit" name="OK" id="OK" value="#(cmdOK)#"></center>
			</td></tr>
			>
		&html<</table></form>>
		Quit $$$OK
}

/// Return FileName user entered
ClassMethod GetFileName() As %String
{
	Set SaveTo = %request.Get("SaveTo")
	Set FileName = $S(SaveTo="Local":%request.Get("LocalFileName"),1:%request.Get("RemoteFileName"))
	Set FileName = $zstrip(FileName,"<>W")
	Quit FileName
}

ClassMethod HelpTextCancel()
{
	If $G(%request.Data("OK",1)) = "" &html<<div class="div">#($$$Text("Click the [OK] button to proceed, or click the [Close] button to cancel."))#</div>>
}

/// Return displable Mode Title
ClassMethod LocalizePage(ByRef msgPage As %String) As %String
{
	Set msgPage("DeleteQuery") = $$$Text("Delete Query")
	Set msgPage("LanguageMode") = $$$Text("Language Mode")
	Set msgPage("DeleteErrorByError") = $$$Text("Delete Application Errors")
	Set msgPage("DeleteErrorByDate") = $$$Text("Delete Application Errors by Date")
	Set msgPage("DeleteErrorByNamespace") = $$$Text("Delete Application Errors by Namespace")
	Set msgPage("DeleteErrorODBCByError") = $$$Text("Delete xDBC Errors")
	Set msgPage("DeleteErrorODBCByNamespace") = $$$Text("Delete xDBC Errors by Namespace")
	Set msgPage("CopyMapsFrom") = $$$Text("Copy Namespace Mappings")
	
	Set msgPage("ExportApplications") = $$$Text("Export Applications")
	Set msgPage("ImportApplications") = $$$Text("Import Applications")

	Set msgPage("IntegrityCheck - Databases") = $$$Text("Integrity Check - Databases")
	Set msgPage("IntegrityCheck - Databases (background job)") = $$$Text("Integrity Check - Databases")
	Set msgPage("Change Status AuditEvent") = $$$Text("Change Status AuditEvent")
	
	Set msgPage("EnableEnsNamespace") = $$$Text("Enable Ensemble Namespace")
	
	Set msgPage("PleaseReview") = $$$Text("Please review what you have selected from ")
}

}
