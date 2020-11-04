Include %sySystem

/// Methods for controlling and exporting  the system metrics as a group.
Class SYS.Stats.Manager Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

/// Export all current values for SYS.Stats Classes as an XML file.
ClassMethod ExportXML(FileName As %String = "CacheMetrics.xml") As %Status
{
}

/// Entry point for background job.
/// Call ExportXML() in a loop, writing to file at specifed interval (in seconds).
ClassMethod Server(File As %String, Interval As %Integer = 300) As %Status
{
}

/// Start a background job to export XML metrics periodically.
/// Calls SYS.Stats.Manager.Server() as job entry point.
ClassMethod Job(File As %String, Interval As %Integer) As %String
{
}

/// Stop the background XML Export job.
ClassMethod StopJob() As %Status
{
}

}
