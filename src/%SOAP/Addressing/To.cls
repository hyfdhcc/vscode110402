/// WS-Addressing To header.
/// If not present value defaults to "http://www.w3.org/2005/08/addressing/anonymous"
Class %SOAP.Addressing.To Extends %SOAP.Header [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Property To As %xsd.anyURI(XMLPROJECTION = "content");

}
