Class %Dictionary.StorageSQLMapDefinition Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.StorageDefinition [ Cardinality = parent, Inverse = SQLMaps ];

/// BlockCount
Property BlockCount As %Integer [ InitialExpression = 0 ];

/// Condition
Property Condition As %CacheString;

/// ConditionalWithHostVars
Property ConditionalWithHostVars As %Boolean [ InitialExpression = 0 ];

/// ConditionFields
Property ConditionFields As %CacheString;

/// Data
Relationship Data As %Dictionary.StorageSQLMapDataDefinition [ Cardinality = children, Inverse = parent ];

/// Global
Property Global As %CacheString [ SqlFieldName = _Global ];

/// Name
Property Name As %CacheString [ Required ];

/// PopulationPct
Property PopulationPct As %CacheString;

/// PopulationType
Property PopulationType As %CacheString;

/// RowIdSpec
Relationship RowIdSpecs As %Dictionary.StorageSQLMapRowIdSpecDefinition [ Cardinality = children, Inverse = parent ];

/// RowReference
Property RowReference As %CacheString;

/// Structure
Property Structure As %CacheString;

/// Subscript
Relationship Subscripts As %Dictionary.StorageSQLMapSubDefinition [ Cardinality = children, Inverse = parent ];

/// Specifies what kind of a map this is.
Property Type As %CacheString;

ClassMethod TypeIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="data" q $$$OK
 i val="index" q $$$OK
 i val="bitmap" q $$$OK
 i val="bitmapextent" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.StorageSQLMapDefinition:Type",val)
}

Index IDKEY On Name [ IdKey ];

Parameter SQLENABLED = 1;

Trigger OnInsertUpdate [ Event = INSERT/UPDATE ]
{
 set %ok=0
 set %msg="Insert/Update operations not supported on this table."
}

Trigger OnDelete [ Event = DELETE, Time = AFTER ]
{
 $$$defClassKeySet($p({parent},"||",1),$$$cCLASStimechanged,$zutil(188))
 do RebuildItemIndex^%R($p({parent},"||",1),"CLS")
}

Method %OnNew(name As %String) As %Status [ Private ]
{
 i $g(name)="" q $$$OK
 s i%parent=$$$NormalizeClassname($p(name,":",1))_"||"_$p(name,":",2)
 s i%Name=$p(name,":",3)
 q $$$OK
}

ClassMethod %LockId(id As %String, shared As %Boolean = 0, timeout As %Integer) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 QUIT $$LockClassRef^%occLock(name1,shared,.timeout)
}

ClassMethod %UnlockId(id As %String, shared As %Boolean = 0, immediate As %Boolean = 0) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 QUIT $$UnlockClassRef^%occLock(name1,shared,immediate)
}

ClassMethod %Exists(oid As %ObjectIdentity) As %Boolean
{
 s $zt="TrapExists"
 s id=$$$oidPrimary(oid) QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 i (name1="")||(name2="")||(name3="") QUIT 0
 i '$$$defClassDefined(name1)||($$$defClassKeyGet(name1,$$$cCLASSdeployed)=2) QUIT 0
 i $$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3) QUIT 1
 QUIT 0
TrapExists s $zt=""
 QUIT 0
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 s sc=$$$OK
 s $zt="trap"
 i ..%Concurrency>0 s sc=..%LockId(id,..%Concurrency'=4) If $$$ISERR(sc) Quit sc
 i (name1="")||(name2="")||(name3="")||('$$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%BlockCount=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPblockcount)
 . s i%Condition=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPcondition)
 . s i%ConditionalWithHostVars=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionalwithhostvars)
 . s i%ConditionFields=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionfields)
 . s i%Global=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPglobal)
 . s i%PopulationPct=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationpct)
 . s i%PopulationType=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationtype)
 . s i%RowReference=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAProwreference)
 . s i%Structure=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPstructure)
 . s i%Type=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPtype)
exit i ..%Concurrency=2||(..%Concurrency=1) d ..%UnlockId(id,1,1)
 q sc
trap s $zt=""
 s sc=$$$ERROR($$$CacheError,$ze)
 g exit
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 $$$IsClassDefVersionMatched(ismatched) i ismatched=0 q $$$ERROR($$$ClassDictionaryVersionMismatch)
 s sc=$$$OK,id=$$$idCurrent i id'="" s insert=0,idassigned=1
 e  s insert=1,idassigned=0
 s lock=0
 i i%parent'="",'##class(%Dictionary.StorageDefinition).%ExistsId(i%parent) q $$$ERROR($$$ReferencedObjectDoesNotExist,"ClassName")
 i 'insert DO
 . i $s(i%parent'=$p(id,"||",1,2):1,i%Name'=$p(id,"||",3):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 . i '($$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defStorageSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,"")
 . i i%BlockCount=0 { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPblockcount) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPblockcount,i%BlockCount) }
 . i i%Condition="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPcondition) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPcondition,i%Condition) }
 . i i%ConditionalWithHostVars=0 { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionalwithhostvars) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionalwithhostvars,i%ConditionalWithHostVars) }
 . i i%ConditionFields="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionfields) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionfields,i%ConditionFields) }
 . i i%Global="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPglobal) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPglobal,i%Global) }
 . i i%PopulationPct="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationpct) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationpct,i%PopulationPct) }
 . i i%PopulationType="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationtype) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationtype,i%PopulationType) }
 . i i%RowReference="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAProwreference) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAProwreference,i%RowReference) }
 . i i%Structure="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPstructure) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPstructure,i%Structure) }
 . i i%Type="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPtype) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPtype,i%Type) }
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,2):1,i%Name'=$p(id,"||",3):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.StorageSQLMapDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defStorageSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,"")
 . i i%BlockCount=0 { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPblockcount) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPblockcount,i%BlockCount) }
 . i i%Condition="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPcondition) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPcondition,i%Condition) }
 . i i%ConditionalWithHostVars=0 { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionalwithhostvars) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionalwithhostvars,i%ConditionalWithHostVars) }
 . i i%ConditionFields="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionfields) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionfields,i%ConditionFields) }
 . i i%Global="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPglobal) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPglobal,i%Global) }
 . i i%PopulationPct="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationpct) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationpct,i%PopulationPct) }
 . i i%PopulationType="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationtype) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationtype,i%PopulationType) }
 . i i%RowReference="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAProwreference) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAProwreference,i%RowReference) }
 . i i%Structure="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPstructure) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPstructure,i%Structure) }
 . i i%Type="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPtype) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPtype,i%Type) }
 . i ..%Concurrency=3 s sc=..%LockId(id,1)
 . s:..%Concurrency=4 lock=0
 i $$$ISERR(sc) d:lock ..%UnlockId(id) QUIT sc
 d:lock ..%UnlockId(id)
 If $$$ISOK(sc) Set %objTX(9,"Do UpdClsDef^%occLibrary("""_name1_""")")=""
 QUIT sc
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 Quit:id="" $$$ERROR($$$NullId)
 Set sc=$$$OK
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 If concurrency Set sc=..%LockId(id) If $$$ISERR(sc) Quit sc
 If '$$$GetddlNo30,'($$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defStorageSubMemberKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="BlockCount">
<RetrievalCode> s {BlockCount}=$g(^oddDEF({L1},"s",{L3},"S",{L5},29),$g(^%qCacheObjectKey(1,"S",29)))
</RetrievalCode>
</Data>
<Data name="Condition">
<RetrievalCode> s {Condition}=$g(^oddDEF({L1},"s",{L3},"S",{L5},21),$g(^%qCacheObjectKey(1,"S",21)))
</RetrievalCode>
</Data>
<Data name="ConditionFields">
<RetrievalCode> s {ConditionFields}=$g(^oddDEF({L1},"s",{L3},"S",{L5},23),$g(^%qCacheObjectKey(1,"S",23)))
</RetrievalCode>
</Data>
<Data name="ConditionalWithHostVars">
<RetrievalCode> s {ConditionalWithHostVars}=$g(^oddDEF({L1},"s",{L3},"S",{L5},22),$g(^%qCacheObjectKey(1,"S",22)))
</RetrievalCode>
</Data>
<Data name="PopulationPct">
<RetrievalCode> s {PopulationPct}=$g(^oddDEF({L1},"s",{L3},"S",{L5},25),$g(^%qCacheObjectKey(1,"S",25)))
</RetrievalCode>
</Data>
<Data name="PopulationType">
<RetrievalCode> s {PopulationType}=$g(^oddDEF({L1},"s",{L3},"S",{L5},26),$g(^%qCacheObjectKey(1,"S",26)))
</RetrievalCode>
</Data>
<Data name="RowReference">
<RetrievalCode> s {RowReference}=$g(^oddDEF({L1},"s",{L3},"S",{L5},27),$g(^%qCacheObjectKey(1,"S",27)))
</RetrievalCode>
</Data>
<Data name="Structure">
<RetrievalCode> s {Structure}=$g(^oddDEF({L1},"s",{L3},"S",{L5},28),$g(^%qCacheObjectKey(1,"S",28)))
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$g(^oddDEF({L1},"s",{L3},"S",{L5},5),$g(^%qCacheObjectKey(1,"S",5)))
</RetrievalCode>
</Data>
<Data name="_Global">
<RetrievalCode> s {_Global}=$g(^oddDEF({L1},"s",{L3},"S",{L5},24),$g(^%qCacheObjectKey(1,"S",24)))
</RetrievalCode>
</Data>
<Global>^oddDEF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.ClassDefinition.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"s"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.StorageDefinition.Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.StorageSQLMapDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.StorageSQLMa80ES</StreamLocation>
<Type>%CustomStorage</Type>
}

}
