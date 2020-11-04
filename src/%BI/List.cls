Class %BI.List Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property QueryCom As %String(TRUNCATE = 1);

Property ListName As %String(TRUNCATE = 1);

Property ListQuery As %String(TRUNCATE = 1);

Property ComplexCriteria As %String(TRUNCATE = 1);

Property ListClass As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {ListClass}=##class(%BI.ReportObj).GetListClass({QueryCom})}, SqlComputed ];

Method ListClassGet() As %String
{
 quit (..GetListClass(..QueryCom))
}

ClassMethod GetListClass(qmid As %String) As %String
{
 quit $LG(^BI.DetailListD(qmid),2)
}

Query AllList() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,ListName
FROM List
}

Storage Default
{
<Data name="ListClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="ListDefaultData">
<Value name="1">
<Value>ListName</Value>
</Value>
<Value name="2">
<Value>QueryCom</Value>
</Value>
<Value name="3">
<Value>ListQuery</Value>
</Value>
<Value name="4">
<Value>ComplexCriteria</Value>
</Value>
</Data>
<DataLocation>^BI.ListD</DataLocation>
<DefaultData>ListDefaultData</DefaultData>
<IdLocation>^BI.ListD</IdLocation>
<IndexLocation>^BI.ListI</IndexLocation>
<StreamLocation>^BI.ListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
