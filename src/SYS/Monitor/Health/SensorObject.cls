Class SYS.Monitor.Health.SensorObject Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock, System = 3 ]
{

Index IDKEY On Sensor [ IdKey, PrimaryKey, Unique ];

Property Sensor As %String [ Required ];

Property Threshold As %String [ InitialExpression = 0 ];

Property AlertValue As %String [ InitialExpression = 0 ];

Property MaxMult As %String [ InitialExpression = 0 ];

Property WarnValue As %String [ InitialExpression = 0 ];

Property WarnMult As %String [ InitialExpression = 0 ];

/// Container Group
Relationship Charts As SYS.Monitor.Health.Chart [ Cardinality = many, Inverse = SensorObject ];

/// Set the Sensor properties.
/// WarnValue and WarnMult are optional. If present, there must also be a corresponding AlertValue or MaxMult
Method %OnNew(Sensor As %String, Threshold As %Integer = 0, MaxVal As %Integer = 0, MaxMult As %Integer = 0, WarnVal As %Integer = 0, WarnMult As %Integer = 0) As %Status
{
}

Method %OnValidateObject() As %Status
{
}

/// A list of all sensors
Query Sensors() As %SQLQuery(CONTAINID = 1)
{
SELECT Sensor,Threshold,AlertValue,MaxMult,WarnValue,WarnMult FROM SensorObject
}

/// A list of all sensors with a AlertValue defined
Query SensorsMaxVal() As %SQLQuery(CONTAINID = 1)
{
SELECT Sensor,AlertValue,WarnValue FROM SensorObject WHERE AlertValue <> 0
}

/// A list of sensors without AlertValue defined
Query SensorsNotMaxVal() As %SQLQuery(CONTAINID = 1)
{
SELECT Sensor,Threshold,MaxMult,WarnMult FROM SensorObject WHERE AlertValue = 0
}

Storage Default
{
<Data name="SensorObjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Threshold</Value>
</Value>
<Value name="3">
<Value>AlertValue</Value>
</Value>
<Value name="4">
<Value>MaxMult</Value>
</Value>
<Value name="5">
<Value>WarnValue</Value>
</Value>
<Value name="6">
<Value>WarnMult</Value>
</Value>
</Data>
<DataLocation>^ISC.Monitor.SensorObjectD</DataLocation>
<DefaultData>SensorObjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ISC.Monitor.SensorObjectD</IdLocation>
<IndexLocation>^ISC.Monitor.SensorObjectI</IndexLocation>
<StreamLocation>^ISC.Monitor.SensorObjectS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
