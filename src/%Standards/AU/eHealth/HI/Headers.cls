Include %soap

/// %Standards.AU.eHealth.HI.Headers supports adding, signing and validating headers
/// that are defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br><br>
/// See AddRequestHeaders and AddResponseHeaders for details of how to add and sign headers.<br>
/// See ValidateHeaders for details of how to validate headers.
Class %Standards.AU.eHealth.HI.Headers Extends %RegisteredObject [ System = 4 ]
{

/// product SOAP header is to be supplied by caller for creating request and response.
/// product SOAP header will reference header after validating.
Property product As %Standards.AU.eHealth.HI.ProductType;

/// user SOAP header is to be supplied by caller for creating request.
/// user SOAP header will reference header after validating received request.
Property user As %Standards.AU.eHealth.HI.UserType;

/// timestamp SOAP header will be created request.
/// timestamp SOAP header will reference header after validating received request.
Property timestamp As %Standards.AU.eHealth.HI.TimestampType;

/// signature SOAP header will be created for request and response and will sign other headers.
/// signature SOAP header will reference header after validating received request or response.
Property signature As %Standards.AU.eHealth.HI.SignatureContainerType;

/// Add request headers.
/// <ul>
/// <li>SOAP addressing headers will be created and added.</li>
/// <li>product header will be as supplied by caller by setting product property.</li>
/// <li>user header will be as supplied by caller by setting product property.</li>
/// <li>timestamp and signature headers will be created by this method.</li>
/// </ul>
/// 
/// AddRequestHeaders interface:
/// <ul>
/// <li>The service argument is required and is the web client or service for which to add the headers.</li>
/// <li>The credentials argument is the X.509 credentials object used for signing.
/// See %SYS.X509Credentials class documentation for details.</li>
/// <li>The optional interval argument is used to create the timestamp header,
/// if the optional expires field is desired.</li>
/// </ul>
Method AddRequestHeaders(service As %SOAP.WebBase, credentials As %SYS.X509Credentials, interval As %Integer)
{
	If $isobject(..product) {
		Do service.HeadersOut.SetAt(..product,"product")
	}

	If $isobject(..user) {
		Do service.HeadersOut.SetAt(..user,"user")
	}
	
	Set ..timestamp=##class(%Standards.AU.eHealth.HI.TimestampType).Create(.interval)
	Do service.HeadersOut.SetAt(..timestamp,"timestamp")
	
	Set ..signature=##class(%Standards.AU.eHealth.HI.SignatureContainerType).Create(service,credentials)
	Do service.HeadersOut.SetAt(..signature,"signature")
}

/// Add response headers.
/// <ul>
/// <li>SOAP addressing headers will be created and added.</li>
/// <li>product header will be as supplied by caller by setting product property.</li>
/// <li>signature header will be created by this method.</li>
/// </ul>
/// 
/// AddResponseHeaders interface:
/// <ul>
/// <li>The service argument is required and is the web client or service for which to add the headers.</li>
/// <li>The credentials argument is the X.509 credentials object used for signing.
/// See %SYS.X509Credentials class documentation for details.</li>
/// </ul>
Method AddResponseHeaders(service As %SOAP.WebBase, credentials As %SYS.X509Credentials)
{
	If $isobject(..product) {
		Do service.HeadersOut.SetAt(..product,"product")
	}

	Set ..signature=##class(%Standards.AU.eHealth.HI.SignatureContainerType).Create(service,credentials)
	Do service.HeadersOut.SetAt(..signature,"signature")
}

/// Validate the signature and other HI required headers.<br>
/// If called from a web service, a fault is issued in case of error and this method does not return.<br>
/// If called from a web client, a %Status is returned in case of error.<br>
/// In order to valdate the headers the web service or client must be told to import the headers.<br>
/// Web service needs request headers defined in SOAPHEADERS parameter<br><br>
///    Parameter SOAPHEADERS = &nbsp;&nbsp;&nbsp;"signature:%Standards.AU.eHealth.HI.SignatureContainerType,product:%Standards.AU.eHealth.HI.ProductType,user:%Standards.AU.eHealth.HI.UserType,timestamp:%Standards.AU.eHealth.HI.TimestampType"<br>
/// Web client needs response headers defined in SOAPHEADERS parameter<br>
///    Parameter SOAPHEADERS = &nbsp;&nbsp;&nbsp;"signature:%Standards.AU.eHealth.HI.SignatureContainerType,product:%Standards.AU.eHealth.HI.ProductType"<br>
Method ValidateHeaders(service As %SOAP.WebBase) As %Status
{
	Set sc=$$$OK
	// Get header instances
	Set ..product=service.HeadersIn.GetAt("product")
	Set ..user=service.HeadersIn.GetAt("user")
	Set ..timestamp=service.HeadersIn.GetAt("timestamp")
	Set ..signature=service.HeadersIn.GetAt("signature")

	// Validate presence of a signature and validate the signature
	If '$isobject(..signature) || '$isobject(..signature.Signature) {
		Set error="No signature header"
		Set code="badSignature"
	} Else {
		Set error=..signature.Validate(service.ImportHandler,service)
		Set code="badSignature"
	}
	
	// Validate presence of product header
	If error="",'$isobject(..product) {
		Set error="No product header"
		Set code="badlyFormedMsg"
	}
	
	If service.%Extends("%SOAP.WebClient") {
		// For web client just return any error as %Status
		If error'="" {
			Set sc=$$$ERROR($$$SOAPBadLogin,error)
		}
	} Else {
		// Validate presence of user header for web service
		If error="",'$isobject(..user) {
			Set error="No user header"
			Set code="notAuthenticated"
		}
		// Validate presence and expiration of tiomestamp header
		If error="" {
			If '$isobject(..timestamp) {
				Set error="No timestamp header"
				Set code="badTimestamp"
			} Else {
				Set error=..timestamp.Validate(service.ImportHandler,service)
				Set code="badTimestamp"
			}
		}
		// For web service error issue fault and do not return.
		If error'="" {
			Set fault=service.MakeFault($$$FAULTServer,code,error)
			Do service.ReturnFault(fault)
		}
	}
	
	Quit sc
}

}
