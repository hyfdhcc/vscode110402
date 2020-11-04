/// Monitor System metrics.<br>
Class %Monitor.System.SystemMetrics Extends (%Monitor.System.Adaptor, %Monitor.System.Abstract, %Monitor.System.AbstractMetrics, %Monitor.System.AbstractGlobals) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
SAP277	12/01/04 Steve Pettibone, remove MONENABLED
SAP250	10/21/04 Steve Pettibone, start counters using %Monitor.Manager
-------------------End Documentation----------------------------------
*/
Parameter APPLICATION [ Internal ] = "CACHE";

Property Data As %String [ Internal, MultiDimensional ];

/// On Startup enable PERFMON
Method Startup() As %Status
{
 d ##class(%Monitor.Manager).StartSystemCounters(1)
 Quit $$$OK
}

/// Initialize system metrics
Method Initialize() As %Status
{
	 ; Collect global stats
	k stat s stat=$tr($zu(84,7),"^ ",",,")
	Merge ..Data = stat
	Quit $$$OK
}

/// Get system metric sample
/// A return code of $$$OK indicates there is a new sample instance.
/// A return code of 0 indicates there is no sample instance.
Method GetSample() As %Status
{
	d ..SaveStat(..Data,"S",$this)
	Q $$$OK
}

}
