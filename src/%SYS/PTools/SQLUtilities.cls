Include (%msql, %sqlcode)

Class %SYS.PTools.SQLUtilities Extends %Persistent [ CompileAfter = %SYS.PTools.SQLUtilResults, System = 4 ]
{

Property Type As %String;

Property Name As %String;

/// comma delimited list of Package names to use compiling queries
Property ImportPackage As %String;

Property SQLText As %Stream.GlobalCharacter;

/// <br>This method finds all the SQL Queries in a namespace, generates a Show Plan for each one, keeps a count of the indices used and then lists the totals for all the indices in the namespace. 
/// <br>This can be used to find and remove unneeded indices.<br>
/// <br>Test this by invoking this procedure from an xDBC client:
/// 	<example>
/// call %SYS_PTools.IndexUsage(1)
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SchemaName, Tablename, IndexName, UsageCount FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='IU' ORDER BY UsageCount
/// </example>
/// This method can also be run from a command prompt:
/// <example>
/// do ##class(%SYS.PTools.SQLUtilities).IndexUsage(1)
/// </example>
/// Then in $SYSTEM.SQL.Shell()
/// <example>
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SchemaName, Tablename, IndexName, UsageCount FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='IU' ORDER BY UsageCount
/// </example>
ClassMethod IndexUsage(PopTable As %Integer = 1, SystemTables As %Integer = 0, IgnoreEns As %Integer = 1, IgnoreIDKeys As %Integer = 1, Display As %Integer = 0) As %Status [ PublicList = SQLCODE, SqlName = IndexUsage, SqlProc ]
{
	n SQLCODE
	s status=1
	&SQL(SELECT ID FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='IU')
	if PopTable=1!(SQLCODE=100) {
		lock +^%sqlcq($NAMESPACE,"PTools","Utils","Queries"):5
		s:$T status=$$IndexUsage^%SYS.PTools(PopTable, SystemTables, IgnoreEns, IgnoreIDKeys, Display)
		lock -^%sqlcq($NAMESPACE,"PTools","Utils","Queries")
	}
	QUIT status
}

/// <br>This method looks at all the SQL Queries in a namespace and list out the ones that are doing a table scan.  The Table scan could be over an index or the master map.
/// 
/// <br>For some queries a table scan can't be avoided, but any query in this list should be reviewed to see if an index could help.<br>
/// 
/// <br>Test this by invoking this procedure from an xDBC client:
/// <example>
/// call %SYS_PTools.TableScans(1)
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SQLPointer->Type As "Routine Type", SQLPointer->Name As "Routine Name", SchemaName, TableName, ModuleName, ExtentSize FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='TS' ORDER BY ExtentSize DESC
/// </example>
/// This method can also be run from a command prompt:
/// <example>
/// do ##class(%SYS.PTools.SQLUtilities).TableScans(1)
/// </example>
/// Then in $SYSTEM.SQL.Shell()
/// <example>
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SQLPointer->Type As "Routine Type", SQLPointer->Name As "Routine Name", SchemaName, TableName, ModuleName, ExtentSize FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='TS' ORDER BY ExtentSize DESC
/// </example>
ClassMethod TableScans(PopTable As %Integer = 1, SystemTables As %Integer = 0, IgnoreEns As %Integer = 1, Display As %Integer = 0) As %Status [ PublicList = SQLCODE, SqlName = TableScans, SqlProc ]
{
	n SQLCODE
	s status=1
	&SQL(SELECT ID FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='TS')
	if PopTable=1!(SQLCODE=100) {
		lock +^%sqlcq($NAMESPACE,"PTools","Utils","Queries"):5
		s:$t status=$$TableScans^%SYS.PTools(PopTable, SystemTables, IgnoreEns, Display)
		lock -^%sqlcq($NAMESPACE,"PTools","Utils","Queries")
	}
	QUIT status
}

/// <br>This method looks at all the SQL queries in a namespace and displays any query that is building a temp table.
/// 
/// <br>The results of this method and the Table scan method might have a large overlap.
/// 
/// <br>Not all temp indices can be avoided, but often the structure of a temp indice could be the basis of a class index to help speed up the query.<br>
/// 
/// <br>Test this by invoking this procedure from an xDBC client:
/// <example>
/// CALL %SYS_PTools.TempIndices(1)
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SchemaName,TableName, IndexFields, DataValues, ExtentSize FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='TI' ORDER BY ExtentSize DESC
/// </example>
/// This method can also be run from a command prompt:
/// <example>
/// do ##class(%SYS.PTools.SQLUtilities).TempIndices(1)
/// </example>
/// Then in $SYSTEM.SQL.Shell()
/// <example>
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SchemaName,TableName, $LISTTOSTRING(IndexFields) As "Index Fields", $LISTTOSTRING(DataValues) As "Data Fields", ExtentSize FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='TI' ORDER BY ExtentSize DESC
/// </example>
ClassMethod TempIndices(PopTable As %Integer = 1, SystemTables As %Integer = 0, IgnoreEns As %Integer = 1, Display As %Integer = 0) As %Status [ PublicList = SQLCODE, SqlName = TempIndices, SqlProc ]
{

	n SQLCODE
	s status=1
	&SQL(SELECT ID FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='TI')
	if PopTable=1!(SQLCODE=100) {
		lock +^%sqlcq($NAMESPACE,"PTools","Utils","Queries"):5
		s:$T status=$$TempIndices^%SYS.PTools(PopTable, SystemTables, IgnoreEns, Display)
		lock -^%sqlcq($NAMESPACE,"PTools","Utils","Queries")
	}
	QUIT status
}

/// <br>This method looks at all the SQL queries on a system.  
/// <br>For any query doing a JOIN it will look at the fields from both tables that are part of the join 
/// and then see if there is an index that supports the join.
/// <br>
/// <br>The Property JoinIndexFlag has 4 values:
///      <ul>0 - No index to support the join.
///                Some version of the suggested index should be created to improve this queries performance.</ul>
///      <ul>1 - There is an index to support the join but it does not contain all the join fields.
///                This will produce poor performance and for that reason is rarely used.</ul>
///      <ul>2 - There is an index to support the join but it is not an exact match, the first index field is not part of the join. 
///                This might produce OK performance, but improvements should be made.</ul>
///      <ul>3 - There is an index to support the join but it is not an exact match, the first index field is part of the join but there are additional fields.
///                This will produce OK performance, but improvements can be made.</ul>
///      <ul>4 - Index fully supports the join. 
///                This is not included in the table as there is nothing to improve.</ul>
/// <br>Creating a new index in the case of JoinIndexFlag = 0 or 1 should show good performance gains
/// <br>Creating a new index for JoinIndexFlag = 2 will help, improvements will depend on the number of leading subscripts and their selectivity
/// <br>Creating a new index for JoinIndexFlag = 3 could help, in most cases you will only see small improvements.
/// <br>
/// <br>The property IndexFields would be an index we think could help improve performance.
/// <br>The Order of the subscripts does not matter for the join, but could make a difference in performance.
/// <br>The property with the lowest selectivity should be first.
/// <br>
/// 
/// <br>Test this by invoking this procedure from an xDBC client:
/// <example>
/// call %SYS_PTools.JoinIndices(1)
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SchemaName, TableName, IndexFields As IndexNeeded, JoinIndexFlag FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='JI' ORDER BY 1,2,3
/// </example>
/// This method can also be run from a command prompt:
/// <example>
/// do ##class(%SYS.PTools.SQLUtilities).JoinIndices(1)
/// </example>
/// Then in $SYSTEM.SQL.Shell()
/// <example>
/// SELECT %EXACT(Type), Count(*) As QueryCount FROM %SYS_PTools.SQLUtilities GROUP BY Type
/// SELECT SchemaName, TableName, IndexFields As IndexNeeded, JoinIndexFlag, COUNT(*) AS QueryCount 
/// FROM %SYS_PTools.SQLUtilResults
/// WHERE JoinIndexFlag < 4 and OptionName ='JI' 
/// GROUP BY SchemaName, TableName, IndexFields
/// ORDER BY 4,5 DESC
/// </example>
ClassMethod JoinIndices(PopTable As %Integer = 1, SystemTables As %Integer = 0, IgnoreEns As %Integer = 1, Display As %Integer = 0) As %Status [ PublicList = SQLCODE, SqlName = JoinIndices, SqlProc ]
{
	n SQLCODE
	s status=1
	&SQL(SELECT ID FROM %SYS_PTools.SQLUtilResults WHERE OptionName ='JI')
	if PopTable=1!(SQLCODE=100) {
		lock +^%sqlcq($NAMESPACE,"PTools","Utils","Queries"):5
		s:$T status=$$JoinIndices^%SYS.PTools(PopTable, SystemTables, IgnoreEns, Display)
		lock ^%sqlcq($NAMESPACE,"PTools","Utils","Queries")
	}
	QUIT status
}

/// This Method returns a ResultSet that contains:  Location, Type, SQLText
ClassMethod GetSQLStatements(cachedQueries = 1, classQueries = 1, classMethods = 1, routines = 1, SystemTables, Display = 0) As %Status [ PublicList = (SQLCODE, %ROWID, %ROWCOUNT, name, class, query), ReturnResultsets ]
{
	#;      cachedQueries : TinyInt, default is 1.  if 1, export SQL queries from cached queries
	#;      classQueries  : TinyInt, default is 1.  if 1, export SQL queries from SQL class queries
	#;      classMethods  : TinyInt, default is 1.  if 1, export embedded SQL queries from class methods
	#;      routines      : TinyInt, default is 1.  if 1, export embedded SQL queries from MAC routines
	#;                    :  This does not include system routines or generated routines
	
	d GetSQLStatements^%SYS.PTools(cachedQueries, classQueries, classMethods, routines, Display)
	QUIT $$$OK
}

ClassMethod ClearResults() As %Status
{
	QUIT $$ClearResults^%SYS.PTools()
}

ClassMethod ClearStatements() As %Status
{
	QUIT $$ClearStatements^%SYS.PTools()
}

ClassMethod PossiblePlans(sql, PPcost = 0, num = 0, level = 0, arr, showstats = 0, packages, schemapath = "", preparse = 0, hash = "") [ ProcedureBlock = 0 ]
{
	n dasl,data,dcost,dint,dmac,dmt,dsql,Hval,mtc,i,j,inclist,mcurs,mtag,ppsql,str,%substk,%SYSTEMINCLUDE
	if schemapath'="" new %sqlSchemaPath set %sqlSchemaPath=schemapath
	if preparse {
		try {
			set ppsql=$$preparse^%qaqpreparser(.sql,1)
			kill sql
			set sql=1,sql(1)=$lg(ppsql,1)	// sql is now the preparsed version of the statement
		}
		catch {
			w !,"Unexpected Error:  ",$ze
			set ok=0
		}
	}
	try { 
		n %msg,ok,SQLCODE s ok=1
		d comp^%qaqqt("query",.sql,"info","",0,"","%qsc(%qscacn",,,$g(packages))
	}
	catch { 
		if $g(err)="qaqperr",$g(SQLCODE) { w !,"SQLCODE = ",SQLCODE," ",$$sqlcode(SQLCODE),".  ",!,$g(%msg) }
		else { w !,"Unexpected Error:  ",$ze }
		set ok=0
	}
	QUIT:'ok
	s i="" 
	For  {
		s i=$o(mtc(0,0,"table",i),1,data)
		q:i=""  
		s data=$p(data,$c(1),4)	// data is now the extentname
		i data'="" {
			s j="" For  Set j=$o(^oddCOM(data,36,j)) Quit:j=""  Set inclist(j)=""
		}
	}
	i $d(inclist) s i="" f  s i=$o(inclist(i)) q:i=""  s dmac($i(dmac))="#INCLUDE "_i
	if $g(packages)'="" f i=1:1:$ll(packages) s dmac($i(dmac))="#import "_$lg(packages,i)
	if schemapath'="" s dmac($i(dmac))="#sqlcompile path="_$listtostring(schemapath)
	f i=1:1:$g(sql) s dmac($i(dmac))=$s(i=1:" &sql(",1:" ")_$g(sql(i))
	s dmac($i(dmac))=" )"	// DPV3472 - put closing ")" on line by itself in case SQL satemet ends with comment
	zb close+1^%qaqcasl:"N"::"kill dmt(""sql"") MERGE dmt(""sql"")=mt(""sql"")"  ;  AK731 3/21/2k9
	zb +1^%qaqcasl:"N"::"MERGE:'$d(dsql) dsql=sql,dasl=asl,dmt=mt,dcost=omscost"
	zb +1^%qaqpag:"N"::"do ##class(%SYS.PTools.SQLUtilities).ChangeCost(PPcost,num,level,.mt,.mts,.%malg)"			
	d LINES^%qarmac("dmac","dint")  ;  run the compiler and collect data
	zb --+1^%qaqpag
	zb --+1^%qaqcasl  ;  clear the breakpoint
	zb --close+1^%qaqcasl  ;  clear the breakpoint  ;  AK731 3/21/2k9
	k %plan s %plan=0
	d:$g(dsql) nliz^%qaqplan(.dsql,.dasl,.dmt,dcost,showstats)  ;  analyze asl/mt
	s str=$LB("")
	s Hval=1,Hval(1)=$LB("")
	s hash=$$Hash^%SYS.SQLSRV(str,.%plan,.Hval)
	i '$g(arr) f %plan=1:1:%plan w !,%plan(%plan)  ;  output results
	QUIT
}

ClassMethod ChangeCost(PPcost, num, level, dmt, dmts, dalg)
{
	; if this is the first time in we need to loop over the %mcost array to get the different cost values

	; %mcost(qoqn,qojsn,numstream,streams,order,outtype,i) = solution
	try {
		if $g(num)=0 {
			k ^||PPcost
			m ^||PPcost("data",1)=%mcost(1)
			d ..BuildPPcost(1, .dmt, .dmts, .dalg, .cost)
			m ^||PPcost("cost")=cost
		}	; if
		; any other time in we modify the %mcost array to change the plan
		i num'=0 {
			s data=$g(^||PPcost("cost",level,PPcost,num))
			; to change the plan set all the sixth level to ""
			f i=0:1:2 s %mcost($LG(data,1),$LG(data,2),$LG(data,3),$LG(data,4),$LG(data,5),i)=""
			; then only set the one sixth level you want to the plan you want
			s %mcost($LG(data,1),$LG(data,2),$LG(data,3),$LG(data,4),$LG(data,5),$LG(data,6))=$LG(data,7)
		}
	}	;try
	
	catch {
		w !,"Error:  ",$ze
	}
}

ClassMethod BuildPPcost(qoqn, dmt, dmts, dalg, PPcost) [ PublicList = ptfjoo ]
{
 Try {	
	QUIT:qoqn=""
	s qojsn=""
	f  {
		s qojsn=$O(%mcost(qoqn,qojsn))		; always 1 yes!
		QUIT:qojsn=""
		s numstream=$O(%mcost(qoqn,qojsn,""),-1)			; this is the tables involved? don't loop $O(,-1)
		s streams=$O(%mcost(qoqn,qojsn,numstream,""))	; list of tables handled at this level
		s order=$S(ptfjoo(qoqn)'="":ptfjoo(qoqn),1:0)	; use 0 unless the query has an ORDER BY
		s outtype=""
		f  {
			s outtype=$O(%mcost(qoqn,qojsn,numstream,streams,order,outtype))	; 0, 1, or 2
			QUIT:outtype=""
			s i=""
			f  {
				s i=$O(%mcost(qoqn,qojsn,numstream,streams,order,outtype,i),1,data)	; loop over all the solutions for this output type
				QUIT:i=""
				s counter=$i(PPcost(numstream))
				s cost=$P($P(data,"^",1),",",1)
				s qosn=$P(data,"^",2)
				
				s PPcost(numstream,cost,counter)=$LB(qoqn,qojsn,numstream,streams,order,outtype,i)
				s parent=$P(data,"^",3)
				i qoqn=1 {								; need to go back up the tree to get the starting table
					f  {
						QUIT:parent=""					; we know we are at the top of the tree when parent is NULL
						s s1=$P(parent,":",1)
						s s2=$P(parent,":",2)
						s s3=$P(parent,":",3)
						s s4=$P(parent,":",4)
						s s5=$P(parent,":",5)
						s s6=$P(parent,":",6)
						s s7=$P(parent,":",7)
						s data=%mcost(s1,s2,s3,s4,s5,s6,s7),qosn=$P(data,"^",2),stnum=s2
						s parent=$P(%mcost(s1,s2,s3,s4,s5,s6,s7),"^",3)
					}
					s PPcost(numstream,cost,counter,"map")=..map(data,.dmt,.dmts,.dalg,qoqn,qosn)
				}
			} 	; i
		}	; outtype			
	}	; qojsn
 }
 	catch {
		w !,"Error:  ",$ze
	}
}

ClassMethod map(data, mt, mts, alg, qnum, str)
{
	if $g(mt("r",str,"q"))'="" {
		if $D(mt("union"))=0
		{
			; This is a view figure out the starting map
			s vqnum=mt("r",str,"q")
			; sort the %mcost array for the view
			d ..BuildPPcost(vqnum, .mt, .mts, .alg, .cost)
			s vqnum=$O(cost(""))
			s qcost=$O(cost(vqnum,""))
			s qcounter=$O(cost(vqnum,qcost,""),1,costdata)
			s qdata=%mcost($LG(costdata,1),$LG(costdata,2),$LG(costdata,3),$LG(costdata,4),$LG(costdata,5),$LG(costdata,6),$LG(costdata,7))
			s algnum=$P(qdata,"^",4)
			s imp=$P(alg(algnum),"^",12)
			s qstr=$P(qdata,"^",2)
			s irn=$P(mt("r",qstr),"^",1)
			s TableName=$$$smdSchema(1,irn)_"."_$$$smdName(1,irn)
	}
		else  {
			; this is a UNION OR optimization, not a real view.

			s vqnum=4 ;$O(mt("union",""))
			d ..BuildPPcost(vqnum, .mt, .mts, .alg, .cost)
			s vqnum=$O(cost(""))
			s qcost=$O(cost(vqnum,""))
			s qcounter=$O(cost(vqnum,qcost,""),1,costdata)
			s qdata=%mcost($LG(costdata,1),$LG(costdata,2),$LG(costdata,3),$LG(costdata,4),$LG(costdata,5),$LG(costdata,6),$LG(costdata,7))
			s algnum=$P(qdata,"^",4)
			s imp=$P(alg(algnum),"^",12)
			s qstr=$P(qdata,"^",2)
			s irn=$P(mt("r",qstr),"^",1)
			s TableName=$$$smdSchema(1,irn)_"."_$$$smdName(1,irn)

		}
	}
	ELSE {
		; this is a table, get the name and the map
		s algnum=$P(data,"^",4)
		s imp=$P(alg(algnum),"^",12)
		s irn=$P(mt("r",str),"^",1)
		s TableName=$$$smdSchema(1,irn)_"."_$$$smdName(1,irn)
	}
	If TableName="." QUIT $LB("Union Or Optimization","Not supported")
	If imp="" QUIT $LB(TableName, "Multi Index")
    ;  identify map:  master/index map "s.t.m"  *** check for virtual map!  JLF015
	i $d(mt("filterm",imp),filter) QUIT $LB(TableName_".%ID ",$s($e(filter,1,6)="%INBIT":"bitmap ",1:"")_"filter ")
	s smdimp=$s($d(mt("smdimp",imp)):mt("smdimp",imp),1:imp)
	i $$$smdG(12,+smdimp)="" QUIT $LB(TableName_"."_"?","?")
	s it=$$$smdMapIndexType(smdimp)
	s node=$s($$$smdMapMaster(smdimp)="Y":"master map ",it="BE":"extent bitmap ",it="B":"bitmap index ",1:"index map ")
	if node = "master map " {
		s idifn=$P(mts(qnum,str),"^",5)
		s idcon=$D(mts(qnum,str,"CON",idifn))				; is there a condition on the ID field
		s inherited=($p($g(mts(qnum,str,"MAP",imp),1),"^",5)=0) ;  it must be inherited
		i 'idcon&(inherited) {
			; see if there is a bitmap extent that will get used
			s ebm=$$$smdBitmapExtentMap(1,irn)
			if $d(mts(qnum,str,"MAP",+ebm))  s smdimp=ebm,node="extent bitmap"
		}

	}
	; QUIT $LB(Schema_"."_Table_"."_Map, MapType)
	QUIT $LB(TableName_"."_$$$smdMapName(smdimp), node)
}

Query IndexUsage(schema) As %SQLQuery(ROWSPEC = "SchemaName:%String,TableName:%String,IndexName:%String,Count:%Integer")
{
	SELECT SchemaName, Tablename, IndexName, UsageCount
	FROM %SYS_PTools.SQLUtilResults 
	WHERE OptionName ='IU' 
	and (SchemaName = :schema or :schema IS NULL)
	ORDER BY UsageCount
}

Query TableScans(schema) As %SQLQuery(ROWSPEC = "SchemaName:%String,TableName:%String,Type:%String,Class/Routine Name:%String,ModuleName:%String,Map Type:%String,ExtentSize:%Integer,Block Count:%Integer,SQLText:%String")
{
	SELECT SchemaName, TableName, SQLPointer->Type, SQLPointer->Name, ModuleName, MapType, ExtentSize, BlockCount, SQLPointer->SQLText 
	FROM %SYS_PTools.SQLUtilResults 
	WHERE OptionName ='TS' 
	and (SchemaName = :schema or :schema IS NULL)
	ORDER BY BlockCount DESC
}

Query TempIndices(schema) As %SQLQuery(ROWSPEC = "SchemaName:%String,TableName:%String,Type:%String,Class/Routine Name:%String,IndexFields:%String,DataFields:%String,ExtentSize:%Integer,Block Count:%Integer,SQLText:%String")
{
	SELECT SchemaName, TableName, SQLPointer->Type, SQLPointer->Name, $LISTTOSTRING(IndexFields) As "Index Fields", $LISTTOSTRING(DataValues) As "Data Fields", ExtentSize, BlockCount, SQLPointer->SQLText 
	FROM %SYS_PTools.SQLUtilResults 
	WHERE OptionName ='TI' 
	and (SchemaName = :schema or :schema IS NULL)
	ORDER BY BlockCount DESC
}

Query JoinIndices(schema) As %SQLQuery(ROWSPEC = "SchemaName:%String,TableName:%String,IndexNeeded:%String,JoinIndexFlag:%Integer,UsageCount:%Integer,SQLText:%String")
{
	SELECT %Exact(SchemaName), %Exact(TableName), %Exact($LISTTOSTRING(IndexFields)) As IndexNeeded, JoinIndexFlag, 
    (SELECT COUNT(*) 
     FROM %SYS_PTools.SQLUtilResults Sub
     WHERE Sub.SchemaName= Main.SchemaName
           AND Sub.TableName = Main.Tablename
           AND Sub.IndexFields = Main.IndexFields
           AND Sub.JoinIndexFlag < 4) As UsageCount, 
    SQLPointer->SQLText
	FROM %SYS_PTools.SQLUtilResults Main
	WHERE JoinIndexFlag < 4
	AND OptionName ='JI' 
	and (SchemaName = :schema or :schema IS NULL)
	GROUP BY JoinIndexFlag, SchemaName, TableName, IndexFields
	ORDER BY JoinIndexFlag, UsageCount DESC
}

Query FindSQL() As %SQLQuery(ROWSPEC = "QueryType:%String,QueryCount:%Integer")
{
	SELECT %EXACT(Type), Count(*) 
    FROM %SYS_PTools.SQLUtilities 
    GROUP BY Type
}

Query PossiblePlans(sql As %String) As %Query(ROWSPEC = "ID:%Integer,Cost:%Integer,MapType:%String(MAXLEN=15),StartingMap:%String(MAXLEN=30),Plan:%String(MAXLEN=15)") [ SqlName = PossiblePlans, SqlProc ]
{
}

ClassMethod PossiblePlansExecute(ByRef qHandle As %Binary, sql As %String) As %Status
{
	i sql'=+sql s sql(1)=sql,sql=1
	;m sql=^mqh($USERNAME)
	d ShowPlanAlt^%apiSQL(.sql,1)
	s qHandle=0
	Quit $$$OK
}

ClassMethod PossiblePlansClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PossiblePlansExecute ]
{
	k %AltPlan
	Quit $$$OK
}

ClassMethod PossiblePlansFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PossiblePlansExecute ]
{
	s qHandle=$O(%AltPlan(qHandle))
	If qHandle="" s AtEnd=1,Row="" QUIT $$$OK
	s cost=$FN($LG(%AltPlan(qHandle,0),1),"N",1)
	s map=$LG($LG(%AltPlan(qHandle,0),3),2)
	s type=$LG($LG(%AltPlan(qHandle,0),3),1)
	s Row=$LB(qHandle,cost,map,type,"Plan")
	Quit $$$OK
}

Query PossiblePlansStats(sql As %String, ids As %String) As %Query(ROWSPEC = "ID:%Integer,Cost:%Integer,StartingMap:%String,GlobalRef:%Integer,Commands:%Integer,TotalTime:%Integer,RowsReturned:%Integer,Plan:%String") [ SqlName = PossiblePlansStats, SqlProc ]
{
}

ClassMethod PossiblePlansStatsExecute(ByRef qHandle As %Binary, sql As %String, ids As %String) As %Status
{
	i sql'=+sql s sql(1)=sql,sql=1
	;m sql=^mqh($USERNAME,"stats",1)
	;s ids=^mqh($USERNAME,"stats",2)
	s idlist=""
	f i=1:1:$L(ids,",") s:$p(ids,",",i)'="" idlist=idlist_","_$P(ids,",",i)
	s idlist=$e(idlist,2,*)
	d ShowPlanAlt^%apiSQL(.sql,1,"",1,"","",0,idlist)
	s qHandle=0
	Quit $$$OK
}

ClassMethod PossiblePlansStatsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PossiblePlansExecute ]
{
	k %AltPlan
	Quit $$$OK
}

ClassMethod PossiblePlansStatsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PossiblePlansExecute ]
{
	s qHandle=$O(%AltPlan(qHandle))
	If qHandle="" s AtEnd=1,Row="" QUIT $$$OK
	s line=1
	f  {
		s line=$O(%AltPlan(qHandle,line),1,data)
		QUIT:line=""
		CONTINUE:data'="<stats>"
		s time=$ZSTRIP($P(%AltPlan(qHandle,(line+1)),"=",2),"<W")
		s globals=$ZSTRIP($P(%AltPlan(qHandle,(line+3)),"=",2),"<W")
		s commands=$ZSTRIP($P(%AltPlan(qHandle,(line+4)),"=",2),"<W")
		s rows=$ZSTRIP($P(%AltPlan(qHandle,(line+5)),"=",2),"<W")
		QUIT
	}
	s cost=$FN($LG(%AltPlan(qHandle,0),1),"N",1)
	s map=$LG($LG(%AltPlan(qHandle,0),3),1)
	s Row=$LB(qHandle,cost,map,globals,commands,time,rows,"Plan")
	Quit $$$OK
}

Storage Default
{
<CounterLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Queries","C")</CounterLocation>
<Data name="SQLUtilitiesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>SQLText</Value>
</Value>
<Value name="5">
<Value>ImportPackage</Value>
</Value>
</Data>
<DataLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Queries","D")</DataLocation>
<DefaultData>SQLUtilitiesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Queries","D")</IdLocation>
<IndexLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Queries","I")</IndexLocation>
<StreamLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Queries","S")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
