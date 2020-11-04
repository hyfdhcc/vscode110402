ROUTINE %occSqlfunc [Type=INC]
#ifndef %occSqlfuncinc
#define %occSqlfuncinc
#define ALPHAUP(%s) $zu(28,%s,6)
#define MVR(%s) $zu(28,%s,2)
#define SQLSTRINGT(%s,%l) $zu(28,%s,8,%l)
#define SQLUPPERT(%s,%l) $zu(28,%s,7,%l)
#define STRINGT(%s,%l) $zu(28,%s,9,%l)
#define TRUNCATET(%s,%l) $e(%s,1,%l)
#define UPPER(%s) $zu(28,%s,5)
#define MaxStringLength 3641144
SQLUPPER(v,l) { quit $$$SQLUPPERT(v,$g(l,32767)) }
ALPHAUP(v,r) { quit $$$ALPHAUP(v) }
STRING(v,l) { quit $$$STRINGT(v,$g(l,32767)) }
SQLSTRING(v,l) { quit $$$SQLSTRINGT(v,$g(l,32767)) }
UPPER(v) { quit $$$UPPER(v) }
MVR(v) { quit $$$MVR(v) }
TRUNCATE(v,l) { quit $$$TRUNCATET(v,$g(l,$$$MaxStringLength)) }
#endif