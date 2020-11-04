ROUTINE %syJrninc [Type=INC]
 ;%syJrninc.INC    Flat file journalling definitions file, HYY1771 06/28/12
 
 ;flat file journalling uses these macro definitions to perform
 ;     the indicated actions.  These could be (possibly) simulated
 ;     with normal global journalling.
 
#ifndef %syJrninc
#define %syJrninc
 /* Revision: $Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/inc/_syJrninc.inc#1 $ ($Change: 4521965 $) */

 ; **** File Operations
#;		/*=======================Maintenance========================*/
#;HYY2074  2/03/16 Huayong Yang, add JrnHdrOLDNEWOFFSETS
#;SML2208 12/10/15 Simon Li, Fix up calculation of "dejrnchkpnt" in mirroring.
#;HYY2034  7/10/15 Huayong Yang, use trailing ":" for JRNMIRDBNAMSFN
#;HYY2028  6/11/15 Huayong Yang, add IsMirrorDBName and macros for $zu(78,31)
#;RJF177   5/08/15 Ray Fucillo, split record-extraction macros to %syJrnRecord
#;HYY1981  1/23/15 Huayong Yang, add DEJRNGETSFNUPD
#;HYY1954  9/30/14 Huayong Yang, add JRNMIRDBNAME
#;HYY1942  8/28/14 Huayong Yang, add DEJRNINICHKPNTADDR
#;JO2769   7/14/14 Jeffrey Orlin, add MIRDBINFODEJRNTARG[JRNOFF,MIRFILECNT] values 
#;JO2721   1/17/14 Jeffrey Orlin, update $$$ISCLUSYS so it resolves to a boolean value
#;HYY1899  1/07/14 Huayong Yang, add DEJRNSHAREALLOCMAX
#;STC2253 10/13/13 Steve Clay, Move Globals implementation
#;SML1771  9/18/13 Simon Li, Support converting shadow DB to mirrored DB.
#;SML1748  8/02/13 Simon Li, Detect failure when mirror configuration needs to be rebuilt during mirroring startup.
#;SML1628 12/20/12 Simon Li, Fix missing mirror log while journal switching might not create correct log file.
#;SML1599 11/21/12 Simon Li, Add checksum in mirror journal log file and rebuild it if corruption is detected.
#;HYY1802 10/10/12 Huayong Yang, pass #pages, not #bytes, to $zu(78,50)
#;HYY1775 07/02/12 Huayong Yang, add JRNCURNAMCAN and update JRNCURIOINC
#;HYY1771 06/28/12 Huayong Yang, extend DEJRNQUECHKPNT for mid-file checkpoint
#;HYY1762 06/05/12 Huayong Yang, add macros for errors in jornal restore
#;JO2489  12/23/11 Jeffrey Orlin, add MIBJRNOFFOLD, MIBJRNMIRFILECNTOLD and
#;				   MIBCREATEDNEWBit (for MIB_CREATEDNEW)
#;HYY1718 12/22/11 Huayong Yang, add JRNSCANSETUP
#;HYY1715 12/06/11 Huayong Yang, add JRNRAWDIRSFN
#;HYY1682 09/05/11 Huayong Yang, rename PPG to conform to naming convention
#;JO2465   8/30/11 Jeffrey Orlin add JRNSWREASONMissingFile
#;JO2459   8/19/11 Jeffrey Orlin, add GET/SETJRNPREFIX for $ZU(78,93,<prefix string>)
#;HYY1671 08/09/11 Huayong Yang, add macros for option to disable journaling
#;HYY1641 08/03/11 Huayong Yang, add DEJRNCHKSURREQ
#;JO2429   6/29/11 Jeffrey Orlin, remove MIRDBINFOJRNGUID field
#;GK938	  06/24/11 Garen Kotikian, added JRNTROLEVEL
#;HYY1650 04/21/11 Huayong Yang, add DEJRNGETSFNSKIP
#;JO2430   4/04/11 Jeffrey Orlin, move LifeSpan here from JRNUTIL.mac and
#;                 rename it to JrnHistoryLifeSpan
#;SML1287  1/04/11 Simon Li, Handle JRNMIRSET and JRNKIRKILL journal records.
#;HYY1600 12/09/10 Huayong Yang, add JRNPIDREAL and JRNECPSYS
#;HYY1584 07/31/10 Huayong Yang, add private globals for purged mirror files
#;HYY1548 04/12/10 Huayong Yang, add TRANSFILECNTONDISK
#;HYY1504 12/11/09 Huayong Yang, add JRNCHECKENC
#;JO2141  10/24/09 Jeffrey Orlin, add jrnswitch reason codes for mirroring.
#;		   		   add JrnHdrFILECNT. Add MIRDBINFO field definitions for 
#;                 taking apart the return  value of SYSTEM.MIRROR.DBGetInfo.
#;		   		   Add $$$IsMirrorJournalFile(). Add definitions for new
#;                 new journal info codes.
#;HYY1509 06/11/09 Huayong Yang, add macros for journal log operations
#;HYY1425 12/12/08 Remove use of source database index (srcidx)
#;HYY1360 04/30/08 Huayong Yang, extra parameter of $zu(78,46)
#;JO2192  11/02/07 Jeffrey Orlin, definitions for $ZU(78,20,csn) (JRNLOOKUP) 
#;                 and $ZU(78,21) (JRNINDEX)
#;HYY1352 10/11/07 Huayong Yang, a macro to roll journaling to next file
#;JO2188   9/17/07 Jeffrey Orlin, JRNPID documentation changes
#;HYY1344 09/13/07 Huayong Yang, add macros related to $zu(78,22,file,99)
#;HYY1324 06/07/07 Huayong Yang, add DEJRNSETCURADDR
#;HYY1317 05/10/07 Huayong Yang, clean up UNLOCKROLLBACK and OPENJRNTOROLLBACK
#;HYY1078 10/04/06 Huayong Yang, revised behavior of journaling
#;HYY1255 ;08/31/06 Huayong Yang, add DEJRNSET/GETTMPNODE
#;HYY1212 ;07/21/06 Huayong Yang, allow one queue with multiple prefetchers
#;RJW1293 ;05/01/06 Ron Watt, Remove obsolete $zu(78,43) and $zu(78,44)
#;HYY1220 ;04/19/6 Huayong Yang, remove single-threading TROLLBACK
#;HYY1200 ;01/24/6 Huayong Yang, add journal encryption macros
#;HYY1176 ;10/27/5 Huayong Yang, journal $INCR differently from SET
#;HYY1163 ;09/29/5 Huayong Yang, add GLONAM and DIRGLO
#;HYY1142 ;08/15/5 Huayong Yang, add/edit DEJRN* macros based on $zu(78,53)
#;HYY1119 ;06/28/5 Huayong Yang, define internal types of journal markers
#;HYY1091 ;05/05/5 Huayong Yang, add reasons for jrnswitch
#;HYY995 ;12/23/04 Huayong Yang, add DEJRNCLEANJOB, DEJRNREAD, DEJRNGETRECAT
#;HYY994 ;10/05/04 Huayong Yang, add DEJRNSETBRK, DEJRNCLRBRK, & DEJRNGETBRK
#;HYY975 ;08/18/04 Huayong Yang, add JRNFNEXT
#;HYY943 ;07/02/04 Huayong Yang, split CreateGloIfNewAndCol... into two
#;HYY942 ;06/30/04 Huayong Yang, add DEJRNGETSEQ and DEJRNSETSEQ
#;HYY941 ;06/27/04 Huayong Yang, add DEJRNGETNXTREC
#;HYY940 ;06/27/04 Huayong Yang, simplify macro DEJRNGETREC
#;HYY866 ;02/05/04 Huayong Yang, support collation for compatible mode shadowing
#;SML378 ;10/30/03 Simon Li, Support 'Nested' transaction with USENESTEDTRANS.
#;HYY824 ;10/24/03 Huayong Yang, define JRNENDSET
#;HYY803 ;09/04/03 Huayong Yang, use correct delimiter in dealing with JRNSTATUS
#;STC471 ;08/19/03 Steve Clay, Rename to %syJrninc
#;JO1728 ;07/07/03 Jeffrey Orlin, add CLUJRNMARKLOG macro
#;HYY700 ;03/20/03 Huayong Yang, fast dejournaling
#;HYY681 ;08/09/02 Huayong Yang, add macros for (new) fields of $zu(78,22)
#;PWC640 ;06/13/02 Peter Cudhea-Pierce, journal files in infinite sequence for
#; ;         ECP recovery.
#;PWC637 ;05/22/02 Peter Cudhea-Pierce, add JRNBIGNET, cleaned journal type
#; ;         definitions. 
#;HYY627 ;05/13/02 Huayong Yang, add JRNBLKSIZ
#;HYY605 ;05/09/02 Huayong Yang, another macro related to clujrnseq
#;HYY623 ;05/07/02 Huayong Yang, make ISCLUSYS more robust
#;HYY617 ;05/02/02 Huayong Yang, macros for single/multi-threading TROLLBACKs
#;HYY616 ;04/30/02 Huayong Yang, macros for atomic compare and set/kill
#;HYY611 ;04/25/02 Huayong Yang, macro to force TCOMMIT into journal
#;HYY609 ;04/12/02 Huayong Yang, macros to enable/disable journaling on the fly
#;HYY600 ;04/01/02 Huayong Yang, macros related to clujrnseq 
#;HYY601 ;03/27/02 Huayong Yang, add ISCLUSYS
#;HYY591 ;03/01/02 Huayong Yang, add CLUPIJDIR and CLUJRNLOG
#;HYY551 ;11/19/01 Huayong Yang, add JRNCURIOINC, a wrapper for $ZU(78,40)
#;SJ1303 ;08/20/01 Scott Jones, added JRNOLDBITLEN
#;HYY530 ;08/13/01 Huayong Yang, add macro GNEW and CreateGloIfNewAndCol...
#;SJ1300 ;07/04/01 Scott Jones, added JRNOLDBITVAL
#;RAM990 ;05/21/01 Rick Miller, add JRNBITSET and JRNNBITSET types for atomic
#; ;               Set $BIT.
#;HYY408 ;07/25/00 Huayong Yang, add JRNMARK type
#;APJ922 ;05/10/00 Phil Johnson, Fix ControlPanel global protection bug,
#; ;         clean out old change marks
#;HYY379 ;11/05/99 Huayong Yang, added JRNTHRHD
#;HYY339 ;08/20/99 Huayong Yang, added GLOPURGE
#;HYY291 ;03/25/99 Huayong Yang, added JRNTYPEMIN and JRNTYPEMAX
#;STC200 ;02/26/99 Steve Clay, Removed Site Is macro
#;HYY228 ;12/14/98 Huayong Yang, enhancement to shadowing
#;HYY194 ;08/20/98 Huayong Yang, add a macro
#;HYY166 ;04/13/98 Huayong Yang, added some new journaling $zu(78) functions
#;JAO974 ;10/28/97 Jeffrey Orlin, added some new journaling $ZU(78) functions
#;HYY062 ;03/19/97 Huayong Yang, updated JRNSWTCH and defined JRNSWTCHQ
#;HYY051 ;02/25/97 Huayong Yang, define JRNMAXSIZE()
#;HYY024 ;01/08/97 Huayong Yang, define NONAUTJRNROL
#;HYY021 ;01/03/97 Huayong Yang, support for new journalling scheme
#;LFT379 ;07/08/96 Laura Tillem, define $$$JRNCOLLATE for collation type
#;JAO838 ;02/27/96 Jeffrey Orlin, support for network transaction processing
#; ;         and for journaling zkills and (for clusters) remote zkills
#;LRS105 ;12/01/95 Lee Smith, define $$$JRNTSTAMP for record timestamp
#;JAO789 ;05/31/95 Jeffrey Orlin, $ZU(78,2) (JRNSTOP) extended to specify
#;         the flag that says stop regardless of whether journaling
#;         is suspended/paused/etc... If this is omitted or specified
#;         as 0 then if $ZU(78,2) will fail if journaling is suspended,
#;         paused or if there is a journal I/O error retry in prog.
#;AN144 ;03/10/95 Jeffrey Orlin. Make this work on the VAX where we don't
#;         have long strings but we do use the journal record types
#;         that log strings uses
#;DPB124 ;06/03/93 Dan Smith, SPJ891 now conditionalized on
#;         $$$NOLONGSTRINGS in %system.inc
#;SPJ891 ;06/03/93 Scott Jones, changes to handle very long strings
#;ZSH003 ;04/06/93 Zahra Sharifnia: defined JRNCHECK(file) to check if
#;        file is a valid journal file
#;BEB507 ;02/15/93 Ben Bishop: defined JRNSWTCH(newfile,size,expandby)
#;         to be used for non-vax platforms
#;JAO498 ;06/01/92 Jeffrey Orlin. Extend JRNSTART() to take two new
#;         parameters: the initial journal file size and the
#;         expansion quantity
#;		/*=====================End Maintenance======================*/
 
#include %syJrnRecord
#include %sySystem     ;need to know if we have NOLONGSTRINGS
 
 ;HYY024: NONAUTJRNROL=1 means using old journal scheme
#define NONAUTJRNROL 0 
 
 ; $$$JRNCUR returns: address,dir
 ; where: address = the journal address at the end of the journal
 ;          (i.e. the next available space).  An attempt to read
 ;          $$$JRNTYPE on that address returns $$$JRNEND
 ;        dir = the directory name of the journal for our system
#define  JRNCUR $zu(78,4)_","_$zu(78,3)
								#;HYY1078+
 ; $$$JRNSTATUS returns  enabled^paused^suspended^fail^frozen^type
 ; where:    enabled = 1/0 if journal I/O is currently enabled
								#;HYY1078-
 ;            paused = 1/0 if journaling currently paused
 ;         suspended = 1/0 if journaling currently suspended
 #;HYY681+
 ;              fail = 1/0 if journaling is running into I/O error
 ;            frozen = 1/0 if journaling is frozen (updates are blocked)
 #;HYY681-
								#;HYY1078+
 ;              type = 1/0 if database updates are currently journaled
								#;HYY1078-
#define  JRNSTATUS $zu(78,22)
#;HYY681+, HYY803 (replace "," with "^" in the following macros)
#define ISJRNENABLED   $p($$$JRNSTATUS,"^")
#define ISJRNPAUSED    $p($$$JRNSTATUS,"^",2)
#define ISJRNSUSPENDED $p($$$JRNSTATUS,"^",3)
#define ISJRNIOERR     $p($$$JRNSTATUS,"^",4)
#define ISJRNFROZEN    $p($$$JRNSTATUS,"^",5)
								#;HYY1078+
	#; Is journaling in a troubled state, i.e., disabled due to I/O error?
	#; It is independent of the status of the failed I/O operation --
	#; if $$$JRNWRTON is 1, the failed I/O operation is still being
	#; retried; otherwise, it has been either retried successfully or
	#; discarded (e.g., by ^JRNSTOP).
#define	ISJRNTROUBLED  $$$ISJRNSUSPENDED
#define ISJRNRETRYIO   ($$$ISJRNWRTON&&$$$ISJRNTROUBLED)
	#; NB: We probably should swap the two fields for ISJRNWRTON and 
	#; ISJRNUPDON in $zu(78,22).
	#; Is journal I/O still active currently?
	#; Even if journaling of database updates is disabled, journal I/O
	#; may be still active briefly (in jrnstop) or for a while (when
	#; retrying a failed I/O operation after journaling is disabled).
#define ISJRNWRTON     $$$ISJRNENABLED
	#; Is journaling of database updates enabled (system wide)?
#define ISJRNUPDON     $p($$$JRNSTATUS,"^",6)
								#;HYY1078-
#;HYY681-
 
 ; $$$JRNCHECK(%f)  returns 1 if file %f is a valid journal file
 ;                  returns 0 otherwise
#define  JRNCHECK(%f)  $ZU(78,22,%f)
 
 ; $$$JRNINDEX returns: address,dir
 ; where: address = the journal address at the last checkpoint as
 ;          stored in the IMJ and dir is the filename stored in the IMJ
 ;      or 0,""
#define  JRNINDEX $zu(78,21)
#;
#;JO2192+ 
 ; The following define the pieces in the string returned by
 ; $$$JRNINDEX, $ZU(78,21). This is information from shared memory
 ; of this system. The JI* and JL* values are the same
 ; except JRNLOOK includes the mgdir of the cluster member.
#define JIJRNOFF       1
#define JIJRNFILENAME  2
#define JIJRNFILECNT   3
#define JITRANSFILECNT 4
#define JITRANSINDEX   5
#define JIJRNWDPASS    6
#define JIPREVJRNOFF   7
#define JIPREVJRNFILECNT  8
#;JO2192-
								#;HYY1548+
 ; The minxfilecnt value that has been written to disk (WIJ)
#define TRANSFILECNTONDISK $zu(78,21,1)
								#;HYY1548-
 ; IMJRNTHRHD is about how often we update the open transaction index in image
 ; journal (as reported by $zu(78,21)). The index is updated once the size
 ; of a journal has grown by a certain amount (threshold) or more. 
 ; SETIMJRNTHRHD sets the threshold to the given value (in bytes) and returns 
 ; the old threshold value whereas GETIMJRNTHRHD returns the current value.
#define SETIMJRNTHRHD(%a) $zu(78,21,0,%a)
#define GETIMJRNTHRHD $zu(78,21,0)
 
#if $$$NONETTRANSPROC
 ; $$$JRNLOOKUP(csn) returns:    address,dir
 ;   where: csn = cluster system number
 ;          address = the journal address stored in its .IMJ
 ;          dir = the directory name where the journal for that
 ;               cluster system is located
#else                 ;JAO838=, JO2192+
 ; $$$JRNLOOKUP(csn) returns information from the WIJ header of
 ;    the specified cluster member. The string is a comma delimited
 ;    string with the pieces defined by the JL_* constants below.
#endif                ;JAO838-, JO2192-
 ;   it returns a null string if there is no system with that csn
#define  JRNLOOKUP(%a) $zu(78,20,%a)
#;HYY591+
#define CLUPIJDIR $s($$$SYSUSECLUSTER:$p($zu(78,20),","),1:"")
#define CLUJRNLOG $s($$$SYSUSECLUSTER:$p($zu(78,20),",",2),1:"")
#;HYY601+,HYY623+ $zu(59,0) returns ENQDMNpid,enqcsn,etc.
#; JO2721 ISCLUSYS should return 0/1 for is/isn't a cluster member
#define ISCLUSYS $s($$$SYSUSECLUSTER:''$zu(59,0),1:0)
#;HYY601-,HYY623-
#;HYY591-
#;JO1728+
#define CLUJRNMARKLOG $s($$$SYSUSECLUSTER:$p($zu(78,20),",",3),1:"")
#;JO1728-
#;JO2192+ 
 ; The following define the pieces in the string returned by
 ; $$$JRNLOOKUP, $ZU(78,20,csn). This is information from the WIJ of
 ; the specified cluster member. 
#define JLJRNOFF       $$$JIJRNOFF
#define JLJRNFILENAME  $$$JIJRNFILENAME
#define JLJRNFILECNT   $$$JIJRNFILECNT
#define JLTRANSFILECNT $$$JITRANSFILECNT
#define JLTRANSINDEX   $$$JITRANSINDEX
#define JLJRNWDPASS    $$$JIJRNWDPASS
#define JLPREVJRNOFF   $$$JIPREVJRNOFF
#define JLPREVJRNFILECNT  $$$JIPREVJRNFILECNT
#define JLMGRDIR       9
#;JO2192-
 ; $$$JRNOPEN(directory name,buff)
 ;     opens a channel to that journal
 ;     and returns an arbitrary channel number by which $$$JRNUSE
 ;     and $$$JRNCLOSE refer to it
 ;  buff = 1 if we use the special system buffer; 0 => allocate
 ;          buddy block space
 ;  -1 => error
#define  JRNOPEN(%a,%b) $zu(78,5,%a,%b)
#;HYY700+
#define  JRNOPENSHR(%a,%b,%s) $zu(78,5,%a,%b,%s)
#;HYY700-
								#;HYY1142+
#define  JRNOPENSHRCSN(%jrnf,%buf,%shid,%csn) $zu(78,5,%jrnf,%buf,%shid,%csn)
								#;HYY1142-
 
 ; $$$JRNUSE(channel)  use the specified channel for future references
#define  JRNUSE(%a) $zu(78,6,%a)
 
 ; $$$JRNCLOSE(channel) close the specified channel
#define  JRNCLOSE(%a) $zu(78,7,%a)
 
 ; $$$JRNSTOP
 ; disable journaling
#define  JRNSTOP $zu(78,2,1)
 
 ; $$$JRNSTART(file,curdir,maxsize,inisize,expqty,altdir)
 ; start journaling, where:
 ;     file = journal file name (without path)
 ;     curdir = directory into which file is written
 ;     maxsize = max journal file size
 ;     inisize = initial size (in bytes) of journal file (ignored
 ;           if we don't create a new file)
 ;     expqty = expansion size in bytes of journal file
 ;     altdir = directory into which file is written if curdir is full
 ;     prevfilnam = previous journal file name
 ;     prevfilcnt = jrnfilecnt of previous journal file name
 ;     NOTE: Both the initial size and the expansion size are rounded
 ;           DOWN to the nearest I/O boundary
 ; return: 1 => success, 0 => failure
								#;PWC640+
#define  JRNSTART(%a,%b,%c,%d,%e,%f,%g,%h) $zu(78,0,%a,%b,%c,%d,%e,%f,%g,%h)
								#;PWC640-
								#;HYY1352+
 ; $$$JrnRollToNextFile(Reason): simply roll journaling to next file with NO
 ; journal property change to activate. It makes most of the following journal 
 ; switch macros obsolete, e.g., JRNSWTCHQ, JRNSWITCH, etc.
 ; To activate changes to one or more journal properties (directories,
 ; maxsize, etc.), use $$$JRNSWTCH(...), the full version of journal switch.
#define JrnRollToNextFile(%reason) $zu(78,72,%reason)
								#;HYY1352-
 ; $$$JRNSWTCHQ: (simple) switch in the same directory
								#;HYY1091+
 ; currently this is used by journal restore (and record-mode shadow)
#define  JRNSWTCHQ $$$JRNSWITCHBYRESTORE
								#;HYY1091-
 ; $$$JRNSWTCHC(curdir,altdir): current effect of $$$JRNSWTCH
 ;       see below
#define  JRNSWTCHC(%a,%b) $zu(78,1,%a,%b)
 ;
 ; $$$JRNSWTCH(curdir,altdir,initial size,expansion qty)
 ;     curdir = directory where journal files go to
 ;     altdir = alternate directory for journal files if curdir is full
 ;       if either one is "", current setting is used for that item.
 ;     initial size = initial size (in bytes) of journal file (ignored
 ;           if we don't create a new file)
 ;     expansion size in bytes of journal file
 ;     NOTE: Both the initial size and the expansion size are rounded
 ;           DOWN to the nearest I/O boundary
 ; return: 1 => success, 0 => failure
								#;HYY1091+
#define JRNSWTCH(%a,%b,%c,%d,%reason) $zu(78,1,%a,%b,%c,%d,%reason)
#define JRNSWITCH(%reason) $$INT^JRNSWTCH(,,,,,,,%reason)
 ; INT^JRNSWTCH() with parameters other than reason will be phased out
 ; current parameters are:
 ;   curdir,altdir,err,io,maxsiz,jrnall,chkshdw,reason
#define JRNSWITCH3(%curdir,%altdir,%err,%reason) $$INT^JRNSWTCH(%curdir,%altdir,%err,/*io*/,/*maxsiz*/,/*jrnall*/,/*chkshdw*/,%reason)
								#;HYY1091-
 
								#;HYY1718+ 
 ; $$$JRNSCANSET(jobid,sysid)
 ; Set up a scan for records in a given transactions, identified by jobid
 ; and sysid. Subsequent $zu(78,18,address) calls skip to the next record
 ; in that transaction after 'address'. The record @ 'address' is irrelevant.
#define  JRNSCANSET(%job,%sys) $zu(78,78,%job,%sys)
								#;HYY1718- 
#;HYY824+
 ; $$$JRNENDSET(address)
 ; Set jrnend (the one $$$JRNPREV(0) returns) to the given journal address.
 ; Mainly used by block-mode shadowing, where the copier passes end-of-block
 ; or $$$JRNPREV(0) info to the dejournaler to prevent the latter from
 ; reading blocks that the copier may be still modifying. As an additional 
 ; benefit, the dejournaler also avoids some I/O accesses to get jrnend.
 ; 
 ; $$$JRNENDSET(0) will clear the mark that says the end of the journal
 ; is valid which allow $$$JRNPREV(0) to re-calculate the end of the journal
 ; if new records are added [JO2141]
#define JRNENDSET(%addr)	$zu(78,59,%addr)
#;HYY824-
  
 ; $$$JRNFPREV(file)
 ; Returns prior journal file from which file is switched
#define JRNFPREV(%a) $P($zu(78,22,%a,1),",",2) 
								#;HYY1091+
 ; $$$JRNSWREASON(file)
 ; Returns reason for switching to 'file'
#define JRNSWREASON(%a) $P($zu(78,22,%a,1),",",3) 
								#;HYY1091-
								#;HYY975+
#define JRNFNEXT(%a) $P($zu(78,22,%a,2),",",2) 
								#;HYY975-
#define JRNMAXSIZE(%a) $P($ZU(78,22,%a,3),",",2)
								#;HYY1504+
#define JRNCHECKENC(%f)	$zu(78,22,%f,5)
								#;HYY1200+
#define JRNENCKEYIDLEN(%f)	$p($$$JRNCHECKENC(%f),",",2)
								#;HYY1200-
								#;HYY1504-
								#;HYY1344+
  #; JRNHDRALL(%f) returns a comma-delimited string, lead by the state value
  #; of the file (consistent with what $zu(78,22,%f) returns), followed by
  #; the fields as defined by the macros below. Note that you should add 1
  #; to the fields #'s defined below, to take into account the state value
  #; field. The macros should be maintained in according with journal.c,
  #; that is, JrnHdrXXX here == JRNHDR_XXX in journal.c
#define	JRNHDRALL(%f)		$zu(78,22,%f,99)
#define JrnHdrPREVJRN  		 1
#define JrnHdrNEXTJRN  		 2
#define JrnHdrMAXSIZ   		 3
#define JrnHdrTIMECREATED 	 4
#define JrnHdrENCKEYIDLEN 	 5
#define JrnHdrPREVGUID 		 6
#define JrnHdrTHISGUID 		 7
#define JrnHdrNEXTGUID 		 8
#define JrnHdrJRNCNT   		 9
#define JrnHdrCURREND 		10
#define JrnHdrPREVEND 		11
#;JO2141+
#define JrnHdrFILECNT       12
#define JrnHdrMIRFILECNT    13
#define JrnHdrSYSGUID 		14
#define JrnHdrMIRGUID 		15
#define JrnHdrMIREND        16
#define JrnHdrSESSGUID 		17
  #; JrnHdrMINTRANSFILECNT is the local (not mirror) journal
  #; file count for the file which contains JrnHdrMINTRANSINDEX
#define JrnHdrMINTRANSFILECNT 18
#define JrnHdrMINTRANSINDEX 19
  #; JrnHdrMINMIRTRANSFILECNT returns the same file count as
  #; JrnHdrMINTRANSFILECNT however it convets it to a mirror 
  #; journal file # using the MIRFILECNT, 1stMIRFILECNT & FILECNT 
  #; in the journal header. We could do this in COS but its easier 
  #; to have a function to get it.
#define JrnHdrMINMIRTRANSFILECNT 20
  #; JrnHdrMINMIRTRANSINDEX should be used when the file count from
  #; JrnHdrMINMIRTRANSFILECNT is used. The index is generally the same
  #; as JrnHdrMINTRANSINDEX unless the file count preceeds the 1st
  #; file created by the associated primary in which case MINMIRTRANSFILECNT
  #; is the 1st file created by that primary and MINMIRTRANSINDEX is the
  #; start of that file.
#define JrnHdrMINMIRTRANSINDEX 21
#;JO2141-
								#;HYY2074+
  #; $zu(78,22,jrnf,$$$JrnHdrOLDNEWOFFSETS) returns 22,newoffset,oldoffset;
  #; whereas $p($zu(78,22,jrnf,99),",",$$$JrnHdrOLDNEWOFFSETS+1) returns 
  #; newoffset:oldoffset (note the different delimiter).
  #; newoffset is an offset in 'jrnf', whereas oldoffset is its corresponding
  #; offset in the previous file. In other words, data at newoffset in 'jrnf'
  #; would have been written at oldoffset in the previous file had there not
  #; been a journal switch. Therefore, data at an offset 'off' in the
  #; previous file is expected to be found at (off-oldoffset+newoffset) in
  #; 'jrnf' if 'off' >= the end of the previous file.
#define JrnHdrOLDNEWOFFSETS 22
								#;HYY2074-
#;SML1748+
#; Return encryption key ID in the journal file.
#define JrnHdrENCKEYID 	 23
#define JRNENCKEYID(%f)	$p($zu(78,22,%f,$$$JrnHdrENCKEYID),",",2)
#; Encryption block size for journal.
#define	JRNENCBLKSIZ	2048
#;SML1748-
  #; This serves as an example of retrieving a field from journal header.
  #; Normally, you should save $$$JRNHDRALL(%f) to a local variable, test
  #; its state value and stop if it is nonpositive (see JRNCHECK); otherwise,
  #; retrieve whatever fields you are intrested in via the macros above.
#define	GetJrnHdrField(%f,%i)	$p($$$JRNHDRALL(%f),",",%i+1)
								#;HYY1344-
 
 ; $$$JRNCURFILECNT
 ; Returns the current "journal file counter" value. This value is used in
 ; conjunction with remote transaction rollback to detect whether the journal
 ; file that's currently active is the same as the one our transaction was
 ; started in
#define  JRNCURFILECNT $ZU(78,26)
 
#define JRNCURNAM   $zu(78,3)
								#;HYY1775+
 ; $$$JRNCURNAMCAN
 ; Returns the current journal file path in "canonical" form a la $zu(12), 
 ; which is NOT case-preserving on Windows/VMS. Good for comparison purpose.
#define JRNCURNAMCAN   $zu(12,$zu(78,3))
								#;HYY1775-
#define JRNFLUSHBUF     $zu(78,29)
 ; returns dirblkver^dirblknum (of journal file being used or current)
#define JRNDIRINFO   $zu(78,28)
         
 ; $$$JRNDELETE(address)
 ; Marks the record at that address as deleted
#define  JRNDELETE(%a) $zu(78,19,%a)
 
 ; $$$JRNHDRINFO(item)
 ; Returns information from the journal header. Item values are:
 ;   1 - Cluster mstart timestamp (0 for non-USECLUSTER systems)
#define  JRNHDRINFO(%item) $ZU(78,30,%item)
 
 ; $$$JRNDIRLOOKUP(sfn)
 ; Returns the directory spec for the specified sfn or NULL if there
 ; is none
#define JRNDIRLOOKUP(%sfn) $ZU(78,31,%sfn)
 
#;HYY551+
 ; $$$JRNCURIOINC(jrnf)
 ; Returns the 0-based offset of the first byte of current journal not on disk
 								#;HYY1775+
 ; assuming jrnf (or %f) is "canonical" (NOT case-preserving on Windows/VMS)
#define JRNCURIOINC(%f) ($ZU(78,40)*(%f=$$$JRNCURNAMCAN))
 								#;HYY1775-
#;HYY551-
 
#;HYY600+
 ; $$$GETJRNCLUSEQLOCAL, get local copy of cluster journal sequence #
 ; $$$SETJRNCLUSEQLOCAL(n), set local copy of cluster journal sequence # to n
 ; $$$GETJRNCLUSEQMASTER, get master copy of cluster journal sequence #
 ; $$$SETJRNCLUSEQOTHER(n), set cluster journal sequence # on other members to 
#define GETJRNCLUSEQLOCAL	$zu(78,41,0)
#define SETJRNCLUSEQLOCAL(%n)	$zu(78,41,0,%n)
#define GETJRNCLUSEQMASTER	$zu(78,41,1)
#define SETJRNCLUSEQOTHER(%n)	$zu(78,41,2,%n)
#;HYY600-
#;HYY605+
 ; $$$GETJRNCLUSEQMAX(n), get max of n and all cluster journal sequence #'s  
#define GETJRNCLUSEQMAX(%n)	$zu(78,41,3,%n)
#;HYY605-
 
#;HYY611+
 ; (privileged jobs only) journal TCOMMIT at failover on behalf of other jobs
#define JRNTCOMMIT	$zu(34,4)
#define JRNUSEPIDSYS(%p,%s)	$zu(34,9,%p,%s)
#define JRNTCOMMITPIDSYS(%p,%s)	($$$JRNUSEPIDSYS(%p,%s)!$$$JRNTCOMMIT!$$$JRNUSEPIDSYS(0,0))
#;HYY611-
 
#;HYY408+
 ; $$$SETJRNMARKLOC: Set a journal marker locally
 ; Input - %id: marker ID; %msg: marker text
 ; Output - retcode[,jrnoff,jrnfilenam]
 ;   retcode: 1 (success) or <=0 (error code)
 ;   jrnoff and jrnfilenam: location of the marker if successfully set
#define SETJRNMARKLOC(%id,%msg) $ZU(78,34,0,%id,%msg)
 ; $$$GETJRNMARK(addr): Returns the info about the marker at the given address
#define GETJRNMARK(%a) $ZU(78,35,%a)
 ; %info: result from $$$GETJRNMARK
 ; $$$GETJRNMARKPREV(%info): address of previous marker
 ; $$$GETJRNMARKSEQ(%info): sequence number of current marker
 ; $$$GETJRNMARKID(%info): current marker ID
 ; $$$GETJRNMARKTEXT(%info): current marker text
#define GETJRNMARKPREV(%info) $p(%info,",")
#define GETJRNMARKSEQ(%info) $p(%info,",",2)
#define GETJRNMARKID(%info) $p(%info,",",3)
#define GETJRNMARKTEXT(%info) $p(%info,",",4,$l(%info))
 
 ;Journal Marker Service Codes (JMSC)
 ;JMSCINIT: initial code to establish a connection with journal marker server
#define JMSCINIT "JMK"
 ;JMSCQUIT: end of session (OK for server to quit)
#define JMSCQUIT 0
 ;JMSCJRSW: switch journal file
#define JMSCJRSW 1
 ;JMSCSTMK: set journal marker
#define JMSCSTMK 2
#;HYY408-
#;JO2459+
#;  $ZU(78,93,str) loads 'str' into memory as the new journal file prefix whic
#;  takes effect @ the next jrnswitch. Generates a <FUNCTION> error if the 
#;  prefix is too long when combined with either the primary or alternate
#;  directory. $ZU(77,92) without a 3rd argument returns the current value
#;  of jrnmast.jrnprefix.
#define GETJRNPREFIX $ZU(78,93)
#define SETJRNPREFIX(%str) $ZU(78,93,%str)
#;JO2459-
#;PWC637+
#define	GETREQTRANSINFO(%addr) $zu(78,45,%addr)
#define	GETREQTRANSNUM(%info) (%info)
#;PWC637-
#;SML378+
#define	GETTRANSLEVEL(%addr) $zu(78,60,%addr)
#define WRITEROLLBCOMMIT(%l) $zu(34,17,%l)
#define UPDATETLEVEL(%l) $zu(34,18,%l)
#;SML378-
  
         ; MAXCLUMEM is defined by the system code
#define MAXCLUMEM 14
 
#; $zu(154[,nam,dir,blk]) makes any process accessing the global next time
#; reread the global from the disk rather than its cache.  Useful when the
#; journaling state of a global has been changed and we want all existing
#; processes to see the change.  $zu(154) purges current global vector from
#; the cache.  $zu(154,nam,dir,blk) requires a global name (w/o leading
#; "^"), a directory name (with leading "^^"), and its top pointer block #
#; to purge an arbitrary global.
								#;APJ922+
#define GLOPURGE(%nam,%dir,%blk) $zu(154,%nam,"^^"_%dir,%blk)
								#;APJ922-
 
#define	JRNWITHLEVEL(%t) ((%t'<$$$JRNTBEGINLEVEL)&&(%t'>$$$JRNTCOMMITLEVEL))
 
#define TMPJRNGLO ^%SYS("TMPJRN")
#;HYY408+
#define DJSTARTLOC(%x) "offset "_+%x_" in "_$p(%x,",",2)
#;HYY408-
   
#;HYY530+
								#;HYY1163+
 ; $$$GLONAM extracts global name (excl. directory) from global node reference
 ; %gref: extended global reference (with optional subscripts)
 ; NB: $qs(%gref,0) returns global name with a leading "^". To remove the "^",
 ; $e($qs(%gref,0),2,32) is slightly faster than $p($p(%gref,"""]",2),"("),
 ; which is slightly faster than $e($qs(newref,0),2,512). If MAXGLONM=31, 32
 ; should suffice, but it is worrisome using a hard-coded # right on the limit.
 ; The problem with $p($p(%gref,"""]",2),"(") is that "] is a valid string in
 ; a Unix directory name.
#define GLONAM(%gref) $e($qs(%gref,0),2,512)
 ; $$$DIRGLO extracts global name (incl. directory) from global node reference
 ; NB: The equivalent $name(@%gref,0) is slower, probably due to indirection.
 ; %dir: database that hosts the global node %gref (with optional prefix "^^")
 ; %gref: extended global reference (with optional subscripts)
#define DIRGLO(%gref,%dir) $p(%gref,"(",1,$l(%dir,"("))
								#;HYY1163-
 ; $$$GNEW detects whether the global associated with the given node %g is new
 ; %d: database that hosts the global node %g (with optional prefix "^^")
 ; %g: extended global reference (with optional subscripts)
#define GNEW(%d,%g) ('$d(@($p(%g,"(",1,$l(%d,"(")))))
 ; Create a global with its own collation if it doesn't exist (i.e., new) AND 
 ; its collation is different from that of the host database
 ; %dir: host database name (without prefix "^^")
 ; %glo: extended global reference (with optional subscripts)
 ; %col: collation of the global (as stored in the journal record)
 ; %dbcol: an array of the collations of the databases involved
 ; %addr: address of the journal record
#define CreateGloIfNewAndColDiffFromDB(%dir,%glo,%col,%dbcol,%addr) s %col=$$$JRNCOLLATE(%addr) i %col'=%dbcol(%dir),$$$GNEW(%dir,%glo),$zu(178,"^^"_%dir,$qs(%glo,0),%col)
 ; Same as above except that %ns is a directory name with prefix "^^"
#define CreateGloIfNewAndColDiffFromNS(%ns,%glo,%col,%dbcol,%addr) s %col=$$$JRNCOLLATE(%addr) i %col'=%dbcol(%ns),$$$GNEW(%ns,%glo),$zu(178,%ns,$qs(%glo,0),%col)
								#;HYY866+
 ; same as above except that %col is given
#define CreateGloIfNewAndColDiffFromNS0(%ns,%glo,%col,%dbcol) i %col'=%dbcol(%ns),$$$GNEW(%ns,%glo),$zu(178,%ns,$qs(%glo,0),%col)
								#;HYY866-
								#;HYY943+
#; In IsNewGloOfDiffColFromDB, %ns can be either a directory or namespace name
#define	IsNewGloOfDiffColFromDB(%ns,%glo,%col,%dbcol) (%col'=%dbcol(%ns)&&$$$GNEW(%ns,%glo))
#; In CreateGlo, %ns must be a namespace name
#define	CreateGlo(%glo,%col,%ns) $zu(178,%ns,$qs(%glo,0),%col)
								#;HYY943-
#;HYY530-
  
#;HYY616+
 ; kill global reference %g if its current value is %v
#define GLOCMPANDKILL(%g,%v)	$zu(185,%g,%v)
 ; set global reference %g to %n if its current value is %v
#define GLOCMPANDSET(%g,%v,%n)	$zu(185,%g,%v,%n)
#;HYY616-
  
#;HYY617+
								#;HYY1317+
 ; Must use the same %-variable to coordinate %ROLLBACK and %ROLLBACR
 ; %jrn: journal file to open, %dev: device #
					#;HYY1220+ ;no more single-threading
#define OPENJRNTOROLLBACK(%jrn,%dev) s %dev=$$$JRNOPEN(%jrn,0) 
								#;HYY1220-
								#;HYY1317-
	#;endif
#;HYY617-
  
#;HYY627+
#define JRNBLKSIZ 65536
#;HYY627-
  
#;HYY700+
#define	JRNDIRSFN(%dir)		$zu(78,31,%dir)
								#;HYY1715+
#define	JRNRAWDIRSFN(%dir)	$zu(78,31,%dir,1)
								#;HYY1715-
								#;HYY2028+
#; Given slot#, find the db path or mirror db name in that slot of journal
#; directory block. Note that <sfn>^<mirror db name...> is in slot <sfn+1>. 
#define	JRNRAWDIRLOOKUP(%slot)	$zu(78,31,%slot,1)
#; Given sfn#, find its mirror db name (in form of :mirror:<MIR>:<DB>) if any
#define	JRNMDNLOOKUP(%sfn)	$zu(78,31,%sfn,2)
								#;HYY2034+
#; Given a mirror db name (%mdn), find its sfn in journal directory table.
#; %mdn should have the form of ":mirror:<MIR>:<DB>". NOTE: A trailing ":" 
#; is appeneded to the given mirror db name to ensure name uniqueness.
#define	JRNMIRDBNAMSFN(%mdn)	$zu(78,31,%mdn_":",2)
								#;HYY2034-
#define IsMirrorDBName(%s) ($e(%s,1,8)=":mirror:")
								#;HYY2028-
#define	DEJRNREDIRADD(%srcsfn,%dstsfn,%dstcol) $zu(78,46,%srcsfn,%dstsfn,%dstcol)
								#;HYY941+
#define	DEJRNGETNXTREC(%addr,%next)	$zu(78,47,%addr,%next+1)
								#;HYY941-
								#;HYY940+
#define	DEJRNGETREC(%addr)	$zu(78,47,%addr)
								#;HYY940-
								#;HYY995+
#define	DEJRNGETRECAT(%addr)	$zu(78,47,%addr,%addr)
								#;HYY995-
								#;HYY942+
#define	DEJRNGETSEQ		$zu(78,62)
#define	DEJRNSETSEQ(%seq)	$zu(78,62,%seq)
								#;HYY942-
#define	DEJRNSYNC		$zu(78,49)
								#;HYY955+
#define	DEJRNSYNCSID(%shrid)	$zu(78,49,%shrid)
								#;HYY955-
								#;HYY1802+
#define	DEJRNSHAREALLOC(%q,%qsz,%stk)	$zu(78,50,2,%qsz\65536,%stk\65536)
								#;HYY1802-
#; %flg values:							#;HYY1899+
#;  2 = %qsz and %stk are in #pages (same as 0)
#; +4 = %qsz is also the maximum size
#; +8 = %stk is also the maximum size
								#;HYY1903+
#define	DEJRNSHAREALLOCPAG(%flg,%qsz,%stk) $zu(78,50,%flg,%qsz,%stk)
								#;HYY1903-
								#;HYY1899-
#define DEJRNSHAREFREE(%shr)		$zu(78,52,%shr)
								#;HYY955+
#define	DEJRNCLEANJOB		$zu(78,51,-1,0,-1)
#define	DEJRNREAD(%shr)		$zu(78,51,%shr,0,0)
								#;HYY955-
#define	DEJRNSETKILL(%shr,%que)	$zu(78,51,%shr,%que,1)
#define	DEJRNDBFETCH(%shr,%que)	$zu(78,51,%shr,%que,2)
								#;HYY994+
#define	DEJRNGETBRK(%shr)	$zu(78,53,%shr,0)
#define	DEJRNSETBRK(%shr)	$zu(78,53,%shr,0,1)
#define	DEJRNCLRBRK(%shr)	$zu(78,53,%shr,0,0)
								#;HYY995+
#define	DEJRNSETBRKALL		$zu(78,53,-1,-1,1)
								#;HYY995-
								#;HYY994-
								#;HYY1212+
#define	DEJRNSETNUMPREF(%shr,%num)	$zu(78,70,%shr,%num)
								#;HYY1212-
								#;HYY1255+
#define	DEJRNSETTMPNODE(%shr,%gref)	$zu(78,71,%shr,%gref)
#define	DEJRNGETTMPNODE(%shr)		$zu(78,71,%shr)
								#;HYY1255-
								#;HYY1641+
#define	DEJRNCHKSURREQ(%shr)		$zu(78,97,%shr)
								#;HYY1641-
								#;HYY1324+
  #; update the latest processed address for latency report purpose
#define	DEJRNSETCURADDR(%addr)		$zu(78,54,%addr)
								#;HYY1324-
 								#;HYY1142+
#define	DEJRNSETINILOC(%shr,%csn,%addr,%jrnf) $zu(78,53,%shr,1,%csn,%addr,%jrnf)
#define	DEJRNGETONESTAT(%shr,%csn)	$zu(78,53,%shr,1,%csn)
#define	DEJRNGETSHRSTAT(%shr)		$zu(78,53,%shr,2)
#define	DEJRNGETADDRAPPLIED(%shr)	$zu(78,53,%shr,4)
								#;HYY1360+
#define	DEJRNGETQUEREC(%shr)		$zu(78,53,%shr,8)
								#;HYY1360-
								#;HYY1942+
#; Initialize updater-side dejournaling address (that has been applied)
#define	DEJRNINICHKPNTADDR(%shr,%addr) $zu(78,53,%shr,32,%addr)
								#;HYY1942-
								#;HYY1671+
								#;HYY1771+
#; Specify a journal file path (string) to queue up a new-file checkpoint OR
#; a journal record address (integer) for a mid-file checkpoint.
#define	DEJRNQUECHKPNT(%shr,%pathORaddr)	$zu(78,92,%shr,%pathORaddr) 
								#;HYY1771-
#define	DEJRNSETUPDFLG(%shr)		$zu(78,92,%shr,"") 
								#;HYY1671-
  #; %onestat is the return value of DEJRNGETONESTAT
#define DEJRNSTATJRNF(%onestat)		$p(%onestat,",",1)
#define DEJRNSTATADDRBEG(%onestat)	$p(%onestat,",",2)
#define DEJRNSTATADDRCUR(%onestat)	$p(%onestat,",",3)
#define DEJRNSTATTIMEBEG(%onestat)	$p(%onestat,",",4)
#define DEJRNSTATTIMEEND(%onestat)	$p(%onestat,",",5)
  #; %shrstat is the return value of DEJRNGETSHRSTAT
#define DEJRNSTATSIZECUR(%shrstat)	$p(%shrstat,",",1)
#define DEJRNSTATTIMECUR(%shrstat)	$p(%shrstat,",",2)
#define DEJRNSTATSIZESYN(%shrstat)	$p(%shrstat,",",3)
#define DEJRNSTATTIMESYN(%shrstat)	$p(%shrstat,",",4)
#define DEJRNSTATSIZETOT(%shrstat)	$p(%shrstat,",",5)
#define DEJRNSTATTIMETOT(%shrstat)	$p(%shrstat,",",6)
 								#;HYY1142-
#;HYY700-
								#;HYY1360+
#; cause updates of a certain database (%sfn) to be skipped
#define	DEJRNSETSFNSKIP(%shr,%sfn)	$zu(78,76,%shr,%sfn)
#; clear the sfnskip table and return the old one as a string of 0s and 1s
#define	DEJRNCLRSFNSKIP(%shr)		$zu(78,76,%shr,-1)
								#;HYY1650+
#; return sfnskip table as a string of 0s and 1s without clearing the table
#define	DEJRNGETSFNSKIP(%shr)		$zu(78,76,%shr,-2)
								#;HYY1650-
								#;HYY1981+
#; return sfnupd table as a string of 0s and 1s
#define	DEJRNGETSFNUPD(%shr)		$zu(78,76,%shr,-3)
								#;HYY1981-
								#;HYY1360-
								#;HYY1091+
#; reasons for jrnswitch (or jrnstart with a pointer to prior file)
#; NB: make sure journal.c is in sync with the defintions below
#define JRNSWREASONUNSPECIFIED 0
#define JRNSWREASONUSER        1 
#define JRNSWREASONFILESIZELMT 2 
#define JRNSWREASONIORETRY     3 
#define JRNSWREASONBACKUP      4 
#define JRNSWREASONRESTORE     5 
#define JRNSWREASONTASKMGR     6 
#define JRNSWREASONACTIVATE    7 
#define JRNSWREASONREENABLEJRN 8 
#; ;JO2141+
#; JRNSWREASONPRIMARYMIRRORStart is used when a mirror member switches journal
#; files as part of becoming the primary mirror server. The journal files
#; involved in mirroring all start with the prefix MIRROR-<mirrorname>-
#; to seperate them from journal files created while a system is not a
#; mirror member (startup) or not the primary server.
#define JRNSWREASONPRIMARYMIRRORStart 9
#; JRNSWREASONPRIMARYMIRRORStop is used when the primary mirror member
#; stops being the primary so we need to switch to a "non-mirrored"
#; journal file.
#define JRNSWREASONPRIMARYMIRRORStop 10
#; JRNSWREASONMirrorDBRemoved indicates a mirrored database was removed
#; from the mirror and we needed to switch journals (eg. on the primary)
#; so we could re-add the sfn for that database without the mirror
#; mapping so subsequent sets/kills to that db are not replicated on the
#; backup/etc...
#define JRNSWREASONMirrorDBRemoved 11
#; ;JO2141-
#; ;JO2465+
#; JRNSWREASONMissingJrnfile indicates that CheckCurJrnfile() decided
#; the current journal file was missing and issued a jrnswitch to create
#; a new journal file. The journal daemon (on Unix at least) could still
#; be writing to a deleted file but we'd run into trouble trying to use it
#; for rollback, or journal restore.
#define JRNSWREASONMissingJrnfile 12
#; ;JO2465-

#define JRNSWREASONSTARTUP -1
#define JRNSWITCHBYTASKMGR	$$$JRNSWITCH($$$JRNSWREASONTASKMGR)
#define JRNSWITCHBYBACKUP	$$$JRNSWITCH($$$JRNSWREASONBACKUP)
#define JRNSWITCHBYRESTORE	$zu(78,1,"","",0,0,$$$JRNSWREASONRESTORE)
#define JRNSWITCHBYUSER		$$$JRNSWITCH($$$JRNSWREASONUSER)
#define JRNSWITCHTOACTIVATE	$$$JRNSWITCH($$$JRNSWREASONACTIVATE)
								#;HYY1091-
								#;HYY1119+
#; internal types of journal markers:
  #; -1 = end of backup
#define JRNMARKTYPEBACKUP	-1
  #; -2 = end of journal restore
#define JRNMARKTYPEJRNRESTORE	-2
  #; -3 = ECP cluster recovery (open transactions associated with that system 
  #; prior to the marker can be ignored by restore), see HYY965,PL#37800
#define JRNMARKTYPEECPCLURCVRY	-3
  #; -4 = Marks where a SYS.MoveGlobals operation started
#define JRNMARKTYPEMOVEGLOBAL -4
								#;HYY1119-
								#;HYY1200+
#;get or set the system flag for journal encryption 
#define IsJournalEncryptionOn		$zu(69,68)
#define EnableJournalEncryption		$zu(69,68,1)
#define DisableJournalEncryption	$zu(69,68,0)
  #; %s = 1 (to enable) or 0 (to disable)
#define SetJournalEncryptionState(%s)	$zu(69,68,%s)
#define	IsCurrentJournalEncrypted	$$$JRNENCKEYIDLEN($$$JRNCURNAM)
								#;HYY1200-
  
								#; JO2141+
#; The following are the $Piece offsets for the value
#; returned from $SYSTEM.MIRROR.DBGetInfo(sfn). ^ is the
#; delimiter
#define MIRDBINFODBPATH       1
#define MIRDBINFODBNAME       2
#define MIRDBINFOMIRFILECNT   3
#define MIRDBINFOJRNOFF       4
#;  JO2429: Field #5 is unused
#define MIRDBINFODBGUID       6
#define MIRDBINFOMIRGUID      7
#define MIRDBINFOMIRRORNAME   8
#define MIRDBINFOCURSYSGUID   9
#define MIRDBINFOCURDIRNAME  10
#define MIRDBINFOLASTFILECNTRESTORED 11
#define MIRDBINFODBFLAGS     12
#;SML1343+
#define MIRDBINFOMIRFILECNTNEW 13
#define MIRDBINFOJRNOFFNEW   14
#;SML1343-
#;JO2489+
#define MIRDBINFOMIRFILECNTOLD 15
#define MIRDBINFOJRNOFFOLD	 16
#;JO2489-
#;SML1771 ; for mibjrnguid.
#define MIRDBINFOJRNGUID	 17
#;JO2769+
#define MIRDBINFODEJRNTARGMIRFILECNT 18
#define MIRDBINFODEJRNTARGJRNOFF 19
#;JO2769-
#;SML2208 ; DB is active.
#define MIRDBINFODBACTIVE	 20

#; Bits in MIRDBINFOFLAGS
#define MIBNOFAILOVERBit $ZU(40,8,31)
#;SML1343+
#define MIBCREATEDNEWBit $ZU(40,8,34)
#;SML1343-

#; $$$IsMirrorJournalFile(x) is non-zero if the journal file is
#; a mirror journal and 0 if it isn't. "mirjrnfilecnt" is stored 
#; in the journal header and is 0 for non-mirrored journal files.								
#define IsMirrorJournalFile(%a) (+$P($ZU(78,22,%a,$$$JrnHdrMIRFILECNT),",",2))

#; Definitions for fields in mirror journal log file (mirrorjrn.log)
#; for data returned from $SYSTEM.Mirror.GetJournalFileInfo() which
#; returns 1,<line from mirrorjrn.log> which matches a given file name
#; so the log file data starts at piece #2. The time is UTC time in
#; yyyy-mm-dd hh:mm:ss format.
#define MIRLOGFILENAME   2  
#define MIRLOGMIRFILECNT 3
#define MIRLOGFILEGUID   4
#define MIRLOGCRETIME    5
								#; JO2141-
								#;HYY1509+
#define	JRNLOGRDSHRSET	$zu(78,79,0,1,0)
#define	JRNLOGRDSHRCLR	$zu(78,79,0,0,0)
#define	JRNLOGWTLCKSET	$zu(78,79,1,1,0)
#define	JRNLOGWTLCKCLR	$zu(78,79,1,0,0)
#define	JRNLOGRDBANSET	$zu(78,79,2,1,0)
#define	JRNLOGRDBANCLR	$zu(78,79,2,0,0)
#define	JRNLOGHdrKeyVersionU	"VERSION="
#define	JRNLOGHdrKeyHostU	"HOST="
#define	JRNLOGHdrKeyEditionU	"EDITION="
#define	JRNLOGHdrKeyBaseU	"BASE="
#define	JRNLOGHdrKeyEndU	"<ENDOFHEADER>"
#define	JRNLOGHdrKeyVersionM	"Version="
#define	JRNLOGHdrKeyHostM	"Host="
#define	JRNLOGHdrKeyEditionM	"Edition="
#define	JRNLOGHdrKeyBaseM	"Base="
#define	JRNLOGHdrKeyEndM	"<EndOfHeader>"
#define	JRNLOGLineIsHdrKey(%line,%keyU) ($e($zcvt(%line,"U"),1,$l(%keyU))=%keyU)
#define	JRNLOGVERSION	1.0
#define	JRNLOGHDRMaxLine	5
#; The following JRNLOGRecXXX macros are the comma-delimited field #'s of 
#; a journal log record (entry).
#; Be sure to keep them in sync with jrnlog_addrec() in journal.c.
#define	JRNLOGRecCSN	1
#define	JRNLOGRecPath	2
#define	JRNLOGRecVer	3
#define	JRNLOGRecGUID	4
#define	JRNLOGRecPrevGUID	5
#define	JRNLOGRecTime	6
#define	JRNLOGRecReason	7
#define	JRNLOGRecChksum	8
#;SML1599+
#; The following MIRJRNLOGRecXXX macros are the comma-delimited field #'s of 
#; a mirror journal log record (entry).
#; Be sure to keep them in sync with mirjrnlog_addrec() in journal.c.
#define	MIRJRNLOGRecPath	1
#define	MIRJRNLOGRecJCNT	2
#define	MIRJRNLOGRecGUID	3
#define	MIRJRNLOGRecTime	4
#define	MIRJRNLOGRecVer		5
#define	MIRJRNLOGRecChksum	6
#;SML1599-
							#;HYY1682+
#define	PurgedJrnFileList	^||%ISC.PurgedJrnFiles
#define	PurgedJrnFileListS(%i)	^||%ISC.PurgedJrnFiles(%i)
							#;HYY1584+
#define	PurgedMirJrnFileList		^||%ISC.PurgedMirJrnFiles
#define	PurgedMirJrnFileListS(%m)	^||%ISC.PurgedMirJrnFiles(%m)
#define	PurgedMirJrnFileListSS(%m,%i)	^||%ISC.PurgedMirJrnFiles(%m,%i)
							#;HYY1584-
							#;HYY1682-
#define	JrnLogOpenForRead(%f)	o %f:($s($$$ISVMS:"rh",1:"r"):/IOT="UTF8")
	#; JrnLogOpenCreate - Open/create a journal log file
	#; Return: <1 - failure
	#;          1 - success
#define	JrnLogOpenCreate(%logf)	$zu(78,85,%logf)
	#; JrnLogAppend - Append a journal file entry to the opened journal log
	#; Return: <0 - the journal file doesn't exist or is not a journal file
	#;          0 - error writing to journal log
	#;          1 - success
#define	JrnLogAppend(%jrnf)	$zu(78,86,%jrnf)
	#; JrnLogClose - Close the journal log opened via $zu(78,85)
#define	JrnLogClose	$zu(78,87)
#;SML1599+
#define	MirJrnLogOpenForRead(%f)	o %f:($s($$$ISVMS:"rh",1:"r"):/IOT="UTF8")
#;SML1628+
	#; MirJrnLogCreate - Create a mirror journal log file. 
	#; Return: <1 - failure
	#;          1 - success
#define	MirJrnLogCreate(%logf,%index)	$zu(78,85,%logf,%index,1)
	#; MirJrnLogOpen - Open a mirror journal log file
	#; Return: <1 - failure
	#;          1 - success
#define	MirJrnLogOpen(%logf,%index)	$zu(78,85,%logf,%index)
#;SML1628-
	#; MirJrnLogAppend - Append a journal file entry to the opened mirror journal log
	#; Return: <0 - the journal file doesn't exist or is not a journal file
	#;          0 - error writing to journal log
	#;          1 - success
#define	MirJrnLogAppend(%jrnf,%index)	$zu(78,86,%jrnf,%index)
	#; MirJrnLogClose - Close the mirror journal log opened via $zu(78,85)
#define	MirJrnLogClose(%index)	$zu(78,87,%index)
	#; MIRJRNLOGCHKSUMPOS - checksum position in the line of mirror log file.
#define MIRJRNLOGCHKSUMPOS(%line) ($p($p(%line,",",5),"-",2)+1)
#;SML1599-
	#; umask = 0117 to ensure write permission for the group
#define	JRNLOGumask	(64+8+7)
								#;HYY1509-
#; For mirror journal log file.
#;SML1599+
#define	MIRJRNLOGRDSHRSET(%index)	$zu(78,79,0,1,%index)
#define	MIRJRNLOGRDSHRCLR(%index)	$zu(78,79,0,0,%index)
#define	MIRJRNLOGWTLCKSET(%index)	$zu(78,79,1,1,%index)
#define	MIRJRNLOGWTLCKCLR(%index)	$zu(78,79,1,0,%index)
#define	MIRJRNLOGRDBANSET(%index)	$zu(78,79,2,1,%index)
#define	MIRJRNLOGRDBANCLR(%index)	$zu(78,79,2,0,%index)
#;SML1599-
#define	JRNLOGHdrKeyMirrorSetGUIDU	"MIRRORSETGUID="
#define	JRNLOGHdrKeyLocalMirrorGUIDU	"LOCALMIRRORGUID="
#;SML1599+
#define	MIRJRNLOGVERSION	2.0
#define	MIRJRNLOGVERSIONC	"2.0"
#define	MIRJRNLOGHDRMaxLine	7
#;SML1599-
#define STARTREPORTNODEINDEX	101
								#;HYY1500+
#; For journal restore
#;Journal restore options.  0 is a flag indicating questions have been asked. 
#define JRNRSTOPTDB	1
  #; continuing restore on database-related errors is default
  #; if JRNRSTABORTDB(%opt)=1, abort restore on database-related errors
#define JRNRSTABORTDB(%opt)	(%opt[$$$JRNRSTOPTDB)
#define JRNRSTOPTJRN	2
  #; aborting restore on journal-related errors is default
  #; if JRNRSTABORTJRN(%opt)=1, abort restore on journal-related errors
#define JRNRSTABORTJRN(%opt)	(%opt'[$$$JRNRSTOPTJRN)
#define JRNRSTOPTFLUSH	3
  #; applying sorted updates to databases upon aborting restore is default
  #; if JRNRSTABORTFLUSH(%opt)=1, discard sorted, not-yet-applied updates
#define JRNRSTABORTFLUSH(%opt)	(%opt[$$$JRNRSTOPTFLUSH)
								#;HYY1500-
								#;JO2430+
 ; The constant JrnHisoryLifeSpan is set to 30, so that entries older than 30
 ; days would get deleted. 
  
 ; delete entries older than 30 days in journal history
#define  JrnHistoryLifeSpan  30   
								#;JO2430-
								#;HYY1762+
#define	ErrJrnRestGUIDNotFound(%guid) $$$ERROR($$$JrnRestGUIDNotFound,%guid)
#define	ErrJrnRestNameNotFound(%name) $$$ERROR($$$JrnRestNameNotFound,%name)
#define	ErrJrnRestBareNotFound(%bare,%dir) $$$ERROR($$$JrnRestBareNotFound,%bare,%dir)
#define	ErrJrnRestNameAmbiguous(%name) $$$ERROR($$$JrnRestNameAmbiguous,%name)
#define	ErrJrnRestBareAmbiguous(%bare,%dir) $$$ERROR($$$JrnRestBareAmbiguous,%bare,%dir)
#define	ErrJrnRestPriorNotFound(%name) $$$ERROR($$$JrnRestPriorNotFound,%name)
#define	ErrJrnRestPrefixNotFound(%bare,%pref) $$$ERROR($$$JrnRestPrefixNotFound,%bare,%pref)
								#;HYY1762-
								#;HYY2031+
#; RegisterJrnLogFiles enables recovery of a jrnlog from its temp copy in the
#; event that the job died after deleting the jrnlog.
#; UnregisterJrnLogFiles disables it.
#; %mf: mirror index, %tmp: temp copy of jrnlog, %cur: current copy of jrnlog
#define	RegisterJrnLogFiles(%mf,%tmp,%cur) $zu(78,113,%mf,%tmp,%cur)
#define	UnregisterJrnLogFiles(%mf) $zu(78,113,%mf,"")
								#;HYY2031-
#endif %syJrninc
 
 
 