/// This class represents any builder-specific parameters not covered elsewhere.
/// Nodes of this type can be appended to a classifier definition to allow it to be reloaded
/// into a classifier builder for optimization or other purposes.
Class %iKnow.Classification.Definition.BuilderParameter Extends node [ System = 3 ]
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property value As %String(MAXLEN = "", XMLPROJECTION = "ATTRIBUTE");

}
