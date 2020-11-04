Include (%sySystem, %sySite, %msql)

IncludeGenerator %msql

///  System Management Portal SQL Catalog Queries
/// 
///  <br><b><u>This class is used internally by Cach&eacute;
///  <br>You should not make direct  use of it within your applications.
///  There is no guarantee made about either the behavior or future operation of this class.</b></u>
Class %SQL.Manager.Catalog Extends %RegisteredObject [ Not ProcedureBlock, System = 3 ]
{

///  Get the currently defined EXTENTSIZE of a base table
///  <b>Parameters:</b>
///  <ul>
///  <li>%schema: name of the table's schema (required)</li>
///  <li>%tablename: name of the table (required)</li>
///  </ul>
ClassMethod GetCurrentTableExtentSize(%schema As %Library.String, %tablename As %Library.String) As %Library.Integer [ Internal, ProcedureBlock = 1 ]
{
 s ext=$$$GetExtentNameFromTableName(%schema,%tablename) QUIT:ext="" ""
 s x=$g($$$EXTsqlinfo($$$rEXT,ext))
 Quit $$$SQLLocTableExtentSize(x)
}

///  Calculate the actual EXTENTSIZE of a base table
///  <b>Parameters:</b>
///  <ul>
///  <li>%schema: name of the table's schema (required)</li>
///  <li>%tablename: name of the table (required)</li>
///  </ul>
ClassMethod GetCalcTableExtentSize(%schema As %Library.String, %tablename As %Library.String, pSC As %Library.Status) As %Library.Integer [ Internal, ProcedureBlock = 1 ]
{
	set %tablename=%schema_"."_$tr(%tablename,".",$c(2))
	Quit $$GetNumberRows^%qarTune(%tablename,,,,.pSC)
}

///  Set the EXTENTSIZE parameter of a class and table to the value of extentsize
///  <b>Parameters:</b>
///  <ul>
///  <li>%schema: name of the table's schema (required)</li>
///  <li>%tablename: name of the table (required)</li>
///  </ul>
ClassMethod SetTableExtentSize(pSchema As %Library.String, pTablename As %Library.String, pExtentSize As %Library.Integer, pKeepClassUpToDate As %Boolean = 0) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#dim tClassname,tCollection,tExtent,tParentClass As %String
	#dim tTabInfo As %List
	#dim tReturnValue As %Status
	
	QUIT:$g(pSchema)="" $$$OK
	QUIT:$g(pTablename)="" $$$OK
	set tExtent=$$$GetExtentNameFromTableName(pSchema,pTablename)
	QUIT:tExtent="" $$$OK
	set tTabInfo=$$$EXTsqlinfo($$$rEXT,tExtent)
	set tClassname=$$$SetSQLLocTableClassname(tTabInfo)
 	if $Case($$$SQLLocTableChildTableType(tTabInfo),"A":1,"L":1,:0) {
		set tParentClass = $$$SQLLocTableParentExtent(tTabInfo)
		set tCollection = $ListGet($$$comClassArrayGet(tParentClass,$$$cCLASSextents,tExtent))	// tCollection is the name of the collection property
	}
	else { set tCollection = "" }
	set tReturnValue=$$SetExtentSize^%qarTune(tExtent,tTabInfo,tClassname,,pExtentSize,0,1,,,,pKeepClassUpToDate,tCollection,$g(tParentClass))
		#;  Now update the Q.O. map statistics since the EXTENTSIZE probably changed
	do NumberOfTuples^%ocsSQLRTDict(tExtent)
	do DeleteExtentCQ^%SYS.SQLSRV(tExtent)
	QUIT tReturnValue
}

///  Set the SELECTIVITY parameter of a field and property to the value of selectivity
///  <b>Parameters:</b>
///  <ul>
///  <li>%schema: name of the table's schema (required)</li>
///  <li>%tablename: name of the table (required)</li>
///  <li>%fieldname: name of the field (required)</li>
///  <li>selectivity: New selectivity value (property parameter format)</li>
///  <li>OutlierSelectivity: New outlier selectivity value (.##)</li>
///  <li>OutlierValue: If there is an outlier selectivity, the value for the outlier</li>
///  </ul>
ClassMethod SetFieldSelectivity(pSchema As %Library.String, pTableName As %Library.String, pFieldName As %Library.String, pSelectivity As %Library.String, pKeepClassUpToDate As %Boolean = 0, pOutlierSelectivity As %String = "", pOutlierValue As %String = "", pAverageFieldSize As %Integer = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#dim tClassname,tCollection,tExtent,tExtentSize,tFldInfo,tParentClass,tTabInfo As %String
	#dim sc As %Status
	
	QUIT:$g(pSchema)="" $$$OK
	QUIT:$g(pTableName)="" $$$OK
	QUIT:$g(pFieldName)="" $$$OK
	set tExtent=$$$GetExtentNameFromTableName(pSchema,pTableName)   QUIT:tExtent="" $$$OK
	set tFldInfo=$g($$$EXTSQLCOLsqlinfo($$$rEXT,tExtent,pFieldName)) QUIT:tFldInfo="" $$$OK
	set tTabInfo=$$$EXTsqlinfo($$$rEXT,tExtent)
	set tClassname=$$$SetSQLLocTableClassname(tTabInfo)
	set tExtentSize=$$$SQLLocTableExtentSize(tTabInfo)
 	if $Case($$$SQLLocTableChildTableType(tTabInfo),"A":1,"L":1,:0) {
		set tParentClass = $$$SQLLocTableParentExtent(tTabInfo)
		set tCollection = $ListGet($$$comClassArrayGet(tParentClass,$$$cCLASSextents,tExtent))	// tCollection is the name of the collection property
	}
	else { set tCollection = "" }
	if pOutlierSelectivity'="" {
		set tOutlierSelectivity=$lb(pOutlierSelectivity/100,$s(pOutlierValue="":"",1:##class(%Library.Global).Unquote(pOutlierValue)))
	}
	else { set tOutlierSelectivity="" }
	set sc=$$SetSelectivity^%qarTune(tExtent,pFieldName,tFldInfo,tClassname,tExtentSize,pSelectivity,$$ConvertSelectivity^%ocsExtent(pSelectivity,tExtentSize),,,,pKeepClassUpToDate,tCollection,$g(tParentClass),,tOutlierSelectivity,pAverageFieldSize)
	Do DeleteExtentCQ^%SYS.SQLSRV(tExtent)
	QUIT sc
}

///  Set the BLOCKCOUNT value of an SQL Map to the value of pBlockCount
///  <b>Parameters:</b>
///  <ul>
///  <li>pSchema: name of the table's schema (required)</li>
///  <li>pTtableName: name of the table (required)</li>
///  <li>pMapName: name of the sql map (required)</li>
///  <li>pBlockCount: New block count value (required, integer)</li>
///  <li>pKeepClassUpToDate: 1/0, if 1 after updating the block count the class will still be uptodate</li>
///  </ul>
ClassMethod SetMapBlockCount(pSchema As %Library.String, pTableName As %Library.String, pMapName As %Library.String, pBlockCount As %Library.String, pKeepClassUpToDate As %Boolean = 0) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#dim tClassname,tCollection,tExtent,tParentClass,tTabInfo As %String
	#dim tSC As %Status
	
	QUIT:$g(pSchema)="" $$$OK
	QUIT:$g(pTableName)="" $$$OK
	QUIT:$g(pMapName)="" $$$OK
	//QUIT:$g(pBlockCount)="" $$$OK
	set tExtent=$$$GetExtentNameFromTableName(pSchema,pTableName)
	QUIT:tExtent="" $$$OK
	set tTabInfo=$$$EXTsqlinfo($$$rEXT,tExtent)
	set tClassname=$$$SetSQLLocTableClassname(tTabInfo)
 	if $Case($$$SQLLocTableChildTableType(tTabInfo),"A":1,"L":1,:0) {
		set tParentClass = $$$SQLLocTableParentExtent(tTabInfo)
		set tCollection = $ListGet($$$comClassArrayGet(tParentClass,$$$cCLASSextents,tExtent))	// tCollection is the name of the collection property
	}
	else { set tCollection = "",tParentClass="" }
	do SetBlockCount^%qarTune(tExtent,pMapName,pBlockCount,.tSC,"",0,pKeepClassUpToDate,tCollection,0,1,tParentClass)
	do DeleteExtentCQ^%SYS.SQLSRV(tExtent)
	QUIT tSC
}

/// <pre>
/// The CachedQueryInfo query returns a list of cached queries the current user has privilege to see in a given schema.
/// Note that only the first 80 characters of a query are returned.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.CachedQueryInfo Procedure
/// 	%SQL.Manager.Catalog.CachedQueryInfo(%schema)
/// 		Returns Cached Queries the current user is privileged to see in a given schema
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 		ROWSPEC = ROUTINE:%Library.String		- Name of the Cached Query's routine
/// 			  QUERY:%Library.String 		- Cached Query's SQL Text
/// 			  CREATE_TIME:%Library.TimeStamp	- Date/Time of Cached Query creation
/// 			  SOURCE:%Library.Boolean		- Cached Query source there?
/// 			  QUERYTYPE:%Integer			- 6 or 7
/// 			  QUERYTYPE_EXT:%String			- ODBC QUERY OR DYNAMIC QUERY
/// 			  COST:%Library.Numeric			- QO Generated Cost of the query
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query CachedQueryInfo(%schema As %Library.String) As %Library.Query(ROWSPEC = "Routine:%Library.String,Query:%Library.String,CreateTime:%Library.TimeStamp,Source:%Library.Boolean,QueryType:%Integer,QueryTypeExt:%Library.String,Cost:%Library.Numeric") [ Internal, SqlName = CachedQueryInfo, SqlProc ]
{
}

ClassMethod CachedQueryInfoExecute(ByRef qh As %Library.Binary, %schema As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s package=$$GetPackage^%apiDDL(%schema)
 s qh=$i(^CacheTemp),%r(qh)=""
 $$$AddTempNode(^CacheTemp(qh))
 s sc=$$CQInfoExecute^%SYS.SQLSRV(qh,package,"%SQL.Manager.Catalog::CachedQueryInfoExecute")
 Quit sc
}

ClassMethod CachedQueryInfoFetch(ByRef qh As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ Internal ]
{
	s AtEnd=0,Row="" s %r(qh)=$o(^CacheTemp(qh,%r(qh)),1,Row) QUIT $$$OK
}

ClassMethod CachedQueryInfoClose(qh As %Library.Binary) As %Library.Status [ Internal ]
{
	k %r(qh),^CacheTemp(qh) $$$RemoveTempNode(^CacheTemp(qh)) QUIT $$$OK
}

/// <pre>
/// The CachedQueryTable query returns a list of cached queries for a given table/view.
/// Note that only the first 80 characters of a query are returned.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.CachedQueryTable Procedure
/// 	%SQL.Manager.Catalog.CachedQueryTable('%schema','%table')
/// 		Returns Cached Queries on this table the current user is privileged to see
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table or view
/// 		ROWSPEC = ROUTINE:%Library.String		- Name of the Cached Query's routine
/// 			  QUERY:%Library.String			- Cached Query's SQL Text
/// 			  CREATE_TIME:%Library.TimeStamp	- Date/Time of Cached Query creation
/// 			  SOURCE:%Library.Boolean		- Cached Query source there?
/// 			  QUERYTYPE:%Integer			- 6 or 7
/// 			  QUERYTYPE_EXT:%String			- ODBC QUERY OR DYNAMIC QUERY
/// 			  COST:%Library.Numeric			- QO Cost for the query
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query CachedQueryTable(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "Routine:%Library.String,Query:%Library.String,CreateTime:%Library.TimeStamp,Source:%Library.Boolean,QueryType:%Integer,QueryTypeExt:%Library.String,Cost:%Library.Numeric") [ Internal, SqlName = CachedQueryTable, SqlProc ]
{
}

ClassMethod CachedQueryTableExecute(ByRef qh As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
		#;  Assume schema/table name are already in proper case.
	s extent=$$$GetExtentNameFromTableName(%schema,%table)
	s qh=$i(^CacheTemp),%r(qh)=""
	QUIT:extent="" $$$OK
	s tabinfo=$$$EXTsqlinfo($$$rEXT,extent)
	s classname=$$$SQLLocTableClassname(tabinfo)
	$$$AddTempNode(^CacheTemp(qh))
	s sc=$$CQTableExecute^%SYS.SQLSRV(qh,classname,"%SQL.Manager.Catalog::CachedQueryTableExecute")
	Quit sc
}

ClassMethod CachedQueryTableFetch(ByRef qh As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s AtEnd=0,Row="" s %r(qh)=$o(^CacheTemp(qh,%r(qh)),1,Row) QUIT $$$OK
}

ClassMethod CachedQueryTableClose(qh As %Library.Binary) As %Library.Status [ Internal ]
{
	k %r(qh),^CacheTemp(qh) $$$RemoveTempNode(^CacheTemp(qh)) QUIT $$$OK
}

/// <pre>
/// Returns information about the cached query <var>Routine</var>.
/// <p>Returns a string containing the query text for the cached query.
/// Returns the create times by reference.
/// <p><var>Source</var> indicates that there is source for the routine and <var>QueryType</var> indicates whether it is a ODBC query or a Dynamic query.
/// </pre>
ClassMethod GetCachedQueryInfo(Routine As %Library.String, ByRef CreateTime As %Library.TimeStamp, ByRef Source As %Library.Boolean, ByRef QueryType As %Library.Integer, ByRef Cost As %Library.Numeric) As %Library.String [ Internal, ProcedureBlock = 1 ]
{
	QUIT $$GetCachedQueryInfo^%SYS.SQLSRV(Routine,.CreateTime,.Source,.QueryType,.Cost)
}

/// <pre>
/// Returns a list of all SQLCODE values and descriptions
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.SQLCODEList Procedure
/// 	%SQL.Manager.Catalog.SQLCODEList()
/// 		Returns list of all SQLCODE values and descriptions
/// 		ROWSPEC = SQLCODE:%Library.SmallInt	- SQLCODE number
/// 			  DESCRIPTION:%Library.String	- SQLCODE Description
/// 		Rows are returned in SQLCODE order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query SQLCODEList() As %Library.Query(ROWSPEC = "SQLCODE:%Library.SmallInt,DESCRIPTION:%Library.String") [ Internal, SqlName = SQLCODEList, SqlProc ]
{
}

ClassMethod SQLCODEListExecute(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s %q=1,%i(%q)=-11003 QUIT $$$OK
}

ClassMethod SQLCODEListFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s %i(%q)=%i(%q)+1,AtEnd=0,Row="" if %i(%q)>100 s AtEnd=1 QUIT $$$OK
 s:%i(%q)=-10049 %i(%q)=-500 s:%i(%q)=-100 %i(%q)=-99 s:%i(%q)=1 %i(%q)=100
SLoop s eText=$$$FormatMessage(,"%SqlCode","SqlCode"_$zabs(%i(%q)),,) if eText="" { s %i(%q)=%i(%q)+1 if %i(%q)=101 { QUIT $$$OK } GOTO SLoop } 
 s Row=$lb(%i(%q),eText)
 QUIT $$$OK
}

ClassMethod SQLCODEListClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %i(%q) QUIT $$$OK
}

/// <pre>
/// Get a List of all constraints from a schema.table.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.Constraints Procedure
/// 	%SQL.Manager.Catalog.Constraints('schema','table')
/// 		Returns all constraints in the table:
/// 		ARGUMENTS = schema	- Name of a schema.
/// 			    table	- Name of a table
/// 		ROWSPEC = CONSTRAINT_NAME:%Library.String	- Name of the constraint
/// 			  TYPE:%Library.String			- Type of constraint
/// 			  CONSTRAINT_DATA:%Library.String	- Constraint info depends on type
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query Constraints(schema As %Library.String, table As %Library.String) As %Library.Query(ROWSPEC = "CONSTRAINT_NAME:%Library.String(MAXLEN=64),CONSTRAINT_TYPE:%Library.String(MAXLEN=15),CONSTRAINT_DATA:%Library.String(MAXLEN=255)") [ Internal, SqlName = Constraints, SqlProc ]
{
}

ClassMethod ConstraintsExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 	#; %q(1) = constraint loop variable
 	#; %q(2) = extentname
 	#; %q(3) = contraint type (1 - explicit, or 2 implicit)
 	#; %q(4) = schema name
 	#; %q(5) = table name
	set %q(1)="",%q(3)=1
	QUIT:$g(%schema)="" $$$OK		// No error now, just return no info in Fetch
	QUIT:$g(%table)="" $$$OK		// No error now, just return no info in Fetch
	set %q(2)=$$$GetExtentNameFromTableName(%schema,%table)	// extentname
	QUIT:%q(2)="" $$$OK		// No error now, just return no info in Fetch
	set %q(4)=%schema,%q(5)=%table
	QUIT $$$OK
}

ClassMethod ConstraintsFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set AtEnd=0,Row=""
	if %q(2)="" s AtEnd=1 QUIT $$$OK
	if %q(3)=2 GOTO CFLOOP2
	if %q(3)=3 GOTO CFLOOP3
CFLOOP	set %q(1)=$o($$$EXTCONS($$$pEXT,%q(2),%q(1)))
	if %q(1)="" set %q(3)=2 GOTO CFLOOP2
	set data=$$$EXTCONSsqlinfo($$$pEXT,%q(2),%q(1))
	set $li(Row)=$lg(data,4)    ; Constraint name
	if $li(Row)="" s Row="" g CFLOOP  ; Must be a %rowid 'fake' constraint
	set $li(Row,2)=$lg(data,2) set:$li(Row,2)="PKEY" $li(Row,2)="PRIMARY KEY"	// Constraint type
	set $li(Row,3)=$lg(data,3)							// Constraint info
	if $li(Row,2)="UNIQUE"||($li(Row,2)="PKEY") {
 		for i=1:1:$l($li(Row,3),",") s $p(v,", ",i)=$$quoter2^%apiDDL($p($li(Row,3),",",i))
 		set $li(Row,3)="("_v_")"  ; (Field1, Field2, ..., FieldN)
 	}
	if $li(Row,2)="FKEY" {
		for i=1:1:$l($li($li(Row,3),1),",") s $p(fkeyflds,", ",i)=$$quoter2^%apiDDL($p($li($li(Row,3),1),",",i))
		set fkeyflds="("_fkeyflds_")"  ; (Field1, Field2, ..., FieldN)
		set reftab=$$quoter2^%apiDDL($li($li(Row,3),2))
		for i=1:1:$l($li($li(Row,3),3),",") s $p(refflds,", ",i)=$$quoter2^%apiDDL($p($li($li(Row,3),3),",",i))
		set refflds="("_refflds_")"  ; (Field1, Field2, ..., FieldN)
		set $li(Row,2)="FOREIGN KEY"
		set urule=$li($li(Row,3),6)
		set drule=$li($li(Row,3),7)
		set $li(Row,3)=fkeyflds_" REFERENCES "_reftab_" "_refflds_" ON UPDATE "_urule_" ON DELETE "_drule
	}
	QUIT $$$OK
CFLOOP2	; report implicit primary key constraints
	set %q(1)=$o(^oddSQL(%q(4),%q(5),4,%q(1)),1,data)
	if %q(1)="" set %q(3)=3 GOTO CFLOOP3
	set name=$lg(data,6) GOTO CFLOOP2:name'="RowIDField_As_PKey"
	set Row=$lb(name,"Implicit PRIMARY KEY")
	set fields="("_$lg(data,4)
	for  set %q(1)=$o(^oddSQL(%q(4),%q(5),4,%q(1)),1,data) q:%q(1)=""  set fields=fields_","_$lg(data,4)
	set Row=Row_$lb(fields_")")
	set %q(3)=3
	QUIT $$$OK
CFLOOP3	; report implicit foreign key constraints
	set %q(1)=$o(^oddSQL(%q(4),%q(5),5,%q(1)),1,data)
	if %q(1)="" set AtEnd=1,Row="" QUIT $$$OK
	set name=$lg(data,12) GOTO CFLOOP3:$e(name,1,11)'="REFERENCE__"
	set Row=$lb($lg(data,12),"Implicit FOREIGN KEY")
	set reftab=$lg(data,2)_"."_$lg(data,3)
	set refflds="("_$lg(data,4)_")"
	set fkeyflds="("_$lg(data,8)_")"
	set urule=$lg(data,10) set urule=$case(urule,0:"CASCADE",1:"RESTRICT",2:"SET NULL",3:"NO ACTION",4:"SET DEFAULT",:"???")
	set drule=$lg(data,11) set drule=$case(drule,0:"CASCADE",1:"RESTRICT",2:"SET NULL",3:"NO ACTION",4:"SET DEFAULT",:"???")
	set $li(Row,3)=fkeyflds_" REFERENCES "_reftab_" "_refflds_" ON UPDATE "_urule_" ON DELETE "_drule
	QUIT $$$OK
}

ClassMethod ConstraintsClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
/// Get a List of all Fields from a schema.table.
/// %SQL_MANAGER.Fields Procedure
/// 	%SQL.Manager.Catalog.Fields('%schema','%table')
/// 		Returns all fields in the table:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table
/// 		ROWSPEC = FIELD_NAME:%Library.String		- Name of the field
/// 			  DATATYPE:%Library.String		- Field's datatype
/// 			  COLUMN_NUMBER:%Library.Integer	- Field's internal column number
/// 			  REQUIRED:%Library.String		- Is field required, 'Yes' or 'No'
/// 			  UNIQUE:%Library.String		- Is field unique, 'Yes', or 'No'
/// 			  COLLATION_FUNCTION:%Library.String 	- ALPHAUP, UPPER, STRING, EXACT, PLUS or MINUS
/// 			  HIDDEN:%Library.String		- Is field hidden, 'Yes' or 'No'
/// 			  MAXLEN:%Library.String		- MAXLEN parameter of field (or NULL)
/// 			  MAXVAL:%Library.String		- MAXVAL parameter of field (or NULL)
/// 			  MINVAL:%Library.String		- MINVAL parameter of field (or NULL)
/// 			  BLOB:%Library.String			- Is field a BLOB, 'Yes' or 'No'
/// 			  CONTAINER_FIELD:%Library.String	- If this is a sub-field of a serial container, the name of the serial field
/// 			  XDBC_TYPENAME:%Library.String		- xDBC TYPENAME for this column
/// 			  REFERENCE_TO:%Library.String		- If a reference field, name of the table referenced
/// 			  VERSION_COLUMN:%Library.String	- Is this field a Version Column, 'Yes' or 'No'
/// 			  SELECTIVITY:%Library.String		- Field's SELECTIVITY
/// 			  OUTLIER_SELECTIVITY:%Library.String	- The Outlier Selectivity (if any) for this field
/// 			  OUTLIER_VALUE:%Library.String		- The Outlier Value (if any) for this field
/// 			  AVERAGE_FIELD_SIZE:%Library.String	- The average size of the field's data
/// 		Rows are returned in column number order
/// </pre>
Query Fields(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "FIELD_NAME:%Library.String,DATATYPE:%Library.String,COLUMN_NUMBER:%Library.Integer,REQUIRED:%Library.String,UNIQUE:%Library.String,COLLATION_FUNCTION:%Library.String,HIDDEN:%Library.String,MAXLEN:%Library.String,MAXVAL:%Library.String,MINVAL:%Library.String,BLOB:%Library.String,CONTAINER_FIELD:%Library.String,XDBC_TYPENAME:%Library.String,REFERENCE_TO:%Library.String,VERSION_COLUMN:%Library.String,SELECTIVITY:%Library.String,OUTLIER_SELECTIVITY:%Library.String,OUTLIER_VALUE:%Library.String,AVERAGE_FIELD_SIZE:%Library.String") [ Internal, SqlName = Fields, SqlProc ]
{
}

ClassMethod FieldsExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	 #;  %q(1) = Extent Name
	 #;  %q(2) = Field icol $Order loop variable
	 #;  %q(2,icol) = Field Name
	 #;  $q(3) = privilege object string
	 #;  %q(4) = privileged at table level? (1/0)
	 #;  %q(5) = schema
	 #;  %q(6) = tablename
 s %q(1)=$$$GetExtentNameFromTableName(%schema,%table) QUIT:%q(1)="" $$$OK
 s x="",%q(2)="",%q(3)="1,"_%schema_"."_%table,%q(4)=$$AnyPrivTable^%SYS.SQLSEC(%q(3),0),%q(5)=%schema,%q(6)=%table
 For  s x=$o($$$EXTSQLCOL($$$rEXT,%q(1),x)) q:x=""  s d=$$$EXTSQLCOLsqlinfo($$$rEXT,%q(1),x) s %q(2,$$$SQLLocColNumber(d))=x
 QUIT $$$OK
}

ClassMethod FieldsFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s AtEnd=0,Row=""
	If %q(1)="" s AtEnd=1 QUIT $$$OK
Loop	s %q(2)=$o(%q(2,%q(2)),1,fieldname)
	If %q(2)="" s AtEnd=1 QUIT $$$OK
	goto:'%q(4)&&'$$AnyPrivField^%SYS.SQLSEC(%q(3),fieldname,0) Loop
	s x=$$$EXTSQLCOLsqlinfo($$$rEXT,%q(1),fieldname)
	s sel=$$$SQLLocColSelectivity(x),sel=$s(sel="NUMROWS":1,sel["NUMROWS":sel,'sel:"",1:$j((100/sel),0,4)_"%")
	s col=$$$SQLLocColCollation(x)	// Collation
	s col=$s(col="A":"ALPHAUP",col="U":"UPPER",col="E":"EXACT",col="P":"PLUS",col="M":"MINUS",col="MV":"MVR",col="S":"SPACE",col="T":"STRING",col["T(":"STRING"_"("_$p(col,"(",2),col="SS":"SQLSTRING",col["SS(":"SQLSTRING"_"("_$p(col,"(",2),col="SU":"SQLUPPER",col["SU(":"SQLUPPER"_"("_$p(col,"(",2),col="TR":"TRUNCATE",col["TR(":"TRUNCATE"_"("_$p(col,"(",2),1:"")
	s maxlen="",minval="",maxval=""
	If $$$SQLLocColTypeParameters(x)'="" {
		set parms=$$$SQLLocColTypeParameters(x)
		for i=1:1:$ll(parms) {
			if $lg(parms,i)["MAXLEN=" { set maxlen=$p($lg(parms,i),"=",2) }
			if $lg(parms,i)["MAXVAL=" { set maxval=$p($lg(parms,i),"=",2) }
			if $lg(parms,i)["MINVAL=" { set minval=$p($lg(parms,i),"=",2) }
		}
	}
	set vercol="No"
	if $d(^oddSQL(%q(5),%q(6),13)) {
		set i="" for  { set i=$o(^oddSQL(%q(5),%q(6),13,i),1,data) q:i=""  if $lg(data,2)=fieldname set vercol="Yes" q  }
	}
	set tOutlierSelectivity=$$$SQLLocColOutlierSelectivity(x)
	if tOutlierSelectivity'="" {
		set tOutlierSel=($lg(tOutlierSelectivity)*100)_"%"
		set tOutlierValue=$lg(tOutlierSelectivity,2)
		set tOutlierValue=$s(tOutlierValue="":"<Null>",1:##class(%Library.Global).Quote(tOutlierValue))
	}
	//s sel=$s(sel="NUMROWS":1,sel["NUMROWS":sel,'sel:"",1:$j((100/sel),0,4)_"%")
	s Row=$lb(fieldname,$$$SQLLocColDatatype(x),$$$SQLLocColNumber(x),$s($$$SQLLocColRequired(x)="Y":"Yes",1:"No"),$s($$$SQLLocColUnique(x)="Y":"Yes",1:"No"),col,$s($$$SQLLocColHidden(x)="Y":"Yes",1:"No"),maxlen,maxval,minval,$s($$$SQLLocColStream(x)=1:"Yes",1:"No"),$$$SQLLocColContainerField(x),$$$SQLLocColxDBCType(x),$s($$$SQLLocColReferencedTable(x)="":"",1:$$quoter2^%apiSQL($$$AllButLastPiece($$$SQLLocColReferencedTable(x),"."))_"."_$$quoter2^%apiSQL($tr($$$LastPiece($$$SQLLocColReferencedTable(x),"."),$c(2),"."))),vercol,sel,tOutlierSel,tOutlierValue,$$$SQLLocColAverageFieldSize(x))
	QUIT $$$OK
}

ClassMethod FieldsClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
/// Get a List of all Field's selectivity from a schema.table.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.FieldCurrentSelectivity Procedure
/// 	%SQL.Manager.Catalog.FieldCurrentSelectivity('%schema','%table')
/// 		Returns all fields in the table:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table
/// 		ROWSPEC = FIELD_NAME:%Library.String		- Name of the field
/// 			  SELECTIVITY:%Library.String		- Field's SELECTIVITY setting
/// 			  NOTES:%Library.String			- Misc information about the field
/// 			  OUTLIER_SELECTIVITY:%Library.String	- Field's outlier selectivity (if any)
/// 			  OUTLIER_VALUE:%Library.String		- If there is an outlier selectivity, the value for the outlier
/// 			  AVERAGE_FIELD_SIZE:%Library.Numeric	- Field's average length of data
/// 		Rows are returned in field name order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query FieldCurrentSelectivity(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "FIELD_NAME:%Library.String(MAXLEN=128),SELECTIVITY:%Library.String(MAXLEN=24),NOTES:%Library.String(MAXLEN=50),OUTLIER_SELECTIVITY:%Library.String,OUTLIER_VALUE:%Library.String,AVERAGE_FIELD_SIZE:%Library.String") [ Internal, SqlName = FieldCurrentSelectivity, SqlProc ]
{
}

ClassMethod FieldCurrentSelectivityExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	 #;  %q(1) = Extent Name
	 #;  %q(2) = Field icol $Order loop variable
	 #;  %q(2,$$$UPPER(FieldName)) = $lb(Field Name,selectivity,notes)
	 
	#dim cfldinfo,d,notes,tabinfo,x As %String
	s %q(1)=$$$GetExtentNameFromTableName(%schema,%table) QUIT:%q(1)="" $$$OK
	set tabinfo=$g($$$EXTsqlinfo($$$rEXT,%q(1)))
	s x="",%q(2)=""
	For  {
		s notes=""
		s x=$o($$$EXTSQLCOL($$$rEXT,%q(1),x)) q:x=""  
		s d=$$$EXTSQLCOLsqlinfo($$$rEXT,%q(1),x)
		s:$$$SQLLocColNumber(d)=0 notes="Parent reference field"
		s:$$$SQLLocColNumber(d)=1 notes="RowID field"
		s:$$$SQLLocColHidden(d)="Y" notes=notes_$s(notes'="":", ",1:"")_"Hidden field"
		s:$$$SQLLocColStream(d)=1 notes=notes_$s(notes'="":", ",1:"")_"Stream field"
		If $$$SQLLocColContainerField(d)="" {
			set:$$$comMemberArrayGet($$$SQLLocTableClassname(tabinfo),$$$cCLASSproperty,$$$SQLLocColPropertyName(d),$$$cPROPparameter,"CALCSELECTIVITY")=0 notes=notes_$s(notes'="":", ",1:"")_"SELECTIVITY will not be calculated"
		}
		Else {
			s cfldinfo=$$$EXTSQLCOLsqlinfo($$$rEXT,%q(1),$$$SQLLocColContainerField(d))
			set:$$$comMemberArrayGet($$$SQLLocColDatatype(cfldinfo),$$$cCLASSproperty,$$$SQLLocColPropertyName(d),$$$cPROPparameter,"CALCSELECTIVITY")=0 notes=notes_$s(notes'="":", ",1:"")_"SELECTIVITY will not be calculated"
		}
		set tOutlierSelectivity=$$$SQLLocColOutlierSelectivity(d),tOutlierSel="",tOutlierValue=""
		if tOutlierSelectivity'="" {
			set tOutlierSel=($lg(tOutlierSelectivity)*100)_"%"
			set tOutlierValue=$lg(tOutlierSelectivity,2)
			set tOutlierValue=$s(tOutlierValue="":"<Null>",1:##class(%Library.Global).Quote(tOutlierValue))
		}
		set %q(2,$$$UPPER(x))=$lb(x,$s($$$SQLLocColSelectivity(d)="NUMROWS":1,'$$$SQLLocColSelectivity(d):"",1:$j((100/$$$SQLLocColSelectivity(d)),0,4)_"%"),notes,tOutlierSel,tOutlierValue,$$$SQLLocColAverageFieldSize(d))
	}
	QUIT $$$OK
}

ClassMethod FieldCurrentSelectivityFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s AtEnd=0,Row=""
 If %q(1)="" s AtEnd=1 QUIT $$$OK
 s %q(2)=$o(%q(2,%q(2)),1,Row)
 If %q(2)="" s Row="",AtEnd=1 QUIT $$$OK
 QUIT $$$OK
}

ClassMethod FieldCurrentSelectivityClose(%q As %Library.Binary) As %Library.Status [ Internal ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
/// Get a List of all Field's selectivity from a schema.table.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
///  %SQL_MANAGER.FieldCalcSelectivity Procedure
/// 	%SQL.Manager.Catalog.FieldCalculatedSelectivity('%schema','%table')
/// 		Returns all fields and selectivities for the table:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table or view
/// 		ROWSPEC = FIELD_NAME:%Library.String		- Name of the field
/// 			  SELECTIVITY:%Library.String		- Field's Calculated SELECTIVITY setting
/// 			  OUTLIER_SELECTIVITY:%Library.String	- Field's outlier selectivity (if any)
/// 			  OUTLIER_VALUE:%Library.String		- If there is an outlier selectivity, the value for the outlier
/// 			  AVERAGE_FIELD_SIZE:%Library.Integer	- Field's calculated average data size
/// 		Rows are returned in $$$UPPER(fieldname) order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query FieldCalcSelectivity(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "FIELD_NAME:%Library.String(MAXLEN=128),SELECTIVITY:%Library.String(MAXLEN=24),OUTLIER_SELECTIVITY:%Library.String,OUTLIER_VALUE:%Library.String,AVERAGE_FIELD_SIZE:%Library.Integer") [ Internal, SqlName = FieldCalcSelectivity, SqlProc ]
{
}

ClassMethod FieldCalcSelectivityExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;  %q = current icol for $Order loop
	#;  %q(icol) = column's selectivity
	#;  %q("f",$$$UPPER(fieldname))= $lb(fieldname,icol)
	#;  %q("e") = extent
	#;  %q("o",icol) = column's outlier selectivity
	#;  %q("s",icol) = column's average field size

	#dim f,fi,tabinfo As %String
	#dim sc As %Status
	set %q("e")=$$$GetExtentNameFromTableName(%schema,%table)
	QUIT:%q("e")="" $$$OK
	set tabinfo=$$$EXTsqlinfo($$$rEXT,%q("e")),sc=$$$OK
	set tExtentSize=$$$SQLLocTableExtentSize(tabinfo)
	if tExtentSize < 1000	{ set tSampleSize=tExtentSize } 
	else 			{ set tSampleSize = $normalize(3*$zsqr(tExtentSize),0) }
	new %qafs,%qq
	do CalculateSelectivity^%qarTune(%q("e"),tabinfo,tExtentSize,,,.%q,.%qq,,.%qafs,.sc,0,0,,tSampleSize,(tExtentSize=0)) QUIT:$$$ISERR(sc) sc
	merge %q("o")=%qq
	merge %q("s")=%qafs
	set %q(1)="NUMROWS"	// RowID always UNIQUE
	set f=""
	for  {
		set f=$o($$$EXTSQLCOL($$$rEXT,%q("e"),f)) quit:f=""
		set fi=$$$EXTSQLCOLsqlinfo($$$rEXT,%q("e"),f)
		set:$d(%q($$$SQLLocColNumber(fi))) %q("f",$$$UPPER(f))=$lb(f,$$$SQLLocColNumber(fi))
	}
	set %q=""
	QUIT $$$OK
}

ClassMethod FieldCalcSelectivityFetch(ByRef %q As %Library.Binary, ByRef %row As %Library.List, %atend As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#dim data,fieldname,objselectivity,sqlselectivity As %String
	#dim AtEnd,icol As %Integer
	set %atend=0,%row=""
	if $g(%q("e"))="" { set %atend=1 QUIT $$$OK }
	set %q=$o(%q("f",%q),1,data)
	if %q="" { set %atend=1 QUIT $$$OK }
	set fieldname=$lg(data,1),icol=$lg(data,2),sqlselectivity=%q(icol)
	set:$g(sqlselectivity)="" sqlselectivity=0
	if sqlselectivity { set objselectivity=$j((100/sqlselectivity),0,4)_"%" s:'objselectivity objselectivity=$zstrip($j(100/sqlselectivity,0,19),">W","0")_"%" } ;BJB295+
	if sqlselectivity="NUMROWS"||'sqlselectivity { set objselectivity=1 }
	if $d(%q("o",icol)) {
		set tOutlierSel=$lg(%q("o",icol))
		set tOutlierValue=$lg(%q("o",icol),2)
		set tOutlierValue=$s(tOutlierValue="":"<Null>",1:##class(%Library.Global).Quote(tOutlierValue))
	}
	else { set tOutlierSel="",tOutlierValue="" }
	set %row=$lb(fieldname,objselectivity,tOutlierSel,tOutlierValue,$g(%q("s",icol)))
	QUIT $$$OK
}

ClassMethod FieldCalcSelectivityClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	k %q QUIT $$$OK
}

/// <pre>
/// %SQL_MANAGER.Indices Procedure
/// 	%SQL.Manager.Catalog.Indices('%schema',%'table')
/// 		Returns all Indices in the table:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table
/// 		ROWSPEC = INDEX_NAME:%Library.String	- Name of the index
/// 			  SQL_MAP_NAME:%Library.String	- Name of the SQL Map
/// 			  FIELDS:%Library.String	- Indexed Fields
/// 			  TYPE:%Library.String		- Type of Index.  Unique, Bitmap, Bitmap Extent
/// 			  BI_ARGUMENT:%Library.String	- Name of index (if application, or SQL Map) What is passed to RebuildIndex
/// 			  BLOCKCOUNT:%Library.String    - BlockCount for this map
/// 			  MAP_INHERITED:%Library.String - Yes if this map is inherited from a super class, otherwise No
/// 		Rows are returned in no particular order
/// </pre>
Query Indices(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "INDEX_NAME:%Library.String,SQL_MAP_NAME:%Library.String,FIELDS:%Library.String,TYPE:%Library.String,BI_ARGUMENT:%String,BLOCK_COUNT:%Library.String,MAP_INHERITED:%Library.String") [ Internal, SqlName = Indices, SqlProc ]
{
}

ClassMethod IndicesExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;  %q(1) = Count
	#;  %q(2) = Type
	#;  %q(3) = Extentname
	#;  %q(4) = Schema
	#;  %q(5) = TableName
	#;  %q(6) = Fields
	#;  %q(7) = ExternalTableFlag (1/0)
	#;  %q(8) = tabinfo
	#;  %q(9) = Index Name
	#;  %q(10) = BLOCKCOUNT
	#;  %q(11) = Map Inheritied
 s %q=1
 s %q(1)="",%q(2)=""
 s %q(3)=$$$GetExtentNameFromTableName(%schema,%table) QUIT:%q(3)="" $$$OK
 s %q(4)=%schema,%q(5)=%table
 s %q(7)=($$$SQLTabConnect(%q(3))'="")
 QUIT $$$OK
}

ClassMethod IndicesFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s AtEnd=0,Row=""
 i %q(3)="" s AtEnd=1 QUIT $$$OK
 s %q(6)="",rowdone=0
 If %q(7) {	// external tables
 	For  {
	 	s %q(1)=$o(^oddSQL(%q(4),%q(5),9,%q(1)),1,data) q:%q(1)=""
 		s $p(%q(6),",",$li(data,8))=$li(data,9)
 		s name=$li(data,6),%q(9)=name
 		s:'$li(data,4) %q(2)="Unique"
 		s nextcnt=$o(^oddSQL(%q(4),%q(5),9,%q(1)),1,data2) quit:nextcnt=""
 		i name'=$li(data2,6) q
 	}
 }
 Else {	// regular tables
 	s:'$d(%q(8)) %q(8)=$$$EXTsqlinfo($$$rEXT,%q(3))					// Extent info data
 	For  {
	 	s %q(1)=$o($$$EXTSQLMAP($$$rEXT,%q(3),%q(1))) q:%q(1)=""
	 	s mapinfo=$$$EXTSQLMAPsqlinfo($$$rEXT,%q(3),%q(1))
	 	// continue:$$$SQLLocMapMaster(mapinfo)'="N"				// Quit if not an index map
 		s name=%q(1)
 		if $$$SQLLocMapMaster(mapinfo)="Y" { set %q(2)="Data/Master" } 		// Map/Index Name
 		ElseIf $$$SetSQLLocMapUnique(mapinfo) { s %q(2)="Unique" } 		// Only for %CacheStorage
 		ElseIf $$$SQLLocMapIndexType(mapinfo)="B" { s %q(2)="Bitmap" }		// Only for %CacheStorage
 		ElseIf $$$SQLLocMapIndexType(mapinfo)="BE" { s %q(2)="Bitmap Extent" }  // Only for %CacheStorage
 		ElseIf $e($$$SQLLocMapIndexType(mapinfo),1,2)="FI" { s %q(2)=$$$SQLLocMapIndexType(mapinfo) }  // Only for %CacheStorage
 		ElseIf '$$$SQLLocTableCacheStorage(%q(8)) { s %q(2)="N/A" }		// Type Not Available for non-%CacheStorage
 		Else { s %q(2)="Index" }
 		set %q(9)=$$$SQLLocMapIndexName(mapinfo)
 		if $$$SQLLocMapBlockCount(mapinfo) {
	 		if $$$SQLLocMapBlockCountType(mapinfo)="M" { set %q(10)=$zabs($$$SQLLocMapBlockCount(mapinfo))_" (Measured)" }
	 		else { set %q(10)=$zabs($$$SQLLocMapBlockCount(mapinfo))_" (Defined)" }
 		}
 		else { set %q(10)=$$$SQLLocMapNumberOfBlocks(mapinfo)_" (Estimated)" }
 		set %q(11)=$s($$$SQLLocMapFromThisTable(mapinfo)=1:"No",1:"Yes")
 		s idxfields=$$$SQLLocMapIndexFields(mapinfo)
		If $e($$$SQLLocMapIndexType(mapinfo),1,2)="FI" {
			set %q(6)=idxfields,rowdone=1
		}
 		ElseIf idxfields="" {	// Not %CacheStorage
 			s ilev=""
 			For  {
	 			s ilev=$o($$$EXTSQLMAPSUB($$$rEXT,%q(3),%q(1),ilev)) q:ilev=""
	 			s msinfo=$$$EXTSQLMAPSUBsqlinfo($$$rEXT,%q(3),%q(1),ilev)
				s field=$$$SQLLocMapSubFieldName(msinfo)
				If $$$SQLLocMapSubFieldSchema(msinfo)="",$$$SQLLocMapMaster(mapinfo)'="Y" {
					continue:$$$SQLLocTableRowIDField(%q(8))=field			// This is the RowID field
 					continue:$lf($$$SQLLocTableRowIDLogicalFields(%q(8)),field)	// This is a RowID based on field
				}
				If $$$SQLLocMapSubFunction(msinfo)'="" {
					s %q(6)=%q(6)_$$MapExpressionIntExt^%ocsSQLRTDict(%q(3),%q(1),0,$$$SQLLocMapSubExpression(msinfo))_", "	// Complex map subscript expression
				}
 				ElseIf field'="" { s %q(6)=%q(6)_field_", " }	// Just a normal field
 			}
			s:%q(6)'="" %q(6)=$e(%q(6),1,$l(%q(6))-2)
			s rowdone=1
 		}
 		Else {  // %CacheStorage
 			s fcnt=0
 			s ilev="" 
 			For  {
	 			s ilev=$o($$$EXTSQLMAPSUB($$$rEXT,%q(3),%q(1),ilev)) q:ilev=""
	 			s msinfo=$$$EXTSQLMAPSUBsqlinfo($$$rEXT,%q(3),%q(1),ilev)
				s field=$$$SQLLocMapSubFieldName(msinfo)
				i field'="" continue:'$lf(idxfields,field)  s fcnt=fcnt+1	// %CacheStorage index, see if this field is in the index definition
				If $$$SQLLocMapSubFunction(msinfo)'="" {
					s %q(6)=%q(6)_$$MapExpressionIntExt^%ocsSQLRTDict(%q(3),%q(1),0,$$$SQLLocMapSubExpression(msinfo))_", "	// Complex map subscript expression
				}
 				ElseIf field'="" { s %q(6)=%q(6)_field_", " }	// Just a normal field
				q:fcnt'<($ll(idxfields))
 			}
			s:%q(6)'="" %q(6)=$e(%q(6),1,$l(%q(6))-2)
			s rowdone=1
 		}
		q:rowdone
	 }
 }
 if %q(1)="",%q(6)="" { set AtEnd=1 QUIT $$$OK }
 set Row=$lb(%q(9),name,%q(6),%q(2),$s(%q(9)'="":%q(9),1:name),%q(10),%q(11))
 QUIT $$$OK
}

ClassMethod IndicesClose(%q As %Library.Binary) As %Library.Status [ Internal ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
/// %SQL_MANAGER.MapBlockCount Procedure
/// 	%SQL.Manager.Catalog.MapBlockCount('%schema',%'table')
/// 		Returns all SQL maps with BlockCounts in the table:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table
/// 		ROWSPEC = SQL_MAP_NAME:%Library.String	- Name of the SQL Map
/// 			  BLOCK_COUNT:%Library.Integer	- Map's block count
/// 			  BLOCK_COUNT_TYPE:%Library.String - Is the BLOCK_COUNT easured by TuneTable, Defined by the user, or Estimated by the class compiler?
/// 		Rows are returned in no particular order
/// </pre>
Query MapBlockCount(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "SQL_MAP_NAME:%Library.String,BLOCK_COUNT:%Library.Integer,BLOCK_COUNT_TYPE:%Library.String") [ Internal, SqlName = MapBlockCount, SqlProc ]
{
}

ClassMethod MapBlockCountExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;  %q(1) = Map Name
	#;  %q(2) = Extentname
	#;  %q(3) = ExternalTableFlag (1/0)
	#;  %q(4) = Block Count Type
	#;  %q(5) = Block Count
	set %q(1)=""
 	set %q(2)=$$$GetExtentNameFromTableName(%schema,%table) QUIT:%q(2)="" $$$OK
	set %q(3)=($$$SQLTabConnect(%q(2))'="")
	QUIT $$$OK
}

ClassMethod MapBlockCountFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set AtEnd=0,Row=""
	if %q(2)="" { set AtEnd=1 QUIT $$$OK }
	if %q(3) { set AtEnd=1 QUIT $$$OK }	// external table

	set %q(1)=$o($$$EXTSQLMAP($$$rEXT,%q(2),%q(1)))
	if %q(1)="" { set AtEnd=1 QUIT $$$OK }			// no more maps
	set tMapInfo=$$$EXTSQLMAPsqlinfo($$$rEXT,%q(2),%q(1))
	if $$$SQLLocMapBlockCount(tMapInfo)'="" {
		set %q(5)=$$$SQLLocMapBlockCount(tMapInfo)
 		if $$$SQLLocMapBlockCountType(tMapInfo)="M" { set %q(4)="Measured by TuneTable" }
 		else { set %q(4)="Defined in class definition" }
	}
	else { 
		set %q(4)="Estimated by class compiler"
		set %q(5)=$$$SQLLocMapNumberOfBlocks(tMapInfo)
	}
	set Row=$lb(%q(1),%q(5),%q(4))
	QUIT $$$OK
}

ClassMethod MapBlockCountClose(%q As %Library.Binary) As %Library.Status [ Internal ]
{
	kill %q
	QUIT $$$OK
}

/// <pre>
/// Gets a list of namespaces that have an xDBC error defined.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.NamespacesWithXdbcErrors Procedure
/// 	%SQL.Manager.Catalog.NamespacesWithXdbcErrors()
/// 		Returns all Caché Namespaces which have one or more xDBC errors logged
/// 		ROWSPEC = NAMESPACE:%Library.String	- Name of a NAMESPACE with at least 1 xDBC error logged
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query NamespacesWithXdbcErrors() As %Library.Query(ROWSPEC = "NAMESPACE:%Library.String") [ Internal, SqlName = NamespacesWithXdbcErrors, SqlProc ]
{
}

ClassMethod NamespacesWithXdbcErrorsExecute(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;  %q(1) = Loop variable
	#;  %q(2,namespace) = Array of all namespaces defined, to loop over
	#;  %q(3) = cached query database reference
#dim ns As %Library.String
	set %q(1)="",ns=""
	set %q(3)=$$GetCacheDatabase^%SYS.SQLSRV()
	for  {	set ns=$o($$$CQrootExtended(%q(3))(ns)) quit:ns=""  set %q(2,ns)="" }
	QUIT $$$OK
}

ClassMethod NamespacesWithXdbcErrorsFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set AtEnd=0,Row=""
NWXENext	set %q(1)=$o(%q(2,%q(1))) if %q(1)="" set AtEnd=1,Row="" QUIT $$$OK
	set $zt="NWXENext"  // <DIRECTORY> error just continues on to next row
	GOTO NWXENext:$o($$$CQrootExtended(%q(3))(%q(1),"LastError",""))=""
	set $zt="",Row=$lb(%q(1))
	QUIT $$$OK
}

ClassMethod NamespacesWithXdbcErrorsClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q QUIT $$$OK
}

/// <pre>
/// Gets all the xDBC errors logged in a single namespace.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.XdbcErrors Procedure
/// 	%SQL.Manager.Catalog.XdbcErrors('nspace','pFilter')
/// 		Returns all xDBC errors logged in a given namespace
/// 		ARGUMENTS = nspace	- Namespace to look for errors in.
/// 			    pFilter	- Error text filter (optional).  The filter may be a single string optionally prefixed by "'" (NOT).
/// 					     Examples: if pFilter = "'DISCONNECT", any Xdbc errors that include the string DISCONNECT will NOT be returned.
/// 						       if pFilter = "STORE", only the xDbc errors that include the string "STORE" will be returned
/// 		ROWSPEC = DATE_TIME:%Library.Timestamp	- Date/Time the error was logged
/// 			  PROCESS_ID:%Library.String	- PID which got the error
/// 			  SQLCODE:%Library.String	- Code/String with the error
/// 			  CACHE_ERROR:%Library.String	- Caché error string
/// 			  LOCATION:%Library.String	- Where in the server the error occurred
/// 			  DisplayID:%String		- PID for displaying, hexadecimal for VMS.
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query XdbcErrors(nspace As %Library.String = "%SYS", pFilter As %Library.String = "") As %Library.Query(ROWSPEC = "DATE_TIME:%Library.String,PROCESS_ID:%Library.String,SQLCODE:%Library.String,CACHE_ERROR:%Library.String,LOCATION:%Library.String,MESSAGE:%Library.String,DisplayPID:%String") [ Internal, SqlName = XdbcErrors, SqlProc ]
{
}

ClassMethod XdbcErrorsExecute(ByRef qh As %Library.Binary, nspace As %Library.String = "", pFilter As %Library.String = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
		#;  %q(qh) = Loop Variable
	set qh=$i(^CacheTemp),%q(qh)=""
	$$$AddTempNode(^CacheTemp(qh))
	set %q("filter")=0,%q("filter2")=0
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	set sc=$$XdbcErrorsExecute^%SYS.SQLSRV(qh,nspace,"%SQL.Manager.Catalog::XdbcErrorsExecute",.%q)
	Quit sc
}

ClassMethod XdbcErrorsFetch(ByRef qh As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s AtEnd=0,Row="" s %q(qh)=$o(^CacheTemp(qh,%q(qh)),-1,Row) QUIT $$$OK
}

ClassMethod XdbcErrorsClose(qh As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	k %q(qh),^CacheTemp(qh) $$$RemoveTempNode(^CacheTemp(qh)) QUIT $$$OK
}

/// <pre>
/// Gets a description of the stored procedures available in the schema.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.Procedures Procedure
/// 	%SQL.Manager.Catalog.Procedures('%schema','grantOnly')
/// 		Returns all SQL Procedures which exist in the schema that the user is privileged to EXECUTE
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    grantOnly	- 1 to only return procedures in the schema the user has at least one grantable privilege for
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all tables are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema name contains ABC and table name contains XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned,
/// 						along with schema names that begin with DEF and tables that begin with XYZ.  
/// 			    pTypeFilter	- Procedure type filter (optional), used to determine hat type of procedures are returned
/// 					The values are:
/// 					1 - Functions & Queries, no Extent Queries (default)
/// 					2 - Functions & Queries, including Extent Queries
/// 					3 - Functions only
/// 					4 - Queries only, no Extent Queries
/// 					5 - Queries only, including Extent Queries
/// 		ROWSPEC = PROCEDURE_NAME:%Library.String	- Name of the Stored procedure, LIKE Pattern allowed
/// 			  PROCEDURE_TYPE:%Library.String	- Type of Stored procedure
/// 			  PROCEDURE_CLASS:%String		- Name of the class which projected the Procedure
/// 			  METHOD_OR_QUERY_NAME:%Library.String	- Name of the method or query the procedure is generated from
/// 			  ALLOW_DELETE:%Library.Boolean		- 1/0 1 if we allow this procedure to be deleted (procedure's origin is this class)
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query Procedures(%schema As %Library.String, grantOnly As %Library.Boolean, pFilter As %Library.String = "", pTypeFilter As %Library.Integer = 1) As %Library.Query(ROWSPEC = "PROCEDURE_NAME:%Library.String,PROCEDURE_TYPE:%Library.String,PROCEDURE_CLASS:%Library.String,METHOD_OR_QUERY_NAME:%Library.String,ALLOW_DELETE:%Library.Boolean") [ Internal, SqlName = Procedures, SqlProc ]
{
}

ClassMethod ProceduresExecute(ByRef %q As %Library.Binary, %schema As %Library.String, grantOnly As %Library.Boolean = 0, pFilter As %Library.String = "", pTypeFilter As %Library.Integer = 1) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;  %q(1) = Loop variable
	#;  %q(2) = SCHEMA
	s %q(1)="",%q(2)=$$$UPPER(%schema),%q(3)=grantOnly
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
 	set %q("typefilter")=pTypeFilter
	QUIT $$$OK
}

ClassMethod ProceduresFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s AtEnd=0,Row=""
PNext	s %q(1)=$o(^oddPROC(%q(2),%q(1))) i %q(1)="" s AtEnd=1,Row="" QUIT $$$OK
	//GOTO PNext:$$$PROChidden($$$pPROC,%q(2),%q(1))
	GOTO PNext:'$$$PROCprojected($$$pPROC,%q(2),%q(1))
	s pname=$g($$$PROCschema($$$pPROC,%q(2),%q(1)))_"."_$g($$$PROCname($$$pPROC,%q(2),%q(1)))
	if %q("tfilter") {
		set ok=0
		for i=1:1:%q("tfilter") { if %q(1)?@%q("tfilter",i) { set ok=1 quit  }}
		GOTO:'ok PNext	// Table does not match any of the positive patterns specified
	}
	if %q("tfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("tfilter2") { if %q(1)?@%q("tfilter2",i) { set ok=0 quit  }}
		GOTO:'ok PNext	// Table does match one of the NOT patterns specified, don't report it
	}
	GOTO:'$$ExecutePriv^%SYS.SQLSEC("9,"_pname,%q(3)) PNext
 	if %q("typefilter")=3,$$$PROCtype($$$pPROC,%q(2),%q(1))'="function" GOTO PNext	// Looking for functions only
 	if %q("typefilter")>3,$$$PROCtype($$$pPROC,%q(2),%q(1))="function" GOTO PNext	// Looking for queries only
 	if (%q("typefilter")=1 || (%q("typefilter")=4)) && ($$$PROCprocedure($$$pPROC,%q(2),%q(1))="Extent") GOTO PNext	// No Extent Queries
	set allowDelete=1,mqname=$$$PROCprocedure($$$pPROC,%q(2),%q(1)),classname=$$$PROCclass($$$pPROC,%q(2),%q(1))
	if '$$$defMemberDefined(classname,$$$cCLASSmethod,mqname),'$$$defMemberDefined(classname,$$$cCLASSquery,mqname) set allowDelete=0
	s Row=$lb($$$PROCname($$$pPROC,%q(2),%q(1)),$$$PROCtype($$$pPROC,%q(2),%q(1)),$$$PROCclass($$$pPROC,%q(2),%q(1)),mqname,allowDelete)
	QUIT $$$OK
}

ClassMethod ProceduresClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Gets a detailed information about a single Stored Procedure
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ProcedureInfo Procedure
/// 	%SQL.Manager.Catalog.ProcedureInfo('%schema','%proc')
/// 		Returns information for the Procedure
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %proc	- Name of a procedure
/// 		ROWSPEC = CLASS_NAME:%Library.String			- Name of the class procedure method or query reside in
/// 			  PROCEDURE_TYPE:%Library.String		- Type of Stored procedure
/// 			  METHOD_OR_QUERY_NAME:%Library.String		- Name of the method or query the procedure is generated from
/// 			  DESCRIPTION:%Library.String			- Procedure's description
/// 			  NUMBER_INPUT_PARAMS:%Library.Integer		- Number of input paramaters
/// 			  NUMBER_INPUT_OUTPUT_PARAMS:%Library.Integer	- Number of input/output parameters
/// 			  NUMBER_OUTPUT_PARAMS:%Library.Integer		- Number of output parameters
/// 			  NUMBER_OUTPUT_PARAMS:%Library.Integer		- Number of output parameters
/// 			  RETURN_VALUE:%Library.Integer			- Has a return value?
/// 			  PROCEDURE_INTERFACE:%Library.String		- -2, -1, 0, 1, or 2
/// 									  -2	Procedure with a return value that may return result sets
/// 									  -1	Procedure without a return value that may return result sets
/// 									   0	Procedure without a return value, no result sets
/// 									   1	query procedure (single static result set)
/// 									   2	function with a return value, no result sets
/// 			  INPUT_PARAMETERS:%Library.String		- List of input parameters
/// 			  INPUT_OUTPUT_PARAMETERS:%Library.String	- List of input/output parameters
/// 			  OUTPUT_PARAMETERS:%Library.String		- List of output parameters
/// 			  RESULTSET_COLUMNS:%Library.String		- List of resultset columns
/// 			  NUMBER_OF_COLUMNS:%Library.Integer		- Number of columns
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ProcedureInfo(%schema As %Library.String, %proc As %Library.String) As %Library.Query(ROWSPEC = "CLASS_NAME:%Library.String,PROCEDURE_TYPE:%Library.String,METHOD_OR_QUERY_NAME:%Library.String,DESCRIPTION:%Library.String,NUMBER_INPUT_PARAMS:%Library.Integer,NUMBER_INPUT_OUTPUT_PARAMS:%Library.Integer,NUMBER_OUTPUT_PARAMS:%Library.Integer,RETURN_VALUE:%Library.Integer,PROCEDURE_INTERFACE:%Library.String,NUMBER_OF_COLUMNS:%Library.Integer,INPUT_PARAMETERS:%Library.String,INPUT_OUTPUT_PARAMETERS:%Library.String,OUTPUT_PARAMETERS:%Library.String,RESULTSET_COLUMNS:%Library.String,RETURN_VALUE:%Library.String") [ Internal, SqlName = ProcedureInfo, SqlProc ]
{
}

ClassMethod ProcedureInfoExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %proc As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#; %q(1) = SCHEMA
	#; %q(2) = PROCNAME
	#; %q(3) = Fetch Count
	#; %q(4) = Column Count
 s %q(1)=$$$UPPER(%schema),%q(2)=$$$UPPER(%proc),%q(3)=0,%q(4)=0
 QUIT $$$OK
}

ClassMethod ProcedureInfoFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 	#dim i,numInputParms,numIOParms,numOutputParms,x As %Integer
 	#dim resultCols,retParms,inoutParms,inputParms,outParms As %String
 s AtEnd=0,Row=""
 i %q(1)=""||(%q(2)="") s AtEnd=1 QUIT $$$OK 		// No procedure to lookup on
 i $i(%q(3))>1 s AtEnd=1 QUIT $$$OK 			// Second time Fetch was called - all done
 i '$d(^oddPROC(%q(1),%q(2))) s AtEnd=1 QUIT $$$OK 	// No such procedure
 s resultCols="",inputParms="",inoutParms="",outParms="",retParms="",numInputParms=0,numIOParms=0,numOutputParms=0
 If $d($$$PROCcolumn($$$pPROC,%q(1),%q(2)),x) {
	 f i=1:1:x {
		 i $$$PROCCOLtype($$$pPROC,%q(1),%q(2),i)=1 s numInputParms=numInputParms+1,inputParms=inputParms_", "_$$$PROCCOLname($$$pPROC,%q(1),%q(2),i)_" "_$$$PROCCOLodbctypename($$$pPROC,%q(1),%q(2),i)
		 i $$$PROCCOLtype($$$pPROC,%q(1),%q(2),i)=2 s numIOParms=numIOParms+1,inoutParms=inoutParms_", "_$$$PROCCOLname($$$pPROC,%q(1),%q(2),i)_" "_$$$PROCCOLodbctypename($$$pPROC,%q(1),%q(2),i)
		 i $$$PROCCOLtype($$$pPROC,%q(1),%q(2),i)=3 s %q(4)=%q(4)+1,resultCols=resultCols_", "_$$$PROCCOLname($$$pPROC,%q(1),%q(2),i)_" "_$$$PROCCOLodbctypename($$$pPROC,%q(1),%q(2),i)
		 i $$$PROCCOLtype($$$pPROC,%q(1),%q(2),i)=4 s numOutputParms=numOutputParms+1,outParms=outParms_", "_$$$PROCCOLname($$$pPROC,%q(1),%q(2),i)_" "_$$$PROCCOLodbctypename($$$pPROC,%q(1),%q(2),i)
		 i $$$PROCCOLtype($$$pPROC,%q(1),%q(2),i)=5 s retParms=retParms_", "_$$$PROCCOLname($$$pPROC,%q(1),%q(2),i)_" "_$$$PROCCOLodbctypename($$$pPROC,%q(1),%q(2),i)
	 }
 }
 s Row=$lb($$$PROCclass($$$pPROC,%q(1),%q(2)),$$$PROCtype($$$pPROC,%q(1),%q(2)),$$$PROCprocedure($$$pPROC,%q(1),%q(2)),$$$PROCdescription($$$pPROC,%q(1),%q(2)),numInputParms,numIOParms,numOutputParms,$$$PROCreturnval($$$pPROC,%q(1),%q(2)),$g($$$PROCinterface($$$pPROC,%q(1),%q(2))),%q(4),$e(inputParms,3,*),$e(inoutParms,3,*),$e(outParms,3,*),$e(resultCols,3,*),$e(retParms,3,*))
 QUIT $$$OK
}

ClassMethod ProcedureInfoClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
/// Returns a list of all SQL Reserved Words
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.RWList Procedure
/// 	%SQL.Manager.Catalog.SQLCODEList()
/// 		Returns list of all SQL Reserved Words
/// 		ROWSPEC = RESERVED_WORD:%Library.String	- Reserved Word
/// 		Rows are returned in Reserved Word alphabetic order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query RWList() As %Library.Query(ROWSPEC = "RESERVED_WORD:%Library.String") [ Internal, SqlName = RWList, SqlProc ]
{
}

ClassMethod RWListExecute(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#; %q(1) = Loop variable
 s %q(1)=""
 QUIT $$$OK
}

ClassMethod RWListFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s AtEnd=0,Row=""
RWLoop	s %q(1)=$o(^%qCacheSQL("reservewords",%q(1))) i %q(1)="" s AtEnd=1 QUIT $$$OK
 i $p(^%qCacheSQL("reservewords",%q(1)),$c(1),2)'="Y" GOTO RWLoop
 s Row=$lb(%q(1))
 QUIT $$$OK
}

ClassMethod RWListClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
///  Get a List of all Schemas in the current namespace.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.Schemas Procedure
/// 	%SQL.Manager.Catalog.Schemas('system')
/// 		Privileges are checked against pre-define $Username.
/// 		Returns a list of schemas defined in the current namespace.
/// 		ARGUMENTS = pSystem	- 1 to return system tables, 0 (default) to return non-system tables only
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all tables are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema name contains ABC and table name contains XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned,
/// 						along with schema names that begin with DEF and tables that begin with XYZ.  
/// 			    pMapped	- 1 (default) to return schemas mapped from another database, 0 to return schemas only from this database
/// 		ROWSEPC = SCHEMA_NAME:%Library.String		- Name of the schema
/// 			  TABLE_EXISTS:%Library.Boolean		- (1/0) Do any tables exist in this schema?
/// 			  VIEW_EXISTS:%Library.Boolean		- (1/0) Do any views exist in this schema?
/// 			  PROCEDURE_EXISTS:%Library.Boolean	- (1/0) Do any Stored Procedures exist in this schema?
/// 			  CACHED_QUERY_EXISTS:%Library.Boolean	- (1/0) Do any Cached Queries exist in this schema?
/// 		Rows are returned in order by SCHEMA_NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query Schemas(system As %Library.Boolean = 0, pFilter As %Library.String = "", pMapped As %Library.Boolean = 1) As %Library.Query(ROWSPEC = "SCHEMA_NAME:%Library.String,TABLE_EXISTS:%Library.Boolean,VIEW_EXISTS:%Library.Boolean,PROCEDURE_EXISTS:%Library.Boolean,CACHED_QUERY_EXISTS:%Library.Boolean") [ Internal, SqlName = Schemas, SqlProc ]
{
}

ClassMethod SchemasExecute(ByRef %q As %Library.Binary, system As %Library.Boolean = 0, pFilter As %Library.String = "", pMapped As %Library.Boolean = 1) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	  #;  First we need to make sure there are no entries in ^rINDEXSQL("schema") which need to be deleted
	  #;  This may be needed because there is no other place where schemas are deleted from ^rINDEXSQL("schema")
	  #;  If system is FALSE, don't return "%" or INFORMATION_SCHEMA schemas
	  #;  If 'pMapped, don't return any schemas mapped from other databases

	s:$znspace="%SYS" system=1
	Do SchemasExecuteKillLoop^%SYS.SQLSEC(system)
	s %q(1)=$e("&",'system)	//  %q(1) = SCHEMA ($o loop variable)
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	set %q("system")=system
 	set %q("mapped")=pMapped
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	QUIT $$$OK
}

ClassMethod SchemasFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s AtEnd=0,Row=""
SFLoop	s %q(1)=$o(^rINDEXSQL("schema",%q(1)),1,schema) 
	if %q(1)="" { set AtEnd=1 QUIT $$$OK }  	// no more schemas
	
		// Skip any mapped schemas if 'pMapped
	if '%q("mapped") {
		if $zu(12,"")'=$p($$GetGlobalSourceDatabase^%SYS.SECURITY($name(^rINDEXSQL("schema",%q(1)))),"^",3) { goto SFLoop }
	}

		// Check schema filter
	set tSchemaU=$$$UPPER(schema)
	goto:tSchemaU="INFORMATION_SCHEMA"&&('%q("system")) SFLoop	// Skip "INFORMATION_SCHEMA", a system schema
	if %q("sfilter") {
		set ok=0
		for i=1:1:%q("sfilter") { if tSchemaU?@%q("sfilter",i) { set ok=1 quit  }}
		goto:'ok SFLoop 	// Schema does not match any of the positive patterns specified
	}
	if %q("sfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("sfilter2") { if tSchemaU?@%q("sfilter2",i) { set ok=0 quit  }}
		goto:'ok SFLoop	// Schema does match one of the NOT patterns specified, don't report it
	}
	

	  #;  See if any Tables exists 'in' this schema that we have any privilege for
	s tableFlag=$$AnySchemaTablePriv^%SYS.SQLSEC(schema,0,.%q)

	  #;  See if any View exists 'in' this schema that we have any privilege for
	s viewFlag=$$AnySchemaViewPriv^%SYS.SQLSEC(schema,0,.%q)

	  #;  See if any Stored Procedures exists 'in' this schema that we are privileged to execute
	s procFlag=$$AnySchemaProcPriv^%SYS.SQLSEC(schema,0,.%q)
	
	  #;  See if any Cached Queries exists 'in' this schema
	  #;  Assume they can't see any cached queries for this schema if they have no privilege on any tables, views, or procedures in this schema
	s cqflag=0 If tableFlag||viewFlag||procFlag { s package=$$GetPackage^%apiDDL(schema,1) s:$$CQPackageIndexDefined^%SYS.SQLSRV(package) cqflag=1 }

	GOTO:'(tableFlag+viewFlag+procFlag+cqflag) SFLoop
	s Row=$lb(schema,tableFlag,viewFlag,procFlag,cqflag)
	QUIT $$$OK
}

ClassMethod SchemasClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 	Kill %q	QUIT $$$OK
}

/// <pre>
/// Get a List of all Schemas in the current namespace, possibly filtered by privilege checking.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.SchemasOnly Procedure
/// 	%SQL.Manager.Catalog.SchemasOnly(system,relType,grantOption)
/// 		Privileges are checked against pre-define $Username.
/// 		Returns a list of schemas defined in the current namespace.
/// 		ARGUMENTS = system	- 1 to return system objects, 0 (default) to return non-system objects only
/// 			    relType	- Type of SQL object to check for:  "TABLE", "VIEW", or "PROCEDURE"
/// 			    grantOption	= 1 to only return objects in the schema the user has at least one grantable privilege for
/// 		ROWSEPC = SCHEMA_NAME:%Library.String	- Name of the schema
/// 		Rows are returned in order by SCHEMA_NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query SchemasOnly(system As %Library.Boolean = 0, relType As %Library.String = "", grantOption As %Library.Boolean = 0) As %Library.Query(ROWSPEC = "SCHEMA_NAME:%Library.String") [ Internal, SqlName = SchemasOnly, SqlProc ]
{
}

ClassMethod SchemasOnlyExecute(ByRef %q As %Library.Binary, system As %Library.Boolean = 0, relType As %Library.String = "", grantOption As %Library.Boolean = 0) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	  #;  First we need to make sure there are no entries in ^rINDEXSQL("schema") which need to be deleted
	  #;  This may be needed because there is no other place where schemas are deleted from ^rINDEXSQL("schema")
	  #;  If system is FALSE, don't return "%" schemas

	s:$znspace="%SYS" system=1
	Do SchemasExecuteKillLoop^%SYS.SQLSEC(system)
	
	s %q(1)=$e("&",'system)	//  %q(1) = SCHEMA ($o loop variable)
	s %q(2)=relType
	s %q(3)=grantOption
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	set %q("system")=system
	QUIT $$$OK
}

ClassMethod SchemasOnlyFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s AtEnd=0,Row=""
SOFLoop	s %q(1)=$o(^rINDEXSQL("schema",%q(1)),1,schema) 
	if %q(1)="" { set AtEnd=1 QUIT $$$OK }  	// no more schemas
	goto:%q(1)="INFORMATION_SCHEMA"&&('%q("system")) SOFLoop	// Skip "INFORMATION_SCHEMA", a system schema

	if %q(2)="TABLE"     { GOTO:'$$AnySchemaTablePriv^%SYS.SQLSEC(schema,%q(3),.%q) SOFLoop }
	if %q(2)="VIEW"      { GOTO:'$$AnySchemaViewPriv^%SYS.SQLSEC(schema,%q(3),.%q) SOFLoop }
	if %q(2)="PROCEDURE" { GOTO:'$$AnySchemaProcPriv^%SYS.SQLSEC(schema,%q(3),.%q) SOFLoop }

	s Row=$lb(schema)
	QUIT $$$OK
}

ClassMethod SchemasOnlyClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 	Kill %q	QUIT $$$OK
}

/// <pre>
/// Get a List of all Basetables and Views in a schema.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.Tables Procedure
/// 	%SQL.Manager.Catalog.Tables('%schema')
/// 		Privileges are checked against pre-define $Username.
/// 		Returns a list of tables and views defined in the current namespace.
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 		ROWSPEC = NAME:%Library.String			- Name of the table or view
/// 			  TYPE:%Library.String			- 'TABLE' or 'VIEW'
/// 			  OWNER:%Library.String			- SQL Username of the table's owner
/// 			  LAST_COMPILED:%Library.TimeStamp	- When the table's class was last compiled.
/// 			  EXTERNAL:%Library.Boolean		- TRUE if external table, FALSE if not
/// 			  READ_ONLY:%Library.Boolean		- TRUE is table is readonly, FALSE if not
/// 			  CLASSNAME:%Library.String		- Name of the class which projected the table/view
/// 			  CHECK_OPTION:%Library.String		- Pertains to views only.  CASCADED, LOCAL, ""
/// 		Rows are returned in order by NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query Tables(%schema As %Library.String) As %Library.Query(ROWSPEC = "NAME:%Library.String,TYPE:%Library.String,OWNER:%Library.String,LAST_COMPILED:%Library.TimeStamp,EXTERNAL:%Library.Boolean,READ_ONLY:%Library.Boolean,CLASSNAME:%Library.String,CHECK_OPTION:%Library.String(MAXLEN=8)") [ Internal, SqlName = Tables, SqlProc ]
{
}

ClassMethod TablesExecute(ByRef %q As %Library.Binary, %schema As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s %q=1
 s %q("schema")=%schema
 s %q("table")=""	// table looping variable
 QUIT $$$OK
}

ClassMethod TablesFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s AtEnd=0,Row=""
 i %q("schema")="" s AtEnd=1 Quit $$$OK  ; No such schema in this namespace
TFLoop s %q("table")=$o(^oddSQL(%q("schema"),%q("table")),1,data) i %q("table")="" { s AtEnd=1 QUIT $$$OK } g:'($d(^(%q("table")))#2) TFLoop /* not a table */
 i '$$AnyPrivObj^%SYS.SQLSEC($li(data,6)) g TFLoop
 s reltype=$li(data,4)
 s ext=$$$GetExtentNameFromTableName(%q("schema"),%q("table")) g:ext="" TFLoop  ; Corrupt ^oddSQL???
 s extinfo=$$$EXTsqlinfo($$$rEXT,ext)
 s Row=$lb(%q("table"),reltype,$$$SQLLocTableOwner(extinfo),$zdt($$$SQLLocTableLastCompileTime(extinfo),3))
 If reltype="TABLE" { s Row=Row_$lb($p($$$SQLTabConnect(ext),",")'="",$s($$$SQLLocTableReadOnly(extinfo)="Y":1,$$$SQLLocFilerReadOnly(extinfo)="Y":1,1:0),$$$SQLLocTableClassname(extinfo),"") }
 If reltype="VIEW" { s Row=Row_$lb(0,'$$$SQLLocViewUpdateable(extinfo),$$$SQLLocTableClassname(extinfo),$s($$$SQLLocViewCheckOption(extinfo)="C":"CASCADED",$$$SQLLocViewCheckOption(extinfo)="L":"LOCAL",1:"")) }
 QUIT $$$OK
}

ClassMethod TablesClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

ClassMethod GetStatementInfo(Hash As %Library.String, ByRef RoutineList As %Library.List, ByRef RelationList As %Library.List, ByRef Statement As %Library.String, ByRef PlanState As %Library.SmallInt, ByRef DefaultSchema As %Library.List, ByRef SchemaPath As %String, ByRef SelectMode As %String, ByRef PlanTS As %TimeStamp, ByRef PlanVersion As %String, ByRef PlanError As %String) As %Library.String [ Internal, ProcedureBlock = 1, PublicList = (backgrnd, objAsl) ]
{
	// Assume the statement exists, then at the end if it does not, clear all data and return
	#dim node As %Library.List
	#dim Packages,rel,rtn,selmode,StatementSP As %Library.String
	#dim i As %Library.Integer

	if $g(Hash)="" { goto Error404 }
	set:Hash[" " Hash=$tr(Hash," ","+")
	set Statement="" for i=1:1:$g($$$SQLIndex(1,Hash,1)) { set Statement=Statement_$g($$$SQLIndex(1,Hash,1,i))_" " }
	set PlanError=$g($$$SQLIndex(1,Hash,"err"))
	set node=$g($$$SQLIndex(1,Hash,0))
	set SelectMode=$lg(node,1)
	set SchemaPath=$listtostring($lg(node,2))
	if PlanError="" {	// Plan is not currently in error, see if it should be
		new backgrnd,%plan,%sqlcodegen,objAsl
		set backgrnd=1
		merge StatementSP=$$$SQLIndex(1,Hash,1)
		set selmode=$case($$$LOWER(SelectMode),"%runtime":"RUNTIME","%odbc":"ODBC","%external":"DISPLAY","%fdbms":"FDBMS",:"")
		do ShowPlan^%apiSQL(.StatementSP,1,,0,"",SchemaPath,0,selmode)
		set PlanError=$g($$$SQLIndex(1,Hash,"err"))	// May have changed
	}
	set rel="",RelationList=""
	for  { set rel=$o($$$SQLIndex(1,Hash,"rel",rel)) quit:rel=""  set RelationList=RelationList_$lb(rel) }
	set DefaultSchema=$listtostring($lg(node,3))
	set Packages=$lg(node,4)
	set node=$g($$$SQLIndex(1,Hash,"planinfo"))
	set PlanState=$lg(node,1)
	set PlanTS=$lg(node,2)
	set PlanVersion=$lg(node,3)
	set RoutineList="",rtn=""
	for  { set rtn=$o($$$SQLIndex(1,Hash,"rtn",rtn)) quit:rtn=""  set RoutineList=RoutineList_$lb(rtn) }
	if '$d($$$SQLIndex(1,Hash)) { goto Error404 }	// Statement no longer exists
	QUIT $$$OK

Error404	// Statement not found or missing
	set RoutineList="",RelationList="",PlanState="",PlanTS="",DefaultSchema="??",SchemaPath="??",SelectMode="??",PlanError="" kill Statement
	QUIT 0
}

ClassMethod GetStatementInfo2(Hash As %Library.String, ByRef Statement As %Library.String, ByRef Packages As %String, ByRef %switch As %String) As %Library.String [ Internal, ProcedureBlock = 1 ]
{
	// Assume the statement exists, then at the end if it does not, clear all data and return

	#dim node0 As %Library.List
	#dim rtn As %Library.String
	#dim i As %Library.Integer

	if $g(Hash)="" { goto Error404 }
	set:Hash[" " Hash=$tr(Hash," ","+")
	set node0=$g($$$SQLIndex(1,Hash,0))
	set Packages=$lg(node0,4)
	set %switch=$lg(node0,5)
	merge Statement=$$$SQLIndex(1,Hash,1)
	if '$d($$$SQLIndex(1,Hash)) { goto Error404 }	// Statement no longer exists
	QUIT $$$OK

Error404	// Statement not found or missing
	set Packages="",%switch="" kill Statement
	QUIT 0
}

/// <pre>
/// Return list of SQL statements against the given Table or View name
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// StatementIndex Procedure
/// %SQL_MANAGER.StatementIndex Procedure
/// 	%SQL.Manager.Catalog.StatementIndex('schema','table')
/// 		Takes 2 %String/VARCHAR type parameters which is the name of a schema and a Table or View name.
/// 		Returns a list of SQL statements against the table or view
/// 		ROWSPEC = STATEMENT_ID:%String(MAXLEN=30)	- SQL Statement Hash ID
/// 			  RELATION_NAME:%String(MAXLEN=128)	- Table/View name
/// 			  PLAN_STATE:%String(32)		- Frozen/Explicit, Unfrozen, Unfrozen/Parallel
/// 			  LOCATION:%String(MAXLEN=128)		- Routine name the SQL code is located in
/// 			  STATEMENT:%String(MAXLEN(16348)	- SQL Statement
/// 		Note:  Only DECLARE, SELECT, INSERT, UPDATE, and DELETE statements are returned.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query StatementIndex(pShema As %String, pTable As %String) As %Query(ROWSPEC = "STATEMENT_ID:%String(MAXLEN=30),RELATION_NAME:%String(MAXLEN=256),PLAN_STATE:%String(MAXLEN=32),LOCATION:%String(MAXLEN=128),STATEMENT:%String(MAXLEN=16384)") [ Internal, SqlName = StatementIndex, SqlProc ]
{
}

ClassMethod StatementIndexExecute(ByRef %q As %Binary, pSchema As %String, pTable As %String) As %Status [ Internal, ProcedureBlock = 1 ]
{
		#; %q(1) = relation name (UPPER IQN)
		#; %q(2) = table extent loop variable
		#; %q(3) = location loop variable
		#; %q(4) = statement
		#; %q(5) = exact IQN
	do CleanSQLIndex^%SYS.SQLSRV(0)
	set %q(1)="",%q(2)="",%q(3)="",pTable=pSchema_"."_$tr(pTable,".",$c(1))
	QUIT:$g(pTable)="" $$$OK
	set:pTable'["." pTable=$$$DefaultSchema_"."_pTable			// was an unqualified name
	//set tType=$$$GetTableTypeFromIQN(pTable) QUIT:tType="" $$$OK	// No such relation
	set %q(5)=$$$GetExactIQNFromIQN(pTable)
	if %q(5)="" {
				#;  Might be a TVF...
		if $$IsATVF^%qTable(pTable,.schema,.table,.classname,.classTS) {
			set %q(5)=schema_"."_table
		}
		else { QUIT $$$OK } // No such relation
	}

		#; These Statement* class queries can only be accessed from the SMP and they can only be called from the SQL section of the SMP
		#; if they have "USE" privilege on the %Development resource.  
		#; We decided in Dec. 2015 that anyone with "USE" privilege on the %Development resource can see statements and [un]freeze plans.
		#; Thus there is no need to check for privileges here.
	//if '$$AnyPrivTable^%SYS.SQLSEC(tType_","_%q(5),0) { QUIT $$$OK }	// No privs on relation
	set %q(1)=$$$UPPER(%q(5))
	QUIT $$$OK
}

ClassMethod StatementIndexFetch(ByRef %q As %Binary, ByRef Row As %List, AtEnd As %Integer) As %Status [ Internal, ProcedureBlock = 1 ]
{
	#dim tData As %String

	set AtEnd=0,Row=""
	if %q(1)="" { set AtEnd=1 QUIT $$$OK }
	if %q(3)'="" { goto LocLoop }
HashLoop ;
	set %q(2)=$o($$$SQLIndex(3,%q(1),%q(2))) if %q(2)="" { set AtEnd=1 QUIT $$$OK }
	//goto:'$$StatementIndexPrivileged^%SYS.SQLSEC(%q(2)) HashLoop
	set %q(4)=""
	for i=1:1:$g($$$SQLIndex(1,%q(2),1)) {
		set %q(4)=%q(4)_$e(" ",%q(4)'="")_$g($$$SQLIndex(1,%q(2),1,i))
		quit:$l(%q(4))>16384
	}
	set:$l(%q(4))>16381 %q(4)=$e(%q(4),1,16381)_"..."
LocLoop	;
	if '$d($$$SQLIndex(1,%q(2),"rtn")) {
		set frozenPlan=($lg($g($$$SQLIndex(1,%q(2),"planinfo")),1))
		set frozenPlan=$case(frozenPlan,0:"Unfrozen",1:"Frozen/Explicit",3:"Unfrozen/Parallel",:"")
		set relation=$$$SchemaFromIQN(%q(5))_"."_$$$TableFromIQN(%q(5)) set:relation="." relation=%q(5)_" - Deleted?"
		set Row=$lb(%q(2),relation,frozenPlan,"",%q(4))
		QUIT $$$OK
	}
	set %q(3)=$o($$$SQLIndex(1,%q(2),"rtn",%q(3))) 
	goto:%q(3)="" HashLoop	// No more locations for this statement
	set frozenPlan=($lg($g($$$SQLIndex(1,%q(2),"planinfo")),1))
	set frozenPlan=$case(frozenPlan,0:"Unfrozen",1:"Frozen/Explicit",3:"Unfrozen/Parallel",:"")
	if '$d(^rMAC(%q(3))),'$d(^ROUTINE(%q(3))),'$d(^rOBJ(%q(3))) { try { do DeleteSQLIndex^%SYS.SQLSRV(%q(3),0) } catch{ } goto LocLoop}	// Cleanup orphaned entries on the fly
	set relation=$$$SchemaFromIQN(%q(5))_"."_$$$TableFromIQN(%q(5)) set:relation="." relation=%q(5)_" - Deleted?"
	set Row=$lb(%q(2),relation,frozenPlan,%q(3),%q(4))
	QUIT $$$OK
}

ClassMethod StatementIndexClose(ByRef %q As %Binary) As %Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q QUIT $$$OK
}

/// <pre>
/// Return list of SQL statements against the given Table or View name
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// StatementIndexAll Procedure
/// %SQL_MANAGER.StatementIndexAll Procedure
/// 	%SQL.Manager.Catalog.StatementIndexAll()
/// 		Returns a list of SQL statements the user has privileges on in this namespace
/// 		ROWSPEC = STATEMENT_ID:%String(MAXLEN=48)	- SQL Statement Hash ID
/// 			   RELATION_NAME:%String(MAXLEN=128)	- Table/View/Procedure name
/// 			   PLAN_STATE:%String(32)		- Frozen/Explicit, Unfrozen, UnFrozen/Parallel
/// 			   LOCATION:%String(MAXLEN=128)	- Routine name the SQL code is located in
/// 			   STATEMENT:%String(MAXLEN(16348)	- SQL Statement
/// 			   RELATION_TYPE:%SmallInt		- 0 - Table, 2, View, 3 Procedure
/// 		Note:  Only DECLARE, SELECT, INSERT, UPDATE, and DELETE statements are returned.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query StatementIndexAll(filter As %String = "") As %Query(ROWSPEC = "STATEMENT_ID:%String(MAXLEN=48),RELATION_NAME:%String(MAXLEN=256),PLAN_STATE:%String(MAXLEN=32),LOCATION:%String(MAXLEN=128),STATEMENT:%String(MAXLEN=16384),RELATION_TYPE:%SmallInt") [ Internal, SqlName = StatementIndexAll, SqlProc ]
{
}

ClassMethod StatementIndexAllExecute(ByRef %q As %Binary, filter As %String = "") As %Status [ Internal, ProcedureBlock = 1 ]
{
		#; %q(1) = relation loop
		#; %q(2) = hash loop variable
		#; %q(3) = Display Releation Name
		#; %q(4) = filter
		#; %q(5) = relation type.  0 = table, 1=view, 2=stored procedure
	do CleanSQLIndex^%SYS.SQLSRV(0)
	set %q(1)=$c(1),%q(2)="",%q(4)=$$$LOWER(filter),%q(5)=0
	QUIT $$$OK
}

ClassMethod StatementIndexAllFetch(ByRef %q As %Binary, ByRef Row As %List, AtEnd As %Integer) As %Status [ Internal, ProcedureBlock = 1 ]
{
	#dim i,iqn,locs,ll,stmt As %String
	#dim frozenPlan As %SmallInt

	set AtEnd=0,Row=""
	if %q(1)="" { set AtEnd=1 QUIT $$$OK }
	if %q(2)'="" { goto HashLoop }
RelationLoop ;
	set %q(1)=$o($$$SQLIndex(3,%q(1))) if %q(1)="" { set AtEnd=1 QUIT $$$OK }
	goto:%q(1)'["." RelationLoop	// Skip over bad entries that might be from %ELEMENT (DPV4941)
	set iqn=$$$GetExactIQNFromIQN(%q(1))
	
	set %q(3)=$$$SchemaFromIQN(iqn)_"."_$$$TableFromIQN(iqn),%q(5)=0
	if %q(3)="." {
			#;  Might be a TVF...
		if $$IsATVF^%qTable(%q(1),.schema,.table,.classname,.classTS) {
			set %q(3)=schema_"."_table
			set %q(5)=2
		}
		else { set:%q(3)="." %q(3)=%q(1)_" - Deleted??" }
	}
	else { set %q(5)=$case($$$GetTableTypeFromIQN(iqn),1:0,3:1,:0) }
	set %q(2)=""
HashLoop	;
	set %q(2)=$o($$$SQLIndex(3,%q(1),%q(2))) 
	goto:%q(2)="" RelationLoop	// No more hashs for this relation
		#; These Statement* class queries can only be accessed from the SMP and they can only be called from the SQL section of the SMP
		#; if they have "USE" privilege on the %Development resource.  
		#; We decided in Dec. 2015 that anyone with "USE" privilege on the %Development resource can see statements and [un]freeze plans.
		#; Thus there is no need to check for privileges here.
	//goto:'$$StatementIndexPrivileged^%SYS.SQLSEC(%q(2)) HashLoop
	set frozenPlan=($lg($g($$$SQLIndex(1,%q(2),"planinfo"))))
	set frozenPlan=$case(frozenPlan,0:"Unfrozen",1:"Frozen/Explicit",3:"Unfrozen/Parallel",:"")
	set stmt="",locs="",ll="",ts=$lg($g($$$SQLIndex(1,%q(2),0)),4)
	for i=1:1:$g($$$SQLIndex(1,%q(2),1)) {
		set stmt=stmt_$e(" ",stmt'="")_$g($$$SQLIndex(1,%q(2),1,i))
		quit:$l(stmt)>16384
	}
	for  {
		set ll=$o($$$SQLIndex(1,%q(2),"rtn",ll)) quit:ll=""
		if '$d(^rMAC(ll)),'$d(^ROUTINE(ll)),'$d(^rOBJ(ll)) { try { do DeleteSQLIndex^%SYS.SQLSRV(ll,0) } catch{ } goto HashLoop }	// Cleanup orphaned entries on the fly
		set locs=locs_$s(locs="":"",1:$$$NL)_ll
	}
	set:$l(stmt)>16381 stmt=$e(stmt,1,16381)_"..."
	set Row=$lb(%q(2),%q(3),frozenPlan,locs,stmt,%q(5))
	if %q(4)'="",$$$LOWER($listtostring($li(Row,2,*),$c(10)))'[%q(4) { set Row="" goto HashLoop }	// filter specified, row does not match
	QUIT $$$OK
}

ClassMethod StatementIndexAllClose(ByRef %q As %Binary) As %Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q QUIT $$$OK
}

/// <pre>
/// Return list of SQL locations or a given SQL Statement Hash
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// StatementLocations Procedure
/// %SQL_MANAGER.StatementLocations Procedure
/// 	%SQL.Manager.Catalog.StatementLocations()
/// 		Returns a list of statement locations for a given statemnt hash
/// 		ROWSPEC = ROUTINE:%String(MAXLEN=128)		- Routine name
/// 			  CONTAINER_TYPE:%String(MAXLEN=3)	- Type, CLS or RTN
/// 			  COMPILE_DATETIME:%TimeStamp		- TimeStamp of the time the statement was last compiled
/// 		Note:  Only DECLARE, SELECT, INSERT, UPDATE, and DELETE statements are returned.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query StatementLocations(hash As %String = "") As %Query(ROWSPEC = "ROUTINE:%String(MAXLEN=128),CONTAINER_TYPE:%String(MAXLEN=3),COMPILE_DATETIME:%TimeStamp") [ Internal, SqlName = StatementLocations, SqlProc ]
{
}

ClassMethod StatementLocationsExecute(ByRef %q As %Binary, hash As %String = "") As %Status [ Internal, ProcedureBlock = 1 ]
{
		#; %q(1) = location loop
		#; %q(2) = hash variable
	do CleanSQLIndex^%SYS.SQLSRV(0)
	set:hash[" " hash=$tr(hash," ","+")
	set %q(1)="",%q(2)=hash
	QUIT $$$OK
}

ClassMethod StatementLocationsFetch(ByRef %q As %Binary, ByRef Row As %List, AtEnd As %Integer) As %Status [ Internal, ProcedureBlock = 1 ]
{
	#dim data As %List
	#dim ts As %String

	set AtEnd=0,Row=""
	if %q(2)=""||('$d($$$SQLIndex(1,%q(2)))) { set AtEnd=1 QUIT $$$OK }	// no hash given, or statement with hash does not exist, or user not privileged to xecute this statement
LoationLoop ;
	set %q(1)=$o($$$SQLIndex(1,%q(2),"rtn",%q(1)),1,data) if %q(1)="" { set AtEnd=1 QUIT $$$OK }	// no more locations
	set ts=$lg($g(^rINDEX(%q(1),"OBJ"),1)) 
	if ts'="" { set ts=$zdth(ts,3,3),ts=$zdt(ts,,,$l($p(ts,".",2))) }
	set type=$case($lg(data,1),"CLS":"Class Method","RTN":"MAC Routine",:"? Unknown")
	set Row=$lb(%q(1),type,ts)
	QUIT $$$OK
}

ClassMethod StatementLocationsClose(ByRef %q As %Binary) As %Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q QUIT $$$OK
}

/// <pre>
/// Return list of SQL relations for a given SQL Statement Hash
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// StatementRelations Procedure
/// %SQL_MANAGER.StatementRelations Procedure
/// 	%SQL.Manager.Catalog.StatementRelations()
/// 		Returns a list of statement Relations for a given statemnt hash
/// 		ROWSPEC = TABLE_NAME:%String(MAXLEN=128)	- Table or view name
/// 			  TABLE_TYPE:%String(MAXLEN=3)		- Type, TABLE or VIEW
/// 			  COMPILE_DATETIME:%TimeStamp		- Time the table was compiled
/// 			  CLASSNAME:%String			- Name of the class that projected this table
/// 		Note:  Only DECLARE, SELECT, INSERT, UPDATE, and DELETE statements are returned.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query StatementRelations(hash As %String = "") As %Query(ROWSPEC = "TABLE_NAME:%String(MAXLEN=128),TABLE_TYPE:%String(MAXLEN=3),COMPILE_DATETIME:%TimeStamp,CLASSNAME:%String(MAXLEN=128)") [ Internal, SqlName = StatementRelations, SqlProc ]
{
}

ClassMethod StatementRelationsExecute(ByRef %q As %Binary, hash As %String = "") As %Status [ Internal, ProcedureBlock = 1 ]
{
		#; %q(1) = relation loop
		#; %q(2) = hash variable
		#; %q(3) = relation $list
	do CleanSQLIndex^%SYS.SQLSRV(0)
	set:hash[" " hash=$tr(hash," ","+")
	set %q(1)=0,%q(2)=hash,%q(3)=""
	QUIT:%q(2)="" $$$OK
		#; These Statement* class queries can only be accessed from the SMP and they can only be called from the SQL section of the SMP
		#; if they have "USE" privilege on the %Development resource.  
		#; We decided in Dec. 2015 that anyone with "USE" privilege on the %Development resource can see statements and [un]freeze plans.
		#; Thus there is no need to check for privileges here.
	//if '$$StatementIndexPrivileged^%SYS.SQLSEC(%q(2)) { set %q(2)="" QUIT $$$OK }
	set rel="",%q(3)=""
	for  { set rel=$o($$$SQLIndex(1,hash,"rel",rel)) quit:rel=""  set %q(3)=%q(3)_$lb(rel) }
	QUIT $$$OK
}

ClassMethod StatementRelationsFetch(ByRef %q As %Binary, ByRef Row As %List, AtEnd As %Integer) As %Status [ Internal, ProcedureBlock = 1 ]
{
	#dim exactIqn,extentname,iqn,ts,ttype As %String

	set AtEnd=0,Row=""
	if %q(2)=""||(%q(3)="") { set AtEnd=1 QUIT $$$OK }	// no hash given, or statement with hash does not exist
	set %q(1)=%q(1)+1
	set iqn=$lg(%q(3),%q(1))
	if iqn="" { set AtEnd=1 QUIT $$$OK }	// no more locations
	set exactIqn=$$$GetExactIQNFromIQN(iqn)
	if exactIqn="" {
			#;  Might be a TVF...
		if $$IsATVF^%qTable(iqn,.schema,.table,.classname,.classTS) {
			set Row=$lb(schema_"."_table,"TVF",$zdt(classTS,,,$l($p(classTS,".",2))),classname)
			QUIT $$$OK
		}
		set Row=$lb(iqn_" - Deleted?","??","??","??")
		QUIT $$$OK
	}
	set ts=$$$GetTimeStampFromIQN(iqn)
	set ttype=$case($$$GetTableTypeFromIQN(iqn),1:"Table",3:"View",:"? Unknown")
	set extentname=$$$GetExtentNameFromIQN(exactIqn)
	set Row=$lb($$$SchemaFromIQN(exactIqn)_"."_$$$TableFromIQN(exactIqn),ttype,$zdt(ts,,,$l($p(ts,".",2))),$$$GetClassNameFromIQN(iqn))
	QUIT $$$OK
}

ClassMethod StatementRelationsClose(ByRef %q As %Binary) As %Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q QUIT $$$OK
}

/// <pre>
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL.Manager.Catalog.GetTableInfo('schema','table')
/// Given a schema name and table name, return table information.
/// 		ARGUMENTS = schema	- Name of a schema.
/// 			    table	- Name of the table
/// Data returned is $List with values: 
/// 		 1 NAME:%Library.String			- Name of the table or view
/// 		 2 TYPE:%Library.String			- 'TABLE' or 'VIEW'
/// 		 3 OWNER:%Library.String		- SQL Username of the table's owner
/// 		 4 LAST_COMPILED:%Library.TimeStamp	- When the table's class was last compiled.
/// 		 5 EXTERNAL:%Library.Boolean		- TRUE if external table, FALSE if not
/// 		 6 READ_ONLY:%Library.Boolean		- TRUE is table is readonly, FALSE if not
/// 		 7 CLASSNAME:%Library.String		- Name of the class which projected the table/view
/// 		 8 CHECK_OPTION:%Library.String		- Pertains to views only.  CASCADED, LOCAL, ""
/// 		 9 EXTENTSIZE:%Library.Integer		- Table's EXTENTSIZE
/// 		10 PARENT_TABLE:%Library.String		- Name of the parent table if there is one.
/// 		11 CHILD_TABLES:%Library.String		- List of any child tables
/// 		12 REFERENCES:%Library.String		- List of any field references and the tables they reference
/// 		13 USES_CACHE_STORAGE:%Library.Integer	- 1/0 - 1 if this class uses %CacheStorage (default storage)
/// 		13 BITMAP_FRIENDLY:%Library.Boolean	- 1/0 - 1 if this class allows bitmap indices (positive integer rowid), otherwaise 0
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
ClassMethod GetTableInfo(schema As %String, table As %String) As %String [ Internal ]
{
	If schema = "" || table = "" Quit $lb(0,"table name not complete")
	Set data = $G(^oddSQL(schema,table)) If data = "" Quit $lb(0,"No data")
	If '$$AnyPrivObj^%SYS.SQLSEC($li(data,6)) Quit $lb(0,"No priv")
	Set reltype = $li(data,4)
	Set ext = $$$GetExtentNameFromTableName(schema,table)
	If ext = "" Quit $lb(0,"No ext data")
	Set extinfo = $$$EXTsqlinfo($$$rEXT,ext)
	Set Row = $lb(table,reltype,$$$SQLLocTableOwner(extinfo),$zdt($$$SQLLocTableLastCompileTime(extinfo),3))
	set tExtentSize=$$$SQLLocTableExtentSize(extinfo)
	set tParentTable=$$$SQLLocTableParentTable(extinfo)
	set tChildTables=""
	set tChildTables=$g($$$EXTchildren($$$rEXT,ext)) set:tChildTables'="" tChildTables=$ListToString(tChildTables," , ")
	set x=$$$SQLLocTableReferences(extinfo) 
	if x'="" {
		set tReferences=""
		for i=1:1:$ll(x) {
			set tField=$lg($lg(x,i))
			set tRefExtent=$lg($lg(x,i),3)
			set tRefExtentInfo=$$$EXTsqlinfo($$$rEXT,tRefExtent)
			set tReferences=tReferences_$s(i>1:" , ",1:"")_tField_"->"_$$$SQLLocTableSchema(tRefExtentInfo)_"."_$$$SQLLocTableName(tRefExtentInfo)
		}
	}
	set tCacheStorage=$$$SQLLocTableCacheStorage(extinfo)
	set bmfriendly=$$$SQLLocTableBitMapFriendly(extinfo)
	If reltype = "VIEW" { Set Row=Row_$lb(0,'$$$SQLLocViewUpdateable(extinfo),$$$SQLLocTableClassname(extinfo),$s($$$SQLLocViewCheckOption(extinfo)="C":"CASCADED",$$$SQLLocViewCheckOption(extinfo)="L":"LOCAL",1:""),"") }
	else { set Row=Row_$lb($p($$$SQLTabConnect(ext),",")'="",$s($$$SQLLocTableReadOnly(extinfo)="Y":1,$$$SQLLocFilerReadOnly(extinfo)="Y":1,1:0),$$$SQLLocTableClassname(extinfo),"",tExtentSize,tParentTable,tChildTables,tReferences,tCacheStorage,bmfriendly) }
	Quit Row
}

/// <pre>
/// Get a List of all BaseTables in a schema.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.TablesOnly Procedure
/// 	%SQL.Manager.Catalog.TablesOnly('%schema','grantOnly','pFilter')
/// 		Privileges are checked against pre-define $Username.
/// 		Returns a list of tables defined in the current namespace for the given schema.
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    grantOnly	- 1 to only return views in the schema the user has at least one grantable privilege for
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all tables are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema name contains ABC and table name contains XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned,
/// 						along with schema names that begin with DEF and tables that begin with XYZ.  
/// 		ROWSPEC = NAME:%Library.String			- Name of the table
/// 			  OWNER:%Library.String			- SQL Username of the table's owner
/// 			  LAST_COMPILED:%Library.TimeStamp	- When the table's class was last compiled.
/// 			  EXTERNAL:%Library.Boolean		- TRUE if external table, FALSE if not
/// 			  READ_ONLY:%Library.Boolean		- TRUE is table is readonly, FALSE if not
/// 			  CLASSNAME:%Library.String		- Name of the class which projected the table
/// 			  ALLOW_DROP:%Library.Boolean		= If TRUE, display the 'Delete' link to allow dropping the table
/// 			  EXTENTSIZE:%Library.BigInt		= EXTENTSIZE of the table
/// 		Rows are returned in order by NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query TablesOnly(%schema As %Library.String, grantOnly As %Library.Boolean = 1, pFilter As %Library.String = "") As %Library.Query(ROWSPEC = "NAME:%Library.String(MAXLEN=128),OWNER:%Library.String(MAXLEN=64),LAST_COMPILED:%Library.TimeStamp,EXTERNAL:%Library.Boolean,READ_ONLY:%Library.Boolean,CLASSNAME:%Library.String,ALLOW_DROP:%Library.Boolean,EXTENTSIZE:%Library.BigInt") [ Internal, SqlName = TablesOnly, SqlProc ]
{
}

ClassMethod TablesOnlyExecute(ByRef %q As %Library.Binary, %schema As %Library.String, grantOnly As %Library.Boolean = 1, pFilter As %Library.String = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	s %q=1
	s %q("table")="",%q("go")=grantOnly	// table looping variable
	s %q("schema")=$$$UPPER(%schema)
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	QUIT $$$OK
}

ClassMethod TablesOnlyFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;	 ^rINDEXSQL("rv",$$$UPPER(schema),$$$UPPER(table)) = $LB(classname,extentname,Relation Type - 1 or 3,InternalQualifiedName)
	s AtEnd=0,Row=""
	if %q("schema")="" s AtEnd=1 Quit $$$OK  	// No such schema in this namespace
TOFLoop	s %q("table")=$o(^rINDEXSQL("rv",%q("schema"),%q("table")),1,data)
	if %q("table")="" { s AtEnd=1 QUIT $$$OK } 
	goto:($lg(data,3)'=1) TOFLoop /* not a table */
	if %q("tfilter") {
		set ok=0
		for i=1:1:%q("tfilter") { if %q("table")?@%q("tfilter",i) { set ok=1 quit  }}
		GOTO:'ok TOFLoop	// Table does not match any of the positive patterns specified
	}
	if %q("tfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("tfilter2") { if %q("table")?@%q("tfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TOFLoop	// Table does match one of the NOT patterns specified, don't report it
	}
	GOTO:'$$AnyPrivObj^%SYS.SQLSEC("1,"_$lg(data,4),%q("go")) TOFLoop	// DPV3029
	s ext=$lg(data,2) g:ext="" TOFLoop  ; Corrupt ???
	s extinfo=$$$EXTsqlinfo($$$rEXT,ext)
	s Row=$lb($tr($$$LastPiece($lg(data,4),"."),$c(2),"."),$$$SQLLocTableOwner(extinfo),$zdt($$$SQLLocTableLastCompileTime(extinfo),3),$p($$$SQLTabConnect(ext),",")'="",$s($$$SQLLocTableReadOnly(extinfo)="Y":1,$$$SQLLocFilerReadOnly(extinfo)="Y":1,1:0),$$$SQLLocTableClassname(extinfo),$case($$$SQLLocTableChildTableType(extinfo),"A":0,"L":0,:1),$$$SQLLocTableExtentSize(extinfo))
	QUIT $$$OK
}

ClassMethod TablesOnlyClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Get a List of all BaseTables for the new tree control
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.TablesTree Procedure
/// 	%SQL.Manager.Catalog.TablesTree(pSystem,pFilter)
/// 		Privileges are checked against pre-define $Username.
/// 		This query takes in a filter for schematable name. 
/// 		ARGUMENTS = pSystem	- 1 to return system tables, 0 (default) to return non-system tables only
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all tables are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema name contains ABC and table name contains XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned,
/// 						along with schema names that begin with DEF and tables that begin with XYZ.  
/// 		ROWSPEC = SCHEMA_NAME:%Library.String      - Name of the schema
/// 			  TABLE_NAME:%Library.String       - Name of the table
/// 		Rows are returned in order by SCHEMA_NAME,TABLE_NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query TablesTree(pSystem As %Library.Boolean = 0, pFilter As %Library.String = "") As %Library.Query(ROWSPEC = "SCHEMA_NAME:%Library.String(MAXLEN=128),TABLE_NAME:%Library.String(MAXLEN=128)") [ Internal, SqlName = TablesTree, SqlProc ]
{
}

ClassMethod TablesTreeExecute(ByRef %q As %Library.Binary, pSystem As %Library.String = 0, pFilter As %Library.String = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set %q=1
	set %q("schema")=$e("&",pSystem'=1),%q("table")=""	// looping variables for schema, if pSystem'=1, start looping at "&" (right after % schemas)
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	set %q("system")=pSystem
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	QUIT $$$OK
}

ClassMethod TablesTreeFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;	 ^rINDEXSQL("rv",$$$UPPER(schema),$$$UPPER(table)) = $LB(classname,extentname,Relation Type - 1 or 3,InternalQualifiedName)
	s AtEnd=0,Row=""
	goto:%q("table")'="" TTNLoop
TTSLoop	set %q("schema")=$o(^rINDEXSQL("rv",%q("schema")))
	if %q("schema")="" { set AtEnd=1 QUIT $$$OK }  	// No such schema in this namespace
	goto:%q("schema")="INFORMATION_SCHEMA"&&('%q("system")) TTSLoop	// Skip "INFORMATION_SCHEMA", a system schema
	if %q("sfilter") {
		set ok=0
		for i=1:1:%q("sfilter") { if %q("schema")?@%q("sfilter",i) { set ok=1 quit  }}
		GOTO:'ok TTSLoop	// Schema does not match any of the positive patterns specified
	}
	if %q("sfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("sfilter2") { if %q("schema")?@%q("sfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TTSLoop	// Schema does match one of the NOT patterns specified, don't report it
	}
TTNLoop	set %q("table")=$o(^rINDEXSQL("rv",%q("schema"),%q("table")),1,tData)
	goto:%q("table")="" TTSLoop	// Try next schema
	goto:($lg(tData,3)'=1) TTNLoop	// not a table
	if %q("tfilter") {
		set ok=0
		for i=1:1:%q("tfilter") { if %q("table")?@%q("tfilter",i) { set ok=1 quit  }}
		GOTO:'ok TTNLoop	// Table does not match any of the positive patterns specified
	}
	if %q("tfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("tfilter2") { if %q("table")?@%q("tfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TTNLoop	// Table does match one of the NOT patterns specified, don't report it
	}
	goto:'$$AnyPrivObj^%SYS.SQLSEC("1,"_$lg(tData,4)) TTNLoop	// Make sure user is privileged
	set Row=$lb($$$AllButLastPiece($lg(tData,4),"."),$tr($$$LastPiece($lg(tData,4),"."),$c(2),"."))
	QUIT $$$OK
}

ClassMethod TablesTreeClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Get a List of all Views for the new tree control
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ViewsTree Procedure
/// 	%SQL.Manager.Catalog.ViewsTree(pSystem,pFilter)
/// 		Privileges are checked against pre-define $Username.
/// 		This query takes in a filter for schemaview name. 
/// 		ARGUMENTS = pSystem	- 1 to return system views, 0 (default) to return non-system views only
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all views are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema names containing ABC and view names containing XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema names beginning with ABC and view names beginning with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema names beginning with ABC and view names beginning with XYZ are returned,
/// 					      along with schema names beginning with DEF and view names beginning with XYZ.  
/// 		ROWSPEC = SCHEMA_NAME:%Library.String      - Name of the schema
/// 			  VIEW_NAME:%Library.String        - Name of the view
/// 		Rows are returned in order by SCHEMA_NAME,VIEW_NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ViewsTree(pSystem As %Library.Boolean = 0, pFilter As %Library.String = "") As %Library.Query(ROWSPEC = "SCHEMA_NAME:%Library.String(MAXLEN=128),VIEW_NAME:%Library.String(MAXLEN=128)") [ Internal, SqlName = ViewsTree, SqlProc ]
{
}

ClassMethod ViewsTreeExecute(ByRef %q As %Library.Binary, pSystem As %Library.String = 0, pFilter As %Library.String = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set %q=1
	set %q("schema")=$e("&",pSystem'=1),%q("view")=""	// looping variables for schema, if pSystem'=1, start looping at "&" (right after % schemas)
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	set %q("system")=pSystem
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	QUIT $$$OK
}

ClassMethod ViewsTreeFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;	 ^rINDEXSQL("rv",$$$UPPER(schema),$$$UPPER(view)) = $LB(classname,extentname,Relation Type - 1 or 3,InternalQualifiedName)
	s AtEnd=0,Row=""
	goto:%q("view")'="" TTNLoop
TTSLoop	set %q("schema")=$o(^rINDEXSQL("rv",%q("schema")))
	if %q("schema")="" set AtEnd=1 Quit $$$OK  	// No such schema in this namespace
	goto:%q("schema")="INFORMATION_SCHEMA"&&('%q("system")) TTSLoop	// Skip "INFORMATION_SCHEMA", a system schema
	if %q("sfilter") {
		set ok=0
		for i=1:1:%q("sfilter") { if %q("schema")?@%q("sfilter",i) { set ok=1 quit  }}
		GOTO:'ok TTSLoop	// Schema does not match any of the positive patterns specified
	}
	if %q("sfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("sfilter2") { if %q("schema")?@%q("sfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TTSLoop	// Schema does match one of the NOT patterns specified, don't report it
	}
TTNLoop	set %q("view")=$o(^rINDEXSQL("rv",%q("schema"),%q("view")),1,tData)
	goto:%q("view")="" TTSLoop	// Try next schema
	goto:($lg(tData,3)'=3) TTNLoop	// not a view
	if %q("tfilter") {
		set ok=0
		for i=1:1:%q("tfilter") { if %q("view")?@%q("tfilter",i) { set ok=1 quit  }}
		GOTO:'ok TTNLoop	// View does not match any of the positive patterns specified
	}
	if %q("tfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("tfilter2") { if %q("view")?@%q("tfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TTNLoop	// View does match one of the NOT patterns specified, don't report it
	}
	goto:'$$AnyPrivObj^%SYS.SQLSEC("3,"_$lg(tData,4)) TTNLoop	// Make sure user is privileged
	set Row=$lb($$$AllButLastPiece($lg(tData,4),"."),$tr($$$LastPiece($lg(tData,4),"."),$c(2),"."))
	QUIT $$$OK
}

ClassMethod ViewsTreeClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Get a List of all Procedures for the new tree control
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ProceduresTree Procedure
/// 	%SQL.Manager.Catalog.ProceduresTree(pSystem,pFilter,pTypeFilter)
/// 		Privileges are checked against pre-define $Username.
/// 		This query takes in a filter for schemaProcedure name. 
/// 		ARGUMENTS = pSystem	- 1 to return system procedures, 0 (default) to return non-system procedures only
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all Procedures are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema name contains ABC and Procedure name contains XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema name begin with ABC and Procedure name begin with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema name begin with ABC and Procedure name begin with XYZ are returned,
/// 					       along with schema names that begin with DEF and Procedures that begin with XYZ.  
/// 			    pTypeFilter	- Procedure type filter (optional), used to determine hat type of procedures are returned
/// 					The values are:
/// 					1 - Functions & Queries, no Extent Queries (default)
/// 					2 - Functions & Queries, including Extent Queries
/// 					3 - Functions only
/// 					4 - Queries only, no Extent Queries
/// 					5 - Queries only, including Extent Queries
/// 		ROWSPEC = SCHEMA_NAME:%Library.String      - Name of the schema
/// 			  PROCEDURE_NAME:%Library.String   - Name of the Procedure
/// 		Rows are returned in order by SCHEMA_NAME,PROCEDURE_NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ProceduresTree(pSystem As %Library.Boolean = 0, pFilter As %Library.String = "", pTypeFilter As %Integer = 1) As %Library.Query(ROWSPEC = "SCHEMA_NAME:%Library.String(MAXLEN=128),PROCEDURE_NAME:%Library.String(MAXLEN=128)") [ Internal, SqlName = ProceduresTree, SqlProc ]
{
}

ClassMethod ProceduresTreeExecute(ByRef %q As %Library.Binary, pSystem As %Library.String = 0, pFilter As %Library.String = "", pTypeFilter As %Integer = 1) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set %q=1
	set %q("schema")=$e("&",pSystem'=1),%q("procedure")=""	// looping variables for schema, if pSystem'=1, start looping at "&" (right after % schemas)
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	set %q("typefilter")=pTypeFilter
 	set %q("system")=pSystem
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	QUIT $$$OK
}

ClassMethod ProceduresTreeFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
		#; ^oddPROC($$$UPPER(schema),$$$UPPER(procedure)) = $LB(classname,extentname,Relation Type - 1 or 3,InternalQualifiedName)
	s AtEnd=0,Row=""
	goto:%q("procedure")'="" TTNLoop
TTSLoop	set %q("schema")=$o(^oddPROC(%q("schema")))
	if %q("schema")="" set AtEnd=1 Quit $$$OK  	// No such schema in this namespace
	goto:%q("schema")="INFORMATION_SCHEMA"&&('%q("system")) TTSLoop	// Skip "INFORMATION_SCHEMA", a system schema
	if %q("sfilter") {
		set ok=0
		for i=1:1:%q("sfilter") { if %q("schema")?@%q("sfilter",i) { set ok=1 quit  }}
		GOTO:'ok TTSLoop	// Schema does not match any of the positive patterns specified
	}
	if %q("sfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("sfilter2") { if %q("schema")?@%q("sfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TTSLoop	// Schema does match one of the NOT patterns specified, don't report it
	}
TTNLoop	set %q("procedure")=$o(^oddPROC(%q("schema"),%q("procedure")))
	goto:%q("procedure")="" TTSLoop	// Try next schema
	if %q("tfilter") {
		set ok=0
		for i=1:1:%q("tfilter") { if %q("procedure")?@%q("tfilter",i) { set ok=1 quit  }}
		GOTO:'ok TTNLoop	// procedure does not match any of the positive patterns specified
	}
	if %q("tfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("tfilter2") { if %q("procedure")?@%q("tfilter2",i) { set ok=0 quit  }}
		GOTO:'ok TTNLoop	// procedure does match one of the NOT patterns specified, don't report it
	}
 	//GOTO TTNLoop:$$$PROChidden($$$pPROC,%q("schema"),%q("procedure"))
 	GOTO TTNLoop:'$$$PROCprojected($$$pPROC,%q("schema"),%q("procedure"))
 	if %q("typefilter")=3,$$$PROCtype($$$pPROC,%q("schema"),%q("procedure"))'="function" GOTO TTNLoop	// Looking for functions only
 	if %q("typefilter")>3,$$$PROCtype($$$pPROC,%q("schema"),%q("procedure"))="function" GOTO TTNLoop	// Looking for queries only
 	if (%q("typefilter")=1 || (%q("typefilter")=4)) && ($$$PROCprocedure($$$pPROC,%q("schema"),%q("procedure"))="Extent") GOTO TTNLoop	// No Extent Queries
 	set tName=$g($$$PROCschema($$$pPROC,%q("schema"),%q("procedure")))_"."_$g($$$PROCname($$$pPROC,%q("schema"),%q("procedure")))
	GOTO:'$$ExecutePriv^%SYS.SQLSEC("9,"_tName) TTNLoop	// Make sure user is privileged
	set Row=$lb($$$PROCschema($$$pPROC,%q("schema"),%q("procedure")),$$$PROCname($$$pPROC,%q("schema"),%q("procedure")))
	QUIT $$$OK
}

ClassMethod ProceduresTreeClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q QUIT $$$OK
}

/// <pre>
/// Get a List of all Triggers from a schema.table.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.Triggers Procedure
/// 	%SQL.Manager.Catalog.Triggers('%schema','%table')
/// 		Returns all triggers in the table:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %table	- Name of a table
/// 		ROWSPEC = TRIGGER_NAME:%Library.String	- Name of the trigger
/// 			  TIME_EVENT:%Library.String   - Trigger's TIME and EVENT
/// 			  ORDER:%Library.SmallInt      - Trigger's order with the TIME_EVENT
/// 			  CODE:%Library.String         - Trigger code
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query Triggers(%schema As %Library.String, %table As %Library.String) As %Library.Query(ROWSPEC = "TRIGGER_NAME:%Library.String,TIME_EVENT:%Library.String,ORDER:%Library.Integer,CODE:%Library.String") [ Internal, SqlName = Triggers, SqlProc ]
{
}

ClassMethod TriggersExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %table As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s %q=1
 s %q("class")=$$$GetExtentNameFromTableName(%schema,%table) QUIT:%q("class")="" $$$OK
 s %q("trigger")="",%q("event")="",%q("order")=""
 QUIT $$$OK
}

ClassMethod TriggersFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set AtEnd=0,Row=""
	if %q("class")="" { set AtEnd=1 Quit $$$OK  }  	// No such class in this namespace
TLoop	set %q("trigger")=$$$comMemberNext(%q("class"),$$$cCLASStrigger,%q("trigger"))
	if %q("trigger")="" { set AtEnd=1 QUIT $$$OK  }
	$$$comMemberKeyGetLvar(origin,%q("class"),$$$cCLASStrigger,%q("trigger"),$$$cTRIGGERorigin)
	GOTO:origin="%Library.Persistent" TLoop
	$$$comMemberKeyGetLvar(event,%q("class"),$$$cCLASStrigger,%q("trigger"),$$$cTRIGGERevent)
	$$$comMemberKeyGetLvar(time,%q("class"),$$$cCLASStrigger,%q("trigger"),$$$cTRIGGERtime)
	$$$comMemberKeyGetLvar(order,%q("class"),$$$cCLASStrigger,%q("trigger"),$$$cTRIGGERorder)
	$$$comMemberKeyGetLvar(code,%q("class"),$$$cCLASStrigger,%q("trigger"),$$$cTRIGGERcode)
	set sqlname=$$$comMemberKeyGet(%q("class"),$$$cCLASStrigger,%q("trigger"),$$$cTRIGGERsqlname)
	set:sqlname="" sqlname=%q("trigger")
	set Row=$lb(sqlname,$$$LOWER(time_" "_event),order,code)
	QUIT $$$OK
}

ClassMethod TriggersClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q
 QUIT $$$OK
}

/*
/// Translate any curlybrace ifn in exp into curlybrace FieldNames
ClassMethod ExternalizeCurlyBrace(irn As %Library.Integer, exp As %Library.String) As %Library.String
{
 n a,b,flag,fld,i,quote,tabid,x
 f i=1:1 s a=$p(exp,"{",1,i),b=$p(exp,"{",i+1,999) q:b=""  s quote=($l(a,"""")#2) i quote,exp["}" d  s exp=a_fld_b
 . s fld=$p(b,"}"),b=$p(b,"}",2,999) i '$e(fld) s fld="{"_fld_"}" q  ; Not an ifn
 . s flag=""
 . s x=$l(a),x=$e(a,x-2,x)
 . i fld["*" s flag="*"_$p(fld,"*",2),fld=$p(fld,"*")
 . i fld="" s fld="{}" q
 . s x=$g(^mdd(1,"ifn",fld)),fld=$p(x,$c(1)) i fld="" s fld="{}" q
 . s fld=$$quoter2^%apiDDL(fld)
 . s:$e(fld)="." fld=$e(fld,2,999)
 . s fld="{"_fld_flag_"}"
 QUIT exp
}
	*/
/// <pre>
/// Get a List of all Fields from a schema.view.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ViewFields Procedure
/// 	%SQL.Manager.Catalog.ViewFields('%schema','%view')
/// 		Returns all fields in the view:
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %view	- Name of the view
/// 		ROWSPEC = FIELD_NAME:%Library.String	- Name of the field
/// 			  DATATYPE:%Library.String 	- Field's datatype
/// 			  MAXLEN:%Library.String 	- MAXLEN parameter of field (or NULL)
/// 			  MAXVAL:%Library.String 	- MAXVAL parameter of field (or NULL)
/// 			  MINVAL:%Library.String 	- MINVAL parameter of field (or NULL)
/// 			  BLOB:%Library.String 		- Is field a BLOB, 'Yes' or 'No'
/// 			  LENGTH:%Library.Integer 	- Length of the column
/// 			  PRECISION:%Library.Integer 	- Precision of the column
/// 			  SCALE:%Library.Integer 	- Scale of the column
/// 		Rows are returned view column order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ViewFields(%schema As %Library.String, %view As %Library.String) As %Library.Query(ROWSPEC = "FIELD_NAME:%Library.String,DATATYPE:%Library.String,MAXLEN:%Library.String,MAXVAL:%Library.String,MINVAL:%Library.String,BLOB:%Library.String,LENGTH:%Library.Integer,PRECISION:%Library.Integer,SCALE:%Library.Integer") [ Internal, SqlName = ViewFields, SqlProc ]
{
}

ClassMethod ViewFieldsExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %view As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#;  %q(1) = Extent Name
	#;  %q(2) = Field Loop Variable
	#;  $q(3) = privilege object string
	#;  %q(4) = privileged at table level? (1/0)
	#;  %q(5) = schema name
	#;  %q(6) = view name
 s %q(1)=$$$GetExtentNameFromTableName(%schema,%view) QUIT:%q(1)="" $$$OK
 s %q(2)="",%q(3)="3,"_%schema_"."_%view,%q(4)=$$AnyPrivTable^%SYS.SQLSEC(%q(3),0),%q(5)=%schema,%q(6)=%view
 QUIT $$$OK
}

ClassMethod ViewFieldsFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
#dim blob,data,dt,fieldName,fldinfo,fn,maxlen,parms,tabfldinfo As %Library.String
#dim i As %Library.Integer

	s AtEnd=0,Row=""
	i %q(1)="" s AtEnd=1 QUIT $$$OK
Loop	s %q(2)=$o(^oddSQL(%q(5),%q(6),8,%q(2)),1,data) i %q(2)="" s AtEnd=1 QUIT $$$OK
	set fieldName=$lg(data,4)
	goto:'%q(4)&&'$$AnyPrivField^%SYS.SQLSEC(%q(3),fieldName,0) Loop
	s fldinfo=$$$EXTSQLCOLsqlinfo($$$rEXT,%q(1),fieldName)
	s fn=$$$SQLLocViewColTableFieldName(fldinfo)  ; FieldName ("" for non table field)
	set maxlen="",maxval="",minval=""
	if fn'="" {	// real field
 		set tabfldinfo=$$$EXTSQLCOLsqlinfo($$$rEXT,$$$SQLLocViewColExtent(fldinfo),fn)
 		set dt=$$$SQLLocColDatatype(tabfldinfo)				// Datatype
		if $$$SQLLocColTypeParameters(tabfldinfo)'="" {
			set parms=$$$SQLLocColTypeParameters(tabfldinfo)
			for i=1:1:$ll(parms) {
				if $lg(parms,i)["MAXLEN=" { set maxlen=$p($lg(parms,i),"=",2) }
				if $lg(parms,i)["MAXVAL=" { set maxval=$p($lg(parms,i),"=",2) }
				if $lg(parms,i)["MINVAL=" { set minval=$p($lg(parms,i),"=",2) }
			}
		}
 		s blob=$s($$$SQLLocColStream(tabfldinfo)=1:"Yes",1:"No")	// BLOB?
	}
	Else {		// expression column
		set dt=$$$SQLLocViewColObjType(fldinfo)
		if dt="" {
	 		s dt=$$$SQLLocViewColxDBCType(fldinfo)					// Datatype
 			s:dt||(dt="") dt=$Case(dt,-11:"%Library.UniqueIdentifier",-7:"%Library.Boolean",-6:"%Library.TinyInt",-5:"%Library.BigInt",-4:"%Library.GlobalBinaryStream",-3:"%Library.Binary",-1:"%Library.GlobalCharacterStream",2:"%Library.Numeric",4:"%Library.Integer",5:"%Library.SmallInt",8:"%Library.Float",9:"%Library.Date",10:"%Library.Time",11:"%Library.TimeStamp",:"%Library.String")
		}
 		// if dt="%Library.String" { s maxlen=$$$SQLLocViewColMaxLength(fldinfo) } else { s maxlen="" }	// MAXLEN
 		s maxlen="",blob="No"								// BLOB? // DPV3442 (No MAXLEN parameter for exp cols)
	}
	set Row=$lb(fieldName,dt,maxlen,maxval,minval,blob,$$$SQLLocViewColMaxLength(fldinfo),$$$SQLLocViewColPrecision(fldinfo),$$$SQLLocViewColScale(fldinfo))
	QUIT $$$OK
}

ClassMethod ViewFieldsClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Get full View definition.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ViewInfo Procedure
/// 	%SQL.Manager.Catalog.ViewInfo('%schema','%view')
/// 		Returns a View's Query text
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %view	- Name of a view
/// 		ROWSPEC = VIEW_QUERY:%Library.String - Query Text of the View
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ViewInfo(%schema As %Library.String, %view As %Library.String) As %Library.Query(ROWSPEC = "VIEW_QUERY:%Library.String") [ Internal, SqlName = ViewInfo, SqlProc ]
{
}

ClassMethod ViewInfoExecute(ByRef %q As %Library.Binary, %schema As %Library.String, %view As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#; %q(1) = Fetch count
	#; %q(2) = View extent
 s %q(1)=0
 s %q(2)=$$$GetExtentNameFromTableName(%schema,%view) QUIT:%q(2)="" $$$OK
 QUIT $$$OK
}

ClassMethod ViewInfoFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 s AtEnd=0,Row=""
 i $i(%q(1))>1 s AtEnd=1 QUIT $$$OK  // Second time through, get out
 i %q(2)="" s AtEnd=1 QUIT $$$OK
 s nl=$g($$$EXTsqlviewquery($$$rEXT,%q(2),0))
 i nl="" s AtEnd=1 QUIT $$$OK
 s Row="" 
 For i=1:1:nl s:i'=1||($e($$$StripLeadingWhiteSpace($$$EXTsqlviewquery($$$rEXT,%q(2),i)))'="(") Row=Row_$s(Row="":"",1:$c(13,10))_$$$EXTsqlviewquery($$$rEXT,%q(2),i)
 s Row=$lb(Row)
 QUIT $$$OK
}

ClassMethod ViewInfoClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q
 QUIT $$$OK
}

/// <pre>
/// Get info for a single View
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ViewInfo2 Procedure
/// 	%SQL.Manager.Catalog.ViewInfo2(%'schema','%view')
/// 		Returns metatdata information for the given view
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    %view	- Name of the view
/// 		ROWSPEC = OWNER:%Library.String			- SQL Username of the view's owner
/// 			  LAST_COMPILED:%Library.TimeStamp	- When the view's class was last compiled.
/// 			  DEFINED_AS_READ_ONLY:%Library.Boolean	- TRUE is view is defined WITH READ ONLY (or with READONLY class parameter), FALSE if not
/// 			  UPDATABLE:%Library.Boolean		- TRUE is view is Updatable, FALSE if not
/// 			  CLASSNAME:%Library.String		- Name of the class which projected the view
/// 			  CHECK_OPTION:%Library.String		- CASCADED, LOCAL, ""
/// 			  CLASSTYPE:%Library.String		- Type of the class which projected the view, VIEW, PERSISTENT, etc.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ViewInfo2(%schema As %Library.String, %view As %Library.String) As %Library.Query(ROWSPEC = "OWNER:%Library.String(MAXLEN=64),LAST_COMPILED:%Library.TimeStamp,DEFINED_AS_READ_ONLY:%Library.Boolean,UPDATABLE:%Library.Boolean,CLASSNAME:%Library.String(MAXLEN=64),CHECK_OPTION:%Library.String(MAXLEN=8),CLASSTYPE:%Library.String(MAXLEN=20)") [ Internal, SqlName = ViewInfo2, SqlProc ]
{
}

ClassMethod ViewInfo2Execute(ByRef %q As %Library.Binary, %schema As %Library.String, %view As %Library.String) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#; %q(1) = Fetch count
	#; %q(2) = View extent
 s %q(1)=0
 s %q(2)=$$$GetExtentNameFromTableName(%schema,%view) QUIT:%q(2)="" $$$OK
 QUIT $$$OK
}

ClassMethod ViewInfo2Fetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#dim definedAsReadOnly,extinfo As %Library.String
 set AtEnd=0,Row=""
 if $i(%q(1))>1 s AtEnd=1 QUIT $$$OK  // Second time through, get out
 if %q(2)="" s AtEnd=1 QUIT $$$OK
 set extinfo=$$$EXTsqlinfo($$$rEXT,%q(2))
 set definedAsReadOnly=($$$comMemberKeyGet($$$SQLLocTableClassname(extinfo),$$$cCLASSparameter,"READONLY",$$$cPARAMdefault)=1)
 set Row=$lb($$$SQLLocTableOwner(extinfo),$zdt($$$SQLLocTableLastCompileTime(extinfo),3),definedAsReadOnly,$$$SQLLocViewUpdateable(extinfo),$$$SQLLocTableClassname(extinfo),$s($$$SQLLocViewCheckOption(extinfo)="C":"CASCADED",$$$SQLLocViewCheckOption(extinfo)="L":"LOCAL",1:""),$$$UPPER($$$defClassKeyGet($$$SQLLocTableClassname(extinfo),$$$cCLASSclasstype)))
 QUIT $$$OK
}

ClassMethod ViewInfo2Close(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Get a List of all Views in a schema.
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.ViewsOnly Procedure
/// 	%SQL.Manager.Catalog.ViewsOnly('%schema','grantOnly')
/// 		Privileges are checked against pre-define $Username.
/// 		Returns a list of views defined in the current namespace within the given schema
/// 		ARGUMENTS = %schema	- Name of a schema.
/// 			    grantOnly	- 1 to only return views in the schema the user has at least one grantable privilege for
/// 			    pFilter	- Filter string (optional).  Examples are A*, A_B, 'C*
/// 						* means 0 or more characters
/// 						_ means any one character
/// 						' at the beginning means NOT pattern
/// 					    If nothing is passed in then all tables are returned. 
/// 					    If "*ABC*.*XYZ*" is passed in then schema name contains ABC and table name contains XYZ are returned. 
/// 					    If ABC*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned.  
/// 					    If ABC*.XYZ*,DEF*.XYZ* is passed in then schema name begin with ABC and table name begin with XYZ are returned,
/// 						along with schema names that begin with DEF and tables that begin with XYZ.  
/// 		ROWSPEC = NAME:%Library.String		- Name of the view
/// 		  OWNER:%Library.String			- SQL Username of the view's owner
/// 		  LAST_COMPILED:%Library.TimeStamp	- When the view's class was last compiled.
/// 		  READ_ONLY:%Library.Boolean		- TRUE is view is defined as readonly, FALSE if not
/// 		  UPDATABLE:%Library.Boolean		- TRUE is view is updatable, FALSE if not
/// 		  CLASSNAME:%Library.String		- Name of the class which projected the view
/// 		  CHECK_OPTION:%Library.String		- CASCADED, LOCAL, ""
/// 		  CLASSTYPE:%Library.String		- Type of the class which projected the view, VIEW, PERSISTENT, etc.
/// 		Rows are returned in order by NAME
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query ViewsOnly(%schema As %Library.String, grantOnly As %Library.Boolean = 0, pFilter As %Library.String = "") As %Library.Query(ROWSPEC = "NAME:%Library.String(MAXLEN=128),OWNER:%Library.String(MAXLEN=64),LAST_COMPILED:%Library.TimeStamp,READ_ONLY:%Library.Boolean,UPDATABLE:%Library.Boolean,CLASSNAME:%Library.String(MAXLEN=64),CHECK_OPTION:%Library.String(MAXLEN=8),CLASSTYPE:%Library.String(MAXLEN=20)") [ Internal, SqlName = ViewsOnly, SqlProc ]
{
}

ClassMethod ViewsOnlyExecute(ByRef %q As %Library.Binary, %schema As %Library.String, grantOnly As %Library.Boolean = 0, pFilter As %Library.String = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set %q=1,%q("view")="",%q("go")=grantOnly,%q("schema")=$$$UPPER(%schema)
 	set %q("sfilter")=0,%q("sfilter2")=0
 	set %q("tfilter")=0,%q("tfilter2")=0
 	do:pFilter'="" ..GetFilters(pFilter,.%q)
	QUIT $$$OK
}

ClassMethod ViewsOnlyFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#dim definedAsReadOnly As %Library.Boolean
	s AtEnd=0,Row=""
	if %q("schema")="" s AtEnd=1 Quit $$$OK  	// No such schema in this namespace
VOFLoop	s %q("view")=$o(^rINDEXSQL("rv",%q("schema"),%q("view")),1,data)
	if %q("view")="" { s AtEnd=1 QUIT $$$OK } 
	goto:($lg(data,3)'=3) VOFLoop /* not a view */
	if %q("tfilter") {
		set ok=0
		for i=1:1:%q("tfilter") { if %q("view")?@%q("tfilter",i) { set ok=1 quit  }}
		GOTO:'ok VOFLoop	// View does not match any of the positive patterns specified
	}
	if %q("tfilter2") {	// NOT pattern matches
		set ok=1
		for i=1:1:%q("tfilter2") { if %q("view")?@%q("tfilter2",i) { set ok=0 quit  }}
		GOTO:'ok VOFLoop	// View does match one of the NOT patterns specified, don't report it
	}
	GOTO:'$$AnyPrivObj^%SYS.SQLSEC("3,"_$lg(data,4),%q("go")) VOFLoop	// DPV3029
	s ext=$lg(data,2) g:ext="" VOFLoop  ; Corrupt ???
	s extinfo=$$$EXTsqlinfo($$$rEXT,ext)
	set definedAsReadOnly=($$$comMemberKeyGet($$$SQLLocTableClassname(extinfo),$$$cCLASSparameter,"READONLY",$$$cPARAMdefault)=1)
	s Row=$lb($tr($$$LastPiece($lg(data,4),"."),$c(2),"."),$$$SQLLocTableOwner(extinfo),$zdt($$$SQLLocTableLastCompileTime(extinfo),3),definedAsReadOnly,$$$SQLLocViewUpdateable(extinfo),$$$SQLLocTableClassname(extinfo),$s($$$SQLLocViewCheckOption(extinfo)="C":"CASCADED",$$$SQLLocViewCheckOption(extinfo)="L":"LOCAL",1:""),$$$UPPER($$$defClassKeyGet($$$SQLLocTableClassname(extinfo),$$$cCLASSclasstype)))
	QUIT $$$OK
}

ClassMethod ViewsOnlyClose(ByRef %q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
 k %q QUIT $$$OK
}

/// <pre>
/// Get Query History for SMP Execute Query
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.QueryHistory Procedure
/// 	%SQL.Manager.Catalog.QueryHistory()
/// 		Returns a the Query History for this user
/// 		ROWSPEC = SQL_STATEMENT:%Library.String		- SQL Text of the statement
/// 			  ID:%Library.Integer - ID of the Query History entry
/// 			  SQL_STATEMENT120:%Library.String	- First 120 characters of the SQL statement, used for ordering by the UI
/// 			  LAST_EXECUTED:%Library.TimeStamp	- Timestamp of the last execution of the statement
/// 			  EXECUTE_COUNT:%Library.Integer	- Number of times this Statement has been executed
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query QueryHistory(pFilter As %String) As %Library.Query(ROWSPEC = "SQL_STATEMENT:%Library.String,ID:%Library.Integer,SQL_STATEMENT_120:%Library.String(MAXLEN=120),LAST_EXECUTED:%Library.TimeStamp,EXECUTE_COUNT:%Library.Integer") [ Internal, SqlName = QueryHistory, SqlProc ]
{
}

ClassMethod QueryHistoryExecute(ByRef %q As %Library.Binary, pFilter As %String = "") As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	#; %q(1) = loop id
	#; %q(2,LAST_EXECTUED)=Row
	#;  Query History is stored in %SYS.DynamicStatement as:
	#;		$$$CQ("SMPQueryHistory",$username,0,tID)=$lb($zdt($zu(188),3),1,tHash,QueryText)
	#;  We are going to return the rows ordered by LAST_EXECUTED DESC, ID; so we'll build the ordered output here in Execute and then just loop over it in Fetch
	set %q(1)=""
	for  {
		set %q(1)=$o($$$CQ("SMPQueryHistory",$username,0,%q(1)),1,tData) quit:%q(1)=""
		if pFilter'="",$lg(tData,1)'[pFilter,$$$UPPER($lg(tData,4))'[$$$UPPER(pFilter) { continue }
		set %q(2,$lg(tData,1)_"."_%q(1))=$lb($lg(tData,4),%q(1),$S($lg(tData,4)>120:$E($lg(tData,4),1,120)_"...",1:$lg(tData,4)),$lg(tData,1),$lg(tData,2))
	}
	set %q(1)=""	// Reverse $o() on a timestamp value...
	QUIT $$$OK
}

ClassMethod QueryHistoryFetch(ByRef %q As %Library.Binary, ByRef Row As %Library.List, AtEnd As %Library.Integer) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set AtEnd=0,Row=""
	set %q(1)=$o(%q(2,%q(1)),-1,Row)
	if %q(1)="" { set AtEnd=1,Row="" QUIT $$$OK }
	QUIT $$$OK
}

ClassMethod QueryHistoryClose(%q As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	kill %q
	QUIT $$$OK
}

/// <pre>
/// The CachedQueryTree query returns a list of cached queries the current user has privilege to see
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// %SQL_MANAGER.CachedQueryTree Procedure
/// 	%SQL.Manager.Catalog.CachedQueryTree()
/// 		Returns Cached Queries the current user is privileged to see for this namespace
/// 		ROWSPEC = ROUTINE:%Library.String		- Name of the Cached Query's routine/class
/// 		Rows are returned in no particular order
/// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/// </pre>
Query CachedQueryTree() As %Library.Query(ROWSPEC = "Routine:%Library.String") [ Internal, SqlName = CachedQueryTree, SqlProc ]
{
}

ClassMethod CachedQueryTreeExecute(ByRef qh As %Library.Binary) As %Library.Status [ Internal, ProcedureBlock = 1 ]
{
	set qh=$i(^CacheTemp),%r(qh)=""
	$$$AddTempNode(^CacheTemp(qh))
	set sc=$$CQTreeExecute^%SYS.SQLSRV(qh,"%SQL.Manager.Catalog::CachedQueryTreeExecute")
	QUIT sc
}

ClassMethod CachedQueryTreeFetch(ByRef qh As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ Internal ]
{
	set AtEnd=0,Row="" set %r(qh)=$o(^CacheTemp(qh,%r(qh)),1,Row) QUIT $$$OK
}

ClassMethod CachedQueryTreeClose(qh As %Library.Binary) As %Library.Status [ Internal ]
{
	kill %r(qh),^CacheTemp(qh) $$$RemoveTempNode(^CacheTemp(qh)) QUIT $$$OK
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

/* Utility methods */
ClassMethod MakePat(like As %Library.String, esc As %Library.String) As %Library.String [ Internal, ProcedureBlock = 1 ]
{
 s pat="",str=""
 f nn=1:1 s cc=$e(like,nn) d  QUIT:cc=""  ; Creat the pattern...
 . i "_%"'[cc s:esc=cc nn=nn+1,cc=$e(like,nn) i cc'="" s str=str_$s(cc="""":"""""",1:cc) QUIT
 . s:str'="" pat=pat_"1"""_str_"""",str=""
 . q:cc=""
 . s pat=pat_$s(cc="%":".E",1:"1E")
 QUIT pat
}

/// This utility method will take the filter string and turn it into 4 pieces of pattern match operands we need to check against the name
/// %q("sfilter")  - schema name pattens
/// %q("sfilter2") - schema not NOT patterns
/// %q("tfilter")  - object name pattens
/// %q("tfilter2") - object not NOT patterns
ClassMethod GetFilters(pFilter As %Library.String, ByRef %q As %Library.String) As %Library.String [ Internal, ProcedureBlock = 1 ]
{
	#dim i,not As %Integer
	#dim thisFilter,xx As %String
	
 	if pFilter'="" {
		for i=1:1:$l(pFilter,",") {
				#; Each filter could be separated into schema.table filter, for example *ABC*.*XYZ*
				#; If there is no "." in the filter, assume filter is on schema name only
				#; schema filter first...
			set thisFilter=$$$UPPER($p($p(pFilter,",",i),".",1))
			set:thisFilter="" thisFilter="*"	// .Person should return all schemas
			set not=0 if $e(thisFilter)="'" set not=1,thisFilter=$e(thisFilter,2,*)
			if 'not { set %q("sfilter",$i(%q("sfilter")))=##class(%Library.ODBCCatalog).MakePat($tr(thisFilter,"*","%"),"\") }
		 	else { set %q("sfilter2",$i(%q("sfilter2")))=##class(%Library.ODBCCatalog).MakePat($tr(thisFilter,"*","%"),"\") }
		 	set xx=$p($p(thisFilter,"*"),"_")
		 	continue:$p(pFilter,",",i)'["."
				#; tablename filter second...
			set thisFilter=$$$UPPER($p($p(pFilter,",",i),".",2))
			set:thisFilter="" thisFilter="*"	// Sample. is the same as Sample.*
			set not=0 if $e(thisFilter)="'" set not=1,thisFilter=$e(thisFilter,2,*)
			if 'not { set %q("tfilter",$i(%q("tfilter")))=##class(%Library.ODBCCatalog).MakePat($tr(thisFilter,"*","%"),"\") }
		 	else { set %q("tfilter2",$i(%q("tfilter2")))=##class(%Library.ODBCCatalog).MakePat($tr(thisFilter,"*","%"),"\") }
		 	set xx=$p($p(thisFilter,"*"),"_")
		}
 	} 
	 	#; %q("sfilter"),%q("tfilter") is now an array of pattern match arguments
	 	#; %q("sfilter2"),%q("tfilter2") is an array of NOT pattern match arguments
}

///  This method returns an array of properties and their column names subscripted by an integer.
///  The array can be ordered by property name or SQL column number.
ClassMethod PropertyInfo(class As %String = "", sort As %Integer = 1, ByRef info As %String) As %Status [ Internal, ProcedureBlock = 1 ]
{
	Kill info
	Set info = 0
	If '$Data($$$EXT($$$pEXT,class)) { Quit $$$OK }
	Set property = $Order($$$EXTPROP($$$pEXT,class,""))
	While property '= "" {
		Set sqlcolumn = $Get($$$EXTPROPsqlcolumnnumber($$$pEXT,class,property))
		If sqlcolumn '= "" {
			If sort = 1 { Set info($Increment(info)) = property _ $c(22,35,1) _ $$$EXTPROPsqlcolumnname($$$pEXT,class,property) }
			Else { Set temp(sqlcolumn) = property _ $c(22,35,1) _ $$$EXTPROPsqlcolumnname($$$pEXT,class,property) }
		}
		Set property = $Order($$$EXTPROP($$$pEXT,class,property))
	}
	If sort >1 {
		Set sqlcolumn = $Order(temp(""))
		While sqlcolumn '= "" {
			Set info($Increment(info)) = temp(sqlcolumn)
			Set sqlcolumn = $Order(temp(sqlcolumn))
		}
	}
	Quit $$$OK
}

}
