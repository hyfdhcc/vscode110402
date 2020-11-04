ROUTINE ISCSWSET [Type=INC]
         ;
         ;ISCSWSET.inc - switch set subroutine for people who can't call ^SWSET
         ;
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
JO1984   ;11/16/05 Jeffrey Orlin, use $SYSTEM.Util methods to set/check/clr 
         ;switches.
HYY302   ;04/21/99, Huayong Yang: use +$J instead of $J when necessary
         ; NOTE -- (DPBS 06/16/93) -- don't use for new work just yet.
         ; Created for use in, and called by, DBREST, but parallels
         ; %switch.inc.  
JAO580   ;6/09/93 Jeffrey Orlin, created this include file. In
         ;                the view command use a length of 4 bytes not 2
         ;                bytes to avoid endian problems
#endif  /*=====================End Maintenance======================*/
SWSET   do $SYSTEM.Util.SetSwitch(%SW,%VAL)
	quit
         ;------------------------------------------------------------------
         ;set10  -- sets switch 10
SET10   do $SYSTEM.Util.SetSwitch(10,1)
        quit
         ;------------------------------------------------------------------
         ;clear10  --  sets switch 10 to 0
CLEAR10 do $SYSTEM.Util.SetSwitch(10,0) 
        quit
         ;------------------------------------------------------------------
         ;check10 - check to see if switch 10 is set & we own it.
CHECK10() n res
	s res=$SYSTEM.Util.GetSwitch(10)
	if '+res quit 0  ; not owned
	; 2nd piece is $J of owner.
	if +$P(res,",",2)'=+$J quit 0  ; not owned by us
	quit 1  ; set and owned by us
 