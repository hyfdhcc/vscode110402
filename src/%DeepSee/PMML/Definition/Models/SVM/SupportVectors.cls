Class %DeepSee.PMML.Definition.Models.SVM.SupportVectors Extends node [ System = 4 ]
{

Property numberOfSupportVectors As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE");

Property numberOfAttributes As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE");

Property Vectors As list Of SupportVector(XMLNAME = "SupportVector", XMLPROJECTION = "ELEMENT");

}
