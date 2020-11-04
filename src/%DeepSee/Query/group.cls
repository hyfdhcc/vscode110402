/// Base class for DeepSee RunTime nodes that contain children.
Class %DeepSee.Query.group Extends node [ Abstract, System = 3 ]
{

/// Children of this group.<br/>
/// The type of the children depends on context.
Relationship children As %DeepSee.Query.node(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = parent ];

/// Diagnostic. Print value of this node to the console.
Method %PrintNode(pLevel As %Integer = 0)
{
	Do ##super(pLevel)
	Set tCount = ..children.Count()
	For n=1:1:tCount {
		Do ..children.GetAt(n).%PrintNode(pLevel+1)
	}
}

/// Execute the pre-processing logic for this node.
Method %PreProcess(pIsSlicer As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Set tCount = ..children.Count()
	For n=1:1:tCount {
		Set tSC = ..children.GetAt(n).%PreProcess(pIsSlicer)
		Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

/// Process this node within the context of the filter section of a query<br/>
Method %ProcessFilter(ByRef pFilterTree As %List, pCube As %String, ByRef pNodeNo As %Integer, Output pNewNodeNo As %Integer, pParent As %Integer) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set tCount = ..children.Count()
	For n=1:1:tCount {
		Set tSC = ..children.GetAt(n).%ProcessFilter(.pFilterTree,pCube,.pNodeNo,.pNewNodeNo,pParent)
		Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

}
