/// This [read-only] class/table maps to a single condition row in ^SpeedI.Hi
/// It contains one record per Id present in the bitstring.
/// The Id is Col#, the data is Id in target class.
/// It can be used as a normal table, as in
/// select Name,City,Country,Sex into :name,:city,:country,:sex
/// from Speed.Hi,SQLUser.HPerson
/// where Class = "User.HPerson"
/// and Cond = 1961
/// and TheId = SQLUser.HPerson.Id
Class %BI.Hi Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, StorageStrategy = HiStorage, System = 4 ]
{

Index Col On (Class, Cond, Col) [ IdKey ];

Property Class As %String(TRUNCATE = 1);

Property Col As %Integer;

Property Cond As %BI.Condition;

Property NumericId As %Integer;

Property StringId As %String(TRUNCATE = 1);

Method %OnBeforeSave(Insert As %Boolean) As %Status [ Final ]
{
 quit $$$ERROR($$$GeneralError,"Class %BI.Hi is Read-only")
}

ClassMethod %OnDelete(Oid As %ObjectIdentity) As %Status [ Final ]
{
 quit $$$ERROR($$$GeneralError,"Class %BI.Hi is Read-only")
}

Trigger HyperDelete [ Event = DELETE ]
{
 set %ok=0,%msg="Class %BI.Hi is read-only"
 quit
}

Trigger HyperInsert [ Event = INSERT, Order = 1 ]
{
 set %ok=0,%msg="Class %BI.Hi is read-only"
 quit
}

Trigger HyperUpdate [ Event = UPDATE ]
{
 set %ok=0,%msg="Class %BI.Hi is read-only"
 quit
}

Storage HiStorage
{
<SQLMap name="HiMaster">
<Data name="NumericId">
<RetrievalCode> set {*}=$Get(^BIidx.Col({L1},{L3}))

</RetrievalCode>
</Data>
<Data name="StringId">
<RetrievalCode> set {*}=$Get(^BIidx.Col({L1},{L3}))

</RetrievalCode>
</Data>
<Global>^BIidx.Hi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Class</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>Cond</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>Col</Field>
</RowIdSpec>
<RowReference>^BIidx.Col({L1},{L3})</RowReference>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Class}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Cond}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>other</AccessType>
<Expression>{Col}</Expression>
<Invalidcondition name="1">
<Expression>'##class(%BI.MinerUtils).GetBit({L1},{L2},{L3})</Expression>
</Invalidcondition>
<NextCode> set {L3}=##class(%BI.MinerUtils).Next({L1},{L2},{L3})

</NextCode>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^BIidx.HiS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
