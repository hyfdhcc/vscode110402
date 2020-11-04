Class %BI.Query Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property descr As %String(MAXLEN = 10000, TRUNCATE = 1);

Property fldr As %String(TRUNCATE = 1);

Property nm As %String(TRUNCATE = 1);

Property qry As %String(MAXLEN = 10000, TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,nm,fldr
	FROM %BI.Query
	ORDER BY nm
}

Query ListFolder(folder) As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,nm
	FROM %BI.Query
	WHERE (fldr = :folder)
	ORDER BY nm
}

Storage Default
{
<Data name="QueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
<Value name="3">
<Value>Query</Value>
</Value>
<Value name="4">
<Value>QueryName</Value>
</Value>
<Value name="5">
<Value>LastAccessed</Value>
</Value>
<Value name="6">
<Value>Accessed</Value>
</Value>
<Value name="7">
<Value>Descr</Value>
</Value>
<Value name="8">
<Value>User</Value>
</Value>
<Value name="9">
<Value>Users</Value>
</Value>
<Value name="10">
<Value>acc</Value>
</Value>
<Value name="11">
<Value>descr</Value>
</Value>
<Value name="12">
<Value>fldr</Value>
</Value>
<Value name="13">
<Value>nm</Value>
</Value>
<Value name="14">
<Value>qry</Value>
</Value>
<Value name="15">
<Value>users</Value>
</Value>
</Data>
<DataLocation>^BI.QueryD</DataLocation>
<DefaultData>QueryDefaultData</DefaultData>
<IdLocation>^BI.QueryD</IdLocation>
<IndexLocation>^BI.QueryI</IndexLocation>
<StreamLocation>^BI.QueryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
