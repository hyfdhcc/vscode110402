/// User facing "busy" panel
/// This is the display panel for alerting the user that the system is busy
/// acting on his/her latest request.
Class %DeepSee.Report.UI.busyPanel Extends %ZEN.Component.component [ System = 4 ]
{

Parameter DEFAULTENCLOSINGCLASS = "busyTrapBody";

/// Icon to display at the top of the panel
Property icon As %ZEN.Datatype.uri [ InitialExpression = "CSP/broker/deepsee/dsrwait.gif" ];

Property activityStr As %ZEN.Datatype.caption [ InitialExpression = "Saving File" ];

Property requestStr As %ZEN.Datatype.caption [ InitialExpression = "Please wait" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.busyTrapBody {
	width:100%;
	height:113px;
	padding-top:30px;
	background:white;
	text-align:center;
}

.busyTrapIconDiv {
	margin-left:auto;
	margin-right:auto;
	text-size:18px;
}

.busyTrapActivityDiv {
	font:bold 20px Arial;
}

.busyTrapRequestDiv {
	font:bold 16px Arial;
}

</style>
}

Method %DrawHTML()
{
	&html<
		<div class="busyTrapIconDiv" >
			<img id="#(..%MakeId("busyTrapIcon"))#" src="#(..icon)#" />
		</div>
		<div id="#(..%MakeId("busyTrapActivity"))#" class="busyTrapActivityDiv" >#(..activityStr)#</div>
		<div id="#(..%MakeId("busyTrapRequest"))#" class="busyTrapRequestDiv" >#(..requestStr)#</div>
	>
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'icon':
		this.findElement('busyTrapIcon').src = value;
		break;
	case 'activityStr':
		this.findElement('busyTrapActivityStr').innerHTML = value;
		break;
	case 'requestStr':
		this.findElement('busyTrapRequestStr').innerHTML = value;
		break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
