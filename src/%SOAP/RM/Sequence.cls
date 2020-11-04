Include %soap

/// Sequence SOAP header as defined in WS-ReliableMessaging 1.2.
Class %SOAP.RM.Sequence Extends %SOAP.Header [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://docs.oasis-open.org/ws-rx/wsrm/200702";

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLPREFIX = "wsrm";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter OUTPUTTYPEATTRIBUTE = 0;

Property Identifier As %xsd.anyURI;

Property MessageNumber As %SOAP.RM.MessageNumberType;

/// Create Sequence header based on WS-ReliableMessaging session
ClassMethod CreateHeader(session As %SYS.RMSession, request As %Boolean) As %SOAP.RM.Sequence [ Internal ]
{
	Set sequence=..%New()
	Set sequence.Identifier=$select(request:session.RequestIdentifier,1:session.ResponseIdentifier)
	Set sequence.MessageNumber=session.MessageNumber
	$$$SOAPLogSecurity("Add Sequence. MessageNumber="_sequence.MessageNumber)
	Quit sequence
}

}
