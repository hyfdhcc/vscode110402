Include (%msql, %occCPT)

/// <class>%SQL.Statement</class> implements an interface to prepare and execute dynamic SQL statements.  <br> <br>
/// <!doctype html public "-//w3c//dtd html 4.0 transitional//en">
/// <html>
/// <head>
///    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
///    <meta name="GENERATOR" content="Mozilla/4.77 [en] (Windows NT 5.0; U) [Netscape]">
///    <title>Dynamic SQL</title>
/// </head>
/// 	<body>
/// 	<h1>Dynamic SQL</h1>
/// 	<h2>Overview</h2>
/// 	
/// 	<p>The %SQL.Statement class implements an interface for managing dynamic SQL statements. The interface consists of %Prepare, %Execute, %ExecDirect methods and the %Dialect, %Metadata, %SchemaPath, and %Selectmode properties.
/// 	</p>
/// 	<p>
/// 	To prepare and execute a dynamic SQL statement, use an instance of %SQL.Statement, such as:
/// 	</p>
/// 	<pre>
/// 	set tStatement = ##class(%SQL.Statement).%New(2,"Sample")
/// 	</pre>
/// 	<p>
/// 	%New() accepts three optional parameters that allow you to specify the value of the %SelectMode, %SchemaPath and %Dialect properties.  You can explicitly set these properties at any time; the value of each affects subsequent statement preparation and execution.
/// 	</p>
/// 	<p>
/// 	Next, prepare the dynamic statement by invoking the %Prepare() method. %Prepare() accepts an SQL statement in the form of a simple value or in an array passed by reference. For an array, the value of the base node is the number of lines in the array and each node&rsquo;s subscript specifies its line number; the value of each subnode is a portion of the SQL statement. An example of preparing an array is:
/// 	</p>
/// 	<pre>
/// 	    set tSQL = 3
/// 	    set tSQL(1) = "select %ID as id, Name, DOB, Home_State"
/// 	    set tSQL(2) = "from Person where Age > 80"
/// 	    set tSQL(3) = "order by 2"
/// 	    set tStatus = tStatement.%Prepare(.tSQL)
/// 	</pre>
/// 	<p>
/// 	%Prepare() returns a status value that indicates success or failure. If the statement is successfully prepared, the next step is to execute it by invoking the %Execute() method.
/// 	</p>
/// 	<pre>
/// 	   set tResult = tStatement.%Execute()
/// 	</pre>
/// 	<p>
/// 	The %Execute() method returns an instance of the <class>%SQL.StatementResult</class> class. Refer to that class for more information
/// 	on the result object interface. All result objects support a %Display() method that is useful for testing.
/// 	</p>
/// 	<p>
/// 	The following example demonstrates the use of the %Prepare(), %Execute, and %Display() methods:
/// 	</p>
/// 	<pre>
/// 	   SAMPLES>s tStatus = tStatement.%Prepare(.tSQL)
/// 	
/// 	   SAMPLES>w tStatus
/// 	   1
/// 	   SAMPLES>s tResult = tStatement.%Execute()
/// 	
/// 	   SAMPLES>d tResult.%Display()
/// 	   id    Name                  DOB           Home_State
/// 	   99    Finn,George V.        03/23/1928    MA
/// 	   140   Hanson,James K.       04/02/1928    VT
/// 	   14    Klein,Michael X.      06/17/1923    WV
/// 	   159   Klingman,Brenda U.    07/09/1924    WA
/// 	   49    Paladino,Rhonda H.    06/29/1923    AR
/// 	   63    Vonnegut,Nellie K.    03/24/1926    HI
/// 	   146   Zimmerman,Martin K.   05/25/1924    OH
/// 	
/// 	7 Rows(s) Affected
/// 	</pre>
/// 	<p>
/// 	Once an SQL statement has been successfully prepared, its %Metadata property is available. %Metadata is an instance of the <class>%SQL.StatementMetadata</class> class. %SQL.Metadata implements a %Display() method that is useful for examining the metadata interactively, such as:
/// 	</p>
/// 	<pre>
/// 	    SAMPLES>do tStatement.%Metadata.%Display()
/// 	    Columns (property 'columns'):
/// 	    Column Name  Type Prec Scale Null
/// 	    -----------  ---- ---- ----- ----
/// 	    id              4   10     0    0 id           Person       Sample       0            Y  N  N  Y0    1
/// 	    Name           12   50     0    0 Name         Person       Sample       0            N  N  N  N0    0
/// 	    DOB             9   10     0    1 DOB          Person       Sample       0            N  N  N  N0    0
/// 	    Home_State     12    2     0    1 Home_State   Person       Sample       0            N  N  N  N0    0
/// 	
/// 	    Statement Parameters (property 'parameters'):
/// 	
/// 	    Nbr. Type precision scale nullable colName      columntype
/// 	    ---- ---- --------- ----- -------- ------------ ----------
/// 	       1    4     10        0     1    %parm(1)        1
/// 	       2   12      2        0     1    %parm(2)        1
/// 	
/// 	    Formal Parameters (property 'formalParameters'):
/// 	
/// 	    Nbr. Type precision scale nullable colName      columntype
/// 	    ---- ---- --------- ----- -------- ------------ ----------
/// 	       2    4     10        0     1    %parm(1)        1
/// 	       2   12      2        0     1    %parm(2)        1
/// 	
/// 	    Objects:
/// 	
/// 	    Column Name    Extent    ExportCall
/// 	    -----------    ------    ----------
/// 	    %%ID        Sample.Person    %QuickLoad^Sample.Person.T1(%rowid,%nolock,0,0,1)
/// 	SAMPLES>
/// 	</pre>
/// 	<p>
/// 	You can execute a successfully prepared statement repeatedly. This is most useful when the statement includes parameters, where a parameter is defined in the SQL statement source by a question mark (&ldquo;?&rdquo;). A statement may include an arbitrary number of parameters. (There are system limitations that limit the number of dynamic parameters; this limit varies but up to 200 should work with most Cach&eacute; versions.)
/// 	</p>
/// 	<p>
/// 	The %Execute() method accepts parameter values in the order in which they appear in the source statement.  For example:
/// 	</p>
/// 	<pre>
/// 	   SAMPLES>set tSQL=3
/// 	
/// 	   SAMPLES>set tSQL(1)="select %ID as id,Name,DOB,Home_State"
/// 	
/// 	   SAMPLES>set tSQL(2)="from Person where Age > ? and Home_State = ?"
/// 	
/// 	   SAMPLES>set tSQL(3)="order by 2"
/// 	
/// 	   SAMPLES>set tStatus = tStatement.%Prepare(.tSQL)
/// 	
/// 	   SAMPLES>set tResult = tStatement.%Execute(80,"VT")
/// 	
/// 	   SAMPLES>do tResult.%Display()
/// 	   id     Name                DOB           Home_State
/// 	   140    Hanson,James K.     04/02/1928    VT
/// 	
/// 	   1 Rows(s) Affected
/// 	   SAMPLES>set tResult = tStatement.%Execute(50,"VT")
/// 	
/// 	   SAMPLES>do tResult.%Display()
/// 	   id     Name                DOB           Home_State
/// 	   3      Eagleman,Emilio N.  09/01/1946    VT
/// 	   140    Hanson,James K.     04/02/1928    VT
/// 	   167    Hertz,Keith O.      01/01/1952    VT
/// 	
/// 	   3 Rows(s) Affected
/// 	   SAMPLES>
/// 	   </pre>
/// 	<p>
/// 	You can also use the same statement object for many different statements by simply invoking %Prepare() with the new statement. This is because %Prepare() initializes the statement&rsquo;s execution plan and metadata.  Also, an arbitrary number of statement objects can coexist in the same process.
/// 	</p>
/// 	<p>
/// 	You can also prepare and execute dynamic SQL statements by calling %ExecDirect(). This method prepares the statement and, if it prepares the statement successfully, executes it with the supplied argument values. An optional by-reference parameter returns an instance of %SQL.Statement; this instance contains the currently prepared statement. You can then execute that statement instance just as if it had been instantiated by invoking %New() followed by a call to %Prepare(). You can also use that statement instance to prepare other dynamic statements just as if it were instantiated by %New().
/// 	</p>
/// 	<p>
/// 	If an error occurs during either statement preparation or execution, then the error is described in the result object properties of %SQLCODE and %Message. Always check the result property %SQLCODE for an error following %Execute() and %ExecDirect().
/// 	</p>
/// 	<pre>
/// 	   SAMPLES>set tResult = ##class(%SQL.Statement).%ExecDirect(.tStatement,"select name,age from Sample.Person where age > ? and home_state = ?",50,"VT")
/// 	
/// 	   SAMPLES>write tResult.%SQLCODE
/// 	   0
/// 	   SAMPLES>do tResult.%Display()
/// 	   Name                  Age
/// 	   Eagleman,Emilio N.    62
/// 	   Hanson,James K.       81
/// 	   Hertz,Keith O.        57
/// 	
/// 	   3 Rows(s) Affected
/// 	
/// 	   SAMPLES>write tStatement
/// 	
/// 	   1@%SQL.Statement
/// 	
/// 	   SAMPLES>set tResult = tStatement.%Execute(40,"AK")
/// 	
/// 	   SAMPLES>do tResult.%Display()
/// 	   Name                  Age
/// 	   Finn,Quentin O.       66
/// 	
/// 	   1 Rows(s) Affected
/// 	
/// 	   SAMPLES>
/// 	</pre>
/// 	</body>
/// 	</example> 
Class %SQL.Statement Extends %Library.RegisteredObject [ ClientDataType = HANDLE, Final, System = 4 ]
{

/// <property>%Dialect</property> defines the SQL dialect used to prepare dynamic SQL statements. Valid values are
/// CACHE, MSSQLSERVER, MSSQL, and SYBASE. The default is CACHE. Support for MSSQLSERVER and SYBASE dialects is limited
/// to a subset of the TSQL grammar supported by the Cache TSQL language mode.
Property %Dialect As %String;

Method %DialectSet(pValue As %String = "") As %Status
{
	if pValue = i%%Dialect quit $$$OK
	set tDialect = $ListFind($$$SQLDIALECTDYNAMICUPPER,$zconvert(pValue,"U"))
	if tDialect { set i%%Dialect = $ListGet($$$SQLDIALECTDYNAMIC,tDialect) quit $$$OK } else { quit $$$ERROR($$$GeneralError,"Invalid dynamic statement Dialect mode: '"_pValue_"'") }
}

/// %ObjectSelectMode allows the user to specify how columns whose type class is a swizzleable class
/// will be defined in the result set class generated from a SELECT statement. If %ObjectSelectMode
/// is false (the default) then the property corresponding to the swizzleable column will be defined
/// in result sets as a simple literal type corresponding to the SQL table's ROWID type.
/// If %ObjectSelectMode is true then the property will be defined with the columns declared type. That
/// means that accessing the result set property will trigger swizzling.
Property %ObjectSelectMode As %Library.Boolean [ InitialExpression = 0 ];

/// <p>%SchemaPath provides a list of schema names for resolving unqualified 
/// names during statement preparation. By default, its value is null; to set 
/// its value, use a comma-delimited list of schema names:</p>
/// 
/// <pre>
/// Set %SQL.Statement.%SchemaPath = "My_Schema,Your_Schema,DEFAULT_SCHEMA"
/// </pre>
/// 
/// <p>This is equivalent to the macro-preprocessor directive for embedded 
/// SQL:</p>
/// 
/// <pre>
/// #sqlcompile PATH = My_Schema,Your_Schema,DEFAULT_SCHEMA
/// </pre>
/// 
/// <p>PATH is a search path: if the unqualified name is found in a schema 
/// in the PATH, then this schema is used to qualify the name and no further 
/// searching is performed.<p>
/// 
/// <p>You can set the value of %SchemaPath at any time, but it is only used 
/// by the %Prepare method.</p>
/// 
/// <p>%SchemaPath can contain special schema name tokens that are resolved 
/// by the SQL compiler. Special tokens are:</p>
/// 
/// <ul>
/// <li>CURRENT_SCHEMA is the current default schema. If the <class>%SQL.Statement</class> 
/// call is defined in a class method, CURRENT_SCHEMA is 
/// the  schema mapped to the current class package. If the statement is 
/// defined in a .MAC routine, CURRENT_SCHEMA is the configuration default 
/// schema.</li>
/// <li>CURRENT_PATH is the currently defined schema search path. You can 
/// use this to add an additional schema to the search path while retaining 
/// the current search path.</li>
/// <li>DEFAULT_SCHEMA specifies the use of the system-defined default 
/// schema.</li>
/// </ul>
/// 
/// <p>You can also set %SchemaPath to a PATH value that is constructed from 
/// a given class definition; simply set %SchemaPath to 
/// ##class(%SQL.Statement).%ClassPath(classname).</p>
Property %SchemaPath As %String(MAXLEN = "");

/// This property is set on instantiation to the current select mode as returned by $system.SQL.GetSelectMode(). It
/// can be set directly by the user. It is used by the statement object to establish the
/// SQL SELECTMODE value used by dynamic statements.
/// <br>
/// Possible values are:
/// <ul>
/// <li> 0 for LOGICAL mode.</li>
/// <li> 1 for ODBC mode.</li>
/// <li> 2 for DISPLAY mode.</li>
/// </ul>
Property %SelectMode As %Library.String [ InitialExpression = {$zu(115,5)} ];

/// %StatementActualArgs are the actual values bound to formal statement arguments.
/// This value is established during %Prepare from the %StatementArgs value. This value is used
/// to form the actual arguments passed when executing the currently prepared statement. The value
/// of %StatementActualArgs includes and literals and host variables replaced during preparsing
/// as well as the local variables used to hold actual parameter values passed to %Execute. We use
/// two types of locals - %parm(parameter_ordinal_position) for non-CALL statements and
/// parm_parameter_ordinal_position (for example, parm1 for the first '?') for CALL statements.
/// The reason for the difference is that we need to preserve 'undefinedness' of parameters passed
/// to SQL invoked routines.
Property %StatementActualArgs As %String(MAXLEN = "") [ Internal, Private ];

/// At prepare time, %CallArgs is initialized to the literals and host vars (argtype C, V) with gaps left for the ?-args.
/// NOT USED ANYMORE (DPV4449)
Property %CallArgs As %String(MAXLEN = "") [ Internal, MultiDimensional ];

/// This is an array of ?-args - base is the number of qArgs, %CallQArgs(arg#) = argument position
/// At execute time, this array is used to populate the ?-arg values. This work is done in bindArguments 
/// which returns an array of arguments suitable for passing using byref array syntax. This has two primary 
/// benefits - first of all, we can execute the statement directly instead of using $xecute. Second of all 
/// there is no limit to the number of arguments we pass.
Property %CallQArgs As %Integer [ Internal, MultiDimensional, Private ];

Property %HostVars As %Integer [ Internal, MultiDimensional, Private ];

/// This property is used to set %msqlvars during the compilation of the cached query.  
/// If defined, %msqlvars will be placed into the cached query methods as
/// 		#EXECUTE set %msqlvar=<%msqlvar>
Property %msqlvar As %String [ Internal ];

Method bindArguments(ByRef pActual As %String(MAXLEN=""), ByRef %CallArgs As %String) As %Integer [ Internal, Private ]
{
		#; First populate %CallArgs with any i%%CallArgs that may have been defined in prepare()
		#; From this point forward we use %CallArgs instead of <%SQL.Statement-Object>.%CallArgs because in the cached query the oref.%CallArgs references are too expensive :(
	merge %CallArgs = i%%CallArgs
	set tQCount = i%%CallQArgs, tVCount = i%%HostVars
	quit:'(tQCount+tVCount)
	set tStatementType = i%%StatementType
	if i%%StatementType '= 45 {
		for tPtr = 1:1:tQCount { if '$data(pActual(tPtr),%CallArgs(i%%CallQArgs(tPtr))) { throw ##class(%Exception.SQL).CreateFromSQLCODE(-400,"Invalid Dynamic Statement Parameter") } }
		for tPtr = 1:1:tVCount { set %CallArgs(i%%HostVars(tPtr)) = $Get(@($List(i%%StatementActualArgs,i%%HostVars(tPtr)*2))) }
	}
	else {
		for tPtr = 1:1:tQCount { merge %CallArgs(i%%CallQArgs(tPtr))=pActual(tPtr) }
	}
}

/// statementArgs are literals, host variables (not supported here), and parameters (as ?)
/// This value is established during preparsing and is a $list consisting of n*2 elements
/// where 'n' is the number of arguments discovered by the preparser. For a non-empty list,
/// the first element of the list is the argType and the second is the argValue for the first
/// argument discovered. This structure repeats for each argument. Arguments are either constants,
/// (argType = 'C', argValue is a literal), host variables (argType = 'V', argValue
/// is a legal COS identifier), or replacable parameter (argType = '?', argValue = '?').
/// This value is processed during %Prepare to construct the %StatementActualArgs value. This value
/// is retained for metadata reporting as the actual statement prepared might have a different formal
/// argument specification.
Property %StatementArgs As %String(MAXLEN = "") [ Internal, Private ];

Property %StatementArgCount As %Integer [ InitialExpression = 0, Internal, Private ];

Property %PreparedStatement As %ObjectHandle [ Internal, Private ];

Method %PreparedStatementSet(pPS As %ObjectHandle) As %Status [ ServerOnly = 1 ]
{
	try {
		if i%%PreparedStatement'="",i%%PreparedStatement'=pPS {	// if a new prepared statement and the old prepared statement was not NULL
			if (i%%StatementType>6 && (i%%StatementType<20)) || (i%%StatementType>25) {	// AutoPurge statement (same as xDBC cached queries as defined in Compile^%SYS.SQLSRV)
				do PurgeRtn^%SYS.SQLSRV($classname(i%%PreparedStatement))
			   }
			}
	}
	catch {}	// Don't care is Purge failed, just continue on
	set i%%PreparedStatement=pPS
	Quit $$$OK
}

Property %StatementGUID As %Binary [ Internal, Private ];

Property %StatementHash As %Binary [ Internal, Private ];

/// %Metadata is the statement descriptor. It is an instance of <class>%SQL.StatementMetadata</class>.
Property %Metadata As %SQL.StatementMetadata;

/// Internal property containing the actual SQL statement submitted to prepare().
Property %StatementText As %String(MAXLEN = "") [ Internal, MultiDimensional, Private ];

/// <p>Integer value indicating the type of statement.</p>
/// <table>
/// 	<tr><td>1</td><td>SELECT</td></tr>
/// 	<tr><td>2</td><td>INSERT (also 'INSERT OR UPDATE')</td></tr>
/// 	<tr><td>3</td><td>UPDATE</td></tr>
/// 	<tr><td>4</td><td>DELETE</td></tr>
/// 	<tr><td>5</td><td>COMMIT</td></tr>
/// 	<tr><td>6</td><td>ROLLBACK</td></tr>
/// 	<tr><td>7</td><td>GRANT</td></tr>
/// 	<tr><td>8</td><td>REVOKE</td></tr>
/// 	<tr><td>9</td><td>CREATE TABLE</td></tr>
/// 	<tr><td>10</td><td>ALTER TABLE</td></tr>
/// 	<tr><td>11</td><td>DROP TABLE</td></tr>
/// 	<tr><td>12</td><td>CREATE VIEW</td></tr>
/// 	<tr><td>13</td><td>ALTER VIEW</td></tr>
/// 	<tr><td>14</td><td>DROP VIEW</td></tr>
/// 	<tr><td>15</td><td>CREATE INDEX</td></tr>
/// 	<tr><td>16</td><td>ALTER INDEX (Not supported)</td></tr>
/// 	<tr><td>17</td><td>DROP INDEX</td></tr>
/// 	<tr><td>18</td><td>CREATE ROLE</td></tr>
/// 	<tr><td>19</td><td>DROP ROLE</td></tr>
/// 	<tr><td>20</td><td>SET TRANSACTION</td></tr>
/// 	<tr><td>21</td><td>START TRANSACTION</td></tr>
/// 	<tr><td>22</td><td>%INTRANSACTION</td></tr>
/// 	<tr><td>23</td><td>%BEGTRANS (Alias for START TRANSACTION)</td></tr>
/// 	<tr><td>24</td><td>%INTRANS (Alias for %INTRANSACTION)</td></tr>
/// 	<tr><td>25</td><td>GET (Not supported)</td></tr>
/// 	<tr><td>26</td><td>SET OPTION</td></tr>
/// 	<tr><td>27</td><td>STATISTICS (UPDATE STATISTICS, not supported))</td></tr>
/// 	<tr><td>28</td><td>%CHECKPRIV</td></tr>
/// 	<tr><td>29</td><td>CREATE USER</td></tr>
/// 	<tr><td>30</td><td>ALTER USER</td></tr>
/// 	<tr><td>31</td><td>DROP USER</td></tr>
/// 	<tr><td>32</td><td>%CHECKPRIV (SQL Admin Privilege)</td></tr>
/// 	<tr><td>33</td><td>GRANT (SQL Admin Privilege)</td></tr>
/// 	<tr><td>34</td><td>REVOKE (SQL Admin Privilege)</td></tr>
/// 	<tr><td>35</td><td>CREATE FUNCTION</td></tr>
/// 	<tr><td>36</td><td>CREATE METHOD</td></tr>
/// 	<tr><td>37</td><td>CREATE PROCEDURE</td></tr>
/// 	<tr><td>38</td><td>CREATE QUERY</td></tr>
/// 	<tr><td>39</td><td>DROP FUNCTION</td></tr>
/// 	<tr><td>40</td><td>DROP METHOD</td></tr>
/// 	<tr><td>41</td><td>DROP PROCEDURE</td></tr>
/// 	<tr><td>42</td><td>DROP QUERY</td></tr>
/// 	<tr><td>43</td><td>CREATE TRIGGER</td></tr>
/// 	<tr><td>44</td><td>DROP TRIGGER</td></tr>
/// 	<tr><td>45</td><td>CALL</td></tr>
/// 	<tr><td>46</td><td>SAVEPOINT</td></tr>
/// 	<tr><td>47</td><td>LOCK TABLE</td></tr>
/// 	<tr><td>48</td><td>UNLOCK TABLE</td></tr>
/// 	<tr><td>49</td><td>CREATE DATABASE</td></tr>
/// 	<tr><td>50</td><td>DROP DATABASE</td></tr>
/// 	<tr><td>51</td><td>USE DATABASE</td></tr>
/// 	<tr><td>99</td><td>Anything not list above</td></tr>
/// </table>
Property %StatementType As %Integer [ Internal, Private ];

/// Prepare and execute an SQL statement. If no statement handle is allocated in pHStatement then a new statement handle will be
/// allocated and returned by reference. That behavior is different from SQLPrepare.
/// Formal Parameters:
/// pHStatement		-	OPTIONAL (byref) the statement handle. If an actual arg is passed by reference then it will be populated with an oref to a new
/// 						statement object;
/// pStatementText	-	(byref) SQL statement text. This can be an array of SQL statement lines with the base node set to the number of lines or
/// 					-	it can be a single string;
/// %parm...		-	variable number of arguments that represent the values to be bound to parameters contained in <var>pStatementText</var>.
/// 						only parameters with input direction (input or input-output) are actually used but a position for each '?' contained in
/// 						<var>pStatementText</var> needs to be represented. In the statement:
/// 								? = call Sample.PersonSets(?,?)
/// 						the %parms... list must contain an empty position for the return value. An example of a call to %ExecDirect for such a
/// 						statement is:
/// 								set tResult = ##class(%SQL.Statement).%ExecDirect(.tStatement,"?=call Sample.PersonSets(?,?)",,"A","NY")
/// 						In this example, the return value is allocated a position in the %parms list (the ,,), "A" is bound to the first argument passed
/// 						to Sample.PersonSets and "NY" is bound to the second.
/// 
/// This method returns a %SQL.StatementResult object.
ClassMethod %ExecDirect(ByRef pHStatement As %SQL.Statement = {$$$NULLOREF}, ByRef pStatementText As %CacheString = "", %parm...) As %SQL.StatementResult [ PublicList = SQLCODE ]
{
	new %tResult, %tStatement,SQLCODE
	if '$isobject(pHStatement) { set pHStatement = ..%New() }
	try {
		do pHStatement.prepare(.pStatementText)
		set tResult = pHStatement.%Execute(%parm...)
	}
	catch tException {
		$$$ISEXCEPTIONINTERRUPTTHROW(tException)
		set tResult = ##class(%SQL.StatementResult).%New()
		if tException.%IsA("%Exception.SQL") { set tResult.%SQLCODE = tException.Code,tResult.%Message = tException.Data }
		elseif (tException.Name = "<UNDEFINED>") && (($Extract(tException.Data,1,6) = "%parm(")) { set tResult.%SQLCODE = -400, tResult.%Message = "Invalid Dynamic Statement Parameter" }
		else { set tResult.%SQLCODE = -400, tResult.%Message = "Exception caught during dSQL statement %Execute: "_tException.Data }
	}
#; TODO: We continue to have a split error reporting personality and we are losing error info here. Let's standardize error reporting!!
	quit tResult
}

/// Prepare an SQL statement. Pass the statement as a simple string or an array of lines with the root containing the number of lines.
/// A comma delimited list of packages can also be passed. This list of packages will be used to qualify any unqualified names referenced
/// in the statement source. This method returns a %Status value.
Method %Prepare(ByRef pStatementText As %CacheString = "") As %Status
{
#dim tException as %Exception.AbstractException
	set tStatus = $$$OK
	try { do ..prepare(.pStatementText) }
	catch tException {
		set tStatus = tException.AsStatus()
		$$$ISINTERRUPTTHROW(tStatus)
	}
	quit tStatus
}

/// %PrepareClassQuery will generate the appropriate CALL statement for invoking a class query. That generated
/// statement is then %Prepare'd and, if successful, the statement can be executed by invoking %Execute. All parameters
/// defined in the formal specification of the query are assigned place holder '?' in the generated CALL statement.
/// Actual values for those parameters can be passed in the %Execute() call. %Metadata is available after a successful
/// prepare.  Because %PrepareClassQuery generates a CALL statement, the executed class query must have the SqlProc keyword set to True.
/// Class queries defined with SqlProc = False cannot be called by %PrepareClassQuery.
Method %PrepareClassQuery(pClassName As %String = "", pQueryName As %String = "") As %Library.Status
{
	set tStatus = $$$OK
	try {
		set pClassName=$$$NormalizeClassname(pClassName)
		if (pClassName = "") || (pQueryName = "") || ('$$$comMemberDefined(pClassName,$$$cCLASSquery,pQueryName)) { throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$QueryDoesNotExist,pClassName_":"_pQueryName)) }
		Set tSchemaName=$$$comClassKeyGet(pClassName,$$$cCLASSsqlschemaname)
		$$$comMemberKeyGetLvar(tProcedureName,pClassName,$$$cCLASSquery,pQueryName,$$$cQUERYsqlname)
		set tIsProjected = $$$comMemberKeyGet(pClassName,$$$cCLASSquery,pQueryName,$$$cQUERYsqlproc)
		$$$comMemberKeyGetLvar(tFormalSpec,pClassName,$$$cCLASSquery,pQueryName,$$$cQUERYformalspecparsed)
		if $ListLength(tFormalSpec) {
			set tStatementText = "call " _ tSchemaName _ "." _ tProcedureName _ "(?"
			for tPtr = 2:1:$ListLength(tFormalSpec) { set tStatementText = tStatementText _ ",?" }
			set tStatementText = tStatementText _ ")"
		}
		else { set tStatementText = "call " _ tSchemaName _ "." _ tProcedureName _ "()" }		
		do ..prepare(.tStatementText)
	}
	catch tException {
		set tStatus = tException.AsStatus()
		$$$ISINTERRUPTTHROW(tStatus)
	}
	quit tStatus
}

/// prepare() is an internal method that does the actual work of preparing a statement.
/// This method throws an exception if any error is encountered.
Method prepare(ByRef pStatementText As %CacheString = "") [ Internal ]
{
#DEFINE Hash(%a) $system.Encryption.Base64Encode($system.Encryption.SHA1Hash(%a))
#define CachedQueryVersion      8
#define quoter(%val)	$s(%val'=+%val:$s(%val=$char(0):"$c(0)",1:$zu(144,1,%val)),1:""""_%val_"""")

	new %ROWID, %ROWCOUNT, %tResult, %msg
#; 0) Initialize the allocated statement and normalize the input arguments
		#; Set %PreparedStatement first before %StatementType because %PreparedStatement needs to see the value of %StatementType to determine
		#; if we need to auto-Purge the previous cached statement.
	set ..%StatementActualArgs = "", ..%StatementArgs = "", ..%StatementArgCount = 0, ..%PreparedStatement = "", ..%StatementType = "", ..%Metadata = "", ..%StatementHash = ""
	kill ..%CallQArgs, ..%CallArgs s i%%CallQArgs=0, i%%CallArgs=0
	kill ..%StatementText
	merge ..%StatementText = pStatementText
		#; Replace schema tokens with actual values now as they need to be fixed for the prepare. The statement implementation is static with regards to path.
	if ..%SchemaPath '= "" {
		set tCurrentPath = $Select($Data(%sqlSchemaPath):$ListToString(%sqlSchemaPath),1:"")
		set tSchemaPath = $$$UPPER(..%SchemaPath)
		for tPtr = 1:1:$l(tSchemaPath,",") {
			set tSchema=$p(tSchemaPath,",",tPtr)
			if tSchema = "" { throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$SqlCompileBadMode)) }
			elseif tSchema="CURRENT_PATH" { set $p(tSchemaPath,",",tPtr) = tCurrentPath }
#; TODO: How do we determine the code container? It is either contextless (server based or command line based), in a routine or in a class. We are only interested
#; 		if we are in a class. This code, from the MPP, knows the code container:
			elseif tSchema="CURRENT_SCHEMA" { set $p(tSchemaPath,",",tPtr) = $s($g(%classname)'="":$$$UPPER($$DetermineSchemaName^%qarmac(%classname)),1:$$$DEFAULTSCHEMA) }
			elseif tSchema = "DEFAULT_SCHEMA" { set $p(tSchemaPath,",",tPtr) = $$$DEFAULTSCHEMA }
		}
	}
	else { set tSchemaPath = "" }
	new %sqlSchemaPath set %sqlSchemaPath = $ListFromString(tSchemaPath)
#; 1) Preparse the statement to normalize it, extract literals, identify temporary tables used, and locate parameters.
		#;  We need to convert the query string into an array so SQL comments will work OK.
#; TODO (DLP20091215)	Do we use different preparsers for different dialect settings? Probably but not yet.
	if (..%Dialect = $$$SQLDIALECTDEFAULT) || ($$$UPPER(..%Dialect) = $$$SQLDIALECTCACHE) {

		set SQLCODE = ..preparse(.pStatementText,.tStatementPreparsed,.tStatementArgs)

		set ..%StatementActualArgs = tStatementArgs
		if $Get(SQLCODE)<0 { throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,$Get(%msg)) }
		set ..%StatementGUID = $SYSTEM.Util.CreateGUID()
			#; the following call will throw an exception if an error is detected...
		set ..%PreparedStatement = ##class(%SQL.DynamicStatement).Prepare(..%StatementGUID,tStatementPreparsed,"",tSchemaPath,.tStatementHash,.tStatementType,..%ObjectSelectMode,..%Dialect,$this)
	}
		// Must be a Dialect other than Cache and we do not preparse in non-Cache Dialect mode
	else {
			// tStatementArgs is normally constructed as a result of preparsing. Non-Cache dialect statements are not preparsed
			// so we have to store this information in the statement cache and return it from Prepare. For now, there is no literal
			// replacement so formal arguments and actual arguments are the same lists.
			// the following call will throw an exception if an error is detected...
		set tStatementArgs = ""
		set ..%StatementGUID = $SYSTEM.Util.CreateGUID()
		set ..%PreparedStatement = ##class(%SQL.DynamicStatement).Prepare(..%StatementGUID,.pStatementText,"",tSchemaPath,.tStatementHash,.tStatementType,..%ObjectSelectMode,..%Dialect,$this)
		if $IsObject(..%PreparedStatement) { set tParameters = ..%PreparedStatement.#%statementparameters for tPtr = 1:1:$Listget(tParameters,1) { set tStatementArgs = tStatementArgs _ $ListBuild("?","?") } }
		set ..%StatementActualArgs = tStatementArgs

		if ..%StatementType = 45 {
			set tExecuteArgs = "",qcount=0 For ptr=1:2:$ListLength(tStatementArgs) s tArgType=$li(tStatementArgs,ptr),tArgVal=$li(tStatementArgs,ptr+1),arg = $Case(tArgType,"?":".parm"_$Increment(qcount)_"","c":$$$quoter(tArgVal),"v":"."_tArgVal,:"") s tExecuteArgs = tExecuteArgs_arg_","
			set $Extract(tExecuteArgs,$Length(tExecuteArgs)) = ""
			set ..%StatementArgs = tExecuteArgs, ..%StatementArgCount = qcount
		}
	}
	set ..%StatementHash = tStatementHash
		#; If this is a statement type not recognized by the simple three character extract of the first token, just set it to 99 - we don't really care
		#; since we only want to know SELECT, CALL, and everything else. If we store the statement type in the implementation class then we can get more
		#; precise info.
	if tStatementType { set ..%StatementType = tStatementType } else { set ..%StatementType = 99 }
		#; And store the results of prepare in the dynamic statement object:
		#; Construct the execute actual argument string
	s tElemCount=$ll(tStatementArgs),qcount=0,tArgCount=0,vcount=0 
	for ptr=1:2:tElemCount {
		set tArgCount=tArgCount+1,tArgType=$li(tStatementArgs,ptr),tArgVal=$li(tStatementArgs,ptr+1)
		if tArgType="?" { s qcount=qcount+1 s i%%CallQArgs(qcount)=tArgCount } 
		elseif tArgType="c" { s i%%CallArgs(tArgCount)=tArgVal } 
		elseif tArgType="v" { s vcount=vcount+1,i%%HostVars(vcount)=tArgCount } 
		else { }
	}
	s i%%CallArgs=tArgCount,i%%CallQArgs=qcount,i%%HostVars=vcount
	quit
}

/// prepareForServer() is an internal method that is called by the xDBC server.
/// It constructs metadata specific to the server and populates the server statement object.
/// (%qsc(%qacn) is where the server "statement object" is kept).
/// **NOTE** THIS METHOD IS INTERNAL, ISC USE ONLY!!
Method prepareForServer(ByRef pServerStatement As %Binary, pStatementHandle As %Integer = 0, ByRef pMetadata As %Binary = "") [ Internal ]
{
	// This is a partial server statement object definition (from %SYS.DBSRV.inc):
#DEFINE RoutineName             pServerStatement(pStatementHandle)
#DEFINE SPClassName             pServerStatement(pStatementHandle,5)
#DEFINE SPName                  pServerStatement(pStatementHandle,6)
#DEFINE SPExecString            pServerStatement(pStatementHandle,7)
#DEFINE RoutineTimestamp        pServerStatement(pStatementHandle,8)
#DEFINE PrivilegeInfo           pServerStatement(pStatementHandle,10)
#DEFINE SPHandle                pServerStatement(pStatementHandle,11)
#DEFINE SPContext               pServerStatement(pStatementHandle,12)
#DEFINE ParameterDirection      pServerStatement(pStatementHandle,18)
#DEFINE ParameterObjectCategory pServerStatement(pStatementHandle,20)
#DEFINE SPPrivilegeParam        pServerStatement(pStatementHandle,23)
#DEFINE StaticCursor            pServerStatement(pStatementHandle,24)
#DEFINE SPInputParmLen          pServerStatement(pStatementHandle,25)

		// We might consider optimizing this later. This method is only called when the server is executing in a "dialect" mode
		// and the metadata is wired to a specific form - interface = -1, parameters only on prepare and so on.
	// set pMetadata = $Listbuild(-1) _ ..%Metadata.getParameterMetadata()
	set pMetadata = ..%Metadata.getParameterMetadata()
	set $$$RoutineName = $$$nameClassRoutineNameGet($classname(..%PreparedStatement),0)
	set $$$RoutineTimestamp = $Extract($Get(^rOBJ($$$RoutineName)),1,16)
	set $$$SPHandle = $this
}

ClassMethod preparse(ByRef pStatementText, ByRef pStatementPreparsed, ByRef pStatementArgs) As %Integer [ PublicList = SQLCODE ]
{
#define NL                 $c(13,10)
#define InSingleQuotes(%s,%p) ($L($E(%s,1,%p-1),"'")+1#2)
#define InDoubleQuotes(%s,%p) ($L($E(%s,1,%p-1),"""")+1#2)

	new SQLCODE
	set SQLCODE = 0
	do $system.Encryption.SHA1HashResult()

	if $Data(pStatementText) '> 2 {
		do $system.Encryption.SHA1HashInput(pStatementText)
		set tHash = $system.Encryption.Base64Encode($system.Encryption.SHA1HashResult())
		if '$Data(^||%isc.sqlppc(tHash),tPreparserResult) {
				// We can't lose any $c(13) or $c(10)'s that are part of a literal value.
				// So we will not replace any $$$NL that are within a '...' or "..."
				
			set tTemp=$select(pStatementText[$c(13):$$StringReplaceSQL^%SYS.DynamicQuery(pStatementText,$c(13)," ",1),1:pStatementText)
			set tPos=0,sqlinput=0
			for tPtr=1:1 {
				set tPos=$find(tTemp,$c(10),tPos)
				if 'tPos { set sqlinput=sqlinput+1,sqlinput(sqlinput)=$e(tTemp,tPos,*) quit  }	// no [more] found
				continue:$$$InSingleQuotes(tTemp,tPos)			// skip if within '...'
				continue:$$$InDoubleQuotes(tTemp,tPos)			// skip if within "..."
				set sqlinput=sqlinput+1,sqlinput(sqlinput)=$e(tTemp,1,tPos-2),tTemp=$e(tTemp,tPos,*),tPos=0
			}

			set tPreparserResult = $$preparse^%qaqpreparser(.sqlinput)
			if (tPreparserResult '= "") && ('SQLCODE) {
				kill:$Increment(^||%isc.sqlppc)>1000 ^||%isc.sqlppc
				set ^||%isc.sqlppc(tHash) = tPreparserResult
			}
			else { set tPreparserResult = "" }
		}
	}
	else {
		for tPtr = 1:1:pStatementText { do $system.Encryption.SHA1HashInput(pStatementText(tPtr)_$$$NL) }
		set tHash = $system.Encryption.Base64Encode($system.Encryption.SHA1HashResult())
		if '$Data(^||%isc.sqlppc(tHash),tPreparserResult) {
			set tPreparserResult = $$preparse^%qaqpreparser(.pStatementText)
			if (tPreparserResult '= "") && ('SQLCODE) {
				kill:$Increment(^||%isc.sqlppc)>1000 ^||%isc.sqlppc
				set ^||%isc.sqlppc(tHash) = tPreparserResult
			}
			else { set tPreparserResult = "" }
		}
	}
	set pStatementPreparsed = $Listget(tPreparserResult,1), pStatementArgs = $Listget(tPreparserResult,2)
	quit SQLCODE
}

/// <p>Execute the current statement and return the result. The result of the execute is always the return value.
/// Success/Failure information is reported in the result object as %SQLCODE, %Message, %ROWCOUNT, and/or %ROWID.
/// </p>
/// <p>
/// The %Execute() method accepts parameter values in the order in which they appear in the source statement.  For example:
/// </p>
/// <pre>
///    SAMPLES>set tSQL=3
/// 
///    SAMPLES>set tSQL(1)="select %ID as id,Name,DOB,Home_State"
/// 
///    SAMPLES>set tSQL(2)="from Person where Age > ? and Home_State = ?"
/// 
///    SAMPLES>set tSQL(3)="order by 2"
/// 
///    SAMPLES>set tStatus = tStatement.%Prepare(.tSQL)
/// 
///    SAMPLES>set tResult = tStatement.%Execute(80,"VT")
/// 
///    SAMPLES>do tResult.%Display()
///    id     Name                DOB           Home_State
///    140    Hanson,James K.     04/02/1928    VT
/// 
///    1 Rows(s) Affected
///    SAMPLES>set tResult = tStatement.%Execute(50,"VT")
/// 
///    SAMPLES>do tResult.%Display()
///    id     Name                DOB           Home_State
///    3      Eagleman,Emilio N.  09/01/1946    VT
///    140    Hanson,James K.     04/02/1928    VT
///    167    Hertz,Keith O.      01/01/1952    VT
/// 
///    3 Rows(s) Affected
///    SAMPLES>
///    </pre>
/// <p>
/// You can also use the same statement object for many different statements by simply invoking %Prepare() with the new statement. This is because %Prepare() initializes the statement&rsquo;s execution plan and metadata.  Also, an arbitrary number of statement objects can coexist in the same process.
/// </p>
/// 	<p>
/// <table border=1>
/// <th>
/// Parameters
/// </th>
/// <tr>
/// 		<td>%parm...</td>
/// 		<td>Input</td>
/// 		<td>
/// 				<p>Variable number of arguments that represent the values to be bound to parameters contained in <var>pStatementText</var>.
/// 			only parameters with input direction (input or input-output) are actually used but the position of each '?' contained in
/// 				the source statement must be maintained.</p>
/// 				<p>An example of calling %Execute for a prepared statement "? = call Sample.PersonSets(?,?)" is:
/// 				<pre>
/// 	set tStatement = ##class(%SQL.Statement).%New()
/// 	set tStatus = tStatement.%Prepare("?=call Sample.PersonSets(?,?)")
/// 	set tResult = tStatement.%Execute(,"A","NY")
/// 				</pre>
/// 				<br>
/// 				In this example, the return value is allocated a position in the %parms list (the ','), "A" is bound to the first argument passed
/// 				to Sample.PersonSets and "NY" is bound to the second.
/// 		</td>
/// </tr>
/// </table>
/// </p>
/// <br>
/// 	<p>
/// 	<b>Return value</b>: This method returns a %SQL.StatementResult object.
/// </p>
Method %Execute(%parm...) As %SQL.StatementResult [ PublicList = SQLCODE ]
{
	try {
		set tResult = ..execute(%parm...)
	}
	catch tException {
		set tResult = ##class(%SQL.StatementResult).%New()
		set tResult.%StatementType = ..%StatementType
		$$$ISEXCEPTIONINTERRUPTTHROW(tException)
		if tException.%IsA("%Exception.SQL") { set tResult.%SQLCODE = tException.Code, tResult.%Message = tException.Data }
		elseif (tException.Name = "<UNDEFINED>") && (($Extract(tException.Data,1,6) = "%parm(")) { set tResult.%SQLCODE = -400, tResult.%Message = "Invalid Dynamic Statement Parameter" }
		else { set tResult.%SQLCODE = -400, tResult.%Message = "Exception caught during dSQL statement %Execute: "_tException.Name_$Select(tException.Data'="":" "_tException.Data,1:"") }
	}
	quit tResult
	// #endif ; DLP-	new SQLCODE, %ROWID, %ROWCOUNT, %objlasterror
}

Method execute(%parm...) As %SQL.StatementResult [ PublicList = SQLCODE ]
{
	new %CallArgs, SQLCODE, %ROWID, %ROWCOUNT, %objlasterror
	try {
		if $Isobject($Get(%sqlcontext)) {
			set tStatementContext = ##class(%ProcedureContext).%New()
			merge tStatementContext.%LTT = %sqlcontext.%LTT, tStatementContext.TTNI = %sqlcontext.TTNI, tStatementContext.PTT = %sqlcontext.PTT
			new %sqlcontext
			set %sqlcontext = tStatementContext
		}
		else { new %sqlcontext }
		if $Get(%parm) > i%%CallQArgs { throw ##class(%Exception.SQL).CreateFromSQLCODE(-400,"Dynamic SQL Execute, more parameter values passed than are specified in the dynamic statement") }
			// Update the select mode of the prepared statement object
		if ..%StatementType = 1 {
			set %objlasterror = ""
			do ..bindArguments(.%parm,.%CallArgs)
			set tResult = ..%PreparedStatement.%New(..%PreparedStatement,..%SelectMode,$this,.%CallArgs)
			if '$Isobject($Get(tResult)) { throw ##class(%Exception.StatusException).CreateFromStatus($Select($Get(%objlasterror)'="":%objlasterror,1:$$$ERROR($$$SQLCode,-400,"Unknown error, possibly related to $ZE: "_$ZE))) }
		}
		elseif ..%StatementType {
			try {
				set tSelectMode = $Zutil(115,5,..%SelectMode)
				if (..%Dialect = $$$SQLDIALECTDEFAULT) || (..%Dialect = $$$SQLDIALECTCACHE) || ('$Find("|45|99|",..%StatementType)) {
					do ..bindArguments(.%parm,.%CallArgs)
					set tResult = ..%PreparedStatement.%Execute($this,.%CallArgs)
					set tResult.%StatementType = ..%StatementType
				}
				else {
						// Not Cache Dialect - EXEC/CALL statement
					set tExecute = "q tPreparedStatement.%Execute("_..%StatementArgs_")"
					if $Get(%parm) {
						set tBindArgs = "", tNewArgs = "" 
						for tPtr = 1:1:$Get(%parm) { set tNewArgs = tNewArgs _ ",parm" _ tPtr, tBindArgs = tBindArgs _ ",parm"_tPtr_"=%parm("_tPtr_")" }
						set tExecute = "n "_$Extract(tNewArgs,2,*)_" m "_$Extract(tBindArgs,2,*)_" "_tExecute
					}
					set tResult = $Xecute("(tPreparedStatement) "_tExecute,..%PreparedStatement)
					if '$IsObject(tResult) { set tResult = ##class(%SQL.StatementResult).%New() set tResult.%SQLCODE = "-400", tResult.%Message = "Error occurred during SQL routine CALL" }
					set tResult.%StatementType = ..%StatementType
				}
				set tSelectMode = $Zutil(115,5,tSelectMode)
			}
				#; The purpose of this nested try/catch is simply to reset the selectmode $zu switch to the original
			catch tException {
				if $Get(tSelectMode) '= "" { set tSelectMode = $Zutil(115,5,tSelectMode) }
				throw tException
			}
		}
		else {
			throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$SQLCode,-400,"Statement not prepared"))
		}
	}
	catch tException {
		$$$ISEXCEPTIONINTERRUPTTHROW(tException)
		set tResult = ##class(%SQL.StatementResult).%New()
		set tResult.%StatementType = ..%StatementType
		if tException.%IsA("%Exception.SQL") { set tResult.%SQLCODE = tException.Code, tResult.%Message = tException.Data }
		elseif (tException.Name = "<UNDEFINED>") && (($Extract(tException.Data,1,6) = "%parm(")) { set tResult.%SQLCODE = -400, tResult.%Message = "Invalid Dynamic Statement Parameter" }
		else { set tResult.%SQLCODE = -400, tResult.%Message = "Exception caught during dSQL statement %Execute: "_tException.Name_$Select(tException.Data'="":" "_tException.Data,1:"") }
	}
	QUIT tResult
}

Method %MetadataGet() As %SQL.StatementMetadata [ Internal ]
{
	if (r%%Metadata = "") && ($IsObject(..%PreparedStatement)) {
		set tMDC = ..%PreparedStatement.#%statementmetadata
		for tPtr=0:1:tMDC { s tMetadata(tPtr) = $parameter(..%PreparedStatement,"%statementmetadata"_tPtr) }
		set r%%Metadata = ##class(%SQL.StatementMetadata).%New(..%StatementType,.tMetadata,..%PreparedStatement.#%statementparameters,..%PreparedStatement.#%statementobjects,..%StatementActualArgs,..%PreparedStatement.#%statementactual,..%PreparedStatement.#%statementmetadataext)
	}
	quit r%%Metadata
}

/// %OnClose will Purge the just used cached query for certain statement types, like DDL statements.
Method %OnClose() As %Status [ Internal, Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	try {
		if (..%StatementType>6 && (..%StatementType<20)) || ((..%StatementType>25) && (..%StatementType '= 45)) {	// AutoPurge statement (same as xDBC cached queries as defined in Compile^%SYS.SQLSRV)
			do PurgeRtn^%SYS.SQLSRV(..%PreparedStatement.%PackageName()_"."_..%PreparedStatement.%ClassName())
		   }
	}
	catch {}	// Don't care if Purge got an error
	Quit $$$OK
}

/// %OnNew accepts three optional parameters, the values of these three parameters are the initial values of %SelectMode, %SchemaPath and %Dialect.
Method %OnNew(pSelectMode As %CacheString = "", pPath As %CacheString = "", pDialect As %CacheString = "") As %Status [ Internal, Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	if pSelectMode '= "" { set ..%SelectMode = pSelectMode }
	if pPath '= "" { set ..%SchemaPath = pPath }
	if pDialect '= "" { set ..%Dialect = pDialect }
	Quit $$$OK
}

/// %Display() - display the details of the currently prepared statement.
Method %Display()
{
	if $IsObject(..%PreparedStatement) {
		write !,"Implementation class: ",$classname(..%PreparedStatement)
		write !,"           Arguments: "
		if ..%StatementActualArgs '= "" {
			write $List(..%StatementActualArgs,2)
			for tPtr = 4:2:$ListLength(..%StatementActualArgs) { write ",",$List(..%StatementActualArgs,tPtr) }
		}
		else { write "<<none>>" }
		write !,"      Statement Text: "
		if $Get(..%StatementText) = +$Get(..%StatementText) {
			for tPtr = 1:1:..%StatementText { write !,$Char(9),..%StatementText(tPtr) }
		}
		else { write ..%StatementText }
	}
	else { write "No statement currently prepared",! }
	write !
}

/// <p>
/// %GetImplementationDetails() - returns the details of the currently prepared statement.
/// This method returns the implementation class, the statement text and the actual arguments bound to
/// formal statement arguments.
/// </p>
/// <p>
/// <table border="1" cellspacing="0" cellpadding="1">
/// 		<tr>
/// 			<td  nowrap><a><var>pClassName</var></a></td>
/// 			<td><a>contains the name of the current statement's implementation class.</a></td>
/// 		</tr>
/// 		<tr>
/// 			<td  nowrap><a><var>pStatementText</var></a></td>
/// 			<td><a>Contains the statement text. This variable is either a simple string or an array of strings where pStatementText is the number of lines and pStatementText(line) is a line of statement text.</a></td>
/// 		</tr>
/// 		<tr>
/// 			<td  nowrap><a><var><var>pArguments</var></var></a></td>
/// 			<td><a>A $list containing argument types and argument value in the form $list(arg1type, arg1value[, arg2type, arg2value...argNtype, argNvalue]).
/// 			There are three argument types - 'c' = constant, 'v' = host variable and '?' is a parameter. All three argument types are replaced by
/// 			? arguments during statement prepare to improve the efficiency of the statement cache. Only actual arguments of type '?' require a value
/// 			to be supplied when executing the statement.</a></td>
/// 		</tr>
/// 	</table><br/>
///  
///  
/// 	</p>
/// <p>
/// This method returns 1 for success and 0 for failure. This method fails when no statement has been prepared.
/// </p>
Method %GetImplementationDetails(Output pClassName As %Library.String(MAXLEN=300), Output pStatementText As %Library.String(MAXLEN=""), Output pArguments As %Library.List) As %Integer
{
	if $IsObject(..%PreparedStatement) {
		set pClassName = $classname(..%PreparedStatement)
		set pArguments = ..%StatementActualArgs
		kill pStatementText
		merge pStatementText = ..%StatementText
		set tReturn = 1
	}
	else { set tReturn = 0 }
	quit tReturn
}

/// %ClassPath returns the PATH string for a given class name. The PATH string is essentially the same
/// as a default schema that is determined from the compiled class. If no extra IMPORT or inheritance rules
/// are present, the default schema within a class context is determined from the class's package. IMPORT and
/// inheritance add additional items to the PATH.
ClassMethod %ClassPath(pClassName As %Library.String) As %Library.String(MAXLEN="")
{
	set tSchemaPath = $$DetermineSchemaName^%qarmac(pClassName)
	merge tImports = $$$comClassKeyRaw(pClassName,$$$cCLASSimportall)
	set tPackage = $Order(tImports(""))
	while tPackage '= "" {
		set tSchema = $g($$$PACKAGEsqlname(tPackage)) 
		if tSchema = "" {
			if tPackage = "User" { set tSchema="SQLUser" }
			else { set tSchema = $tr(tPackage,".","_") }
		}
		set tSchemaPath = tSchemaPath _ "," _ tSchema
		set tPackage = $Order(tImports(tPackage))
	}
	quit tSchemaPath
}

}
