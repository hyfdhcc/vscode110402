ROUTINE ISCPATRN [Type=INC]
;ISCPATRN.INC  code for returning a pattern match string --> changes parameter!
 
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
BB400    04/23/92. Ben Bishop: using bluck-structure DO to limit to one tag
#endif  /*=====================End Maintenance======================*/
 
#ifndef ISCPATRN
#define ISCPATRN
 
#if 0    ; BEB400+
PATRN(X) N q,i,x,c S q=0,x="" F i=1:1:$L(X) S c=$E(X,i) S:c="""" c=c_c D Pat
 S:q x=x_"""" S X=$P($P($P($P(X,"?"),"#"),"&"),"*") Q x ;return ?@x
Pat I "*?&#"'[c S x=x_$S(q:c,1:"1"""_c),q=1 Q  ;simple text -- no pattern
 S x=x_$E("""",q)_$S(c="&":"1A",c="#":"1N",c="*":".E",1:"1E"),q=0 Q
 ; & -> 1 alpha; # -> 1 number; ? -> 1 anything; * -> infinite anythings
#else    ; BEB400=
PATRN(X) N q,i,x,c S q=0,x="" F i=1:1:$L(X) S c=$E(X,i) S:c="""" c=c_c DO
 . I "*?&#"'[c S x=x_$S(q:c,1:"1"""_c),q=1 Q  ;simple text -- no pattern
 . S x=x_$E("""",q)_$S(c="&":"1A",c="#":"1N",c="*":".E",1:"1E"),q=0 Q
 ; & -> 1 alpha; # -> 1 number; ? -> 1 anything; * -> infinite anythings
 S:q x=x_"""" S X=$P($P($P($P(X,"?"),"#"),"&"),"*") Q x ;return ?@x
#endif 0 ; BEB400-
 
#endif ISCPATRN