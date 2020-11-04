/// StatusType type from WS-Trust 1.3.
Class %SOAP.WST.Status Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://docs.oasis-open.org/ws-sx/ws-trust/200512";

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLPREFIX = "wst";

Property Code As %xsd.anyURI;

Property Reason As %String(MAXLEN = "");

}
