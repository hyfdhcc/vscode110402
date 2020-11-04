Class %BI.Shortcut Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property folder As %Integer;

Property name As %String;

Property objType As %Integer;

Property objID As %Integer;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT objID,name,folder,ID
	FROM %BI.Shortcut
}

Query ListByType(type) As %SQLQuery(CONTAINID = 1)
{
	SELECT objID,name,folder,ID
	FROM %BI.Shortcut
	WHERE (objType=:type)
	ORDER BY name
}

Query ListTypeFolder(Type As %String, Folder As %String) As %SQLQuery(CONTAINID = 3)
{
SELECT objID,name,ID FROM Shortcut
 WHERE (folder = :Folder AND objType = :Type)
 ORDER BY name
}

Storage Default
{
<Data name="ShortcutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>folder</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
<Value name="4">
<Value>objID</Value>
</Value>
<Value name="5">
<Value>objType</Value>
</Value>
</Data>
<DataLocation>^BI.ShortcutD</DataLocation>
<DefaultData>ShortcutDefaultData</DefaultData>
<IdLocation>^BI.ShortcutD</IdLocation>
<IndexLocation>^BI.ShortcutI</IndexLocation>
<StreamLocation>^BI.ShortcutS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
