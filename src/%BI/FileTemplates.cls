Class %BI.FileTemplates Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(MAXLEN = 5000, TRUNCATE = 1);

Property ExcelOmitCol As %String(TRUNCATE = 1);

Property ExcelStartLine As %SmallInt;

Property FileName As %String(MAXLEN = 5000, TRUNCATE = 1);

Property DataSheetIndex As %Integer;

Property ChartSheetIndex As %Integer;

Property ChartTop As %Integer;

Property ChartLeft As %Integer;

Property ChartWidth As %Integer;

Property ChartHeight As %Integer;

Query byType(iType As %SmallInt) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TemplateName FROM FileTemplates
 WHERE (TemplateType = :iType) AND (IsActive=1)
}

Query AllTemplates() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TemplateName,FileName,%External(TemplateType),IsActive FROM FileTemplates
}

Property TemplateName As %String(MAXLEN = 5000, TRUNCATE = 1);

Property TemplateType As %String(DISPLAYLIST = ",MS Excel,MS Word,HTML", TRUNCATE = 1, VALUELIST = ",0,1,2");

Property IsActive As %Boolean;

Property ExcellExportHeader As %Boolean;

Property ChartShow As %Boolean;

Storage Default
{
<Data name="FileTemplatesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>TemplateName</Value>
</Value>
<Value name="5">
<Value>TemplateType</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>ExcelOmitCol</Value>
</Value>
<Value name="8">
<Value>ExcelStartLine</Value>
</Value>
<Value name="9">
<Value>ExcellExportHeader</Value>
</Value>
<Value name="10">
<Value>ChartHeight</Value>
</Value>
<Value name="11">
<Value>ChartLeft</Value>
</Value>
<Value name="12">
<Value>ChartSheetIndex</Value>
</Value>
<Value name="13">
<Value>ChartTop</Value>
</Value>
<Value name="14">
<Value>ChartWidth</Value>
</Value>
<Value name="15">
<Value>DataSheetIndex</Value>
</Value>
<Value name="16">
<Value>ChartShow</Value>
</Value>
</Data>
<DataLocation>^BI.FileTemplatesD</DataLocation>
<DefaultData>FileTemplatesDefaultData</DefaultData>
<IdLocation>^BI.FileTemplatesD</IdLocation>
<IndexLocation>^BI.FileTemplatesI</IndexLocation>
<StreamLocation>^BI.FileTemplatesS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
