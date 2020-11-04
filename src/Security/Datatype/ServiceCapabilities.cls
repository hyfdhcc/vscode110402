Include %sySecurity

Class Security.Datatype.ServiceCapabilities Extends %Integer [ System = 2 ]
{

Parameter DOMAIN = "%Utility";

ClassMethod DisplayToLogical(%val As %String) As %Integer [ Internal ]
{
 try {
	 s Authe=0
	 f i=1:1 {
		s String=$zcvt($p(%val,",",i),"U") q:String=""
		i String=$zcvt($$$Text("Enabled property can be modified","%Utility"),"U") s Authe=$zb(Authe,$$$EnableEnabled,7) continue
		i String=$zcvt($$$Text("USE check on resource","%Utility"),"U") s Authe=$zb(Authe,$$$EnableUsePrivilege,7) continue
		i String=$zcvt($$$Text("Privilege-based security","%Utility"),"U") s Authe=$zb(Authe,$$$EnablePrivilegeBasedSecurity,7) continue
		i String=$zcvt($$$Text("Client system security","%Utility"),"U") s Authe=$zb(Authe,$$$EnableClientSystemSecurity,7) continue
		i String=$zcvt($$$Text("Client system security with role restriction","%Utility"),"U") s Authe=$zb(Authe,$$$EnableClientSystemSecurityRoles,7) continue
		i String=$zcvt($$$Text("Client application security","%Utility"),"U") s Authe=$zb(Authe,$$$EnableClientApplicationSecurity,7) continue
		i String=$zcvt($$$Text("Internal","%Utility"),"U") s Authe=$zb(Authe,$$$EnableInternalService,7) continue
		i String=$zcvt($$$Text("Windows","%Utility"),"U") s Authe=$zb(Authe,$$$EnableWindows,7) continue
		i String=$zcvt($$$Text("Unix","%Utility"),"U") s Authe=$zb(Authe,$$$EnableUnix,7) continue
		i String=$zcvt($$$Text("VMS","%Utility"),"U") s Authe=$zb(Authe,$$$EnableVMS,7) continue
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
	 i $zb(+%val,$$$EnableEnabled,1) s AutheString=AutheString_$$$Text("Enabled property can be modified","%Utility")_","
	 i $zb(+%val,$$$EnableUsePrivilege,1) s AutheString=AutheString_$$$Text("USE check on resource","%Utility")_","
	 i $zb(+%val,$$$EnablePrivilegeBasedSecurity,1) s AutheString=AutheString_$$$Text("Privilege-based security","%Utility")_","
	 i $zb(+%val,$$$EnableClientSystemSecurity,1) s AutheString=AutheString_$$$Text("Client system security","%Utility")_","
	 i $zb(+%val,$$$EnableClientSystemSecurityRoles,1) s AutheString=AutheString_$$$Text("Client system security with role restriction","%Utility")_","
	 i $zb(+%val,$$$EnableClientApplicationSecurity,1) s AutheString=AutheString_$$$Text("Client application security","%Utility")_","
	 i $zb(+%val,$$$EnableInternalService,1) s AutheString=AutheString_$$$Text("Internal","%Utility")_","
	 i $zb(+%val,$$$EnableWindows,1) s AutheString=AutheString_$$$Text("Windows","%Utility")_","
	 i $zb(+%val,$$$EnableUnix,1) s AutheString=AutheString_$$$Text("Unix","%Utility")_","
	 i $zb(+%val,$$$EnableVMS,1) s AutheString=AutheString_$$$Text("VMS","%Utility")_","
	 s AutheString=$e(AutheString,1,$l(AutheString)-1)
 } catch {
	 s AutheString = ""
 }
 q AutheString
}

}
