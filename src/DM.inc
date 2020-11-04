ROUTINE DM [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML1106 9/15/10 Jeffrey Orlin, add mirrorinfotype for block type of
#;                mirror information block
#;SML714  6/20/06 Simon Li, Fix Integrity checking return code problkem.
#;LFT1480 3/29/06 Laura Tillem, remove duplicate status macros
#;LFT1320 11/09/4 Laura Tillem, %DM -> %SYS.DATABASE
#;LFT1278 8/03/04 Laura Tillem, remove JO1796 define
#;JO1796  4/05/04 Jeffrey Orlin, add $$$collatepiece for $ZU(49)
#;LFT1116 8/15/03 Laura Tillem, enhanced integrity checking
#;SAP123  7/25/03 Steve Pettibone, improve performance of FREECNT
#;HYY761  3/31/03 Huayong Yang, support new journal attributes of a global
#;PWC715  2/17/03 Peter Cudhea-Pierce, added security block type
#;LFT1016 8/07/02 Laura Tillem, add map editing for REPAIROLD
#;LFT999  6/11/02 Support viewing blocks in garbage tree
#;CFL719  5/23/02 Carlos Lopes, added replsep
#;LFT997  5/22/02 Laura Tillem, more defines for %DMCONFIG
#;STC347  5/17/02 Steve Clay, Update UIC
#;LFT985  4/11/02 Laura Tillem, map defines
#;LFT977  3/04/02 Laura Tillem, defines for %DMCONFIG
#;CLN043  3/04/02 Laura Tillem
#;LFT957  8/09/01 Laura Tillem, max file size
#;HYY530  8/06/01 Huayong Yang, add macro dbcollation
#;LFT940  6/28/01 Laura Tillem, REPAIR enhancements
#;LFT939  5/16/01 Laura Tillem, add constant for collation byte
#;STC273  4/29/01 Steve Clay, Move messages to MESSAGES.INC, 
#;                ENU now default locale
#;LFT932  4/16/01 Laura Tillem, add colrule macro
#;LFT931  4/10/01 Laura Tillem, add constants for using GContiguousMaps[]
#;PWC559  4/02/01 Peter Cudhea-Pierce, %GIF and %GOF for bigDB
#;LFT918  4/02/01 Laura Tillem, add constants for $v(even,-6) in data block
#;LFT911  3/23/01 Laura Tillem, add constants for CheckFreeCount
#;LFT912  3/23/01 Laura Tillem, support Silent^Integrity
#;LFT908  3/20/01 Laura Tillem, add constants for map checking
#;LFT901  3/12/91 Laura Tillem, add constants for REPAIR support
#;JO1357 03/05/01 Jeffrey Orlin, add error #29 for Integrit when
#;                the right link of the pointer block is 0 but the lower level
#;                block isn't zero. 
#;LFT850  1/22/01 Laura Tillem, integrity messages
#;LFT898  1/16/01 Laura Tillem, fix link to get block number correctly
#;LFT893  1/07/01 Laura Tillem, changes to support CFL421
#;CFL421  1/07/01 Laura Tillem, port these defines from Wserver.inc
#;LFT886 12/18/00 Laura Tillem, add protect message
#;LFT885 12/18/00 Laura Tillem, add journaling function to api
#;                              also adds glopurge macro from JRNINC.INC
#;LFT881 12/16/00 Laura Tillem, more changes for bigdb utility support
#;LFT877 12/06/00 Laura Tillem, add protection code
#;LFT863 11/26/00 Laura Tillem, rewrite of ^%DM
#;LFT806 08/02/00 Laura Tillem, include file for database management api %DM
#endif  /*=====================End Maintenance======================*/
 ;
#ifndef DMINC
#define DMINC
 
#; Block sizes
#define 2k 2048
#define 4k 4096
#define 8k 8192
#define 16k 16384
#define 32k 32768
#define 64k 65536
 
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
   
#define freezeyes 1
#define collateunicode 5
#define megabyte 1048576
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
#;STC347+
#define defuic $zu(67,20,$j)
#;STC347-
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
#define offsetval(%big) $case(%big,1:$$$offset,$$$offset2k)
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
#; PWC715+
#define	securityblktype 13
#; PWC715-
#if 0  ;LFT1016+
#define bitmaptype 16
#else  ;LFT1016=
#define bitmaptype(%bigval) $Case(%bigval,0:170,:16)
#endif ;LFT1016-
#; SML1106+
#define mirrorinfotype 17
#; SML1106-
#define bigdatatype 24
#define toppointertype 66
#define topbottompointertype 70
#;LFT999+
#define garbitval 32
#define isgartype(%x) $Zboolean(+%x,$$$garbitval,1)
#;LFT999-
#if 1  ;LFT940+
#define isbottomtype(%x) (%x=$$$bottompointertype || (%x=$$$topbottompointertype))
#endif	;LFT940-
 
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
 
#define readstatus(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,2),1)
#define readonlyattr(%x) $zb(+$p(%x,",",$$$statuspiece),$zu(40,8,13),1)
#define clmntmode(%x) $zb(+$p(%x,",",$$$attribpiece),$zu(40,8,15),1)
 
#; Here %x is the dir name
#define dirblksiz(%x) $Piece($$$dirinfo(%x),",",$$$blksizpiece)
#; Here %x is the zu49 value
#define getblksiz(%x) $Piece(%x,",",$$$blksizpiece)
#define getbigval(%x) $Piece(%x,",",$$$bigdbpiece)
#define getglodir(%x) $Piece(%x,",",$$$glodirpiece)
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
#;HYY761+
#define getgtypejrnval(%gtype) ($zu(78,55,-%gtype))
#define getgtypejrnstate(%gtype) ($zu(78,55,%gtype))
#define getnewgtype(%gtype,%jrnval) ($zu(78,55,%gtype,%jrnval))
#;HYY761-
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
#if  0  ;LFT1116+
#define errmaxperglobal 5
#define errmaxperdir 10
#;JO1357+
#define ErrLowerBlkRightLinkNotZero 29   
#;JO1357-
#define errmaxpersys 30
#else  ;LFT1116=
#define errmaxperglobal 100
#define errmaxperdir 500
#;JO1357
#define ErrLowerBlkRightLinkNotZero 29   
#define errmaxpersys 1000
#endif  ;:LFT1116-
 
#define MountIfNotMounted 1
#define DoNotMount 0
#define IsBig 1
 
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
#; LFT908+,LFT911
#; Defines for map blocks
#define mapoff2k 1
#define numfreeblks2k $$$offset2k
#; For big database map blocks
#define mapoff 2
#define numfreeblks $View($$$dataoff,0,4)
#;LFT1016+
#define mapoffset(%x) $Case(%x,0:1,:$$$mapoff)
#define numfree(%x) $Case(%x,0:$$$offset2k,:$$$numfreeblks)
#;LFT1016-
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
 
#; Definitions for using %Status return codes
#;STC273+
#define DEFAULTLOCALE "ENU"
#define MessageGlobal "^%Messages"
#;STC273-
#;LFT1480
#;SML714+
#def1arg MSG(%args) 1_$e($$$ERROR(%args),2,*)
#define ADDSCMSG(%sc1,%sc2) $$AppendStatus^%occSystem(%sc1,%sc2)
#;SML714-
 
#;LFT977+
#; Pieces of namespace value string in config file
#define sepns ","
#define getcpf $Piece($Zutil(86),"*")
#define nspiece 1
#define glodspiece 2
#define sysglodspiece 3
#define roudspiece 4 
#define sysroudspiece 5
#define libdspiece 6
 
#; Pieces of dataset value string in config file
#define sepds ","
#define dsnamepiece 1
#define dirpiece 2
#define systempiece 3
#define mountdirpiece 4
#define mountstatepiece 5
#define readonlypiece 6
#define requiredpiece 7
#;LFT977-
 
#;LFT997+
#; Pieces of global and routine mapping strings in config file
#define sepmap ","
#;CFL719+
#define replsep "~"
#;CFL719-
#define glopiece 1
#define destpiece 2
#define allspecpiece 2
#define roudestpiece 3
#define lockpiece 3
#define slmindpiece 4
#define slmcolpiece 5
#define replpiece 6
#;LFT997-
 
#endif DMINC