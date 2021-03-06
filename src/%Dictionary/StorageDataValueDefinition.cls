Class %Dictionary.StorageDataValueDefinition Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.StorageDataDefinition [ Cardinality = parent, Inverse = Values ];

/// Specifies the name of the StorageDataValue. This name must be a valid storage member name and must not conflict with any other StorageDataValue names.
Property Name As %Integer [ Required ];

/// Value
Property Value As %CacheString;

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
 s i%parent=$$$NormalizeClassname($p(name,":",1))_"||"_$p(name,":",2)_"||"_$p(name,":",3)
 s i%Name=$p(name,":",4)
 q $$$OK
}

ClassMethod %LockId(id As %String, shared As %Boolean = 0, timeout As %Integer) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 QUIT $$LockClassRef^%occLock(name1,shared,.timeout)
}

ClassMethod %UnlockId(id As %String, shared As %Boolean = 0, immediate As %Boolean = 0) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 QUIT $$UnlockClassRef^%occLock(name1,shared,immediate)
}

ClassMethod %Exists(oid As %ObjectIdentity) As %Boolean
{
 s $zt="TrapExists"
 s id=$$$oidPrimary(oid) QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 i (name1="")||(name2="")||(name3="")||(name4="") QUIT 0
 i '$$$defClassDefined(name1)||($$$defClassKeyGet(name1,$$$cCLASSdeployed)=2) QUIT 0
 i $$$defStorageSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4) QUIT 1
 QUIT 0
TrapExists s $zt=""
 QUIT 0
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 s sc=$$$OK
 s $zt="trap"
 i ..%Concurrency>0 s sc=..%LockId(id,..%Concurrency'=4) If $$$ISERR(sc) Quit sc
 i (name1="")||(name2="")||(name3="")||(name4="")||('$$$defStorageSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,3)
 . s i%Name=name4
 . s i%Value=$$$defStorageSubSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,$$$cSDEFDATAVALvalue)
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
 i i%parent'="",'##class(%Dictionary.StorageDataDefinition).%ExistsId(i%parent) q $$$ERROR($$$ReferencedObjectDoesNotExist,"ClassName")
 i 'insert DO
 . i $s(i%parent'=$p(id,"||",1,3):1,i%Name'=$p(id,"||",4):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 . i '($$$defStorageSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defStorageSubSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,"")
 . i i%Value="" { $$$defStorageSubSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,$$$cSDEFDATAVALvalue) } else { $$$defStorageSubSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,$$$cSDEFDATAVALvalue,i%Value) }
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,3):1,i%Name'=$p(id,"||",4):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defStorageSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.StorageDataValueDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defStorageSubSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,"")
 . i i%Value="" { $$$defStorageSubSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,$$$cSDEFDATAVALvalue) } else { $$$defStorageSubSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4,$$$cSDEFDATAVALvalue,i%Value) }
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
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4)
 If concurrency Set sc=..%LockId(id) If $$$ISERR(sc) Quit sc
 If '$$$GetddlNo30,'($$$defStorageSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defStorageSubSubMemberKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAvalue,name4) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Value">
<RetrievalCode> s {Value}=$g(^oddDEF({L1},"s",{L3},"D",{L5},"V",{L7},21),$g(^%qCacheObjectKey(1,"V",21)))
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
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.StorageDataDefinition.Name}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"V"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{%Dictionary.StorageDataValueDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.StorageData71C3S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
