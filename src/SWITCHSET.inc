ROUTINE SWITCHSET [Type=INC]
; %switchset.inc
  
#if 0   /*=======================Maintenance========================*/
#;CLEAN  11/16/05 Jeffrey Orlin, cleaned out old code
#;LRS974 08/19/05 Lee Smith, allow switch 0 (zero)
#;PWC936 12/02/04 Peter Cudhea, Use $System.Util.SwitchGet()
#;STC708 11/29/04 Steve Clay, moved from SWITCH.INC
#endif  /*=====================End Maintenance======================*/
  
  
#ifndef %switchset
#define %switchset
  
#include ST
%swset(sw,val,detail) ; Set Switch (sw) to (val - {0,1})...
 ;---------------------------------------------------------------------
 ;      sw   - Switch number to set
 ;      val  - Value to set the SWITCH to: {0,1}
 ;
 ;      If detail is NULL or 0 then RETURN: 0 - SWsw WAS set
 ;                                          1 - SWsw WAS NOT set
 ;                                         -1 - Error Occured
 ;      Else, RETURN: 0 - 0
 ;                    1 - 1
 ;                   -1 - -1_$c(1)_$ze
 ;
 ; **NOTE: When 'detail' is set, I pass a {-1,0,1} as the first $c(1)
 ;         piece of the return value so the user can do a 
 ;         +$$%swset(1) comparison for a simple True/False test.
 ;---------------------------------------------------------------------
 s sw=+$g(sw),val=+$g(val),detail=+$g(detail)
 i sw<0 q $s(detail:-1_$c(1)_"Illegal Switch",1:-1)
 i val'=0,val'=1 q $s(detail:-1_$c(1)_"Illegal Switch Value",1:-1)
 s $zt="%swseter^"_$zn,$ze=""
#;PWC936+
 If +$System.Util.GetSwitch(sw)=val q 1
 Do $System.Util.SetSwitch(sw,val)  ;Also maintains job # for job 10
 If +$System.Util.GetSwitch(sw)=val q 1
#;PWC936-
 q 0
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%swseter ; Some error occured when Setting Switch (sw) to (val)...
 s $zt=""
 q $s(detail:-1_$c(1)_$ze,1:-1)
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#endif %switchset
 