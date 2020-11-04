/// 
/// Foundation class for all pages within Zen Mojo
/// 
/// This provides the core functionality shared by all pages within the framework.
Class %ZEN.Mojo.abstractPage Extends (%ZEN.Component.page, %ZEN.Mojo.localizableObject, %ZEN.Mojo.abstractPageOverride) [ Abstract, Inheritance = right ]
{

/// 
/// Class name of application this page belongs to.
Parameter APPLICATION;

/// 
/// Displayed name of this page.
/// 
/// Overriden by application class.
Parameter PAGENAME = "Zen Mojo";

/// 
/// Logical name of this page.
/// 
/// Overriden by application class.
Parameter LOGICALNAME = "HOME";

Parameter DOMAIN = "%ZEN";

/// 
/// Projection to assist in localization of Zen Mojo pages.
Projection MojoPageProjection As %ZEN.Mojo.PageProjection;

/// 
/// Optional display mode of the page.
/// 
/// The page can provide a different appearance depending on this value.
/// 
/// This value is passed on the application class.
Property currMode As %ZEN.Datatype.string(ZENURL = "MODE");

/// 
/// If true, only show the core content.
Property embedded As %ZEN.Datatype.boolean(ZENURL = "EMBED") [ InitialExpression = 0 ];

/// 
/// Array of named links (from application settings).
Property linkList As array Of %String;

/// 
/// Server-side copy of application settings object
Property %appSettings As %ZEN.proxyObject;

/// 
/// This Style block contains page-specific CSS style definitions.
/// 
/// This mostly will come from the application class.
XData Style
{

<style type="text/css">

</style>
}

/// 
/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{

<page xmlns="http://www.intersystems.com/zen" title="">

</page>
}

/// 
/// This callback is called at the end of the HTML HEAD section of the page.<br/>
/// 
/// (default implementation is a simple expression).
Method %OnDrawHTMLHead() As %Status
{

	Set tSC = $$$OK

	Try {

		Set tSettings = ..%GetAppSettings()

		

		// determine favorite icon from settings

		If (tSettings.imageFavorite'="") {

			&html<<link rel="shortcut icon" href="#(tSettings.imageFavorite)#">>

		}



		// write out loader for additional js methods from the application class

		// this will be pushed into core ZEN at some point

		Write "<script language=""javascript"">",!

		Write "function loadApplicationMethods() {",!

		If ($IsObject($G(%application)) && ($G(%application).%IsA("%ZEN.Mojo.baseApplication"))) {

			Set tSC = %application.%DrawClientMethods()

		}

		Write "}",!

		If $$$ISERR(tSC) Quit



		// localization for application methods

		If ($IsObject($G(%application)) && ($G(%application).%IsA("%ZEN.Mojo.baseApplication"))) {

			Set tSC = %application.%DrawJSStrings()

			If $$$ISERR(tSC) Quit

		}



		Write "</script>",!

	}

	Catch(ex) {

		Set tSC = ex.AsStatus()

	}

	Quit tSC
}

/// 
/// Return an object containing the various configured settings for the portal.
Method %GetAppSettings() As %ZEN.proxyObject
{

	If $IsObject(..%appSettings) {

		Set tInfo = ..%appSettings

	}

	Else {

		If ($IsObject($G(%application)) && ($G(%application).%IsA("%ZEN.Mojo.baseApplication"))) {

			Set tInfo = %application.%GetAppSettings(..#LOGICALNAME,..currMode)

		}

		Else {

			Set tInfo = ##class(%ZEN.proxyObject).%New()

		}

		Set ..%appSettings = tInfo

	}

	Quit tInfo
}

ClassMethod SetSessionLanguage(pLanguageCode As %String = "") As %Boolean [ ZenMethod ]
{

	If (pLanguageCode '= "") && $IsObject($get(%session)) && $IsObject($get(%response)) && (pLanguageCode '= $$$SessionLanguage) {

		Set %response.Language = pLanguageCode

		Set %session.Language = pLanguageCode

		&js<zenLoadJS('#($zconvert(##class(%ZEN.Mojo.Utils).%GetLocalizationFilename($classname($this),pLanguageCode,""),"O","JS"))#');>

		Quit 1

	}

	Quit 0
}

/// 
/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{

	// make sure method from application class are loaded

	// note: application methods will not be available to other components onload handler

	if (window.loadApplicationMethods) {

		window.loadApplicationMethods();

	}
}

/// 
/// This callback is called after the server-side page 
/// 
/// object and all of its children are created.<br/>
Method %OnAfterCreatePage() As %Status
{

	Set tSC = $$$OK

	Try {

	}

	Catch(ex) {

		Set tSC = ex.AsStatus()

	}

	Quit tSC
}

Method %OnDetermineCSSLevel() As %Integer
{

	Set tSettings = ..%GetAppSettings()

	Set:tSettings.nameApplication'="" ..title = tSettings.nameApplication

	Quit 3
}

/// 
/// Override onServerMethodError to catch HyperEvent errors.
ClientMethod onServerMethodError(err, errObject) [ Language = javascript ]
{

	if (errObject) {

		if ((errObject.serverCode == 5919) || (errObject.serverCode == 5918) || ((errObject.code == 401) && (errObject.serverCode == 864))) {

			return false;

		}

	}
}

/// 
/// This callback is called at the start of the HTML HEAD section of the page (just after the title).<br/>
/// 
/// It allows a page to write out meta tags, if desired.
/// 
/// (default implementation is a simple expression).
Method %OnDrawHTMLMeta() As %Status
{

	// Make it so that, when the user has selected IE compatibility mode, we ignore it and use the most recent IE version available

	Write "<meta http-equiv=""X-UA-Compatible"" content=""IE=edge"" />"

	// turn off unless this is actually mobile

	// Write "<meta name=""viewport"" content=""width=device-width, initial-scale=1.0,maximum-scale=1, user-scalable=no""/>"

	Quit $$$OK
}

ClassMethod %OnUseSoftModals() As %Boolean [ CodeMode = expression ]
{
1
}

/// 
/// Return the device orientation.
ClientMethod getOrientation() [ Language = javascript ]
{
	return ('undefined' != typeof window.orientation) ? window.orientation : 0;
}

/// 
/// Helper method; test if we are running in a mobile client.
ClientMethod isMobile() [ Language = javascript ]
{

	// is it android?

	var isAndroid = (navigator.userAgent.toLowerCase().indexOf("android")>-1);



	// is orientation defined?

	var hasOrientation = 'undefined' != typeof window.orientation;

	return (isAndroid||hasOrientation) ? true : false;
}

/// 
/// Test if this page is "embedded".
ClientMethod isEmbedded() [ Language = javascript ]
{
	return this.embedded || this.isMobile();
}

/// 
/// Ensure that we include the correct localization data for the page and its templates.
Method %OnDrawObjectProperties()
{



		Set tLocalizationFile = ##class(%ZEN.Mojo.Utils).%GetLocalizationFilename($classname($this),%response.Language,"")

		Set tFileExist = 0

		Do ##class(%ZEN.Mojo.Utils).%CreateLocalizationFiles($classname($this),,,,tLocalizationFile,.tFileExist)

		If (tFileExist = 1){

			&js<zenLoadJS('#($zconvert(tLocalizationFile,"O","JS"))#'); >

		}
}

/// 
/// Internal parameter.
/// 
/// There is nothing to queue up for page classes.
Parameter POSTCOMPILEACTIONS = "HTML";

/// 
/// Specifies how components within this group should be layed out. (VALUELIST = ",vertical,horizontal")
Property layout As %ZEN.Datatype.string(MAXLEN = 250, ZENENCRYPT = 0) [ InitialExpression = {..#DEFAULTLAYOUT} ];

}
