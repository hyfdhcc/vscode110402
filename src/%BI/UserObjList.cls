Class %BI.UserObjList Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property UserId As %String;

Property ObjectId As %String;

Property ObjectType As %String;

Property ObjectImg As %String;

Index Idx On UserId;

Index idkey On (ObjectId, ObjectType, UserId) [ IdKey, Unique ];

Query ListAll(ID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT UserId,ObjectId,ObjectType,ObjectImg
FROM %BI.UserObjList 
where UserId = :ID
order By ObjectId
}

Storage Default
{
<Data name="UserObjListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ObjectId</Value>
</Value>
<Value name="3">
<Value>ObjectType</Value>
</Value>
<Value name="4">
<Value>UserId</Value>
</Value>
<Value name="5">
<Value>ObjectImg</Value>
</Value>
</Data>
<DataLocation>^BI.UserObjListD</DataLocation>
<DefaultData>UserObjListDefaultData</DefaultData>
<IdLocation>^BI.UserObjListD</IdLocation>
<IndexLocation>^BI.UserObjListI</IndexLocation>
<StreamLocation>^BI.UserObjListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
