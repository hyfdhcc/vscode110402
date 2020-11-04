Class %BI.CodeTableEnc Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Category As %String;

Property Group As %String;

Property Column As %String;

Property Description As %String;

Index MainIndex On (Category, Group, Column) [ IdKey, Unique ];

Storage Default
{
<Data name="CodeTableEncDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Column</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^BI.CodeTableEncD</DataLocation>
<DefaultData>CodeTableEncDefaultData</DefaultData>
<IdLocation>^BI.CodeTableEncD</IdLocation>
<IndexLocation>^BI.CodeTableEncI</IndexLocation>
<StreamLocation>^BI.CodeTableEncS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
