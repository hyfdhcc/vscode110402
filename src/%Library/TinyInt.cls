/// The <b>%TinyInt</b> represents a tiny integer value.
/// <p>This is identical to the <CLASS>%Integer</CLASS> data type with the
/// exception that it has odbctype of TINYINT, a default MAXVAL parameter
/// value of 127, and a default MINVAL parameter value of -128.
Class %Library.TinyInt Extends %Integer [ OdbcType = TINYINT, System = 2 ]
{

/// Declares the XSD type used when projecting XML Schemas.
Parameter XSDTYPE = "byte";

/// Converts the SOAP encoded input decimal value into a Cache %TinyInt value.
/// Returns "" for error.
ClassMethod XSDToLogical(%val As %String) As %TinyInt [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$number(%val,""I"",-128,127)"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Tests if the logical value <var>%val</var>, which is an integer value, is valid.
/// The validation is based on the class parameter settings used
/// for the class attribute this data type is associated with.
/// In this case, <a href="#MAXVAL">MAXVAL</a> and <a href="#MINVAL">MINVAL</a>.
ClassMethod IsValid(%val As %CacheString) As %Status [ CodeMode = generator, ServerOnly = 0 ]
{
	#; If subclass has a IsValidDT then call this
	If %property'="",$$$comSubMemberDefined(%class,$$$cCLASSproperty,%property,$$$cPROPmethod,"IsValidDT") {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$select(##class("_%class_")."_$$$QN(%property_"IsValidDT")_"(%val):1,1:$$$ERROR($$$DTFailure,%val))"
		Quit $$$OK
	}
	s %code=0
	s %codemode=$$$cMETHCODEMODEEXPRESSION
	i %parameter("VALUELIST")'="" d   QUIT $$$OK
	. s sep=$e(%parameter("VALUELIST")) ;for now
	. s %code="$select(%val'["""_sep_"""&&("_$$$quote(%parameter("VALUELIST")_sep)_"[("""_sep_"""_%val_"""_sep_""")):$$$OK,1:$$$ERROR($$$DTValueList,%val,"_$$$quote(%parameter("VALUELIST"))_"))"
	s max=$s(%parameter("MAXVAL")="":127,%parameter("MAXVAL")>127:127,1:%parameter("MAXVAL"))
	s min=$s(%parameter("MINVAL")="":-128,%parameter("MINVAL")<-128:-128,1:%parameter("MINVAL"))
	s str="$isvalidnum(%val,0,"_min_","_max_")"
	s %code="$select("_str_":1,'$isvalidnum(%val):$$$ERROR($$$DTNotNum,%val),%val<"_min_":$$$ERROR($$$DTMinVal,%val,"_min_"),1:$$$ERROR($$$DTMaxVal,%val,"_max_"))"
	QUIT $$$OK
}

}
