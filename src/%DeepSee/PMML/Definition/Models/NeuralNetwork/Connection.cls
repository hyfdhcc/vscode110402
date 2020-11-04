Class %DeepSee.PMML.Definition.Models.NeuralNetwork.Connection Extends %DeepSee.PMML.Definition.extendableNode [ System = 3 ]
{

Parameter XMLNAME = "Con";

Property from As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property weight As %DeepSee.PMML.Datatype.RealNumber(XMLPROJECTION = "ATTRIBUTE") [ Required ];

}
