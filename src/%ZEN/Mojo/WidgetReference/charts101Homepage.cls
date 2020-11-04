Class %ZEN.Mojo.WidgetReference.charts101Homepage Extends %ZEN.Mojo.WidgetReference.jQM132BaseHomepage
{

/// Class name of application this page belongs to.
/// This is set by the %OnCreateApplication method.
Parameter APPLICATION = "%ZEN.Mojo.WidgetReference.charts101Application";

Parameter PAGENAME = "Charts.js 1.0.1 Widget Reference";

Parameter TEMPLATECLASS = "%ZEN.Mojo.WidgetReference.charts101Template";

Parameter JSINCLUDES = "jquery-2.0.3.min.js,jquery.mobile-1.3.2.min.js,Chart-1.0.1.min.js";

XData Style
{
<style type="text/css">
.ui-listview-filter {
	margin: 0px;
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
<mojo:jQM-1.3.2-PageManager>
<mojo:jQM-1.3.2-Helper jQueryCollapsibleTheme="d"/>
<mojo:charts-1.0.1-Helper/>
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:jQM-1.3.2-PageManager>
</mojo:documentView>

</pane>
}

}
