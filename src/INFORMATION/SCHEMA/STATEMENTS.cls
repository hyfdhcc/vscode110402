/// Contains SQL Statement Index entries that can be accessed by the current user in the current namespace.
Class INFORMATION.SCHEMA.STATEMENTS Extends (%Library.Persistent, %XML.Adaptor) [ ClassType = persistent, Final, Owner = {_PUBLIC}, SqlRowIdPrivate, SqlTableName = STATEMENTS, StorageStrategy = SQLStorage, System = 4 ]
{

Parameter READONLY = 1;

Index IDKeyIndex On Hash [ IdKey, Internal, Unique ];

/// Internal unique statement hash used as the ID for the statement.
Property Hash As %String(MAXLEN = 32) [ Required, SqlColumnNumber = 2 ];

/// SQL Compilation mode, Logical, Odbc, Display, Runtime, etc., when the statement was compiled
Property SqlComp As %String(MAXLEN = 32) [ SqlColumnNumber = 3 ];

/// Value of %defschema when the statement was compiled
Property DefaultSchema As %Library.List [ SqlColumnNumber = 4 ];

/// Value of %sqlSchemaPath when the statement was compiled
Property SQLSchemaPath As %Library.List [ SqlColumnNumber = 5 ];

/// Value of packages argument passed to SQL compiler when the statement was compiled
Property Packages As %Library.List [ SqlColumnNumber = 6 ];

/// Value of %switch when the statement was compiled
Property Switch As %String(MAXLEN = 32) [ SqlColumnNumber = 7 ];

/// 0/1/2/3 flag which defines if the statement plan Unfrozen (0), Frozen/Explicit (1), Frozen/Upgrade (2), or Unfrozen/Parallel (3)
Property Frozen As %Integer [ SqlColumnNumber = 8 ];

/// Timestamp value for when the plan was saved.
Property Timestamp As %TimeStamp [ SqlColumnNumber = 9 ];

/// $zversion string for when the plan was saved.
Property Version As %String(MAXLEN = 200) [ SqlColumnNumber = 10 ];

/// Error string recorded for this plan
Property Error As %String(MAXLEN = 4096) [ SqlColumnNumber = 11 ];

/// Query plan
Property Plan As list Of %Binary(MAXLEN = 65536) [ SqlColumnNumber = 12, SqlListType = SUBNODE ];

Property Statement As %String(COLLATION = "STRING(150)", MAXLEN = 262144) [ SqlColumnNumber = 13 ];

/// Hash of this statement's parent statement.  Only defined if this is a recursive compile for %PARALLEL statements.  This references the root parent's hash.
Property ParentHash As %String(MAXLEN = 32) [ Required, SqlColumnNumber = 14 ];

/// Version counter for internal statement version
Property StatementVersion As %Integer [ Internal, SqlColumnNumber = 15 ];

Relationship Children As INFORMATION.SCHEMA.STATEMENTCHILDREN [ Cardinality = children, Inverse = Statement ];

Relationship Relations As INFORMATION.SCHEMA.STATEMENTRELATIONS [ Cardinality = children, Inverse = Statement ];

Relationship Locations As INFORMATION.SCHEMA.STATEMENTLOCATIONS(XMLPROJECTION = "NONE") [ Cardinality = children, Inverse = Statement ];

Relationship PrivilegeRelations As INFORMATION.SCHEMA.STATEMENTPRIVOBJECTS [ Cardinality = children, Inverse = Statements ];

/// Table qualifier - always NULL in Cach&eacute;.
Storage SQLStorage
{
<Description>
<![CDATA[Table qualifier - always NULL in Cach&eacute;.]]></Description>
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="DefaultSchema">
<Node>0</Node>
<Piece>3</Piece>
</Data>
<Data name="Error">
<Node>"err"</Node>
</Data>
<Data name="Frozen">
<Node>"planinfo"</Node>
<Piece>1</Piece>
</Data>
<Data name="Packages">
<Node>0</Node>
<Piece>4</Piece>
</Data>
<Data name="ParentHash">
<Node>"planinfo"</Node>
<Piece>4</Piece>
</Data>
<Data name="Plan">
<RetrievalCode>new i,plan set plan="" for i=1:1:$g(^rINDEXSQL({L1},{L2},{L3},"plan")) { set plan=plan_$lb($g(^rINDEXSQL({L1},{L2},{L3},"plan",i))) } set {*}=plan</RetrievalCode>
</Data>
<Data name="SQLSchemaPath">
<Node>0</Node>
<Piece>2</Piece>
</Data>
<Data name="SqlComp">
<Node>0</Node>
<Piece>1</Piece>
</Data>
<Data name="Statement">
<RetrievalCode>new i,sql set sql="" for i=1:1:$g(^rINDEXSQL({L1},{L2},{L3},1)) { set sql=sql_" "_$g(^rINDEXSQL({L1},{L2},{L3},1,i)) } set {*}=sql</RetrievalCode>
</Data>
<Data name="StatementVersion">
<RetrievalCode>set {*}={3D}</RetrievalCode>
</Data>
<Data name="Switch">
<Node>0</Node>
<Piece>5</Piece>
</Data>
<Data name="Timestamp">
<Node>"planinfo"</Node>
<Piece>2</Piece>
</Data>
<Data name="Version">
<Node>"planinfo"</Node>
<Piece>3</Piece>
</Data>
<Global>^rINDEXSQL</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<Expression>"sqlidx"</Expression>
</Subscript>
<Subscript name="2">
<Expression>1</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Hash}</Expression>
<Invalidcondition name="1">
<Expression>'$$StatementIndexPrivileged^%SYS.SQLSEC({L3})</Expression>
</Invalidcondition>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^INFORMATION.SCHEMA.STATISTICSS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
