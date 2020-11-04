/// Elements are defined in the subclasses, to ensure the right element sequence
Class %DeepSee.PMML.Definition.Models.AbstractModel Extends %DeepSee.PMML.Definition.extendableNode [ Abstract, System = 3 ]
{

Property modelName As %DeepSee.PMML.Datatype.String(MAXLEN = 2000, XMLPROJECTION = "ATTRIBUTE", XSDTYPE = "xs:string");

Property functionName As %DeepSee.PMML.Datatype.MiningFunction(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property algorithmName As %DeepSee.PMML.Datatype.String(MAXLEN = 2000, XMLPROJECTION = "ATTRIBUTE", XSDTYPE = "xs:string");

Property isScorable As %DeepSee.PMML.Datatype.Boolean(XMLPROJECTION = "ATTRIBUTE");

Method %ValidateNames(ByRef pGlobalDictionary) As %Status [ Final ]
{
	set tSC = $$$OK
	try {
		
		set tSC = ..MiningSchema.%GetDictionary(.pGlobalDictionary, .tLocalDictionary)
		quit:$$$ISERR(tSC)
		
		if $isobject(..LocalTransformations) {
			set tSC = ..LocalTransformations.%ValidateNames(.tLocalDictionary)
			quit:$$$ISERR(tSC)
		}
		
		if $isobject(..Targets) {
			set tSC = ..Targets.%ValidateNames(.tLocalDictionary)
			quit:$$$ISERR(tSC)
		}
		
		if $isobject(..Output) {
			set tSC = ..Output.%ValidateNames(.tLocalDictionary)
			quit:$$$ISERR(tSC)
		}
		
		// TODO: ModelStats
		// TODO: ModelExplanation
		// TODO: ModelVerification
		
		set tSC = ..%OnValidateNames(.tLocalDictionary)
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method %OnValidateNames(ByRef pDictionary) As %Status
{
	set tSC = $$$OK
	try {
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod %GetModelClass() As %String [ CodeMode = objectgenerator, Internal ]
{
	set tClassName = %compiledclass.Name
	do %code.WriteLine("	quit "_$$$QUOTE("%DeepSee.PMML.Model."_$e($p(tClassName,".",*),1,*-5)))
}

Method %IsOutputFeatureSupported(pFeature As %String, pValue As %String = "", Output pSC As %Status) As %Boolean [ Internal ]
{
	set pSC = $$$OK
	set tOutputField = ##class(%DeepSee.PMML.Definition.OutputField).%New()
	set tOutputField.name = "dummy", tOutputField.feature = pFeature, tOutputField.value=pValue
	quit $classmethod(..%GetModelClass(), "%IsOutputFieldSupported", $this, tOutputField, .pSC)
}

}
