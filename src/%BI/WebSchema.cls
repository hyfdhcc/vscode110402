Class %BI.WebSchema [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadClassProp()
{
	s iClass = %session.Get("BaseCls")
	i iClass'="" {
	s cnt=0
 	s cnt = ..LoadPropList(iClass,.propNm, cnt,0,iClass)
 	s menu = "["
 	s retMenu = $$BuildMenu^%bi.SWrCSP.TreeList1(.propNm,cnt)
  	;s retMenu = ##class(%BI.WebAnalyzer).BuildMenu(.propNm,cnt)
	s menu = menu_retMenu
	s menu =menu_"];"
	w "<script language=javascript>"
	w "menu1 = "_menu
	w "</script>"
	}
}

ClassMethod LoadPropList(iClass, propNm, cnt, child, parentNode)
{
	set rs=##class(%ResultSet).%New("%BI.ClassMethodPropList:PropList")
	do rs.Execute(iClass)
	while rs.Next() {
		s cnt = cnt+1
 		S VALUE=$$DRtable^%bi.SMr.Measure1(iClass,rs.GetData(1))
 		i ($e(VALUE,1)=1) {
	 		s propNm(cnt) = "*"_parentNode_"|"_rs.GetData(1)_$C(4)_rs.GetData(1)_$C(4)_child
	 		s cnt = ..LoadPropList($e(VALUE,2,$L(VALUE)),.propNm, cnt,1,parentNode_"|"_rs.GetData(1))
 		} else {
	 		s propNm(cnt) = parentNode_"|"_rs.GetData(1)_$C(4)_rs.GetData(1)_$C(4)_child	
	 	}
 	}
 	q cnt
}

ClassMethod DimensionList()
{
	s noOfCols = "5"
	s selLast = %session.Get("selectLast")
	s colNm = "Dimension Name:30,Property:30,Data Type:20,Active:10,Complex:10"
	d ##class(%BI.WebTableList).GenerateHeader(noOfCols,colNm,"",0,"#666666")
	s baseCls = %session.Get("BaseCls")
	i baseCls'="" {
		s Val = $$load^%bi.SMr.Measure1(baseCls)
		f i=1:1:Val {
			s id = $P(OLIST(i),$C(2),1)
			s valA(1) = $P(OLIST(i),$C(2),2)
			s valA(2) = $P(OLIST(i),$C(2),4)
			s valA(3) = $P(OLIST(i),$C(2),5)
		
			s checked = ""
			i ($P(OLIST(i),$C(2),8)=1) s checked = " checked"
			s valA(4) = "<input type=""checkbox"" name=""chkAc"_i_""" value="""_id_""""_checked_" disabled>"
		
			s checked = ""
			i ($P(OLIST(i),$C(2),15)=1) s checked = " checked"
			s valA(5) = "<input type=""checkbox"" name=""chkCplx"_i_""" value="""_id_""""_checked_" disabled>"
			s bgCol=""
			i selLast=1 {
				i i=Val s bgCol="#0099CC"	
			}
			d ##class(%BI.WebTableList).GenerateBodyTRow(i,.valA,id,bgCol,"loadDimeProp()")	
		}
	}
	w "</table>"
	d ..killOfLoadDimeSession()
}

ClassMethod setBaseCls(baseCls)
{
	s %session.Data("BaseCls")=baseCls
	s %session.Data("SmCls")=baseCls
}

ClassMethod compareWhichDef(val)
{
	s def(1) = "Values"
	s def(2) = "References"
	s def(3) = "Date"
	s def(4) = "Time"
	s def(5) = "Number"
	s def(6) = "Boolean"
	s def(7) = "Words"
	s def(8) = "Date YYYY-MM-DD"
	s def(9) = "Date YYYY/MM/DD"
	s def(10) = "Date DD-MM-YYYY"
	s def(11) = "Date DD/MM/YYYY"
	s retVal = ""
	f i=1:1:11 {
		i val=def(i) s retVal = i
	}
	q retVal
}

ClassMethod loadDimeProp(dimeID)
{
	i dimeID'="" {
		s dimeObj = ##class(%BI.Measure).%OpenId(dimeID)
		s dimeName = dimeObj.CatName
		s ClassName = dimeObj.ClassName
		s IsActive = dimeObj.IsActive
		s startClass = dimeObj.StartClass
		s propName = dimeObj.PropName
		s LinkField = dimeObj.LinkField
		s AdditionalCondition = dimeObj.AdditionalCondition
		s ComplexCode = dimeObj.ComplexCode
		s ChildLoop = dimeObj.ChildLoop
		s ChildFetch = dimeObj.ChildFetch
		s ChildClose = dimeObj.ChildClose
		s mTrans = dimeObj.MTranslation
		s ranges = dimeObj.Ranges
		s NullField = dimeObj.NullField
		s NullPointer = dimeObj.NullPointer
		s StrConv = dimeObj.StringConversion
		s def= dimeObj.Definition
		
		// Load all into session.
		s %session.Data("currDimeID") = dimeID					; P0
		s %session.Data("ClassName") = ClassName				; P1
		s %session.Data("startClass") = startClass				; P2
		s %session.Data("LinkField") = LinkField				; P3.1
		s %session.Data("propName") = propName					; P3.2
		s %session.Data("dimeName") = dimeName					; P3.3
		s %session.Data("ChildLoop") = ChildLoop				; P4.1
		s %session.Data("ChildFetch") = ChildFetch				; P4.2
		s %session.Data("ChildClose") = ChildClose				; P4.3
		s %session.Data("ComplexCode") = ComplexCode			; P5.1
		s %session.Data("AddtnlCondition")=AdditionalCondition	; P5.2
		s %session.Data("def")=def								; P5.3
		s %session.Data("StrConv")=StrConv						; P5.4
		s %session.Data("ranges") = ranges						; P7
		s %session.Data("IsActive") = IsActive					; P8.3
		s %session.Data("NullField") = NullField				; P8.1
		s %session.Data("NullPointer") = NullPointer			; P8.2
		s %session.Data("mTrans") = mTrans						; P9
		
		// Load the General Properties ala DHTML style.
		
		w "dimeName.value = """_dimeName_""";"
		
		s checked = "false"
		i IsActive=1 s checked = "true"
		w "activeOrNot.checked = """_IsActive_""";"
		
		w "startClass.value = """_startClass_""";"
		w "propName.value = '"_propName_"';"
		w "LinkField.value = """_LinkField_""";"
		w "addCondition.value = '"_AdditionalCondition_"';"
		w "complxCode.value = '"_ComplexCode_"';"
		w "AddBtn.value = 'Update';"
		s selIdx = ..compareWhichDef(def)
		w "type.selectedIndex ='"_(selIdx-1)_"';"
		w "DeleteBtn.disabled = false;"
	} else {
		w "dimeName.value = """";"	
		w "activeOrNot.checked = ""true"";"
		w "extVal.checked = ""false"";"
		w "startClass.value = """";"
		w "propName.value = '';"
		w "LinkField.value = """";"
		w "addCondition.value = '';"
		w "complxCode.value = '';"
		w "AddBtn.value = 'Add';"
		w "DeleteBtn.disabled = true;"
		
		d ..killOfLoadDimeSession()		
	}
}

ClassMethod killOfLoadDimeSession()
{
	// Kill off the sessions
	k %session.Data("currDimeID") 				
	k %session.Data("startClass") 			
	k %session.Data("LinkField") 			
	k %session.Data("propName")				
	k %session.Data("dimeName") 			
	k %session.Data("ChildLoop") 
	k %session.Data("ChildFetch") 			
	k %session.Data("ChildClose") 	
	k %session.Data("ComplexCode") 	
	k %session.Data("AddtnlCondition")
	k %session.Data("IsActive") 		
	k %session.Data("mTrans")
	k %session.Data("ranges")
	k %session.Data("NullField") 
	k %session.Data("NullPointer")
}

ClassMethod addADimension(valueSet)
{
}

ClassMethod saveNewDime(P33, P55, def, P2, P32, P31, P51, P52, dParam, aoNot, xVal, aNew)
{
	i aNew=1 {
		d ..killOfLoadDimeSession()	
		s %session.Data("selectLast")=1
	}
	s X=$C(3)
	s P0 = %session.Get("currDimeID")				; P0
	s P1 = %session.Get("ClassName")				; P1
	i P1 = "" s P1=%session.Get("BaseCls")			; if ClassName session not available
	s P2 = P2										; P2
	s P3 = P31										; P3.1
	s P3 = P3_X_P32									; P3.2
	s P3 = P3_X_P33									; P3.3
	s P4 = %session.Get("ChildLoop") 				; P4.1
	s P4 = P4_X_%session.Get("ChildFetch") 			; P4.2
	s P4 = P4_X_%session.Get("ChildClose")			; P4.3
	s P5 = P51										; P5.1
	s P5 = P5_X_P52									; P5.2
	s P5 = P5_X_def									; P5.3
	s P5 = P5_X_P55									; P5.4
	s P6 = dParam									; P6
	s P7 = %session.Get("ranges")  					; P7
	s P8 = %session.Get("NullField")  				; P8.1
	s P8 = P8_X_%session.Get("NullPointer")  		; P8.2
	s P8 = P8_X_aoNot  								; P8.3
	s P8 = P8_X_xVal								; P8.4
	s P9 = %session.Get("mTrans") 	 				; P9
	
	s id = $$save^%bi.SMr.Measure1(P0,P1,P2,P3,P4,P5,P6,P7,P8,P9)
}

ClassMethod delete()
{
	s gID = %session.Get("currDimeID")				; P0
	d ##class(%BI.Measure).%DeleteId(gID)
}

ClassMethod setChildInfo(cLoop, cFetch, cClose)
{
	s %session.Data("ChildLoop") = cLoop				; P4.1
	s %session.Data("ChildFetch") = cFetch				; P4.2
	s %session.Data("ChildClose") = cClose				; P4.3
}

ClassMethod loadTransRep()
{
	// Load the translate and replaced table list
	s mTrans = %session.Get("mTrans")
	w "<script language=javascript>dataVal = '"_mTrans_"';</script>"
	s noOfCols = "2"
	s colNm = "Original Text:50,Translate to:50"
	d ##class(%BI.WebTableList).GenerateHeader(noOfCols,colNm,"",0,"#666666")
	
	d ##class(%BI.WebTableList).GenerateBodyTRow2(mTrans,$C(4),$C(5),"#CCCCCC","selTheRow()")
	w "</table>"
	w "<script language=javascript>var totalRow="""_$L(mTrans,$C(4))_""";</script>"
}

ClassMethod upDateMtrans(nPtr, nFld, mTrans)
{
	s %session.Data("mTrans") = mTrans
	s %session.Data("NullPointer") = nPtr
	s %session.Data("NullField") = nFld
}

ClassMethod upDateRanges(ranges)
{
	s %session.Data("ranges") = ranges
}

ClassMethod loadRangesRep()
{
	// Load the ranges table list
	s ranges = %session.Get("ranges")
	w "<script language=javascript>dataVal = '"_ranges_"';</script>"
	s noOfCols = "3"
	s colNm = "Caption:30,From:30;To:30"
	d ##class(%BI.WebTableList).GenerateHeader(noOfCols,colNm,"",0,"#666666")
	
	d ##class(%BI.WebTableList).GenerateBodyTRow2(ranges,$C(4),$C(5),"#CCCCCC",1)
	w "</table>"
}

ClassMethod saveDimensionProp()
{
}

}
