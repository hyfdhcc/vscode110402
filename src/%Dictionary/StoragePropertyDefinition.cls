Class %Dictionary.StoragePropertyDefinition Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.StorageDefinition [ Cardinality = parent, Inverse = Properties ];

/// AverageFieldSize
Property AverageFieldSize As %CacheString;

/// BiasQueriesAsOutlier
Property BiasQueriesAsOutlier As %CacheString;

/// ChildBlockCount
Property ChildBlockCount As %CacheString;

/// ChildExtentSize
Property ChildExtentSize As %CacheString;

/// Name
Property Name As %CacheString [ Required ];

/// OutlierSelectivity
Property OutlierSelectivity As %CacheString;

/// Selectivity
Property Selectivity As %CacheString;

/// StreamLocation
Property StreamLocation As %CacheString;

ClassMethod BiasQueriesAsOutlierIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="0" q $$$OK
 i val="1" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.StoragePropertyDefinition:BiasQueriesAsOutlier",val)
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
 i $$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3) QUIT 1
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
 i (name1="")||(name2="")||(name3="")||('$$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%AverageFieldSize=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYaveragefieldsize)
 . s i%BiasQueriesAsOutlier=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYbiasqueriesasoutlier)
 . s i%ChildBlockCount=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildblockcount)
 . s i%ChildExtentSize=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildextentsize)
 . s i%OutlierSelectivity=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYoutlierselectivity)
 . s i%Selectivity=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYselectivity)
 . s i%StreamLocation=$$$defStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYstreamlocation)
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
 . i '($$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defStorageSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,"")
 . i i%AverageFieldSize="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYaveragefieldsize) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYaveragefieldsize,i%AverageFieldSize) }
 . i i%BiasQueriesAsOutlier="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYbiasqueriesasoutlier) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYbiasqueriesasoutlier,i%BiasQueriesAsOutlier) }
 . i i%ChildBlockCount="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildblockcount) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildblockcount,i%ChildBlockCount) }
 . i i%ChildExtentSize="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildextentsize) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildextentsize,i%ChildExtentSize) }
 . i i%OutlierSelectivity="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYoutlierselectivity) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYoutlierselectivity,i%OutlierSelectivity) }
 . i i%Selectivity="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYselectivity) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYselectivity,i%Selectivity) }
 . i i%StreamLocation="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYstreamlocation) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYstreamlocation,i%StreamLocation) }
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,2):1,i%Name'=$p(id,"||",3):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.StoragePropertyDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defStorageSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,"")
 . i i%AverageFieldSize="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYaveragefieldsize) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYaveragefieldsize,i%AverageFieldSize) }
 . i i%BiasQueriesAsOutlier="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYbiasqueriesasoutlier) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYbiasqueriesasoutlier,i%BiasQueriesAsOutlier) }
 . i i%ChildBlockCount="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildblockcount) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildblockcount,i%ChildBlockCount) }
 . i i%ChildExtentSize="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildextentsize) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYchildextentsize,i%ChildExtentSize) }
 . i i%OutlierSelectivity="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYoutlierselectivity) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYoutlierselectivity,i%OutlierSelectivity) }
 . i i%Selectivity="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYselectivity) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYselectivity,i%Selectivity) }
 . i i%StreamLocation="" { $$$defStorageSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYstreamlocation) } else { $$$defStorageSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3,$$$cSTORAGEPROPERTYstreamlocation,i%StreamLocation) }
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
 If '$$$GetddlNo30,'($$$defStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defStorageSubMemberKill(name1,$$$cCLASSstorage,name2,$$$cSDEFproperty,name3) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="AverageFieldSize">
<RetrievalCode> s {AverageFieldSize}=$g(^oddDEF({L1},"s",{L3},"M",{L5},26),$g(^%qCacheObjectKey(1,"M",26)))
</RetrievalCode>
</Data>
<Data name="BiasQueriesAsOutlier">
<RetrievalCode> s {BiasQueriesAsOutlier}=$g(^oddDEF({L1},"s",{L3},"M",{L5},25),$g(^%qCacheObjectKey(1,"M",25)))
</RetrievalCode>
</Data>
<Data name="ChildBlockCount">
<RetrievalCode> s {ChildBlockCount}=$g(^oddDEF({L1},"s",{L3},"M",{L5},27),$g(^%qCacheObjectKey(1,"M",27)))
</RetrievalCode>
</Data>
<Data name="ChildExtentSize">
<RetrievalCode> s {ChildExtentSize}=$g(^oddDEF({L1},"s",{L3},"M",{L5},23),$g(^%qCacheObjectKey(1,"M",23)))
</RetrievalCode>
</Data>
<Data name="OutlierSelectivity">
<RetrievalCode> s {OutlierSelectivity}=$g(^oddDEF({L1},"s",{L3},"M",{L5},24),$g(^%qCacheObjectKey(1,"M",24)))
</RetrievalCode>
</Data>
<Data name="Selectivity">
<RetrievalCode> s {Selectivity}=$g(^oddDEF({L1},"s",{L3},"M",{L5},21),$g(^%qCacheObjectKey(1,"M",21)))
</RetrievalCode>
</Data>
<Data name="StreamLocation">
<RetrievalCode> s {StreamLocation}=$g(^oddDEF({L1},"s",{L3},"M",{L5},22),$g(^%qCacheObjectKey(1,"M",22)))
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
<Expression>"M"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.StoragePropertyDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.StoragePropB37CS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
