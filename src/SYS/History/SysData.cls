Include (%sySite, MONEXT)

/// Basic detail collection class of System Usage metrics for the Monitor History database.
/// Properties represent metrics which get collected every few minutes by the %MONAPP 
/// Application Monitor process when the %Monitor.System.HistorySys class is "active".
Class SYS.History.SysData Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// Time of sample
Property DateTime As %TimeStamp [ SqlColumnNumber = 2 ];

/// Length of sample in seconds
Property Length As %Integer;

/// UTC date key
Property ZDATE As %Integer;

/// UTC time key
Property ZTIME As %Integer;

/// System usage metrics
Property Sys As SYS.History.SystemUsage;

/// Database metrics
Property DB As array Of SYS.History.Database;

Index ZDTindex On (ZDATE, ZTIME) [ IdKey ];

/// Instantiate the class and fetch current values for all metric properties.
ClassMethod Sample() As SYS.History.SysData
{
}

/// Fetch CPU usage "kernel,user,idle,iowait" as percentage for a 1 second sample
ClassMethod GetCPU() As %String [ Internal ]
{
}

/// Get Unix command for CPU usage for this platform
/// We remember this in CacheTemp so we don't have to figure it out each time
ClassMethod UnixCPU(debug) As %String [ Internal ]
{
}

/// Purge SysData interval data, keeping the last 'Keep' days. This is typically called at
/// the start of each day from the %Monitor.System.HistorySys class, using the current
/// system default for 'Keep' (see the SetPurge() method). The 'Keep' argument allows 
/// you to over ride the system default (a value of "0" or "" uses the system default)
/// <br><br>
/// Returns the number of entries purged.
ClassMethod Purge(Keep As %Integer = 0) As %Integer
{
}

/// Collect summaries of the SysData metrics for a day into the Hourly/Daily database.
/// This is typically done automatically by %Monitor.System.HistorySys at the
/// beginning of each day (for the previous day), but could be called manually 
/// if there's a problem.
/// <br><br>
/// The 'Day' argument sets the end date of the collection, with the default
/// of "0" being the start of today (i.e. $H+Day), which would collect everything for 
/// yesterday. A "-1" would collect the day before yesterday; a "1" would collect
/// today (as much as there is).
ClassMethod Summary(Day As %Integer = 0)
{
}

/// Build a demo database for the Sys metrics. 'Days' is the number of days of history to generate.
ClassMethod Demo(Days As %Integer = 30) As %Status [ Internal ]
{
}

/// Instantiate the class and fetch values for all metric properties.
/// This fills in semi-random values from a base value for each metric for a demo database.
/// 'pct' is a percentage value used to modify (+ or -) the base values.
/// 'dt' is date,time of sampel in $H format
/// 'DB" is array of database names/sizes
ClassMethod DemoSample(pct As %Integer, ByRef DB As %String) As SYS.History.SysData [ Internal ]
{
}

/// Export SystemUsage data for a time range in CSV format. The default is all of the data 
/// currently in the SysData class.
/// <br><br>
/// The default FileName is HistorySys_config_date_time.csv in the MGR directory.
/// <br>
/// 'Start' and 'End' times (if necessary) are in YYYY-MM-DD HH:MM:SS format.
ClassMethod Export(FileName As %String, Start As %TimeStamp, End As %TimeStamp) As %Status
{
}

/// Export Database data for a time range in CSV format. The default is all of the data 
/// currently in the SysData class.
/// <br><br>
/// The default 'FileName' is HistoryDB_config_date_time.csv in the MGR directory. 
/// <br>
/// 'Start' and 'End' times (if necessary) are in YYYY-MM-DD HH:MM:SS format.
/// <br>
/// The 'Database' argument can select (by name) a single database to export.
/// Otherwise, data for all databases is exported and the database name is exported as a column.
ClassMethod ExportDB(FileName As %String, Start As %TimeStamp, End As %TimeStamp, Database As %String) As %Status
{
}

/// Full listing of SystemUsage metrics for a day or range of date/times. Default is today.
Query DateList(Start As %TimeStamp = {$zdt(+$h,3)}, End As %TimeStamp = {$zdt($h+1,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT * FROM SysData
 WHERE (DateTime >= :Start AND DateTime <= :End)
}

/// Full listing of the Database metrics for a day or range of date/times. Default is today.
Query DBDateList(Start As %TimeStamp = {$zdt(+$h,3)}, End As %TimeStamp = {$zdt($h+1,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,SysData_DB.* FROM SysData,SysData_DB
 WHERE ((SysData_DB.SysData = SysData.ID) AND (DateTime >= :Start) AND (DateTime <= :End))
}

Storage Default
{
<Data name="DB">
<Attribute>DB</Attribute>
<Structure>subnode</Structure>
<Subscript>"DB"</Subscript>
</Data>
<Data name="Detail2DefaultData">
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
<Value>Sys</Value>
</Value>
</Data>
<DataLocation>^SYS.History("Detail2")</DataLocation>
<DefaultData>Detail2DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.History("Detail2")</IdLocation>
<IndexLocation>^SYS.History("Detail2I")</IndexLocation>
<StreamLocation>^SYS.History("Detail2S")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
