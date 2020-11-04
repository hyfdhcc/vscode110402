Include (%syMonitor, %syPidtab, %sySystem, %occErrors)

/// Monitor Class definition
Class SYS.Monitor.Health.Period Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock, System = 3 ]
{

/// Recurrance:
/// 	every day at (start/end),
/// 		every week on day (default)
/// 		every month on day of month or "last day of month"
/// 	every 3 months (quarterly) on day of month or "last day of month"
/// 	every year on month and day of month or "last day of month"
/// Description of the interval
Property Description As %String(MAXLEN = 250);

/// Start time
Property StartTime As %Integer [ InitialExpression = -1, Required ];

/// End time
Property EndTime As %Integer [ InitialExpression = -1, Required ];

/// Recurrence - weekly-1, monthly-2, quarterly-3, yearly-4
Property Recurrence As %Integer [ InitialExpression = 1, Required ];

/// Day. 1-7 for weekly, 1-31 or 99 for others
Property Day As %Integer [ InitialExpression = 0, Required ];

/// Month - Quarterly or yearly
Property Month As %String [ InitialExpression = 0, Required ];

/// Set the interval properties
Method %OnNew(rec As %Integer, day As %Integer, month As %Integer, start As %Integer, end As %Integer, desc As %String) As %Status [ Private ]
{
}

/// Create a Period. Start and End time is 24-hour time format.
/// Recurrence - weekly-1, monthly-2, quarterly-3, yearly-4
/// Day = day of week (1-7) for weekly recurrence, day of month (1-31 or 99 for "end of month") for all other recurrence.
ClassMethod Create(Rec As %Integer, Start As %String, End As %String, Day As %Integer, Desc As %String = "", Month As %Integer = 0) As %Status
{
}

/// Modify a Period.
ClassMethod Modify(Period As %Integer, Start As %String = "", End As %String = "", Day As %Integer = 0, Rec As %Integer = 0, Desc As %String = "", Month As %Integer = 0) As %Status
{
}

ClassMethod Validate(Start As %String, End As %String, Rec As %Integer, Day As %Integer, Month As %Integer, ByRef startsecs As %Integer, ByRef endsecs As %Integer) As %Status
{
}

/// Delete a Period
ClassMethod Delete(PeriodId As %String) As %Status
{
}

Query TodayPeriods() As %Query(ROWSPEC = "Start:%Integer,End:%Integer,ID:%String,Description:%String")
{
}

ClassMethod TodayPeriodsExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod TodayPeriodsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TodayPeriodsExecute ]
{
}

ClassMethod TodayPeriodsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TodayPeriodsExecute ]
{
}

/// Get all periods for day - weekly recurrence
Query WPeriods(day As %Integer) As %SQLQuery(CONTAINID = 1)
{
SELECT StartTime,EndTime,%ID FROM Period  WHERE (Recurrence = 1) AND (Day = :day) ORDER BY StartTime
}

/// Get all periods for day - Monthly recurrence
Query MPeriods(day As %Integer) As %SQLQuery(CONTAINID = 1)
{
SELECT StartTime,EndTime,%ID FROM Period  WHERE (Recurrence = 2) AND (Day = :day) ORDER BY StartTime
}

/// Get all periods for day - quarterly recurrence
Query QPeriods(day As %Integer, month As %Integer) As %SQLQuery(CONTAINID = 1)
{
SELECT StartTime,EndTime,%ID FROM Period  WHERE (Recurrence = 3) AND ((Day = :day)AND(Month = :month)) ORDER BY StartTime
}

/// Get all periods for day - yearly recurrence
Query YPeriods(day As %Integer, month As %Integer) As %SQLQuery(CONTAINID = 1)
{
SELECT StartTime,EndTime,%ID FROM Period  WHERE (Recurrence = 4) AND ((Day = :day)AND(Month = :month)) ORDER BY StartTime
}

/// Get period descriptions, order by Recurrence
Query PeriodDescriptions() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM Period ORDER BY Recurrence,Month,Day,StartTime
}

/// Get period descriptions by Day
Query PeriodDescriptionsDay(day As %Integer) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM Period  WHERE (Day = :day) ORDER BY Day,StartTime
}

/// Get period descriptions, order by ID
Query PeriodDescriptionsID() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM Period ORDER BY %ID
}

Storage Default
{
<Data name="PeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>Days</Value>
</Value>
<Value name="6">
<Value>DayWeek</Value>
</Value>
<Value name="7">
<Value>DayMonth</Value>
</Value>
<Value name="8">
<Value>Recurrence</Value>
</Value>
<Value name="9">
<Value>DayofWeek</Value>
</Value>
<Value name="10">
<Value>DayofMonth</Value>
</Value>
<Value name="11">
<Value>MonthandDay</Value>
</Value>
<Value name="12">
<Value>Day</Value>
</Value>
<Value name="13">
<Value>Month</Value>
</Value>
<Value name="14">
<Value>Group</Value>
</Value>
</Data>
<DataLocation>^ISC.Monitor.Health.PeriodD</DataLocation>
<DefaultData>PeriodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ISC.Monitor.Health.PeriodD</IdLocation>
<IndexLocation>^ISC.Monitor.Health.PeriodI</IndexLocation>
<StreamLocation>^ISC.Monitor.Health.PeriodS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
