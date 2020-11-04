/// Reference an Assertion using an ID
Class %SAML.AssertionIDRef Extends %SAML.AssertionReference [ System = 4 ]
{

Parameter ELEMENTQUALIFIED = 1;

Property ID As %String(CONTENT = "escape", MAXLEN = "", XMLPROJECTION = "content") [ Required ];

}
