Class %BI.DetailList Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Dashboard On Dashboard [ Unique ];

Index Class On ListClass As Exact;

Property MergeCell As %Boolean;

Relationship ListAttachForm As %BI.ListAttachForm [ Cardinality = children, Inverse = DetailList ];

Property RowHeight As %String(TRUNCATE = 1);

Property ListClass As %String(TRUNCATE = 1);

Property DetailListName As %String(TRUNCATE = 1);

Property DisplayFields As array Of %BI.DetailListFields;

Property Dashboard As %String(TRUNCATE = 1);

Property DashboardName As %String(TRUNCATE = 1) [ Calculated ];

Property ObjectHeight As %Integer;

Property ObjectWidth As %Integer;

Property RecPerPage As %Integer;

Property DetListBar As %Integer;

Property DetAgg As %Integer;

Property DetApp As %Integer;

Property MrgFrm As %Integer;

Property MrgTo As %Integer;

Property MrgYN As %Integer;

Property AlwMult As %Integer;

Method DashboardNameGet() As %String
{
 if ..Dashboard="" quit ""
 quit $LG($G(^BI.DashBoardD(..Dashboard)),1)
}

Relationship ListDrillDown As %BI.ListDrillDown [ Cardinality = children, Inverse = DetailList ];

Property LayoutOption As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DetailListName,ListClass
FROM %BI.DetailList
}

Query ListByClass(cls As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,DetailListName FROM DetailList
 WHERE (ListClass = :cls) ORDER BY DetailListName
}

Storage Default
{
<Data name="DetailListClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DetailListDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>DetailListName</Value>
</Value>
<Value name="2">
<Value>ListClass</Value>
</Value>
<Value name="3">
<Value>LayoutOption</Value>
</Value>
<Value name="4">
<Value>MergeCell</Value>
</Value>
<Value name="5">
<Value>RowHeight</Value>
</Value>
<Value name="6">
<Value>Dashboard</Value>
</Value>
<Value name="7">
<Value>ObjectHeight</Value>
</Value>
<Value name="8">
<Value>ObjectWidth</Value>
</Value>
<Value name="9">
<Value>RecPerPage</Value>
</Value>
<Value name="10">
<Value>DetListBar</Value>
</Value>
<Value name="11">
<Value>DetAgg</Value>
</Value>
<Value name="12">
<Value>DetApp</Value>
</Value>
<Value name="13">
<Value>MgrFrm</Value>
</Value>
<Value name="14">
<Value>MgrTo</Value>
</Value>
<Value name="15">
<Value>MrgFrm</Value>
</Value>
<Value name="16">
<Value>MrgTo</Value>
</Value>
<Value name="17">
<Value>MrgYN</Value>
</Value>
<Value name="18">
<Value>AlwMult</Value>
</Value>
</Data>
<Data name="ListDisplayFields">
<Attribute>DisplayFields</Attribute>
<Structure>subnode</Structure>
<Subscript>"L"</Subscript>
</Data>
<DataLocation>^BI.DetailListD</DataLocation>
<DefaultData>DetailListDefaultData</DefaultData>
<IdLocation>^BI.DetailListD</IdLocation>
<IndexLocation>^BI.DetailListI</IndexLocation>
<StreamLocation>^BI.DetailListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
