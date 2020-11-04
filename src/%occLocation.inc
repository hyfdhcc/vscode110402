ROUTINE %occLocation [Type=INC]
#;
#; keyword table index
#;
#define cTableRoot          ^%qCacheObjectKey
#;
#define cTableDefault           1
#define cTableClasskeyword      2
#define cTableType              3
#define cTableMultiLine         4
#define cTableSubSubToExt      11
#define cTableSubSubToInt      13
#define cTableIntIntToSub      14
#define cTableSubSubToNoExport 15
#define cTableSubExtToXML      16
#define cTableSubSubVer        17
#;
#define tableDefaultRaw(%cat,%key)     ^%qCacheObjectKey($$$cTableDefault,%cat,%key)
#define tableClasskeywordRaw(%key)     ^%qCacheObjectKey($$$cTableClasskeyword,%key)
#define tableTypeRaw(%cat,%key)        ^%qCacheObjectKey($$$cTableType,%cat,%key)
#define tableMultiLineRaw(%cat,%key)   ^%qCacheObjectKey($$$cTableMultiLine,%cat,%key)
#define tableSubSubToExtRaw(%cat,%key) ^%qCacheObjectKey($$$cTableSubSubToExt,%cat,%key)
#define tableCatSubToExtRaw(%key)      ^%qCacheObjectKey($$$cTableSubSubToExt,"C",%key)
#define tableSubSubToIntRaw(%cat,%key) ^%qCacheObjectKey($$$cTableSubSubToInt,%cat,%key)
#define tableIntIntToSubRaw(%cat,%key) ^%qCacheObjectKey($$$cTableIntIntToSub,%cat,%key)
#define tableSubSubToNoExportRaw(%cat,%key) ^%qCacheObjectKey($$$cTableSubSubToNoExport,%cat,%key)
#define tableSubExtToXMLRaw(%cat,%key) ^%qCacheObjectKey($$$cTableSubExtToXML,%cat,%key)
#define tableSubSubToVerRaw(%cat,%key) ^%qCacheObjectKey($$$cTableSubSubVer,%cat,%key)
#;
#define tableDefaultGet(%cat,%key)                  $g(^%qCacheObjectKey($$$cTableDefault,%cat,%key))
#define tableClasskeywordGet(%key)                  $g(^%qCacheObjectKey($$$cTableClasskeyword,%key))
#define tableTypeGet(%cat,%key)                     $g(^%qCacheObjectKey($$$cTableType,%cat,%key))
#define tableMultiLineGet(%cat,%key)                $d(^%qCacheObjectKey($$$cTableMultiLine,%cat,%key))
#define tableSubSubToExtGet(%cat,%key)              $g(^%qCacheObjectKey($$$cTableSubSubToExt,%cat,%key))
#define tableCatSubToExtGet(%key)                   $g(^%qCacheObjectKey($$$cTableSubSubToExt,"C",%key))
#define tableSubSubToIntGet(%cat,%key)              $g(^%qCacheObjectKey($$$cTableSubSubToInt,%cat,%key))
#define tableIntIntToSubGet(%cat,%key)              $g(^%qCacheObjectKey($$$cTableIntIntToSub,%cat,%key))
#define tableSubSubToNoExportGet(%cat,%key)         $g(^%qCacheObjectKey($$$cTableSubSubToNoExport,%cat,%key))
#define tableSubExtToXMLGet(%cat,%key)              $g(^%qCacheObjectKey($$$cTableSubExtToXML,%cat,%key))
#define tableSubSubToVer(%cat,%key)                 $g(^%qCacheObjectKey($$$cTableSubSubVer,%cat,%key))
#;
 
#;
#; locational macros copied from the old INC files, first the cross process ones
#define tNEWDEPENDtop                               ^CacheTempClass(%ISCName,1)
#define tNEWDEPENDall(%depClass)                    ^CacheTempClass(%ISCName,1,%depClass)
#define tNEWDEPEND(%depClass,%class)                ^CacheTempClass(%ISCName,1,%depClass,%class)
#define tNEWDEPENDold(%depClass,%class)             ^CacheTempClass(%ISCName,2,%depClass,%class)
#define tNEWDEPENDoldall                            ^CacheTempClass(%ISCName,2)
#define tSUPERTREEall                               ^CacheTempClassTree
#def1arg tSUPERTREE(%args)                          ^CacheTempClassTree(%args)
#define tTABall                                     ^CacheTempClass(%ISCName,4)
#define tTAB(%table)                                ^CacheTempClass(%ISCName,4,%table)
#define tTABclass(%table)                           $li(^CacheTempClass(%ISCName,4,%table),1)
#define tTABschema(%table)                          $li(^CacheTempClass(%ISCName,4,%table),2)
#define tTABtable(%table)                           $li(^CacheTempClass(%ISCName,4,%table),3)
#define tTABcontainer(%table)                       $li(^CacheTempClass(%ISCName,4,%table),4)
#define tCLASSall                                   ^CacheTempClass(%ISCName,5)
#define tCLASS(%class)                              ^CacheTempClass(%ISCName,5,%class)
#def1arg tCLSRTNS(%nodes)                           ^CacheTempClass(%ISCName,6,%nodes)
#define tUPDATEHASHclass(%class)                    ^CacheTempClass(%ISCName,7,%class)
#define tUPDATEHASHdependency(%class,%dep)          ^CacheTempClass(%ISCName,7,%class,%dep)
#define tUPDATEHASHtype(%class,%dep,%type)          ^CacheTempClass(%ISCName,7,%class,%dep,%type)
#define tCLSQUALIFIERS                              ^CacheTempClass(%ISCName,8)
#define tCLSORDERall                                ^CacheTempClass(%ISCName,9)
#def1arg tCLSORDER(%nodes)                          ^CacheTempClass(%ISCName,9,%nodes)
#def1arg tVIEWAOV(%args)                            ^CacheTempClass(%ISCName,10,%args)
#define tREFall                                     ^CacheTempClass(%ISCName,11)
#define tREF(%class)                                ^CacheTempClass(%ISCName,11,%class)
#define tREFt(%class,%field)                        ^CacheTempClass(%ISCName,11,%class,%field)
#define tPROCschema(%schema)                        ^CacheTempClass(%ISCName,13,%schema)
#define tPROC(%schema,%proc)                        ^CacheTempClass(%ISCName,13,%schema,%proc)
#define tFKEYall                                    ^CacheTempClass(%ISCName,14)
#define tFKEY(%class)                               ^CacheTempClass(%ISCName,14,%class)
#define tFKEYk(%class,%fkey)                        ^CacheTempClass(%ISCName,14,%class,%fkey)
#define tVIEWall                                    ^CacheTempClass(%ISCName,15)
#define tVIEW(%view)                                ^CacheTempClass(%ISCName,15,%view)
#define tVIEWDEFall                                 ^CacheTempClass(%ISCName,16)
#define tVIEWDEF(%view)                             ^CacheTempClass(%ISCName,16,%view)
#define tVIEWDEFschema(%view)                       ^CacheTempClass(%ISCName,16,%view,1)
#define tVIEWDEFname(%view)                         ^CacheTempClass(%ISCName,16,%view,2)
#define tVIEWDEFclass(%view)                        ^CacheTempClass(%ISCName,16,%view,3)
#define tVIEWDEFowner(%view)                        ^CacheTempClass(%ISCName,16,%view,4)
#define tVIEWDEFcode(%view)                         ^CacheTempClass(%ISCName,16,%view,5)
#define tVIEWDEFdescription(%view)                  ^CacheTempClass(%ISCName,16,%view,6)
#define tVIEWDEFextentname(%view)                   ^CacheTempClass(%ISCName,16,%view,7)
#define tVIEWDEFreadonly(%view)                     ^CacheTempClass(%ISCName,16,%view,8)
#define tVIEWDEFcheckoption(%view)                  ^CacheTempClass(%ISCName,16,%view,9)
#define tREL(%class)                                ^CacheTempClass(%ISCName,17,%class)
#define tRELt(%class,%relationship)                 ^CacheTempClass(%ISCName,17,%class,%relationship)
#define tQUEUEclassesall                            ^CacheTempClass(%ISCName,18,0)
#def1arg tQUEUEclass(%subs)                         ^CacheTempClass(%ISCName,18,0,%subs)
#define tQUEUEqualifiers                            ^CacheTempClass(%ISCName,18,1)
#; tCURSOR is a counter used to allocate SQL cursor ID's for a class runtime.
#define tCURSOR(%class)                             ^CacheTempClass(%ISCName,19,%class)
#; Cursor type is $$$cCLASSproperty, $$$cCLASSquery, etc.
#define tCURSORid(%class,%type)                     ^CacheTempClass(%ISCName,19,%class,%type)
#define tCURSORID(%class,%type,%cursor)             ^CacheTempClass(%ISCName,19,%class,%type,%cursor)
#define tCLSUPDATEDall                              ^CacheTempClass(%ISCName,21)
#define tCLSUPDATED(%class)                         ^CacheTempClass(%ISCName,21,%class)
#define tCLSLOADEDall                               ^CacheTempClass(%ISCName,22)
#def1arg tCLSLOADED(%arg)                           ^CacheTempClass(%ISCName,22,%arg)
    // Orphans are projected SQL items that are temporarily dropped during uncompile of a class
    // and are never reprojected by compiling the class. Orphans have to be properly cleaned
    // up during post compile by executing a permanent drop. The orphans structure is populated
    // during uncompile when temp drop is true. Each new projection during compilation deletes the
    // projected item from the orphan structure. During post compile, any remaining orphans are
    // permanently dropped from the SQL dictionary.
#define tORPHANall                                  ^CacheTempClass(%ISCName,23)
#define tORPHAN(%class)                             ^CacheTempClass(%ISCName,23,%class)
    // orphaned types - table, view, procedure
#define tORPHANtable(%class)                        ^CacheTempClass(%ISCName,23,%class,$$$cCLASStables)
#define tORPHANview(%class)                         ^CacheTempClass(%ISCName,23,%class,$$$cCLASSviews)
#define tORPHANprocedure(%class)                    ^CacheTempClass(%ISCName,23,%class,$$$cCLASSprocedures)
    // Individual orphaned items
#define tORPHANTABLE(%class,%table)                 ^CacheTempClass(%ISCName,23,%class,$$$cCLASStables,%table)
#define tORPHANVIEW(%class,%view)                   ^CacheTempClass(%ISCName,23,%class,$$$cCLASSviews,%view)
#define tORPHANPROCEDURE(%class,%procedure)         ^CacheTempClass(%ISCName,23,%class,$$$cCLASSprocedures,%procedure)
#define tITREE(%class)                              ^CacheTempClass(%ISCName,24,%class)
#define tITREEHASH(%hash)                           ^CacheTempClass(%ISCName,24,%hash)
#define tITREEHASHREF(%hash,%node)                  ^CacheTempClass(%ISCName,24,%hash,%node)
#define tITREEHASHTREE(%hash,%node)                 ^CacheTempClass(%ISCName,24,%hash,%node,1)
#def1arg INHTREE(%args)                             ^CacheTempClass(%ISCName,25,%args)
#define INHTREEroot                                 ^CacheTempClass(%ISCName,25)

#def1arg tQUEUEWORK(%args)                          ^CacheTempClassPrj(%ISCName,%args)
#define tQUEUEWORKroot                              ^CacheTempClassPrj(%ISCName)

#;
#; locational macros copied from the old INC files, now the process specific ones
#define tCOMPILEDATA                                %ISCCompile
#define tMETHSAME(%mtype,%member,%method)           %ISCCompile(1,%mtype,%member,%method)
#define tMETHSAME2(%mtype,%member,%method)          %ISCCompile(2,%mtype,%member,%method)
#define tMETHSAME2i(%mtype,%member,%method,%index)  %ISCCompile(2,%mtype,%member,%method,%index)
#def1arg tINSERTGENERATOR(%nodes)                   %ISCCompile(3,%nodes)
#define tEXTcodeall                                 %ISCCompile(4)
#define tEXTcode(%method)                           %ISCCompile(4,%method)
#define tEXTCODELINE(%method,%linenbr)				%ISCCompile(4,%method,%linenbr)
#define tDAGc                                       %ISCCompile(5)
#define tDAG(%dag)                                  %ISCCompile(5,%dag
#define tSYM(%class)                                %ISCCompile(7,%class
#def1arg tPARAMTAG(%args)                           %ISCCompile(8,%args)
#define tEXTdef(%class,%args1,%args2,%key,%default) %ISCCompile(9,%class$$$REMOVEPAREN%args1$$$REMOVEPAREN%args2$$$REMOVEPAREN%key)
#def1arg tMetadata(%args)                            %ISCCompile(10,%metadata,%args)
#define tMetadataRoot                                %ISCCompile(10,%metadata)
#define tMetadataUses(%name)                         New %metadata Set %metadata=$zcrc(%name,7) If '$data($$$tMetadataRoot) { New %metadatasc $$$THROWONERROR(%metadatasc,$$metadata^%occCode(%name)) }
#define tClassTypeCache(%name)						%ISCCompile(11,%name)

#def1arg tGENCODE(%args)                    ^CacheTempClsCode(%ISCName,%args)
#define cMETHCODEMODESQLGEN            "s"
    
#define tCITIZENprop            2
#define tCITIZENquery           2
#define tCITIZENconstraint      3
#define tCITIZENindex           4
#define tCITIZENxxx(%kind)      $s(%kind=$$$cCLASSproperty:$$$tCITIZENprop,%kind=$$$cCLASSquery:$$$tCITIZENquery,%kind=$$$cCLASSconstraint:$$$tCITIZENconstraint,%kind=$$$cCLASSindex:$$$tCITIZENindex,1:$$$tCITIZENprop)
    
#define ResetAllTemp        k ^||%Cls,%ISCCompile,^CacheTempClass(%ISCName),^CacheTempClsCode(%ISCName),^CacheTempCls($job),^||%ocsFlo
#define ResetOneClassTemp   k %ISCCompile(1),%ISCCompile(2),%ISCCompile(3),%ISCCompile(5),%ISCCompile(8),%ISCCompile(9),%ISCCompile(10)
#define ResetOnePhaseTemp   k %ISCCompile(2),%ISCCompile(3),^CacheTempClass(%ISCName,4),^(11),^(13),^(14),^(15),^(16),^(17),^(19),^(21),^(23)
#define ResetExtentTemp     k %ISCCompile(4),%ISCCompile(7)
#define ResetInheritanceTrees k $$$INHTREEroot,^CacheTempClass(%ISCName,24)
    
#define QpCOMroot       "^oddCOM"
#define QpMACroot       "^oddCOM"
#define QpMAProot       "^oddMAP"
#define QpPROCroot      "^oddPROC"
    
#define AddTempNode(%node)      s ^CacheTempNodes("gbl",$j,$name(%node))=$lb($h,$username)
#define RemoveTempNode(%node)   k ^CacheTempNodes("gbl",$j,$name(%node))
#define AddTempQueue(%node)     s ^CacheTempNodes("event",$j,%node)=$lb($h,$username)
#define RemoveTempQueue(%node)  k ^CacheTempNodes("event",$j,%node)
#define AddTempSemaphore(%node) s ^CacheTempNodes("semaphore",$j,%node)=$lb($h,$username)
#define RemoveTempSemaphore(%node) k ^CacheTempNodes("semaphore",$j,%node)
#define ClsLockRecordAll	    ^CacheTempNodes("clslock",%ISCName)
#def1arg ClsLockRecord(%subs)	^CacheTempNodes("clslock",%ISCName,%subs)
#define ClsLockTmpRecordAll	    ^||%occCompile.lock
#def1arg ClsLockTmpRecord(%subs)	^||%occCompile.lock(%subs)

#; Copied from %syPidtab.inc to avoid having to include while file
#define WORKQUEUESRV 59

#define ISCCompileActive        ^CacheTempCompileActive(%ISCName)
#define ISCMasterName(%job)     $zstrip($piece(%job,":"),"*PC")
#define IsISCMaster(%job)       ($get(%ISCName)=$zstrip($piece(%job,":"),"*PC"))
#define InitISCName             If $get(%ISCName)="" { New %ISCName Set %ISCName=$$$ISCMasterName($job) }
#define IsISCWorker             ($zutil(67,10,$job)=$$$WORKQUEUESRV)
#define IsISCWorkerNoRecurse	$$$IsISCWorker&&($get(%ISCName)'="")&&($extract(%ISCName)'="r")&&('$$$IsISCMaster($job))
#define AddClsTempNodes         $$$AddTempNode(^CacheTempClsCode(%ISCName)) $$$AddTempNode(^CacheTempClass(%ISCName)) $$$AddTempNode($$$ISCCompileActive) Set $$$ISCCompileActive=1
#define RemoveClsTempNodes      $$$RemoveTempNode(^CacheTempClsCode(%ISCName)) $$$RemoveTempNode(^CacheTempClass(%ISCName)) $$$RemoveTempNode($$$ISCCompileActive) Kill $$$ISCCompileActive

#define InitCompileVars           New %ISCCompileLog Set %ISCCompileLog=$get(^oddLOG)
#define ResetCompileVars          Set %ISCCompileLog=$get(^oddLOG)
#define IncPerfCount(%node,%time) If $get(%ISCCompileLog),$increment(^||%occCompile.log(%node),$zh-%time) {}
#define IncPerfVal(%node,%val)    If $get(%ISCCompileLog),$increment(^||%occCompile.log(%node),%val) {}
#def1arg PerfCount(%args)         ^||%occCompile.log(%args)
#define PerfCountroot             ^||%occCompile.log
#define PerfSum                   If $data(^||%occCompile.log) Do EndCompile^%occCompile()

#define InitErrorCount         New %ISCCountErrors Set %ISCCountErrors=1
#define InitErrorNums          $$$InitErrorCount If '$$$IsISCWorker { Kill ^CacheTempErr($get(%ISCName,$zstrip($job,"*PC"))) $$$AddTempNode(^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")))) }
#define CountingErrorNum       $data(%ISCCountErrors)
#define IncErrorNum            If $data(%ISCCountErrors),$increment(^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")),"Error")) {}
#define IncErrorNums(%val)     If $data(%ISCCountErrors),$increment(^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")),"Error"),%val) {}
#define DecErrorNum            If $data(%ISCCountErrors),$increment(^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")),"Error"),-1) {}
#define SetErrorNum(%val)      Set:$data(%ISCCountErrors) ^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")),"Error")=%val
#define ErrorNum               +$get(^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")),"Error"))
#define SuspendErrorCount      New %ISCCountErrors
#define SuspendErrorCountVar(%var) Set %var=$get(%ISCCountErrors) New %ISCCountErrors
#define RestoreErrorCount(%var)    Set %ISCCountErrors=$get(%var)
#define RemoveErrorNum         If '$$$IsISCWorker { Kill ^CacheTempErr($get(%ISCName,$zstrip($job,"*PC"))) $$$RemoveTempNode(^CacheTempErr($get(%ISCName,$zstrip($job,"*PC")))) }

#define cAllMemberMethods	   $$$cCLASSproperty,$$$cCLASSindex,$$$cCLASStrigger,$$$cCLASSquery,$$$cCLASSconstraint,$$$cCLASSparameter

#define ClassTypeGetCache(%var,%class)	If $data($$$tClassTypeCache(%class),%var)#10=0 Set ($$$tClassTypeCache(%class),%var)=$$ClassType^%occName(%class)



