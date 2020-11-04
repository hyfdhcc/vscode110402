Include %quoter

/// <p>This Class gets populated from the <method>%SYS.PTools.SQLStats.Init()</method> method when gathering stats is turned on.
///    There is more info on how to run Stats in <class>%SYS.PTools.SQLStats</class>.
/// 
/// <p>The class contains the SQLText, the Job Number, the Time Stamp from when the query was run, and the Parameters that were used.
/// 
/// <p>The Method <method>Run</method> will loop over all the saved queries and execute them one after the other.
/// 
/// <p>Because ^%SYS.PTools.BenchMarkResults stores data in the CACHE DB you need to have %All to execute the Run() method.
Class %SYS.PTools.SQLBenchMarkQueries Extends %Persistent [ System = 4 ]
{

Property QueryText As %String(MAXLEN = 15000);

Property NameSpace As %String;

Property PValues As array Of %String;

Property RunTime As %TimeStamp;

Property JobNumber As %String;

Query QueryWithParameters() As %SQLQuery [ SqlView, SqlViewName = Query_With_Parameters ]
{
SELECT P.Id, P.NameSpace, P.QueryText, P.RunTime, P.JobNumber, PV.PValues
FROM %SYS_PTools.SQLBenchMarkQueries P 
LEFT OUTER JOIN %SYS_PTools.SQLBenchMarkQueries_PValues PV ON P.ID = PV.SQLBenchMarkQueries
}

/// <p>This is a simple example of what can be done with the data stored in this table.
/// <p>This method take 2 parameters:
/// <ul>
/// <li>NameSpace - the NameSpace where you want to run the Benchmark</li>
/// <li>Display   - 1 or 0 to control output to the screen</li>
/// </ul>
/// <p>This method will loop over the queries that are stored in this classes
/// and execute them as Dynamic SQL statements
/// SQLStats is turned off for this run and the state is returned when the code finishes
/// The code will display and save data for fetching the first row and for fetching all the rows
/// The data saved will be:  Global Refs, Lines of Code, Rows Returned, and Total Time.
/// All the results are stored in the <class>%SYS.SQLBenchMarkResults</class> class.
ClassMethod Run(NameSpace As %String, Display As %Integer = 1) As %Status
{
	&SQL(DECLARE query1 CURSOR FOR
	     SELECT ID, QueryText, RunTime
	     INTO :Pid, :sql, :TS
	     FROM %SYS_PTools.SQLBenchMarkQueries  
	     WHERE NameSpace=:NameSpace
	     ORDER BY RunTime)
	     
	&SQL(DECLARE query2 CURSOR FOR
	     SELECT PV.PValues
	     INTO :param
		 FROM %SYS_PTools.SQLBenchMarkQueries_PValues PV 
		 WHERE PV.SQLBenchMarkQueries = :Pid)
		 
 s status=$$$OK
 Try {	 
     s currentNS=$NameSpace
	 s NameSpace=$ZU(5,NameSpace)
	 s SQLStats=$SYSTEM.SQL.SetSQLStats(0)
	 s Run=$i(^%sqlcq($NAMESPACE,"PTools","Bench","Results","C","Run"))
	 s StartTS=$ZDATETIME($ZTIMESTAMP,3)
	 &SQL(Open query1)
	 f QueryCount=1:1 {
		 ; get a query to run
		 &SQL(FETCH query1) 
		 Q:SQLCODE'=0 	
		 i Display w !,"Query# ",QueryCount,!,?2,sql,!
		 &SQL(OPEN query2)
		 ; build a comma delimited list of parameter values
		 s values=""
		 f  &SQL(FETCH query2) Q:SQLCODE'=0  s values=values_","_$$quoter(param,1) 
		 s values=$e(values,2,*)
		 i Display w !,?5,"Parameter values:  ",values
		 s execute="set %tResult = %tStatement.%Execute("_values_")"
		 &SQL(CLOSE query2)
		 s sc=1
		 ; make the query all upper case
		 s sql=$zu(28,sql,5)
		 ; If this was embedded SQL we need to remove the DECLARE and the INTO
		 s:sql["CURSOR FOR" sql=$P(sql,"CURSOR FOR",2)
		 s:sql[" INTO " sql=$P(sql," INTO ",1)_" FROM "_$P(sql," FROM ",2)
		 ; call the Parse function to parameterize the query
		 i sql [ ":" s sql=..Parse(sql)
		 i sql'="" {
		 	set %tStatement = ##class(%SQL.Statement).%New()
	 	 	set %tStatus = %tStatement.%Prepare(sql)
	 	 	if $$$ISERR(%tStatus) w:Display=1 !,"Error preparing SQL Statement:  ",$SYSTEM.OBJ.DisplayError(%tStatus) CONTINUE
 			s SQLStats("Stime")=$ZH
 			s SQLStats("Sline")=$ZU(67,8,$j)
 			s SQLStats("Sglo")=$ZU(67,9,$j)
 			x execute
 			
 			; calculate time to first row
 			d %tResult.%Next()
 			s SQLStats("Etime")=$ZH
 			s SQLStats("Eline")=$ZU(67,8,$j)
 			s SQLStats("Eglo")=$ZU(67,9,$j)
 			s FGlo=(SQLStats("Eglo")-SQLStats("Sglo"))
 			s FLines=(SQLStats("Eline")-SQLStats("Sline"))
 			s FTime=(SQLStats("Etime")-SQLStats("Stime"))
 			
 			i Display w !,!,?5,"Stats:"
 			i Display w !,?10,"Global Refs to First Row:  ",?45,FGlo
 			i Display w !,?10,"Lines Executed to get First Row:  ",?45,FLines
 			i Display w !,?10,"Time to First Row: ",?45,FTime
 			
 			;Calculate time to last row
	 	 	if %tResult.%SQLCODE '< 0 {
				While %tResult.%Next() {}
	 	 	}
	 	 	s SQLStats("Etime")=$ZH
 			s SQLStats("Eline")=$ZU(67,8,$j)
 			s SQLStats("Eglo")=$ZU(67,9,$j)
 			s Glo=(SQLStats("Eglo")-SQLStats("Sglo"))
 			s Lines=(SQLStats("Eline")-SQLStats("Sline"))
 			s Time=(SQLStats("Etime")-SQLStats("Stime"))
 			s RowCount=%tResult.%ROWCOUNT
			i Display w !,!,?5,"Stats:"
 			i Display w !,?10,"Total Global Refs:  ",?45,Glo
 			i Display w !,?10,"Total Lines Executed:  ",?45,Lines
 			i Display w !,?10,"Total Time to Last Row: ",?45,Time
 			i Display w !,?10,"Rows Returned:  ",?45, RowCount
 			i Display w !,!,!
 			&SQL(INSERT %NOCHECK %NOLOCK INTO %SYS_PTools.SQLBenchMarkResults 
 			(QueryId,Run,StartTS,FRGlobalRefs,GlobalRefs,FRLines,Lines,FRRunTime,RunTime,Rowcount) 
 			VALUES (:Pid,:Run,:StartTS,:FGlo,:Glo,:FLines,:Lines,:FTime,:Time,:RowCount))
		 }
	 }
 }
 
 Catch exception {
	Set rc=exception.AsStatus()
	Set status=$$$ADDSC(sc,rc)
 }
 
 &SQL(CLOSE query1)
 s SQLStats=$SYSTEM.SQL.SetSQLStats(SQLStats)
 s NameSpace=$ZU(5,currentNS)
 
 QUIT status
}

ClassMethod Parse(sql) As %String
{
	s sql(1)=sql,sql=1
	s sc=$$dynamic^%qaqpreparser(.sql,.psql,.args)
	if sc'=0 QUIT ""
	QUIT psql
}

/// This method is called to remove data from the <class>%SYS.PTools.SQLBenchMarkQueries</class> and <class>%SYS.PTools.SQLBenchMarkResults</class>.
ClassMethod Purge() As %Status [ SqlName = PurgeBench, SqlProc ]
{
	d PurgeBench^%SYS.PTools()
	QUIT $$$OK
}

Storage Default
{
<CounterLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Queries","C")</CounterLocation>
<Data name="PValues">
<Attribute>PValues</Attribute>
<Structure>subnode</Structure>
<Subscript>"PValues"</Subscript>
</Data>
<Data name="SQLBenchMarkQueriesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryText</Value>
</Value>
<Value name="3">
<Value>NameSpace</Value>
</Value>
<Value name="4">
<Value>RunTime</Value>
</Value>
<Value name="5">
<Value>JobNumber</Value>
</Value>
</Data>
<DataLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Queries","D")</DataLocation>
<DefaultData>SQLBenchMarkQueriesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Queries","D")</IdLocation>
<IndexLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Queries","I")</IndexLocation>
<StreamLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Queries","S")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
