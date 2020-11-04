Class %BI.Utils Extends %Library.RegisteredObject [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

ClassMethod KPI(KPIID As %String, Filter As %String, Variables As %String) As %String [ WebMethod ]
{
	n zzQueryVar
	s zzQueryVar=$TR(Variables,":;",$C(5)_$C(4))
    Quit $$KPIV^%bi.SMr.KPI3(KPIID,Filter)
}

ClassMethod Pivot(PivotId As %String, ColumnDelimiter As %String) As %BI.PivotData [ WebMethod ]
{
	// eg. 10386
	n x,line,lineD,i,nLine,lineDHdr,RGH
	
	s x=$$WSLoad^%bi.SMr.Query1d(PivotId,"","")
	i $G(ColumnDelimiter)="" s ColumnDelimiter="^"
	e  i $ZCVT($E(ColumnDelimiter,1),"U")="$C" d RUN^%bi.SMr.KPI3("s ColumnDelimiter="_ColumnDelimiter)
	s line="" f  s line=$O(^mtemp($J,"A","DA",line),1,lineD) q:line=""  d
	. s lineDHdr=$G(^mtemp($J,"A","HR",line))
	. s lineL=$LL(lineDHdr)
	. s nLine=$LG(lineDHdr,1)
	. f i=2:1:lineL s nLine=nLine_ColumnDelimiter_$LG(lineDHdr,i)
	. s lineL=$LL(lineD)
	. f i=1:1:lineL s nLine=nLine_ColumnDelimiter_$LG(lineD,i)
	. s ^mtemp($J,"A","D*",line)=nLine
	
	s RGH=$G(^mtemp($J,"A","RGH")),RGHok="",RGHx=""
	f i=$LL(RGH):-1:1 s RGHok=$LG(RGH,i)_"^"_RGHok,RGHx="^"_RGHx
	
	s line="" f  s line=$O(^mtemp($J,"A","HC",line),1,lineD) q:line=""  d
	. s lineL=$LL(lineD)
	. f i=1:1:lineL d
	.. i line=1 d  q
	... i i=lineL s ^mtemp($J,"A","H*",i)=RGHok_$LG(lineD,i) q
	... s ^mtemp($J,"A","H*",i)=RGHx_$LG(lineD,i)
	.. s ^mtemp($J,"A","H*",i)=^mtemp($J,"A","H*",i)_"^"_$LG(lineD,i)
	
    
    quit ##class(%BI.PivotData).%OpenId($J)
}

}
