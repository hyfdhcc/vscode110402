Class %BI.Presenter Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Folder On Folder As Exact;

Property Caption As %String(TRUNCATE = 1);

Property Folder As %String(TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Property Slides As array Of %BI.DashBoardItem;

Method FolderNameGet() As %String
{
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

Query ListAll(iUser As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Caption,Folder
FROM %BI.Presenter
}

Query FolderAll(iFolder As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Caption
FROM %BI.Presenter
WHERE Folder=:iFolder
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="PresenterDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
</Data>
<Data name="Slides">
<Attribute>Slides</Attribute>
<Structure>subnode</Structure>
<Subscript>"S"</Subscript>
</Data>
<DataLocation>^BI.PresenterD</DataLocation>
<DefaultData>PresenterDefaultData</DefaultData>
<IdLocation>^BI.PresenterD</IdLocation>
<IndexLocation>^BI.PresenterI</IndexLocation>
<StreamLocation>^BI.PresenterS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
