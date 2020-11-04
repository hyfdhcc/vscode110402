ROUTINE ISCGetDir [Type=INC]
#;ISCGetDir.INC  function to prompt for and get a directory name; LFT1256 05/04/04
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;LFT1256 5/04/04 Laura Tillem, check for ^ from $$YN
#;CLN051 04/26/04 Laura Tillem, clean #if 0 code
#;DMD044 09/02/03 Daniel Derksen, if there is an error in GetDirLoop do not 
#;		goto GetDirLoop from GetDirE since this can lead to an
#;		infinite loop. Instead, let the error handler in the calling
#;		routine handle the error unless $ZT was never set in the 
#;		calling routine.
#;JO1726 07/02/03 Jeffrey Orlin, add exists<0 for GetDir which means don't
#;                check at all whether its valid or it exists.
#;LFT992 05/13/02 Laura Tillem, add quit parameter to GetDir
#;STC315 01/10/02 Steve Clay: Rewrite without editor features.
#;CLEAN	 01/08/02 Steve Clay: Cleaned
#;LFT819 05/01/00 Laura Tillem, use $$ZSTOP
#;STC242 04/13/00 Steve Clay: Fix NOLINE error
#;RAM798 03/02/99 Rick Miller, GetDir now invokes $$ChkDirOrSpecEXISTS instead
#;                of $$ChkDirEXISTS in order to support database virtual
#;                volumes in raw disk partitions on Unix platforms.
#;LFT611 10/02/98 Laura Tillem, use a local variable for dirlist, not global
#;LFT583 08/17/98 Laura Tillem, add sanity check for dirlist
#;JAO982 11/24/97 Jeffrey Orlin, ChkDir was changed to use $ZU(12,dir,2) to
#;                verify that the directory exists (HYY022). This is not
#;                necessarily what we want. Added a 3rd optional
#;                parameter to control this behavior. If the parameter is
#;                present then 0 = only check for validity and 1 = check that
#;                it exists to. If the parameter is omitted it defaults to 1,
#;                the current behavior. If the flag is 0 and the check for
#;                validity fails, we ask the user whether they want to use
#;                this directory anyway.
#;LFT435 02/20/97 Laura Tillem, work around $ZB bug in read line recall
#;JFP064 11/26/96 John Paladino, Allow "^" to signal exit properly  
#;LRS129 05/09/96 Lee Smith, substitute UC tag with #include ZUC
#;JAO658 03/04/94 Jeffrey Orlin: Entering ^ or QUIT in response to
#;                GetDir results in GetDir returning "". CTRL/C works
#;                too.
#endif  /*=====================End Maintenance======================*/
  
#ifndef ISCGetDir
#define ISCGetDir
GetDir(prompt,defdir,exists,quit) ;ask for a directory, allow defaults
GetDirLoop ; Loop until we get something valid or exit
 s $zt="GetDirE"
 n exist,dir,x
 s exist=+$g(exists,1) ; default is to check if exists
 w !,prompt_": "_$s($g(defdir)'="":$g(defdir)_" => ",1:"") r dir s:dir="" dir=$g(defdir)
 i $$STOP(dir) Set quit=1 Q ""
 i $E(dir)="?" Q dir ;pass-on request for elaboration
#;      ;JO1726+
 q:exist<0 dir ;exist<0 means don't check valid or exists
#;      ;JO1726-
 s x=$S(exist:$$ChkDirOrSpecEXISTS(dir),1:$$ChkDirVALID(dir)) 
 i x="" W *7,"  "_$s(exist:"Directory '"_dir_"' does not exist",1:"Invalid directory specification '"_dir_"'") G:exist GetDirLoop d  g:x="N" GetDirLoop
 . s x=$$YN("Use this directory anyway","N")
#;LFT1256
 i x="^" s quit=1 Quit ""
 q dir
GetDirE S $ZT=""
 i $ze["<INTERRUPT>" q ""
 w !,"Error: "_$ZE
#; This needs to be generic so that if an error trap has been established by the calling
#; routine that error trap will be executed and if no error trap has been established this
#; routine will just quit
#; As of right now, the routines that include this file do not have an error trap established
#; before calling GetDir, but this change allows for one if needed
 zquit 1 i $ZT'="" G @$ZT
 q ""
Touch(D)
 q
#include ISCChkDir
#include ISCYESNO   ;JAO982  
#include ISCSTOP    ;LFT819
#endif ISCGetDir
 