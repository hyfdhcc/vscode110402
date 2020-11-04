Class %DeepSee.PMML.Model.Tree Extends AbstractModel [ Abstract, System = 4 ]
{

Parameter TRACEWEIGHTTYPE = "tree";

ClassMethod %CreateModelClass(pClass As %Dictionary.ClassDefinition, pDefinition As %DeepSee.PMML.Definition.Models.AbstractModel) As %Status [ Internal ]
{
	#dim tDefinition As %DeepSee.PMML.Definition.Models.TreeModel = pDefinition
	
	set tSC = $$$OK
	try {
		
		/// Create %ExecuteModelInternal method
		set tExecute = ##class(%Dictionary.MethodDefinition).%New()
		set tExecute.Name = "%ExecuteModelInternal"
		set tExecute.FormalSpec = "pObservation:%DeepSee.PMML.ModelInput,*pOutput:%DeepSee.PMML.ModelOutput"
		set tExecute.ReturnType = "%Status"
		set tExecute.Private = 1
		
		#define WriteLine(%c) do tExecute.Implementation.WriteLine($c(9)_%c)
		$$$WriteLine("set tSC = $$$OK")
		$$$WriteLine("try {")
		$$$WriteLine("	set tMissingValueCount = 0, tTrace = ..Tracing")
		if (tDefinition.missingValueStrategy="aggregateNodes") || (tDefinition.missingValueStrategy="weightedConfidence") {
			$$$WriteLine("	set tAggregationMode = 0")
		}
		
		set tSC = ..%WriteNodeBranch(tDefinition.Node, tExecute.Implementation, tDefinition.missingValueStrategy, tDefinition.noTrueChildStrategy, , 1)
		quit:$$$ISERR(tSC)
		
		// as the last part of walking the tree, process tScores
		do tExecute.Implementation.WriteLine("end	// process tScores")
		if (tDefinition.missingValueStrategy="weightedConfidence") {
			
			$$$WriteLine("	if (tAggregationMode) {")
			$$$WriteLine("		set tValue = """", tConfidence = """", tBestValue = """"")
			$$$WriteLine("		for {")
			$$$WriteLine("			set tValue = $order(tAggregatedConf(tValue),1,tConf)")
			$$$WriteLine("			quit:tValue=""""")
			$$$WriteLine("			set:(tConfidence="""")||(tConfidence<tConf) tConfidence = tConf, tBestValue = tValue")
			$$$WriteLine("		}")
			$$$WriteLine("")
			$$$WriteLine("		kill tScores")
			$$$WriteLine("		set tValue = """"")
			$$$WriteLine("		for {")
			$$$WriteLine("			set tValue = $order(tAggregatedScores(tValue), 1, tRecordCount)")
			$$$WriteLine("			quit:tValue=""""")
			$$$WriteLine("			set tScores(tValue) = tRecordCount / tAggregatedScores")
			if (tDefinition.functionName="classification") {
				$$$WriteLine("			set:i%KeepAllClassProbabilities tAllClassProbs($i(tAllClassProbs)) = $lb(tValue, tScores(tValue))")
			}
			$$$WriteLine("		}")
			$$$WriteLine("		set tBestProb = $s(tBestValue="""":"""", 1:$g(tScores(tBestValue)))")
			$$$WriteLine("	} else {")
			$$$WriteLine("		set tValue = """", tBestProb = """", tBestValue = """"")
			$$$WriteLine("		for {")
			$$$WriteLine("			set tValue = $order(tScores(tValue),1,tProb)")
			$$$WriteLine("			quit:tValue=""""")
			if (tDefinition.functionName="classification") {
				$$$WriteLine("			set:i%KeepAllClassProbabilities tAllClassProbs($i(tAllClassProbs)) = $lb(tValue, tProb)")
			}
			$$$WriteLine("			set:(tBestProb="""")||(tBestProb<tProb) tBestProb = tProb, tBestValue = tValue")
			$$$WriteLine("		}")
			$$$WriteLine("		// derive confidence value")
			$$$WriteLine("		set tConfidence = $s(tBestValue="""":"""", 1:$g(tConfidence(tBestValue)))")
			$$$WriteLine("	}")
			
		} else {
			if tDefinition.missingValueStrategy="aggregateNodes" {
				$$$WriteLine("	if (tAggregationMode) {")
				$$$WriteLine("		kill tScores")
				$$$WriteLine("		set tValue = """"")
				$$$WriteLine("		for {")
				$$$WriteLine("			set tValue = $order(tAggregatedScores(tValue), 1, tRecordCount)")
				$$$WriteLine("			quit:tValue=""""")
				$$$WriteLine("			set tScores(tValue) = tRecordCount / tAggregatedScores")
				$$$WriteLine("		}")
				$$$WriteLine("	}")
				$$$WriteLine("")
			}
			
			$$$WriteLine("	set tValue = """", tBestProb = """", tBestValue = """"")
			$$$WriteLine("	for {")
			$$$WriteLine("		set tValue = $order(tScores(tValue),1,tProb)")
			$$$WriteLine("		quit:tValue=""""")
			if (tDefinition.functionName="classification") {
				$$$WriteLine("		set:i%KeepAllClassProbabilities tAllClassProbs($i(tAllClassProbs)) = $lb(tValue, tProb)")
			}
			$$$WriteLine("		set:(tBestProb="""")||(tBestProb<tProb) tBestProb = tProb, tBestValue = tValue")
			$$$WriteLine("	}")
			$$$WriteLine("	// derive confidence value")
			$$$WriteLine("	set tConfidence = $s(tBestValue="""":"""", 1:$g(tConfidence(tBestValue)))")
		}
		
		if (tDefinition.missingValuePenalty'="") && (tDefinition.missingValuePenalty'=1) {
			$$$WriteLine("	set tConfidence = tConfidence * ("_tDefinition.missingValuePenalty_" ** tMissingValueCount)")
		}
		$$$WriteLine("")
		
		set tSC = ..%PopulateOutputObject(pDefinition, tExecute.Implementation, "tBestValue")
		quit:$$$ISERR(tSC)
		
		// append tracing info
		$$$WriteLine("")
		$$$WriteLine("	if (tTrace) {")
		$$$WriteLine("		set tSC = ..%PopulateTrace(.pOutput, .tTrace)")
		$$$WriteLine("		quit:$$$ISERR(tSC)")
		$$$WriteLine("	}")
		
		// append tAllClassProbs
		if (tDefinition.functionName="classification") {
			$$$WriteLine("	merge:i%KeepAllClassProbabilities pOutput.%AllClassProbs = tAllClassProbs")
		}
		
		$$$WriteLine("} catch (ex) {")
		$$$WriteLine("	set tSC = ex.AsStatus()")
		$$$WriteLine("}")
		$$$WriteLine("quit tSC")
		
		do pClass.Methods.Insert(tExecute)
		set tExecute=""
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	
	quit tSC
}

ClassMethod %OnGetOutputFeature(pMethod As %Stream.Object, pDefinition As %DeepSee.PMML.Definition.Models.AbstractModel, pOutputField As %DeepSee.PMML.Definition.OutputField, ByRef pFeatureValueVar As %String, Output pSupported As %Boolean) As %Status [ Internal, Private ]
{
	#define WriteLine(%c) do pMethod.WriteLine($c(9,9)_%c)
	set pSupported = 0
	
	if (pOutputField.feature = "probability") {
		set pSupported = 1
		if (pOutputField.value="") {
			$$$WriteLine("set "_pFeatureValueVar_" = $s(tBestValue="""":0, 1:$g(tScores(tBestValue)))")
		} else {
			$$$WriteLine("set "_pFeatureValueVar_" = $g(tScores("_$$$QUOTE(pOutputField.value)_"))")
		}
		
	}
	
	quit $$$OK
}

ClassMethod %WriteNodeBranch(pNode As %DeepSee.PMML.Definition.Models.Trees.TreeNode, pCode As %Stream.TmpCharacter, pMVStrategy As %String, pNTChildStrategy As %String, ByRef pNodeLabels, pIndent As %Integer, pParentsDefaultChild As %String = "") As %Status [ Internal, Private ]
{
#define NODELABEL(%l,%id) set:'$d(pNodeLabels(%id),%l) %l = "node"_$i(pNodeLabels), pNodeLabels(%id) = %l

	set tSC = $$$OK
	try {
		
		set tIndent = ""
		for i=1:1:pIndent+1 {
			set tIndent = tIndent _ $c(9)
		}
		
		do pCode.WriteLine()
		do pCode.WriteLine(tIndent_"// predicate evaluation for node "_pNode.id)
		do pNode.Predicate.%WriteComputeCode("tCheck","pObservation",tIndent,pCode)
		
		if (pMVStrategy="none") {
			
			do pCode.WriteLine(tIndent_"if (tCheck = 1) { // missingValueStrategy = none")
			
		} else {
			
			// first check if the predicate for this node itself evaluates to UNKNOWN
			do pCode.WriteLine(tIndent_"if (tCheck = ""UNKNOWN"") { // missing value strategy: "_pMVStrategy)
			
			if (pMVStrategy="lastPrediction") {
				do pCode.WriteLine(tIndent_"	goto end")
			} elseif (pMVStrategy="nullPrediction") {
				do pCode.WriteLine(tIndent_"	kill tScores")
				do pCode.WriteLine(tIndent_"	goto end")
			} elseif (pMVStrategy="defaultChild") {
				if (pParentsDefaultChild'="") {
					
					$$$NODELABEL(tLabel,pParentsDefaultChild)
					
					// write some trace output before jumping to the default child
					do pNode.Predicate.%GetAsTree(.tTree)
					set tInfo = ##class(%DeepSee.PMML.Utils.TreeBuilder).GetCondition(.tTree)
					set tFields = ##class(%DeepSee.PMML.Utils.TreeBuilder).GetFieldList(.tTree)
					do pCode.WriteLine(tIndent_"	set:tTrace tTrace($i(tTrace),0) = $lb($lb("""_$lts(tFields,""",""")_"""),,,""Tree node "_pNode.id_": "_$replace(tInfo,"""","""""")_""")")
					do pCode.WriteLine(tIndent_"	set:tTrace tTrace($i(tTrace),0) = $lb($lb("""_$lts(tFields,""",""")_"""),,,""Tree node "_pNode.id_": MISSING VALUES - go to node "_pParentsDefaultChild_""")")
					
					do pCode.WriteLine(tIndent_"	set tMissingValueCount = tMissingValueCount + 1")
					do pCode.WriteLine(tIndent_"	goto "_tLabel_" // defaultChild of parent: '"_pParentsDefaultChild_"'")
					
				} else {
					// no default child, so quit
					do pCode.WriteLine(tIndent_"	goto end")
				}
			
			} elseif (pMVStrategy="aggregateNodes") || (pMVStrategy="weightedConfidence") {
				
				// write some trace output before aggregating nodes
				do pNode.Predicate.%GetAsTree(.tTree)
				set tInfo = ##class(%DeepSee.PMML.Utils.TreeBuilder).GetCondition(.tTree)
				set tFields = ##class(%DeepSee.PMML.Utils.TreeBuilder).GetFieldList(.tTree)
				do pCode.WriteLine(tIndent_"	set:tTrace&&'tAggregationMode tTrace($i(tTrace),0) = $lb($lb("""_$lts(tFields,""",""")_"""),,,""Tree node "_pNode.id_": "_$replace(tInfo,"""","""""")_" - aggregating..."")")
				
				do pCode.WriteLine(tIndent_"	set tAggregationMode = 1")
					
				// now just jump into the node's body
				set:pNode.id="" pNode.id = $random(99999)
				$$$NODELABEL(tLabel,pNode.id)
				do pCode.WriteLine(tIndent_"	goto "_tLabel)
				
			} elseif (pMVStrategy="none") { // do nothing and wait for noTrueChildStrategy
			} else {
				set tSC = $$$ERROR($$$NotImplemented)
				quit
			}
			
			do pCode.WriteLine(tIndent_"} elseif (tCheck = 1) { // visit node "_pNode.id)
			
		}
		
		
		// print label, if any
		if (pNode.id'="") {
			do pCode.WriteLine()
			$$$NODELABEL(tLabel,pNode.id)
			do pCode.WriteLine(tLabel_" // label for node '"_pNode.id_"'")
		}
		
		
		// tracing: first transform the node condition into a field list and info
		do pNode.Predicate.%GetAsTree(.tTree)
		if $d(tTree) { // skip True and False conditions
			// derive condition (as string) and field list from tree
			set tInfo = ##class(%DeepSee.PMML.Utils.TreeBuilder).GetCondition(.tTree)
			set tFields = ##class(%DeepSee.PMML.Utils.TreeBuilder).GetFieldList(.tTree)
			
			do pCode.WriteLine(tIndent_"	set:tTrace tTrace($i(tTrace),0) = $lb($lb("""_$lts(tFields,""",""")_"""),,,""Tree node "_pNode.id_": "_$replace(tInfo,"""","""""")_""")")
		}
		
		
		// clear the score array ahead of processing this node
		do pCode.WriteLine(tIndent_"	kill tScores")
		set tHasSubnodes = ''pNode.Subnodes.Count()
		
		// if this is a leaf node or we need to keep track of the last prediction, store
		// the ScoreDistribution/score info in the tScores array
		if 'tHasSubnodes || (pNTChildStrategy="returnLastPrediction") || (pMVStrategy="lastPrediction") {
			
			// aggregate recordCount ScoreDistribution elements
			set tRecordCount = pNode.recordCount
			if 'tRecordCount {
				for i = 1:1:pNode.ScoreDistributions.Count() {
					set tRecordCount = tRecordCount + pNode.ScoreDistributions.GetAt(i).recordCount
				}
			}
			if (pNode.ScoreDistributions.Count()) {
				for i = 1:1:pNode.ScoreDistributions.Count() {
					set tDistribution = pNode.ScoreDistributions.GetAt(i)
					set tProbability = tDistribution.probability
					set:'tProbability tProbability = $s(tRecordCount:tDistribution.recordCount / tRecordCount, 1:0)
					do pCode.WriteLine(tIndent_"	set x = $i(tScores("_$$$QUOTE(tDistribution.value)_"), "_tProbability_")")
					
					do:tDistribution.confidence'="" pCode.WriteLine(tIndent_"	set tConfidence("_$$$QUOTE(tDistribution.value)_") = "_tDistribution.confidence)
				}
			} elseif (pNode.score'="") {
				// otherwise, if there is a single score, store it
				do pCode.WriteLine(tIndent_"	set x = $i(tScores("_$$$QUOTE(pNode.score)_"), 1)")
			} else {
				set tSC = $$$ERROR($$$GeneralError, "Tree node '"_pNode.id_"' has no score or scoredistribution")
				quit
			}
			
		}
		
		// now process any subnodes
		if tHasSubnodes {
			for i = 1:1:pNode.Subnodes.Count() {
				set tSC = ..%WriteNodeBranch(pNode.Subnodes.GetAt(i), pCode, pMVStrategy, pNTChildStrategy, .pNodeLabels, pIndent+1, pNode.defaultChild)
				quit:$$$ISERR(tSC)
			}
			quit:$$$ISERR(tSC)
		}
		
		
		// if in aggregateNodes mode, append score distribution values if this is a leaf node
		if 'tHasSubnodes && ((pMVStrategy="aggregateNodes") || (pMVStrategy="weightedConfidence")) {
			do pCode.WriteLine()
			do pCode.WriteLine(tIndent_"	if tAggregationMode {")
			
			if (pMVStrategy="weightedConfidence") {
				set tRecordCount = pNode.recordCount
				if 'tRecordCount {
					for i = 1:1:pNode.ScoreDistributions.Count() {
						set tRecordCount = tRecordCount + pNode.ScoreDistributions.GetAt(i).recordCount
					}
				}
			}
			
			if (pNode.ScoreDistributions.Count()) {
				for i = 1:1:pNode.ScoreDistributions.Count() {
					set tDistribution = pNode.ScoreDistributions.GetAt(i)
					do pCode.WriteLine(tIndent_"		set x = $i(tAggregatedScores("_$$$QUOTE(tDistribution.value)_"), "_tDistribution.recordCount_"), x = $i(tAggregatedScores, "_tDistribution.recordCount_")")
					do:pMVStrategy="weightedConfidence" pCode.WriteLine(tIndent_"		set x = $i(tAggregatedConf("_$$$QUOTE(tDistribution.value)_"), "_$s(tDistribution.confidence="":tDistribution.probability, 1:tDistribution.confidence)_" * "_$s(tRecordCount:tDistribution.recordCount_" / "_tRecordCount, 1:0)_")")
				}
			} elseif (pNode.score'="") {
				do pCode.WriteLine(tIndent_"		set x = $i(tAggregatedScores("_$$$QUOTE(pNode.score)_"), "_tRecordCount_"), x = $i(tAggregatedScores, "_tRecordCount_")")
			}
			
			do pCode.WriteLine(tIndent_"	}")
		}
		
		// always go to the end at this point. noTrueChildStrategy has already prepared tScores
		if (pMVStrategy="aggregateNodes") || (pMVStrategy="weightedConfidence") {
			do pCode.WriteLine(tIndent_"	goto:'tAggregationMode end")
		} else {
			do pCode.WriteLine(tIndent_"	goto end")
		}
		do pCode.WriteLine(tIndent_"}")
		do pCode.WriteLine()
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
