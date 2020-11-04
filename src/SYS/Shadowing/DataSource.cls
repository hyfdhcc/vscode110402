Include (SHDW, %syJrninc)

/// API for current Cache system acting as a data source of shadowing 
Class SYS.Shadowing.DataSource [ Abstract, System = 4 ]
{

/// Latency of transferring journal files to the shadow side (destination) <br>
/// The latency is the time (in seconds) needed to transfer the remaining journal data, 
/// projected based on the current transfer rate. -1 if latency is (temporarily) unavailable. <br>
ClassMethod GetLatency(pid As %Integer) As %Integer
{
}

ClassMethod Stat(pid As %Integer, ByRef Latency As %Integer, ByRef shdwstat As %List, ByRef gapsiz As %Integer, ByRef shdwrate As %Integer, ByRef shdwraterec As %Integer, ByRef shdwrateavg As %Integer) As %Status [ Internal ]
{
}

/// To close existing shadow connections. To deny future incoming connections as well, one should configure %Service_Shadow accordingly before calling this method or simply call <method>Disable</method>, which disables %Service_Shadow.
ClassMethod Close(WaitTime As %Integer = 15) As %Status
{
}

/// To deny future incoming connections by disabling %Service_Shadow and close existing shadow connections. WaitTime specifies how long (in seconds) to wait for existing connections to close before returning. 0 means no wait, in which case one may query for existing connections afterwards. The default is 15 seconds. Returns 0 (no error description) if wait timed out.
ClassMethod Disable(WaitTime As %Integer = 15) As %Status
{
}

/// Returns details about current connections from shadows: <ul><li>
/// Port: The port number of Cache TCP device receiving the incoming shadow connection; </li><li>
/// Shadow IP: IP address of the incoming shadow connection; </li><li>
/// Journal: The path of the source journal file currently being sent to the shadow; </li><li>
/// PID: process ID of the job sending source journal file to the shadow; </li><li>
/// Latency: A string typically consisting of a number and a time unit (seconds, minutes or hours), e.g., 
/// "0 second", or "N/A" if latency figure is (temporarily) unavailable; </li><li>
/// Shadowing Rate: Rate of transferring journal files to the shadow, in units such as bytes/sec, KB/sec, etc. (e.g., "10 MB/sec"),
/// or "N/A" if the rate is (temporarily) unavailable. </li></ul>
Query Connections() As %Query(ROWSPEC = "Port:%String,Shadow IP:%String,Journal:%String,PID:%Integer,Latency:%String,Shadowing Rate:%String")
{
}

ClassMethod ConnectionsExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ConnectionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ConnectionsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// Returns details about errors.
Query Errors() As %Query(ROWSPEC = "Time:%TimeStamp,$ZE:%String,Info:%String,Occurrences:%Integer")
{
}

ClassMethod ErrorsExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ErrorsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ErrorsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ErrorText(Error As %String) As %String [ Internal ]
{
}

}
