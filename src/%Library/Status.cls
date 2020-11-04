Include %occInclude

IncludeGenerator %occInclude

/// The <b>%Status</b> data type class is used to represent an error status code.
/// 
/// <p>Many of the methods provided by the <i>Cach&eacute; Class Library</i> return error status 
/// information using the <b>%Status</b> data type. The include file, <i>%occStatus.INC</i>, contains several 
/// macro definitions that are useful in testing the value of an error code in <b>%Status</b> format.
/// 
/// <p>These macros include:
/// 
/// <ul>
/// <li><code>$$$ISOK(status:%Status)</code> returns true (1) if the status code <var>status</var> 
/// does not represent an error condition.</li>
/// <li><code>$$$ISERR(status:%Status)</code> returns true (1) if the status code <var>status</var> 
/// represents an error condition.</li>
/// </ul>
/// 
/// <p>You can get a more detailed description of an error by using the system-provided 
/// DecomposeStatus^%apiOBJ(status:%Status,&amp;err,flag) routine. 
/// <p>This routine takes a status code and returns an array of error strings.
/// <p>For example:
/// <br>
/// <p>
/// Set status=obj.%Save()
/// If $$$ISERR(status) Do DecomposeStatus^%apiOBJ(status,.err,"-d")
/// For i=1:1:err Write err(i),!
/// <br>
/// 
/// <p>A method returning a <b>%Status</b> code representing an error will throw an exception in 
/// a client Visual Basic (ActiveX) or Java application.
Class %Library.Status [ ClassType = datatype, ClientDataType = STATUS, Not ProcedureBlock, System = 2 ]
{

/// Declares the XSD type used when projecting XML Schemas.
Parameter XSDTYPE = "base64Binary";

/// Converts the SOAP encoded base64 input value to a Cache value.
ClassMethod XSDToLogical(%val As %String) As %Binary [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$system.Encryption.Base64Decode($translate(%val,$char(9,10,13,32)))"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the Cache %Binary value to the SOAP base64 encoded value.
ClassMethod LogicalToXSD(%val As %Binary) As %String [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$system.Encryption.Base64Encode(%val)"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the value of this data type from <code>$List</code> format to a delimited string 
/// using the value of the <var>ODBCDELIMITER</var> parameter as a delimiter.
ClassMethod LogicalToOdbc(%val = "") As %String
{
 quit:%val=$$$OK $$$OK
 n text,i,one
 d $system.Status.DecomposeStatus(%val,.text,"-d")
 s one="" f i=1:1:$g(text) s:i>1 one=one_$c(13,10) s one=one_$g(text(i)) 
 q one
}

}
