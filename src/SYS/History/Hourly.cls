/// This class is an Hourly summary of the detail PerfData and SysData collections. For each class sample 
/// collected you may chose to have the Average, Maximum, Minimum, Median, Standard Deviation, and Total
/// maintained for the day. By default Average, Maximum, and Standard Deviation are kept.
/// Use the SetSummary method in each individual class (Performance, SystemUsage, etc.) to modify this.
/// Performance counters (SYS.History.Performance) are normalized to a per-second rate for
/// all the calculations.
/// <br><br>
/// <br><br>
/// By default, this data is automatically purged after 60 days.
Class SYS.History.Hourly Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// Time of summary
Property DateTime As %TimeStamp [ SqlColumnNumber = 2 ];

/// Number of Performance samples in this Hourly period
Property PerfCount As %Integer;

/// Number of SystemUsage samples in this Hourly period
Property SysCount As %Integer;

/// Number of WriteDaemon cycles in this Hourly period
Property WDCount As %Integer;

/// Performance metrics
Property Perf As array Of SYS.History.Performance;

/// WriteDaemon metrics
Property WD As array Of SYS.History.WriteDaemon;

/// System Usage metrics
Property Sys As array Of SYS.History.SystemUsage;

/// Database metrics
Property DB As array Of SYS.History.Database;

/// UTC date key
Property ZDATE As %Integer;

/// UTC time key
Property ZTIME As %Integer;

Index ZDTindex On (ZDATE, ZTIME) [ IdKey ];

/// Purge Hourly total data, keeping the last 'Keep' days. This is typically called at
/// the start of each day from the %Monitor.System.History* classes, using the current
/// system default for 'Keep' (see the SetPurge() method). The 'Keep' argument allows 
/// you to over ride the system default (a value of "0" or "" uses the system default)
/// <br><br>
/// Returns the number of entries purged.
ClassMethod Purge(Keep As %Integer = 0) As %Integer
{
}

/// Export Hourly data for a time range in CSV format. The default is all of the 
/// Perf, Sys and WD data currently in the Hourly class.
/// <br><br>
/// The default FileName is HistoryHour_config_date_time.csv in the MGR directory.
/// <br>
/// 'Start' and 'End' times (if necessary) are in YYYY-MM-DD HH:MM:SS format.
/// <br>
/// 'Class' can be a comma-delimited list one or more of these classes of metrics: "Perf", "Sys", "WD". 
/// Or it can be "DB" to select the Database properties. The Database class can not be mixed with
/// the other classes since it uses a different key structure to accommodate multiple databaes.
/// <br>
/// 'Function' can be a comma-delimited list one or more of these summary functions: "Avg", "Max", "Min", StDev", Med" or "Tot".
/// The default is to include all summary functions.
/// <br>
/// 'Database' can be used to select a specific database (by name). Only used if "DB" is selected in 'Class'
ClassMethod Export(FileName As %String, Start As %TimeStamp, End As %TimeStamp, Class As %String, Function As %String, Database As %String) As %Status
{
}

/// Set the system parameter for the number of days of hourly data to keep. 
/// Initial system default is 60 days. Return value is the previous setting, and executing
/// this method with a "" argument will return the current setting without modifying it.
ClassMethod SetPurge(Keep As %Integer = "") As %Integer
{
}

/// Full listing of Hourly Performance metrics for a day or range of date/times. Default is yesterday.
Query PerfDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Hourly_Perf.* FROM Hourly,Hourly_Perf
 WHERE ((Hourly.ID = Hourly_Perf.Hourly) AND (DateTime >= :Start) AND (DateTime <= :End))
}

/// Full listing of Hourly SystemUsage metrics for a day or range of date/times. Default is yesterday.
Query SysDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Hourly_Sys.* FROM Hourly,Hourly_Sys
 WHERE ((Hourly.ID = Hourly_Sys.Hourly) AND (DateTime >= :Start) AND (DateTime <= :End))
}

/// Full listing of Hourly WriteDaemon metrics for a day or range of date/times. Default is yesterday.
Query WDDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Hourly_WD.* FROM Hourly,Hourly_WD
 WHERE ((Hourly.ID = Hourly_WD.Hourly) AND (DateTime >= :Start) AND (DateTime <= :End))
}

/// Full listing of Hourly Database metrics for a day or range of date/times. Default is yesterday.
Query DBDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Hourly_DB.* FROM Hourly,Hourly_DB
 WHERE ((Hourly.ID = Hourly_DB.Hourly) AND (DateTime >= :Start) AND (DateTime <= :End))
}

Storage Default
{
<Data name="DB">
<Attribute>DB</Attribute>
<Structure>subnode</Structure>
<Subscript>"DB"</Subscript>
</Data>
<Data name="HourlyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateTime</Value>
</Value>
<Value name="3">
<Value>PerfCount</Value>
</Value>
<Value name="4">
<Value>SysCount</Value>
</Value>
<Value name="5">
<Value>WDCount</Value>
</Value>
</Data>
<Data name="Perf">
<Attribute>Perf</Attribute>
<Structure>subnode</Structure>
<Subscript>"Perf"</Subscript>
</Data>
<Data name="Sys">
<Attribute>Sys</Attribute>
<Structure>subnode</Structure>
<Subscript>"Sys"</Subscript>
</Data>
<Data name="WD">
<Attribute>WD</Attribute>
<Structure>subnode</Structure>
<Subscript>"WD"</Subscript>
</Data>
<DataLocation>^SYS.History("Hourly")</DataLocation>
<DefaultData>HourlyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.History("Hourly")</IdLocation>
<IndexLocation>^SYS.History("HourlyI")</IndexLocation>
<StreamLocation>^SYS.History("HourlyS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
