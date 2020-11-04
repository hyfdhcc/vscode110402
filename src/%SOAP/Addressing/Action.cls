/// WS-Addressing Action header.
Class %SOAP.Addressing.Action Extends %SOAP.Header [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Property Action As %xsd.anyURI(XMLPROJECTION = "content");

}
