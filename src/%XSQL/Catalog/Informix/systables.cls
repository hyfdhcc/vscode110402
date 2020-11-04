/// The systables system catalog table describes each table in the database. 
/// It contains one row for each table, view, or synonym that is defined in the database. 
/// This includes all database tables and the system catalog tables.
Class %XSQL.Catalog.Informix.systables Extends %Persistent [ SqlRowIdPrivate, StorageStrategy = SQLStorage, System = 4 ]
{

Parameter READONLY = 1;

/// Name of table, view, or synonym
Property tabname As %String(MAXLEN = 128) [ SqlColumnNumber = 2 ];

/// Owner of table (user informix for system catalog tables and user name for database tables)
Property owner As %String(MAXLEN = 128) [ SqlColumnNumber = 3, SqlComputeCode = { Set {owner}=$ListGet($Get(^oddEXTR({extentname},91)),4)}, SqlComputed, Transient ];

/// Tblspace identifier (similar to tabid)
/// Property partnum As %Integer [ SqlColumnNumber = 4 ];
/// System-assigned sequential ID number (system tables: 1 through 24, user tables: 100 through nnn)
Property tabid As %Integer [ SqlColumnNumber = 5 ];

/*
/// Row size
Property rowsize As %Smallint [ SqlColumnNumber = 6 ];

/// Number of columns
/// Property ncols As %Smallint [ SqlColumnNumber = 7 ];
/// Number of indexes
Property nindexes  As %Smallint [ SqlColumnNumber = 8 ];

/// Number of nrows 
Property nrows   As %Integer [ SqlColumnNumber = 9 ];

/// Date created
Property created As %Date [ SqlColumnNumber = 10 ];

/// Number that changes when table is altered
Property version As %Integer [ SqlColumnNumber = 11 ];
*/
/// Table type:
/// 	'T' = Table
/// 	'V' = View
/// 	'P' = Private synonym
/// 	'P' = Synonym (in an ANSI-compliant database)
/// 	'S' = Synonym 
Property tabtype As %String(MAXLEN = 1) [ SqlColumnNumber = 12, SqlComputeCode = { Set {tabtype}=$Case({tabtype_internal},"U":"T","S":"T","V":"V",:"?")}, SqlComputed, Transient ];

/*
/// Lock mode for a table:
///	'B' = Page
///	'P' = Page
///	'R' = Row 
Property locklevel As %String(MAXLEN = 1) [ SqlColumnNumber = 13 ];

/// Number of data pages in use
Property npused As %Integer [ SqlColumnNumber = 14 ];

/// Size of initial extent (in kilobytes)
Property fextsize As %Integer [ SqlColumnNumber = 15 ];

/// Size of all subsequent extents (in kilobytes)
Property xextsize As %Integer [ SqlColumnNumber = 16 ];

/// Reserved for future use
Property flags As %String [ SqlColumnNumber = 17 ];

/// Reserved for future use (used to store database collation and C type information)
Property site As %String [ SqlColumnNumber = 18 ];

/// Reserved for future use
Property dbname As %String [ SqlColumnNumber = 19 ];

/// Data type of table, if the table is a typed table
Property typexid As %Integer [ SqlColumnNumber = 20, sqlfieldname = type_xid ];

/// Access method identifier. A primary access method can be specified when the table is created. 
///A value of null or zero indicates that the built-in storage manager is being used.
/// This is the am_id in the sysams system catalog table. 
Property amid As %Integer [ SqlColumnNumber = 21, sqlfieldname = am_xid ];
*/
/// Name of the schema the table resides in
Property schema As %String(MAXLEN = 128) [ Private, SqlColumnNumber = 22 ];

/// Name of the extent that projected this table
Property extentname As %String(MAXLEN = 128) [ Internal, Private, SqlColumnNumber = 23, SqlComputeCode = { Set {extentname}=$ListGet($Get(^rINDEXSQL("rv",$zcvt({schema},"U"),$zcvt({tabname},"U"))),2)}, SqlComputed, Transient ];

/// Table type:
/// 	'U' = User table
/// 	'V' = View
/// 	'S' = System Table
Property tabtypeinternal As %String(MAXLEN = 1) [ Private, SqlColumnNumber = 24, SqlFieldName = tabtype_internal ];

Index IDKEYIndex On tabid [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="schema">
<Piece>1</Piece>
</Data>
<Data name="tabname">
<Piece>2</Piece>
</Data>
<Data name="tabtype_internal">
<Piece>3</Piece>
</Data>
<Global>^oddTSQL</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<Expression>{tabid}</Expression>
<Invalidcondition name="1">
<Expression>$Case($lg($Get(^oddTSQL({L1})),3),"S":0,"U":0,"V":0,:1)</Expression>
</Invalidcondition>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="SchemaNameIndex">
<Global>^oddSQL</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<Expression>{schema}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{tabname}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"tsql"</Expression>
</Subscript>
<Subscript name="4">
<Expression>1</Expression>
</Subscript>
<Subscript name="5">
<Expression>{tabid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dbo.sysobjectsS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
