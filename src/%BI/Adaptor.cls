Include %occInclude

IncludeGenerator %occInclude

/// Hyperindex Generator class 
Class %BI.Adaptor Extends %BI.MinerParams [ Abstract, ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
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
 new Id,class,mode,sc,ccode
 if $get(HiSkipUpdate) quit 1 ; set by user to skip the rebuild
 X "set Id=..%Id(),class=..%ClassName(1)"

 s ccode=$G(^SYS("BI","CFG","Configuration","OLAP",0,6))
 if ccode'="" X ccode
 if '$G(^SYS("BI","CFG","Configuration","ETL",0,2)) quit 1
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

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ ProcedureBlock = 0, ServerOnly = 1 ]
{
	Quit ..SpeedOnDelete(oid)
}

ClassMethod SpeedOnDelete(oid) As %Status [ CodeMode = generator, Final, ProcedureBlock = 0 ]
{
 q:%class="%BI.Adaptor" 1
 $$$GENERATE(" new class,Id,sc,mode")
 $$$GENERATE(" set class="""_%class_""",Id=$lg(oid),sc=$$$OK")
 $$$GENERATE(" set sc=##class(%BI.MinerUtils).Delete(class,Id)")
 $$$GENERATE(" quit sc")
 quit $$$OK
}

ClassMethod zzBuild(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	set sc=$$$OK,zzQUICK=1
	do Build^%bi.SMr.Miner1a(1)
	quit sc
}

ClassMethod zzBuildDebug(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	set sc=$$$OK,zzQUICK=1
	do Build^%bi.SMr.Miner1a(1,1)
	quit sc
}

ClassMethod zzSBuild(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	set sc=$$$OK,zzQUICK=1
	do Build^%bi.SMr.Miner1a(2)
	quit sc
}

ClassMethod zzInitProc() As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	set sc=$$$OK
	do InitProc^%bi.SMr.Miner1
	quit sc
}

ClassMethod zzBuildOne(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 q:%class="%BI.Adaptor" 1
 $$$GENERATE(" new %this,sc,zzClassNZ")
 $$$GENERATE(" set zzClassNZ=$$gClass^%bi.SMr.Main("""_%class_""")")
 $$$GENERATE(" i '$D(SPEEDV(""INIT "_%class_""")) s sc=$zobjclassmethod("""_%class_""",""zzInitProc"")")
 i '$LG($G(^BI.Class(%class,"Option")),1) d
 . s isRegObj=($G(^oddCOM(%class,60))["RegisteredObject")
 . i 'isRegObj $$$GENERATE(" set %this=##class("_%class_").%OpenId(Id)")
 . e  d
 .. n qry
 .. s qry=$O(^oddCOM(%class,"q",""))
 .. $$$GENERATE(" set %this=""""")
 .. $$$GENERATE(" set rs=##class(%ResultSet).%New("""_%class_":"_qry_""")")
 .. $$$GENERATE(" i rs'="""" {s sc=rs.Execute(Id) i sc {i rs.Next() {s %this=rs}}}")
 . $$$GENERATE(" set sc=0")
 ;$$$GENERATE(" do ClrRec^%bi.SMr.Miner3("""_%class_""",zzClassNZ,Id)")
 $$$GENERATE(" set sc=##class("_%class_").zzBuild(Id)")
 $$$GENERATE(" i sc set sc=##class(%BI.MinerUtils).SetCompoundConditionsOneRecord("""_%class_""",Id)")
 $$$GENERATE(" i '$D(SPEEDV(""INIT "_%class_""")) d ClrAll^%bi.SMr.Miner3("""_%class_""",Id)")
 $$$GENERATE(" quit sc")
 quit sc
}

ClassMethod zzQBuildOne(Id) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 q:%class="%BI.Adaptor" 1
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
 q:%class="%BI.Adaptor" 1
 $$$GENERATE(" quit ##class(%BI.MinerUtils).FastRebuild("""_%class_""",SortSize)")
}

/// Rebuild ^SpeedI.Hi for the class.
/// This method rebuilds it quite slowly, and creates a fragmented
/// file, but the class remains queryable all the time.
/// (Do not kill ^SpeedI.Condition* as it may contain manual compound conditions).
ClassMethod HiRebuild(option, user) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
    q:%class="%BI.Adaptor" 1
	set sc=$$$OK
	do ReBuild^%bi.SMr.Miner1a(1)
	quit sc
}

ClassMethod HiDebug(JobId, buildcnt) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
    q:%class="%BI.Adaptor" 1
	set sc=$$$OK
	do ReDebug^%bi.SMr.Miner1a
	quit sc
}

/// builopt = 1 build batch relationship
ClassMethod SelectBuild(builopt, user) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
    q:%class="%BI.Adaptor" 1
	set sc=$$$OK
	do ReBuild^%bi.SMr.Miner1a(2)
	;do IncBuild^%bi.SMr.Miner1c($G(user))
	quit sc
}

ClassMethod zzBuildProcess(jobid, jobseq) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	set sc=$$$OK
	do BuildProcess^%bi.SMr.Miner1(1)
	quit sc
}

ClassMethod zzSBuildProcess(jobid, jobseq) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
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
 	q:%class="%BI.Adaptor" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do ListHdr^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod DrillDownList(ComId) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do DrillDownList^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod DrillDownData(DDId, RecId) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do DrillDownData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod ListData(%this, ComId, Col) As %Status [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	
 	q:%class="%BI.Adaptor" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do ListData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

ClassMethod SaveAIData(ComId, dat, Id) As %String [ CodeMode = generator, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do SaveAIData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

Method SimQueryData(ComId, Col) As %Status [ CodeMode = generator, Final, ProcedureBlock = 0 ]
{
 	q:%class="%BI.Adaptor" 1
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	do SimQueryData^%bi.SMr.Miner1
	set sc=$$$OK
	quit sc
}

Trigger HyperDelete [ Event = DELETE, Order = 1, Time = AFTER ]
{
 new class,Id,o
 set class={%%CLASSNAMEQ} quit:class=""
 set Id={%%ID} quit:Id=""
 do ##class(%BI.MinerUtils).Delete(class,Id)
 quit
}

Trigger HyperInsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
 new class,Id,o
 set class={%%CLASSNAMEQ} quit:class=""
 set Id={%%ID} quit:Id=""
 set o=$zobjclassmethod(class,"%OpenId",Id) quit:o=""
 do $zobjmethod(o,"%OnAfterSave",1)
 do $zobjmethod(o,"%Close")
 quit
}

Trigger HyperUpdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
 new class,Id,o
 set class={%%CLASSNAMEQ} quit:class=""
 set Id={%%ID} quit:Id=""
 set o=$zobjclassmethod(class,"%OpenId",Id) quit:o=""
 do $zobjmethod(o,"%OnAfterSave",0)
 do $zobjmethod(o,"%Close")
 quit
}

}
