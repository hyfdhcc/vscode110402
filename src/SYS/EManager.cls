Include %ems

/// This class provides a set of public APIs for an Instance managed by the Enterprise Manager.
Class SYS.EManager Extends %RegisteredObject
{

Parameter DOMAIN [ Internal ] = "%EMSMessages";

/// Allows an application to control whether a managed Instance will accept updates
/// from the Enterprise Manager for a specific Service, and helps manage user access
/// to the system. Returns the current state as a %Boolean value. The default is for
/// updates to all Services to be enabled. This requires %Admin_Secure and %Admin_Manage
/// privileges to change 'Enabled'.
/// <br><br>
/// No 'Enabled' argument just returns current status for a Service.
/// <br><br>
/// This setting will be remembered even if the Instance is not managed for a Service or
/// is removed from management.
/// <br><br>
/// Note that future versions of Enterprise Manager and Cache should provide features
/// (such as run-levels or full synchronization of updates between Instances) that make this unnecessary.
/// But this is provided as an interim step to facilitate application controlled updates.
ClassMethod UpdateEnabled(ServiceName As %String, Enabled As %Boolean) As %Boolean
{
	Set enabled=0,managed=0
	Try {
		If ServiceName="Configuration" Set ServiceName="Config"
		#; make sure it's a valid Service name
		Set service=##class(EMS.Service.Base).GetService(ServiceName) Quit:service=""
		#; see if the user has privs to modify service.Enabled
		Set secerror=##class(EMS.Utils).CheckSecurity()
		Set instance=##class(EMS.Instance).Open(4)
		If instance'="" {
			Set service=instance.Services.GetAt(ServiceName)
			If service'="" {
				Set enabled=$s(service.Enabled="":1,1:service.Enabled),managed=1
				If '$d(Enabled) Quit
				If secerror="" {
					Set service.Enabled=+Enabled
					Set sc=service.%Save() If $$$ISERR(sc) Quit
					Set enabled=service.Enabled
					Set ^ISC.EMS("ServiceEnabled",ServiceName)=+Enabled
				}
			}
		}
		#; if  we're not managed for this Service, save Enabled in the global
		If 'managed {
			If $d(Enabled),secerror="" Set ^ISC.EMS("ServiceEnabled",ServiceName)=+Enabled
			Set enabled=+$g(^ISC.EMS("ServiceEnabled",ServiceName))
		}
	} Catch {
	}
	Quit enabled
}

/// Indicates that an Enterprise Manager update is in progress.
/// Can be checked to see when it's safe to enable user access.
/// Also returns date/time for last update completed.
ClassMethod UpdateInProgress(Output LastUpdateComplete As %TimeStamp) As %Boolean
{
	Set LastUpdateComplete="",inprogress=0
	Try {
		Set instance=##class(EMS.Instance).Open(0) If instance="" Quit
		Set LastUpdateComplete=instance.LastUpdateTime
		Set inprogress=+(instance.UpdateInProgress)
	} Catch {
	}
	Quit inprogress
}

/// Contacts the Enterprise Manager to get the current status of the Instance and
/// check the connection. Returned value may be 'NotManaged', 'NoAnswer','AwaitingAcceptance',
/// 'Managed','Suspended', 'NotUpdated','RejectedForManagement', or 'RemovedFromManagement'.
/// Caller should handle any unknown status code to accomodate future versions.
ClassMethod Status() As %String
{
	Set return="NoAnswer"
	Try {
		Set instance=##class(EMS.Instance).Open(0)
		If instance="" Set return="NotManaged" Quit
		Set request=##class(EMS.ServiceMessageContent).%New()
		Set error=instance.CallWebMethod("Ping",request,.response,$$$EMSControlTimeoutDefault)
		If error="" {
			Set state=response.State
		} Else {
			#; if we can't contact the Instance, then return the local state
			Set state=instance.State
		}
		If state=$$$EMSCStateAwaitingAccept { Set return="AwaitingAcceptance" }
		ElseIf state=$$$EMSCStateAwaitingReaccept { Set return="AwaitingAcceptance" }
		Elseif state=$$$EMSCStateManaged { Set return="Managed" }
		Elseif state=$$$EMSCStateSuspended { Set return="Suspended" }
		Elseif state=$$$EMSCStateNotUpdated { Set return="NotUpdated" }
		Elseif state=$$$EMSCStateRejected { Set return="RejectedForManagement" }
		Elseif state=$$$EMSCStateRemoved { Set return="RemovedFromManagement" }
		Else { Set return="Unknown" }
	} Catch {
		s return="Unexpected error: "_$ze
	}
	Quit return
}

/// Suspend management of this Instance. Returns 1 (success) or 0 (fail).
/// 'Error' may contain a text error message if this fails for some reason.
/// <br> <br>
/// Note that this is primarily for use in emergency situations where CSP has
/// been disabled accidentally, and it's not possible to use the Management Portal
/// or the Enterprise Manager (which both depend on CSP) to Suspend management.
/// The Instance will be Suspended and local management enabled, regardless of
/// whether we can contact the Enterprise Manager.
ClassMethod SuspendManagement(Output Error As %String) As %Boolean
{
	Set return=1,Error=""
	Try {
		Set err=##class(EMS.Instance).SuspendManagement(1,.return)
		If err'="" Set Error=err.AsString()
	} Catch {
		s return=0
		s Error="Unexpected error: "_$ze
	}
	Quit return
}

/// Returns "SSL", "WS-Security", or "None" to indicate security setting of EM, and the Certificate values
/// as an array. This step is optional if the user knows the security setting and doesn't want to check the
/// certificate. Might also return "Error: error message" if there's a problem.
ClassMethod GetPolicy(ManagerAddress As %List, ByRef Certificate As %String) As %String
{
	Set return="",Certificate=""
	Try {
		If ##class(EMS.Instance).IsRegistered() {
			Set return="Error: "_$$$Text("This Instance is already Registered or has already requested Registration.")
			Quit
		}
		Set host=$lg(ManagerAddress,1),port=$lg(ManagerAddress,2),prefix=$lg(ManagerAddress,3)
		Set error=##class(EMS.Instance).RegisterInit(host,port,prefix,.policy,.endpoint)
		If error="" {
			Set type=policy.PolicyId
			Set cert="" If type'="Username" s cert=policy.Certificate
			Set return=$s(type="X509":"WS-Security",type="SSL":"SSL",1:"None")
			If cert'="" {
				Set Certificate("Subject") = $System.Encryption.X509GetField(cert,"Subject")
				Set Certificate("Issuer") = $System.Encryption.X509GetField(cert,"Issuer")
				Set Certificate("Serial Number") = $System.Encryption.X509GetField(cert,"SerialNumber")
			}
		} Else {
			Set return="Error: "_error.Text_" "_error.Detail
		}
	} Catch ex {
		s return="Error: "_$ze
	}
	Quit return
}

/// Request registration with Enterprise Manager for this Instance.
/// <br>
/// The 'Address' arguments are three element $List structures with a HostName (or IP address),
/// Port and an optional Prefix (for hosted CSP connections).
/// <br>
/// 'SecurityName' is either an SSL/TLS configuration name or an X.509 credentials alias (or null). 
/// The user is responsible for creating these using the UI or Security class APIs.
/// <br>
/// Will return null "" on success or an error string if there's a problem.
ClassMethod RequestRegistration(ManagerAddress As %List, InstanceAddress As %List, InstanceDescription As %String, SecurityName As %String) As %String
{
	Set return=""
	Try {
		If ##class(EMS.Instance).IsRegistered() {
			Set return="Error: "_$$$Text("This Instance is already Registered or has already requested Registration.")
			Quit
		}
		#; Set up policy for instance
		Set host=$lg(ManagerAddress,1),port=$lg(ManagerAddress,2),prefix=$lg(ManagerAddress,3)
		Set error=##class(EMS.Instance).RegisterInit(host,port,prefix,.mgrPolicy,.endpoint)
		If error="" {
			Set policyId=mgrPolicy.PolicyId
			Set policy = ##class(EMS.Connection.Policy).GetPolicy(policyId)
			If policyId = "Username" {
				Set policy.Username = $$$EMSManagerProxyUsername
				Set policy.Password = ##class(%SYS.EMS).GeneratePassword(16)
			} ElseIf policyId = "SSL" {
				Set policy.SSLConfiguration = SecurityName
			} ElseIf policyId = "X509" {
				Set policy.X509CredentialsAlias = SecurityName
			}	
			Set host=$lg(InstanceAddress,1),port=$lg(InstanceAddress,2),prefix=$lg(InstanceAddress,3)
			If (host="")||(port="") {
				Set status=##Class(%Library.RoutineMgr).GetWebServerPort(.defPort,.defHost)
				If status=$$$OK Set:host="" host=defHost Set:port="" port=defPort
			}
			Set error=##class(EMS.Instance).RequestManagement(host,port,prefix,InstanceDescription,policy,0)
		}
		If error'="" Set return="Error: "_error.Text_" "_error.Detail
	} Catch ex {
		s return="Unexpected error: "_$ze
	}
	Quit return
}

}
