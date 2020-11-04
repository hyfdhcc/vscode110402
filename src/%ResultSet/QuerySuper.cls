/// Internal class that defines some common query properties
Class %ResultSet.QuerySuper [ ClassType = donotuse ]
{

Parameter %info;

Parameter %extinfo;

Parameter %colinfo;

Property %CursorDataerr As %CacheString [ MultiDimensional, Private ];

Property %CursorDatahstmt As %CacheString [ MultiDimensional, Private ];

Property %CursorDatahdbc As %CacheString [ MultiDimensional, Private ];

Property %CursorDataiot As %CacheString [ MultiDimensional, Private ];

Property %CursorDataparloop As %CacheString [ MultiDimensional, Private ];

Property %CursorDataparms As %CacheString [ MultiDimensional, Private ];

Property %CursorDatapdt As %CacheString [ MultiDimensional, Private ];

Property %CursorDatapl As %CacheString [ MultiDimensional, Private ];

Property %CursorDataps As %CacheString [ MultiDimensional, Private ];

Property %CursorDatarlist As %CacheString [ MultiDimensional, Private ];

Property %CursorDatasql As %CacheString [ MultiDimensional, Private ];

Property %CursorDataTS As %CacheString [ MultiDimensional, Private ];

Property %CursorDataTS2 As %CacheString [ MultiDimensional, Private ];

Method Fetch() As %Status [ ProcedureBlock = 0 ]
{
	Set AtEnd=1,Row=""
	Quit $$$OK
}

Method FetchRows() As %Status [ ProcedureBlock = 0 ]
{
	Set FetchCount=0,AtEnd=1,Row=""
	Quit $$$OK
}

Method GetInfo() As %Status [ ProcedureBlock = 0 ]
{
	Set idinfo=..#%info,colinfo=$lg(idinfo,1),parminfo=$lg(idinfo,2),idinfo=$lg(idinfo,3)
	If $get(extoption) Set extinfo=..#%extinfo
	Quit $$$OK
}

Method GetODBCInfo() As %Status [ ProcedureBlock = 0 ]
{
	Set colinfo=..#%colinfo,parminfo=""
	Quit $$$OK
}

Method Close() As %Status
{
	Quit $$$OK
}

}
