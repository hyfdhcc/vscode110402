Include %ems

/// Enterprise Manager distributed SQL Security API
Class %EM.DistSQLSecurity Extends (%RegisteredObject, %XML.Adaptor)
{

/// Localization Domain
Parameter DOMAIN [ Internal ] = "%EMSMessages";

/// Execute an SQL command to update SQL Security meta-data.  Updates can be made on an instance that is a member of an Enterprise Management group that manages the Distributed SQL Security service.  Updates made with Enterprise Manager Distributed SQL Security API class are first applied locally and then distributed to other instances in the EM group containing the Distributed SQL Security service.
/// The command argument is a string containing a valid SQL security command from the following set:  "CREATE USER", "DROP USER", "CREATE ROLE", "DROP ROLE", "GRANT" and "REVOKE".  Any valid command syntax from this set of commands is acceptable.  Other SQL commands (examples:  "CREATE TABLE", "DROP VIEW", "SELECT") are not supported and will return an error status.
/// <br><br>Example commands:
/// <ul><li>CREATE USER UserName IDENTIFIED BY Password</li>
/// <li>DROP USER UserName</li>
/// <li>CREATE ROLE RoleName</li>
/// <li>DROP ROLE RoleName</li>
/// <li>GRANT RoleName TO UserName</li>
/// <li>GRANT PrivilegeName TO RoleName</li>
/// <li>REVOKE RoleName FROM UserName</li></ul>
/// When invoked, the SQL command is first executed on the local instance.  If it fails, an error status is returned and no further processing occurs.  If it succeeds, the command, $username and namespace are transmitted to the Enterprise Manager server where it is stored and forwarded to other members of the group sharing the Distributed SQL Security service.  There, the command is stored and executed by a background process and the results are saved.  When the update has been received by all instances, the message is deleted on the EM server.
/// The CREATE/DROP USER commands are disabled for instances that are managed for Users and the CREATE/DROP ROLE commands are disabled for instances that are managed for Security.
ClassMethod Execute(Command As %String) As %Status
{
	i '##class(%SYS.EMS).IsManagedForService("SQLSecurityUpdate") Quit $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Instance not managed for Distributed SQL Security."))
	Set command=$zstrip(Command,"<=>"," ")
	Set c1=$zconvert($p(command," ",1),"U")
	Set rc = $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Invalid or unsupported command."))
	tstart
	s $zt="Error"
	if c1="CREATE" {
		set c2=$zconvert($p(command," ",2),"U")
		if c2="USER" { 
			s c3=$zconvert($p(command," ",4,5),"U")
			if c3="IDENTIFIED BY"||(c3="IDENTIFY BY") { 
				Set rc = ..CreateUser($p(command," ",3),$p(command," ",6))
			} else {
				Set rc = $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Invalid or unsupported command."))
			}
		} elseif c2="ROLE" {
			Set rc = ..CreateRole($p(command," ",3))
		}
	} elseif c1="DROP" {
		set c2=$zconvert($p(command," ",2),"U")
		if c2="USER" {
			Set rc = ..DropUser($p(command," ",3))
		} elseif c2="ROLE" {
			Set rc =  ..DropRole($p(command," ",3))
		} else {
			Set rc = $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Invalid or unsupported command."))
		}
	} elseif c1="GRANT" {
		Set rc = ..Grant($p(command," ",2,*))
	} elseif c1="REVOKE" {
		Set rc = ..Revoke($p(command," ",2,*))
	} else {
		Set rc = $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Invalid or unsupported command."))
	}
	if $$$ISERR(rc) trollback
	if $$$ISOK(rc) tcommit
	Quit rc
Error	;
	Set $zt=""
	trollback
	Quit $$$ERROR($$$CacheError,$zerror)
}

/// Create a User<b>
/// Argument "Name" is the name of the user to create.<b>
/// Argument "Password" is the password for the created user.
ClassMethod CreateUser(Name As %String, Password As %String) As %Status [ Internal, Private ]
{
	#; Check auth.
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) { Set Status=$$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName) quit Status }
	Set Status=$$$OK
	#; Format command
	Set command="CREATE USER "_Name_" IDENTIFY BY "_Password
	#; Execute locally
	Set Result=..SQLExecute(command)
	if Result.%SQLCODE<0 {
		#;Error
		Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		Quit Status
	}
	#; Forward to EM server
	Set Status = ..SendToServer(command)
	#; Return Status
	Quit Status
Error	;
 Set $zt=""
 Quit $$$ERROR($$$CacheError,$zerror)
}

/// Drop a User<b>
/// Argument "Name" is the name of the User to drop
ClassMethod DropUser(Name As %String) As %Status [ Internal, Private ]
{
	#; Check auth
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) { Set tSC=$$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName) Quit  }
	If ##class(%SYS.EMS).IsManagedForService("Users") Quit $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Users are managed, you must use EM server to modify."))
	Set Status=$$$OK
	#; Format command
	Set command="DROP USER "_Name
	#; Execute locally
	Set Result=..SQLExecute(command)
	If Result.%SQLCODE<0 {
		#; Error
		Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		Quit Status
	}
	#; Forward to EM server
	Set Status = ..SendToServer(command)
	#; Return Status
	Quit Status
}

/// Create a Role<b>
/// Argument "Name" is the name of the role to create
ClassMethod CreateRole(Name As %String) As %Status [ Internal, Private ]
{
	#; Check auth
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) { Set tSC=$$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName) Quit  }
	If ##class(%SYS.EMS).IsManagedForService("Security") Quit $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Security is managed, you must use EM server to modify."))
	Set Status=$$$OK
	#; Format command
	Set command="CREATE ROLE "_Name
	#; Execute locally
	Set Result=..SQLExecute(command)
	If Result.%SQLCODE<0 {
		#;Error
		Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		Quit Status
	}
	#; Forward to EM server
	Set Status = ..SendToServer(command)
	#; Return Status
	Quit Status
}

/// Drop a Role<b>
/// Argument "Name" is the name of the role to drop
ClassMethod DropRole(Name As %String) As %Status [ Internal, Private ]
{
	#; Check auth
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) { Set tSC=$$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName) Quit  }
	If ##class(%SYS.EMS).IsManagedForService("Security") Quit $$$ERROR($$$EMSError,$$$Text("Distributed SQL Security API: Security is managed, you must use EM server to modify."))
	Set Status=$$$OK
	#; Format command
	Set command="DROP ROLE "_Name
	#; Execute locally
	Set Result=..SQLExecute(command)
	If Result.%SQLCODE<0 {
		#;Error
		Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		Quit Status
	}
	#; Forward to EM server
	Set Status = ..SendToServer(command)
	#; Return Status
	Quit Status
}

/// Grant role or privilege.<b>
/// Argument "GrantArgs" is a string conaining arguments to the "GRANT" command.<b>
/// The "GRANT" command will be prefixed to GrantArgs to create a SQL statement.  So if you want to distribute the SQL command "GRANT RoleName TO Username" you would call ##CLASS(%EM.DistSQLSecurity).Grant("RoleName TO Username").
ClassMethod Grant(GrantArgs As %String) As %Status [ Internal, Private ]
{
	#; Check auth
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) { Set tSC=$$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName) Quit  }
	Set Status=$$$OK
	#; Format command
	Set command="GRANT "_GrantArgs
	#; Execute locally - not sure if we need to set ppg for grant/revoke
	Set Result=..SQLExecute(command)
	;Set Result=..SQLExecute(command)
	If Result.%SQLCODE<0 {
		#;Error
		Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		Quit Status
	}
	#; Forward to EM server
	Set Status = ..SendToServer(command)
	#; Return Status
	Quit Status
}

/// Revoke role or privilege.<b>
/// Argument "RevokeArgs" is a string conaining arguments to the "REVOKE" command.<b>
/// The "REVOKE" command will be prefixed to RevokeArgs to create a SQL statement.  So if you want to distribute the SQL command "REVOKE RoleName FROM Username" you would call ##CLASS(%EM.DistSQLSecurity).Revoke("RoleName FROM Username").
ClassMethod Revoke(RevokeArgs As %String) As %Status [ Internal, Private ]
{
	#; Check auth
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) { Set tSC=$$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName) Quit  }
	Set Status=$$$OK
	#; Format command
	Set command="REVOKE "_RevokeArgs
	#; Execute locally - not sure if we need to set ppg for grant/revoke
	Set Result=..SQLExecute(command)
	If Result.%SQLCODE<0 {
		#;Error
		Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		Quit Status
	}
	#; Forward to EM server
	Set Status = ..SendToServer(command)
	#; Return Status
	Quit Status
}

/// Update enabling ppg if necessary and execute SQL statement on local instance.
/// Must run in namespace metadata applies to.
ClassMethod SQLExecute(command As %String) As %Status [ Internal, Private ]
{
	Set t=$g($$$EMSManagerDownload,"undefined")
	If t="undefined" Set $$$EMSManagerDownload=""
	try { Set Result=$SYSTEM.SQL.Execute(command) }
	catch { Set Result=$$$ERROR($$$CacheError,$ze) }
	If t="undefined" Kill $$$EMSManagerDownload
	Quit Result
}

/// Transmit update to EM Server.
/// Use %SYS.EMS which can add %All temporarily because we must change namespace to %SYS to execute EMS.Instance to transmit message.
ClassMethod SendToServer(command As %String) As %Status [ Internal, Private ]
{
	Quit ##class(%SYS.EMS).SendSQLSecUpdateToServer(command)
}

}
