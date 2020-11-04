Include (%occUtility, %DeepSee)

/// Contains additional logic for calculating the results of a DeepSee query.
Class %DeepSee.Query.Engine2 Extends %RegisteredObject [ System = 3 ]
{

/// Compute the values of cells within the result cube.<br/>
/// <var>pCube</var> is the name of the cube.<br/>
/// <var>pKey</var> is the query key.<br/>
/// <var>pBucketNo</var> is the logical bucket number to execute.<br/>
/// <var>pSlotNo</var> is the physical bucket slot number containing the results.<br/>
/// <var>pSection</var>, if defined, specifies, by axis, which sections of the result to calculate:<br/>
/// pSection(axis) = $LB(startNode,endNode)<br/>
/// <var>pTrace</var> is a debugging flag.<br/>
/// <var>pStats</var> is an array of statistics.<br/>
ClassMethod %ExecuteForBucket(pCube As %String, pKey As %String, pBucketNo As %Integer, pSlotNo As %Integer, ByRef pSections As %List, pTrace As %Boolean = 0, ByRef pStats) As %Status [ Internal ]
{
	Set tSC = $$$OK 
	Try {
		Set pCube = $$$UPPER(pCube)
		Set tCubeIndex = $$$DeepSeeIndex(pCube)
		Set tUseCache = (pBucketNo>0)	// no cache for active chunk

		// test for showplan, bitset, or drillthrough query
		Set tShowPlan = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"showPlan"))
		Set tQueryType = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"queryType"))
		Set tIsBitSet = (tQueryType = "%BITSET")
		Set tIsDrillThru = (tQueryType = "DRILLTHROUGH")

		// find set of relations for this cube (if any)
		// these will be processed using a join index
		Set tHasRelations = 0
		Set r = $O($$$DeepSeeMetaGLVN("cubes",pCube,"rel#",""))
		While (r'="") {
			Set tHasRelations = 1
			Set tRelation(r) = ""
			Set r = $O($$$DeepSeeMetaGLVN("cubes",pCube,"rel#",r))
		}

		// test for default measure
		Set tDefAgg = ""
		Set tDefMsr = ""
		Set tDefMsrType = ""
		Set tDefScale = 0
		Set tMsrName = $G($$$DeepSeeMetaGLVN("cubes",pCube,"defmsr"))
		If (tMsrName '= "") {
			Set tNode = $G($$$DeepSeeMetaGLVN("cubes",pCube,"mbrs","MEASURES",$$$UPPER(tMsrName)))
			If (tNode '= "") {
				Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",pCube,"mbr#",$LG(tNode,1),$LG(tNode,2),$LG(tNode,3)))
				Set tDefMsr = $LG(tInfo,5)
				Set tDefMsrType = $LG(tInfo,8)
				Set tDefAgg = $LG(tInfo,7,"SUM")
				Set tDefScale = +$LG(tInfo,9)
			}
		}

		Set tChunksPerBucket = $$$DeepSeeChunksPerBucket(pCube)

		// set up section ranges
		// pSection(axis) = $LG(start,end)
		Set a = $O(pSections(""))
		While (a '= "") {
			Set tSect = pSections(a)
			If (tSect '= "") {
				Set tSectionStart(a) = $LG(tSect,1)
				Set tSectionEnd(a) = $LG(tSect,2) // start of next section
			}
			Set a = $O(pSections(a))
		}

		// get start/end bitmap chunk for this bucket
		If (pBucketNo = -1) {
			// active chunk
			Set tStartChunk = pSlotNo
			Set tEndChunk = tStartChunk
			Set tResultSlot = -1
		}
		Else {
			// make sure we don't process the active chunk
			// we assume this is always at the *end* of a bucket
			Set tActiveChunk = +$G($$$DeepSeeBucketsGLVN(tCubeIndex,"chunk"))
			Set tStartChunk = ((pBucketNo-1)*tChunksPerBucket)+1
			Set tEndChunk = tStartChunk + tChunksPerBucket - 1

			If ((tActiveChunk >= tStartChunk)&&(tActiveChunk <= tEndChunk)) {
				Set tEndChunk = tActiveChunk - 1
			}

			Set tResultSlot = pSlotNo
		}
		If (tEndChunk < tStartChunk) Quit

		// number of fact properties in cube
		Set tFactCount = $G($$$DeepSeeMetaGLVN("cubes",pCube,"factCount"))
		// JMD1453
		If (tFactCount="") {
			Set tSC = $$$ERROR($$$GeneralError,"Cube must be recompiled")
			Quit
		}

		// construct base spec
		// this is a $List with "" defined for each fact
		// plus an initial reserved slot
		Set tBaseSpec = $LB("")
		For n = 1:1:tFactCount {
			Set tBaseSpec = tBaseSpec _ $LB("")
		}

		// determine order in which to visit facts
		Set tFactOrder = $G($$$DeepSeeMetaGLVN("cubes",pCube,"factOrder"))
		If (tFactOrder="") {
			Set tFactOrder = $LB("")
			For n = 1:1:tFactCount {
				Set tFactOrder = tFactOrder _ $LB(tFactCount-n)
			}
		}

		// get set of extent indices for each bitmap chunk
		For tChunk = tStartChunk:1:tEndChunk {
			If ($D($$$DeepSeeIndexGLVN(tCubeIndex,"$Fact",tChunk),data)) {
				If ($BitFind(data,1)>0) {
					Set tExtent(tChunk) = data
				}
			}
		}

		// initialize context and stacks
		Set tContext = ""

		// Find axes
		Set tTotalAxisCount = ..%GetAxisInfo(pCube,pKey,.tAxisType,.tAxisKey,.tAxisSize,.tSlicerAxis)
		If (tTotalAxisCount = 0) {
			// no axes:
			// result is simply the fact count (or default measure) for this bucket
			If (tIsBitSet) {
				// compute bitset and save it in the result cache
				Set tChunk = $O(tExtent(""))
				While (tChunk '= "") {
					Set tMask = $$Mask(tBaseSpec,tChunk,.tFactMask)
					Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tChunk) = tMask
					Set tChunk = $O(tExtent(tChunk))
				}
				Quit
			}
			ElseIf (tIsDrillThru) {
				Set tValue = tBaseSpec
				Quit
			}
			ElseIf (tDefMsr = "") {
				Set tValue = $$Count(tBaseSpec,"",tDefMsrType)
			}
			Else {
				If (tDefAgg = "COUNT") {
					Set tValue = $$Count(tBaseSpec,tDefMsr,tDefMsrType)
				}
				ElseIf (tDefAgg = "SUM") {
					Set tValue = $$Sum(tBaseSpec,tDefMsr,tDefScale)
				}
				ElseIf ($P(tDefAgg,":",1) = "MIN") {
					Set tValue = $$Min(tBaseSpec,tDefMsr,tDefScale)
					Set tValue = $LB(tDefAgg,tValue)
				}
				ElseIf ($P(tDefAgg,":",1) = "MAX") {
					Set tValue = $$Max(tBaseSpec,tDefMsr,tDefScale)
					Set tValue = $LB(tDefAgg,tValue)
				}
				ElseIf ($P(tDefAgg,":",1) = "AVG") {
					Set tCount = $$Count(tBaseSpec,tDefMsr,tDefMsrType)
					Set tSum = $$Sum(tBaseSpec,tDefMsr,tDefScale)
					Set tValue = $LB(tDefAgg,tCount,tSum)	// agg format
				}
				ElseIf ($P(tDefAgg,":",1) = "NULL") {
					Set tValue = ""
				}
			}
			Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot) = tValue
			Quit
		}

		// build list ordered by size of axis
		Set tSlicerSize = 0
		Set tSlicerAxis = ""
		Set tSlicerKey = ""
		For ra=1:1:tTotalAxisCount {
			If (tAxisType(ra) = "slicer") {
				// slicer is always first in the list
				Set tAxisList(-999999,ra) = tAxisKey(ra)
				Set tSlicerKey = tAxisKey(ra)
				Set tSlicerSize = tAxisSize(ra)
				Set tSlicerAxis = ra
			}
			ElseIf (tAxisType(ra) = "axis") {
				Set tAxisList(-tAxisSize(ra),ra) = tAxisKey(ra)
			}
		}

		// compute slicer mask
		If (tSlicerKey'="") {
			Do ..%ApplySlicerMask(pCube, tSlicerKey,.tExtent,tHasRelations,.tRelation)
		}

		// see if there are currentMember substitutions in play
		If ($D($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"cmbrMap"))) {
			Set tHasCMBR = 1
		}
		Else {
			Set tHasCMBR = 0
		}

		Kill tAxisKey  // this gets rebuilt

		// initialize axis info (using size ordered list)
		// first pass, build axis indices
		Set tAxisCount = 0
		Set s = $O(tAxisList(""))
		While (s'="") {
			Set ra = $O(tAxisList(s,""))
			While (ra'="") {
				Set tAxisCount = tAxisCount + 1
				Set tOrigAxisNo = ra
				Set tRealAxisNo(tAxisCount) = ra
				Set tSortedAxisNo(ra) = tAxisCount // reverse index
				Set tAxisRoot(tAxisCount) = 1
				Set tAxisKey(tAxisCount) = tAxisList(s,ra)
				Set tStartNode(tAxisCount) = $S(($G(tSectionStart(tOrigAxisNo))=""):$O($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tAxisCount),"axes",tAxisRoot(tAxisCount),"all","")),1:tSectionStart(tOrigAxisNo))
				Set tEndNode(tAxisCount) = $G(tSectionEnd(tOrigAxisNo))
				Set tNodeNo(tAxisCount) = tStartNode(tAxisCount)

				// JMD1319: if true, then axis has a NON EMPTY clause
				// used for DISTINCT COUNT
				Set tAxisNonEmpty(tAxisCount) = $LG($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tAxisCount),"axes",tAxisRoot(tAxisCount)),5)

				Set ra = $O(tAxisList(s,ra))
			}
			Set s = $O(tAxisList(s))
		}

		// second pass, do the rest
		Set tAxisCount = 0
		Set s = $O(tAxisList(""))
		While (s'="") {
			Set ra = $O(tAxisList(s,""))
			While (ra'="") {
				Set tAxisCount = tAxisCount + 1
				Set tOrigAxisNo = ra
				If (tNodeNo(tAxisCount)="") {
					// no members for axis: ignore
				}
				Else {
					Do SetContext(tAxisCount)
				}
				Set ra = $O(tAxisList(s,ra))
			}
			If $$$ISERR(tSC) Quit
			Set s = $O(tAxisList(s))
		}
		If $$$ISERR(tSC) Quit

		// if slicer has one node, then do not
		// add an additional results subscript
		If (tSlicerSize = 1) {
			Set tRealAxisCount = tAxisCount - 1
		}
		Else {
			Set tRealAxisCount = tAxisCount
		}

		// JMD948
		/*
		If (tIsBitSet && (tRealAxisCount>1)) {
			Set tSC = $$$ERROR($$$GeneralError,"BITSET Query must have one axis or less.")
			Quit
		}
		*/

		// general loop over all axes
		Set tDone = 0
		While ('tDone) {
			Kill tNodeNums
			Set tHasExpression = 0
			Set tCellCalc = 1
			Set tCellMsr = tDefMsr
			Set tCellMsrType = tDefMsrType
			Set tCellAgg = tDefAgg
			Set tDistinctAxis = ""			// non-"" if this cell has a %DISTINCT calc
			Set tCellScale = tDefScale
			Set tCellSpec = tBaseSpec
			Set tSlicerSpec = tBaseSpec		// track separately
			Set tHasSkip = 0

			// find cell context from axes context
			// visit axes in order of solve_order
			// followed by real axis order (reversed to pick up axis 0 last)
			Kill tSO
			For a=1:1:tAxisCount {
				// JMD1503
				Set tSO(+$G(tSolveOrder(a)),tRealAxisNo(a)) = a
			}

			Set ak1 = $O(tSO(""))
			While (ak1'="") {
				// JMD1497 visit in reverse order
				Set rxa = $O(tSO(ak1,""),-1,a)
				While (rxa'="") {
					// cell address in original axis order
					Set tNodeNums(rxa) = +tNodeNo(a)

					Set tCellCalc = tCellCalc && $G(tCalc(a))
					If (tCellCalc) {
						Set tAxisSpec = $G(tSpec(a))
						If (rxa=tSlicerAxis) {
							// fold in later
							Set tSlicerSpec = tAxisSpec
						}
						Else {
							Set:$D(tSkipFacts(a)) tHasSkip = 1

							// JMD1453
							Set tCellSpec = ..%CombineSpecs(tFactCount,tCellSpec,tAxisSpec)
						}
						If ($G(tMeasure(a))'="") {
							Set tCellMsr = tMeasure(a)
						}
						If ($G(tMeasureType(a))'="") {
							Set tCellMsrType = tMeasureType(a)
						}
						If ($G(tMsrScale(a))'="") {
							Set tCellScale = tMsrScale(a)
						}
						If ($G(tAgg(a))'="") {
							Set tCellAgg = tAgg(a)
						}
						If ($G(tDistinct(a))'="") {
							Set tDistinctAxis = a
						}
						If ($G(tLiteral(a))'="") { // JSL4407
							Set tHasExpression = 1
						}
						If ($D(tExpression(a))) {
							Set tHasExpression = 1
						}
					}
					// next axis
					Set rxa = $O(tSO(ak1,rxa),-1,a)
				}
				Set ak1 = $O(tSO(ak1))
			}

			// now remove everything referenced in the skip facts set
			If (tHasSkip) {
				For a=1:1:tAxisCount {
					// cell address in original axis order
					Set tNodeNums(tRealAxisNo(a)) = +tNodeNo(a)
					Set tCellCalc = tCellCalc && $G(tCalc(a))
					If (tCellCalc) {
						Set tAxisSpec = $G(tSpec(a))
						If (tRealAxisNo(a)'=tSlicerAxis) {
							For f = 1:1:tFactCount {
								If $D(tSkipFacts(a,f)) {
									Set $List(tCellSpec,f+1) = tSkipFacts(a,f)
								}
							}
						}
					}
				}
			}

			// currentMember handling
			// See if we need to overlay substitutions due to currentMember
			Set tCMListNodeNo = ""
			Kill tCMList,tCMData,tCMBRInfo
			If (tHasCMBR) {
				// see if there is an overlay in the cmbr map
				// this is always a 3d structure!
				Set tCMBRInfo = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"cmbrMap",+$G(tNodeNums(1)),+$G(tNodeNums(2)),+$G(tNodeNums(3))))
				If (tCMBRInfo'="") {
					Set tCMBRType = $LG(tCMBRInfo,1)
					If (tCMBRType="mbr") {
						// use one value as cell spec
						Set tCMBRNodeNo = $O($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"cmbrMap",+$G(tNodeNums(1)),+$G(tNodeNums(2)),+$G(tNodeNums(3)),""))
						Set tCellSpec = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"cmbrMap",+$G(tNodeNums(1)),+$G(tNodeNums(2)),+$G(tNodeNums(3)),tCMBRNodeNo))
						// JMD1488
						Set tCMBRAggInfo = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"cmbrMap",+$G(tNodeNums(1)),+$G(tNodeNums(2)),+$G(tNodeNums(3)),tCMBRNodeNo,"agg"))
						Set tCMBRAgg = $LG(tCMBRInfo,16)
						Set:tCMBRAgg'="" tCellAgg = tCMBRAgg
						// if there is a measure in the cmbr info, use it
						// make sure to use scale and type as well
						Set tCMBRMsr = $LG(tCMBRInfo,15)
						If (tCMBRMsr'="") {
							Set tCellMsr = tCMBRMsr
							Set tCellScale = $LG(tCMBRInfo,19)
							Set tCellMsrType = $LG(tCMBRInfo,20)
						}
						If (tCMBRAggInfo'="") {
							Set tCMBRAgg = $LG(tCMBRAggInfo,1)
							Set:tCMBRAgg'="" tCellAgg = tCMBRAgg
							Set tCMBRMsr = $LG(tCMBRAggInfo,2)
							Set tCellMsr = tCMBRMsr
							Set tCellScale = $LG(tCMBRAggInfo,3)
							Set tCellMsrType = $LG(tCMBRAggInfo,4)
						}
					}
					ElseIf (tCMBRType="agg") {
						Set tCMBRAgg = $LG(tCMBRInfo,16)
						If ((tCMBRAgg'="%MDX")&&(tCMBRAgg'="%KPI")) {
							// get set of children
							Merge tCMList = $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"cmbrMap",+$G(tNodeNums(1)),+$G(tNodeNums(2)),+$G(tNodeNums(3)))
							// if there is a measure in the cmbr info, use it
							// JMD1488 look for cell specific measure/agg info
							Set tCMBRAggInfo = ""
							Set kx = $O(tCMList(""))
							If (kx'="") {
								Set tCMBRAggInfo = $G(tCMList(kx,"agg"))
							}
							Set:tCMBRAgg'="" tCellAgg = tCMBRAgg
							Set tCMBRMsr = $LG(tCMBRInfo,15)
							If (tCMBRMsr'="") {
								Set tCellMsr = tCMBRMsr
								Set tCellScale = $LG(tCMBRInfo,19)
								Set tCellMsrType = $LG(tCMBRInfo,20)
							}
							If (tCMBRAggInfo'="") {
								Set tCMBRAgg = $LG(tCMBRAggInfo,1)
								Set:tCMBRAgg'="" tCellAgg = tCMBRAgg
								Set tCMBRMsr = $LG(tCMBRAggInfo,2)
								Set tCellMsr = tCMBRMsr
								Set tCellScale = $LG(tCMBRAggInfo,3)
								Set tCellMsrType = $LG(tCMBRAggInfo,4)
							}
						}
						// we don't need a cellspec; it comes from each item in CMList
						Set tCellSpec = tBaseSpec
					}
					Else {
						Set tCellSpec = tBaseSpec
						Set tHasExpression = 1
					}

					// if there are nodes above the cmbr node, fold in their spec
					// DTB062 - use the axis mapping to determine which sorted axis 
					// will contain the parent spec
					If (1 && (+$LG(tCMBRInfo,4)>1)) {
						Set tCMBRAxisInfo = $LG(tCMBRInfo,23)		
						Set a = tSortedAxisNo($LG(tCMBRAxisInfo,1))
						Set tCMBaseSpec = $G(tStackSpec(a,tLevel(a)-1))
						If (tCMBaseSpec'="") { 
							// JMD1453
							Set tCellSpec = ..%CombineSpecs(tFactCount,tCellSpec,tCMBaseSpec)
						}
					}
				}
			}					
			
			// JMD1403: check for cell override due to relationship
			If ($D($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"relMap",+$G(tNodeNums(1),1),+$G(tNodeNums(2),1),+$G(tNodeNums(3),1)))) {
				// DTB225 - Gather the information stored in the relMap and then combine it with the contextual information collected thus far
				Set tRelMapSpec = $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"relMap",+$G(tNodeNums(1),1),+$G(tNodeNums(2),1),+$G(tNodeNums(3),1))
				Set tCellSpec = ..%CombineSpecs(tFactCount,tCellSpec,tRelMapSpec)
			}

			// fold in slicer, if present
			// JMD1453
			// JMD1501 test against base spec as well
			If (tSlicerSpec'="")&&(tSlicerSpec'=tBaseSpec) {
				Set tCellSpec = ..%CombineSpecs(tFactCount,tCellSpec,tSlicerSpec)
			}

			// !!!
			//Write ">>>>>>",tNodeNo(1),",",$G(tNodeNo(2)),",",$G(tNodeNo(3))," ",tCellMsr,!
			//Write ?10,"slice:",?30,$ListToString(tSlicerSpec,":"),!
			//Write ?10,$ListToString(tCellSpec,":")
			//Write "  ",tCellCalc," ",tHasExpression,!
			Set tValue = ""
			If ($D(tCMList)) {
				Set cc = $O(tCMList(""),1,tCMSpec)
				While (cc'="") {
					// combine CMSpec with current cell spec
					// JMD1453.2 Move to inside loop
					Set tCMCellSpec = tCellSpec

					// JMD1453
					Set tCMCellSpec = ..%CombineSpecs(tFactCount,tCMCellSpec,tCMSpec)
					Set tValue = ""
					Set:tCellAgg="" tCellAgg="COUNT"
					If (tIsBitSet) {
						// !!!
					}
					ElseIf (tCellMsr="") {
						// no measure in context; count cells
						// actual aggregation occurs in consolidation phase
						If (tCellAgg = "NULL") {
							Set tValue = ""
						}
						Else {
							Set tValue = $$Count(tCMCellSpec,"","")
						}
					}
					Else {
						// measure in context; evaluate
						If (tCellAgg = "COUNT") {
							Set tValue = $$Count(tCMCellSpec,tCellMsr,tCellMsrType)
						}
						ElseIf (tCellAgg = "SUM") {
							Set tValue = $$Sum(tCMCellSpec,tCellMsr,tCellScale)
						}
						// JMD1488 add more cases
						ElseIf (tCellAgg = "MIN") {
							Set tValue = $$Min(tCMCellSpec,tCellMsr,tCellScale)
							Set tValue = $LB(tCellAgg,tValue)
						}
						ElseIf (tCellAgg = "MAX") {
							Set tValue = $$Max(tCMCellSpec,tCellMsr,tCellScale)
							Set tValue = $LB(tCellAgg,tValue)
						}
						ElseIf (tCellAgg = "AVG") {
							Set tAvgCount = $$Count(tCMCellSpec,tCellMsr,tCellScale)
							Set tAvgSum = $$Sum(tCMCellSpec,tCellMsr,tCellScale)
							Set tValue = $LB(tCellAgg,tAvgCount,tAvgSum)	// agg format
						}
						ElseIf (tCellAgg = "NULL") {
							Set tValue = ""
						}
						Else {
							Set tValue = $$Sum(tCMCellSpec,tCellMsr,tCellScale)
						}
					}

					// JMD852: special handling for drillthrough: set spec *if* there are values
					If (tIsDrillThru && (tValue'="")) {
						Set tValue = tCellSpec
					}

					// store the result
					Set tCMData(cc) = tValue
					Set tValue = ""

					// next spec
					Set cc = $O(tCMList(cc),1,tCMSpec)
				}
				// Put marker into value for this cell
				// we will replace during consolidation
				Set tValue = "N.A."

			} // cmlist
			ElseIf (tCellCalc && 'tHasExpression) {
				Set:tCellAgg="" tCellAgg="COUNT"
				If (tIsBitSet) {
					// compute bitset and save it in the result cache
					Set n = 0
					Set k = $O(tNodeNums(""))
					While (k'="") {
						Set tAddr($I(n)) = tNodeNums(k)
						Set k = $O(tNodeNums(k))
					}
					Set tChunk = $O(tExtent(""))
					While (tChunk '= "") {
						Set tMask = $$Mask(tCellSpec,tChunk,.tFactMask)

						// only 1 axis in answer
						// JMD948: if we are called again, union with prior results
						If ($G(tAddr(1))'="") {
							Set tPrio = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),tChunk))
							If (tPrio'="") {
								Set tMask = $BitLogic(tMask|tPrio)
							}
							Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),tChunk) = tMask
						}

						// next chunk
						Set tChunk = $O(tExtent(tChunk))
					}
				}
				ElseIf (tDistinctAxis'="") {
					// if we are the active bucket, then compute the distinct values
					If (pBucketNo = -1) {
						// see if we are excluding empty values
						Set tDNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tNodeNo(tDistinctAxis)))
						Set tDExclude = ($LG(tDNode,7)="EXCLUDEEMPTY")

						// we have to loop over the set members here
						// do this recursively as we could be from a crossjoin
						// JMD1319: see if any of the *other* axes are NON EMPTY
						// if so, then the default count will be "" instead of 0
						Set tDCount = 0
						Set ka = $O(tNodeNo(""))
						While (ka'="") {
							If ((ka'=tDistinctAxis)&&(+$G(tAxisNonEmpty(ka)))) {
								Set tDCount = ""
								Quit
							}
							Set ka = $O(tNodeNo(ka))
						}

						Set tDLevel = 1
						Set tDSpec(tDLevel) = tCellSpec
						Set tDParent(tDLevel) = tNodeNo(tDistinctAxis)
						Set tDNodeNo(tDLevel) = $O($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDParent(tDLevel),"ch",""))
						While (tDNodeNo(tDLevel)'="") {
							// are there children?
							While $D($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDNodeNo(tDLevel),"ch")) {
								// build spec
								If (tDExclude) {
									Set tDNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDNodeNo(tDLevel)))
									Set tDKey = $LG(tDNode,6)
									Set tDFact = $LG(tDNode,7)
									// directly replace fact in spec
									If ((tDFact'="")&&(tDKey'="")) {
										// JMD1453.2
										Set tDSpec(tDLevel) = ..%SetFactIntoSpec(tFactCount,tDSpec(tDLevel),tDFact,tDKey,1)
									}
								}
								Set tDLevel = tDLevel + 1
								Set tDParent(tDLevel) = tDNodeNo(tDLevel-1)
								Set tDSpec(tDLevel) = tDSpec(tDLevel-1)
								Set tDNodeNo(tDLevel) = $O($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDParent(tDLevel),"ch",""))
							}

							If ('tDExclude) {
								Set tDCount = tDCount + 1
							}
							Else {
								Set tDNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDNodeNo(tDLevel)))
								Set tDKey = $LG(tDNode,6)
								Set tDFact = $LG(tDNode,7)
								If ((tDFact'="")&&(tDKey'="")) {
									// directly replace fact in spec
									// JMD1453.2
									Set tDSpec(tDLevel) = ..%SetFactIntoSpec(tFactCount,tDSpec(tDLevel),tDFact,tDKey,1)
								}
								// JMD1050: combine spec with orginal spec and test
								// JMD1453.4 we still need to combine in order to zero out
								// competing keys (COUNT (ASIA) WHERE EUROPE)
								Set tTestSpec = ..%CombineSpecs(tFactCount,tCellSpec,tDSpec(tDLevel))
								Set tExists = $$Exists(tTestSpec,tCellMsr,tCellMsrType)
								Set:tExists tDCount = tDCount + 1
							}

							// next
							Set tDNodeNo(tDLevel) = $O($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDParent(tDLevel),"ch",tDNodeNo(tDLevel)))
							While ((tDLevel>1)&&(tDNodeNo(tDLevel)="")) {
								Set tDLevel = tDLevel - 1
								Set tDNodeNo(tDLevel) = $O($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tDistinctAxis),"axes",tDParent(tDLevel),"ch",tDNodeNo(tDLevel)))
							}
						}
						Set tValue = tDCount
					}
				}
				ElseIf (tCellMsr="") {
					// no measure in context; count cells
					If ((tCellAgg = "MIN")||(tCellAgg = "MAX")||(tCellAgg = "AVG")) {
						Set tValue = 1
					}
					ElseIf (tCellAgg = "NULL") {
						Set tValue = ""
					}
					Else {
						Set tValue = $$Count(tCellSpec,"","")
					}
				}
				Else {
					// measure in context; evaluate
					If (tCellAgg = "COUNT") {
						Set tValue = $$Count(tCellSpec,tCellMsr,tCellMsrType)
					}
					ElseIf (tCellAgg = "SUM") {
						Set tValue = $$Sum(tCellSpec,tCellMsr,tCellScale)
					}
					ElseIf ($P(tCellAgg,":",1) = "MIN") {
						Set tValue = $$Min(tCellSpec,tCellMsr,tCellScale)
						Set tValue = $LB(tCellAgg,tValue)
					}
					ElseIf ($P(tCellAgg,":",1) = "MAX") {
						Set tValue = $$Max(tCellSpec,tCellMsr,tCellScale)
						Set tValue = $LB(tCellAgg,tValue)
					}
					ElseIf ($P(tCellAgg,":",1) = "AVG") {
						Set tAvgCount = $$Count(tCellSpec,tCellMsr,tCellMsrType)
						Set tAvgSum = $$Sum(tCellSpec,tCellMsr,tCellScale)
						Set tValue = $LB(tCellAgg,tAvgCount,tAvgSum)	// agg format
					}
					ElseIf ($P(tCellAgg,":",1) = "NULL") {
						Set tValue = ""
					}
					Else {
						Set tSC = $$$ERROR($$$GeneralError,"Unknown aggregate in ExecuteForBucket: " _ tCellAgg)
						Quit
					}
				}			

				// JMD852: special handling for drillthrough: set spec *if* there are values
				If (tIsDrillThru && (tValue'="")) {
					Set tValue = tCellSpec
				}
			} // calculated

			If (tValue'="") {
				// store value: construct address from node #s
				Kill tAddr
				Set n = 0
				Set k = $O(tNodeNums(""))
				While (k'="") {
					Set tAddr($I(n)) = tNodeNums(k)
					Set k = $O(tNodeNums(k))
				}
				// write value to cache
				Goto $Case(tRealAxisCount,0:DIM0,1:DIM1,2:DIM2,3:DIM3,:DIMERR)
DIM0
				Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot) = tValue
				Merge:$D(tCMData) $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,"ch") = tCMData
				Goto POSTDIM
DIM1
				Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1)) = tValue
				Merge:$D(tCMData) $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),"ch") = tCMData
				Goto POSTDIM
DIM2
				Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),tAddr(2)) = tValue
				Merge:$D(tCMData) $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),tAddr(2),"ch") = tCMData
				Goto POSTDIM
DIM3
				Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),tAddr(2),tAddr(3)) = tValue
				Merge:$D(tCMData) $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"data",tResultSlot,tAddr(1),tAddr(2),tAddr(3),"ch") = tCMData
				Goto POSTDIM
DIMERR
				Set tSC = $$$ERROR($$$GeneralError,"Too many dimensions in query: " _ (tAxisCount))
				Quit
POSTDIM
			}

			// find next cell intersection
			Set tAxis = tAxisCount
			If (tAxis=0) {
				Set tDone = 1
			}
			While (1&&'tDone) {
				Set tNodeNo(tAxis) = $O($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tAxis),"axes",tAxisRoot(tAxis),"all",tNodeNo(tAxis)))
				If ((tNodeNo(tAxis)'="") && (tNodeNo(tAxis)'=tEndNode(tAxis))) {
					Do SetContext(tAxis)
					Quit
				}
				// try previous axis
				If ((tAxis > 1) && (tStartNode(tAxis)'="")) {
					Set tNodeNo(tAxis) = tStartNode(tAxis)
					// reset context
					Do SetContext(tAxis)
					Set tAxis = tAxis - 1
				}
				Else {
					Set tDone = 1
					Quit
				}
 			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC

	// set context for the given node
SetContext(tAxis)
	Set tNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tAxis),"axes",tNodeNo(tAxis)))
	Set tType = $LG(tNode,1)
	Set tCalc(tAxis) = +$LG(tNode,3)
	Kill tExpression(tAxis)
	Kill tLiteral(tAxis)
	Kill tSolveOrder(tAxis)
	Set tSpec(tAxis) = tBaseSpec

	// JMD1453: check for "orset";
	Set tInOR = 0
	Set tInORtuple = 0		// "ortuple": tuple as leg of OR

	// list of "orsets", by OR and branch within OR
	Set tORSetNo = 0
	Kill tORList

	// build chain of nodes back up to the top
	Kill tChain,tChainNode
	Set tLevelCount = 1
	Set tChain(tLevelCount) = tNodeNo(tAxis)
	Set tChainNode(tLevelCount) = tNode

	Set tParentNo = $LG(tNode,4)
	While (tParentNo '= "") {
		Set tLevelCount = tLevelCount + 1
		Set tChain(tLevelCount) = tParentNo
		Set tParentNode = $G($$$DeepSeeAxisGLVN(tCubeIndex,tAxisKey(tAxis),"axes",tParentNo))
		Set tChainNode(tLevelCount) = tParentNode
		Set tNewParentNo = $LG(tParentNode,4)
		If (tParentNo = tNewParentNo) {
			// cycle: should not happen
			Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Internal error: Cycle detected in axis"))
		}
		Set tParentNo = tNewParentNo
	}

	// build stacks of node info from top down
	Kill tSkipSet
	Set tLevel = 0
	For nn = tLevelCount:-1:1 {
		Set tLevel = tLevel + 1
		Set tLevel(tAxis) = tLevel
		Set tStackNo(tAxis,tLevel) = tChain(nn)
		Set tStackNode(tAxis,tLevel) = tChainNode(nn)

		Set tSNode = tStackNode(tAxis,tLevel)
		Set tSType = $LG(tSNode,1)
		Set tKey = $LG(tSNode,6)
		Set tFact = $LG(tSNode,7)
		Set tKey(tAxis,tLevel(tAxis)) = tKey
		Set tFact(tAxis,tLevel(tAxis)) = tFact

		Set tStackSpec(tAxis,tLevel(tAxis)) = $G(tStackSpec(tAxis,tLevel(tAxis)-1),tBaseSpec)

		Set sf = $LG(tSNode,20)
		If (sf'="") {
			For sx = 1:1:$L(sf,",") {
				Set fno = $P(sf,",",sx)
				// use key for current fact, if present
				Set tSkipSet(fno) = $S(tFact=fno:tKey,1:"")
			}
		}

		// JMD735: init stack vars
		Set tStackMeasure(tAxis,tLevel(tAxis)) = ""
		Set tStackMeasureType(tAxis,tLevel(tAxis)) = ""
		Set tStackAgg(tAxis,tLevel(tAxis)) = ""
		Set tStackScale(tAxis,tLevel(tAxis)) = ""
		Set tStackDistinct(tAxis,tLevel(tAxis)) = ""

		// test for %DISTINCT
		If (tSType = "agg") {
			If ($LG(tSNode,6)="%DISTINCT") {
				Set tStackDistinct(tAxis,tLevel(tAxis)) = 1
			}
		}

		If (tSType = "exp") {
			Set:+$LG(tSNode,15) tSolveOrder(tAxis)=+$LG(tSNode,15)
		}
		ElseIf (tSType = "lit") {
			Set:+$LG(tSNode,15) tSolveOrder(tAxis)=+$LG(tSNode,15)
		}
		ElseIf (tSType = "msr") {
			Set:+$LG(tSNode,15) tSolveOrder(tAxis)=+$LG(tSNode,15)
			Set tStackMeasure(tAxis,tLevel(tAxis)) = tFact
			// JMD1382 use 17
			Set tStackMeasureType(tAxis,tLevel(tAxis)) = $LG(tSNode,17)
			Set tStackAgg(tAxis,tLevel(tAxis)) = $LG(tSNode,8)
			Set tStackScale(tAxis,tLevel(tAxis)) = $LG(tSNode,13)
		}
		ElseIf (tSType = "orset") {
			// JMD1453 start accumulating an "orset"
			Set tORSetNo = tORSetNo + 1
			Set tInOR = 1
			Set tInORtuple = 0
		}
		ElseIf (tSType = "ortuple") {
			// JMD1453 start accumulating an "ortuple"
			Set tInORtuple = 1
			// advance to next or branch
			If ($D(tORList(tORSetNo))) {
				Set ox = $I(tORList(tORSetNo))
			}
		}
		ElseIf (tSType = "tuple") {
			// JMD1453 stop accumulating "orset"
			Set tInOR = 0
			Set tInORtuple = 0
			
			// WAL028 - Inherit measure context for tuple
			Set tStackMeasure(tAxis,tLevel(tAxis)) = $G(tStackMeasure(tAxis,tLevel(tAxis)-1))
			Set tStackMeasureType(tAxis,tLevel(tAxis)) = $G(tStackMeasureType(tAxis,tLevel(tAxis)-1))
			Set tStackAgg(tAxis,tLevel(tAxis)) = $G(tStackAgg(tAxis,tLevel(tAxis)-1))
			Set tStackScale(tAxis,tLevel(tAxis)) = $G(tStackScale(tAxis,tLevel(tAxis)-1))
			Set:$G(tStackDistinct(tAxis,tLevel(tAxis)))="" tStackDistinct(tAxis,tLevel(tAxis)) = $G(tStackDistinct(tAxis,tLevel(tAxis)-1))

		}
		Else {
			// inherit current measure, agg
			Set tStackMeasure(tAxis,tLevel(tAxis)) = $G(tStackMeasure(tAxis,tLevel(tAxis)-1))
			Set tStackMeasureType(tAxis,tLevel(tAxis)) = $G(tStackMeasureType(tAxis,tLevel(tAxis)-1))
			Set tStackAgg(tAxis,tLevel(tAxis)) = $G(tStackAgg(tAxis,tLevel(tAxis)-1))
			Set tStackScale(tAxis,tLevel(tAxis)) = $G(tStackScale(tAxis,tLevel(tAxis)-1))
			Set:$G(tStackDistinct(tAxis,tLevel(tAxis)))="" tStackDistinct(tAxis,tLevel(tAxis)) = $G(tStackDistinct(tAxis,tLevel(tAxis)-1))

			// set spec for this level
			If (tSType'="cmbr") {
				If ((tFact'="")&&(tKey'="")) {
					If (tInOR) {
						If (tInORtuple) {
							// JMD1453: add to current ortuple
							Set ox = $G(tORList(tORSetNo))
							Set:ox="" ox = $I(tORList(tORSetNo))
							Set tORList(tORSetNo,ox) = ..%CombineSpecs(tFactCount,$G(tORList(tORSetNo,ox)),..%SetFactIntoSpec(tFactCount,tStackSpec(tAxis,tLevel(tAxis)),tFact,tKey))
						}
						Else {
							// JMD1453: accumulate OR spec
							Set ox = $I(tORList(tORSetNo))
							Set tORList(tORSetNo,ox) = ..%SetFactIntoSpec(tFactCount,tStackSpec(tAxis,tLevel(tAxis)),tFact,tKey)
						}
					}
					Else {
						Set tStackSpec(tAxis,tLevel(tAxis)) = ..%SetFactIntoSpec(tFactCount,tStackSpec(tAxis,tLevel(tAxis)),tFact,tKey)
					}
				}
			}
		}

		Set tMeasure(tAxis) = $G(tStackMeasure(tAxis,tLevel(tAxis)))
		Set tMeasureType(tAxis) = $G(tStackMeasureType(tAxis,tLevel(tAxis)))
		Set tAgg(tAxis) = $G(tStackAgg(tAxis,tLevel(tAxis)))
		Set tDistinct(tAxis) = $G(tStackDistinct(tAxis,tLevel(tAxis)))
		Set tMsrScale(tAxis) = $G(tStackScale(tAxis,tLevel(tAxis)))
		Set tSpec(tAxis) = $G(tStackSpec(tAxis,tLevel(tAxis)))
		Set tSubstSpec(tAxis) = $G(tSubstStackSpec(tAxis,tLevel(tAxis)))

		// JMD1453: fold in OR sets
		Set oc = $O(tORList(""))
		While (oc'="") {
			Set tORSpec = ""
			Set ox = $O(tORList(oc,""))
			While (ox'="") {
				Set tORSpec = tORSpec _ $G(tORList(oc,ox))
				Set ox = $O(tORList(oc,ox))
			}
			If (tORSpec'="") {
				Set tSpec(tAxis) = ..%CombineSpecs(tFactCount,tSpec(tAxis),tORSpec)
			}
			Set oc = $O(tORList(oc))
		}

		Kill tSkipFacts(tAxis)
		// JMD: test before merge
		Merge:$D(tSkipSet) tSkipFacts(tAxis) = tSkipSet
		If (tType = "exp") {
			Set tExpression(tAxis) = ""
		}
		ElseIf (tType = "lit") {
			Set tLiteral(tAxis) = $LG(tNode,6)
		}
	} // For nn
	Quit

	// convert spec to a cache address
	Set tSpec =""
SpecToAddr(tSpec)
	// JMD918: correct call to %CanonizeAddr
	For px=1:1:$LL(tSpec) {
		Set:$LG(tSpec,px)["&" $List(tSpec,px) = ..%CanonizeAddr($LG(tSpec,px))
	}
	// remove trailing :
	Set tCacheAddr = $ZSTRIP($ListToString(tSpec,":"),">",":")
	// JMD1169
	Quit $S(($L(tCacheAddr)+$L(tCubeIndex))>480:"",1:tCacheAddr)

	// Get bit mask for the given spec
Mask(tSpec,tChunk,tFactMask)
	If (tShowPlan) {
		Set tFactMask = ""
	}

	// JMD1453 the spec may contain multiple OR specs, each tFactCount+1 long
	Set tOrCount = $LL(tSpec)/(tFactCount+1)
	Set tOrMask = "" 
	For oc = 1:1:tOrCount {
		Set tMask = $G(tExtent(tChunk),$$$DeepSeeIndexGLVN(tCubeIndex,"$Fact",tChunk))
		For fc = 1:1:tFactCount {
			// translate fc to fact #
			Set f = $LG(tFactOrder,fc+1)
			Set tOrOffset = (oc-1)*(tFactCount+1)

			// JMD879: test for missing f
			Set k = $S(f="":"",1:$LG(tSpec,f+1+tOrOffset))
			If (k'="") {
				If (tShowPlan) {
					Set $List(tFactMask,f) = 1
				}
				If (tHasRelations && $D(tRelation(f)) && ($E(k)="@")) { // this is a relation
					// JMD1501 normalize key code so that it matches join index
					Set kcode = ..%CanonizeRelationKey(k)

					// JMD1017
					Set khash = $S($L(kcode)<100:kcode,1:$ZCRC(kcode,7))	// DTB055 - use the canonized kcode
					Set tMask = $BitLogic(tMask&$$$DeepSeeJoinGLVN(tCubeIndex,f,khash,tChunk))
				}
				Else {
					For j = 1:1:$L(k,"&") {
						Set k2 = $P(k,"&",j)
						If (k2'="") {
							Kill tTest
							If (k2["|") {
								// OR
								For j2 = 1:1:$L(k2,"|") {
									Set k3 = $P(k2,"|",j2)
									If (k3'="") {
										Set tTest(j2) = tMask
										If ($E(k3)="!") {
											// strip off marker and negate index
											Set k3 = $E(k3,2,*)
											Set tTest(j2) = $BitLogic(tTest(j2)&~$$$DeepSeeIndexGLVN(tCubeIndex,f,k3,tChunk))
										}
										Else {
											Set tTest(j2) = $BitLogic(tTest(j2)&$$$DeepSeeIndexGLVN(tCubeIndex,f,k3,tChunk))
										}
									}
								}
								// fold branches
								Set tMask = ""
								Set jx = $O(tTest(""))
								If (jx'="") {
									Set tMask = tTest(jx)
									Set jx = $O(tTest(jx))
								}
								While (jx'="") {
									Set tMask = $BitLogic(tMask|tTest(jx))
									Set jx = $O(tTest(jx))
								}
							}
							Else {
								// test for NOT (!)
								If ($E(k2)="!") {
									// strip off marker and negate index
									Set k2 = $E(k2,2,*)
									Set tMask = $BitLogic(tMask&~$$$DeepSeeIndexGLVN(tCubeIndex,f,k2,tChunk))
								}
								Else {
									Set tMask = $BitLogic(tMask&$$$DeepSeeIndexGLVN(tCubeIndex,f,k2,tChunk))
								}
							}
						}
					}
					Quit:'$BitFind(tMask,1)
				}
			}
		}
		If (tOrCount>1) {
			Set tOrMask = $BitLogic(tOrMask|tMask)
		}
	} // oc

	If (tOrCount>1) {
		Set tMask = $BitLogic(tOrMask)
	}
	Set:$BitCount(tMask,1)=0 tMask=""
	Quit tMask

	// Basic Aggregates
	Set tSpec = ""
	Set tMeasure = "" // if supplied, this is the current measure
	Set tMeasureType = ""
Count(tSpec,tMeasure,tMeasureType)
	Kill tAddr
	Set tAddr = $S(tUseCache:$$SpecToAddr(tSpec),1:"")
	If (tMeasure'="") {
		Set tMeasureNo = +$E(tMeasure,2,*)
		If (tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))< 480)&&$D($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),val) { // JSL4457 - check length of subscripts
			If $LD(val,$$$DeepSeeAggCOUNT) {
				Set x=$I(pStats($$$dsqStatCache))
				Quit $LG(val,$$$DeepSeeAggCOUNT)
			}
		}
	}
	Else {
		If (tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr))<480)&&(1=$D($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr),val)) { // JSL4457 - check length of subscripts
			Set x=$I(pStats($$$dsqStatCache))
			Quit val
		}
	}
	Set x=$I(pStats($$$dsqStatCompute))

	// calculate count from indices
	If (tMeasure'="") {
		// compute count including measure index
		Set tCount = ""
		Set tChunk = $O(tExtent(""))
		While (tChunk '= "") {
			Set tMask = $$Mask(tSpec,tChunk,.tFactMask)
			If ($BitFind(tMask,1)) {
				If (tMeasureType = "B") { // boolean: look at "true" index 
					Set c = $BitCount($BitLogic(tMask&$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,1,tChunk)),1)
				}
				Else {
					Set c = $BitCount($BitLogic(tMask&~$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,"N",tChunk)),1)
				}
				Set:c>0 tCount = tCount + c
			}
			Set tChunk = $O(tExtent(tChunk))
		}
	}
	Else {
		Set tCount = ""
		Set tChunk = $O(tExtent(""))
		While (tChunk '= "") {
			Set tMask = $$Mask(tSpec,tChunk,.tFactMask)
			Set c = $BitCount(tMask,1)
			Set:c>0 tCount = tCount + c
			Set tChunk = $O(tExtent(tChunk))
		}
	}

	If (tShowPlan) {
		// remember which indices were needed
		If (tMeasure'="") {
			Set tFactMask = $G(tFactMask)
			Set:tFactMask="" tFactMask = 0 	// no dimensions
			Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"keys",tFactMask,tMeasure) = ""
		}
		ElseIf ($G(tFactMask)'="") {
			Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"keys",tFactMask) = ""
		}
	}

	// store value in cell cache
	If (tMeasure'="") {
		Set:(tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480) $List($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),$$$DeepSeeAggCOUNT) = tCount // JSL4457 check length of subscripts
	}
	Else {
		Set:(tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr))<480) $$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr) = tCount // JSL4457 - check length of subscripts
	}
	Quit tCount

	Set tSpec="",tMeasure=""

	// test if *any* value exists for the given spec
Exists(tSpec,tMeasure,tMeasureType)
	Kill tAddr

	// we are only called for the active slot, so test slot 1
	Set tAddr = $$SpecToAddr(tSpec)

	If (tMeasure'="") {
		Set tMeasureNo = +$E(tMeasure,2,*)
		If (tAddr'="")&&(($L(tCubeIndex)+$L(tMeasureNo)+$L(tAddr))<480)&&$D($$$DeepSeeCellsGLVN(tCubeIndex,1,tAddr,tMeasureNo),val) { // JSL4457 - check length of subscripts
			// test the "count" cache; if there is a value, then we can skip the rest
			If ($LD(val,$$$DeepSeeAggCOUNT)&&($LG(val,$$$DeepSeeAggCOUNT)>0)) {
				Set x=$I(pStats($$$dsqStatCache))
				Quit 1
			}
		}
	}
	Else {
		If (tAddr'="")&&(($L(tCubeIndex)+$L(tAddr))<480)&&(1=$D($$$DeepSeeCellsGLVN(tCubeIndex,1,tAddr),val)) { // JSL4457 - check length of subscripts
			// test the "count" cache; if there is a value, then we can skip the rest
			If (val>0) {
				Set x=$I(pStats($$$dsqStatCache))
				Quit 1
			}
		}
	}

	Set x=$I(pStats($$$dsqStatCompute))

	// loop over *all* chunks, stop as soon as there is a bit
	Set tExists = 0
	If (tMeasure'="") {
		// use non-null measure index as well
		Set tChunk = $O($$$DeepSeeIndexGLVN(tCubeIndex,"$Fact",""))
		While (tChunk '= "") {
			Set tMask = $$Mask(tSpec,tChunk,.tFactMask)
			If ($BitFind(tMask,1)) {
				If (tMeasureType = "B") { // boolean: look at "true" index 
					Set c = $BitFind($BitLogic(tMask&$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,1,tChunk)),1)
				}
				Else {
					Set c = $BitFind($BitLogic(tMask&~$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,"N",tChunk)),1)
				}
				If (c) {
					Set tExists = 1
					Quit
				}

			}
			Set tChunk = $O($$$DeepSeeIndexGLVN(tCubeIndex,"$Fact",tChunk))
		}
	}
	Else {
		Set tChunk = $O($$$DeepSeeIndexGLVN(tCubeIndex,"$Fact",""))
		While (tChunk '= "") {
			Set tMask = $$Mask(tSpec,tChunk,.tFactMask)
			If ($BitFind(tMask,1)) {
				Set tExists = 1
				Quit
			}
			Set tChunk = $O($$$DeepSeeIndexGLVN(tCubeIndex,"$Fact",tChunk))
		}
	}
	Quit tExists

	Set tSpec="",tMeasure=""

Sum(tSpec,tMeasure,tScale)
	// Note: measure *could* be boolean, but it all works out
	Set tScaleFactor = $Case(tScale,1:1E-1,2:1E-2,3:1E-3,4:1E-4,5:1E-5,6:1E-6,7:1E-7,8:1E-8,9:1E-9,10:1E-10,11:1E-11,12:1E-12,13:1E-13,14:1E-14,15:1E-15,16:1E-16,17:1E-17,18:1E-18,:1)
	Kill tAddr
	Set tAddr = $S(tUseCache:$$SpecToAddr(tSpec),1:"")
	Set tMeasureNo = +$E(tMeasure,2,*)
	If (tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480)&&$D($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),val) { // JSL4457 - check length of subscripts
		If $LD(val,$$$DeepSeeAggSUM) {
			Set x=$I(pStats($$$dsqStatCache))
			Quit $LG(val,$$$DeepSeeAggSUM)
		}
	}
	Set x=$I(pStats($$$dsqStatCompute))

	Set tSum = ""
	Set tCount = ""
	Set tChunk = $O(tExtent(""))
	While (tChunk '= "") {
		Set tMask = $$Mask(tSpec,tChunk,.tFactMask)
		If (tMask'="") {
			Set tDigit = $O($$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,""))
			While (tDigit '= "") {
				If (+tDigit) {
					Set minus = $BitLogic(tMask&$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,"-",tChunk))
					Set data = $BitLogic(tMask&$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,tDigit,tChunk))
					Set sub = $BitCount(data,1)-(2*$BitCount($BitLogic(data&minus),1))
					Set:sub'=0 tSum = 2**(tDigit-1)*tScaleFactor*sub+tSum
				}
				Set tDigit = $O($$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,tDigit))
			}
			If (tSum = "") {
				Set zeroBitStr = $bitlogic(tMask & $$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,"Z",tChunk))
				If ($bitcount(zeroBitStr,1) > 0) { Set tSum = 0 }
			}
		}
		Set tChunk = $O(tExtent(tChunk))
	}
	If (tShowPlan) {
		// remember which indices were needed
		Set tFactMask = $G(tFactMask)
		Set:tFactMask="" tFactMask = 0 	// no dimensions
		Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"keys",tFactMask,tMeasure) = ""
	}
	Set:(tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480) $List($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),$$$DeepSeeAggSUM) = tSum // JSL4457 - check length of subscripts
	Quit tSum

Min(tSpec,tMeasure,tScale)
	Kill tAddr
	Set tAddr = $S(tUseCache:$$SpecToAddr(tSpec),1:"")
	Set tMeasureNo = +$E(tMeasure,2,*)
	If (tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480)&&$D($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),val) { // JSL4457 - check length of subscripts
		If $LD(val,$$$DeepSeeAggMIN) {
			Set x=$I(pStats($$$dsqStatCache))
			Quit $LG(val,$$$DeepSeeAggMIN)
		}
	}
	Set x=$I(pStats($$$dsqStatCompute))
	Set tMin = $$calcAggr(tSpec, tMeasure, 0, tScale)
	Set:(tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480) $List($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),$$$DeepSeeAggMIN) = tMin // JSL4457 - check length of subscripts
	Quit tMin

Max(tSpec,tMeasure,tScale)
	Kill tAddr
	Set tAddr = $S(tUseCache:$$SpecToAddr(tSpec),1:"")
	Set tMeasureNo = +$E(tMeasure,2,*)
	If (tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480)&&$D($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),val) { // JSL4457 - check length of subscripts
		If $LD(val,$$$DeepSeeAggMAX) {
			Set x=$I(pStats($$$dsqStatCache))
			Quit $LG(val,$$$DeepSeeAggMAX)
		}
	}
	Set x=$I(pStats($$$dsqStatCompute))
	Set tMax = $$calcAggr(tSpec, tMeasure, 1, tScale)
	Set:(tAddr'="")&&(($L(tCubeIndex)+$L(tResultSlot)+$L(tAddr)+$L(tMeasureNo))<480) $List($$$DeepSeeCellsGLVN(tCubeIndex,tResultSlot,tAddr,tMeasureNo),$$$DeepSeeAggMAX) = tMax // JSL4457 - check length of subscripts
	Quit tMax

calcAggr(tSpec, tMeasure, isMax, tScale)
	s res = ""
	
	s chunk = $o(tExtent(""))	
	while (chunk '= "") { // go over all chunks
		s tMask = $$Mask(tSpec,chunk,.tFactMask)
		
		// JMD-ignore null values
		Set:($bitcount(tMask,1)>0) tMask = $BitLogic(tMask&~$$$DeepSeeIndexGLVN(tCubeIndex,tMeasure,"N",chunk))
		s bitPos = $o($$$DeepSeeIndexGLVN(tCubeIndex, tMeasure, ""), -1)
		s chunkRes = "" // the result in this chunk

		s allBitStr = tMask // all candidate values in the chunk
		s negBitStr = $g($$$DeepSeeIndexGLVN(tCubeIndex, tMeasure, "-", chunk))
		if (negBitStr '= "") {
			if (isMax) { // calculate Max
				s posAllBitStr = $bitlogic(~negBitStr & allBitStr)
				if ($bitcount(posAllBitStr, 1) > 0) { // there are positive values, calculate max(|S|)
					s isAbsMax = 1, sign = 1, allBitStr = posAllBitStr
				}
				else { // only negative values, calculate min(|S|)
					s isAbsMax = 0, sign = -1, allBitStr = $bitlogic(negBitStr & allBitStr)
				}
			}
			else { // calculate Min
				s negAllBitStr = $bitlogic(negBitStr & allBitStr)
				if ($bitcount(negAllBitStr, 1) > 0) { // there are negative values, calculate max(|S|)
					s isAbsMax = 1, sign = -1, allBitStr = negAllBitStr
				}
				else { // only positive values, calculate min(|S|)
					s isAbsMax = 0, sign = 1, allBitStr = $bitlogic(~negBitStr & allBitStr)
				}
			}
		}
		else { // all values are positive
			s sign = 1, isAbsMax = isMax
		}
			
		while ((bitPos '= "") && ($bitcount(allBitStr, 1) > 0)) { // go over all bits in one chunk
			s bitStr = $g($$$DeepSeeIndexGLVN(tCubeIndex, tMeasure, bitPos, chunk)) // deleted ids are filtered in allBitStr						
			if (+bitPos && (bitStr '= ""))  {
				s bitSet = $bitlogic(bitStr & allBitStr)
				s:isAbsMax countBit = $bitfind(bitSet, 1) // one bit is enough
				s:'isAbsMax countBit = ($bitcount(allBitStr, 1) = $bitcount(bitSet, 1)) // need all bits
				if (countBit) {
					s allBitStr = bitSet
					s chunkRes = chunkRes + (2 ** (bitPos - 1)) 
				}
				else {
					s allBitStr = $bitlogic(~bitStr & allBitStr)
				}
			}
			s bitPos = $o($$$DeepSeeIndexGLVN(tCubeIndex, tMeasure, bitPos), -1)
		}
		
		if (chunkRes = "") {
			s zeroBitStr = $bitlogic(tMask & $$$DeepSeeIndexGLVN(tCubeIndex, tMeasure, "Z", chunk))
			if ($bitcount(zeroBitStr,1) > 0) { s chunkRes = 0 }  // jmd: added 1 to bitcount
		}
		if (chunkRes '= "") {
			s chunkRes = sign * chunkRes	
			if ((res = "") || (isMax && (res < chunkRes)) || ('isMax && (res > chunkRes))) {
				s res = chunkRes 
			}
		}
		
		s chunk = $O(tExtent(chunk))			
	}

	If (tShowPlan) {
		// remember which indices were needed
		Set tFactMask = $G(tFactMask)
		Set:tFactMask="" tFactMask = 0 	// no dimensions
		Set $$$DeepSeeResultsGLVN(tCubeIndex,pKey,"keys",tFactMask,tMeasure) = ""
	}
	Set tScaleFactor = $Case(tScale,1:1E-1,2:1E-2,3:1E-3,4:1E-4,5:1E-5,6:1E-6,7:1E-7,8:1E-8,9:1E-9,10:1E-10,11:1E-11,12:1E-12,13:1E-13,14:1E-14,15:1E-15,16:1E-16,17:1E-17,18:1E-18,:1)
	Quit $S(res="":"",1:res*tScaleFactor)
}

/// Insert the given fact/key into the given cell spec.
ClassMethod %SetFactIntoSpec(pFactCount As %Integer, pSpec As %List, pFact As %Integer, pKey As %String, pForce As %Boolean = 0) As %List [ Internal ]
{
	// JMD1453 if there are OR branches in the spec; apply fact to each
	Set tOrCount = $LL(pSpec)/(pFactCount+1)
	For oc = 1:1:tOrCount {
		Set tKey = pKey
		Set tOrOffset = (oc-1)*(pFactCount+1)
		If ('pForce) {
			Set ef = $LG(pSpec,pFact+1+tOrOffset)
			// test for conflicting facts; 
			// check for "@" for relationships
			If ((ef'="")&&(ef'=tKey)) {
				// JMD1509 check for relation keys and normalize!
				If ($E(tKey)="@") {
					Set tKey = ef _ "*" _ tKey
					Set tKey = ..%CanonizeRelationKey(tKey)
				}
				Else {
					Set tKey = ef _ "&" _ tKey
				}
			}
		}
		Set $List(pSpec,pFact+1+tOrOffset) = tKey
	}
	Quit pSpec
}

/// Combine 2 cell "specs" and return the resulting spec.
ClassMethod %CombineSpecs(pFactCount As %Integer, pSpec1 As %List, pSpec2 As %List) As %List [ Internal ]
{
	If (pSpec1="") Quit pSpec2
	If (pSpec2="") Quit pSpec1

	// fold spec2 into spec1
	// find number of "or" pieces in each spec
	Set tOrCount1 = $LL(pSpec1)/(pFactCount+1)
	Set tOrCount2 = $LL(pSpec2)/(pFactCount+1)

	// make sure counts are integers!
	// (throw an error)
	If ((tOrCount1'=(tOrCount1\1))||(tOrCount2'=(tOrCount2\1))) {
		Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Internal error: %CombineSpecs"))
		Quit "INVALID SPEC"
	}

	// if no ORs, use simpler code
	If ((tOrCount1=1)&&(tOrCount2=1)) {
		For f = 1:1:pFactCount {
			Set tKey = $LG(pSpec2,f+1)
			If (tKey'="") {
				Set ef = $LG(pSpec1,f+1)
				If ((ef'="")&&(ef'=tKey)) {
					// JMD1509 check for relation keys and normalize!
					If ($E(tKey)="@") {
						Set tKey = ef _ "*" _ tKey
						Set tKey = ..%CanonizeRelationKey(tKey)
					}
					Else {
						Set tKey = ef _ "&" _ tKey
					}
				}
				Set $List(pSpec1,f+1) = tKey
			}
		}
		Quit pSpec1
	}

	// deal with or*or
	// split s1 and s2 into pieces
	For s1 = 1:1:tOrCount1 {
		Set tOff = ((s1-1)*(pFactCount+1))
		Set tSpec(1,s1) = $List(pSpec1,1+tOff,pFactCount+tOff+1)
	}
	For s2 = 1:1:tOrCount2 {
		Set tOff = ((s2-1)*(pFactCount+1))
		Set tSpec(2,s2) = $List(pSpec2,1+tOff,pFactCount+tOff+1)
	}

	// now compute s1*s2
	For s1 = 1:1:tOrCount1 {
		For s2 = 1:1:tOrCount2 {
			Set tSpec1 = tSpec(1,s1)
			For f = 1:1:pFactCount {
				Set tKey = $LG(tSpec(2,s2),f+1)
				If (tKey'="") {
					Set ef = $LG(tSpec1,f+1)
					If ((ef'="")&&(ef'=tKey)) {
						Set tKey = ef _ $S($E(tKey)="@":"*",1:"&") _ tKey
					}
					Set $List(tSpec1,f+1) = tKey
				}
			}
			Set tOutput($I(tOutput)) = tSpec1
		}
	}
	
	// combine
	Set tOutSpec = ""
	Set k = $O(tOutput(""))
	While (k'="") {
		Set tOutSpec = tOutSpec _ tOutput(k)
		Set k = $O(tOutput(k))
	}
	Quit tOutSpec
}

/// Apply the slicer mask to a given query and bucket number.
ClassMethod %ApplySlicerMask(pCube As %String, pSlicerKey As %String, ByRef pExtent, pHasRelations As %Boolean = 0, ByRef pRelation) [ Internal ]
{
	Set tAddr = ""
	Set tCubeName = $$$UPPER(pCube)
	Set tCubeIndex = $$$DeepSeeIndex(pCube)

	If (pSlicerKey'="") {
		Do ##class(%DeepSee.Query.Engine).%GetBranchesForSlicer(pCube,pSlicerKey,.tBranch)
	}

	If ('$D(tBranch)) {
		// nothing to do
		Quit
	}
	Else {
		// fold slicer branches into tAddr (per each branch)
		Set bno = $O(tBranch(""))
		While (bno'="") {
			Set tAddr(bno) = tAddr
			Set i = $O(tBranch(bno,""),1,data)
			While (i '= "") {
				Set f = $LG(data,1)
				Set k = $LG(data,2)

				// get current key for fact and replace (with AND if needed)
				Set ck = $P(tAddr(bno),":",f+1)
				Set k = $S(ck="":k,1:k_"&"_ck)
				Set $P(tAddr(bno),":",f+1) = k
				Set i = $O(tBranch(bno,i),1,data)
			}
			Set bno = $O(tBranch(bno))
		}
	}

	Set tChunksPerBucket = $$$DeepSeeChunksPerBucket(tCubeName)

	// apply slicer to every element within the extent list
	Set tChunk = $O(pExtent(""))
	While (tChunk'="") {
		// Test against each OR branch in the slicer
		Set tIgnoreMask = 0
		Kill tChunkMask
		Set bno = $O(tBranch(""))
		While ((bno'="")) {
			Kill tMask
			Set tIgnoreMask = $$GetSlicerMask(.tMask,.tBranch,bno,tChunk)
			If (tIgnoreMask) {
				Quit
			}
			If $D(tMask) {
				If $D(tChunkMask) {
					Set tChunkMask = $BitLogic(tMask|tChunkMask)
				}
				Else {
					Set tChunkMask = tMask
				}
			}
			// next branch
			Set bno = $O(tBranch(bno))
		}
		If ('tIgnoreMask) {
			Set tChunkMask = $G(tChunkMask)
			Set pExtent(tChunk) = $BitLogic(pExtent(tChunk)&tChunkMask)
			If ('$BitFind(pExtent(tChunk),1)) {
				Kill pExtent(tChunk)
			}
		}

		// next chunk
		Set tChunk = $O(pExtent(tChunk))
	}
	Quit

	// build mask from slicer for the given chunk and branch
	// return 1 if this is a relationship and there is no index for it;
	// this tells the caller to ignore the result
GetSlicerMask(tMask,tBranch,tBranchNo,tChunk)
	Set tIgnore = 0
	Set i = $O(tBranch(tBranchNo,""),1,data)
	While (i '= "") {
		// DTB067 - Initialize tTest (individual OR processing) for each tBranchNo (branches to be ANDed together)
		Kill tTest  
		Set f = $LG(data,1)
		Set k = $LG(data,2)

		If (pHasRelations && $D(pRelation(f))&&($E(k)="@")) { // this is a relation
			Set k= ..%CanonizeRelationKey(k) // JSL4407		
			// JMD1017 use hash to prevent subscript error
			Set khash = $S($L(k)<100:k,1:$ZCRC(k,7))
			If ('$D(tMask)) {
				If $D($$$DeepSeeJoinGLVN(tCubeIndex,f,khash,tChunk)) {
					Set tMask = $BitLogic($$$DeepSeeJoinGLVN(tCubeIndex,f,khash,tChunk))
				}
				Else {
					//Set tIgnore = 1
					Set tIgnore = 0		// DTB323 - Do not ignore based on missing join index
				}
			}
			Else {
				If $D($$$DeepSeeJoinGLVN(tCubeIndex,f,khash,tChunk)) {
					Set tMask = $BitLogic(tMask&$$$DeepSeeJoinGLVN(tCubeIndex,f,khash,tChunk))
					Quit:'$BitFind(tMask,1)
				}
				Else {
					//Set tIgnore = 1
					Set tIgnore = 0		// DTB323 - Do not ignore based on missing join index
				}
			}
		}
		Else {
			// not a relation; loop over ORs within this key if any
			For j=1:1:$L(k,"|") {
				Set k2 = $P(k,"|",j)
				Kill tTest(j)
				Set:$D(tMask) tTest(j) = tMask

				If ('$D(tTest(j))) {
					Set tNot = 0
					If ($E(k2)="!") {
						Set tNot = 1,k2 = $E(k2,2,*)
					}
					If (tNot) {
						Set tTest(j) = $BitLogic(pExtent(tChunk)&~$$$DeepSeeIndexGLVN(tCubeIndex,f,k2,tChunk))
					}
					Else {
						Set tTest(j) = $G($$$DeepSeeIndexGLVN(tCubeIndex,f,k2,tChunk))
					}
				}
				Else {
					Set tNot = 0
					If ($E(k2)="!") {
						Set tNot = 1,k2 = $E(k2,2,*)
					}
					If (tNot) {
						Set tTest(j) = $BitLogic(tTest(j)&~$$$DeepSeeIndexGLVN(tCubeIndex,f,k2,tChunk))
					}
					Else {
						Set tTest(j) = $BitLogic(tTest(j)&$$$DeepSeeIndexGLVN(tCubeIndex,f,k2,tChunk))
					}
				}
			} // j
			
			// fold branches of the current OR
			Set tMask = ""
			Set jx = $O(tTest(""))
			If (jx'="") {
				Set tMask = tTest(jx)
				Set jx = $O(tTest(jx))
			}
			While (jx'="") {
				Set tMask = $BitLogic(tMask|tTest(jx))
				Set jx = $O(tTest(jx))
			}
			Quit:'$BitFind(tMask,1)
		}
		Set i = $O(tBranch(tBranchNo,i),1,data)
	}
	Quit tIgnore
}

/// For a given cube and query (key) return the number of
/// axes (including the slicer).<br/>
/// <var>pAxisType</var> is an array containing the type of each axis: "axis" or "slicer".<br/>
/// <var>pAxisNode</var> is an array containing the top node number for each axis.<br/>
/// <var>pAxisSize</var> is an array containing the number of leaf nodes for each axis.<br/>
/// <var>pSlicerAxis</var> indicates whether there is a slicer axis. If there is this will contain the axis number for the slicer otherwise 0.<br/>
ClassMethod %GetAxisInfo(pCubeName As %String, pKey As %String, Output pAxisType As %String, Output pAxisKey As %String, Output pAxisSize As %Integer, Output pSlicerAxis As %Boolean) As %Integer
{
	Set tAxisCount = 0
	Set pSlicerAxis = 0

	Set tCubeIndex = $$$DeepSeeIndex(pCubeName)
	Set tSizeInfo = $G($$$DeepSeeResultsGLVN(tCubeIndex,pKey,"size"))
	Set tAxisCount = $LL(tSizeInfo)
	For a = 1:1:tAxisCount {
		Set tInfo = $LG(tSizeInfo,a)
		Set pAxisType(a) = $LG(tInfo,1)
		Set pAxisKey(a) = $LG(tInfo,2)
		Set pAxisSize(a) = $LG(tInfo,3)
		If (pAxisType(a)="slicer") {
			Set pSlicerAxis = a
		}
	}
	Quit tAxisCount
}

/// Take a cell address and return its canonic form.
ClassMethod %CanonizeAddr(pAddr As %String) As %String [ Internal ]
{
	// JMD1115
	// Do not remove non-matching ANDed items: 1&2 should remain 1&2
	// Note: OR binds tighter than AND, so:
	// 1&2&4|3 is the same as 1&2&3|4

	Set tOut = ""
	Set tLen = $L(pAddr,":")
	For f=1:1:tLen {
		Kill tTerms
		Set tKey = ""
		Set tFactKey = $P(pAddr,":",f)
		If (tFactKey'="") {
			// we have the form: A|B&C|D&E|F
			// factor out AND/ORs and return keys in alpha order
			For a = 1:1:$L(tFactKey,"&") {
				Set and = $P(tFactKey,"&",a)
				For b = 1:1:$L(and,"|") {
					Set k = $P(and,"|",b)
					// remove duplicate OR terms
					Set tTerms(a,k) = ""
				}
			}
			// JMD1160: do not process AND of OR expressions
			// 1|2&2 --> 1|2&2
			// find out which items are ORs
			Set a = $O(tTerms(""))
			While (a'="") {
				Set b = $O(tTerms(a,""))
				If ($O(tTerms(a,b))'="") {
					Set tOrTerms(a) = 1
				}
				Set a = $O(tTerms(a))
			}

			// process ANDs
			Set a1 = $O(tTerms(""))
			While (a1'="") {
				If ('$D(tOrTerms(a1))) {
					Set a2 = $O(tTerms(a1))
					While (a2'="") {
						If ('$D(tOrTerms(a2))) {
							// first test a1*a2
							Set b = $O(tTerms(a1,""))
							While (b'="") {
								Kill tTerms(a2,b)
								Set b = $O(tTerms(a1,b))
							}

							// then test a2*a1
							Set b = $O(tTerms(a2,""))
							While (b'="") {
								Kill tTerms(a1,b)
								Set b = $O(tTerms(a2,b))
							}
						}
						Set a2 = $O(tTerms(a2))
					}
				}
				Set a1 = $O(tTerms(a1))
			}

			// emit
			Set a = $O(tTerms(""))
			While (a'="") {
				Set tOR = ""
				Set b = $O(tTerms(a,""))
				While (b'="") {
					Set tOR = tOR _ $S(tOR'="":"|",1:"") _ b
					Set b = $O(tTerms(a,b))
				}
				Set:tOR'="" tKey = tKey _ $S(tKey'="":"&",1:"") _ tOR
				Set a = $O(tTerms(a))
			}
		}
		Set tOut = tOut _ $S(f>1:":",1:"") _ tKey
	}
	Quit tOut
}

/// Take a relationship key code and return its canonic form (put all pieces in
/// alpha-order).
ClassMethod %CanonizeRelationKey(pKeyCode As %String) As %String [ Internal ]
{
	If (pKeyCode'["*") {
		Quit pKeyCode
	}
	For p = 1:1:$L(pKeyCode,"*") {
		Set k = $P(pKeyCode,"*",p)
		Set:k'="" tList(k) = ""
	}
	Set tKeyCode = ""
	Set p = $O(tList(""))
	While (p'="") {
		Set tKeyCode = tKeyCode _$S(tKeyCode="":"",1:"*") _ p
		Set p = $O(tList(p))
	}
	Quit tKeyCode
}

/// Diagnostic.
ClassMethod PrintBits(pMsg, pBits) [ Internal ]
{
	W $E(pMsg,1,10),?10
	If (pBits'="") {
		Set l = $BitCount(pBits)
		W:l>70 !
		For n=1:1:l {
			Set b = $Bit(pBits,n)
			W $S(b=0:0,1:$C(27)_"[1m"_1_$C(27)_"[0m")
		}
	}
	W !
}

}
