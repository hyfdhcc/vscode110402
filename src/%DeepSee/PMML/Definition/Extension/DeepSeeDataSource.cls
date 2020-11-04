Class %DeepSee.PMML.Definition.Extension.DeepSeeDataSource Extends DataSource [ System = 3 ]
{

Parameter XMLNAME = "X-DeepSeeDataSource";

Property cubeName As %String(MAXLEN = 200, XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property filter As %String(MAXLEN = 2000, XMLPROJECTION = "ATTRIBUTE");

Property idField As %DeepSee.PMML.Datatype.FieldName(XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "ID" ];

}
