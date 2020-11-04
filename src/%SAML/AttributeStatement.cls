/// Attribute Statement
Class %SAML.AttributeStatement Extends %SAML.Statement [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "urn:oasis:names:tc:SAML:2.0:assertion";

Parameter ELEMENTQUALIFIED = 0;

Property Attribute As list Of %XML.Adaptor(XMLCHOICELIST = "%SAML.Attribute,%SAML.EncryptedAttribute", XMLPROJECTION = "element", XMLREF = 1, XMLTYPECONSTRAINT = "choice") [ Required ];

}
