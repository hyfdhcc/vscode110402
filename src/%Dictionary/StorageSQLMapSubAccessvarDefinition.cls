Class %Dictionary.StorageSQLMapSubAccessvarDefinition Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.StorageSQLMapSubDefinition [ Cardinality = parent, Inverse = Accessvars ];

/// Code
Property Code As %CacheString;

/// Name
Property Name As %Integer [ Required ];

/// Variable
Property Variable As %CacheString;

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
 s i%parent=$$$NormalizeClassname($p(name,":",1))_"||"_$p(name,":",2)_"||"_$p(name,":",3)_"||"_$p(name,":",4)
 s i%Name=$p(name,":",5)
 q $$$OK
}

ClassMethod %LockId(id As %String, shared As %Boolean = 0, timeout As %Integer) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 QUIT $$LockClassRef^%occLock(name1,shared,.timeout)
}

ClassMethod %UnlockId(id As %String, shared As %Boolean = 0, immediate As %Boolean = 0) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 QUIT $$UnlockClassRef^%occLock(name1,shared,immediate)
}

ClassMethod %Exists(oid As %ObjectIdentity) As %Boolean
{
 s $zt="TrapExists"
 s id=$$$oidPrimary(oid) QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 i (name1="")||(name2="")||(name3="")||(name4="")||(name5="") QUIT 0
 i '$$$defClassDefined(name1)||($$$defClassKeyGet(name1,$$$cCLASSdeployed)=2) QUIT 0
 i $$$defStorageSubSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5) QUIT 1
 QUIT 0
TrapExists s $zt=""
 QUIT 0
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 s sc=$$$OK
 s $zt="trap"
 i ..%Concurrency>0 s sc=..%LockId(id,..%Concurrency'=4) If $$$ISERR(sc) Quit sc
 i (name1="")||(name2="")||(name3="")||(name4="")||(name5="")||('$$$defStorageSubSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,4)
 . s i%Name=name5
 . s i%Code=$$$defStorageSubSubSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARcode)
 . s i%Variable=$$$defStorageSubSubSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARvariable)
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
 i i%parent'="",'##class(%Dictionary.StorageSQLMapSubDefinition).%ExistsId(i%parent) q $$$ERROR($$$ReferencedObjectDoesNotExist,"ClassName")
 i 'insert DO
 . i $s(i%parent'=$p(id,"||",1,4):1,i%Name'=$p(id,"||",5):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 . i '($$$defStorageSubSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defStorageSubSubSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,"")
 . i i%Code="" { $$$defStorageSubSubSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARcode) } else { $$$defStorageSubSubSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARcode,i%Code) }
 . i i%Variable="" { $$$defStorageSubSubSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARvariable) } else { $$$defStorageSubSubSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARvariable,i%Variable) }
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,4):1,i%Name'=$p(id,"||",5):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defStorageSubSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.StorageSQLMapSubAccessvarDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defStorageSubSubSubMemberSet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,"")
 . i i%Code="" { $$$defStorageSubSubSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARcode) } else { $$$defStorageSubSubSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARcode,i%Code) }
 . i i%Variable="" { $$$defStorageSubSubSubMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARvariable) } else { $$$defStorageSubSubSubMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5,$$$cSDEFSQLMAPSUBACCESSVARvariable,i%Variable) }
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
 s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3),name4=$p(id,"||",4),name5=$p(id,"||",5)
 If concurrency Set sc=..%LockId(id) If $$$ISERR(sc) Quit sc
 If '$$$GetddlNo30,'($$$defStorageSubSubSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defStorageSubSubSubMemberKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlmap,name3,$$$cSDEFSQLMAPsubscript,name4,$$$cSDEFSQLMAPSUBaccessvar,name5) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Code">
<RetrievalCode> s {Code}=$g(^oddDEF({L1},"s",{L3},"S",{L5},"B",{L7},"A",{L9},21),$g(^%qCacheObjectKey(1,"A",21)))
</RetrievalCode>
</Data>
<Data name="Variable">
<RetrievalCode> s {Variable}=$g(^oddDEF({L1},"s",{L3},"S",{L5},"B",{L7},"A",{L9},22),$g(^%qCacheObjectKey(1,"A",22)))
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
<Subscript name="6">
<Expression>"B"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{%Dictionary.StorageSQLMapSubDefinition.Name}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{%Dictionary.StorageSQLMapSubAccessvarDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.StorageSQLMABF4S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
