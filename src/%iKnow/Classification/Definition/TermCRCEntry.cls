Class %iKnow.Classification.Definition.TermCRCEntry Extends node [ System = 3 ]
{

Parameter XMLNAME = "Entry";

Property Master As %String(MAXLEN = 200, XMLPROJECTION = "ELEMENT");

Property Relation As %String(MAXLEN = 200, XMLPROJECTION = "ELEMENT");

Property Slave As %String(MAXLEN = 200, XMLPROJECTION = "ELEMENT");

Method ToString() As %String
{
	quit ..Master_$c(0)_..Relation_$c(0)_..Slave
}

}
