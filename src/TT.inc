ROUTINE TT [Type=INC]
#;%TT                                                   ;HYY080 4/24/97
#ifndef %TT
#define %TT
#if 0    /*==========================Maintenance=============================*/
HYY080 ;04/24/97, Huayong Yang, split %TT into %TT, %TT1, %TT2, and %TT.INC
CFL002 ;11/04/96, Carlos Lopes: Test tercap definitions
#endif   /*========================End Maintenance===========================*/
 
 ;
fill d msg("Testing /fill")
 i test<4 w /fill(1,1,mc,ml,".")
 e  d
 . n l f l=1:1:ml-1 w /cup(l,1),fill
 . w /cup(ml,1),$e(fill,1,mc-1)
 w /cup(l2,c2) r r:1 q
 ;
ruler(l) w /cup(l,1),$e(ruler,1,mc),/cup(l,c2) q
 ;
vruler n l f l=1:1:ml w /cup(l,1) w:l<10 0 w l
 q
 ;
msg(m) n x,y s x=$x,y=$y
 i msg=1 w /wuse(1),/clr,?65-$l(m)\2,m,/wrefresh,/wuse(2)
 e  w /cup(1,1),/eol,?80-$l(m)\2,m,/wrefresh
 w /cup(y+1,x+1) q
 ;
msg2(m1,m2) w /cup(3,20),m1,/eol,/cup(4,20),m2,/eol q
 ;
center(m) w /clr,/cup(tml\2,tmc-$l(m)\2),m,/wrefresh q
 ;
display(m) n ml,mc
 s ml=$zu(119,42,0,7),mc=$zu(119,42,0,6)
 w /cup(ml\2,mc-$l(m)\2),m,/wrefresh q
#endif  %TT