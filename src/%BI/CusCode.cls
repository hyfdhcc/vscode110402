Class %BI.CusCode Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property code As %String(MAXLEN = 100000, TRUNCATE = 1);

Property descr As %String(MAXLEN = 10000, TRUNCATE = 1);

Property help As %String(TRUNCATE = 1);

Property name As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,name
	FROM %BI.CusCode
	ORDER BY name
}

Storage Default
{
<Data name="CusCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>descr</Value>
</Value>
<Value name="4">
<Value>help</Value>
</Value>
<Value name="5">
<Value>name</Value>
</Value>
</Data>
<DataLocation>^BI.CusCodeD</DataLocation>
<DefaultData>CusCodeDefaultData</DefaultData>
<IdLocation>^BI.CusCodeD</IdLocation>
<IndexLocation>^BI.CusCodeI</IndexLocation>
<StreamLocation>^BI.CusCodeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
