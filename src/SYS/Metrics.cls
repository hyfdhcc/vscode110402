Include (%occInclude, %cspInclude, %sySystem, MONEXT)

IncludeGenerator %occInclude

/// This class contains the methods used to calculate system metrics displayed by the System Dashboard.
Class SYS.Metrics [ Abstract ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// This method returns the metric values used by the main system dashboard.
/// <var>pID</var> is an optional identifier; this is used for dashboards
/// that may provide values for different items.<br>
/// <var>pCount</var> indicates how many times the corresponding 
/// Dashboard last called this method. On the initial call, this value is 0.
/// This is useful for cases where you do not want to recalculate value each time.
ClassMethod GetMainMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for process specified by pID. The pID must be in decimal form.
ClassMethod GetProcessMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for database specified by pID
ClassMethod GetDatabaseMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for shadow server specified by pID
ClassMethod GetShadowMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for task schedule specified by pID
ClassMethod GetTaskMetrics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for system statistics
ClassMethod GetStatistics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for system Global and Resource statistics
ClassMethod GetGlobalStatistics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

/// Return metrics for ECP statistics
ClassMethod GetECPStatistics(pID As %String, pCount As %Integer, Output pValues, Output pStatus, Output pMsg) As %Status
{
}

ClassMethod GetSeparator() As %String
{
}

}
