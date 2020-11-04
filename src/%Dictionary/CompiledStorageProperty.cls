Class %Dictionary.CompiledStorageProperty Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledStorage [ Cardinality = parent, Inverse = Properties ];

/// AverageFieldSize
Property AverageFieldSize As %CacheString;

/// BiasQueriesAsOutlier
Property BiasQueriesAsOutlier As %CacheString;

/// ChildBlockCount
Property ChildBlockCount As %CacheString;

/// ChildExtentSize
Property ChildExtentSize As %CacheString;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Name
Property Name As %CacheString [ Required ];

/// OutlierSelectivity
Property OutlierSelectivity As %CacheString;

/// Selectivity
Property Selectivity As %CacheString;

/// StreamLocation
Property StreamLocation As %CacheString;

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
 i $$$comStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3) QUIT 1
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
 i (name1="")||(name2="")||(name3="")||('$$$comStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%AverageFieldSize=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYaveragefieldsize)
 . s i%BiasQueriesAsOutlier=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYbiasqueriesasoutlier)
 . s i%ChildBlockCount=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildblockcount)
 . s i%ChildExtentSize=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildextentsize)
 . s i%KeywordError=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYkeyworderror)
 . s i%KeywordModified=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYkeywordmodified)
 . s i%OutlierSelectivity=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYoutlierselectivity)
 . s i%Selectivity=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYselectivity)
 . s i%StreamLocation=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYstreamlocation)
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
<Data name="AverageFieldSize">
<RetrievalCode> s {AverageFieldSize}=$g(^oddCOM({L1},"s",{L3},"M",{L5},26),$g(^%qCacheObjectKey(1,"M",26)))
</RetrievalCode>
</Data>
<Data name="BiasQueriesAsOutlier">
<RetrievalCode> s {BiasQueriesAsOutlier}=$g(^oddCOM({L1},"s",{L3},"M",{L5},25),$g(^%qCacheObjectKey(1,"M",25)))
</RetrievalCode>
</Data>
<Data name="ChildBlockCount">
<RetrievalCode> s {ChildBlockCount}=$g(^oddCOM({L1},"s",{L3},"M",{L5},27),$g(^%qCacheObjectKey(1,"M",27)))
</RetrievalCode>
</Data>
<Data name="ChildExtentSize">
<RetrievalCode> s {ChildExtentSize}=$g(^oddCOM({L1},"s",{L3},"M",{L5},23),$g(^%qCacheObjectKey(1,"M",23)))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$g(^oddCOM({L1},"s",{L3},"M",{L5},12),$g(^%qCacheObjectKey(1,"M",12)))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$g(^oddCOM({L1},"s",{L3},"M",{L5},13),$g(^%qCacheObjectKey(1,"M",13)))
</RetrievalCode>
</Data>
<Data name="OutlierSelectivity">
<RetrievalCode> s {OutlierSelectivity}=$g(^oddCOM({L1},"s",{L3},"M",{L5},24),$g(^%qCacheObjectKey(1,"M",24)))
</RetrievalCode>
</Data>
<Data name="Selectivity">
<RetrievalCode> s {Selectivity}=$g(^oddCOM({L1},"s",{L3},"M",{L5},21),$g(^%qCacheObjectKey(1,"M",21)))
</RetrievalCode>
</Data>
<Data name="StreamLocation">
<RetrievalCode> s {StreamLocation}=$g(^oddCOM({L1},"s",{L3},"M",{L5},22),$g(^%qCacheObjectKey(1,"M",22)))
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
<Expression>"M"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.CompiledStorageProperty.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledSto4B18S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
