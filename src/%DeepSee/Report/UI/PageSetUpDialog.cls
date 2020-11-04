/// Created using the page template: Default
Class %DeepSee.Report.UI.PageSetUpDialog Extends %ZEN.Dialog.standardDialog [ LegacyInstanceContext, System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION;

/// Displayed name of this page.
Parameter PAGENAME = "Page Setup";

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// This XML block defines the contents of this page.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" title="" layout="none">
<form name="Content"  layout="none" >
<pageSetupControl id="pgCtrl"/>
</form>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Page Set-up Dialog")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Set paper stock, orientation and margins")
}

/// This class method callback is called just before the server-side page 
/// object is created.
Method %OnAfterCreatePage() As %Status
{
	// first dispatch to super class
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set tSC = $$$OK
	Try {
		// check privileges
		If ('$$CheckReportFormatDefAccess^%qdsUtils()) {
			Set %response.Redirect = ##class(%DeepSee.Utils).%GetErrorPageURL("License")
			Throw ##class(%Exception.SystemException).%New("DeepSee License")
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return this.getComponentById('pgCtrl').getValue();
}

ClientMethod ondialogStart() [ Language = javascript ]
{
	if (window.innerWidth) {
		if (window.innerWidth<628) window.innerWidth=628;
		if (window.innerHeight<466) window.innerHeight=466;
	}
	var o = this.getOpener();
	 if (o && o.zenPage && o.zenPage.getPageModel) {
		var v = o.zenPage.getPageModel();
		var pc = zen("pgCtrl");
		pc.initializeValueObject(v);
	}
}

}
