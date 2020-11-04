Include (%sySite, MONEXT)

/// Class to define an individual shared memory consumer for use
/// with the SYS.History.SharedMemoryData class, which in turn
/// is called by the application monitor (%Monitor.System.HistoryMemory).
Class SYS.History.SharedMemoryUsage Extends %SerialObject [ System = 4 ]
{

/// Time of sample
Property DateTime As %TimeStamp [ SqlColumnNumber = 2 ];

/// Name of SMH Consumer
Property ConsumerName As %String [ SqlColumnNumber = 3, SqlFieldName = ConsumerName ];

/// Number of SMH Consumer
Property ConsumerID As %Integer [ SqlColumnNumber = 4, SqlFieldName = ConsumerID ];

/// Shared Memory Allocated
Property Allocated As %Integer [ SqlColumnNumber = 5, SqlFieldName = Allocated ];

/// Shared Memory Available
Property Available As %Integer [ SqlColumnNumber = 6, SqlFieldName = Available ];

/// Shared Memory Used
Property Used As %Integer [ SqlColumnNumber = 7, SqlFieldName = Used ];

/// Static Memory Table Used
Property SMTUsed As %Integer [ SqlColumnNumber = 8, SqlFieldName = SMTUsed ];

/// General String Table Used
Property GSTUsed As %Integer [ SqlColumnNumber = 9, SqlFieldName = GSTUsed ];

/// Total Memory used
Property TotalUsed As %Integer [ SqlColumnNumber = 10, SqlFieldName = TotalUsed ];

Index ZDTindex On ConsumerID [ IdKey ];

Storage Default
{
<Data name="SharedMemoryUsageState">
<Value name="1">
<Value>ConsumerName</Value>
</Value>
<Value name="2">
<Value>ConsumerID</Value>
</Value>
<Value name="3">
<Value>Allocated</Value>
</Value>
<Value name="4">
<Value>Available</Value>
</Value>
<Value name="5">
<Value>Used</Value>
</Value>
<Value name="6">
<Value>SMTUsed</Value>
</Value>
<Value name="7">
<Value>GSTUsed</Value>
</Value>
<Value name="8">
<Value>TotalUsed</Value>
</Value>
<Value name="9">
<Value>DateTime</Value>
</Value>
</Data>
<ExtentSize>100000</ExtentSize>
<State>SharedMemoryUsageState</State>
<StreamLocation>^SYS.History.SharedMemoryUsageS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
