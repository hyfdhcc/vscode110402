/// A list of System Usage properties for the SysData interval collection class
Class SYS.History.SystemUsage Extends %SerialObject [ System = 4 ]
{

/// Process count
Property Processes As %Numeric;

/// Count of CSP Sessions
Property CSPSession As %Numeric;

/// License count currently used (local)
Property LicUsedLocal As %Numeric;

/// License count currently used (distributed)
Property LicUsedDist As %Numeric;

/// Percentage of system CPU(s) time in kernel mode.
Property CPUKernel As %Numeric;

/// Percentage of system CPU(s) time in user mode.
Property CPUUser As %Numeric;

/// Percentage of system CPU(s) time idle.
Property CPUIdle As %Numeric;

/// Percentage of system CPU(s) time in io_wait mode.
Property CPUIOwait As %Numeric;

/// Number of Journal files
Property JrnFiles As %Numeric;

/// Total size of Journal files (in MB)
Property JrnSize As %Numeric;

/// ECP Response time
Property ECPResponse As %Numeric;

/// Application error count, taken from %Monitor.System.Dashboard2 class
Property AppErrors As %Numeric;

/// Serious alert count, taken from %Monitor.System.Dashboard1 class
Property Alerts As %Numeric;

/// Fetch a list of detail properties for this class for Hourly and Daily summaries
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
<Data name="SystemUsageState">
<Value name="1">
<Value>Processes</Value>
</Value>
<Value name="2">
<Value>CSPSession</Value>
</Value>
<Value name="3">
<Value>LicUsedLocal</Value>
</Value>
<Value name="4">
<Value>LicUsedDist</Value>
</Value>
<Value name="5">
<Value>JrnFiles</Value>
</Value>
<Value name="6">
<Value>JrnSize</Value>
</Value>
<Value name="7">
<Value>ECPResponse</Value>
</Value>
<Value name="8">
<Value>AppErrors</Value>
</Value>
<Value name="9">
<Value>Alerts</Value>
</Value>
<Value name="10">
<Value>CPUKernel</Value>
</Value>
<Value name="11">
<Value>CPUUser</Value>
</Value>
<Value name="12">
<Value>CPUIdle</Value>
</Value>
<Value name="13">
<Value>CPUIOwait</Value>
</Value>
</Data>
<State>SystemUsageState</State>
<StreamLocation>^SYS.History.SystemUsageS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
