/// This is the base class for application classes within Zen Mojo
/// Applications should extend this class.
Class %ZEN.Mojo.baseApplication Extends %ZEN.Mojo.abstractApplication
{

/// This Style block contains application-wide CSS style definitions in alphabetical order.
XData Style
{
<style type="text/css">

#zMojoContentGroup {
	position: relative;
	top: 0px;
	left: 0px;
	overflow: hidden;
}

#zMojoContentPane {
	position: absolute;
	top: 0px;
	left: 0px;
}

#zMojoContentBackground {
	position: absolute;
}

</style>
}

/// Return an object containing the various configured settings for the portal.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method. 
ClassMethod %GetAppSettings(pPage As %String = "", pMode As %String = "") As %ZEN.proxyObject
{
	
	Set tInfo = ##class(%ZEN.proxyObject).%New()

	// initial templateClass - usually set by basePage
	Set tInfo.templateClass = ""

	// names
	Set tInfo.nameApplication = "Zen Mojo"

	// images
	//Set tInfo.imageFavorite = "portal/ensemble.ico"
	//Set tInfo.imageLogo = "portal/icon_ensemble.png"

	// optional background of content area
	//Set tInfo.imageBackground = "covers/6702449_s.jpg"
	//Set tInfo.opacityBackground = 0.1

	// links
	//Set tInfo.linkAboutUs = "http://www.intersystems.com"	// customer info
	Set tInfo.linkEncyclopedia = ""
	Set tInfo.linkHelp = ""
	Set tInfo.linkLegalNotices = ""
	Set tInfo.linkTermsOfUse = ""

	// overrides

	Quit tInfo
}

/// Draw the contents of the background div section (this is purely decorative)
/// <var>pPage</var> is the calling page's LOGICALNAME.
/// This method will be removed in a future release. 
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
/// This method will be removed in a future release. 
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

/// Draw the contents of the basic section.
/// <var>pPage</var> is the calling page's LOGICALNAME.
/// This method will be removed in a future release.
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
/// This method will be removed in a future release.
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

/// Notification that page has been resized.
ClientMethod applicationLayoutHandler(load) [ Language = javascript ]
{
}

}
