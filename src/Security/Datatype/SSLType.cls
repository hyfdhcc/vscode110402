Class Security.Datatype.SSLType Extends %Library.Boolean [ System = 2 ]
{

Parameter DOMAIN = "%Utility";

ClassMethod DisplayToLogical(%val As %String) As %Library.Boolean [ Internal ]
{
 q $case($zcvt(%val,"U"),$zcvt($$$Text("Server","%Utility"),"U"):1,$zcvt($$$Text("Client","%Utility"),"U"):0,:0)
}

ClassMethod LogicalToDisplay(%val As %Library.Boolean) As %String [ Internal ]
{
 q $case(%val,1:$$$Text("Server","%Utility"),0:$$$Text("Client","%Utility"),:$$$Text("Client","%Utility"))
}

ClassMethod LogicalToODBC(%val As %Library.Boolean) As %String
{
 q ..LogicalToDisplay(%val)
}

}
