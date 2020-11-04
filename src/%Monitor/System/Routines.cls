/// Monitor System routines.<br>
Class %Monitor.System.Routines Extends (%Monitor.System.Adaptor, %Monitor.System.Abstract, %Monitor.System.AbstractMetrics, %Monitor.System.AbstractGlobals) [ Inheritance = right, System = 4 ]
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

Parameter INDEX [ Internal ] = "RoutineName";

/// Name of routine
Property RoutineName As %Monitor.String;

/// Directory where routine is
Property Directory As %Monitor.String;

/// On Startup enable PERFMON
Method Startup() As %Status
{
 d ##class(%Monitor.Manager).StartSystemCounters(0)
 Quit $$$OK
}

/// Initialize routine metrics.
Method Initialize() As %Status
{
	 ; Collect global stats
	k stat Do ..GetStat("R",.stat)
	Merge ..Data = stat
	Set ..Count = 0
	Quit $$$OK
}

/// Get routine metric sample.<br>
/// A return code of $$$OK indicates there is a new sample instance.<br>
/// A return code of 0 indicates there is no sample instance.
Method GetSample() As %Status
{
	Set ..Count = ..Count+1
	I ..Count > ..Data Q 0
	s name =..Name(..Data(..Count,"Name"),"R")	; Routine^Dir^Sys
	s ..RoutineName=$p(name,"^",1)
	s ..Directory=$p(name,"^",2)
	d ..SaveStat(..Data(..Count,"Stat"),"R",$this)
	Q $$$OK
}

}
