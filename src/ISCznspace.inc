ROUTINE ISCznspace [Type=INC]
#ifndef ISCznspace
#define ISCznspace
 /*  ; Revision: $Id$ ($Change$)  */
#;/*=======================Maintenance=============================*/
#;STC2505  4/19/16 Steve Clay, Remove setting of switch 10 in ZN command 
#;SML1840  3/06/14 Simon Li, Check $J correctly when NodeNameInPid is enabled.
#;STC2251 10/08/13 Steve Clay, ZN "^^dir" tests for dir=""
#;STC2205 05/06/13, Steve Clay Add directory to <PROTECT> error when switching namespaces
#;STC2184 02/22/13, Steve Clay, Allow ^PROFILE to collect data on SQL cached queries 
#;STC2182 02/21/13 Steve Clay, ZN protects namespace table correctly
#;SML1565 10/17/12 Simon Li, Protect namespace table scanning without lock command.
#;JLC1615 05/24/12 Jose' Cordeiro, give <NAMESPACE> instead of <UNKNOWN ERROR>
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;STC1956  6/14/11 Fix ZN class does not exist error
#;JO2397   2/11/10 Jeffrey Oriln, zn for USEDBONLY uses $ZU(5)
#;STC1880 12/27/10 Steve Clay, Fix class does not exist on upgrade
#;STC1646 07/23/09 Steve Clay Fix ZN command if we have lost privileges in current namespace 
#;RJW1704 06/03/09 Ron Watt, Error due to ECP licensing problem should be <NETWORK UNLICENSED> instead of <PROTECT>
#;STC1569 03/30/09 Steve Clay, Don't make a $d() global reference during ZN command
#;STC1529 01/20/09 Steve Clay, Get CACHELIB DB from global in %CACHELIB not defined
#;STC1407 06/20/08 Steve Clay ZN command now works if in implied namespace with no mappings
#;STC1301 02/22/08 Steve Clay Improve performance of ZN command
#;STC1263 09/20/07 Fix ZN command for remote implied namespaces 
#;SML922 08/24/07 Simon Li, Fix ZN "" getting <NAMESPACE> error.
#;STC1148 101/11/07 Steve Clay, create %SYS namespace if zn to %SYS and it doesn't exist
#;STC1104 10/17/06 Steve Clay, Allow ZN to a remote DB which has not yet been touched
#;STC939 10/31/05 Steve Clay, Force mount of remote DB when ZN to them
#;RJW1154 8/02/05 Ron Watt, $ZNSPACE should handle remote system and database
#;SML586 06/01/05 Simon Li, trap <NAMESPACE> error for ZN command.
#;RJW1131 05/25/05 Ron Watt, fix error message in ZNSPACE, removed ZZNSPACE
#;RJW1126 05/14/05 Ron Watt, "ZN" For Underprivileged User Results In Two Protect Records
#;STC745 01/10/05 Steve Clay, Create implied namespace
#;SJ1280 12/10/00 Scott Jones, znspace.INC creation
#;/*=====================End Maintenance============================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#include %sySite
#include %sySystem  ;JO2397
#include %sySecurity
#;SML1565
#include ISCQUIEDEF
ZN(%) public {
#;If we are requesting the same namespace, then get out without doing anything.
 q:$g(%)=$zu(5)
 Set $ZT="znerror"
 #;JO2397+
 if $$$USEDSONLY { s %=$ZU(5,%) quit }
 #;JO2397-
#;We first get where the CACHELIB namespace is. If it doesn't exist, we then get where the 
#;CACHELIB database is. We use this location to find the %NSP routine. The %NSP routine actually does the
#;$zu(5,%) call to change to the namespace. We need to do this from a routine which doesn't exist
#;in the CACHESYS database so if we don't have access we will get a protect error.
#;If the %SYS namespace doesn't exist, and we are trying to change to it, create it. This means
#;we started the system with NOSTU, or by hand.
 s LOC="%CACHELIB" s:'$zu(90,10,"%CACHELIB") LOC=$g(^%SYS("DBRefByName","CACHELIB")) i $e(%)'="^" s:$e(%,1)'="@" %=$zcvt(%,"U") i $zu(90,10,%) { s Protect=$zu(179,0,8,0) s rc=$$Access^|LOC|%NSP(%) d $zu(179,0,8,Protect) i rc { Quit } else { s $zt="" Ztrap $$$APPERROR($$$LASTERROR)}} else {i %="%SYS" {s %1=$$MAP^%SYS.NAMESPACE("%SYS",,,$zu(12)) S %=$ZU(5,%) Quit } i %="" { s %=$zu(5,"") Quit} s $zt="" Ztrap $$$APPERROR($$$ERNAMSP)} 
#;If here, we have an implied namespace we are changing to ( zn "^^c:\cache\mgr\user" )
#;Canonize local directory.  Leave remote unchanged.
 i $l(%,"^")'=3 {ztrap $$$APPERROR($$$ERNAMSP)}
 s sys=$zcvt($p(%,"^",2),"U"),dir=$P(%,"^",3) s:sys="" dir=$zu(12,dir) s:sys'="" dir=$$canondir(dir) s CanonDir="^"_sys_"^"_dir
#;Now check for access to the implied namespace. If I have the %All role I don't have to check.
 i '$$$IOwnAllRole {
#;If we don't own the %All role, we need to check if we are trying to ZN "^^CACHE". Disallow it.
#;We need to add the %All role here to check the global
	i $zcvt(CanonDir,"l")=$zcvt($g(^%SYS("DBRefByName","CACHE")),"l") s $zt="" ztrap $$$APPERRORTEXT($$$ERPROTMISC,%)
#;We need to add the %All role here as we may not have access to the namespace we are currently
#;in (privileges may have been reduced by the caller, but we are still in the namespace), 
#;and we need to get back to it when the new $namespace pops it stack.
#;Turn off logging of protect errors. If we don't, we get multiple protect errors in the audit.
	s Protect=$zu(179,0,8,0) 
 	Try {
 		d
 		. n $roles,$namespace s rc=$$Access^|LOC|%NSP(CanonDir)
		. $$$AddAllRole
 	} catch {
	 	s rc=0
	}
 	d $zu(179,0,8,Protect)
#;If I don't have access, it is because I got either a protect error or a directory error where the
#;DB does not exist, or can't be mounted or something.
	i 'rc s $zt="" Ztrap $$$APPERROR($$$LASTERROR)
 }
#; Form namespace as @SYS@DIRECTORY and map if it doesn't exist
#;SML1565,SML1651
 s ZNDir=$translate(CanonDir,"^","@")
 if '$zu(90,10,ZNDir) {
#;We no longer need to set switch 10 here since we are adding to the end of the nmespace table.
#;Note that the following will fail if I am in a real implied namespace ($zu(5,"^^USER")) when called
#;since I don't have access to %SYS.GlobalQuery at this point (used in %SYS.NAMESPACE). We only allow 
#;creating a namespace here if we are already in a namespace which has mappings set up.		 
	s rc=$$MAP^%SYS.NAMESPACE(ZNDir,dir,,,sys)
 	i 'rc s $zt="" ztrap $$$APPERROR($$$ERNAMSP) 
 }
#;Finally switch to the namespace
 S %=$ZU(5,ZNDir) 
 quit
znerror Set $ZT="" d:$d(Protect) $zu(179,0,8,Protect) Ztrap:'$D(%) $$$APPERROR($$$ERSYNTX) Ztrap $$$APPERROR($$$LASTERROR)
#;SML1565
#;Canon makes sure the directory has a trailing "/" or "\". Ignore for VMS.
canondir(dir) q:("\/]"[$e(dir,*)) dir q:dir["/" dir_"/" q:dir["\" dir_"\" q dir
}
#;ZNSPACE entry point
ZNSPACE(%) public {
 d ZN(.%)
}
#endif
