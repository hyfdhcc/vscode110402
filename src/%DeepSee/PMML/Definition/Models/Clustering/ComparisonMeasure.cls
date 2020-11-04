Class %DeepSee.PMML.Definition.Models.Clustering.ComparisonMeasure Extends node [ System = 3 ]
{

Property Metric As ComparisonMetric(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "choice");

Property kind As %DeepSee.PMML.Datatype.String(VALUELIST = ",distance,similarity", XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property compareFunction As %DeepSee.PMML.Datatype.String(VALUELIST = ",absDiff,gaussSim,delta,equal,table", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "absDiff" ];

Property minimum As %DeepSee.PMML.Datatype.Number(XMLPROJECTION = "ATTRIBUTE");

Property maximum As %DeepSee.PMML.Datatype.Number(XMLPROJECTION = "ATTRIBUTE");

}
