Class %iKnow.Classification.Definition.PredicateNOT Extends PredicateBase [ System = 3 ]
{

Parameter XMLNAME = "NOT";

Property predicate As PredicateBase(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

Method %GenerateCode() As %String
{
	quit "'"_..predicate.%GenerateCode()
}

}
