Class %ZEN.Mojo.WidgetReference.jQM132BaseHomepage Extends %ZEN.Mojo.WidgetReference.abstractHomepage [ DependsOn = (%ZEN.Mojo.Plugin.jQMPageManager, %ZEN.Mojo.Plugin.jQMHelper, %ZEN.Mojo.Plugin.HTML5Helper, %ZEN.Mojo.Plugin.mojoDefaultHelper) ]
{

Parameter CSSINCLUDES = "jquery.mobile-1.3.2.min.css";

Parameter JSINCLUDES = "jquery-2.0.3.min.js,jquery.mobile-1.3.2.min.js";

XData Style
{
<style type="text/css">
.mainDiv {
	width:80%;
	padding-left:10%;
	/*left:10%;*/
	/*position:absolute;*/
}
.headerDiv {
	width: 100%;
	height: 50px;
	background-color: black;
	color: white;
	/*text-align: center;*/
	padding-top: 5px;
	font-size: 2.0em;
}
.headerDiv .ui-btn {
	margin: 0px;
}
.headerDiv .header {
	display: inline-block;
	text-align: center;
	width: 100%;
	position: absolute;
	left: 0px;
}
.sampleSection {
	/*
	border-top: 1px solid rgba(0,0,0,.08);
	*/
	margin-top: 40px;
}
.sampleSection > h2 {
	font-family: 'Open Sans', sans-serif;
	font-weight: 300;
	font-size: 1.6em;
	color: #60a725;
}
.sampleSection > p {
	font-family: 'Open Sans', sans-serif;
	font-weight: 400;
	font-size: 0.95em;
}
.sampleSection b {
	background: #e6e6e6;
	background: rgba(0,0,0,.1);
}
.sampleArea {
	border-top: 1px solid rgba(0,0,0,.08);
	border-bottom: 1px solid rgba(0,0,0,.08);
	margin-top:2.4em;
	margin-bottom:1.2em;
	padding:1em;
}
.gutter {
	color:#afafaf;
	border-right: 1px solid #afafaf;
	padding-right: 15px;
}
.code {
	margin-left: 15px;
}
.layoutType {
	color:#98da31;
}
.keyType {
	color:#ffae00;
}
.ui-listview-filter-inset {
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
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:jQM-1.3.2-PageManager>
</mojo:documentView>

</pane>
}

}
