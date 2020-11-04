/// %ZEN.Mojo.Component.mojoPane
Class %ZEN.Mojo.Component.mojoPane Extends %ZEN.Component.pane [ System = 3 ]
{

/// This is the XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

/// Does the actual work of laying out the children of this group.
/// <var>pTuple</var> indicates the current tuple number in the
/// case of a repeatingGroup.
Method %LayoutChildren(pTuple As %Integer = "") [ Final, Private ]
{
	Set $ZT = "Trap"
	#; dispatch to Layout Manager to provide HTML layout
	#; if a *built-in* method; dispatch directly
	If (..layout = "vertical") {
		Do ##class(%ZEN.LayoutManager).vertical($this,pTuple)
	}
	ElseIf (..layout = "horizontal") {
		Do ##class(%ZEN.LayoutManager).horizontal($this,pTuple)
	}
	ElseIf ((..layout = "")||(..layout = "none")) {
		#; no layout
		Do ##class(%ZEN.LayoutManager).default($this,pTuple)
	}
	Else {
		#; dispatch to "%ZEN.LayoutManager:method"
		Set tLayoutClass = "%ZEN.LayoutManager"
		Set tLayoutMethod = ..layout
		Do $zobjclassmethod(tLayoutClass,tLayoutMethod,$this,pTuple)
	}
Done
	Quit
Trap
	Set $ZT=""
	Set tSC = $$$ERROR($$$GeneralError,$ZE)
	Do ##class(%ZEN.Utils).%DisplayErrorHTML($this,tSC)
	Goto Done
}

/// Specifies how components within this group should be layed out. (VALUELIST = ",vertical,horizontal")
Property layout As %ZEN.Datatype.string(MAXLEN = 250, ZENENCRYPT = 0) [ InitialExpression = {..#DEFAULTLAYOUT} ];

}
