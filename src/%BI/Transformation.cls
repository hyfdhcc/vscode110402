Class %BI.Transformation Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property TypeName As %String(TRUNCATE = 1);

Property Ranges As %String(MAXLEN = 30000, TRUNCATE = 1);

Property MTranslation As %String(MAXLEN = 30000, TRUNCATE = 1);

Index Name On TypeName As Exact;

Property CaseConvertion As %SmallInt;

Property NullField As %String(TRUNCATE = 1);

Property NullPointer As %String(TRUNCATE = 1);

Property UseExternalValue As %Boolean;

Property Justification As %String(TRUNCATE = 1);

Property TrBitMap As array Of %BI.TransBitMap;

//new development

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TypeName
FROM %BI.Transformation
}

ClassMethod genDefault()
{
}

Storage Default
{
<Data name="Class">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="TrBitMap">
<Attribute>TrBitMap</Attribute>
<Structure>subnode</Structure>
<Subscript>"B"</Subscript>
</Data>
<Data name="TransformationDefaultData">
<Value name="1">
<Value>TypeName</Value>
</Value>
<Value name="2">
<Value>MTranslation</Value>
</Value>
<Value name="3">
<Value>Ranges</Value>
</Value>
<Value name="4">
<Value>CaseConvertion</Value>
</Value>
<Value name="5">
<Value>NullField</Value>
</Value>
<Value name="6">
<Value>NullPointer</Value>
</Value>
<Value name="7">
<Value>UseExternalValue</Value>
</Value>
<Value name="8">
<Value>Justification</Value>
</Value>
</Data>
<DataLocation>^BI.TransformationD</DataLocation>
<DefaultData>TransformationDefaultData</DefaultData>
<IdLocation>^BI.TransformationD</IdLocation>
<IndexLocation>^BI.TransformationI</IndexLocation>
<StreamLocation>^BI.TransformationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
