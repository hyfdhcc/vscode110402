/// The system information server provides XML-formatted information on system status
/// and services. Information is divided into categories selected via selectors
/// of the form "/services". This is designed to be an easy mapping to URLs, such as
/// those supported by the pseudo-HTTP server in the super server.
Class SYS.Info.Server Extends %RegisteredObject
{

/// Writes the information for the given selector to the current device.
ClassMethod Serve(selector As %String)
{
}

/// Handle SuperServer pseudo-HTTP "GET" requesets
ClassMethod HTTPServe()
{
}

ClassMethod WriteEOL()
{
}

ClassMethod WriteHeaders()
{
}

}
