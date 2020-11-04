Class %BI.Template Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DashID As %String(TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1);

Property FolderID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TempObj As array Of %BI.TemplateObject;

Query QAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,FolderID FROM Template
}

Storage Default
{
<Data name="ClassName">
<Subscript>"X"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="TempObj">
<Attribute>TempObj</Attribute>
<Structure>subnode</Structure>
<Subscript>"T"</Subscript>
</Data>
<Data name="TemplateDefaultData">
<Value name="1">
<Value>DashID</Value>
</Value>
<Value name="2">
<Value>FolderID</Value>
</Value>
<Value name="3">
<Value>FolderName</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>TemplateID</Value>
</Value>
</Data>
<DataLocation>^BI.TemplateD</DataLocation>
<DefaultData>TemplateDefaultData</DefaultData>
<IdLocation>^BI.TemplateD</IdLocation>
<IndexLocation>^BI.TemplateI</IndexLocation>
<StreamLocation>^BI.TemplateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

Storage StorageSQL
{
<Type>%CacheSQLStorage</Type>
}

}
