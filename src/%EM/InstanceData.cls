/// The %EM.InstanceData class represents the descriptive instance data for an
/// Enterprise Manager instance for the remote API
Class %EM.InstanceData Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Node name of the client.
Property NodeName As %String(MAXLEN = 64);

/// Instance name of the Client.
Property InstanceName As %String(MAXLEN = 64);

/// EMS Software version of client.
/// XMLNAME is version for compatibility with older InstannceData
Property EMSVersionNumber As %Float(XMLNAME = "Version");

/// Description of the Client.
Property Description As %String(MAXLEN = 128);

/// Network address (Address|Port) used to communicate to the client's SuperServer.
Property SuperServer As %NetworkAddress;

/// Internal web server name.  If localhost, then value is ""
Property WebServerName As %String;

/// Internal web server port
Property WebServerPort As %Integer;

/// Product name (Cache, Ensemble, HealthShare)<br>
Property Product As %String;

/// Build number of the system.<br>
Property SystemBuildNumber As %String;

/// O/S for which the system was built for.<br>
Property SystemOS As %String;

/// Platform for which the system was built for.<br>
Property SystemPlatform As %String;

/// Version of the system.<br>
Property SystemVersion As %String;

/// Whether system is Unicode
Property IsUnicode As %Boolean;

/// $zv of the instance.
Property ZVersion As %String(MAXLEN = 256);

/// $zversion(0) of the instance.
Property ZVersion0 As %Binary;

/// Base installation directory of the Instance. Primarily used for remote start/stop.
/// The call to ISCAgent can get this if we don't have it and stores it here.
Property InstallDir As %SysPath(MAXLEN = 256);

/// default charset for this instance
Property Charset As %String;

/// Create from EMS.InstanceData
ClassMethod CreateFromInstanceData(data As EMS.InstanceData) [ Internal ]
{
	Set new=..%New()
	Set new.NodeName=data.NodeName
	Set new.InstanceName=data.InstanceName
	Set new.EMSVersionNumber=data.EMSVersionNumber
	Set new.Description=data.Description
	Set new.SuperServer=data.SuperServer
	Set new.WebServerName=data.WebServerName
	Set new.WebServerPort=data.WebServerPort
	Set new.Product=data.Product
	Set new.SystemBuildNumber=data.SystemBuildNumber
	Set new.SystemOS=data.SystemOS
	Set new.SystemPlatform=data.SystemPlatform
	Set new.SystemVersion=data.SystemVersion
	Set new.IsUnicode=data.IsUnicode
	Set new.ZVersion=data.ZVersion
	Set new.ZVersion0=data.ZVersion0
	Set new.InstallDir=data.InstallDir
	Set new.Charset=data.Charset
	Quit new
}

}
