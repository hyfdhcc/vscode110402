ROUTINE %PMML [Type=INC]
/// Utility
#define PROPERTYNAME(%p) $s(+$zstrip(%p,"*PWC"):"p"_$zstrip(%p,"*PWC"), 1:$zstrip(%p,"*PWC"))
#define STATUSPROPERTYNAME(%p) "%"_%p_"Status"

#define DUMMYFIELD(%f) (%f="RawResult")

#define CAMELSPACE(%in,%out) s %out="",l=$l(%in),pu=1 f p=1:1:l { s c=$e(%in,p),u=((c=$$$UPPER(c))&&'$isvalidnum(c)),%out=%out_$s(u&&'pu:" ",1:"")_c,pu=u }

#define QUOTEIFRESERVED(%spec) set:$system.SQL.IsReservedWord($piece(%spec,".",*)) %spec = $s($find(%spec,"."):$piece(%spec,".",1,*-1)_".", 1:"")_$$$QUOTE($piece(%spec,".",*))