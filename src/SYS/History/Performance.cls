/// A list of Performance metric properties for the PerfData interval collection class.
Class SYS.History.Performance Extends %SerialObject [ System = 4 ]
{

/// Global references (local databases)
Property GloRef As %Numeric [ SqlColumnNumber = 3 ];

/// Global references (remote databases)
Property GloRefRem As %Numeric [ SqlColumnNumber = 4 ];

/// Global updates (local SET and KILL)
Property GloUpdate As %Numeric [ SqlColumnNumber = 5 ];

/// Global updates (remote SET and KILL)
Property GloUpdateRem As %Numeric [ SqlColumnNumber = 6 ];

/// Physical Database Reads (blocks from disk)
Property PhysReads As %Numeric [ SqlColumnNumber = 7 ];

/// Logical Database Reads (blocks in memory)
Property LogReads As %Numeric [ SqlColumnNumber = 8 ];

/// Physical Database Writes (blocks written to disk)
Property PhysWrites As %Numeric [ SqlColumnNumber = 9 ];

/// Routine calls (local)
Property RtnCallLocal As %Numeric [ SqlColumnNumber = 10 ];

/// Routine calls (remote)
Property RtnCallRemote As %Numeric [ SqlColumnNumber = 11 ];

/// Routines calls not found in memory 
Property RtnCallMiss As %Numeric [ SqlColumnNumber = 12 ];

/// Routines loaded from disk (or saved to disk) locally 
Property RtnLoad As %Numeric [ SqlColumnNumber = 13 ];

/// Routines loaded from disk (or saved to disk) remotely 
Property RtnLoadRem As %Numeric [ SqlColumnNumber = 14 ];

/// Journal Entries, journal records created
Property JrnEntry As %Numeric [ SqlColumnNumber = 15 ];

/// Journal Block Writes, journal blocks written to disk.
Property JrnBlock As %Numeric [ SqlColumnNumber = 16 ];

/// WIJ physical block writes
Property WIJWrites As %Numeric [ SqlColumnNumber = 17 ];

/// Object references (found in process memory)
Property ObjHit As %Numeric [ SqlColumnNumber = 18 ];

/// Object references (not in process memory)
Property ObjMiss As %Numeric [ SqlColumnNumber = 19 ];

/// Object loaded from disk (not in shared memory)
Property ObjLoad As %Numeric [ SqlColumnNumber = 20 ];

/// Object initialized
Property ObjNew As %Numeric [ SqlColumnNumber = 21 ];

/// Object deleted
Property ObjDel As %Numeric [ SqlColumnNumber = 22 ];

/// Global resource seize
Property GloSeize As %Numeric;

/// Global resource "N" seize (spin failed)
Property GloNSeize As %Numeric;

/// Global resource "A" seize (acquired by spinning)
Property GloASeize As %Numeric;

/// Routine resource seize
Property RtnSeize As %Numeric;

/// Routine resource "A" seize (acquired by spinning)
Property RtnASeize As %Numeric;

/// Object resource seize
Property ObjSeize As %Numeric;

/// Object resource "A" seize (acquired by spinning)
Property ObjASeize As %Numeric;

/// ECP Data Server active client connections
Property ECPConn As %Numeric;

/// ECP App Server database blocks added to cache
Property ECPBlockAdd As %Numeric;

/// ECP App Server database blocks purged by buffer allocation
Property ECPBlockPurgeBuff As %Numeric;

/// ECP App Server database blocks purged as requested by a Data Server
Property ECPBlockPurgeSvr As %Numeric;

/// ECP App Server bytes sent
Property ECPByteSent As %Numeric;

/// ECP App Server bytes received
Property ECPByteRcvd As %Numeric;

/// Fetch a list of detail properties for this class
/// These are the "counter" type properties for which deltas and totals can be calculated.
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

Storage Default
{
<Data name="PerformanceState">
<Value name="1">
<Value>GloRef</Value>
</Value>
<Value name="2">
<Value>GloRefRem</Value>
</Value>
<Value name="3">
<Value>GloUpdate</Value>
</Value>
<Value name="4">
<Value>GloUpdateRem</Value>
</Value>
<Value name="5">
<Value>PhysReads</Value>
</Value>
<Value name="6">
<Value>LogReads</Value>
</Value>
<Value name="7">
<Value>PhysWrites</Value>
</Value>
<Value name="8">
<Value>RtnCallLocal</Value>
</Value>
<Value name="9">
<Value>RtnCallRemote</Value>
</Value>
<Value name="10">
<Value>RtnCallMiss</Value>
</Value>
<Value name="11">
<Value>RtnLoad</Value>
</Value>
<Value name="12">
<Value>RtnLoadRem</Value>
</Value>
<Value name="13">
<Value>JrnEntry</Value>
</Value>
<Value name="14">
<Value>JrnBlock</Value>
</Value>
<Value name="15">
<Value>WIJWrites</Value>
</Value>
<Value name="16">
<Value>ObjHit</Value>
</Value>
<Value name="17">
<Value>ObjMiss</Value>
</Value>
<Value name="18">
<Value>ObjLoad</Value>
</Value>
<Value name="19">
<Value>ObjNew</Value>
</Value>
<Value name="20">
<Value>ObjDel</Value>
</Value>
<Value name="21">
<Value>GloSeize</Value>
</Value>
<Value name="22">
<Value>GloNSeize</Value>
</Value>
<Value name="23">
<Value>GloASeize</Value>
</Value>
<Value name="24">
<Value>RtnSeize</Value>
</Value>
<Value name="25">
<Value>RtnASeize</Value>
</Value>
<Value name="26">
<Value>ObjSeize</Value>
</Value>
<Value name="27">
<Value>ObjASeize</Value>
</Value>
<Value name="28">
<Value>ECPConn</Value>
</Value>
<Value name="29">
<Value>ECPBlockAdd</Value>
</Value>
<Value name="30">
<Value>ECPBlockPurgeBuff</Value>
</Value>
<Value name="31">
<Value>ECPBlockPurgeSvr</Value>
</Value>
<Value name="32">
<Value>ECPByteSent</Value>
</Value>
<Value name="33">
<Value>ECPByteRcvd</Value>
</Value>
</Data>
<State>PerformanceState</State>
<StreamLocation>^SYS.History.PerformanceS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
