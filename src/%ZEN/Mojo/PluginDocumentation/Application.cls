/// Zen Mojo Plugin Documentation Application class
/// 
/// 0.9.0
/// 	- Support display of the refreshable flag of properties
/// 
/// 0.8.8
/// 	- Removed unnecessary styles
/// 
/// 0.8.7
/// 	- Added a legend on the helper plugin screen
/// 
/// 0.8.6
/// 	- Use the new plugins, which include a version string
/// 
/// 0.8.5
/// 	- Added support to display the XMLNAME instead of the classname
/// 
/// 0.8.4
/// 	- Removed parameter TEMPLATECLASS as templateDispatchMode is used
/// 
/// 0.8.3
/// 	- Changed order of accordions on home screen.
/// 	  Helper plugins now appear first. 
/// 	- Added content for page manager documentation
/// 
/// 0.8.2
/// 	- added lexical sort for attributes of layout objects
/// 	- ensure that tab content can be scrolled
/// 
Class %ZEN.Mojo.PluginDocumentation.Application Extends %ZEN.Mojo.baseApplication
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Zen Mojo Plugin Documentation";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE;

/// The version of the plugin documentation
Parameter VERSION = "0.9.0";

/// Return an object containing the various configured settings for the portal.
ClassMethod %GetAppSettings(pPage As %String = "", pMode As %String = "") As %ZEN.proxyObject
{
	
	Set tInfo = ##class(%ZEN.proxyObject).%New()

	// initial templateClass
	Set tInfo.templateClass = ""

	// names
	Set tInfo.nameApplication = "Zen Mojo Plugin Documentation"

	// overrides

	Quit tInfo
}

/// Draw the contents of the background div section (this is purely decorative)
/// <var>pPage</var> is the calling page's LOGICALNAME.
ClassMethod ZMojoDrawBackgroundDiv(pPage As %String, pMode As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw the contents of the quick links section.
/// <var>pPage</var> is the calling page's LOGICALNAME.
ClassMethod ZMojoDrawQuickLinks(pPage As %String, pMode As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// Draw the contents of the basic section.
/// <var>pPage</var> is the calling page's LOGICALNAME.
ClassMethod ZMojoDrawBasicHelp(pPage As %String, pMode As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw the contents of the footer group section.
/// <var>pPage</var> is the calling page's LOGICALNAME.
ClassMethod ZMojoDrawFooterGroup(pPage As %String, pMode As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
