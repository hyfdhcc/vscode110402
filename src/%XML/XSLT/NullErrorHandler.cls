/// Provides an error handler which does nothing
Class %XML.XSLT.NullErrorHandler Extends %XML.XSLT.ErrorHandler
{

/// Do Nothing
Method error(pMessage As %String)
{
}

/// Do Nothing
Method fatalError(pMessage As %String)
{
}

/// Do Nothing
Method warning(pMessage As %String)
{
}

}
