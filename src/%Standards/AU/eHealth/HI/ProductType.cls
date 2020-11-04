/// This SOAP header is defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br>
/// The class name is derived from the type definition in CommonCoreElements.xsd.<br>
/// The SOAP header element name is "product".<br>
/// See %Standards.AU.eHealth.HI.Headers class for adding and validating headers.
Class %Standards.AU.eHealth.HI.ProductType Extends %SOAP.Header [ System = 4 ]
{

/// The header element name and key name for HeadersIn and HeadersOut arrays.
Parameter XMLNAME = "product";

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLPREFIX = "cce";

Property vendor As %Standards.AU.eHealth.HI.QualifiedId [ Required ];

Property productName As %String(MAXLEN = "") [ Required ];

Property productVersion As %String(MAXLEN = "") [ Required ];

Property platform As %String(MAXLEN = "") [ Required ];

}
