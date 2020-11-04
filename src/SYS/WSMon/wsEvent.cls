/// A general Event class used by Web Services Monitoring to describe alerts or events.
/// See the SYS.WSMon.EventSink service and the SYS.WSMon.Service.EventSubscribe() method
/// for more details about how to receive Events.
/// <br><br>
/// The "alerts" would be the same events as those sent via SNMP or WMI, including all relevant
/// alerts from cconsole.log (and the Cache System Monitor). These are documented in the chapters
/// on SNMP and WMI in the Cache Monitoring Guide.
Class SYS.WSMon.wsEvent Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// The network name of the system which signaled the Event
Property System As %String;

/// The name of the Cache instance which signaled the Event
Property Instance As %String;

/// A string which uniquely identifies the Event, for example 'cacheDBOutOfSpace'.
Property Name As %String;

/// The severity of the Event, where 0=info, 1=warning, 2=severe, 3=fatal
Property Severity As %Integer;

/// A numeric value identifying this Event type. This number matches the SNMP trap ID 
Property SnmpId As %Integer;

/// A text string containing any secondary information about the event. 
/// For example a database full event would indicate the name of the database here.
Property AdditionalInfo As %String(MAXLEN = 255);

}
