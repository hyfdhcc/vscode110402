Include (%sySystem, %syMirror, %syINET)

/// SYS.Mirroring.MirroringWebServices
Class SYS.Mirroring.MirroringWebServices Extends %SOAP.WebService [ System = 4 ]
{

/// Name of the WebService.
Parameter SERVICENAME = "GetMirroringInformation";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.intersystems.com/mirroring";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
Method GetDatabaseSizeProperties(MirrorDatabaseName As %String, Output Status As %Status = "") As %List [ WebMethod ]
{
}

ClassMethod GetDbDirFromMirrorName(MirrorDatabaseName As %String, SFN As %String = "") As %String [ Internal ]
{
}

/// TODO: add arguments and implementation.
Method GetFailoverMemberInformation(MirrorSetName As %String, Output Status As %Status = "") As Config.MapMirrors [ WebMethod ]
{
}

}
