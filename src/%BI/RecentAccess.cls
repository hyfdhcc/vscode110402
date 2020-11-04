Class %BI.RecentAccess Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property accDate As %Date;

Property accTime As %Time;

Property objID As %String;

Property objType As %String;

Property userID As %Integer;

Index MainIndex On (userID, objType, objID) [ IdKey ];

Index DateTime On (userID, objType, accDate, accTime);

Storage Default
{
<Data name="RecentAccessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>accDate</Value>
</Value>
<Value name="3">
<Value>accTime</Value>
</Value>
</Data>
<DataLocation>^BI.RecentAccessD</DataLocation>
<DefaultData>RecentAccessDefaultData1</DefaultData>
<IdLocation>^BI.RecentAccessD</IdLocation>
<IndexLocation>^BI.RecentAccessI</IndexLocation>
<Property name="accDate"/>
<Property name="accTime"/>
<Property name="objID"/>
<Property name="objType"/>
<Property name="userID"/>
<StreamLocation>^BI.RecentAccessS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
