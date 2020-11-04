/// This class is defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br>
/// The class name is derived from the type definition in CommonQualifiedIdentifier.xsd.
Class %Standards.AU.eHealth.HI.QualifiedId Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/QualifiedIdentifier/3.0";

Parameter XMLPREFIX = "qid";

Property qualifier As %xsd.anyURI [ Required ];

Property id As %String(MAXLEN = "") [ Required ];

}
