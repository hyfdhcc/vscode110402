ROUTINE %apiXSQL [Type=INC]
 
 
 // aliases for $ZLTS and $ZSTL until $LTS and $LFS are established
#define ZLTS(%L) $ZLTS(%L)
#define ZSTL(%S) $ZSTL(%S)
 
 // is debugging on?
#define DEBUGGING ##expression(+$Get(^%XSQL("DEBUGGING")) || +$Get(%tsqldebugging))
 
 // define message writer, assertion and break macros
#if $$$DEBUGGING
	#define DEBUG(%M) Write:$X ! Write "| ",%M,!
	#define ASSERT(%X) If '(%X) {Set %AssertIO=$I Use 0 Write !!,"Assertion failure",!! B  Use %AssertIO}
	#define BREAK Break
#else
	#define DEBUG(%M)
	#define ASSERT(%X)
	#define BREAK
#endif
 
 // trace GENERATEX? (needs DEBUGGING to be on too)
#define TRACEGENERATEX 1
#if $$$DEBUGGING
	#if $$$TRACEGENERATEX
		#define GENERATEXW(%line) w:$x ! W gen,"> ",%line,!
	#else
		#define GENERATEXW(%line)
	#endif
#else
	#define GENERATEXW(%line)
#endif
 
#define GENERATEX(%line) Set tsqlGenLine=%line $$$GENERATEXW(tsqlGenLine) If $ZStrip(tsqlGenLine,"<>W")'="" {Do ..OutputGeneratedLine(gen,tsqlGenLine)}
 
 // class, method being compiled
#define CCLASSQ ##expression(""""_$Get(%symtab("#classcontext",1),"(some class)")_"""")
#define CMETHODQ ##expression(""""_$Get(%symtab("#method",1),"(some method)")_"""")
#define CCLASS ##expression($Get(%symtab("#classcontext",1),"(some class)"))
#define CMETHOD ##expression($Get(%symtab("#method",1),"(some method)"))
 
 // call a method or function and if it returns failing status: return status
#define CALL(%C,%A) $$$INTCALL(%C,%A,Quit sc)
 
 // call a method or function and if it returns failing status: quit the loop
#define LCALL(%C,%A) $$$INTCALL(%C,%A,Quit)
 
 // call a method or function and if it returns failing status: perform the given quit-action
#define INTCALL(%C,%A,%Q) Set sc=%C If $$$ISERR(sc) {$$$DEBUG($$GetErrorText^%apiOBJ(sc)_" at "_$$$CCLASSQ_"."_$$$CMETHODQ_" ("_%A_")") %Q}
 
 // return a string consisting of the given number of spaces
#define SP(%W) $Justify("",%W)
 
 // right-justify the given string within the given width, left-padding with zeroes
 // - warning: %S should not be a complex expression because it's used twice
#define RJZ(%S,%W) $Translate($$$SP(%W-$Length(%S))," ","0")_%S
 
 // OdbcToLogical cache: (TSQL-datatypebase,odbcvalue) = logicalvalue
 
#; cache key
#define TSQLOTLKEY $J_"`TSQL:OTLCACHE"
 
#; entire cache
#define TSQLOTLTOP ^CacheTemp($$$TSQLOTLKEY)
 
#; cache element
#define TSQLOTL(%D,%O) ^CacheTemp($$$TSQLOTLKEY,%D,%O)
 
#; naked-reference to cache element (a copy of TSQLOTL if were a local, of course)
#define TSQLOTLR(%D,%O) ^(%O)
 
 // proctypes (element 5 of procinfo list) - must match definitions used in CacheTSQL.DLL
#define TSQLPROCTYPEMETHOD 0
#define TSQLPROCTYPEQUERY 1
#define TSQLPROCTYPETRIGGER 2
 
 // ^%SYS
#define TSQLSYSSETTINGS ^%SYS("tsql","defaultsettings")
 
 // query logging
#define TSQLQUERYLOGNONE 0
#define TSQLQUERYLOGFLOW 1
#define TSQLQUERYLOGSYSV 2
#define TSQLQUERYLOGDEEP 3
#define TSQLQUERYLOG(%LEVEL,%EVENT,%MESSAGE,%RSVAR) If %LEVEL<=..QueryLoggingLevel {Do ..QueryLog(%LEVEL,%EVENT,%MESSAGE,%RSVAR)}
 
 // CPT
#define TSQLCPTG ^|"^"|%isc.cpt
 
 
 // set the 'allow row id insert' flag (to 0 or 1)
#define TSQLSETARII(%S) If $ZUtil(115,11,%S)
 
 
 // unit test query class
#define TSQLUNITTESTQUERY "TSQLUNITTEST.Query"
 
 
 