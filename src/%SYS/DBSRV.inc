ROUTINE %SYS.DBSRV [Type=INC]
	#; Description:    Cache 5.1.+ xDBC Server include file
	#; Author:         Aleksandar Djakovic
	#;
	#;  JMM598  (03/22/2015) - Add new "MP" message to CPPServerFunction
	#;  JCN1511 (06/24/2014) - Bump protocol version to 50
	#;  JCN1225 (10/25/2011) - Bump protocol version to 49
	#;  JMM394  (07/07/2010) - Define LCBUseNewContinuationLogic
	#;  AND1082 (08/20/2009) - Bump protocol version to 48
	#;  JMM301  (05/12/2009) - Change CV message to SV
	#;  JMM292  (04/15/2009) - Add new CV message to CPPServerFunction
	#;  AND1030 (01/23/2009) - Bump protocol version to 47
	#;  AND1008 (08/20/2008) - Bump protocol version to 46
	#;  DPV3199 (06/20/2008) - Correct some issues with Purge during execution of multiple-routine cached queries 
	#;  DPV3168 (05/21/2008) - Perform $Decimal on NUMERIC data before sending to the client in SELECT
	#;  JMM248  (03/26/2008) - Identify LCB jobs as $$$LCBTYPE rather than $$$ODBCSRV
	#;  DPV3115 (02/27/2008) - Don't check Error404 for "DQ", "DU", or "DX"; minor privilege corrections with cached queries
	#;  IYB503  (02/06/2008) - On error, ignore current message input before processing next message 
	#;  JLC1075 (10/09/2007) - Call $$GetCharset^%SYS.NLS() to get character set
	#;  JMM226  (08/18/2007) - Chance TC to CT to avoid conflict with TCOMMIT msg
	#;  JMM226  (07/27/2007) - Add new TC message to CPPServerFunction
	#;  JMM225  (07/27/2007) - Add new PS message to CPPServerFunction
	#;  AND894  (05/21/2007) - Kill %qsc(%qacn) on receiving CU message
	#;  AND855  (01/22/2007) - Use orefs for all stream retrievals
	#;  DPV2773 (10/30/2006) - Fix execute privilege check for hidden procedures
	#;                         SQL Fix ProdLog 54113: Minimum resources needed to allow a user to use CacheNetWizard?
	#;  JO2062  (08/04/2006) - Change odbc jobtype from 108 to $$$ODBCSRV
	#;  AND791  (06/22/2006) - New static cursor support
	#;  JMM145  (06/19/2006) - Added MX, MT, SE, and MG messages to CPPServerFunction
	#;  MAB533  (06/16/2006) - Added MZ message to CPPServerFunction
	#;  DPV2558 (12/08/2005) - Don't reset error trap in ServerLoop if it is already set.  Caused stack problems with implicit NEW $ETRAP
	#;                         SQL Fix ProdLog 47718: <FRAMESTACK> during calling SP procedure, %server issue
	#;  AND703/4 (11/02/2005) - Add IT (IN_TRANSACTION) message, additional metadata
	#;  DPV2498 (10/05/2005) - Suspend writing to the journal file when creating/deleting cached query definitions
	#;  DPV2524 (09/22/2005) - Moved Cached Query metadata back to ^mcq
	#;  DPV2479 (08/02/2005) - Fix StopRedirect to not do anything if we never Started Redirect
	#;                         SQL Fix ProdLog 44980: <<UNDEFINED>AuthenticationError+143^%SYS.DBSRV *%qrdr("|TCP|...")
	#;  DPV2454 (07/19/2005) - Move ^mcq global to ^|"%SYS"|CQ[I] subscripted by namespace
	#;  AND663  (05/26/2005) - Enable CU message
	#;  DPV2428 (05/11/2005) - Remove SQL bindings privilege check for each message
	#;                         SQL Fix ProdLog 43107: User w/o %SQL can connect to a DSN but gets errors executing any queries
	#;  DPV2412 (04/14/2005) - Check privilege for cached procedure call, handle using 404 logic for procedures
	#;                         SQL Fix ProdLog 42616:  ODBC: REVOKE EXECUTE is not honored by existing ODBC connections
	#;  DPV2321 (11/10/2004) - Use new %SYS.CONFIG API for SQL Configuration settings
	#;  DPV2320 (11/10/2004) - Rename server routines, created this include file from %server.INC
	#;  MAB323  (10/28/2004) - Moved CheckStatus macro from %bindserver
	#;  AND552  (09/24/2004) - implement maxRows
	#;  AND550  (09/23/2004) - Implement query timeout
	#;  DPV2292 (09/21/2004) - Kill %qsc(%qacn) when a Cached Query is immediately purged
	#;                         SQL Fix ProdLog 38666: <STORE> error using multiple times CREATE USER or GRANT
	#;  AND515  (07/08/2004) - Do not use ^CacheTemp for reading Update parameters
	#;  DPV2198 (03/17/2004) - Use $Username instead of %msql, use new privilege global
	#;  DPV2196 (03/12/2004) - Make proper privilege check to determine if 404 error is thrown
	#;                         SQL Fix ProdLog 36172: Query fails if schema name equals username 
	#;  AND461  (02/26/2004) - Chage StopRedirect to Use %qdev (instead Use 0)	
	#;  AND429  (12/17/2003) - Update some macros	
	#;  DPV2138 (12/05/2003) - Change LastPiece macro to LastPce to avoid conflict with LastPiece from %msql.INC
	#;  DPV2134 (12/02/2003) - CompileDeferredList is in %apiDDL2, not %apiDDL
	#;			   SQL Fix ProdLog 34862:  SET OPTION COMPILEMODE=IMMEDIATE fails
	#;  IYB119  (07/01/2003) - added message "BK" for code generation in .NET binding 
	#;  AND345  06/05/2003 - Add zobjexport continuation switch
	#;  AND337  05/13/2003 - Initial Implementation

#include %syPidtab ;JO2062
#define CQVersion 9
#define CQTimeStamp $parameter(%qsc(%qacn),"%RandomSig")
#define SPTimeStamp $e($g(^rOBJ(%qsc(%qacn))),1,16)
 
#DEFINE ServerVersion "Cache xDBC Server 8.01"
#DEFINE ProtocolVersion 51
#DEFINE MetadataVersion $Select(%protocol>46:5,%protocol>42:4,%protocol>40:3,1:2)

#DEFINE RoutineName             %qsc(%qacn)
#DEFINE FetchStatus             %qsc(%qacn,0)
#DEFINE CQoref	                %qsc(%qacn,1)
#DEFINE SPClassName             %qsc(%qacn,5)
#DEFINE SPName                  %qsc(%qacn,6)
#DEFINE SPExecString            %qsc(%qacn,7)
	// For cached queries this is the timestamp of the CQ class pkg.class.0 routine.  For stored procedures, this is the timestamp of the class that projected the procedure
#DEFINE RoutineTimestamp        %qsc(%qacn,8)
#DEFINE PrivilegeInfo           %qsc(%qacn,10)
#DEFINE SPHandle                %qsc(%qacn,11)
#DEFINE SPContext               %qsc(%qacn,12)
#DEFINE ColumnCount             %qsc(%qacn,13)
#DEFINE LastPce                 %qsc(%qacn,14)
#DEFINE CurrentRow              %qsc(%qacn,15)
#DEFINE AutoGeneratedKeyColumn  %qsc(%qacn,17)
	#; ParameterDirection is a string of 0|1 where 1 indicates the parameter corresponding to the string position (starting with 1) has an output direction
#DEFINE ParameterDirection      %qsc(%qacn,18)
#DEFINE MaxRows                 %qsc(%qacn,19)
	#; ParameterObjectCategory is a string of $Char(0|1|2) where the parameter corresponding to the string position is:
	#;		$Char(0) = datatype or other non-registered class;
	#;		$Char(1) = all object types except SERIAL
	#;		$Char(2) = SERIAL
#DEFINE ParameterObjectCategory %qsc(%qacn,20)
	#; SPPrivilegeParam contains the 9,Schema.sProc string to pass to the privilege check for Error404SP check (DPV2412)
#DEFINE SPPrivilegeParam        %qsc(%qacn,23)
#DEFINE StaticCursor            %qsc(%qacn,24)
	#; This is a $List() of integer values. If the value is > 0 then the input parameter value will be truncated to that length
	#; when read from the wire. The element position corresponds to the parameter number. The value is positive only for input/i-o
	#; parameters whose type is a string type.
#DEFINE SPInputParmLen          %qsc(%qacn,25)
#DEFINE DoubleColumns           %qsc(%qacn,26)
#DEFINE DecimalColumns          %qsc(%qacn,27)
	#; OBSOLETE - MultipleRoutines is a 1/0 flag to indicate if the cached query contains multiple routines or not (DPV3199)
#DEFINE MultipleRoutines        %qsc(%qacn,28)
	#; OBSOLETE - If MultipleRoutines is TRUE we need to lock the cached query when it is in use, this will hold the lock reference for the CQ (DPV3199)
#DEFINE CQLockRef	        %qsc(%qacn,29)
	#; SPInterface = 1 if a Query procedure, 0 if not
#DEFINE SPInterface	        %qsc(%qacn,30)
#DEFINE CheckStatus(%qsc) if $$$ISERR(%qsc)  d DecomposeStatus^%apiOBJ(%qsc, .%elst) s %qrc=$$$GETERRORCODE(%qsc) Do FlushError^%SYS.DBSRV(%elst(1)) q

#DEFINE StartRedirect set %qrdr(%qdev)=$g(%qrdr(%qdev))+1 If %qrdr(%qdev)=1 If $zu(82,12,1)
#DEFINE StopRedirect If $g(%qrdr(%qdev)) { set %qrdr(%qdev)=%qrdr(%qdev)-1 if %qrdr(%qdev)=0 If $zu(82,12,0) Use %qdev }
#DEFINE DebugOn Do $ZU(128,3,1)
#DEFINE DebugOff Do $ZU(128,3,0)
 
#DEFINE CPPServerFunction(%fun) ",B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BP,BQ,M1,M2,M3,M4,M5,M6,M7,M8,M9,LI,LO,LQ,LE,BN,MI,MP,MZ,MX,MT,SE,MG,PS,CT,SV,D1,D2,D3,D4,WS,"[(","_%fun_",")
#DEFINE ODBCCatalogFunction(%fun) ",br,c3,ca,co,cp,cr,e3,ek,i3,ik,p3,pc,pk,pr,r3,sc,st,t3,ta,tp,ti,tt,vc,"[(","_%fun_",")
#DEFINE JDBCCatalogFunction(%fun) ",BR,CA,AT,SY,SL,CO,CP,CR,EK,IK,II,PC,PK,PR,SC,TA,TP,TI,TT,UT,VC,FC,FN,CF,CH,"[(","_%fun_",")
 
#DEFINE UseNewContinuationLogic Use io Set x=$zobjexport(1,31)
#DEFINE LCBUseNewContinuationLogic Set x=$zobjexport(1,31)
#DEFINE WriteData(%data) Set x=$zobjexport(%data,18)
#DEFINE WriteRawData(%data) Set x=$zobjexport(%data,5)
#DEFINE	Flush0 Set x=$zobjexport(0,8)
#DEFINE	IfErrorFlush0 Set:'%qrc x=$zobjexport(0,8)
#DEFINE	FlushSignal(%signal) Set x=$zobjexport(%signal,8)
#DEFINE	Flush(%error) Set x=$S(%error>0:$zobjexport(%error,8),1:$zobjexport(-%error,8))
#DEFINE WriteAndFlushHeader(%error) Set x=$zobjexport(%qmsgid,1),x=$zobjexport(%qacn,2),x=$zobjexport(%error,8)
#DEFINE SuperErrorFlush(%msgid,%acn,%error) Set x=$zobjexport(%msgid,1),x=$zobjexport(%acn,2),x=$S(%error>0:$zobjexport(%error,8),1:$zobjexport(-%error,8))
#DEFINE WriteHeader Set x=$zobjexport(%qmsgid,1),x=$zobjexport(%qacn,2)
 
#DEFINE ReadHeader Set %qmsgid=$zobjexport(9),%qacn=$zobjexport(10),%qfun=$zobjexport(15)
#DEFINE ReadNext $zobjexport(12)
#DEFINE ReadNextBytes(%len) $zobjexport(%len,13)
#DEFINE IgnoreMsgInput i $zobjexport(14)
 
#DEFINE ZU151(%d) $zobjexport(%d,7)
#DEFINE ReadSPParameter Set:$zobjexport(17) @("%qpar"_j)=$zobjexport(12)
#DEFINE ReadQuickParameter Set:$zobjexport(17) %qd(i+1)=$zobjexport(12)
 
	#; given an sql query, perform the hash that is used in accessing $$$CQ("Query",5,hash,...)
#DEFINE Hash(%str) $System.Encryption.Base64Encode($System.Encryption.SHA1Hash(%str))
 
#DEFINE Locale $$GetCharset^%SYS.NLS()
#DEFINE IsUnicode $zwc($zbitget($zversion(0),1))
#DEFINE Error404 Try { If ($$$RoutineTimestamp'=$$$CQTimeStamp) || ( ('$$$IAmSuperUser) && ($$$SQLSecurityOn) && ($g($$$PrivilegeInfo)'="") && ('$d($$$CQ("Query",9,$lg($$$PrivilegeInfo),$lg($$$PrivilegeInfo,2),$zu(110),"pu",%uhash)) && ($d($$$CQ("Query",9,$lg($$$PrivilegeInfo),$lg($$$PrivilegeInfo,2),"priv")))) ) { Goto Error404 } } catch { Goto Error404 }
#DEFINE Error404k Try { If ($$$RoutineTimestamp'=$$$CQTimeStamp) || ( ('$$$IAmSuperUser) && ($$$SQLSecurityOn) && ($g($$$PrivilegeInfo)'="") && ('$d($$$CQ("Query",9,$lg($$$PrivilegeInfo),$lg($$$PrivilegeInfo,2),$zu(110),"pu",%uhash)) && ($d($$$CQ("Query",9,$lg($$$PrivilegeInfo),$lg($$$PrivilegeInfo,2),"priv")))) ) { kill %qsc(%qacn,1) Goto Error404 } } catch { Goto Error404 }
	#; Note for Error404SP, a function call is made to ISCProcAll in the local routine.  All uses of $$$Error404SP ar in %SYS.DBSRV.
	#; If $$$Error404SP is ever used elsewhere, this will need to change
#DEFINE Error404SP Try { If '$d($$$RoutineTimestamp) || ($g($$$RoutineName)="") || ($$$RoutineTimestamp'=$$$SPTimeStamp) || ( ('$$$IAmSuperUser) && ($$$SQLSecurityOn) && ('$$ISCProcAll($$$UPPER($$$AllButLastPiece($e($$$SPPrivilegeParam,3,9999),".")),$$$UPPER($tr($$$LastPiece($$$SPPrivilegeParam,"."),$c(2),".")))) && ('$d($$$SecurityGlobalSQLPriv($namespace,0,$$$SPPrivilegeParam,"e",$Username)) && ('$d(^("_PUBLIC"))) && ($$rolechek^%SYS.SQLSEC($namespace,$$$SPPrivilegeParam,"e",0)) && ($$OwnerCheck^%SYS.SQLSEC($$$SPPrivilegeParam))) ) { Goto Error404 } } catch { Goto Error404 }
#DEFINE SetEventClass Set:%0CacheEventClass=$c(0) %0CacheEventClass="" Set:%0CacheEventClass'="" %0CacheEvent=1
 
#DEFINE CheckStream(%handle) If '$isobject(%handle) { Set x=$zobjexport(411,8) Quit } ElseIf (%handle.IsNull()) { Set x=$zobjexport(403,8) Kill %handle Quit } ElseIf (%handle.Size<0) { Set x=$zobjexport(412,8) Kill %handle Quit }
 
	#; If we are in Deferred Compilation Mode, any pending class compilations have to
	#; be completed before accessing catalog queries - so the information is accurate
#DEFINE CheckDeferred Do:$G(^mtemp2($namespace,"Deferred Compile Mode")) CompileDeferredList^%apiDDL2(.%qrc)
	#; DPV2524= #DEFINE PurgeOnLogoff If +$G($$$CQ("LastPurge"))'=+$H Set ^("LastPurge")=$H Do Purge^%SYS.SQLSRV("")
#DEFINE DropCursorsOnLogoff	Set %qacn="" For  Set %qacn=$O(%qsc(%qacn)) Quit:%qacn=""  Do CloseUp()
	; READ_COMMITED and READ_UNCOMMITED (conc=3) ; READ_UNCOMMITED only (conc=1)
#DEFINE SetConcurrency Set conc=3 Set:$zbitget($zversion(0),21)=0 conc=1
#DEFINE CheckSPError If $$$ISERR(rc) { Do ProcessError^%ourProcedure(rc,%sqlcontext,.%qrc,.%msg) Do Logerr^%SYS.SQLSRV(%qrc,"","SP",.%msg) Set SQLCODE=%qrc }
#DEFINE StartTransactionIfAutocommitOff If $ZU(115,1)=2,'$TLEVEL TSTART
#DEFINE SetErrorTrap Set $ZT="Error",$ZE=""
#DEFINE SetMainErrorTrap Set:$ZT'="Error^%SYS.DBSRV" $ZT="Error",$ZE=""
#;JO2062, change 108 to $$$ODBCSRV
#DEFINE IdentifyAsXDBCProcess If $zu(67,10,$$$ODBCSRV,$j)
#DEFINE IdentifyAsLCBProcess If $zu(67,10,$$$LCBTYPE,$j)
	#; There are times %qsc(%qacn) may not be defined, like after USE <database> command
#DEFINE RoutineChange If $g(%qsc(%qacn))'="",$LG($G($$$CQ("QueryRoutine",%qsc(%qacn))),5) { $$$SuspendTrans d PurgeRtn^%SYS.SQLSRV(%qsc(%qacn)) k %qsc(%qacn) $$$ResumeTrans }
#DEFINE ReadQueryParameters Set x=$$$ReadNext For i=1:1:$$$ReadNext Set %qpar(i)=$$$ReadNext

	#; Normalize stream handle.  If the length of the stream id is > 180 characters in length, we assume it is a stream Oid and we hash it soe it will fit 
	#; in the Subscript of the %qobjhandle() array without getting a <SUBSCRIPT> error
#DEFINE NormalizeStreamId(%s) $s($l(%s)'>180:%s,1:$$$Hash(%s))
