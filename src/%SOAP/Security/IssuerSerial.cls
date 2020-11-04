/// IssuerSerial identifier for X509Data reference for SOAP SecurityTokenReference.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class."
Class %SOAP.Security.IssuerSerial Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://www.w3.org/2000/09/xmldsig#";

/// Issuer Distinguished Name
Property IssuerName As %String(CONTENT = "escape", MAXLEN = "") [ Internal ];

/// Issuer Distinguished Name
Property IssuerSerial As %xsd.integer [ Internal ];

}
