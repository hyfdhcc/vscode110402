/// This is the parent class of <class>%SYS_PTools.SQLStats</class>.  
/// <p>This class stores the general info of a query from compile time: <property>QueryText</property>, <property>QueryType</property>, <property>CursorName</property>, <property>RoutineName</property>, and <property>NameSpace</property>. 
/// All of the run time data is stored in the <class>%SYS_PTools.SQLStats</class> class.
/// <p>Error information is stored in <b>^%sqlcq(NAMESPACE,"PTools","Error",$J)</b>.
/// 
Class %SYS.PTools.SQLQuery Extends %Persistent [ System = 4 ]
{

/// Store the first 15000 charactors of the SQL Query in this field.
Property QueryText As %String(COLLATION = "SQLUPPER(255)", MAXLEN = 30000, TRUNCATE = 1) [ Calculated, SqlComputeCode = {s {*}=$S($D($$$CQ("QueryText",$S({RoutineName}[".cls":$E({RoutineName},1,*-2),1:{RoutineName}))):$P($$$CQ("QueryText",$S({RoutineName}[".cls":$E({RoutineName},1,*-2),1:{RoutineName}),1),"~RUNTIME~",1),1:{InternalQueryText})}, SqlComputed ];

Property InternalQueryText As %String(MAXLEN = 30000, TRUNCATE = 1);

/// Is the Query an INSERT UPDATE DELETE or SELECT query
Property QueryType As %String;

/// What NameSpace the SQL was generated in
Property NameSpace As %String;

/// What Routine is the SQL generated in
Property RoutineName As %String;

/// What is the name of the cursor for this SQL Statement
Property CursorName As %String;

/// Number of Seconds it takes to compile the query
Property CompileTime As %Numeric;

/// hash the SQL so we can match incoming SQL with already stored Stats
Property Hash As %String(MAXLEN = 500);

/// ImportSchema is used in generated code to handle sql statements that have unqualified table names.
Property ImportSchema As %String;

/// Number of times this query has be executed
Property RunCount As %Integer [ InitialExpression = 0 ];

/// Do we have level 3 stats for this query
Property details As %Integer;

Relationship SQLStatsPointer As %SYS.PTools.SQLStats [ Cardinality = children, Inverse = SQLQueryPointer ];

/// This method is called at compile time for a query
/// It deletes all current stats for this query, as they could be very different after the compile
ClassMethod NewQuery(ByRef SQLText As %String, SQLType As %String, NameSpace As %String, RoutineName As %String, CursorName As %String, CompileTime As %Numeric = 0) As %Status
{
	s status=$zu(115,12,-1)
	d NewQuery^%SYS.PTools(.SQLText, SQLType, NameSpace, RoutineName, CursorName, CompileTime)
	s status=$zu(115,12,status)
	QUIT
}

Index master On (RoutineName, CursorName) [ IdKey, Unique ];

/// <p>
/// ##class(%SYS.PTools.SQLQuery).Export(<i>FileName</i>,<i>delim</i>,<i>ExportPlan</i>)<br>
/// <dl>
/// <dt><i>FileName</i>
/// <dd>Path and name of the file you want to export to.<br>
/// <dt><i>delim</i>
/// <dd>Default value $c(9) (tab) Delimiter for the columns of the export file.<br>
/// <dt><i>ExportPlan</i>
/// <dd>Optional. Default value = 0 if 1 then the SQL Show Plan will be included as part of the export<br>
/// This method is used to export data from the <class>%SYS.PTools.SQLQuery</class> class to a delimited text file.
ClassMethod Export(FileName = "", delim = "", ExportPlan = 0) As %String
{
	set:delim="" delim=$C(9)
	set LogDir=$zu(12)
	s version = "SQLStatsv03"
	;define report file name
	s config=$p($zu(86),"*",2),fdate=$zd($h,8),ftime=$tr($zt($p($h,",",2)),":","")
	s fname=$zu(54,0)_"_"_config_"_"_fdate_"_"_ftime_"_SQLQuery.psql"

	set LogFile=$s(FileName'="":FileName,1:LogDir_fname)
	open LogFile:"WNS":5 ; need a recover for open failure
	if '$T use 0 write "unable to open logfile - exiting",! QUIT "Error" 
	do ..LogHeader(LogFile,version,delim)
	s NS=$NAMESPACE
	s status=$zu(115,12,-1)
	&SQL(DECLARE exp CURSOR FOR
	     SELECT  RoutineName, CursorName, RunCount, QueryType, QueryText,ImportSchema
	     INTO :rou, :cur, :counter, :type, :query, :schema
	     FROM %SYS_PTools.SQLQuery
	     WHERE Namespace = :NS)
	&SQL(OPEN exp)

	u LogFile
	&SQL(FETCH exp)
	while SQLCODE=0  {
		w !, rou,delim, cur,delim, counter,delim, type,delim
		s QUERY=$zconvert(query,"U")
		if QUERY["CURSOR FOR" {
			s selectlen=$L($P(QUERY,"CURSOR FOR",2))
			s query=$E(query,($L(query)-selectlen+1),*)
		}
		s QUERY=$zconvert(query,"U")
		if QUERY["INTO ?" {
			s selectlen=$L($P(QUERY,"INTO ?",1))
			s QUERY=$P(QUERY,"INTO ?",2,*)
			s fromlen=$L($P(QUERY,"FROM",2,*))
			s part1=$e(query,1,selectlen)_" FROM "
			s part2=$E(query,($L(query)-fromlen+1),*)
			s query=part1_part2
		}
		s sql=1
		s sql(1)=query
		k %plan
		d:ExportPlan ShowPlan^%apiSQL(.sql,1,"",0,schema,"",1)
		u LogFile
		if +$g(%plan)'=0 { f i=1:1:%plan w %plan(i)_"<br>" }
		ELSE { w query_"<br>"}
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
	w !,"Routine",delim,"Cursor",delim,"Run Count",delim,"Query Type",delim,"Query Plan"
	QUIT
}

Storage Default
{
<CounterLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLQueryC")</CounterLocation>
<Data name="SQLQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InternalQueryText</Value>
</Value>
<Value name="3">
<Value>QueryType</Value>
</Value>
<Value name="4">
<Value>CompileTime</Value>
</Value>
<Value name="5">
<Value>Hash</Value>
</Value>
<Value name="6">
<Value>NameSpace</Value>
</Value>
<Value name="7">
<Value>RoutineName</Value>
</Value>
<Value name="8">
<Value>CursorName</Value>
</Value>
<Value name="9">
<Value>QueryText</Value>
</Value>
<Value name="10">
<Value>ImportSchema</Value>
</Value>
<Value name="11">
<Value>RunCount</Value>
</Value>
<Value name="12">
<Value>details</Value>
</Value>
</Data>
<DataLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLQueryD")</DataLocation>
<DefaultData>SQLQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLQueryD")</IdLocation>
<IndexLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLQueryI")</IndexLocation>
<StreamLocation>^%sqlcq($NAMESPACE,"PTools","RunTime","SQLQueryS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
