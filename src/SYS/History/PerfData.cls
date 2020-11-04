Include (%sySite, MONEXT)

/// Basic detail collection class of Performance metrics for the Monitor History database.
/// Properties represent metrics which get collected every few seconds by the %MONAPP 
/// Application Monitor process when the %Monitor.System.HistoryPerf class is "active".
/// The values stored for most properties are deltas calculated from the last interval.
Class SYS.History.PerfData Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// Time of sample
Property DateTime As %TimeStamp [ SqlColumnNumber = 2 ];

/// Length of sample in seconds
Property Length As %Integer;

/// UTC date key
Property ZDATE As %Integer;

/// UTC time key
Property ZTIME As %Integer;

/// Performance metrics
Property Perf As SYS.History.Performance;

/// WriteDaemon metrics
Property WD As array Of SYS.History.WriteDaemon;

Index ZDTindex On (ZDATE, ZTIME) [ IdKey ];

/// Instantiate the class and fetch current values for all metric properties.
ClassMethod Sample() As SYS.History.PerfData
{
}

/// Purge PerfData interval data, keeping the last 'Keep' days. This is typically called at
/// the start of each day from the %Monitor.System.HistoryPerf class, using the current
/// system default for 'Keep' (see the SetPurge() method). The 'Keep' argument allows 
/// you to over ride the system default (a value of "0" or "" uses the system default)
/// <br><br>
/// Returns the number of entries purged.
ClassMethod Purge(Keep As %Integer = 0) As %Integer
{
}

/// Set the system parameter for the number of days of detail data to keep. 
/// Initial system default is 7 days. Return value is the previous setting, and executing
/// this method with a "" argument will return the current setting without modifying it.
ClassMethod SetPurge(Keep As %Integer = "") As %Integer
{
}

/// Export PerfData data for time range in CSV format. The default is all of the data 
/// currently in the PerfData class. Note that Write Daemon cycle properties are exported
/// as the high-water mark for the cycles during an interval.
/// <br><br>
/// The default FileName is HistoryPerf_config_date_time.csv in the MGR directory. 
/// <br>
/// 'Start' and 'End' times (if necessary) are in YYYY-MM-DD HH:MM:SS format.
ClassMethod Export(FileName As %String, Start As %TimeStamp, End As %TimeStamp) As %Status
{
}

/// Collect summaries of the PerfData metrics for a day into the Hourly/Daily database.
/// This is typically done automatically by %Monitor.System.HistoryPerf at the
/// beginning of each day (for the previous day), but could be called manually 
/// if there's a problem.
/// <br><br>
/// The 'Day' argument sets the end date of the collection, with the default
/// of "0" being the start of today (i.e. $H+Day), which would collect everything for 
/// yesterday. A "-1" would collect the day before yesterday; a "1" would collect
/// today (as much as there is).
ClassMethod Summary(Day As %Integer = 0) As %Status
{
}

/// Build a demo database for the Perf metrics. 'Days' is the number of days of history to generate.
ClassMethod Demo(Days As %Integer = 30) As %Status [ Internal ]
{
}

/// Instantiate the class and fetch values for all metric properties.
/// This fills in semi-random values from a base value for each metric for a demo database.
/// 'pct' is a percentage value used to modify (+ or -) the base values.
/// 'dt' is date,time of sampel in $H format
/// Values for Perf metrics are per-second rates.
ClassMethod DemoSample(pct As %Integer, dt As %String) As SYS.History.PerfData [ Internal ]
{
}

/// Full listing of PerfData metrics for a day or range of date/times. Default is today.
Query DateList(Start As %TimeStamp = {$zdt(+$h,3)}, End As %TimeStamp = {$zdt($h+1,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT * FROM PerfData
 WHERE (DateTime >= :Start AND DateTime <= :End)
}

/// Full listing of WriteDaemon PerfData metrics for a day or range of date/times. Default is today.
Query WDDateList(Start As %TimeStamp = {$zdt(+$h,3)}, End As %TimeStamp = {$zdt($h+1,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,PerfData_WD.* FROM PerfData,PerfData_WD
 WHERE ((PerfData_WD.PerfData = PerfData.ID) AND (DateTime >= :Start) AND (DateTime <= :End))
}

Storage Default
{
<Data name="DetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateTime</Value>
</Value>
<Value name="3">
<Value>Length</Value>
</Value>
<Value name="4">
<Value>Perf</Value>
</Value>
</Data>
<Data name="WD">
<Attribute>WD</Attribute>
<Structure>subnode</Structure>
<Subscript>"WD"</Subscript>
</Data>
<DataLocation>^SYS.History("Detail")</DataLocation>
<DefaultData>DetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.History("Detail")</IdLocation>
<IndexLocation>^SYS.History("DetailI")</IndexLocation>
<StreamLocation>^SYS.History("DetailS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
