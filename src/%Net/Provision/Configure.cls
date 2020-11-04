Include %sySystem

/// Represents a Cache Provisioning object.  Each Provisioning object must first be connected, then authenticated
/// with the remote system.  Note that there are multiple methods of authentication: password and publickey.
/// Once connected and authenticated, the Provisioning object can be used to perform
/// Cache install to a remote system. Once installed, the object can also be used
/// to apply for EM Management.
/// <b>NOTE:</b> Provisioning is not supported on OpenVMS platforms.
/// <br/>
/// <b>NOTE:</b> Sudo is required for install. Note also that the "Defaults requiretty" setting in /etc/sudoers
/// must be disabled (the default). SSH must be configured on the target machine, with PasswordAuthentication for sshd.
Class %Net.Provision.Configure Extends %RegisteredObject [ System = 3 ]
{

Property Authenticated As %Boolean [ InitialExpression = 0 ];

Property Session As %Net.SSH.Session;

Property Sftp As %Net.SSH.SFTP;

Property Username As %String;

Property Password As %String;

/// Instance name we install on the remote machine
Property InstanceName As %String;

/// Where we install the instance on the remote machine.
Property InstallDir As %String;

Property Upgrade As %Boolean [ InitialExpression = 0 ];

/// Directory where the kit lives on the local machine.<br>
/// This may be a network drive which is available on the remote machine as well.<br>
Property KitDir As %String;

/// Temporary directory on the remote machine which we create, and the kit is unpacked to.<br>
/// The instance name gets appended to this.<br>
Property TempDir As %String [ InitialExpression = "/tmp/cache_install" ];

Property SSHHostName As %String;

Property SSHPort As %Integer [ InitialExpression = 22 ];

Property SSHHostKey As %String;

Property SSPort As %Integer;

/// Name of the tar file we are going to install.<br>
Property KitFile As %String;

Property WSPort As %Integer;

Property Status As %Integer;

Property SSHPublicKeyFile As %String;

Property SSHPrivateKeyFile As %String;

Property SSHPassPhrase As %String;

/// Output log from this session.<br>
Property Log As %String [ InitialExpression = {"Provision_"_$j_".log"} ];

/// Output log from execution of EM Manage Cache.
Property EMManageStatus As %String;

/// System log from EM Manage
Property EMSystemLog As %String;

/// Output from remote operation
Property RemoteOutput As %String;

Property ManagerGroup As %String [ InitialExpression = "root" ];

Property CacheGroup As %String [ InitialExpression = "cacheusr" ];

Property CacheUser As %String [ InitialExpression = "cacheusr" ];

Property SecurityType As %String [ InitialExpression = "Minimal" ];

Property Unicode As %Boolean [ InitialExpression = 1 ];

Property CachePassword As %String [ InitialExpression = "SYS" ];

Property CacheKeyFile As %String;

Property Manifest As %String;

Method Init() As %Status [ Internal ]
{
 s $zt="Error"
 s Status=..LogOpen()
 i '$$$ISOK(Status) q
 s ..TempDir=..TempDir_"/"_..InstanceName
 d ..LogWrite("Starting Provisioning")
 d ..LogWrite("Provisioning Parameters:")
 Set Property = $$$comMemberNext($ClassName(),$$$cCLASSproperty,"")
 While Property '= "" {
	d ..LogWrite(Property_": "_$zobjproperty($this,Property))
	Set Property = $$$comMemberNext($ClassName(),$$$cCLASSproperty,Property)
 }
 d ..LogWrite("Exiting Init() method")
 q $$$OK
Error s $zt = ""
 q $$$ERROR($$$CacheError,$ze)
}

Method Connect() As %Status [ Internal ]
{
 s $zt="Error"
 d ..LogWrite("Entering Connect() method")
#;CacheSSH is not currently supported on VMS or windows
 i ($$$isVMS) Quit ..LogError($$$ERROR($$$FeatureNotSupported,"CacheSSH/VMS"))
 i ($$$isWINDOWS) Quit ..LogError($$$ERROR($$$FeatureNotSupported,"CacheSSH/Windows"))
 s ..Session = ##class(%Net.SSH.Session).%New()
 i '$IsObject(..Session) Q ..LogError(%objlasterror)
 s Status = ..Session.Connect(..SSHHostName, ..SSHPort, ..SSHHostKey)
 i '$$$ISOK(Status) q ..LogError(Status)
 d ..LogWrite("Exiting Connect() method")
 Quit $$$OK
Error s $zt = ""
 q $$$ERROR($$$CacheError,$ze)
}

/// Authenticate with the remote server using a username/password via the "password" authentication
/// scheme.  Note that this is NOT the same as keyboard-interactive which is typically what login
/// sessions use.
Method AuthenticateWithUsername() As %Status
{
 s $zt="Error"
 d ..LogWrite("Entering AuthenticateWithUsername() method")
 if ..Authenticated {
	d ..LogWrite("Already authenticated")
	q $$$OK
 }
 s Status = ..Session.AuthenticateWithUsername(..Username, ..Password)
 i '$$$ISOK(Status) q ..LogError(Status)
 s Status=..OpenFTP()
 i '$$$ISOK(Status) q ..LogError(Status)
 s Status=..CheckSudo()
 i '$$$ISOK(Status) q ..LogError(Status)
 s ..Authenticated = 1
 d ..LogWrite("Exiting AuthenticateWithUsername() method")
 q $$$OK
Error s $zt = ""
 q ..LogError($$$ERROR($$$CacheError,$ze))
}

/// Authenticate with the remote server using a public/private key pair and passphrase (for the private key)
Method AuthenticateWithKeyPair() As %Status
{
 s $zt = "Error"
 d ..LogWrite("Entering AuthenticateWithKeyPair() method")
 if ..Authenticated {
	d ..LogWrite("Already authenticated")
	q $$$OK
 }
 s Status = ..Session.AuthenticateWithKeyPair(username, publickeyfile, privatekeyfile, passphrase)
 i '$$$ISOK(Status) q ..LogError(Status)
 s Status=..OpenFTP()
 i '$$$ISOK(Status) q ..LogError(Status)
 s Status=..CheckSudo()
 i '$$$ISOK(Status) q ..LogError(Status)
 s ..Authenticated = 1
 d ..LogWrite("Exiting AuthenticateWithKeyPair() method")
 q $$$OK
Error s $zt = ""
 q ..LogError($$$ERROR($$$CacheError,$ze))
}

/// Open FTP channel
Method OpenFTP() As %Status [ Internal, Private ]
{
 d ..LogWrite("Entering OpenFTP() method")
 s Status = ..Session.OpenSFTP(.sf)
 i '$$$ISOK(Status) q Status
 s ..Sftp = sf
 d ..LogWrite("Exiting OpenFTP() method")
 q $$$OK
Error s $zt = ""
 q $$$ERROR($$$CacheError,$ze)
}

/// Provision the target machine.<br>
/// User must have sudo privilege on target machine.<br>
/// cachekitfile - tar file for the cache installation kit.<br>
/// cachekey (optional) - cache key file.<br>
/// manifest (optional) - user install manifest file.<br>
/// At the end, the tarfile has been expanded and is ready for install.
Method Provision() As %Status
{
 s $zt = "Error"
 d ..LogWrite("Entering Provision() method")
 i '..Authenticated s $ze="Not Authenticated" goto Error
#;First clean out the install directory. We may have had a previous failed install there.
 s cmd = "sudo rm -R "_..TempDir_"; echo $?"
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to cleanup TempDir "_..TempDir))
#;Create the temp directory we unpack the kit to if it doesn't exist
 s cmd = "mkdir -p -m777 "_..TempDir_"; echo $?"
 s Status = ..Execute(cmd,.Response) 
 i '$$$ISOK(Status) q ..LogError(Status)
 i Response q ..LogError($$$ERROR($$$GeneralError,"mkdir failed - "_TempDir))
#; check the tarfile against the target platform
 s Status=..CheckTarfile(..KitFile,.plat)
 i 'Status q ..LogError(Status)
#; first check if it already exists on a network share
 s KitLocation = ..KitDir_"/"_..KitFile
 s Status = ..Sftp.FileInfo(KitLocation, .info)
 i '$$$ISOK(Status) {
	s KitLocation=..TempDir_"/"_..KitFile
	d ..LogWrite("Transferring kit file "_..KitDir_"/"_..KitFile_" to "_KitLocation)
	Set Status = ..Sftp.Put(..KitDir_"/"_..KitFile, KitLocation)
	i '$$$ISOK(Status) q ..LogError(Status)
 } else {
	d ..LogWrite("Kit file "_KitLocation_" found")
 }
 s script = ##class(%Stream.FileCharacter).%New()
 i '$isobject(script) s $ze="Failed to create script file" goto Error
 s script.LineTerminator = $char(10)
 d script.WriteLine(":")
 d script.WriteLine("kitfile=$1")
 d script.WriteLine("os=`uname`")
 d script.WriteLine("case $os in")
 d script.WriteLine("    HP-UX)")
 d script.WriteLine("	GUNZIP=/usr/contrib/bin/gunzip ;;")
 d script.WriteLine("    *)")
 d script.WriteLine("	GUNZIP=gunzip ;;")
 d script.WriteLine("esac")
 d script.WriteLine("sudo rm -R -f cinstall_silent kitlist LICENSE copyright.pdf lgpl.txt NOTICE cplatname package dist cinstall docs cinstall_client tools")
 d script.WriteLine("# unload the tar file")
 d script.WriteLine("$GUNZIP -c $kitfile | tar xf -")
 d script.WriteLine("echo $?")
 d script.WriteLine("exit 0")
 d script.Flush()
 s scriptfile = script.Filename
 s script.RemoveOnClose = 1
 Set target = ..TempDir_"/provision.sh"
 d ..Sftp.Delete(target)
 d ..LogWrite("Transferring file "_scriptfile_" to "_target)
 s Status = ..Sftp.Put(scriptfile, target, "0700")
 i '$$$ISOK(Status) q ..LogError(Status)
 k script
 s cmd = "cd "_..TempDir_"; ./provision.sh "_KitLocation
 Set Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 i Response {
	s $ze = "Failed to expand tarfile "_KitLocation_", file may be corrupt" goto Error
 }
#; sanity check
 s cmd = "ls "_..TempDir_"/cinstall_silent; echo $?"
 Set Status = ..Execute(cmd,.Response) 
 i '$$$ISOK(Status) q ..LogError(Status)
 i Response {
	s $ze = "Failed to expand tarfile, cinstall_silent missing" goto Error
 }
 Quit $$$OK
Error s $zt = ""
 q ..LogError($$$ERROR($$$CacheError,$ze))
}

Method Cleanup() As %Status [ Internal ]
{
 s $zt = "Error"
 d ..LogWrite("Entering Cleanup() method")
 if '..Authenticated s $ze="Not Authenticated" goto Error
 s cmd = "sudo rm -R "_..TempDir_"; echo $?"
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to cleanup TempDir "_..TempDir))
 d ..LogWrite("Exiting Cleanup() method")
 d ..LogClose()
 q $$$OK
Error s $zt = ""
 q ..LogError($$$ERROR($$$CacheError,$ze))
}

Method Delete() As %Status [ Internal ]
{
 s $zt = "Error"
 d ..LogWrite("Entering Delete() method")
 if '..Authenticated s $ze="Not Authenticated" goto Error
#; stop and remove instance already running
 s Status=..Status(.Properties)
 i '$$$ISOK(Status) q ..LogError(Status)
 i Properties("Exists") {
	s cmd = "sudo ccontrol stop "_..InstanceName_" quietly; echo $?"
	s Status = ..Execute(cmd,.Response)	
	i '$$$ISOK(Status) q ..LogError(Status)
	i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to stop instance "_..InstanceName))
	s cmd = "sudo ccontrol delete "_..InstanceName_"; echo $?"
	s Status = ..Execute(cmd,.Response)
	i '$$$ISOK(Status) q ..LogError(Status)
	i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to remove instance "_..InstanceName))
	s cmd = "sudo rm -R "_..InstallDir_"; echo $?"
	s Status = ..Execute(cmd,.Response)
	i '$$$ISOK(Status) q ..LogError(Status)
	i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to delete instance "_..InstanceName))
 }
 d ..LogWrite("Exiting Delete() method")
 q $$$OK
Error s $zt = ""
 q ..LogError($$$ERROR($$$CacheError,$ze))
}

/// Install Cache on target machine.<br>
/// User must have sudo privilege on target machine.<br>
/// Note that the owner of instance is the Username property set when this object was created.
Method Install() As %Status [ Internal ]
{
 s $zt = "Error"
 d ..LogWrite("Entering Install() method")
 if '..Authenticated s $ze="Not Authenticated" goto Error
 s Status=..Status(.Properties)
 i '$$$ISOK(Status) q ..LogError(Status)
 i ..Upgrade {
	i 'Properties("Exists") q ..LogError($$$ERROR($$$GeneralError,"Instance "_..InstanceName_" does not exist"))
	s cmd = "sudo ccontrol stop "_..InstanceName_" quietly; echo $?"
	s Status = ..Execute(cmd,.Response)	
	i '$$$ISOK(Status) q ..LogError(Status)
	i Response {
		d ..LogError($$$ERROR($$$GeneralError,"Unable to stop instance "_..InstanceName))
		s cmd = "sudo ccontrol force "_..InstanceName_" quietly; echo $?"
		s Status = ..Execute(cmd,.Response)	
		i '$$$ISOK(Status) q ..LogError(Status)
		i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to force instance "_..InstanceName))
	}
 } else {
	i Properties("Exists") q ..LogError($$$ERROR($$$GeneralError,"Instance "_..InstanceName_" already exists"))
#;Now create the mgr directory
	s cmd = "sudo mkdir -p "_..InstallDir_"/mgr; echo $?"
	s Status = ..Execute(cmd,.Response)  
 	i '$$$ISOK(Status) q ..LogError(Status)
 	i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to create directory "_..InstallDir_"/mgr"))
 }
 #; generate our manifest file
 s Status = $system.OBJ.ExportToStream("Net.Provision.Installer.cls",.instr,"-d")
 i '$$$ISOK(Status) q ..LogError(Status)
#; write it out
 d instr.Flush()
 s instfile = instr.Filename
 s instr.RemoveOnClose = 1
 s target = ..TempDir_"/DefaultInstallerClass.xml"
 d ..Sftp.Delete(target)
 d ..LogWrite("Transferring file "_instfile_" to "_target)
 s Status = ..Sftp.Put(instfile, target)
 i '$$$ISOK(Status) q ..LogError(Status)
 k instr
#; set the permissions
 s cmd = "sudo chmod 666 "_target_"; echo $?"
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to chmod "_target))
#; if we have license info, create a cache.key
 i '..Upgrade {
	i ..CacheKeyFile'="" {
		s target = ..TempDir_"cache.key"
		d ..LogWrite("Transferring file "_..CacheKeyFile_" to "_target)
		d ..Sftp.Delete(target)
		s Status = ..Sftp.Put(..CacheKeyFile, target) 
		i '$$$ISOK(Status) q ..LogError(Status)
		Set cmd = "sudo cp "_target_" "_..InstallDir_"/mgr/cache.key; echo $?"
		Set Status = ..Execute(cmd,.Response)
		i '$$$ISOK(Status) q ..LogError(Status)
		i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to copy "_target))
	}
 }
#; if we have manifest, create manifest file
 if ..Manifest'="" {
	Set target = ..TempDir_"/usermanifest.xml"
	d ..Sftp.Delete(target)
	d ..LogWrite("Transferring file "_..Manifest_" to "_target)
	Set Status = ..Sftp.Put(..Manifest, target) 
	i '$$$ISOK(Status) q ..LogError(Status)
	Set cmd = "sudo mkdir -p "_..InstallDir_"/manifest; cp "_target_" "_..InstallDir_"/manifest; chmod 755 "_..InstallDir_"/manifest; echo $?"
	Set Status = ..Execute(cmd,.Response)
	i '$$$ISOK(Status) q ..LogError(Status)
	i Response q ..LogError($$$ERROR($$$GeneralError,"Unable to chmod "_target))
 }
#; generate the shell script
 s script = ##class(%Stream.FileCharacter).%New()
 i '$isobject(script) s $ze="Failed to create script file" goto Error
 s script.LineTerminator = $char(10)
 d script.WriteLine(":")
 d script.WriteLine("CheckGroup() {")
 d script.WriteLine("	while :")
 d script.WriteLine("	do")
 d script.WriteLine("		check_status=1")
 d script.WriteLine("		touch /tmp/ctempgroup$$ 2>/dev/null")
 d script.WriteLine("		chgrp ""$1"" /tmp/ctempgroup$$ 2>/dev/null")
 d script.WriteLine("		if [ $? = 0 ] ; then check_status=0 ; break ; fi")
 d script.WriteLine("		break")
 d script.WriteLine("	done")
 d script.WriteLine("	rm -f /tmp/ctempgroup$$ 2>/dev/null")
 d script.WriteLine("	echo $check_status")
 d script.WriteLine("}")
 d script.WriteLine("CheckUser() {")
 d script.WriteLine("	while :")
 d script.WriteLine("	do")
 d script.WriteLine("		check_status=1")
 d script.WriteLine("		# Need to create a dummy file.")
 d script.WriteLine("		touch /tmp/ctempuser$$ 2>/dev/null")
 d script.WriteLine("		chown ""$1"" /tmp/ctempuser$$ 2>/dev/null")
 d script.WriteLine("		if [ $? = 0 ] ; then check_status=0 ; break ; fi")
 d script.WriteLine("		break")
 d script.WriteLine("	done")
 d script.WriteLine("	rm -f /tmp/ctempuser$$ 2>/dev/null")
 d script.WriteLine("	echo $check_status")
 d script.WriteLine("}")
 d script.WriteLine("manager_group=$1")
 d script.WriteLine("cache_user=$2")
 d script.WriteLine("cache_group=$3")
 d script.WriteLine("manager_user="""_..Username_"""")
 d script.WriteLine("# set POSIX compliant utilities location")
 d script.WriteLine("test -x /sbin/useradd && USERADD=/sbin/useradd")
 d script.WriteLine("test -x /usr/sbin/useradd && USERADD=/usr/sbin/useradd")
 d script.WriteLine("test -x /sbin/groupadd && GROUPADD=/sbin/groupadd")
 d script.WriteLine("test -x /usr/sbin/groupadd && GROUPADD=/usr/sbin/groupadd")
 d script.WriteLine("	os=`uname`")
 d script.WriteLine("case $os in")
 d script.WriteLine("    Darwin)")
 d script.WriteLine("	USERADD=./dist/macx64/bin/shared/useradd ;")
 d script.WriteLine("	GROUPADD=./dist/macx64/bin/shared/groupadd ;;")
 d script.WriteLine("  AIX)")
 d script.WriteLine("	test -x /usr/bin/mkgroup && GROUPADD=/usr/bin/mkgroup ;;")
 d script.WriteLine("esac")
 d script.WriteLine("# Check manager group.")
 d script.WriteLine("group_status=`CheckGroup $manager_group`")
 d script.WriteLine("if [ ! $group_status -eq 0 ]")
 d script.WriteLine("then")
 d script.WriteLine("	$GROUPADD $manager_group")
 d script.WriteLine("	if [ $? -ne 0 ]")
 d script.WriteLine("	then")
 d script.WriteLine("		echo ""Could not create group $manager_group""")
 d script.WriteLine("		exit 1")
 d script.WriteLine("	fi")
 d script.WriteLine("fi")
 d script.WriteLine("# Check cache group.")
 d script.WriteLine("group_status=`CheckGroup $cache_group`")
 d script.WriteLine("if [ ! $group_status -eq 0 ]")
 d script.WriteLine("then")
 d script.WriteLine("	$GROUPADD $cache_group")
 d script.WriteLine("	if [ $? -ne 0 ]")
 d script.WriteLine("	then")
 d script.WriteLine("		echo ""Could not create group $cache_group""")
 d script.WriteLine("		exit 1")
 d script.WriteLine("	fi")
 d script.WriteLine("fi")
 d script.WriteLine("# Check cache user.")
 d script.WriteLine("user_status=`CheckUser $cache_user`")
 d script.WriteLine("if [ ! $user_status -eq 0 ]")
 d script.WriteLine("then")
 d script.WriteLine("	$USERADD -g $cache_group $cache_user")
 d script.WriteLine("	if [ $? -ne 0 ]")
 d script.WriteLine("	then")
 d script.WriteLine("		echo ""Could not create user $cache_user""")
 d script.WriteLine("		exit 1")
 d script.WriteLine("	fi")
 d script.WriteLine("fi")
 d script.WriteLine("ISC_PACKAGE_INSTALLDIR="""_..InstallDir_""" \")
 d script.WriteLine("ISC_PACKAGE_INSTANCENAME="""_..InstanceName_""" \")
 d script.WriteLine("ISC_PACKAGE_MGRGROUP=$manager_group \")
 d script.WriteLine("ISC_PACKAGE_MGRUSER=$manager_user \")
 d script.WriteLine("ISC_PACKAGE_CACHEGROUP=$cache_group \")
 d script.WriteLine("ISC_PACKAGE_CACHEUSER=$cache_user \")
 d script.WriteLine("ISC_PACKAGE_INITIAL_SECURITY="""_..SecurityType_""" \")
 d script.WriteLine("ISC_PACKAGE_UNICODE="""_$case(..Unicode,1:"Y",:"N")_""" \")
 d script.WriteLine("ISC_PACKAGE_USER_PASSWORD="""_..CachePassword_""" ./cinstall_silent 2>"_..InstallDir_"/install.log")
 d script.WriteLine("exit 0")
 #; write it out
 d script.Flush()
 s scriptfile = script.Filename
 s script.RemoveOnClose = 1
 s target = ..TempDir_"/install.sh"
 d ..Sftp.Delete(target)
 d ..LogWrite("Transferring file "_scriptfile_" to "_target)
 s Status = ..Sftp.Put(scriptfile, target, "0700")
 i '$$$ISOK(Status) q ..LogError(Status)
 k script
#; execute the script
 s cmd = "cd "_..TempDir_"; sudo ./install.sh "_..ManagerGroup_" "_..CacheGroup_" "_..CacheUser
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 s Status=..Status(.Parameters,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 s ..SSPort=Parameters("SSPort")
 s ..WSPort=Parameters("WSPort")
#; upload the logs, parsing the output
 s cmd = "sudo cat "_..InstallDir_"/install.log"
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 d ..LogWrite("")
 d ..LogWrite("Now writing last 200 lines of cconsole.log")
 d ..LogWrite("")
 s cmd = "sudo tail -n200 "_..InstallDir_"/mgr/cconsole.log"
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q ..LogError(Status)
 d ..LogWrite("")
 Quit $$$OK
Error s $zt = ""
 q ..LogError($$$ERROR($$$CacheError,$ze))
}

/// Get status of a Cache instance. Response is one of the following:
/// LongForm = 0 - CACHE^/usr/cachesys^2016.1.0.513.0^running, since Fri Jul 24 10:29:04 2015^cache.cpf^1972^57772^62972^ok^<br>
/// LongForm = 1 - <br>
/// Configuration 'CACHE'   (default) <br>
/// 	directory: /usr/cachesys<br>
/// 	versionid: 2016.1.0.513.0<br>
/// 	conf file: cache.cpf  (SuperServer port = 1972, WebServer = 57772)<br>
/// 	status:    running, since Fri Jul 24 10:29:04 2015<br>
/// 	state:     ok<br>
/// If the instance doesn't exist, then - ccontrol: instance 'CACHE1' not found
Method Status(ByRef Properties As %String, ByRef Response As %String) As %Status
{
 s $zt="Error"
 k Properties,Response
 if '..Authenticated Quit $$$ERROR($$$CacheError,"Not Authenticated")
 s cmd = "ccontrol list "_..InstanceName
 s Properties("Exists")=0
 Set Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q Status
 i $g(Response)'="" {
	 i Response'["not found" {
		s Properties("Exists")=1
 		s cmd = "ccontrol qlist "_..InstanceName
 		s Status = ..Execute(cmd,.Response1)
 		i '$$$ISOK(Status) q Status
		i ($g(Response1)'="") {
	 		s Properties("Directory")=$p(Response1,"^",2)
	 		s Properties("VersionId")=$p(Response1,"^",3)
	 		s Properties("Status")=$p($p(Response1,"^",4),",",1)
	 		s Properties("Time")=$p($p(Response1,"^",4),",",2)
	 		s Properties("CPFFile")=$p(Response1,"^",5)
	 		s Properties("SSPort")=$p(Response1,"^",6)
	 		s Properties("WSPort")=$p(Response1,"^",7)
	 		#;^^^I don't know what piece 8 is
	 		s Properties("State")=$p(Response1,"^",9)
	 	}
	 }
 }
 Quit Status
Error s $zt = ""
 q $$$ERROR($$$CacheError,$ze)
}

Method ManageCache(instancename As %String = "", command As %String = "stop", options As %String = "", ByRef Status As %String) As %Status
{
	if '..Authenticated Quit $$$ERROR($$$CacheError,"Not Authenticated")
	try {
		if instancename="" s instancename=..InstanceName
		s cmd = "ccontrol "_command_" "_instancename_" quietly "_options
		Set sc = ..Execute(cmd,.Status)
	} catch {
		s $zt = ""
		s sc = $$$ERROR($$$CacheError,$ze)
	}
	Quit sc
}

/// Sends an Apply for Management request on behalf of the instance to the specified EM Server.<br>
/// An X509 Credential alias, and location of X509 Certificates are passed.
/// An X509 Credential corresponding to the Alias is created if it does not already exist.<br>
/// The EM Manager host, port number, and prefix are used to contact the EM Server.<br>
/// CredentialAlias - Credential alias to be used.<br>
/// CAfile - Certificate Authority X.509 certificate file (should also be in the /mgr directory of the instance).<br>
/// Certfile - Client certificate file.<br>
/// Keyfile - Client certificate key file.<br>
/// cachegrp - group owner for the files on target system.<br>
/// Pass - Client certificate password (if any).<br>
/// Host - EM host name or IP address.<br>
/// Port - EM Webserver port number.<br>
/// Prefix - EM instance URLPrefix (if any).<br>
/// Description (optional) - User text to describe the Apply for Management request on the EM Server.<br>
Method EMManage(CredentialAlias As %String, CAfile As %String, Certfile As %String, Keyfile As %String, cachegrp As %String = "cacheusr", Pass As %String, Host As %String, Port As %Integer, Prefix As %String = "", Description As %String = "") As %Status
{
	s $zt = "err"
	if '..Authenticated s $ze="Not Authenticated" goto err
	if '$d(CAfile) || '$d(Certfile) || '$d(Keyfile) s $ze="No keys" goto err
	
	#; create the download directory
	s cmd = "mkdir -p  -m777 "_..KitDir
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	

	if $$$ISUNIX {
		s cachecert = $p(CAfile,"/",*-0)
		s cert = $p(Certfile,"/",*-0)
		s key = $p(Keyfile,"/",*-0)
	} else {
		s cachecert = $p(CAfile,":",2)
		s cert = $p(Certfile,":",2)
		s key = $p(Keyfile,":",2)
		s cachecert = $p(cachecert,"\",*-0)
		s cert = $p(cert,"\",*-0)
		s key = $p(key,"\",*-0)
	}
	#; download all the keys
	Set cachecertfile = ..InstallDir_"/mgr/cache.cer"
	Set sc = ..Sftp.Put(CAfile, cachecertfile) Quit:$$$ISERR(sc) sc

	#; set the permissions
	Set cmd = "sudo chmod 660 "_cachecertfile_"; sudo chgrp "_cachegrp_" "_cachecertfile
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	
	
	Set certfile = ..InstallDir_"/"_cert
	Set sc = ..Sftp.Put(Certfile, certfile) Quit:$$$ISERR(sc) sc

	#; set the permissions
	Set cmd = "sudo chmod 660 "_certfile_"; sudo chgrp "_cachegrp_" "_certfile
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	
	
	Set keyfile = ..InstallDir_"/"_key
	Set sc = ..Sftp.Put(Keyfile, keyfile) Quit:$$$ISERR(sc) sc

	#; set the permissions
	Set cmd = "sudo chmod 660 "_keyfile_"; sudo chgrp "_cachegrp_" "_keyfile
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	

	#; clean the logs
	s cmd = "cd "_..InstallDir_"/mgr; sudo rm em.log"
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	
	
	#; generate the shell script
	s dev = "em.log"
	s script = ##class(%Stream.FileCharacter).%New()
	i '$isobject(script) s $ze="Failed to create script file" goto err
	s script.LineTerminator = $char(10)

	d script.WriteLine("Set $ZNSPACE = ""%SYS""")
	d script.WriteLine("s status = ##class(%Net.Provision.EMManage).EMReqManagement("""_CredentialAlias_""","""_cachecertfile_""","""_certfile_""","""_keyfile_""","""_Pass_""","""_Host_""","""_Port_""","""_Prefix_""","""_Description_""")")
	d script.WriteLine("s dev="""_dev_""" o dev:""WNS"" u dev i status=1 {w 1,!} else {w $System.Status.GetErrorText(status),!} c dev")
	d script.WriteLine("h")
	
	#; write it out
	d script.Flush()
	s scriptfile = script.Filename
	s script.RemoveOnClose = 1

	Set target = ..KitDir_"/emscript.sh"
	Set sc = ..Sftp.Put(scriptfile, target, "0700") Quit:$$$ISERR(sc) sc
	k script
	
	#; execute the script
	s cmd = "rm "_..InstallDir_"/mgr/"_dev_"; csession "_..InstanceName_" < "_..KitDir_"/emscript.sh; rm "_..KitDir_"/emscript.sh"
	Set sc = ..Execute(cmd, .response)

	#; upload the logs
	Set target = ..InstallDir_"/mgr/"_dev
	Set sc = ..Sftp.Get(target, dev)
	i sc'=$$$OK s %ze="EM Manage failed. No further information available" goto err
	d ..Sftp.Delete(target)
	#; open the file
	o dev:0
	try {
		s ..EMManageStatus = ""
		f {
			u dev Read emstat
			s ..EMManageStatus = ..EMManageStatus_emstat
		}
	} catch {
		#; ignore errors
	}
	u $P
	c dev
	#; upload the em sys.log if em.log had errors
	i ..EMManageStatus'=1 {
		s Status = $$$ERROR($$$CacheError,"Management request failed: "_..EMManageStatus)
	} else {
		s Status = $$$OK
	}
	Quit Status
err
	s $zt = ""
	s Status = $$$ERROR($$$CacheError,$ze)
	Q Status
}

/// Sends an Apply for Management request on behalf of the instance to the specified EM Server based on password policy.<br>
/// Host - EM host name or IP address.<br>
/// Port - EM Webserver port number.<br>
/// Prefix - EM instance URLPrefix (if any).<br>
/// Description (optional) - User text to describe the Apply for Management request on the EM Server.<br>
Method EMManagePass(Host As %String, Port As %Integer, Prefix As %String = "", Description As %String = "") As %Status
{
	s $zt = "err"
	if '..Authenticated s $ze="Not Authenticated" goto err
	
	#; create the download directory
	s cmd = "mkdir -p  -m777 "_..KitDir
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	

	#; clean the logs
	s cmd = "cd "_..InstallDir_"/mgr; sudo rm em.log"
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	
	
	#; generate the shell script
	s dev = "em.log"
	s script = ##class(%Stream.FileCharacter).%New()
	i '$isobject(script) s $ze="Failed to create script file" goto err
	s script.LineTerminator = $char(10)

	d script.WriteLine("Set $ZNSPACE = ""%SYS""")
	d script.WriteLine("s status = ##class(%Net.Provision.EMManage).EMReqManagementByPass("""_Host_""","""_Port_""","""_Prefix_""","""_Description_""")")
	d script.WriteLine("s dev="""_dev_""" o dev:""WNS"" u dev i status=1 {w 1,!} else {w $System.Status.GetErrorText(status),!} c dev")
	d script.WriteLine("h")
	
	#; write it out
	d script.Flush()
	s scriptfile = script.Filename
	s script.RemoveOnClose = 1

	Set target = ..KitDir_"/emscript.sh"
	d ..Sftp.Delete(target)
	Set sc = ..Sftp.Put(scriptfile, target, "0700") Quit:$$$ISERR(sc) sc
	k script
	
	#; execute the script
	s cmd = "csession "_..InstanceName_" < "_..KitDir_"/emscript.sh; rm "_..KitDir_"/emscript.sh"
	Set sc = ..Execute(cmd, .response)

	#; upload the logs
	Set target = ..InstallDir_"/mgr/"_dev
	Set sc = ..Sftp.Get(target, dev)
	i sc'=$$$OK s %ze="EM Manage failed. No further information available" goto err
	d ..Sftp.Delete(target)
	#; open the file
	o dev:0
	try {
		s ..EMManageStatus = ""
		f {
			u dev Read emstat
			s ..EMManageStatus = ..EMManageStatus_emstat
		}
	} catch {
		#; ignore errors
	}
	u $P
	c dev
	#; upload the em sys.log if em.log had errors
	i ..EMManageStatus'=1 {
		s Status = $$$ERROR($$$CacheError,"Management request failed: "_..EMManageStatus)
	} else {
		s Status = $$$OK
	}
	Quit Status
err
	s $zt = ""
	s Status = $$$ERROR($$$CacheError,$ze)
	Q Status
}

/// Sends an Apply for Management request on behalf of the instance to the specified EM Server.<br>
/// An X509 Credential alias, and location of X509 Certificates are passed.
/// An X509 Credential corresponding to the Alias is created if it does not already exist.<br>
/// The EM Manager host, port number, and prefix are used to contact the EM Server.<br>
/// CredentialAlias - Credential alias to be used.<br>
/// CAfile - Certificate Authority X.509 certificate file (should also be in the /mgr directory of the instance).<br>
/// Certfile - Client certificate file.<br>
/// Keyfile - Client certificate key file.<br>
/// cachegrp - group owner for the files on target system.<br>
/// Pass - Client certificate password (if any).<br>
/// Host - EM host name or IP address.<br>
/// Port - EM Webserver port number.<br>
/// Prefix - EM instance URLPrefix (if any).<br>
/// Description (optional) - User text to describe the Apply for Management request on the EM Server.<br>
Method EMRemove() As %Status
{
	s $zt = "err"
	if '..Authenticated s $ze="Not Authenticated" goto err
	#; clean the logs
	s cmd = "cd "_..InstallDir_"/mgr; sudo rm em.log"
	Set sc = ..Execute(cmd,.res) Quit:$$$ISERR(sc) sc	
	
	#; generate the shell script
	s dev = "em.log"
	s script = ##class(%Stream.FileCharacter).%New()
	i '$isobject(script) s $ze="Failed to create script file" goto err
	s script.LineTerminator = $char(10)

	d script.WriteLine("Set $ZNSPACE = ""%SYS""")
	d script.WriteLine("s EMstat = ##class(EMS.Instance).RemoveFromManagement(1,.res)")
	d script.WriteLine("s dev="""_dev_""" o dev:""WNS"" u dev i EMstat="" {w 1,!} else {w $System.Status.GetErrorText(EMstat.AsStatus()),!} c dev")
	d script.WriteLine("h")
	
	#; write it out
	d script.Flush()
	s scriptfile = script.Filename
	s script.RemoveOnClose = 1

	Set target = ..KitDir_"/emscript.sh"
	d ..Sftp.Delete(target)
	Set sc = ..Sftp.Put(scriptfile, target, "0700") Quit:$$$ISERR(sc) sc
	k script
	
	#; execute the script
	s cmd = "rm "_..InstallDir_"/mgr/"_dev_"; csession "_..InstanceName_" < "_..KitDir_"/emscript.sh; rm "_..KitDir_"/emscript.sh"
	Set sc = ..Execute(cmd, .res) Q:sc'=$$$OK sc

	#; upload the logs
	Set target = ..InstallDir_"/mgr/"_dev
	Set sc = ..Sftp.Get(target, dev)
	i sc'=$$$OK s %ze="EM Manage failed. No further information available" goto err
	d ..Sftp.Delete(target)
	#; open the file
	o dev:0
	try {
		s ..EMManageStatus = ""
		f {
			u dev Read emstat
			s ..EMManageStatus = ..EMManageStatus_emstat
		}
	} catch {
		#; ignore errors
	}
	u $P
	c dev
	#; upload the em sys.log if em.log had errors
	i ..EMManageStatus'=1 {
		s Status = $$$ERROR($$$CacheError,"Management removal request failed: "_..EMManageStatus)
	} else {
		s Status = $$$OK
	}
	Quit Status
err
	s $zt = ""
	s Status = $$$ERROR($$$CacheError,$ze)
	Q Status
}

Method EMGetGUID(Output GUID As %String) As %Status
{
	s $zt = "err"
	if '..Authenticated s $ze="Not Authenticated" goto err

	#; generate the shell script
	s dev = "guid.log"
	s script = ##class(%Stream.FileCharacter).%New()
	i '$isobject(script) s $ze="Failed to create script file" goto err
	s script.LineTerminator = $char(10)

	d script.WriteLine("Set $ZNSPACE = ""%SYS""")
	d script.WriteLine("s guid = ##class(EMS.Instance).InstanceGUID()")
	d script.WriteLine("s dev="""_dev_""" o dev:""WNS"" u dev w guid,! c dev")
	d script.WriteLine("h")
	
	#; write it out
	d script.Flush()
	s scriptfile = script.Filename
	s script.RemoveOnClose = 1

	Set target = ..KitDir_"/getguid.sh"
	d ..Sftp.Delete(target)
	Set sc = ..Sftp.Put(scriptfile, target, "0700") Quit:$$$ISERR(sc) sc
	k script
	
	#; execute the script
	s cmd = "rm "_..InstallDir_"/mgr/"_dev_"; csession "_..InstanceName_" < "_..KitDir_"/getguid.sh; rm "_..KitDir_"/getguid.sh; echo $?"
	Set sc = ..Execute(cmd, .res) Q:sc'=$$$OK sc

	#; upload the logs
	Set target = ..InstallDir_"/mgr/"_dev
	Set sc = ..Sftp.Get(target, dev)
	i sc'=$$$OK s %ze="Couldn't get instance guid" goto err
	d ..Sftp.Delete(target)
	#; open the file
	o dev:0
	try {
		f {
			u dev Read guid
			s GUID = guid
		}
	} catch {
		#; ignore errors
	}
	u $P
	c dev
	Quit $$$OK
err
	s $zt = ""
	s Status = $$$ERROR($$$CacheError,$ze)
	Q Status
}

Method Execute(cmd As %String, ByRef Output = "") As %Status [ Private, ProcedureBlock = 1 ]
{
	d ..LogWrite("Executing Command:")
	d ..LogWrite(cmd)
	Set sc = ..Session.Execute(cmd,.pDev)
	Quit:$$$ISERR(sc) sc
	#; Every command expects at least one output. Wait up to 1 second for the first output. 
	d ..LogWrite("Getting response:")
	s first = 0
	f {
		try {
			Use pDev
			Read Output
			Set lines = $L(Output,$C(10))
			Set Output = $P(Output,$C(10),1,lines-1)
			d ..LogWrite(Output)
		} catch {
			i first<10 {
				s first = first + 1
				h .1
				continue
			} else {
				i $ZE["<READ>" {
					s sc = $$$OK
					s $ZE = ""
				} else {
					s sc = $$$ERROR($$$CacheError,$ze)
				}
				goto done
			}
		}
		Q
	}
	#; get remaining output
	try {
		f {
			Use pDev
			Read Output
			Set lines = $L(Output,$C(10))
			Set Output = $P(Output,$C(10),1,lines-1)
			d ..LogWrite(Output,1)
		}
	} catch {
		i $ZE["<READ>" {
			s sc = $$$OK
			s $ZE = ""
		} else {
			s sc = $$$ERROR($$$CacheError,$ze)
		}
	}
done
	Use $P
	c pDev
	Quit sc
}

Method CheckSudo() As %Boolean [ Internal, Private ]
{
 s $zt = "Error"
 d ..LogWrite("Entering CheckSudo() method")
#; create the temp dir on the remote machine. Since this is usually the
#; /tmp directory, we should have write access to it and be able to create it.
 s cmd = "mkdir -p  -m777 "_..TempDir_"; echo $?"
 s Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q Status
 i Response q $$$ERROR($$$GeneralError,"mkdir failed - "_TempDir)
 s script = ##class(%Stream.FileCharacter).%New()
 i '$isobject(script) s $ze="Failed to create script file" goto Error
 s script.LineTerminator = $char(10)
 d script.WriteLine(":")
 d script.WriteLine("# Check that you're root, required for server install")
 d script.WriteLine("os=`uname`")
 d script.WriteLine("ID=id")
 d script.WriteLine("#Solaris puts the POSIX id somewhere else for backward compatibility")
 d script.WriteLine("if [ ""$os"" = ""SunOS"" ] ; then")
 d script.WriteLine("ID=/usr/xpg4/bin/id")
 d script.WriteLine("fi")
 d script.WriteLine("userid=`$ID -u`")
 d script.WriteLine("if [ ! $userid -eq 0 ]")
 d script.WriteLine("then")
 d script.WriteLine("    exit 1")
 d script.WriteLine("fi")
 d script.WriteLine("exit 0")
#; write it out
 d script.Flush()
 s scriptfile = script.Filename
 s script.RemoveOnClose = 1
 Set target = ..TempDir_"/testsudo.sh"
 d ..Sftp.Delete(target)
 d ..LogWrite("Transferring file "_scriptfile_" to "_target)
 Set Status = ..Sftp.Put(scriptfile, target, "0700") 
 i '$$$ISOK(Status) q Status
 k script
#; execute the script
 s cmd = "cd "_..TempDir_"; sudo ./testsudo.sh; echo $?"
 Set Status = ..Execute(cmd,.Response) 
 i '$$$ISOK(Status) q Status
 d ..Sftp.Delete(target)
 d ..LogWrite("Exiting CheckSudo() method")
#;Response is 1 if failure, 0 if success
 i Response q $$$ERROR($$$GeneralError,"Sudo failed")
 q $$$OK
Error s $zt = ""
 q $$$ERROR($$$CacheError,$ze)
}

Method CheckTarfile(kitfile As %String, ByRef Plat = "") As %Boolean [ Private, ProcedureBlock = 1 ]
{
 s $zt = "Error"
 d ..LogWrite("Entering CheckTarFile() method")
 s script = ##class(%Stream.FileCharacter).%New()
 i '$isobject(script) s $ze="Failed to create script file" goto Error
 s script.LineTerminator = $char(10)
 #; get the os type
 d script.WriteLine(":")
 d script.WriteLine("	plat=""""")
 d script.WriteLine("	opsys=`uname -s`")
 d script.WriteLine("	case $opsys in")
 d script.WriteLine("	    AIX)")
 d script.WriteLine("		procnames=`lsdev -C -c processor -F 'name'`")
 d script.WriteLine("		for x in $procnames")
 d script.WriteLine("		do")
 d script.WriteLine("		    lsattr -El $x 1>/dev/null 2>/dev/null || continue")
 d script.WriteLine("		    proc=`lsattr -El $x -a type | (read a b c; echo $b)`")
 d script.WriteLine("		    case $proc in")
 d script.WriteLine("			PowerPC*)")
 d script.WriteLine("				osver=`uname -v`")
 d script.WriteLine("				osminver=`uname -r`")
 d script.WriteLine("				if [ ""$osver$osminver"" -ge ""53"" ] ")
 d script.WriteLine("				then")
 d script.WriteLine("					# Check 64-bit kernel")
 d script.WriteLine("					if [ ""`bootinfo -K`"" = ""64"" ] ; then")
 d script.WriteLine("					    if [ ""$osver$osminver"" -ge ""61"" ]")
 d script.WriteLine("					    then")
 d script.WriteLine("						plat=""ppc64""")
 d script.WriteLine("					    fi")
 d script.WriteLine("					else")
 d script.WriteLine("            				  plat=""ppc""")
 d script.WriteLine("					fi")
 d script.WriteLine("				else plat=""""")
 d script.WriteLine("				fi ;;")
 d script.WriteLine("		    esac")
 d script.WriteLine("		    break")
 d script.WriteLine("		done")
 d script.WriteLine("		;;")
 d script.WriteLine("	    Darwin)")
 d script.WriteLine("		proc=`uname -m`")
 d script.WriteLine("		case $proc in")
 d script.WriteLine("		   i386|x86)")
 d script.WriteLine("			majver=`uname -r | cut -f1 -d.`")
 d script.WriteLine("			#only support 10.6+")
 d script.WriteLine("			if [ ""$majver"" -lt ""10"" ] ; then")
 d script.WriteLine("				plat=""""")
 d script.WriteLine("				break")
 d script.WriteLine("			else")
 d script.WriteLine("				if `sysctl hw | grep cpu64bit_capable | grep 1 > /dev/null 2>&1`")
 d script.WriteLine("			    	then plat=macx64")
 d script.WriteLine("				fi")
 d script.WriteLine("			fi ;;")
 d script.WriteLine("		   x86_64)   plat=macx64 ;;")
 d script.WriteLine("		esac")
 d script.WriteLine("		;;")
 d script.WriteLine("	    HP-UX)")
 d script.WriteLine("		kernel=`getconf KERNEL_BITS 2>/dev/null`")
 d script.WriteLine("		proc=`uname -m`")
 d script.WriteLine("		rel=`uname -r`")
 d script.WriteLine("		case $proc in")
 d script.WriteLine("		    ia64)	plat=hpit ;;")
 d script.WriteLine("		    itanium)	plat=hpit ;;")
 d script.WriteLine("		    *)")
 d script.WriteLine("			case $kernel in")
 d script.WriteLine("			   32)	")
 d script.WriteLine("			   	case $rel in")
 d script.WriteLine("				     ""B.11.11"") plat="""" ;;")
 d script.WriteLine("				     ""B.11.00"") plat="""" ;;")
 d script.WriteLine("				esac")
 d script.WriteLine("				;;")
 d script.WriteLine("			   64)	plat=""hp64"" ;;	# 64-bit")
 d script.WriteLine("			esac")
 d script.WriteLine("			;;")
 d script.WriteLine("		esac")
 d script.WriteLine("		;;")
 d script.WriteLine("	    Linux)")
 d script.WriteLine("		if [ -f /etc/SuSE-release ]")
 d script.WriteLine("		then")
 d script.WriteLine("		    grep ""SUSE Linux Enterprise Server 11"" /etc/SuSE-release > /dev/null 2>&1")
 d script.WriteLine("		    sles=$?")
 d script.WriteLine("		    if [ $sles = 0 ]")
 d script.WriteLine("		    then")
 d script.WriteLine("			proc=`uname -m`")
 d script.WriteLine("			case $proc in")
 d script.WriteLine("			x86_64)   plat=lnxsusex64 ;;")
 d script.WriteLine("			i*86)     plat=lnxsusex86 ;;")
 d script.WriteLine("			esac")
 d script.WriteLine("		    fi")
 d script.WriteLine("		fi")
 d script.WriteLine("		if [ -f /etc/issue ]")
 d script.WriteLine("		then")
 d script.WriteLine("		  distName=`cat /etc/issue | cut -f1 -d"" ""`")
 d script.WriteLine("		  version=`cat /etc/issue | cut -f2 -d"" "" | cut -f1-2 -d"".""`")
 d script.WriteLine("		  proc=`uname -m`")
 d script.WriteLine("		  if [ ""$distName"" = ""Ubuntu"" -a ""$version"" = ""11.04"" -a ""$proc"" = ""x86_64"" ] ; then")
 d script.WriteLine("		    plat=""lnxsusex64""")
 d script.WriteLine("		  fi")
 d script.WriteLine("		fi")
 d script.WriteLine("		if [ -f /etc/redhat-release ]")
 d script.WriteLine("		then")
 d script.WriteLine("		    grep -P 'Red Hat Enterprise Linux .* release 6' /etc/redhat-release > /dev/null 2>&1")
 d script.WriteLine("		    if [ $? = 0 ]")
 d script.WriteLine("		    then")
 d script.WriteLine("			proc=`uname -m`")
 d script.WriteLine("			case $proc in")
 d script.WriteLine("			x86_64)   plat=lnxrhx64 ;;")
 d script.WriteLine("			i*86)     plat=lnxrhx86 ;;")
 d script.WriteLine("			esac")
 d script.WriteLine("	            fi")
 d script.WriteLine("		fi")
 d script.WriteLine("		;;")
 d script.WriteLine("	    SunOS)")
 d script.WriteLine("		mach=`uname -p`")
 d script.WriteLine("		bit=`isainfo -b`")
 d script.WriteLine("		majrev=`uname -r | cut -f1 -d"".""`")
 d script.WriteLine("		minrev=`uname -r | cut -f2 -d"".""`")
 d script.WriteLine("		if [ ""$majrev$minrev"" -ge ""510"" ] ; then")
 d script.WriteLine("		    case $mach in")
 d script.WriteLine("		    	i386)")
 d script.WriteLine("			    case $bit in")
 d script.WriteLine("				64) plat=solx64 ;;")
 d script.WriteLine("			    esac")
 d script.WriteLine("			    ;;")
 d script.WriteLine("			sparc)")
 d script.WriteLine("			    case $bit in")
 d script.WriteLine("				64) plat=usparc ;;")
 d script.WriteLine("			    esac")
 d script.WriteLine("			    ;;")
 d script.WriteLine("		    esac")
 d script.WriteLine("	fi")
 d script.WriteLine("		;;")
 d script.WriteLine("	esac")
 d script.WriteLine("	echo $plat")
 d script.WriteLine("	exit 0")
 #; write it out
 d script.Flush()
 s scriptfile = script.Filename
 s script.RemoveOnClose = 1
 s target = ..TempDir_"/cplatname"
 d ..Sftp.Delete(target)
 d ..LogWrite("Transferring file "_scriptfile_" to "_target)
 s Status=..Sftp.Put(scriptfile, target, "0700")
 i '$$$ISOK(Status) q Status
 k script
#; set the permissions
 Set cmd = "sudo chmod 777 "_target_"; echo $?"
 Set Status = ..Execute(cmd,.Response)
 i '$$$ISOK(Status) q Status
 i Response q $$$ERROR($$$GeneralError,"chmod failed")
#; execute the script
 s cmd = "sudo "_target
 s Status = ..Execute(cmd,.Platform) 
 i '$$$ISOK(Status) q Status
#; delete any old files. Ignore errors.
 d ..Sftp.Delete(target)
 i $find(..KitFile,Platform) {
	 s Status=$$$OK
 } else {
 	s Status=$$$ERROR($$$GeneralError,"Install kit does not match destination platform")
 }
 d ..LogWrite("Exiting CheckTarFile() method")
 q Status
Error s $zt = ""
 q $$$ERROR($$$CacheError,$ze)
}

Method LogError(Status As %Status) [ Internal ]
{
 d ..LogWrite($SYSTEM.Status.GetErrorText(Status))
 q Status
}

Method LogOpen() As %Status [ Internal ]
{
 
 o ..Log:"WNS":5
 i '$t q $$$ERROR($$$GeneralError,"Unable to open log file "_..Log)
 q $$$OK
}

Method LogWrite(Message, NoTimestamp = 0) [ Internal ]
{
 s IO=$i
 u ..Log w !
 i (NoTimestamp=0),(Message'="") {
	 S Time=$zdatetime($h)
	 s Time=$p(Time,"/",1,2)_"/"_$e($p(Time,"/",3),3,4)_"-"_$p(Time," ",2,*)
	 w Time_" "
 }
 w Message
 u IO
 q
}

Method LogClose() [ Internal ]
{
 c ..Log
 q
}

}
