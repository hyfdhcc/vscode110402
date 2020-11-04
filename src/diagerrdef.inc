ROUTINE diagerrdef [Type=INC]
;error definitions for DIAG/MECH utilities
#if 0   /*=======================Maintenance========================*/
LFT542  ;01/12/98, Laura Tillem, fix long string block checking
LRS181   ;08/06/97, Lee Smith: Cache' nomenclature changes
BEB419   ;05/19/92, Ben Bishop: added $G(DIRNAM)_"|" infront of global names
#endif  /*=====================End Maintenance======================*/
  
;LINK error: 'block' has a link pointer of 'actual' but was expected
;            to have a link pointer of 'expected'
#define Qlink            "SUSPECT LINK POINTER"
#define Nlink            1
#define Elink(%b,%e,%a,%p) Elink(%b,%e,%a,%p)
#define Llink            Elink(block,expected,actual,parent)
#define Vlink            $$$Nlink_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(expected)_"^"_$G(actual)_"^"_$G(parent)
  
;BLOCK TYPE error: block is type 'actual' but should have been 'expected'
;                  'parent' is the parent of 'block' (if available)
#define Qtype            "SUSPECT BLOCK TYPE"
#define Ntype            2
#define Etype(%b,%e,%a,%p) Etype(%b,%e,%a,%p)
#define Ltype            Etype(block,expected,actual,parent)
#define Vtype            $$$Ntype_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(expected)_"^"_$G(actual)_"^"_$G(parent)
  
;SELF-POINTER error: node 'node' in block 'block' points to itself
#define Qself            "SELF-POINTER IN BLOCK"
#define Nself            3
#define Eself(%b,%n,%p)  Eself(%b,%n,%p)
#define Lself            Eself(block,node,parent)
#define Vself            $$$Nself_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(node)_"^"_$G(parent)
  
;NULL POINTER error: node 'node' in pointer block 'block' is null.
#define Qnull            "NULL POINTER IN BLOCK"
#define Nnull            4
#define Enull(%b,%n,%p)  Enull(%b,%n,%p)
#define Lnull            Enull(block,node,parent)
#define Vnull            $$$Nnull_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(node)_"^"_$G(parent)
  
;ALLOCATION error: 'block' is marked as unallocated in 'mapblk'
#define Qalloc           "BLOCK NOT ALLOCATED IN MAP"
#define Nalloc           5
#define Ealloc(%b,%m)    Ealloc(%b,%m)
#define Lalloc           Ealloc(block,mapblk)
#define Valloc           $$$Nalloc_"^"_$G(block)_"^"_$G(mapblk)
  
;LABEL error: block is the map block, label1/label2 were the existing labels
#define Qlabel           "SUSPECT MAP LABEL"
#define Nlabel           6
#define Elabel(%b,%x,%y) Elabel(%b,%x,%y)
#define Llabel           Elabel(block,label1,label2)
#define Vlabel           $$$Nlabel_"^"_$G(block)_"^"_$G(label1)_"^"_$G(label2)
  
;COLLATION SEQUENCE error: if fblock=lblock=block, then first]last nodes
;                          otherwise last-node of fblock follows the first
;                          node of lblock
#define Qcolseq          "SUSPECT COLLATION SEQUENCE"
#define Ncolseq          7
#define Ecolseq(%b,%f,%l,%p) Ecolseq(%b,%f,%l,%p)
#define Lcolseq          Ecolseq(block,fblock,lblock,parent)
#define Vcolseq          $$$Ncolseq_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(fblock)_"^"_$G(lblock)_"^"_$G(parent)
  
;BAD BLOCK error: block does not satisfy format (i.e. $V(0,0)'=0, etc)
#define Qbad             "BAD STRUCTURE IN BLOCK"
#define Nbad             8
#define Ebad(%b,%n,%p,%e) Ebad(%b,%n,%p,%e)
#define Lbad             Ebad(block,node,parent,error)
#define Vbad             $$$Nbad_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(node)_"^"_$G(parent)_"^"_$G(error)
  
;DIRECTORY error: directory does not exist
#define Qnodir           "DIRECTORY DOES NOT EXIST"
#define Nnodir           9
#define Enodir(%d)       Enodir(%d)
#define Lnodir           Enodir(dirnam)
#define Vnodir           $$$Nnodir_"^"_$G(dirnam)
  
;GLOBAL REFERENCE error: global references don't match, parent-child
#define Qgref            "MIS-MATCHED POINTER-CHILD GLOBAL REFERENCE"
#define Ngref            10
#define Egref(%b,%p,%n)  Egref(%b,%p,%n)
#define Lgref            Egref(block,parent,node)
#define Vgref            $$$Ngref_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(parent)_"^"_$G(node)
  
;GENERIC error: database degrades, block numbers, etc
#define Qerror           "HARD READ ERROR"
#define Nerror           11
#define Eerror(%b,%p,%e) Eerror(%b,%p,%e)
#define Lerror           Eerror(block,parent,error)
#define Verror           $$$Nerror_"^"_$G(DIRNAM)_"|"_gloname_"^"_$G(block)_"^"_$G(parent)_"^"_$G(error)
  
;ROUTINE error: routine's initial bytes don't match pointer reference
#ifdef  CACHENAMES ; LRS181+
#define Qrout            "Cache ObjectScript Compiled Code failure"
#else    ; LRS181=
#define Qrout            "COS-code failure"
#endif   ; LRS181-
#define Nrout            12
#define Erout(%b,%p,%r)  Erout(%b,%p,%r)
#define Lrout            Erout(block,parent,ref)
#define Vrout            $$$Nrout_"^"_$G(block)_"^"_$G(parent)_"^"_$G(ref)
  
;NOTTOP error: root block has a link pointer -- so it isn't a root block
#define Qntop            "NOT TOP LEVEL BLOCK"
#define Nntop            13
#define Entop(%n,%b,%l)  Entop(%n,%b,%l)
#define Lntop            Entop(name,block,link)
#define Vntop            $$$Nntop_"^"_$G(name)_"^"_$G(block)_"^"_$G(link)
#if  1 ;LFT542+
;Pointer block gives different type than data block, one is a big string
#define Nbigerr          14
#endif ;LFT542-        