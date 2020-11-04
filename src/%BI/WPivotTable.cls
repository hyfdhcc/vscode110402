Class %BI.WPivotTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Folder On Folder As Exact;

Property PivotName As %String(MAXLEN = 300, TRUNCATE = 1) [ Required ];

Property PivotNotes As %String(MAXLEN = 32000, TRUNCATE = 0);

Property Folder As %String(TRUNCATE = 1);

Property PreLoadSkrip As %String(MAXLEN = 10000, TRUNCATE = 1);

Property PostLoadSkrip As %String(MAXLEN = 10000, TRUNCATE = 1);

Property FixedRow As %String(MAXLEN = 100, TRUNCATE = 1);

Property FixedCol As %String(MAXLEN = 100, TRUNCATE = 1);

Property RowCell As array Of %String(MAXLEN = 10000, TRUNCATE = 1);

Property RowQuery As array Of %String(MAXLEN = 10000, TRUNCATE = 1);

Property ColQuery As array Of %String(MAXLEN = 10000, TRUNCATE = 1);

Property Filters As array Of %String(MAXLEN = 10000, TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,PivotName,PivotNotes,Folder
FROM %BI.WPivotTable ORDER BY PivotName
}

Storage Default
{
<Data name="ColQuery">
<Attribute>ColQuery</Attribute>
<Structure>subnode</Structure>
<Subscript>"cQ"</Subscript>
</Data>
<Data name="Filters">
<Attribute>Filters</Attribute>
<Structure>subnode</Structure>
<Subscript>"Filters"</Subscript>
</Data>
<Data name="RowCell">
<Attribute>RowCell</Attribute>
<Structure>subnode</Structure>
<Subscript>"rC"</Subscript>
</Data>
<Data name="RowCell2">
<Attribute>RowCell2</Attribute>
<Structure>subnode</Structure>
<Subscript>"RowCell2"</Subscript>
</Data>
<Data name="RowQuery">
<Attribute>RowQuery</Attribute>
<Structure>subnode</Structure>
<Subscript>"rQ"</Subscript>
</Data>
<Data name="WPivotTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
<Value name="3">
<Value>PivotName</Value>
</Value>
<Value name="4">
<Value>PivotNotes</Value>
</Value>
<Value name="5">
<Value>PostLoadSkrip</Value>
</Value>
<Value name="6">
<Value>PreLoadSkrip</Value>
</Value>
<Value name="7">
<Value>RowQueries</Value>
</Value>
<Value name="8">
<Value>FixedCol</Value>
</Value>
<Value name="9">
<Value>FixedRow</Value>
</Value>
</Data>
<DataLocation>^BI.WPivotTableD</DataLocation>
<DefaultData>WPivotTableDefaultData</DefaultData>
<IdLocation>^BI.WPivotTableD</IdLocation>
<IndexLocation>^BI.WPivotTableI</IndexLocation>
<StreamLocation>^BI.WPivotTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
