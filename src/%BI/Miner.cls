Include %occInclude

IncludeGenerator %occInclude

/// Hyperindex Generator class
Class %BI.Miner Extends (%BI.MinerParams, %Populate) [ Abstract, ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

ClassMethod zzDeleteAllIdx() [ ProcedureBlock = 0 ]
{
 k ^BIidx.HiTemp,^BIidx.Param,^BI.CategoryD,^BI.CategoryI,^BIidx.Col,^BIidx.Cols,^BIidx.ConditionD,^BIidx.ConditionI,^BIidx.Hi,^BIidx.Id,^BIidx.Link,^BIidx.Companion
 quit
}

ClassMethod zzCompress() [ ProcedureBlock = 0 ]
{
 d Compress^%bi.SMr.MinerU2(..%ClassName(1),"",0)
 quit
}

ClassMethod zzDeleteCondition(Class As %Library.String, CatName As %Library.String, CondName As %Library.String) [ ProcedureBlock = 0 ]
{
 &SQL(DELETE FROM %BI.Condition where Class = :Class AND Category->CategoryName=:CatName AND ShortName=:CondName)
 quit
}

Method SpeedOnAfterSave(insert) As %Status [ Final, ProcedureBlock = 0 ]
{
 new Id,class,mode,sc
 if $get(HiSkipUpdate) quit 1 ; set by user to skip the rebuild
 X "set Id=..%Id(),class=..%ClassName(1)"
 set zzClassNZ=$$gClass^%bi.SMr.Main(class)

 ; if in delayed mode, just set the trigger
 set mode=$lg($get(^BIidx.Hi),1)
 if mode>1 set ^BIidx.Hi(zzClassNZ,"Upd",Id)=insert quit $$$OK

 ; else (immediate mode) update indices
 ;i '$G(^BI.Class(class,"Option")) {
 ;	set sc=..Build(Id)
 ;}
 ;else {
 	set sc=$zobjclassmethod(class,"zzBuildOne",Id)
 ;}
 ;if $$$ISERR(sc) quit sc
 ;set sc=##class(%BI.MinerUtils).SetCompoundConditionsOneRecord(class,Id)
 quit sc
}

Method %OnAfterSave(insert) As %Status [ Final, ProcedureBlock = 0 ]
{
	Quit ..SpeedOnAfterSave(insert)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ProcedureBlock = 0, ServerOnly = 1 ]
{
	Quit ..SpeedOnDelete(oid)
}

ClassMethod SpeedOnDelete(oid) As %Status [ CodeMode = generator, Final, ProcedureBlock = 0 ]
{

 /* Generated code :
 new class,Id,sc,mode
 set class="<class>",Id=$lg(oid),sc=$$$OK
 ; if in delayed mode, just set the trigger
 set mode=$lg($get(^BIidx.Hi),1)
 if mode>1 set ^BIidx.Hi(class,"Upd",Id)=-1 quit $$$OK
 ; else (immediate mode) update indices
 set sc=##class(%BI.MinerUtils).Delete(class,Id)		
 quit sc

 */
 ;if @%parameter("ExitGenerator") quit $$$OK

 q:%class="%BI.Miner" 1
 $$$GENERATE(" new class,Id,sc,mode")
 $$$GENERATE(" set class="""_%class_""",Id=$lg(oid),sc=$$$OK")
 $$$GENERATE(" ;if in delayed mode, just set the trigger")
 $$$GENERATE(" ;set mode=$lg($get(^BIidx.Hi),1)")
 $$$GENERATE(" ;if mode>1 set ^BIidx.Hi(class,""Upd"",Id)=-1 quit $$$OK")
 $$$GENERATE(" set sc=##class(%BI.MinerUtils).Delete(class,Id)")
 $$$GENERATE(" quit sc")
 quit $$$OK
}

ClassMethod zzBuild(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	set sc=$$$OK,zzQUICK=1
	do Build^%bi.SMr.Miner1a(1)
	quit sc
}

ClassMethod zzBuildDebug(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	set sc=$$$OK,zzQUICK=1
	do Build^%bi.SMr.Miner1a(1,1)
	quit sc
}

ClassMethod zzSBuild(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	set sc=$$$OK,zzQUICK=1
	do Build^%bi.SMr.Miner1a(2)
	quit sc
}

ClassMethod zzInitProc() As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	set sc=$$$OK
	do InitProc^%bi.SMr.Miner1
	quit sc
}

ClassMethod zzBuildOne(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 q:%class="%BI.Miner" 1
 $$$GENERATE(" set zzClassNZ=$$gClass^%bi.SMr.Main("""_%class_""")")
 $$$GENERATE(" i '$D(SPEEDV(""INIT "_%class_""")) s sc=$zobjclassmethod("""_%class_""",""zzInitProc"")")
 i '$LG($G(^BI.Class(%class,"Option")),1) d
 . $$$GENERATE(" set %this=##class("_%class_").%OpenId(Id),sc=0")
 ;$$$GENERATE(" do ClrRec^%bi.SMr.Miner3("""_%class_""",zzClassNZ,Id)")
 $$$GENERATE(" set sc=##class("_%class_").zzBuild(Id)")
 $$$GENERATE(" i sc set sc=##class(%BI.MinerUtils).SetCompoundConditionsOneRecord("""_%class_""",Id)")
 $$$GENERATE(" i '$D(SPEEDV(""INIT "_%class_""")) d ClrAll^%bi.SMr.Miner3("""_%class_""")")
 $$$GENERATE(" quit sc")
 quit sc
}

ClassMethod zzQBuildOne(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 q:%class="%BI.Miner" 1
 i '$LG($G(^BI.Class(%class,"Option")),1) d
 . $$$GENERATE(" set %this=##class("_%class_").%OpenId(Id),sc=0")
 $$$GENERATE(" set zzClassNZ=$$gClass^%bi.SMr.Main("""_%class_""")")
 ;$$$GENERATE(" do ClrRec^%bi.SMr.Miner3("""_%class_""",zzClassNZ,Id)")
 $$$GENERATE(" set sc=##class("_%class_").zzBuild(Id)")
 $$$GENERATE(" ;i sc set sc=##class(%BI.MinerUtils).SetCompoundConditionsOneRecord("""_%class_""",Id)")
 $$$GENERATE(" quit sc")
 quit sc
}

/// Rebuild ^SpeedI.Hi for the class.
/// This method is only preserved for backwards compatibility - you can call Speed.MinerUtils.FastRebuild() directly
ClassMethod zzFastRebuild(SortSize = 256) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 q:%class="%BI.Miner" 1
 $$$GENERATE(" quit ##class(%BI.MinerUtils).FastRebuild("""_%class_""",SortSize)")
}

/// Calls the Populate() method for the target class,
/// with journalling and TP disabled (unless mode is 4 or 5)
ClassMethod PopulateData(Count, Verbose, Defer) As %Integer [ CodeMode = generator, ProcedureBlock = 0 ]
{
 ; This has to be a generator because Cache 5.0 beta 3 gives error on ..Populate()
 ; if this does not exist, but accepts ##class(<theclass>).Populate()
 q:%class="%BI.Miner" 1
 $$$GENERATE(" new mode,tp,jrn,saved,ze")
 $$$GENERATE(" set $zt=""poperror""")
 $$$GENERATE(" set mode=$lg($get(^BIidx.Hi),1)")
 $$$GENERATE(" if mode<4 do")
 $$$GENERATE(" . set tp=$$SetTransactionMode^%apiOBJ(0) ; stop TP")
 $$$GENERATE(" . set jrn=$$CURRENT^%NOJRN if jrn do DISABLE^%NOJRN ; stop jrn")
 $$$GENERATE(" if '$data(Count) set saved=##class("_%class_").Populate()")
 $$$GENERATE(" else  if '$data(Verbose) set saved=##class("_%class_").Populate(Count)")
 $$$GENERATE(" else  if '$data(Defer) set saved=##class("_%class_").Populate(Count,Verbose)")
 $$$GENERATE(" else  set saved=##class("_%class_").Populate(Count,Verbose,Defer)")
 $$$GENERATE(" if mode<4 do")
 $$$GENERATE(" . if jrn do ENABLE^%NOJRN ; restart jrn")
 $$$GENERATE(" . if tp set Id=$$SetTransactionMode^%apiOBJ(1) ; restart TP")
 $$$GENERATE(" quit saved")
 $$$GENERATE("poperror set ze=$ze")
 $$$GENERATE(" if mode<4 do")
 $$$GENERATE(" . if jrn do ENABLE^%NOJRN ; restart jrn")
 $$$GENERATE(" . if tp set Id=$$SetTransactionMode^%apiOBJ(1) ; restart TP")
 $$$GENERATE(" if ze?1""<METHOD DOES NOT EXIST>"".e quit -1")
 $$$GENERATE(" quit saved")
}

/// Rebuild ^SpeedI.Hi for the class.
/// This method rebuilds it quite slowly, and creates a fragmented
/// file, but the class remains queryable all the time.
/// (Do not kill ^SpeedI.Condition* as it may contain manual compound conditions).
ClassMethod HiRebuild(option, user) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
    q:%class="%BI.Miner" 1
	set sc=$$$OK
	do ReBuild^%bi.SMr.Miner1a(1)
	quit sc
}

ClassMethod HiDebug(JobId, buildcnt) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
    q:%class="%BI.Miner" 1
	set sc=$$$OK
	do ReDebug^%bi.SMr.Miner1a
	quit sc
}

/// builopt = 1 build batch relationship
ClassMethod SelectBuild(builopt, user) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
    q:%class="%BI.Miner" 1
	set sc=$$$OK
	do ReBuild^%bi.SMr.Miner1a(2)
	;do IncBuild^%bi.SMr.Miner1c($G(user))
	quit sc
}

ClassMethod zzBuildProcess(jobid, jobseq) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	set sc=$$$OK
	do BuildProcess^%bi.SMr.Miner1(1)
	quit sc
}

ClassMethod zzSBuildProcess(jobid, jobseq) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	set sc=$$$OK
	do BuildProcess^%bi.SMr.Miner1(2)
	quit sc
}

/// Split a time field into its various indices
ClassMethod zzTime(Class, Cat, val, Col, chunk, offset, nullidx) [ ProcedureBlock = 0 ]
{
	do HiTime^%bi.SMr.Miner1
	quit
}

/// Split a time field into its various ranges.
/// Params:       -to[name],from-to[name],from-to[name],from-to[name],...,from-[name]
/// Each from/to must be valid time (accepted by $zth(x))
/// [ assumes non-overlapping, increasing ranges ]
ClassMethod zzTimeRanges(Class, Cat, val, Params, Col, chunk, offset) [ ProcedureBlock = 0 ]
{
	do HiTimeRanges^%bi.SMr.Miner1
	quit
}

ClassMethod ListHeader(ComId) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do ListHdr^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod DrillDownList(ComId) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do DrillDownList^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod DrillDownData(DDId, RecId) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do DrillDownData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod ListData(%this, ComId, Col) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	
 	q:%class="%BI.Miner" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do ListData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod SaveAIData(ComId, dat, Id) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do SaveAIData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

Method SimQueryData(ComId, Col) As %Status [ CodeMode = generator, Final, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Miner" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do SimQueryData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

Trigger HyperDelete [ Event = DELETE, Order = 1, Time = AFTER ]
{
 new class,Id,o
 ;dirty trick to get the class, will not work with long classnames !
 set class=$p($zn,".",1,$l($zn,".")-1) if class="" quit
 ;dirty trick to get the Id - this probably only works for simple classes
 set Id=$g(%d(1)) if Id="" quit
 do ##class(%BI.MinerUtils).Delete(class,Id)
 quit
}

Trigger HyperInsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
 new class,Id,o
 ;dirty trick to get the class, will not work with long classnames !
 set class=$p($zn,".",1,$l($zn,".")-1) if class="" quit
 ;dirty trick to get the Id - this probably only works for simple classes
 set Id=$g(%d(1)) if Id="" quit
 set o=$zobjclassmethod(class,"%OpenId",Id) if o="" quit
 do $zobjmethod(o,"%OnAfterSave",1)
 do $zobjmethod(o,"%Close")
 quit
}

Trigger HyperUpdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
 new class,Id,o
 ;dirty trick to get the class, will not work with long classnames !
 set class=$p($zn,".",1,$l($zn,".")-1) if class="" quit
 ;dirty trick to get the Id - this probably only works for simple classes
 set Id=$g(%d(1)) if Id="" quit
 set o=$zobjclassmethod(class,"%OpenId",Id) if o="" quit
 do $zobjmethod(o,"%OnAfterSave",0)
 do $zobjmethod(o,"%Close")
 quit
}

}
