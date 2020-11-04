Class %BI.PopUp Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DetListId As %String(TRUNCATE = 1);

Property PopCon As array Of %BI.PopUpCon;

Index DList On DetListId As Exact;

Storage Default
{
<Data name="PopCon">
<Attribute>PopCon</Attribute>
<Structure>subnode</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="PopUpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetListId</Value>
</Value>
</Data>
<DataLocation>^BI.PopUpD</DataLocation>
<DefaultData>PopUpDefaultData</DefaultData>
<IdLocation>^BI.PopUpD</IdLocation>
<IndexLocation>^BI.PopUpI</IndexLocation>
<StreamLocation>^BI.PopUpS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
