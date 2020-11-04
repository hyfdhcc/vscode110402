ROUTINE %occCPTassert [Type=INC]

#include %occCPTconfig

#if $$$CPTASSERTIONS

#define CPTASSERTM(%item,%message) If '(%item) {Write:$X ! Write "*** Assertion Failed: ",$$$CMD," - ",%message,! BREAK}

#else

#define CPTASSERTM(%item,%message)

#endif

#define CPTASSERT(%item) $$$CPTASSERTM(%item,##quote(%item))

#; the current method name
#define METHODNAME ##safeexpression(""""_$Get(%methodname)_"""")

#; current class/method description (if any)
#define CMD $Select($This="":"",1:$This_":"_$$$METHODNAME)
