Class %BI.FORMDESIGN Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Caption As %String;

Property Folder As %String;

Property Background As %String;

Property Height As %String;

Property Width As %String;

Property FormObject As array Of %BI.FORMOBJECT;

Storage Default
{
<Data name="FORMDESIGNDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Background</Value>
</Value>
<Value name="3">
<Value>Caption</Value>
</Value>
<Value name="4">
<Value>Folder</Value>
</Value>
<Value name="5">
<Value>Height</Value>
</Value>
<Value name="6">
<Value>Width</Value>
</Value>
</Data>
<Data name="FormObject">
<Attribute>FormObject</Attribute>
<Structure>subnode</Structure>
<Subscript>"FormObject"</Subscript>
</Data>
<DataLocation>^BI.FORMDESIGND</DataLocation>
<DefaultData>FORMDESIGNDefaultData</DefaultData>
<IdLocation>^BI.FORMDESIGND</IdLocation>
<IndexLocation>^BI.FORMDESIGNI</IndexLocation>
<StreamLocation>^BI.FORMDESIGNS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
