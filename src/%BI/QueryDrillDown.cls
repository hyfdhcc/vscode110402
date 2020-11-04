Class %BI.QueryDrillDown Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property AdditionalCondition As %String(TRUNCATE = 1);

Property IsActive As %Boolean;

Property LinkField As %String(TRUNCATE = 1);

Property MenuDesc As %String(TRUNCATE = 1);

Relationship QueryCom As %BI.QueryCom [ Cardinality = parent, Inverse = QueryDrillDown ];

Property TargetQueryCom As %String(TRUNCATE = 1);

Property TargetQueryComName As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {TargetQueryComName}=$S({TargetQueryCom}="":"",1:$LG(^BI.QueryComD({TargetQueryCom}),1)) 
}, SqlComputed, SqlFieldName = TargetQueryComName ];

Method TargetQueryComNameGet() As %String
{
 if ..TargetQueryCom="" quit ""
 quit $LG(^BI.QueryComD(..TargetQueryCom),1)
}

Query byQueryCom(comid As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,MenuDesc,TargetQueryCom,LinkField,AdditionalCondition,IsActive,TargetQueryComName
 FROM QueryDrillDown
 WHERE (QueryCom = :comid)
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="QueryDrillDownDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>IsActive</Value>
</Value>
<Value name="2">
<Value>LinkField</Value>
</Value>
<Value name="3">
<Value>MenuDesc</Value>
</Value>
<Value name="4">
<Value>TargetQueryCom</Value>
</Value>
<Value name="5">
<Value>AdditionalCondition</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DD")</DataLocation>
<DefaultData>QueryDrillDownDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DD")</IdLocation>
<IndexLocation>^BI.QueryDrillDownI</IndexLocation>
<StreamLocation>^BI.QueryDrillDownS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
