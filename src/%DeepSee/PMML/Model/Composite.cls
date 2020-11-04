Class %DeepSee.PMML.Model.Composite Extends AbstractModel [ Abstract, System = 4 ]
{

ClassMethod %CreateModelClass(pClass As %Dictionary.ClassDefinition, pDefinition As %DeepSee.PMML.Definition.Models.AbstractModel) As %Status [ Internal ]
{
	#dim tDefinition As %DeepSee.PMML.Definition.Models.MiningModel = pDefinition
	#dim tOutputField As %DeepSee.PMML.Definition.OutputField
	#dim tMiningField As %DeepSee.PMML.Definition.MiningField

	set tSC = $$$OK
	try {
		quit:'$isobject(tDefinition.Segmentation)
		set tMethod = tDefinition.Segmentation.multipleModelMethod
		set tBaseModelName = %PMML("Classes",$$$UPPER(pClass.Name))_"."
		
		// for model chains, we'll need a handle on the ModelInput
		if (tMethod = "modelChain") {
			set tModelInputClassName = %PMML("Classes",$$$UPPER(pClass.Name),"input")
			set tModelInputClass = ##class(%Dictionary.ClassDefinition).%OpenId(tModelInputClassName)
		}
		
		// generate %ExecuteModelInternal
		set tExecute = ##class(%Dictionary.MethodDefinition).%New()
		set tExecute.Name = "%ExecuteModelInternal"
		set tExecute.FormalSpec = "pObservation:%DeepSee.PMML.ModelInput,*pOutput:%DeepSee.PMML.ModelOutput"
		set tExecute.ReturnType = "%Status"
		set tExecute.Private = 1
		
		#define WriteLine(%c) do tExecute.Implementation.WriteLine($c(9)_%c)
		$$$WriteLine("set tSC = $$$OK, pOutput=""""")
		$$$WriteLine("try {")
		$$$WriteLine("	set tLastModelIndex = 0")
		
		kill tOutputFields, tOutputFieldNames, tSegmentOutputs
		if $isobject(tDefinition.Output) {
			set tPredictedField = ..%GetPredictedFieldFromDef(tDefinition)
			for j = 1:1:tDefinition.Output.OutputFields.Count() {
				set tOutputField = tDefinition.Output.OutputFields.GetAt(j)
				if (tOutputField.segmentId'="") {
					if (tMethod="selectFirst") {
						set tSC = $$$ERROR($$$GeneralError, "OutputField segmentId attribute not supported when multipleModelMethod=""selectFirst""")
						quit
					}
					set tSegmentOutputs($i(tSegmentOutputs)) = tOutputField
					continue
				}
				set tPredicted = $s(tOutputField.targetField="":tPredictedField, 1:tOutputField.targetField)
				set tValue = $s(tOutputField.value="":$c(0), 1:tOutputField.value)
				set tOutputFields(0, tPredicted, tOutputField.feature, tValue) = tOutputField
			}
		} else {
			do ..%GetPredictedFieldsFromDef(tDefinition, .tAllFields)
			for i = 1:1:$g(tAllFields) {
				set tOutputFields(0, tAllFields(i), "predictedValue", $c(0)) = ""
			}
		}
		quit:$$$ISERR(tSC)
		
		#dim tSegment As %DeepSee.PMML.Definition.Segment
		for i = 1:1:tDefinition.Segmentation.Segments.Count() {
			set tSegment = tDefinition.Segmentation.Segments.GetAt(i)
			set tSegmentId = $s(tSegment.id="":i, 1:$$$QUOTE(tSegment.id))
			set tSegmentIds(i) = tSegmentId, tSegmentIdsI(tSegmentId) = i
			set tNestedModel = tSegment.Model
			
			// derive meaningful model name
			if (tSegment.id'="") {
				set tModelName = tBaseModelName _ $tr($s($isvalidnum(tSegment.id):"S"_tSegment.id, 1:tSegment.id), ".","_")
			} elseif (tNestedModel.modelName'="") {
				set tModelName = tBaseModelName _ tNestedModel.modelName
			} else {
				set tModelName = tBaseModelName_"S"_i
			}
			
			// list output fields for this model
			set tPredictedFieldProb = ""
			if $isobject(tSegment.Model.Output) {
				set tPredictedField = $classmethod(tSegment.Model.%GetModelClass(), "%GetPredictedFieldFromDef", tSegment.Model)
				set tPredictedFields(i) = tPredictedField
				for j = 1:1:tSegment.Model.Output.OutputFields.Count() {
					set tOutputField = tSegment.Model.Output.OutputFields.GetAt(j)
					if (tOutputField.segmentId'="") {
						set tSC = $$$ERROR($$$GeneralError, "OutputField segmentId attribute not supported for nested models")
						quit
					}
					set tPredicted = $s(tOutputField.targetField="":tPredictedField, 1:tOutputField.targetField)
					set tValue = $s(tOutputField.value="":$c(0), 1:tOutputField.value)
					set tOutputFields(i, tPredicted, tOutputField.feature, tValue) = tOutputField
					set tOutputFieldNames(i, tOutputField.name) = tOutputField
					set:(tOutputField.feature="probability")&&(tOutputField.value="") tPredictedFieldProb = tOutputField.name
				}
			} else {
				do $classmethod(tSegment.Model.%GetModelClass(), "%GetPredictedFieldsFromDef", tSegment.Model, .tAllFields)
				for j = 1:1:$g(tAllFields) {
					set tOutputFields(i, tAllFields(j), "predictedValue", $c(0)) = ""
					set tOutputFieldNames(i, tAllFields(j)) = ""
				}
				set (tPredictedField, tPredictedFields(i)) = $g(tAllFields(1))
			}
			quit:$$$ISERR(tSC)
			
			
			// if this is a model chain, ensure ModeInput class can be generated for
			// fields not in the DataDictionary
			if (tMethod="modelChain") && (i>1) {
				for j = 1:1:tSegment.Model.MiningSchema.MiningFields.Count() {
					set tInputField = tSegment.Model.MiningSchema.MiningFields.GetAt(j)
					continue:tInputField.usageType'="active"
					set tOutputField = "", tOutputFieldIndex = 0
					for k = i-1:-1:1 {
						if $d(tOutputFieldNames(k, tInputField.name), tOutputField) {
							set tOutputFieldIndex = k
							quit
						}
					}
					continue:'tOutputFieldIndex
					
					// we'll need to store some metadata so the ModelInput class can be generated
					set tPropName = $$$PROPERTYNAME(tInputField.name)
					continue:$d(%PMML("Fields", tPropName))
					kill tFieldInfo
					set tFieldInfo("datatype") = tOutputField.dataType
					set tFieldInfo("type") = ##class(%DeepSee.PMML.Datatype.DataType).GetClassname(tOutputField.dataType)
					set tFieldInfo("optype") = tOutputField.optype
					merge %PMML("Fields", tPropName) = tFieldInfo
				}
			}
			
			set tSC = ##class(%DeepSee.PMML.Generator).%CreateModelClasses(tNestedModel, .tModelName, .tModelClass, $e(tBaseModelName,1,*-1))
			quit:$$$ISERR(tSC)
			
			// write segment predicate
			$$$WriteLine("")
			if (tSegment.Predicate.%IsA("%DeepSee.PMML.Definition.Util.CompoundPredicate")) {
				set tSC = tSegment.Predicate.%WriteComputeCode("tPredicateValue", "pObservation", $c(9), tExecute.Implementation)
				quit:$$$ISERR(tSC)
				set tCondition = "tPredicateValue"
			} else {
				set tCondition = tSegment.Predicate.%GetComputeCode("pObservation")
			}
			$$$WriteLine("	if ("_tCondition_") {")
			$$$WriteLine("		// Executing model for segment "_tSegmentId)
			$$$WriteLine("		set tLastModelIndex = "_i)
			$$$WriteLine("		set tModel = ##class("_tModelClass_").%New()")
			
			if (tDefinition.functionName="classification") && '("majorityVote,weightedMajorityVote,selectFirst,modelChain"[tMethod) {
				$$$WriteLine("		set tModel.KeepAllClassProbabilities = 1")
			}
			
			$$$WriteLine("		set tSC = tModel.%ExecuteModel(pObservation, .tOutput)")
			$$$WriteLine("		quit:$$$ISERR(tSC)")
			$$$WriteLine("")
			
			
			if (tMethod="selectFirst") {
				
				// translate last tOutput to pOutput
				$$$WriteLine("		if $isobject($g(tOutput)) {")
				$$$WriteLine("			set pOutput = $classmethod(..#OUTPUTCLASS, ""%New"")")
				set tPredictedField = ""
				for {
					set tPredictedField = $order(tOutputFields(0, tPredictedField))
					quit:tPredictedField=""
					set tFeature = ""
					for {
						set tFeature = $order(tOutputFields(0, tPredictedField, tFeature))
						quit:tFeature=""
						set tValue = ""
						for {
							set tValue = $order(tOutputFields(0, tPredictedField, tFeature, tValue), 1, tOutputField)
							quit:tValue=""
							
							set tField1 = $s($isobject(tOutputField):tOutputField.name, 1:tPredictedField)
							if $d(tOutputFields(i, tPredictedField, tFeature, tValue), tOutputField2) {
								set tField2 = $s($isobject(tOutputField2):tOutputField2.name, 1:tPredictedField)
								$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tField1)_" = tOutput."_$$$PROPERTYNAME(tField2))
							} elseif '$isobject(tOutputField) {
								// these are implied output fields, which we can ignore if no data is present
							} else {
								set tVariableName = $s('$d(tOutputFields(i, tPredictedField, "predictedValue", $c(0)),f):"", 1:"tOutput."_$$$PROPERTYNAME($s(f="":tPredictedField, 1:f.name)))
								if (tOutputField.feature = "transformedValue") {
									set pSupported = 1
									set tExprCode = tOutputField.Expression.%GetComputeCode(.tInline, tVariableName)
									if (tInline) {
										$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tOutputField.name)_" = "_tExprCode)
									} else {
										$$$WriteLine("			// compute code for transformedValue expression")
										$$$WriteLine("			set tValue = "_tVariableName_", tStatus = $s(tValue="""":""missing"", 1:""valid"")")
										$$$WriteLine("			"_tExprCode)
										set tExprCode = "tValue"
									}
									$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tOutputField.name)_" = "_tExprCode)
								} elseif (tOutputField.feature = "entityId") {
									$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tField1)_" = "_tSegmentId)
								} else {
									set tSC = $$$ERROR($$$GeneralError, "No mapping found for output field '"_tOutputField.name_"' from nested models with method='selectFirst'")
									quit
								}
							}
						}
						quit:$$$ISERR(tSC)
					}
					quit:$$$ISERR(tSC)
				}
				quit:$$$ISERR(tSC)
				$$$WriteLine("		}")
				$$$WriteLine("		quit  // multipleModelMethod=""selectFirst""")
				
				
			} elseif (tMethod="modelChain") {
				
				$$$WriteLine("		if $isobject($g(tOutput)) {")
				
				// append output to pObservation
				if $isobject(tSegment.Model.Output) {
					for j = 1:1:tSegment.Model.Output.OutputFields.Count() {
						set tOutputField = tSegment.Model.Output.OutputFields.GetAt(j)
						set tPropName = $$$PROPERTYNAME(tOutputField.name)
						$$$WriteLine("			set pObservation."_tPropName_" = tOutput."_tPropName)
						
						// also append a dummy property to the ModelInput object if it's unknown
						continue:$d(%PMML("Classes",pClass.Name,"input",tPropName))
						set tDataProp = ##class(%Dictionary.PropertyDefinition).%New()
						set tDataProp.Name = tPropName
						set tDataProp.Type = ##class(%DeepSee.PMML.Datatype.DataType).GetClassname(tOutputField.dataType)
						set tDataProp.Internal = 1
						do tModelInputClass.Properties.Insert(tDataProp)
						set tDataPropSetter = ##class(%Dictionary.MethodDefinition).%New()
						set tDataPropSetter.Name = tPropName_"Set"
						set tDataPropSetter.Internal = 1
						set tDataPropSetter.ServerOnly = 1
						set tDataPropSetter.FormalSpec = "pValue:"_tDataProp.Type
						set tDataPropSetter.ReturnType = "%Status"
						do tDataPropSetter.Implementation.WriteLine("	set i%"_tPropName_" = pValue, tStatus = ""valid""")
						do tDataPropSetter.Implementation.WriteLine("	quit $$$OK")
						do tModelInputClass.Methods.Insert(tDataPropSetter)
						set %PMML("Classes",pClass.Name,"input",tPropName) = ""
					}
				}
					
				$$$WriteLine("			set tOutputs("_tSegmentId_") = tOutput")
				$$$WriteLine("		}")
				
			} else {
				
				$$$WriteLine("		if $isobject($g(tOutput)) {")
				$$$WriteLine("			set tOutputs("_tSegmentId_") = tOutput")
				
				if (tMethod="majorityVote") {
					$$$WriteLine("			set x = $i(tVotes(tOutput."_$$$PROPERTYNAME(tPredictedField)_"))")
					$$$WriteLine("			set tVotes(tOutput."_$$$PROPERTYNAME(tPredictedField)_", "_tSegmentId_") = """"")
				} elseif (tMethod="weightedMajorityVote") {
					$$$WriteLine("			set x = $i(tVotes(tOutput."_$$$PROPERTYNAME(tPredictedField)_"),"_tSegment.weight_")")
					$$$WriteLine("			set tVotes(tOutput."_$$$PROPERTYNAME(tPredictedField)_", "_tSegmentId_") = """"")
					
				} elseif (tDefinition.functionName="classification") {
					
					if (tMethod="max") {
						if (tPredictedFieldProb'="") {
							$$$WriteLine("			set tProb(tOutput."_$$$PROPERTYNAME(tPredictedFieldProb)_", "_tSegmentId_") = tOutput."_$$$PROPERTYNAME(tPredictedField))
						} else {
							$$$WriteLine("			set tSC = tOutput.%GetAllClassProbabilities(.tAllProbs)")
							$$$WriteLine("			quit:$$$ISERR(tSC)")
							$$$WriteLine("			for i = 1:1:$g(tAllProbs) {")
							$$$WriteLine("				continue:$li(tAllProbs(i),1)'=tOutput."_$$$PROPERTYNAME(tPredictedField))
							$$$WriteLine("				set tProb($li(tAllProbs(i),2), "_tSegmentId_") = tOutput."_$$$PROPERTYNAME(tPredictedField))
							$$$WriteLine("			}")
						}
					} else {
						// go through probs for each category in Output
						$$$WriteLine("			set tSC = tOutput.%GetAllClassProbabilities(.tAllProbs)")
						$$$WriteLine("			quit:$$$ISERR(tSC)")
						$$$WriteLine("			for i = 1:1:$g(tAllProbs) {")
						$$$WriteLine("				set tProb($li(tAllProbs(i),1), "_tSegmentId_") = "_$s(tMethod="weightedAverage":"$lb($li(tAllProbs(i),2),"_tSegment.weight_")", 1:"$li(tAllProbs(i),2)"))
						$$$WriteLine("			}")
					}
					
				} else {
					
					// regression models
					if (tMethod="max") {
						$$$WriteLine("			set tValues(tOutput."_$$$PROPERTYNAME(tPredictedField)_", "_tSegmentId_")=""""")
					} elseif (tMethod="median") {
						$$$WriteLine("			set x = $i(tValues(tOutput."_$$$PROPERTYNAME(tPredictedField)_")), x = $i(tCount)")
					} elseif (tMethod="weightedAverage") {
						$$$WriteLine("			set x = $i(tValue, tOutput."_$$$PROPERTYNAME(tPredictedField)_"*"_tSegment.weight_"), x = $i(tCount,"_tSegment.weight_")")
					} else {
						$$$WriteLine("			set x = $i(tValue, tOutput."_$$$PROPERTYNAME(tPredictedField)_"), x = $i(tCount)")
					}
				}
				$$$WriteLine("		}")
			}
			
			$$$WriteLine("	}")
		}
		quit:$$$ISERR(tSC)
		
		$$$WriteLine("")
		
		// now process tOutputs array
		if (tMethod="selectFirst") {
			// has been taken care of already
		} elseif (tMethod="modelChain") {
			
			// save tModelInputClass as some intermediate output may have been appended
			set tSC = tModelInputClass.%Save()
			quit:$$$ISERR(tSC)
			
			// translate last tOutput to pOutput
			$$$WriteLine("	if $isobject($g(tOutput)) {")
			$$$WriteLine("		set pOutput = $classmethod(..#OUTPUTCLASS, ""%New"")")
			
			// to be safe, we need mappings from all previous models until we arrive at one with a TRUE condition
			set tLastModelIndex = ""
			for {
				set tLastModelIndex = $order(tOutputFields(tLastModelIndex), -1)
				quit:'tLastModelIndex
				
				$$$WriteLine("		if (tLastModelIndex = "_tLastModelIndex_") {")
				set tPredictedField = ""
				for {
					set tPredictedField = $order(tOutputFields(0, tPredictedField))
					quit:tPredictedField=""
					set tFeature = ""
					for {
						set tFeature = $order(tOutputFields(0, tPredictedField, tFeature))
						quit:tFeature=""
						set tValue = ""
						for {
							set tValue = $order(tOutputFields(0, tPredictedField, tFeature, tValue), 1, tOutputField)
							quit:tValue=""
							
							set tField1 = $s($isobject(tOutputField):tOutputField.name, 1:tPredictedField)
							
							if $d(tOutputFields(tLastModelIndex, tPredictedField, tFeature, tValue), tOutputField2) {
								set tField2 = $s($isobject(tOutputField2):tOutputField2.name, 1:tPredictedField)
								$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tField1)_" = tOutputs("_tLastModelIndex_")."_$$$PROPERTYNAME(tField2))
							} elseif '$isobject(tOutputField) {
								// these are implied output fields, which we can ignore if no data is present
							} else {
								set tVariableName = $s('$d(tOutputFields(i, tPredictedField, "predictedValue", $c(0)),f):"", 1:"tOutputs("_tLastModelIndex_")."_$$$PROPERTYNAME($s(f="":tPredictedField, 1:f.name)))
								if (tOutputField.feature = "transformedValue") {
									set pSupported = 1
									set tExprCode = tOutputField.Expression.%GetComputeCode(.tInline, tVariableName)
									if (tInline) {
										$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tOutputField.name)_" = "_tExprCode)
									} else {
										$$$WriteLine("			// compute code for transformedValue expression")
										$$$WriteLine("			set tValue = "_tVariableName_", tStatus = $s(tValue="""":""missing"", 1:""valid"")")
										$$$WriteLine("			"_tExprCode)
										set tExprCode = "tValue"
									}
									$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tOutputField.name)_" = "_tExprCode)
								} elseif (tOutputField.feature="entityId") {
									$$$WriteLine("			set pOutput."_$$$PROPERTYNAME(tOutputField.name)_" = "_tSegmentIds(tLastModelIndex))
								} else {
									// we have to ignore this as it can be a model that wasn't intended to be the last one
								}
							}
						}
						quit:$$$ISERR(tSC)
					}
					quit:$$$ISERR(tSC)
				}
				quit:$$$ISERR(tSC)
				
				$$$WriteLine("			quit")
				$$$WriteLine("		}")
				
				// we can exit this loop if the corresponding model was certainly executed
				quit:tDefinition.Segmentation.Segments.GetAt(tLastModelIndex).Predicate.%IsA("%DeepSee.PMML.Definition.Util.True")
			}
			$$$WriteLine("	}")
			
		} elseif (tMethod="majorityVote") || (tMethod="weightedMajorityVote") {
			
			$$$WriteLine("	set tMaxVotes = 0, tBestValue="""", tValue = """"")
			$$$WriteLine("	for {")
			$$$WriteLine("		set tValue = $order(tVotes(tValue),1,tVotes)")
			$$$WriteLine("		quit:tValue=""""")
			$$$WriteLine("		set:tVotes>tMaxVotes tBestValue = tValue, tMaxVotes = tVotes")
			$$$WriteLine("	}")
			
			set tSC = ..%PopulateOutputObject(tDefinition, tExecute.Implementation, "tBestValue")
			quit:$$$ISERR(tSC)
			
		} elseif (tDefinition.functionName="classification") {
			
			if (tMethod="max") {
				$$$WriteLine("	set tBestProb = $order(tProb(""""),-1), tBestModel = $order(tProb(tBestProb,""""),1,tBestValue)")
			} elseif (tMethod="median") {
				$$$WriteLine("	set tValue=""""")
				$$$WriteLine("	for {") 
				$$$WriteLine("		set tValue = $order(tProb(tValue))")
				$$$WriteLine("		quit:tValue=""""")
				$$$WriteLine("		kill v")
				$$$WriteLine("		s i = """", c=0 f { s i = $o(tProb(tValue, i),1,p)  q:i=""""  s x = $i(v(p)), c=c+1 }")
				$$$WriteLine("		set t=0, h=c\2, e=c#2, p=""""")
				$$$WriteLine("		for {")
				$$$WriteLine("			set p = $order(v(p),1,n)")
				$$$WriteLine("			quit:p=""""")
				$$$WriteLine("			continue:$i(t,n)>h")
				$$$WriteLine("			if 'e || (t>h) { set tMedian = p quit }")
				$$$WriteLine("			set tMedian = (p + $order(v(p)))/2")
				$$$WriteLine("			quit")
				$$$WriteLine("		}")
				$$$WriteLine("		set tMedians(tMedian,tValue)=""""")
				$$$WriteLine("	}")
				$$$WriteLine("	set tBestProb = $order(tMedians(""""),-1), tBestValue = $order(tMedians(tBestProb,""""))")
			} else {
				$$$WriteLine("	set tValue=""""")
				$$$WriteLine("	for {") 
				$$$WriteLine("		set tValue = $order(tProb(tValue))")
				$$$WriteLine("		quit:tValue=""""")
				$$$WriteLine("		set i = """", c=0, sum=0")
				$$$WriteLine("		for { s i = $o(tProb(tValue, i),1,p)  q:i=""""")
				if (tMethod="weightedAverage") {
					$$$WriteLine("			set x = $i(sum,$li(p,1)*$li(p,2)), c=c+$li(p,2)")
				} else {
					$$$WriteLine("			set x = $i(sum,p), c=c+1")
				}
				$$$WriteLine("		}")
				$$$WriteLine("		set:c tAvgProbs(sum/c,tValue)=""""")
				$$$WriteLine("	}")
				$$$WriteLine("	set tBestProb = $order(tAvgProbs(""""),-1), tBestValue = $s(tBestProb'="""":$order(tAvgProbs(tBestProb,"""")), 1:"""")")
			}
			
			set tSC = ..%PopulateOutputObject(tDefinition, tExecute.Implementation, "tBestValue")
			quit:$$$ISERR(tSC)
			
		} else { // regression
		
			if (tMethod="max") {
				$$$WriteLine("	set tBestValue = $order(tValues(""""))")
			} elseif (tMethod="median") {
				$$$WriteLine("	set t = 0, h = tCount\2, e = tCount#2, tValue=""""")
				$$$WriteLine("	for {")
				$$$WriteLine("		set tValue = $order(tValues(tValue),1,n)")
				$$$WriteLine("		quit:tValue=""""")
				$$$WriteLine("		continue:$i(t,n)<h")
				$$$WriteLine("		if 'e || (t>h) { set tBestValue = tValue quit }")
				$$$WriteLine("		set tBestValue = (tValue + $o(tValues(tValue)))/2")
				$$$WriteLine("		quit")
				$$$WriteLine("	}")
			} elseif (tMethod="sum") {
				$$$WriteLine("	set tBestValue = tValue")
			} else {
				$$$WriteLine("	set tBestValue = $s(tCount:tValue / tCount, 1:"""")")
			}
			
			set tSC = ..%PopulateOutputObject(tDefinition, tExecute.Implementation, "tBestValue")
			quit:$$$ISERR(tSC)
		}
		
		// now process additional segment outputs
		for i = 1:1:$g(tSegmentOutputs) {
			set tOutputField = tSegmentOutputs(i)
			set tModelIndex = tSegmentIdsI(tOutputField.segmentId)
			set tPredicted = $s(tOutputField.targetField="":tPredictedField(tModelIndex) , 1:tOutputField.targetField)
			set tValue = $s(tOutputField.value="":$c(0), 1:tOutputField.value)
			if '$d(tOutputFields(tModelIndex, tPredicted, tOutputField.feature, tValue), tOutputField2) {
				set tSC = $$$ERROR($$$GeneralError, "Could not find output field in nested model for '"_tOutputField.name_"'")
				quit
			}
			$$$WriteLine("	set pOutput."_$$$PROPERTYNAME(tOutputField.name)_" = tOutputs("_$$$QUOTE(tOutputField.segmentId)_")."_$$$PROPERTYNAME(tOutputField2.name))
		}
		
		$$$WriteLine("} catch (ex) {")
		$$$WriteLine("	set tSC = ex.AsStatus()")
		$$$WriteLine("}")
		$$$WriteLine("quit tSC")
		do pClass.Methods.Insert(tExecute)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod %OnGetOutputFeature(pMethod As %Stream.Object, pDefinition As %DeepSee.PMML.Definition.Models.AbstractModel, pOutputField As %DeepSee.PMML.Definition.OutputField, ByRef pFeatureValueVar As %String, Output pSupported As %Boolean) As %Status [ Internal, Private ]
{
	set pSupported = 0
	set tMethod = pDefinition.Segmentation.multipleModelMethod
	if (pOutputField.feature = "entityId") {
		if (tMethod="majorityVote") || (tMethod="weightedMajorityVote") {
			set pFeatureValueVar = "$order(tVotes(tBestValue, """"))", pSupported=1
		} elseif (pDefinition.functionName="classification") && (tMethod="max") {
			set pFeatureValueVar = "tBestModel", pSupported=1
		} elseif (pDefinition.functionName="regression") && (tMethod="max") {
			set pFeatureValueVar = "$order(tValues(tBestValue, """"))", pSupported=1
		}
	}
	quit $$$OK
}

}
