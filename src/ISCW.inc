ROUTINE ISCW [Type=INC]
;include file to write text with quoted control/special characters
 
#ifndef ISCW
#define ISCW
 
W(X) I X?.ANP Q X ;string conversion
 N ii,c,a,q,s S s="""",q=1 F ii=1:1:$L(X) S c=$E(X,ii),a=$A(c) DO
 . ;I a<32 S s=s_$S(q>0:"""_",q<0:")_",1:"")_"^"_$C(a+64),q=0 Q
 . I (a<32)!(a>126) S s=s_$S(q>0:"""_$c(",q<0:",",1:"_$c(")_a,q=-1 Q
 . S:a=34 c=c_c S s=s_$S(q<0:")_""",q>0:"",1:"_""")_c,q=1 Q
 S s=s_$S(q<0:")",q>0:"""",1:"") S:$E(s,1,3)="""""_" s=$E(s,4,$L(s)) Q s
 
#endif ISCW