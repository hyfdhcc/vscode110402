Class %BI.Printer Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Data As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Title As %String(TRUNCATE = 1);

Property FolderId As %String(MAXLEN = 50, TRUNCATE = 1);

Property ControlSeq As %String(MAXLEN = 20000, TRUNCATE = 1);

Property ClassName As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Loop As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Checkbox As %String(MAXLEN = 20000, TRUNCATE = 1);

Query All() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Title,FolderId FROM Printer
ORDER BY Title
}

Storage Default
{
<Data name="PrinterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>FolderId</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Data</Value>
</Value>
<Value name="6">
<Value>ControlSeq</Value>
</Value>
<Value name="7">
<Value>Loop</Value>
</Value>
<Value name="8">
<Value>Checkbox</Value>
</Value>
<Value name="9">
<Value>ClassName</Value>
</Value>
<Value name="10">
<Value>JSExe</Value>
</Value>
</Data>
<DataLocation>^BI.PrinterD</DataLocation>
<DefaultData>PrinterDefaultData</DefaultData>
<Final>1</Final>
<IdLocation>^BI.PrinterD</IdLocation>
<IndexLocation>^BI.PrinterI</IndexLocation>
<StreamLocation>^BI.PrinterS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
