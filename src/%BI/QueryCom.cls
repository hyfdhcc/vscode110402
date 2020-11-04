Class %BI.QueryCom Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Class On QueryClass As Exact;

Property ListingType As %String(TRUNCATE = 1);

Relationship QueryAttachForm As %BI.QueryAttachForm [ Cardinality = children, Inverse = QueryCom ];

Property QueryClass As %String(TRUNCATE = 1);

Property QueryComName As %String(TRUNCATE = 1);

Relationship QueryDisplayFields As %BI.QueryDisplayFields [ Cardinality = children, Inverse = QueryCom ];

Relationship QueryDrillDown As %BI.QueryDrillDown [ Cardinality = children, Inverse = QueryCom ];

Property RowHeight As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,QueryComName,QueryClass
FROM %BI.QueryCom
}

Storage Default
{
<Data name="QueryComClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="QueryComDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>QueryComName</Value>
</Value>
<Value name="2">
<Value>QueryClass</Value>
</Value>
<Value name="3">
<Value>RowHeight</Value>
</Value>
<Value name="4">
<Value>ListingType</Value>
</Value>
</Data>
<DataLocation>^BI.QueryComD</DataLocation>
<DefaultData>QueryComDefaultData</DefaultData>
<IdLocation>^BI.QueryComD</IdLocation>
<IndexLocation>^BI.QueryComI</IndexLocation>
<StreamLocation>^BI.QueryComS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
