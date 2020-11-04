Include %soap

/// Implementation of Australian E-health XML secured payload profiles.
/// Document ATS 5821-2010
Class %Standards.AU.eHealth.SMD.SignedPayloadDataType Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/SignedPayload/2010";

Parameter XMLPREFIX = "sp";

Property content As %Standards.AU.eHealth.SMD.BaseDataType(XMLREF = 1, XMLTYPECONSTRAINT = "choice") [ Required ];

Property id As %String(MAXLEN = "", XMLPROJECTION = "attribute") [ Required ];

/// Create a new signedPayloadData with id set.
ClassMethod Create() As %Standards.AU.eHealth.SMD.EncryptedPayloadDataType
{
	Set signedPayloadData=..%New()
	If signedPayloadData.id="" {
		If $$$CheckSOAPTestMode {
			Set signedPayloadData.id="id-payload"
		} Else {
			Set signedPayloadData.id="Id-"_$system.Util.CreateGUID()
		}
	}
	Quit signedPayloadData
}

}
