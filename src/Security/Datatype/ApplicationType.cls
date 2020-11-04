Include %sySecurity

Class Security.Datatype.ApplicationType Extends %Integer [ System = 2 ]
{

Parameter DOMAIN = "%Utility";

ClassMethod DisplayToLogical(%val As %String) As %Integer [ Internal ]
{
 try {
 	s Type=0
	f i=1:1 {
		s String=$zcvt($p(%val,",",i),"U") q:String=""
		i String=$zcvt($$$Text("CSP","%Utility"),"U") s Type=$zb(Type,$$$AppTypeCSP,7) continue
		i String=$zcvt($$$Text("Routine","%Utility"),"U") s Type=$zb(Type,$$$AppTypePrivRoutine,7) continue
		i String=$zcvt($$$Text("Executable","%Utility"),"U") s Type=$zb(Type,$$$AppTypeExecutable,7) continue
		i String=$zcvt($$$Text("System","%Utility"),"U") s Type=$zb(Type,$$$AppTypeSystem,7) continue
	#;Invalid authentication
	 	s Type=-1 q	
	}
 } catch {
	 s Type = -1
 }
 q Type
}

ClassMethod LogicalToDisplay(%val As %Integer) As %String [ Internal ]
{
 try {
 	s DisplayType=$case($zb(+%val,$$$AppTypeCSP+$$$AppTypePrivRoutine+$$$AppTypeExecutable,1),$$$AppTypeCSP:$$$Text("CSP","%Utility"),$$$AppTypePrivRoutine:$$$Text("Routine","%Utility"),$$$AppTypeExecutable:$$$Text("Executable","%Utility"))
 	i $zb(+%val,$$$AppTypeSystem,1) s DisplayType=$$$Text("System","%Utility")_","_DisplayType
 	} catch {
	 	s DisplayType = ""
	}
 q DisplayType
}

ClassMethod LogicalToOdbc(%val As %Integer) As %String [ Internal ]
{
 q ..LogicalToDisplay(%val)
}

}
