Class %DeepSee.PMML.Definition.Models.SVM.VectorDictionary Extends node [ System = 4 ]
{

Property numberOfVectors As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE");

Property Fields As VectorFields(XMLNAME = "VectorFields", XMLPROJECTION = "ELEMENT");

Property Instances As list Of VectorInstance(XMLNAME = "VectorInstance", XMLPROJECTION = "ELEMENT");

}
