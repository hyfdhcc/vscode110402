Class %DeepSee.PMML.Definition.OutputField Extends extendableNode [ System = 3 ]
{

Property name As %DeepSee.PMML.Datatype.FieldName(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property displayName As %DeepSee.PMML.Datatype.String(MAXLEN = 2000, XMLPROJECTION = "ATTRIBUTE");

Property optype As %DeepSee.PMML.Datatype.OpType(XMLPROJECTION = "ATTRIBUTE");

Property dataType As %DeepSee.PMML.Datatype.DataType(XMLPROJECTION = "ATTRIBUTE");

Property targetField As %DeepSee.PMML.Datatype.FieldName(XMLPROJECTION = "ATTRIBUTE");

Property feature As %DeepSee.PMML.Datatype.ResultFeature(XMLPROJECTION = "ATTRIBUTE");

Property value As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property ruleFeature As %DeepSee.PMML.Datatype.RuleFeature(XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "consequent" ];

Property algorithm As %DeepSee.PMML.Datatype.String(VALUELIST = ",recommendation,exclusiveRecommendation,ruleAssociation", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "exclusiveRecommendation" ];

Property rank As %DeepSee.PMML.Datatype.IntNumber(XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = 1 ];

Property rankBasis As %DeepSee.PMML.Datatype.String(VALUELIST = ",confidence,support,lift,leverage,affinity", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "confidence" ];

Property rankOrder As %DeepSee.PMML.Datatype.String(VALUELIST = ",descending,ascending", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "descending" ];

Property isMultiValued As %DeepSee.PMML.Datatype.BooleanInt(XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "0" ];

Property segmentId As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property Decisions As Decisions(XMLPROJECTION = "ELEMENT");

Property Expression As %DeepSee.PMML.Definition.Util.AbstractExpression(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
