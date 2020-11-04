Class %DeepSee.PMML.Definition.Targets Extends extendableNode [ System = 3 ]
{

Property Targets As list Of Target(XMLNAME = "Target", XMLPROJECTION = "ELEMENT");

Method %ValidateNames(ByRef pDictionary) As %Status
{
	set tSC = $$$OK
	try {
		
		for i = 1:1:..Targets.Count() {
			set tTarget = ..Targets.GetAt(i) 
		
			if '$d(pDictionary("fields", tTarget.field), tFieldInfo) {
				set tSC = $$$ERROR($$$GeneralError, "Unknown field: '"_tTarget.field_"'")
				quit
			}
			
			set pDictionary("targets", tTarget.field) = "Target"
			set pDictionary("targets", tTarget.field, "optype") = tTarget.optype
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
