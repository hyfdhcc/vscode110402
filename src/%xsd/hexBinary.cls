IncludeGenerator (%occInclude, %occUtility)

/// This data type is used to represent binary data
/// that will be encoded using the hex encoding for XML serialization.
/// Internally, this is stored as a string containing a binary value.
/// 
/// <p>When a <b>%Binary</b> data type value is projected to a client application,
/// such as when it is used in a Java, Visual Basic (ActiveX), ODBC, or JDBC application,
/// the Cach&eacute; Object Server performs no translations or conversions on it.
/// That is, the actual binary data is sent to and from the client without any Unicode (or other) translations.
Class %xsd.hexBinary Extends %Binary [ Not ProcedureBlock, System = 2 ]
{

/// Declares the XSD type used when projecting XML schemas.
Parameter XSDTYPE = "hexBinary";

/// There is no length restriction for %xsd binary types.
Parameter MAXLEN As INTEGER;

/// Converts the SOAP encoded base64 input value to a Cache value.
ClassMethod XSDToLogical(%val As %String) As %xsd.hexBinary [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		$$$GENERATE(" New bin,i,len set bin=""""")
		$$$GENERATE(" Set %val=$translate(%val,$char(9,10,13,32))")
		$$$GENERATE(" Set len=$length(%val) If len#2 Quit """"")
		$$$GENERATE(" For i=1:2:len {")
		$$$GENERATE("    Set bin=bin_$char($zhex($extract(%val,i,i+1)))")
		$$$GENERATE(" }")
		$$$GENERATE(" Quit bin")
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the Cache %Binary value to the SOAP base64 encoded value.
ClassMethod LogicalToXSD(%val As %xsd.hexBinary) As %String [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		$$$GENERATE(" New a,hex,i set hex=""""")
		$$$GENERATE(" For i=1:1:$length(%val) {")
		$$$GENERATE("    Set a=$ascii(%val,i)")
		$$$GENERATE("    Set hex=hex_$select(a<16:""0"",1:"""")_$zhex(a)")
		$$$GENERATE(" }")
		$$$GENERATE(" Quit hex")
	} Else {
	Set %code=0 
	}
	Quit $$$OK
}

}
