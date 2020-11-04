/// <p>This classification method relies on the Naive Bayes theorem to calculate the probability
/// a document belongs to a category based on probability scores for the individual terms.</p>
/// <p>Given this probability-based approach, the document vector local weights and normalization
/// settings are fixed at "binary" and "none" respectively.</p>
Class %iKnow.Classification.Methods.naiveBayes Extends Base [ System = 4 ]
{

Method %BuildClassificationMethod(ByRef pClassifier As %iKnow.Classification.Definition.Classifier, pVerbose As %Boolean = 1, pIncludeBuilderParams As %Boolean = 1) As %Status
{
	set tSC = $$$OK
	try {
		set tSC = ##super(.pClassifier, pVerbose, pIncludeBuilderParams)
		quit:$$$ISERR(tSC)
		
		set tTotalRecordCount = ..Builder.%GetRecordCount(.tSC)
		quit:$$$ISERR(tSC)
		
		set tSC = ..Builder.%GetCategoryInfo(.tCatInfo)
		quit:$$$ISERR(tSC)
		
		set tSC = ..Builder.%GetTermInfo(.tTermInfo, "spread")
		quit:$$$ISERR(tSC)
		
		set tCatWeights = ""
		set tMatrix = ##class(%DeepSee.PMML.Definition.Util.Matrix).%New()
		for i = 1:1:tCatInfo {
			set tCatName = $li(tCatInfo(i),1)
			set tCatRecordCount = $li(tCatInfo(i),2)
			set tNotInCatRecordCount = tTotalRecordCount - tCatRecordCount
			
			set tCatWeights = tCatWeights _ " " _ (tCatRecordCount / tTotalRecordCount)
			
			set tTermWeights = ""
			for j = 1:1:..Builder.Terms.Count() {
				if '$d(tTermInfo(j)) {
					set tTermWeights = tTermWeights _ " 0"
					continue
				}
				set tCatSpread = $g(tTermInfo(j,"spread",i))
				
				if 'tCatSpread {
					set tEntProb = 0
				} else {
					set tEntProb = (tCatSpread/tCatRecordCount) / ((tCatSpread/tCatRecordCount) + ((tTermInfo(j,"spread")-tCatSpread)/tNotInCatRecordCount))
				}
				
				set tTermWeights = tTermWeights _ " " _ tEntProb
			}
			
			set tCatTermArray = ##class(%DeepSee.PMML.Definition.Util.Array).%New()
			set tCatTermArray.Values = $e(tTermWeights,2,*)
			do tMatrix.Arrays.InsertAt(tCatTermArray, i)
			
		}
		quit:$$$ISERR(tSC)
		
		set pClassifier.ClassificationMethod.CategoryTermWeights = tMatrix
			
		set tCatArray = ##class(%DeepSee.PMML.Definition.Util.Array).%New()
		set tCatArray.Values = $e(tCatWeights,2,*)
		set pClassifier.ClassificationMethod.CategoryWeights = tCatArray
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
