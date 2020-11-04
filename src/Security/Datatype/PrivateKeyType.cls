Class Security.Datatype.PrivateKeyType Extends %Library.Integer [ System = 2 ]
{

ClassMethod DisplayToLogical(%val As %String) As %Library.Integer [ Internal ]
{
 q $case($zcvt(%val,"U"),"DSA":1,"RSA":2,:2)
}

ClassMethod LogicalToDisplay(%val As %Library.Integer) As %String [ Internal ]
{
 q $case(%val,1:"DSA",2:"RSA",:"RSA")
}

ClassMethod LogicalToODBC(%val As %Library.Integer) As %String
{
 q ..LogicalToDisplay(%val)
}

}
