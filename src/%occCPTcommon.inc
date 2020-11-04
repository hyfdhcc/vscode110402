ROUTINE %occCPTcommon [Type=INC]

#include %occCPTconfig
#include %occCPT
#include %occKeyword

#define THISHASMETHOD(%method) $$$HASMETHOD($Classname(),%method)
#define HASMETHOD(%class,%method) $$$comMemberDefined(%class,$$$cCLASSmethod,%method)

#define THISINHMETHOD(%method) $$$INHMETHOD($Classname(),%method)
#define INHMETHOD(%class,%method) ($$lookupOrigin^%occInherit(%class,$$$cCLASSmethod,%method)'="")

#define THISSUPPORTSMETHOD(%method) $$$THISHASMETHOD(%method) || $$$THISINHMETHOD(%method)
#define SUPPORTSMETHOD(%class,%method) $$$HASMETHOD(%class,%method) || $$$INHMETHOD(%class,%method)

#;
#; debugging - see %CPT.CalloutShell:cmdHELP for flag details

#; don't use HPTSHOULDTRACE directly - use $$$HPTIFTRACE
#if $$$HPTDEBUGENABLED
#define HPTSHOULDTRACE(%lang,%flags) ##class(%CPT.CalloutCommon).FlagsInclude($$$GETCONFIG(%lang,"HPTTRACE"),%flags)
#define HPTIFTRACE(%lang,%flags,%code) If $$$HPTSHOULDTRACE(%lang,%flags) {%code}
#define HPTTRACE(%lang,%flags,%descr,%item) If $$$HPTSHOULDTRACE(%lang,%flags) {$$$HPTDEBUG("<"_(%flags)_"> "_(%descr),%item)}
#define HPTDEBUG(%descr,%item) Write:$X ! Write "| ",..%ClassName(),": ",%descr,"  ",%item,!
#define HPTASSERT(%item) If '(%item) {Write:$X ! Write "*** Assertion Failed: ",##quote(%item),! BREAK}
#define HPTASSERTV(%cond,%item) $Select(%cond:%item,1:##class(%CPT.CalloutCommon).AssertVFailure(##quote(%cond),%items))
#else
#define HPTIFTRACE(%lang,%flags,%code)
#define HPTTRACE(%lang,%flags,%descr,%item)
#define HPTDEBUG(%descr,%item)
#define HPTASSERT(%item)
#define HPTASSERTV(%cond,%item) %item
#endif

#define HPTF(%x) ##class(%XSQL.Format).ListFormat(%x)

