Class PKI.CAServerSoap Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost:57772/isc/pki/PKI.CAServer.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://pki.intersystems.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "CAServer";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetCertificate(number As %String) As PKI.Certificate [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method ListCertificates(hostname As %String, instance As %String) As %XML.DataSet [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

Method SubmitCSR(csr As PKI.CSR) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

}
