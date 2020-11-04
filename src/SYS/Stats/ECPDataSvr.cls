Include MONEXT

/// This class represents system metrics captured for ECP Data Server activity. Each 
/// property is a different metric. A class may be instantiated by calling the class method 
/// 'Sample', and then the current value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s ref=##class(SYS.Stats.ECPDataSvr).Sample()
/// w ref.GloRef ; display number of Global References returned by this Data Server
/// </example>
/// <br>
/// System stats for an ECP Data Server
Class SYS.Stats.ECPDataSvr Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// Maximum possible number of connections to this Data Server.
Property MaxConn As %Integer;

/// Number of current active connections to this Data Server
Property ActConn As %Integer;

/// The number of Global references returned.
Property GloRef As %Integer;

/// The number of global references that updated the database.
Property GloUpdate As %Integer;

/// The number of Requests received.
Property ReqRcvd As %Integer;

/// The number of request buffers processed.
Property ReqBuff As %Integer;

/// The number of Blocks sent.
Property BlockSent As %Integer;

/// The number of lock requests that are immediately granted.
Property LockGrant As %Integer;

/// The number of lock requests that immediately fail.
Property LockFail As %Integer;

/// The number of lock requests that must be queued.
Property LockQue As %Integer;

/// The number of lock requests that are queued and later granted.
Property LockQueGrant As %Integer;

/// The number of lock requests that are queued and later fail.
Property LockQueFail As %Integer;

/// The number of Bytes sent. Note that this is currently only a 32 bit integer and may overflow quickly on a busy system.
Property ByteSent As %Integer;

/// The number of Bytes received. Note that this is currently only a 32 bit integer and may overflow quickly on a busy system.
Property ByteRcvd As %Integer;

/// The number of blocks the server has requested the client to purge.
Property SvrBlockPurge As %Integer;

/// The number of messages sent by the server to purge a routine on the client .
Property RoutinePurge As %Integer;

/// The number of messages sent by the server for big kills.
Property BigKill As %Integer;

/// The number of times the block was not sent to the client because the result was a big string.
Property BigString As %Integer;

ClassMethod Sample() As SYS.Stats.ECPDataSvr
{
}

}
