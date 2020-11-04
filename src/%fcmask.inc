ROUTINE %fcmask [Type=INC]
#IF 0   ; DPV1486+
MASK(val) s val=$tr(val,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678","xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx999999999") n jj f jj=1:1:$l(val) i $a(val,jj)>127,$zname($e(val,jj)) s $e(val,jj)="x"
#ELSE   ; DPV1486=
MASK(val) s val=$tr(val,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678"_$s('$g(%COSParse):"",1:"$:'"""),"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx999999999"_$s('$g(%COSParse):"",1:"xxxx")) n jj f jj=1:1:$l(val) i $a(val,jj)>127,$zname($e(val,jj)) s $e(val,jj)="x"
#ENDIF  ; DPV1486-
 QUIT val
 