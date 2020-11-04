ROUTINE ISCYESNO [Type=INC]
;;code for asking a yes/no question -- returns either Y or N
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
RJW1158	 ;08/05/05, Ron Watt, Dejournal only those databases currently marked journaled.
BEB407   ;04/29/92, Ben Bishop -- restructure to allow third argument
         ;          which allows specification of a timeout
#endif  /*=====================End Maintenance======================*/
 
#ifndef ISCYESNO
#define ISCYESNO
 
#if 0    ; BEB407+
 
YN(T,D) N X,R S T=$G(T),D=$E($G(D)_"?") S:T="" T="Yes or No"
YN2 W !,T_"? "_$S("Nn"[$e(D):"No => ","Yy"[$e(D):"Yes => ",1:"") R R
 S X=$$UC($E(R_D_"?")) I "^YN"'[X W "?? Yes or No, please" G YN2
 S POP=0 I X="^" S POP=1 Q $E(D_"N") ;in case of ^ try to treat as a punt
 W $E($S(X="N":"No",X="Y":"Yes",1:""),$L(R)+1,3) Q X
 
#include ISCUC
 
#else    ; BEB407=
 
YN(P,D,t) N R,X S P=$G(P),D=$E($G(D)_"?"),t=$G(t) ;ask Yes/No w/ Prompt,Default
 S D=$S("Yy"[D:"Yes => ","Nn"[D:"No => ",1:"") ;Yes, No or no default
 F  W !,P_"? "_D Read:t R:t Read:'t R DO  I "^YN"[R Q  ;timed or non-timed read
 . S X=R,R=$TR($E(R_D_"?"),"yn","YN") I "^YN"'[R W "  enter Yes or No, please"
 S POP=(R="^") W $E($S(R="N":"No",R="Y":"Yes",1:""),$L(X)+1,3) Q R
 
#endif 0 ; BEB407-
 
#ifdef ZYESNONEVER
 
YNN(P,D,t) N R,X S P=$G(P),D=$E($G(D)_"?"),t=$G(t) ;ask Yes/No/Never w/ Prompt,Default
 S D=$S("Yy"[D:"Yes => ","Nn"[D:"No => ","Vv"[D:"Never => ",1:"") ;Yes, No, Never, or no default
 F  W !,P_"? "_D Read:t R:t Read:'t R DO  I "^YNV"[R Q  ;timed or non-timed read
 . S X=R,R=$TR($E(R_D_"?"),"ynv","YNV") I "^YNV"'[R W "  enter Yes or No, or V for Never, please"
 S POP=(R="^") W *8,$E($S(R="N":"No",R="Y":"Yes",R="V":"Never",1:""),$L(X),5) Q R
 
#endif
 
#ifdef ZYESNOALWAYS
 
YNA(P,D,t) N R,X S P=$G(P),D=$E($G(D)_"?"),t=$G(t) ;ask Yes/No/Always w/ Prompt,Default
 S D=$S("Yy"[D:"Yes => ","Nn"[D:"No => ","Vv"[D:"Never => ",1:"") ;Yes, No, Always, or no default
 F  W !,P_"? "_D Read:t R:t Read:'t R DO  I "^YNV"[R Q  ;timed or non-timed read
 . S X=R,R=$TR($E(R_D_"?"),"yna","YNA") I "^YNA"'[R W "  enter Yes or No, or Always, please"
 S POP=(R="^") W $E($S(R="N":"No",R="Y":"Yes",R="A":"Always",1:""),$L(X)+1,6) Q R
 
#endif
 
#endif ISCYESNO