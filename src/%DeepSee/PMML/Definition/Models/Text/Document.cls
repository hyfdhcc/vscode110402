Class %DeepSee.PMML.Definition.Models.Text.Document Extends %DeepSee.PMML.Definition.node [ System = 3 ]
{

Parameter XMLNAME = "TextDocument";

Property Extension As list Of %DeepSee.PMML.Definition.Extension(XMLPROJECTION = "ELEMENT");

Property id As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property name As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property length As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE");

Property file As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

}
