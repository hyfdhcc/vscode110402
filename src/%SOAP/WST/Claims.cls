/// ClaimsType type from WS-Trust 1.3.
Class %SOAP.WST.Claims Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://docs.oasis-open.org/ws-sx/ws-trust/200512";

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLPREFIX = "wst";

Property content As %XML.String(XMLPROJECTION = "content");

Property Dialect As %xsd.anyURI(XMLPROJECTION = "attribute");

}
