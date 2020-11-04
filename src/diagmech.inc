ROUTINE diagmech [Type=INC]
 ;diagmech.inc ;Diagnostician/mechanic related constants ; LFT744 8/04/99
  
#include SYSTEM
#include SITE
  
 ;old mech.inc: assorted variables for the MECH*.MAC utilities
  
#if 0   /*=======================Maintenance========================*/
SJ2958	 ;04/02/14 Scott Jones, cleaned out old global vector stuff
LFT744   ;08/04/99 Laura Tillem, use TYPEALLOWED and ISDATATYPE
STC200   ;02/27/99 Steve Clay: Removes site Is macro
VVS040   ;XXXXXXXX Vlad Skaletsky: Fixed for UNICODE View ($V) for -1, -2, -3 mode.
VGG195   ;06/19/95 Vadim Goldin, cleaned up old types
DKA247   ;04/06/95 Keith Avery, corrected calculation of RSIZE for 6.1
VGG138   ;07/11/94 Vadim Goldin, add Big Data (long string) for TYPENAME
SSG009   ;10/21/92 Susan Gibbs; changed MAPSIZE definition from double to word
#endif  /*=====================End Maintenance======================*/
  
#include VIEW
  
 ;allocation map is the first block of each map (1, 401, 801, etc)
 ;allocation word is 1 byte wide for each block in the map
  #define MAPBLK(%b)     (%b-1\Dsiz*Dsiz+1)
  #define MAPPTR(%b)     (%b-1#Dsiz)
  #define ZAPVAL         255
  #define ZAPTYP         $$$VBYT
  #define ZAPOFF         1
  #define NUMMAPS        $$$GETAWRD(1026)
  #define MAPSIZE        $$$GETADBL(1060)
  
 ;ZAP values are from the allocation map
#define GETZAP(%i)       $V(%i*$$$ZAPOFF,0,$$$ZAPTYP)
#define SETZAP(%i,%v)    V (%i*$$$ZAPOFF):0:$$$ZAPTYP:%v
  
 ;   checkpoint uses $V(,-7,,) to start from a given checkpoint
#define CHECKPOINT(%a)   $V($P(%a,",",3),-7,$P(%a,",",4),Dsiz)
  
 ;   N3BYTE is 256^3
#define N3BYTE           16777216
  
 ;   1st label pair: 21845 = 5555hex   2nd label pair: 43690 = AAAAhex
#define LABEL1VIEW       $$$GETAWRD(2040)
#define LABEL1VALUE      21845
#define LABEL1SET        $$$SETAWRD(2040,$$$LABEL1VALUE)
  
#define LABEL2VIEW       $$$GETAWRD(2042)
#define LABEL2VALUE      43690
#define LABEL2SET        $$$SETAWRD(2042,$$$LABEL2VALUE)
  
  
 ;need a conversion from block type to output name
#define TYPENAME(%t)     $S(%t=1:"Global Dir.",%t=2:"Pointer",%t=6:"Bot.Ptr.",%t=8:"Data",%t=12:"Big Data",%t="16":"Routines",%t="160":"Map Block",1:"Unknown type")
  
#;LFT744
#define TYPEALLOWED(%type) ((%type=1)!(%type=2)!(%type=6)!(%type=8)!(%type=12)) 
#define ISDATATYPE(%type) ((%type=8)!(%type=12))
 
 ;include the error definitions
#include diagerrdef
  
 ;the VAL and REF variables need to be globals for M/11+
#define NOVAL       K VAL
#define VAL(%a)     VAL(%a)
#define NOREF       K REF
#define REF(%a)     REF(%a)
  