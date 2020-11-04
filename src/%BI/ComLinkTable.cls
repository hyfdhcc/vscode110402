Class %BI.ComLinkTable [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod zzInitComLinkTable(xDiv)
{
  n (%session)
  i $g(xDiv)'="" s %session.Data("ComLinkTableDiv") = xDiv
  s %session.Data("ComLinkTableDiv")="divMainBody"
  s xComLinkTableHeader=..zzComLinkTableHeader()
  s xComLinkTableBody=..zzComLinkTableBody()
  &html<
    <br>
    <table width='350' height='400' border='0' cellspacing='0' cellpadding='0' style='position: relative; left: 10;'><tr><td valign='top'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr><td class='blackHeader'>
          &#160;Gateway
        </td></tr>
        <tr><td>
          <br>
          <div id='divMain'>
            <table><tr valign='top' align='center'>
              <td>
                #(xComLinkTableHeader)#
                <br>
                <table><tr><td><div id='appArea1' class='frameETL' style='width: 350;'>
                  <table><tr><td><div class='labelETL'>&#160;Tables&#160;</div></td></tr></table>
                  #(xComLinkTableBody)#
                </div></td></tr></table>
                <div align='right'>
                  <input type='submit' name='cmdOk' value='Ok' onClick='tableOk();' style='cursor: hand;' class='submtBtn'>
                  <input type='submit' name='cmdCancel' value='Cancel' onClick='tableCancel();' style='cursor: hand;' class='submtBtn'>
                </div>
              </td>
            </tr></table>
          </div>
        </td></tr>
      </table>
    </td></tr></table>
    <script language='javascript'>
    </script>
>
}

ClassMethod zzComLinkTableHeader()
{
  n
  s Z=$c(2),xWidth(1)=350
  s xStr="<table width='"_xWidth(1)_"' border='0' cellspacing='0' cellpadding='0'><tr><td>"
  ;
  s xStr=xStr_"<table width='100%' border='0' cellspacing='1' cellpadding='0'>"
  s xStr=xStr_"<tr><td width='15%'>Gateway:</td>"
  s xStr=xStr_"<td width='75%'><select id='selGateway' style='width: 200;' onChange=loadComSelect('TableList',selGateway.value); class='dropdnStyle'>"
  d Gateway^%bi.SMw.ETL
  s xStr=xStr_"<option value=0></option>"
  f i=1:1:OLIST d
  . s xStr=xStr_"<option value="_$p(OLIST(i),Z,1)_">"_$p(OLIST(i),Z,2)_"</option>"
  s xStr=xStr_"</select></td></tr>"
  s xStr=xStr_"</table>"
  ;
  s xStr=xStr_"</td></tr></table>"
  s xStr=xStr_"<script language=javascript>temp=location.href.split('dsn=');selGateway.selectedIndex=(temp.length>1?temp[1]:-1);</script>"
  q xStr
}

ClassMethod zzComLinkTableBody()
{
  n
  s Z=$c(2),xWidth(1)=310
  s cnt=0
  s xStr="<table width='"_xWidth(1)_"' border='0' cellspacing='0' cellpadding='0' style='position: relative; left: 10;'><tr><td>"
  ;
  s xStr=xStr_"<div id='divMainBody' style='height: 250; overflow: auto;'>&nbsp;</div>"
  ;
  s xStr=xStr_"</td></tr></table><br>"  
  q xStr
}

ClassMethod zzComLinkTableList(xGatewayId, xGatewayName)
{
  n (xGatewayId,xGatewayName,%session)
  d ..zzComGetClassDNS(xGatewayId)
  d ##class(%BI.Reporter).zzLoadTreePre(.OLIST,xGatewayName,xGatewayId)
  s xStr=$$loadTree^%bi.SMw.Util("chkTable",.VLIST,0)
  w ""_%session.Data("ComLinkTableDiv")_".innerHTML=""<div style='position: relative; left: -10;'>"_xStr_"</div>"";"
  ;w "divMainBody.innerHTML=""<div style='position: relative; left: -10;'>"_xStr_"</div>"";"
  ;
  s cnt=0
  s xStr=""
  s sb="" f  s sb=$o(IDLIST(sb)) q:sb=""  d
  . s xStr=xStr_"fieldRows["_cnt_"]="_IDLIST(sb)_";"
  . s xStr=xStr_"fieldRowsDesc["_cnt_"]="""_sb_""";"
  . s cnt=cnt+1
  w xStr
  q
}

ClassMethod zzComGetClassDNS(xGatewayId)
{
  n (xGatewayId,OLIST)
  s cond=$$Table^%bi.SMw.ETL(xGatewayId)
  f  d  q:cond=""
  . s:cond'="" cond=$$MoreTab^%bi.SMw.ETL(cond)
  q
}

}
