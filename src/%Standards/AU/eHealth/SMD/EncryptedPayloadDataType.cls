/// Implementation of Australian E-health XML secured payload profiles.
/// Document ATS 5821-2010
Class %Standards.AU.eHealth.SMD.EncryptedPayloadDataType Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/EncryptedPayload/2010";

Parameter XMLPREFIX = "ep";

Property EncryptedData As %XML.Security.EncryptedData(REFNAMESPACE = "http://www.w3.org/2001/04/xmlenc#", XMLREF = 1) [ Required ];

}
