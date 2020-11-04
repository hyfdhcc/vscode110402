Class %DeepSee.PMML.Definition.Util.SparseArrayReal Extends SparseArray [ System = 3 ]
{

Parameter XMLNAME = "REAL-SparseArray";

Property defaultValue As %DeepSee.PMML.Datatype.RealNumber(XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = 0 ];

Property Entries As %DeepSee.PMML.Datatype.String(MAXLEN = 20000, XMLNAME = "REAL-Entries", XMLPROJECTION = "ELEMENT");

}
