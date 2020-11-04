Class %BI.ListDrillDown Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property AdditionalCondition As %String(TRUNCATE = 1);

Property IsActive As %Boolean;

Property LinkField As %String(TRUNCATE = 1);

Property MenuDesc As %String(TRUNCATE = 1);

Relationship DetailList As %BI.DetailList [ Cardinality = parent, Inverse = ListDrillDown ];

Property TargetDetailList As %String(TRUNCATE = 1);

Property TargetDetailListName As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {TargetDetailListName}=$S({TargetDetailList}="":"",1:$LG(^BI.DetailListD({TargetDetailList}),1)) 
}, SqlComputed, SqlFieldName = TargetDetailListName ];

Method TargetDetailListNameGet() As %String
{
 if ..TargetDetailList="" quit ""
 quit $LG(^BI.DetailListD(..TargetDetailList),1)
}

Query byDetailList(comid As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,MenuDesc,TargetDetailList,LinkField,AdditionalCondition,IsActive,TargetDetailListName
 FROM ListDrillDown
 WHERE (DetailList = :comid)
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="ListDrillDownDefaultData">
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
<Value>TargetDetailList</Value>
</Value>
<Value name="5">
<Value>AdditionalCondition</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DD")</DataLocation>
<DefaultData>ListDrillDownDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DD")</IdLocation>
<IndexLocation>^BI.ListDrillDownI</IndexLocation>
<StreamLocation>^BI.ListDrillDownS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
