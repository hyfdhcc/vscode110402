Class %iKnow.Classification.Definition.PredicateOR Extends PredicateBase [ System = 3 ]
{

Parameter XMLNAME = "OR";

Property predicates As list Of PredicateBase(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

Method %GenerateCode() As %String
{
	set tCode = "", tCount = ..predicates.Count()
	for i = 1:1:tCount {
		set tCode = tCode _$s(tCode="":"", 1:" || ")_ ..predicates.GetAt(i).%GenerateCode()
	}
	quit "("_tCode_")"
}

}
