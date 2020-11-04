Include %sqlui

/// This page allows to print execute query result to a printer.
Class %CSP.UI.Portal.SQL.PrintQuery Extends %ZEN.Component.page [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

/// Displayed name of this page.
Parameter PAGENAME = "PrintQuery";

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.SQL.PrintQuery.zen";

Parameter RESOURCE = "%Development";

/// Display title of this page <title></title>
Parameter PAGETITLE = "Print Query";

/// Domain used for localization.
Parameter DOMAIN = "%Utility";

/// Switch namespace for this page: 
Parameter AUTONS As %Boolean = 1;

/// Namespace passed in from URL.
Property NAMESPACE As %String(ZENURL = "$NAMESPACE");

/// History Id passed in from URL.
Property HistoryId As %String(ZENURL = "$ID1");

/// Save to file name
Property FileName As %String;

Property RuntimeMode As %ZEN.Datatype.string(ZENURL = "RuntimeMode") [ InitialExpression = "2" ];

Property Dialect As %ZEN.Datatype.string(ZENURL = "Dialect") [ InitialExpression = "Nothing" ];

Property ObjectSelectMode As %ZEN.Datatype.boolean(ZENURL = "ObjectSelectMode") [ InitialExpression = 0 ];

Property MaxRows As %ZEN.Datatype.string(ZENURL = "MaxRows") [ InitialExpression = "1000" ];

Property ShowRowNum As %ZEN.Datatype.boolean(ZENURL = "ShowRowNum") [ InitialExpression = 0 ];

Property msgSelect As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Please enter a file name.")} ];

Property msgValidate As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("File already exists. Overwrite the existing file?")} ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
a.link {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size:0.8em;		
}
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<vgroup cellStyle="padding-top:2px;" containerStyle="padding:10px;">
<hgroup cellStyle="padding-right:2px;">
<button caption="Close" onclick="zenPage.doClose();" valign="top"/>
<button caption="Print" title="Print the current page. Click to select a printer" onclick="zenPage.doPrint();" valign="top"/>
<checkbox id="chkExport" caption="Export to File" captionClass="normal" title="Export query results to a file. Click to select options." onclick="zenPage.show('groupExport');" valign="top"/>
<vgroup id="groupExport" labelPosition="left" hidden="true" valign="top"  enclosingStyle="padding:4px;background:#F1F1F1;">
<select id="selDisplayMode" label="File Format" labelClass="normal" title="Select a file format" showEmpty="false" 
displayList="xml,html,pdf,txt,csv" 
valueList="0,1,2,99,100" 
value="2"
onchange="zenPage.updateFileExt(zenThis.value);"
/>
<hgroup cellVAlign="bottom" label="File Name" labelClass="normal" labelPosition="left" title="Enter a directory and filename. If no directory is entered, the manager Temp directory will be used.">
<text id="txtFileName" size="70" value="queryText" hint="File Format is always used as the file extension in the export." hintClass="helpText" title="You may leave the file extension out."/>
<button caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect();" valign="top"/>
</hgroup>
<button caption="Export" title="Click to start exporting job in the background" onclick="zenPage.doSave();"/>
</vgroup>
</hgroup>
<vgroup id="idResult" hidden="true">
<label id="idFileName" label="The export task will be run in the background."/>
<link id="idFileLink" caption="Click here to view the background tasks page." href="/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen"/>
</vgroup>
<link caption="Query" href="javascript:zenPage.show('show');"/>
<vgroup id="show" hidden="false">
<label id="QueryText"/>
</vgroup>

<link caption="Result" href="javascript:zenPage.show('htmlResult');"/>
<html id="htmlResult" OnDrawContent="DrawHTML"/>

</vgroup>
</page>
}

/// Prepare to start printing
ClientMethod doPrint() [ Language = javascript ]
{
	window.print();
}

/// User clicked the Browse button.
ClientMethod browseSelect() [ Language = javascript ]
{
	var File = zen("txtFileName").getValue();
	var wildcard = this.getWildcard(zen("selDisplayMode").getValue());
	zenLaunchPopupWindow('%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(File)+'&wildcard='+wildcard,'FileSelect','resizable,width=600,height=700');
}

ClientMethod getWildcard(value) [ Language = javascript ]
{
	if (value == 0) return "*.xml";
	if (value == 1) return "*.html";
	if (value == 2) return "*.pdf";
	if (value == 99) return "*.txt";
	if (value == 100) return "*.csv";
	return ""
}

/// User changed File Format. Update the file extension in the file name.
ClientMethod updateFileExt(Format) [ Language = javascript ]
{
	var newFileName = this.GetFile(Format,zen("txtFileName").getValue());
	zen("txtFileName").setValue(newFileName);
}

/// Prepare to start export
ClientMethod doSave() [ Language = javascript ]
{
	var DisplayMode = zen("selDisplayMode").getValue();
	// make sure that the extension matches the File Format selected in case user has changed it.
	this.updateFileExt(DisplayMode);

	var FileName = zen("txtFileName").getValue();
	var ok = this.ValidateFile(FileName);
	if (ok == 0) {
		alert(this.msgSelect);
		zen("txtFileName").focus();
		return;
	}
	if (ok == 2) {
		if (!confirm(this.msgValidate)) {
			zen("txtFileName").focus();
			return;
		}
	}
	var ok = this.StartExport(this.HistoryId,FileName,DisplayMode,this.RuntimeMode,this.Dialect,this.ObjectSelectMode);
	this.getComponentById("idResult").setHidden(false);
	this.getComponentById("idFileName").setProperty("value",FileName);
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			zen("txtFileName").setValue(value);
		}
	} catch (ex) {
		alert("Error: " + ex);
	}
}

ClientMethod doClose() [ Language = javascript ]
{
	this.cancelPopup();
}

/// Show or hide the other information
ClientMethod show(name) [ Language = javascript ]
{
	var nameObj = zenPage.getComponentById(name);
	nameObj.setProperty("hidden",!nameObj.getProperty("hidden"));
	if (name == "groupExport") {
		// if user checks the Export checkbox, show or hide the current result to make the page clearner.
		var flag = 	nameObj.getProperty("hidden");
		zen("htmlResult").setHidden(!flag);
	}
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set ..%GetComponentById("htmlResult").label = $$$Text("Namespace: ")_$G(%request.Data("$NAMESPACE",1))
	If ..HistoryId = "" Set ..HistoryId = $G(%session.Data($Username,"SQL","HistoryId"))
	Set Query = ##class(%CSP.UI.Portal.SQL.Home).GetText(..HistoryId)
	Set ..%GetComponentById("htmlResult").seed = Query
	Set ..%GetComponentById("QueryText").value = Query
	Set LastSaved = $G($$$CacheTempMgt($UserName,"LastFile","SQL","ExportQuery"))
	Set LastDisplayMode = $LG(LastSaved,1)
	Set LastSaveFile = $LG(LastSaved,2)
	Set DisplayMode = $S(LastDisplayMode="":2,1:LastDisplayMode)
	Set FileName = $S(LastSaveFile="":##class(%File).NormalizeFilename("exportQuery"),1:LastSaveFile)
	Set ..%GetComponentById("selDisplayMode").value = DisplayMode
	Set ..%GetComponentById("txtFileName").value = FileName
	Set EventDesc = "Print Query Result"
	Set EventData = "Query text: "_$$$CRLF_Query
	$$$SMPAuditExecute
	Quit $$$OK
}

/// Prepare for background export of the file.
ClassMethod StartExport(pHistoryId, pFileName, pDisplayMode, pRuntimeMode, pDialect, pObjectSelectMode) As %Integer [ ZenMethod ]
{
	Set $$$CacheTempMgt($UserName,"LastFile","SQL","ExportQuery") = $LB(pDisplayMode,pFileName)
	Set tParms("NAMESPACE") = $ZU(5)
	Set tParms("FileName") = pFileName
	Set tParms("DisplayMode") = pDisplayMode
	Set tParms("HistoryId") = pHistoryId
	Set tParms("RuntimeMode") = pRuntimeMode
	Set tParms("Dialect") = pDialect
	Set tParms("ObjectSelectMode") = pObjectSelectMode
	Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("QueryExport",$ZU(5),.tParms,.tJob)
	If $$$ISERR(status) Do ##class(%CSP.UI.SQL.ExImWizardResultPage).LogMsg($System.Status.GetErrorText(status))
	Quit 1
}

/// Return 0 if file is directory; 2 if file exists.
ClassMethod ValidateFile(FileName) As %Integer [ ZenMethod ]
{
	If ##class(%File).DirectoryExists(FileName) Quit 0
	If ##class(%File).Exists(FileName) Quit 2

	Quit 1
}

/// Return file name with new extension
ClassMethod GetFile(Format, FileName) As %String [ ZenMethod ]
{
	Quit:FileName="" FileName
	Set Mode = $Case(Format,"0":"xml","1":"html","2":"pdf","99":"txt",:"csv")
	If $L(FileName,".")<2 Quit FileName_"."_Mode
	Set NewFile = $P(FileName,".",1,$L(FileName,".")-1)_"."_Mode
	Quit NewFile
}

ClassMethod DrawHTML(pText As %String(MAXLEN="")) As %Status
{
	If pText '= "" {
		Set tResult = ##class(%CSP.UI.Portal.SQL.Utils).SQLExecuteQuery(.pText, .tClassName, %page.RuntimeMode, %page.Dialect, %page.ObjectSelectMode, , .tGlobals)
		Set tDrawTab = 0
		Do ##class(%CSP.UI.Portal.SQL.Utils).DrawResult(tResult,tDrawTab,%page.ShowRowNum)
		If $G(tClassName) '= "" {
			Write "<br/><div valign='top'>",$ZDT($h,3),"&nbsp;&nbsp;",$$$TextHTML("Routine: "),$ZCVT(tClassName,"O","HTML"),"</div>"
		}
	}
	Quit $$$OK
}

}
