/// Text Area replacement optimized for source code
Class %DeepSee.Report.UI.codeEditor Extends %ZEN.Component.control [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zenCEM.js";

/// This is the width of a tab stop in characters
Property tabStop As %ZEN.Datatype.integer [ InitialExpression = 5 ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.codeBody {
	min-height:15px;
	max-height:300px;
}
.codeEditorBody {
	font:12px monospace;
	color:#404040;
	border:1px solid gray;
	background:#ffffff;
	position:relative;
	top:0px;
	left:0px;
	width:100%;
	height:100%;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("editBase"))#" class="codeEditor"></div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.initializeEditor();
}

ClientMethod initializeEditor() [ Language = javascript ]
{
	var d = this.findElement("editBase");
	this.controller = new ZCE.CodeEditor(d);
	if (this.value) this.controller.setValue(this.value);
	else this.controller.setValue("");
	if (this.height) d.style.height = this.height;
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.value=value;
		var d = this.findElement("textArea");
		if (!d) this.initializeEditor();
		this.controller.setValue(value);
		break;

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
