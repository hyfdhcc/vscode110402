ROUTINE VIEW [Type=INC]
#ifndef %view
#define %view
  
#if 0   /*=======================Maintenance========================*/
VVS041   ;04/08/97, Vlad Skaletsky: Added addreses for block parts
VGG138   ;07/12/94. Vadim Goldin: long strings - read pointer with 'Big' flag
DKA212   ;11/19/93, Keith Avery: Added get and set functions for collation
DPB139   ;07/09/93, Dan Smith, Add $$$GET3PNT and $$$ISBIGPNT.
         ;          Use $$$GET3PNT when threading a bottom-pointer block.
PWC232   ;05/26/93, Peter Cudhea, Support for Long Strings
#endif  /*=====================End Maintenance======================*/
  
  
#if 1   ;VVS041+    link, Type, offset, ... addresses
; block structure constants
#define INFOBYTE   2036
#define GARBA      2036
#define GARBAM1    2035
#define LINKA      2040
#define TYPEA      2043
#define TYPEAM1    2042
#define BLOOF      2046
#define LASTWORDA  2044
#define HDBLSIZE   2048
#define HDBLSIZEM1 2047
#endif  ;VVS041-
  
  
;%view.inc
;useful codings to avoid using view commands
  
#define VBYT      1
#define VWRD      "2O"
#define VPNT      "3O"
#define VDBL      "4O"
  
#define PARVEC(%X,%Y)    $V(%X,-1,%Y)
#define SYSVEC(%X,%Y)    $V(%X,-2,%Y)
#define MEMVEC(%X,%Y)    $V(%X,-3,%Y)
#if 0   /*======================Documentation=======================*/
DPB139   ; NOTE: To extract a pointer from a bottom-pointer-block when
         ; processing global structures, use $$$GET3PNT, _not_ $$$GETPOINT
#endif  /*====================End Documentation=====================*/
  
;how to get values
#define GETBYTE(%n)      $V(%n,0,$$$VBYT)
#define GETWORD(%n)      $V(%n,0,$$$VWRD)
#define GETAWRD(%n)      $V(%n,0,2)
#define GETPOINT(%n)     $V(%n,0,$$$VPNT)
#define GETDOUBLE(%n)    $V(%n,0,$$$VDBL)
#define GETADBL(%n)      $V(%n,0,4)
#define GETSTRING(%n,%l) $V(%n,0,-%l)
  
#define SETBYTE(%p,%v)   V %p:0:$$$VBYT:%v
#define SETWORD(%p,%v)   V %p:0:$$$VWRD:%v
#define SETAWRD(%p,%v)   V %p:0:2:%v
#define SETPOINT(%p,%v)  V %p:0:$$$VPNT:%v
#define SETDOUBLE(%p,%v) V %p:0:$$$VDBL:%v
#define SETADBL(%p,%v)   V %p:0:4:%v
  
#if 1   ;VVS041+
#define SETHREE(%p,%v)   V %p:0:3:%v
#endif  ;VVS041-
  
  
#define LINK             $$$GETPOINT(2040)
#define TYPE             $$$GETBYTE(2043)
#define SIZE             $$$GETAWRD(2046)
#define GARB             $$$GETDOUBLE(2036)
#if 1    ; DKA212+
#define COLL             $$$GETBYTE(2044)
#endif   ; DKA212-
  
;how to view blocks in and out
#define READ(%b)         V (%b)
#define WRITE(%b)        V -(%b)
  
;shorthands to set the standard values
#define SETLINK(%l)      $$$SETPOINT(2040,%l)
#define SETTYPE(%t)      $$$SETBYTE(2043,%t)
#define SETSIZE(%s)      $$$SETAWRD(2046,%s)
#define SETGARB(%g)      $$$SETDOUBLE(2036,%g)
#if 1    ; DKA212+
#define SETCOLL(%c)      $$$SETBYTE(2044,%c)
#endif   ; DKA212-
  
#if 1   ;VVS041=
#define SET3LINK(%l)      $$$SETHREE(2040,%l)
#define SET4GARB(%g)      $$$SETADBL(2036,%g)
#define SET3GARB(%g)      $$$SETHREE(2036,%g)
#endif  ;VVS041-
  
  
;global directory values given an offset into the table
#define GTYPE(%i)        $$$GETWORD(%i)
#define GPROT(%i)        $$$GETBYTE(%i+2)
#define GGROW(%i)        $$$GETPOINT(%i+3)
#define GROOT(%i)        $$$GETPOINT(%i+6)
#define GSIZE            9
  
;shorthands for using the $V(,-5) and $V(,-6) modes
#define VIEWREF(%n)      $V(%n*2-1,-5)
#define VIEWCHK(%n)      $V(%n*2-1,-6)
#define VIEWVAL(%n)      $V(%n*2,-5)
#if 1    VGG138+
#define VIEWBIG(%n)      $V(%n*2,-6)
#endif   VGG138-
#define LASTREF          $V(-1,-5)
#define LASTCHK          $V(-1,-6)
  
#if 1    ;PWC232
; GBIGPNT indicates that a pointer value points to a big data node
#define GBIGPNT 8388608
#endif   ;PWC232 
#if 1    ;DPB139   Note: $ZB(A,B,2) = A and (not B), i.e. $$$BITCLEAR(A,B)
#define GET3PNT(%n) $ZBOOLEAN($$$GETPOINT(%n),$$$GBIGPNT,2)
#define ISBIGPNT(%n) ($ZBOOLEAN($$$GETPOINT(%n),$$$GBIGPNT,1)'=0)
#endif