Include %ems

/// Utilities for EMS Management.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class %SYS.EMS Extends %RegisteredObject
{

Parameter DOMAIN [ Internal ] = "%EMSMessages";

ClassMethod GetInstanceState(Output IsManaged As %Boolean, Output Services As %String) As %String [ Internal ]
{
	Try {
		$$$AddAllRoleTemporaryInTry
		New $namespace
		Set $namespace = "%SYS"
		Set instance = ##class(EMS.Instance).Open(,.error)
		If '$isobject(instance) Throw
		Set stateString = ##class(EMS.Instance).StateAsString(instance.State)
		If instance.State = $$$EMSCStateManaged {
			Set IsManaged = 1
			Set Services = ##class(EMS.Instance).ServicesAsString(1,1)
		} Else {
			Set IsManaged = 0
			Set Services = ""
		}
	} Catch Error {
		Set stateString = $$$Text("Not managed")
		Set IsManaged = 0
		Set Services = ""
	}
	Quit stateString
}

ClassMethod IsManagedForService(ServiceName As %String, status As %Status) As %Boolean
{
	Try {
		$$$AddAllRoleTemporaryInTry
		New $namespace
		Set $namespace = "%SYS"
		Set status=$$$OK
		Set instance = ##class(EMS.Instance).Open(,.error)
		If '$isobject(instance) Throw ##class(%Exception.StatusException).CreateFromStatus($s($isobject(error):error.AsStatus(),1:$$$ERROR($$$Text("Could not open EMS Instance object"))))
		If instance.State = $$$EMSCStateManaged {
			Set service=instance.Services.GetAt(ServiceName)
			Set IsManaged=$s(service="":0,1:1)
		} Else {
			Set IsManaged = 0
		}
	} Catch Error {
		Set IsManaged = 0
		Set status = Error.AsStatus()
	}
	Quit IsManaged
}

/// *** EMS API for instance.<br>
/// Return true if this instance is an EMS manager
ClassMethod IsEMSManager(Output tSC As %Status) As %Boolean [ Internal ]
{
	Try {
		$$$AddAllRoleTemporaryInTry
		Set isEMS = 0
		New $namespace
		Set $namespace = "%SYS"
		If ##class(Config.Namespaces).Exists($$$EMSNamespace) {
			Set $namespace = $$$EMSNamespace
			New %emsroot
			Set isEMS=(##class(Manager.Root).GetEMSRoot()'="")
		}
		Set tSC = $$$OK
	} Catch Error {
		Set isEMS = 0
		Set tSC = Error.AsStatus()
	}
	Quit isEMS
}

/// Return true if this is an EMS manager and we are not in a group's context<br>
/// (unless the debug variable is on.)<br>
ClassMethod IsEMSManagerSMP() As %Boolean [ Internal ]
{
	Set returnVal = 0
	Try {
		If ..IsEMSManager() {
			$$$AddAllRoleTemporaryInTry
			New $namespace
			Set $namespace = $$$EMSNamespace
			If ($G(^ISC.EMS("ManagerSMP"))'=1) Set returnVal = 1
		}
	} Catch {
		Set returnVal = 0
	}
	Quit returnVal
}

ClassMethod IsEMSSetUp() As %Boolean [ Internal ]
{
	Try {
		$$$AddAllRoleTemporaryInTry
		New $namespace
		Set $namespace = "%SYS"
		Set instance = ##class(EMS.Instance).Open(,.tErr)
		If ('instance || tErr) {
			Set isSetUp = 0
		} Else {
			Set isSetUp = 1
		}
	} Catch Error {
		Set isSetUp = 0
	}
	Quit isSetUp
}

/// *** EMS API for instance.<br>
/// Return true if this instance is currently being managed for the specified service
/// serviceName and GroupName arguments are never used after 2013.2. 
/// However, these arguments are kept so that code may be moved to 2013.2 as needed.
ClassMethod IsReadOnly(classname As %String, serviceName As %String, GroupName As %String, Output tSC As %Status) As %Boolean [ Internal ]
{
	Try {
		If classname = "",$get(serviceName) = "" {
			Set isReadOnly = 0
		} ElseIf ($get(GroupName) = "") || '..IsValidGroupName(GroupName,.groupID) || '..IsEMSManager() {
			// managed instance - we are read only if the service is managed
			$$$AddAllRoleTemporaryInTry
			New $namespace
			Set $namespace = "%SYS"
			Set isReadOnly = ##class(EMS.Instance).IsManaged(classname,.tError)
			If tError Set tSC = tError.AsStatus()
		} Else {
			// EMS - we are read only if we are not the edit user
			New $namespace
			Set $namespace = $$$EMSNamespace
			Set canEdit = ##class(Manager.Group).IsEditable(groupID,serviceName,.isBeingEdited,.tError)
			If tError Set tSC = tError.AsStatus()
			If canEdit && isBeingEdited {
				Set isReadOnly = 0
			} Else {
				Set isReadOnly = 1
			}
		}
		Set tSC = $$$OK
	} Catch Error {
		Set isReadOnly = 0
		Set tSC = Error.AsStatus()
	}
	
	Quit isReadOnly
}

ClassMethod GetGroupID(GroupName As %String) As %Integer [ Internal, Private ]
{
	Try {
		New $namespace
		Set $namespace = $$$EMSNamespace
		Set group = ##class(Manager.Group).NameIndexOpen(GroupName)
		Set id = group.%Id()
	} Catch Error {
		Set id = -1
	}
	Quit id
}

/// If GroupName is an EMS group's name this returns 1, with GroupID = the group's ID.<br/>
/// Otherwise, returns 0 and GroupID = -1.</br>
ClassMethod IsValidGroupName(GroupName As %String, Output GroupID As %Integer) As %Boolean [ Internal, Private ]
{
	If GroupName = "" {
		Set GroupID = -1
		Quit 0
	}
	Set GroupID = ..GetGroupID(GroupName)
	If GroupID = -1 {
		Quit 0
	}
	
	Quit 1
}

/// Generates a random password of a specified length.<br>
/// Append a few characters to the end of the password to ensure it meets complexity requirements.
ClassMethod GeneratePassword(Length As %Integer = 16) As %String [ Internal ]
{
	Set pass = ""
	For i=1:1:(Length-4) {
		Set pass = pass_$char($random(95)+32)
	}
	Set pass = pass_"aA1!"
	Quit pass
}

ClassMethod SendSQLSecUpdateToServer(command As %String) As %Status [ Internal ]
{
	#; Insure user has role/resource
	If '$SYSTEM.Security.Check($$$EMSDistributedSQLSecurityAPI,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$EMSDistributedSQLSecurityAPI_":"_$$$PermUseName)
	}
	Set status=$$$OK
	#; Send message.
	try {
		$$$AddAllRoleTemporaryInTry
		Set oldns=$namespace
		New $namespace Set $namespace = "%SYS"
		try { 
			Set error=##class(EMS.Instance).DistSQLSecurityUpdate(command,oldns)
			If $ISOBJECT(error) {
				$$$EMSLogText(2,"Error sending command %EM.DisSQLSecurity.SendToServer() - "_error.AsString())
				Set status=error.AsStatus()
			}
		} catch {
			Set status=$$$ERROR($$$EMSError,$$$Text("Error sending SQL Security update to Enterprise Manager, ")_$system.Status.GetErrorText($$$ERROR($$$CacheError,$zerror)))
		}
	} catch {
		Set status=$$$ERROR($$$EMSError,$$$Text("Error sending SQL Security update to Enterprise Manager, ")_$system.Status.GetErrorText($$$ERROR($$$CacheError,$zerror)))
	}
	Quit status
}

}
