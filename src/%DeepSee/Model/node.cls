/// Base class for DeepSee Cube Definition meta-data objects.<br/>
Class %DeepSee.Model.node Extends abstractNode [ Abstract, System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/deepsee";

Parameter XMLINCLUDEINGROUP = 1;

/// Logical name of this element.
Property name As %DeepSee.Datatype.entityName(XMLPROJECTION = "attribute");

/// Localized name of this element.
/// This is used by tools but not within actually queries.
Property displayName As %DeepSee.Datatype.entityName(XMLPROJECTION = "attribute");

/// Optional description for this node.
Property description As %DeepSee.Datatype.string(MAXLEN = 2500, XMLPROJECTION = "attribute");

/// Disabled flag. If true, then this member will be ignored when the
/// DeepSee cube model is compiled.
Property disabled As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

}
