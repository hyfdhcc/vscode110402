Include %sySecurity

Class Security.Datatype.Permission Extends %Integer [ System = 2 ]
{

/*
---------------------Documentation------------------------------------
STC666 10/24/04 Steve Clay, Changes for CACHELIB/CACHESYS split
PWC886 07/15/04 Peter Cudhea, Remove DEVELOP permission, and USE for databases
STC471 08/19/03 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
ClassMethod DisplayToLogical(%val As %String) As %Integer [ Internal ]
{
 q ..ExternalToInternal(%val)
}

ClassMethod LogicalToDisplay(%val As %Integer) As %String [ Internal ]
{
 q ..InternalToExternal(%val)
}

ClassMethod LogicalToOdbc(%val As %Integer) As %String [ Internal ]
{
 q ..InternalToExternal(%val)
}

/// Convert an external string of permissions to an internal mask.
/// <br>
/// The permission list can be a comma separated list of permissions using
/// either the full permission name or 1 character abbreviations (upper or lowercase).
/// The permission
/// string can also be a single string consisting of single character abreviations.
/// If the permission string is not valid, then 0 is returned.
/// <br>
/// Examples:
/// <br>
/// "Read,Use"
/// <br>
/// "READ,w,U"
/// <br>
/// "RWU"
ClassMethod ExternalToInternal(Permissions As %String) As %Integer [ Internal ]
{
  s $zt="Error"
 s Perms=$zcvt(Permissions,"u")
 s Mask=0
 f i=1:1:$l(Perms,",") {
#; First check for comma-delimited permissions, either single char
#; or the entire word
	s Perm=$p(Perms,",",i)
	i (Perm=$$$PermReadName)!(Perm=$$$PermReadAbrev) s Mask=$zb(Mask,$$$PermReadMask,7) Continue
	i (Perm=$$$PermWriteName)!(Perm=$$$PermWriteAbrev) s Mask=$zb(Mask,$$$PermWriteMask,7) Continue
	i (Perm=$$$PermUseName)!(Perm=$$$PermUseAbrev) s Mask=$zb(Mask,$$$PermUseMask,7) Continue
#; Failing that, now check for all single character permissions in 1 string
	i $l(Perms,",")=1 {
		f j=1:1:$l(Perm) {
 			s P=$e(Perm,j)
	 		i (P=$$$PermReadAbrev) s Mask=$zb(Mask,$$$PermReadMask,7) Continue
			i (P=$$$PermWriteAbrev) s Mask=$zb(Mask,$$$PermWriteMask,7) Continue
	 		i (P=$$$PermUseAbrev) s Mask=$zb(Mask,$$$PermUseMask,7) Continue
#; The string isn't a valid permission, so return 0
 			s Mask=0
 			q
 		}
 		Continue
	}
#; The string isn't a valid permission, so return 0
	s Mask=0
	q
 }
 q Mask
Error s $zt=""
 q 0
}

/// Convert internal permission code to external display.
/// <br>
/// Flag = 0 - Display in RWU format<br>
/// Flag = 1 - Display in R,W,U format<br>
/// Flag = 2 - Display in READ,WRITE,USE format<br>
ClassMethod InternalToExternal(Mask As %Integer, Flag As %Integer = 0) As %String [ Internal ]
{
 s $zt="Error"
 s String=""
 f i=$$$PermReadMask,$$$PermWriteMask,$$$PermUseMask {
	 i Mask\i#2 {
		 i Flag=0 s String=String_$case(i,$$$PermReadMask:$$$PermReadAbrev,$$$PermWriteMask:$$$PermWriteAbrev,$$$PermUseMask:$$$PermUseAbrev,:"")
		 i Flag=1 s String=String_$case(i,$$$PermReadMask:$$$PermReadAbrev,$$$PermWriteMask:$$$PermWriteAbrev,$$$PermUseMask:$$$PermUseAbrev,:"")_","
		 i Flag=2 s String=String_$case(i,$$$PermReadMask:$$$PermReadName,$$$PermWriteMask:$$$PermWriteName,$$$PermUseMask:$$$PermUseName,:"")_","
	 }
 }
 i $e(String,$l(String))="," s String=$e(String,1,$l(String)-1)
 q String
Error s $zt=""
 q ""
}

}
