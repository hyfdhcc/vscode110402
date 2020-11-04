Include (%callout, %syInfo)

/// This class provides facilities to enumerate cache instances and their services
Class SYS.Info.Accessor Extends %RegisteredObject
{

/// This Query enumerates 'InfoProviders'. An InfoProvider is an object (implemented in an external library) which 
/// knows how to find instances of Cache and determine information about the 'applications' those Cache instances 
/// support. An example of an application would be the system management portal.
/// 
/// Currently there are two InfoProviders available, the 'Bonjour' provider which uses Apples Bonjour
/// protocol to find instances of Cache on the local network and the 'Http' provider which uses Http to discover
/// the applications which individual Cache instances provide.
/// 
/// The result set contains two rows, Name and Description. Use this name with the 'EnumerateInstallations' or 'EnumerateApplications'
/// queries
Query EnumerateInfoProviders() As %Query(ROWSPEC = "Name:%Library.String,Description:%Library.String") [ SqlProc ]
{
}

ClassMethod EnumerateInfoProvidersClose(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod EnumerateInfoProvidersExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod EnumerateInfoProvidersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

/// Test enumeration of the installed 'Info Providers'
ClassMethod TestEnumerateInfoProviders()
{
}

/// This query enumerates 'Installations', that is, individual instances of Cache or Ensemble. Depending upon which InfoProvider
/// is selected, these installations may be local to this machine or remote. The 'HttpProvider' will enumerate local installations whilst
/// the 'BonjourProvider' will enumerate installations that have been advertised by the 'Bonjour' protocol. The query requires the name
/// of the InfoProvider to use such as 'HttpProvider' or 'BonjourProvider. The AppId parameter is reserved for future use.
/// 
/// The information regarding the installations is returned as a list of dictionary objects each which contains a set
/// of keys and values describing each installation. Each installation has these well known keys:-
/// 
/// host: 		The hostname of the computer where the installation is located
/// name: 		The name of the instance of Cache or Ensemble
/// serverPort: The superserver port
/// status:     The current status of the installatio, 'up', 'dn' etc
/// version:    The $ZV version string
Query EnumerateInstallations(pProviderName As %String) As %Query(ROWSPEC = "host:%Library.String,name:%Library.String,serverPort:%Library.Integer,status:%Library.String,version:%Library.String") [ SqlProc ]
{
}

ClassMethod EnumerateInstallationsClose(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod EnumerateInstallationsExecute(ByRef qHandle As %Binary, pProviderName As %String) As %Status
{
}

ClassMethod EnumerateInstallationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

/// Test enumeration of the installed 'Installations'
ClassMethod TestEnumerateInstallations()
{
}

/// This method enumerates 'Applications'. Individual instances of Cache or Ensemble may advertise 'Applications'
/// which typically represent a 'service' that is provided, for example, the System Management Portal.
/// The AppId parameter is reserved for future use.
/// 
/// The information regarding the Applications is returned as a list of dictionary objects each which contains a set
/// of keys and values describing each application. Each application has these well known keys:-
/// 
/// TBD:
Method EnumerateApplications(pProviderName As %String, Output pInstallations As %ListOfObjects, pAppId As %String = "SYS.Info.Accessor") As %Status
{
}

/// Test enumeration of applications
ClassMethod TestEnumerateApplications()
{
}

}
