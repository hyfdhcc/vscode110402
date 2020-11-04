Include (%occDS, %msql)

///  This is an internal class used for distributed SQL processing.
///  This class contains no user-accessible methods.
Class %SQL.Agent [ Abstract, System = 4 ]
{

/// Given a global and optional start/end range and a function to call create the work manager IPQ object and schedule the work for this
/// return the IPQ object. On the event of any errors use standard SQL error handling (ZTrap).
ClassMethod %RunWork(global As %String, start As %String, end As %String, rtnidx As %Binary, function As %String, args As %String, prefix As %Boolean = 0) As %SYSTEM.WorkMgrIPQ [ Internal ]
{
	Set gblend=$order(@global@(""),-1),ostart=start
	If prefix Set end=""
	If gblend="" {
		#; No data at all, nothing to do
		Quit $$$NULLOREF
	}
	Set numberjobs=$$calcJobs^%SYS.WorkQueueMgr(),splits=numberjobs
	Set split=$$SplitSize^%GSIZE(global,"N",splits,start,end,prefix)
	Set status=$listget(split,1),split=$listget(split,2)
	If status=1,$listlength(split)+1<numberjobs Set numberjobs=$listlength(split)+1
	Set group=##class(%SYSTEM.WorkMgrIPQ).SQLInitialize(numberjobs)
	#; To make sure we do not skip any items in the first range if condition is >=start we need to back up a node
	If start'="" {
		Set start=$order(@global@(start),-1)
	}
	Set oldsubnode=start
	If status=1 {
		#; SplitSize worked
		Set ptr=0
		While $listnext(split,ptr,subnode) {
			Set sc=group.QueueLocalEntry(rtnidx,function,oldsubnode,subnode,args) If $$$ISERR(sc) Goto error
			Set oldsubnode=subnode
		}
	} Else {
		#; Split Size failed to split so see what we can do
		#; Does this look like an integer range, if so divide it up
		Set first=$order(@global@(start)),last=$select(end="":gblend,1:$order(@global@(end),-1))
		If first?.N,last?.N,start?.N,end?.N,'prefix {
			Set last=$select(end="":gblend,1:end)
			#; Double number of splits because this is probably less accurate than SplitSize
			Set jump=last-first/splits/2
			If jump<1 Set jump=1
			For subnode=first+jump:jump:last-jump {
				Set sc=group.QueueLocalEntry(rtnidx,function,oldsubnode,subnode\1,args) If $$$ISERR(sc) Goto error
				Set oldsubnode=subnode\1
			}
		} Else {
			Set modulo=1
			Set node=start
			#; Set naked
			If $data(@global@(gblend))
			For i=0:1 {
				Set node=$order(^(node)) Quit:node=""
				If prefix {
					If $extract(node,1,$length(ostart))'=ostart Set end=node Quit
				} ElseIf end'="" {
					If node]end||(node=end) Quit
				}
				If i#modulo=0 {
					Set split(i)=node
					If i/modulo=splits {
						Set modulo=modulo*2
						If modulo>65535 {
							Do callqueue
							Kill split
							#; Set naked
							If $data(@global@(node))
						}
					}
				}
			}
			Do callqueue
		}
	}
	#; Queue the last range and then free workers
	Set sc=group.QueueLocalEntry(rtnidx,function,oldsubnode,$select(end="":gblend,1:end),args) If $$$ISERR(sc) Goto error
	Set sc=group.Free() If $$$ISERR(sc) Goto error
	Quit group
error	Set SQLCODE=$$StatusToSQLCODE^%apiOBJ(sc,.msg)
	Do SQERror^%apiSQL(242,"Parallel query run-time error: -"_SQLCODE_" "_msg)
	QUIT
callqueue	For j=modulo:modulo:i {
		If '$data(split(j),subnode) Continue
		Set sc=group.QueueLocalEntry(rtnidx,function,oldsubnode,subnode,args) If $$$ISERR(sc) Goto error
		Set oldsubnode=subnode
	}
}

/// Given an array of vals and a function to call create the work manager IPQ object and schedule the work for this
/// return the IPQ object. On the event of any errors use standard SQL error handling (ZTrap).
ClassMethod %RunWorkVals(ByRef vals As %String, rtnidx As %Binary, function As %String, args As %String) As %SYSTEM.WorkMgrIPQ [ Internal ]
{
	Set val=""
	For count=0:1:1 {
		Set val=$order(vals(val)) Quit:val=""
	}
	Set group=##class(%SYSTEM.WorkMgrIPQ).SQLInitialize(count)
	Set val = ""
	For  {
		Set val = $O(vals(val)) QUIT:val=""
		Set sc=group.QueueLocalEntry(rtnidx,function,val,args) If $$$ISERR(sc) Goto error
	}
	Set sc=group.Free()
	If $$$ISERR(sc) Goto error
	Quit group
error	Set SQLCODE=$$StatusToSQLCODE^%apiOBJ(sc,.msg)
	Do SQERror^%apiSQL(242,"Parallel query run-time error: -"_SQLCODE_" "_msg)
}

///  Given an SQL query, <var>pSQL</var>, and a index number within a temp global
///  <var>pTempIndex</var>, post the query for background processing with the results going
///  to the temp global.<br/>
///  This method is called by the foreground coordinator when it wants to have an SQL
///  statement processed in the background.
///  pTempIndex is passed by reference.  We allocate the temp file index and report it back to the caller
ClassMethod %QueueQuery(pSQL As %String, ByRef pTempIndex As %String, pSelectMode As %Integer, pArgs As %List = "") As %Status [ Internal ]
{
	#def1arg pipe ^CacheTempSql

	Set tSC = $$$OK
	Try {
		// set up deepsee task master
		If '##class(%DeepSee.TaskMaster).%IsActive() {
			Set tSC = ##class(%DeepSee.TaskMaster).%CreateAgents()
			If $$$ISERR(tSC) do ..ProcessError(tSC,.SQLCODE,.%msg) Quit
		}

		// Allocate TempIndex
		set pTempIndex = $i($$$pipe)
		set $$$pipe(pTempIndex,-1)=$lb("Queued by PID: "_$j,pSelectMode,$zu(188),"Temp File for %SQL.Agent.%QueueQuery task",pSQL)
		
		// Store pArgs in -2 node of the temp file for retrieval later in %ExecuteQuery
		set:pArgs'="" $$$pipe(pTempIndex,-2)=pArgs
		
		// queue the request
		Set tSC = ##class(%DeepSee.TaskMaster).%QueueTask("H","","","EXECSQL",pSQL,pTempIndex,pSelectMode, $zu(115,2) /*read committed?*/)
		If $$$ISERR(tSC) do ..ProcessError(tSC,.SQLCODE,.%msg) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		do ..ProcessError(tSC,.SQLCODE,.%msg)
	}
	Quit tSC
}

ClassMethod %EndQuery(pTempIndex As %String) As %Status [ Internal ]
{
	#def1arg pipe ^CacheTempSql
	#dim tSC As %Status

	Set tSC = $$$OK
	Try {
		// Make sure temp file is complete, when done, kill it
		quit:'$d($$$pipe(pTempIndex,-1))	// temp file never allocated/started!  why???
		set tLastRowData=""
		for {
			set tLastRow=$o($$$pipe(pTempIndex,0,""),-1,tLastRowData)
			if $a(tLastRowData)=1 { kill $$$pipe(pTempIndex) quit  }
			hang .1
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  Process the Status code error into an SQLCODE and %msg error.  %msg is a public variable.
ClassMethod ProcessError(pSC As %Status, ByRef SQLCODE As %Integer, ByRef %msg As %String) [ Internal ]
{
	#dim ex As %Exception.SystemException
	#dim i,ecode As %Integer
	#dim errlist As %String

	Try {
		set errlist=""
		set SQLCODE=-400
		do DecomposeStatus^%apiOBJ(pSC,.errlist)
		set ecode=$$$GETERRORCODE(pSC) if ecode=921||(ecode=922)||(ecode=923) set SQLCODE=-99
		for i=1:1:errlist set %msg=errlist(i)_$s(i>1:"  ",1:"")
	}
	Catch(ex) {
		set SQLCODE=-400, %msg="Error in %SQL.Agent.ProcessError():: "_$ze_"  Attempting to process status code "_$g(pSC)
	}
	Quit
}

///  This method executes the given query and writes the results to the specified temp global
///  location.<br/>
///  This is called by a background agent.
ClassMethod %ExecuteQuery(pSQL As %String, pTempIndex As %String, pSelectMode As %Integer = 0, pReadCommitted As %Integer = 0) As %Status [ Internal ]
{
	#dim tStatment As %SQL.Statement
	#dim tRSET As %SQL.StatementResult
	#dim tSC As %Library.Status
	
		// Name of the global to pipe the output to
	#def1arg pipe ^CacheTempSql
	
	Set tSC = $$$OK
	Try {
		// execute the query
		// For this implementation we are going to simply use %SQL.Statement.ExecDirect() to execute the pSQL statement.
		
		#; set zh=$zh
		set tCnt=0
		set $li($$$pipe(pTempIndex,-1),2)="Executed by PID: "_$j_"  SELECTMODE: "_pSelectMode
		if $d($$$pipe(pTempIndex,-2),tArgList) { set pArgs=$ll(tArgList) for i=1:1:$ll(tArgList) { set:$ld(tArgList,i) pArgs(i)=$li(tArgList,i) } }

		set tStatement = ##class(%SQL.Statement).%New(pSelectMode)
		do $zu(115,2,pReadCommitted)
		set tStatement.%msqlvar="""%sqldata"""
		set tSC = tStatement.%Prepare(.pSQL)
		if $$$ISERR(tSC) {
			new %msg
			do DecomposeStatus^%apiOBJ(tSC,.err,"-d")
			if $g(err(1,"code"))="5540"||($g(err(1,"code"))="5521") { 
				set SQLCODE=$g(err(1,"param",1)),%msg=$g(err(1,"param",2))
			}
			set:$g(SQLCODE)="" SQLCODE=-400
			set:$g(%msg)="" %msg=$g(err(1))
			set tCnt=tCnt+1
			set $$$pipe(pTempIndex,0,tCnt)=$lb(,SQLCODE,%msg)
			quit
		}

		set tRSET = tStatement.%Execute(pArgs...)
		set tNumColumns=tRSET.%ResultColumnCount
		if tRSET.%SQLCODE<0 {	// Error
			set tCnt=tCnt+1
			set $$$pipe(pTempIndex,0,tCnt)=$lb(,tRSET.%SQLCODE,tRSET.%Message)
			quit
		}

		// write results to temp global

		// Results should be be a $List of the fields in the SELECT list in the
		// order they appear in the SELECT list.
		// We should $Increment the temp global to get the subscript used to write out the $List
		// When we are done, or if there is an error set it into the second piece of the $List in the last row
		// If there is an error, we put the error message in the third column of the last row of the temp file data
		// When done with the query we put the following values in $$$pipe(pTempIndex,0,Counter) = $lb(,status,message)
		//   -  status = 100 - no [more] data
		//   -  status = -##, SQLCODE error value if error, piece 2 will have an error message

		if tRSET.%FetchIntoTemp(pTempIndex,.tCnt,.tSC) {}
		if tRSET.%SQLCODE=100 {	// No rows returned or some rows returned, but no error and we are done
			set tCnt=tCnt+1
			set $$$pipe(pTempIndex,0,tCnt)=$lb(,100)
		}
		elseif tRSET.%SQLCODE<0 {	// Error
			set tCnt=tCnt+1
			set $$$pipe(pTempIndex,0,tCnt)=$lb(,tRSET.%SQLCODE,tRSET.%Message)
		}
			// destuct the oref here to force a cursor close (%OnClose) here.
			// If we wait for the procedure to exit, it is too late as we have no chance to clean up the %sqldata## variables.
			// This is a special case ONLY for %parallel code.  The statement uses %sqldata## public variables instead of arrays for performance,
			// but the %sqldata## variables are not cleaned up by cursor close.  We clean them up here.
		set tRSET=""
		new %tVar
		set %tVar="%sqldata"
		for  { set %tVar=$o(@(%tVar)) quit:$e(%tVar,1,8)'="%sqldata"  kill @%tVar }
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Set tCnt=tCnt+1
		set $$$pipe(pTempIndex,0,tCnt)=$lb(,400,ex.DisplayString())
	}
	#; set $$$pipe(pTempIndex,-3)=($zh-zh)
	Quit tSC
}

///  !!! TEST METHOD -- REMOVE
ClassMethod Test(pSQL As %String, pTempIndex As %String, pTasks As %Integer = 1) As %Status [ Internal ]
{
	For n = 1:1:pTasks {
		Do ..%QueueQuery(pSQL,pTempIndex)
	}
	Quit $$$OK
}

}
