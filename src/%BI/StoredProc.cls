Class %BI.StoredProc Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property cls As %String(TRUNCATE = 1);

Property descr As %String(MAXLEN = 10000, TRUNCATE = 1);

Property fldr As %String(TRUNCATE = 1);

Property help As %String(TRUNCATE = 1);

Property nm As %String(TRUNCATE = 1);

Property param As %String(MAXLEN = 10000, TRUNCATE = 1);

Property proc As %String(TRUNCATE = 1);

Index Name On nm As Exact;

Query ListProc() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,nm,fldr
	FROM %BI.StoredProc
	ORDER BY nm
}

//Query ListProcFldr(rowid As %String) As %SQLQuery(CONTAINID = 1){	SELECT ID,nm,fldr	FROM %BI.StoredProc	ORDER BY nm //'WHERE fldr = :rowid [removed from ListProcFldr}

Query ListByFldr(fldr As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,nm FROM StoredProc
 WHERE (fldr = :fldr)
 ORDER BY nm
}

Query ListFolder(folder) As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,nm
	FROM %BI.StoredProc
	WHERE (fldr = :folder)
	ORDER BY nm
}

Storage Default
{
<Data name="StoredProcDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>cls</Value>
</Value>
<Value name="3">
<Value>descr</Value>
</Value>
<Value name="4">
<Value>fldr</Value>
</Value>
<Value name="5">
<Value>nm</Value>
</Value>
<Value name="6">
<Value>param</Value>
</Value>
<Value name="7">
<Value>proc</Value>
</Value>
<Value name="8">
<Value>help</Value>
</Value>
</Data>
<DataLocation>^BI.StoredProcD</DataLocation>
<DefaultData>StoredProcDefaultData</DefaultData>
<IdLocation>^BI.StoredProcD</IdLocation>
<IndexLocation>^BI.StoredProcI</IndexLocation>
<StreamLocation>^BI.StoredProcS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
