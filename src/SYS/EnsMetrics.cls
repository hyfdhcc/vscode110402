/// Specialized system metric class for Ensemble-enabled systems.
Class SYS.EnsMetrics Extends SYS.Metrics
{

/// This method returns the metric values used by the Ensemble system dashboard.
/// <var>pID</var> is an optional identifier; this is used for dashboards
/// that may provide values for different items.<br>
/// <var>pCount</var> indicates how many times the corresponding 
/// Dashboard last called this method. On the initial call, this value is 0.
/// This is useful for cases where you do not want to recalculate value each time.
/// <var>pInterval</var> indicates how stale data is allowed to get before a process will attempt to 
/// update the Ensemble-specific data.
ClassMethod GetMainMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg, pInterval As %Numeric = 10) As %Status
{
}

/// Convert timestamp value to more user-friendly display format
ClassMethod mactime(pDateTime As %String = "", pUTC As %Boolean = 0) As %String [ Internal, Private ]
{
}

}
