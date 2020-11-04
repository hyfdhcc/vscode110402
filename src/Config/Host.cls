Include %syINET

/// This datatype class validates IP addresses.
Class Config.Host Extends %Library.String [ System = 4 ]
{

ClassMethod IsValid(%Val As %CacheString) As %Status [ CodeMode = generator, Internal ]
{
	s %code=0
	s %codemode=$$$cMETHCODEMODEEXPRESSION
#;SML994
	s str="'((%Val="""")!$$$ISIP(%Val)!((%Val?1AN.(1AN,1""-"",1""_"").(1"".""1.(1AN,1""-"",1""_"")).AN)&($l(%Val)<256)&($tr(%Val,""."","""")'?.N)))"
	s %code="$case("_str_",0:1,1:$$$ERROR($$$DTFailure,%Val))"
	QUIT $$$OK
}

}
