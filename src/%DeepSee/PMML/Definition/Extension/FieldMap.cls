Class %DeepSee.PMML.Definition.Extension.FieldMap Extends %DeepSee.PMML.Definition.node [ System = 3 ]
{

Parameter XMLNAME = "X-FieldMap";

Property fieldName As %DeepSee.PMML.Datatype.FieldName(XMLPROJECTION = "ATTRIBUTE");

Property spec As %DeepSee.PMML.Datatype.String(MAXLEN = 200, XMLPROJECTION = "ATTRIBUTE");

}
