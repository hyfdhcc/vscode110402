ROUTINE SWITCHGET [Type=INC]
; %switchget.inc
#if 0   /*=======================Maintenance========================*/
#;CLEAN  11/16/05 Jeffrey Orlin, cleaned out old code
#;LRS974 08/19/05 Lee Smith, allow switch 0 (zero)
#;PWC936 12/02/04 Peter Cudhea, Use $System.Util.SwitchGet()
#;STC708 11/29/04 Steve Clay, moved from SWITCH.INC
#endif  /*=====================End Maintenance======================*/
  
  
#ifndef %switchget
#define %switchget
  
#include ST
 
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%swstat(sw,detail) ; Return the status of Switch (sw)...
 ;---------------------------------------------------------------------
 ;      sw - Switch number to return status about
 ;
 ;      If detail is NULL or 0 then RETURN: 0 - SWsw NOT set
 ;                                          1 - SWsw IS set
 ;                                         -1 - Error Occured
 ;      Else, RETURN: 0 - 0_$c(1)_"Swith sw is NOT set"
 ;                    1 - 1_$c(1)_{Detail about JOB who set SW10}
 ;                   -1 - -1_$c(1)_$ze
 ;
 ; **NOTE: When 'detail' is set, I pass a {-1,0,1} as the first $c(1)
 ;         piece of the return value so the user can do a 
 ;         +$$%swstat(1) comparison for a simple True/False test.
 ;---------------------------------------------------------------------
 s sw=+$g(sw),detail=+$g(detail)
 i sw<0 q $s(detail:-1_$c(1)_"Illegal Switch",1:-1)
 n bit,i,info,job10
 s info=""
 s $zt="%swerr^"_$zn,$ze=""
#;PWC936+
 Set i=$System.Util.GetSwitch(sw)
 i +i=0 q $s(detail:0_$c(1)_"Switch "_sw_" is NOT set.",1:0)
 i sw=10 s job10=$p(i,",",2),info=" Set by JOB #: "_job10_"  ("_$v(-1,job10)_")"
 q $s(detail:1_$c(1)_"Switch "_sw_" IS set."_info,1:1)
#;PWC936-
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%swerr   ; Some error occured when doing a Switch 10 Status...
 s $zt=""
 q $s(detail:-1_$c(1)_$ze,1:-1)
#endif %switchget
 