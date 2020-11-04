/// This class is a Daily summary of the detail PerfData and SysData collections. For each class sample 
/// collected you may chose to have the Average, Maximum, Minimum, Median, Standard Deviation, and Total
/// maintained for the day. By default Average, Maximum, and Standard Deviation are kept.
/// Use the SetSummary method in each individual class (Performance, SystemUsage, etc.) to modify this.
/// Performance counters (SYS.History.Performance) are normalized to a per-second rate for
/// all the calculations.
/// <br><br>
/// This data can be manually purged using the Purge() method.
Class SYS.History.Daily Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// Time of summary
Property DateTime As %TimeStamp [ SqlColumnNumber = 2 ];

/// Number of Performance samples in this Daily period
Property PerfCount As %Integer;

/// Number of SystemUsage samples in this Daily period
Property SysCount As %Integer;

/// Number of WriteDaemon cycles in this Daily period
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

/// Purge Summary data. Purge all days prior to the 'Date' parameter (in YYYY-MM-DD format).
/// Returns the number of days purged.
ClassMethod Purge(Date As %String) As %Integer
{
}

/// Export Daily data for a time range in CSV format. The default is all of the 
/// Perf, Sys and WD data currently in the Daily class.
/// <br><br>
/// The default FileName is HistoryDay_config_date_time.csv in the MGR directory.
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

/// Full listing of Daily Performance metrics for a day or range of date/times. Default is yesterday.
Query PerfDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Daily_Perf.* FROM Daily,Daily_Perf
 WHERE ((Daily.ID = Daily_Perf.Daily) AND (DateTime >= :Start) AND (DateTime <= :End))
}

/// Full listing of Daily SystemUsage metrics for a day or range of date/times. Default is yesterday.
Query SysDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Daily_Sys.* FROM Daily,Daily_Sys
 WHERE ((Daily.ID = Daily_Sys.Daily) AND (DateTime >= :Start) AND (DateTime <= :End))
}

/// Full listing of Daily WriteDaemon metrics for a day or range of date/times. Default is yesterday.
Query WDDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Daily_WD.* FROM Daily,Daily_WD
 WHERE ((Daily.ID = Daily_WD.Daily) AND (DateTime >= :Start) AND (DateTime <= :End))
}

/// Full listing of Daily Database metrics for a day or range of date/times. Default is yesterday.
Query DBDateList(Start As %TimeStamp = {$zdt($h-1,3)}, End As %TimeStamp = {$zdt($h,3)}) As %SQLQuery(CONTAINID = 1)
{
SELECT DateTime,Daily_DB.* FROM Daily,Daily_DB
 WHERE ((Daily.ID = Daily_DB.Daily) AND (DateTime >= :Start) AND (DateTime <= :End))
}

Storage Default
{
<Data name="DB">
<Attribute>DB</Attribute>
<Structure>subnode</Structure>
<Subscript>"DB"</Subscript>
</Data>
<Data name="DailyDefaultData">
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
<DataLocation>^SYS.History("Daily")</DataLocation>
<DefaultData>DailyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.History("Daily")</IdLocation>
<IndexLocation>^SYS.History("DailyI")</IndexLocation>
<StreamLocation>^SYS.History("DailyS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
