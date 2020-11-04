/// This is a specialized subclass of the <class>menu</class> component
/// that draws a vertical menu.
Class %ZEN.Component.vmenu Extends menu [ System = 3 ]
{

Parameter DEFAULTLAYOUT = "vertical";

Parameter DEFAULTCELLVALIGN = "top";

Parameter DEFAULTGROUPCLASS = "vmenuTable";

Parameter DEFAULTENCLOSINGCLASS = "vmenu";

XData Style
{
<style type="text/css">

/* style for enc div */
.vmenu {
	height: 100%;
	padding: 0px;
}

/* style for layout table */
.vmenuTable {
	border: 1px solid darkblue;
	font-family: verdana;
	padding: 0px;
}

</style>
}

}
