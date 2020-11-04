Class %BI.ComSQLGenerator [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod zzInit()
{
  n
  s Z=$c(2)
  s xLoadDNS=##class(ComLinkTable).zzComLinkTableHeader()
  &html<
    <br>
    <table style='position: relative; left: 10;'><tr><td valign='top'>
      <table width='475' border='0' cellspacing='0' cellpadding='0'>
        <tr><td class='blackHeader'>
          &#160;Class Selection
        </td></tr>
      </table>
      <br>
      <table width='100%' height='55' border='0' cellspacing='0' cellpadding='0'><tr>
        <td width='90%'>
          <table width='100%' border='0' cellspacing='0' cellpadding='0'>
            <tr>
              <td valign='bottom'>
                <input type='checkbox' name='chkSource1' checked=1; hideFocus='true'>Local&#160;&#160;
                <input type='checkbox' name='chkSource2' hideFocus='true'>Data Warehouse&#160;&#160;
              </td>
              <td valign='bottom'>
                Schema from&#160;
                <input type='text' name='txtSchemaFrom' class='txtField' style='width: 50;' onblur='txtSchemaTo.value = txtSchemaFrom.value;'>
                &#160;to&#160;
                <input type='text' name='txtSchemaTo' class='txtField' style='width: 50;'>
              </td>
            </tr>
            <tr valign='top'>
              <td colspan='2'><div id='divList' style='position: relative; left: 5;'>
                #(xLoadDNS)#
              </div></td>
            </tr>
          </table>
        </td>
        <td width='10%'>
          <table width='100%' border='0' cellspacing='0' cellpadding='0'>
            <tr><td width='25%'><div align='right'><input type='submit' name='cmdFind' value='Find' onClick=reporterFind('chkSource',2); style='width: 45; cursor: hand;' class='submtBtn'></div></td></tr>
            <tr><td><div align='right'><input type='submit' name='cmdCancel' value='Cancel' onClick=genericCancel(); style='width: 45; cursor: hand;' class='submtBtn'></div></td></tr>
          </table>
        </td>
      </tr></table>
      <table border='0'><tr><td><div id='appArea1' class='frameETL'>
        <table><tr><td><div class='labelETL'>&#160;Load Class&#160;</div></td></tr></table>
        <div style='overflow-X: scroll; overflow-Y: scroll; width: 472; height: 343;'>
        <div id='divMain'></div>
      </div></td></tr></table>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'><tr>
        <td width='50%'>
          <input type='submit' name='cmdPrevious' value='&#160;<&#160;' onClick='reporterPage("Previous");' style='cursor: default;' class='submtBtn' disabled='True'>
          <span id='spanNext'><input type='submit' name='cmdNext' value='&#160;>&#160;' onClick='reporterPage("Next");' style='cursor: hand;' class='submtBtn' disabled='True'></span>
        </td>
        <td width='50%' align='right'>
          <input type='submit' name='cmdRelation' value='Relationship...' onClick='loadWindow("ComRelationShip.csp","LoadRelationShip","");' style='cursor: hand;' class='submtBtn' disabled='true'>
          <!--input type='submit' name='cmdLink' value='Link Table...' onClick='loadWindow("ComLinkTable.csp","LoadLinkTable","");' style='cursor: hand;' class='submtBtn'-->
        </td>
      </tr></table>
    </td></tr></table>
>
}

ClassMethod zzLoadClasses(inInclude, inExclude, inFilter)
{
  n (inInclude,inExclude,inFilter)
  d getCls^%bi.SMw.Class002($g(inInclude),$g(inExclude),$g(inFilter))
  s xJobId=..zzLoadCommon("LOCAL",.OLIST)
  q
}

ClassMethod zzLocalGetClasses(inClassName, inList, inJobId, inList2)
{
  n (inClassName,inList,inJobId,inList2)
  s ^ttv21(1)=$g(inClassName),^ttv21(2)=$g(inJobId)
  m ^ttv22=inList
  m ^ttv23=inList2
  s xLen=$l(inClassName,"->")
  s xParent=$p(inClassName,"->",1,xLen-1)
  s xPointer=$p(inClassName,"->",xLen)
  ;s inMenu=^BI.TMP("SQLWIZARD",inJobId)
  ;f i=1:1:$l(inMenu,"&#34;") d
  ;. i i=1 s xStr=$p(inMenu,"&#34;") q
  ;. s xStr=xStr_""""_$p(inMenu,"&#34;",i)
  ;s inMenu=xStr
  i $d(inList) s inList="",inList=$o(inList(inList),-1)
  ;f i=1:1:$l(xParent,">") d
  ;. i i=1 s outParent=$p(xParent,">") q
  ;. s outParent=outParent_"&gt;"_$p(xParent,">",i)
  ;s xParent=outParent
  ;f xMenu=1:1:2 d
  ;. d ..zzLocalTree(xPointer,inList,xMenu,xParent)
  s xMenu=1
  m ^ttv16a=inList2
  d ..zzLocalTree(xPointer,inList,xMenu,xParent,.inList2)
  m ^ttv16=inList2
  ;s xStr=..zzLocalTreeList(xPointer,outParent,.inList)
  s xStr=..zzLocalTreeList(xPointer,xParent,.inList,.inList2)
  q xStr
}

ClassMethod zzLocalTreeList(inClassName, inParent, inList, inList2)
{
  n (inClassName,inParent,inList,inList2)
  s ^ttv12(1)=inClassName,^ttv12(2)=$g(inParent)
  m ^ttv13=inList
  m ^ttv14=inList2
  d getProperty^%bi.SMw.Property002(inClassName)
  i $d(inList) d
  . s xCnt=inList
  . s xCnt=xCnt+1,inList(xCnt)=inParent_"->"_inClassName
  . f i=1:1:OLIST d
  .. s xCnt=xCnt+1
  .. s inList(xCnt)=inParent_"->"_inClassName_"->"_OLIST(i)
  . s inList=xCnt
  . k OLIST
  . m OLIST=inList
  s xCnt=0 ;,xCnt2=0
  s xStr="<select id='selProperty' style='position: absolute; left: 100; visibility: hidden;'>"
  s xStr=xStr_"<option value=0></option>"
  ;s xStr2="<select id='selProperty2' style='position: absolute; visibility: visible;'>"
  ;s xStr2=xStr2_"<option value=0></option>"
  f i=1:1:OLIST d
  . i OLIST(i)'["*" d
  .. s xCnt=xCnt+1
  .. s xStr=xStr_"<option value="_xCnt_">"_OLIST(i)_"</option>"
  ;i $d(inList2) d
  ;. f i=1:1:inList2 d
  ;.. s xCnt2=xCnt2+1
  ;.. s xStr2=xStr2_"<option value="_xCnt2_">"_inList2(i)_"</option>"
  ;e  d
  ;. f i=1:1:OLIST d
  ;.. i OLIST(i)["*" d
  ;... s xCnt2=xCnt2+1
  ;... s xStr2=xStr2_"<option value="_xCnt2_">"_$tr(OLIST(i),"*")_"</option>"
  s xStr=xStr_"</select>"
  ;s xStr2=xStr2_"</select>"
  q xStr	;_xStr2
}

ClassMethod zzLocalTreeList2(inClassName, inParent, inList, inList2)
{
  n (inClassName,inParent,inList,inList2)
  s ^ttv12(1)=inClassName,^ttv12(2)=$g(inParent)
  m ^ttv13=inList
  m ^ttv14=inList2
  d getProperty^%bi.SMw.Property002(inClassName)
  i $d(inList) d
  . s xCnt=inList
  . s xCnt=xCnt+1,inList(xCnt)=inParent_"->"_inClassName
  . f i=1:1:OLIST d
  .. s xCnt=xCnt+1
  .. s inList(xCnt)=inParent_"->"_inClassName_"->"_OLIST(i)
  . s inList=xCnt
  . k OLIST
  . m OLIST=inList
  s xCnt=0
  s xStr="<select id='selProperty2' style='position: absolute; visibility: hidden;'>"
  s xStr=xStr_"<option value=0></option>"
  s sb="" f  s sb=$o(inList2(sb)) q:sb=""  d
  . s xCnt=xCnt+1
  . s xStr=xStr_"<option value="_xCnt_">"_inList2(sb)_"</option>"
  b
  f i=1:1:OLIST d
  . i OLIST(i)["*" d
  .. s xCnt=xCnt+1
  .. s xStr=xStr_"<option value="_xCnt_">"_$tr(OLIST(i),"*")_"</option>"
  s xStr=xStr_"</select>"
  q xStr
}

ClassMethod zzLocalTreeList2Pre(inClassName, inList, inJobId, inList2)
{
  n (inClassName,inList,inJobId,inList2)
  s ^ttv31(1)=$g(inClassName)
  s ^ttv31(2)=$g(inJobId)
  m ^ttv32=inList
  m ^ttv33=inList2
  s xLen=$l(inClassName,"->")
  s xParent=$p(inClassName,"->",1,xLen-1)
  s xPointer=$p(inClassName,"->",xLen)
  i $d(inList) s inList="",inList=$o(inList(inList),-1)
  s xStr=..zzLocalTreeList2(xPointer,xParent,.inList,.inList2)
  q xStr
}

ClassMethod zzLocalTree(inClassName, inTotal, inMenu, inParent, inList2)
{
  n (inClassName,inTotal,inMenu,inParent,inList2)
  s ^ttv9("inClassName")=$g(inClassName),^ttv9("inTotal")=$g(inTotal),^ttv9("inMenu")=$g(inMenu),^ttv9("inParent")=$g(inParent)
  m ^ttv20=inList2
  d getProperty^%bi.SMw.Property002(inClassName)
  s xClose=0,xStr="",xCnt=0
  s inMenu=$g(inMenu)
  i $d(inList2) d
  . s xCnt2="",xCnt2=$o(inList2(xCnt2),-1)
  . s inList2=xCnt2
  e  s xCnt2=0,inList2=0
  s sb="" f  s sb=$o(inList2(sb)) q:sb=""  d
  . s inList2i(inList2(sb))=sb
  ;i $g(inJobId)'="" s xJobId=inJobId
  ;e  s xJobId=+$h_$j
  w ..zzLocalTreeOpen(inMenu)
  ;i $g(inMenu)'="" w ..zzLocalTreeOpen()
  ;e  w "MainTree"_inMenu_" =""~"
  ;s:'$d(inTotal) inTotal=0
  i $g(inTotal)'="" s inTotal=inTotal+1,xTotal=inTotal
  e  s inTotal=0
  s xImg="JSCookTree/ThemeXP/property.gif"
  f i=1:1:OLIST d
  . i i=1 s xClose=0
  . e  s xClose=1
  . ;i $d(inMenu) s OLIST(i)=inParent_"-&gt;"_OLIST(i)
  . i $g(inMenu)'="" d
  .. ;s OLIST(i)=inParent_"->"_OLIST(i)
  .. ;s OLIST2(i)=inParent_"->"_inClassName_"->"_$p(OLIST(i),"->",2,$l(OLIST(i)))
  .. s OLIST(i)=OLIST(i)
  .. s OLIST2(i)=inParent_"->"_inClassName_"->"_OLIST(i)
  . e  s OLIST2(i)=OLIST(i)
  . s xTitle="'"_$tr(OLIST(i),"*")_"'"
  . s xDesc="'"_$tr(OLIST(i),"*")_"'"
  . i OLIST(i)["*" d
  .. ;s xIcon="""<input type='image' border='0' name='img"_$tr(OLIST(i),"*")_"' src='"_xImg_"' style='cursor: hand;' onclick=reportGetClass('"_$tr(OLIST(i),"*")_"');>"""
  .. ;i '$d(inList2i($p($tr(OLIST(i),"*"),"->",2,$l($tr(OLIST(i),"*"))))) s xCnt2=xCnt2+1,inList2(xCnt2)=$tr(OLIST(i),"*"),inList2=xCnt2
  .. m ^ttv17=inList2i
  .. s ^ttv18=$tr(OLIST(i),"*")
  .. s xIcon="'<input type=image border=0 src="_xImg_" onclick=reportGetClass("_inList2i($tr(OLIST2(i),"*"))_");>'"
  . e  d
  .. ;s inTotal=inTotal+1,xIcon="""<input type='checkbox' name='chkProperty"_inTotal_"'>"""
  .. s inTotal=inTotal+1,xIcon="'<input type=checkbox name=chkProperty"_inTotal_">'"
  . i $g(inMenu)="" d
  .. w ..zzLocalTreeBody(xIcon,xTitle,"","",xDesc,xClose)
  . e  d
  .. s xCnt=xCnt+1
  .. w ..zzLocalTreeBody(xIcon,xTitle,"","",xDesc,xClose,xCnt,inMenu)
  i $g(inMenu)="" w ..zzLocalTreeClose(xClose)
  e  d
  . w ..zzLocalTreeClose(xClose,1,inMenu)
  . w """;"
  . ;s inMenu1=$p(inMenu,"""<input type='image' border='0' name='img"_inParent_"-&gt;"_inClassName_"' src='img/property.gif' style='cursor: hand;' onclick=reportGetClass('"_inParent_"-&gt;"_inClassName_"');>""",1)
  . ;s inMenu2=$p(inMenu,"""<input type='image' border='0' name='img"_inParent_"-&gt;"_inClassName_"' src='img/property.gif' style='cursor: hand;' onclick=reportGetClass('"_inParent_"-&gt;"_inClassName_"');>""",2)
  . ;s inMenu=inMenu1_"""<input type='checkbox' name='chkProperty"_xTotal_"'>"""_inMenu2
  . ;s xDelimiter=inParent_"-&gt;"_inClassName_"""]"
  . ;s xStr=$p(inMenu,xDelimiter,1)_""_inParent_"-&gt;"_inClassName_""""_xStr_$p(inMenu,xDelimiter,2)
  ;w xStr
  m ^ttv15=inList2
  ;f i=1:1:$l(xStr,"""") d
  ;. i i=1 s xStr3=$p(xStr,"""",i) q
  ;. s xStr3=$g(xStr3)_"&#34;"_$p(xStr,"""",i)
  q
}

ClassMethod zzLocalTreeOpen(inMenu)
{
  n (inMenu)
  ;s xStr="MainTree ="
  s xStr="txtTest.value ="""
  ;s xStr=xStr_"["
  i $g(inMenu)="" s xStr=xStr_"~"
  q xStr
}

ClassMethod zzLocalTreeBody(inIcon, inTitle, inURL, inTarget, inDesc, inClose, isSubClass, inMenu)
{
  ; [ -> ~, ] -> `
  n (inIcon,inTitle,inURL,inTarget,inDesc,inClose,isSubClass,inMenu)
  s xStr=""
  ;i $d(inMenu) s xSymbol1="~",xSymbol2="'"
  ;e  s xSymbol1="[",xSymbol2="]"
  s xSymbol1="~",xSymbol2="`"
  i inClose'=0 d
  . f i=1:1:inClose s xStr=xStr_xSymbol2
  . s xStr=xStr_","
  i $d(isSubClass) s:isSubClass=1 xStr=xStr_","
  s xStr=xStr_xSymbol1_inIcon_","_inTitle_","_inURL_","_inTarget_","_inDesc
  q xStr
}

ClassMethod zzLocalTreeClose(inClose, isSubClass, inMenu)
{
  n (inClose,isSubClass,inMenu)
  s xStr=""
  ;i $d(inMenu) s xSymbol="`"
  ;e  s xSymbol="]"
  s xSymbol="`"
  f i=1:1:inClose s xStr=xStr_xSymbol
  i '$d(isSubClass) s xStr=xStr_","_xSymbol_";"
  ;e  s xStr=xStr_xSymbol
  i $g(inMenu)="" s xStr=xStr_""""
  q xStr
}

ClassMethod zzLocalMain(inClassName)
{
  n (inClassName)
  s xTreeList=..zzLocalTreeList(inClassName)
  s xTreeList2=..zzLocalTreeList2(inClassName)
  s xFooter=..zzLocalFooter()
  s xStr="<br>"
  s xStr=xStr_"<table style='position: relative; left: 10;'><tr><td valign='top'>"
  s xStr=xStr_"<table width='475' border='0' cellspacing='0' cellpadding='0'>"
  s xStr=xStr_"<tr><td class='blackHeader'>"
  s xStr=xStr_"&#160;"_inClassName
  s xStr=xStr_"</td></tr>"
  s xStr=xStr_"</table>"
  s xStr=xStr_"<br>"
  s xStr=xStr_"<table border='0'><tr><td><div id='appArea1' class='frameETL'>"
  s xStr=xStr_"<table><tr><td><div class='labelETL'>&#160;Property&#160;</div></td></tr></table>"
  s xStr=xStr_"<div style='overflow-X: scroll; overflow-Y: scroll; width: 472; height: 369;'>"
  s xStr=xStr_"<div id='divSelProperty'>"_xTreeList_"</div>"
  s xStr=xStr_"<div id='divSelProperty2'>"_xTreeList2_"</div>"
  s xStr=xStr_"<div id='divMainTree'></div>"
  s xStr=xStr_"</div></td></tr></table>"
  s xStr=xStr_"<table><tr><td><div id='appArea2' class='frameETL'>"
  s xStr=xStr_xFooter
  s xStr=xStr_"</div></td></tr></table>"
  s xStr=xStr_"<table width='100%' border='0' cellspacing='0' cellpadding='0'><tr>"
  s xStr=xStr_"<td width='50%'>"
  s xStr=xStr_"<input type='submit' name='cmdPrevious' value='&#160;<&#160;' onClick=reporterPage('Previous'); style='cursor: hand;' class='submtBtn'>"
  s xStr=xStr_"&#160;<span id='spanNext'><input type='submit' name='cmdNext' value='&#160;>&#160;' onClick=reporterPage('Next'); style='cursor: default;' class='submtBtn' disabled='True'></span>"
  s xStr=xStr_"&#160;<span id='spanExpand'><input type='checkbox' name='chkExpand' onclick='reportGetClass2();' checked>Expand Tree</span>"
  s xStr=xStr_"</td>"
  s xStr=xStr_"<td width='50%' align='right'>"
  s xStr=xStr_"<input type='submit' name='cmdOk' value='Ok' onClick='propertyOk();' style='cursor: hand;' class='submtBtn'>"
  s xStr=xStr_"&#160;<input type='submit' name='cmdCancel' value='Cancel' onClick='genericCancel();' style='cursor: hand;' class='submtBtn'>"
  s xStr=xStr_"</td>"
  s xStr=xStr_"</tr></table>"
  q xStr
}

ClassMethod zzLocalFooter()
{
  n
  s xStr="<table border='0' cellspacing='0' cellpadding='0'><tr><td>&#160;WHERE&#160;</td><td>"
  s xStr=xStr_"<input type='text' name='txtWhere' class='txtField' style='width: 422;'>"
  s xStr=xStr_"</td></tr></table>"
  q xStr
}

ClassMethod zzLoadCommon(inFlag, OLIST)
{
  n (inFlag,OLIST)
  s ^ttv1("inFlag")=$g(inFlag)
  m ^vicLIST=OLIST
  s xJobId=+$h_$j,xSub=1,xSub2=0
  i inFlag="DNS" s xDelimiter=$c(2)
  e  s xDelimiter="."
  s xImg="JSCookTree/ThemeXP/property.gif"
  ;w ..zzLocalTreeOpen()
  w "MainTree ="
  w "["
  f i=1:1:OLIST d
  . s xLIST($p(OLIST(i),xDelimiter,1),$p(OLIST(i),xDelimiter,2))=""
  s xFlag=0
  s sb1="" f  s sb1=$o(xLIST(sb1)) q:sb1=""  d
  . i xFlag w "],"
  . s xFlag=1
  . w "[,"""_sb1_""",,,"""_sb1_""""
  . s sb2="" f  s sb2=$o(xLIST(sb1,sb2)) q:sb2=""  d
  .. s xSub=xSub+1
  .. s xIcon="""<input type='image' border='0' name='img"_sb1_"' src='"_xImg_"' style='cursor: hand;' onclick=reporterPage('Goto','"_sb1_"."_sb2_"');>"""
  .. w ",["_xIcon_","""_sb2_""",,,"""_sb2_"""]"
  i OLIST'=0 w "]];"
  e  w "];"  
  q xJobId
}

ClassMethod zzLoadDNSMain(inClassId)
{
  n (inClassId)
  d ##class(ComLinkTable).zzComGetClassDNS(inClassId)
  s xJobId=..zzLoadCommon("DNS",.OLIST)
  q
}

}
