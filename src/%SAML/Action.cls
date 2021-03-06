/// Decision Action
Class %SAML.Action Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "urn:oasis:names:tc:SAML:2.0:assertion";

Parameter ELEMENTQUALIFIED = 0;

Property Action As %String(CONTENT = "escape", MAXLEN = "", XMLPROJECTION = "content") [ Required ];

Property Namespace As %xsd.anyURI(XMLPROJECTION = "attribute") [ Required ];

}
