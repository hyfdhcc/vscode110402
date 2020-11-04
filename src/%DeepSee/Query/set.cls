/// This class defines an set within a DeepSee query.<br/>
/// A set can contain <class>tuple</class> objects within its
/// <property>children</property> collection.
Class %DeepSee.Query.set Extends group [ System = 3 ]
{

/// Return type of this node.
Method %GetType() As %String
{
	Quit $$$dstSet
}

/// Convert this node to its text representation.
Method %ToString(Output pSC As %Status) As %String
{
	Set tText = ""
	Set pSC = $$$OK

	Set tCount = ..children.Count()
	If (tCount>1) {
		Set tText = tText_"{"
	}
	For n = 1:1:tCount {
		Set tChild = ..children.GetAt(n)
		Set tText = tText _ $S(n>1:",",1:"") _ tChild.%ToString(.pSC)
		If $$$ISERR(pSC) Quit
	}
	If (tCount>1) {
		Set tText = tText_"}"
	}
	Quit tText
}

/// Execute and build the axes output for this set.
Method %ProcessAxes(pCube As %String, pKey As %String, ByRef pNodeNo As %Integer, Output pNewNodeNo As %Integer, pParent As %Integer, pVisible As %Boolean = 1) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		// add node to axis tree
		Set tCubeIndex = $$$DeepSeeIndex(pCube)
		Set $$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",$I(pNodeNo)) = $LB("set",0,0,pParent)
		Set $$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",pParent,"ch",pNodeNo) = ""
		Set tSetNode = pNodeNo
		Set pNewNodeNo = pNodeNo

		Set tChildCount = ..children.Count()
		For n=1:1:tChildCount {
			Set tChild = ..children.GetAt(n)
			// JMD1453: children *could* get deleted during this loop
			If $IsObject(tChild) {
				Set tSC = tChild.%ProcessAxes(pCube,pKey,.pNodeNo,.tNewNodeNo,tSetNode,pVisible)
				If $$$ISERR(tSC) Quit
			}
		}
		If $$$ISERR(tSC) Quit

		// reduce this node
		Set tSC = ..%ReduceNode(tCubeIndex,pKey,pNewNodeNo)
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

}
