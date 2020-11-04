ROUTINE DBRTEXT [Type=INC]
#show
 ;DBRTEXT.INC; STC2115, 8/2/12
#if 0    ;==========================Maintenance================================
#;STC2115 8/02/12 Steve Clay, ^BACKUP and ^DBREST now allows for display of backup volume contents 
#;JO2379  1/14/10 Jeffrey Orlin, error messages for mirror database restore
#;SML783 10/26/06 Simon Li, Fix a typo from SML730.
#;SML730  6/30/06 Simon Li, Support unattended restore when DB does not exist.
LRS746   ; 01/08/04, Lee Smith, improve and correct dialog, some cleaning
LRS452   ; 08/10/00, Lee Smith, modify "MakExist" entry per new meaning
JO1047   ; 06/18/98, Jeffrey Orlin, add include of %system
LRS181   ; 09/19/97, Lee Smith, Cache' nomenclature changes
EAV005   ; 09/27/96, Edward Valenti. keep routines under 8K, split to DBRTEXT1.MAC
LRS106   ; 12/11/95, Lee Smith. Changed MUMPS.XXX to OPENM.XXX
DXU001   ;  8/15/95, David Xu. Changed MUMPS and M/SQL to M or Open M
AHS171   ;  8/11/95, Amir Shokrollahi.  Added buffer count display.
RAM485   ;  5/10/95, Rick Miller.  Added new "NotExist" and "MakExist" entries.
RAM477   ;  3/15/95, Rick Miller.  Added new "DUPLDIR" entry.
RAM451   ; 12/16/94, Rick Miller.  Added new entries related to $ZV value.
RAM420   ; 12/07/94, Rick Miller.  Added new entries related to the revised
         ;           format of the incremental backup file and support for
         ;           the backup device being a magtape.
RAM427   ; 08/31/94, Rick Miller, added new entries.
DPB156   ; 07/28/93, Dan Smith, new entries
DPB144   ; 07/16/93, Dan Smith. Major revision; storage in local rather
         ;           than global; added new entries; revised some wording.
  
         ;           Design goal: make DBRTEXT as maintainable as possible;
         ;           allow as much space on each line as possible for text
         ;           so that visual effect can be be judged unimpeded by
         ;           line wrap.  Made DBRTEXT an INCLUDE file so editor
         ;           will not try to insert spaces before comment semicolons.
  
         ;           Requires long string support.
  
         ;           Within DBREST: Do Show("ITEMNAME"[,P1[,P2[,P3[,P4]]]]
         ;           Up to four substitutable parameters.
  
         ;           Within DBRTEXT:
         ;
         ;                 #    Replaced by a substitutable parameter
         ;
         ;                 !    Replaced by $C(7) (bell) IF it's the
         ;                      first character following the semicolon
  
AN038    ; 04/08/92,  Arvind Narayan. Created this routine.
#endif   ;=====================================================================
 
#noshow
#include %sySystem
#show
#; Display text for Cache database restore. Store a good part of the
#; display text in dbrtext to compact DBREST.
  
  
#define entry(%item) ##continue
%item d entry("%item")
  
GO       K dbrtext
  
$$$entry(aborting)
  
 ;;[Aborting restoration from this backup file]
  
$$$entry(abtdmt)
  
 ;;[Aborting restoration of this directory and dismounting it]
 ;;
$$$entry(anymore0)
  
 ;;Do you have any backups to restore?
  
$$$entry(anymore1)
  
 ;;Do you have any more backups to restore?
  
$$$entry(ASKRES)
  
 ;;Restore: 1. All directories
 ;;         2. Selected and/or renamed directories
 ;;         3. Display backup volume information
 ;;         4. Exit the restore program
  
$$$entry(ALREADY)
  
 ;;Do you want to set switch 10 so that other processes will be
 ;;prevented from running during the restore?
  
#;LRS746+
$$$entry(MAYBE)
  
 ;;NOTE: Some operations could cause switch 10 to be set for a few seconds.
 ;;      A warning message will be printed if this happens.
  
#;LRS746-
  
$$$entry(chnglist)
  
 ;;Do you want to change this list of directories?
  
#;SML730+
$$$entry(confirmRestore)
  
 ;;Restore will overwrite the data in the old database. Confirm Restore?
  
#;SML730-
  
$$$entry(CREATE)
  
 ;;You can retry opening it, create it, or abort the restoration
 ;;of this directory.
  
$$$entry(DIRNAM)
  
 ;;
 ;;For each database included in the backup file, you can:
 ;;
 ;; -- press RETURN to restore it to its original directory;
 ;; -- type X, then press RETURN to skip it and not restore it at all.
 ;; -- type a different directory name.  It will be restored to the directory
 ;;    you specify.  (If you specify a directory that already contains a 
 ;;    database, the data it contains will be lost).
 ;;
  
#if 1   ; RAM477+
$$$entry(DUPLDIR)
 ;;!Directory # was already specified
 ;;as the target of another restore operation
 ;;
 ;;
#endif   ; RAM477-
  
#if 1   ; RAM485+
$$$entry(NotExist)
#if 0   ;LRS746+
 ;;!# does not exist
 ;;at the operating system level so a database cannot be stored there.
 ;;
#else   ;LRS746=
 ;;!Directory # does not exist
 ;;at the operating system level so a database cannot be stored there.
#endif  ;LRS746-
 
#;LRS746+
$$$entry(MakeLater)
 ;;   You can continue and this check will be repeated when restoration
 ;;   to that directory begins, at which time you can choose to have it
 ;;   be created, or else you can select a different directory now.
 ;;Do you want to modify your selection of directory?
#;LRS746-
 
$$$entry(MakExist)
#if 0   ;LRS746+
#if 0   ;LRS452+
 ;;If available, you can go to another window or terminal and create
 ;;# at the operating
 ;;system level and then have this utility create a database in it by
 ;;responding "C" to the following question, or you can abort the
 ;;restoration into this directory by responding "S".
#else   ;LRS452=
 ;;You can have this utility make the directory and then create a
 ;;database in it by responding "C" to the following question.
#endif  ;LRS452-
 ;;
 ;;
#else   ;LRS746=
 ;;   You can have this utility make the directory and then create a
 ;;   database in it by responding "C" to the following question.
#endif  ;LRS746-
#endif   ; RAM485-
  
#if 0   ;LRS746+
$$$entry(dirnexis)
  
 ;;!Directory # doesn't exist or can't be accessed.
  
$$$entry(DIRREST0)
  
 ;;You can either continue the restoration of this directory,
 ;;abort the restoration of this directory,
 ;;or abort this restoration session altogether.  All of these choices
 ;;will probably result in losing data and maybe in database degradation.
 ;;Continue the restoration of this directory?
 ;;
  
$$$entry(DIRREST1)
  
 ;; You can either retry writing these blocks, skip these
 ;; blocks and continue restoring to this directory,
 ;; abort the restoration of this directory
 ;; or abort restoring this backup.  All but the choice of
 ;; retrying will result in losing data and maybe in
 ;; database degradation)
 ;;Retry these blocks?
  
#else   ;LRS746=
$$$entry(dirnexis)
  
 ;;!Directory # does not contain a database
 ;;or it can't be accessed.
  
$$$entry(DIRREST0)
  
 ;; You can continue the restoration of this directory, abort the
 ;; restoration of this directory, or abort this restoration session
 ;; altogether.  All of these choices will probably result in losing
 ;; data and maybe in database degradation.
 ;;Continue the restoration of this directory?
 ;;
  
$$$entry(DIRREST1)
  
 ;; You can retry writing these blocks, skip these blocks and continue
 ;; restoring to this directory, abort the restoration of this
 ;; directory, or abort restoring this backup.  All but the choice of
 ;; retrying will result in losing data and maybe in database
 ;; degradation.
 ;;Retry these blocks?
  
#endif  ;LRS746-
#if 1   ; RAM420+
  
#if 0   ;LRS746+
$$$entry(DIRREST2)
  
 ;; You can either skip this block and continue the restoration of this
 ;; directory, abort the restoration of this directory, or abort this
 ;; restoration session altogether.  All of these choices will probably
 ;; result in losing data and maybe in database degradation.
 ;;Continue the restoration of this directory?
  
#else   ;LRS746=
$$$entry(DIRREST2)
  
 ;; You can skip this block and continue the restoration of this
 ;; directory, abort the restoration of this directory, or abort this
 ;; restoration session altogether.  All of these choices will probably
 ;; result in losing data and maybe in database degradation.
 ;;Continue the restoration of this directory?
  
#endif  ;LRS746-
$$$entry(erbadrec)
  
 ;;!Invalid backup data record read from device # for
 ;;database block # of directory #.
  
$$$entry(erbadlab)
  
 ;;!Invalid backup label record read from device # following
 ;;directory #.
  
$$$entry(skip2lab)
  
 ;; If you do not continue, the restoration of this backup will be
 ;; aborted.  If you do continue, you will have missed a directory
 ;; label block that will result in your missing the restore of a
 ;; portion of a directory.
 ;;
 ;;Continue?
  
$$$entry(endofvol)
  
 ;;!End of backup device # encountered prematurely while
 ;;reading directory #.
 ;;Aborting restoration.  Data may have been lost.  Database degradation
 ;;is likely.
  
#endif   ; RAM420-
  
$$$entry(errabort)
  
 ;;
 ;;***ERROR OCCURRED: [#] -- Aborting restoration.
 ;;
  
$$$entry(errmrk)
  
 ;;Error marking directory # as the target of a restore.
 ;;# will not be restored.
 ;;
  
$$$entry(errmrk1)
 ;;Directory # was created, but an error occurred trying
 ;;to mark it as a restoration target.
 ;;
  
  #;JO2379+
$$$entry(errmrk2)
  
 ;;Directory # is mirrored and cannot be the target of a restore.
 ;;# will not be restored.
 ;;
 #;JO2379-
 g ^DBRTEXT1
  
entry(fromtag) ;Scan lines starting at fromtag+1 and put in dbrtext(fromtag)
 n break,i,line,stop,tag,text
 s break=$c(13,10) ;Maybe not system-independent???
 f i=1:1 d  q:stop  s dbrtext(fromtag)=$g(dbrtext(fromtag))_break_text
 . s line=$text(@fromtag+i)
 . s tag=$p(line,";;"),text=$p(line,";;",2)
 . i $e(text)="!" s $e(text)=$c(7) ;Leading bang becomes bell
 . s stop=$$isblank(line)!$$nonblank(tag)
 q
  
isblank(line) q $tr(line," ","")=""
nonblank(line) q '$$isblank(line)