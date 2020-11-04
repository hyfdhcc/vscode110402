ROUTINE LABEL [Type=INC]
#ifndef LABELINC
#define LABELINC
;;LABEL.INC -- LABEL.MAC, LABEL1.MAC common subroutines
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;LFT1320 10/28/4 Laura Tillem, %ST -> ST
#;HYY766 04/15/03 Huayong Yang, use SFNUNDEF instead of a hard-coded #
#;LFT914 03/29/01 Laura Tillem, changes for big database, CLEANED
#;JAO950 07/07/97 Jeffrey Orlin, updated DKIOERR calls.
#;EAV005 09/26/96 Edward Valenti: keep LABEL routines under 8K, move
#;                #include DKIOERR to DKIOERR.MAC
#;DKA294 06/10/96 Keith Avery: Added NONEWZURETVAL option
#;DKA294 04/27/96 Keith Avery: Changes for new $ZU return format
#;                and common code clusters.
#;                Cleaned out old code for DVU186
#;DPV546 09/08/95 David Van De Griek: In MOUNTED, $$STAT() returns 255
#;                if directory is not mounted and has never been mounted
#;DVU186          Dmitry Umansky: Fix undefined error in LNKSET
#endif  /*=====================End Maintenance======================*/
 
#include SYSTEM
#include %occErrors
  
FAIL(X) W !,X,!,"Volume Modification aborted.",! Q
 ;-=-=-=-=
LABSET(DIR,NEW) N ZU36
 S ZU36=$ZU(36,DIR,0,0,NEW) ;set label of primary vol to NEW
 Q $S(ZU36<0:"Label change failed because "_$$MSG^%DKIOERR(ZU36),1:1)
  
LNKSET(DIR,NEW) N TYP,ZU36 S TYP=$$TYPE(DIR)
 I TYP="" Q ("Link change failed: no Volume-Type")
 S ZU36=$ZU(36,DIR,TYP,1,NEW) ;change the continuation pointer
 Q $S(ZU36<0:"Link change failed because "_$$MSG^%DKIOERR(ZU36),1:1)
  
#if 1  ;LFT914+
LNKSETBIGDB(DIR,NEW,VOL) New ZU36
 Set ZU36=$Zutil(36,DIR,0,VOL-1,NEW)
 Q $S(ZU36<0:"Changing volume "_VOL_" failed because "_$$MSG^%DKIOERR(ZU36),1:1)
#endif	;LFT914-
 
PNTSET(DIR,NEW) N TYP,ZU36 S TYP=$$TYPE(DIR)
 I TYP'=1 Q ("Root pointer change failed: inappropriate Volume-Type")
 S ZU36=$ZU(36,DIR,1,0,NEW) ;change the root pointer
 Q $S(ZU36<0:"Root pointer change failed because"_$$MSG^%DKIOERR(ZU36),1:1)
 ;-=-=-=-=
ROOT(DIR) N ZU36 S ZU36=$ZU(36,DIR,0,0) Q:ZU36'<0 ZU36 ;label of primary volume
 S ZU36=$ZU(36,DIR,1,0) Q:ZU36'<0 ZU36 ;location of primary volume
 Q -1 ;return -1: could not get the root directory
  
#; For big databases this only gets the first extent.
LINK(DIR) N ZU36 S ZU36=$ZU(36,DIR,0,1) Q:ZU36'<0 ZU36 ;link from root volume
 S ZU36=$ZU(36,DIR,1,1) Q:ZU36'<0 ZU36 ;link from secondary volume
 Q -1 ;return -1: could not get link directory
 
#if 1  ;LFT914+
#; For big databases only, get the next extent after the VOLth one.
NEXTLINK(DIR,VOL) New ZU36 Set ZU36=$Zutil(36,DIR,0,VOL+1) Quit:ZU36'<0 ZU36
 Quit -1  ; Unknown Error
#endif	;LFT914-
  
STAT(DIR) I (DIR=-1)!(DIR="") Q "" ;handle special case; bad directory name...
 S $ZT="STERR" Q $ZU(49,DIR) ;could fail, so...
STERR S $ZT="",$ZE="" Q "" ;return null: MUMPS.DAT, but bad label
  
TYPE(DIR) N ZU36 S ZU36=$ZU(36,DIR,0,0) Q:ZU36'<0 0 ;assumed primary worked
 S ZU36=$ZU(36,DIR,1,0) Q:ZU36'<0 1 ;assumed secondary worked
 Q "" ;neither!
  
NVOL(DIR) ;return number-of-volumes belonginf to database
 N ROOT,STAT S STAT=$$STAT(DIR) ;1st try the specified directory
 I STAT="" S ROOT=$$ROOT(DIR),STAT=$$STAT(ROOT) ;then try root
 Q $P(STAT,",",15) ;15th ,-piece is number of database volumes
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
MOUNTED(DIR) N D S D=DIR I $$TYPE(DIR)=1 S D=$$ROOT(DIR) ;use root
 s D=$$STAT(D) q $s(D<1!(D'<$$$SFNUNDEF):0,1:1) ;is directory mounted?
UNMOUNT(DIR) S $ZT="MNTERR1^"_$ZN ;unmount a specific directory
 D ONE^DISMOUNT(DIR) Q 1 ;perform the dismount
MNTERR1 S $ZT="" Q ("Could not dismount '"_DIR_"'")
REMOUNT(DIR) ;remount it (if it was dismounted)
 S $ZT="MNTERR2^"_$ZN N (DIR) D ^ST
 s Status=##Class(SYS.Database).MountDatabase(DIR,0,0)
 i Status'=1 q "Remount of "_DIR_" failed"
 i $$MOUNTED(DIR) q 1
 Q "Could not remount '"_DIR_"'"
MNTERR2 S $ZT="" Q ("Could not remount '"_DIR_"'")
DISMNT(DIR) N X,MNT S MNT=1 DO  Q MNT
 . S X=$$YN("Dismount directory '"_DIR_"' to perform change","Y")
 . I X'="Y" W !,"Modifications discarded.",! S MNT=0 Q  ;by decision
 . S X=$$UNMOUNT(DIR) I 'X D FAIL(X) S MNT=0 Q  ;by error
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#include ISCGetDir
#include ISCChkDir
#include ISCED
#include ISCYESNO
  
#endif LABELINC