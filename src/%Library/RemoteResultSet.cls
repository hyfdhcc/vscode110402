Include %apiCBIND

/// The <class>%RemoteResultSet</class> class provides a way to use 
/// class queries from a different namespace from within a <i>Cach&eacute; ObjectScript</i> application. It is 
/// similar in operation to the <b>ResultSet</b> objects provides with the ActiveX and 
/// Java bindings. It uses C++ binding and therefore the C++ binding library must be installed.
/// <p>You can use a <class>%RemoteResultSet</class> object as follows:
/// <example>
/// ; Display the results of the Person class' ByName query to the console.
/// Set rs=##class(%RemoteResultSet).%New("Sample.Person:ByName")
/// s rs.UserName="_system"
/// s rs.Password="sys"
/// s rs.ConnectionString="localhost[1972]:SAMPLES"
/// w rs.Prepare()
/// w rs.Execute("S")
/// While rs.Next() {
/// 	Write rs.GetDataByName("Name"),!
/// }
/// </example>
/// <p>Note you can bind a <class>%ResultSet</class> object to a query by either 
/// a) setting the <property>ClassName</property> and <property>QueryName</property> 
/// properties or b) passing a string containing the class name and query name (separated 
/// by a <b>:</b>) to the <nobr><b>%New</b></nobr> method:
/// <example>
/// Set result=##class(%ResultSet).%New("Person:ByName")
/// </example>
/// <h2>Dynamic SQL</h2>
/// You can use the <class>%ResultSet</class> class to execute dynamic SQL queries 
/// using the system-provided <nobr><var>%DynamicQuery:SQL</var></nobr> query. In this case, use the 
/// <method>Prepare</method> method to supply the text of the query. For example:
/// 
/// <example>
/// Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
/// 
/// Do result.Prepare("SELECT ID, Name, Salary FROM Employee WHERE Salary > ?")
/// Do result.Execute(10000)
/// While result.Next() {
/// 	Write result.Data("Name"),result.Data("Salary"),!
/// }
/// </example>
/// 
/// Dynamic SQL queries are cached in the same query cache as used by <i>Cach&eacute;</i> ODBC and JDBC. 
/// This means that repeated calls to the same dynamic SQL query do not incur any additional 
/// query preparation and optimization overhead. You can view and manage this cache using the 
/// <i>Cach&eacute; SQL Manager</i>.
Class %Library.RemoteResultSet Extends %AbstractResultSet [ System = 2 ]
{

/// The name of the class containing the query to run.
Property ClassName As %CacheString;

/// The name of the query to run.
Property QueryName As %CacheString;

Property RuntimeMode As %String;

Property ConnectionString As %String;

Property UserName As %String;

Property Password As %String;

Property ErrorMsg As %String;

Property ErrorCode As %Integer [ Private ];

Property conn [ Private ];

Property db [ Private ];

Property query [ Private ];

Property dllhandle [ Private ];

Property QHandle [ MultiDimensional, Private ];

Property HasInfo [ InitialExpression = 0, Private ];

Property ParamInfo [ Private ];

Property ColInfo [ MultiDimensional, Private ];

Property IdInfo [ Private ];

Property AtEnd [ InitialExpression = 0, Private ];

Property Row [ Private ];

Property IsOpened [ InitialExpression = 0, Private ];

Property ColIndex [ MultiDimensional, Private ];

/// Used to store the data returned from the resultset by column name. This can
/// be accessed directly for more performance than the <method>Get</method> and
/// <method>GetDataByName</method> as it avoids a method call. For example code
/// that said:
/// <example>
/// While result.Next() {
/// 	Write result.Get("Name"),result.Get("Salary"),!
/// }
/// 
/// ; Becomes this faster code
/// 
/// While result.Next() {
/// 	Write $get(result.Data("Name")),$get(result.Data("Salary")),!
/// }
/// </example>
/// Note that as this 'Data' property is multidimensional if there
/// is no such column name as 'Salary' you will get an UNDEFINED error without
/// the $get around it. If
/// there are two columns with the same name in the result set then the second
/// one will be the one referenced by the 'Data' property. If you need to refer
/// to both of them use the <method>GetData</method> and give the position
/// of the column you want.
Property Data As %String [ MultiDimensional ];

Method ClassNameSet(class As %String) As %Status [ ProcedureBlock = 1 ]
{
	Set i%ClassName=$$$NormalizeClassname(class)
	Quit $$$OK
}

Method WasError() As %Integer [ ProcedureBlock = 1 ]
{
	s ..ErrorMsg=""
	s ..ErrorCode=$zf(-5, ..dllhandle, $$$cbindGetLastErrCode)
	Quit:'..ErrorCode 0
	s ..ErrorMsg=$zf(-5, ..dllhandle, $$$cbindGetLastErrMsg)
	QUIT ..ErrorCode
}

Method %OnClose() As %Status [ Private, ProcedureBlock = 1 ]
{
	If i%IsOpened d ..Close()
	//d $zf(-4, 2, ..dllhandle)
	Quit $$$OK
}

ClassMethod UnloadDLL()
{
	if $g(%CPPBind)'="" d $zf(-4, 2, ..dllhandle)
	k %CPPBind
}

Method %OnNew(initvalue As %String) As %Status [ Private, ProcedureBlock = 1 ]
{
	If $get(initvalue)="" Set i%ClassName="%Library.DynamicQuery",i%QueryName="SQL" Quit $$$OK
	Set initvalue=$translate(initvalue,",",":")
	If initvalue[":" {
		Set class=$piece(initvalue,":",1),i%QueryName=$piece(initvalue,":",2)
	}Else {
		Set len=$length(initvalue,"."),class=$piece(initvalue,".",1,len-1),i%QueryName=$piece(initvalue,".",len)
	}
 Set i%ClassName=$$$NormalizeClassname(class)
	Quit $$$OK
}

Method Prepare(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %Status
{
	//New %sc,QHandle,execute,i,pcount,dll,idx,dt,nm,pardt,rc,pc
	Set pcount=$zu(141)
	If i%ClassName="" QUIT $$$ERROR($$$ClassNameRequired)
	If i%QueryName="" QUIT $$$ERROR($$$QueryNameRequired)
	//If '..QueryIsValid() QUIT $$$ERROR($$$QueryDoesNotExist,..ClassName_":"_..QueryName)
	//If i%IsOpened QUIT $$$ERROR($$$QueryNotClosed)
	;Set execute="set %sc=$classmethod("""_i%ClassName_""","""_i%QueryName_"Prepare"",.QHandle"
	;For i=1:1:pcount Set execute=execute_",.p"_i
	;Set execute=execute_")"
	;Merge QHandle=i%QHandle
	;Xecute execute
	;Kill i%QHandle Merge i%QHandle=QHandle
	if $g(%CPPBind)="" {
	Set i%HasInfo=0
		s dll=$s($$$isWINDOWS:"cbind.dll",$$$isUNIX:"libcbind.so",$$$isVMS:"cbind.exe",1:"cbind.dll")
 		s dll=^%SYS("bindir")_dll

		s ..dllhandle= $zf(-4, 1, dll)
		d $zf(-5, ..dllhandle, $$$cbindSetZFMode )       ;"setZFMode")
	 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
	 	s %CPPBind=..dllhandle

	}
	else {
		s ..dllhandle=%CPPBind
	}

 	s ..conn = $zf(-5, ..dllhandle, $$$cbindAllocConn, ..ConnectionString, ..UserName,..Password)
 	//i ..conn="" QUIT $$$ERROR($$$GeneralError,"Connection error")
 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
 	
	s rc= $zf(-5, ..dllhandle, $$$cbindSetUniClient, $$$IsUnicode)
 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)

	s ..db = $zf(-5, ..dllhandle, $$$cbindAllocDb, ..conn)
 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
 	s ..query = $zf(-5, ..dllhandle, $$$cbindAllocQuery, ..db)
	if i%ClassName="%Library.DynamicQuery",i%QueryName="SQL" d  i 1
	. s rc= $zf(-5, ..dllhandle, $$$cbindPrepareGenQuery, ..query, p1)
 	e  s rc= $zf(-5, ..dllhandle, $$$cbindPrepareClassQuery, ..query, i%ClassName, i%QueryName)
  	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
	i rc QUIT $$$ERROR($$$GeneralError,"Prepare SQL Error "_rc)
 	s i%ColIndex=$zf(-5, ..dllhandle, $$$cbindQueryGetNumCols, ..query)
 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
 	s pc=$zf(-5, ..dllhandle, $$$cbindQueryGetNumPars, ..query)
  	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
  	set metadata = $listbuild(i%ColIndex)

	f idx=1:1:i%ColIndex {
	 	s ..ColInfo(idx,"Name")=$zf(-5, ..dllhandle, $$$cbindQueryGetColName, ..query, idx)
	 	if ..WasError() QUIT 
	 	s ..ColInfo(idx,"SqlType")=$zf(-5, ..dllhandle, $$$cbindQueryGetColSQLType, ..query, idx)
	 	if ..WasError() QUIT 
	 	s ..ColInfo(idx,"Precision")=$zf(-5, ..dllhandle, $$$cbindQueryGetColPrecision, ..query, idx)
	 	if ..WasError() QUIT 
	 	s ..ColInfo(idx,"Scale")=$zf(-5, ..dllhandle, $$$cbindQueryGetColScale, ..query, idx)
	 	if ..WasError() QUIT 
	 	s ..ColInfo(idx,"DisplaySize")=$zf(-5, ..dllhandle, $$$cbindQueryGetDisplaySize, ..query, idx)
		if ..WasError() QUIT 
	 	s ..ColInfo(idx,"isMoney")=$zf(-5, ..dllhandle, $$$cbindQueryGetColIsMoney, ..query, idx)
	 	if ..WasError() QUIT
	 	s ..ColInfo(idx,"isNullable")=$zf(-5, ..dllhandle, $$$cbindQueryGetColIsNullable, ..query, idx)
	 	if ..WasError() QUIT 
	 	//Set i%ColIndex(idx)=$lb(nm,dt,precision,scale,isNullable,nm)
	 	set bstr=$char(0,0,0,0,0,0,0,0,0,0,0)
		if $get(%protocol,41) '> 40 {
			set metadata = metadata _ $listbuild(..ColInfo(idx,"Name"),..ColInfo(idx,"SqlType"),..ColInfo(idx,"Precision"),..ColInfo(idx,"Scale"),..ColInfo(idx,"isNullable"),..ColInfo(idx,"Name"),"","","")
		}
		else { set metadata = metadata _ $listbuild(..ColInfo(idx,"Name"),..ColInfo(idx,"SqlType"),..ColInfo(idx,"Precision"),..ColInfo(idx,"Scale"),..ColInfo(idx,"isNullable"),..ColInfo(idx,"Name"),"","","",bstr) }
	}
	
	set ..%Metadata = metadata
	
 	
 	if i%ColIndex,..ErrorCode QUIT $$$ERROR(..ErrorMsg)
 	
 	s i%ParamInfo=""
 	f idx=1:1:pc d
 	. s nm="p"_idx
 	. s dt=$zf(-5, ..dllhandle, $$$cbindQueryGetParSQLType, ..query, idx)
	.	if ..WasError() QUIT 
 	. s i%ParamInfo=i%ParamInfo_$lb($lb(nm,dt))
 	if pc,..ErrorCode QUIT $$$ERROR(..ErrorMsg)
 	s i%HasInfo=1

	QUIT $$$OK
}

Method Execute(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) As %Status [ PublicList = (p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) ]
{
	//New %sc,QHandle,PrevMode,pcount,execute,i,val,rc
	s %sc=$$$OK
	Set pcount=$zu(141)
	//if i%ClassName="%Library.DynamicQuery",i%QueryName="SQL" s pcount=pcount-1 ;???
	If i%ClassName="" QUIT $$$ERROR($$$ClassNameRequired)
	If i%QueryName="" QUIT $$$ERROR($$$QueryNameRequired)
	//If '..QueryIsValid() QUIT $$$ERROR($$$QueryDoesNotExist,i%ClassName_":"_i%QueryName)
	If i%IsOpened Set %sc=..Close() If $$$ISERR(%sc) QUIT %sc
	//If i%RuntimeMode'="" Set PrevMode=$zu(115,5,i%RuntimeMode)
	//Set execute="set %sc=$classmethod("""_i%ClassName_""","""_i%QueryName_"Execute"",.QHandle"
	if $$$IsUnicode {
	  s bindFunc=$$$cbindQuerySetUniPar
	}
	else {
	    s bindFunc=$$$cbindQuerySetPar
	}
	For i=1:1:pcount d  //q:rc $$$ERROR($$$GeneralError,"Binding error")             ;Set execute=execute_",.p"_i
	. s execute="p"_i
	. s val=@execute
	. s rc=$zf(-5, ..dllhandle, bindFunc, ..query, i, val)
	. if ..WasError() QUIT

	
	if pcount,..ErrorCode QUIT $$$ERROR(..ErrorMsg)

	//Merge QHandle=i%QHandle
	//Xecute execute
	//Kill i%QHandle Merge i%QHandle=QHandle
	s rc= $zf(-5, ..dllhandle, $$$cbindQueryExecute, ..query)
	if ..WasError() QUIT $$$ERROR(..ErrorMsg)

	//If i%RuntimeMode'="" Do $zu(115,5,PrevMode)
	If rc'=0 QUIT $$$ERROR($$$GeneralError,"Execute Failed")
	Set i%AtEnd=0,i%IsOpened=1
	#;If the GetInfo call fails ignore it, we just do not populate the 'Data' array
	If 'i%HasInfo Do ..GetInfo()
	QUIT $$$OK
}

Method %Next(ByRef sc As %Status) As %Integer
{
	//n tstr
	If 'i%IsOpened||(i%AtEnd) Set sc=$$$OK QUIT 0
	Kill i%Data 
	//New qHandle,Row,AtEnd,PrevMode,i
	//Merge qHandle=i%QHandle
	/*If i%RuntimeMode'="" Set PrevMode=$zu(115,5,i%RuntimeMode)
	If i%ClassName="%Library.DynamicQuery",i%QueryName="SQL" {
		New %qref,rtn Set %qref=$listget(qHandle,1),rtn=$listget(qHandle,2)
		If %qref=""||(rtn="") { Set sc=$$$ERROR($$$QueryNotPrepared) }Else { Set sc=$$Fetch^@rtn }
}Else {
		Set sc=$classmethod(i%ClassName,i%QueryName_"Fetch",.qHandle,.Row,.AtEnd)
	}*/
    //Kill i%QHandle Merge i%QHandle=qHandle
    s rc= $zf(-5, ..dllhandle, $$$cbindQueryFetch, ..query)
    if ..WasError() QUIT 0

    if rc s i%AtEnd=1 QUIT 0
	If i%RuntimeMode'="" Do $zu(115,5,PrevMode)
	//If rc'=0 Quit 0
	#;use $get in case Row not defined at end.
	Set i%Row="" 
	For i=1:1:i%ColIndex d
	. Set tstr= $zf(-5, ..dllhandle, $$$cbindQueryGetDataStr, ..query)
	. Set i%Data(..ColInfo(i,"Name"))= tstr
	. s i%Row=i%Row_$lb(tstr)
	
	Quit i%Row'=""
}

Method Next(ByRef sc As %Status) As %Integer [ CodeMode = expression ]
{
..%Next(.sc)
}

Method GetData(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$listget(i%Row,n)
}

Method Get(name As %String) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select($get(name)'="":$get(i%Data(name)),1:"")
}

Method GetDataByName(name As %String) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select($get(name)'="":$get(i%Data(name)),1:"")
}

Method GetObject() As %RegisteredObject [ ProcedureBlock = 1 ]
{
	 Quit ""
}

Method Close() As %Status
{
	If 'i%IsOpened Quit $$$OK
	//New %sc,QHandle
	Merge QHandle=i%QHandle
	d $zf(-5, ..dllhandle, $$$cbindFreeQuery , ..query)
	if ..WasError() QUIT $$$ERROR(..ErrorMsg)

 	d $zf(-5, ..dllhandle, $$$cbindFreeDb, ..db)
 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
 	d $zf(-5, ..dllhandle, $$$cbindFreeConn, ..conn)
 	if ..WasError() QUIT $$$ERROR(..ErrorMsg)
 	s ..query=""
 	s ..conn=""
 	s ..db=""


	Set i%Row="",i%AtEnd=0,i%IsOpened=0
	Quit $$$OK
}

Method GetInfo() As %Status [ Private ]
{
	//New %sc,paraminfo,idinfo,QHandle,i,extent
	if i%HasInfo q $$$OK
	Quit $$$ERROR($$$GeneralError,"GetInfo Error")
}

Method GetColumnCount() As %Integer [ CodeMode = expression ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):0,1:i%ColIndex)
}

Method GetColumnName(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):"",1:..ColInfo(n,"Name"))
}

Method GetColumnHeader(n As %Integer) As %String [ ProcedureBlock = 1 ]
{
	
	Quit ..GetColumnName(n)
}

Method GetColumnPrecision(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):"",1:..ColInfo(n,"Precision"))
}

Method GetColumnScale(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):"",1:..ColInfo(n,"Scale"))
}

Method GetColumnDisplaySize(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):"",1:..ColInfo(n,"DisplaySize"))
}

Method GetColumnIsMoney(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):"",1:..ColInfo(n,"isMoney"))
}

Method GetParamCount() As %Integer [ CodeMode = expression ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):0,1:$listlength(i%ParamInfo))
}

Method GetParamName(n As %Integer) As %String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$select('i%HasInfo&&($$$ISERR(..GetInfo())):"",1:$list($list(i%ParamInfo,n),1))
}

Method QueryIsValid() As %Integer [ CodeMode = expression ]
{
i%ClassName'=""&&(i%QueryName'="")&&(''$$$comMemberDefined(i%ClassName,$$$cCLASSquery,i%QueryName))
}

Method ContainsId() As %Integer [ CodeMode = expression ]
{
0
}

Method GetExtent() As %String [ CodeMode = expression ]
{
""
}

Method %ResultColumnCountGet() As %Integer [ CodeMode = expression ]
{
$get(i%ColIndex)
}

}
