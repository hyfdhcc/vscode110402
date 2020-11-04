/// <p>This is a read-only object representation wrapping the internal iKnow data structures for 
/// unique CRCs in a Virtual Source.</p>
/// <p>This class can be used from Cache ObjectScript or SQL to access a single or small number of
/// entries, but the storage mappings are not meant to support elaborate or complex queries
/// targeting this SQL table.</p>
/// <p>Please use the predefined queries in <class>%iKnow.Queries.CrcAPI</class> and other query classes
/// to consult CRC data as the internal global structures are designed to optimize performance for
/// these queries rather than general-purpose access.</p>
Class %iKnow.Objects.VirtualCrcUnique Extends %Persistent [ StorageStrategy = iKnowStorage, System = 4 ]
{

Parameter READONLY = 1;

Property DomainId As %Integer;

Property VirtualSourceId As %Integer;

Property CrcUniId As %Integer;

Property RealCrcUniId As %Integer [ Calculated, SqlComputeCode = { set {RealCrcUniId} = $lg(^ISC.IKV.CrcUniDetails({DomainId},{VirtualSourceId},{CrcUniId}),2) }, SqlComputed ];

Property MasterId As %Integer;

Property RelationId As %Integer;

Property SlaveId As %Integer;

Property Frequency As %Integer [ Calculated, SqlComputeCode = { set {Frequency} = $lg(^ISC.IK.CrcUniDetails({DomainId},{VirtualSourceId},{CrcUniId}),1) }, SqlComputed ];

Index PKINDEX On (DomainId, VirtualSourceId, CrcUniId) [ IdKey, PrimaryKey, Unique ];

Property Master As %iKnow.Objects.VirtualEntityUnique [ Calculated, SqlComputeCode = { set {Master} = {DomainId} _"||"_ {VirtualSourceId} _"||"_ {MasterId} }, SqlComputed ];

Property Relation As %iKnow.Objects.VirtualEntityUnique [ Calculated, SqlComputeCode = { set {Relation} = {DomainId} _"||"_ {VirtualSourceId} _"||"_ {RelationId} }, SqlComputed ];

Property Slave As %iKnow.Objects.VirtualEntityUnique [ Calculated, SqlComputeCode = { set {Slave} = {DomainId} _"||"_ {VirtualSourceId} _"||"_ {SlaveId} }, SqlComputed ];

Storage iKnowStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MainMap">
<Data name="MasterId">
<Piece>1</Piece>
</Data>
<Data name="RelationId">
<Piece>2</Piece>
</Data>
<Data name="SlaveId">
<Piece>3</Piece>
</Data>
<Global>^ISC.IKV.CrcUniId</Global>
<Subscript name="1">
<Expression>{DomainId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{VirtualSourceId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CrcUniId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^ISC.IK.Objects.VirtCrcUniqueS</StreamLocation>
<Type>%Library.CacheSQLStorage</Type>
}

}
