IncludeGenerator %occInclude

/// The <b>%List</b> data type class is used to represent data that is in <code>$List</code> format. 
/// The logical value for <b>%List</b> is a list of elements in <code>$List</code> format.
/// 
/// <p>When a <b>%List</b> data type value is projected to a client application, it exposes it 
/// as a Cach&eacute; <b>syslist</b> object. This allows the client application to efficiently 
/// manipulate the contents of the list.
/// 
/// <p>Note that <code>$List</code> format is a compressed binary format; for this reason, 
/// a property of type of <b>%List</b> cannot be set through SQL nor can its value be queried 
/// through SQL (such as with a WHERE clause). 
/// 
/// <p>Refer to the documentation on <code>$List</code> in the <i>Cach&eacute; ObjectScript Reference Manual</i> 
/// for more information.
Class %Library.List [ ClassType = datatype, ClientDataType = LIST, System = 2 ]
{

/// A <b>%List</b> value is converted to a delimited string when 
/// it is projected via ODBC. <var>ODBCDELIMITER</var> is the delimiter character 
/// used to construct the delimited string.
Parameter ODBCDELIMITER = ",";

/// Declares the XSD type used when projecting XML Schemas.
Parameter XSDTYPE = "string";

/// Converts the SOAP encoded input list value into a Cache $list value.
ClassMethod XSDToLogical(val As %String) As %List [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set odbcdelim=%parameter("ODBCDELIMITER")
		If odbcdelim="," Set odbcdelim=""
		Set odbcdelim=$select(odbcdelim'="":","""_odbcdelim_"""",1:"")
		$$$GENERATE("	Quit $listfromstring(val"_odbcdelim_")")
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the Cache $list value to the canonical SOAP encoded value.
ClassMethod LogicalToXSD(val As %List) As %String [ CodeMode = generator ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set odbcdelim=%parameter("ODBCDELIMITER")
		If odbcdelim="," Set odbcdelim=""
		Set odbcdelim=$select(odbcdelim'="":","""_odbcdelim_"""",1:",")
		$$$GENERATE("	Quit $zcvt($listtostring(val"_odbcdelim_",1),""O"",""XML"")")
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

/// Converts the value of this data type from <code>$List</code> format to a delimited string 
/// using the value of the <var>ODBCDELIMITER</var> parameter as a delimiter.
ClassMethod LogicalToOdbc(val = "") As %String [ CodeMode = generator ]
{
	Set odbcdelim=%parameter("ODBCDELIMITER")
	#; Quote the delimiter. If odbcdelimiter was not specified, default to ","
	Set odbcdelim=""""_$select(odbcdelim'="":odbcdelim,1:",")_""""
	$$$GENERATE("	Quit ##class(%Collection.ListOfDT).LogicalToOdbc(val,"_odbcdelim_")")
	Quit $$$OK
}

/// Converts the value of an incoming delimited string to <code>$List</code> format 
/// using the value of the <var>ODBCDELIMITER</var> parameter as a delimiter.
ClassMethod OdbcToLogical(val = "") As %String [ CodeMode = generator ]
{
	Set odbcdelim=%parameter("ODBCDELIMITER")
	#; Quote the delimiter. If odbcdelimiter was not specified, default to ","
	Set odbcdelim=""""_$select(odbcdelim'="":odbcdelim,1:",")_""""
	$$$GENERATE("	Quit ##class(%Collection.ListOfDT).OdbcToLogical(val,"_odbcdelim_")")
	Quit $$$OK
}

}
