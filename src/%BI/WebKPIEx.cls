Class %BI.WebKPIEx [ Abstract, Not ProcedureBlock, System = 4 ]
{

// done by chris 10/9/2004

ClassMethod LoadPivotTableJS()
{
	
	d LoadPivotTableJS^%bi.SWrt.WebKPI
}

ClassMethod LoadKPI(id)
{
	
	d LoadKPI^%bi.SWrt.WebKPI(id)
}

ClassMethod LoadMeasure(val)
{
	
	d LoadMeasure^%bi.SWrt.WebKPI(val)
}

ClassMethod saveKPI(id, queryVal, formulaVal, filename, folderid, min, max, activate, DataMart, strmeasure, kpiDR, KeepSt)
{
	s theID = $$saveKPI^%bi.SWrt.WebKPI(id,queryVal,formulaVal,filename,folderid,min,max,activate,DataMart,strmeasure,kpiDR,KeepSt)
	q theID
}

ClassMethod SaveStaticQ(id, ConT)
{
	d SaveStaticQ^%bi.SWrt.WebKPI(id,ConT)
}

ClassMethod createSelectMeasureJS()
{
	d createSelectMeasureJS^%bi.SWrt.WebKPIQuery("selmeasure","1")
}

ClassMethod setClasses(id)
{
	d setClasses^%bi.SWrt.WebKPI(id)
}

ClassMethod setKPIBaseCls(baseCls)
{
	q $$setKPIBaseCls^%bi.SWrt.WebKPIQuery(baseCls)
}

ClassMethod saveValueRange(id, val)
{
	
	d saveValueRange^%bi.SWrt.WebKPIValueRange(id,val)
}

ClassMethod saveChildList(id, val)
{
	
	d saveChildList^%bi.SWrt.WebKPIChild(id,val)
}

ClassMethod getImageName(id, propertyName)
{
	
	//W "alert('id = "_id_" propoer = "_propertyName_"');"
	d getImageName^%bi.SWrt.WebKPIValueRange(id,propertyName)
}

ClassMethod delKPI(id)
{

	d delKPI^%bi.SWrt.WebKPI(id)
}

ClassMethod loadSchema()
{

	d loadSchema^%bi.SWrt.WebKPIQuery
}

ClassMethod iniLoadKPI()
{
	//d iniLoad^%bi.SWrt.WebKPI
}

ClassMethod loadTree(div)
{
	
	d loadTree^%bi.SWrt.WebKPI(div)
	//d iniLoad^%bi.SWrt.WebKPI
}

ClassMethod loadMeasure2(id)
{
	
	d loadMeasure^%bi.SWrt.WebKPI(id)
	//d iniLoad^%bi.SWrt.WebKPI
}

ClassMethod loadKPIQueryVar(zzKPI, zzFilter, zzQueryVar)
{

	d loadKPIQueryVar^%bi.SWrt.WebKPIChild(zzKPI,zzFilter,zzQueryVar)
}

ClassMethod SVGloadKPIQueryVar(zzKPI, zzFilter, zzQueryVar)
{

	d SVGloadKPIQueryVar^%bi.SWrt.WebKPIChild(zzKPI,zzFilter,zzQueryVar)
}

ClassMethod saveQueryVarFormulaVal(data)
{


	d saveQueryVarFormulaVal^%bi.SWrt.WebKPIChild(data)
}

ClassMethod getQueryVarFormulaVal()
{


	q $$getQueryVarFormulaVal^%bi.SWrt.WebKPIChild()
}

ClassMethod saveQueryVar(type, val)
{
	q $$saveQueryVar^%bi.SWrt.WebQueryVar(type,val)
}

ClassMethod getQueryVar(type)
{
	q $$getQueryVar^%bi.SWrt.WebQueryVar(type)
}

ClassMethod getKPIDLid(id)
{
	q $$getKPIDLid^%bi.SWrt.WebKPIDL(id)
}

ClassMethod getKPIByClass(class)
{
	q $$getKPIByClass^%bi.SWrt.WebKPIDL(class)
}

ClassMethod setDetailListID(kpiid, dLid, queryvar)
{
	q $$setDetailListID^%bi.SWrt.WebKPIDL(kpiid,dLid,queryvar)
}

ClassMethod DisplayList(tid, myquery, queryvar)
{
	q $$DisplayList^%bi.SWrt.WebKPIDL(tid,myquery,queryvar)
}

// DisplayList(tid,myquery,queryvar)

ClassMethod setKPICompDL(kpiid, dllid, queryvar)
{
	q $$setKPICompDL^%bi.SWrt.WebKPIDL(kpiid,dllid,queryvar)
}

ClassMethod setKPICompDL2(kpiid, dllid, query, queryvar)
{
	q $$setKPICompDL2^%bi.SWrt.WebKPIDL(kpiid,dllid,query,queryvar)
}

ClassMethod getClassWithSubjectid(id)
{
	q $$getClassWithSubjectid^%bi.SWrt.WebKPI(id)
}

ClassMethod getDLbyKPIID(kpiid)
{
	q $$SVGgetDefaultDL^%bi.SWrt.WebKPIDL(kpiid)
}

ClassMethod SVGmenugenerateKPImenu(kpiid)
{
	q $$generateKPImenu^%bi.SWrt.WebSVGSpeedoJS(kpiid)
}

ClassMethod getValueRangeColor(kpiid, val)
{
	q $$getValueRangeColor^%bi.SWrt.WebKPIValueRange(kpiid,val)
}

ClassMethod getDefaultDLbySubjectid(subjectid, type)
{
	q $$getDefaultDLbySubjectid^%bi.SWrt.WebKPIDL(subjectid,type)
}

ClassMethod getClass(subjectid)
{
	
	q $$getClass^%bi.SWrt.WebKPIDL(subjectid)
}

ClassMethod FirstLoadKPI()
{
	d FirstLoadKPI^%bi.SWrt.WebKPIDL()
}

ClassMethod GtMyFolder()
{
	d GtMyFolder^%bi.SWrt.WebKPI()
}

}
