ROUTINE ISCChkDir [Type=INC]
#;ISCChkDir.INC   -- check a directory for validity ;STC315 01/08/02
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;SML1290 01/13/11 Simon Li, Support restore mirror journal record for non-mirror system.
#;STC315 01/08/02 Steve Clay, Cleaned up the code.
#;CLEAN	 01/08/02 Steve Clay, Cleaned
#;RAM798 03/02/99 Rick Miller, added new ChkDirOrSpecEXISTS entry point which
#;                supports raw disk partitions on Unix platforms but is
#;                otherwise identical to the existing ChkDirEXISTS entry point.
#;JAO982 11/24/97 Jeffrey Orlin, ChkDir was changed to use $ZU(12,dir,2) to
#;                verify that the directory exists (HYY022). This is not
#;                necessarily what the callers expect. Added ChkDirVALID()
#;                to use $ZU(12,dir,1) and ChkDirEXISTS to use $ZU(12,dir,2).
#;                ChkDirEXISTS is the same as ChkDir but the intention is that
#;                ChkDir gets phased out and replaced by one of the new ones. 
#endif /*=====================End Maintenance======================*/
#ifndef ISCChkDir
#define ISCChkDir
 
#;   ChkDirVALID() checks to see whether a directory spec is valid
#;   as opposed to ChkDir() and ChkDirEXIST() that check to see
#;   that it exists too
#;         
ChkDirVALID(R) S $ZE="",$ZT="ChkBad" q:R[":mirror:" R q $ZU(12,R,1)
ChkDirEXISTS(R) S $ZE="",$ZT="ChkBad" q:R[":mirror:" R q $ZU(12,R,2)
#;   ChkDirOrSpecEXISTS() checks to see whether a directory or file spec is
#;   valid AND that it exists as a directory or, on Unix platforms only, as a
#;   character special or block special file which may be a raw disk partition
#;   that can serve as a Cache database virtual volume.
#;         
ChkDirOrSpecEXISTS(R) S $ZE="",$ZT="ChkBad" q:R[":mirror:" R q $ZU(12,R,3)
ChkDir(R) N N S $ZE="",$ZT="ChkBad" q:R[":mirror:" R q $ZU(12,R,2)
ChkBad S $ZT="" W !,"<"_$P($P($ZE,"<",2),">")_"> error -- invalid directory"
 Q ""
  
#endif ISCChkDir