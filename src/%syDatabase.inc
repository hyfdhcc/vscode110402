ROUTINE %syDatabase [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML2117  8/19/15 Simon Li, Mirror member status and database status updates.
#;SML2106  7/24/15 Simon Li, Allow CatchupDB operates on mirrored DB while Mirroring is starting.
#;HYY2001 04/24/15 Huayong Yang, add securityblktype and mirrorinfotype bits
#;SML1805 12/04/13 Simon Li, Handle mismatched mirrored DB GUID with GUID in journal file.
#;SML1729  6/25/13 Simon Li, Check readonly due to fail to create cache.lck and honor readonly mirrored DB in primary.
#;STC2186  4/22/13 Steve Clay, Add mapping of ^%ISCWorkQueue to CACHE DB
#;JO2644   3/08/13 Jeffrey Orlin, add COMPSKIPPEDBLKS (-9) return status for compaction
#;STC2189 03/07/13 Steve Clay, Move globals from one database to another in realtime 
#;JO2611  12/26/12 Jeffrey Orlin, add badblktypeerr as -8 for defragmentation and compaction
#;STC2153 12/06/12 Steve Clay, Fix filter in global list display 
#;JO2548   5/18/12 Enable FreeSpace Compaction and Database Defragmentation
#;JO2506   1/31/12 Jeffrey Orlin, add truncinprogress for $ZU(45) return values
#;SML1430 12/27/11 Simon Li, Improve performance when looking through all SFN entries.
#;JO2438   5/09/11 Jeffrey Orlin, add IsFirstGDBlock(type,block#)
#;STC1898 01/25/10 Steve Clay, Remove old globals from directory filter
#;STC1882 01/04/10 Steve Clay SYS.Database.FixDefaultGlobalCollation Method to report and correct incorrect collations in System globals 
#;JO2357  11/19/10 Jeffrey Orlin, Add retfreeblkcachefail
#;STC1777 04/01/10 Steve Clay, New SYS.Database.Copy() method
#;JO2141   3/30/09 Jeffrey Orlin, mirroring gfstatus/gfattrib fields
#;LFT1372 12/28/04 Laura Tillem, change bitmaptype to bitmapblocktype
#;LFT1340 11/29/04 Laura Tillem, add keepstate and jrnstate
#;WDS100  11/02/04 David Shambroom, $$$enckeyidpiece, getenckeyid()
#;LFT1320 11/01/04 Laura Tillem, %DM -> %SYS.Database
#;LFT1278  8/03/04 Laura Tillem, add $$$resourcepiece
#;LFT1173 12/07/03 Laura Tillem, add missing colon for $$$offsetval
#;LFT1150 10/18/03 Laura Tillem, add fullstatus and fix up status vs atrrib
#;LFT1135 10/07/03 Laura Tillem, additions for support of ^DATABASE
#;LFT1132 09/21/03 Laura Tillem, %SS changes
#;STC472  08/24/03 Steve Clay, move to %syDatabase
#;LFT1047 10/18/02;Remove messages, they will go in Xerrors.xml instead
#;LFT975  08/01/02;Create include file for %SYSTEM.Database class
#endif  /*=====================End Maintenance======================*/
 #;/* Revision: $Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/inc/_syDatabase.inc#1 $ ($Change: 4521965 $) */
 
 #; Block sizes
#define 2k 2048
#define 4k 4096
#define 8k 8192
#define 16k 16384
#define 32k 32768
#define 64k 65536
 
#;Note 2kb is no longer a valid block size.
#define ValidBlockSize(%Size) $case(%Size,$$$4k:1,$$$8k:1,$$$16k:1,$$$32k:1,$$$64k:1,:0)
#;Offsets into the $list structure returned by $System.Util.GlobalBuffers()
#define GlobalBuffersOffset(%Size) $case(%Size,$$$4k:2,$$$8k:3,$$$16k:4,$$$32k:5,$$$64k:6,:0)
#define megabyte 1048576
 
#define DefaultDatabaseBlockSize $$$8k
 
#if 1   ;LFT957+
#define maxmb8k 33553904
#define maxmb2k 16383
#endif  ;LFT957-
 
#if 1   ;CFL421+
#define GETGBDB0OFF(%a) $v(%a*$$$STILEN+$$$STgbdb0off,-2,$$$STILEN)
#define BUFFAVAILABLE(%a) $case($$$GETGBDB0OFF(%a),4294967295:0,:1)
#endif  ;CFL421-
 
#; GetDatabaseStatus status codes
#define filenotthere 0
#define filemountedok 1
#define notmounted 2
#define skeletondb 3
   
#if 1  ;LFT940+
#define type2bigstringbit (2**30)
#define type1bigstringbit (2**12)
#endif	;LFT940-
#define glodirbig 3
#define glodir2k 2
#if 1  ;LFT940+
#define gdir4datalen 11
#endif	;LFT940-
#define defdir $zu(12,"")
#define canonize(%name) $zu(12,%name)
#define mount(%dir) $zu(17,%dir)
#define lasterror $zu(96,3,$zu(96,0))
#define ProtectError 32
#; del1 will be removed
#define del1 $c(22,35,1)
#define defgp $zu(40,0,40)
#define defgp2k 6
#define def4kgg 50
#if 0  ;LFT975
#define defuic $v($zu(40,1,3),-1,4)
#else  ;LFT975=
#define defuic $Zutil(67,20,$j)
#endif ;LFT975-
#define deffilsiz 1
#define unlimitedfilsiz 0
#define defblksiz 8192
#define defexpandby2k 400
#define mapsize2k 400
#define defexpandby(%x) $case(%x,$$$4k:256,:128)
#define linkoff $Zutil(40,32,4)
#define link $v($$$linkoff,0,4)
#define link2k $v(2040,0,"3O")
#define linkblk(%big) $case(%big,1:$$$link,:$$$link2k)
#define typeoff $Zutil(40,32,1)
#define type $v($$$typeoff,0,1)
#define type2k $v(2043,0,1)
#define blktype(%big) $case(%big,1:$$$type,:$$$type2k)
#define reloffpos $zu(40,32,0)
#define offset $v($$$reloffpos,0,4)+$zu(40,32,10)
#define offset2k $v(2046,0,2)
#define offsetval(%big) $case(%big,1:$$$offset,:$$$offset2k)
#define reloff $v($$$reloffpos,0,4)
#define bigcountoff $zu(40,32,6)
#if 1  ;LFT940+
#define getbigcount $View($$$bigcountoff,0,4)
#define pntlenoff $Zutil(40,32,3)
#define getpntlen $View($$$pntlenoff,0,2)
#define nextpntlenoff $Zutil(40,32,8)
#define getnextpntlen $View($$$nextpntlenoff,0,2)
#define nextpntvaloff $Zutil(40,32,9)
#define getnextpntval $View($$$nextpntvaloff,0,1)
#define nextpntoffoff $Zutil(40,32,7)
#define getnextpntoff $View($$$nextpntoffoff,0,1)
#define blincveroff $Zutil(40,32,5)
#define getblincver $View($$$blincveroff,0,4)
#define collateoff $Zutil(40,32,2)
#endif	;LFT940-
#define dataoff $zu(40,32,10)
#define garoff2k $v(2036,0,"4O")
#define blkcol $v($zu(40,32,2),0,1)
#if 1  ;LFT932+
#define colrule $Zutil(70,1,$View($Zutil(40,32,2),0,1))
#endif ;LFT932-
#define blkcol2 $v(2044,0,1)
#define datasize(%x) $Case(%x,$$$2k:2036,:(%x-$$$dataoff))
 
#; Database block types
#define gdirtype2k 1
#define pointertype 2
#define bottompointertype 6
#define datatype 8
#define gdirtype 9
#define bigdatatype2k 12
								#;HYY2001+
#define securityblktype 13
#define mirrorinfotype 17
								#;HYY2001-
#if 0  ;LFT1372+
#define bitmaptype 16
#else  ;LFT1372=
#define bitmapblocktype 16
#endif ;LFT1372-
#define bigdatatype 24
#define toppointertype 66
#define topbottompointertype 70
#define isgartype(%x) $zb(+%x,32,1)
#define garbit 32
#if 1  ;LFT940+
#define isbottomtype(%x) (%x=$$$bottompointertype || (%x=$$$topbottompointertype))
#endif	;LFT940-
 
#;LFT1320
#define IsDataType(%x)  (%x=$$$datatype || (%x=$$$gdirtype) || (%x=$$$bigdatatype2k) || (%x=$$$bigdatatype))
 
#;JO2348+
#; The 1st global directory block in a new format database is
#; always block #3.
#define IsFirstGDBlock(%type,%blk) ((%type=$$$gdirtype) && (%blk=3))
#;JO2348-

#; Pieces of $zu(27) successful return code
#define volpiece 1
#define primvolpiece 2
#define sequencepiece 3
#define volblkspiece 4
#define totblkspiece 5
#define zu27blksizpiece 6
 
#; Pieces of $zu(27) error return code, first piece is same as above
#define errnumpiece 2
#define codepiece 3
#; Codes for error return from $zu(27)
#define notowner 1
#define nosuchrawdeviceordir 2
#define ioerror 5
#define nosuchdeviceoraddr 6
#define accessdenied 13
#define devicebusy 16
#define fileexists 17
#define nosuchdeviceoruse 19
#define overflow 23
#define toomanyopen 24
#define readonly 30 
#define dirinfo(%x) $zu(49,%x)
#;LFT985+
#define checkavailgetinfo(%x)  Set info=$$$dirinfo(%x) i (+info)<-1 Quit $$$ERROR($$$DatabaseNotAvailable)
#;LFT985-
#; Pieces of return value from $zu(49)
#define mountpiece 1
#define blksizpiece 2
#define uicpiece 3
#define filsizpiece 4
#define expandpiece 5
#define maxblkpiece 6
#define glodirpiece 7
#define gloptrpiece 8
#define rdirpiece 9
#define rgrpiece 10
#define glogrpiece 11
#define freezepiece 12
#define colpiece 13
#define sfnpiece 14
#define totvolpiece 15
#define formatpiece 16
#define attribpiece 17
#define statuspiece 18
#define exptimepiece 19
#define nojrnpiece 20
#define bigdbpiece 21
#define curblkspiece 22
#define blkspermappiece 23
#define curmapspiece 24
#;LFT1278
#define resourcepiece 25
#;WDS090
#define enckeyidpiece 26
 
#;LFT1150
#define fullstatus(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,26),1)
#define readonlystatus(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,2),1)
#;LFT1135
#define readonlyattrib(%x) $zb(+$p(%x,",",$$$attribpiece),$zu(40,8,13),1)
#define clmntmode(%x) $zb(+$p(%x,",",$$$attribpiece),$zu(40,8,15),1)
#define sparsedbattrib(%x) $zb(+$p(%x,",",$$$attribpiece),$zu(40,8,20),1)
#define nojrnstatus(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,18),1)
#define skeletonformat(%x) $zb(+$p(%x,",",$$$formatpiece),$zu(40,8,9),1)
#define encrypteddbformat(%x) $zb(+$p(%x,",",$$$formatpiece),$zu(40,8,27),1)

#; JO2141+
#define inactivemirror(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,29),1)  
#define mirrordbnowrite(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,30),1)  
#define mirrored(%x) $zb(+$p(%x,",",$$$attribpiece),$zu(40,8,28),1)  
#define mirroractivatereq(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,32),1)  
#; JO2141-
#;SML1805
#define mirrorobsolete(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,35),1) 
#;SML2117+
#define mirrordbpaused(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,36),1) 
#define mirrorcatchup(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,37),1) 
#;SML2117-
#;SML2106+ ; check gfstatus to be eligible to become 'active' mirrored DB.
#; The GFINCREST, GFOBSOLETE, GFMIRDBNOWITE, GFDBINACTIVEMIRROR, GFMIRACTIVATEREQ and GFPAUSED needs to be cleared
#define EligibleToBecomeActiveBits ($zu(40,8,11)+$zu(40,8,35)+$zu(40,8,30)+$zu(40,8,29)+$zu(40,8,32)+$zu(40,8,36))
#define EligibleToBecomeActive(%x) ('$zb(+$p(%x,",",$$$statuspiece),$$$EligibleToBecomeActiveBits,1))
#;SML2106-

#; Here %x is the dir name
#define dirblksiz(%x) $Piece($$$dirinfo(%x),",",$$$blksizpiece)
#; Here %x is the zu49 value
#define getblksiz(%x) $Piece(%x,",",$$$blksizpiece)
#define getbigval(%x) $Piece(%x,",",$$$bigdbpiece)
#define getglodir(%x) $Piece(%x,",",$$$glodirpiece)
#;LFT1278
#define getresource(%x) $Piece(%x,",",$$$resourcepiece)
#;WDS090
#define getenckeyid(%x) $Piece(%x,",",$$$enckeyidpiece)
#if 1  ;LFT893+
#define blksizbigval(%x) $Case(%x,$$$2k:0,$$$4k:1,$$$8k:2,$$$16k:3,$$$32k:4,:5)
#endif ;LFT893-
#if 1   ;HYY530+
#define dbcollation(%dir) $Piece($$$dirinfo(%dir),",",$$$colpiece)
#endif  ;HYY530-
 
#; Pieces of the return value from $zu(167)
#; LFT901+
#define nodetypepiece 1
#; LFT901-
#define nodesubpiece 2
#define nodecccpiece 3 
#define nodelenpiece 4
#define nodepadpiece 5
 
#; Pieces of the return value of $v(n*2,-6) in a bigdb global directory
#define ptrpiece 1
#define growthpiece 2
#define collatepiece 3
#define typepiece 4
#define protpiece 5
 
#if 1  :LFT918+
#define gdviewstr(%bigval) 0
#define gdviewint(%bigval) 1
#define gdviewdbl(%bigval) 2
#define gdviewbigbin(%bigval) 3
#define gdviewuni(%bigval) 4
#define gdviewbiguni(%bigval) 5
#define gdviewcompact(%bigval) $Case(%bigval,0:8,:6)
#define gdviewbigcompact(%bigval) $Case(%bigval,0:9,:7)
#endif ;LFT918-
 
#define keepval(%x) ($ZB(+%x,$zu(40,0,57),1))
#define jrnval(%x) ($ZB(+%x,$zu(40,0,56),1))
#;LFT1340+
#define jrnstate(%x) $s($zb(+$p(%x,",",17),$zu(40,8,22),1):3,$zb(+$p(%x,",",17),$zu(40,8,23),1):2,1:1)
#define keepstate(%x) $zb(+$p(%x,",",17),$zu(40,8,24),1)>0
#;LFT1340-
#define glopurge(%nam,%dir,%blk) $Zutil(154,%nam,"^^"_%dir,%blk)
#if 1  ;LFT886+
#define offprotectbyte 2
#endif ;LFT886-
#if 1  ;LFT939+
#define offcollationbyte 1
#endif ;LFT939-
  
#; Integrity definitions
#define ErrNoView 1
#define ErrPtrDegraded 8
#define errmaxperglobal 100
#define errmaxperdir 500
#;JO1357+
#define ErrLowerBlkRightLinkNotZero 29   
#;JO1357-
#define errmaxpersys 1000
 
#define MountIfNotMounted 1
#define DoNotMount 0
#define IsBig 1
 
#; LFT908+,LFT911
#; Defines for map blocks
#define mapoff2k 1
#define numfreeblks2k $$$offset2k
#; For big database map blocks
#define mapoff 2
#define numfreeblks $View($$$dataoff,0,4)
#;LFT985+
#define setfreeblks(%x) View $$$dataoff:0:4:%x
#;Get offsets of secondary and data bitmaps based on block size
#define secondaryoff(%x) ($$$masteroff+((%x\$$$4k)*4))
#define mapdataoff(%x) ($$$secondaryoff(%x)+((((%x\$$$4k)*32)-(%x\$$$4k)-1)*4))
#;LFT985-
#define bigendian $Zutil(40,0,0)
#define masteroff $Zutil(40,0,51)
#if 1  ;LFT931+
#define contigmaps(%x) $Case(%x,0:0,1:16,2:8,3:4,4:2,5:1)
#define blkspermap(%x) $Case(%x,0:400,1:30720,2:62464,3:125952,4:252928,5:506880)
#endif ;LFT931-
#; LFT908-,LFT911
 
#; PWC559+
#; Definitions for using %GOF files
#define GOFVersion2k 2
#define GOFVersion4k 3
#define GOFsystem2k 1
#define GOFsystem4k 2
#; PWC559-
 
#;LFT975+
#; Additional definitions for database class
#;SML1430+ ; the maxsfn is the cuurently set up SFN entries.
#define maxsfn ($v($zu(40,2,176),-2,4)-1)
#; The %x is gfstatus[] value, check id the db is sismounted.
#define dbdismounted(%x) $zb(+%x,$$$STGFDISMOUNT+$zu(40,8,10),1)
#;SML1430-
#;LFT975-	
#;LFT1135+
#define clusterinfo(%x) $Piece($zu(49,%x,1),",",3)
#define	TOREADWRITE	2
#define TOREADONLY	1
#define GETAWRD(%n)      $V(%n,0,2)
#define LABEL1VIEW       $$$GETAWRD(2040)
#define LABEL1VALUE      21845
#;SAP123+
#define NUMINCRFILES4K 5
#define GFirstIncBlk4k 5
#define mapsize4k (30*32*32)		/* 4kb */
#define mapsize8k ((31+30)*32*32)	/* 8kb */
#define 2ndSATBlk $$$mapsize4k+(15*($$$NUMINCRFILES4K+1))+2
#define 3rdSATBlk $$$mapsize8k+(7*($$$NUMINCRFILES4K+1))+2
#define GFirstSATBlk4k ($$$GFirstIncBlk4k+$$$NUMINCRFILES4K)
#define MaxSATBlks(%x) $Case(%x,1:5,2:2,3:1,4:1,5:1)
#define GSecondSATBlk(%x) $Case(%x,1:$$$2ndSATBlk,2:$$$3rdSATBlk,3:0,4:0,5:0)
#define MAXSATNUM 3
#;SAP123-
#define findSATMapBlock(%map,%bigval) $Case(%map,0:$$$GFirstSATBlk4k,:$$$GSecondSATBlk(%bigval)+%map-1)
#define mapoffset(%x) $Case(%x,0:1,:$$$mapoff)
#;LFT1135-
#; Codes for error return from $zu(45)
#define nobuffs -1
#define compinprogress -2
#define nofree -3
#;JO2357+
#;$$$retfreeblkcachefail means we failed to clean up the free
#; block cache of cachetemp blocks and we were trying to compact
#; cachetemp so we had to abort
#define retfreeblkcachefail -4
#;JO2357-
#define	freeexceedsfile -5
#define maxspace        -6
#;JO2506+
#define truncateinprogress -7
#;JO2506-
#;JO2611+
#;BADBLKTYPEERR means we failed to move a block because we encountered
#;   a block type we don't know how to move. Most likely it is 0 and
#;   some block was killed before ever being written to disk. Less likel
#;   is this is the mirror info block.
#define badblktypeerr -8
#;JO2611-
#;JO2644+
#;COMPSKIPPEDBLKS is just a note that compaction completed but had
#;   to skip some blocks it couldn't figure out how to move. Most
#;   likely the db was changing while compaction was in progress
#;   so we couldn't track them down but its possible they are orphans.
#define compskippedblks -9
#;JO2644-
#define ENABLECOMPACTION 1   ;JO2548
#;
#;===========================================================================
#;The following is the list of system globals which are created and maintained
#;when a database is created.
#;They all get a collation value of 5, except for rOBJ which gets a collation of 133.
#;If new globals are added or removed, make sure all the following macros get updated.
#;
#;The following macro is used by the SYS.Database class when we create default globals
#;when we are creating a database.
#define DefaultDatabaseGlobals "oddBIND","oddCOM","oddDEF","oddDEP","oddEXT","oddEXTR","oddMAP","oddMETA","oddPKG","oddPROC","oddPROJECT","oddSQL","oddTSQL","oddStudioDocument","oddStudioMenu","oddXML","ROUTINE","rBACKUP","rINC","rINCSAVE","rINDEX","rINDEXEXT","rINDEXCLASS","rINDEXSQL","rMAC","rMACSAVE","rOBJ","rMAP" 
#define AllRoutineAndClassGlobals "oddBIND","oddCOM","oddDEF","oddDEP","oddEXT","oddEXTR","oddMAP","oddMETA","oddPKG","oddPROC","oddPROJECT","oddSQL","oddTSQL","oddStudioDocument","oddStudioMenu","oddXML","ROUTINE","rBACKUP","rINC","rINCSAVE","rINDEX","rINDEXEXT","rINDEXCLASS","rINDEXSQL","rMAC","rMACSAVE","rOBJ","rMAP" 
#;This definition is used by ^INSTALL to kill off generated class globals when we upgrade a system.
#define CLASSGLOBALS(%ns) ^|%ns|oddBIND,^|%ns|oddCOM,^|%ns|oddDEP,^|%ns|oddEXT,^|%ns|oddEXTR,^|%ns|oddMAP,^|%ns|oddMETA,^|%ns|oddPKG,^|%ns|oddPROC,^|%ns|oddSQL,^|%ns|oddTSQL,^|%ns|oddXML
#;The following two macros are used by %SYS.GlobalQuery
#define PercentSYSSystemGlobalList ",'CacheTemp*,'mtemp*,'ROUTINE,'rMAC,'rINC,'rOBJ,'rMAP,'rBACKUP,'rINCSAVE,'rMACSAVE,'rINDEX,'rINDEXCLASS,'rINDEXSQL,'rINDEXEXT,'odd*,'ISC.*,'%ISC.*,'%odd*,'%nls*,'CacheAudit*,'%csp*,'%SYS,'%tercap,'%MV*,'%iKnow,'%sqlcq,'SYS,'NET,'%ISCWorkQueue"
#define SystemGlobalList           ",'CacheTemp*,'mtemp*,'ROUTINE,'rMAC,'rINC,'rOBJ,'rMAP,'rBACKUP,'rINCSAVE,'rMACSAVE,'rINDEX,'rINDEXCLASS,'rINDEXSQL,'rINDEXEXT,'odd*,'ISC.*,'%ISC.*,'%odd*,'%nls*,'CacheAudit*,'%csp*,'%SYS,'%tercap,'%MV*,'%iKnow,'%sqlcq,'%ISCWorkQueue"
#;===========================================================================
#;SML1729 ; Macro for checking if the DB is allowed for Compact/Truncate/Defragment.
#define NotAllowDBCompTrunDefrag(%o) (%o.MirrorNoWrite||%o.ReadOnly||(%o.ReadOnlyMounted&&($SYSTEM.Mirror.IsPrimary()||'%o.Mirrored)))
