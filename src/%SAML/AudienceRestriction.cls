/// AudienceRestriction condition
Class %SAML.AudienceRestriction Extends %SAML.Condition [ System = 4 ]
{

Property Audience As list Of %xsd.anyURI(XMLPROJECTION = "element", XMLREF = 1) [ Required ];

}
