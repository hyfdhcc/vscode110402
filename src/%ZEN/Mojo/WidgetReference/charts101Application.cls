/// %ZEN.Mojo.WidgetReference.charts101Application
Class %ZEN.Mojo.WidgetReference.charts101Application Extends %ZEN.Mojo.baseApplication
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Zen Mojo - Charts.js 1.0.1 Widget Reference";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "%25ZEN.Mojo.WidgetReference.charts101Homepage.cls";

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
	Set tInfo.nameApplication = "Zen Mojo - Charts.js 1.0.1 Widget Reference"

	Quit tInfo
}

}
