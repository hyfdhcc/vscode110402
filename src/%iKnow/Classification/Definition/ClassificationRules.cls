Class %iKnow.Classification.Definition.ClassificationRules Extends node [ System = 3 ]
{

Property ruleSelectionMethod As %String(VALUELIST = ",firstHit,allHits", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "allHits" ];

Property Rules As list Of Rule(XMLNAME = "Rule", XMLPROJECTION = "ELEMENT");

Method %Validate(ByRef pInfo) As %Status
{
	set tSC = $$$OK
	try {
		
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
