/// Abstract base class for Conditions
Class %SAML.Condition Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, Inheritance = right, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "urn:oasis:names:tc:SAML:2.0:assertion";

Parameter ELEMENTQUALIFIED = 0;

}
