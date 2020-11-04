/// XML Encryption element.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class."
Class %XML.Security.EncryptionProperty Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://www.w3.org/2001/04/xmlenc#";

Parameter ELEMENTQUALIFIED = 1;

Property content As %XML.String(XMLPROJECTION = "content");

Property Target As %xsd.anyURI(XMLPROJECTION = "attribute");

Property Id As %String(MAXLEN = "", XMLPROJECTION = "attribute");

}
