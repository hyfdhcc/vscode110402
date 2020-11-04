Include %apiCBIND

/// <p> This class is <b>DEPRECATED</b>. It is provided only for supporting existing applications.  New applications should use Web services for communication.
/// <br><br>
/// This class depends on C and C++ binding, so C++ binding must be installed on the server that uses this class.
/// 
/// <Example>
/// s rc=##class(%Net.RemoteConnection).%New()
/// Set Status=rc.Connect("127.0.0.1","SAMPLES",1972,"_system","SYS") break:'Status
/// Set Status=rc.OpenObjectId("Sample.Person",1,.per) break:'Status
/// Set Status=rc.GetProperty(per,"Name",.value) break:'Status
/// write value
/// Set Status=rc.ResetArguments() break:'Status
/// Set Status=rc.SetProperty(per,"Name","Jones,Tom "_$r(100),4) break:'Status  // 4 = $$$cbindStringId
/// Set Status=rc.ResetArguments() break:'Status
/// Set Status=rc.GetProperty(per,"Name",.value) break:'Status
/// write value
/// Set Status=rc.ResetArguments() break:'Status
/// Set Status=rc.AddArgument(150,0) break:'Status  // Add 150+10
/// Set Status=rc.AddArgument(10,0) break:'Status  // Add 150+10
/// Set Status=rc.InvokeInstanceMethod(per, "Addition", .AdditionValue, 1) break:'Status
/// Write AdditionValue
/// Set Status=rc.ResetArguments() break:'Status
/// Set Status=rc.InstantiateQuery(.rs,"Sample.Person","ByName")
/// </Example>
Class %Net.RemoteConnection Extends %RegisteredObject [ System = 4 ]
{

Property Connection As %Binary;

Property LastErrorCode As %Integer;

Property LastErrorString As %String(MAXLEN = 1024, TRUNCATE = 1);

Property Database As %Binary;

Property DLL As %Binary;

Method Connect(sIP As %String, sNamespace As %String, sPort As %String = "1972", sUsername As %String = "", sPassword As %String = "", sClientIP As %String = "", sClientPort As %String = "") As %Status
{
	If ..Connection]""!(..Database]"") Do ..Disconnect()
	If ..DLL="" {
		Set dll=$g(^%SYS("bindir"))_$s($$$isWINDOWS:"cbind.dll",$$$isUNIX:"libcbind.so",$$$isVMS:"cbind.exe",1:"cbind.dll")
		Set ..DLL=$zf(-4,1,dll)
		s err=$zf(-5,..DLL, $$$cbindSetClientEncoding, $$$ClientEncoding)
		s err=$zf(-5,..DLL,$$$cbindSetZFMode)
	}
	Set connStr = sIP_"["_sPort_"]:"_sNamespace
	if ((sClientIP '= "") || (sClientPort '= "")) {
		set connStr = connStr_"|"_sClientIP_"["_sClientPort_"]"
	}
	Set ..Connection=$zf(-5,..DLL,$$$cbindAllocConn, connStr, sUsername, sPassword)
	Set Status=..CheckErrorCode()	
	If Status {
		Set ..Database=$zf(-5,..DLL, $$$cbindAllocDb, ..Connection)
		Set Status=..CheckErrorCode()	
	}
	Quit Status
}

Method CreateInstance(sClass As %String = "", ByRef pObject As %RegisteredObject = "") As %Status
{
	Set pObject = $zf(-5, ..DLL, $$$cbindCreateNew, ..Database, sClass)
	Quit ..CheckErrorCode()
}

Method OpenObjectId(sClass, ID, ByRef pObject) As %Status
{
	Set pObject = $zf(-5, ..DLL, $$$cbindOpenId, ..Database, sClass, ID)
	Quit ..CheckErrorCode()
}

Method OpenObject(sClass, OID, ByRef pObject) As %Status
{
	Set pObject = $zf(-5, ..DLL, $$$cbindOpen, ..Database, sClass, OID)
	Quit ..CheckErrorCode()
}

Method CloseObject(ByRef pObject) As %Status
{
	d $zf(-5, ..DLL, $$$cbindCloseObj, ..Database, pObject)
	Set pObject=""
	Quit ..CheckErrorCode()
}

/// This method cannot return references as a result they must be passed as parameters
/// ie you cannot call OpenId you must call the OpenObjectId below
Method InvokeClassMethod(sClass As %String, sMethodName As %String = "", sReturnValue As %String = "", bHasReturn As %Boolean = 0, returnType As %Integer) As %Status
{
	If 'bHasReturn Set returnType=$$$cbindVoid
	Set returnType=$g(returnType,$$$cbindBinaryId)
	Set sReturnValue=$lg($zf(-5,..DLL,$$$cbindRunClassMethod,..Database,sClass,sMethodName,returnType))
	Quit ..CheckErrorCode()
}

/// This method cannot return references as a result they must be passed as parameters
/// ie you cannot call OpenId you must call the OpenObjectId below
Method InvokeInstanceMethod(pObject As %RegisteredObject = "", sMethodName As %String = "", sReturnValue As %String = "", bHasReturn As %Boolean = 0, returnType As %Integer) As %Status
{
	if 'bHasReturn Set returnType=$$$cbindVoid
	Set returnType=$g(returnType,$$$cbindBinaryId)
	S sReturnValue=$lg($zf(-5, ..DLL, $$$cbindRunObjMethod, ..Database, pObject, sMethodName, returnType))
	Quit ..CheckErrorCode()
}

/// After every call you should check the Error Code
Method CheckErrorCode() As %Status
{
	s errCode=$zf(-5, ..DLL, $$$cbindGetLastErrCode)
	If errCode {
		Set ..LastErrorCode=errCode
		Quit $$$ERROR($$$GeneralError,"Code: "_errCode_" "_$zf(-5, ..DLL, $$$cbindGetLastErrMsg))
	}
	Quit $$$OK
}

/// Used to get the value of an argument that was passed by reference
Method GetArgument(ByRef Argument, ArgumentNumber As %Integer) As %Status
{
	Set Argument = $lg($zf(-5,..DLL,$$$cbindGetArg,..Database,ArgumentNumber-1))
	Quit ..CheckErrorCode()
}

/// Add arguments before calling methods (Call Reset before adding any)
Method AddArgument(Argument, ByReference As %Boolean = 0, argType As %Integer) As %Status
{
	Set argType=$G(argType,$$$cbindBinaryId)
	d $zf(-5,..DLL,$$$cbindSetNextArg,..Database,argType,$lb(Argument),ByReference)
	Quit ..CheckErrorCode()
}

/// Used to reset the argument list, must be called before adding arguments
Method ResetArguments() As %Status
{
	d $zf(-5,..DLL,$$$cbindResetArgs,..Database)
	Quit ..CheckErrorCode()
}

/// Set a property on an open object (on the remote system)
Method SetProperty(object As %RegisteredObject, sPropertyName As %String, sPropertyValue As %String, argType As %Integer) As %Status
{
	Set argType=$G(argType,$$$cbindBinaryId)  /// binary when not defined
	d $zf(-5,..DLL,$$$cbindSetProperty,..Database,object,sPropertyName,$lb(sPropertyValue),argType)
	Quit ..CheckErrorCode()
}

/// Get property of an open object (on the remote system)
Method GetProperty(object As %RegisteredObject, sPropertyName As %String, ByRef sPropertyValue As %String) As %Status
{
	S sPropertyValue=$lg($zf(-5,..DLL,$$$cbindGetProperty,..Database,object,sPropertyName))
	Quit ..CheckErrorCode()
}

/// Running queries Instantiate the ResultSet, Execute, Loop {Fetch Row, GetData}, Release Query 
/// <Example>
/// Set rc=##class(%Net.RemoteConnection).%New()
/// Set Status=rc.Connect("127.0.0.1","SAMPLES",1972,"_system","SYS") break:'Status
/// Set Status=rc.InstantiateQuery(.rs,"Sample.Person","ByName") break:'Status
/// Set Status=rc.ResetArguments() break:'Status
/// Set Status=rc.AddArgument("A",0,4) break:'Status   /// 4 = $$$cbindStringId
/// Set Status=rc.ExecuteQuery(rs) break:'Status
/// For  {Set Status=rc.FetchQueryRow(rs, .AtEnd) break:'Status  Quit:AtEnd  Set Status=rc.GetQueryData(rs, 0, .value) break:'Status  Set Status=rc.GetQueryData(rs, 1, .value1) break:'Status  Write value,?10,value1,! }
/// Set Status=rc.ReleaseQuery(rs) break:'Status
/// </Example>
Method InstantiateQuery(ByRef resultSetObject As %ResultSet, ClassName As %String, QueryName As %String) As %Status
{
	Set resultSetObject=$zf(-5,..DLL,$$$cbindAllocQuery,..Database)
	Set Status=..CheckErrorCode()
	Quit:'Status Status
	Do $zf(-5,..DLL,$$$cbindPrepareClassQuery,resultSetObject,ClassName,QueryName)
	Quit ..CheckErrorCode()
}

/// See InstantiateQuery
Method ReleaseQuery(resultSetObject As %ResultSet) As %Status
{
	Do $zf(-5,..DLL,$$$cbindFreeQuery,resultSetObject)
	Quit ..CheckErrorCode()
}

/// See InstantiateQuery
Method ExecuteQuery(resultSetObject As %ResultSet) As %Status
{
	Do $zf(-5,..DLL,$$$cbindQueryExecute,resultSetObject)
	Quit ..CheckErrorCode()
}

/// See InstantiateQuery
Method FetchQueryRow(resultSetObject As %ResultSet, ByRef AtEnd As %Boolean) As %Status
{
	Set AtEnd=$zf(-5,..DLL,$$$cbindQueryFetch,resultSetObject)
	Quit ..CheckErrorCode()
}

/// See InstantiateQuery
Method GetQueryData(resultSetObject As %ResultSet, position As %Integer, ByRef value As %String) As %Status
{
	Set value= $zf(-5,..DLL,$$$cbindQueryGetDataStr,resultSetObject,position)
	Quit ..CheckErrorCode()
}

/// Disconnect from remote system
Method Disconnect() As %Status
{
	s Status=$$$OK
	If ..Database {
		d $zf(-5, ..DLL, $$$cbindFreeDb, ..Database) Set ..Database=""
		Set Status=..CheckErrorCode() 
	}
	If ..Connection {
		d $zf(-5, ..DLL, $$$cbindFreeConn, ..Connection) Set ..Connection=""
		Set Status=..CheckErrorCode()
	}
	Quit Status
}

/// Unload DLL
Method UnloadDLL() As %Status
{
	If ..Database]"" || (..Connection]"" ) Do ..Disconnect()
	If ..DLL]"" {
		Do $zf(-4,2,..DLL)
		Set ..DLL=""
	}
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Close</METHOD> method to 
/// provide notification that the current object is being closed.
/// 
/// <P>The return value of this method is ignored.
Method %OnClose() As %Status [ Private, ProcedureBlock = 1 ]
{
	Set Status= ..Disconnect()
	//Do ..UnloadDLL()
	Quit $$$OK
}

}
