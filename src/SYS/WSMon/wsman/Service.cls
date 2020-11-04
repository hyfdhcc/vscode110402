Include (%soap, %sySystem)

/// Web Services and Methods to support Cache monitoring via the WS-Management specification
/// <br><br>
/// The services supported include wxf:Get, wsen:Enumerate, wsen:Pull, wsen:Release, 
/// wse:Subscribe, wse:Renew and wse:Unsubscribe. See the WS-Management specification for more
/// information, and the comments on the Methods below for details of the Cache implementation.
/// <br><br>
/// This is an example of the SOAP request and response message for a Transfer:Get from the WS-Management specification.
/// <br><br>
/// <example language=HTML>
/// <s:Envelope
///   xmlns:s="http://www.w3.org/2003/05/soap-envelope"
///   xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"
///   xmlns:wsman="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd">
///   <s:Header>
///     <wsa:To>http://1.2.3.4/wsman/</wsa:To>
///     <wsman:ResourceURI>http://example.org/2005/02/physicalDisk
///       </wsman:ResourceURI>
///     <wsa:ReplyTo>
///       <wsa:Address>
///         http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous
///       </wsa:Address>
///     </wsa:ReplyTo> 
///     <wsa:Action>
///       http://schemas.xmlsoap.org/ws/2004/09/transfer/Get
///     </wsa:Action>
///     <wsa:MessageID>
///       urn:uuid:d9726315-bc91-430b-9ed8-ce5ffb858a87
///     </wsa:MessageID>
///     <wsman:SelectorSet>
///       <wsman:Selector Name="LUN"> 2 </wsman:Selector>
///     </wsman:SelectorSet>
///     <wsman:OperationTimeout> PT30S </wsman:OperationTimeout>
///   </s:Header>
///   <s:Body/>
/// </s:Envelope>
/// </example>
/// <example language=HTML>
/// <s:Envelope
///   xmlns:s="http://www.w3.org/2003/05/soap-envelope"
///   xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"
///   xmlns:wsman="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd">
///   <s:Header>
///     <wsa:To>
///       http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous
///     </wsa:To>
///     <wsa:Action s:mustUnderstand="true">
///       http://schemas.xmlsoap.org/ws/2004/09/transfer/GetResponse
///     </wsa:Action>
///     <wsa:MessageID s:mustUnderstand="true">
///       urn:uuid:217a431c-b071-3301-9bb8-5f538bec89b8
///     </wsa:MessageID>
///     <wsa:RelatesTo>
///       urn:uuid:d9726315-bc91-430b-9ed8-ce5ffb858a87
///     </wsa:RelatesTo>
///   </s:Header>
///   <s:Body>
///     <PhysicalDisk 
///       xmlns="http://schemas.example.org/2005/02/samples/physDisk">
///       <Manufacturer> Acme, Inc. </Manufacturer>
///       <Model> 123-SCSI 42 GB Drive </Model>
///       <LUN> 2 </LUN>
///       <Cylinders> 16384 </Cylinders>
///       <Heads> 80 </Heads>
///       <Sectors> 63 </Sectors>
///       <OctetsPerSector> 512 </OctetsPerSector>
///       <BootPartition> 0 </BootPartition>
///     </PhysicalDisk>
///   </s:Body>
/// </s:Envelope>
/// </example>
Class SYS.WSMon.wsman.Service Extends %SOAP.WebService [ System = 4 ]
{

/// Name of the WebService.
Parameter SERVICENAME = "CacheWSManService";

/// Use unwrapped style messages
Parameter ARGUMENTSTYLE = "message";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.intersystems.com/cache/wsman/1/xsd";

/// WS-Management uses WS-Addressing and SOAP 1.2
Parameter WSADDRESSING = "AUTO";

Parameter SOAPVERSION = 1.2;

Parameter SOAPHEADERS = "ResourceURI:SYS.WSMon.wsman.ResourceURI,SelectorSet:SYS.WSMon.wsman.SelectorSet,OptimizeEnumeration:SYS.WSMon.wsman.OptimizeEnumeration,Identifier:SYS.WSMon.wse.Identifier,RequestTotalItemsCountEstimate:SYS.WSMon.wsman.RequestTotalItemsCountEstimate,MaxEnvelopeSize:SYS.WSMon.wsman.MaxEnvelopeSize,OperationTimeout:SYS.WSMon.wsman.OperationTimeout,Locale:SYS.WSMon.wsman.Locale";

/// This method implements the WS-Management WS-Transfer:Get action
/// <br><br> 
/// The resource is taken from the wsman:ResourceURI header, and each resource
/// requested returns a different class structure. The last piece of the resource
/// indicates the class name.
/// <br><br>
/// The selector is from wsman:SelectorSet and identifies the instance.
/// <br><br>
/// Supported resources for TransferGet are:
/// <br><br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.WSMon.wsSystem<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.WSMon.wsDatabase (Selector Name="ID")<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Global<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Buffer (Selector Name="Size")<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Disk<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.ECPAppSvr<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.ECPDataSvr<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Routine<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.WriteDaemon (Selector Name="ID")<br>
/// 	http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Resource (Selector Name="ID")<br>
Method TransferGet() As SYS.WSMon.wsResource(XMLTYPECONSTRAINT="choice") [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/09/transfer/Get", WebMethod ]
{
}

/// Support for a WS-Enumerate Enumerate request, as defined in the WS-Management specification.
/// <br><br> 
/// The resource is taken from the wsman:ResourceURI header, and each resource
/// requested returns a different class structure. The last piece of the resource
/// indicates the class name.
/// <br><br>
/// Only simple, non-filtered Enumeration is supported at this time. We do support (and recommend)
/// the OptimizeEnumeration header which allows enumerated class instances to be returned as part
/// of the response (rather than requiring a separate wse:Pull request). 
/// <br><br>
/// Resources which can be enumerated:
/// <br><br>
/// http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Buffer<br>
/// http://intersystems.com/cache/wsman/1/resource/SYS.Stats.WriteDaemon<br>
/// http://intersystems.com/cache/wsman/1/resource/SYS.Stats.Resource<br>
/// http://intersystems.com/cache/wsman/1/resource/SYS.WSMon.wsDatabase<br>
Method Enumerate(Enumerate As SYS.WSMon.wsen.Enumerate) As SYS.WSMon.wsen.EnumerateResponse [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/09/enumeration/Enumerate", WebMethod ]
{
}

/// Support for a WS-Enumerate Pull request, as defined in the WS-Management specification.
/// <br><br>
/// Returns enumerated class instances based on the EnumerationContext returned in the
/// wse:Enumerate response (or the reponse from a previous wse:Pull request).
Method Pull(Pull As SYS.WSMon.wsen.Pull) As SYS.WSMon.wsen.PullResponse [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/09/enumeration/Pull", WebMethod ]
{
}

/// Support for a WS-Enumerate Release request, as defined in the WS-Management specification.
/// <br><br>
/// This service is currently just a no-op, as Cache doesn't maintain any context beyond what's
/// returned in the EnumerationContext, but we accept the request without error (as recommended
/// in the WS-Management spec).
Method Release(Release As SYS.WSMon.wsen.Release) [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/09/enumeration/Release", WebMethod ]
{
}

/// Support for a WS-Eventing Subscribe request, as defined in the WS-Management specification.
/// <br><br>
/// No Filtering supported at this time. No EndTo message is currently sent, and the EndTo address
/// (if present) must be the same as the NotifyTo address. Only the default 'Push' delivery mode
/// is currently supported.
/// <br><br>
/// Notifications which get returned once a system has subscribed are the same 'events' as signaled
/// by SNMP or WMI. See the Cache Monitoring Guide for details. The Notifications sent to a subscriber's
/// EventSink will have a SOAP Action of "http://www.intersystems.com/cache/wsmon/1/SYS.WSMon.CacheEvent",
/// and will contain an instance of the SYS.WSMon.wsEvent class as the body.
/// <br><br>
/// A Notification message would look something like this:
/// <example language=HTML>
/// <?xml version="1.0" encoding="UTF-8" ?>
/// <SOAP-ENV:Envelope 
///   xmlns:SOAP-ENV='http://www.w3.org/2003/05/soap-envelope' 
///   xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' 
///   xmlns:s='http://www.w3.org/2001/XMLSchema' 
///   xmlns:wsa='http://www.w3.org/2005/08/addressing'>
///  <SOAP-ENV:Header>
///     <MaxEnvelopeSize xmlns="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd" xmlns:wsman="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd">32768</MaxEnvelopeSize>
///     <OperationTimeout xmlns="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd" xmlns:wsman="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd">PT30S</OperationTimeout>
///     <ResourceURI xmlns="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd" xmlns:wsman="http://schemas.dmtf.org/wbem/wsman/1/wsman.xsd">http://intersystems.com/cache/wsman/1/resource/SYS.WSMon.wsEvent</ResourceURI>
///     <wsa:Action>http://www.intersystems.com/cache/wsmon/1/SYS.WSMon.CacheEvent</wsa:Action>
///     <wsa:MessageID>urn:uuid:E4480818-98AC-4F8D-8FC3-2EF4A20055A9</wsa:MessageID>
///     <wsa:ReplyTo><wsa:Address>http://www.w3.org/2005/08/addressing/anonymous</wsa:Address></wsa:ReplyTo>
///     <wsa:To>http://rdavisE6500:8080/csp/sys/SYS.WSMon.wsman.Service.cls</wsa:To>
///  </SOAP-ENV:Header>
///  <SOAP-ENV:Body><Event xmlns="http://www.intersystems.com/cache/wsman/1/xsd">
///     <System>rdavisE6500</System>
///     <Instance>C092</Instance>
///     <Name>cacheTest</Name>
///     <Severity>3</Severity>
///     <SnmpId>1</SnmpId>
///     <AdditionalInfo>This is a test</AdditionalInfo>
///  </Event></SOAP-ENV:Body>
/// </SOAP-ENV:Envelope>
/// </example>
Method Subscribe(Subscribe As SYS.WSMon.wse.Subscribe) As SYS.WSMon.wse.SubscribeResponse [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/08/eventing/Subscribe", WebMethod ]
{
}

/// Support for a WS-Eventing Unsubscribe request, as defined in the WS-Management specification.
/// <br><br>
/// This deletes the current subscription based on the wse:Identifier.
Method Unsubscribe(Unsubscribe As SYS.WSMon.wse.Unsubscribe) As SYS.WSMon.wse.UnsubscribeResponse [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/08/eventing/Unsubscribe", WebMethod ]
{
}

/// Support for a WS-Eventing Renew request, as defined in the WS-Management specification.
/// <br><br>
/// This renews and extends the Expires time on the current subscription based on the wse:Identifier.
Method Renew(Renew As SYS.WSMon.wse.Renew) As SYS.WSMon.wse.RenewResponse [ SoapAction = "http://schemas.xmlsoap.org/ws/2004/08/eventing/Renew", WebMethod ]
{
}

/// Support for testing a WS-Eventing Notification
/// 
Method Notify(Event As SYS.WSMon.wsEvent) As %SOAP.OneWay [ Internal, SoapAction = "http://www.intersystems.com/cache/wsmon/1/SYS.WSMon.CacheEvent", WebMethod ]
{
}

/// Send a Fault response in WS-Management format. 
/// The Fault 'code', 'subcode', 'detail', and 'action' should come from
/// the Master Faults tables in the WS-Management spec.
Method wsmanFault(code As %String, subcode As %String, detail As %String, action As %String) [ Internal ]
{
}

/// Enumerate items in a class for optimized Enumerate or Pull
/// 'next' is the EnumerationContext, indicating the first instance to return
/// 		Passed byref so we can return the "next" instance index
/// 			Returns 0 to signal end of enumeration
/// 'max' is MaxElements, indicating how many to return (default is 1)
///         Passing a 'max' of 0 create a count of instances (in 'next'), with no 'items' returned
Method enum(class As %String, ByRef next As %Integer, max As %Integer) As SYS.WSMon.wsen.Items [ Internal ]
{
}

/// The OnPreWebMethod method will be called before any web method in a web service.
/// 
/// WS-Management uses this to process a couple of Control Headers. We accept MaxEnvelopeSize
/// with a minimum value of 8192 ... none of our responses should exceed this. OperationTimeout
/// and Locale are faulted right now if mustUnderstand is 'true'.
Method OnPreWebMethod() [ Internal, ServerOnly = 1 ]
{
}

}
