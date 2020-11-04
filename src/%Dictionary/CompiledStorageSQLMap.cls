Class %Dictionary.CompiledStorageSQLMap Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledStorage [ Cardinality = parent, Inverse = SQLMaps ];

/// BlockCount
Property BlockCount As %Integer;

/// Condition
Property Condition As %CacheString;

/// ConditionalWithHostVars
Property ConditionalWithHostVars As %Boolean;

/// ConditionFields
Property ConditionFields As %CacheString;

/// Data
Relationship Data As %Dictionary.CompiledStorageSQLMapData [ Cardinality = children, Inverse = parent ];

/// Global
Property Global As %CacheString [ SqlFieldName = _Global ];

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Name
Property Name As %CacheString [ Required ];

/// PopulationPct
Property PopulationPct As %CacheString;

/// PopulationType
Property PopulationType As %CacheString;

/// RowIdSpec
Relationship RowIdSpecs As %Dictionary.CompiledStorageSQLMapRowIdSpec [ Cardinality = children, Inverse = parent ];

/// RowReference
Property RowReference As %CacheString;

/// Structure
Property Structure As %CacheString;

/// Subscript
Relationship Subscripts As %Dictionary.CompiledStorageSQLMapSub [ Cardinality = children, Inverse = parent ];

/// Specifies what kind of a map this is.
Property Type As %CacheString;

Index IDKEY On Name [ IdKey ];

Parameter SQLENABLED = 1;

Trigger OnInsertUpdate [ Event = INSERT/UPDATE ]
{
 set %ok=0
 set %msg="Insert/Update operations not supported on this table."
}

Trigger OnDelete [ Event = DELETE ]
{
 set %ok=0
 set %msg="Delete operation not supported on this table."
}

Method %OnNew(name As %String) As %Status [ Private ]
{
 q $$$ERROR($$$CanNotNewCompiledDictionaryClasses)
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
 i $$$comStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3) QUIT 1
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
 i (name1="")||(name2="")||(name3="")||('$$$comStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%BlockCount=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPblockcount)
 . s i%Condition=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPcondition)
 . s i%ConditionalWithHostVars=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionalwithhostvars)
 . s i%ConditionFields=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPconditionfields)
 . s i%Global=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPglobal)
 . s i%KeywordError=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPkeyworderror)
 . s i%KeywordModified=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPkeywordmodified)
 . s i%PopulationPct=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationpct)
 . s i%PopulationType=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPpopulationtype)
 . s i%RowReference=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAProwreference)
 . s i%Structure=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPstructure)
 . s i%Type=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPtype)
exit i ..%Concurrency=2||(..%Concurrency=1) d ..%UnlockId(id,1,1)
 q sc
trap s $zt=""
 s sc=$$$ERROR($$$CacheError,$ze)
 g exit
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 q $$$ERROR($$$CanNotSaveCompiledDictionaryClasses)
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
	Quit $$$ERROR($$$CanNotDeleteCompiledDictionaryClasses)
}

Storage custom
{
<SQLMap name="Master">
<Data name="BlockCount">
<RetrievalCode> s {BlockCount}=$g(^oddCOM({L1},"s",{L3},"S",{L5},29),$g(^%qCacheObjectKey(1,"S",29)))
</RetrievalCode>
</Data>
<Data name="Condition">
<RetrievalCode> s {Condition}=$g(^oddCOM({L1},"s",{L3},"S",{L5},21),$g(^%qCacheObjectKey(1,"S",21)))
</RetrievalCode>
</Data>
<Data name="ConditionFields">
<RetrievalCode> s {ConditionFields}=$g(^oddCOM({L1},"s",{L3},"S",{L5},23),$g(^%qCacheObjectKey(1,"S",23)))
</RetrievalCode>
</Data>
<Data name="ConditionalWithHostVars">
<RetrievalCode> s {ConditionalWithHostVars}=$g(^oddCOM({L1},"s",{L3},"S",{L5},22),$g(^%qCacheObjectKey(1,"S",22)))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$g(^oddCOM({L1},"s",{L3},"S",{L5},12),$g(^%qCacheObjectKey(1,"S",12)))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$g(^oddCOM({L1},"s",{L3},"S",{L5},13),$g(^%qCacheObjectKey(1,"S",13)))
</RetrievalCode>
</Data>
<Data name="PopulationPct">
<RetrievalCode> s {PopulationPct}=$g(^oddCOM({L1},"s",{L3},"S",{L5},25),$g(^%qCacheObjectKey(1,"S",25)))
</RetrievalCode>
</Data>
<Data name="PopulationType">
<RetrievalCode> s {PopulationType}=$g(^oddCOM({L1},"s",{L3},"S",{L5},26),$g(^%qCacheObjectKey(1,"S",26)))
</RetrievalCode>
</Data>
<Data name="RowReference">
<RetrievalCode> s {RowReference}=$g(^oddCOM({L1},"s",{L3},"S",{L5},27),$g(^%qCacheObjectKey(1,"S",27)))
</RetrievalCode>
</Data>
<Data name="Structure">
<RetrievalCode> s {Structure}=$g(^oddCOM({L1},"s",{L3},"S",{L5},28),$g(^%qCacheObjectKey(1,"S",28)))
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$g(^oddCOM({L1},"s",{L3},"S",{L5},5),$g(^%qCacheObjectKey(1,"S",5)))
</RetrievalCode>
</Data>
<Data name="_Global">
<RetrievalCode> s {_Global}=$g(^oddCOM({L1},"s",{L3},"S",{L5},24),$g(^%qCacheObjectKey(1,"S",24)))
</RetrievalCode>
</Data>
<Global>^oddCOM</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.CompiledClass.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"s"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.CompiledStorage.Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.CompiledStorageSQLMap.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledStoE089S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
