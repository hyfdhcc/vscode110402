Include %sqlui

/// Utilities used by Management Portal SQL.
Class %CSP.UI.Portal.SQL.Utils Extends %RegisteredObject [ Abstract, System = 4 ]
{

Parameter DOMAIN = "%Utility";

/// Method to return SQL statement object and class name. Called by multiple SQL UI pages.
/// When %caller is passed in as "SMP" then the system will prevent the DDL API from checking the DDLAllowed flag for the class (used by modifying view)
ClassMethod SQLExecuteQuery(pText As %String(MAXLEN=""), ByRef pClassName As %String, pRuntimeMode As %Integer = 2, pDialect As %String = "Cache", pObjectSelectMode As %Boolean = 0, %caller As %String = "", ByRef tGlobals, ByRef tLines, ByRef tDiskRead) As %String
{
#dim tException as %Exception.AbstractException
#define ResponseTimeout Set responseTimeout = %request.GatewayTimeout - 5 If responseTimeout < 15 Set responseTimeout = 15
	New %tStatement,%tResult
	Set %tStatement = ##class(%SQL.Statement).%New()
	Set %tStatement.%SelectMode = pRuntimeMode
	Set %tStatement.%Dialect = pDialect
	Set %tStatement.%ObjectSelectMode = pObjectSelectMode
	Set tGlobals = 0, tLines = 0, tDiskRead = 0
	If $get(^%SYS("Compiler","EnableDiskReadTiming"),1) Do ##class(%SYSTEM.Process).EnableDiskReadTiming()
	try {
		x:$d($$$SQLServerInitCode) $$$SQLServerInitCode
		$$$ResponseTimeout
		Do $System.Alarm.Set(responseTimeout)
		If $IsObject(pText) {
			Kill pText
			Merge pText = %session.Data($Username,"SQL","QueryText")	
		}
		Do %tStatement.prepare(.pText)
		Set tParameterCount = %tStatement.%Metadata.parameters.Count()
		If tParameterCount > 0 {
			Set tExecute = "Set %tResult = %tStatement.%Execute("
			#; check if it is the same query!
			If tParameterCount = $P(%session.Data($Username,"SQL","QueryParam"),"^",1) {
				Set tPromptCount = $P(%session.Data($Username,"SQL","QueryParam"),"^",2)
				Set tParm = $O(%session.Data($Username,"SQL","QueryParam",""))
				While tParm '= "" {
					Set tParmExpr = "%tValue"_tParm
					Set tParamColumnType = %session.Data($Username,"SQL","QueryParam",tParm)
					If (tParamColumnType = 1) || (tParamColumnType = 2) {
						Set tParmVal = %session.Data($Username,"SQL","QueryParam",tParm,"Value")
						Set tParmExpr = "%tValue"_tParm
						Set @("%tValue"_tParm) = tParmVal
						Set tExecute = tExecute _ tParmExpr _ ","
					} 				
					ElseIf tParamColumnType > 3 {
						// Output only (4) or Return value (5)
						Set tExecute = tExecute _ ","
					}
					Set tParm = $O(%session.Data($Username,"SQL","QueryParam",tParm))
				}
			}
			Set tExecute = $Select($Extract(tExecute,*)'="(":$Extract(tExecute,1,*-1)_")",1:tExecute _ ")")
			Set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds
			xecute tExecute
		} Else {
			Set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds
			Set %tResult = %tStatement.%Execute()
		}
		Do $System.Alarm.Clear()
		Set tSC = %tStatement.%GetImplementationDetails(.pClassName,.%tStatement,.tArgument)
	}
	catch tException {
		Set %tResult = ##class(%SQL.StatementResult).%New()
		Do $System.Alarm.Clear()
		If ($ZE["<ALARM>") {
			$$$ResponseTimeout
			Set %tResult.%Message = $ZCVT($$$FormatText($$$Text("Query did not compile or execute within %1 seconds."), responseTimeout),"O","HTML")
		} Else {	
			Set %tResult.%SQLCODE = tException.AsSQLCODE()
			Set %tResult.%Message = tException.SQLMessageString()
		}
	}
	Quit %tResult
}

/// Method to return number of parameters that user needs to provide for input in order to execute the query.
/// Return number of Parameters within query text. 0 means none. 
ClassMethod GetQueryParameters(pText As %String(MAXLEN=""), pRuntimeMode As %Integer = 2, pDialect As %String = "Cache", pObjectSelectMode As %Boolean = 0, ByRef tPromptCount As %Integer) As %String
{
#dim tException as %Exception.AbstractException
#define ResponseTimeout Set responseTimeout = %request.GatewayTimeout - 5 If responseTimeout < 15 Set responseTimeout = 15
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tStatement.%SelectMode = pRuntimeMode
	Set tStatement.%Dialect = pDialect
	Set tStatement.%ObjectSelectMode = pObjectSelectMode
	Set tResult = ##class(%SQL.StatementResult).%New()
	Set tResult.%Message = ""
	#; tPromptCount is the total number of input that we will need to prompt the user to enter (param type is 1 or 2 only)
	#; tParameterCount is the total parameters
	try {
		$$$ResponseTimeout
		Do $System.Alarm.Set(responseTimeout)
		If $IsObject(pText) {
			Kill pText
			Merge pText = %session.Data($Username,"SQL","QueryText")
		}
		Do tStatement.prepare(.pText)
		Set tParameterCount = tStatement.%Metadata.parameters.Count()
		Kill %session.Data($Username,"SQL","QueryParam")
		If tParameterCount > 0 {
			For tParm = 1:1:tParameterCount {
				Set tParameter = tStatement.%Metadata.parameters.GetAt(tParm)
				Set tParamColumnType = tParameter.columnType
				Set %session.Data($Username,"SQL","QueryParam",tParm) = tParamColumnType
				If (tParamColumnType = 1) || (tParamColumnType = 2) {
					Set tPromptCount = tPromptCount + 1
				}
			}
		}
		Set %session.Data($Username,"SQL","QueryParam") = tParameterCount_"^"_tPromptCount
		Do $System.Alarm.Clear()
	}
	catch tException {
		Do $System.Alarm.Clear()
		If ($ZE["<ALARM>") {
			$$$ResponseTimeout
			Set tResult.%Message = $ZCVT($$$FormatText($$$Text("Statement did not finish prepare within %1 seconds."), responseTimeout),"O","HTML")
		} Else {	
			Set tResult.%SQLCODE = tException.AsSQLCODE()
			Set tResult.%Message = tException.SQLMessageString()
		}
	}
	Quit tResult
}

/// GetError will return the HTML for an invalid SQLCODE.
ClassMethod GetError(pResult As %SQL.StatementResult, ByRef pMessages As %String(MAXLEN=""))
{
	set pMessages = +$G(pMessages) + 1, pMessages(pMessages) = $ZCVT("[SQLCODE: <"_pResult.%SQLCODE_">:<"_$system.SQL.SQLCODE(pResult.%SQLCODE) _ ">]","O","HTML")
	set pMessages = pMessages + 1, pMessages(pMessages) = $ZCVT("[%msg: <"_pResult.%Message_">]","O","HTML")
}

/// Given schema name and view name, return view info
ClassMethod GetViewInfo2(Schema As %String, ViewName As %String, Output Owner As %String, Output ReadOnly As %Boolean, Output CheckOption As %String) As %Status
{
	Set $ZT="Trap"
	Set currentNS = $zu(5)
	Set tRS = ##class(%ResultSet).%New("%SQL.Manager.Catalog:ViewInfo2")
	Do tRS.Execute(Schema, ViewName)
	If tRS.Next() {
		Set Owner = tRS.Data("OWNER")
		Set ReadOnly = tRS.Data("DEFINED_AS_READ_ONLY")
		Set CheckOption = tRS.Data("CHECK_OPTION")
	}
	Quit $$$OK
Trap
	Set $ZT="" Quit 0
}

/// ***** The following methods are used to draw query results. Multiple resultsets and call statements are handled. *****
/// ***** The caller should have already obtained a SQL statement result using SQLExecuteQuery in this class.        *****
/// ***** See method DrawHTML in %CSP.UI.Portal.SQL.Home and %CSP.UI.Portal.SQL.PrintQuery                               *****
/// 
/// DrawResult will draw all of the result information returned in the statement result object.
ClassMethod DrawResult(pResult As %SQL.StatementResult, pDrawTab As %Boolean = 0, pShowRowNum As %Boolean)
{
#dim tResult as %SQL.StatementResult
#dim tResultSet as %SQL.IResultSet
#dim tRSMD as %SQL.StatementMetadata
	Set tMessages = 0, tOutputValues = 0, tResultSet = 0
	Set ^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount") = ""
	Set ^CacheTemp.ISC.ExeucteQuery($Username,"%SQLCODE") = pResult.%SQLCODE
	If 'pDrawTab &html<<link rel="stylesheet" type="text/css" href='#(##class(%CSP.Page).Link("/csp/sys/intersystems.css"))#'>>
	If pResult.%SQLCODE '< 0 {
		Set tOutputValues = pResult.%OutputColumnCount > 0
		If pResult.%ResultColumnCount {
			#; %CurrentResult will be bound as a result of checking %ResultColumnCount. Grab it now and then loop over
			#; the remaining result sets and place them in the tResultSet array
			Set tResultSet = 1, tResultSet(1) = pResult.%CurrentResult
			Set tTemp = pResult.%NextResult() While $Isobject(tTemp) { Set tResultSet = tResultSet + 1, tResultSet(tResultSet) = tTemp, tTemp = pResult.%NextResult() }
			#; Draw tabs
			Do:pDrawTab ..DrawTabs(tResultSet,tOutputValues)
			#; And now draw the result sets
			For tPtr = 1:1:tResultSet { Do ..DrawResultSet(tPtr,tResultSet(tPtr),pDrawTab,pShowRowNum,.tMessages) }
		}
		Else {
			Write "<p>&nbsp;&nbsp;",$$$FormatText($$$Text("%1 row(s) affected"),pResult.%ROWCOUNT),"</p>"
			Set ^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount") = $S($G(^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount"))'="":^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount")_" / ",1:"")_pResult.%ROWCOUNT
		}
		If tOutputValues {
			Do ..DrawOutputColumns(tResultSet + 1, pResult, pDrawTab, .tMessages)
		}
	}
	Else { 
		Do ..GetError(pResult,.tMessages)
		Do ..DrawMessages("",pDrawTab,.tMessages)
	}
}

/// Draw html for one resultset.
ClassMethod DrawResultSet(pPtr As %Integer, pResult As %SQL.StatementResult, pDrawTab As %Boolean, pShowRowNum As %Boolean, ByRef pMessages As %String(MAXLEN=""))
{
	Set tRSMD = pResult.%GetMetadata()
	Set divid = "div"_pPtr
	Set state = $S(pPtr=1||'pDrawTab:"block",1:"none")
	Set maxrows = %page.MaxRows
	&html<<br/><div id="#(divid)#" class="groupResult" style="display:#(state)#">>
	If 'pDrawTab &html<<h3>#($$$Text("Result #"))##(pPtr)#</h3>>
	Write "<table class='ExecuteTable' cellpadding='1' cellspacing='1'><tr>"
	If pShowRowNum = 1 {
		Write "<th>#</th>"
	}
	Set tColumns = tRSMD.columnCount
	For tColPtr = 1:1:tColumns {
		Write "<th>",$ZCVT(tRSMD.columns.GetAt(tColPtr).colName,"O","HTML"),"</th>"
	}
	Write "</tr>"
	Set (tRow,tTotal) = 0
	While pResult.%Next() & (tTotal < maxrows) {
		Set tRow = 'tRow
		Set tTotal = tTotal + 1
		Set tClass = $S(tRow:"EvenRow",1:"OddRow")
		&html<<tr class="#(tClass)#">>
		If pShowRowNum = 1 Write "<td>",tTotal,"</td>"
		For tColPtr = 1:1:tColumns {
			Write "<td>",$ZCVT(pResult.%GetData(tColPtr),"O","HTML"),"</td>"
		}
		Write "</tr>"
	}
	//pResult.%ROWCOUNT
	Write "</table>"
	Write "<p>",$$$FormatText($$$Text("%1 row(s) affected"),tTotal),"</p>"
	Set ^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount") = $S($G(^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount"))'="":^CacheTemp.ISC.ExeucteQuery($Username,"ResultCount")_" / ",1:"")_tTotal
	If pResult.%SQLCODE < 0 {
		Do ..GetError(pResult,.tMessages)	
		Do ..DrawMessages("",pDrawTab,.tMessages)
	}
	&html<</div>>
}

ClassMethod DrawOutputColumns(pPtr As %Integer = 0, pResult As %SQL.StatementResult, pDrawTab As %Boolean, ByRef pMessages As %String(MAXLEN=""))
{
	Set tRSMD = pResult.%GetMetadata()
	Set divid = "div"_pPtr
	Set state = $S(pPtr=1||'pDrawTab:"block",1:"none")
	&html<<div id="#(divid)#" style="display:#(state)#">>
	If 'pDrawTab &html<<h3>#($$$Text("Output Columns"))##(pPtr)#</h3>>
	Write "<table class='DetailTable'><tr>"
	Write "<th>",$ZCVT("Parameter","O","HTML"),"</th>"
	Write "<th>",$ZCVT("Value","O","HTML"),"</th>"
	Write "</tr>"
	Set tRow = 0
	Set tPosition = ""
	Set tValue = pResult.%NextOutputValue(.tPosition)
	While tPosition '= "" {
		Set tRow = 'tRow
		Set tClass = $S(tRow:"DarkRow",1:"LiteRow")
		&html<<tr class="#(tClass)#">>
		Write "<td>",$ZCVT(tPosition,"O","HTML"),"</td>"
		Write "<td>",$ZCVT(tValue,"O","HTML"),"</td>"
		Write "</tr>"
		Set tValue = pResult.%NextOutputValue(.tPosition)
	}
	Write "</table>"
	&html<</div>>
}

/// Messages passed in should already been HTML escaped.
ClassMethod DrawMessages(pPtr As %Integer = 1, pDrawTab As %Boolean, ByRef pMessages As %String(MAXLEN=""))
{
	If pDrawTab = 0 &html<<h3>#($$$TextHTML("Messages"))#</h3>>
	&html<<div id="idMessages" class="ErrorBox">>
	For tMsgPtr = 1:1:$Get(pMessages) { Write "<p>&nbsp;&nbsp;",pMessages(tMsgPtr),"<p>" }
	&html<</div>>
}

/// Control method to draw tab group. This is only used on the SQL Home page for Execute Query tab. 
ClassMethod DrawTabs(totalResultsets, pOutputValues As %Integer = 0)
{
	#; If single resultset and no output values, then no need to draw tabs.
	If totalResultsets = 1,'pOutputValues Quit
	&html<<table class="tabGroupBar" border="0" cellspacing="0" cellpadding="0">
	<tr><td width="20">&nbsp;</td>>
	Set totalTabs = totalResultsets + 1 + pOutputValues
	For t = 1:1:totalResultsets {
		Set tCaption = $$$TextHTML("Result #")_t
		Set tTabclass = "tabGroupButton"_$S(t=1:"On",1:"Off")
		Do ..DrawTabBox(tTabclass,tCaption,t,totalTabs)
	}
	If pOutputValues { 
		Set tCaption = $$$TextHTML("Output Values")
		Do ..DrawTabBox("tabGroupButtonOff",tCaption,t+1,totalTabs) 
	}
	//Set tCaption = $$$TextHTML("Messages")	
	//Do ..DrawTabBox("tabGroupButtonOff",tCaption,t+1+pOutputValues,totalTabs)
	
	&html<<td width="25%" class="tabGroupExtra">&nbsp;</td>
	</tr></table>>
}

/// Draws each tab in tab group button
ClassMethod DrawTabBox(tabClass As %String, tabCaption As %String, tabIndex As %Integer, totalTabs As %Integer)
{
	Set title = $$$TextHTML("Click to change to or refresh this tab")
	Set tText = "<a href='#'>&nbsp;"_$ZCVT(tabCaption,"O","HTML")_"&nbsp;</a>"
	Set tId = "extab"_tabIndex
	Set tClick = "onclick=""return zenPage.tabChanged("_tabIndex_","_totalTabs_");"""
	&html<<td nowrap="1" id="#(tId)#" class="#(tabClass)#" #(tClick)#>#(tText)#</td><td class="tabGroupGapTd"><div class="tabGroupGap"> </div></td>>
}

/// *****                 End of Group Methods for DrawResult                  *****
/// List schemas based on cache gateway connection - you must have a DSN (Cache configuration name) passed in.
/// This method is Jobbed from the wizard page.
ClassMethod LoadSchemas(pWizard, pDSN, pTableType, pSchemaFilter) As %String
{
	Set $ze="",$zt="errSchema"
	
	Set ^CacheTemp.LinkWizardLoad(+$J) = $H
	Set cnt = 0,pfx=""
	Do getFlags^%apiGTW(pDSN,.f,.isJ)

	If isJ set pfx="J"

	If pWizard = "LinkProcedure" Set QUERYNAME = "%GTWCatalog:SQLProcedures"_pfx
	Else  set QUERYNAME = "%GTWCatalog:SQLTables"_pfx
	
	Set rs = ##class(%ResultSet).%New(QUERYNAME)
	Set tname = ""
	If isJ, pWizard '="LinkProcedure" Set tname = "%"

	If isJ, pWizard = "LinkProcedure" Set tSC = rs.Execute(pDSN,"",pSchemaFilter)
	If isJ, pWizard '= "LinkProcedure" Set tSC = rs.Execute(pDSN,tname,pTableType,pSchemaFilter)
	If 'isJ {
		If pWizard '= "LinkProcedure" Set tSC = rs.Execute(pDSN,tname,pTableType,pSchemaFilter)
		Else  Set tSC = rs.Execute(pDSN,"",pSchemaFilter)
	}
	If $$$ISERR(tSC) {
		Set ^CacheTemp.LinkWizardLoad(+$J) = "ERROR" _ $System.Status.GetErrorText(tSC)
		Quit 1
	}

	Set msg = $$$Text("retrieved")
	Set n = 0
	While rs.Next() {
		Set n = n + 1
	  Set schemaname = rs.Data("SCHEMA_NAME") 
	  If schemaname="" set schemaname="[null schema]"
	  If schemaname'="",$a(schemaname) = 0 set schemaname="[empty schema]"
	  Set ^CacheTemp.LinkWizardLoad(+$J) = n_" " _ msg
	  Set sche(schemaname) = 1
	  
	}
	// YSD1234 - if the only schema is [empty schema] then change it to [null schema]
	Set schemaname=$o(sche(""))
	If schemaname = "[empty schema]",$o(sche(schemaname))="" Set sche("[null schema]") = 1 kill sche("[empty schema]")
	Set (rs,s) = ""
	Merge ^CacheTemp.LinkWizardLoad(+$J) = sche
	Set ^CacheTemp.LinkWizardLoad(+$J) = "Done"
	Quit 1
errSchema
	Set ^CacheTemp.LinkWizardLoad(+$J) = "ERROR" _ $ZCVT($ZE,"O","HTML")
	Set $ZE = ""
	Quit 0
}

// background job to load tables or procedures

ClassMethod LoadTables(pWizard, pDSN, pSchema, pTableType, pFilter) As %String
{
	Set $ze="",$zt="errTable"
	Set ^CacheTemp.LinkWizardLoad(+$J)=$H

	Set cnt = 0,pfx=""
	Do getFlags^%apiGTW(pDSN,.f,.isJ)
	If isJ set pfx="J"

	Set tschema = ..ReverseSchema(pSchema)
	If pWizard = "LinkTable"!(pWizard = "DataMigration") {
		Set rs = ##class(%ResultSet).%New("%GTWCatalog:SQLTables"_pfx)
		
		//If isJ do rs.Execute(pDSN,pFilter,pTableType,tschema)
		//If 'isJ do rs.Execute(pDSN,pFilter,pTableType,tschema)
		Set tSC = rs.Execute(pDSN,pFilter,pTableType,tschema)
		Set NAME = "TABLE_NAME"
		Set TYPE = "TABLE_TYPE"
	} else {
		Set rs = ##class(%ResultSet).%New("%GTWCatalog:SQLProcedures"_pfx)
		Set tSC = rs.Execute(pDSN,pFilter,tschema)
		Set NAME = "PROC_NAME"
		Set TYPE = "PROC_TYPE"
	}
	If $$$ISERR(tSC) {
		Set ^CacheTemp.LinkWizardLoad(+$J) = "ERROR" _ $System.Status.GetErrorText(tSC)
		Quit 1
	}

	While rs.Next() {
	  	Set tablename = rs.Data(NAME)
	  	If tablename'="" Set ^CacheTemp.LinkWizardLoad(+$J,tablename) = rs.Data(TYPE)
	}
	Set rs = ""
	Set ^CacheTemp.LinkWizardLoad(+$J) = "Done"
	Quit 1
errTable
	Set ^CacheTemp.LinkWizardLoad(+$J) = "ERROR" _ $ZCVT($ZE,"O","HTML")
	Set $ze = ""
	Quit 0
}

ClassMethod ReverseSchema(schema) As %String
{
	if schema = "[null schema]" quit ""
	if schema = "[empty schema]" quit $c(0)
	if schema = "[no schema]" quit ""
	quit schema
}

}
