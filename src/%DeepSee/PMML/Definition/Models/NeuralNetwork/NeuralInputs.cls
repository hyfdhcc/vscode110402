Class %DeepSee.PMML.Definition.Models.NeuralNetwork.NeuralInputs Extends %DeepSee.PMML.Definition.extendableNode [ System = 3 ]
{

Property numberOfInputs As %DeepSee.PMML.Datatype.IntNumber(MINVAL = 0, XMLPROJECTION = "ATTRIBUTE");

Property Inputs As list Of NeuralInput(XMLNAME = "NeuralInput", XMLPROJECTION = "ELEMENT");

}
