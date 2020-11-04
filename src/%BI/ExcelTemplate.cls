Class %BI.ExcelTemplate Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property HeaderCode As %String(MAXLEN = 10000);

Property FooterCode As %String(MAXLEN = 10000);

Property CustHeaderCode As %String(MAXLEN = 10000);

Property CustFooterCode As %String(MAXLEN = 10000);

Property Name As %String;

Property Fldr As %String;

Property Description As %String(MAXLEN = 10000);

Query ByAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID,Name,Fldr FROM %BI.ExcelTemplate
	ORDER BY Name
}

Storage Default
{
<Data name="ExcelTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FooterCode</Value>
</Value>
<Value name="3">
<Value>HeaderCode</Value>
</Value>
<Value name="4">
<Value>Fldr</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Style</Value>
</Value>
<Value name="7">
<Value>Desc</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
<Value name="9">
<Value>CustFooterCode</Value>
</Value>
<Value name="10">
<Value>CustHeaderCode</Value>
</Value>
</Data>
<DataLocation>^BI.ExcelTemplateD</DataLocation>
<DefaultData>ExcelTemplateDefaultData</DefaultData>
<IdLocation>^BI.ExcelTemplateD</IdLocation>
<IndexLocation>^BI.ExcelTemplateI</IndexLocation>
<StreamLocation>^BI.ExcelTemplateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
