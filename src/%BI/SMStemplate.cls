Class %BI.SMStemplate Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/* The content/description of the particular SMS template */
Property tName As %String(TRUNCATE = 1);

Property tDesc As %String(MAXLEN = 1000, TRUNCATE = 1);

Property FolderId As %String(MAXLEN = 50, TRUNCATE = 1);

Query All() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,tName,FolderId,tDesc FROM SMStemplate
ORDER BY tName
}

Storage Default
{
<Data name="SMStemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>tName</Value>
</Value>
<Value name="3">
<Value>tDesc</Value>
</Value>
<Value name="4">
<Value>FolderId</Value>
</Value>
</Data>
<DataLocation>^BI.SMStemplateD</DataLocation>
<DefaultData>SMStemplateDefaultData</DefaultData>
<IdLocation>^BI.SMStemplateD</IdLocation>
<IndexLocation>^BI.SMStemplateI</IndexLocation>
<StreamLocation>^BI.SMStemplateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

Storage StorageSQL
{
<Type>%CacheSQLStorage</Type>
}

}
