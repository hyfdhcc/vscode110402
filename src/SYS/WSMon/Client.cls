/// Web Client class to call the SYS.WSMon.Service Web Services.
Class SYS.WSMon.Client Extends %SOAP.WebClient [ System = 4 ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost:57772/csp/sys/SYS.WSMon.Service.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/cache/wsmon/1";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "CacheMonitorService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetSystem() As SYS.WSMon.wsSystem [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetDashboard() As SYS.Stats.Dashboard [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetGlobal() As SYS.Stats.Global [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetRoutine() As SYS.Stats.Routine [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetDisk() As SYS.Stats.Disk [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetECPAppSvr() As SYS.Stats.ECPAppSvr [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetECPDataSvr() As SYS.Stats.ECPDataSvr [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EnumDatabase() As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EnumProcess(sort As %String, number As %Integer) As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EnumBuffer() As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EnumWriteDaemon() As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EnumResource() As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EventSubscribe(location) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method EventCancel(id) As %Integer [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method CacheEventSink(event As SYS.WSMon.wsEvent) As %Integer [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

}
