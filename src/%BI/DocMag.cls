Class %BI.DocMag Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FileName As %String(TRUNCATE = 1);

Property FileType As %Integer;

Property Folder As %String(TRUNCATE = 1);

Property DateNTime As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property DocHtml As %String(TRUNCATE = 1);

Property DocLink As %String(MAXLEN = 100, TRUNCATE = 1);

Property FileNum As %String(TRUNCATE = 1);

Property TableOfCon As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,FileName,Description,Folder,FileNum
FROM DocMag ORDER BY FileName
}

Query ListFolder(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,FileName
FROM DocMag 
WHERE (Folder = :folder)
ORDER BY FileName
}

Storage Default
{
<Data name="DocMagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateNTime</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>Folder</Value>
</Value>
<Value name="6">
<Value>FileNum</Value>
</Value>
<Value name="7">
<Value>FileN</Value>
</Value>
<Value name="8">
<Value>FileType</Value>
</Value>
<Value name="9">
<Value>DocHtml</Value>
</Value>
<Value name="10">
<Value>DocLink</Value>
</Value>
<Value name="11">
<Value>TableOfCon</Value>
</Value>
</Data>
<DataLocation>^BI.DocMagD</DataLocation>
<DefaultData>DocMagDefaultData</DefaultData>
<IdLocation>^BI.DocMagD</IdLocation>
<IndexLocation>^BI.DocMagI</IndexLocation>
<StreamLocation>^BI.DocMagS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
