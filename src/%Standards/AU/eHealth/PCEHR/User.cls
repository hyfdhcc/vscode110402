/// Created from: c:/ensembledata/ehealthv2/pcehrwsdls/schema/common/pcehr_commontypes.xsd
Class %Standards.AU.eHealth.PCEHR.User Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock, SqlTableName = _User, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "User";

Parameter XMLSEQUENCE = 1;

Property IDType As %String(MAXLEN = "", VALUELIST = ",HPII,PortalUserIdentifier,LocalSystemIdentifier", XMLNAME = "IDType") [ Required ];

Property ID As %String(MAXLEN = "", XMLNAME = "ID") [ Required ];

Property role As %String(MAXLEN = "", XMLNAME = "role");

Property userName As %String(MAXLEN = "", XMLNAME = "userName") [ Required ];

Property useRoleForAudit As %Boolean(XMLNAME = "useRoleForAudit") [ Required ];

}
