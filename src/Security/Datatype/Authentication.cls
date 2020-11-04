Include %sySecurity

IncludeGenerator %sySecurity

Class Security.Datatype.Authentication Extends %Integer [ System = 2 ]
{

/*
---------------------Documentation------------------------------------
STC1076 09/25/06 Steve Clay, Allow SQL update to Authentication options 
STC666 10/24/04 Steve Clay, Changes for CACHELIB/CACHESYS split
STC579 05/20/04 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
/// Convert external Authentication names to internal bit string.
/// <br>
ClassMethod DisplayToLogical(AutheString As %String) As %Integer [ Internal ]
{
 s $zt="Error"
 s Authe=0
 f i=1:1 {
	s String=$zcvt($p(AutheString,",",i),"U") q:String=""
	i String=$zcvt($$$AutheK5CCacheStr,"U") s Authe=$zb(Authe,$$$AutheK5CCache,7) continue
	i String=$zcvt($$$AutheK5PromptStr,"U") s Authe=$zb(Authe,$$$AutheK5Prompt,7) continue
	i String=$zcvt($$$AutheK5APIStr,"U") s Authe=$zb(Authe,$$$AutheK5API,7) continue
	i String=$zcvt($$$AutheK5KeyTabStr,"U") s Authe=$zb(Authe,$$$AutheK5KeyTab,7) continue
	i String=$zcvt($$$AutheOSStr,"U") s Authe=$zb(Authe,$$$AutheOS,7) continue
	i String=$zcvt($$$AutheLDAPStr,"U") s Authe=$zb(Authe,$$$AutheLDAP,7) continue
	i String=$zcvt($$$AutheLDAPCacheStr,"U") s Authe=$zb(Authe,$$$AutheLDAPCache,7) continue
	i String=$zcvt($$$AutheCacheStr,"U") s Authe=$zb(Authe,$$$AutheCache,7) continue
	i String=$zcvt($$$AutheUnauthenticatedStr,"U") s Authe=$zb(Authe,$$$AutheUnauthenticated,7) continue
	i String=$zcvt($$$AutheKBStr,"U") s Authe=$zb(Authe,$$$AutheKB,7) continue
	i String=$zcvt($$$AutheKBEncryptionStr,"U") s Authe=$zb(Authe,$$$AutheKBEncryption,7) continue
	i String=$zcvt($$$AutheKBIntegrityStr,"U") s Authe=$zb(Authe,$$$AutheKBIntegrity,7) continue
	i String=$zcvt($$$AutheDelegatedStr,"U") s Authe=$zb(Authe,$$$AutheDelegated,7) continue
	i String=$zcvt($$$AutheLoginTokenStr,"U") s Authe=$zb(Authe,$$$AutheLoginToken,7) continue
	i String=$zcvt($$$AutheKerberosDelegatedStr,"U") s Authe=$zb(Authe,$$$AutheKerberosDelegated,7) continue
	i String=$zcvt($$$AutheOSDelegatedStr,"U") s Authe=$zb(Authe,$$$AutheOSDelegated,7) continue
	i String=$zcvt($$$AutheTwoFactorSMSStr,"U") s Authe=$zb(Authe,$$$AutheTwoFactorSMS,7) continue
	i String=$zcvt($$$AutheTwoFactorPWStr,"U") s Authe=$zb(Authe,$$$AutheTwoFactorPW,7) continue
#;Invalid authentication
 	s Authe=-1 q	
 }
 q Authe
Error s $zt=""
 q -1
}

/// Convert internal authentication bit string to external name.
/// <br>
ClassMethod LogicalToDisplay(Authe As %Integer) As %String [ Internal ]
{
 s $zt="Error"
 s AutheString=""
 i $zb(+Authe,$$$AutheK5CCache,1) s AutheString=AutheString_$$$AutheK5CCacheStr_","
 i $zb(+Authe,$$$AutheK5Prompt,1) s AutheString=AutheString_$$$AutheK5PromptStr_","
 i $zb(+Authe,$$$AutheK5API,1) s AutheString=AutheString_$$$AutheK5APIStr_","
 i $zb(+Authe,$$$AutheK5KeyTab,1) s AutheString=AutheString_$$$AutheK5KeyTabStr_","
 i $zb(+Authe,$$$AutheOS,1) s AutheString=AutheString_$$$AutheOSStr_","
 i $zb(+Authe,$$$AutheLDAP,1) s AutheString=AutheString_$$$AutheLDAPStr_","
 i $zb(+Authe,$$$AutheLDAPCache,1) s AutheString=AutheString_$$$AutheLDAPCacheStr_","
 i $zb(+Authe,$$$AutheCache,1) s AutheString=AutheString_$$$AutheCacheStr_","
 i $zb(+Authe,$$$AutheUnauthenticated,1) s AutheString=AutheString_$$$AutheUnauthenticatedStr_","
 i $zb(+Authe,$$$AutheKB,1) s AutheString=AutheString_$$$AutheKBStr_","
 i $zb(+Authe,$$$AutheKBEncryption,1) s AutheString=AutheString_$$$AutheKBEncryptionStr_","
 i $zb(+Authe,$$$AutheKBIntegrity,1) s AutheString=AutheString_$$$AutheKBIntegrityStr_","
 i $zb(+Authe,$$$AutheDelegated,1) s AutheString=AutheString_$$$AutheDelegatedStr_","
 i $zb(+Authe,$$$AutheLoginToken,1) s AutheString=AutheString_$$$AutheLoginTokenStr_","
 i $zb(+Authe,$$$AutheKerberosDelegated,1) s AutheString=AutheString_$$$AutheKerberosDelegatedStr_","
 i $zb(+Authe,$$$AutheOSDelegated,1) s AutheString=AutheString_$$$AutheOSDelegatedStr_","
 i $zb(+Authe,$$$AutheTwoFactorSMS,1) s AutheString=AutheString_$$$AutheTwoFactorSMSStr_","
 i $zb(+Authe,$$$AutheTwoFactorPW,1) s AutheString=AutheString_$$$AutheTwoFactorPWStr_","
 i $zb(+Authe,$$$AutheMax,2) s AutheString=AutheString_$$$AutheUnknown_","
 s AutheString=$e(AutheString,1,$l(AutheString)-1)
 q AutheString
Error s $zt=""
 q ""
}

ClassMethod IsValid(%val As %CacheString) As %Status [ CodeMode = generator, Internal ]
{
	s %code=0
	s %codemode=$$$cMETHCODEMODEEXPRESSION
	s str="'$isvalidnum(%val,0,0,"_$$$AutheMax_")"
	s %code="$case("_str_",0:1,1:$$$ERROR($$$DatatypeValidationFailed,"""_%class_":"_%property_""",%val))"
	QUIT $$$OK
}

}
