ROUTINE DBREST [Type=INC]
#show
 ;DBREST.INC, LRS227 05/19/98
#noshow
#; LRS227 05/19/98 Lee Smith, substitute use of $TR() for case conversion
 
#if 0   ; LRS227+
UC(x) Q $TR(x,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
#else   ; LRS227=
#include ISCUC
#endif  ; LRS227-
 ;check  for stop text function
STOP(x) S x=$$UC($E(x,1,4)) Q (x["EXIT")!(x["STOP")!(x["QUIT")!(x["HALT")!($E(x)="^")
 
 
#if 0   /*======================Documentation=======================*/
 ; $$YESNO(default)
 ; read a yes/no response
 ; input: 1 => yes, 0 => no
 ; return: 1 => yes, 0 => no
#endif  /*====================End Documentation=====================*/
 
YESNO(a) N v,b S a=$G(a)  F  DO  Q:$D(v)
 . W *-1,$S(a:" Yes",1:" No")_" => " R b I b="" S v=a Q
 . S b=$TR($E(b),"yn","YN") I "YN"[b S v=(b="Y") Q
 . W *7," [answer Yes or No, please]" I $x>68 W !
 Q v
 
#if 0    ; DPB144+
 ;------------------------------------------------------------------
 ;DBshow.INC      --  display backup specific text
Show(fld) ;display the text in field 'fld' (^SYS("BACKUP","TEXT",fld,*))
 N i S i=0 F  S i=$O(^SYS("BACKUP","TEXT",fld,i)) Q:i=""  W !,^(i)
 Q
 ;------------------------------------------------------------------
#else    ; DPB144=
 
#if 0   /*======================Documentation=======================*/
 ; Show("item"[,P1[,P2,[,P3,[P4]]]])
 ; dbr("item") contains item text, uses long strings, stores
 ;     multiple lines in a single string.  Each string
 ;     begins with, and does NOT end with, CR+LF.  Each
 ;     string may contain up to three # which are replaced
 ;     by P1-P4 respectively.  See DBRTEXT.MAC and DBRTEXT.INC
#endif  /*====================End Documentation=====================*/
 
 
Show(item,p1,p2,p3,p4) ;
 n d,i,p0,p,tx s d="#",tx=$g(dbrtext(item)) w !
 i tx="" w !,*7,"MISSING DBRTEXT ITEM ",item q
 f i=0:1:4 s p="p"_i w $p(tx,d,i),$g(@p)
 q 
 
 