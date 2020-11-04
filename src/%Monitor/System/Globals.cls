/// Monitor System globals.<br>
/// See AbstractGlobals for complete list of global metrics.<br>
Class %Monitor.System.Globals Extends (%Monitor.System.Adaptor, %Monitor.System.Abstract, %Monitor.System.AbstractGlobals) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
SAP277	12/01/04 Steve Pettibone, remove MONENABLED
SAP250	10/21/04 Steve Pettibone, start counters using %Monitor.Manager
-------------------End Documentation----------------------------------
*/
Parameter APPLICATION [ Internal ] = "CACHE";

Property Data As %String [ Internal, MultiDimensional ];

Property GloCount As %Integer [ Internal ];

Parameter INDEX [ Internal ] = "Name";

/// Full Global name
Property Name As %Monitor.String;

/// Directory where Global is
Property Directory As %Monitor.String;

/// Name of the Global
Property GlobalName As %Monitor.String;

/// On Startup enable PERFMON
Method Startup() As %Status
{
 d ##class(%Monitor.Manager).StartSystemCounters(0)
 Quit $$$OK
}

/// Initialize global metrics
Method Initialize() As %Status
{
	 ; Collect global stats
	k stat Do ..GetStat("G",.stat)
	Merge ..Data = stat
	Set ..GloCount = 0
	Quit $$$OK
}

/// Get global metric sample
/// A return code of $$$OK indicates there is a new sample instance.
/// A return code of 0 indicates there is no sample instance.
Method GetSample() As %Status
{
	Set ..GloCount = ..GloCount+1
	I ..GloCount > ..Data Q 0
	s ..Name=..Name(..Data(..GloCount,"Name"),"G")	; Global^Dir^Sys
	s ..GlobalName=$p(..Name,"^",1)
	s ..Directory=$p(..Name,"^",2)
	d ..SaveStat(..Data(..GloCount,"Stat"),"G",$this)
	Q $$$OK
}

}
