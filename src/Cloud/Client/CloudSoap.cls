Class Cloud.Client.CloudSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://store.intersystems.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "Cloud";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// The name of the activated TLS/SSL configuration to use for https requests.
Property SSLConfiguration As %String [ InitialExpression = "Cloud", Transient ];

Method RegisterCloudLicense(LicenseID As %String, IPAddress As %String, CloudID As %String, Platform As %String, LicenseType As %String, ZVERSION As %String, Sysinfo As %List) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

}
