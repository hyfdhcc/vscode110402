/// Name ID
Class %SAML.NameID Extends %SAML.BaseID [ System = 4 ]
{

Property NameID As %String(CONTENT = "escape", MAXLEN = "", XMLPROJECTION = "content");

Property Format As %xsd.anyURI(XMLPROJECTION = "attribute");

Property NameQualifier As %String(MAXLEN = "", XMLPROJECTION = "attribute");

Property SPNameQualifier As %String(MAXLEN = "", XMLPROJECTION = "attribute");

Property SPProvidedID As %String(MAXLEN = "", XMLPROJECTION = "attribute");

}
