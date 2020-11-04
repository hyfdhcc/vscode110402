Class %DeepSee.PMML.Definition.Models.NaiveBayes.BayesInput Extends %DeepSee.PMML.Definition.extendableNode [ System = 3 ]
{

Property DerivedField As %DeepSee.PMML.Definition.DerivedField(XMLPROJECTION = "ELEMENT");

Property PairCounts As list Of PairCounts(XMLPROJECTION = "ELEMENT");

Property fieldName As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

}
