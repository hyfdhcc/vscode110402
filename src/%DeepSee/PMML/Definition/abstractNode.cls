Include %PMML

Class %DeepSee.PMML.Definition.abstractNode Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, Inheritance = right, System = 3 ]
{

/// Ensures <method>%ValidateObject</method> is called for this node and all its nested
/// %PMML subnodes.
/// This works depth-first, so all nested elements are validated before the nesting element
/// itself gets validated. Therefore, <method>%OnValidateObject</method> methods may assume
/// nested elements are fully validated.
Method %ValidatePMML(pForce As %Boolean = 0) As %Status [ Final ]
{
	set tSC = $$$OK
	try {
		
		set tClassDef = ##class(%Dictionary.CompiledClass).%OpenId($classname())
		if (tClassDef = "") {
			set tSC = $$$ERROR($$$GeneralError, "Class not found: "_$classname())
			quit
		}
		
		for i = 1:1:tClassDef.Properties.Count() {
			#dim tProp As %Dictionary.CompiledProperty = tClassDef.Properties.GetAt(i)
			continue:'$$IsDerivedFrom^%occLibrary(tProp.Type,"%DeepSee.PMML.Definition.abstractNode")
			
			if tProp.Collection = "list" {
				
				#dim tPropCollection As %ListOfObjects = $property($this, tProp.Name)
				for j = 1:1:tPropCollection.Count() {
					set tPropObj = tPropCollection.GetAt(j)
					continue:tPropObj=""
					
					set tSC = tPropObj.%ValidatePMML(pForce)
					quit:$$$ISERR(tSC)
				}
				quit:$$$ISERR(tSC)
				
			} else {
				
				set tPropObj = $property($this, tProp.Name)
				continue:tPropObj=""
				
				set tSC = tPropObj.%ValidatePMML(pForce)
				quit:$$$ISERR(tSC)
				
			}
		}
		quit:$$$ISERR(tSC)
		
		set tSC = ..%ValidateObject(pForce)
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Adds node-specific validation checks
Method %OnValidateObject(force As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
