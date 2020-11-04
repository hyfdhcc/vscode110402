Class SYS.Monitor.Alert Extends %Persistent [ ClassType = persistent, ProcedureBlock, System = 3 ]
{

/// Name of sensor
Property Sensor As %String(MAXLEN = 250);

/// Alert message
Property Msg As %String(MAXLEN = 250);

/// Previous state
Property PrevState As %Integer [ Required ];

/// Current state
Property State As %Integer [ Required ];

/// Date/Time of Alert
Property AlertTime As %String [ Required ];

/// Purge old alerts, up to specified date/time. Date/time is in $zdt($h,3) format.
ClassMethod Purge(Time As %String) As %Status [ Internal ]
{
}

/// Return the alerts between current state, and previous green state
Query HealthState() As %SQLQuery(CONTAINID = 1)
{
	SELECT *
	FROM Alert
	WHERE AlertTime >= (SELECT MAX(AlertTime) FROM Alert WHERE PrevState = 0)
}

/// Return the alerts for a given date/time range. Date/time is in $zdt($h,3) format.
Query Alerts(BeginTime As %String, EndTime As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT *
	FROM Alert
	WHERE AlertTime BETWEEN :BeginTime AND :EndTime
}

/// Return the alert(s) for a given sensor, for a given date/time range. Date/time is in $zdt($h,3) format.
Query AlertsBySensor(BeginTime As %String, EndTime As %String, Sensor As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT *
	FROM Alert
	WHERE AlertTime BETWEEN :BeginTime AND :EndTime
		AND Sensor = :Sensor
}

Storage Default
{
<Data name="AlertDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Sensor</Value>
</Value>
<Value name="3">
<Value>Item</Value>
</Value>
<Value name="4">
<Value>Rulecode</Value>
</Value>
<Value name="5">
<Value>Severity</Value>
</Value>
<Value name="6">
<Value>Values</Value>
</Value>
<Value name="7">
<Value>Readings</Value>
</Value>
<Value name="8">
<Value>Mean</Value>
</Value>
<Value name="9">
<Value>Sigma</Value>
</Value>
<Value name="10">
<Value>AlertTime</Value>
</Value>
<Value name="11">
<Value>Value</Value>
</Value>
<Value name="12">
<Value>PrevState</Value>
</Value>
<Value name="13">
<Value>State</Value>
</Value>
<Value name="14">
<Value>AlertTime</Value>
</Value>
<Value name="15">
<Value>FirstAlertTime</Value>
</Value>
<Value name="16">
<Value>Msg</Value>
</Value>
</Data>
<DataLocation>^ISC.Monitor.AlertD</DataLocation>
<DefaultData>AlertDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ISC.Monitor.AlertD</IdLocation>
<IndexLocation>^ISC.Monitor.AlertI</IndexLocation>
<StreamLocation>^ISC.Monitor.AlertS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
