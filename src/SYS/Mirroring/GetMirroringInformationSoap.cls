Class SYS.Mirroring.GetMirroringInformationSoap Extends %SOAP.WebClient [ System = 4 ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.211.55.2:57773/csp/sys/SYS.Mirroring.MirroringWebServices.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/mirroring";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "GetMirroringInformation";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetDatabaseSizeProperties(MirrorDatabaseName As %String, Output Status As %Status) As %List [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method GetFailoverMemberInformation(MirrorSetName As %String, Output Status As %Status) As Config.MapMirrors [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

}
