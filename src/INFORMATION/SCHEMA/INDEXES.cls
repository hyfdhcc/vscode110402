/// Returns one row for each indexed field in the current namespace for tables that can be accessed by the current user in the current namespace.
Class INFORMATION.SCHEMA.INDEXES Extends %Library.Persistent [ ClassType = persistent, Final, Owner = {_PUBLIC}, SqlRowIdPrivate, SqlTableName = INDEXES, StorageStrategy = SQLStorage, System = 4 ]
{

Parameter READONLY = 1;

Index IDKeyIndex On (SchemaExact, TableExact, Sequence) [ IdKey, Internal, Unique ];

Property SchemaExact As %String(MAXLEN = 128) [ Internal, Private, Required, SqlColumnNumber = 20 ];

Property TableExact As %String(MAXLEN = 128) [ Internal, Private, Required, SqlColumnNumber = 21 ];

Property Sequence As %Integer [ Internal, Private, Required, SqlColumnNumber = 22 ];

/// Is the table a system table (1 or 0)
Property SystemTable As %Integer [ Calculated, Internal, Private, Required, SqlColumnNumber = 23, SqlComputeCode = { set {*}=$s($e({TABLE_SCHEMA})="%"||({TABLE_SCHEMA}="INFORMATION_SCHEMA"):1,1:0) }, SqlComputed ];

/// Table qualifier - always NULL in Cach&eacute;.
Property TABLECATALOG As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 2, SqlComputeCode = { set {*}="" }, SqlComputed, SqlFieldName = TABLE_CATALOG ];

/// Name of schema that contains the table.
Property TABLESCHEMA As %String(COLLATION = "Upper", MAXLEN = 128) [ Required, SqlColumnNumber = 3, SqlFieldName = TABLE_SCHEMA ];

/// Name of the table.
Property TABLENAME As %String(COLLATION = "Upper", MAXLEN = 128) [ Required, SqlColumnNumber = 4, SqlFieldName = TABLE_NAME ];

/// NON_UNIQUE indicates whether or not the index is a unique index.  Returns one of the following values:
/// <br><ul>
/// 	<li>1 - If the index values can be nonunique (not a unique index).</li>
/// 	<li>0 - if the index values must be unique (a unique index).</li>
/// </ul>
Property NONUNIQUE As %SmallInt [ SqlColumnNumber = 5, SqlFieldName = NON_UNIQUE ];

/// Table qualifier - always NULL in Cach&eacute;.
Property INDEXCATALOG As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 6, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = INDEX_CATALOG ];

/// Name of schema that contains the index.  Always the same as the TABLE_SCHEMA.
Property INDEXSCHEMA As %String(COLLATION = "Upper", MAXLEN = 128) [ Calculated, SqlColumnNumber = 7, SqlComputeCode = { set {*}={TABLE_SCHEMA} }, SqlComputed, SqlFieldName = INDEX_SCHEMA ];

/// Name of the index.
Property INDEXNAME As %String(COLLATION = "Upper", MAXLEN = 128) [ SqlColumnNumber = 8, SqlFieldName = INDEX_NAME ];

/// Column sequence number in index (starting with 1).
Property ORDINALPOSITION As %SmallInt [ SqlColumnNumber = 9, SqlFieldName = ORDINAL_POSITION ];

/// Name of column in the index.
Property COLUMNNAME As %String(COLLATION = "Upper", MAXLEN = 128) [ SqlColumnNumber = 10, SqlFieldName = COLUMN_NAME ];

/// Sort sequence for the column: "A" for ascending; "D" for descending. Cach&eacute; only supports "A" sort sequences.
Property ASCORDESC As %String(COLLATION = "Upper", MAXLEN = 1) [ SqlColumnNumber = 11, SqlFieldName = ASC_OR_DESC ];

/// PRIMARY_KEY indicates whether or not the index is a primary key index.  Returns one of the following values:
/// <br><ul>
/// 	<li>1 - If the index values are the primary key values.</li>
/// 	<li>0 - if the index values are not the primary key values.</li>
/// </ul>
Property PRIMARYKEY As %SmallInt [ Calculated, SqlColumnNumber = 12, SqlComputeCode = { 
	if {NON_UNIQUE}=1 { set {*}=0 }
 	else {
		new tPKeyName
		set tPKeyName=$lg($g(^oddSQL({SchemaExact},{TableExact},4,1)),6)
		set {*}=({INDEX_NAME}=tPKeyName)
		
	}
 }, SqlComputed, SqlFieldName = PRIMARY_KEY ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="ASC_OR_DESC">
<Piece>10</Piece>
</Data>
<Data name="COLUMN_NAME">
<Piece>9</Piece>
</Data>
<Data name="INDEX_NAME">
<Piece>6</Piece>
</Data>
<Data name="NON_UNIQUE">
<Piece>4</Piece>
</Data>
<Data name="ORDINAL_POSITION">
<Piece>8</Piece>
</Data>
<Data name="TABLE_NAME">
<RetrievalCode> set {*}={L2}</RetrievalCode>
</Data>
<Data name="TABLE_SCHEMA">
<RetrievalCode> set {*}={L1}</RetrievalCode>
</Data>
<Global>^oddSQL</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<Expression>{SchemaExact}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TableExact}</Expression>
<Invalidcondition name="1">
<Expression>'($d(^oddSQL({L1},{L2}))#2)</Expression>
</Invalidcondition>
<Invalidcondition name="2">
<Expression>'$$AnyPrivObj^%SYS.SQLSEC($li(^oddSQL({L1},{L2}),6),0)</Expression>
</Invalidcondition>
</Subscript>
<Subscript name="3">
<Expression>9</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Sequence}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="rxIndex">
<Data name="SchemaExact">
<RetrievalCode>set {*}=$p($lg(^rINDEXSQL("rv",{L2},{L3}),4),".",1,*-1)</RetrievalCode>
</Data>
<Data name="TableExact">
<RetrievalCode>set {*}=$tr($p($lg(^rINDEXSQL("rv",{L2},{L3}),4),".",*),$c(2),".")</RetrievalCode>
</Data>
<Global>^rINDEXSQL</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<Expression>"rv"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$UPPER({TABLE_SCHEMA})</Expression>
</Subscript>
<Subscript name="3">
<Accessvar name="1">
<Code> set {3D1}=$p($lg(^rINDEXSQL("rv",{L2},{L3}),4),".",1,*-1)</Code>
<Variable>{3D1}</Variable>
</Accessvar>
<Accessvar name="2">
<Code> set {3D2}=$tr($p($lg(^rINDEXSQL("rv",{L2},{L3}),4),".",*),$c(2),".")</Code>
<Variable>{3D2}</Variable>
</Accessvar>
<Expression>$$UPPER({TABLE_NAME})</Expression>
<Invalidcondition name="1">
<Expression>'$$AnyPrivObj^%SYS.SQLSEC($li(^rINDEXSQL("rv",{L2},{L3}),3)_","_$li(^rINDEXSQL("rv",{L2},{L3}),4))</Expression>
</Invalidcondition>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<DataAccess>^oddSQL({3D1},{3D2},9)</DataAccess>
<Expression>{Sequence}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^INFORMATION.SCHEMA.STATISTICSS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
