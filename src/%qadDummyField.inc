ROUTINE %qadDummyField [Type=INC]
 ;%qadDummyField.INC ; $$dummy function determines is a field is dummy field
         #;
#IF 0    ;
         ;---------------------------------------------------------------------
         ; Description:   determines is a field is dummy field
         ; Author:        David Van De Griek
         ; Date:          February 3, 1998
         ; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
         ;
         ;  DPV811 (02/03/98) - Initial creation of entire include file
         ;
         ;---------------------------------------------------------------------
         ;                         INFORMATION
         ;---------------------------------------------------------------------
         ;
         ;---------------------------------------------------------------------
#ENDIF   ;
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
dummy(ifn,irn) ; entry point to determine if a field is dummy or not
         #; we answer 1 if dummy 0 if not dummy
         #; if irn is undefined we get it from the "ifn" index
         n computed,inrowid,onmap,parid,rowid
         #; if ifn ill defined quit it as dummy
         i ifn'?1n.n QUIT 1
         i '$d(irn) s irn=$p(^mdd(1,"ifn",ifn),$c(1),2)
         #; if the irn is invalid quit it as dummy
         i irn'?1n.n QUIT 1
         #; check if computed and on map
         s computed=$p($g(^mdd(1,irn,2,ifn,5)),$c(1),2)="Y"
         s onmap=$s($d(^mdd(1,irn,2,ifn,51)):1,$d(^mdd(1,irn,2,ifn,52)):1,1:0)
         #; check if rowid (if icol=1) or inrowid
         s rowid=$p($g(^mdd(1,irn,2,ifn,1)),$c(1),3)=1
         s inrowid=(","_$p($g(^mdd(1,irn,2,^mdd(1,irn,"col",1),33)),$c(1),2)_",")[(","_ifn_",")
         s parid=(ifn=$g(^mdd(1,irn,"col",0)))  ; maybe it's the parent id
         #; if not comp and not on map and not(rowid or in rowid) it's dummy
         i 'computed,'onmap,'(rowid!inrowid!parid) QUIT 1
         #; it's not dummy
         QUIT 0
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-