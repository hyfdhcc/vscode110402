Include %ems

/// This class implements a remote API that may be used to control several basic functions of an Enterprise Manager server.
/// This allows the user to write systems management scripts, by invoking Enterprise Manager methods.
/// <br><br> 
/// The %EM.Session object starts and maintains the API session with the EM server, and serves as the web client to make the remote calls.
/// The Remote API must first be enabled on Enterprise Manager and the Security Policy defined (Username, WS-Security, or SSL/TLS Security).
/// This Security Policy corresponds to the %EM.Session.Type property ("Username", "X509", "SSL"), which must be defined in the
/// session object. 
/// The programmer first instantiates and sets all the necessary properties of an %EM.Session object (see StartSession).
/// All error reporting by this API will be done by Throwing a %Exception.EMAPI. So all calls should be made within a Try/Catch block.
/// The session is connected by calling StartSession: 
/// <br>
/// <example>
/// set session=##class(%EM.Session).%New()
/// set session.Type="Username"
/// set session.Username="Manager"
/// set session.Password="password"
/// set session.Host="localhost"
/// set session.Port=57780
/// set session.Prefix=""
/// try {
/// 	write !,"Call StartSession"
/// 	do session.StartSession()
/// } catch ex {
/// 	write !,"Error: ",ex.DisplayString()
/// }
/// </example>
/// <br>
/// The %EM.Sesssion object may then be used for further API calls:
/// <br>
/// <example>
/// set status=1
/// set group="GRP1",service="Namespace"
/// #; do Submit/Approve/Activate for an edited Service
/// try {
/// 	do session.EditComplete(group,service)
/// 	do session.EditApprove(group,service)
/// 	do session.EditActivate(group,service)
/// 	do session.EndSession()
/// } catch ex {
/// 	write !,"Error: ",ex.DisplayString()
/// 	set status=0
/// }
/// q status
/// </example>
Class %EM.Session Extends %SOAP.WebClient [ System = 4 ]
{

/// Localization Domain
Parameter DOMAIN [ Internal ] = "%EMSMessages";

/// Name of the WebService.
Parameter SERVICENAME [ Internal ] = "EMAPIService";

/// SOAP Namespace for the WebService
Parameter NAMESPACE [ Internal ] = "http://www.intersystems.com/ems/api";

/// Allow WS-Security header
Parameter SECURITYIN = "ALLOW";

///  If the web client has the parameter SOAPACTIONQUOTED=1, then the web client will
/// quote the SOAPAction value for SOAP 1.1.
Parameter SOAPACTIONQUOTED As %Boolean = 0;

/// Type of security to be used for the session:
/// "SSL" for SSL/TLS, "X509" for WS-Security or "Username" for only username security.
Property Type As %String;

/// Name of Security.SSLConfig object if SSL to be used
Property Config As %String;

/// Username for session authentication
Property Username As %String;

/// Password for session authentication.
/// Note that the password is cleared after StartSession is called.
Property Password As %String;

/// Host IP address or DNS name of EM server.
Property Host As %String;

/// Port at host address of EM server.
Property Port As %String;

/// CSP prefix to be used for CSP host address of EM server.
Property Prefix As %String;

/// True (1) if the session has been started
Property IsStarted As %Boolean [ InitialExpression = 0 ];

/// True (1) if the session is being started
Property IsStarting As %Boolean [ InitialExpression = 0, Internal, Private ];

/// The GetEMCertificate method is used to query the EM for its certificate.
/// The Host, Port and Prefix properties must be set before calling GetEMCertificate.
Method GetEMCertificate() As %Binary
{
	If ..Host="" {
		Throw ##class(%Exception.EMAPI).ClientError("Host property must be specified for GetEMCertificate call.")
		Quit ""
	}
	
	// Set %Net.HttpRequest object
	Set httprequest=##class(%Net.HttpRequest).%New()
	Set httprequest.Server=..Host
	Set httprequest.Port=..Port
	Set httprequest.Timeout=2
	Set httprequest.ReadRawMode=1
	// Use string for response
	Set httprequest.ResponseStream="string"
	
	// Set URL for certificate request
	Set application=$select(..Prefix="":"",1:"/"_..Prefix)_$$$EMSWSConnectionApp_"/Manager.API.GetEMCertificate.cls"
	Set application=application_"?CacheUserName="_$$$EMSRegistrarUsername_"&CachePassword="_$$$EMSRegistrarPassword
	
	// Get certificate
	Set sc=httprequest.Get(application)
	If $$$ISERR(sc) {
		Throw ##class(%Exception.StatusException).CreateFromStatus(sc)
		Quit ""
	}
	
	Set response=httprequest.HttpResponse
	If response.StatusCode'=200 {
		Throw ##class(%Exception.EMAPI).EMError("Unexpected status requesting certificate.  Status="_response.StatusCode)
		Quit ""
	}
	
	If response.ContentLength=0 Quit ""
	
	Quit $system.Encryption.Base64Decode(response.Data.Read())
}

Method CallWebMethod(name As %String, resultRequired As %Boolean = 0, arg1, arg2, arg3, arg4, arg5) [ Internal ]
{
	// Session must have been started for all calls except StartSession.
	If '..IsStarted,'..IsStarting {
		Throw ##class(%Exception.EMAPI).ClientError("The session has not been started.")
		Quit ""
	}
	Try {
		Set ..IsStarting=0
		Set action="http://www.intersystems.com/ems/api/Manager.API.WebService."_name
		If resultRequired {
			If '$data(arg1) {
				Set result=..WebMethod(name).Invoke($this,action)
			} ElseIf '$data(arg2) {
				Set result=..WebMethod(name).Invoke($this,action,arg1)
			} ElseIf '$data(arg3) {
				Set result=..WebMethod(name).Invoke($this,action,arg1,arg2)
			} ElseIf '$data(arg4) {
				Set result=..WebMethod(name).Invoke($this,action,arg1,arg2,arg3)
			} ElseIf '$data(arg5) {
				Set result=..WebMethod(name).Invoke($this,action,arg1,arg2,arg3,arg4)
			} Else {
				Set result=..WebMethod(name).Invoke($this,action,arg1,arg2,arg3,arg4,arg5)
			}
		} Else {
			If '$data(arg1) {
				Do ..WebMethod(name).Invoke($this,action)
			} ElseIf '$data(arg2) {
				Do ..WebMethod(name).Invoke($this,action,arg1)
			} ElseIf '$data(arg3) {
				Do ..WebMethod(name).Invoke($this,action,arg1,arg2)
			} ElseIf '$data(arg4) {
				Do ..WebMethod(name).Invoke($this,action,arg1,arg2,arg3)
			} ElseIf '$data(arg5) {
				Do ..WebMethod(name).Invoke($this,action,arg1,arg2,arg3,arg4)
			} Else {
				Do ..WebMethod(name).Invoke($this,action,arg1,arg2,arg3,arg4,arg5)
			}
			Set result=""
		}
	} Catch ex {
		If $ze["<ZSOAP>" {
			If $$$GETERRORCODE(%objlasterror)=$$$ERRORCODE($$$SOAPFaultReceived) {
				Throw ##class(%Exception.EMAPI).CreateFromFault(..SoapFault)
			} Else {
				Throw ##class(%Exception.StatusException).CreateFromStatus(%objlasterror)
			}
		} Else {
			Throw ex
		}
		Set result=""
	}
	
	Quit result
}

/// The programmer needs to first instantiate and fill in the descriptive arguments of an %EM.Session object.
/// The session is then started by calling StartSession.
/// The Type, Config, Username, Password, Host, Port and Prefix properties must be set before calling StartSession.<br>
/// The Config property of %EM.Session must be set according to the type of the session security.<br>
/// The Security.SSLConfig object must be created using the SMP or the usual Security.SSLConfig API with the client side certificate being optional.
/// Authentication and Authorization are done by the username and password.  The Security.SSLConfig is only used for Encryption.<br>
/// The %SYS.X509Credentials object must contain the private key which will be used to identify the client computer.
/// Authentication and Authorization is done by the username and password.  The %SYS.X509Credentials is only used for Encryption. 
Method StartSession(type As %String = "") [ WebMethod ]
{
	If ..IsStarted {
		Throw ##class(%Exception.EMAPI).ClientError("The session has already been started.")
		Quit
	}
	
	// Force a new %Net.HttpRequest object to create new session if StartSession called again.
	Set ..HttpRequest=""
	Set ..SessionCookie=""
	// If X509 force a new secure conversation session
	Set ..SecurityContextToken=""

	If ..Type="" Set ..Type=type
	If (..Type="") || (..Username="") || (..Password="") || (..Host="") {
		Throw ##class(%Exception.EMAPI).ClientError("Type, Username, Password and Host properties must be specified for StartSession call.")
		Quit
	}
	
	If ..Type="X509" {
		Set certificate=..GetEMCertificate()
		If certificate="" {
			Throw ##class(%Exception.EMAPI).ClientError("For X509 security, GetEMCertificate did not return a certificate.  Probably not configured for X.509 security.")
			Quit
		}
		Set credentials=##class(%SYS.X509Credentials).%New()
		Set credentials.Certificate=certificate
		Set token=##class(%SOAP.Security.BinarySecurityToken).CreateX509Token(credentials)
		Do ..SecurityOut.AddToken(token)
	} ElseIf ..Type="SSL" {
		If ..Config="" {
			Throw ##class(%Exception.EMAPI).ClientError("For SSL security, Config must be specified.")
			Quit
		}
		Set ..SSLConfiguration=..Config
	} ElseIf ..Type="Username" {
	} Else {
		Throw ##class(%Exception.EMAPI).ClientError("Valid security type was not specified: "_..Type)
		Quit
	}

	If '##class(%SOAP.Policy).PolicyExists("%EM.Session","%EM.Policy."_..Type_":APIConnection") {
		Set compiledclass=##class(%Dictionary.CompiledClass).%OpenId("%EM.Policy."_..Type,,.sc)
		If $$$ISOK(sc) {
			Set sc=##class(%SOAP.Configuration).ParseAll("%EM.Policy."_..Type,compiledclass)
		}
		If $$$ISERR(sc) {
			Throw ##class(%Exception.EMAPI).ClientError("Start Session instantiate policy error: "_$system.Status.GetErrorText(sc))
			Quit
		}
	}

	Set policy=$classmethod("%EM.Policy."_..Type,"%New")

	Set token=##class(%SOAP.Security.UsernameToken).Create(..Username,..Password)
	Do ..SecurityOut.AddSecurityElement(token)
	Do policy.AssociateConfiguration("%EM.Session", "APIConnection")

	Set endpoint=##class(%CSP.Endpoint).%New()
	Set endpoint.Host=..Host
	Set endpoint.Port=..Port
	Set endpoint.Prefix=..Prefix
	Set endpoint.CSPApplication=$$$EMSWSManagerAPIApp
	Set endpoint.ServiceClass="Manager.API.WebService"
	Set ..Location=endpoint.GetLocation(..Type="SSL")
	
	Set ..IsStarting=1
	Try {
		Do ..CallWebMethod("StartSession",0,..Type)
		Set ..Password=""
		Set ..SecurityOut=""
		Set ..IsStarted=1
	} Catch ex {
		Throw ex
	}
}

/// Make sure that EndSession is always called.
Method %OnClose() As %Status [ Internal, Private ]
{
	If ..IsStarted Do ..EndSession()
	Quit $$$OK
}

/// EndSession ends the session associated with this %EM.Session object.
Method EndSession() [ WebMethod ]
{
	Do ..CallWebMethod("EndSession",0)
	Set ..IsStarted=0

	// Force a new %Net.HttpRequest object to create new session if StartSession called again.
	Set ..HttpRequest=""
	Set ..SessionCookie=""
	// If X509 force a new secure conversation session
	Set ..SecurityContextToken=""
}

/// Review Managent Request for an Instance. Returns a list of %String with the Issuer, SerialNumber, and Subject in that order.
Method ReviewManagementRequest(instanceName As %String) As %EM.DataList [ WebMethod ]
{
	Quit ..CallWebMethod("ReviewManagementRequest",1,instanceName)
}

/// Accept a Management Request for an Instance.
Method AcceptManagement(instanceName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("AcceptManagement",0,instanceName)
}

/// CreateGroup creates a new group.
Method CreateGroup(name As %String, description As %String = "", serviceList As %String = "") [ WebMethod ]
{
	Do ..CallWebMethod("CreateGroup",0,name,description,serviceList)
}

/// CopyGroup creates a copy of an existing group, copying all Services and their data.
/// The new group must not exist.
Method CopyGroup(oldGroup As %String, newGroup As %String, newDescription As %String) [ WebMethod ]
{
	Do ..CallWebMethod("CopyGroup",0,oldGroup,newGroup,newDescription)
}

/// DeleteGroup deletes an existing group.
Method DeleteGroup(name As %String) [ WebMethod ]
{
	Do ..CallWebMethod("DeleteGroup",0,name)
}

/// GetGroup returns %EM.Group object which describes the named group.
Method GetGroup(name As %String) As %EM.Group [ WebMethod ]
{
	Quit ..CallWebMethod("GetGroup",1,name)
}

/// GetAllGroups returns a list of %EM.Group objects which describe all defined groups.
Method GetAllGroups() As %EM.GroupList [ WebMethod ]
{
	Quit ..CallWebMethod("GetAllGroups",1)
}

/// GetAllGroupsForService returns a list of %EM.Group objects which describe all groups
/// which manage the specified service.
Method GetAllGroupsForService(serviceName As %String) As %EM.GroupList [ WebMethod ]
{
	Quit ..CallWebMethod("GetAllGroupsForService",1,serviceName)
}

/// Subscribe the named group to the named master group.
Method SubscribeToMasterGroup(groupName As %String, masterGroupName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("SubscribeToMasterGroup",0,groupName,masterGroupName)
}

/// Unsubscribe the named group to the named master group.
Method UnsubscribeFromMasterGroup(groupName As %String, masterGroupName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("UnsubscribeFromMasterGroup",0,groupName,masterGroupName)
}

/// GetSubscribingGroupList returns a list of %EM.Group objects which describe
/// all subscribing groups for the specified master group.
Method GetSubscribingGroupList(masterGroupName As %String) As %EM.GroupList [ WebMethod ]
{
	Quit ..CallWebMethod("GetSubscribingGroupList",1,masterGroupName)
}

/// GetMasterGroupList returns a list of %EM.Group objects which describe
/// all master groups for the specified group.
Method GetMasterGroupList(groupName As %String) As %EM.GroupList [ WebMethod ]
{
	Quit ..CallWebMethod("GetMasterGroupList",1,groupName)
}

/// GetInstanceByGUID returns %EM.Instance object which describes the identified instance.
Method GetInstanceByGUID(guid As %String) As %EM.Instance [ WebMethod ]
{
	Quit ..CallWebMethod("GetInstanceByGUID",1,guid)
}

/// GetInstanceByName returns %EM.Instance object which describes the identified instance.
Method GetInstanceByName(instanceName As %String) As %EM.Instance [ WebMethod ]
{
	Quit ..CallWebMethod("GetInstanceByName",1,instanceName)
}

/// GetInstanceByLocation returns %EM.Instance object which describes the identified instance.
/// The host, port and prefix must exactly match those specified when registering the instance
/// (i.e. those that display in the on the EM server).
Method GetInstanceByLocation(host As %String, port As %String, prefix As %String) As %EM.Instance [ WebMethod ]
{
	Quit ..CallWebMethod("GetInstanceByLocation",1,host,port,prefix)
}

/// GetAllInstances returns a list of %EM.Instance objects which describe all instances managed by this EM server.
Method GetAllInstances() As %EM.InstanceList [ WebMethod ]
{
	Quit ..CallWebMethod("GetAllInstances",1)
}

/// No longer manage specified instance.
Method RemoveFromManagement(guid As %String) [ WebMethod ]
{
	Do ..CallWebMethod("RemoveFromManagement",0,guid)
}

/// Suspend management of the specified instance.
Method SuspendManagement(guid As %String) [ WebMethod ]
{
	Do ..CallWebMethod("SuspendManagement",0,guid)
}

/// Resume management of the specified instance.
/// The resume will be done without returning Diffs for approval.
Method ResumeManagement(guid As %String) [ WebMethod ]
{
	Do ..CallWebMethod("ResumeManagement",0,guid)
}

/// AssignToGroupChange returns the list of changes which will be applied to an Instance
/// when Assigned to a Group. This could be called prior to AssignToGroup().<br>
/// If override is true, add subgroup overrides for any diffs from the Master group.
Method AssignToGroupChanges(guid As %String, groupName As %String, override As %Boolean = 0) As %EM.ChangeList [ WebMethod ]
{
	Quit ..CallWebMethod("AssignToGroupChanges",1,guid,groupName,override)
}

/// Assign an instance to a group.  The assign will be done without returning Diffs for approval.<br>
/// If override is true, add subgroup overrides for any diffs from the Master group.
Method AssignToGroup(guid As %String, groupName As %String, override As %Boolean = 0) [ WebMethod ]
{
	Do ..CallWebMethod("AssignToGroup",0,guid,groupName,override)
}

/// Remove an instance from management by a group
Method RemoveFromGroup(guid As %String, groupName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("RemoveFromGroup",0,guid,groupName)
}

/// Return a list of all instances which are already assigned to the specified group.
Method ListGroupInstances(groupName As %String) As %EM.InstanceList [ WebMethod ]
{
	Quit ..CallWebMethod("ListGroupInstances",1,groupName)
}

/// Return a list of all groups to which the specified instance may be assigned.
/// This method filter groups to those which may be validly have this instance assigned.
/// For example, groups which have a service that is not already managed for one of this instance.
Method ListGroupsForAssign(guid As %String) As %EM.GroupList [ WebMethod ]
{
	Quit ..CallWebMethod("ListGroupsForAssign",1,guid)
}

/// GetServiceGroup takes an instance GUID and service name as input and returns the group
/// which manages this service for the specified instance or "" if service not managed for this instance. 
Method GetServiceGroup(guid As %String, serviceName As %String) As %EM.Group [ WebMethod ]
{
	Quit ..CallWebMethod("GetServiceGroup",1,guid,serviceName)
}

/// Assume management of an existing Mirror by Assigning all Instances to a new Mirror Group.
/// The mirror is found based on the specified GUID of one of the mirror memebers
Method CreateMirrorGroup(groupName As %String, guid As %String) [ WebMethod ]
{
	Do ..CallWebMethod("CreateMirrorGroup",0,groupName,guid)
}

/// UnmanageMirror removes all Instances from the Mirror Group, but does not change the Mirror
/// configuration on the Instances. It assumes the Group is already validated as a Mirror.
Method UnmanageMirror(groupName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("UnmanageMirror",0,groupName)
}

/// Start editing a service that is managed by a specified group.
/// If timeout argument is specified, then wait for this number of seconds for in process activation to finish.
/// This method checks that this service is editable now.
/// i.e. not in edit mode for a different user and not in update mode for approval or add instance. 
/// If editable, then puts the service into edit mode for this user.  
Method EditService(groupName As %String, serviceName As %String, timeout As %Integer = 0) [ WebMethod ]
{
	Do ..CallWebMethod("EditService",0,groupName,serviceName,timeout)
}

/// Return a comma-delimited string indicating if the service may be edited (i.e. IsEditable)
/// and if it is currently being edited, e.g. "1,1" if both true.
/// Note that 'IsEditable' includes services that are Submitted or Approved, as they may be returned to Edit.
Method IsEditable(groupName As %String, serviceName As %String) As %String [ WebMethod ]
{
	Quit ..CallWebMethod("IsEditable",1,groupName,serviceName)
}

/// Abort editing a service that is managed by a specified group.
/// This method checks that the current user has edit or awaiting approval state for this service.
Method EditAbort(groupName As %String, serviceName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("EditAbort",0,groupName,serviceName)
}

/// This method changes which user may edit a service.
/// This method checks that the current user either has edit mode for this service or
/// edit is completed and the current user has approval privilege.
/// It also checks that the new user has edit privilege for the service.
/// If OK, then edit user is changed and service is put/left in edit mode.  
Method EditChangeUser(groupName As %String, serviceName As %String, username As %String) [ WebMethod ]
{
	Do ..CallWebMethod("EditChangeUser",0,groupName,serviceName,username)
}

/// Complete editing a service that is managed by a specified group.
/// This method checks that the current user has edit mode for this service.
/// If OK, then the service is put in the edit state of AwaitingApproval.
/// No one else may edit, add or resume instances.
/// The service data is validity checked for each instance.
/// The error for each instance is returned as part of the overall error message.
Method EditComplete(groupName As %String, serviceName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("EditComplete",0,groupName,serviceName)
}

/// Return information about whether service may be approved for a group. Return is true if may be approved.
Method IsApprovable(groupName As %String, serviceName As %String) As %Boolean [ WebMethod ]
{
	Quit ..CallWebMethod("IsApprovable",1,groupName,serviceName)
}

/// Approve editing a service that is managed by a specified group.
/// This method checks that the service is awaiting approval for this service.
/// If OK, then the service is put in the edit state of Approved.
/// No one else may edit, add or resume instances.
/// The service data is validity checked for each instance.
/// The error for each instance is returned as part of the overall error message.
Method EditApprove(groupName As %String, serviceName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("EditApprove",0,groupName,serviceName)
}

/// Return the list of changes which will be applied to an Instance when the Service is Activated.
Method ApprovedChanges(groupName As %String, serviceName As %String) As %EM.ChangeList [ WebMethod ]
{
	Quit ..CallWebMethod("ApprovedChanges",1,groupName,serviceName)
}

/// Return information about whether service has already been approved for a group.
/// Return is true if it is in approved state.
Method IsApproved(groupName As %String, serviceName As %String) As %Boolean [ WebMethod ]
{
	Quit ..CallWebMethod("IsApproved",1,groupName,serviceName)
}

/// Return information about whether a Prepare step (e.g. DataMove) is required for an edit.
/// Return is true if it is necessary for this group and service.
Method IsPrepareRequired(groupName As %String, serviceName As %String) As %Boolean [ WebMethod ]
{
	Quit ..CallWebMethod("IsPrepareRequired",1,groupName,serviceName)
}

/// Start the Prepare step prior to update.
Method PrepareForUpdate(groupName As %String, serviceName As %String) [ WebMethod ]
{
	Quit ..CallWebMethod("PrepareForUpdate",0,groupName,serviceName)
}

/// Return is true if the Prepare step for the service is complete and it's ready for update.
Method IsPrepareComplete(groupName As %String, serviceName As %String) As %Boolean [ WebMethod ]
{
	Quit ..CallWebMethod("IsPrepareComplete",1,groupName,serviceName)
}

/// Activate changes and update instances with approved data for a service that is managed by a specified group.
/// This method checks that the service is in edit mode and approved.
/// First the versions are updated, then this method creates a message for each instance.
/// The message is sent to the instance and results in update of the instance.
/// Note that most services are Activated immediately and any errors are returned here.
/// But some services (primarily Namespace) may use background JOBs to update the instances,
/// and in that case you must check GetActivateStatus to determine the status of the Activation. 
Method EditActivate(groupName As %String, serviceName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("EditActivate",0,groupName,serviceName)
}

/// For a background Activation, return %EM.Update for the current status of the Activation.
Method GetActivateStatus(groupName As %String, serviceName As %String) As %EM.Update [ WebMethod ]
{
	Quit ..CallWebMethod("GetActivateStatus",1,groupName,serviceName)
}

/// The GetHighestVersion method will return the version object for the highest (i.e. most recent) previous version
/// for a service that is managed by a specified group.
Method GetHighestVersion(groupName As %String, serviceName As %String) As %EM.Version [ WebMethod ]
{
	Quit ..CallWebMethod("GetHighestVersion",1,groupName,serviceName)
}

/// The GetLowestVersion method will return the version object for the lowest (i.e. earliest) previous version
/// number that is still stored for a service that is managed by a specified group.
Method GetLowestVersion(groupName As %String, serviceName As %String) As %EM.Version [ WebMethod ]
{
	Quit ..CallWebMethod("GetLowestVersion",1,groupName,serviceName)
}

/// Set Description property of a service's version.
Method SetVersionDescription(version As %EM.Version) [ WebMethod ]
{
	Do ..CallWebMethod("SetVersionDescription",0,version)
}

/// PurgeVersions deletes all versions with specified version's versionNumber or lower.
Method PurgeVersions(version As %EM.Version) [ WebMethod ]
{
	Do ..CallWebMethod("PurgeVersions",0,version)
}

/// RevertVersion will revert the active version to the specified version.
/// The service must be put in edit mode using EditService before revert and
/// then must be finished by EditAborted or EditCompleted/UpdateInstances.
/// This version will become a new version. 
Method RevertVersion(version As %EM.Version) [ WebMethod ]
{
	Do ..CallWebMethod("RevertVersion",0,version)
}

/// ListVersions returns a list of all versions for the specified group and service.
Method ListVersions(groupName As %String, serviceName As %String) As %EM.VersionList [ WebMethod ]
{
	Quit ..CallWebMethod("ListVersions",1,groupName,serviceName)
}

/// Export the specified version of the service data as an XML file in the current format used by EM for exports.<br>
/// filename is the path of the file to create which contains the exported version
Method ExportVersion(version As %EM.Version, filename As %String) As %FileBinaryStream [ WebMethod ]
{
	#dim stream As %FileBinaryStream
	Set stream=..CallWebMethod("ExportVersion",1,version)
	If '##class(%File).CopyFile(stream.Filename,filename,1) {
		Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$FileCanNotCopy,stream.Filename,filename))
	}
	Quit stream
}

/// Export the differences between the specified target version and the specified base version
/// of the service data as an XML file in the current format used by EM for exports.
/// This export may be used by ImportToService to update a service with the changes
/// that were made to the base to become the target.<br>
/// version is the version object for the target version.<br>
/// versionNumber is the version number of the base version 
/// filename is the path of the file to create which contains the exported version
Method ExportVersionDifferences(version As %EM.Version, versionNumber As %String, filename As %String) As %FileBinaryStream [ WebMethod ]
{
	#dim stream As %FileBinaryStream
	Set stream=..CallWebMethod("ExportVersionDifferences",1,version,versionNumber)
	If '##class(%File).CopyFile(stream.Filename,filename,1) {
		Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$FileCanNotCopy,stream.Filename,filename))
	}
	Quit stream
}

/// Move the differences between the specified target version and the specified base version
/// of the service data to a new version in the group named by targetGroupName (which must be in Edit mode).  
/// This move updates the service in the target group with the changes that were made to the base to become the target.<br>
/// version is the version object for the target version.<br>
/// versionNumber is the version number of the base version 
/// targetGroupName is the name of the group to bemodified with the changes
Method MoveVersionDifferences(version As %EM.Version, versionNumber As %Integer, targetGroupName As %String) [ WebMethod ]
{
	Do ..CallWebMethod("MoveVersionDifferences",0,version,versionNumber,targetGroupName)
}

/// When a service is in edit mode, it may be modified before the service data
/// is approved and updated to the managed instances.
/// In the initial version of this API, the service data may be modified only by importing data
/// in XML format using the ImportToService or ImportToServiceFromStream method.
/// The XML is in the current format used by EM for exports including exports by this API.<br>
/// Import an XML export to the Workspace for a Group/Service.
/// The caller must make sure the Service is in "edit" mode.
/// We will check the serviceName argument against the root.ServiceName in the XML export.
/// Note that trying to 'Add' an object that already exists is an error,
/// as is 'Change' or 'Delete' for an object that doesn't exist.
/// For a full Version we can use 'copy'=1, which will remove all Service data
/// objects (except Overrides and Variables), and create an exact copy of the Import Service data.
Method ImportToService(groupName As %String, serviceName As %String, filename As %String, copy As %Boolean = 0) [ WebMethod ]
{
	Set stream=##class(%FileBinaryStream).%New()
	Set stream.Filename=filename
	Do ..ImportToServiceFromStream(groupName,serviceName,stream,copy)
}

/// When a service is in edit mode, it may be modified before the service data
/// is approved and updated to the managed instances.
/// In the initial version of this API, the service data may be modified only by importing data
/// in XML format using the ImportToService or ImportToServiceFromStream method.
/// The XML is in the current format used by EM for exports including exports by this API.<br>
/// Import an XML export to the Workspace for a Group/Service.
/// The caller must make sure the Service is in "edit" mode.
/// We will check the serviceName argument against the root.ServiceName in the XML export.
/// Note that trying to 'Add' an object that already exists is an error,
/// as is 'Change' or 'Delete' for an object that doesn't exist.
/// For a full Version we can use 'copy'=1, which will remove all Service data
/// objects (except Overrides and Variables), and create an exact copy of the Import Service data.
Method ImportToServiceFromStream(groupName As %String, serviceName As %String, stream As %FileBinaryStream, copy As %Boolean = 0) [ WebMethod ]
{
	Do ..CallWebMethod("ImportToServiceFromStream",0,groupName,serviceName,stream,copy)
}

/// Set the value of a variable
Method SetVariable(variable As %EM.Variable) [ WebMethod ]
{
	Do ..CallWebMethod("SetVariable",0,variable)
}

/// Delete the variable
Method DeleteVariable(variable As %EM.Variable) [ WebMethod ]
{
	Do ..CallWebMethod("DeleteVariable",0,variable)
}

/// Return the variable with the current value set.
/// All properties of the %EM.Variable object except Value must be set must be before calling GetVariable.
Method GetVariable(variable As %EM.Variable) As %EM.Variable [ WebMethod ]
{
	Quit ..CallWebMethod("GetVariable",1,variable)
}

/// List all variables which match the GroupName and ServiceName.
/// Also restrict the list by GUID, if GUID is specified '= "".
Method ListVariables(variable As %EM.Variable) As %EM.VariableList [ WebMethod ]
{
	Quit ..CallWebMethod("ListVariables",1,variable)
}

/// CreateUser will create a new EM user.
Method CreateUser(user As %EM.User) [ WebMethod ]
{
	Do ..CallWebMethod("CreateUser",0,user)
}

/// DeleteUser deletes the specified user.
Method DeleteUser(username As %String) [ WebMethod ]
{
	Do ..CallWebMethod("DeleteUser",0,username)
}

/// ModifyUser will modify an existing EM user.
/// Any properties which are not specified will remain unchanged.
Method ModifyUser(user As %EM.User) [ WebMethod ]
{
	Do ..CallWebMethod("ModifyUser",0,user)
}

/// GetUser will get the description of the specified user.
Method GetUser(username As %String) As %EM.User [ WebMethod ]
{
	Quit ..CallWebMethod("GetUser",1,username)
}

/// Get a list of all defined EM users.
Method ListUsers() As %EM.UserList [ WebMethod ]
{
	Quit ..CallWebMethod("ListUsers",1)
}

/// GetGroupPrivileges returns the user's privileges as a bit string for the specified group:
/// a combination of $$$EMSUserEdit, $$$EMSUserApprove and $$$EMSUserActivate, or $$$EMSUserNone.
Method GetGroupPrivileges(username As %String, groupName As %String) As %Integer [ WebMethod ]
{
	Quit ..CallWebMethod("GetGroupPrivileges",1,username,groupName)
}

/// GetInstancePrivileges returns the user's privileges as a bit string:
/// a combination of $$$EMSUserEdit, $$$EMSUserApprove and $$$EMSUserActivate, or $$$EMSUserNone.
/// The privilege is set if the user has this privilege for any group containing this instance.
Method GetInstancePrivileges(username As %String, guid As %String) As %Integer [ WebMethod ]
{
	Quit ..CallWebMethod("GetInstancePrivileges",1,username,guid)
}

}
