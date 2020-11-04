/// Created from: http://glassfish.iscinternal.com:9180/opensso/identityservices?WSDL
Class %Net.OpenAM.tns.token Extends (%RegisteredObject, %XML.Adaptor) [ CompileAfter = , Inheritance = right, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://opensso.idsvcs.identity.sun.com/";

Parameter XMLNAME = "token";

Parameter XMLSEQUENCE = 1;

Property id As %String(MAXLEN = "", XMLNAME = "id");

}
