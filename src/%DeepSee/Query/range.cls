/// This class defines a range within a DeepSee query.<br/>
/// A range is set defined by a starting and ending member.
/// It corresponds to the A:B syntax within MDX.
Class %DeepSee.Query.range Extends node [ System = 3 ]
{

/// Starting member for this range.
/// This can be a <class>memberSpec</class> or a <class>memberFunction</class>.
Property startMember As %DeepSee.Query.node;

/// Ending member for this range.
/// This can be a <class>memberSpec</class> or a <class>memberFunction</class>.
Property endMember As %DeepSee.Query.node;

/// Member object that provides the member API for the range.
/// This is created during the pre-processing phase.
Property %member As %DeepSee.Query.member(XMLPROJECTION = "none");

/// Return type of this node.
Method %GetType() As %String
{
	Quit $$$dstSet
}

/// Convert this node to its text representation.
Method %ToString(Output pSC As %Status) As %String
{
	Set tText = ..startMember.%ToString(.pSC) _ ":" _ ..endMember.%ToString(.pSC)
	Quit tText
}

/// Execute the pre-processing logic for this node.
Method %PreProcess(pIsSlicer As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		If '$IsObject(..startMember) {
			Set tSC = $$$ERROR($$$GeneralError,"Range node with no start member!")
			Quit
		}
		If '$IsObject(..endMember) {
			Set tSC = $$$ERROR($$$GeneralError,"Range node with no end member!")
			Quit
		}

		Set tSC = ..startMember.%PreProcess(pIsSlicer)
		If $$$ISERR(tSC) Quit

		Set tSC = ..endMember.%PreProcess(pIsSlicer)
		If $$$ISERR(tSC) Quit

		// find member providers for start and end
		Set tStartOffset = 0
		Set tEndOffset = 0
		If (..startMember.%IsA("%DeepSee.Query.memberSpec")) {
			Set tStartMember = ..startMember.%GetMemberProvider()
		}
		ElseIf (..startMember.%IsA("%DeepSee.Query.memberFunction")) {
			Set tStartOffset = $Case($$$UPPER(..startMember.function),"FIRSTCHILD":1,"LASTCHILD":1,"PARENT":-1,:0)
			// look until we find an actual member!
			// track if we are going up or down levels!
			Set tChild = ..startMember.children.GetAt(1)
			While (tChild.%IsA("%DeepSee.Query.memberFunction")) {
				Set tStartOffset = tStartOffset + $Case($$$UPPER(tChild.function),"FIRSTCHILD":1,"LASTCHILD":1,"PARENT":-1,:0)
				Set tChild = tChild.children.GetAt(1)
			}
			Set tStartMember = tChild.%GetMemberProvider()
		}
		If '$IsObject($G(tStartMember)) {
			Set tSC = $$$ERROR($$$GeneralError,"Start of range is of wrong type")
			Quit
		}
		If (..endMember.%IsA("%DeepSee.Query.memberSpec")) {
			Set tEndMember = ..endMember.%GetMemberProvider()
		}
		ElseIf (..endMember.%IsA("%DeepSee.Query.memberFunction")) {
			Set tEndOffset = $Case($$$UPPER(..endMember.function),"FIRSTCHILD":1,"LASTCHILD":1,"PARENT":-1,:0)
			Set tChild = ..endMember.children.GetAt(1)
			While (tChild.%IsA("%DeepSee.Query.memberFunction")) {
				Set tEndOffset = tEndOffset + $Case($$$UPPER(tChild.function),"FIRSTCHILD":1,"LASTCHILD":1,"PARENT":-1,:0)
				Set tChild = tChild.children.GetAt(1)
			}
			Set tEndMember = tChild.%GetMemberProvider()
		}
		If '$IsObject($G(tEndMember)) {
			Set tSC = $$$ERROR($$$GeneralError,"End of range is of wrong type")
			Quit
		}
		If ((tStartMember.%dimNumber '= tEndMember.%dimNumber) ||
			(tStartMember.%hierNumber '= tEndMember.%hierNumber) ||
			((tStartMember.%levelNumber+tStartOffset) '= (tEndMember.%levelNumber+tEndOffset))) {
			Set tSC = $$$ERROR($$$GeneralError,"Both parts of range expression must refer to same dimension and level.")
			Quit
		}
		// JMD1324: ignore this error
		/*
		If ((tStartMember.%memberId = "") || (tEndMember.%memberId = "")) {
			Set tSC = $$$ERROR($$$GeneralError,"Both parts of range expression must refer to specific members.")
			Quit
		}
		*/
		
		// Use member object from start member for subsequent work
		Set ..%member = tStartMember
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Execute and build the axes output for this set.
Method %ProcessAxes(pCube As %String, pKey As %String, ByRef pNodeNo As %Integer, Output pNewNodeNo As %Integer, pParent As %Integer, pVisible As %Boolean = 1) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tCubeIndex = $$$DeepSeeIndex(pCube)

		// create a set to hold the range members
		Set $$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",$I(pNodeNo)) = $LB("set",0,0,pParent)
		Set $$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",pParent,"ch",pNodeNo) = ""
		Set tSetNode = pNodeNo
		Set pNewNodeNo = pNodeNo

		// process start and end members of range
		Set tSC = ..startMember.%ProcessAxes(pCube,pKey,.pNodeNo,.tStartNodeNo,tSetNode,pVisible)
		If $$$ISERR(tSC) Quit

		Set tSC = ..endMember.%ProcessAxes(pCube,pKey,.pNodeNo,.tEndNodeNo,tSetNode,pVisible)
		If $$$ISERR(tSC) Quit

		// now replace child nodes with range of nodes
		Set tStartNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",tStartNodeNo))
		// +DTB165 - Check startNode to make sure it exists
		Set tStartMemberName = $LG(tStartNode,6)
		If tStartMemberName="NO MEMBER" {
			Set x = $O(..startMember.%resolvedSpec(""),-1,tStartKey)
			Set tStartDim = $LG(tStartNode,9)
			Set tStartHier = $LG(tStartNode,10)
			Set tStartLevel = $LG(tStartNode,11)
			
			Set tSC = ..startMember.%member.%GetRelatedMember(tCubeIndex,tStartDim,tStartHier,tStartLevel,"",tSetNode,.tStartSet,"","lead",1,tStartKey,1)
			If $$$ISERR(tSC) Quit
		}
		// -DTB165
		
		Set tEndNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",tEndNodeNo))
		// +DTB165 - Check endNode to make sure it exists.
		Set tEndMemberName = $LG($$$DeepSeeAxisGLVN(tCubeIndex,pKey,"axes",tEndNodeNo),6)	// DTB303 - Use cube index
		If (tEndMemberName="NO MEMBER") {
			Set x = $O(..endMember.%resolvedSpec(""),-1,tEndKey)
			Set tEndDim = $LG(tEndNode,9)
			Set tEndHier = $LG(tEndNode,10)
			Set tEndLevel = $LG(tEndNode,11)		
			
			Set tSC = ..endMember.%member.%GetRelatedMember(tCubeIndex,tEndDim,tEndHier,tEndLevel,"",tSetNode,.tEndSet,"","lag",1,tEndKey,1)
			If $$$ISERR(tSC) Quit
		}
		
		// Test any related member information to finalize the startNode and endNode
		If ($D(tStartSet)&&$D(tEndSet)) {
			// Two nonexistent members. Make sure there was actually something between them by swapping directions
			// and comparing the new endpoints with the original. If the sets are reverse images of each other, 
			// there is nothing in between the two original values
			Set tSC = ..startMember.%member.%GetRelatedMember(tCubeIndex,tStartDim,tStartHier,tStartLevel,"",tSetNode,.tStartSet,"","lag",1,tStartKey,1)
			If $$$ISERR(tSC) Quit
			Set tSC = ..endMember.%member.%GetRelatedMember(tCubeIndex,tEndDim,tEndHier,tEndLevel,"",tSetNode,.tEndSet,"","lead",1,tEndKey,1)
			If $$$ISERR(tSC) Quit
			
			If '($D(tStartSet(2)) && $D(tEndSet(2)) && (tStartSet(1)=tEndSet(2)) && (tStartSet(2)=tEndSet(1)) ) {
				// The endpoints are valid, pass them along
				Set tStartNode = tStartSet(1)
				Set tEndNode = tEndSet(1)
			}
			Else {
				// Do nothing: both nodes are NO MEMBER.
			}

		}
		Else {
			If $D(tStartSet) {
				// Replace NO MEMBER start node with next node
				Set tStartNode = tStartSet(1)
			}
			If $D(tEndSet) {
				// Replace NO MEMBER end node with previous node
				Set tEndNode = tEndSet(1)
			}
		}
		// -DTB165

		Set tStartNodeType = $LG(tStartNode,1)
		Set tEndNodeType = $LG(tEndNode,1)
		Set tStartVal = $LG(tStartNode,5)
		Set tEndVal = $LG(tEndNode,5)
		Set tStartKey = $LG(tStartNode,6)
		Set tEndKey = $LG(tEndNode,6)
		Set tStartDim = $LG(tStartNode,9)
		Set tStartHier = $LG(tStartNode,10)
		Set tStartLevel = $LG(tStartNode,11)
		Set tEndDim = $LG(tEndNode,9)
		Set tEndHier = $LG(tEndNode,10)
		Set tEndLevel = $LG(tEndNode,11)

		If ((tStartNodeType'="mbr")||(tEndNodeType'="mbr")) {
			Set tSC = $$$ERROR($$$GeneralError,"Both parts of a range must be members")
			Quit
		}

		// make sure both ends of range are at same level
		If ((tStartDim'=tEndDim)||(tStartHier'=tEndHier)||(tStartLevel'=tEndLevel)) {
			Set tSC = $$$ERROR($$$GeneralError,"Both parts of a range must be from the same dimension and level")
			Quit
		}

		// JMD1301: test for time dimension
		Set tLevelInfo = $G($$$DeepSeeMetaGLVN("cubes",tCubeIndex,"mbr#",tStartDim,tStartHier,tStartLevel))
		Set tTimeClass = $LG(tLevelInfo,6)

		// JMD1301: for time dimensions use keys not values
		If (tTimeClass [ "%DeepSee.") {
			Set tRange(1) = tStartKey
			Set tRange(2) = tEndKey
		}
		Else {
			// use values for data so that sort order is preserved
			Set tRange(1) = tStartVal
			Set tRange(2) = tEndVal
		}

		// find rollup key to restrict by
		//Set tSC = ..%member.%GetRollupKey(..%member.%levelNumber,..%member.%memberId,.tRollupKey)
		//If $$$ISERR(tSC) Quit

		// Do not use rollup key for range
		Set tRollupKey = ""

		Set tMember = ..%member
		Set tSC = tMember.%GetMembers(tMember.%cube,tMember.%dimNumber,tMember.%hierNumber,tStartLevel,tRollupKey,tSetNode,pKey,.pNodeNo,0,.tRange)
		If $$$ISERR(tSC) Quit

		// Delete original start/end nodes
		Set tSC = ..%DeleteNode(tCubeIndex,pKey,%axis,tStartNodeNo)
		If $$$ISERR(tSC) Quit
		Set tSC = ..%DeleteNode(tCubeIndex,pKey,%axis,tEndNodeNo)
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

}
