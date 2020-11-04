Class %BI.Scorecard [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod addNodeJS(pivID, nodeName, valueSet)
{
	d addNodeJS^%bi.SWr.Scorecard(pivID,nodeName,valueSet)
}

ClassMethod renameNodeJS(pivID, nodeName, valueSet)
{
	d renameNodeJS^%bi.SWr.Scorecard(pivID,nodeName,valueSet)
}

ClassMethod delNodeJS(pivID, valueSet)
{
	d delNodeJS^%bi.SWr.Scorecard(pivID,valueSet)
}

ClassMethod genTreeJS()
{
	/* not being used */
	m arr = ^BI.Scorecard("MODULE")
	d genTreeJS^%bi.SWr.Scorecard(.arr)
}

ClassMethod setProp(pivID, menuStr, cnt)
{
	d setProp^%bi.SWr.Scorecard(pivID,menuStr,cnt)
}

ClassMethod getProp(pivID)
{
	d getProp^%bi.SWr.Scorecard(pivID)
}

ClassMethod loadNextGroupJS(subScipt, nextID, pivID)
{
	d loadNextGroupJS^%bi.SWr.Scorecard(subScipt,nextID,pivID)
}

/*
ClassMethod setScorecard(scName, displayType, decPoint, currKPIID, procOrder, arr, fontSet, fml, pFml)
{
	s rtnValue = $$setScorecard^%bi.SWr.Scorecard(scName,displayType,decPoint,currKPIID,procOrder,arr,fontSet,fml,pFml)
	q rtnValue
}
	*/
ClassMethod getKPI(currKPIID)
{
	s kpiStr = $LG(^BI.KPID(currKPIID),1)
	q "["_currKPIID_"] "_kpiStr
}

ClassMethod setSess(valueSet)
{
	; if $C(6) is represented by the symbol (')
	; s$'fml'valueTxt'displayType'decPoint'procOrder'fontSet'lb'""'currKPIID'""'pFml)
	
	s valueSet = $TR(valueSet,$C(4)," ")
	s $P(valueSet,$C(6),8) = $$dlrTR2^%bi.SWr.WebMain2($P(valueSet,$C(6),8),"$C(13,10)",$C(13,10)) // Fix by Mun Yau on 20/12/2006 to allow newline characters to be loaded to the textarea. 
	s %session.Data("theFormula") = $P(valueSet,$C(6),2)
	s %session.Data("theFormula2") = $P(valueSet,$C(6),12)
	s %session.Data("selectedVal") = $E(valueSet,4,$L(valueSet)) ; begins from 4 b'cos the first 3 will be 's','$' and '$C(6)'
	s %session.Data("daSCPosition") = $P(valueSet,$C(1),2)

	q valueSet	; returns the translated 'valueSet'
}

ClassMethod xsetSess(valueSet)
{
	; if $C(6) is represented by the symbol (')
	; s$'fml'valueTxt'displayType'decPoint'procOrder'fontSet'lb'""'currKPIID'""'pFml)
	
	s valueSet = $TR(valueSet,$C(4)," ")
	s %session.Data("theFormula") = $P(valueSet,$C(6),2)
	s %session.Data("theFormula2") = $P(valueSet,$C(6),12)
	s %session.Data("selectedVal") = $E(valueSet,4,$L(valueSet)) ; begins from 4 b'cos the first 3 will be 's','$' and '$C(6)'
	s %session.Data("daSCPosition") = $P(valueSet,$C(1),2)

	q valueSet	; returns the translated 'valueSet'
}

ClassMethod killSess()
{
	; if $C(6) is represented by the symbol (')
	; s$'fml'valueTxt'displayType'decPoint'procOrder'fontSet'lb'""'currKPIID'""'pFml)
	
	k %session.Data("theFormula")
	k %session.Data("theFormula2")
	;s %session.Data("selectedVal") = $E(valueSet,4,$L(valueSet)) ; begins from 4 b'cos the first 3 will be 's','$' and '$C(6)'
	;s %session.Data("daSCPosition") = $P(valueSet,$C(1),2)

	q
}

ClassMethod editMenuTree(trgt, valueSet, valueTxt)
{
	s valueSet = valueSet_$C(6,1)_%session.Data("daSCPosition")
	d editMenuTree^%bi.SWr.WebAnalyzer(trgt, valueSet, valueTxt)
}

}
