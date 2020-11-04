Class %DeepSee.PMML.Definition.Models.NeuralNetwork.NeuralOutputs Extends %DeepSee.PMML.Definition.extendableNode [ System = 3 ]
{

Property numberOfOutputs As %DeepSee.PMML.Datatype.IntNumber(MINVAL = 0, XMLPROJECTION = "ATTRIBUTE");

Property Outputs As list Of NeuralOutput(XMLNAME = "NeuralOutput", XMLPROJECTION = "ELEMENT");

}
