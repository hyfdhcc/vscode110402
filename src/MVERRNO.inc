ROUTINE MVERRNO [Type=INC]
#;
#; Cache MV Error Message Definitions
#;
#; The multivalue system has myriad error numbers that programs rely on
#; remaining the same and sometimes in the same output format.
#; This file encapsulates the error message numbers that programs and runtime
#; functions written in C must use.
#;
#; This is the master list of error numbers and each number can be in one of 4
#; states.
#; 1. Fully defined - In Use - message in ERRMSG
#; 2. Fully defined - In Use - message in ERRMSG but commented out in here
#;    only used from C
#; 3. Missing - The existing pick message may be needed. Add entry if required. 
#; 4. Available - There was no Pick message or it was not relevant to our
#;    architecture.
#;    (eg Assembler, Batch, Workspace, Card Reader, Runoff Messages)
#;
#;
#; See mverrno.h for C Equivalents
#;
#;----------------------------------------
#;
#; Missing terminating string delimiter
#; 
#define MVEMISSINGCLOSEQUOTE 2
#;
#; Not a Verb
#; 
#define MVENOTAVERB 3
#;
#; Available
#; 
#;define MVE 4
#;
#; Bad Dict Item
#; 
#define MVEBADDICTITEM 5
#;
#; Available
#; 
#;define MVE 6
#;
#; Available
#; 
#;define MVE 8
#;
#; File Name Missing
#; 
#define MVEFILENAMEMISSING 10
#;
#; Available
#; 
#define MVENOATTRIBUES 11
#;
#; Too many execute Levels
#; 
#define MVETOOMANYEXECUTES 20
#;
#; Available
#; 
#;define MVE 21
#;
#; Available
#; 
#;define MVE 22
#;
#; Available
#; 
#;define MVE 23
#;
#; Available
#; 
#;define MVE 28
#;
#; error in format of verb
#; 
#define MVEBADVERBFORMAT 30
#;
#; basic pointer missing routine name
#; 
#define MVEMISSINGTARGET 31
#;
#; Recursive keyword definition
#; 
#define MVELOOPINGDEFN 32
#;
#; Available
#; 
#;define MVE 33
#;
#; Available
#; 
#;define MVE 34
#;
#; Available
#; 
#;define MVE 35
#;
#; Available
#; 
#;define MVE 36
#;
#; Available
#; 
#;define MVE 37
#;
#; Available
#; 
#;define MVE 38
#;
#; Available
#; 
#;define MVE 39
#;
#; Available
#; 
#define MVENOTCOMPILED 40
#;
#; Available
#; 
#define MVENOPROGRAM 41
#;
#; Available
#; 
#;define MVE 42
#;
#; Available
#; 
#;define MVE 43
#;
#; Available
#; 
#;define MVE 44
#;
#; Available
#; 
#;define MVE 45
#;
#; Available
#; 
#;define MVE 46
#;
#; Available
#; 
#;define MVE 47
#;
#; Available
#; 
#;define MVE 48
#;
#; Available
#; 
#;define MVE 49
#;
#; Available
#; 
#;define MVE 50
#;
#; Available
#; 
#;define MVE 51
#;
#; Available
#; 
#;define MVE 52
#;
#; Available
#; 
#;define MVE 53
#;
#; Available
#; 
#;define MVE 54
#;
#; Available
#; 
#;define MVE 55
#;
#; Available
#; 
#;define MVE 56
#;
#; Available
#; 
#;define MVE 57
#;
#; Available
#; 
#;define MVE 58
#;
#; Available
#; 
#;define MVE 59
#;
#; Available
#; 
#;define MVE 60
#;
#; Available
#; 
#;define MVE 61
#;
#; Available
#; 
#;define MVE 62
#;
#; Available
#; 
#;define MVE 63
#;
#; Available
#; 
#;define MVE 65
#;
#; Available
#; 
#;define MVE 66
#;
#; Available
#; 
#;define MVE 67
#;
#; Available
#; 
#;define MVE 69
#;
#; Available
#; 
#;define MVE 70
#;
#; Available
#; 
#;define MVE 72
#;
#; Available
#; 
#;define MVE 74
#;
#; Available
#; 
#;define MVE 75
#;
#; Available
#; 
#;define MVE 76
#;
#; Available
#; 
#;define MVE 77
#;
#; Available
#; 
#;define MVE 78
#;
#; Available
#; 
#;define MVE 79
#;
#; Available
#; 
#;define MVE 80
#;
#; Available
#; 
#;define MVE 81
#;
#; Available
#; 
#;define MVE 83
#;
#; Available
#; 
#;define MVE 84
#;
#; Available
#; 
#;define MVE 85
#;
#; Available the 90's are tape 
#; 
#;define MVE 92
#;
#; Available
#; 
#;define MVE 95
#;
#; Available
#; 
#;define MVE 98
#;
#; Available
#; 
#;define MVE 100
#;
#; Available
#; 
#;define MVE 101
#;
#; Available
#; 
#;define MVE 102
#;
#; Available
#; 
#;define MVE 103
#;
#; Available
#; 
#;define MVE 104
#;
#; Available
#; 
#;define MVE 105
#;
#; Available
#; 
#;define MVE 106
#;
#; Available
#; 
#;define MVE 107
#;
#; Available
#; 
#;define MVE 108
#;
#; Available
#; 
#;define MVE 109
#;
#; Available
#; 
#;define MVE 110
#;
#; Available
#; 
#;define MVE 111
#;
#; Available
#; 
#;define MVE 112
#;
#; Available
#; 
#;define MVE 113
#;
#; Available
#; 
#;define MVE 114
#;
#; Available
#; 
#;define MVE 115
#;
#; Available
#; 
#;define MVE 116
#;
#; Available
#; 
#;define MVE 118
#;
#; Available
#; 
#;define MVE 119
#;
#; Available
#; 
#;define MVE 121
#;
#; Available
#; 
#;define MVE 122
#;
#; Available
#; 
#;define MVE 123
#;
#; Available
#; 
#;define MVE 124
#;
#; Available
#; 
#;define MVE 125
#;
#; Available
#; 
#;define MVE 126
#;
#; Available
#; 
#;define MVE 127
#;
#; Available
#; 
#;define MVE 128
#;
#; Available
#; 
#;define MVE 129
#;
#; Available
#; 
#;define MVE 130
#;
#; Available
#; 
#;define MVE 131
#;
#; Available
#; 
#;define MVE 132
#;
#; Available
#; 
#;define MVE 133
#;
#; Available
#; 
#;define MVE 134
#;
#; Available
#; 
#;define MVE 135
#;
#; Available
#; 
#;define MVE 136
#;
#; Available
#; 
#;define MVE 137
#;
#; Available
#; 
#;define MVE 138
#;
#; Available
#; 
#;define MVE 139
#;
#; Available
#; 
#;define MVE 140
#;
#; Available
#; 
#;define MVE 141
#;
#; Available
#; 
#;define MVE 142
#;
#; Available
#; 
#;define MVE 143
#;
#; Available
#; 
#;define MVE 144
#;
#; Available
#; 
#;define MVE 145
#;
#; Available
#; 
#;define MVE 146
#;
#; Available
#; 
#;define MVE 147
#;
#; Available
#; 
#define MVEDATEFORMATUS 148
#;
#; Available
#; 
#define MVEDATEFORMATINT 149
#;
#; Available
#; 
#define MVECENTURYDEFAULT 150
#;
#; Available
#; 
#define MVECENTURYGLOBAL 151
#;
#; Available
#; 
#define MVECENTURYPROCESS 152
#;
#; Available
#; 
#;define MVE 153
#;
#; Mvimport
#; 
#define MVEIMPORTDIFFNS 157
#;
#; Mvimport
#; 
#define MVEIMPORTEXISTNS 159
#;
#; Mvimport
#; 
#define MVEIMPORTNEWNS 160
#;
#; Mvimport
#; 
#define MVEACCOUNTEXISTS 161
#;
#; Mvimport
#; 
#define MVECONTINUEORQUIT 162
#;
#; Mvimport
#; 
#define MVENSEXISTS 164
#;
#; Mvimport
#; 
#define MVENSNOEXIST 165
#;
#; Available
#; 
#;define MVE 168
#;
#;  Syntax error in conversion code 
#;
#define MVECONVBADSYNTAX	169
#;
#; missing left Parenthesis
#; 
#define MVEMISSINGLEFTPAREN 170
#;
#;  missing Right Parenthesis
#; 
#define MVEMISSINGRIGHTPAREN 171
#;
#;  a conversion IF statement was missing an ELSE 
#;
#define MVEIFMISSINGTHEN 172
#;
#;  Expected a semi colon
#;
#define MVEMISSINGSEMICOLON 173
#;
#;  Expected a comma 
#;
#define MVEMISSINGCOMMA 174
#;
#; Itype not compiled
#; 
#define MVEITYPENOTCOMP 175
#;
#; Available
#; 
#define MVEEVALMISSINGEXP 176
#;
#; Available
#; 
#define MVEASMISSINGWHAT 177
#;
#; Available
#; 
#define MVEEVALCOMPILEFAILED 178
#;
#; Available
#; 
#define MVEMISSINGINTEGERPARAM 179
#;
#; n items processed
#; 
#define MVEITEMSPROCESSED 180
#;
#; N Messages Sent
#; 
#define MVEMESSAGESSENT 181
#;
#; Invalid Device
#; 
#define MVEINVALIDDEVICE 182
#;
#; Available
#; 
#define MVEPATHEXPECTED 183
#;
#; Available
#; 
#define MVECANNOTOPENPATH 184
#;
#; Available
#; 
#define MVENUMBEREXPECTED 185
#;
#; Available
#; 
#define MVEBADACORRNITEM 186
#;
#; Available
#; 
#define MVEMISSINGACORRNITEM 187
#;
#; Available
#; 
#;define MVE 188
#;
#; Available
#; 
#;define MVE 189
#;
#; Available
#; 
#;define MVE 190
#;
#; Available
#; 
#;define MVE 191
#;
#; Available
#; 
#;define MVE 192
#;
#; Available
#; 
#;define MVE 193
#;
#; Available
#; 
#;define MVE 194
#;
#; Not a list
#; 
#define MVENOTALIST 195
#;
#; Available
#; 
#define MVENODELTHISACC 196
#;
#; Full File Retrieval not allowed
#; 
#;define MVE 197
#;
#; Account Name?
#; 
#define MVEACCOUNTMISSING 198
#;
#; Available
#; 
#define MVEINTERNALERROR 199
#;
#; File Name Missing
#; 
#define MVEFILENAMEMISSING 200
#;
#; File not found/opened
#;
#define	MVEBADFILE        201
#;
#; Item not found
#;
#define	MVEITEMNOEXIST    202
#;
#; Item Name Missing
#; 
#define MVEITEMNAMEMISSING 203
#;
#; Missing data section name
#; 
#define MVESECTIONNAME 205
#;
#; Data Section not found
#; 
#define MVESECTIONNOEXIST 206
#;
#; Available
#; 
#define MVEMISSINGLISTNUMBER 207
#;
#; Available
#; 
#define MVEACCOUNTDELETED 208
#;
#; Available
#; 
#define MVELISTNUMBERRANGE 209
#;
#; Available
#; 
#define MVEINDEXNAME 211
#;
#; iNDEX DOES NOT EXIST
#; 
#define MVENOSUCHIDX 212
#;
#; Unknown Backup format
#; 
#define MVEUNKNOWNBACKUP 213
#;	
#; MVIMPORT already running
#; 
#define MVEMVIMPORTRUNNING 214
#;
#; Available
#; 
#define  MVEDATABASEMAPPED 215
#;
#; Available
#; 
#;define MVE 216
#;
#; Available
#; 
#;define MVE 217
#;
#; Available
#; 
#;define MVE 218
#;
#; Available
#; 
#;define MVE 219
#;
#; <Item> exited from file <file> - (ED)
#; 
#define MVEEDITEMEXIT 220
#;
#; <Item> filed in file <file> - (ED)
#; 
#define MVEEDITEMFILED 221
#;
#; <Item> deleted from file <file> - (ED)
#; 
#define MVEEDITEMDEL 222
#;
#; Available
#; 
#;define MVE 224
#;
#; Available
#; 
#;define MVE 225
#;
#; Available
#; 
#;define MVE 226
#;
#; PrintCatalog Info Message
#; 
#define MVECATDIFFILEO 227
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATNOOBJO 228
#;
#; Account name is invalid - 1 param, being the account name
#;
#define	MVEBADACC         229
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATSOURCE 230
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATNORMAL 231
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATLOCAL 232
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATGLOBAL 233
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATBADACC 234
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATNOOBJ 235
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATOBJ 236
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATOBJO 237
#;
#; PrintCatalog Info Message
#; 
#define MVEPRTCATSOURCEO 239
#;
#; No Select List Active (from save list)
#; 
#define MVENOSELECTLIST 240
#;
#; <item> Cataloged.
#; 
#define MVECATALOGED 241
#;
#; <item> decataloged
#; 
#define MVEDECATALOGED 242
#;
#; <item> Cataloged Local.
#; 
#define MVELOCALCATALOGED 243
#;
#; <item> Cataloged Global.
#; 
#define MVEGLOBALCATALOGED 244
#;
#; List Deleted
#; 
#;define MVE 245
#;
#; Available
#; RRMSG
#;define MVE 246
#;
#; List saved
#; 
#define MVELISTSAVED 247
#;
#; Don't panic
#; 
#define MVEDONTPANIC 248
#;
#; Don't Do that
#; 
#;define MVEDONTDOTHAT 249
#;
#; Punt
#; 
#;define MVEPUNT 250
#;
#; done
#; 
#;define MVEDONE 251
#;
#; Available
#; 
#;define MVE 252
#;
#; Available
#; 
#;define MVE 253
#;
#; Available
#; 
#;define MVE 254
#;
#; Available
#; 
#;define MVE 255
#;
#; ElapsedTime
#; 
#define MVEELAPSEDTIME 256
#;
#; No Match
#; 
#define MVENOMATCH 257
#;
#; Available
#; 
#;define MVE 257
#;
#; Available
#; 
#;define MVE 258
#;
#; Available
#; 
#;define MVE 259
#;
#; Available
#; 
#;define MVE 260
#;
#; Available
#; 
#;define MVE 261
#;
#; Available
#; 
#;define MVE 262
#;
#; Available
#; 
#;define MVE 263
#;
#; Available
#; 
#;define MVE 264
#;
#; Available
#; 
#;define MVE 265
#;
#; Available
#; 
#;define MVE 266
#;
#; Proc Transfer failed
#; 
#;define MVE 267
#;
#; Proc GO - dest not found
#; 
#;define MVE 268
#;
#; Proc invalid operand of value
#; 
#;define MVE 269
#;
#; Proc format error
#; 
#;define MVE 270
#;
#; Proc Missng target for GO/Proc transfer
#; 
#;define MVE 271
#;
#; Proc compile failed
#; 
#;define MVE 272
#;
#; Proc invalid pattern match operator
#; 
#;define MVE 273
#;
#; Proc - unsupported command
#; 
#;define MVE 274
#;
#; Proc - unknown user exit
#; 
#;define MVE 275
#;
#; Proc - Too many labels found in the PROC
#; 
#;define MVE 276
#;
#; Available
#; 
#;define MVE 277
#;
#; Available
#; 
#;define MVE 278
#;
#; Available
#; 
#;define MVE 279
#;
#; Available
#; 
#;define MVE 280
#;
#; Available
#; 
#;define MVE 281
#;
#; Available
#; 
#;define MVE 282
#;
#; Available
#; 
#;define MVE 283
#;
#; Available
#; 
#;define MVE 284
#;
#; Available
#; 
#;define MVE 285
#;
#; Available
#; 
#;define MVE 286
#;
#; Available
#; 
#;define MVE 287
#;
#; Available
#; 
#;define MVE 288
#;
#; Term Display
#; 
#;define MVETERMDISPLAY 289
#;
#; Range of parameter not acceptable
#; 
#;define MVE 290
#;
#; Available
#; 
#;define MVE 291
#;
#; Available
#; 
#;define MVE 292
#;
#; Available
#; 
#;define MVE 293
#;
#; Available
#; 
#;define MVE 294
#;
#; Available
#; 
#;define MVE 295
#;
#; Available
#; 
#;define MVE 296
#;
#; Available
#; 
#;define MVE 297
#;
#; Format Error in Specification
#; 
#;define MVE 298
#;
#; Available
#; 
#;define MVE 299
#;--------------------------------
#; only actively used messages from here for now.
#;
#; ED - Item is locked by ...
#; 
#define MVEITEMLOCKEDBY 310
#;
#; Logon Prompt message
#; 
#define MVELOGONPROMPT 330
#;
#; Logon Welcome message
#; 
#define MVELOGGEDON 335
#;
#; Logged Off Message
#; 
#define MVELOGGEDOFF 336
#;
#; Connect Statistics
#; 
#;define MVE 340
#;
#; Multiple Using clauses
#; 
#define MVEMULTIPLEUSINGS 351
#;
#; Multiple Using clauses in Macro
#; 
#define MVEMULTIMACROUSINGS 352
#;
#; Using not followed by a filespec
#;
#define MVEUSINGWHAT 353
#;
#; Bad Macro
#;
#define MVEBADMACRO 354
#; No items present
#;
#define	MVNOITEMS        401
#;
#; Cannot overwrite File Defn
#; 
#define MVENOOVRFILEDEF 402
#;
#; One item listed
#; 
#define MVEONEITEMLISTED 403
#;
#; <n> items selected
#; 
#define MVEITEMSSELECTED 404
#;
#; <n> items listed
#; 
#define MVEITEMSLISTED 405
#;
#; ISTAT OUTPUT
#; 
#;define MVE 406
#;
#; <n> items counted
#; 
#define MVEITEMSCOUNTED 407
#;
#; One item counted
#; 
#define MVEONEITEMCOUNTED 408
#;
#; data secrtion already exists
#; 
#define MVEDATASECTEXISTS 409
#;
#; Cannot use a Q pointer for this statement
#; 
#;define MVENOUSEQPOINTER 410
#;
#; file name Exists in Voc
#; 
#define MVEFILEEXISTSINVOC 413
#;
#; Exists on File
#; 
#define MVEEXISTSONFILE 415
#;
#;File Created
#; 
#define MVEFILECREATED 417
#define	MVEFILECREATEDNS	"417NS"
#; messages 418 - 422 file stats
#;
#;Total of <attr> = <value>
#; 
#define MVETOTAL 423
#;
#; No Items deleted
#; 
#define MVENOITEMSDELETED 430
#;
#; One Items deleted
#; 
#define MVEONEITEMSDELETED 431
#;
#; Items deleted
#; 
#define MVEITEMSDELETED 432
#;
#; File cleared
#;
#define MVEFILECLEARED 433
#; messages 450 - 700 mainly spooler
#;
#; Syntax error in F corr 
#define	MVECONVBADFCORR	701
#;
#; Missing right bracket ']' 
#;define MVEMISSINGRIGHTBRACKET 702
#;
#;  Error in C conversion 
#;define MVECONVCERROR		703
#;
#; Translate code was invalid 
#define MVEINVALIDTRANSCODE 706
#;
#; The F correlative stack was popped one too many times. 
#;define MVEFCORRSTACKUNDERFLOW 713
#;
#; The F correlative stack was pushed one too many times. 
#;define MVEFCORRSTACKOVERFLOW 714
#;
#; Format mask exceeds max 256 
#;define MVEFORMATTOOLONG 723
#;
#; Length conversion exceeds maximum of 32k 
#;define MVEPARAMTOOBIG 724
#;
#; F correlative exceeds limit of 200 opcodes
#;define MVEFCORRTOOBIG 725
#;
#; Invalid substitute code 
#;define MVEINVALIDSUBSTITUTECODE 726
#;
#; Invalid char position in Text extract 
#;define MVEBADFIELDSPEC 727
#;
#; Invalid code in format Spec 
#;efine MVEBADFORMATCODE 728
#;
#; Too many ranges specified in range conversion 
#;define MVECONVTOOMANYRANGES 729
#;
#; Unrecognised characters at end of conversion code 
#;define MVECONVTRAILINGLINT 730
#;
#; A;N(xxx) cannot compile because the DICT was not opened
#;define MVEDICTNOTOPEN 731
#;
#; Error in conversion code Attr7 in item
#define MVEDICTATTR7ERROR 732
#;
#; Error in conversion code Attr8 in item
#define MVEDICTATTR8ERROR 733
#;
#; The generated object code exceeded the allocated buffer size 
#;define MVECONVCODEOVERFLOW 800
#;
#; the year digits specified on the date conversion were not a cache compatible code. 
#define MVEBADYEARDIGITS 801
#;
#; Missing a separator 
#;define MVEMISSINGSEP	804
#;
#; n items copied 
#define MVEITEMSCOPIED	805
#;
#; Conversion code finished too sooon 
#;define MVEEARLYTERMINATION 807
#;
#;
#; Account exists - 1 param, being the account name
#;
#define MVEACCEXISTS      810
#;
#; Error in CREATE-ACCOUNT - 1 param, being the account name
#;
#define	MVEACCERR         811
#;
#; Invalid emulation name supplied - 1 param, being the emulation asked for
#;
#define	MVEBADEMU         812
#;
#; Displays the current emulation type
#;
#define MVEEMULATION      813
#;
#; Account created successfully - 1 param, being the name of the account
#;
#define	MVEACCCREAT       814
#;
#; Cannot change emulation type of the SYSPROG account 
#;
#define	MVENOCHNGSP       815
#;
#; PORT USERNAME  for WHO
#;
#define MVEPORTUSER       816
#;
#; PORT ACCOUNT (User) for WHO
#;
#define MVEPORTACCUPAR    817
#;
#; PORT ACCOUNT From USER  for WHO
#;
#define MVEPORTACCFU      818
#;
#; SELECTINFO, list # out of range
#;
#define	MVESELINFORANGE	 819
#;
#; SELECTINFO, key out of range
#;
#define	MVESELINFOKEY	 820
#;
#; SELECT, invalid list #
#;
#define	MVESELECTLIST	 821
#;
#; AttachAccounts sucess
#;
#define	MVEACCATTACHED	 822
#;
#; Long strings not enabled
#;
#define	MVELONGSTRINGS	 823
#;
#; Invalid trigger event specified
#;
#define MVEINVTRIGEVENT		824
#;
#; Invalid trigger subroutine specified
#;
#define MVEINVTRIGSUBR		825
#;
#; Trigger is already installed, use Overwrite to replace it
#;
#define MVETRIGEXIST		826
#;
#; Trigger install was succesful
#;
#define MVETRIGSUCCESS		827
#;
#; Trigger delete was succsful
#;
#define MVETRIGDELETE		828
#;
#; Missing Port Number
#;
#define MVEMISSINGPORT		829
#;
#; Port Not logged on
#;
#define MVEPORTNOTON		830
#;
#; Insufficient Privs
#;
#define MVENOPRIV		831
#;
#; Port Logged OFF
#;
#define MVELOGGEDOFF		832
#;
#; General A corrN failure
#;
#define MVEACORRNFAILED		833
#;
#; @FILENAME was null
#;
#define MVEATFNNULL		834
#;
#; eRROR CREATING DIRECTORY
#;
#define MVCREATEDIRFAILED       835
#;
#; Bad package name for class
#;
#define MVEBADPACKAGENAME       836
#;
#; bad class name
#;
#define MVEBADCLASSNAME       837
#;
#; date format width exceeds max
#;
#define DATEFORMATWIDTH       838
#;
#; date format text string length exceeds max
#;
#define DATEFORMATTEXT       839
#;
#; transactions rolled back
#;
#define MVEROLLBACK       840
#;
#; No dict items
#;
#define MVEDICTEMPTY      841
#;
#; No indexes defined
#;
#define MVENOINDEXES      842
#;
#; Shell Access Denied
#;
#define MVESHELLDENIED      843
#;
#; SYSPROG Access Denied
#;
#define MVESYSPROGDENIED      844
#;
#; Insufficient privs
#;
#define MVEPRIVERROR      845
#;
#; No access to database
#;
#define MVEACCOUNTNOACCESS      846
#;
#; Cannot copy F pointer between VOCs
#;
#define MVEFPOINTERNOCOPY      847
#;
#; Invalid routine name
#;
#define MVEBADROUTINE		848
#;
#; Invalid user exit
#;
#define MVEUSEREXITUNK 849
#;
#; TRAP.EXCEPTIONS staus message
#define MVETRAPEXCEPT		853
#;
#; TRAP.EXCEPTIONS ON|OFF previous staus
#define MVETRAPEXCEPTPREV	854
#;
#;
#;define MVECONVUNIMP	855
#;
#; Multiple occurences of same MVNAME in class
#;
#define MVEMULTIMVNAME	856
#;
#; Trying to create an index but the name is already in use
#;
#define MVEINDEXNAMEINUSE	857
#;
#; Trying to build an index when the file is not an inode file.
#;
#define MVEWRONGFILETYPE	858
#;
#; Trying to create an index it already exists
#;
#define MVEINDEXEXISTS	859
#;
#; index deleted message
#;
#define MVEINDEXDELETED	860
#;
#; no index deleted message
#;
#define MVENOINDEXESDELETE	861
#;
#; no index deleted message
#;
#define MVEATTRNOMISMATCH	862
#;
#; no index deleted message
#;
#define MVEITYPEMISMATCH	863
#;
#; no index deleted message
#;
#define MVETYPEMISMATCH	864
#;
#; no index deleted message
#;
#define MVEATTR8MISMATCH	865
#;
#; index created message
#;
#define MVEINDEXCREATED	866
#;
#; index(ES) built message
#;
#define MVEINDEXBUILT	867
#;
#; index(ES) build failed
#;
#define MVEINDEXBUILDFAILED	868
#;
#; Multi/Single Value mismatch - currently MV
#;
#define MVECURRENTMV	869
#;
#; Multi/Single Value mismatch - currently S
#;
#define MVECURRENTSV	870
#;
#; No class associated with file
#;
#define MVENOFILECLASS	871
#;
#; Unable to open compiled class associated with file
#;
#define MVECOMPCLASSFAIL	872
#;
#; Invalid collation name
#;
#define MVEBADCOLLATION	873
#;
#; Index Type not supported by MVBasic
#;
#define MVEUNSUPIDXTYPE	874
#;
#; Property name is in use
#;
#define MVEPROPNAMEINUSE	875
#;
#; Itype code contains system delimiters
#;
#define MVEITYPESYSDELIM	876
#;
#; The SP-ASSIGN has been used to clear a single print queue assignment
#;
#define	MVESPASSIGNONE		877
#;
#; The SP-ASSIGN has been used to clear all print queue assignments
#;
#define	MVESPASSIGNALL		878
#;
#; The Class is locked against modification
#;
#define	MVECLASSLOCKED		879
#;
#; The printer channel defined with 'LPTR nnn' is out of range
#;
#define	MVELPTRRANGE		880
#;
#; The operation was terminated by control C
#;
#define	MVCTRLC			881
#;
#; Trying to perform a spooler operation, but it is already locked.
#;
#define MVESPLOCKED		882

