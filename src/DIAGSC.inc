ROUTINE DIAGSC [Type=INC]
 ;DIAGSC.inc
 ; include file for the FAST integrity checker implementation
 ; original design provided by Paul Rowny of Compucare
 
#if 0   ;/*=======================Maintenance========================*/
 ;LFT1322 11/08/4, Laura Tillem, replace ^%utility($j) with ^CacheTempJ($j)
 ;JO1092 11/08/98, Jeffrey Orlin, improve performance by storing information
 ;                 in bitstrings rather than in character arrays.
 ;JO1091 11/06/98, Jeffrey Orlin, added some constants for CHKINCMAP
 ;DVU202 10/06/95, Dmitry Umansky Support for Large Files (>900000 blk)
 ;DPB139 07/12/93, Dan Smith Add block type definitions
 ;           Add #include COPYRIGH, #show comment line, move #includes 
 ;                 inside #ifndef, change #ifndef variable from FASTIC 
 ;                 to DIAGSC
#endif  ;/*=====================End Maintenance======================*/
 
#ifndef DIAGSC
#define DIAGSC
 
#show   ;DPB139+
 ;DIAGSC.INC DPB139, 07/12/93
#noshow ;DPB139-
 
#include COPYRIGH   ; DPB139
#include SITE
#include VIEW
 
#if 0   ;JO1092+
#define K2            250
#define K3            1018
#define LEN           509
#define MAXBLOCK      900000
 
 ;The block map information is kept in a dense-pack type-2 local
 ;array. Each entry equals a 509 character string which will contain
 ;1018 block values.  On the DG this represents about 900,000 blocks
 ;or about 1.8 Gbytes of database.
 ;The object is to have any number of 1st level values, with 250
 ;(or so) subscripts at each of the upper levels.
 
#define S1(%b)        (%b\$$$K3\$$$K2)
#define S2(%b)        (%b\$$$K3#$$$K2)
#define S3(%b)        (%b-1#$$$K3+2\2)
 
 ;so, for any block 'n', it maps to position  'map(n\63000,n\1018#250)'
 ;and position  'n-1#1018+2\2'   in the resulting string.
 
#define OFF(%b)      $S(%b#2:16,1:1)
 
#if 1    ;DVU202+
#define VAL(%b)      $A(@MAP@($$$S1(%b),$$$S2(%b)),$$$S3(%b))\$$$OFF(%b)
#else    ;DVU202= 
#define VAL(%b)      $A(MAP($$$S1(%b),$$$S2(%b)),$$$S3(%b))\$$$OFF(%b)
#endif   ;DVU202-
 
 ;Balloc indicates that the block is IN USE in the SAT MAP
#define Balloc       1
#define ChkUsed(%b)  $$$VAL(%b)\1#2
 
 ;Bdownp indicates that the block has been pointed to from above
#define Bdownp       2
#define ChkDown(%b)  $$$VAL(%b)\2#2
 
 ;Bright indicates that the block has been pointed to from the left
#define Bright       4
#define ChkLink(%b)  $$$VAL(%b)\4#2
 
 ;Bvspec indicates that the block has a valid block type
#define Bbtype       8
#define ChkType(%b)  $$$VAL(%b)\8#2
 
#else   ;JO1092=
 ; This block map information is kept either in a local
 ; array or in a global on disk (depending on the size of the
 ; database). The structure of the information is the same:
 ;       @MAP(<type index>)@(offset)
 ; where
 ;       MAP(0)="MAP0",MAP(1)="MAP1",MAP(2)="MAP2"... and
 ;       MAP0/MAP1/MAP2/MAP3 = local variab;es that contains the names
 ;               of the local arrays (or global nodes) that defines the storage
 ;               (depending on database size)
 ;       type index = Balloc (block is inuse in the satmap)
 ;                  = Bdownp (blocks is pointed to from above)
 ;                  = Bright (block is pointed to from the left)
 ;                  = Bbtype (block has a valid block type)
 ;       offset = <block #>\<BITSTRMAX>
 ;
 ; BITSTRMAX is the # of bits in a single string. Empirically I've
 ; found that a string length around 512 bytes gives the best
 ; performance both for globals and for locals. We use a size of
 ; 509 bytes as that packs four bitstrings into a global block.
 ; If we introduce a ZBITSTR command (eg. in place bit set) then
 ; longer strings will probably give better performance.
 ;
 ; 4072 bits = 509 bytes * 8 bits/bytedefine BITSTRMAX 4072
#define BITSTRMAX 4072
 ;
 ; Both block #'s and bit #'s are 1 based so for any block 'n' it 
 ; maps to:
 ;  $ZBITGET(MAP(<type index>,(n-1)\BITSTRMAX),(n-1)#BITSTRMAX+1)
 ;                       -or-
 ;  $ZBITGET(MAP(<type index>,$$$OFFSET(n)),$$$BITNUM(n))
 ;
 ; OFFSET is 0 based, BITNUM is one based
 ;
#define OFFSET(%n) ((%n-1)\$$$BITSTRMAX)
#define BITNUM(%n) ((%n-1)#$$$BITSTRMAX+1)
 
 ; Use these to set or retrieve the entire "bitmap" for a given
 ; offset. SetOff is used when initializing the arrays in
 ; ^DIAGSC and GetOff is used in analyzing the resutls in ^DIAGSC8
#define SetOff(%type,%offset,%val) s @MAP(%type)@(%offset)=%val
#define GetOff(%type,%offset) @MAP(%type)@(%offset)
 
 ; type index definitions. These are the "sub lists" of @MAP@ where
 ; we track different types of information about each block. Each
 ; type has a macro to manipulate it
 
 ;Balloc indicates that the block is IN USE in the SAT MAP
#define Balloc 0
#define ChkUsed(%off,%bit) $ZBITGET(MAP0(%off),%bit)
#define SetUsed(%off,%bit) s MAP0(%off)=$ZBITSET(MAP0(%off),%bit,1)
#define ChkUsedG(%off,%bit) $ZBITGET(^CacheTempJ($J,0,%off),%bit)
#define SetUsedG(%off,%bit) s ^CacheTempJ($J,0,%off)=$ZBITSET(^CacheTempJ($J,0,%off),%bit,1)
 
 ;Bdownp indicates that the block has been pointed to from above
#define Bdownp 1
#define ChkDown(%off,%bit) $ZBITGET(MAP1(%off),%bit)
#define SetDown(%off,%bit) s MAP1(%off)=$ZBITSET(MAP1(%off),%bit,1)
#define ChkDownG(%off,%bit) $ZBITGET(^CacheTempJ($J,1,%off),%bit)
#define SetDownG(%off,%bit) s ^CacheTempJ($J,1,%off)=$ZBITSET(^CacheTempJ($J,1,%off),%bit,1)
 
 ;Bright indicates that the block has been pointed to from the left
#define Bright 2
#define ChkLink(%off,%bit) $ZBITGET(MAP2(%off),%bit)
#define SetLink(%off,%bit) s MAP2(%off)=$ZBITSET(MAP2(%off),%bit,1)
#define ChkLinkG(%off,%bit) $ZBITGET(^CacheTempJ($J,2,%off),%bit)
#define SetLinkG(%off,%bit) s ^CacheTempJ($J,2,%off)=$ZBITSET(^CacheTempJ($J,2,%off),%bit,1)
 
 ;Bbtype indicates that the block has a valid block type
#define Bbtype 3
#define ChkType(%off,%bit) $ZBITGET(MAP3(%off),%bit)
#define SetType(%off,%bit) s MAP3(%off)=$ZBITSET(MAP3(%off),%bit,1)
#define ChkTypeG(%off,%bit) $ZBITGET(^CacheTempJ($J,3,%off),%bit)
#define SetTypeG(%off,%bit) s ^CacheTempJ($J,3,%off)=$ZBITSET(^CacheTempJ($J,3,%off),%bit,1)
 
 ;MAXTYPE is the highest value of type we use for loops
#define MAXTYPE $$$Bbtype
#endif  ;JO1092- 
 
 ;MAP LABELS
 ;1st label pair: 21845 = 5555hex   2nd label pair: 43690 = AAAAhex
#define LABEL1VIEW       $$$GETAWRD(2040)
#define LABEL1VALUE      21845
#define LABEL2VIEW       $$$GETAWRD(2042)
#define LABEL2VALUE      43690
 
#if 1    ; DPB139+
 
#if 0   ;/*======================Documentation=======================*/
 ; Extracted from globals.h w/;'s added to make syntax checker happy
#define NORMALBLK       1       ;/* Any kind of block with a standard 12-byte
                         ;          header at the end of the block */
#define NOTALLOCBLK     0xFE    ;/* Set into a map block to indicate that this
                         ;          particular block is not physically
                         ;          allocated to the database (eg. this is
                         ;          a short map) */
#define SATMAPBLK       0xFD    ;/* This is a SAT map block */   /* SPJ880+ */
#define INCINDEXBLK     0xFC    ;/* This is an INC backup file index block */
#define INCMAPBLK       0xFB    ;/* This is an INC backup bitmap block */
#define BLOBINDEXBLK    0xFA    ;/* This is a BLOB index block */
#define BLOBDATABLK     0xF9    ;/* This is a BLOB data block */ /* SPJ880- */
#define LABELBLK        0xF8    ;/* This is a label block */     /* SPJ888+ */
#define MAPBLOCK        0xF7    ;/* This is a non-label map block */
#define BADBLOCK        0x80    ;/* This is a BAD block */       /* SPJ888- */
#endif  ;/*====================End Documentation=====================*/
 
 ;MAP BLOCK ALLOCATION TYPE CODES, based on globals.h 07/12/93
#define NORMALBLK       1
#define NOTALLOCBLK     $ZH("FE")
#define SATMAPBLK       $ZH("FD")
#define INCINDEXBLK     $ZH("FC")
#define INCMAPBLK       $ZH("FB")
#define BLOBINDEXBLK    $ZH("FA")
#define BLOBDATABLK     $ZH("F9")
#define LABELBLK        $ZH("F8")
#define MAPBLOCK        $ZH("F7")
#define BADBLOCK        $ZH("80")
 
#endif   ; DPB139-
 
#if 1   ;JO1091+
 ; INCRCONTIGBLKS = # of contigious incr bitmap blocks 
#define INCRCONTIGBLKS  4 
 ; GFINCOFF = start of incr block #'s in label
#define GFINCOFF (1024+760)
#endif  ;JO1091-
 
#endif  DIAGSC