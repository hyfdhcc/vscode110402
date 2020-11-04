Include (%sySite, MONEXT, SMHEAP)

/// Basic detail collection class of System Usage metrics for the Shared Memory Application Monitor (%Monitor.System.HistoryMemory)
/// Properties represent metrics which get collected every few minutes by the %MONAPP 
/// Application Monitor process when the %Monitor.System.HistoryMemory class is "active".
Class SYS.History.SharedMemoryData Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

/// Time of sample
Property DateTime As %TimeStamp [ Internal, SqlColumnNumber = 2 ];

/// Length of sample in seconds
Property Length As %Integer [ SqlColumnNumber = 3 ];

/// UTC date key
Property ZDATE As %Integer [ SqlColumnNumber = 4 ];

/// UTC time key
Property ZTIME As %Integer [ SqlColumnNumber = 5 ];

/// System usage metrics
Property SMID As array Of SYS.History.SharedMemoryUsage;

/// Shared Memory Allocated
Property Allocated As %Integer [ SqlColumnNumber = 6, SqlFieldName = Allocated ];

/// Shared Memory Available
Property Available As %Integer [ SqlColumnNumber = 7, SqlFieldName = Available ];

/// Shared Memory Used
Property Used As %Integer [ SqlColumnNumber = 8, SqlFieldName = Used ];

/// Static Memory Table Used
Property SMTUsed As %Integer [ SqlColumnNumber = 9, SqlFieldName = SMTUsed ];

/// General String Table Used
Property GSTUsed As %Integer [ SqlColumnNumber = 10, SqlFieldName = GSTUsed ];

/// Total Memory used
Property TotalUsed As %Integer [ SqlColumnNumber = 11, SqlFieldName = TotalUsed ];

/// Total GST and SMT allocated
Property TotalGSTSMTAllocated As %Integer [ SqlColumnNumber = 12, SqlFieldName = TotalGSTSMTAllocated ];

/// Database metrics
Index ZDTindex On (ZDATE, ZTIME) [ IdKey ];

/// Instantiate the class and fetch current values for all metric properties.
ClassMethod Sample() As SYS.History.SharedMemoryData [ Internal ]
{
}

Method Finalise(sample As SYS.History.SharedMemoryData) As SYS.History.SharedMemoryData [ Internal ]
{
}

/// <br>Generate a report that analyses the data that has been previously
/// captured by the application monitor. 
/// <br><br>By default the report will 
/// include all samples from the table and will simply return a value
/// that is the recommended size of SMH expressed in Kilobytes, which is calculated
/// as the sum of the peak usage of all the shared memory heap consumers with a
/// growth value added (2MB per CPU).
/// <br><br><b>Verbosity</b>  The verbosity of the display to the screen, where 0 is the 
/// minimum verbosity (no output), 1 displays a summary and 2 displays a breakdown
/// of the different consumers.
/// <br><br><b>StartZD</b>  By default the report will include all samples found, but by
/// passing a value here in internal date format, the report will only start from that date
/// <br><br><b>EndZD</b>  By default the report will continue until the final sample at the last
/// time and date is found. By passing a value here, which is a date in internal format, the
/// report will stop its analysis at the end of this date.
/// 
ClassMethod Report(Verbosity As %Integer = 0, StartZD As %Integer = 0, EndZD As %Integer = 0)
{
}

/// <p>Query the shared memory heap data and return a single data for each sample. The data returned
/// is the total for this sample.
Query UsageQuery() As %Query(ROWSPEC = "DateTime:%TimeStamp,ZDATE:%Integer,ZTIME:%Integer,Allocated:%Integer,Available:%Integer,Used:%Integer,SMTUsed:%Integer,GSTUsed:%Integer,TotalUsed:%Integer")
{
}

ClassMethod UsageQueryExecute(ByRef qHandle As %Binary, StartZD As %String = "") As %Status [ Internal ]
{
}

ClassMethod UsageQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod UsageQueryClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// <p>Query the shared memory heap data and return a data row for each consumer for each sample.
/// Therefore the data returned reflects a single consumer of shared memory heap, and you will need
/// multiple data rows returned for a full sample.
Query UsageQuerySMID() As %Query(ROWSPEC = "DateTime:%TimeStamp,ZDATE:%Integer,ZTIME:%Integer,ConsumerName:%String,ConsumerID:%Integer,Allocated:%Integer,Available:%Integer,Used:%Integer,SMTUsed:%Integer,GSTUsed:%Integer,TotalUsed:%Integer")
{
}

ClassMethod UsageQuerySMIDExecute(ByRef qHandle As %Binary, StartZD As %String = "") As %Status [ Internal ]
{
}

ClassMethod UsageQuerySMIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod UsageQuerySMIDClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// <p> Create some data for demonstration purposes. 
/// <br><br>By default this method will create
/// data for a single day assuming a sample interval of 300 seconds, hence it will
/// generate (86400/300) samples.
/// <br><br>The method works by finding the current usage of shared memory heap, and
/// then for every sample will randomly increase or decrease the shared memory
/// heap usage for a single consumer, with a bias towards gradually increasing
/// the total SMH usage.
/// <br><br><b>Warning: This will delete all existing data for SMH analysis</b>
/// 
ClassMethod Demo(Days As %Integer = 1, Interval As %Integer = 300) As %Integer
{
}

/// <p>Set the system parameter for the number of days of sample data to keep.
/// <br><br>Initial system default is 7 days. Return value is the previous setting, and executing
/// this method with a "" argument will return the current setting without modifying it.
ClassMethod SetPurge(Keep As %Integer = 0)
{
}

/// <p>Purge SharedMemoryData interval data, keeping the last 'DaysKeep' days. 
/// <br><br>This is typically called at the start of each day from the %Monitor.System.HistorySys class, 
/// using the current system default for 'Keep' (see the SetPurge() method). 
/// The 'DaysKeep' argument allows you to over ride the system default 
/// , a value of "0" or "" uses the system default, and a value of -1 deletes everything.
/// <br><br>
/// Returns the number of entries purged.
ClassMethod Purge(DaysKeep As %Integer = 0) As %Integer
{
}

Storage Default
{
<Data name="SMID">
<Attribute>SMID</Attribute>
<Structure>subnode</Structure>
<Subscript>"SMID"</Subscript>
</Data>
<Data name="SharedMemoryDataDefaultData">
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
<Value>Allocated</Value>
</Value>
<Value name="5">
<Value>Available</Value>
</Value>
<Value name="6">
<Value>Used</Value>
</Value>
<Value name="7">
<Value>SMTUsed</Value>
</Value>
<Value name="8">
<Value>GSTUsed</Value>
</Value>
<Value name="9">
<Value>TotalUsed</Value>
</Value>
<Value name="10">
<Value>TotalGSTSMTAllocated</Value>
</Value>
</Data>
<DataLocation>^SYS.History("Detail3")</DataLocation>
<DefaultData>SharedMemoryDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.History("Detail3")</IdLocation>
<IndexLocation>^SYS.History("Detail3I")</IndexLocation>
<StreamLocation>^SYS.History("Detail3S")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
