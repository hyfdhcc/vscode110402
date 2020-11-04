/// This data data type represents an XML format duration.
/// Internally, this is stored as a string.
Class %xsd.duration Extends %String [ Not ProcedureBlock, System = 2 ]
{

/// Declares the XSD type used when projecting XML schemas.
Parameter XSDTYPE = "duration";

/// Converts the SOAP encoded input dateTime value into a Cache %TimeStamp value.
ClassMethod XSDToLogical(%val As %String) As %xsd.duration [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="%val"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the Cache %TimeStamp value to the canonical SOAP encoded value.
ClassMethod LogicalToXSD(%val As %xsd.duration) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="%val"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Tests if the logical value <var>%val</var>, which represents a duration
/// value in <code>PnYnMnDTnHnMn[.nnnnnnnn]S</code> format, is valid.
ClassMethod IsValid(%val As %CacheString) As %Status [ CodeMode = generator, ServerOnly = 0 ]
{
	#; If subclass has a IsValidDT then call this
	Set %codemode=$$$cMETHCODEMODEEXPRESSION
	If %property'="",$$$comSubMemberDefined(%class,$$$cCLASSproperty,%property,$$$cPROPmethod,"IsValidDT") {
		Set %code="$select(##class("_%class_")."_$$$QN(%property_"IsValidDT")_"(%val):1,1:$$$ERROR($$$DTFailure,%val))"
		Quit $$$OK
	}
	Set %code="$select(##class(%XML.Implementation).IsDuration(%val):$$$OK,1:$$$ERROR($$$DTNotDuration,%val))"
	QUIT $$$OK
}

}
