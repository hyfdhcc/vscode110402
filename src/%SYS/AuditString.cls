Class %SYS.AuditString Extends %Library.String [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC1353 04/04/08 Steve Clay, XML Escape audit data in audit log when exporting
STC1165 02/07/07 Steve Clay, Allow export of audit data with CTRL characters in it
-------------------End Documentation----------------------------------
*/
/// Converts the Cache %String value to valid XML, remove $c(1-31) except 
/// for 13,10,9 (CR,LF,TAB)
ClassMethod LogicalToXSD(%val As %String) As %String [ CodeMode = generator, Internal, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$zcvt($zstrip(%val,""*"",$c(1,2,3,4,5,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)),""O"",""XML"")"
	} Else {
		Set %code=0 
	}
	Quit $$$OK
}

}
