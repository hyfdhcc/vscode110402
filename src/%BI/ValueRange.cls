Class %BI.ValueRange [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadvalRange(id)
{
	d loadvalRange^%bi.SWr.ValueRange(id)
	d loadKPIHistory^%bi.SWr.ValueRange(id)
}

ClassMethod changePic(id)
{
	q $$getPicture^%bi.SWr.WebReporter(id)
}

ClassMethod saveValueRange(id, name, desc, value)
{
	d saveValueRange^%bi.SWr.ValueRange(id,name,desc,value)
}

ClassMethod getKPIname(id)
{
	s obj = ##class(%BI.KPI).%OpenId(id)
	q:obj="" "KPI does not exist"	
	s nm = obj.KPIName
	q nm
}

ClassMethod LinkToValueRange(value, vrid, chk)
{
	if chk=1 k ^ValueRange(vrid,"HISTORY")
	for i = 1:1:$L(value,",") 
	{
		s val = $P(value,",",i)
		s xx =  $$LinkToValueRange^%bi.SWr.ValueRange($P(value,",",i),vrid,chk)	 
		if xx = "OK" s img = "<img src=img/Scheduler/clear2.GIF>"
		else  s img = "<img src=img/Scheduler/x2.GIF alt='"_xx_"'>"
		
		w "document.getElementById(""KPIlist"").rows["_(i-1)_"].cells[0].innerHTML = """_img_""";"
	}
}

ClassMethod deleteValueRange(id)
{
	d deleteValueRange^%bi.SWr.ValueRange(id)
}

ClassMethod getPictureNm(imgId)
{
	s imgObj = 	##class(%BI.ImageList).%OpenId(imgId)
	q:imgObj="" ""
	q imgObj.ImageName
}

}
