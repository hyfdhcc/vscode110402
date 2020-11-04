Class %BI.WebCdnEditor [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod retCond(valIn, chc, wTrgt)
{
	w "timeOut=1;"
	i $E(valIn,1,2)="a$" s valIn = $E(valIn,3,*)
	s dimeID = $P(valIn,$C(1),1)
	
	s selMea2 = $P($P(valIn,$C(1),2),$C(2),1)
	s selMea3 = $P($P(valIn,$C(1),2),$C(2),2)
	s currClass = %session.Get("AnalyzerBaseCls")
	s cls = $P(currClass,$C(3),1)
	s dimeNm=""
	
	i wTrgt=5 s dimeNm = $LG(%session.Data("rowM",selMea2),3)
	i wTrgt=6 s dimeNm = $LG(%session.Data("colM",selMea2),3)
	s CatID = $O(^BI.CategoryI("Cat",cls,dimeNm,""))
	s valIn=CatID_$C(1)_selMea2_$C(2)_selMea3
	/*i dimeID="" {
		s selMea2 = $P(valIn,$C(1),2)
		s currClass = %session.Get("AnalyzerBaseCls")
		s cls = $P(currClass,$C(3),1)
		s dimeNm=""
		
		i wTrgt=5 s dimeNm = $LG(%session.Data("rowM",selMea2),3)
		i wTrgt=6 s dimeNm = $LG(%session.Data("colM",selMea2),3)
		s CatID = $O(^BI.CategoryI("Cat",cls,dimeNm,""))
		s valIn=CatID_$C(1)_selMea2
	} else {
		i $G(^BI.CategoryD(dimeID))="" {
			
		}
	}*/
	s %session.Data("selMea") = valIn
	s %session.Data("wTrgt") = wTrgt	// Added by Kok Hong on 24-09-04
	q 1
}

ClassMethod LoadCondition(cond)
{
	;startQuery,sortKey,MaxCond,searchCond
	d LoadCondition^%bi.SWr.WebCdnEditor(cond)
}

// Added by Kok Hong on 24-09-04

ClassMethod LoadCondHist()
{
	d LoadCondHist^%bi.SWr.WebCdnEditor()
}

// -----------------------------------------

ClassMethod ReLoadCondition(condBegin)
{
	d ReLoadCondition^%bi.SWr.WebCdnEditor(condBegin)
}

// Added by Kok Hong on 24-09-24

ClassMethod showNext()
{
	d showNext^%bi.SWr.WebCdnEditor()
}

// Added by Kok Hong on 24-09-24

ClassMethod showPrevious()
{
	d showPrevious^%bi.SWr.WebCdnEditor()
}

}
