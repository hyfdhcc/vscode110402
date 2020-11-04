Class %BI.DashBoard Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property AutoFind;

Index Folder On Folder As Exact;

Property BoardItems As array Of %BI.BoardObject;

Property BoardPicture As %GlobalBinaryStream;

Property Caption As %String(MAXLEN = 25000, TRUNCATE = 1);

Property Appearance As %Integer;

Property ImageID As %String(TRUNCATE = 1);

Property Style As %Integer;

Property PicturePos As %Integer;

Property BackColor As %String(TRUNCATE = 1);

Property NotActive As %Boolean;

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Property ImageName As %String(TRUNCATE = 1) [ Calculated ];

Property Folder As %String(TRUNCATE = 1);

Property Width As %String(TRUNCATE = 1);

Property Height As %String(TRUNCATE = 1);

Property SubjectAreaID As %String(TRUNCATE = 1);

Property DetailListID As %String(TRUNCATE = 1);

Method FolderNameGet() As %String
{
 q:..Folder="" ""
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

Method ImageNameGet() As %String
{
 quit $LG($G(^BI.ImageListD(+..ImageID)),1)
}

Property Remarks As %String(MAXLEN = 2000, TRUNCATE = 1);

Query ListAll(iUser As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Caption,Remarks,Folder
FROM %BI.DashBoard ORDER BY Caption
}

Query FolderAll(iFolder As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Caption
FROM %BI.DashBoard
WHERE Folder=:iFolder ORDER BY Caption
}

Query StrategyMapAll(iFolder As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Caption,Remarks,Folder
FROM %BI.DashBoard
/*WHERE StrategyMap=1 ORDER BY Caption*/
}

Storage Default
{
<Data name="BoardItems">
<Attribute>BoardItems</Attribute>
<Structure>subnode</Structure>
<Subscript>"I"</Subscript>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="DashBoardDefaultData">
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>Remarks</Value>
</Value>
<Value name="3">
<Value>Folder</Value>
</Value>
<Value name="4">
<Value>NotActive</Value>
</Value>
<Value name="5">
<Value>AutoFind</Value>
</Value>
<Value name="6">
<Value>Appearance</Value>
</Value>
<Value name="7">
<Value>BackColor</Value>
</Value>
<Value name="8">
<Value>Style</Value>
</Value>
<Value name="9">
<Value>PicturePos</Value>
</Value>
<Value name="10">
<Value>ImageID</Value>
</Value>
<Value name="11">
<Value>Height</Value>
</Value>
<Value name="12">
<Value>Width</Value>
</Value>
<Value name="13">
<Value>SubjectArea</Value>
</Value>
<Value name="14">
<Value>SubjectAreaID</Value>
</Value>
<Value name="15">
<Value>DetailListID</Value>
</Value>
<Value name="16">
<Value>StrategyMap</Value>
</Value>
</Data>
<Data name="Picture">
<Attribute>BoardPicture</Attribute>
<Structure>node</Structure>
<Subscript>"P"</Subscript>
</Data>
<DataLocation>^BI.DashBoardD</DataLocation>
<DefaultData>DashBoardDefaultData</DefaultData>
<IdLocation>^BI.DashBoardD</IdLocation>
<IndexLocation>^BI.DashBoardI</IndexLocation>
<StreamLocation>^BI.DashBoardS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
