Class %BI.QueryDisplayFields Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property AdditionalCondition As %String(TRUNCATE = 1);

Property ColumnWidth As %String(TRUNCATE = 1);

Property ComplexCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DecPoint As %String(TRUNCATE = 1);

Property DisplayCol As %String(TRUNCATE = 1);

Property DisplayRow As %String(TRUNCATE = 1);

Property DisplayType As %SmallInt;

Property FieldTranslation As %String(MAXLEN = 10000, TRUNCATE = 1);

Property HeaderDesc As %String(TRUNCATE = 1);

Property IsActive As %Boolean;

Property LinkField As %String(TRUNCATE = 1);

Property NullField As %String(TRUNCATE = 1);

Property NullPointer As %String(TRUNCATE = 1);

Property PropName As %String(MAXLEN = 5000, TRUNCATE = 1);

Relationship QueryCom As %BI.QueryCom [ Cardinality = parent, Inverse = QueryDisplayFields ];

Property Ranges As %String(MAXLEN = 10000, TRUNCATE = 1);

Property StartClass As %String(TRUNCATE = 1);

Property UseExternalValue As %Boolean;

Property Validation As %String(TRUNCATE = 1);

Query byQueryCom(comid As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,PropName,HeaderDesc,StartClass,DisplayType,NullField,NullPointer,IsActive,ComplexCode,LinkField,AdditionalCondition,FieldTranslation,DecPoint,Ranges,UseExternalValue,ColumnWidth,DisplayRow,DisplayCol
 FROM QueryDisplayFields
 WHERE (QueryCom = :comid)
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="QueryDisplayFieldsDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>UseExternalValue</Value>
</Value>
<Value name="2">
<Value>ComplexCode</Value>
</Value>
<Value name="3">
<Value>HeaderDesc</Value>
</Value>
<Value name="4">
<Value>PropName</Value>
</Value>
<Value name="5">
<Value>Validation</Value>
</Value>
<Value name="6">
<Value>ColumnWidth</Value>
</Value>
<Value name="7">
<Value>AdditionalCondition</Value>
</Value>
<Value name="8">
<Value>DisplayType</Value>
</Value>
<Value name="9">
<Value>StartClass</Value>
</Value>
<Value name="10">
<Value>DecPoint</Value>
</Value>
<Value name="11">
<Value>FieldTranslation</Value>
</Value>
<Value name="12">
<Value>IsActive</Value>
</Value>
<Value name="13">
<Value>LinkField</Value>
</Value>
<Value name="14">
<Value>NullField</Value>
</Value>
<Value name="15">
<Value>NullPointer</Value>
</Value>
<Value name="16">
<Value>Ranges</Value>
</Value>
<Value name="17">
<Value>DisplayCol</Value>
</Value>
<Value name="18">
<Value>DisplayRow</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DF")</DataLocation>
<DefaultData>QueryDisplayFieldsDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DF")</IdLocation>
<IndexLocation>^BI.QueryDisplayFieldsI</IndexLocation>
<StreamLocation>^BI.QueryDisplayFieldsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
