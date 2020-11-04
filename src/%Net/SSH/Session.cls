Include %occSSH

/// Represents an SSH session object.  Each SSH session object must first be connected, then authenticated
/// with the remote system.  Note that there are multiple methods of authentication, this class supports
/// password and publickey.  Once connected and authenticated, the SSH object can be used to perform
/// SCP (Secure Copy) operations of single files to and from the remote system, it can also be used
/// to execute remote commands, tunnel TCP traffic and forms the base connection for SFTP operations (see
/// %Net.SSH.SFTP).
/// <br/>
/// The Test() method of this class illustrates some basic usage scenarios for this class.
/// <br/>
/// <b>NOTE:</b> CacheSSH is currently not supported on OpenVMS platforms.
Class %Net.SSH.Session Extends %RegisteredObject [ System = 3 ]
{

/// Default SSH port
Parameter SSHPORT As %Integer [ Final ] = 22;

/// Enables tracing of SSH transactions
Parameter SSHTRACETRANS As %Integer [ Final ] = 2;

/// Enables tracing of SSH key exchange
Parameter SSHTRACEKEX As %Integer [ Final ] = 4;

/// Enables tracing of SSH authentication
Parameter SSHTRACEAUTH As %Integer [ Final ] = 8;

/// Enables tracing of SSH connections
Parameter SSHTRACECONN As %Integer [ Final ] = 16;

/// Enables tracing of SSH/SCP operations
Parameter SSHTRACESCP As %Integer [ Final ] = 32;

/// Enables tracing of SSH/SFTP operations
Parameter SSHTRACESFTP As %Integer [ Final ] = 64;

/// Enables tracing of SSH error operations
Parameter SSHTRACEERROR As %Integer [ Final ] = 128;

/// Enables tracing of SSH public key operations
Parameter SSHTRACEPUBLICKEY As %Integer [ Final ] = 256;

/// Enables tracing of low level socket operations
Parameter SSHTRACESOCKET As %Integer [ Final ] = 512;

/// Remote host key
Property HostKey As %String;

/// SSH Session handle
Property Session As %String [ Internal, Private ];

Method %OnNew() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim result As %List

	// CacheSSH is not currently supported on VMS
	If $$$isVMS Quit $$$ERROR($$$FeatureNotSupported,"CacheSSH/VMS")

	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHCREATESESSION)
	Quit:+$LG(result) $$$SSHERROR(result,"CreateSession")
	
	Set ..Session = $LI(result,2)
	
	Quit $$$OK
}

/// Connect to a remote host, specifying the hostname, and optionally the port and remote hostkey to match.
/// The hostkey helps prevent impersonation attacks, it is a hash of the remote hosts' public key.
Method Connect(hostname As %String, port As %Integer = {..#SSHPORT}, hostkey As %String = "") As %Status
{
	#dim result As %List
	
	If ..Session="" {
		Set result = $ZF(-6,$$$SSHLibrary,$$$SSHCREATESESSION)
		Quit:+$LG(result) $$$SSHERROR(result,"CreateSession")
		
		Set ..Session = $LI(result,2)
	}
	
	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHCONNECT,$LB(..Session,hostname,port,hostkey))
	Quit:+$LG(result) $$$SSHERROR(result,"Connect")
	
	Set ..HostKey = $LI(result,2)
	
	Quit $$$OK
}

/// Clean up any resources
Method %OnClose() As %Status
{
	Quit $S(..Session'="":..Disconnect(),1:$$$OK)
}

/// Disconnect from the remote host
Method Disconnect() As %Status
{
	#dim result As %List
	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHDISCONNECT,$LB(..Session))
	Quit:+$LG(result) $$$SSHERROR(result,"Disconnect")
	
	Set ..Session = ""
	Set ..HostKey = ""
	
	Quit $$$OK
}

/// Authenticate with the remote server using a username/password via the "password" authentication
/// scheme.  Note that this is NOT the same as keyboard-interactive which is typically what login
/// sessions use.
Method AuthenticateWithUsername(username As %String, password As %String) As %Status
{
	#dim result As %List
	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHAUTHENTICATEWITHUSERNAME,$LB(..Session,username,password))
	Quit:+$LG(result) $$$SSHERROR(result,"AuthenticateWithUsername")

	Quit $$$OK
}

/// Authenticate with the remote server using a public/private key pair and passphrase (for the private key)
Method AuthenticateWithKeyPair(username As %String, publickeyfile As %String, privatekeyfile As %String, passphrase As %String) As %Status
{
	#dim result As %List
	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHAUTHENTICATEWITHKEYPAIR,$LB(..Session,username,publickeyfile,privatekeyfile,passphrase))
	Quit:+$LG(result) $$$SSHERROR(result,"AuthenticateWithKeyPair")

	Quit $$$OK
}

/// Open up an SFTP session for SFTP activity.
Method OpenSFTP(ByRef sftp As %Net.SSH.SFTP) As %Status
{
	#dim result As %List
	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHOPENSFTP,$LB(..Session))
	Quit:+$LG(result) $$$SSHERROR(result,"OpenSFTP")
	
	// Construct an SFTP wrapper
	Set sftp = ##class(%Net.SSH.SFTP).%New($this,$LI(result,2))

	Quit $$$OK
}

/// Execute a remote command on the remote system.  In order to do I/O with the remote
/// command, an XDEV device instance is passed back via the pDevice parameter.  This is
/// a normal Cache' device and can be used with the USE/READ/WRITE/CLOSE commands.
/// Note that environment variables for the remote command can be passed as an array
/// of name/value pairs.
Method Execute(pCommand As %String, ByRef pDevice As %String, ByRef pEnv) As %Status
{
	#dim result As %List
	#dim environ As %List
	
	Set environ="",i=""
	For {
		Set i=$O(pEnv(i))
		Quit:i=""
		
		Set environ=environ_$LB($LB(i,pEnv(i)))
	}
	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHEXECUTE,$LB(..Session,pCommand,environ))
	Quit:+$LG(result) $$$SSHERROR(result,"Execute")
	
	Quit ..openXDEV($LI(result,2),$LI(result,3),"SSHEXECUTE",.pDevice)
}

/// Demonstrates the execution of a remote command (by default, uname -a).
ClassMethod TestExecute(host As %String, username As %String, password As %String, command As %String = "uname -a", pTimeout As %Integer = -1) As %Status
{
	Set s = ##class(%Net.SSH.Session).%New()
	Set sc = s.Connect(host)
	Quit:$$$ISERR(sc) sc
	If pTimeout'=-1 {
		Set sc = s.SetTimeout(pTimeout)
		Quit:$$$ISERR(sc) sc
	}
	Set sc = s.AuthenticateWithUsername(username,password)
	Quit:$$$ISERR(sc) sc
	Set sc = s.Execute(command,.tDevice)
	Quit:$$$ISERR(sc) sc
	
	Set $ZT="Trap"
	For {
		Use tDevice
		Read X
		Use $P
		If X'[$C(13) {
			For i=1:1:$L(X,$C(10)) Write $P(X,$C(10),i),!
		} Else {
			Write X
		}
	}
Exit
	Use $P
	Close tDevice
	Quit sc
Trap
	Set sc = $S($ZE["<READ>":$$$OK,1:$$$ERROR($$$CacheError,$ZE))
	Goto Exit
}

/// Forwards traffic via the SSH connection to a remote host/port.  The traffic is sent via an XDEV device
/// that is opened by ForwardPort() and passed back by reference via the pDevice parameter.
Method ForwardPort(pRemoteHost As %String, pRemotePort As %Integer, ByRef pDevice As %String) As %Status
{
	#dim result As %List

	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHFORWARDPORT,$LB(..Session,pRemoteHost,+pRemotePort))
	Quit:+$LG(result) $$$SSHERROR(result,"ForwardPort")
	
	Quit ..openXDEV($LI(result,2),$LI(result,3),"SSHFORWARDPORT",.pDevice)
}

/// Retrieves the client and server SSH versions.  If the server version is not available,
/// or if the session is not connected, then pServerVersion will be undefined.  Note that the
/// client version refers to the release of libssh2 being used.
Method VersionInfo(ByRef pClientVersion As %String, ByRef pServerVersion As %String) As %Status
{
	#dim result As %List

	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHVERSIONINFO,$LB(..Session))
	Quit:+$LG(result) $$$SSHERROR(result,"VersionInfo")
	
	Set pClientVersion = $LG(result,2)
	If $LD(result,3) {
		// Server version available, grab it
		Set pServerVersion = $LG(result,3)
	} Else {
		// No server version available (or not connected)
		Kill pServerVersion
	}
	
	Quit $$$OK
}

/// Sets the timeout for SSH operations in milliseconds.  An infinite timeout can be set by passing -1 to this 
/// methods, an infinite timeout is also the default.
Method SetTimeout(pTimeoutMS As %Integer = -1) As %Status
{
	#dim result As %List

	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHSETTIMEOUT,$LB(..Session,pTimeoutMS))
	Quit:+$LG(result) $$$SSHERROR(result,"SetTimeout")
	
	Quit $$$OK
}

/// Gets the timeout for SSH operations in milliseconds.  An infinite timeout is represented by the value of -1,
/// which is the default value if none other has been set.
Method GetTimeout(ByRef pTimeoutMS As %Integer = -1) As %Status
{
	#dim result As %List

	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHGETTIMEOUT,$LB(..Session))
	Quit:+$LG(result) $$$SSHERROR(result,"GetTimeout")

	// Grab the current timeout value
	Set pTimeoutMS = $LG(result,2)
	
	Quit $$$OK
}

/// Demonstrates the use of port forwarding to whatismyipaddress.com via the remote SSH server.
ClassMethod TestForwardPort(host As %String, username As %String, password As %String, remotehost As %String = "whatismyipaddress.com", remoteport As %Integer = 80) As %Status
{
	Set s = ##class(%Net.SSH.Session).%New()
	Set sc = s.Connect(host)
	Quit:$$$ISERR(sc) sc
	Set sc = s.AuthenticateWithUsername(username,password)
	Quit:$$$ISERR(sc) sc
	Set sc = s.ForwardPort(remotehost,remoteport,.tDevice)
	Quit:$$$ISERR(sc) sc
	
	Set $ZT="Trap"
	
	Use tDevice
	Write "GET / HTTP/1.0"_$C(13,10,13,10)
	Write *-3 // Flush
	
	// Now the response
	For {
		Use tDevice
		Read X
		Use $P
		If X'[$C(13) {
			For i=1:1:$L(X,$C(10)) Write $P(X,$C(10),i),!
		} Else {
			Write X
		}
	}
Exit
	Use $P
	Close tDevice
	Quit sc
Trap
	Set sc = $S($ZE["<READ>":$$$OK,1:$$$ERROR($$$CacheError,$ZE))
	Goto Exit
}

/// Sets the trace mask and log file for SSH tracing/logging.  The trace mask is a bitmap consisting
/// of flags specified above in the SSHTRACE* parameters.
Method SetTraceMask(pTraceMask As %Integer, pTraceFile As %String = "") As %Status [ Internal ]
{
	#dim result As %List

	Set result = $ZF(-6,$$$SSHLibrary,$$$SSHTRACEMASK,$LB(..Session,+pTraceMask,pTraceFile))
	Quit $S(+$LG(result):$$$SSHERROR(result,"TraceMask"),1:$$$OK)
}

/// Sets up an XDEV device for use with port forwarding or remote command execution.
ClassMethod openXDEV(pXDEV As %String, pOwner As %String, pType As %String, ByRef pDevice As %String) As %Status [ Internal, Private ]
{
	Set $ZT="Trap"
	Set pDevice = "|XDEV|"_($ZCRC(pOwner,7)\2)
	Set tTimeout = 0
	Open pDevice:(pXDEV:"":"S":/HOSTNAME=pType:/IOT=$S($$$IsUnicode:"UTF8",1:"RAW"):/IBU=16384:/OBU=16384):tTimeout
	Quit $S($TEST:$$$OK,1:$$$ERROR($$$ErrIOOpenTimeout,pDevice,tTimeout))
Trap
	Quit $$$ERROR($$$CacheError,$ZE)
}

}
