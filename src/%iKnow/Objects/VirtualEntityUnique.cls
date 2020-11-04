/// <p>This is a read-only object representation wrapping the internal iKnow data structures for 
/// unique Entities in a Virtual Source.</p>
/// <p>This class can be used from Cache ObjectScript or SQL to access a single or small number of
/// entries, but the storage mappings are not meant to support elaborate or complex queries
/// targeting this SQL table.</p>
/// <p>Please use the predefined queries in <class>%iKnow.Queries.EntityAPI</class> and other query classes
/// to consult entity data as the internal global structures are designed to optimize performance for
/// these queries rather than general-purpose access.</p>
Class %iKnow.Objects.VirtualEntityUnique Extends %Persistent [ StorageStrategy = iKnowStorage, System = 4 ]
{

Parameter READONLY = 1;

Property DomainId As %Integer;

Property VirtualSourceId As %Integer;

Property EntUniId As %Integer;

Property RealEntUniId As %Integer [ Calculated, SqlComputeCode = {set {RealEntUniId} = $lg(^ISC.IKV.EntUniDetails({DomainId},{VirtualSourceId},{EntUniId}),3) }, SqlComputed ];

Property EntityValue As %String(MAXLEN = 2000);

Property Frequency As %Integer [ Calculated, SqlComputeCode = {set {Frequency} = {FrequencyAsConcept} + {FrequencyAsRelation}}, SqlComputed ];

Property FrequencyAsConcept As %Integer [ Calculated, SqlComputeCode = {set {FrequencyAsConcept} = +$lg(^ISC.IKV.EntUniDetails({DomainId},{VirtualSourceId},{EntUniId}),1) }, SqlComputed ];

Property FrequencyAsRelation As %Integer [ Calculated, SqlComputeCode = {set {FrequencyAsRelation} = +$lg(^ISC.IKV.EntUniDetails({DomainId},{VirtualSourceId},{EntUniId}),2) }, SqlComputed ];

Index PKINDEX On (DomainId, VirtualSourceId, EntUniId) [ IdKey, PrimaryKey, Unique ];

Storage iKnowStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MainMap">
<Data name="EntityValue"/>
<Global>^ISC.IKV.EntUniId</Global>
<Subscript name="1">
<Expression>{DomainId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{VirtualSourceId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EntUniId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^ISC.IK.Objects.VirtEntUniqueS</StreamLocation>
<Type>%Library.CacheSQLStorage</Type>
}

}
