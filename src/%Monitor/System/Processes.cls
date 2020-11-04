/// Monitor System processes.<br>
/// 
Class %Monitor.System.Processes Extends (%Monitor.System.Adaptor, %Monitor.System.Abstract, %Monitor.System.AbstractGlobals) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
SAP277	12/01/04 Steve Pettibone, remove MONENABLED
SAP250	10/21/04 Steve Pettibone, start counters using %Monitor.Manager
-------------------End Documentation----------------------------------
*/
Parameter APPLICATION [ Internal ] = "CACHE";

Property Data As %String [ Internal, MultiDimensional ];

Property Count As %Integer [ Internal ];

Parameter INDEX [ Internal ] = "Pid";

/// Process id
Property Pid As %Monitor.Integer;

/// On Startup enable PERFMON
Method Startup() As %Status
{
 d ##class(%Monitor.Manager).StartSystemCounters(0)
 Quit $$$OK
}

/// Initialize process metrics
Method Initialize() As %Status
{
	 ; Collect global stats
	k stat Do ..GetStat("P",.stat)
	Merge ..Data = stat
	Set ..Count = 0
	Quit $$$OK
}

/// Get process metric sample
/// A return code of $$$OK indicates there is a new sample instance.
/// A return code of 0 indicates there is no sample instance.
Method GetSample() As %Status
{
	Set ..Count = ..Count+1
	I ..Count > ..Data Q 0
	s ..Pid=..Name(..Data(..Count,"Name"),"P")	; Pid #
	d ..SaveStat(..Data(..Count,"Stat"),"P",$this)
	Q $$$OK
}

}
