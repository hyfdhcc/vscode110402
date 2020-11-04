Include %sySecurity

Class Security.Datatype.Protocol Extends %Integer [ System = 2 ]
{

ClassMethod DisplayToLogical(%val As %String) As %Integer [ Internal ]
{
 try {
	 s Authe=0
	 f i=1:1 {
		s String=$zcvt($p(%val,",",i),"U") q:String=""
		i String=$zcvt("SSLv2","U") s Authe=$zb(Authe,$$$SSLv2,7) continue
		i String=$zcvt("SSLv3","U") s Authe=$zb(Authe,$$$SSLv3,7) continue
		i String=$zcvt("TLSv1.0","U") s Authe=$zb(Authe,$$$TLSv1,7) continue
		i String=$zcvt("TLSv1.1","U") s Authe=$zb(Authe,$$$TLSv11,7) continue
		i String=$zcvt("TLSv1.2","U") s Authe=$zb(Authe,$$$TLSv12,7) continue
	#;Invalid authentication
	 	s Authe=-1 q	
	 }
 } catch {
	 s Authe = -1
 }
 q Authe
}

ClassMethod LogicalToDisplay(%val As %Integer) As %String [ Internal ]
{
 try {
	 s AutheString=""
	 i $zb(+%val,$$$SSLv2,1) s AutheString=AutheString_"SSLv2"_","
	 i $zb(+%val,$$$SSLv3,1) s AutheString=AutheString_"SSLv3"_","
	 i $zb(+%val,$$$TLSv1,1) s AutheString=AutheString_"TLSv1.0"_","
	 i $zb(+%val,$$$TLSv11,1) s AutheString=AutheString_"TLSv1.1"_","
	 i $zb(+%val,$$$TLSv12,1) s AutheString=AutheString_"TLSv1.2"_","
	 s AutheString=$e(AutheString,1,$l(AutheString)-1)
 } catch {
	 s AutheString = ""
 }
 q AutheString
}

ClassMethod LogicalToOdbc(%val As %Integer) As %String [ Internal ]
{
 q ..LogicalToDisplay(%val)
}

}
