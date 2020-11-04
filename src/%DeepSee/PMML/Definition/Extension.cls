Class %DeepSee.PMML.Definition.Extension Extends node [ System = 3 ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Property extender As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property name As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property value As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property iscExtensions As list Of %DeepSee.PMML.Definition.Extension.ISCExtension(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
