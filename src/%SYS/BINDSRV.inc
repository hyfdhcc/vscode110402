ROUTINE %SYS.BINDSRV [Type=INC]
 //==============
 
#define jobbufsize 128
#define initjobbuffer View $zu(106,2,$$$jobbufsize):-3:-$$$jobbufsize:$$zeros^%CDUtil($$$jobbufsize)
 
#define SETV(%off,%l,%v) View %off:-4:-%l:%v 
#define GETV(%off,%l) $v(%off,-4,-%l)
 
#define setJobInfo(%info) $$$SETV(0, $l(%info), %info)
#define getJobInfo $$$GETV(0, $$$jobbufsize)
#define bldJobInfo $lb(%qdev, %clientVersion, %useCache, %allowNestedCalls) 
#define getDevice(%info) $li(%info, 1)
#define getClientVersion(%info) $li(%info, 2)
#define getUseCache(%info) $li(%info, 3)
#define allowNestedCalls(%info) $li(%info, 4)
 
#define setHeaderId1 u %qdev i $zobjexport(%qmsgid,1)!1
#define setHeaderId2 u %qdev i $zobjexport(%qacn,2)!1
#define setMaxMDPropLen(%val) i $zobjexport(%val,42)!1
#define getNext(%e) s %e = $zobjexport(12)
#define putNext(%e) u %qdev i $zobjexport(%e,3)!1
#define putNextInBatch(%e) $zobjexport(%e,7)
#define putNextEndElem $$$putNextBin($lb())
#define putNextBin(%e) u %qdev i $zobjexport(%e,5)!1
#define getNextBin(%e) $zobjexport(%e,13)
#define putNextWholeObj(%e) u %qdev i $zobjexport(%e,40)!1 d $system.CLS.SetSModified(%e,0)
#define putNextDiffs(%e) u %qdev i $zobjexport(%e,43)!1 d $system.CLS.SetSModified(%e,0)
#define putErr(%e) $$$putNext(%e) s %e=""
#define putRes $$$putNext(%res) s %res=""
#define putResBin $$$putNextBin(%res) s %res=""
#define flushOutput() u %qdev i $zobjexport("",6)!1
#define flushOutputBuf() u %qdev i $zobjexport(20)!1
 
#define InputRedirectionMsgId 439
 
#define serverVersion 4.07
#define srvVerCutOff 3.025
///; #define srvVerCutOff 2.08
#define sendOidBranch 2.16
#define m5m9MesagesBranch 2.16
#define srvOutputBranch 2.17
#define descrArgsBranch 2.18
#define metaInfoBranch 3.00
#define metaInfoBranch2 3.01
#define sendZobjvalDiffsBranch 3.02
#define srvOutputBranch1 3.03
#define streamPropBranch 3.04
#define srvOutputBranch2 3.05
#define srvOutputBranch3 3.06
#define DynObjMetaInfoBranch 3.07
#define inputRedirectionBranch 3.08
#define DynObjMetaInfoBranch2 3.09
#define metaInfoBranch3 3.10
#define metaInfoBranch4 3.11
#define metaInfoBranch5 3.13
#define metaInfoBranch6 3.14
#define newObjectDispatch 4.00
#define mtdExceptions 4.01
#define resetMsgSupport 4.02
#define optionalNestedCalls 4.03
#define metaInfoBranch7 4.04
#define colnMsgBranch 4.05
#define propertyPathsBranch 4.06
#define propertyPathsColnBranch 4.07
 
#define closeObjErr -7
#define closeObjsErr -8
#define openObjErr -9
#define openOrefErr -11
 
#define noClassErrCode 150

#define openObjPropertyPathsSimpleList 1
#define openAllObjectsListRecursive 1
#define openAllObjectsListWithPropertyPaths 2
#define openAllObjectsArrayWithPropertyPaths 3
 
#define makeErr(%code,%msg,%data) $lb(%code,%msg,%data)
#define makeGenErr $$$makeErr($ZU(96,0),$ZE,"")
#define setErrMsg(%err,%msg) s $li(%err,2)=%msg
#define getErrCode(%e) $li(%e,1)
#define setupTry s $zt="catch"
#define setupCatch If ($ze["<WRITE")||($ze["<READ")||($ze["<DISCONNECT")||($ze["<DSCON") { Halt } s $zt=""
#define setupCatchCmn $$$setupCatch s %err=$$$makeGenErr, %res=""
 
#define maxOutputPieceLen 32760
#define isLOGGING $g(^%SYS.BINDSRV)["l"
#define LOG(%str) i $g(^%SYS.BINDSRV)'="" s:^%SYS.BINDSRV["l" ^%SYS.BINDSRV($j,$o(^%SYS.BINDSRV($j,""),-1)+1)=%str i ^%SYS.BINDSRV["d" d addToOutput($c(13,10)_"%SYS.BINDSRV: "_%str,"LOG","")  
 
#define useCacheVar ^||BindSrvUseCache
#define bufferSrvOutput ^||BindSrvBufferOutput
#define outCountVar ^||BindSrvOutCountVar
#define outPieceVar(%e) ^||BindSrvOutPieceVar(%e)
#define outLastPieceVar $$$outPieceVar($$$outCountVar)
#define resetBufferedOutput k $$$outCountVar s $$$outCountVar = 1, $$$outLastPieceVar = ""
#define redirectOutput ^||BindSrvRedirectOutput
 
#define setBufferSrvOutput(%e) s $$$bufferSrvOutput = %e
#define StartRedirectEx $$$StartRedirect $$$setBufferSrvOutput(1)
 
#define resetChangedObjs k %changedObjs s %changedObjs=0
#define addChangedObj(%e) i %e'=0 { i '$d(%changedObjs(%e)) { i $i(%changedObjs) s %changedObjs(%e)="" } }
#define resetNewObjs k %newObjs
#define addNewObj(%e) s %newObjs(%e)=""
#define isNewObj(%e) $d(%newObjs(%e))
#define addDSRS(%e) s %dsOrefs($$$objToOref(%e))=%e
#define killDSRS(%e) k %dsOrefs($$$objToOref(%e))
 
#define objToOref(%e) +%e
#define orefToObj(%e) $zobjref(%e)
#define initObjVar(%e) d incRefCnt(%e) $$$addChangedObj($$$objToOref(%e))
#define killObjVar(%e) k %sysOrefs(%e)
#define isClientOref(%e) $d(%sysOrefs(%e))
#define toClientObj(%e) $s('%debug:$$$orefToObj(%e),%debug:$$toClientObjChecked(%e))
#define toInt(%e) +%e
 
#define MetaInfoEB 0
#define MetaInfoLB 1
#define MetaInfoLG 2
 
#define clientTypeVoidId -1
#define clientTypeStrId 4
#define clientTypeObjId 0
#define clientTypeLongStrId 12
#define clientTypeLongBinId 13
 
#define getArgType(%e) %mtdInfo(%mtdInfo, "args", %e, "type")
#define setArgType(%idx,%val) s %mtdInfo(%mtdInfo, "args", %idx, "type")=%val
#define getArg(%e) %mtdInfo(%mtdInfo, "args", %e)
#define getArgStr(%e) "%mtdInfo(%mtdInfo, ""args"", "_%e_")"
#define setArg(%idx,%val) s %mtdInfo(%mtdInfo, "args", %idx)=%val
#define makeArgByRef(%e) s %mtdInfo(%mtdInfo, "refs", %e) = ""
#define getNextArgByRef(%e) $o(%mtdInfo(%mtdInfo, "refs", %e))
#define isArgByRef(%e) $d(%mtdInfo(%mtdInfo, "refs", %e))
#define setExceptionInfo(%e) s %mtdInfo(%mtdInfo, "exception") = %e
#define getExceptionInfo %mtdInfo(%mtdInfo, "exception")
#define putResWire d putArgWire(0)
 
#define initMtdInfo i $i(%mtdInfo)
#define resetMtdInfo k %mtdInfo(%mtdInfo) i $i(%mtdInfo, -1)
#define getMtdOref %mtdInfo(%mtdInfo, "oref")
#define getMtdClassName %mtdInfo(%mtdInfo, "className")
#define getMtdClassNameStr "%mtdInfo(%mtdInfo, ""className"")"
#define getMtdName %mtdInfo(%mtdInfo, "mtdName")
#define getMtdNameStr "%mtdInfo(%mtdInfo, ""mtdName"")"
#define getMtdRetType $$$getArgType(0)
#define getMtdRetVal $$$getArg(0)
#define getMtdRetValStr $$$getArgStr(0)
#define getMtdNumArgs %mtdInfo(%mtdInfo, "args")
#define getMtdNumRefs %mtdInfo(%mtdInfo, "refs")
 
#define getClassName(%e) $lg(%e, 2)
 
#define nonCacheableOldColn ",%Library.ListOfDataTypes,%Library.ListOfObjects,%Library.ArrayOfDataTypes,%Library.ArrayOfObjects,"
#define nonCacheableNewColn ",%Collection.ListOfDT,%Collection.ListOfObj,%Collection.ArrayOfDT,%Collection.ArrayOfObj," 
#define nonCacheableObjects $$$nonCacheableOldColn_$$$nonCacheableNewColn
#define isNonCacheableObj(%e) ($$$nonCacheableObjects [ (","_$zobjclass(%e)_",")) ! $$$classIsStream($zobjclass(%e)) 
 
#define closeServer kill %sysOrefs,%dsOrefs,%tcpProvider,^||BindSrvRedirectOutput,^||BindSrvBufferOutput,^||BindSrvOutPieceVar,^||BindSrvOutCountVar
 