/// Handles errors encountered during transformation
Class %XML.XSLT.ErrorHandler Extends %RegisteredObject [ System = 3 ]
{

Method error(pMessage As %String)
{
	Write !,pMessage
}

Method fatalError(pMessage As %String)
{
	Write !,pMessage
}

Method warning(pMessage As %String)
{
	Write !,pMessage
}

}
