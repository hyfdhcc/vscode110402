Class %BI.TextList Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Folder On Folder As Exact;

Property TextName As %String(TRUNCATE = 1);

Property Text As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Folder As %String(TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Method FolderNameGet() As %String
{
 if ..Folder="" q ""
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

Query FolderAll(iFolder As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TextName
FROM %BI.TextList
WHERE Folder=:iFolder
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TextName,Folder
FROM %BI.TextList
}

Storage Default
{
<Data name="TextListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
<Value name="4">
<Value>TextName</Value>
</Value>
</Data>
<DataLocation>^BI.TextListD</DataLocation>
<DefaultData>TextListDefaultData</DefaultData>
<IdLocation>^BI.TextListD</IdLocation>
<IndexLocation>^BI.TextListI</IndexLocation>
<StreamLocation>^BI.TextListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
