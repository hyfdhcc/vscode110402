ROUTINE BITWISE [Type=INC]
#ifndef BITWISE
#define BITWISE
#show
 ; BITWISE.INC, DPB139 07/09/93
#noshow
 
#if 0   /*======================Documentation=======================*/
         ; Front end for $ZBOOLEAN
         ; Defensively parenthesized for good evaluation order if args
         ; are expressions and if macros are included in expressions
         ; + signs to force numeric interpretation
#endif  /*====================End Documentation=====================*/
 
#define BITAND(%A1,%A2) ($ZBOOLEAN(+(%A1),+(%A2),1))
#define BITCLEAR(%A1,%A2) ($ZBOOLEAN(+(%A1),+(%A2),2))
#define BITXOR(%A1,%A2) ($ZBOOLEAN(+(%A1),+(%A2),6))
#define BITOR(%A1,%A2) ($ZBOOLEAN(+(%A1),+(%A2),7))
#define BITNOT(%A1) ($ZBOOLEAN(+(%A1),0,12))
 
#endif
 