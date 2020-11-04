Include %syConfig

/// This class allows you to modify and view the [SQL] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters, or use Object sytax to open and directly manipulate the config
/// objects.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.SQL).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("TCPKeepAlive")
/// Properties("TCPKeepAlive")=300
/// %SYS>s Properties("TCPKeepAlive")=200
/// %SYS>s Status=##Class(Config.SQL).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.SQL).Open()
/// %SYS>w Obj.TCPKeepAlive
/// 200
/// %SYS>s Obj.TCPKeepAlive=300
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.SQL Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// 1 - The table compiler omits the checks to see if the RowID field(s) are being updated.<br>
/// 0 - The checks are performed.
Property AllowRowIDUpdate As %Boolean [ InitialExpression = 0, Required ];

/// Set to 1 if queries on fields with non-null outliers often refer to the outlier.<br>
Property BiasQueriesAsOutlier As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if embedded SQL statements are retained as comments in the .INT code version of the routine.<br>
Property Comment As %Boolean [ InitialExpression = 1, Required ];

/// Set the flag that determines if SQL security is enabled. If SQL security is ON, all Caché SQL security is active. This means: Each user must specify a valid username and password when logging in through ODBC (or by setting the %msql variable directly); Privilege-based table/view security is active, and the user may only perform actions on a table or view they have been granted access to. If SQL Security is off: Any user may access SQL through ODBC, and may be prompted for a username/password but will not be validated; Privilege-based table/view security is suppressed, and user's may perform actions on tables and views to which they have not been given access.<br>
Property DBMSSecurity As %Boolean [ InitialExpression = 1, Required ];

/// Sets the flag which determines if a class created by a DDL CREATE TABLE statement defines a bitmap extent index for the class.
/// This setting only applies to classes created through DDL that do not also define an explicit IdKey index.
/// DDLDefineBitmapExtent=0 means a bitmap extent index will not be defined.
/// DDLDefineBitmapExtent=1 means a bitmap extent index will be defined, if possible.
Property DDLDefineBitmapExtent As %Boolean [ InitialExpression = 1, Required ];

/// Sets the flag which determines if a class created by a DDL CREATE TABLE statement is Final.<br>
/// DDLFinal=0 means the class created by the statement will not be defined as Final<br>
/// DDLFinal=1 means the class created by the statement will be defined as Final.<br>
Property DDLFinal As %Boolean [ InitialExpression = 1, Required ];

/// Set the flag that determines if an SQLCODE -30 error is returned when an attempt is made to DROP a non-existing table through DDL.<br>
Property DDLNo30 As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if an SQLCODE -201 error is returned when an attempt is made to CREATE a previously existing table through DDL.<br>
Property DDLNo201 As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if an SQLCODE -307 error is returned when an attempt is made to a primary key constraint to a table through DDL, when a primary key constraint already exists for that table.<br>
Property DDLNo307 As %Boolean [ InitialExpression = 0, Required ];

/// Setting this parameter to 'Yes' allows you to ADD a foreign key through DDL even if one with the same name already exists. Setting this parameter to 'No' disallows this action and returns an error code.<br>
Property DDLNo311 As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if an SQLCODE -315 error is returned when an attempt is made to DROP a non-existant constraint through DDL.<br>
Property DDLNo315 As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if an SQLCODE -324 error is returned when an attempt is made to CREATE a previously existing index through DDL.<br>
Property DDLNo324 As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if an SQLCODE -333 error is returned when an attempt is made to drop a non-existant index through DDL.<br>
Property DDLNo333 As %Boolean [ InitialExpression = 0, Required ];

/// 1 - any class compilation performed as a result of executing a DDL statement will compile the class with the "q" (sqlonly) flag.<br>
/// 0 - the "q" flag is not used. This is the default.
Property DDLSQLOnlyCompile As %Boolean [ InitialExpression = 0, Required ];

/// Sets the flag which determines if a class created by a DDL CREATE TABLE statement uses $Sequence for ID assignment.
/// The storage keyword IDFUNCTION can be defined as INCREMENT or SEQUENCE. This keyword value is used by the class compiler to determine 
/// which system function - $increment or $sequence - is to be used for assigning new ID values for a persistent class using default storage.
/// The default value for IDFUNCTION is INCREMENT, however the default behavior for classes defined through DDL is to define IDFUNCTION as SEQUENCE.
/// To configure the system to have classes created through DDL to define IDFUNCTION as INCREMENT, define DDLUseSequence=0.
/// To configure the system to have classes created through DDL to define IDFUNCTION as SEQUENCE, define DDLUseSequence=1.
Property DDLUseSequence As %Boolean [ InitialExpression = 1, Required ];

/// This setting provides the ability to define a default schema name other than SQLUser, the default. When an unqualified table name is encountered in an SQL statement (and there is no #import statement specified), the default schema will be used.  You may specify _CURRENT_USER for the default schema name if you wish to use the SQL username the process logged in as the name of the default schema. If the process has not logged in to SQL, SQLUser will be used as the default schema name.  You may also specify _CURRENT_USER/<default name>.  In this case, if the process has not logged in to SQL, <default name> will be used as the default schema name.  For example:  _CURRENT_USER/HMO will use HMO as the default schema if the process has not logged in to SQL.  This setting has nothing to do with the mappings between SQL schema names and the class package name, it only specifies the default schema.<br>
Property DefaultSchema As %String(MAXLEN = 128, MINLEN = 0) [ InitialExpression = "SQLUser", Required ];

/// Set the flag that determines if double quotes (") in an SQL statement are used for delimited (quoted) identifiers or string constants.  If "Yes", a double quoted string ("My String") will be considered an identifier within an SQL statement.  If "No", a double quoted string ("My String") will be considered a string literal within an SQL statement.<br>
Property DelimitedIds As %Boolean [ InitialExpression = 1, Required ];

/// Set the flag that determines whether a DDL DROP TABLE statement deletes the table's data.<br>
Property DropDelete As %Boolean [ InitialExpression = 1, Required ];

/// When an SQL Select statement is executed, forces all pending ECP requests to the DB-server.
/// On completion it guarantees that the client cache is in sync.
Property ECPSync As %Boolean [ InitialExpression = 0, Required ];

/// Allows/disallows extrinsic functions to be used in SQL statements through ODBC, JDBC, and Dynamic Query.<br>
Property ExtrinsicFunctions As %Boolean [ InitialExpression = 0, Required ];

/// Set the flag that determines if SQL DISTINCT optimization is turned on.  If true (the default) many SQL queries involving DISTINCT (and GROUP BY) 
/// 	will run much more efficiently by making better use of indices (if available). 
/// 	This is an optimization added in Cache 5.1.
/// 	The downside of this is that the values returned by such queries will be collated 
/// 	in the same way they are stored within the index (i.e., results may be in upper case). 
/// 	Some applications care about the case of values returned by such queries. 
/// 	If "Fast DISTINCT" is set to false (0), the SQL will revert to its pre-5.1 
/// 	behavior with regards to DISTINCT behavior.<br>
Property FastDistinct As %Boolean [ InitialExpression = 1, Required ];

/// Set the flag that determines whether a Primary Key constraint specified through DDL also<br>
/// becomes the IDKey index in the class definition or not. By default, the primary key does<br>
/// also become the idkey index. This generally gives better performance, but means that<br>
/// the Primary Key fields cannot be updated.<br>
Property IdKey As %Boolean [ InitialExpression = 1, Required ];

/// Modifies the DDL Identifier Translation mappings. This is for filtering/modifying valid SQL identifier characters when translating SQL identifiers into Objects identifiers. When converting an SQL identifier to an Objects identifier at DDL run-time, the characters in the 'From' list are converted to the characters in the 'To' list.<br>
Property IdTrxFrom As %String(MAXLEN = 256, MINLEN = 0) [ InitialExpression = {$$$DEFIdTrxFrom} ];

/// Modifies the DDL Identifier Translation mappings. This is for filtering/modifying valid SQL identifier characters when translating SQL identifiers into Objects identifiers. When converting an SQL identifier to an Objects identifier at DDL run-time, the characters in the 'From' list are converted to the characters in the 'To' list.<br>
Property IdTrxTo As %String(MAXLEN = 256, MINLEN = 0);

Property JavaClassPath As %SysPath(MAXLEN = 256, MINLEN = 0);

Property JavaHome As %String(MAXLEN = 256, MINLEN = 0);

/// Address for the JDBC Gateway.<br>
Property JDBCGatewayAddress As Config.Host(MAXLEN = 256, MINLEN = 0);

/// Optional JVM arguments to include in the command line when starting the JDBC Gateway.<br>
Property JDBCGatewayJVMArgs As %String(MAXLEN = 1024, MINLEN = 0);

/// Name of the JDBC Gateway log file.<br>
Property JDBCGatewayLog As %String(MAXLEN = 256, MINLEN = 0);

/// Port number for the JDBC Gateway.<br>
Property JDBCGatewayPort As %Integer(MAXVAL = 99999, MINVAL = 0) [ InitialExpression = 62972, Required ];

/// The value n is the lock threshold. This is the number of inserts, updates, or deletes for a single table
/// within a single transaction that will trigger a table-level lock when reached. For example, if the lock
/// threshold is 1000 and a process starts a transaction and then inserts 2000 rows, after the 1001st row is
/// inserted the process will attempt to acquire a table-level lock instead of continue to lock individual
/// rows. This is to help keep the lock table from becoming too full.
Property LockThreshold As %Integer [ InitialExpression = 1000, Required ];

/// Set the Lock Timeout for Caché locks made during execution of SQL statements.<br>
Property LockTimeout As %Integer(MAXVAL = 32767, MINVAL = 0) [ InitialExpression = 10, Required ];

/// Defines the MaxLen for ODBC fields of type VarChar.<br>
Property ODBCVarcharMaxlen As %Integer [ InitialExpression = 4096, Required ];

/// Defines what routine prefix name is used for cached query routines.<br>
Property Prefix As %String(MAXLEN = 24, MINLEN = 1) [ InitialExpression = "CacheSql", Required ];

/// Defines whether or not all class queries project as SQL Stored Procedures 
/// regardless of the query's SqlProc setting.<br>
/// Default is 0, only class queries defined with SqlProc=1 will project as 
/// Stored Procedures. When set to 1, all class queries will project as stored
/// procedures. When changing this setting, you must recompile the classes with 
/// the class queries in order for this change to have an affect.
Property QueryProcedures As %Boolean [ InitialExpression = 0, Required ];

/// For INSERT, UPDATE, and DELETE, setting this parameter to 'Yes' instructs Caché to validate the foreign key constraint. Setting this parameter to 'No' will bypass foreign key constraint checking.<br>
Property ReferentialChecks As %Boolean [ InitialExpression = 1, Required ];

/// Defines whether or not the source code (.MAC and .INT) is saved or not. The default is that no source code is saved. This setting is made on a per-system basis.<br>
Property SaveMAC As %Boolean [ InitialExpression = 0, Required ];

/// Set the TCP Keep Alive timeout for CachÃ© xDBC TCP connections.<br>
/// This is the number of seconds between keep alive-messages.  The default for this is 300 seconds (5 minutes).]]></Description>
Property TCPKeepAlive As %Integer [ InitialExpression = 300, Required ];

/// Set the default precision for the Time component of the value returned by the GETDATE(), CURRENT_TIME, and CURRENT_TIMESTAMP SQL Scalar functions.  The precision, the number of decimal places for the millisecond portion of the time value, has a default is 0, which means milliseconds are not returned in the values returned by the GETDATE(), CURRENT_TIME, and CURRENT_TIMESTAMP functions.<br>
Property TimePrecision As %Integer(MAXVAL = 9, MINVAL = 0) [ InitialExpression = 0, Required ];

/// Default date format for the SQL TO_DATE() function.<br>
Property TODATEDefaultFormat As %String(MAXLEN = 32, MINLEN = 1) [ InitialExpression = "DD MON YYYY", Required ];

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

Method %OnValidateObject() As %Status [ Internal ]
{
}

/// Called from %OnBeforeSave. Provides a way for a specific class to override the 
/// EMS.Restricted() check when the Instance is managed. Used when a few properties in
/// a class (like Config.SQL.JDBCGatewayPort) are not managed by EMS.
Method EMSAllowEdit(insert As %Boolean) As %Boolean [ Internal ]
{
}

Storage Default
{
<Data name="SQLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AllowRowIDUpdate</Value>
</Value>
<Value name="3">
<Value>Comment</Value>
</Value>
<Value name="4">
<Value>DBMSSecurity</Value>
</Value>
<Value name="5">
<Value>DDLNo30</Value>
</Value>
<Value name="6">
<Value>DDLNo201</Value>
</Value>
<Value name="7">
<Value>DDLNo307</Value>
</Value>
<Value name="8">
<Value>DDLNo311</Value>
</Value>
<Value name="9">
<Value>DDLNo315</Value>
</Value>
<Value name="10">
<Value>DDLNo324</Value>
</Value>
<Value name="11">
<Value>DDLNo333</Value>
</Value>
<Value name="12">
<Value>DDLSQLOnlyCompile</Value>
</Value>
<Value name="13">
<Value>DefaultSchema</Value>
</Value>
<Value name="14">
<Value>DelimitedIds</Value>
</Value>
<Value name="15">
<Value>DropDelete</Value>
</Value>
<Value name="16">
<Value>ExtrinsicFunctions</Value>
</Value>
<Value name="17">
<Value>FastDistinct</Value>
</Value>
<Value name="18">
<Value>IdKey</Value>
</Value>
<Value name="19">
<Value>IdTrxFrom</Value>
</Value>
<Value name="20">
<Value>IdTrxTo</Value>
</Value>
<Value name="21">
<Value>JavaClassPath</Value>
</Value>
<Value name="22">
<Value>JavaHome</Value>
</Value>
<Value name="23">
<Value>JDBCGatewayAddress</Value>
</Value>
<Value name="24">
<Value>JDBCGatewayLog</Value>
</Value>
<Value name="25">
<Value>JDBCGatewayPort</Value>
</Value>
<Value name="26">
<Value>LockThreshold</Value>
</Value>
<Value name="27">
<Value>LockTimeout</Value>
</Value>
<Value name="28">
<Value>ODBCVarcharMaxlen</Value>
</Value>
<Value name="29">
<Value>Prefix</Value>
</Value>
<Value name="30">
<Value>QueryProcedures</Value>
</Value>
<Value name="31">
<Value>ReferentialChecks</Value>
</Value>
<Value name="32">
<Value>SaveMAC</Value>
</Value>
<Value name="33">
<Value>TCPKeepAlive</Value>
</Value>
<Value name="34">
<Value>TimePrecision</Value>
</Value>
<Value name="35">
<Value>TODATEDefaultFormat</Value>
</Value>
<Value name="36">
<Value>ECPSync</Value>
</Value>
<Value name="37">
<Value>JDBCGatewayJVMArgs</Value>
</Value>
<Value name="38">
<Value>BiasQueriesAsOutlier</Value>
</Value>
<Value name="39">
<Value>DDLDefineBitmapExtent</Value>
</Value>
<Value name="40">
<Value>DDLFinal</Value>
</Value>
<Value name="41">
<Value>DDLUseSequence</Value>
</Value>
<Value name="42">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>configDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
