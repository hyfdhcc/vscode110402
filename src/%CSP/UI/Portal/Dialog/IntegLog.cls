Include %sqlui

/// This pages shows the integrity output of the System Management Portal.
Class %CSP.UI.Portal.Dialog.IntegLog Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.Dialog.IntegLog.zen";

/// Set this to the correct domain.
Parameter DOMAIN = "%Utility";

Parameter RESOURCE = "%Admin_Operate:USE";

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />

<pane paneName="dialogBody" id="body" />

<hgroup id="footer" width="100%" cellAlign="right">
<hgroup id="buttonHolder" cellAlign="right">
<button id="btnCancel" controlClass="commandButton" caption="Close" onclick="zenPage.dialogCancel();" />
</hgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:4 6 4 10;">

<hgroup enclosingStyle="padding-top:10px;" labelPosition="left" >
<text id="FileName" size="70" label="File name:" onkeyup="zenPage.keyUp(zenEvent);"/>
<button caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect('FileName','*.txt');"/>
<button caption="View File" onclick="zenPage.doView();"/>
</hgroup>

<iframe id="output" hidden="false"/>

</pane>
}

/// User clicked the Browse button.
ClientMethod browseSelect(name, wildcard) [ Language = javascript ]
{
	var Dir = zen(name).getValue();
	zenLaunchPopupWindow('%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir)+'&wildcard='+wildcard+'&showdirectoryonly=0','FileSelect','resizable,width=600,height=700');
}

/// Check if user hit [Enter].
ClientMethod keyUp(zenEvent) [ Language = javascript ]
{
	if ((zenEvent.which==13)||(zenEvent.keyCode==13)) {
		this.doView();
	}
}

/// User clicked the View File button.
ClientMethod doView() [ Language = javascript ]
{
	var FileName = zen("FileName").getValue();
	if (FileName == "") {
		alert($$$Text("Please enter a filename that contains your last integrity check result."));
		zen("FileName").focus();
		return;
	}
	zen('output').setProperty('src','_CSP.UI.Portal.Dialog.IntegLogContent.zen?FILENAME='+zenLink(FileName));
}

/// Returning from file select OR qualifers dialog and setting the value into the appropriate field.
/// The id of the field that needs to be updated is saved in "dialogClicked".
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action == "ok") {
		zen("FileName").setValue(value);
	}
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.onresizeHandler();
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onstartHandler() [ Language = javascript ]
{
    zen("FileName").focus();
}

/// This client event, if present, is fired when the page is resized.
ClientMethod onresizeHandler() [ Language = javascript ]
{

	var frame = zen("output");
	var wd = zenGetWindowWidth() - 60;
	var ht = zenGetWindowHeight() - 200;
	if (wd < 100) wd = 100;
	if (ht < 100) ht = 100;
	frame.setProperty("width",wd);
	frame.setProperty("height",ht);
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set FILENAME = $G($$$CacheTempMgt($Username,"Integ","FILENAME"))
	Set:FILENAME="" FILENAME = $zu(12)_"integ.txt"
	Set ..%GetComponentById("FileName").value = FILENAME
	Set ..%GetComponentById("output").src = "_CSP.UI.Portal.Dialog.IntegLogContent.zen?FILENAME="_..EscapeURL(FILENAME)
	Quit $$$OK
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Integrity Log")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

ClassMethod DrawContent(pSeed) As %Status
{
	Set tSC = $$$OK
	Set FILENAME = pSeed
	&html<<div style="padding:20px;"><pre>>
 	Set stream = ##class(%FileCharacterStream).%New()
 	Set stream.Filename = FILENAME
 	While 'stream.AtEnd {
 		Set line = stream.ReadLine()
 		Write $ZCVT(line,"O","HTML")
	}
	&html<</pre></div>
	<br>&nbsp;<br>>
	Kill stream	
	Quit tSC
}

/*
/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
	Set tSC = $$$OK
	Try {
		Set tTitle = $$$Text("Integrity Log")
		Set tPrintImage = ..Link("/csp/broker/deepsee/printer_24.png")
		Set tPrintTitle = $$$TextHTML("Print")
		Set BrowsePage = ..Link("%25ZEN.Dialog.fileSelect.zen",,1)
		&html<<html><title>#(tTitle)#</title><head>
		</head>
		
		
		<link rel="stylesheet" href='#(..Link("/csp/sys/intersystems.css"))#'>>
		&html<<body>>
		&html<<table width="100%" border="0" cellpadding="0" cellspacing="0">>		
		&html<<tr height="40" bgcolor="#9C9A8C">>
		&html<
	   	<td>
	   	<span id="lblTitle" style="font-weight: bold; color: #FFFAE7; font-size:20px; padding:6px; margin-left:14px;"><nobr>&nbsp;#($ZCVT(tTitle,"O","HTML"))#</nobr></span></td>
		<td align="right">
		<a href="javascript:window.print();" title="#(tPrintTitle)#" target="_top" style="pointer-events:auto;cursor:pointer;">
		<img src="#(tPrintImage)#" width="24" height="24" border="0"></a>&nbsp;&nbsp;</td>
		</tr>
	 	<tr>
		<td colspan="2" bgcolor="#356B8D"><img src='#(..Link("/csp/sys/images/spacer.gif"))#' width="100%" height="2" alt="-" border="0"></td>
	 	</tr>
		</table>>
		&html<<div style="padding:20px;"><pre>>
	 	Set stream = ##class(%FileCharacterStream).%New()
	 	Set stream.Filename = filename
	 	While 'stream.AtEnd {
	 		Set line = stream.ReadLine()
	 		&html<#($ZCVT(line,"O","HTML"))#>
		}
		&html<</pre></div>
		<br>&nbsp;<br>>
		Kill stream		
		Do %response.Flush()
		&html<</body>>
		&html<</html>>
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Write $System.Status.GetErrorText(tSC)	
	}

	Quit $$$OK
}
*/
}
