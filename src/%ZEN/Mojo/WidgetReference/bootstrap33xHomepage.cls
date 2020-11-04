Class %ZEN.Mojo.WidgetReference.bootstrap33xHomepage Extends %ZEN.Mojo.WidgetReference.abstractHomepage [ DependsOn = (%ZEN.Mojo.Plugin.mojoDefaultPageManager, %ZEN.Mojo.Plugin.bootstrap33xHelper, %ZEN.Mojo.Plugin.HTML5Helper, %ZEN.Mojo.Plugin.mojoDefaultHelper, %ZEN.Mojo.WidgetReference.bootstrap33xBaseTemplate) ]
{

/// Class name of application this page belongs to.
/// This is set by the %OnCreateApplication method.
Parameter APPLICATION = "%ZEN.Mojo.WidgetReference.bootstrap33xApplication";

Parameter PAGENAME = "bootsTrap 3.3.x Widget Reference";

Parameter TEMPLATECLASS = "%ZEN.Mojo.WidgetReference.bootstrap33xTemplate";

Parameter CSSINCLUDES = "bootstrap-3-3-5/dist/css/bootstrap.min.css";

Parameter JSINCLUDES = "jquery-1.11.3.min.js,bootstrap-3-3-5/dist/js/bootstrap.min.js";

/// If true, only show the core content.
Property embedded As %ZEN.Datatype.boolean(ZENURL = "EMBED") [ InitialExpression = 1 ];

XData Style
{
<style type="text/css">
#navbar-collapse6,#navbar-collapse7 {
	position:relative;
}
.glyphicons{
	list-style: none;
	margin-bottom: 23px;
}
.glyphicons li{
	width: 12.5%;
	font-size: 20px;
	float: left;
	text-align: center;
}
#dropdown2{
	clear:both;
}
#dropdown1Button{
	float:left;
}
#dropdown1Menu{
	display:block;
	position:static;
	clear:left;
	margin-bottom: 5px;
}
#dropdown3{
	float:right;
}
.sampleArea > .container > .btn-group{
	margin:5px 3px;
}
span{
	margin-left:2px !important;
	margin-right:2px !important;
}
.disabled>span, .active>span{
	margin-left:0 !important;
	margin-right:0 !important;
}
.navbar-brand>img{
	margin-top:-25px;
}
#grid1 .col-xs-4, #grid2 .col-md-1, #grid3 .col-md-8, 
#grid3 .col-md-4, #grid4 .col-md-4, #grid5 .col-md-6,
#grid6 .col-md-8, #grid6 .col-md-4, #grid6 .col-xs-12,
#grid6 .col-xs-6, #grid7 .col-md-4, #grid7 .col-xs-6,
#grid8 .col-xs-6, #grid9 .col-xs-6, #grid9 .col-xs-12,
#grid9 .col-sm-6, #grid9 .col-md-8, #grid9 .col-md-4,
#grid10 .col-xs-6,#grid10 .col-sm-4,#grid11 .col-md-4,
#grid12 .col-md-3,#grid13 .col-md-6,#grid14 .col-sm-9,
#grid14 .col-sm-6,#grid14 .col-xs-8,#grid14 .col-xs-4,
#grid15 .col-md-3,#grid15 .col-md-9{
	padding-top: 10px;
  	padding-bottom: 10px;
	background-color: rgba(86,61,124,.15);
	border: 1px solid rgba(86,61,124,.2);
	margin-bottom: 15px;
}
#bg-example p{
	padding: 15px;
}
.modal-lg {
  width: 60%;
}
.headerDiv .header {
	display: inline-block;
	text-align: center;
	width: 85%;
	position: absolute;
	left: 7.5%;
}

.mainDiv {
	width:80%;
	padding-left:10%;
	padding-top:40px;
	/*left:10%;*/
	/*position:absolute;*/
}
.headerDiv {
	width: 100%;
	height: 50px;
	background-color: black;
	color: white;
	/*text-align: center;*/
	padding: 3px 10px;
	font-size: 2.0em;
}
.headerDiv .ui-btn {
	margin: 0px;
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
	word-wrap: break-word;
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
#staticCode, #staticCode code, #CSS, #CSS code, #dynamicCode, #dynamicCode code, #dynamicData, #dynamicData code {
	background: #000;
}
#zMojoContentBackground{
	height: 5px !important;
}
.dvEnclosingClass {
	border:none;
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
<mojo:mojoDefaultPageManager>
<mojo:bootstrap-3.3.x-Helper/>
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:mojoDefaultPageManager>
</mojo:documentView>
</pane>
}

/// Adjust size of components within the content area.
ClientMethod adjustContentSize(load, width, height) [ Language = javascript ]
{
	var view = zen('mainView');
	if (view) {
		view.setSize(width,height);
	}
}

}
