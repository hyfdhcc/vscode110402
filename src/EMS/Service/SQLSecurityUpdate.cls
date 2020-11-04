/// Manages Distributed SQL Security API update messages received by a managed instance.
Class EMS.Service.SQLSecurityUpdate Extends EMS.Service.Base
{

/// The event name
Parameter EVENT = "EMSQMGRc";

/// Get the localized name of the service
/// This method must be overridden for each service
ClassMethod GetLocalizedName() As %String
{
	Quit $$$Text("Distributed SQL Security")
}

/// Signal update process to exit.
ClassMethod StopUpdater() As %Status
{
	try {
		Set Result=$SYSTEM.Event.Signal(..#EVENT,"Exit") 
	} catch {
		Set Result=$$$ERROR($$$CacheError,$ze)
	}
	Quit Result
}

/// Signal update process.  Useful for debugging if it gets stuck.
ClassMethod SignalUpdater() As %Status
{
	try {
		Set Result=$SYSTEM.Event.Signal(..#EVENT) 
	} catch {
		Set Result=$$$ERROR($$$CacheError,$ze)
	}
	Quit Result
}

/// Save Distributed SQL Security update on managed instance.<br>
/// Signal updater to process input or create an updater if none is running. 
ClassMethod Update(GUID As %String, msg As EMS.SQLSecurityMessage) As EMS.Error [ Internal ]
{
	$$$EMSLogObject(7,msg)
	If GUID'=##CLASS(EMS.Instance).InstanceGUID() {
		Set error=##class(EMS.Error).NewError($$$Text("Wrong GUID in Distributed SQL Security Update."),$$$Text("Bad GUID=")_GUID)
		Quit error
	}
	Set error=""
	Set Update=$lb(msg.IssuingUser,msg.Namespace,msg.NumberOfCommands)
	For i=1:1:msg.NumberOfCommands Set $li(Update,i+3)=msg.Commands.GetAt(i)
	Set n=$i(^ISC.EMS.SQLupdate),^ISC.EMS.SQLupdate(n)=Update
	try {
		Set rc=$system.Event.Signal(..#EVENT)
		$$$EMSLogText(7,"EMS.Service.SQLSecurityUpdate UpdateProcess signalled.")
	} catch {
		Job ##Class(EMS.Service.SQLSecurityUpdate).UpdateProcess()
	}
	Quit error
}

/// Process jobbed to process updates saved by web service.<br>
/// Take and hold a lock on ^ISC.EMS.SQLupdate to exclude other updaters.<br>
/// Process all updates in ^ISC.EMS.SQLupdate, then wait for event ..#EVENT to signal more events.<br>
/// Exit if ^ISC.EMS.SQLupdate was killed or if the ..#EVENT was signaled with message "Exit".
ClassMethod UpdateProcess() [ Internal ]
{
	Set $zt="Error"
	$$$EMSLogText(4,"EMS.Service.SQLSecurityUpdate UpdateProcess started.  PID="_$j)
	Lock ^ISC.EMS.SQLupdate:0 s tf=$t
	If 'tf $$$EMSLogText(4,"EMS.Service.SQLSecurityUpdate UpdateProcess already running.")
	If 'tf Quit
	#;Enable updates by process on instance.
	Set $$$EMSManagerDownload="UPDATE"
	Set Event=$System.Event.Create(..#EVENT)
loop	;
	Set LastProcessed=$g(^ISC.EMS.SQLupdate(0),0)
	Set Next=$o(^ISC.EMS.SQLupdate(LastProcessed))
	While Next'="" {
		Set update=$g(^ISC.EMS.SQLupdate(Next))
		$$$EMSLogText(9,"EMS.Service.SQLSecurityUpdate UpdateProcess processing: "_$listtostring(update))
		If update'="" {
			Set rc=..ProcessOneUpdate(update)
			Set ^ISC.EMS.SQLupdated(Next)=update,^ISC.EMS.SQLupdated(Next,"result")=rc,^ISC.EMS.SQLupdated(Next,"job")=$j,^ISC.EMS.SQLupdated(Next,"DT")=$zdt($h) ;Temp:  save data and result.
		}
		Set ^ISC.EMS.SQLupdate(0)=Next
		Set Next=$o(^ISC.EMS.SQLupdate(Next))
	}
	If $d(^ISC.EMS.SQLupdate) Set t=$system.Event.WaitMsg(..#EVENT,60) If $li(t,1)>0,$lg(t,2)'="Exit" Goto loop
Exit	;
	Kill $$$EMSManagerDownload
	d $System.Event.Delete(..#EVENT) L
	$$$EMSLogText(4,"EMS.Service.SQLSecurityUpdate UpdateProcess exited.")
	Quit
Error	;
	Set $zt="",Result=$$$ERROR($$$CacheError,$ze)
	$$$EMSLogText(2,"EMS.Service.SQLSecurityUpdate UpdateProcess error.  "_$system.Status.GetErrorText(Result))
	Goto Exit
}

/// Process one update at the receiving instance.
ClassMethod ProcessOneUpdate(update) As %Status
{
	Set IssuingUser=$li(update,1),Namespace=$li(update,2),NumberOfCommands=$li(update,3)
	For i=1:1:NumberOfCommands {
		Set command=$li(update,i+3),sqlcmd=$p(command," ",1,2)
		$$$EMSLogText(9,"EMS.Service.SQLSecurity.ProcessOneUpdate: "_IssuingUser_", "_Namespace_", "_command)
		#;Execute the SQL command locally
		If sqlcmd="CREATE USER" {
			If ##class(EMS.Instance).IsManaged("Security.Users") { Set Result=$$$ERROR($$$Text("Distributed SQL Security API: Users are managed, you must use EM server to modify.")) }
			Else { Set Result=..SQLExecute(command,Namespace,IssuingUser) }
		} ElseIf sqlcmd="DROP USER" {
			If ##class(EMS.Instance).IsManaged("Security.Users") { Set Result=$$$ERROR($$$Text("Distributed SQL Security API: Users are managed, you must use EM server to modify.")) }
			Else { Set Result=..SQLExecute(command,Namespace,IssuingUser) }
		} ElseIf sqlcmd="CREATE ROLE" {
			If ##class(EMS.Instance).IsManaged("Security.Roles") { Set Result=$$$ERROR($$$Text("Distributed SQL Security API: Security is managed, you must use EM server to modify.")) }
			Else { Set Result=..SQLExecute(command,Namespace,IssuingUser) }
		} ElseIf sqlcmd="DROP ROLE" {
			If ##class(EMS.Instance).IsManaged("Security.Roles") { Set Result=$$$ERROR($$$Text("Distributed SQL Security API: Security is managed, you must use EM server to modify.")) }
			Else { Set Result=..SQLExecute(command,Namespace,IssuingUser) }
		} ElseIf $p(sqlcmd," ",1)="GRANT" {
			Set Result=..SQLExecute(command,Namespace,IssuingUser)
		} ElseIf $p(sqlcmd," ",1)="REVOKE" {
			Set Result=..SQLExecute(command,Namespace,IssuingUser)
		} Else {
			Set Result=$$$OK
			$$$EMSLogText(3,$$$Text("Unknown Distributed SQL Security command in EMS.Service.SQLSecurity.ProcessOneUpdate(")_sqlcmd_")")
		}
		#; If Number of commands ever exceeds 1, we may need to quit out of this loop on error.
		If $$$ISERR(Result) $$$EMSLogText(2,"EMS.Service.SQLSecurity.ProcessOneUpdate: Error Applying Distributed SQL Security update:  "_$system.Status.GetErrorText(Result))
	}
	Quit Result
}

/// Change namespace and execute SQL statement.  Ideally, we would execute the SQL statement in this method, but GRANT and REVOKE revert to the logon roles (bug?).
/// This erases %All from the current roles and makes it impossible to restore the namespace.  Without restoring the Namespace we can't access ^ISC.EMS.SQLupdate or ^ISC.EMS.SQLupdatew.
/// Instead we call DoSQL() where $Roles is newed to protect the process roles.
ClassMethod SQLExecute(command As %String, Namespace As %String, Username As %String) As %Status [ Internal, Private ]
{
	Set Status=$$$OK
	If $d(Namespace)=0 Set Namespace=$Namespace
	try {
		If Namespace'=$Namespace Set oldns=$Namespace zn Namespace
		Set Status=..DoSQL(.command)
		try {
			If $d(oldns) zn oldns
		} catch {
			Set Status=$$$ERROR($$$CacheError,$ze)
			$$$EMSLogText(2,"EMS.Service.SQLSecurityUpdate UpdateProcess error.  "_$system.Status.GetErrorText(Status))
		}
	} catch { ;Error in znamespace command.
		Set Status=$$$ERROR($$$CacheError,$ze)
		$$$EMSLogText(2,"EMS.Service.SQLSecurityUpdate UpdateProcess error.  "_$system.Status.GetErrorText(Status))
	}
	Quit Status
}

/// Execute SQL statement while protecting $Roles
ClassMethod DoSQL(command) As %Status
{
	New $roles ;grant and revoke alter $roles.
	Set Status=$$$OK
	try {
		Set Result=$SYSTEM.SQL.Execute(command)
		If Result.%SQLCODE<0 {
			//Error executing SQL Statement.
			Set Status=$$$ERROR($$$SQLError,Result.%SQLCODE,Result.%Message)
		}
	} catch { 
		Set Status=$$$ERROR($$$CacheError,$ze) 
	}
	Quit Status
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
