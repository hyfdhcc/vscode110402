ROUTINE %cspBuild [Type=INC]
#;%cspBuild.INC -Defines for csp servers ;JO2075, 9/7/06
#if 0   /*=======================Maintenance========================*/
#;JO2075  9/07/06 Jeffrey Orlin, removed CSPJOBTYPE. Servers include
#;                %syPid.inc and use $$$CSPSRV
#endif  /*=====================End Maintenance======================*/
 ;
#include %cspInclude
 ;
#define cRULEFAMILYRULEVERSION 19.3
 ;
#define cFAMILYCSR          "csr"
#define cFAMILYCSP          "csp"
#define cFAMILYDEFAULT      $$$cFAMILYCSP
 ;
#define cFAMILYspec         "spec"
#define cFAMILYtag          "tag"
 ;
#define cFAMILYtopclass     "topclass"
#define cFAMILYtagclass     "tagclass"
#define cFAMILYtxtclass     "txtclass"
#define cFAMILYtimecompiled "timecompiled"
 ;
#define sfamilyRoot(%family) ^%qcspRule(%family)
#define ufamilyRoot(%family) ^cspRule(%family)
 ;
#define sruleGlobalRoot      ^%qcspRule
#define uruleGlobalRoot      ^cspRule
 ;
#define sruleVersion         ^%qcspRule
#define uruleVersion         ^cspRule
#define mruleVersion(%rule)  @("^"_$select($extract(%rule)="%":"%q",1:"")_"cspRule")
 ;
#define sfamilyTag(%family)           ^%qcspRule(%family,$$$cFAMILYtag)
#define ufamilyTag(%family)           ^cspRule(%family,$$$cFAMILYtag)
 ;
#define mfamilyTopClass(%family)      ^%qcspRule(%family,$$$cFAMILYspec,$$$cFAMILYtopclass)
#define mfamilyTagClass(%family)      ^%qcspRule(%family,$$$cFAMILYspec,$$$cFAMILYtagclass)
#define mfamilyTxtClass(%family)      ^%qcspRule(%family,$$$cFAMILYspec,$$$cFAMILYtxtclass)
#define sfamilyTimeCompiled(%family)  ^%qcspRule(%family,$$$cFAMILYspec,$$$cFAMILYtimecompiled)
#define ufamilyTimeCompiled(%family)  ^cspRule(%family,$$$cFAMILYspec,$$$cFAMILYtimecompiled)
 ;
#define cRULEname        "name"
#define cRULEmatch       "match"
#define cRULEempty       "empty"
#define cRULEclass       "class"
#define cRULEcomplete    "complete"
#define cRULEtextonly    "textonly"
#define cRULElanguage    "language"
#define cRULEdescription "description"
#define cRULEattribute   "attribute"
 ;
#define sruleGlobal      "^%qcspRule"
#define uruleGlobal      "^cspRule"
#define sruleRoot(%family,%ruleindex)           ^%qcspRule(%family,"rule",%ruleindex)
#define uruleRoot(%family,%ruleindex)           ^cspRule(%family,"rule",%ruleindex)
#define mruleRoot(%family,%ruleindex)           @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex)
 ;
#define mruleName(%family,%ruleindex)           @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEname)
#define mruleDescription(%family,%ruleindex)    @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEdescription)
#define mruleMatch(%family,%ruleindex)          @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEmatch)
#define mruleEmpty(%family,%ruleindex)          @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEempty)
#define mruleClass(%family,%ruleindex)          @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEclass)
#define mruleComplete(%family,%ruleindex)       @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEcomplete)
#define mruleTextOnly(%family,%ruleindex)       @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEtextonly)
#define mruleLanguage(%family,%ruleindex)       @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULElanguage)
 ;
#define mruleAttribute(%family,%ruleindex,%attrib)            @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEattribute,%attrib)
#define mruleAttributeDefault(%family,%ruleindex,%attrib)     @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEattribute,%attrib,"default")
#define mruleAttributeRequired(%family,%ruleindex,%attrib)    @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEattribute,%attrib,"required")
#define mruleAttributeType(%family,%ruleindex,%attrib)        @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEattribute,%attrib,"type")
#define mruleAttributeDescription(%family,%ruleindex,%attrib) @("^"_$select($extract(%ruleindex)="%":"%q",1:"")_"cspRule")@(%family,"rule",%ruleindex,$$$cRULEattribute,%attrib,"description")
 ;
#define matchGameTotal(%matchspec)        $listlength(%matchspec)
#define matchGame(%matchspec,%game)       $list(%matchspec,%game)
 ;
#define gameTagName(%gamespec)            $list(%gamespec,1)
#define gameAttribTotal(%gamespec)        $listlength($lg(%gamespec,2))
 ;
#define attribName(%gamespec,%attrib)     $list($list($list(%gamespec,2),%attrib),1)
#define attribHasValue(%gamespec,%attrib) $listdata($list($list(%gamespec,2),%attrib),2)
#define attribValue(%gamespec,%attrib)    $list($list($list(%gamespec,2),%attrib),2)
 ;
#define TAGMAKEVALUE(%active,%empty) (''%active*2)+''%empty
 ;
#define stagValue(%family,%tag)       ^%qcspRule(%family,"tag",%tag)
#define utagValue(%family,%tag)       ^cspRule(%family,"tag",%tag)
 ;
#define mtagIsDefined(%family,%tag)   ($d($$$stagValue(%family,%tag))!$d($$$utagValue(%family,%tag)))
#define mtagIsAvtive(%family,%tag)    (($g($$$stagValue(%family,%tag))\2)!($g($$$utagValue(%family,%tag))\2))
#define mtagIsEmpty(%family,%tag)     (($g($$$stagValue(%family,%tag))#2)!($g($$$utagValue(%family,%tag))#2))
 ;
 
#define LOGFLAGS        ^%qCacheObjectSys("csplog")
#define LOGTAGS(%tag)   ^%qCacheObjectSys("csplog",%tag)
#define isLOG(%flag)    $g(^%qCacheObjectSys("csplog"))[%flag
#define LOGSTR(%string) w !,%string
 
#define TIMESTAMP(%t)           ($piece(%t,",")*86400+$piece(%t,",",2))
#define CSPdefaulttimeout       900
 
#define GETNS                   $namespace
 
#define cspHtoD(%h)             ($piece($zdatetime(%h,11,,,,,,,,,,1)," ")_", "_$zdatetime(%h,2,,,,4,,,,,,1)_" GMT")
#define cspAddH(%h,%s)          $select(($piece(%h,",",2)+%s)<86400:+%h_","_($piece(%h,",",2)+%s),1:(%h+1)_","_($piece(%h,",",2)+%s-86400))
 
#define RuleClassName(%family,%rule) $select($extract(%rule)="%":"%csr."_%family_"."_$extract(%rule,2,$l(%rule)),1:"csr."_%family_"."_%rule)
#define sruleClassPrefix		"%csr.csp"
#define uruleClassPrefix		"csr.csp"
 
#define UnEscapeHTML(%string)   $zconvert(%string,"I","HTML")
 
#define EnableDebug             Do $zutil(128,3,0)
#define DisableDebug            Do $zutil(128,3,1)
 
#define cspClassName(%url,%path,%config) $Select($$$GetSecurityApplicationsPackage(%config)="":"csp",1:$$$GetSecurityApplicationsPackage(%config))_$ZConvert($Translate($Extract($Piece(%url,".",1,*-1),$Length(%path),*),"\/",".."),"l")
#define compH(%h1,%h2) $select(+%h1<+%h2:-1,%h1>%h2:1,$piece(%h1,",",2)<$piece(%h2,",",2):-1,$piece(%h1,",",2)>$piece(%h2,",",2):1,1:0)
 
#define cspStartMethodImplementation(%handle,%method)             Do AddMethod^%occModify(%handle,%method) $$$editMemberKeyKill(%handle,$$$cCLASSmethod,%method,$$$cMETHimplementation)
#define cspStartMethodImplementationEx(%handle,%method,%sc)       Set %sc=$$AddMethod^%occModify(%handle,%method) If $$$ISOK(%sc) $$$editMemberKeyKill(%handle,$$$cCLASSmethod,%method,$$$cMETHimplementation)
#define cspAddMethodLine(%handle,%method,%linenum,%line)          $$$editMemberArraySet(%handle,$$$cCLASSmethod,%method,$$$cMETHimplementation,%linenum,%line)
#define cspFinishMethodImplementation(%handle,%method,%numlines)  $$$editMemberKeySet(%handle,$$$cCLASSmethod,%method,$$$cMETHimplementation,%numlines)
 
#define csphdrAUTHPASSWORD 0
#define csphdrAUTHTYPE 1
#define csphdrREMOTEADDR 2
#define csphdrREMOTEHOST 3
#define csphdrREMOTEUSER 4
#define csphdrHTTPUSERAGENT 5
#define csphdrSERVERPROTOCOL 6
#define csphdrSERVERSOFTWARE 7
#define csphdrSERVERNAME 8
#define csphdrGATEWAYINTERFACE 9
#define csphdrSERVERPORT 10
#define csphdrREMOTEIDENT 11
#define csphdrHTTPACCEPT 12
#define csphdrHTTPREFERER 13
#define csphdrPATHTRANSLATED 14
#define csphdrCONTENTTYPE 15
#define csphdrHTTPAUTHORIZATION 16
#define csphdrHTTPCOOKIE 17
#define csphdrHTTPS 18
#define csphdrSERVERPORTSECURE 19
#define csphdrREQUESTMETHOD 20
#define csphdrHTTPSOAPACTION 21
#define csphdrHTTPACCEPTCHARSET 22
#define csphdrHTTPACCEPTLANGUAGE 23
#;
#define SysFlag $view(0,-2,$zutil(40,0,1))
#;
#define BLD 661
#define PROTOCOL 636
 
#define CSPConfigName $zconvert($get(^%SYS("CSP","CSPConfigName"),$piece($zutil(86),"*",2)),"l")
 
 #; Stored session data list indexes
#define sesPreserveFlag		3
#define sesOldTimeout		4
#define sesMsgNum       	13
#define sesLicenseId		12
#define sesApplication		15
#define sesSecurityContext	16
#define sesGroupId          30
#define sesSOAPCounter		31
#define sesProcessId		32
#define sesByIdGroups       33
#define sesApplicationLicenses 34

 