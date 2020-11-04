Include MONEXT

/// This class represents system metrics captured for ECP Application Server activity. Each 
/// property is a different metric. A class may be instantiated by calling the class method 
/// 'Sample', and then the current value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s ref=##class(SYS.Stats.ECPAppSvr).Sample()
/// w ref.GloRef ; display number of remote Global References requested by this Application Server
/// </example>
/// <br>
/// System stats for an ECP Application Server
Class SYS.Stats.ECPAppSvr Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// The maximum possible number of ECP connections from this Application Server.
Property MaxConn As %Integer;

/// The number of current active ECP connections from this Application Server.
Property ActConn As %Integer;

/// The number of remote Global "read" type references which were not found in the global cache.
/// This number can be compared to the total number of remote read-only references (i.e. GloRefRemote - GloUpdateRemote)
/// to measure the efficiency of the global caching.
Property GloRef As %Integer;

/// The number of Bytes sent. Note that this is currently only a 32 bit integer and may overflow quickly on a busy system.
Property ByteSent As %Integer;

/// The number of Bytes received. Note that this is currently only a 32 bit integer and may overflow quickly on a busy system.
Property ByteRcvd As %Integer;

/// The number of Blocks added to local cache.
Property BlockAdd As %Integer;

/// The number of Blocks purged by buffer allocation.
Property BlockBuffPurge As %Integer;

/// The number of Blocks purged as requested by a Data Server.
Property BlockSvrPurge As %Integer;

/// The total number of Local global references.
Property GloRefLocal As %Integer;

/// The total number of Remote global references.
Property GloRefRemote As %Integer;

/// The number of Local global updates (Set, Kill, etc).
Property GloUpdateLocal As %Integer;

/// The number of Remote global updates (Set, Kill, etc).
Property GloUpdateRemote As %Integer;

/// The number of Local routine calls.
Property RoutineCallLocal As %Integer;

/// The number of Remote routine calls.
Property RoutineCallRemote As %Integer;

/// The number of Local routine buffer loads and saves.
Property RoutineBuffLocal As %Integer;

/// The number of Remote routine buffer loads and saves.
Property RoutineBuffRemote As %Integer;

/// The response time of the currently connected ECP Data Server(s), 
/// measured as a decimal number in seconds.
/// <br><br>
/// If there are multiple connections, this number represents an overall response time
/// for all Data Server connections. Running the Sample() method will attempt to 'sync'
/// to all Data Servers, and returns the time after the last one has answered.
/// <br><br>
/// A return of zero ('0') indicates there were no active connections which were able to
/// respond to the 'sync' request.
Property ResponseTime As %Numeric;

/// The number of Data Server connections that responded for the ResponseTime.
Property ResponseConn As %Integer;

ClassMethod Sample() As SYS.Stats.ECPAppSvr
{
}

}
