Class %ZEN.Mojo.WidgetReference.jQM132Homepage Extends %ZEN.Mojo.WidgetReference.jQM132BaseHomepage
{

/// Class name of application this page belongs to.
/// This is set by the %OnCreateApplication method.
Parameter APPLICATION = "%ZEN.Mojo.WidgetReference.jQM132Application";

Parameter PAGENAME = "jQM 1.3.2 Widget Reference";

Parameter TEMPLATECLASS = "%ZEN.Mojo.WidgetReference.jQM132Template";

XData Style
{
<style type="text/css">
.ui-listview-filter {
	margin: 0px;
}
.ui-collapsible-heading {
	margin: 0px;	
}
.ui-collapsible-content {
	margin: 0px;
}

/* Most layout objects generate their own ids, $listviewitem is an exception */
.ui-icon-skull-listview {
    background-image: url("zenmojo_images/glyphish-icons/21-skull.png");
    background-position: 3px 3px;
    background-size: 70%;
}
.demo-borders-collapsible .ui-collapsible .ui-collapsible-heading .ui-btn { 
	border-top-width: 2px !important;
	border-bottom-width: 2px;
}
.demo-grid-60px {
	height:60px;
}
.demo-header-styleone {
	width: 92%;
	margin-bottom: 5px !important;
	margin-top:15px !important;
	display: inline-block;
}
.demo-header-styletwo {
	position: absolute;
	width: 8%;
	right: 0px;
	margin-top: 0px;
	display: inline-block;
}
.demo-header-stylethree {
	margin: 0.3em 0px 1em;
	font-size: 85%;
}
@media all and (max-width: 28em){
    .demo-flip-slider-grid .ui-block-a,
    .demo-flip-slider-grid .ui-block-b {
        width: 100%;
        clear: left;
    }
}
.ui-icon-chat-navbar {
	background:url("zenmojo_images/glyphish-icons/09-chat-2.png") 50% 50% no-repeat;
	background-size: 24px 22px;
}
.ui-icon-email-navbar {
	background:url("zenmojo_images/glyphish-icons/18-envelope.png") 50% 50% no-repeat;
	background-size: 24px 16px;
}
.ui-icon-danger-navbar {
	background:url("zenmojo_images/glyphish-icons/21-skull.png") 50% 50% no-repeat;
	background-size: 22px 24px;
}
.ui-icon-beer-navbar {
	background:url("zenmojo_images/glyphish-icons/88-beer-mug.png") 50% 50% no-repeat;
	background-size: 22px 27px;
}
.ui-icon-coffee-navbar {
	background:url("zenmojo_images/glyphish-icons/100-coffee.png") 50% 50% no-repeat;
	background-size: 20px 24px;
}
.nav-glyphish-example .ui-btn .ui-icon {
	width: 30px!important;
	height: 27px!important;
	margin-left: -15px !important;
	box-shadow: none!important;
	-moz-box-shadow: none!important;
	-webkit-box-shadow: none!important;
	-webkit-border-radius: 0 !important;
	border-radius: 0 !important;
}
.demo-popup-tooltip {
	max-width: 350px;
}
.demo-popup-photolink-link {
	width: 30%;
	margin-left: 5px;
}
.demo-popup-photolink-popup {
	max-width: 90% !important;
	max-height: 90% !important;
	margin-left: 5%;
}
.demo-popup-menu {
	min-width: 210px;
}
.demo-popup-nestedmenu {
	margin: 0px;
	width: 250px;
}
.demo-popup-form {
	padding: 10px 20px;
}
.demo-popup-dialog {
	max-width: 400px;
}
.demo-popup-closing {
	max-width: 280px;	
}
.demo-navbar-oh {
	overflow: hidden;
}

</style>
}

}
