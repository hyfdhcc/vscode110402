/// %ZEN.Mojo.WidgetReference.bootstrap33xApplication
Class %ZEN.Mojo.WidgetReference.bootstrap33xApplication Extends %ZEN.Mojo.baseApplication
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Zen Mojo - Twitter Bootstrap 3.3.x Widget Reference";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "%25ZEN.Mojo.WidgetReference.bootstrap33xHomepage.cls";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
	</style>
}

/// Return an object containing the various configured settings for the portal.
ClassMethod %GetAppSettings(pPage As %String = "", pMode As %String = "") As %ZEN.proxyObject
{
	
	Set tInfo = ##class(%ZEN.proxyObject).%New()
	// names
	Set tInfo.nameApplication = "Zen Mojo - Twitter Bootstrap 3.3.x Widget Reference"

	Quit tInfo
}

}
