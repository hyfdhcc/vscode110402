Include %IKInclude

/// <p>Note: the use of this class is no longer recommended for accessing elements of a specific domain.
/// For those scenarios, <class>%iKnow.Tables.Utils</class> offers a more flexible and customizable
/// way of projecting iKnow domain data to SQL</p>
///  <p>This is a read-only object representation wrapping the internal iKnow data structures for 
///  unique CCs.</p>
///  <p>This class can be used from Cache ObjectScript or SQL to access a single or small number of
///  entries, but the storage mappings are not meant to support elaborate or complex queries
///  targeting this SQL table.</p>
///  <p>Please use the predefined queries in <class>%iKnow.Queries.CcAPI</class> and other query classes
///  to consult CC data as the internal global structures are designed to optimize performance for
///  these queries rather than general-purpose access.</p>
///  <p>NOTE: This object assumes all underlying data structures are present. Use domain-specific
///  copies of these objects for domains where not all indices are built. See also the 
///  GenerateAllObjectsForDomain() method in <class>%iKnow.Objects.Utils</class>.</p>
Class %iKnow.Objects.CcUnique Extends %Persistent [ StorageStrategy = iKnowStorage, System = 4 ]
{

Parameter READONLY = 1;

Property DomainId As %Integer;

Property CcUniId As %Integer;

Property MasterId As %Integer;

Property SlaveId As %Integer;

Property CorpusFrequency As %Integer [ Calculated, SqlComputeCode = { set {CorpusFrequency} = $lg(^ISC.IK.CcUniDet({DomainId},{CcUniId}),1) }, SqlComputed ];

Property CorpusSpread As %Integer [ Calculated, SqlComputeCode = { set {CorpusSpread} = $lg(^ISC.IK.CcUniDet({DomainId},{CcUniId}),2) }, SqlComputed ];

Index PKINDEX On (DomainId, CcUniId) [ IdKey, PrimaryKey, Unique ];

Property Master As %iKnow.Objects.EntityUnique [ Calculated, SqlComputeCode = { set {Master} = {DomainId} _"||"_ {MasterId} }, SqlComputed ];

Property Slave As %iKnow.Objects.EntityUnique [ Calculated, SqlComputeCode = { set {Slave} = {DomainId} _"||"_ {SlaveId} }, SqlComputed ];

Index CcUni On (DomainId, MasterId, SlaveId) [ Unique ];

Index CcUniIdFreq On (DomainId, CorpusFrequency);

Index CcUniIdSpread On (DomainId, CorpusSpread);

Storage iKnowStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="CcUni">
<Data name="CcUniId"/>
<Global>^ISC.IK.CcUni</Global>
<RowIdSpec name="1">
<Expression>{S1}</Expression>
<Field>DomainId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{CcUniId}</Expression>
<Field>CcUniId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DomainId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MasterId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SlaveId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CcUniIdFreq">
<Global>^ISC.IK.CcUniIdFreq</Global>
<RowIdSpec name="1">
<Expression>{S1}</Expression>
<Field>DomainId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{S3}</Expression>
<Field>CcUniId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DomainId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>-{CorpusFrequency}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CcUniId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CcUniIdSpread">
<Global>^ISC.IK.CcUniIdSpread</Global>
<RowIdSpec name="1">
<Expression>{S1}</Expression>
<Field>DomainId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{S3}</Expression>
<Field>CcUniId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DomainId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>-{CorpusSpread}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CcUniId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MainMap">
<Data name="MasterId">
<Piece>1</Piece>
</Data>
<Data name="SlaveId">
<Piece>2</Piece>
</Data>
<Global>^ISC.IK.CcUniId</Global>
<Subscript name="1">
<Expression>{DomainId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CcUniId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^ISC.IK.Objects.CcUniqueS</StreamLocation>
<Type>%Library.CacheSQLStorage</Type>
}

}
