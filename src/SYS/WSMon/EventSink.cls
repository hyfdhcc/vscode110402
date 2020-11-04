Include %sySite

/// This is an example of a CacheEventSink Web service which can recieve alerts from any
/// Cache instance. Users should follow the WSDL generated from this class to create their
/// own CacheEventSink Web method. Then register it using SYS.WSMon.Service.EventSubscribe()
/// to "subscribe" to all alerts from each Cache instance.
/// <br><br>
/// The "alerts" would be the same events as those sent via SNMP or WMI, including all relevant
/// alerts from cconsole.log (and the Cache System Monitor). See the SYS.WSMon.wsEvent class for
/// details on the properties included with each alert.
Class SYS.WSMon.EventSink Extends %SOAP.WebService
{

/// Name of the WebService.
Parameter SERVICENAME = "CacheEventSink";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.intersystems.com/cache/wsmon/1";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// Example service for a CacheEventSink
Method CacheEventSink(event As SYS.WSMon.wsEvent) As %Integer [ SoapAction = "http://www.intersystems.com/cache/wsmon/1/SYS.WSMon.CacheEventSink", WebMethod ]
{
}

}
