/// WS-Addressing MessageID header.
Class %SOAP.Addressing.MessageID Extends %SOAP.Header [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Property MessageID As %xsd.anyURI(XMLPROJECTION = "content");

}
