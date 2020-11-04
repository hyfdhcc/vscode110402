/// Created using the page template: Default
Class %ZEN.Mojo.PluginDocumentation.HomePage Extends %ZEN.Mojo.basePage [ DependsOn = (%ZEN.Mojo.Plugin.dojoPageManager, %ZEN.Mojo.Plugin.dojoDijitHelper, %ZEN.Mojo.Plugin.HTML5Helper, %ZEN.Mojo.Plugin.mojoDefaultHelper) ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%ZEN.Mojo.PluginDocumentation.Application";

/// Displayed name of this page.
Parameter PAGENAME = "Zen Mojo Plugin Documentation";

/// Domain used for localization.
Parameter DOMAIN = "Zen Mojo Plugin Documentation";

/// List of JSON providers created for this page.
/// Used by contentProvider.
Parameter PROVIDERLIST = "data,layout";

/// Comma-separated list of additional JS include files for the page.
Parameter JSINCLUDES As STRING = "dojo-release-1-9-1/dojo/dojo.js";

/// Comma-separated list of additional CSS include files for the page.
/// If this page is using CSS3 then the CSS3INCLUDES parameter is used (if defined).
Parameter CSSINCLUDES As STRING = "dojo-release-1-9-1/dijit/themes/claro/claro.css,dojo-release-1-9-1/gridx/resources/claro/Gridx.css";

/// If this property is set to true the page will automatically dispatch
/// getContent() requests to different templates based on contentProvider name
/// and key.
/// <PROPERTY>templateDispatchBaseNamespace</PROPERTY> needs to be set if this property
/// is true.
Property templateDispatchMode As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// If <PROPERTY>templateDispatchMode</PROPERTY> is set to true this is the 
/// xml namespace which is used for loading templates. All templates
/// of the same application need to be in the same xml namespace
Property templateDispatchBaseNamespace As %ZEN.Datatype.string [ InitialExpression = "http://www.intersystems.com/zen/mojo/documentation" ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.dvDocument {
	width: 100%;
	height: 100%;
}
.dvEnclosingClass iframe {
	position:relative;
}
.dvEnclosingClass {
	border: none;
}
#zMojoContentGroup {
	border:none;
}
#zMojoHeaderPane {
	display:none;
}
.headerText {
	font-family: Verdana;
	font-size: 2em;
	font-weight: bold;	
	display:inline;
	padding-left:40px;
}
.inlineText {
	display:inline;
	font-family: Verdana;
	font-size: 0.8em;
}
.description {
	font-size: 0.6em;
	padding-left: 30px;
	display:block;
	padding-bottom:5px;
}
.typeImage {
	display: inline;
	vertical-align: middle;
	padding: 2px;
}
</style>
}

/// This XML block defines the contents of this pane.
XData pageContents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane
xmlns="http://www.intersystems.com/zen"
xmlns:mojo="http://www.intersystems.com/zen/mojo"
layout="none"
>

<mojo:documentView
id="mainView"
onload="zenPage._usedDojoDijitPlugin = 'dojo-1.9.1-DijitHelper';"
ongetlayout="return zenPage.getContent('layout',key,criteria);"
ongetdata="return zenPage.getContent('data',key,criteria);"
initialDocumentKey="home"
initialLayoutKey="home"
maxPanels="2"
developerMode="false"
>
<mojo:dojo-1.9.1-PageManager>
<mojo:dojo-1.9.1-DijitHelper/>
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:dojo-1.9.1-PageManager>
</mojo:documentView>

</pane>
}

/// Implementation for this page. This method adjusts the size of components 
/// within the content area based on the current width and height of the screen. 
/// In this case there is only one component.
ClientMethod adjustContentSize(load, width, height) [ Language = javascript ]
{
	
	var mainView = zen('mainView');
	if (mainView) {
		
		mainView.setSize(width, height);
		var mainDiv = mainView.getEnclosingDiv();
		mainDiv.style.top =  '0px';
		mainDiv.style.left = '0px';
	}
}

ClientMethod onlayoutHandler() [ Language = javascript ]
{
	this.invokeSuper('onlayoutHandler',arguments);
	
	var topContainer = zen('mainView').getItemByKey('layoutContainer-1');
	
	if (topContainer) {
		topContainer.$dojoItem.resize();
	}
}

/// In non-embed mode, maximum width of page content area.
ClientMethod getMaxContentWidth() [ Language = javascript ]
{
	return 1900;
}

}
