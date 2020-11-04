ROUTINE %syGluedef [Type=INC]
 ;%syGluedef.INC - Glue Code Definitions. ; STC2205 05/06/13
  
#if 0   /*=======================Maintenance========================*/
STC2205;05/06/13 Steve Clay Add directory to <PROTECT> error when switching namespaces
SOH303 ; 1/02/12  Steven Hobbs, Added <REGULAR EXPRESSION> error
GK791  ;11/06/09  Garen Kotikian - Added <OBJECT DISPATCH> error 
GK760  ; 8/26/09  Garen Kotikian, added <WRONG NAMESPACE> error code
GK686  ; 3/04/09  Garen Kotikian, Added <Max Routines> and <out of GMHeap> errors
SOH099  ;1/06/09 Steven Hobbs, Clean up kernel error mappings
SML1059 ;9/17/08  Simon Li, add <MAX LOCKS> error
CDS1118 ;7/25/07  Chuck Sorenson, add COMPLEX PATTERN error
SJ2393 ; 4/26/07  Scott Jones, clean up error defines
CDS707 ;10/03/05, Chuck Sorenson, add ERPROTDB error
RJW1198 ;9/30/05, Ron Watt, Inhibit Database encryption with Entree and Edge licenses.
JPL003  ;8/16/05 John Lambert, added MVWRAPUP error.
JO1945 ;07/07/05, Jeffrey Orlin, add code from %SSVN* routines to avoid
                  cross routine calls. The code is included when 
                  only when INCLSSVNCODE is defined so not all routines
                  which include this header will have it.
HYY1069 ;03/25/5, Huayong Yang, add APPERROR1
CDS644 ;01/26/05, Chuck Sorenson, add IEEE float data type
LRS876 ;12/14/04, Lee Smith, implement process external interrupts - EREXTINT
KMK179 ;08/25/04, Keith Knowles, support long strings.
CDS585 ;07/06/04, Chuck Sorenson, add ERRESJOB
JO1804 ;05/07/04, Jeffrey Orlin, added ERSQDKFUL
PWC811 ;02/11/04, Peter Cudhea, added ERPROTMISC
PWC783 ;12/05/03. Peter Cudhea-Pierce, added ERPROTMETHOD
SML378 ;10/30/03. Simon Li, Support 'Nested' transaction with USENESTEDTRANS.
HYY777 ;08/28/03, Huayong Yang, renamed from GLUEDEF to %syGluedef
RJW750 ;06/05/03, Ron Watt, Provide a method to restrict the number of license units that a configuration will consume.
RJW705 ;02/19/03, Ron Watt, Check for multi-server license when mounting DCP or ECP volumes.
JO1560 ;04/15/02, Jeffrey Orlin, add ERNOJVM and ERJAVAEXCEPTION
CDS254 ;04/05/02, Chuck Sorenson, add ERPRIVPROP, ERPRIVMETH
LRS542 ;09/06/01, Lee Smith, add ERINVARG, ERDYNLOAD, EROREFNO, and ERNOOREF
CDS180 ;03/20/01, Chuck Sorenson, renamed ERNOPGMPOPPED to ERNOPGMNOPOP
CDS141 ;11/07/00, Chuck Sorenson, add ERNOSOURCE and ERMALLOC
CDS079 ;05/08/00, Chuck Sorenson, add ERROUTINESIZE
RAM886 ;02/08/00, Rick Miller, added EBADBITSTR.
DAS289 ;07/19/99, Diane Steidler, add new network asynchronous errors
RAM837 ;04/08/99, Rick Miller, added ERTOOMANYCLASSES.
RAM834 ;03/25/99, Rick Miller, added ERZFHEAPSPACE.
RAM830 ;03/20/99, Rick Miller, added ERNOCURRENTOBJECT.
RJW250 ;03/05/99, Ron Watt, Asynchronous TCP disconnect detection and error
       ;          report.
CDS009 ;01/18/99, Chuck Sorenson, removed underscore from ERNOPGM_POPPED
RAM763 ;12/10/98, Rick Miller, add new error code definitions for Dot Syntax.
RAM761 ;11/12/98, Rick Miller, add ERSTRMISMATCH.
JO1018 ;03/27/98, Jeffrey Orlin, add ERDOMAINSPACERETRY and CSMISMATCH
SJ1175 ;09/09/97, Rick Miller: rename ERRANGE to ERVALRANGE, add ERRANGE. 
RAM650 ;08/22/97, Rick Miller: add ERRANGE error code definition
MEB047 ;07/02/97, Marty Belliveau: add the latest error code definitions
HYY089 ;05/22/97, Huayong Yang: have unsupported collations generate an error
MEB034 ;05/02/97, Marty Belliveau: prevent multiple %gluedef inclusions
MEB032 ;03/27/97, Marty Belliveau: update error codes
MEB021 ;01/23/97, Marty Belliveau: %gluedef.INC creation
#endif  /*=====================End Maintenance======================*/
  
#ifndef %syGluedef ; MEB034, HYY777
#define %syGluedef ; MEB034, HYY777
 
 ;+
 ; Glue Code debug flag
 ;-
#define GLUEDEBUG 0
 ;+
 ; Cause error %x at the application code level
 ;-
#define APPERROR(%x) $ZUTIL(96,3,%x)
 ;+
 ; Cause error %x at the first do level above this level.  [CDS459]
 ;-
#define APPERROR1(%x) $ZUTIL(96,3,%x,1)
 ;+
 ; Cause error %x with auxinfo at the application code level
 ;-
#define APPERRORTEXT(%x,%text) $ZUTIL(96,3,%x,0,%text)
 ;+
 ; Cause error %x with auxinfo at the first do level above this level.
 ;-
#define APPERROR1TEXT(%x,%text) $ZUTIL(96,3,%x,1,%text)

 ;+
 ; Cause error %x at the current glue code level
 ;-
#define GLUERROR(%x) $ZUTIL(96,0,%x)
 ;+
 ; Error code of last error
 ;-
#define LASTERROR $ZUTIL(96,0)
 ;+
 ; Internal error code definitions
 ;-
#define ERMXNUM 1
#define ERSELER 2
#define ERSYNTX 3
#define ERMULLAB 4
#define ERMXSTR 5
#define ERFUNCT 6
#define ERCTRLC 7
#define ERLINER 8
#define ERUNDEF 9
#define ERSYSTM 10
#define EREDITX 11
#define ERCMMND 12
#define ERMXBLK 13
#define ERNAME 14
#define ERSTORE 15
#define ERSBSCR 16
#define ERNOPGM 17
#define ERDIVER 18
#define ERSWIZZLEFAIL 19
 ; #define ERSTACK 20 no longer used                ; SOH099
#define ERFRAME 21
#define ERUNIMP 22
#define ERASTACK 23
#define ERSSTACK 24
 ; #define EROS1 25 no longer used              ; SOH099
 ; #define EROS2 26 no longer used              ; SOH099
#define ERREGEX 27                      
#define ERDBDGD 28
#define ERDKFUL 29
#define ERNAKED 30
#define ERPLDER 31
#define ERPROT 32
#define ERSYSER 33
#define ERNOPEN 34
#define ERNOTRM 35
#define ERDKHER 36
#define ERDKSER 37
#define ERNAMR 38
#define ERNOJOB 39
#define ERREAD 40
#define ERWRITE 41
#define ERFEOF 42
#define ERPARAM 43
#define ERNETWORK 44
#define ERRCMPL 45
#define ERCMPL 45
#define ERNOMBX 46
#define ERNOCP 47
#define ERNOWD 48
#define ERNOGC 49
#define ERMTERR 50
#define ERDOWN 51
#define ERCLNUP 52
#define ERMAXPID 53
#define ERNOSIGNON 54
#define ERHALT 55
#define ERWAITINIT 56
#define ERPRIMARY 57
#define ERCORRUPT 58
#define ERMAPS 59
#define ERVOLSET1 60
#define ERFORMAT 61
#define ERMAPRSV 62
#define ERCOLNSUP 63
#define ERZTRP 64
#define ERNODEV 65
#define ERLANG 66
#define ERDIR 67
#define ERNOSYS 68
#define ERGIMPL 69
#define ERNGLOREF 70
#define ERNFORMAT 71
#define ERDSCON 72
#define ERNVERSION 73
#define ERNJOBMAX 74
#define ERNRETRY 75
#define ERNAMADD 76
#define ERNETLOCK 77
#define ERVALUE 78
#define ERNUMFIL 79
#define ERCLUSTER 80
#define ERLIST 81
#define ERNAMSP 82
#define ERMXSCOPE 83
#define ERCMTFAIL 84
#define ERROLLFAIL 85
#define ERNSRVFAIL 86
#define ERCOLMISMAT 87
#define ERSLMSPAN 88
#define ERWIDECHAR 89
#define ERFNCOMB 90
#define ERRANDOM 91
#define ERNEGLREF 92
#define ERUNDEFLVN $$$ERUNDEF
#define ERUNDEFGVN 93
#define ERUNDEFSVN 94
#define ERINVPAT 95
#define ERNOPARAM 96
#define ERNEGOFF 97
#define ERLINELEV 98
#define ERUNDEFIND 99
#define ERQUIT0 100
#define ERQUIT1 101
#define ERNEGLEN 102
#define ERMERGE 103
#define ERNOLIST 104
#define ERARGDUP 105
#define ERSSVNGDEF 106
#define ERSSVNNOJ 107
#define ERCOLCHG 108
#define ERNOENVIR 109
#define ERRESTART 110
#define ERSSVNIMP 111
#define ERCOLDIFF 112
#define ERNOMNESEL 113
#define ERMNELINE 114
#define ERSSVNRDEF 115
#define ERDEVNOMNE 116
#define ERINCMPMNE 117
#define ERNODEVRD 118
#define ERSSVNSUB 119
#define ERNAMEINV 120
#define ERJOBCALL 121
#define ERTRANSLK 122
#define ERTRANSQT 123
#define ERXYRANGE 124
#define ERNOTRANS 125
#define ERGOTO 126
#define ERFEWPAR 127
#define ERECODE 128
#define ERLOCKLOST 129
#define ERDATALOST 130
#define ERTRANSLOST 131
#define ERZOLE 132
#define ERLICENSE 133
#define ERNOLICSERV 134
#define ERNLSTAB 135
#define ERXLATE 136
#define ERNULLVAL 137
#define ERNOVAL 138
#define ERUNKTYPE 139
#define ERVALRANGE 140 
#define ERRANGE 141 
#define ERDOMAINSPACERETRY 142
#define ERCSMISMATCH      143
#define ERSTRMISMATCH     144
#define ERBADCLASS        145
#define ERIOBJECT         146
#define ERBADOREF         147
#define ERNOMETHOD        148
#define ERNOPROPERTY      149
#define ERNOCLASS         150
#define ERCLASSDESC       151
#define ERCLASSCOMP       152
#define ERCLASSRECOMP     153
#define ERCLASSMEMORY     154
#define ERNUMCLASS        155
#define ERNUMOREF         156
#define ERGETINVALID      157
#define ERSETINVALID      158
#define ERREMCLASSRECOMP  159
#define ERREMCLASSEDITED  160
#define ERCLASSEDITED     161
#define ERNOPGMNOPOP      162
#define ERCLASSLOAD       163
#define ERCLASSSIZE       164
#define ERCORRUPTOBJECT   165
#define ERDISCONNECT      166
#define ERNOCURRENTOBJECT 167
#define ERZFHEAPSPACE     168
#define ERTOOMANYCLASSES  169
#define ERNETSTRMISMATCH  170 
#define ERNETSSTACK       171 
#define ERNETDIR          172 
#define ERNETDKHER        173 
#define ERNETDBDGD        174 
#define ERNETCLUSTER      175 
#define ERNETCSMISMATCH   176 
#define ERNETPROT         177 
#define ERNETDKSER        178 
#define ERNETDKFUL        179 
#define ERNETMXSTR        180 
#define ERNETSBSCR        181 
#define ERNETSYSTM        182 
#define ERNETWIDECHAR     183 
#define ERNETNVERSION     184 
#define ERNETNFORMAT      185 
#define ERNETNGLOREF      186 
#define ERBADBITSTR       187
#define ERROUTINESIZE     188
#define ERNOSOURCE        189
#define ERMALLOC          190
#define EROREFNO          191
#define ERNOOREF          192
#define ERINVARG          193
#define ERDYNLOAD         194
#define ERNOJVM           195
#define ERPRIVPROP        196
#define ERPRIVMETH        197
#define ERJAVAEXCEPTION   198
#define ERNETLICENSE      199
#define ERSBSCRGVN        201
#define ERPROTGVN         202
#define ERLICENSEALLOC    203
#define ERTRANLEVEL       204
#define ERPROTMETHOD      205
#define ERPROTMISC        206
#define ERSQDKFUL         207
#define ERRESJOB          208
#define ERALARM           209
#define ERLOSTTABOVER     210
#define EREXTINT          211
#define ERNOIEEE          212
#define ERMVWRAPUP        213
#define ERUNLICENSED      214
#define ERPROTDB          215
#define ERARRDIM          216
#define ERNOCATCH         217
#define ERNOTFILVAR       218
#define ERNOTSELLST       219
#define ERCMPLXPAT        220
#define ERCLASSPROP       221
#define ERMAXLOCKS        222
#define ERLOCKFULL        223
#define ERSVRLOCKFULL     224
#define ERMAXROUTINES     225
#define EROUTOFHEAP       226
#define ERMAXINCR         227
#define ERWRONGNS         228
#define ERCALLBACKSYN     229
#define EROBJDISP         230
#define ERCOMMATCH        231
#define ERRTNLIMIT        232
#define ERZFMAXSTR        233
#define ERTOOCOMPLEX      234
#define ERINVALGLOBALREF  235
#define ERTCPWRITE        236
#define ERDIRNM           237
#define ERMTHDSUPPORT     238
#;      ;JO1945+
#ifdef  INCLSSVNCODE
#show
 ;GLUEDEF.INC
#;
#; The following are subroutines used by the
#; %SSVN* routines to take apart arguments and
#; format return strings. They are here so that
#; each routine can have a local copy to avoid
#; cross routine calls. Define INCLSSVNCODE before
#; including gluedef.inc if you want a copy of these.
#; 
 
errexit(err) ;
 i $d(zr) s $zr=zr ; restore $zr
 i $$$APPERROR(err) ; Creat exit with "err"
 ;
 ;
getNameExt(ref,name,ext,type,where) ;
#if 0   /*=======================DOCUMENTATION========================*/
 ; function get name and ext separatly from input parameter
 ; Input  : ref - ssvn array
 ; Output : name - name without extended reference
 ;          type - type extension references 
 ;                       1 - in [] one parameters 
 ;                       2 - in [] two parameters
 ;                      -1 - in || one parameters 
 ;                      -2 - in || two parameters
 ;                      -3 - ^|| private global reference    ;JO1844+
 ;                      -4 - ^|"^"| private global reference ;JO1844-
 ;          ext  - extended reference without "", [], ||
 ;                 if type 2 or -2
 ;                       first extension's part in ext(1)
 ;                       second                 in ext(2)
 ;                 if type 1 or -1 extension in ext
 ;               
 ;          where - 0 none
 ;                  1 before ssvn variable name
 ;                  2 inside 
 ;
 ; WARNING: now function work only for extended ref as part of ssvn reference (where=1)                
 ;
#endif  /*=====================End DOCUMENTATION======================*/
 k name,ext,type
 s ext=ref(1),type=ref(2),name=ref(4)
 if $$$USEPRIVATEGLOBALS,((type=-3)!(type=-4)) {
     s:type=-4 type=-1  ;change -4 to -1, leave -3 alone
     s ext="^"
 }
 s where=$s(type=0:0,1:1)
 q
 #;
 #; Return left delimeter in extension references 
#define DEL1(%t) $s(%t=1:"[",%t=-1:"|",%t=2:"[",%t=-2:"[",%t=-3:"|")
 #;
 #; Return right delimeter in extension references        
#define DEL2(%t) $s(%t=1:"]",%t=-1:"|",%t=2:"]",%t=-2:"]",%t=-3:"|")
 ;
retdata(return,typ) ; Change return for $DATA depend on typ
#if 0   /*=======================DOCUMENTATION========================*/
 ; Input: return - return $DATA
 ;        typ - see input parameters for $DATA ssvn
 ; Output: typ - 0 to indicate normal $DATA
 ;               1 to check for node value (return 0 for 0/10 or 1 for 1/11)
 ;               2 to check for descendants (return 0 for 0/1 or 1 for 10/11)
 ;               3 to check for node value or descendants (return 0 or 1 for 1/10/11)
#endif  /*=====================End DOCUMENTATION======================*/
 i $l(typ) d
 . i typ=1 s return=$s(return=0:0,return=10:0,1:1) q
 . i typ=2 s return=$s(return=0:0,return=1:0,1:1) q  
 . i typ=3 s return=$s(return=0:0,1:1) q
 e  d errexit($$$ERSYSER) ; system error
 q return
 ;
 ;        
retquery(return,type,where,what) ; Prepare return for $QUERY 
#if 0   /*=======================DOCUMENTATION========================*/
 ; Input: return
 ;        type
 ;        where
 ;        what   - GLOBAL, ROUTINE, JOB , LOCK            
#endif  /*=====================End DOCUMENTATION======================*/
 i $l(return) d
 . i where=0 s return="^$"_what_"("""_return_""")" q
 . s del1=$$$DEL1(type),del2=$$$DEL2(type)
 . i where=1 d  q
 . . i type=-3 s return="^$||"_what_"("""_return_""")" q
 . . i (type=1)!(type=-1) s return="^$"_del1_""""_ext_""""_del2_what_"("""_return_""")" q
 . . i (type=2) d  q
 . . . s ext1=$p(ext,"^",2)
 . . . s ext2=$p(ext,"^",3)
 . . . s return="^$"_del1_""""_ext2_""""_","_""""_ext1_""""_del2_what_"("""_return_""")" q
 . . i type=-2 s return="^$"_del1_""""_ext_""""_","_""""""_del2_what_"("""_return_""")" q
 q
 ;End of code from GLUEDEF.INC
#noshow
#endif ;INCSSVNCODE
#;      ;JO1945-
#endif  ; %syGluedef MEB034, HYY777