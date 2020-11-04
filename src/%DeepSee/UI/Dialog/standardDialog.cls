Include %DeepSee

/// Base class for DeepSee dialog pages.
Class %DeepSee.UI.Dialog.standardDialog Extends %ZEN.Dialog.standardDialog [ System = 4 ]
{

Parameter DOMAIN = "%DeepSee";

/// All DeepSee pages require %DeepSee_Portal USE.
Parameter RESOURCE = "%DeepSee_Portal";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

Parameter APPLYBUTTON = 1;

XData Style
{
<style type="text/css">
a.radioButtonCaption {
	font-size: 12px;
}
a.radioButtonCaptionDisabled {
	font-size: 12px;
}
.comboboxTable td {
	padding-left: 3px;
}
.labelValue {
	color: #404040;
}

select option {
	background-color: #FFFFFF;
}

select option:nth-of-type(odd) {
	background-color: #F8F8F8;
}

</style>
}

/// Contents of this page:
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#"
	dragAndDrop="true"
	>
<!-->WAL126 dragAndDrop, above<-->
<html id="header" OnDrawContent="%DrawTitle" />
<pane paneName="dialogBody" id="body" />
<hgroup id="footer" width="100%" cellAlign="right">
<hgroup id="buttonHolder" cellAlign="right">
<button id="btnApply" hidden="#(%page.hideApplyButton)#" caption="Apply" onclick="zenPage.dialogApply();" />
<spacer width="5" />
<button id="btnCancel" hidden="#(%page.hideCancelButton)#" caption="Cancel" onclick="zenPage.dialogCancel();" />
<spacer width="5" />
<button id="btnOK" caption=" OK " onclick="zenPage.dialogFinish();" />
<spacer width="10" />
</hgroup>
</hgroup>
</page>
}

/// Provide HTML for html title box.<br>
/// Override for DeepSee dialogs.
Method %DrawTitle(pSeed As %String) As %Status
{
	#; draw html title box
	Set tTitle = ..%OnGetTitle()
	Set tProp = ..%OnGetSubtitle()

	&html<<table class="stdTitle" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		<td align="left" width="40"><img src="portal/icon_deepsee.png"/></td>
		<td align="left" width="90%" style="padding-left:20px;">
		<div style="font-size: 0.8em;">#(tTitle)#</div>
		<div style="font-size: 0.6em; font-style: italic;">#(tProp)#</div></td>
		<td>&nbsp;</td></tr></table>>
	Quit $$$OK
}

/// Strip beginning and ending whitespaces from a given string.
ClientMethod stripWhitespaces(string As %String) As %String [ Language = javascript ]
{
	return string.replace(/^\s*|\s*$/g,'')
}

ClientMethod getOpener() [ Language = javascript ]
{
	var realSuper = this.superClass;
	var origMethod = this.getOpener;
	while (realSuper && (typeof realSuper.getOpener == 'function') && (realSuper.getOpener === origMethod)) {
		realSuper = realSuper.superClass;
	}
	if (realSuper && realSuper.getOpener) return this.invokeSuper('getOpener',arguments);
	return window.opener;
}

/// Ensure that we force Internet Explorer to use its most recent rendering engine.
Method %OnDrawHTMLMeta() As %Status
{
	If $$$ZENISIE &html<<meta http-equiv="X-UA-Compatible" content="IE=edge" />>
	Quit $$$OK
}

}
