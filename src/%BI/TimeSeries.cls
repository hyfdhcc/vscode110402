Class %BI.TimeSeries [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod setTimeSeries(tsName, disType, startVal, incVal, endVal, fontSet, filQuery)
{
	;s rtnValue = $$setTimeSeries^%bi.SWr.TimeSeries(tsName,disType,startVal,incVal,endVal,fontSet,filQuery)
	;q rtnValue
	q "t$"_$C(6)_disType_$C(6)_tsName_$C(6)_startVal_$C(6)_incVal_$C(6)_endVal_$C(6)_fontSet_$C(6)_filQuery
}

ClassMethod setSess(action, valueSet)
{
	; this classmethod is reused by Labels
	s valueSet = $TR(valueSet,$C(4)," ")
	
	i (action = 2) {
		s %session.Data("selectedVal") = $E(valueSet,4,$L(valueSet)) ; begins from 4 b'cos the first 3 will be 't','$' and '$C(6)'
		s %session.Data("daTSPosition") = $P(valueSet,$C(1),2)
	}
	
	q valueSet	; returns the translated 'valueSet'
}

ClassMethod editMenuTree(trgt, valueSet, valueTxt)
{
	s valueSet = valueSet_$C(6,1)_%session.Data("daTSPosition")
	d editMenuTree^%bi.SWr.WebAnalyzer(trgt, valueSet, valueTxt)
}

}
