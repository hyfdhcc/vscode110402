Class %DeepSee.PMML.Definition.Decisions Extends extendableNode [ System = 3 ]
{

Property businessProblem As %DeepSee.PMML.Datatype.String(MAXLEN = 2000, XMLPROJECTION = "ATTRIBUTE");

Property description As %DeepSee.PMML.Datatype.String(MAXLEN = 20000, XMLPROJECTION = "ATTRIBUTE");

Property Decision As list Of Decision(XMLPROJECTION = "ELEMENT") [ Required ];

}
