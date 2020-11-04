/// Reference an Assertion using a URI
Class %SAML.AssertionURIRef Extends %SAML.AssertionReference [ System = 4 ]
{

Parameter ELEMENTQUALIFIED = 1;

Property URI As %xsd.anyURI(XMLPROJECTION = "content") [ Required ];

}
