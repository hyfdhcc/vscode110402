ROUTINE ShmObj [Type=INC]
#show 
 ;%ShmObj.INC ; JLC1084 11/07/07
#noshow 
#;============================Maintenance=============================
#; JLC1084 11/07/07 Jose' Cordeiro, support 1K NLS pages
#; JLC360  8/22/01 Jose' Cordeiro, fix loading of xltdefault when SHMOFFBYTES=8
#; CFL204 12/11/99 Carlos Lopes, fix JLC180 (it broke INSTALL.MAC)
#; JLC180 12/06/99 Carlos Lopes, fix table loading for Big Endian machines
#; JLC062 11/23/98 Jose' Cordeiro, define constants for ^%shm unification
#; SJ1150  5/10/97 Scott Jones, substantially rewrote this file
#; LRS168  5/06/97 Lee Smith, initial creation
#;==========================End Maintenance===========================
 
#;      Defines for shared memory and for NLS usage
 
#;      <<< WARNING >>>
#;      These defines mirror those in the system code header files,
#;      such as mconst.h, nls.h, mchar.h, etc.  Any changes must be
#;      made to both places.
 
#;      Object types
 
#define OBJINVALID      0
#define OBJBYTE         1
#define OBJUINT2        2
#define OBJUINT4        3
#define OBJUINT8        4
#define OBJCNT1         5
#define OBJCNT2         6
#define OBJSTRUCT4      7
#define OBJSTRUCT8      8
#define OBJSTRUCTOFF    9
#define OBJPAG1         10
#define OBJPAG2         11
#define OBJPAG4         12
#define OBJPAG8         13
#define OBJPAKBYT2      14
#define OBJPAKBYT4      15
#define OBJPAKBYT8      16
#define OBJPAKWRD4      17
#define OBJPAKWRD8      18
#define OBJPAGOFFT      19
#define OBJ1KPAG1       20
#define OBJ1KPAG2       21
#define OBJ1KPAG4       22
#define OBJ1KPAG8       23
#define OBJ1KPAKBYT2    24
#define OBJ1KPAKBYT4    25
#define OBJ1KPAKBYT8    26
#define OBJ1KPAKWRD4    27
#define OBJ1KPAKWRD8    28
#define OBJ1KPAGOFFT    29
 
#define OBJNames "Invalid,byte,uint2,uint4,uint8,ByteStr,WordStr,Struct4,Struct8,StructOFF,Page1,Page2,Page4,Page8,Packed2,Packed4,Packed8,PakWrd4,PakWrd8,PageOff,1KPage1,1KPage2,1KPage4,1KPage8,1KPacked2,1KPacked4,1KPacked8,1KPakWrd4,1KPakWrd8,1KPageOff"
 
#define OBJsimple(%typ) (+$E("11111100011111111101111111110",%typ))
#define OBJprimitive(%typ) (+$E("1111",%typ))
#define OBJstruct(%typ) (+$E("000000111",%typ))
#define OBJeleswp(%typ) (+$E("0123010000123123230012312323",%typ))
#define OBJelesiz(%typ) $S(%typ>4!(%typ=3):$ZU(40,0,25),1:$A($C(1,2,4,8),%typ))
 
#define OBJload(%typ,%val) $ZU(126,0,%typ,%val)
#define OBJswap(%ele,%val) $ZU(126,1,%ele,$$Pad(%val,%ele))
#define OBJpack(%val) $E($ZQC(%val),1,$ZU(40,0,25))
#define OBJalign(%val,%typ) $E($ZQC(0),1,(6-$L(%val))#$$$OBJelesiz(%typ))
#define OBJcrc(%val) $ZCRC(%val,7)
 
#define OBJofft32 $C(19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19)
 
#define SHMObj          "Obj"
#define SHMSrc          "Src"
#define SHMHsh          "Hsh"
#define SHMOff          "Off"
 