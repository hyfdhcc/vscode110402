Include %sySecurity

Class Security.Datatype.ResourceType Extends %Integer [ System = 2 ]
{

Parameter DOMAIN = "%Utility";

ClassMethod DisplayToLogical(%val As %String) As %Integer [ Internal ]
{
 try {
 	s Type=0
	f i=1:1 {
		s String=$zcvt($p(%val,",",i),"U") q:String=""
		i String=$zcvt($$$Text("Database","%Utility"),"U") s Type=$zb(Type,$$$DBResourceType,7) continue
		i String=$zcvt($$$Text("Service","%Utility"),"U") s Type=$zb(Type,$$$ServiceResourceType,7) continue
		i String=$zcvt($$$Text("System","%Utility"),"U") s Type=$zb(Type,$$$ApplicationResourceType,7) continue
		i String=$zcvt($$$Text("DeepSee","%Utility"),"U") s Type=$zb(Type,$$$DeepSeeResourceType,7) continue
		i String=$zcvt($$$Text("Application","%Utility"),"U") s Type=$zb(Type,$$$UserResourceType,7) continue
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
 	s DisplayType = $s($zb(%val,$$$DBResourceType,1):$$$Text("Database","%Utility"),$zb(%val,$$$ServiceResourceType,1):$$$Text("Service","%Utility"),$zb(%val,$$$ApplicationResourceType,1):$$$Text("System","%Utility"),$zb(%val,$$$DeepSeeResourceType,1):$$$Text("DeepSee","%Utility"),$zb(%val,$$$UserResourceType,1):$$$Text("Application","%Utility"),1:$$$Text("Unknown","%Utility"))
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
