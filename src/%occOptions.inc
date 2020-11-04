ROUTINE %occOptions [Type=INC]
#define CompileDebugMode          $g(^%oddENV("debug"))
#def1arg CompileDebugModeSub(%arg) ^%oddENV("debug",%arg)
#define LogInfo                   1
#define StrictChecking            $g(^%qCacheObjectSys("strictchecking"),1)
#define CreateMAC                 $g(^%qCacheObjectSys("createmac"))
 
#define SysMultiDimProperty       $zbitget($zversion(0)_$c(0,0,0),23)
#define SysReferenceCount         $zbitget($zversion(0)_$c(0,0,0,0),25)
#define hasNEWLANGUAGE            $zbitget($zversion(0)_$c(0,0,0),20)
#define IsUnicode                 $zbitget($zversion(0),1)
#define SysObjectDispatch         $zbitget($zversion(0)_$c(0,0,0,0),47)
 
#define isVMS                     ($zversion(1)=1)
#define isWINDOWS                 ($zversion(1)=2)
#define isUNIX                    ($zversion(1)=3)

#define	isMACOSX                  ($zv["Mac OS X")

#define CacheVersion              $p($p($zv,") ",2)," ",1)
#define CacheVersionMajor         $p($$$CacheVersion,".",1)
#define CacheVersionMinor         $p($$$CacheVersion,".",2)
#;CFL713+
#define CachePlatform             $p($p($zv,"(",2),")",1)
#define CacheProduct              $p($zv," (")
#define CacheOS                   $p($zv," ",3,$l($$$CacheProduct," "))
#;CFL713-
 
#define isCACHE31                 1
#define isCACHE32                 1
#define isCACHE40                 1
 
#define hasSORTFUNC               $zbitget($zversion(0)_$c(0,0),14)
#define hasBITFUNC                $zbitget($zversion(0)_$c(0,0),15)
 
#; Upper case macros from %occConstant.inc
 
#define ucase(%string)     $zcvt(%string,"u")
#define lcase(%string)     $zcvt(%string,"l")
 
#; SQL Options - copied from %msql.inc
 
#define DefSchema $g(^%SYS("sql","sys","default schema"))
#define DefSchemaNaked $g(^("default schema"))
#define SchemaExpression $s($$$UPPER($p($$$DefSchema,"/"))'="_CURRENT_USER":$$$DefSchemaNaked,1:$s($p($$$aid,"@")'="":$p($$$aid,"@"),1:$s($p($$$DefSchemaNaked,"/",2)="":"SQLUser",1:$p($$$DefSchemaNaked,"/",2))))
 
#define DefaultSchema $$$SchemaExpression
#define DEFAULTSCHEMA $$$UPPER($$$SchemaExpression)
#define DefaultSchemaQ $$quoter2^%apiSQL($$$SchemaExpression)
#define DEFAULTSCHEMAQ $$quoter2^%apiSQL($$$UPPER($$$SchemaExpression))
 