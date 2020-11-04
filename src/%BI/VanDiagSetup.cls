Class %BI.VanDiagSetup [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DSav(Nam, Qry)
{
	d DSav^%bi.SWr.VanDiagSetup(Nam,Qry)
}

ClassMethod GetClsName(clsId)
{
	d GetClsName^%bi.SWr.VanDiagSetup(clsId)
}

ClassMethod SetAnalBaseSes(CurrClass, clsId)
{
	d SetAnalBaseSes^%bi.SWr.VanDiagSetup(CurrClass,clsId)
}

ClassMethod DSaveVenn(Stat, CurrVenn, VennName, VennSchemaId, VennFoldId, DaQry, VennMeasure, ColorID)
{
	d DSaveVenn^%bi.SWr.VanDiagSetup(Stat,CurrVenn,VennName,VennSchemaId,VennFoldId,DaQry,VennMeasure,ColorID)
}

ClassMethod LoadThisFIle(VennId)
{
	d LoadThisFIle^%bi.SWr.VanDiagSetup(VennId)
}

ClassMethod DeleteVenn(CurrVenn)
{
	d DeleteVenn^%bi.SWr.VanDiagSetup(CurrVenn)
}

ClassMethod LoadMeasure(clsId)
{
	d LoadMeasure^%bi.SWr.VanDiagSetup(clsId)
}

ClassMethod DisplayRes(DaQry)
{
	d DisplayRes^%bi.SWr.VanDiagSetup(DaQry)
}

ClassMethod SetListingSession(Cls, Qry, St)
{
	d DGetListing^%bi.SWr.VanDiagSetup(Cls,Qry,St)
}

ClassMethod SetTheCtxMenu(St, qrynum)
{
	d SetTheCtxMenu^%bi.SWr.VanDiagSetup(St,qrynum)
}

ClassMethod WhatIs(st)
{
	
	s %session.Data("ST")=st	
	d WhatIs^%bi.SWr.VanDiagSetup
}

ClassMethod FirstLoad()
{
	d FirstLoad^%bi.SWr.VanDiagSetup()
}

ClassMethod SetVennTable(VID)
{
	d SetVennTable^%bi.SWr.VanDiagSetup(VID)
}

ClassMethod DChgTest(VID, dCls, col, TWidth, THeight, DivId)
{
	d DChgTest^%bi.SWr.VanDiagSetup2(VID,dCls,col,TWidth,THeight,DivId)
}

ClassMethod LoadWizSchema()
{
	d LoadWizSchema^%bi.SWr.VanDiagSetup2
}

}
