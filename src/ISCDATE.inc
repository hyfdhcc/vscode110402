ROUTINE ISCDATE [Type=INC]
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;HYY110 07/14/97 Huayong Yang, created to attack Y2K issue
 
#ifndef ISCDATEinc
#define ISCDATEinc
 
#define ZD(%a) $ZDATE(%a,1,,4)
 ;replace $ZD(%a)
#define ZD0(%a) $ZDATE(%a,2,,4)
 ;replace $ZD(%a,0)
#define ZD1(%a) $ZDATE(%a,1,,4)
 ;replace $ZD(%a,1)
#define ZD2(%a) $ZDATE(%a,2,,4)
 ;replace $ZD(%a,2)
#define ZD0L(%a,%b) $ZDATE(%a,2,%b,4)
 ;replace $ZD(%a,0,%b)
#define ZD2L(%a,%b) $ZDATE(%a,2,%b,4)
 ;replace $ZD(%a,2,%b)
 
#endif ;%ZDATEinc