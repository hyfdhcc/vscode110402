ROUTINE ISCNODIROS [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
STC200   ;02/26/99, Steve Clay: Removed Site is macro
VGG195   ;07/06/95, Vadim Goldin: cleaned up and used modern means ($zu(12))
DKA187   ;06/29/93, Keith Avery: Commonized for AlphaVMS
DPB135   ;06/29/93, Dan Smith -- fixed syntax error that occurred when
         ;          files including ZNODIROS were ZLOADed.  M requires a
         ;          a space following a tag or parameter list, but this is
         ;          not always caught as a syntax error.
DPBS083  ;03/09/93, Dan Smith -- initial creation, test on UNIX and PC
#endif  /*=====================End Maintenance======================*/
 
#if 0   /*======================Documentation=======================*/
         ;Uses a questionable method to determine whether an
         ;operating system directory exists (as seen by the OS, not by M)
 
         ;e.g. on a typical UNIX system, "/usr/bin/" exists as
         ;     an operating system directory, but not as an M directory
         ;     (because it contains no MUMPS.DAT).
 
         ;This function was created in order to present a more useful
         ;error message to the DISMOUNT and %DSET user, particularly
         ;in the case when a directory name is mistyped.  
 
         ;There's currently no well-specified, well-documented way of
         ;obtaining this information.  On tested systems, $ZU(5,D)
         ;error-traps if operating system directory D does not exists,
         ;succeeds if D exists even if it contains no MUMPS.DAT, but
         ;that behavior isn't specified or documented.
 
         ;I'd like to see $ZU(49) return -3 if the OS directory does
         ;not exist.
 
         ;$$NODIROS(D), where D is the name of a directory, returns:
         ;     1 if the operating system directory does not exist         
         ;     0 if the operating system directory exists
         ;     -1 if the answer is unknown.
 
#endif  /*====================End Documentation=====================*/
 
#ifndef ISCNODIROS
#define ISCNODIROS
 
NODIROS(D) ;Return 1 if D doesn't exist, 0 if it exists, -1 if can't tell
 i $zu(12,D,3)="" q 1
 q 0
#endif
 