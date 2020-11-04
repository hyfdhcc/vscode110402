/// Implementation of Australian E-health XML secured payload profiles.
/// Document ATS 5821-2010
Class %Standards.AU.eHealth.SMD.SignatureListType Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/SignedPayload/2010";

Parameter XMLPREFIX = "sp";

Property Signature As list Of %XML.Security.Signature(REFNAMESPACE = "http://www.w3.org/2000/09/xmldsig#", XMLPROJECTION = "element", XMLREF = 1) [ Required ];

}
