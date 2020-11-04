/// This page is accessed from Configuration
Class %CSP.UI.Portal.FileManConfigure Extends %CSP.UI.Portal.FileManTemplate [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "FileMan Conversion Settings";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.FileManConfigure.zen";

Parameter HELPADDRESS = "Home,Configuration,SQL Settings,FileMan Conversion Settings";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* override the image because this form is too tall */
.EditForm {
	background-image: url('');
}
</style>
}

XData buttonsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top">
</pane>
}

/// Save settings and exit.
ClientMethod doSave() [ Language = javascript ]
{
	this.doSaveDefault();
	this.doCancel();
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Do ..LoadProperties()
	
	Set ..lblTitle = $$$Text("Use the form below to view or edit the settings that define how FileMan data structures are converted to InterSystems class definition:")
	
	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	Quit $$$Text("FileMan Conversion Settings")
}

}
