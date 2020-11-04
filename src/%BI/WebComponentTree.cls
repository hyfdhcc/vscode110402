Class %BI.WebComponentTree [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod FilterCount(dm, qr)
{
	s cnt =  $$CntMatch^%bi.SMr.MinerUtils1(dm,qr,"") 	
	w "filtercnt.value = """_cnt_""";"
}

ClassMethod SavePivot(nm, desc, foldId, foldNm, pivId)
{
	d saveAsPivot^%bi.SWr.WebAnalyzer2(nm,desc,"0",foldId,foldNm,"","","",$LB(,,),"",pivId,"","0^"_$c(3,3,3,3,3,3,3,3),"0^"_$c(3,3,3,3,3,3,3,3),$c(2,2,3)_"1","analite")
}

ClassMethod resetClass(P0)
{
	s DM = $O(^SYS("BI","DM","CLS",P0,""))
	s DMNm = $P(^SYS("BI","DM","Data",DM),$C(3),1)
	s %session.Data("AnalyzerBaseCls") = P0_$C(3)_DM_$C(3)_$C(3)_$C(3)_DMNm
	s %session.Data("AnlBaseCls") = DMNm
}

ClassMethod OpenPivot(id)
{
	//w "alert();"
	d OpenPivot^%bi.SWr.WebComponentTree(id)
}

ClassMethod resetall(trgt, value)
{
	d resetall^%bi.SWr.WebComponentTree(trgt,value)
}

ClassMethod SingleCond(dimId, nm, chk)
{
	d SingleCond^%bi.SWr.WebComponentTree(dimId,nm,chk)
}

ClassMethod tempMetric(met)
{
	d tempMetric^%bi.SWr.WebComponentTree(met)
}

ClassMethod LoadDimension(dim, bId)
{
	d LoadDimension^%bi.SWr.WebComponentTree(dim,bId)
}

ClassMethod LoadFilter(dim, xx)
{
	d LoadFilter^%bi.SWr.WebComponentTree(dim,xx)
}

ClassMethod SetTree(trgt, string)
{
	d SetTree^%bi.SWr.WebComponentTree(trgt,string)
}

ClassMethod setColRowDim(set, txt, trgt)
{
	d setColRowDim^%bi.SWr.WebComponentTree(set,txt,trgt)
}

ClassMethod loadedDim()
{
	d loadedDim^%bi.SWr.WebComponentTree
}

ClassMethod setShow(row, col)
{
	k ^Tmp
	s ^Tmp("analite","row") = row
	s ^Tmp("analite","col") = col
}

ClassMethod setMetric(met)
{
	for x = 1:1:$L(met,"//") if $P(met,"//",x)'="" s ^Tmp("analite","met",x) = $P(met,"//",x)
}

ClassMethod setCondition(trgt, data)
{
	for x = 1:1:$L(data,$C(3)) 
	{
		s dat = $P(data,$C(3),x)
		if dat '= "" d
		.s nm = $P(dat,"=",1)
		.s conDat = $P(dat,"=",2)
		.s ^Tmp("anaCond",trgt,nm) = conDat
	}
}

ClassMethod LoadCondition(CondId, CondNm, class, trgt, pg, trgtVal)
{
	d LoadCondition^%bi.SWr.WebComponentTree(CondId,CondNm,class,trgt,pg,trgtVal)
}

ClassMethod LoadConditions3(valueSet, valueTxt, sa, trgt)
{
	d LoadConditions3^%bi.SWr.WebComponentTree(valueSet,valueTxt,sa,trgt)
}

ClassMethod setAll(CondId, CondNm, class, chk, target)
{
	d setAll^%bi.SWr.WebComponentTree(CondId,CondNm,class,chk,target)
}

ClassMethod setMenuTree(trgt, valueSet, valueTxt, valueSet2, frmTrgt)
{
	d setMenuTree^%bi.SWr.WebComponentTree2(trgt, valueSet, valueTxt, valueSet2, frmTrgt)
	;w "debug('" _ trgt _ "," _ valueSet _ "," _ valueTxt _ "," _ frmTrgt_ "');"
}

ClassMethod doFind(wd, ht, topN, lkUnionRpt, fg, ag, gT, sT, SQLVal)
{
	s rs = 0, cs = 0
	s tTabID = "showMe"
	s %session.Data("P8")=$P(lkUnionRpt,$c(1),1)_$c(3)_"0"_$c(3)_$P(lkUnionRpt,$c(1),2)_$c(3)_$P($g(%session.Data("rcGrouping",tTabID)),$c(3),1)_$c(3)_$P($g(%session.Data("rcGrouping",tTabID)),$c(3),2)
	s %session.Data("Width")=wd
	s %session.Data("Height")=ht
	// topN is split by $C(2); #1 - Top/Bottom (0/1), #2 - Numbers of row, #3 - Which column, #4 - Remaining classification
	s %session.Data("P6",1)=$P(topN,$C(2),1)
	s %session.Data("P6",2)=$P(topN,$C(2),2)
	s %session.Data("P6",3)=$P(topN,$C(2),3)
	s %session.Data("P6",4)=$P(topN,$C(2),4)
	s %session.Data("P6",5)=$P(topN,$C(2),5)
	
	; Grand & Sub Aggregate
	s %session.Data("gT")=$g(gT)
	s %session.Data("sT")=$g(sT)
	
	s r=""
	f {
		s r=$o(%session.Data("rowM",r))
		q:((r="") || (rs=1))
		
		s:(%session.Data("rowM",r)'["c$") rs = 1
	}
	
	s c=""
	f {
		s c=$o(%session.Data("colM",c))
		q:((c="") || (cs=1))
		
		s:(%session.Data("colM",c)'["c$") cs = 1
	}
		d doFind^%bi.SWr.WebComponentTree
		w !, "norowselected = 0;"
	;}
}

ClassMethod LoadConditions2(sub, dim, jsId)
{
	d LoadConditions2^%bi.SWr.WebComponentTree(sub, dim, jsId)
}

}
