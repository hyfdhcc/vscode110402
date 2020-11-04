/// Created from: http://glassfish.iscinternal.com:9180/opensso/identityservices?WSDL
Class %Net.OpenAM.tns.attribute Extends (%RegisteredObject, %XML.Adaptor) [ CompileAfter = , Inheritance = right, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://opensso.idsvcs.identity.sun.com/";

Parameter XMLNAME = "attribute";

Parameter XMLSEQUENCE = 1;

Property name As %String(MAXLEN = "", XMLNAME = "name");

Property values As list Of %String(MAXLEN = "", XMLNAME = "values", XMLPROJECTION = "ELEMENT") [ SqlFieldName = _values ];

}
