/// PolicyReference from WS-Policy 1.5.<br><br>
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class."
Class %SOAP.PolicyReference Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://www.w3.org/ns/ws-policy";

Parameter ELEMENTQUALIFIED = 1;

Property URI As %xsd.anyURI(XMLPROJECTION = "attribute") [ Required ];

Property Digest As %xsd.base64Binary(XMLPROJECTION = "attribute");

Property DigestAlgorithm As %xsd.anyURI(XMLPROJECTION = "attribute");

}
