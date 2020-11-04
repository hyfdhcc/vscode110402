/// SQL Manager Class to Show Query Plan
Class %SQL.Manager.ShowPlan Extends %CSP.Util.AutoPage [ Not ProcedureBlock, System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

Parameter SECURITYRESOURCE = "%Development:USE";

ClassMethod HTMLPlan(line, frozen = 0) As %String
{
 // -----
 // Given a line of text, convert possible %plan tags to HTML tags 
 // -----
 new mod,pos,text
 set text = line
 if line="<plan>" quit ""
 if line="<sql>" do ..section1(frozen) quit ""
 if line="</sql>" do ..section1close(),..section2(frozen) quit ""
 if line["<cost value=" do ..cost() q ""
 if line["<module" do ..module(line) q ""
 if line["</module>" do ..moduleclose() q ""
 if line = "</plan>" set text = "<br></td></tr></table></table>" quit text
 if line["<subquery>" do ..module(line) q ""
 if line["</subquery>" do ..moduleclose() q ""
 if line["<Frozen Plan/>" &html<<blockquote>#("Frozen Plan")#</blockquote>> q ""
 //
 // Handle <expression>, <value> or other possible tags
 // Change angle bracket to square bracket otherwise will not display 
 //
 if line["<expression>" set line = $tr($tr(line,"<","["),">","]")
 if line="</expression>"!(line="</value>") q ""
 //
 // Handle <stats>. Return text in between <stats></stats> as is.
 if line["<stats>" set isstats = 1 q "<div style='color:#da4848;'>"_$tr($tr(line,"<","["),">","]")
 if line["</stats>" set isstats = 0 q "</div>"
 if isstats q text
 
 if line["<value>" set line = $tr($tr(line,"<","["),">","]")
 set pos = ..spacepos(line)
 // this is the query text
 if pos < 1,$g(ulclose)="" set ulclose = 1 q line
 // this is the major step, else it's sub
 if pos < 1,line'="" do  q ""
 . set mod = $p(line,"Call module ",2)
 . if mod '="" set mod = $p($p(line,"Call ",2),",",1),line = "Call <a href="_""""_"#"_$tr(mod," ","")_""""_">"_mod_"</a>"_$p(line,mod,2)
 . &html<<li>#(line)#</li><br>>
 else  do ..subpos(line,pos) q ""
 quit text
}

ClassMethod OnPage() As %Status
{
 &html<<html><head>
 <style type="text/css">
 DIV.result { 
  	font-family: courier new;	
 	font-size:	10pt;
 	}
 blockquote {
	margin: 0 0 0 10px;
	padding: 10px 15px 0px 10px;
}
 </style></head>>
 &html<<body bgcolor="#ffffff">>
 &html<<div align="center">>
 &html<<table cellpadding="0" cellspacing="1" border="0" width="100%">>
 &html<<tr bgcolor="#818181"><td valign="top" align="center">>

 new querytext,m,current,namespace,username,ImportPackage
 // -----
 // When this page is accessed via http://ipaddress:port/csp/sys, the current namespace is %SYS.
 // So we need to change to SQL Manager connected namespace.
 // After work is done, return to original namespace - %Cachelib.
 // -----
 set current = $zu(5)
 set namespace = $zcvt(%request.Get("namespace"),"U")
 if namespace'="",current'=namespace zn namespace
 //set (%msql,username) = %request.Get("username")
 set username = %session.Username
 set querytext = $g(^mqh(username))
 set ImportPackage = $g(^mqh(username,"schema"))
 if username = "" write !,$$$Text("No Username")
 if querytext = "" write !,$$$Text("No query text")
 else  set m = ..ShowPlan(querytext,ImportPackage) write !,m

 &html<</table>>
 &html<</div></body>>
 &html<</html>>
 if namespace'="",current'=namespace zn current
 Quit $$$OK
}

/// This method is called from %CSP.UI.SQL.ShowPlanPane to display HTML for show plan. "" is always returned. 
ClassMethod ShowPlan(querytext, ImportPackage = "", preparse, frozenplan As %Boolean = 0, selectmode = "Runtime", addDeclare = 0, schemaPath = "") As %String
{
 new cr,current,from,lastline,line,namespace,nSub,sql,sqlprep,text,to
 set (current,namespace) = $zu(5)
 	#; check so this method may be called when not using the Sys Mgr Portal
 If $IsObject($G(%request)) {
 	set namespace = $G(%request.Data("$NAMESPACE",1))
 } 
 if namespace'="",current'=namespace zn namespace
 // -----
 //  set css style for html output
 // -----
 &html<
 <link rel="stylesheet" href="#(..Link("/csp/sys/intersystems.css"))#" title="System Management Portal Style">
 <style type="text/css">
 TABLE.DetailTable	{ 
	margin-left: 2px;
}
a.modlink:hover
{
    color: #384492;
}
 </style>
 >
 // -----
 //  call to build %plan the first time
 // -----
 set cr = $c(13,10)
 kill %plan,sql
 #; if query text is passed in as an array, then use it as is. ow parse it out into array
 if $O(querytext("")) '= "" {
	 merge sql = querytext
 } else {
 	set sql = $l(querytext,cr)
 	for line=1:1:sql set sql(line) = $p(querytext,cr,line)
 }
 	#; If this is a SELECT query, add on a "DECLARE CURSOR QRS FOR " so the showplan will match the statement index for a dynamic query that may have already been executed and had it's plan frozen.
 	#; This will allow the statment to match and use the frozen plan
 	#;  Remeber, it might be ( SELECT, or any number of "("s before the SELECT token
 if addDeclare {
	for i=1:1:sql {
		if $$$UPPER($e($zstrip(sql(i),"<W","("_$c(13,10)),1,6))="SELECT" {	// line begins with SELECT
		 	set sql(i)="DECLARE QRS CURSOR FOR "_sql(i)
		 	quit
	 	}
	 	if $zstrip(sql(i),"<W","("_$c(13,10))="" { continue }			// blank line
		if $e($zstrip(sql(i),"<W","("_$c(13,10)),1,2)="--" { continue }		// line begins with a comment
	 	quit	// something other than SELECT or blank line
	}
 }
 #; If you want to show "stats" then pass in the parameter stats in the URL.
 #; stats=2 means lookup in %SYS.PTools.SQLStats
 #; stats=1 means generate new routine, execute and display stats, Need preparse =0 so parameters will work
 set stats = %request.Get("stats")
 set AltPlan = %request.Get("AltPlan")
 set:+stats'=0 preparse = 0
 if AltPlan="" { do ShowPlan^%apiSQL(.sql,1,,stats,ImportPackage,schemaPath,preparse,selectmode)}  // DPV3693, preparse then show the plan
 ELSE { do ShowPlanAlt^%apiSQL(.sql,1,,stats,ImportPackage,schemaPath,preparse,AltPlan) 
 		m %plan=%AltPlan(AltPlan)
 }	
 #; 
 #;  ShowPlan^%apiSQL returns array named %plan with integer subscript incremented by 1
 #;  the total number of lines in the array is set in %plan. e.g. %plan=3 means there are three lines
 #; 
 if $g(%plan)=0 {
	 set i=1,%plan(1)="<sql>"
	 for j=1:1:sql set i=i+1,%plan(i)=sql(j)
	 set i=i+1,%plan(i)="</sql>"
	 set i=i+1,%plan(i)="<plan>"
	 set i=i+1,%plan(i)="<br><center>["_$$$TextHTML("No plan created for this statement")_"]</center><br>"
	 set i=i+1,%plan(i)="</plan>"
	 set %plan=i
	 set nSub = 1
	 set to = +$g(%plan)+1
 }
 set nSub = 1
 set to = +$g(%plan)+1
 #;
 #;  Convert each line to HTML format
 #;  Return text when string exceeds 5000 characters
 #;
 set lastline = ""
 set isstats = 0
 while nSub<to {
	 set line = $g(%plan(nSub))
	 if line = "</sql>" set lastline = ""
	 if lastline '= "<sql>" set text = ..HTMLPlan(line,frozenplan)
	 else  set text = line
	 if text'="" {
		if lastline = "<sql>" {
			&html<<blockquote>#(text)#</blockquote>>
		} else {
			&html<#(text)#>
		}
	 }
	 if line = "<sql>" set lastline = line
	 set nSub = nSub + 1
 }
 kill %plan
 quit ""
}

/// This method is called from %CSP.UI.Portal.Dialog.SQLStatementDetails to display HTML for sql text. "" is always returned. 
/// Plan itself cannot be shown because the frozen plan has an error.
/// Or there is another reason the plan cannot be show and that reason is passed in via noPlanReasonTxt argument
ClassMethod ShowPlanError(querytext, noPlanReasonTxt = "") As %String
{
 new cr,current,from,lastline,line,namespace,nSub,sql,sqlprep,text,to
 set (current,namespace) = $zu(5)
 	#; check so this method may be called when not using the Sys Mgr Portal
 If $IsObject($G(%request)) {
 	set namespace = $G(%request.Data("$NAMESPACE",1))
 } 
 if namespace'="",current'=namespace zn namespace
 // -----
 //  set css style for html output
 // -----
 &html<
 <link rel="stylesheet" href="#(..Link("/csp/sys/intersystems.css"))#" title="System Management Portal Style">
 <style type="text/css">
 TABLE.DetailTable	{ 
	margin-left: 2px;
}
a.modlink:hover
{
    color: #384492;
}
 </style>
 >
 // -----
 //  call to build %plan the first time
 // -----
 set cr = $c(13,10)
 kill %plan,sql
 #; if query text is passed in as an array, then use it as is. ow parse it out into array
 if $O(querytext("")) '= "" {
	 merge sql = querytext
 } else {
 	set sql = $l(querytext,cr)
 	for line=1:1:sql set sql(line) = $p(querytext,cr,line)
 }
 #; 
 #;  ShowPlan^%apiSQL returns array named %plan with integer subscript incremented by 1
 #;  the total number of lines in the array is set in %plan. e.g. %plan=3 means there are three lines
 #; 
 QUIT:$g(sql)=0 "<br>["_$$$TextHTML("No SQL Statement")_"]"
 set i=1,%plan(1)="<sql>"
 for j=1:1:sql set i=i+1,%plan(i)=sql(j)
 set i=i+1,%plan(i)="</sql>"
 set i=i+1,%plan(i)="<plan>"
 if noPlanReasonTxt="" { set i=i+1,%plan(i)=$$$TextHTML("Plan could not be determined due to an error in the frozen plan") }
 else                  { set i=i+1,%plan(i)=noPlanReasonTxt }
 set i=i+1,%plan(i)="</plan>"
 set %plan=i
 set nSub = 1
 set to = +$g(%plan)+1
 #;
 #;  Convert each line to HTML format
 #;  Return text when string exceeds 5000 characters
 #;
 set lastline = ""
 set isstats = 0
 while nSub<to {
	 set line = $g(%plan(nSub))
	 if line = "</sql>" set lastline = ""
	 if lastline '= "<sql>" set text = ..HTMLPlan(line)
	 else  set text = line
	 if text'="" {
		if lastline = "<sql>" {
			&html<<blockquote>#(text)#</blockquote>>
		} else {
			&html<#(text)#>
		}
	 }
	 if line = "<sql>" set lastline = line
	 set nSub = nSub + 1
 }
 kill %plan
 quit ""
}

/// parse and write out cost
ClassMethod cost()
{
 set text = $$$TextHTML("Relative cost")_" = "_$p($p(line,"value=",2),"/>",1)
 set text = $tr(text,"""","")
 &html<<blockquote>#(text)#</blockquote>>	
 &html<<ul>>
 set ulclose = 0
}

/// create module table, close previous table first
ClassMethod module(line)
{
 new modname,module,modbkcolor
 set modname = $tr($p($p(line,"name=",2),">",1),"""","")
 set module = $s(line="<subquery>":"subquery",1:"module")
 #; YSD2777 set modbkcolor = $s(module="module":"#ffff00",1:"linen")
 set modbkcolor = $s(module="module":"#F3E799",1:"linen")
 &html<<tr bgcolor="#ffffff"><td>>
 &html<<table width="100%" border="0" cellpadding="4" cellspacing="0">>
 &html<<tr bgcolor=#(modbkcolor)#><td valign="top" align="center" style="color:#444444;"><a class="modlink" name=#(module)##(modname)#><h2> #(module)# #(modname)#</h2></td></tr>>
 set ulclose = 0
 &html<<tr bgcolor="#ffffff"><td align="left"><ul>>
}

/// close module table, close previous table first
ClassMethod moduleclose()
{
 if +$g(ulclose) = 1 &html<</ul>> set ulclose = 10
 &html<</ul></td></tr></table>>
}

/// create query text table
ClassMethod section1(frozen = 0)
{
 &html<<table cellpadding="0" cellspacing="1" border="0" width="100%">>
 &html<<tr bgcolor="#ffffff"><td valign="top" align="left">>
 //YSD2331 &html<<tr bgcolor="#008000"><td valign="top" align="center"><font face="verdana, arial" size="5" color="white"><b>#($$$TextHTML("Statement Text"))#</b></font></td></tr>>	
 if $case(frozen,0:1,3:1,:0) {
	 &html<<tr bgcolor="#60A060"><td valign="top" align="center" style="color:white;"><h1>#($$$TextHTML("Statement Text"))#</h1></td></tr>>
 }
 else {
	 &html<<tr bgcolor="#87CEFA"><td valign="top" align="center" style="color:white;"><h1>#($$$TextHTML("Statement Text"))#</h1></td></tr>>
 }
 //YSD537 &html<<tr bgcolor="#ffffff"><td valign="middle" align="left"><font face="courier new">>
 &html<<tr bgcolor="#ffffff"><td valign="middle" align="left">
 <pre>>
}

/// close query text table
ClassMethod section1close()
{
 &html<</pre><br></td></tr>>
 &html<</table></table><br>>
 &html<<table cellpadding="0" cellspacing="1" border="0" width="100%">>
 &html<<tr bgcolor="#818181"><td valign="top" align="center">>
 &html<<table border="0" width="100%" cellpadding="0" cellspacing="1">>
}

/// create query plan table
ClassMethod section2(frozen = 0)
{
	if $case(frozen,0:1,3:1,:0) {
		&html<<tr bgcolor="#60A060"><td valign="top" align="center" style="color:white;"><h1>#($$$TextHTML("Query Plan"))#</h1></td></tr>>
	}
	else {
		&html<<tr bgcolor="#87CEFA"><td valign="top" align="center" style="color:white;"><h1>#($$$TextHTML("Frozen Query Plan"))#</h1></td></tr>>
	}
	&html<<tr bgcolor="#ffffff"><td valign="top" align="left">>
}

/// Given a line of text, return the position of the first character that is not a space
ClassMethod spacepos(line) As %Integer
{
 new pos
 for pos=1:1:$l(line) q:$e(line,pos)'=" "
 quit pos-1
}

/// write out subroutine lines 
ClassMethod subpos(line, pos)
{
 &html<<img src='../images/spacer.gif' width=#(pos*10/2)# height=1>#(line)#<br>>
}

}
