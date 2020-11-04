/// Returns one row for each schema in the current namespace where the current user has privileges for any object in the namespace.
Class INFORMATION.SCHEMA.SCHEMATA Extends %Library.Persistent [ ClassType = persistent, Final, Owner = {_PUBLIC}, SqlRowIdPrivate, SqlTableName = SCHEMATA, StorageStrategy = SQLStorage, System = 4 ]
{

Parameter READONLY = 1;

Index IDKeyIndex On SchemaUpper [ IdKey, Internal, Unique ];

Property SchemaUpper As %String(MAXLEN = 128) [ Internal, Private, Required, SqlColumnNumber = 10 ];

/// Is the table a system schema (1 or 0)
Property SystemSchema As %Integer [ Calculated, Internal, Private, Required, SqlColumnNumber = 11, SqlComputeCode = { set {*}=$s($e({SCHEMA_NAME})="%"||({SCHEMA_NAME}="INFORMATION_SCHEMA"):1,1:0) }, SqlComputed ];

/// Catalog name - always NULL in Cach&eacute;.
Property CATALOGNAME As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 2, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = CATALOG_NAME ];

/// Name of the schema.
Property SCHEMANAME As %String(COLLATION = "Upper", MAXLEN = 128) [ Required, SqlColumnNumber = 3, SqlFieldName = SCHEMA_NAME ];

/// Owner of the schema - always NULL in Cach&eacute;.
Property SCHEMAOWNER As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 4, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = SCHEMA_OWNER ];

/// Catalog name of the default character set for columns and domains in the schemata.  Always NULL in Cach&eacute;.
Property DEFAULTCHARACTERSETCATALOG As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 5, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = DEFAULT_CHARACTER_SET_CATALOG ];

/// Schema name of the default character set for columns and domains in the schemata.  Always NULL in Cach&eacute;.
Property DEFAULTCHARACTERSETSCHEMA As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 6, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = DEFAULT_CHARACTER_SET_SCHEMA ];

/// Name of the default character set for columns and domains in the schemata.  Always NULL in Cach&eacute;.
Property DEFAULTCHARACTERSETNAME As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 7, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = DEFAULT_CHARACTER_SET_NAME ];

/// Reserved for future use.  Always NULL in Cach&eacute;.
Property SQLPATH As %String(MAXLEN = 128) [ Calculated, SqlColumnNumber = 8, SqlComputeCode = { set {*}=""}, SqlComputed, SqlFieldName = SQL_PATH ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="SCHEMA_NAME"/>
<Global>^rINDEXSQL</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<Expression>"schema"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SchemaUpper}</Expression>
<Invalidcondition name="1">
<Expression>
<![CDATA['$$AnySchemaTablePriv^%SYS.SQLSEC({L2},0)&&('$$AnySchemaViewPriv^%SYS.SQLSEC({L2},0))&&('$$AnySchemaProcPriv^%SYS.SQLSEC({L2},0))]]></Expression>
</Invalidcondition>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^INFORMATION.SCHEMA.SCHEMATAS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
