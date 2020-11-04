/// <p>This class can be used to gather statistical information on SQL queries run on a give Cach&eacute; system.
/// 
/// <p>You can invoke different levels of the Stats gathering with the following command:
/// 
/// <p>DO $SYSTEM.SQL.SetSQLStats(flag) 
/// 
/// <p>Where flag can be: 
/// 
/// <ul>
/// <li>0 = Turn off Stats code generation</li> 
/// <li>1 = Turn on Stats code generation but do NOT gather stats</li> 
/// <li>2 = Turn on Stats code generation to gather stats at the Open and Close of a query</li>
/// <li>3 = Turn on Stats code generation to gather stats at each Module level of a query </li>
/// </ul>
/// 
/// <p>The Stats gathered are: 
/// 
/// <ul>
/// <li>Number of Global References</li> 
/// <li>Number of Commands Executed</li>
/// <li>Number of Times a Module is called</li> 
/// <li>Total Time in a Module</li> 
/// <li>Number of Rows returned by the query</li>
/// </ul> 
/// 
/// 
/// <p>It is also possible to invoke Stats gathering for just the current process.  That command is:
/// 
/// <p>DO $SYSTEM.SQL.SetSQLStatsJob(flag)
/// 
/// <p>The modules can be nested in one another. The outer module will display inclusive numbers, so the Module MAIN will be the overall results for the full query. 
/// 
/// <p>Upon first enabling SQLStats you should Purge Cached Queries in order to force code regeneration. When you stop gathering Stats using the following command: 
/// 
/// <p>DO $SYSTEM.SQL.SetSQLStats(0) 
/// 
/// <p>You do not need to Purge Cached Queries. The small number of additional lines of code should not affect performance.
/// 
/// <p>All of the data is stored in <class>%SYS.PTools.SQLQuery</class> and <class>%SYS.PTools.SQLStats</class>. <class>SQLQuery</class> holds the text of the SQL Statement, the routine name, and the module info. <class>SQLStats</class> holds the stats for each run. 
/// <p>You can query the tables from any directory on the system or use xDBC. 
///  
/// <p>A view, %SYS_PTools.SQLStatsView, has been defined to make looking at the data easier.
/// 
/// <p>For Example:
/// 
/// <example>
/// #include %msql
/// &SQL(DECLARE cur1 CURSOR FOR
/// SELECT RoutineName, ModuleName, ModuleCount, GlobalRefs, DiskWait
///        LinesOfCode, TotalTime, RowCount, QueryType, QueryText 
/// FROM %SYS_PTools.SQLStatsView 
/// WHERE Namespace= 'SAMPLES')
/// 
/// &SQL(OPEN cur1)
/// For  &SQL(FETCH cur1 INTO :A,:B,:C,:D,:E,:F,:G,:H,:I) QUIT:SQLCODE'=0  WRITE !,A,"  ",B,"  ",C,"  ",D,"  ",E,"  ",F,"  ",G,"  ",H,"  ",I
/// &SQL(CLOSE cur1)
/// </example>
/// 
/// <p> or for a more condensed output:
/// 
/// <example>
/// #include %msql
/// &SQL(DECLARE cur2 CURSOR FOR
/// SELECT  V.RoutineName, V.QueryText,
///         (SELECT COUNT(*) 
/// 		 FROM %SYS_PTools.SQLStatsView Sub
/// 		 WHERE Sub.ModuleName = 'Main' AND Sub.RoutineName = V.RoutineName 
/// 		 GROUP BY Sub.CursorName, Sub.ModuleName) as RunCount, 
///         {fn round(avg(V.RowCount),2)} as AvgRows,  
///         {fn round(avg(V.GlobalRefs),2)} as AvgGlorefs,    
///         {fn round(avg(V.LinesOfCode),2)} as AvgLines, 
///         {fn round(avg(V.DiskWait),2)} as AvgDiskWait,  
///        {fn round(avg(V.TotalTime),5)} as AvgTime 
/// FROM %SYS_PTools.SQLStatsView V
/// GROUP BY V.RoutineName, V.CursorName)
/// 
/// &SQL(OPEN cur2)
/// For  &SQL(FETCH cur2 INTO :A,:B,:C,:D,:E,:F,:G) QUIT:SQLCODE'=0  WRITE !,A,"  ",B,"  ",C,"  ",D,"  ",E,"  ",F,"  ",G
/// &SQL(CLOSE cur2)
/// </example>
/// 
/// 
/// <p>Error information is stored in <b>^%sqlcq(NAMESPACE,"PTools","Error",$J)</b>.
/// 
Class %SYS.PTools.SQLStats Extends (%Persistent, %SYS.PTools.Stats) [ Inheritance = right, System = 4 ]
{

/// This method is called once from the cursor open code, initializes local variables, and called Start() for the MAIN loop.
ClassMethod Init(NS As %String, Rou As %String, Cur As %String, ByRef Parms As %ArrayOfDataTypes)
{
	s status=$zu(115,12,-1)
	d Init^%SYS.PTools(NS, Rou, Cur, .Parms)
	s status=$zu(115,12,status)
	QUIT
}

/// This method is called every time you enter a module.
ClassMethod Start(NS As %String, Rou As %String, Cur As %String, ModString As %String)
{
	s:Cur="" Cur="A" 
	f piece=1:1:$L(ModString,",")
	{
		s Mod=$P(ModString,",",piece)
		if $g(%FirstRow)=1 {
			s %SQLStats(NS,Rou,Cur,Mod,"Stime")=$ZH,%SQLStats(NS,Rou,Cur,Mod,"Sline")=$ZU(67,8,$j)+$system.Context.WorkMgr().LinesExecuted,%SQLStats(NS,Rou,Cur,Mod,"Sglo")=$ZU(67,9,$j)
			s %SQLStats(NS,Rou,Cur,Mod,"Sdwait")=$SYSTEM.Process.DiskReadMilliseconds()
		}
		ELSEIF $G(%SQLStats(NS,Rou,Cur,Mod,"Stime"))'="" {
			s %SQLStats(NS,Rou,Cur,Mod,"Stime")=$ZH,%SQLStats(NS,Rou,Cur,Mod,"Sline")=$ZU(67,8,$j)+$system.Context.WorkMgr().LinesExecuted,%SQLStats(NS,Rou,Cur,Mod,"Sglo")=$ZU(67,9,$j)
			s %SQLStats(NS,Rou,Cur,Mod,"Sdwait")=$SYSTEM.Process.DiskReadMilliseconds($j)
		}
	}
}

/// This is the number of times the query has been run since the last compile.
/// 
Property Counter As %Integer [ SqlColumnNumber = 5 ];

/// This method is called every time you exit a module.
ClassMethod Stop(NS As %String, Rou As %String, Cur As %String, ModString As %String)
{
	s:Cur="" Cur="A" f piece=1:1:$L(ModString,",")
	{
		s Mod=$P(ModString,",",piece)
		 
		i $g(%SQLStats(NS,Rou,Cur,Mod,"Stime"))'=""
		{
			s:ModString=+ModString %SQLStats(NS,Rou,Cur,Mod,"counter")=$i(%SQLStats(NS,Rou,Cur,Mod,"counter"))

 			s:$g(%SQLStats(NS,Rou,Cur,Mod,"Sglo"))'="" %SQLStats(NS,Rou,Cur,Mod,"Tglo")=$g(%SQLStats(NS,Rou,Cur,Mod,"Tglo"))+($ZU(67,9,$j)+$system.Context.WorkMgr().GlobalReferences-%SQLStats(NS,Rou,Cur,Mod,"Sglo"))
 			s:$g(%SQLStats(NS,Rou,Cur,Mod,"Sline"))'="" %SQLStats(NS,Rou,Cur,Mod,"Tline")=$g(%SQLStats(NS,Rou,Cur,Mod,"Tline"))+($ZU(67,8,$j)+$system.Context.WorkMgr().LinesExecuted-%SQLStats(NS,Rou,Cur,Mod,"Sline"))
 			s %SQLStats(NS,Rou,Cur,Mod,"Ttime")=$g(%SQLStats(NS,Rou,Cur,Mod,"Ttime"))+($ZH-%SQLStats(NS,Rou,Cur,Mod,"Stime"))
 			s %SQLStats(NS,Rou,Cur,Mod,"Tdwait")=$g(%SQLStats(NS,Rou,Cur,Mod,"Tdwait"))+($SYSTEM.Process.DiskReadMilliseconds($j)-$g(SQLStats(NS,Rou,Cur,Mod,"Sdwait")))
 			
		
			i Mod=1,$g(%FirstRow)=1 {
				k %FirstRow
				s %SQLStats(NS,Rou,Cur,"FirstRow")=$ZH-%SQLStats(NS,Rou,Cur,Mod,"Stime")
			}
		}
	}
}

/// This method is called from the cursor close code.  It is called once for each query run.
/// It calls the <b>GlobalSave</b> method that adds data to the <class>%SYS_PTools.SQLStats</class> table.
ClassMethod Report(NS As %String, Rou As %String, Cur As %String, RowCount As %Integer = 0)
{
	
	s:Cur="" Cur="A"
	d ..Stop(NS,Rou,Cur,1)
	s mod=""
	f  {
		s mod=$O(%SQLStats(NS,Rou,Cur,mod))
		Q:mod'=+mod
		
		d ..GlobalSave(NS,Rou,Cur,mod,RowCount)
		;d ..LogSave(NS,Rou,Cur,mod,Counter,LogFile)
	}   
	;d ..SaveFirstRow(NS, Rou,Cur,Counter)
	d $SYSTEM.Process.DisableDiskReadTiming()
	k %SQLStats(NS,Rou,Cur)
	k %SQLStats("StartTime",NS,Rou,Cur)
}

/// This is the method that stores all of the runtime data in the <class>%SYS_PTools.SQLStats</class> table
ClassMethod GlobalSave(ns, rou, cur, mod, rows)
{
	// wait to stop SQLStats for the Process until we are in %SYS.PTools
	d GlobalSave^%SYS.PTools(ns, rou, cur, mod, rows)
	QUIT
}

/// This method returns the Stats for a given module of a given SQL statement
/// It is called from the Show Plan code when Stats are to be included
ClassMethod GetStats(ByRef sql As %String, Mod As %Integer, showstats As %Integer = 0) As %String
{
	If Mod="MAIN" {
		s %SQLStats("GetStats")=""
		;if showstats=3 then we are are generating stats for an alternate Show Plan.
		;if showstats=2 then we are coming from view stats, lookup the stats and return the averages.
		;if showstats=1 then we are coming from Query Test or ShowPlan^%apiSQL and we need to execute a query and get stats from that.
		;   clean up stats when you are done.

		;Look to see if we already have stats for this SQL Statement
		if showstats = 2 {
			s RoutineName=$P($g(^mqh($UserName,"id")),"||",1)
			s CursorName=$P($g(^mqh($UserName,"id")),"||",2)
			s %SQLStats("GetStats")=$LB(RoutineName,CursorName)
		}
		If (showstats=1)!(showstats=3)!(%SQLStats("GetStats")="") {
			s schema=$zu(28,$s($zu(28,$p($g(^%SYS("sql","sys","default schema",$zu(5)),$g(^%SYS("sql","sys","default schema"))),"/"),5)'="_CURRENT_USER":$g(^%SYS("sql","sys","default schema",$zu(5)),$g(^%SYS("sql","sys","default schema"))),1:$s($Username'="":$Username,1:$s($p($g(^%SYS("sql","sys","default schema",$zu(5)),$g(^%SYS("sql","sys","default schema"))),"/",2)="":"SQLUser",1:$p($g(^%SYS("sql","sys","default schema",$zu(5)),$g(^%SYS("sql","sys","default schema"))),"/",2)))),5)
			s hash=$$Hash^%SYS.SQLSRV($lb(schema,"SQLStats"),.sql,"")
			&SQL(SELECT ImportSchema into :schema FROM %SYS_PTools.SQLQuery WHERE Hash =:hash)
			s status=$zu(115,12,3)
			s rtn="CacheSqlStats"_$j
			s %SQLStats("GetStats")=$LB(rtn,"SQLStats0")
			k ^rMAC(rtn),^rINDEX(rtn)
			s %qsize=0
			s:$e($TR(sql(1)," ",""),1,7)="DECLARE" sql(1)=$P(sql(1),"CURSOR FOR",2)
			d ..mac(rtn_" ; Caché SQL Cached Query   Time: "_$zdt($h,3),rtn)
			d:$g(schema)'="" ..mac("#import "_schema,rtn)
			d ..mac("#EXECUTE s %msqlvar=""%SQLStats""",rtn)
			d ..mac(" &sql(DECLARE SQLStats CURSOR FOR",rtn)
			f %qi=1:1:sql-1 d ..mac("      "_sql(%qi),rtn)
			d ..mac("      "_sql(sql)_")",rtn)
			d ..mac(" &sql(OPEN SQLStats) ",rtn)
			d ..mac(" f  &sql(FETCH SQLStats) Q:SQLCODE'=0",rtn)
			d ..mac(" &sql(CLOSE SQLStats) ",rtn)
			d ..mac(" QUIT",rtn)

			s ^rMAC(rtn,0)=$h,^rMAC(rtn,0,0)=%qln,^rMAC(rtn,0,"GENERATED")=1,^rMAC(rtn,0,"SIZE")=%qsize,^rINDEX(rtn,"MAC")=$LB($zdt(^rMAC(rtn,0),3),%qsize,1)
			s:$g(comperr)="" comperr="comerr"
			s (@comperr@(0),error,checksyn)=0
			s $ze="" 
			zb:showstats=3 +1^%qaqpag:"N"::"do ##class(%SYS.PTools.SQLUtilities).ChangeCost(PPcost,num,level,.mt,.mts,.%malg)"
			d ^%qarmac(rtn,"","","",checksyn,comperr,"","","","","%qsc(%qacn","",.omscost,1,,"xDBC",,$$$CQSaveMAC)	// DPV2905
			zb:showstats=3 --+1^%qaqpag
				#;  The format of @comperr@(1) is something like:
				#;    "CacheSql1.MAC(7) : SQL30: Table `NOTABLE' not found"
				#;  Note, if comperr, %msg will get set in sqlerr to appropriate message
				#;  that is why I set it to NULL here. 
			if @comperr@(0) {  ; set proper error message
				i @comperr@(0)=$g(@comperr@("sql")) s error=(+$p(@comperr@(1),": SQLCODE=",2))_$c(1)_$p(@comperr@(1),":",3,999),%msg="" s:$ze["<SYNTAX>errdone" $ze="" QUIT  ; just SQL Errors so give 1st one
				s error=400_$c(1)_"There are ("_(@comperr@(0)\2)_") syntax errors in ("_rtn_")"
			}
				#;   The variable 'err' will be set by the error trap
				#;   in err^%qaqqt to $ze if a fatal error occurs in
				#;   the SQL compiler.  errdone^%qaqqt will overwrite
				#;   the $ze value when it does X "*".  So, we set
				#;   $ze back to err, if it exists, for better error
				#;   reporting to the client.
			else {
				  i $g(err)'="" s error=400,$ze=err
			}
	    	s:$p(error,$c(1),2)="" error=error_$c(1)_$$sqlcode^%apiSQL(error)
	
			QUIT:$p(error,$c(1),1)'=0 $LB("Failed to Generate Stats - "_$p(error,$c(1),2))
			d @("^"_rtn)
			s status=$zu(115,12,status)
		}
	}
	s status=$zu(115,12,-1)
	s data=""
	s namespace=$zu(5)
	s rtn=$lg(%SQLStats("GetStats"),1)
	s cur=$lg(%SQLStats("GetStats"),2)
	s Mod=$s(Mod="MAIN":"MAIN",Mod="SUBQUERY":"SUBQUERY",Mod>26:Mod,1:$c(64+Mod))
	&SQL(SELECT AVG(GlobalRefs), AVG(LinesOfCode), AVG(TotalTime), AVG(RowCount), Count(ID), AVG(ModuleCount), AVG(DiskWait)
		INTO :GloRef, :Lines, :Time, :RowCount, :RowFound, :ModCount, :DiskWait
	     FROM %SYS_PTools.SQLStatsView
	     WHERE  RoutineName = :rtn
	       AND CursorName = :cur  
	       AND ModuleName = :Mod)
	i RowFound'=0 {   
		i Mod="MAIN" {
			s data1="  Query Totals:  Time = "_$J($fn(Time,",",3),12)
			s data2="  Globals             = "_$J($fn(GloRef,",",0),12)
			s data3="  Commands            = "_$J($fn(Lines,",",0),12)
			s data4="  Disk Wait           = "_$J($fn(DiskWait,",",0),12)
			s data5="  Rows                = "_$J($fn(RowCount,",",0),12)
			s data6="  Run Count           = "_$J($fn(RowFound,",",0),12)
			s data=$LB(data1,data2,data3,data4,data5,data6)
		}
		else  {
			s data1="  Module "_Mod_":  Time = "_$J($fn(Time,",",3),12)
			s data2="  Globals         = "_$J($fn(GloRef,",",0),12)
			s data3="  Commands        = "_$J($fn(Lines,",",0),12)
			s data4="  Disk Wait           = "_$J($fn(DiskWait,",",0),12)
			s data5="  Executions      = "_$J($fn(ModCount,",",0),12)
			s data=$LB(data1,data2,data3,data4,"",data6)
		}
	}
	s status=$zu(115,12,status)
	QUIT data
}

ClassMethod mac(line As %String, rtn As %String)
{
	s ^rMAC(rtn,0,$i(%qln))=line,%qsize=%qsize+$l(line)+1 QUIT
}

Relationship SQLQueryPointer As %SYS.PTools.SQLQuery [ Cardinality = parent, Inverse = SQLStatsPointer ];

/// <p>
/// ##class(%SYS.PTools.SQLStats).ExportAll(<i>FilePrefix</i>,<i>delim</i>,<i>ExportPlan</i>)<br>
/// <dl>
/// <dt><i>FilePrefix</i>
/// <dd>Path and name of the file you want to export to.<br>
/// <dt><i>delim</i>
/// <dd>Default value $c(9) (tab) Delimiter for the columns of the export file.<br>
/// <dt><i>ExportPlan</i>
/// <dd>Optional. Default value = 0 if 1 then the SQL Show Plan will be included as part of the export<br>
/// This method is used to export data from <class>%SYS.PTools.SQLQuery</class> and <class>%SYS.PTools.SQLStats</class> classes to 2 delimited text file.
ClassMethod ExportAll(FilePrefix = "", delim = "", ExportPlan = 0)
{
	s filename=FilePrefix_"SQLQuery.txt"
	if ExportPlan=0 { w !,"Exporting Queries to ",filename }
	else  { w !,"Exporting Querie with ShowPlan to ",filename }
	d ##class(%SYS.PTools.SQLQuery).Export(filename,delim,ExportPlan)
	s filename=FilePrefix_"SQLStats.txt"
	w !,"Exporting Stats to ",filename 
	d ##class(%SYS.PTools.SQLStats).Export(filename,delim)
}

/// <p>
/// ##class(%SYS.PTools.SQLStats).Export(<i>FileName</i>,<i>delim</i>)<br>
/// <dl>
/// <dt><i>FileName</i>
/// <dd>Path and name of the file you want to export to.<br>
/// <dt><i>delim</i>
/// <dd>Default value $c(9) (tab) Delimiter for the columns of the export file.<br>
/// This method is used to export data from the <class>%SYS.PTools.SQLStats</class> class to a delimited text file.
ClassMethod Export(FileName = "", delim = "") As %String
{
	set:delim="" delim=$C(9)
	set LogDir=$zu(12)
	s version = "SQLStatsv03"
	;define report file name
	s config=$p($zu(86),"*",2),fdate=$zd($h,8),ftime=$tr($zt($p($h,",",2)),":","")
	s fname=$zu(54,0)_"_"_config_"_"_fdate_"_"_ftime_"_SQLStats.psql"

	set LogFile=$s(FileName'="":FileName,1:LogDir_fname)
	open LogFile:"WNS":5 ; need a recover for open failure
	if '$T use 0 write "unable to open logfile - exiting",! QUIT "Error" 
	do ..LogHeader(LogFile,version,delim)
	s NS=$NAMESPACE
	s status=$zu(115,12,-1)
	&SQL(DECLARE exp CURSOR FOR
	     SELECT  SQLQueryPointer->RoutineName, SQLQueryPointer->CursorName, SQLQueryPointer->RunCount, ModuleName, StartTime, GlobalRefs, LinesofCode, DiskWait, TotalTime, ROWCOUNT, Pid, UserName, MachineName, IPAddress, EXEName
	     INTO :rou, :cur, :counter, :Mod, :stime, :gloref, :lines, :DiskWait, :ttime, :row, :pid, :user, :machine, :ip, :exe
	     FROM %SYS_PTools.SQLStats
	     WHERE SQLQueryPointer->Namespace = :NS)
	     
	&SQL(OPEN exp)
	u LogFile
	&SQL(FETCH exp)
	while SQLCODE=0  {
		w !, rou,delim, cur,delim, counter,delim, Mod,delim, stime,delim, gloref,delim, lines,delim, DiskWait,delim, ttime,delim, row,delim, pid,delim, user,delim, machine,delim, ip,delim, exe
		&SQL(FETCH exp)
	}
	     
	&SQL(CLOSE exp) 
	s status=$zu(115,12,status)   
	c LogFile
	QUIT LogFile
}

ClassMethod LogHeader(File, version, delim)
{
	u File 
	w File,delim,version,delim,"NameSpace = ",$NameSpace
	w !,"Routine",delim,"Cursor",delim,"Run Count",delim,"Module",delim,"Start Time",delim,"Global Refs",delim,"Lines of Code",delim,"Total Time",delim,"ROWCOUNT",delim,"Process ID",delim,"User Name",delim,"Machine Name",delim,"IP Address",delim,"EXE Name"
	QUIT
}

/// This query def joins <class>%SYS_PTools.SQLQuery</class> and <class>%SYS.PTools.SQLStats</class> to make SQL reporting on the data easier.
Query SQLStatsView() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = SQLStatsView ]
{
SELECT S.ID, Q.NameSpace, Q.RoutineName, Q.CursorName, Q.CompileTime, Q.ImportSchema,
       S.StartTime, S.Counter, S.ModuleName, S.ModuleCount,
       S.GlobalRefs, S.LinesOfCode, S.DiskWait, S.TotalTime, S.TimeToFirstRow, S.RowCount, 
       S.UserName, S.ExeName, S.MachineName, S.IPAddress, S.Pid, Q.QueryType, Q.QueryText, Q.Details, Q.RunCount 
       FROM %SYS_PTools.SQLQuery Q LEFT OUTER JOIN %SYS_PTools.SQLStats S ON Q.ID = S.SQLQueryPointer
}

/// This method is called to remove data from the <class>%SYS.PTools.SQLStats</class> table.
/// It does not remove data from <class>%SYS_PTools.SQLQuery</class>, those rows are cleaned up when a query is compiled
/// it takes two parameters:
/// 		NameSpace - The NameSpace that you want to delete stats from, default is the current NameSpaces
///     	RoutineName - the name of the Routine that you want to delete Stats for, should be used with NameSpace, default is all routines
ClassMethod Purge(NameSpace As %String = "", RoutineName As %String = "") As %Status [ SqlName = Purge, SqlProc ]
{
	QUIT $$Purge^%SYS.PTools(NameSpace, RoutineName)
}

ClassMethod SetSQLStatsJob(Flag As %Integer = 0) As %Integer [ SqlName = SetSQLStatsJob, SqlProc ]
{
	
	QUIT $zu(115,12,Flag)
}

/// This method will return the SQLStats from the last query called.
/// If makes use of a local variable that gets set when the stats data is saved.
/// This only works if you are running in the same process.
/// From terminal to see the data you can call d %sqlcontext.DumpResults()
ClassMethod GetLastSQLStats() As %Integer [ ReturnResultsets, SqlName = GetLastSQLStats, SqlProc ]
{
	d GetLastSQLStats^%SYS.PTools
	quit 1
}

Property ChildSub As %Integer [ InitialExpression = {$I(^%sqlcq($NAMESPACE,"PTools","RunTime","SQLStatsC"))} ];

Index MasterIndex On (Counter, ChildSub) [ IdKey, Unique ];

Query ViewStats(NameSpace As %String) As %SQLQuery(ROWSPEC = "RoutineName:%String,QueryText:%String,RunCount:%Integer,AvgRows:%Integer,AvgGlobalRefs:%Integer,AvgDiskWait:%Integer,AvgCommands:%Integer,AvgTime:%Integer,Details:%Integer,CursorName:%Integer,RoutineCursor:%Integer,ImportSchema:%String")
{
	SELECT Main.RoutineName, Main.QueryText, RunCount,
		{fn round(avg(Main.RowCount),2)} as AvgRows,
		{fn round(avg(Main.GlobalRefs),2)} as AvgGlorefs,
		{fn round(avg(Main.DiskWait),2)} as AvgDiskWait,
		{fn round(avg(Main.LinesOfCode),2)} as AvgCommands,
		{fn round(avg(Main.TotalTime),5)} as AvgTime,
 		Details, CursorName,RoutineName||'^'||CursorName, ImportSchema
		
		FROM %SYS_PTools.SQLStatsView Main
		WHERE Main.Namespace= :NameSpace
		AND RoutineName <> 'source lines'
		AND ModuleName = 'Main'
		GROUP BY Main.RoutineName, Main.CursorName
}

Query ViewStatsDetails(CursorName As %String, RoutineName As %String) As %SQLQuery(ROWSPEC = "QueryText:%String,RunCount:%Integer,AvgRows:%Integer,AvgGlobalRefs:%Integer,AvgDiskWait:%Integer,AvgCommands:%Integer,AvgTime:%Integer,ModuleName:%String,AvgModCount:%Integer") [ SqlProc ]
{
	SELECT QueryText, RunCount,
		{fn round(avg(RowCount),2)} as AvgRows,
		{fn round(avg(GlobalRefs),2)} as AvgGlorefs,
		{fn round(avg(DiskWait),2)} as AvgDiskWait,
		{fn round(avg(LinesOfCode),2)} as AvgCommands,
		{fn round(avg(TotalTime),5)} as AvgTime,
		ModuleName,
		{fn round(avg(ModuleCount),2)} as AvgModCount
		FROM %SYS_PTools.SQLStatsView 
		WHERE CursorName= :CursorName
		AND RoutineName = :RoutineName
		GROUP BY CursorName, ModuleName
}

ClassMethod QueryText(CN As %String, Rtn As %String, Internal As %Boolean = 0) As %String
{
	s status=$zu(115,12,-1)
		&SQL(SELECT QueryText,InternalQueryText
		INTO :sql1,:sql2
		FROM %SYS_PTools.SQLQuery
		WHERE CursorName= :CN
		AND RoutineName = :Rtn)
	s status=$zu(115,12,status)
	i SQLCODE'=0 QUIT ""
	QUIT $S(Internal=0:$ZSTRIP(sql1,"<W"),1:$ZSTRIP(sql2,"<W"))
}

ClassMethod ImportSchema(CN As %String, Rtn As %String, Internal As %Boolean = 0) As %String
{
	s status=$zu(115,12,-1)
		&SQL(SELECT ImportSchema
		INTO :sql1
		FROM %SYS_PTools.SQLQuery
		WHERE CursorName= :CN
		AND RoutineName = :Rtn)
	s status=$zu(115,12,status)
	i SQLCODE'=0 QUIT ""
	QUIT sql1
}

Storage Default
{
<Data name="SQLStatsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoutineInfo</Value>
</Value>
<Value name="3">
<Value>ModuleName</Value>
</Value>
<Value name="4">
<Value>RowCount</Value>
</Value>
<Value name="5">
<Value>GlobalRefs</Value>
</Value>
<Value name="6">
<Value>LinesOfCode</Value>
</Value>
<Value name="7">
<Value>TotalTime</Value>
</Value>
<Value name="8">
<Value>TimeToFirstRow</Value>
</Value>
<Value name="9">
<Value>StartTime</Value>
</Value>
<Value name="10">
<Value>UserName</Value>
</Value>
<Value name="11">
<Value>IPAddress</Value>
</Value>
<Value name="12">
<Value>MachineName</Value>
</Value>
<Value name="13">
<Value>ExeName</Value>
</Value>
<Value name="14">
<Value>ModuleCount</Value>
</Value>
<Value name="15">
<Value>Pid</Value>
</Value>
<Value name="16">
<Value>DiskWait</Value>
</Value>
</Data>
<DataLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLStatsD")</DataLocation>
<DefaultData>SQLStatsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLStatsD")</IdLocation>
<IndexLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLStatsI")</IndexLocation>
<StreamLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLStatsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
