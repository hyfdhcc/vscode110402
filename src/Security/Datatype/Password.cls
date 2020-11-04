Class Security.Datatype.Password Extends %Library.Binary [ System = 2 ]
{

ClassMethod LogicalToDisplay(%val As %String) As %String [ Internal ]
{
	q $case(%val,"":"",:"*****")
}

ClassMethod LogicalToOdbc(%val As %String) As %String [ Internal ]
{
	q $case(%val,"":"",:"*****")
}

}
