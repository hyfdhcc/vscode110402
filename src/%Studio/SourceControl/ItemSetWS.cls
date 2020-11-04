Class %Studio.SourceControl.ItemSetWS Extends %SOAP.WebClient [ System = 4 ]
{

/// This Parameter should be updated when synced from Perforce
Parameter SrcVer = "$Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/cls/Studio/SourceControl/ItemSetWS.xml#1 $";

/// Revision number of this class when compiled as part of the //custom_ccrs/_common/config/... branch.  
/// This version will not be updated (by design) when the class is integrated to other branches.
/// This allows the user to tell what version of the Studio client tools are in use.
Parameter Version = 11;

/// This is the URL used to access the web service.
Parameter LOCATION = "https://ccr.intersystems.com/ccr/CCR.ItemSet.WebService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/ccr/v1";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "CCRItemSetWS";

Method InvokeWebMethod(pAction As %String = "", pJob As %String = "", pEnv As %String = "", pToken As %String = "", ByRef pStr1 As %String = "", ByRef pStr2 As %String = "", ByRef pFile As %FileCharacterStream = "", ByRef pDataSet As %XML.DataSet = "") As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
}

/// Handles all compile-time logic for this class
/// [Previously private]
ClassMethod OnToolsCompile() [ CodeMode = objectgenerator, Internal ]
{
}

}
