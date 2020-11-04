Class %DeepSee.PMML.Definition.Util.MatCell Extends %DeepSee.PMML.Definition.node [ System = 3 ]
{

Property row As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property col As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property value As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "CONTENT");

}
