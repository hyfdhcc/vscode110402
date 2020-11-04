Class %WebStress.Playback.Status Extends (%Persistent, %XML.Adaptor) [ Owner = {%Developer}, System = 4 ]
{

/// Status of this process
Property Status As %Integer;

/// Description of the current status
Property StatusText As %String;

/// The process ID
Property ProcessID As %String;

// The Test ID

Property TestID As %Integer;

// The Run ID

Property RunID As %Integer;

// The script

Property Script As %String;

// System ID so that it's unique across generators

Property SystemID As %String(MAXLEN = "");

Index Main On (SystemID, ProcessID) [ IdKey, PrimaryKey, Unique ];

Storage Default
{
<Data name="StatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>StatusText</Value>
</Value>
<Value name="4">
<Value>TestID</Value>
</Value>
<Value name="5">
<Value>RunID</Value>
</Value>
<Value name="6">
<Value>Script</Value>
</Value>
</Data>
<DataLocation>^WebStress.Playback.StatusD</DataLocation>
<DefaultData>StatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^WebStress.Playback.StatusD</IdLocation>
<IndexLocation>^WebStress.Playback.StatusI</IndexLocation>
<StreamLocation>^WebStress.Playback.StatusS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
