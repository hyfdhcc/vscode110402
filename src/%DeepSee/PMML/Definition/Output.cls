Class %DeepSee.PMML.Definition.Output Extends extendableNode [ System = 3 ]
{

Property OutputFields As list Of OutputField(XMLNAME = "OutputField", XMLPROJECTION = "ELEMENT");

Method %ValidateNames(ByRef pDictionary) As %Status [ Final ]
{
	set tSC = $$$OK
	try {
		
		for i = 1:1:..OutputFields.Count() {
			set tField = ..OutputFields.GetAt(i)
			
			if $isobject(tField.Expression) {
				set tSC = tField.Expression.%ValidateNames(.pDictionary)
				quit:$$$ISERR(tSC)
			}
			
			if (tField.targetField'="") {
				if '$d(pDictionary("targets", tField.targetField)) &&
					 ($g(pDictionary("fields", tField.targetField, "usageType"))'="predicted") {
					set tSC = $$$ERROR($$$GeneralError, "Unkown output field: '"_tField.targetField_"'")
					quit
				}
			}
		}
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
