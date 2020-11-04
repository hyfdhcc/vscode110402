/// This class represents a reference to a set of strings, possibly annotated with metadata, for use
/// in a TT model.
Class %iKnow.TextTransformation.Model.SetReference Extends node [ System = 3 ]
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE");

Property type As %String(VALUELIST = ",set,xdata", XMLPROJECTION = "ATTRIBUTE");

}
