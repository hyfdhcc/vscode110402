/// 
Class %Standards.AU.eHealth.PCEHR.PCEHRHeaderType Extends %SOAP.Header [ ProcedureBlock, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLFORMAT = "literal";

Parameter XMLNAME = "PCEHRHeader";

Parameter XMLSEQUENCE = 1;

Property User As %Standards.AU.eHealth.PCEHR.User(XMLNAME = "User") [ Required, SqlFieldName = _User ];

Property ihiNumber As %Standards.AU.eHealth.PCEHR.ihiNumber(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0", XMLNAME = "ihiNumber", XMLREF = 1);

Property productType As %Standards.AU.eHealth.PCEHR.productType(XMLNAME = "productType") [ Required ];

Property clientSystemType As %String(MAXLEN = "", VALUELIST = ",CIS,CSP,CRP,HI,Medicare,CPP,CCP,Other", XMLNAME = "clientSystemType") [ Required ];

Property accessingOrganisation As %Standards.AU.eHealth.PCEHR.accessingOrganisation(XMLNAME = "accessingOrganisation");

}
