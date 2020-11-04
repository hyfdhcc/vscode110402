/// This class defines an axis within a DeepSee query.
Class %DeepSee.Query.axis Extends group [ System = 3 ]
{

/// Query that this axis belongs to.
Relationship query As %DeepSee.Query.query(XMLPROJECTION = "none") [ Cardinality = one, Inverse = axes ];

/// Collection of subqueries associated with this axis.
Property subqueries As list Of %DeepSee.ResultSet(XMLPROJECTION = "NONE");

/// If true, then empty tuples (e.g. complete rows or columns) are removed
/// from the results of the query.<br/>
/// This is equivalent to the MDX "NON EMPTY" key word.
Property nonEmpty As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// List of facts this axis depends on.
Property %dependencies As %String [ Internal, MultiDimensional ];

/// List of current member markers along this axis.
Property %cmbrIndex As %String [ Internal, MultiDimensional ];

/// Convert this node to its text representation.
Method %ToString(Output pSC As %Status) As %String
{
	Set pSC = $$$OK
	Set tText = ""
	
	Set tCount = ..children.Count()
	If (tCount = 0) {
		Quit tText
	}

	If (..nonEmpty) {
		Set tText = tText _ "" _ "NON EMPTY "
	}

	// axis should never have more than one child
	If (tCount>1) {
		Set tText = tText _ "{"
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

/// Execute and build the axes output for this axis.
Method %ProcessAxes(pCube As %String, pKey As %String, ByRef pNodeNo As %Integer, Output pNewNodeNo As %Integer, pParent As %Integer) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		// process and save cmbr index, if any
		If $D(..%cmbrIndex) {
			Set tCubeIndex = $$$DeepSeeIndex(pCube)
			Set k = $O(..%cmbrIndex(""))
			While (k'="") {
				Set tSpec = ..%cmbrIndex(k)
				Set tInfo = ""

				// parse spec; test for relations
				Kill tSpecInfo
				Set tRelSpec = ""
				Set tFCube = pCube
				Set tFCubeIndex = tCubeIndex
				Set tFSpec = tSpec
				While (1) {
					Kill tSpecInfo2
					Set tSC = ##class(%DeepSee.Utils).%GetDimensionInfo(tFCube,tFSpec,.tDimNo,.tHierNo,.tLevelNo,.tRelationName,.tRelationSpec,.tSpecInfo2,.tCalcMbrs)
					If $$$ISERR(tSC) Quit
					If (tRelationName="") {
						Merge tSpecInfo = tSpecInfo2
						Quit
					}

					Set tRelSpec = tRelSpec _ $S(tRelSpec'="":".",1:"") _ "[" _ tSpecInfo2(1) _ "]"
					Set tFCube = ##class(%DeepSee.Utils).%GetRelatedCube(tFCube,tRelationName)
					Set tFCubeIndex = $$$DeepSeeIndex(tFCube)
					Set tFSpec = tRelationSpec
				}
				If $$$ISERR(tSC) Quit

				Set tDimName = $$$UPPER($G(tSpecInfo(1)))
				Set tHierName = $$$UPPER($G(tSpecInfo(2)))
				Set tLevelName = $$$UPPER($G(tSpecInfo(3)))

				If (tLevelName'="") {
					Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",tFCubeIndex,"mbrs",tDimName,tHierName,tLevelName))
					If ((tInfo="")&&(tHierName'="")) {
						// fall back
						Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",tFCubeIndex,"mbrs",tDimName,tHierName))
					}
				}
				ElseIf (tHierName'="") {
					Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",tFCubeIndex,"mbrs",tDimName,tHierName))
					If ((tInfo="")&&(tDimName'="")) {
						// fall back
						Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",tFCubeIndex,"mbrs",tDimName))
					}
				}
				ElseIf (tDimName'="") {
					Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",tFCubeIndex,"mbrs",tDimName))
				}
				If (tInfo'="") {
					Set $$$DeepSeeAxisGLVN(tCubeIndex,pKey,"cmbrIndex",k) = $LB($$$UPPER(tSpec),+$LG(tInfo,1),+$LG(tInfo,2),+$LG(tInfo,3),$$$UPPER(tRelSpec))
				}
				Set k = $O(..%cmbrIndex(k))
			}
		}

		Set tChildCount = ..children.Count()
		For n=1:1:tChildCount {
			Set tChild = ..children.GetAt(n)
			Set tSC = tChild.%ProcessAxes(pCube,pKey,.pNodeNo, .tNewNodeNo, pParent)
			If $$$ISERR(tSC) Quit
			Set:n=1 pNewNodeNo = tNewNodeNo
		}
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

/// Incates whether or not this axis is a placeholder %SEARCH axis.
Method %IsSearch(Output pSC As %Status) As %Boolean [ Internal ]
{
	// Method added by DTB141
	Set pSC = $$$OK
	Set tIsSearch = 0
	Try {
		Set tChild = ..children.GetAt(1)
		If '($IsObject(tChild)&&tChild.%IsA("%DeepSee.Query.memberSpec")) {
			Quit
		}
		
		Set tSpec = tChild.spec
		Do ##class(%DeepSee.Query.Parser).%ParseMemberSpec(tSpec,.tInfo)
		
		If ($$$UPPER(tInfo(1))="%SEARCH") {
			Set tIsSearch = 1
		}
	}
	Catch ex {
		Set pSC = ex.AsStatus()
	}
	Quit tIsSearch
}

}
