Class %BI.SpeedTrakMap Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property SpeedUsr As %Integer;

Property TrakUsr As %Integer;

Property Type As %String(TRUNCATE = 1);

Index MapIndex On (Type, TrakUsr);

Storage Default
{
<Data name="SpeedTrakMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpeedUsr</Value>
</Value>
<Value name="3">
<Value>TrakUsr</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Seq</Value>
</Value>
</Data>
<DataLocation>^BI.SpeedTrakMapD</DataLocation>
<DefaultData>SpeedTrakMapDefaultData</DefaultData>
<IdLocation>^BI.SpeedTrakMapD</IdLocation>
<IndexLocation>^BI.SpeedTrakMapI</IndexLocation>
<StreamLocation>^BI.SpeedTrakMapS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
