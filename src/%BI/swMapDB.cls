Class %BI.swMapDB Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
		Author : Steven :P
		Purpose: Table holds all pieces of maps only (not points)
		Created: 23.06.2005
		Updated: 13.09.2005 Steven

       Name:Map Name
Description:Small explanation
    MapRef:Map Reference number-this number link to a map file
 FolderRef:A number for grouping maps to a folder
 
 --------------- Group Map --------------
       Name:Map Name
Description:Small explanation
  TotalRow:GridRow
  TotalCol:GridCol
GridHeight:Height(px)
 GridWidth:Width(px)

 --------------- Used by Group Map --------------
  GroupPID:Map belonging to a group
  GroupRow:GridRow
  GroupCol:GridCol
*/
Property MapType As %String(MAXLEN = 1, TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

Property MapRef As %String(TRUNCATE = 1);

//current map

Property FolderRef As %String(TRUNCATE = 1);

Property TotalRow As %Integer;

Property TotalCol As %Integer;

Property GridHeight As %Integer;

Property GridWidth As %Integer;

Property GroupPID As %Integer;

Property GroupRow As %Integer;

Property GroupCol As %Integer;

Property MapLink As %String(TRUNCATE = 1);

//level in map

Query ListAll(iUser As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Name,Description,FolderRef
FROM %BI.swMapDB
ORDER BY Name
}

Property StartMap As %Boolean;

Query ListFolder(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Name
FROM %BI.swMapDB
WHERE (FolderRef = :folder)
ORDER BY Name
}

Storage Default
{
<Data name="swMapDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>FolderRef</Value>
</Value>
<Value name="4">
<Value>GridHeight</Value>
</Value>
<Value name="5">
<Value>GridWidth</Value>
</Value>
<Value name="6">
<Value>GroupCol</Value>
</Value>
<Value name="7">
<Value>GroupPID</Value>
</Value>
<Value name="8">
<Value>GroupRow</Value>
</Value>
<Value name="9">
<Value>MapRef</Value>
</Value>
<Value name="10">
<Value>Name</Value>
</Value>
<Value name="11">
<Value>TotalCol</Value>
</Value>
<Value name="12">
<Value>TotalRow</Value>
</Value>
<Value name="13">
<Value>MapType</Value>
</Value>
<Value name="14">
<Value>MapRef2</Value>
</Value>
<Value name="15">
<Value>MapLink</Value>
</Value>
<Value name="16">
<Value>StartMap</Value>
</Value>
<Value name="17">
<Value>iOHeight</Value>
</Value>
<Value name="18">
<Value>iOWidth</Value>
</Value>
</Data>
<DataLocation>^BI.swMapDBD</DataLocation>
<DefaultData>swMapDBDefaultData</DefaultData>
<IdLocation>^BI.swMapDBD</IdLocation>
<IndexLocation>^BI.swMapDBI</IndexLocation>
<StreamLocation>^BI.swMapDBS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
