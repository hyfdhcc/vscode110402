Class %BI.WordTemplate Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Name As %String;

Property Fldr As %String;

Property HeaderCode As %String(MAXLEN = 10000);

Property FooterCode As %String(MAXLEN = 10000);

Property CustHeaderCode As %String(MAXLEN = 10000);

Property CustFooterCode As %String(MAXLEN = 10000);

Property Description As %String(MAXLEN = 10000);

Query ByAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID,Name,Fldr FROM %BI.WordTemplate
	ORDER BY Name
}

Storage Default
{
<Data name="WordTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Fldr</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>FooterCode</Value>
</Value>
<Value name="5">
<Value>HeaderCode</Value>
</Value>
<Value name="6">
<Value>Desc</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>CustFooterCode</Value>
</Value>
<Value name="9">
<Value>CustHeaderCode</Value>
</Value>
</Data>
<DataLocation>^BI.WordTemplateD</DataLocation>
<DefaultData>WordTemplateDefaultData</DefaultData>
<IdLocation>^BI.WordTemplateD</IdLocation>
<IndexLocation>^BI.WordTemplateI</IndexLocation>
<StreamLocation>^BI.WordTemplateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
