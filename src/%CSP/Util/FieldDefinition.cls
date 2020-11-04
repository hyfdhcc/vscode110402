/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>Represents a field definition used by the AutoForm class.
Class %CSP.Util.FieldDefinition Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 3 ]
{

/// This class represents the following XML document:
XData example
{
<field property="A" />
}

/// Name of property within the AutoForm-enabled class.
Property Property As %String(MAXLEN = 64, TRUNCATE = 0, XMLNAME = "property", XMLPROJECTION = "attribute");

}
