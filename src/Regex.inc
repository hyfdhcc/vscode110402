ROUTINE Regex [Type=INC]
#;
#include %syGluedef
#;
#;===============================Maintenance==========================
#;
#; SOH389  7/31/13 Steven Hobbs, Add RequiredPrefix support
#; SOH326  4/04/12 Steven Hobbs, Added error message symbols REu* and REm*
#; SOH303  1/02/12 Steven Hobbs, Added REUErrorCode
#; SOH291 11/28/11 Steven Hobbs, Created defs for Regular Expressions API
#;=============================End Maintenance========================
#;
#;	Macros for Regular Expression handling functions
#;
#; Definitions of uregex_* routines defined in uregex.h by the ICU libraries
#; But also see eregex.c for definitions of zu*regex routines
#define REclose(%regex) $ZU(74,0,%regex)
#define REopen(%pat) $ZU(74,1,%pat)
#define REclone(%regex) $ZU(74,2,%regex)
#define REsetText(%regex,%text) $ZU(74,3,%regex,%text)
#define REsetText8(%regex,%text) $ZU(74,16,%regex,%text)
#define REmatches(%regex,%start) $ZU(74,4,%regex,%start)
#define RElookingAt(%regex,%start) $ZU(74,5,%regex,%start)
#define REfind(%regex,%start) $ZU(74,6,%regex,%start)
#define REfindNext(%regex) $ZU(74,7,%regex)
#define REgroupCount(%regex) $ZU(74,8,%regex)
#define REgroup(%regex,%groupNum) $ZU(74,9,%regex,%groupNum)
#define REstart(%regex,%groupNum) $ZU(74,10,%regex,%groupNum)
#define REend(%regex,%groupNum) $ZU(74,11,%regex,%groupNum)
#define REreset(%regex,%index) $ZU(74,12,%regex,%index)
#define REhitEnd(%regex) $ZU(74,13,%regex)
#define REreplaceAll(%regex,%replaceText) $ZU(74,14,%regex,%replaceText)
#define REreplaceFirst(%regex,%replaceText) $ZU(74,15,%regex,%replaceText)
#define REsetTimeLimit(%regex,%limit) $ZU(74,17,%regex,%limit)
#define REgetTimeLimit(%regex) $ZU(74,18,%regex)
#define REappendReplacement(%regex,%replaceText,%index) $ZU(74,19,%regex,%replaceText,%index)
#define REUErrorCode $ZU(74,20)
#define RErequiredPrefix(%regex) $ZU(74,23,%regex)
#;
#define REunimplemented $$$GLUERROR($$$ERUNIMP)
#define NOTOK 0
#define ReqPreUnevaluated ($C(0)_$C(159)_$C(127))
#;
#define REuFirstError 66304
#define REuLastError   66323
#define REmFirstMessage 8310
#define REuIndexError 8
#define REmIndexMessage 8351
#define REuIllegalArgError 1
#define REmIllegalArgMessage	8352