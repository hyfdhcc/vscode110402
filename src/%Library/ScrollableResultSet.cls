/// This provides a scrollable resultset object that can also be saved and loaded
/// It works by running the entire query when the first item of data is requested
/// and storing the results in a global. Then you can move around the results by setting the
/// <property>CurrRow</property> and you may also call <method>Previous</method> as
/// well as the standard <method>Next</method>. In addition you may save this resultset
/// and then load it potentially in a different process at a later date and continue
/// reading from it, for example:
/// <example> Set results=##class(%ScrollableResultSet).%New("Classname:QueryName")
/// Do results.Execute()
/// Do results.Next()
/// Write results.Data("fieldname")
/// Do results.%Save()
/// Set id=results.%Id()
/// Kill results
/// Set results=##class(%ScrollableResultSet).%OpenId(id)
/// Do results.Next()
/// Write results.Data("fieldname")
/// </example>
/// Note that if you open a %ScrollableResultSet and do not call %Save on it then when you
/// close this object the data stored in the global will be removed and so you will not be
/// able to open this resultset again. So if you open a scrollable resultset and you wish
/// to use this again call %Save on it, but you must always make sure that when you are finished
/// with it you do not call %Save so the temporary global used is cleaned up when you are done.
/// Alterntively you can call %DeleteId passing the id to remove the saved data.<p>
/// There is also a <method>Count</method> to find the total number of entries in this resultset.
Class %Library.ScrollableResultSet Extends %Library.ResultSet [ System = 3 ]
{

/// Index into temp global used to hold results
Property TempIndex As %Integer [ Private ];

/// Number of current row in the temp table, you can set this property to
/// move to a new location and also use this to check the current position.
/// If you specify a value that is out of bounds then the row will not be moved.
/// The first row is at CurrRow=1, so it is 1 based and not 0 based.
Property CurrRow As %Integer;

Method CurrRowSet(val As %String) As %Status
{
	If ..TempIndex="" Set sc=..PopulateData() If $$$ISERR(sc) Quit sc
	Set Row = $get(^CacheTempRSet(..TempIndex,"Data",+val))
	If (Row = "") {
		Quit $$$OK
	}
	
	Set i%CurrRow=+val

	#; move data into row buffer
	For i=1:1:..ColIndex Set i%Data(i%ColIndex(i))=$listget(Row,i)
	Set ..Row=Row,..AtEnd=1
	Quit $$$OK
}

/// This determines how many rows this query will load, the default '0' will load
/// all the results, if you set it to 10,000 then it will only load the first 10,000
/// rows, which will mean you can not access any data beyond the 10,000th element.
/// Also the actual stopping point may be slightly larger than MaxRows because of the
/// way the data is imported, but it will be around this figure.
Property MaxRows As %Integer [ InitialExpression = 0 ];

/// If true, the temp table has been saved and should not be
/// automatically deleted.
Property IsSaved As %Boolean [ InitialExpression = 0, Private ];

Method %OnClose() As %Status [ Private ]
{
	#; note: *real* result set is already closed by now...
	#; if temp table is allocated, AND not saved, delete it.
	If ((..TempIndex '= "") && ('..IsSaved)) {
		Kill ^CacheTempRSet(..TempIndex)
	}
	
	Quit $$$OK
}

/// Executes the current query.
/// <p>The arguments <var>p1...</var> supply the value of any parameters the 
/// query may have.
Method PopulateData() As %Status [ Private, ProcedureBlock = 0 ]
{
	New idx,columns,i,query,RowSet,ReturnCount,AtEnd,qHandle,classname,sc,j,PrevMode,data,pos
	#; We need query info to work correctly
	If '..HasInfo Quit ..GetInfo()
	If ..TempIndex="" Set ..TempIndex=$increment(^CacheTempRSet)
	Set idx=..TempIndex,columns=..ColIndex
	Kill ^CacheTempRSet(idx)
	If '..IsOpened||(..AtEnd) QUIT $$$OK
	#; Now fill in this global with the results
	Set ^CacheTempRSet(idx)=$listbuild($zdt($horolog,3),$job)
	If ..RuntimeMode'="" Set PrevMode=$zu(115,5,..RuntimeMode)
	If ..ClassName="%Library.DynamicQuery",..QueryName="SQL" {
		If ($isobject($get(i%QHandle(1)))'=1) {
			Set sc=$$$ERROR($$$QueryNotPrepared)
		} Else {
			Set i=0,AtEnd=0
			For  {
				Set sc=i%QHandle(1).FetchRows()
				Quit:$get(RowSet)=""
				Set data=$list(RowSet,1,columns),pos=$length(data)+1
				Set ^CacheTempRSet(idx,"Data",$increment(i))=data
				While pos'>$length(RowSet) {
					Set data=$list($extract(RowSet,pos,*),1,columns),pos=pos+$length(data)
					Set ^($increment(i))=data
				}
				Quit:$$$ISERR(sc)||(AtEnd)||(..MaxRows&&(i>..MaxRows))
			}
		}
	} Else {
		Merge qHandle=i%QHandle
		Set i="",classname=..ClassName,query=..QueryName_"FetchRows",AtEnd=0
		For  {
			Set sc=$classmethod(classname,query,.qHandle,0,.RowSet,.ReturnCount,.AtEnd)
			Quit:$get(RowSet)=""
			Set data=$list(RowSet,1,columns),pos=$length(data)+1
			Set ^CacheTempRSet(idx,"Data",$increment(i))=data
			While pos'>$length(RowSet) {
				Set data=$list($extract(RowSet,pos,*),1,columns),pos=pos+$length(data)
				Set ^($increment(i))=data
			}
			Quit:$$$ISERR(sc)||(AtEnd)||(..MaxRows&&(i>..MaxRows))
		}
		Kill i%QHandle Merge i%QHandle=qHandle
	}
	Set ..AtEnd=0,i%CurrRow=""
	If ..RuntimeMode'="" Do $zu(115,5,PrevMode)
	Do ..Close()
	QUIT sc
}

/// Advance the result set cursor to the next row. Returns 0 if the cursor is at the end of the 
/// result set.
Method Next(ByRef sc As %Status) As %Integer
{
	Set sc = $$$OK
	If ..TempIndex="" Set sc=..PopulateData() If $$$ISERR(sc) Quit sc
	Kill i%Data
	Set i%CurrRow = $order(^CacheTempRSet(..TempIndex,"Data",i%CurrRow),1,Row)
	If (i%CurrRow = "") {
		Set ..AtEnd=1,..Row=""
		Quit 0
	}
	
	#; move data into row buffer
	For i=1:1:..ColIndex Set i%Data(i%ColIndex(i))=$listget(Row,i)
	Set ..Row=Row,..AtEnd=0
	Quit 1
}

/// Advance the result set cursor to the previous row. Returns 0 if the cursor is at the end of the 
/// result set.
Method Previous(ByRef sc As %Status) As %Integer
{
	Set sc = $$$OK
	If ..TempIndex="" Set sc=..PopulateData() If $$$ISERR(sc) Quit sc
	Kill i%Data
	Set i%CurrRow = $order(^CacheTempRSet(..TempIndex,"Data",i%CurrRow),-1,Row)
	If (i%CurrRow = "") {
		Set ..AtEnd=1,..Row=""
		Quit 0
	}
	
	#; move data into row buffer
	For i=1:1:..ColIndex Set i%Data(i%ColIndex(i))=$listget(Row,i)
	Set ..Row=Row,..AtEnd=0
	Quit 1
}

/// Returns the number of rows contained in this ResultSet.
Method Count() As %Integer
{
	If ..TempIndex="" Set sc=..PopulateData() If $$$ISERR(sc) Quit 0
	Quit $select(..TempIndex="":0,1:+$order(^CacheTempRSet(..TempIndex,"Data",""),-1))
}

ClassMethod %OpenId(id As %String, concurrency As %Integer = -1, ByRef sc As %Status = {$$$OK}) As %ObjectHandle
{
	Set oref=..%New()
	Set sc=oref.Load(id)
	If $$$ISERR(sc) Quit ""
	Quit oref
}

Method Load(id As %String) As %Status
{
	If '$data(^CacheTempRSet(id)) Quit $$$ERROR($$$LoadObjectNotFound)
	Set ..TempIndex=id,..IsSaved=0
	Merge i%ColIndex=^CacheTempRSet(..TempIndex,"Index"),i%QHandle=^CacheTempRSet(..TempIndex,"QHandle"),i%Data=^CacheTempRSet(..TempIndex,"RowData")
	Set data=^CacheTempRSet(..TempIndex,"Info")
	Set ..ClassName=$listget(data),..QueryName=$listget(data,2),..RuntimeMode=$listget(data,3),..HasInfo=$listget(data,4),..ParamInfo=$listget(data,5)
	Set ..ColInfo=$listget(data,6),..IdInfo=$listget(data,7),..AtEnd=$listget(data,8),..IsOpened=$listget(data,9),i%CurrRow=$listget(data,10)
	Set ..Row=^CacheTempRSet(..TempIndex,"Row")
	Quit $$$OK
}

Method %Save() As %Status
{
	If ..TempIndex="" Set sc=..PopulateData() If $$$ISERR(sc) Quit sc
	Set ..IsSaved=1
	Merge ^CacheTempRSet(..TempIndex,"Index")=i%ColIndex,^CacheTempRSet(..TempIndex,"QHandle")=i%QHandle,^CacheTempRSet(..TempIndex,"RowData")=i%Data
	Set ^CacheTempRSet(..TempIndex,"Info")=$listbuild(..ClassName,..QueryName,..RuntimeMode,..HasInfo,..ParamInfo,..ColInfo,..IdInfo,..AtEnd,..IsOpened,..CurrRow)
	Set ^CacheTempRSet(..TempIndex,"Row")=..Row,^CacheTempRSet(..TempIndex)=$listbuild($zdt($horolog,3),$job)
	Quit $$$OK
}

ClassMethod %DeleteId(id As %String, concurrency As %Integer = -1) As %Status
{
	Kill ^CacheTempRSet(id)
	Quit $$$OK
}

Method %Id() As %String [ CodeMode = expression, Final ]
{
$select(..IsSaved:..TempIndex,1:"")
}

Method GetObject() As %RegisteredObject [ ProcedureBlock = 1 ]
{
	If ..TempIndex="" {
		If '..IsOpened Set sc=..PopulateData() If $$$ISERR(sc) Quit $$$NULLOREF
		Quit $$$NULLOREF
	}
	If 'i%HasInfo If $$$ISERR(..GetInfo()) Quit $$$NULLOREF
	If '$list(i%IdInfo,1)||($listget(i%IdInfo,2)="")||(i%Row="") Quit $$$NULLOREF
	Set id=$listget(i%Row,$list(i%IdInfo))
	Quit $classmethod($list(i%IdInfo,2),"%OpenId",id)
}

}
