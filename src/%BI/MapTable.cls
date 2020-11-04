Class %BI.MapTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index MainIndex On (Type, Code) [ IdKey, Unique ];

Property Code As %String(TRUNCATE = 1);

Property Data As %List;

Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MapTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^BI.MapTableD</DataLocation>
<DefaultData>MapTableDefaultData</DefaultData>
<IdLocation>^BI.MapTableD</IdLocation>
<IndexLocation>^BI.MapTableI</IndexLocation>
<StreamLocation>^BI.MapTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
