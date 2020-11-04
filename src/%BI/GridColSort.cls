Class %BI.GridColSort [ Abstract, Not ProcedureBlock, System = 4 ]
{

/* old sorting method
ClassMethod colSort(dat, count, tableid)
{
	k ^Speed.GridColSort
	for i=1:1:count {
		s datArr = $P(dat,$C(3),i)
		s datArr = $$dlrTR2^%bi.SWr.WebMain2(datArr,"$","")
		s datArr = $$dlrTR2^%bi.SWr.WebMain2(datArr,",","")
		s ^Speed.GridColSort(+datArr,i) = ""
	}
	d genGridBody^%bi.SWr.GridColSort(tableid,count)
	k ^Speed.GridColSort
	q
}
*/
ClassMethod colSort(tableid, col, sortOrder, sortType, currDDLevel)
{
	s sessID = %session.%Id()
	s hideC = $g(^BI.ASetupD(sessID,tableid,6,"Hide Columns"))
	if hideC'="" {
		for xx=1:1:$L(hideC,",") {s hideC($P(hideC,",",xx)) = ""}
		s cnt=0
		for xx=1:1:$LG($g(^mtemp(sessID,tableid)),2) {
			if '$D(hideC(xx)){s colC($i(cnt))=xx}
		}
		s col = $s($g(colC(col))="":col,1:colC(col))
	}
	s sortColArr(1) = col	
	s %session.Data("isSingleSort",tableid) = "1"_"||"_sortOrder_"||"_sortType
	i currDDLevel > 0 s tableid = tableid_"DD"_currDDLevel
	d SORT^%bi.SMr.Query1b(sessID,tableid,.sortColArr,sortOrder,sortType)

	w "sortedDat = ["
	d buildSortedBody^%bi.SWr.GridColSort(tableid,currDDLevel)
	w "];"
	
	;# Code to get the sorted row indices so that hiding
	;# rows will retrieve a correct row index	
	d TagGridSortedJS^%bi.SWr.GridColSort(tableid,sessID)
	
	d genFS3^%bi.SMw.GridTable(tableid,tableid)
	w "GridData[19] = styleSet_"_tableid_";"

	//w "GridData[17] = styleSet_"_tableid_";"  
	//w "GridData[19] = styleSet_"_tableid_";"
	
	// GridData[17] - commented by Mihad 		above for temporary solution from mihad to avoid error from the function appFontSetting found in GridUtil1.js line number 34 
	// GridData[17] - uncommented again by GTM [if commented bug will occur when : DrillDown To 2nd Level --> Back to 1st Level ---> Sort]
	q
}

ClassMethod checkSorted(clientCoor, tabId, currDDLevel)
{
	;i currDDLevel > 0 s tabId = tabId_"DD"_currDDLevel
	d checkSorted^%bi.SWr.GridColSort(clientCoor,tabId,currDDLevel)
	q
}

ClassMethod checkSorted2(clientCoor, tabId, currDDLevel)
{
	s oriRow = $$checkSorted2^%bi.SWr.GridColSort(clientCoor,tabId,currDDLevel)
	q oriRow
}

ClassMethod canSort(tableid)
{
	; canSort returns 1 if pivoting is being done
	; and "" when no pivoting is being done
	; Sorting can only be done when canSort is ""
	s canSort = $G(%session.Data("pivotingFlag",tableid))
	q canSort
}

}
