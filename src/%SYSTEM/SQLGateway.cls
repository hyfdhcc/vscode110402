/// The <class>%SYSTEM.SQLGateway</class> class provides an interface for managing 
/// Gateway connections.
/// <p>You can use it via the special <b>$system</b> object:
/// <example>
/// Do $system.SQLGateway.DropAll()
/// </example>
Class %SYSTEM.SQLGateway Extends Help [ Abstract, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/// Test a previously defined SQL Gateway connection. 
/// <p> It writes the diagnostic ouput to a current device.
/// <p> <var> nm</var> - connection name 
/// <br><var>timeout</var> - timeout (only relevant for  ODBC connections)
/// <br><var>verbose</var> - setting to a non 0 value will cause the diagnostic output to the current device
/// <br><var>error</var> - output variable for passing back an error if it occurs
ClassMethod TestConnection(nm, timeout = 0, verbose = 1, error = "") As %Status
{
		//do TestConnection^%apiGTW(nm, timeout)
 s error=""
 if $g(nm)="" {
	 s error="Connection name is undefined"
	 if verbose w error 
	 q 0
 }
 
 set timeout=+$g(timeout)
 i ($g(%SQLGateway(nm))'="")||($g(%JDBCGateway(nm))'="") {
	 if verbose w "Already connected" 
	 q 1
 }
 n a,b,c,isJDBC,sc
 &sql(select dsn,usr,pwd,isJDBC into :a,:b,:c,:isJDBC from %Library.sys_SQLConnection where connection_name=:nm)
 i SQLCODE {
	 s error="connection is not defined" 
	  if verbose w !,error
	 q 0
 }
 if (isJDBC){
 	n cn
 	if $d(%JDBCGateway(nm)) {
 	if verbose w !,"Already connected" 
 	q $$$OK
 }
 
 s cn=$$GetJConnection^%apiGTW(nm,,,,.sc)

 
 ;s err=$zf(-3,"","Disconnect",hdbc) w !,"Connection successful"
 if cn'="" {
	  if verbose w !,"Connection successful"
      q $$$OK
 }
 if verbose w !,"Connection failed: "
 if $$$ISERR(sc) {
	 if verbose w $$DisplayError^%apiOBJ(sc)
	 q sc
 }
 
 if $d(%JDBCGateway)  {
 	s error=%JDBCGateway.getErrorText()
 	if verbose w error
 }
 
	 k %JDBCGateway(nm)
	 q 0
 }
  if $d(%SQLGateway(nm)){
	  if verbose  w !,"Already connected" 
	  q 1
	  }

 n hdbc,dll,err
 s hdbc=""
 s dll=$s($$$isWINDOWS:"cgate.dll",$$$isUNIX:"cgate.so",$$$isVMS:"cgate.exe",1:"cgate.dll")
 s dll=^%SYS("bindir")_dll
 i $g(%SQLGateway)="" {
 		s dll=$s($$$isWINDOWS:"cgate.dll",$$$isUNIX:"cgate.so",$$$isVMS:"cgate.exe",1:"cgate.dll")
 		s dll=^%SYS("bindir")_dll
 		s %SQLGateway=$zf(-4,1,dll)
 	}
 i $g(%SQLGateway)="" {
	 	s error="cgate cannot be loaded"
	 	if verbose w !,error
	 	q 0
	 }
 i $g(^%ISCLOG)>1 s err=$zf(-5,%SQLGateway,51,^%ISCLOG)
 s %SQLGateway("-uv")=$zf(-5,%SQLGateway,52)

 s c=$System.Encryption.AESBase64Decode(c,"3Mandelbrot!") 
 
 if b="",c="" s hdbc=$zf(-5,%SQLGateway,46,a,timeout) 
 ;s c=$ZU(170,4,c,"3Mandelbrot!") 
 ;i hdbc="" s hdbc=$zf(-3,"","Connect",a,b,c) //look up 115 !!!!!
 i hdbc="" s hdbc=$zf(-5,%SQLGateway,45,a,b,c,timeout) //look up 115 !!!!!
 i hdbc="" {
 	s erlist=$zf(-5,%SQLGateway,12,0,0) ; GetSQLErrors=12
 	n n1 s n1=$ll(erlist)  

	n jj i n1>0 f jj=1:1:n1 s error=error_$lg(erlist,jj)_" "

	if verbose w !,"Connection failed",!,error 
	q 0
 }
 ;s err=$zf(-3,"","Disconnect",hdbc) w !,"Connection successful"
 s err=$zf(-5,%SQLGateway,6,hdbc) 
 if verbose w !,"Connection successful"
 k %SQLGateway(nm)
 
 quit $$$OK
}

/// Disconnect a JDBC or ODBC connection
/// <p> <var> nm</var> - connection name
ClassMethod DropConnection(nm) As %Status
{
		do DropConnection^%apiGTW(nm)
		quit $$$OK
}

/// Connect to a previously defined JDBC Gateway connection. 
/// <p> It returns an empty string if the connection attempt was unsuccessful.
/// <p> <var> nm</var> - connection name 
ClassMethod GetJDBCConnection(cname) As %Binary
{
		quit $$GetJConnection^%apiGTW(cname)
		quit $$$OK
}

/// Drop all open connections and unload the SQL Gateway library.
ClassMethod DropAll() As %Status
{
		do DropAll^%apiGTW()
		quit $$$OK
}

/// Connect to a previously defined SQL Gateway ODBC connection. 
/// <p> It returns an empty string if the connection attempt was unsuccessful.
/// <p> <var> nm</var> - connection name 
/// <br><var>timeout</var> - timeout
/// <br><var>legacy</var> - legacy mode
ClassMethod GetODBCConnection(nm, timeout, legacy = "") As %Binary
{
		quit $$GetConnection^%apiGTW(nm, timeout,legacy,.err)
}

/// Set the given integer option for all open connections
/// <p> <var> option</var> - option to set 
/// <br><var>vparm</var> - value associated with option
ClassMethod SetAllODBCConnectOption(option, vparm) As %Status
{
		do SetAllConnectOption^%apiGTW(option,vparm)
		quit $$$OK
}

/// Set the autocommit mode for all open connections
/// <p> <var>ac</var> = { 0 -  AUTOCOMMIT OFF, 1 - AUTOCOMMIT ON}
ClassMethod SetAutoCommit(ac) As %Status
{
		do SetAutoCommit^%apiGTW(ac)
		quit $$$OK
}

/// Request a commit or rollback operation for all active operations on JDBC or ODBC connections.
/// <p> <var>type</var> = { 0 - SQL_COMMIT, 1 - SQL_ROLLBACK}
ClassMethod Transact(ttype) As %Status
{
		do Transact^%apiGTW(ttype)
		quit $$$OK
}

}
