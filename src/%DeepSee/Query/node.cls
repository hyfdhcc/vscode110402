Include (%occUtility, %DeepSee)

IncludeGenerator (%occUtility, %DeepSee)

/// Base class for DeepSee RunTime objects.
Class %DeepSee.Query.node Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, System = 3 ]
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDATTRIBUTE = 0;

Parameter NAMESPACE = "http://www.intersystems.com/deepsee/query";

/// Parent of this node.<br/>
/// The type of the parent depends on context.
Relationship parent As %DeepSee.Query.group(XMLPROJECTION = "none") [ Cardinality = one, Inverse = children ];

/// Value of this node.
/// This is used by nodes that provide values.
Property value As %DeepSee.Datatype.string(MAXLEN = 32000, XMLPROJECTION = "attribute");

/// Diagnostic. Print value of this node to the console.
Method %PrintNode(pLevel As %Integer = 0)
{
	Set tText = ..%ToString()
	Set:($L(tText)>40) tText = $E(tText,1,40)_"..."
	Write ?pLevel*2,"-",..%ClassName(0),?30,tText,!
}

/// Return the type of this node.<br/>
/// The type can be one of the $$$dst<TYPE> macros.<br/>
/// This is implemented by subclasses.
Method %GetType() As %String
{
	Quit $$$dstUnknown
}

/// Return the current value of this node.<br/>
/// This is called when a literal value is needed during query processing.
/// This is implemented by subclasses.
Method %GetValue() As %String
{
	Quit ..value
}

/// Convert this node to its text representation.
Method %ToString(Output pSC As %Status) As %String
{
	Set pSC = $$$OK
	Quit ""
}

/// Return the member provider object associated with this node, if any.
Method %GetMemberProvider() As %DeepSee.Query.member
{
	Quit ""
}

/// Execute the pre-processing logic for this node.</br>
/// <var>pIsSlicer</var> is true if this node is part of the slicer
/// (WHERE) clause.
Method %PreProcess(pIsSlicer As %Boolean = 0) As %Status
{
	Quit $$$OK
}

/// Execute and build the axes output for this node.<br/>
/// <var>pCube</var> and <var>pKey</var> identify the current query.<br/>
/// <var>pNodeNo</var> is used to track the next available node number in the axis graph.<br/>
/// <var>pNewNodeNo</var> is the (top-most) node created by this call.<br/>
/// <var>pParent</var> is the parent node to insert into.<br/>
/// If <var>pVisible</var> is false, then force children to not be visible.
Method %ProcessAxes(pCube As %String, pKey As %String, ByRef pNodeNo As %Integer, Output pNewNodeNo As %Integer, pParent As %Integer, pVisible As %Boolean = 1) As %Status [ Internal ]
{
	Quit $$$OK
}

/// Process this node within the context of the filter section of a query<br/>
/// <var>pFilterTree</var> is tree containing processed results.<br/>
/// <var>pCube</var> is the cube name.<br/>
/// <var>pNodeNo</var> is used to track the next available node number in the axis graph.<br/>
/// <var>pNewNodeNo</var> is the (top-most) node created by this call.<br/>
/// <var>pParent</var> is the parent node to insert into.<br/>
Method %ProcessFilter(ByRef pFilterTree As %List, pCube As %String, ByRef pNodeNo As %Integer, Output pNewNodeNo As %Integer, pParent As %Integer) As %Status [ Internal ]
{
	Quit $$$OK
}

/// Make a copy of node <var>pSourceNode</var> and add it to target node <var>pTargetNode</var>.
ClassMethod %CopyNode(pCubeIndex As %String, pKey As %String, ByRef pNodeNo As %Integer, pTargetNode As %Integer, pSourceNode As %Integer, pHideParent As %Boolean = 0, pWrapType As %String = "") As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		If (pSourceNode = pTargetNode) {
			Set tSC = $$$ERROR($$$GeneralError,"%CopyNode: cannot copy node to itself: node("_pSourceNode_")")
			Quit
		}

		// JMD1453 if pWrapType is defined, wrap the source node
		If (pWrapType="tuple") {
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",$I(pNodeNo)) = $LB("tuple",0,0,+pTargetNode)
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pTargetNode,"ch",pNodeNo) = ""
			Set tTupleNode = pNodeNo

			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",$I(pNodeNo)) = $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pSourceNode)
			Set $List($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo),4) = tTupleNode // parent
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tTupleNode,"ch",pNodeNo) = ""
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",%axis,"all",pNodeNo) = ""
		}
		Else {
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",$I(pNodeNo)) = $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pSourceNode)
			Set $List($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo),4) = +pTargetNode // parent
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pTargetNode,"ch",pNodeNo) = ""
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",%axis,"all",pNodeNo) = ""
		}

		// get cmbr marker as well
		If $D($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",%axis,"cmbr",pSourceNode)) {
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",%axis,"cmbr",pNodeNo) = ""
		}

		Set leaf = $I(%leafCount)
		Set tNewNode = pNodeNo

		// recurse over children of source
		Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pSourceNode,"ch",""))

		If (pHideParent && (ch'="")) {
			// hide top node of new node
			Set tNode = $G($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tNewNode))
			Set $List(tNode,2) = 0
			Set $List(tNode,3) = 0

			// JMD792: remove node from "all" list
			If $D($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",1,"all",tNewNode)) {
				Set %leafCount = %leafCount - 1
				Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",1,"all",tNewNode)
			}
			Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tNewNode) = tNode
		}

		While (ch '= "") {
			Set tSC = ..%CopyNode(pCubeIndex,pKey,.pNodeNo,tNewNode,ch,pHideParent)
			If $$$ISERR(tSC) Quit
			Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pSourceNode,"ch",ch))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Delete the specified node and its children.
ClassMethod %DeleteNode(pCubeIndex As %String, pKey As %String, pAxisNode As %Integer, pNodeNo As %Integer) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		If '$D($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo)) {
			Set tSC = $$$ERROR($$$GeneralError,"%DeleteNode: node does not exist "_pNodeNo)
			Quit
		}

		// recursively delete children
		Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",""))
		While (ch'="") {
			Set tSC = ..%DeleteNode(pCubeIndex, pKey, pAxisNode, ch)
			If $$$ISERR(tSC) Quit
			Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",ch))
		}
		If $$$ISERR(tSC) Quit

		Set tParent = $LG($G($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo)),4)
		Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo)
		Kill:tParent'="" $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tParent,"ch",pNodeNo)
		If $D($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pAxisNode,"all",pNodeNo)) {
			Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pAxisNode,"all",pNodeNo)
			Set %leafCount = %leafCount - 1
		}
		Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pAxisNode,"cmbr",pNodeNo)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Hide (or display if <var>pShow</var> is true) the specified node and its children by clearing their visible flags.
ClassMethod %HideNode(pCubeIndex As %String, pKey As %String, pAxisNode As %Integer, pNodeNo As %Integer, pShow As %Boolean = 0) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		If '$D($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo)) {
			Set tSC = $$$ERROR($$$GeneralError,"%HideNode: node does not exist "_pNodeNo)
			Quit
		}

		// recursively process children
		Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",""))
		While (ch'="") {
			Set tSC = ..%HideNode(pCubeIndex, pKey, pAxisNode, ch)
			If $$$ISERR(tSC) Quit
			Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",ch))
		}
		If $$$ISERR(tSC) Quit

		Set tNode = $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo)
		Set $List(tNode,2) = pShow
		Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo) = tNode
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Reduce the given node within the node tree.
/// This means replacing set(set) with set.
ClassMethod %ReduceNode(pCubeIndex As %String, pKey As %String, pNodeNo As %Integer) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tNode = $G($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo))
		Set tNodeType = $LG(tNode,1)

		If (tNodeType = "set") {
			// test children
			Set tChildNo = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",""))
			While (tChildNo'="") {
				Set tChildNode = $G($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tChildNo))
				Set tChildType = $LG(tChildNode,1)
				If (tChildType = "set") {
					// reduce
					// move grandchildren up a level		
					Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tChildNo,"ch",""))
					While (ch '= "") {
						Set $List($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",ch),4) = pNodeNo // parent
						Set $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",ch) = ""
						Set ch = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tChildNo,"ch",ch))
					}

					// kill child node
					Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tChildNo)
					Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",tChildNo,"ch")
					Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",tChildNo)
					
					// JMD822: make sure "all" node is cleaned up
					Kill $$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",1,"all",tChildNo)
				}
				Set tChildNo = $O($$$DeepSeeAxisGLVN(pCubeIndex,pKey,"axes",pNodeNo,"ch",tChildNo))
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
