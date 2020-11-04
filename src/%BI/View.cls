Class %BI.View Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Name As %String(TRUNCATE = 1);

Property Filter As %String(TRUNCATE = 1);

Property FolderID As %Integer;

Property IsStatic As %Boolean;

Query smView() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,Filter,FolderID,IsStatic FROM View
}

ClassMethod saveViewJS(vName, vFil, folderId, isStaticVal)
{
	; to save new view
	d saveViewJS^%bi.SWr.View(vName,vFil,folderId,isStaticVal)
}

ClassMethod editViewJS(vId, vName, vFil, folderId, isStaticVal)
{
	; to edit selected view
	d editViewJS^%bi.SWr.View(vId,vName,vFil,folderId,isStaticVal)
}

Storage Default
{
<Data name="ViewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Filter</Value>
</Value>
<Value name="3">
<Value>FolderID</Value>
</Value>
<Value name="4">
<Value>IsStatic</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^BI.ViewD</DataLocation>
<DefaultData>ViewDefaultData</DefaultData>
<IdLocation>^BI.ViewD</IdLocation>
<IndexLocation>^BI.ViewI</IndexLocation>
<StreamLocation>^BI.ViewS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
