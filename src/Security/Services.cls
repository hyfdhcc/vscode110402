Include (%sySecurity, %sySystem, %syAudit, %occSystemMessages, %syINET, %sySite, %occErrors, %LMF, %syEMS)

/// Services defined for the system.
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Services Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index NameIndex On NameLowerCase [ IdKey ];

Parameter EMSSERVICE [ Internal ] = "Security";

/// Authentication methods enabled for the service<br>
/// Bit 0 = AutheK5CCache<br>
/// Bit 1 = AutheK5Prompt<br>
/// Bit 2 = AutheK5API<br>
/// Bit 3 = AutheK5KeyTab<br>
/// Bit 4 = AutheOS<br>
/// Bit 5 - AutheCache<br>
/// Bit 6 = AutheUnauthenticated<br>
/// Bit 7 = AutheKB<br>
/// Bit 8 = AutheKBEncryption<br>
/// Bit 9 = AutheKBIntegrity<br>
/// Bit 10 = AutheSystem<br>
/// Bit 11 = AutheLDAP<br>
/// Bit 12 = AutheLDAPCache<br>
/// Bit 13 = AutheDelegated<br>
/// Bit 14 = AutheLoginToken<br>
/// Bits 15-19 reserved<br>
/// Bit 20 = TwoFactorSMS<br>
/// Bit 21 = TwoFactorPW<br>
Property AutheEnabled As Security.Datatype.Authentication [ InitialExpression = 0 ];

/// Authentication capabilities of the service.<br>
/// See the AutheEnabled property for legal bit values.
Property AutheEnabledCapabilities As Security.Datatype.Authentication [ InitialExpression = 0, Internal ];

/// Other Capabilities of the service.<br>
/// Bit 0 - Enable Enabled property to be modified<br>
/// Bit 1 - Enable USE check on resource<br>
/// Bit 2 - Enable Privilege based security<br>
/// Bit 3 - Enable Client System Security<br>
/// Bit 4 - Enable Client System Security with role restriction<br>
/// Bit 5 - Enable Client Application Security<br>
/// Bit 6 - Disable display and modification of properties<br>
/// Bit 7 - Enabled for Windows platforms<br>
/// Bit 8 - Enabled for Unix platforms<br>
/// Bit 9 - Enabled for VMS platforms<br>
Property Capabilities As Security.Datatype.ServiceCapabilities [ InitialExpression = 0, Internal ];

/// List of valid IP addresses allowed to connect for this service.
Property ClientSystems As list Of %String(MAXLEN = 32767);

/// Full name of the service
Property Description As %String(MAXLEN = 256, MINLEN = 1) [ Required ];

/// Service enabled
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

/// Indicates if the Session Cookie and the Login Cookie for the CSP system should use the HttpOnly property
Property HttpOnlyCookies As Security.Datatype.BooleanYN [ InitialExpression = 0, Internal ];

/// Name of the service
Property Name As %String(COLLATION = "Exact", MAXLEN = 64, MINLEN = 1) [ Required ];

/// Service Name in Lowercase<br>
/// Used for indexing, not to be displayed or modified
Property NameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// Enable two-factor authentication for this service
Property TwoFactorEnabled As Security.Datatype.BooleanYN [ InitialExpression = 0, Internal ];

ClassMethod CheckLicense(ServiceName As %String) As %Status [ Internal ]
{
}

/// Validate an IP address of an incoming connection against
/// the list of Valid IP Addresses of this Service. 
/// This is an internal method that is called as part of accepting
/// a connection for this service.
ClassMethod CheckOneIPAddress(Name As %String, IP As %String, ByRef Status As %Status) As %Boolean [ Internal ]
{
}

ClassMethod CheckValidIPAddress(Name As %String, IP As %String, ByRef Status As %Status) As %Boolean [ Internal ]
{
}

/// Compile the list of Valid IP addresses from the class into an active list that can be used
/// efficiently as new connections are received.
ClassMethod ComputeAccessControlList(Name As %String, ByRef ref As %String) As %Status [ Internal ]
{
}

/// Create a Service.<br>
/// Create a Service in the Security database. This is for internal use only
/// to initialize the services when the system is installed.<br>
/// Parameters:<br>
/// Name - Name of the Service to create<br>
/// AutheEnabled - Bit string of authentication options enabled<br>
/// AutheEnabledCapabilities - Bit string of authentication options allowed<br>
/// Description - Full name of the service<br>
/// Capabilities - Bit string of additional capabilities for the service<br>
ClassMethod Create(Name As %String, Description As %String, AutheEnabled As %Integer, AutheEnabledCapabilities As %Integer, Capabilities As %Integer, Enabled As %Boolean) As %Status [ Internal ]
{
}

/// Handle %OpenId for EMS update. Check for non-existant, OS-specific Services and ignore them.
/// This happens primarily if we have mixed OS Instances in a Group.
ClassMethod EMSOpen(id As %String, concurrency As %Integer = -1, ByRef sc As %Status) As %RegisteredObject [ Internal ]
{
}

/// Service exists.<br>
/// This method checks for the existence of a Service in the security database.<br>
/// Parameters:<br>
/// Name - Name of the Service to check existence of<br>
/// Return values:<br>
/// If Value of the method = 0 (Service does not exist, or some error occured)<br>
/// Service = Null<br>
/// Status = Service "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Service exists)<br>
/// Service = Object handle to Service<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String, ByRef Service As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports Service records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// Services - Comma separated list of Services to export, "*" = All<br>
ClassMethod Export(FileName As %String = "ServicesExport.xml", ByRef NumExported As %Integer, Services As %String = "*") As %Status
{
}

/// Get a service's properties.<br>
/// Gets a service's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the Service to get<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// Properties("AutheEnabled") - Enabled authentication options<br>
/// Properties("AutheEnabledCapabilities") - Allowed authentication options (Internal use only)<br>
/// Properties("Capabilities") - Additional capability options (Internal use only)<br>
/// Properties("Enabled") - Service is enabled<br>
/// Properties("Description") - Full name of the service<br>
/// Properties("ClientSystems") - Semicolon separated list of allowed IP connections, "ipsec1;ipspec2;ipspec3" (On some services, an ipspec can be ip|role1,role2,etc.)
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Returns 0/1 if any Services or CSP applications have Password authentication enabled 
ClassMethod GetPasswordAutheEnabled(ByRef Enabled As %Boolean) As %Status [ Internal ]
{
}

/// Get a services's properties.<br>
/// Gets a services's properties from the security database.<br>
/// Parameters:<br>
/// Service - Object handle to a Service record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(Service As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Import Service records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Service records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "ServicesExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Service is public.<br>
Method IsPublic() As %Boolean
{
}

/// Called at Startup time to activate the access control list from the ClientSystems field of this
/// Service.
ClassMethod InitAccessControlList(Name As %String) As %Status [ Internal ]
{
}

/// Initialize all the services for the first time.
ClassMethod Initialize(SecuritySetting As %String = "Normal", Flag As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod IsEnabled(ServiceName As %String) As %Boolean [ Internal ]
{
}

/// Modify a Service's properties.<br>
/// Modifies a Service's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the service to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified. Note that some system defined properties are not changeable.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// When a role is being deleted, remove it from the "list of allowed IP
/// addresses" of all services.
ClassMethod RemoveRoleFromAllServices(RoleName As %String) As %Status [ Internal, ProcedureBlock = 1 ]
{
}

/// Initialize the system services list of allowed IP addresses
ClassMethod Start() As %Status [ Internal ]
{
}

/// Initialize the in-system memory for unix and VMS terminals, and windows telnet and console
/// which determines what authentication methods are available.
ClassMethod StartTerminal() As %Status [ Internal ]
{
}

/// Initialize an EMS client when a service changes
ClassMethod StartEMS() [ Internal ]
{
}

/// Start or stop telnet daemon on windows.
/// 
Method StartStopTerminalDaemon() [ Internal, Private ]
{
}

ClassMethod JobTerminalDaemonStart(cmd As %String) As %Status [ Internal ]
{
}

/// Compute the new AccessControlList from the ClientSystems property of this
/// Service, and use "hot-patching" to update the active table of IP addresses
/// that we check for access.
ClassMethod UpdateAccessControlList(Name As %String) As %Status [ Internal ]
{
}

/// Validate the IP/Hostname for the ClientSystems access control list.
/// Return: 0 - valid. 1 - IP range is invalid. 2 - hostname is invalid.<br>
///  3 - error trapped. 4 - hostname can't be resolved to IP. <br>
/// Only error code 4 could be recovered, other errors is fatal and can't proceed.
ClassMethod ValidateClientSystemsIP(addr As %String) As %String [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
/// If the service name is %Service Terminal, reinitialize the memory which depends on it.
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

/// Detail list of services.<br>
/// Names - Comma separated list of Service names, "*" = All<br>
/// Note: This query may change in future versions<br>
Query Detail(Names As %String) As %Query(ROWSPEC = "Name:%String,Enabled:%String,Public:%String,Authentication Methods:%String,Allowed Connections:%String,Description:%String,EnabledBoolean:%Boolean,HttpOnlyCookies:%Boolean,TwoFactorEnabled:%Boolean") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

/// List of services.<br>
/// Names - Comma separated list of Service names, "*" = All<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String) As %Query(ROWSPEC = "Name:%String,Enabled:%String,Public:%String,Description:%String,EnabledBoolean:%Boolean") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<Data name="ServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AutheEnabled</Value>
</Value>
<Value name="3">
<Value>AutheEnabledCapabilities</Value>
</Value>
<Value name="4">
<Value>AuthenticationRequired</Value>
</Value>
<Value name="5">
<Value>Capabilities</Value>
</Value>
<Value name="6">
<Value>ClientSystems</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>Enabled</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>TwoFactorEnabled</Value>
</Value>
<Value name="11">
<Value>HttpOnlyCookies</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ServicesD")</DataLocation>
<DefaultData>ServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ServicesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ServicesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ServicesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
