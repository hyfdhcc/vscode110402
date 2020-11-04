Class %DeepSee.PMML.Definition.Models.RuleSet.Rule Extends %DeepSee.PMML.Definition.extendableNode [ Abstract, System = 3 ]
{

Property Predicate As %DeepSee.PMML.Definition.Util.Predicate(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

Method %ValidateNames(ByRef pDictionary) As %Status [ Final ]
{
	set tSC = $$$OK
	try {
		
		set tSC = ..Predicate.%ValidateNames(.pDictionary)
		quit:$$$ISERR(tSC)
		
		set tSC = ..%OnValidateNames(.pDictionary)
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method %OnValidateNames(ByRef pDictionary) As %Status [ Private ]
{
	quit $$$OK
}

}
