Class %BI.WebEditQueryCom Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	&html<<html>
	<head>
	</head>
	<body>>
	;To do...
	&html<</body>
	</html>>
	Quit $$$OK
}

ClassMethod a()
{
	w "str="""
	d ##class(%BI.WebEditQueryCom).genConditionCom(1)
	w """;"
}

ClassMethod addCond(query)
{
	d addToFilter^%bi.SWr.WebEditQueryCom(query)
}

ClassMethod genConditionCom(type)
{
	
	;&html<
	w "<table width='100%' border='0' cellspacing='0' cellpadding='2' height='100%' >"
        w "<tr> "
         w "<td colspan=2> "
            w "<select name='algo' class='cboBox' style='width:40'>"
              w "<option value='=' selected>=</option>"
              w "<option value='<'>&lt;</option>"
              w "<option value='>'>&gt;</option>"
              w "<option value='<='>&lt;=</option>"
              w "<option value='>='>&gt;=</option>"
            w "</select>"
            w "<input type='text' name='conditionFld' size='30' class='txtField'>"
            w "<input type='button' name='Button62' value='&gt;&gt;' style='font-size:9;' onClick=addCond('') class='button'>"
            w "<input type='button' name='reloadCond' value='R' style='font-size:9;0' onClick=reloadCondition() class='button'>"
          w "</td>"
        w "</tr>"
        w "<tr>"
          ;w "<td height='154' colspan=2> "
          w "<td height='100' colspan=2> "
            w "<div class='bdrStyle' style='overflow:auto;height:100%;width:100%;background-Color:#FFFFFF'> "
              w "<div id='mCondition' style='width:100%;height:100%'> "
            w "</div>"
			w "</div>"
          w "</td>"
        w "</tr>"
        w "<tr> "
        	w "<td  class='bgColor2'>"
        	;w "<input type='button' name='FirstList' value='|<' style='font-size:8; font-family:Verdana, Arial, Helvetica, sans-serif; height:15; width:20px' class='button' onClick=showPage('f');>"
        	w "<input type='button' name='PreviousList' value='<' style='font-size:8; font-family:Verdana, Arial, Helvetica, sans-serif; height:15; width:20px' class='button' onClick=showPage(-1); disabled>"
        	w "<input type='button' name='NextList' value='>' style='font-size:8; font-family:Verdana, Arial, Helvetica, sans-serif; height:15; width:20px' class='button' onClick=showPage(1); disabled>"
        	;w "<input type='button' name='LastList' value='>|' style='font-size:8; font-family:Verdana, Arial, Helvetica, sans-serif; height:15; width:20px' class='button' onClick=showPage('l');>"
        	w "</td>"
          w "<td align='right' class='bgColor2'> "
          	w "<span class='multipass' onselectstart='return false' onClick='getRelCls();'>"_$$$Text("Multipass")_"</span>"
            w "<input type='radio' name='queryCon' id='que1' value='NOT'>"
            w "<b class='fontForSelectList'><label for=que1><font color='#FFFFFF'>"_$$$Text("Not")_"</font></label>"
            w "&nbsp;&nbsp;&nbsp;<input type='radio' name='queryCon' id='que2' value='AND' checked><label for=que2><font color='#FFFFFF'>"_$$$Text("And")_"</font></label>"
            w "&nbsp;&nbsp;&nbsp;<input type='radio' name='queryCon' id='que3' value='OR'>"
            w "<label for=que3><font color='#FFFFFF'>"_$$$Text("Or")_"</font></label></b></td>"
        w "</tr>"
      w "</table>"
}

ClassMethod setClassnFilter(query, currClass)
{
	s X = $C(3)
	
	s %session.Get("currFilter") = $G(query)
    s %session.Get("AnalyzerBaseCls") = currClass_X_""_X_$G(query)
    w "alert('filter = "_%session.Get("currFilter")_" cls = "_%session.Get("AnalyzerBaseCls")_"');"	
	q
}

ClassMethod genFilterCom2()
{
	;&html<
		w "<table width='100%' border='0' cellspacing='0' cellpadding='2' height='100%'>"
        w "<tr> "
          w "<td colspan='2'> "
            ;w "<textarea name='queryArea' cols='45' rows='10'>"_%session.Get("currFilter")_"</textarea>"
            w "<textarea name='queryArea' rows='10' style='width:100%;' onchange='countQuery();'>"_%session.Get("currFilter")_"</textarea>"
            
          w "</td></tr><tr> "
          w "<td width='66%'> "
            w "<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
              w "<tr> "
                w "<td width='21%' class='bdrStyle'><span id=countVal style='color:#FFFFFF'>"
                 ;>
                 //<script language=cache runat=server>
				  	set RecCount = %session.Get("RecCount")
					if (RecCount="") set RecCount=0 
				  	write $FNUMBER(%session.Get("RecCount"),",")
				  //</script>
				  ;&html<
                  w "</span></td>"
                w "<td width='79%' class='bdrStyle'><span id=percentVal style='color:#FFFFFF'> "
                ;>
                  //<script language=cache runat=server>
                  //
       
				  	set recCnt=%session.Get("RecCount")
					set totRec=%session.Get("TotalRec")
					set recCnt=recCnt*1
					i totRec="" s totRec=1

					;write recCnt_":"
					i totRec'=0 {
						i recCnt="" s recCnt = 1
						i recCnt=0 s recCnt = 1
						set trRec = (recCnt/totRec)*100
						//w $JUSTIFY(trRec,20,2)
						w trRec
					}else {
						w totRec
					}
				
					
			
					;write %session.Get("RecCount")
					;write %session.Get("TotalRec")
				  //</script>
				 ;&html< 
				 w "%</span><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"
				  w "</font></td></tr></table></td>"
          w "<td width='34%' align='right' nowrap> "
            w "<input type='button' name='Button' value='Clear' onClick=clearQueryArea() class='button' style=width:50px>"	; Modified by Kok Hong on 02/12/04
            w "<input type='button' name='RedoBut' value='Redo' onClick=reDoLine() class='button' style=width:50px>"
            w "<input type='button' name='UndoBut' value='Undo' onClick=unDoLine() class='button' style=width:50px>"
          w "</td></tr></table>"
	;>
}

ClassMethod genFilterCom(dWid, dm, curLoc)
{
	i $G(dWid)="" s dWid="100%"
		w "<table width='"_dWid_"' height='100%' border='0' cellspacing='0' cellpadding='2'>"
        w "<tr valign='top'> "
          w "<td colspan='2'> "
            ;w "<textarea name='queryArea' cols='45' rows='10'>"_%session.Get("currFilter")_"</textarea>"
            w "<textarea name='queryArea' rows='20' style='width:"_dWid_";' onchange='countQuery()'>"_$C(13,10)_%session.Data("currFilter")_"</textarea>" // Modified by Mun Yau on 7/7/06.
            //w "<textarea name='queryArea' rows='20' style='width:"_dWid_";' onchange='countQuery()'>"_%session.Get("lastQuery")_"</textarea>"
          w "</td></tr><tr>"
          w "<td width='20%' height='100%'> "
           w "<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
              w "<tr> "
              //class='bdrStyle' style='background-color:#002d96'
                w "<td width='10%'><span id=countVal style='color:#FFFFFF'>"
                s query = %session.Get("currFilter")
                i query[" OR " s query = "["_query_"]"
                s %session.Data("b4Edit") = query
                s currClass = %session.Get("AnalyzerBaseCls")
                s currPg = $S($G(curLoc)'="":curLoc,1:%session.Get("currLocation"))
				s currPg=$$toLower^%bi.SWr.WebUtil(currPg)
                s P0=""
                
            	;If any of the following changes occur plz modify the -- refer to GTM.
          		; 1 -- loadCondition^%bi.SWr.EditWebQueryCom
          		; 2 -- recountQueryCnt^%bi.SWr.EditWebQueryCom
          		; 3 -- genFilterCom^%BI.WebEditQueryCom
              	if $g(dm)'="" {
	              	s %session.Data("DataMartID") = dm 
	             	i '(currPg["subjectareamain") {
						s query = $$GetEffQuery^%bi.SWr.WebAnalyzer($g(dm),query) 	   //subject filter
						s query = $$appendRoleQuery^%bi.SWr.WebAnalyzer4($g(dm),query) //role filter	
				  	}     	
				  	
				  	s classInfo = $G(^SYS("BI","DM","Data",dm))
					s P0 = $P(classInfo,$C(3),2)
              	}
                else {
					i currPg["analyzer" {
						s P0 = $P(currClass,$C(3),1)
						s zzquery=$P(currClass,$C(3),3)
						i zzquery[" OR " s zzquery = "["_zzquery_"]"
						i query="" {s query=zzquery}
						elseif zzquery'="" {s query=query_" AND "_zzquery}
						s dm = $P(currClass,$C(3),2)
						s query = $$appendRoleQuery^%bi.SWr.WebAnalyzer4(dm,query) 
						//w "<script language=javascript>alert("""_currClass_""");</script>"
					} 
					else {
						s currPg=$$toLower^%bi.SWr.WebUtil(currPg)
						i currPg["reporter" {
							s currClass=%session.Get("rObjClass")
							s P0 = $P(currClass,$C(3),1)
						}		
						i currPg["analyzerflex" {
							s currClass=%session.Get("BaseCls")
							s P0 = $P(currClass,$C(3),1)	
						}
						i currPg["subjectareamain" {
							;s currClass=%session.Get("BaseCls")
							s P0 = $P(currClass,$C(3),1)
						}
						i currPg["admintaskkpi" {
							s dm = %session.Get("KPIClass")
							s classInfo = $G(^SYS("BI","DM","Data",dm))
							s P0 = $P(classInfo,$C(3),2)
						}
						i currPg["venndiagsetup" {
							s dm =%session.Get("MyClass2")
							s P0=%session.Get("MyClass2")
						} 
						//edited by GTM ... any bug plz come find me
					  	i '(currPg["subjectareamain") {
							s query = $$GetEffQuery^%bi.SWr.WebAnalyzer($g(dm),query) 	   //subject filter
							s query = $$appendRoleQuery^%bi.SWr.WebAnalyzer4($g(dm),query) //role filter	
					  	}    
					}
                }
				//w "<script language=javascript>alert('"_P0_"');</script"_">"
				s query = $$dlrTR2^%bi.SWr.WebMain2(query,$c(13),"") // By Mun Yau on 6/7/06 to fix the \r\n problem.
				s query = $$dlrTR2^%bi.SWr.WebMain2(query,"\r","") // By Mun Yau on 6/7/06 to fix the \r\n problem.
				s query = $$dlrTR2^%bi.SWr.WebMain2(query,$c(10),"") // By Mun Yau on 6/7/06 to fix the \r\n problem.
				s query = $$dlrTR2^%bi.SWr.WebMain2(query,"\n","") // By Mun Yau on 6/7/06 to fix the \r\n problem.

				s P1 = query
				i P0'="" {
	                s VALUE=$$CntMatch^%bi.SMr.MinerUtils1(P0,$G(P1),"")
	               	s %session.Data("RecCount")=VALUE
				}
			  	set RecCount = %session.Get("RecCount")
				if (RecCount="") set RecCount=0 
				w $FNUMBER(%session.Get("RecCount"),",")
              	w "</span></td>"
            	w "<td width='20%' ><span id=percentVal style='color:#FFFFFF'> "
			  	set recCnt=%session.Get("RecCount")
			  	
			  	//edited by GTM ... any bug plz come find me
			  	i currPg["subjectareamain" {
					set totRec=$$CntMatch^%bi.SMr.MinerUtils1(P0,"","") 
			  	}
			  	else {	
			  		s Effquery = $$GetEffQuery^%bi.SWr.WebAnalyzer($g(dm),"") 			 //subject filter
					s Effquery = $$appendRoleQuery^%bi.SWr.WebAnalyzer4($g(dm),Effquery) //role filter
					
                	s DaGrandTotal=$$CntMatch^%bi.SMr.MinerUtils1(P0,$g(Effquery),"")
					set totRec = DaGrandTotal
			  	}
			 
				s %session.Data("TotalRec") = totRec
				set recCnt=recCnt*1
				i totRec="" s totRec=0
				
				if (totRec="zzQuery Error"){ w totRec_" "}
				else {
					i totRec'=0,$ISVALIDNUM(totRec) {
						set trRec = (recCnt/totRec)*100
						w $JUSTIFY(trRec,20,2)
					}else {
						w totRec
					}
				}

			  w "%</span><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"
			  w "</font></td></tr></table></td>"
      	w "<td width='30%' height='100%' align='right' nowrap> "
        w "<input type='button' name='Button' value='"_$$$Text("Clear","%BI")_"' onClick=clearQueryArea() class='button' >&nbsp;"	; Modified by Kok Hong on 02/12/04
        w "<input type='button' name='RedoBut' value='"_$$$Text("Redo","%BI")_"' onClick=reDoLine() class='button' >&nbsp;"
        w "<input type='button' name='UndoBut' value='"_$$$Text("Undo","%BI")_"' onClick=unDoLine() class='button' >&nbsp;"
      	w "</td></tr></table>"
}

ClassMethod cancelEditQuery()
{
	s %session.Data("lastQuery")= %session.Get("b4Edit")
}

ClassMethod loadDimeTree(P0, P1, P2)
{
	d loadDimeTree^%bi.SWr.WebEditQueryCom(P0,P1,P2)
}

ClassMethod genDMForm()
{
	s currPg = %session.Get("currLocation")
	s currPg=$$toLower^%bi.SWr.WebUtil(currPg)
	i currPg="analyzerflex.csp" {	
		d genDMForm^%bi.SWr.WebEditQueryCom
	}
}

// added by chris 12/23/2004

ClassMethod loadConditionJS(currClass, measureID, condBegin)
{

	d loadConditionJS^%bi.SWrt.WebEditQuery(currClass,measureID, $G(condBegin))
	//d loadConditionJS^%bi.SWr.WebEditQueryCom(measureID, $G(condBegin))
}

ClassMethod setLastQuery(query)
{
	
	d setLastQuery^%bi.SWrt.WebEditQuery(query)
	//d loadConditionJS^%bi.SWr.WebEditQueryCom(measureID, $G(condBegin))
}

ClassMethod recountQueryCnt(currClass, query)
{

	d recountQueryCnt^%bi.SWrt.WebEditQuery(currClass,query)
	//d loadConditionJS^%bi.SWr.WebEditQueryCom(measureID, $G(condBegin))
}

ClassMethod setClass(currClass, query)
{

	s X = $C(3)	
	//s %session.Data("currFilter") = $G(query)
    //s %session.Data("AnalyzerBaseCls") = currClass_X_""_X_query
    s VALUE=$$CntMatch^%bi.SMr.MinerUtils1(currClass,$G(query),"")
    s %session.Data("RecCount")=VALUE
	s %session.Data("TotalRec")=VALUE
    //w query_currClass
    /*
    S P0 = currClass
    s P1 = %session.Data("currFilter")
    s VALUE=$$CntMatch^%bi.SMr.MinerUtils1(P0,$G(P1),"")
    set %session.Data("RecCount") = VALUE
	set %session.Data("TotalRec") = VALUE
	*/
}

// Added by Kok Hong on 11/03/05

// Description: Browse to the specified page of conditions

ClassMethod showPage(PageNum, measureID, condBegin)
{
	d showPage^%bi.SWr.WebEditQueryCom(PageNum,measureID,condBegin)
}

ClassMethod setMyClass(CrCls)
{
	s %session.Data("MyClass2")=CrCls
}

}
