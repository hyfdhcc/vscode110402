Class %iKnow.Classification.Definition.Rule Extends node [ System = 3 ]
{

Property category As %String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property score As %Numeric(XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = 1 ];

Property Predicate As PredicateBase(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Required ];

}
