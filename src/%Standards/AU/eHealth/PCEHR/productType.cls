/// Created from: c:/ensembledata/ehealthv2/pcehrwsdls/schema/common/pcehr_commontypes.xsd
Class %Standards.AU.eHealth.PCEHR.productType Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "productType";

Parameter XMLSEQUENCE = 1;

Property vendor As %String(MAXLEN = "", XMLNAME = "vendor") [ Required ];

Property productName As %String(MAXLEN = "", XMLNAME = "productName") [ Required ];

Property productVersion As %String(MAXLEN = "", XMLNAME = "productVersion") [ Required ];

Property platform As %String(MAXLEN = "", XMLNAME = "platform") [ Required ];

}
