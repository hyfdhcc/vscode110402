Include (%sySystem, %sySite)

/// The <class>%SYSTEM.INetInfo</class> class provides an interface for Internet
/// address manipulation.<br>
/// These interfaces support both IPV6 and IPV4 internet addresses.<br>
Class %SYSTEM.INetInfo Extends %SYSTEM.Help [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
SML2581	 2/27/18 Simon Li, Fix %SYSTEM.INetInfo.CheckAddressExist() for Windows due to SML2554.
SML2580	 2/21/18 Simon Li, Fix %SYSTEM.INetInfo.CheckAddressExist() for VMS due to SML2554.
SML2554	 1/05/18 Simon Li, Replace $zf(-1) with $zf(-100).
SML2024  3/04/15 Simon Li, Make virtualIP.sh script executed by 'sh' instead of 'bash' script.
SML1713  5/31/13 Simon Li, Avoid false result of $SYSTEM.INetInfo.CheckAddressExist() for Windows.
SML1673  3/21/13 Simon Li, Support ignoring VIP for promoted DR member.
SML1568 09/19/12 Simon Li, Suppress 'ping' command output for VMS in %SYSTEM.INetInfo.CheckAddressExist().
SML1463 2/29/12 Simon Li, Add document for $SYSTEM.INetInfo.GetInterfacesInfo() and $SYSTEM.INetInfo.GetListOfConfiguredInterfaces().
SOH313  2/14/12 Steven Hobbs, $SYSTEM.INetInfo.EthernetAddress(2) unavailable on Windows
SML1304 2/23/11 Simon Li, Filter out LO* interface for VMS in $SYSTEM.INetInfo.GetListOfConfiguredInterfaces().
SML1282 12/23/10 Simon Li, Fix %SYSTEM.INetInfo.GetInterfacesInfo() for HP-UX.
SML1263 11/30/10 Simon Li, Validate Mirror Virtual IP for IPv4 and IPv6.
SML1256 11/17/10 Simon Li, Fix failed to add/edit/remove Virtual IP address.
SOH154  10/07/09, Steven Hobbs, Connected() class method
SOH149  09/28/09 Steven Hobbs, Add TCPName, TCPState and EthernetAddress to
			       $system.INetInfo.
RJW1643 01/08/09 Ron Watt, API to determine if IPV6 is supported by the O/S. 
SML1035 6/25/08 Simon Li, Add AddrType method.
SML994  3/13/08 Simon Li, Created for IPV6 support.
-------------------End Documentation----------------------------------
*/
/// Find a host name for an Internet address.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Addr</b> - An Internet address in binary form. The length is 4 for IPV4, 16 for IPV6.<br>
/// The address should be in Network order.<br>
/// <br><b>Return:</b> <br>
/// This method returns a host name string, it returns a null string if no host name is associated with the Internet address.<br>
ClassMethod AddrToHostName(Addr As %String) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Find the type of an address text.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Addr</b> - A text string could be a hostname, an IPV4 dotted address or an IPV6 colon-hex text address.<br>
/// <br><b>Return:</b> <br>
/// This method returns 0 for hostname, 1 for IPV4 address type or 2 for IPV6 address type.<br>
ClassMethod AddrType(Addr As %String) As %Integer
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Convert a binary Internet address to a readable text string.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Addr</b> - An Internet address in binary form. The length is 4 for IPV4, 16 for IPV6.<br>
/// The address should be in Network order.<br>
/// <br>
/// <b>Return:</b> <br>
/// This method returns a 'dotted' decimal string if the input address is IPV4 address (worked as inet_ntoa()).<br>
/// It returns colon-hex address string if the input address is IPV6 address.<br>
/// If the address could not be translated, a null string is returned.
ClassMethod BinaryAddrToText(Addr As %String) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Disable IPV6 process or system wide.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>System</b> - Disable IPV6 for process or system wide, 1 for system wide, 0 for process wide (default).<br>
/// <br>
/// <b>Return:</b> <br>
/// Return whether the IPV6 was enabled or not, 1 - was enabled, 0 - was disabled.
ClassMethod DisableIPV6(System As %Integer = 0) As %Integer
{
	s $zt="Error"
	If System {
		i '$SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName) d $zu(96,0,32)  // <PROTECT> error
		Quit $zu(69,71,0)
	}
	Quit $zu(68,71,0)
Error d $zu(96,0,22)  // $zu(68,71) is not supported, get <UNIMPLEMENT> error
}

/// Enable IPV6 process or system wide.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>System</b> - Enable IPV6 for process or system wide, 1 for system wide, 0 for process wide (default).<br>
/// <br>
/// <b>Return:</b> <br>
/// Return whether the IPV6 was enabled or not, 1 - was enabled, 0 - was disabled.
ClassMethod EnableIPV6(System As %Integer = 0) As %Integer
{
	s $zt="Error"
	If System {
		i '$SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName) ZT "Protect"
		Quit $zu(69,71,1)
	}
	Quit $zu(68,71,1)
Error d $zu(96,0,22)  // $zu(68,71) is not supported, get <UNIMPLEMENT> error
}

/// Get port number, protocol name and IP Family from a service name.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Name</b> - The service name string to be translated.<br>
/// <b>Proto</b> - The protocol of service to be returned. If this parameter is omitted the default value is "". The value could be:<br>
/// <ul><li>"": return services for both TCP and UDP protocols.</li>
/// <li>"tcp": return service for TCP protocol.</li>
/// <li>"udp": return service for UDP protocol.</li></ul>
/// <b>Family</b> - The family of the service to be returned. If this parameter is omitted the default value is 0. The value could be: <br>
/// <ul><li>0: depends on value of $SYSTEM.INetInfo.IsIPV6Enabled(), if IPV6 is NOT enabled
/// IPV4 service is returned, otherwise it returns services for both IPV4 and IPV6.</li>
/// <li>1: Only return IPV4 service, if no IPV4 service then return null string as failure.</li>
/// <li>2: Only return IPV6 service, if no IPV6 service then return null string as failure.</li></ul>
/// <b>Return:</b> <br>
/// Returns a List, its element is port number, protocol name and family type separated by "," (e.g. 23,tcp,IPV4).<br>
/// The port number returned is in Host order.<br>
/// Returns null string if the service name could not be resolved.
ClassMethod GetServiceByName(Name As %String, Proto As %String = "", Family As %Integer = 0) As %List
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get a service name from a port number.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Port</b> - The port number to be translated. This port number is in Host order.<br>
/// <br>
/// <b>Family</b> - The family of the service to be returned. If this parameter is omitted the default value is 0. The value could be: <br>
/// <ul><li>0: depends on value of $SYSTEM.INetInfo.IsIPV6Enabled(), if IPV6 is NOT enabled
/// IPV4 service is returned, otherwise it returns services for IPV6.</li>
/// <li>1: Only return IPV4 service, if no IPV4 service then return null string as failure.</li>
/// <li>2: Only return IPV6 service, if no IPV6 service then return null string as failure.</li></ul>
/// <b>Return:</b> <br>
/// Returns a service name string.<br>
/// Returns null string if the service name could not be found.
ClassMethod GetServiceByPort(Port As %Integer, Family As %Integer = 0) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get one IP address from a host name.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>HostName</b> - The host name string to be translated.<br>
/// <b>Family</b> - The family of the IP address to be returned. If this argument is omitted the default value is 0. The value could be: <br>
/// <ul><li>0: depends on value of $SYSTEM.INetInfo.IsIPV6Enabled(), if IPV6 is NOT enabled
/// IPV4 address is returned, otherwise it returns whatever the system supports.</li>
/// <li>1: Always return IPV4 address, if no IPV4 address then return null string as failure.</li>
/// <li>2: Always return IPV6 address, if no IPV6 address then return null string as failure.</li></ul>
/// <b>Format</b> - The format of address to be returned. If this argument is omitted the default value is 0. The value could be:<br>
/// <ul><li>0: in text format,  'dotted' decimal string for IPV4, colon-hex address string for IPV6.</li>
/// <li>1: in binary format, 4 character length for IPV4, 16 characters for IPV6.</li></ul>
/// <b>Return:</b> <br>
/// Returns the primary IP address of the specified host name. It could be in binary or text format depends on the <b>Format</b> parameter.
/// For binary format the IP address is in Network order.<br>
/// If the host name could not be resolved a null string is returned.
ClassMethod HostNameToAddr(HostName As %String, Family As %Integer = 0, Format As %Integer = 0) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Get all IP addresses from a host name.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>HostName</b> - The host name string to be translated.<br>
/// <b>Family</b> - The family of the IP address to be returned. If this argument is omitted the default value is 0. The value could be: <br>
/// <ul><li>0: depends on value of $SYSTEM.INetInfo.IsIPV6Enabled(), if IPV6 is NOT enabled
/// IPV4 address is returned, otherwise it returns whatever the system supports.</li>
/// <li>1: Always return IPV4 address, if no IPV4 address then return null string as failure.</li>
/// <li>2: Always return IPV6 address, if no IPV6 address then return null string as failure.</li></ul>
/// <b>Format</b> - The format of address to be returned. If this argument is omitted the default value is 0. The value could be:<br>
/// <ul><li>0: in text format,  'dotted' decimal string for IPV4, colon-hex address string for IPV6.</li>
/// <li>1: in binary format, 4 character length for IPV4, 16 characters for IPV6.</li></ul>
/// <b>Return:</b> <br>
/// Returns all the IP addresses of the specified host name in a List. Each IP address in the List could be in binary or text format depends on the <b>Format</b> parameter.
/// For binary format the IP address is in Network order.<br>
/// If the host name could not be resolved a null string is returned.
ClassMethod HostNameToAddrMulti(HostName As %String, Family As %Integer = 0, Format As %Integer = 0) As %List
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Convert a 4-byte unsigned integer from Host order to Network order (htonl()). This is used to convert the binary IPV4 address.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Port</b> - A 4-byte unsigned integer as a binary IPV4 address in Host order.<br>
/// <br>
/// <b>Return:</b> <br>
/// Return a A 4-byte unsigned integer as a binary IPV4 address in Network order.<br>
ClassMethod HostToNetLong(Addr As %Integer) As %Integer
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Convert a 2-byte unsigned integer from Host order to Network order (htons()). This is used to convert the Port number.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Port</b> - A 2-byte unsigned integer as a port number in Host order.<br>
/// <br>
/// <b>Return:</b> <br>
/// Return a 2-byte unsigned integer as a port number in Network order.<br>
ClassMethod HostToNetShort(Port As %Integer) As %Integer
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Check if IPV6 is enabled.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>System</b> - Check for process or system wide, 1 for system wide, 0 for process wide (default).<br>
/// <b>Return:</b> <br>
/// Return whether the IPV6 is enabled or not, 1 - is enabled, 0 - is disabled.
ClassMethod IsIPV6Enabled(System As %Integer = 0) As %String [ CodeMode = expression ]
{
$s(System:$zu(69,71),1:$zu(68,71))
}

/// Return the local host name. (gethostname()).<br>
ClassMethod LocalHostName() As %String [ CodeMode = expression ]
{
$zu(54,0)
}

/// Convert a 4-byte unsigned integer from Network order to Host order (htonl()). This is used to convert the binary IPV4 address.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Port</b> - A 4-byte unsigned integer as a binary IPV4 address in Network order.<br>
/// <br>
/// <b>Return:</b> <br>
/// Return a 4-byte unsigned integer as a binary IPV4 address in Host order.<br>
ClassMethod NetToHostLong(Addr As %Integer) As %Integer
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// Convert a 2-byte unsigned integer from Network order to Host order (ntohs()). This is used to convert the Port number.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Port</b> - A 2-byte unsigned integer as a port number in Network order.<br>
/// <br>
/// <b>Return:</b> <br>
/// Return a 2-byte unsigned integer as a port number in Host order.<br>
ClassMethod NetToHostShort(Port As %Integer) As %Integer
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// $SYSTEM.InetInfo.OSsupportsIPV6() provides a way to determine if IPV6 is supported by the operating system.
/// <br> <br>
/// <b>Return:</b> <br>
/// Returns 1 if the operating system supports IPV6. <br>
/// Returns 0 if the operating system does not support IPV6.
ClassMethod OSsupportsIPV6() As %Integer
{
}

/// Convert a readable Internet address text string to a binary Internet address string.<br>
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Addr</b> - Internet address, a string with address in text form. It is a 'dotted' decimal string for IPV4, colon-hex address string for IPV6.<br>
/// <br>
/// <b>Return:</b> <br>
/// This method (worked as inet_addr()) returns a binary IP address in Network order, the length is 4 for IPV4, 16 for IPV6.<br>
/// If the address could not be translated, a null string is returned.
ClassMethod TextAddrToBinary(Addr As %String) As %String
{
	// Not implmented in kernel, get <UNIMPLEMENT> error.
	d $zu(96,0,22)
}

/// TCPName is a class method called by a child process to retrieve the TCP device
/// name assigned by the parent process.
/// 
ClassMethod TCPName() As %String
{
}

/// TCPStats(Code) returns statistics from the current TCP device.
/// <p>
/// <b>Description</b>
/// <p>
/// TCPStats(2) returns the number of bytes that have been read from the current
/// TCP device.
/// <p>
/// TCPStats(3) returns the number of bytes that have been read from the current
/// TCP device and clears the counter.
/// <p>
/// TCPStats(4) returns the number of bytes that have been written to the current
/// TCP device.
/// <p>
/// TCPStats(5) returns the number of bytes that have been written to the current
/// TCP device and clears the counter.
/// 
ClassMethod TCPStats(Code As %Integer) As %Integer
{
}

/// EthernetAddress(flag[,name]) is a class method that determines Ethernet address.
/// <p>
/// <b>Description</b>
/// <p>
/// You can return a string containing ethernet address information by issuing a call
/// to the following class method.
/// <p>
/// EthernetAddress(0) returns the address of the primary ethernet device. This
/// primary ethernet device is the first ethernet device found on the device names
/// list with a valid ethernet address. Any ethernet device can be designated the
/// primary ethernet device.
/// <p> 
/// EthernetAddress(0,name) returns the address of any attached ethernet device
/// specified by name. On OpenVMS systems, this is the physical port address of
/// the ethernet device, not the hardware address.  The ethernet address is returned
/// as a string of 12 characters that represent the 48-bit ethernet address.  The name
/// is not case sensitive. The maximum length of a device names list is
/// platform-dependent, but the name of an individual device cannot be more
/// than 15 characters in length. An invalid name value results in a <FUNCTION> error.
/// <p>
/// EthernetAddress(0) returns a null string, rather than an ethernet address if:
/// <p>
/// The primary ethernet device is not present in the device names list.
/// EthernetAddress(0,name) returns a null string if the named device is not
/// present in the device names list, or has no corresponding ethernet address.
/// <p> 
/// On Windows systems, the InterSystems Packet Driver is not installed.
/// <p>
/// On IBM AIX(r) systems, the DLPI (Data Link Provider Interface) packages are not
/// installed.
/// <p>
/// The ethernet adapters are protected against access by non-root users, and the
/// process invoking EthernetAddress(0) is not the root user.
/// <p> 
/// EthernetAddress(1) returns the current list of attached ethernet device names,
/// delimited by $CHAR(1). The first name in this list is the primary ethernet device.
/// <p>
/// EthernetAddress(2) returns the current list of ethernet device names, delimited
/// by commas.  This feature is not available on Windows systems.
/// <p>
/// EthernetAddress(2,name) replaces the current ethernet device names list with the
/// list specified in name; it then returns the ethernet device names list prior to
/// the replacement.  This feature is not available on Windows systems.
/// <p> 
/// <b>Parameters</b>
/// <p>
/// <b>flag</b> --
/// The switch that specifies the information that EthernetAddress is to return.
/// Valid values are: 
/// <p>
/// 0 Returns the address of an attached ethernet device. When name is specified,
/// it returns the address of the named device. When name is not specified, it
/// returns the primary ethernet device.
/// <p>
/// 1 Returns a list of the ethernet device names actually present on the system.
/// This is a subset of the list returned by flag= 2. Listed names are separated
/// by the $CHAR(1) character.
/// <p>
/// 2 Returns the current list of ethernet device names, as set by system startup
/// or by a subsequent invocation of EthernetAddress(2,name). Listed names are
/// separated by commas.  This flag value is not available on Windows systems.
/// <p>
/// <p>
/// <b>name</b> Optional --
/// Ethernet device name(s). Valid values are:
/// <p>
/// When flag = 0 name is the name of a specific ethernet device.
/// EthernetAddress(0,name) returns the address of the named device.
/// <p>
/// When flag= 2 name is an ethernet device names list, enclosed in quotes
/// with individual device names separated by commas. A name list specified
/// in EthernetAddress(2,name) cannot contain control characters.  The ethernet
/// device names cannot be changed on Windows systems.
/// 
ClassMethod EthernetAddress(flag As %Integer, Name As %String) As %String
{
}

/// The Connected() class method checks if the current device is a TCP device has been
/// disconnected from the remote site. It returns 0 if the TCP device is disconnected.
/// It returns 1 if the TCP device is still connected. An error &lt;FUNCT&gt; is generated
/// if the current device is not a TCP device.
/// <p>
/// You can also have the system poll asynchronously for a TCP disconnect by using the D mode
/// option for the OPEN or USE command.
/// 
ClassMethod Connected() As %Boolean [ CodeMode = expression ]
{
$ZUTIL(189)
}

/// CheckInterfaceExist:
/// <p>
/// <b>Description</b>
/// <p>
/// Check if the specific network interface exists in the system or not.<br>
/// Returns 1 if the network interface exists in the system, otherwise return 0.
/// 
ClassMethod CheckInterfaceExist(Interface As %String, MatchExact As %Integer = 0) As %Integer
{
	if $$$ISUNIX {
		#;SML1871+
		Try {
			return $$zfcall()
		} Catch {
			return 0
		}
		#; Should never get here.
		#;SML1871-
	}
	q 1
	
	#;SML1871+
zfcall()
	#; Escalate to %All so it could pass %System_CallOut checking.
	$$$AddAllRoleTemporary ; verified 9/26/16 STC
	#;SML2554 ; Replace $zf(-1) with $zf(-100)
	quit $zf(-100,"",$SYSTEM.Util.BinaryDirectory()_"virtualIP.sh","Chk-IF",Interface,+MatchExact)=0
	#;SML1871-
}

/// CheckAddressExist:
/// <p>
/// <b>Description</b>
/// <p>
/// Check if the specific IP address exists in the network or not.<br>
/// Returns 1 if the IP address exists in the network, otherwise return 0.
/// 
ClassMethod CheckAddressExist(IPAddr As %String) As %Integer
{
	#;SML1871+
	Try {
		return $$zfcall()
	} catch {
		return 0
	}
	#; Should never get here.
	
zfcall()
	#; Escalate to %All so it could pass %System_CallOut checking.
	$$$AddAllRoleTemporary
	#;SML1871-
	if $$$ISUNIX {
		#;SML2554 ; Replace $zf(-1) with $zf(-100)
		quit $zf(-100,"",$SYSTEM.Util.BinaryDirectory()_"virtualIP.sh","Chk-IP",IPAddr)=0
	}
	if $$$ISWINDOWS {
		#;SML1713 ; make it one second time out.
		#;SML2554 ; Replace $zf(-1) with $zf(-100)
		#;SML2581 ; Need to redirect the output to null device.
		quit $zf(-100,"/STDOUT=NUL/STDERR=NUL","ping","-w",1000,"-n",1,$p(IPAddr,"/"))=0
	}
	#; This is VMS
	#;SML1568
	#;SML2554 ; Replace $zf(-1) with $zf(-100)
	#;SML2580 ; Need to call mc instead of ping for $zf(-100)
	q $zf(-100,"/STDOUT=nla0:","mc","sys$system:tcpip$ping","-t",1,"-c",1,$p(IPAddr,"/"))#2
}

/// CheckSubnetMatch:
/// <p>
/// <b>Description</b>
/// <p>
/// Check to see if the subnets for the IP for a given physical interface match a requested virtual IP.<br>
/// Returns 1 if the subnets match, otherwise return 0.
/// 
ClassMethod CheckSubnetMatch(Interface As %String, IPAddr As %String) As %Integer
{
	if $$$ISUNIX {
		#;SML2024+
		s rc=##class(SYS.MirrorConfiguration).ValidateVirtualAddress(IPAddr,0,Interface)
		I $$$ISOK(rc) Quit 1
		Quit 0
		#;SML2024-
	}
	q 1
}

/// Get interfaces information configured in the system.
/// <br>
/// <b>Parameters:</b> <br>
/// <b>Interface</b> - Null string will return information of all interfaces otherwise it returns the information of the specified interface.<br>
/// <br>
/// <b>Return:</b> <br>
/// Each interface is separated by $c(0) character. Within each interface it contains interface name and IP addresses separated by $c(1) character.<br>
/// The first field separated by $c(1) is interface name and rest fields of them are the IP addresses configured on this interface.
/// 
ClassMethod GetInterfacesInfo(Interface As %String = "") As %String
{
	#;SML2024+  ; Re-write to avoid calling virtualIP.sh Get-Iface-Info which needs bash.
	#; Non-UNIX platforms are implemented by C codes.
	If '$$$ISUNIX quit ""
	$$$AddAllRoleTemporary
	set info=""
	set iosave=$I
	#;Get OS name.
	s OS=$$getpipe("uname -s",1)
	if OS="" {
		#; Can't decide which OS platform, return null.
		$$$WarnMsg("%SYSTEM.INetInfo.GetInterfacesInfo(): failed to decide OS platform.")
		Quit ""
	}
	#; Now get the ifconfig command path.
	s ifcmd=$$getpipe(^%SYS("bindir")_"virtualIP.sh Get-IFC",1)
	if ifcmd="" {
		#; Can't find ifconfig command path, return null.
		$$$WarnMsg("%SYSTEM.INetInfo.GetInterfacesInfo(): failed to find ifconfig command path.")
		Quit ""
	}
	If Interface'="" {
		s IFlist(0)=Interface
		s nlist=1
	} else {
		#;Now get list of interface name.
		if OS="Linux" {
			Set pipestring=ifcmd_" -o link show up | awk '{print $2}' | awk -F"":"" '{print $1}' | sort -u"
		} else {
			Set pipestring="netstat -i -n | grep -v Name | grep -v ""^$"" | grep -v Iface | grep -v Kernel | awk '{print $1}' | sort -u"
		}
		s IFlist=0
		s nlist=$$getpipe(pipestring,.IFlist)
		If nlist=0 Quit ""
	}
	For idx=0:1:nlist-1 {
		s ifn=IFlist(idx)
		#; Skip loop back interface.
		if $zcvt($e(ifn,1,2),"L")="lo" continue
		#; Skip if the interface does not exist.
		if '$SYSTEM.INetInfo.CheckInterfaceExist(ifn,1) continue
		s ifinfo=$$getIfInfo(ifn)
		if ifinfo="" continue
		s info=$s(info="":ifinfo,1:info_$c(0)_ifinfo)
	}
	quit info
getpipe(pipestring,result)
	s zusav=$zu(68,40),ret="",ii=0
	s end=$s(result=1:0,1:9999999)
	try {
		set dev=pipestring
		open dev:"QR" 
		For ii=0:1:end {
			use dev read x Q:x=""||$zeof
			if end=0 {
				set ret=x
			} else {
				s result(ii)=x
			}
		} 
		close dev
	} catch { close dev}
	use iosave
	d $zu(68,40,zusav)
	Quit $s(end=0:ret,1:ii)
cnvmask2cidr(mask)
	#;remove leading "0x" if existed.
	if $e(mask,1,2)="0x" s mask=$e(mask,3,*)
	if mask["." {
		if $l(mask,".")'=4 Quit mask
		for jj=1:1:4 s mask(jj)=+$p(mask,".",jj)
	} elseif $l(mask)=8 {
		for jj=0:1:3 s mask(jj+1)=$zh($e(mask,jj*2+1,jj*2+2))
	} else {
		#;Bad mask format. Just return it.
		quit mask
	}
	#; Now calculat the bits in the array.
	s bitcnt=0
	f jj=1:1:4 {
		s mask=+mask(jj)
		while mask'=0 {
			if mask#2 s bitcnt=bitcnt+1
			s mask=mask\2
		}
	}
	q bitcnt
getIfInfo(ifn)
	s retinfo=ifn
	if OS="Linux" {
		s pipestring=ifcmd_" -o -f inet addr 2>/dev/null | grep -wF "_ifn
	} elseif OS="Darwin" || (OS="OSF1") || (OS="HP-UX") || (OS="AIX") {
		s pipestring=ifcmd_" "_ifn_" 2>/dev/null  | grep -e 'inet ' -e 'inet6 '"
	} elseif OS="SunOS" {
		s pipestring=ifcmd_" "_ifn_" 2>/dev/null  | grep 'inet '"
	} else {
		$$$WarnMsg("%SYSTEM.INetInfo.GetInterfacesInfo(): Unknown OS type "_OS_" for interface "_ifn)
		Quit ""
	}
	#; This will get IPV4 for Linux and SunOS, both IPV4 and IPV6 for rest of OS.
	k inetinfo s inetinfo=0
	s n=$$getpipe(pipestring,.inetinfo)
	For ii=0:1:n-1 {
		s inetinfo=inetinfo(ii)
		if OS="Linux" {
			#; For LInux, the IP/CIDR is displayed in ip command, sojust return it.
			s retinfo=retinfo_$c(1)_$p($p(inetinfo,"inet ",2)," ")
		} else {
			s isipv6=inetinfo["inet6 "
			#; Now the inetinfo contains IP and mask without 'inet'
			s inetinfo=$p(inetinfo,$s(isipv6:"inet6 ",1:"inet "),2)
			#; get piece of "%" in case the ipv6 has % to tell the interface for Darwin.
			#; get piece of "/" icase the ip address is in CIDR format for ipv6.
			s ipaddr=$p($p($p(inetinfo," "),"%"),"/")
			#; Skip if this is a dummy IP address.
			if ipaddr=""||(ipaddr="::")||(ipaddr="0.0.0.0") continue
			if 'isipv6 {
				#; The netmask is in "netmask" for IPv4
				s ipmask=$p($p(inetinfo,"netmask ",2)," ")
				#;The netmask could be in hex format, need to convert it to number.
				s ipmask=$$cnvmask2cidr(ipmask)
			} elseif (OS="Darwin")||(OS="HP-UX") {
				#; The netmask is in thrid piece of " " Darwin, HP-UX for IPv6.
				s ipmask=$p(inetinfo," ",3)
			} else {
				#; This IPV6 for non Darwin nor HP-UX, the address is in CIDR format.
				s ipmask=$p($p(inetinfo," "),"/",2)
			}
			s retinfo=retinfo_$c(1)_ipaddr_"/"_ipmask
		}
	}
	If OS'="Linux",OS'="SunOS" Quit retinfo
	#;There could be IPV6 address for Linux and SunOS, try to get them.
	if OS="Linux" {
		s pipestring=ifcmd_" -o -f inet6 addr 2>/dev/null | grep -wF "_ifn
	} else {
		s pipestring=ifcmd_" "_ifn_" inet6 2>/dev/null  | grep 'inet6 '"
	}
	k inetinfo s inetinfo=0
	s n=$$getpipe(pipestring,.inetinfo)
	if n'=0 {
		For ii=0:1:n-1 {
			s inetinfo=inetinfo(ii)
			s inetinfo=$p($p(inetinfo,"inet6 ",2)," ")
			#; We need to check if this is a vlaid IPV6 address.
			s ipaddr=$p(inetinfo,"/")
			if ipaddr=""||(ipaddr="::") continue
			s retinfo=retinfo_$c(1)_inetinfo
		}
	}
	Quit retinfo
	#;SML2024-
}

/// Get interfaces information configured in the system excluding loopback interface.
/// <br>
/// <b>Parameters:</b> <br>
/// <b>InterfaceNamesOnly</b> - If set it will return only interface name otherwise return interface name and IP address.<br>
/// <b>VIP</b> - If this is non-null string it will return only interfaces with matching subnet of the VIP.<br>
/// <br>
/// <b>Return:</b> <br>
/// For <b>InterfaceNamesOnly</b> is set, it returns all the interface names in $LIST() format, e.g. $LB(InterfaceName1,InterfaceName2,...)<br>
/// If it is not set it returns all interfaces in a nested $LIST() format, e.g. $LB(Interface1,Interface2,...)<br>
/// Each interface is also a $LIST() containing interface name and IP addresses, e.g. $LB(InterfaceName,IPv4,IPv6).
/// Please note that the sequence of IPv4 and IPv6 might be reversed, you need to check whether it is IPv4 or not by $Length(IP,":"),
/// if it is > 2 then it is IPv6 otherwise it is IPv4. And there can be more than one IPV4 or IPV6 addresses in the interfaces.
/// 
ClassMethod GetListOfConfiguredInterfaces(InterfaceNamesOnly As %Boolean = 0, VIP As %String = "") As %List
{
	
	#;This will call a C function for Windows/VMS, and a COS classmethod (in this class) for UNIX
	set info=$SYSTEM.INetInfo.GetInterfacesInfo()	
	quit:info="" ""
	set numIfaces=$l(info,$c(0)),returnString=""
	for i=1:1:numIfaces {
		set ifaceInfo=$p(info,$c(0),i)
		set ifaceName=$p(ifaceInfo,$c(1),1)
		#;SML1304 ; make sure it handle upper case.
		if $s($$$ISWINDOWS:($zcvt($e(ifaceName,1,4),"L")="loop"),1:($zcvt($e(ifaceName,1,2),"L")="lo")) {
			continue	
		}
		#;SML1673+ ; If VIP specified then it is asking for the matching subnet interface.
		if VIP'="",$$$ISERR(##class(SYS.MirrorConfiguration).ValidateVirtualAddress(VIP,0,ifaceName)) Continue
		#;SML1673-
		if InterfaceNamesOnly {
			set returnString=returnString_$listbuild(ifaceName)
		}
		else {
			#;SML2024 ; return all the addresses in the interface.
			set returnString=returnString_$listbuild($listfromstring(ifaceInfo,$c(1)))	
		}
	}
	
	quit returnString
}

}
