Include %occInclude

IncludeGenerator %occInclude

/// The <b>%SQLQuery</b> class is used for defining class queries based on SQL definitions.
Class %Library.SQLQuery Extends %Query [ Not ProcedureBlock, System = 2 ]
{

/// COMPILEMODE is a parameter that similar to the embedded SQL COMPILE directive. COMPILEMODE
/// defaults to 'immediate' which means that the SQL Query will be processed as embedded SQL
/// and the statement is compiled at the same time as the query methods are compiled. If the value
/// is specified as 'dynamic' then the query will be generated at compile time but the statement
/// is processed as a dynamic statement, meaning it will be dynamically prepared. A dynamic prepare
/// checks at runtime to see if the statement has been compiled, if so it just runs the statement. If
/// the statement has not been compiled then it is compiled and then run. The advantage of 'dynamic'
/// COMPILEMODE is that the cost of preparing the statement is deferred until first call and the
/// query can respond to changes to the referenced tables, including any changes made to the table
/// by tuning.
Parameter COMPILEMODE As STRING [ Constraint = "IMMEDIATE,DYNAMIC", Flags = ENUM ] = "IMMEDIATE";

Parameter SQLQUERY;

Parameter SELECTMODE = "RUNTIME";

/// 	Close the query associated with the handle
ClassMethod Close(%qHandle As %Binary) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set %code=0
	 	#; don't generate any code if it not for a query
	if %mode="method" quit $$$OK
	 	#; Close cursor
	if $$$ucase(%parameter("COMPILEMODE")) '= "DYNAMIC" {
		set cursor = $get($$$tCURSORID(%class,$$$cCLASSquery,%property)) if 'cursor { set cursor = $Increment($$$tCURSOR(%class)), $$$tCURSORID(%class,$$$cCLASSquery,%property)=cursor } set cursor = "Q"_cursor
		$$$GENERATE("	&sql(CLOSE "_cursor_")")
		$$$GENERATE("	If SQLCODE { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%Message=$g(%msg) Set sc=$$$ERROR($$$SQLCode,SQLCODE,$get(%msg)) } Else { Set sc=$$$OK }")
		set statevars="	Kill " for var="c","p","s","t","l","R","Z" set statevars=statevars_"%objcs"_var_"(%qHandle),"
		set statevars=statevars_"%objcsd(%qHandle)"
		$$$GENERATE(statevars)
		$$$GENERATE("	Quit sc")
	}
	else {
		$$$GENERATE($Char(9)_"set %qHandle = """"")
		$$$GENERATE($Char(9)_"quit $$$OK")
	}
	quit $$$OK
}

/// Func is a method that is used to invoke the query as a function, returning an instance of %SQL.StatementResult.
ClassMethod Func() As %SQL.StatementResult [ CodeMode = generator, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set %code=0
		// don't generate any code if it not for a query
	if %mode="method" quit $$$OK
		// %mode is "propertymethod" for a valid query. We don't have any way currently to detect a misuse of a query class
	if '$$$comMemberDefined(%class,$$$cCLASSquery,%property) quit $$$OK
		// Reset the formal list to the query declaration:
	$$$comSubMemberKeyGetLvar(formal,%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed)
	$$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
	$$$comSubMemberKeySet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed,formal_qformal)
	set sc=$$SetOneQueryMeth^%occQuery(%class,%property,%method) quit:$$$ISERR(sc) sc

	$$$comMemberKeyGetLvar(origin,%class,$$$cCLASSquery,%property,$$$cXXXXorigin)
	$$$comMemberKeyGetLvar(query,%class,$$$cCLASSquery,%property,$$$cQUERYsqlquery)
		// preparse the query to construct the actual argument list. If more than the supported number of arguments then revert to
		// the non-dynamic option
	set query = $zstrip(query,"<W")
	set tLines = 0 for tPtr = 1:1:$Length(query,$$$NL) { set tLine = $Piece(query,$$$NL,tPtr) if tLine '= "" { set tLines = tLines + 1, tLines(tLines) = tLine } }
	set sc=$$ExpandMacros^%SYS.DynamicQuery(%class,.tLines) QUIT:$$$ISERR(sc) sc
	set SQLCODE = $$dynamic^%qaqpreparser(.tLines,.tStatementPreparsed,.tStatementArgs)
		//
	set tSelectMode = $Case($$$ucase(%parameter("SELECTMODE")), "RUNTIME": "", "ODBC": 1, "DISPLAY": 2, "LOGICAL": 0, : "")
	$$$GENERATE($Char(9)_"try {")
	if SQLCODE=0 && ($Listlength(tStatementArgs) < 361) && ($Length(tStatementPreparsed) < 40000) {
		set tExecuteArgs = "" for tPtr=1:2:$ListLength(tStatementArgs) { set tArg = $Case($List(tStatementArgs,tPtr),"?":"$g(%parm("_$Increment(qcount)_"))","c":$$quoter^%qaqpreparser($List(tStatementArgs,tPtr+1)),"v":"$g("_$List(tStatementArgs,tPtr+1)_")",:"") Set tExecuteArgs = tExecuteArgs _ "," _ tArg }
		$$$GENERATE($Char(9,9)_"set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())")
		$$$GENERATE($Char(9,9,9)_"set tStatement = ##class(%SQL.Statement).%New(" _ tSelectMode _ ",tSchemaPath)")
		$$$GENERATE($Char(9,9,9)_"do tStatement.prepare("_$zu(144,1,tStatementPreparsed) _ ")")
		$$$GENERATE($Char(9,9)_"set tResult = tStatement.%Execute(" _ $Extract(tExecuteArgs,2,*) _ ")")
	}
	else {
		set tExecuteArgs = ""
		if $listlength(qformal) {
			for tPtr = 1:1:$listlength(qformal) {
				set tArgumentName = $list($list(qformal,tPtr))
				set tExecuteArgs = tExecuteArgs_","_ $Select($Extract(tArgumentName,*-2,*)'="...":"."_tArgumentName,1:tArgumentName)
			}
		}
		$$$GENERATE($Char(9,9)_"set tSC = .."_$$$QN(%property_"Execute")_"(.qHandle"_tExecuteArgs_")")
		$$$GENERATE($Char(9,9)_"if $$$ISERR(tSC) { throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }")
		$$$GENERATE($Char(9,9)_"set tResult = ##class(%SQL.ClassQueryResultSet).%New($classname(),"_$zu(144,1,%property)_",.qHandle)")
	}
	$$$GENERATE($Char(9)_"}")
	$$$GENERATE($Char(9)_"catch tException { if '$Isobject($Get(tResult)) { set tResult = ##class(%SQL.StatementResult).%New() } set tResult.%SQLCODE=tException.AsSQLCODE(),tResult.%Message=tException.AsSQLMessage() }")
	$$$GENERATE($Char(9)_"Quit tResult")
	QUIT $$$OK
}

/// 	Execute is passed parameters for Query
/// 	Returns handle for subsequent operations
ClassMethod Execute(ByRef %qHandle As %Binary) As %Status [ CodeMode = generator, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set %code=0
		// don't generate any code if it not for a query
	if %mode="method" quit $$$OK
		// %mode is "propertymethod" for a valid query. We don't have any way currently to detect a misuse of a query class
	if '$$$comMemberDefined(%class,$$$cCLASSquery,%property) quit $$$OK
		// Reset the formal list to the query declaration:
	$$$comSubMemberKeyGetLvar(formal,%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed)
	$$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
	$$$comSubMemberKeySet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed,formal_qformal)
	set sc=$$SetOneQueryMeth^%occQuery(%class,%property,%method) quit:$$$ISERR(sc) sc
	
	$$$comMemberKeyGetLvar(origin,%class,$$$cCLASSquery,%property,$$$cXXXXorigin)
	$$$comMemberKeyGetLvar(query,%class,$$$cCLASSquery,%property,$$$cQUERYsqlquery)
		// Generate the code for IMMEDIATE mode.
	if $$$ucase(%parameter("COMPILEMODE")) '= "DYNAMIC" {
		if origin'="" {
			set package=$$$ClassPackageName(origin)
			$$$GENERATE("#import "_package)
		}	
		$$$GENERATE("	#sqlcompile select="_%parameter("SELECTMODE"))
		set cursor = $get($$$tCURSORID(%class,$$$cCLASSquery,%property)) if 'cursor { set cursor = $increment($$$tCURSOR(%class)), $$$tCURSORID(%class,$$$cCLASSquery,%property)=cursor } set cursor = "Q"_cursor
			#; Initialize %qHandle...
		$$$GENERATE("	s %qHandle=$i(%objcn)")
		#; define cursor
		$$$GENERATE("#EXECUTE s %msqlvar=""%objcs(%qHandle""")
		$$$GENERATE($c(9)_"&sql(DECLARE "_cursor_" CURSOR FOR")
		set qline=0
		for i=1:1:$length(query,$$$NL) set line=$piece(query,$$$NL,i) if line'="" set qline=qline+1,qline(qline)=line
		for i=1:1:qline-1 $$$GENERATE($char(9,9)_qline(i))
		if qline {
			$$$GENERATE($char(9,9)_qline(qline))
			$$$GENERATE($char(9,9)_")")
		}
		$$$GENERATE("#EXECUTE k %msqlvar")
	
		#; Open cursor
		$$$GENERATE("	&sql(OPEN "_cursor_")")
		$$$GENERATE("	If SQLCODE { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%Message=$g(%msg) Set sc=$$$ERROR($$$QueryCannotInstantiate,""SQLCODE = ""_SQLCODE) } Else { Set sc=$$$OK }")
		$$$GENERATE("	Quit sc")
	}
		// and for DYNAMIC mode.
	else {
			// preparse the query to construct the actual argument list
		set query = $zstrip(query,"<W")
		set tLines = 0 for tPtr = 1:1:$Length(query,$$$NL) { set tLine = $Piece(query,$$$NL,tPtr) if tLine '= "" { set tLines = tLines + 1, tLines(tLines) = tLine } }
		set sc=$$ExpandMacros^%SYS.DynamicQuery(%class,.tLines) QUIT:$$$ISERR(sc) sc
		set SQLCODE = $$dynamic^%qaqpreparser(.tLines,.tStatementPreparsed,.tStatementArgs)
		set tExecuteArgs = "" for tPtr=1:2:$ListLength(tStatementArgs) { set tArg = $Case($List(tStatementArgs,tPtr),"?":"$g(%parm("_$Increment(qcount)_"))","c":$$quoter^%qaqpreparser($List(tStatementArgs,tPtr+1)),"v":"$g("_$List(tStatementArgs,tPtr+1)_")",:"") Set tExecuteArgs = tExecuteArgs _ "," _ tArg }
			#; Initialize %qHandle...
		$$$GENERATE($Char(9)_"try {")
		$$$GENERATE($Char(9,9)_"set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())")
		set tSelectMode = $Case($$$ucase(%parameter("SELECTMODE")), "RUNTIME": "", "ODBC": 1, "DISPLAY": 2, "LOGICAL": 0, : "")
		$$$GENERATE($Char(9,9)_"if ($Isobject($Get(%qHandle(1)))) && (%qHandle(1).%IsA(""%SQL.Statement"")) { set tStatement = %qHandle(1) }")
		$$$GENERATE($Char(9,9)_"else {")
		$$$GENERATE($Char(9,9,9)_"set tStatement = ##class(%SQL.Statement).%New(" _ tSelectMode _ ",tSchemaPath)")
		$$$GENERATE($Char(9,9,9)_"do tStatement.prepare("_$zu(144,1,tStatementPreparsed) _ ")")
		$$$GENERATE($Char(9,9,9)_"set %qHandle(1) = tStatement")
		$$$GENERATE($Char(9,9)_"}")
		$$$GENERATE($Char(9,9)_"set %qHandle = tStatement.%Execute(" _ $Extract(tExecuteArgs,2,*) _ ")")
		$$$GENERATE($Char(9,9)_"If %qHandle.%SQLCODE < 0 { If $isobject($get(%sqlcontext)) { Set %sqlcontext.%SQLCODE = %qHandle.%SQLCODE,%sqlcontext.%Message=%qHandle.%Message set sc = $$$ERROR($$$SQLCode,%qHandle.%SQLCODE,%qHandle.%Message) } } else { set sc = $$$OK }")
		$$$GENERATE($Char(9)_"}")
		$$$GENERATE($Char(9)_"catch tException { If %qHandle.%SQLCODE < 0 { If $isobject($get(%sqlcontext)) { Set %sqlcontext.%SQLCODE = tException.AsSQLCODE(),%sqlcontext.%Message=tException.AsSQLMessage() set sc = $$$ERROR($$$SQLCode,%qHandle.%SQLCODE,%qHandle.%Message) } } }")
		$$$GENERATE($Char(9)_"Quit sc")
	}
	QUIT $$$OK
}

/// 	FetchRows returns the next FetchCount rows in the query
/// 	Updates handle for subsequent operations
/// 	Returns $list for row or  "" if no more rows
ClassMethod FetchRows(ByRef %qHandle As %Binary, FetchCount As %Integer = 0, ByRef RowSet As %List, ByRef ReturnCount As %Integer, ByRef AtEnd As %Integer) As %Status [ CodeMode = generator, GenerateAfter = Fetch, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
 s %code=0
 m %code=$$$tEXTcode(%property_"FetchRows")
 QUIT $$$OK
}

/// Fetch the next row of data from the query.
/// <p><var>qHandle</var> is query-defined data and is typically updated by <b>Fetch</b>.
/// <p>The <b>Fetch</b> method should set <var>Row</var> to be a $List of 
/// values corresponding to the columns of the query.  If we are past the end of the data
/// and no row is returned, <var>Row</var> should be set to null string ("").
/// If the non-empty row being returned is the last one, <var>AtEnd</var> could be
/// optionally set to 1, indicating that an additional call to <b>Fetch</b> may be avoided.
/// <p>
/// <var>Row</var> may also be subscripted. If any of the columns in the row are stream orefs
/// then the oref type information is lost in the <var>Row</var> $list encoded value. To retain
/// the oref type, place the oref into <var>Row(columnNumber)</var>. %Library.ResultSet recognizes
/// this form and will extract the column value as the subscripted value. 
ClassMethod Fetch(ByRef %qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = generator, PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set %code=0
		#; don't generate any code if it not for a query
	if %mode="method" QUIT $$$OK
		// Generate the code for IMMEDIATE mode.
	if $$$ucase(%parameter("COMPILEMODE")) '= "DYNAMIC" {
		set rowspec=%parameter("ROWSPEC")
		set cursor = $get($$$tCURSORID(%class,$$$cCLASSquery,%property)) if 'cursor { set cursor = $increment($$$tCURSOR(%class)), $$$tCURSORID(%class,$$$cCLASSquery,%property)=cursor } set cursor = "Q"_cursor
		if rowspec '= "" {
			do parseRowSpec^%occQueryCompiler(%class,%property,rowspec,.degree)
			if 'degree set fcode=1,fcode(1)=" Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=-400,%sqlcontext.%Message=""No columns selected"" QUIT $$$ERROR($$$QueryNothingSelected,"""_%property_""")" $$$GENERATE(fcode(1)) merge $$$tEXTcode(%property_"FetchRows")=fcode quit $$$OK
			#; generate fetch
			set into=":Row(0,1)",rowexpr="$lb(Row(0,1)"
			for i=2:1:degree set into=into_",:Row(0,"_i_")",rowexpr=rowexpr_",Row(0,"_i_")"
			set rowexpr = rowexpr _ ")"
		} else {
			Set into="$$$SQLQueryInto("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_")",rowexpr="$$$SQLQueryExpr("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_")"
		}
	 #; Generate the code for Fetch, FetchODBC, and FetchRows


		$$$GENERATE($Char(9)_"kill Row Set Row="""",AtEnd=0")
		$$$GENERATE($Char(9)_"&sql(FETCH "_cursor_" INTO "_into_")")
		$$$GENERATE($Char(9)_"If 'SQLCODE { Set sc=$$$OK,Row="_rowexpr_" }")
		$$$GENERATE($Char(9)_"ElseIf SQLCODE=100 { Set AtEnd=1,sc=$$$OK Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) }")
		$$$GENERATE($Char(9)_"Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set AtEnd=1,sc=$$$ERROR($$$SQLCode,SQLCODE,$get(%msg)) }")
		$$$GENERATE($Char(9)_"QUIT sc")
			#; Generate FetchRows
		set fcode=0
		set fcode=fcode+1,fcode(fcode)="	Set RowSet="""",ReturnCount=0,AtEnd=0"
		set fcode=fcode+1,fcode(fcode)="	For {"
		set fcode=fcode+1,fcode(fcode)="		Set sc=.."_$$$QN(%property_"Fetch")_"(.%qHandle,.Row,.AtEnd)"
		set fcode=fcode+1,fcode(fcode)="		If $$$ISOK(sc) { Set RowSet=RowSet_Row,ReturnCount=ReturnCount+1 Quit:(ReturnCount=FetchCount)||(($l(RowSet)+($l(RowSet)\ReturnCount))>24000)||(AtEnd) } Else { Set AtEnd=1 Quit }"
		set fcode=fcode+1,fcode(fcode)="	}"
		set fcode=fcode+1,fcode(fcode)="	Quit sc"
	}
	else {
		$$$GENERATE($Char(9)_"if %qHandle.%Next(.sc) { Set Row="""" For colPtr=1:1:%qHandle.%ResultColumnCount { Set Row=Row_$listbuild(%qHandle.%GetData(colPtr)) } } Else { Set Row="""",AtEnd=1 If $isobject($get(%sqlcontext)) { Set %sqlcontext.%SQLCODE = %qHandle.%SQLCODE, %sqlcontext.%Message = %qHandle.%Message i $$$ISOK(sc) { s %sqlcontext.%ROWCOUNT = %qHandle.%ROWCOUNT } else { s %sqlcontext.%Message=%qHandle.%Message } } }")
		$$$GENERATE($Char(9)_"QUIT sc")
		set fcode=0
		set fcode=fcode+1,fcode(fcode)="	Set RowSet="""",ReturnCount=0,AtEnd=0,columnCount=%qHandle.%ResultColumnCount,tStatus = $$$OK"
		set fcode=fcode+1,fcode(fcode)="	Do {"
		set fcode=fcode+1,fcode(fcode)="		Set next = %qHandle.%Next(.tStatus)"
		set fcode=fcode+1,fcode(fcode)="		If next { Set ReturnCount = ReturnCount+1 For colPtr=1:1:columnCount { Set RowSet=RowSet_$listbuild(%qHandle.%GetData(colPtr)) } } Else { Set AtEnd=1 If $isobject($g(%sqlcontext)) { Set %sqlcontext.%SQLCODE = %qHandle.%SQLCODE, %sqlcontext.%Message = %qHandle.%Message If $$$ISOK(tStatus) { Set %sqlcontext.RowCount=%qHandle.%ROWCOUNT } Else { Set %sqlcontext.%Message=%qHandle.%Message } } }"
		set fcode=fcode+1,fcode(fcode)="	} While (next) && (ReturnCount'=FetchCount) && (($length(RowSet)+($length(RowSet)\ReturnCount))'>24000)"
		set fcode=fcode+1,fcode(fcode)="	Quit tStatus"
	}
	merge $$$tEXTcode(%property_"FetchRows")=fcode
 QUIT $$$OK
}

/*
 GetInfo()
	Reimplementation of %Query.GetInfo for SQL queries. A different call to ^%SYS.DynamicQuery is used to allow for
	an information only compile of the query to construct query information.
*/
/// Returns information about the query. It is used by the various <b>ResultSet</b> objects.
ClassMethod GetInfo(ByRef colinfo As %List, ByRef parminfo As %List, ByRef idinfo As %List, ByRef %qHandle As %Binary, extoption As %Integer = 0, extinfo As %List) As %Status [ CodeMode = generator, ProcedureBlock = 1, ServerOnly = 1 ]
{
	If %mode="method" Quit $$$OK
	$$$GENERATE("	$$$SQLQuerySQLInfoItem("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_",1,""colinfo"")")
	$$$GENERATE("	$$$SQLQuerySQLInfoItem("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_",2,""parminfo"")")
	$$$GENERATE("	$$$SQLQuerySQLInfoItem("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_",3,""idinfo"")")
	$$$GENERATE("	If extoption {")
	$$$GENERATE("		$$$SQLQuerySQLInfoItem("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_",4,""extinfo"")")
	$$$GENERATE("	}")
	$$$GENERATE("	Quit $$$OK")
	Quit $$$OK
}

/// Fetch and send a series of rows for the ODBC/JDBC server. For internal use only.
ClassMethod SendODBC(ByRef %qHandle As %Binary, ByRef array As %String, qacn As %Integer, ByRef %qrc As %Integer, ByRef piece As %Boolean, ColumnCount As %Integer) [ CodeMode = generator, GenerateAfter = (FetchODBC, Fetch), PlaceAfter = Execute, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set %code=0
	If %mode="method" QUIT $$$OK
		// Generate the code for IMMEDIATE mode.
	if $$$ucase(%parameter("COMPILEMODE")) '= "DYNAMIC" {
		If $$$comSubMemberDefined(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,"FetchODBC")&&($$$comSubMemberKeyGet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,"FetchODBC",$$$cXXXXorigin)'="%Library.Query")||($$$comMemberDefined(%class,$$$cCLASSmethod,$$$nameMemberMethodName(%property,"FetchODBC"))) {
			$$$GENERATE("SPInnerLoop	Set rc=.."_$$$QN(%property_"FetchODBC")_"(.%qHandle,.array,qacn,,.%qrc)")
			$$$GENERATE("	If $$$ISERR(rc) { Do ProcessError^%ourProcedure(rc,$get(%sqlcontext),.%qrc,.%msg) Do Logerr^%SYS.SQLSRV(%qrc,"""",""SP"",.%msg) }")
			$$$GENERATE("	If %qrc Set piece=0 Quit")
			$$$GENERATE("	If $get(%protocol)>46 { For piece=1:1:ColumnCount { Goto:$zobjexport(array(qacn,piece),50) SPDone } }")
			$$$GENERATE("	Else { For piece=1:1:ColumnCount { Goto:$zobjexport(array(qacn,piece),7) SPDone } }")
			$$$GENERATE("	Goto SPInnerLoop")
			$$$GENERATE("SPDone	Set:$g(%protocol)>46 piece=piece+1 Quit")
		} 
		ElseIf ($$$comMemberDefined(%class,$$$cCLASSmethod,$$$nameMemberMethodName(%property,"Fetch"))||$$$comSubMemberDefined(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,"Fetch")) {
			
				// If the Fetch method originates in %Library.SQLQuery, we can optimize some things...
			if ($$$comSubMemberKeyGet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,"Fetch",$$$cXXXXorigin)="%Library.SQLQuery") {
				set cursor = $get($$$tCURSORID(%class,$$$cCLASSquery,%property)) if 'cursor { set cursor = $increment($$$tCURSOR(%class)), $$$tCURSORID(%class,$$$cCLASSquery,%property)=cursor } set cursor = "Q"_cursor
				set rowspec=%parameter("ROWSPEC")
				if rowspec '= "" {
					do parseRowSpec^%occQueryCompiler(%class,%property,rowspec,.degree)
					set into=":d1"
					for i=2:1:degree set into=into_",:d"_i
					set varlist=$tr(into,":")
				}
				else {
					set into="$$$SQLQueryIntoSendODBC("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_",1)"
					set varlist="$$$SQLQueryIntoSendODBC("_$$$QuoteName(%class)_","_$$$QuoteName(%property)_",0)"
				}
				$$$GENERATE($c(9)_"set %qrc=0,piece=0")
				// Not needed as method is procedureblock $$$GENERATE($c(9)_"new "_varlist)
				$$$GENERATE($c(9)_"for {")
				$$$GENERATE($c(9,9)_"&sql(fetch "_cursor_" into "_into_" )")
				$$$GENERATE($c(9,9)_"if SQLCODE<0 { set %qrc=SQLCODE set:$isobject($g(%sqlcontext)) %sqlcontext.SQLCode=SQLCODE,%sqlcontext.Message=$g(%msg) do Logerr^%SYS.SQLSRV(%qrc,"""",""SP"",.%msg) RETURN  }")		// error
				$$$GENERATE($c(9,9)_"if SQLCODE { set %qrc=100 set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=100 RETURN  }")												// no [mode] data
				$$$GENERATE($c(9,9)_"if $g(%protocol)>50 { RETURN:$zobjexport($lb("_varlist_"),60) }")																// successful fetch
				$$$GENERATE($c(9,9)_"else {")
				$$$GENERATE($c(9,9,9)_"if %protocol>46 { for piece=1:1:ColumnCount { goto:$zobjexport(@(""d""_piece),50) SPDone } }")
				$$$GENERATE($c(9,9,9)_"else { for piece=1:1:ColumnCount { goto:$zobjexport(@(""d""_piece),7) SPDone } }")
				$$$GENERATE($c(9,9)_"}")
				$$$GENERATE($c(9)_"}")		// for loop
				$$$GENERATE($c(9)_"QUIT")
				$$$GENERATE("SPDone"_$c(9)_"set:%protocol>46 piece=piece+1")
				$$$GENERATE($c(9)_"kill array(qacn)")
				$$$GENERATE($c(9)_"for i=piece:1:ColumnCount { set array(qacn,i)=@(""d""_i) }")
				$$$GENERATE($c(9)_"QUIT")
			}
			elseif ($$$comSubMemberKeyGet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,"Fetch",$$$cXXXXorigin)="%Library.ExtentSQLQuery") {
				$$$GENERATE($c(9)_"set %qrc=0,piece=0")
				$$$GENERATE($c(9)_"for {")
				$$$GENERATE($c(9,9)_"set rc=.."_$$$QN(%property_"Fetch")_"(.%qHandle,.row,.atend)")
				$$$GENERATE($c(9,9)_"if $$$ISERR(rc) { set %qrc=-400 set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=-400,%sqlcontext.Message=$g(%msg) do ProcessError^%ourProcedure(rc,$get(%sqlcontext),.%qrc,.%msg),Logerr^%SYS.SQLSRV(%qrc,"""",""SP"",.%msg) RETURN  }")
				$$$GENERATE($c(9,9)_"if row="""" { set %qrc=100 set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=100 RETURN  }")
				$$$GENERATE($c(9,9)_"if $g(%protocol)>50 { RETURN:$zobjexport(row,60) }")
				$$$GENERATE($c(9,9)_"else {")
				$$$GENERATE($c(9,9,9)_"if %protocol>46 { for piece=1:1:ColumnCount { goto:$zobjexport($lg(row,piece),50) SPDone } }")
				$$$GENERATE($c(9,9,9)_"else { for piece=1:1:ColumnCount { goto:$zobjexport($lg(row,piece),7) SPDone } }")
				$$$GENERATE($c(9,9)_"}")
				$$$GENERATE($c(9)_"}")
				$$$GENERATE($c(9)_"QUIT")
				$$$GENERATE("SPDone"_$c(9)_"set:%protocol>46 piece=piece+1")
				$$$GENERATE($c(9)_"kill array(qacn)")
				$$$GENERATE($c(9)_"for i=piece:1:ColumnCount { set array(qacn,i)=$lg(row,i) }")
				$$$GENERATE($c(9)_"QUIT")
			}
			else {	// Fetch not originating in %Library.SQLQuery or %Library.ExtentSQLQuery, use old logic that does not include $zobjexport(...,60)
				$$$GENERATE($c(9)_"Kill array(qacn) Set %qrc=0")
				$$$GENERATE("SPInnerLoop"_$c(9)_"Set rc=.."_$$$QN(%property_"Fetch")_"(.%qHandle,.row,.atend)")
				$$$GENERATE($c(9)_"If $$$ISERR(rc) { Set %qrc=-400 Set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=-400,%sqlcontext.Message=$g(%msg) Do ProcessError^%ourProcedure(rc,$get(%sqlcontext),.%qrc,.%msg) Do Logerr^%SYS.SQLSRV(%qrc,"""",""SP"",.%msg) Set piece=0 Quit }")
				$$$GENERATE($c(9)_"If row="""" Set %qrc=100,piece=0 Set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=100 Quit $$$OK")
				$$$GENERATE($c(9)_"If $get(%protocol)>46 { For piece=1:1:ColumnCount { Goto:$zobjexport($listget(row,piece),50) SPDone } }")
				$$$GENERATE($c(9)_"Else { For piece=1:1:ColumnCount { Goto:$zobjexport($listget(row,piece),7) SPDone } }")
				$$$GENERATE($c(9)_"Goto SPInnerLoop")
					#; As caller expects items to be in a local array fix up remaining entries
				$$$GENERATE("SPDone"_$c(9)_"Set:$g(%protocol)>46 piece=piece+1 For i=piece:1:ColumnCount { Set array(qacn,i)=$listget(row,i) }")
				$$$GENERATE($c(9)_"Quit")
			}
		}
	}
	else { $$$GENERATE($Char(9)_"kill array(qacn) set piece = 0, %qrc = %qHandle.%SendODBC()") }
	Quit $$$OK
}

}
