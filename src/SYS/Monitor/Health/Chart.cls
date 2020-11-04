Include (%syMonitor, %syPidtab, %sySystem, %occErrors)

/// Monitor Class definition
Class SYS.Monitor.Health.Chart Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock, System = 3 ]
{

Index IDKEY On (PeriodID, Sensor, SensorItem) [ IdKey, PrimaryKey, Unique ];

/// Owner Period
Property PeriodID As %String [ Required ];

/// Sensor name
Property Sensor As %String(MAXLEN = 250) [ Required ];

/// Sensor item
Property SensorItem As %String(MAXLEN = 250) [ Required ];

/// Sensor mean
Property Mean As %String;

/// Sensor standard deviation (sigma)
Property Sigma As %String;

/// Sensor High Value. The highest value during the Period
Property HighValue As %String [ InitialExpression = 0, Required ];

/// Sensor Warn Value. An adjusted warning value based on High Value
Property WarnValue As %String [ InitialExpression = 0, Required ];

/// Sensor Alert Value. The value which will trigger an Alert.<p>
/// Computed based on Sensor Object and runtime statistics.
Property AlertValue As %String [ Calculated ];

/// Sensor Warning Value. The value which will trigger a warning.<p>
/// Computed based on Sensor Object and runtime statistics.
Property WarningValue As %String [ Calculated ];

/// Sensor readings
Property Readings As %List;

/// Version
Property Version As %String(MAXLEN = 250) [ Required ];

/// Sensor mean samples
Property SampleMeans As %List;

/// Sensor readings samples
Property SampleReadings As %List;

/// Columns for this table
Relationship SensorObject As SYS.Monitor.Health.SensorObject [ Cardinality = one, Inverse = Charts ];

/// Set chart statistics based on list of values
ClassMethod SetChartStats(pID As %String, sensor As %String, readings As %List, item As %String = "-", highvalue As %String = 0, warnvalue As %String = 0) As %Status
{
}

/// Create a chart for a Period ID, sensor, and list of readings
ClassMethod CreateChart(pID As %String, sensor As %String, mean As %Numeric = "", sigma As %Numeric = "", readings As %List = "", item As %String = "-", high As %String = "", warn As %String = "") As %Status
{
}

/// Set the Chart properties
Method %OnNew(pID As %String, sensor As %String, sensoritem As %String = "-", mean As %String, sigma As %String, readings As %List = "", highvalue As %String, warnvalue As %String, version As %String = "USER CHART") As %Status [ Private ]
{
}

/// returns Alert value
Method AlertValueGet() As %String
{
}

/// returns Warning value
Method WarningValueGet() As %String
{
}

/// A list of all charts for a period
Query ChartsByPeriod(period As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT Sensor,SensorItem,Mean,Sigma,%ID,Version FROM Chart WHERE (PeriodID = :period)
}

/// A list of all charts for a sensor
Query ChartsBySensor(sensor As %String) As %SQLQuery
{
SELECT PeriodID,Sensor,SensorItem,Mean,Sigma,%ID FROM Chart WHERE (Sensor = :sensor)
}

/// A list of all charts for a sensor / item
Query ChartsBySensorItem(sensor As %String, sensoritem As %String) As %SQLQuery
{
SELECT PeriodID,Sensor,SensorItem,Mean,Sigma,%ID FROM Chart WHERE (Sensor = :sensor) AND (SensorItem = :sensoritem)
}

/// A list of all charts for a period and sensor
Query ChartsByPeriodSensor(period As %String, sensor As %String) As %SQLQuery
{
SELECT PeriodID,Sensor,SensorItem,Mean,Sigma,%ID FROM Chart WHERE (Sensor = :sensor) AND (PeriodID = :period)
}

/// A list of all charts for a period, sensor, and sensor item
Query ChartsByPeriodSensorItem(period As %String, sensor As %String, sensoritem As %String) As %SQLQuery
{
SELECT PeriodID,Sensor,SensorItem,Mean,Sigma,%ID FROM Chart WHERE (Sensor = :sensor) AND (PeriodID = :period) AND (SensorItem = :sensoritem)
}

/// A list of all charts
Query Charts() As %SQLQuery
{
SELECT PeriodID,Sensor,SensorItem,Mean,Sigma,Version,%ID FROM Chart
}

/// A list of all charts for a version
Query ChartsByVersion(ver As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID FROM Chart WHERE (Version = :ver)
}

Storage Default
{
<Data name="ChartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Sensor</Value>
</Value>
<Value name="3">
<Value>Mean</Value>
</Value>
<Value name="4">
<Value>Sigma</Value>
</Value>
<Value name="5">
<Value>Readings</Value>
</Value>
<Value name="6">
<Value>PeriodID</Value>
</Value>
<Value name="7">
<Value>SystemType</Value>
</Value>
<Value name="8">
<Value>Version</Value>
</Value>
<Value name="9">
<Value>SampleMeans</Value>
</Value>
<Value name="10">
<Value>SampleReadings</Value>
</Value>
<Value name="11">
<Value>Adjustable</Value>
</Value>
<Value name="12">
<Value>Means</Value>
</Value>
<Value name="13">
<Value>HighValue</Value>
</Value>
<Value name="14">
<Value>SensorClass</Value>
</Value>
<Value name="15">
<Value>SensorItem</Value>
</Value>
<Value name="16">
<Value>AlertValue</Value>
</Value>
<Value name="17">
<Value>SensorObject</Value>
</Value>
<Value name="18">
<Value>WarnValue</Value>
</Value>
</Data>
<DataLocation>^ISC.Monitor.Health.ChartD</DataLocation>
<DefaultData>ChartDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ISC.Monitor.Health.ChartD</IdLocation>
<IndexLocation>^ISC.Monitor.Health.ChartI</IndexLocation>
<StreamLocation>^%Monitor.Health.ChartS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
