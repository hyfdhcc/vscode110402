Include (%sySystem, %sySite)

/// A class describing the metrics kept for the Write Daemon cycle history.
/// The system keeps a list of the last 20 cycles.
/// <br><br>
/// This class is primarily used as an embedded object in the PerfData interval collection.
/// But it may also be accessed directly using the "Sample" query as an API to the 
/// Write Daemon cycle history. 
Class SYS.History.WriteDaemon Extends %SerialObject [ System = 3 ]
{

/// Time that this Write Daemon cycle began
Property StartTime As %TimeStamp [ SqlColumnNumber = 2 ];

/// Time (in milliseconds) that the Write Daemon was inactive before this cycle began
Property Sleep As %Numeric [ SqlColumnNumber = 3 ];

/// Time (in milliseconds) that the Write Daemon was writing the Write Image Journal (WIJ) file
Property WIJTime As %Numeric [ SqlColumnNumber = 4 ];

/// Time (in milliseconds) that the Write Daemon was writing buffers to the database(s)
Property WriteTime As %Numeric [ SqlColumnNumber = 5 ];

/// Time (in milliseconds) for the Write Daemon cycle to complete
Property CycleTime As %Numeric [ SqlColumnNumber = 6 ];

/// The size of database buffers (in KB) written during the cycle.
Property SizeWrite As %Numeric;

/// Number of database buffers written during the cycle.
Property BufferWrite As %Numeric;

/// Number of database buffers written during the cycle that were also written
/// in the prior cycle.
Property BufferRedirty As %Numeric;

/// Number of "in-memory" (i.e. CacheTemp) buffers used at the start of the cycle.
Property TempQueue As %Numeric;

/// Number of "in-memory" buffers written during the cycle (typically none written).
Property TempWrite As %Numeric;

/// Number of processes actively holding global buffers at the start of the cycle.
Property ProcInGlobal As %Numeric;

/// Coded status flags for any special conditions in the cycle.
/// Bits defined with wdcyclehist structure.
Property StatusFlags As %Integer [ Internal ];

/// Start time as UTC date/time stamp in $ZTS format
Property TimeStamp As %String;

/// Return all WD cycles for an interval. Start and End are UTC timestamps.
ClassMethod GetCycles(Start As %String, End As %String) As %ArrayOfObjects [ Internal ]
{
}

/// Fetch a list of detail properties for this class
/// Only return those that should be summarized for Hourly and Daily.
ClassMethod PropList() As %String [ Internal ]
{
}

/// Configure the summary methods for this class for either the Hourly or Daily summaries. 
/// This is a comma-delimited list of functions to use for the summary. The available functions
/// are Average, Maximum (high-water mark), Minimum (lowest value), Standard Deviation, Median, and 
/// Total. These are abbreviated in the 'Function' argument as "Avg", "Max", "Min", StDev", Med",
/// and "Tot". If nothing is specified, the default is "Avg,Max,StDev". You may also specify the 
/// string "None" for a summary period to disable that summary.
/// <br><br>
/// A null 'Function' argument will return the current summary setting in the 'Function' variable.
/// <br><br>
/// The 'Period' argument can be either "Hourly" or "Daily".
ClassMethod SetSummary(ByRef Function As %String, Period As %String) As %Status
{
}

/// Fetch current Write Daemon cycle history.
Query Sample() As %Query(ROWSPEC = "StartTime:%TimeStamp,Sleep:%Integer,WIJTime:%Integer,WriteTime:%Integer,CycleTime:%Integer,SizeWrite:%Integer,BufferWrite:%Integer,TempQueue:%Integer,TempWrite:%Integer,ProcInGlobal:%Integer,Flags:%Integer,TimeStamp:%String")
{
}

ClassMethod SampleExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod SampleClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = SampleExecute ]
{
}

ClassMethod SampleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = SampleExecute ]
{
}

Storage Default
{
<Data name="WriteDaemonState">
<Value name="1">
<Value>StartTime</Value>
</Value>
<Value name="2">
<Value>Sleep</Value>
</Value>
<Value name="3">
<Value>WIJTime</Value>
</Value>
<Value name="4">
<Value>WriteTime</Value>
</Value>
<Value name="5">
<Value>CycleTime</Value>
</Value>
<Value name="6">
<Value>SizeWrite</Value>
</Value>
<Value name="7">
<Value>BufferWrite</Value>
</Value>
<Value name="8">
<Value>TempQueue</Value>
</Value>
<Value name="9">
<Value>TempWrite</Value>
</Value>
<Value name="10">
<Value>ProcInGlobal</Value>
</Value>
<Value name="11">
<Value>StatusFlags</Value>
</Value>
<Value name="12">
<Value>TimeStamp</Value>
</Value>
<Value name="13">
<Value>BufferRedirty</Value>
</Value>
</Data>
<State>WriteDaemonState</State>
<StreamLocation>^SYS.History.WriteDaemonS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
