ROUTINE %sySite [Type=INC]
 ;%sySite.inc
 ;simple definitions for determining which site to compile for
  
#if 0   /*=======================Maintenance========================*/
SAP526 ; 2/16/06 Steve Pettibone, redefine LOGMSG()
CFL1332	;6/01/05 Carlos Lopes, define LOGMSG()
STC471  ;8/19/03 Steve Clay, renamed to %sySite
SJ1371  ;6/04/02 Scott Jones, don't parse $ZV
APJ521  ;3/05/99 Phil Johnson: Add ISDSM macro
STC200  ;2/23/99 Steve Clay: Removed SiteIs macro, added ISVMS etc.
LRS280 ;11/12/98 Lee Smith: change ^%qCacheSQLSys to ^%SYS
LRS218  ;3/31/98 Lee Smith: added defines THREEONE, %sys
DKA290 ;11/17/95 Keith Avery: Commonized for NT & Win95
DKA187  ;6/29/93 Keith Avery: Commonized for AlphaVMS
BB356   ;4/25/91 Ben Bishop: added multiple-inclusion exclusion
#endif  /*=====================End Maintenance======================*/
  
#define SiteUNIX   "M/UX"
#define SiteVMS    "M/AV"
#define SiteNT     "M/WNT"
#define SiteUNKNOWN "UNKNOWN"
 
#define %sys  ^%SYS
  
#;SJ1371+
#define Site $Case($zversion(1),1:$$$SiteVMS,2:$$$SiteNT,3:$$$SiteUNIX,:$$$SiteUNKNOWN)
#define ISVMS           ($zversion(1)=1)
#define ISWINDOWS       ($zversion(1)=2)
#define ISUNIX          ($zversion(1)=3)
#define ISDSM           ($zv["DSM")
#;SJ1371-
#define LOGMSG(%m,%q,%s)   $zu(9,"",%m,(%s>0),%s)
 