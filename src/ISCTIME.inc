ROUTINE ISCTIME [Type=INC]
;ISCTIME.INC  -- extrinsic function to display time in hh:mm am/pm
#if 0   /*=======================Maintenance========================*/
#;RJW2230 08/21/14 Ron Watt, ^%ERN shows confusing 00:xx pm
#;RJW2154 08/15/13 Ron Watt, Change format of times displayed by ^%ERN1 for values between Midnight and one AM 
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;LFT782 11/15/99, Laura Tillem, combine this with ZTime.inc
#endif  /*=====================End Maintenance======================*/      
#ifndef ISCTIME
#define ISCTIME
 
Time(s) N h,m,a S a=" am",h=s\3600,m=s\60#60 S:h>11 a=" pm" s:h>12 h=h-12 S:'h h="00"
 Q ($J(h,2)_":"_$E(100+m,2,3)_a)
#if 1  ;LFT782+
Timelength(T) N D,H,M,S,X S X="",D=T\86400,T=T#86400,H=T\3600,T=T#3600,M=T\60,T=T#60
 S:'H&(D=1) D=0,H=24 S X=$$Tadd(D,"day",1)_$$Tadd(H,"hour",1)
 Q X_$$Tadd(M,"minute")_$J(T,2)_" second"_$E("s",T'=1)
Tadd(n,t,c) Q $S($G(c)&'n:"",1:$J(+n,2)_" "_t_$E("s",n'=1)_",  ")
#endif ;LFT782-
 
#endif ISCTIME