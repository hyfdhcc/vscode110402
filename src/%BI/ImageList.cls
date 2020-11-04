Class %BI.ImageList Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FileName As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Fl As %FileBinaryStream;

Index Folder On Folder As Exact;

Property ImageName As %String(TRUNCATE = 1);

Property LoadToMemory As %Boolean;

Property Picture As %GlobalBinaryStream;

Property Folder As %String(TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Query FileNameByImageId(iImageId As %Integer) As %SQLQuery
{
SELECT FileName FROM ImageList
 WHERE (%ID = :iImageId)
}

Method FolderNameGet() As %String
{
 if ..Folder="" q ""
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

Query FolderAll(iFolder As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,ImageName
FROM %BI.ImageList
WHERE Folder=:iFolder
ORDER BY ImageName
}

ClassMethod getImgPath(img)
{
	; added by Chun Eng on 30/6/2005
	; to retrieve the images' logical path
	s path = $$getPicture^%bi.SWr.WebReporter(img)
	q path
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,ImageName,Folder
FROM %BI.ImageList ORDER BY ImageName
}

Query ListFile() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,ImageName,Folder
FROM %BI.ImageList
WHERE NOT FileName=""
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="ImageListDefaultData">
<Value name="1">
<Value>ImageName</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
<Value name="3">
<Value>LoadToMemory</Value>
</Value>
<Value name="4">
<Value>Picture</Value>
</Value>
<Value name="5">
<Value>FileName</Value>
</Value>
<Value name="6">
<Value>Fl</Value>
</Value>
</Data>
<DataLocation>^BI.ImageListD</DataLocation>
<DefaultData>ImageListDefaultData</DefaultData>
<IdLocation>^BI.ImageListD</IdLocation>
<IndexLocation>^BI.ImageListI</IndexLocation>
<StreamLocation>^BI.ImageListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
