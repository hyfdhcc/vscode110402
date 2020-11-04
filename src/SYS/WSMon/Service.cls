Include %sySystem

/// A Web Service class to support remote monitoring of a Cache instance.
/// <br><br>
/// Each of the following Web Methods may be called to gather information about a Cache instance.
/// See the SYS.WSMon.ws* or the SYS.Stats.* classes for details about the classes and properties
/// which can be accessed.
/// <br><br>
/// The services are generally in 3 categories. There are "Get" services which return single instances
/// of classes and their propeties, e.g. GetSystem(). There are "Enum" services which enumerate multiple
/// instances and return %XML.DataSet collections, e.g. EnumDatabase(). And there are EventSubscribe() 
/// and EventCancel() methods, which let you register your own version of a CacheEventSink() Web method 
/// to receive and process alerts. See the SYS.WSMon.EventSink class for an example and more details on 
/// Events.
/// <br><br>
/// The class SYS.WSMon.Client provides client methods to call these services from Cache. For example:
/// <example>
/// s server="myserver:57772" s client=##class(SYS.WSMon.Client).%New()
/// s client.Location="http://"_server_"/csp/sys/SYS.WSMon.Service.cls"
/// s client.Timeout=10 s sysref=client.GetSystem()
/// w !,"Cache instance ",sysref.Name," has ",sysref.CurrentUsers," current users."
/// </example><br>
/// NOTE: Executing the Web Services requires READ access to the %DB_CACHESYS resource. If the Cache
/// instance which provides the Web Services has security enabled, then you need to grant this access
/// for the CSP processes which execute the Web Services. This can be done in the configuration in
/// a few different ways, e.g. modifying the CSP application. Or, you can add a username/password token
/// (for a Cache user with the appropriate role) to the client request:
/// <example>
/// s usertoken=##class(%SOAP.Security.UsernameToken).Create("wsmon","wsmon")
/// d client.SecurityOut.AddToken(usertoken)
/// </example>
Class SYS.WSMon.Service Extends %SOAP.WebService [ System = 4 ]
{

/// Name of the WebService.
Parameter SERVICENAME = "CacheMonitorService";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.intersystems.com/cache/wsmon/1";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// Fetch System (Cache instance) information
Method GetSystem() As SYS.WSMon.wsSystem [ WebMethod ]
{
}

/// Fetch general system metrics and status
Method GetDashboard() As SYS.Stats.Dashboard [ WebMethod ]
{
}

/// Fetch Global metrics for this instance
Method GetGlobal() As SYS.Stats.Global [ WebMethod ]
{
}

/// Fetch metrics of Disk usage for globals for this instance
Method GetDisk() As SYS.Stats.Disk [ WebMethod ]
{
}

/// Fetch Routine metrics for this instance
Method GetRoutine() As SYS.Stats.Routine [ WebMethod ]
{
}

/// Fetch ECP Application Server metrics for this instance
Method GetECPAppSvr() As SYS.Stats.ECPAppSvr [ WebMethod ]
{
}

/// Fetch ECP Database Server metrics for this instance
Method GetECPDataSvr() As SYS.Stats.ECPDataSvr [ WebMethod ]
{
}

/// Enumerate all databases for this instance
/// Returned as a Data Set of SYS.WSMon.wsDatabase.List() query
Method EnumDatabase() As %XML.DataSet [ WebMethod ]
{
}

/// Enumerate the 'top' processes for this instance.
/// Returned as a Data Set of SYS.WSMon.wsProcess.List() query.
/// <br><br>
/// 'sort' may be either "COMMANDS" (default) or "GLOREFS"<br>
/// 'number' specifies the count of processes to return (default is 10)<br><br>
///  See the List() query documentation for details about the 'top' process list.
Method EnumProcess(sort As %String, number As %Integer) As %XML.DataSet [ WebMethod ]
{
}

/// Enumerate stats for all Write Daemons
/// Returned as a Data Set of SYS.Stats.WriteDaemon.Sample() query
Method EnumWriteDaemon() As %XML.DataSet [ WebMethod ]
{
}

/// Enumerate stats for all buffer sizes
/// Returned as a Data Set of SYS.Stats.Buffer.Sample() query
Method EnumBuffer() As %XML.DataSet [ WebMethod ]
{
}

/// Enumerate stats for all system resource "seizes"
/// Returned as a Data Set of SYS.Stats.Resource.Sample() query
Method EnumResource() As %XML.DataSet [ WebMethod ]
{
}

/// Subscribe to Events from this Cache instance
/// Register a CacheEventSink Web service to receive Events. The Web Service must follow the
/// example and WSDL of the SYS.WSMon.EventSink.CacheEventSink() Web method.
/// <br><br>
/// 'location' is the Cache Web service URL for invoking the EventSink method
/// including the system, port, CSP application, and Web service name: 
///  e.g. "http://localhost:57773/csp/sys/SYS.WSMon.EventSink.cls"
/// <br><br>
/// Cache will attempt to call this Web Service for each "event" with a wsEvent instance.
/// The return value is an ID string that can be used to cancel the subscription.
Method EventSubscribe(location) As %String [ WebMethod ]
{
}

/// Cancel an Event subscription
/// Return the ID string from the Event Subscription to cancel the subscription
Method EventCancel(id) As %Integer [ WebMethod ]
{
}

}
