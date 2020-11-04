Class %BI.FormDef Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Fields As array Of %BI.FormField;

Property FormHeight As %String(TRUNCATE = 1);

Property FormID As %String(TRUNCATE = 1);

Property FormName As %String(TRUNCATE = 1);

Property FormWidth As %String(TRUNCATE = 1);

Property Picture As %GlobalBinaryStream;

Query AllForm() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,FormName,FormID,FormWidth,FormHeight 
FROM FormDef
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="Fields">
<Attribute>Fields</Attribute>
<Structure>subnode</Structure>
<Subscript>"Fields"</Subscript>
</Data>
<Data name="FormDefDefaultData">
<Value name="1">
<Value>FormHeight</Value>
</Value>
<Value name="2">
<Value>FormID</Value>
</Value>
<Value name="3">
<Value>FormName</Value>
</Value>
<Value name="4">
<Value>FormWidth</Value>
</Value>
</Data>
<Data name="Picture">
<Attribute>Picture</Attribute>
<Structure>node</Structure>
<Subscript>"P"</Subscript>
</Data>
<DataLocation>^BI.FormDefD</DataLocation>
<DefaultData>FormDefDefaultData</DefaultData>
<IdLocation>^BI.FormDefD</IdLocation>
<IndexLocation>^BI.FormDefI</IndexLocation>
<StreamLocation>^BI.FormDefS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
