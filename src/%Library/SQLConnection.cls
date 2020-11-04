Class %Library.SQLConnection Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock, SqlTableName = sys_SQLConnection, StorageStrategy = StorageSpec, System = 4 ]
{

/// Index for property Name
Index NameIndex On Name [ Unique ];

Property Name As %String(CAPTION = "Connection Name") [ Required, SqlFieldName = Connection_Name ];

Property DSN As %String(CAPTION = "DSN", MAXLEN = 256);

Property Usr As %String(CAPTION = "User");

Property pwd As %CSP.Util.Passwd(CAPTION = "Password");

Property ReverseOJ As %Boolean(CAPTION = "Legacy Sybase outer join syntax");

Property isJDBC As %Boolean(CAPTION = "Is JDBC connection");

Property useCAST As %Boolean(CAPTION = "Use CAST as VARCHAR");

Property useCASTCHAR As %Boolean(CAPTION = "Use CAST as CHAR");

Property useCOALESCE As %Boolean(CAPTION = "Use COALESCE") [ InitialExpression = 1 ];

Property URL As %String(CAPTION = "URL", MAXLEN = 4096);

Property driver As %String(CAPTION = "driver", MAXLEN = 256);

Property xadriver As %String(CAPTION = "driver", MAXLEN = 256);

Property classpath As %Library.String(CAPTION = "Class Path", MAXLEN = 256);

Property properties As %Library.String(CAPTION = "Properties", MAXLEN = 256);

Property nodefq As %Boolean(CAPTION = "Do not use delimited identifiers by default");

Property noconcat As %Boolean(CAPTION = "Do not generate {fn concat()}");

Property nofnconv As %Boolean(CAPTION = "Do not generate {fn conv ...} by default");

Property needlongdatalen As %Boolean(CAPTION = "Needs long data length");

Property nvl As %Boolean(CAPTION = "Use NVL() instead of IFNULL()");

Property bUnicodeStream As %Boolean(CAPTION = "Supports Unicode Streams") [ InitialExpression = 1 ];

Property tpw As %String [ Private, Transient ];

Property bEncode As %Boolean [ InitialExpression = 1, Private, Transient ];

Method setEncode(val As %Boolean)
{
	set ..bEncode = val
}

ClassMethod ConnExists(nm As %String) As %Boolean
{
	set str=""
	&sql(select connection_name into :str from %Library.sys_SQLConnection where connection_name=:nm)
	Quit str'=""
}

/// Lookup by Connection name
Query ByName(name As %String = "") As %SQLQuery(ROWSPEC = "Connection_Name,DSN,User,ID,isJDBC") [ SqlProc ]
{
 SELECT  Connection_Name, DSN, usr, %ID, isJDBC
 FROM %Library.sys_SQLConnection
 WHERE Connection_Name %STARTSWITH %ALPHAUP(:name)
 ORDER BY Connection_Name
}

/// Lookup by Connection name without input parameter
Query ByConnection() As %SQLQuery(ROWSPEC = "Connection_Name,DSN,User,ID") [ SqlProc ]
{
 SELECT  Connection_Name, DSN, usr, %ID
 FROM %Library.sys_SQLConnection
 WHERE Connection_Name is not null
 ORDER BY Connection_Name
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s ..tpw=..pwd
	if ..bEncode s ..pwd=$$pp^%apiGTW(..pwd)
	q $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s ..pwd=..tpw
	q $$$OK
}

Storage StorageSpec
{
<Data name="SQLConnectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSN</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Usr</Value>
</Value>
<Value name="5">
<Value>pwd</Value>
</Value>
<Value name="6">
<Value>ReverseOJ</Value>
</Value>
<Value name="7">
<Value>isJDBC</Value>
</Value>
<Value name="8">
<Value>URL</Value>
</Value>
<Value name="9">
<Value>driver</Value>
</Value>
<Value name="10">
<Value>classpath</Value>
</Value>
<Value name="11">
<Value>properties</Value>
</Value>
<Value name="12">
<Value>useCAST</Value>
</Value>
<Value name="13">
<Value>xadriver</Value>
</Value>
<Value name="14">
<Value>nodefq</Value>
</Value>
<Value name="15">
<Value>nofnconv</Value>
</Value>
<Value name="16">
<Value>useCOALESCE</Value>
</Value>
<Value name="17">
<Value>needlongdatalen</Value>
</Value>
<Value name="18">
<Value>bUnicodeStream</Value>
</Value>
<Value name="19">
<Value>useCASTCHAR</Value>
</Value>
<Value name="20">
<Value>noconcat</Value>
</Value>
<Value name="21">
<Value>nvl</Value>
</Value>
</Data>
<DataLocation>^%SYS("sql","ODBCCONNECTION","DATA")</DataLocation>
<DefaultData>SQLConnectionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%SYS("sql","ODBCCONNECTION","DATA")</IdLocation>
<IndexLocation>^%SYS("sql","ODBCCONNECTION","INDEX")</IndexLocation>
<StreamLocation>^%Library.SQLConnectionS</StreamLocation>
<Type>%CacheStorage</Type>
}

}
