Class %ZEN.Mojo.WidgetReference.Home Extends %ZEN.Mojo.basePage [ DependsOn = (%ZEN.Mojo.Plugin.jQM132PageManager, %ZEN.Mojo.Plugin.jQM132PageManager, %ZEN.Mojo.Plugin.jQM132Helper, %ZEN.Mojo.Plugin.HTML5Helper, %ZEN.Mojo.Plugin.mojoDefaultHelper), ProcedureBlock ]
{

Parameter APPLICATION;

Parameter CSSINCLUDES = "jquery.mobile-1.3.2.min.css";

Parameter DOMAIN;

Parameter JSINCLUDES = "jquery-2.0.3.min.js,jquery.mobile-1.3.2.min.js";

Parameter PAGENAME;

Parameter PROVIDERLIST = "data,layout";

Parameter TEMPLATECLASS = "%ZEN.Mojo.WidgetReference.HomeTemplate";

XData Style
{
<style type="text/css">
.ui-listview-filter-inset {
	margin-bottom: 5px;	
}
</style>
}

XData pageContents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane
 xmlns="http://www.intersystems.com/zen"
 xmlns:mojo="http://www.intersystems.com/zen/mojo"
 layout="none"
>
 <mojo:documentView
 id="mainView"
ongetdata="return zenPage.getContent('data',key,criteria);"
ongetlayout="return zenPage.getContent('layout',key,criteria);"
initialDocumentKey="home"
initialLayoutKey="home"
>
<mojo:jQM-1.3.2-PageManager jQueryAnimation="fade">
<mojo:jQM-1.3.2-Helper/>
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:jQM-1.3.2-PageManager>
</mojo:documentView>
</pane>
}

}
