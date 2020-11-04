Include %sySite

/// The <class>%SYSTEM.TCPDevice</class> class provides an interface for retrieving
/// IP address and port of current Cache TCP device.<br>
/// These interfaces support both IPV6 and IPV4 internet addresses.<br>
Class %SYSTEM.TCPDevice Extends Help [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
RJW2142 6/26/13 Ron Watt, Add ability to detect type of <DSCON> error with TCP device.
SML994  3/13/08 Simon Li, Created for IPV6 support.
-------------------End Documentation----------------------------------
*/
/// Get the O/S error that caused a <READ> or <WRITE> error due to peer disconnect or
/// network error on a TCP device.   $IO must be a TCP device or $system.TCPDevice.GetDisconnectCode() generates a <FUNCTION> error.
/// The error returned will be 0 if the peer closed the TCP connection.
ClassMethod GetDisconnectCode() As %Integer
{
}

/// Get local IP address of current TCP device.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Format</b> - The format of address to be returned. If this argument is omitted the default value is 0. The value could be:<br>
/// <ul><li>0: in text format,  'dotted' decimal string for IPV4, colon-hex address string for IPV6.</li>
/// <li>1: in binary format, 4 character length for IPV4, 16 characters for IPV6.</li></ul>
/// <b>Return:</b> <br>
/// Returns the local IP address associated with the TCP device. It could be in binary or text format depends on the <b>Format</b> parameter.
/// For binary format the IP address is in Network order.<br>
/// If the current device ($IO) is not a TCP device, it gets <FUNCTION> error.<br>
/// If the TCP device is in 'listening' state, the IP address would be all zeros (INADDR_ANY).<br>
ClassMethod LocalAddr(Format As %Integer = 0) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get local IP address and port number of current TCP device.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Format</b> - The format of address to be returned. If this argument is omitted the default value is 0. The value could be:<br>
/// <ul><li>0: in text format,  'dotted' decimal string for IPV4, colon-hex address string for IPV6.</li>
/// <li>1: in binary format, 4 character length for IPV4, 16 characters for IPV6.</li></ul>
/// <b>Return:</b> <br>
/// Returns the local IP address and port number associated with the TCP device. The IP address could be in binary or text format depends on the <b>Format</b> parameter.
/// For binary format the IP address is in Network order.<br>
/// If the current device ($IO) is not a TCP device, it gets <FUNCTION> error.<br>
/// If the TCP device is in 'listening' state, the IP address would be all zeros (INADDR_ANY).<br>
/// The return string is a List string with IP address in first and port number in second element.<br>
/// The port number is a numberic string in Host order.<br>
ClassMethod LocalAddrPort(Addr As %String) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get local port number of current TCP device.<br>
/// <br>
/// <b>Return:</b> <br>
/// Returns the local port number associated with the TCP device.
/// If the current device ($IO) is not a TCP device, it gets <FUNCTION> error.<br>
/// The port number is a numberic string in Host order.<br>
ClassMethod LocalPort() As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get foreign IP address of current TCP device.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Format</b> - The format of address to be returned. If this argument is omitted the default value is 0. The value could be:<br>
/// <ul><li>0: in text format,  'dotted' decimal string for IPV4, colon-hex address string for IPV6.</li>
/// <li>1: in binary format, 4 character length for IPV4, 16 characters for IPV6.</li></ul>
/// <b>Return:</b> <br>
/// Returns the foreign IP address associated with the TCP device. It could be in binary or text format depends on the <b>Format</b> parameter.
/// For binary format the IP address is in Network order.<br>
/// If the current device ($IO) is not a TCP device, it gets <FUNCTION> error.<br>
/// If the TCP device is in 'listening' state or not connected to remote system, it returns a null string.<br>
ClassMethod PeerAddr(Format As %Integer = 0) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get foreign IP address and port number of current TCP device.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Format</b> - The format of address to be returned. If this argument is omitted the default value is 0. The value could be:<br>
/// <ul><li>0: in text format,  'dotted' decimal string for IPV4, colon-hex address string for IPV6.</li>
/// <li>1: in binary format, 4 character length for IPV4, 16 characters for IPV6.</li></ul>
/// <b>Return:</b> <br>
/// Returns the foreign IP address and port number associated with the TCP device. The IP address could be in binary or text format depends on the <b>Format</b> parameter.
/// For binary format the IP address is in Network order.<br>
/// If the current device ($IO) is not a TCP device, it gets <FUNCTION> error.<br>
/// If the TCP device is in 'listening' state or not connected to remote system, it returns a null string.<br>
/// The return string is a List string with IP address in first and port number in second element.<br>
/// The port number is a numberic string in Host order.<br>
ClassMethod PeerAddrPort(Format As %Integer = 0) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get foreign port number of current TCP device.<br>
/// <br>
/// <b>Return:</b> <br>
/// Returns the foreign port number associated with the TCP device.
/// If the current device ($IO) is not a TCP device, it gets <FUNCTION> error.<br>
/// If the TCP device is in 'listening' state or not connected to remote system, it returns a null string.<br>
/// The port number is a numberic string in Host order.<br>
ClassMethod PeerPort() As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

}
