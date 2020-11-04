Class %Dictionary.CompiledStorageData Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledStorage [ Cardinality = parent, Inverse = Data ];

/// Attribute
Property Attribute As %CacheString;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Specifies the name of the StorageData definition. This name must be a valid storage member name and must not conflict with any other StorageData names.
Property Name As %CacheString [ Required ];

/// Specifies how the data is stored into a global node.
Property Structure As %CacheString;

/// Subscript
Property Subscript As %CacheString;

/// Value
Relationship Values As %Dictionary.CompiledStorageDataValue [ Cardinality = children, Inverse = parent ];

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
 i $$$comStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3) QUIT 1
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
 i (name1="")||(name2="")||(name3="")||('$$$comStorageSubMemberDefined(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%Attribute=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAattribute)
 . s i%KeywordError=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAkeyworderror)
 . s i%KeywordModified=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAkeywordmodified)
 . s i%Structure=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAstructure)
 . s i%Subscript=$$$comStorageSubMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdata,name3,$$$cSDEFDATAsubscript)
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
<Data name="Attribute">
<RetrievalCode> s {Attribute}=$g(^oddCOM({L1},"s",{L3},"D",{L5},21),$g(^%qCacheObjectKey(1,"D",21)))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$g(^oddCOM({L1},"s",{L3},"D",{L5},12),$g(^%qCacheObjectKey(1,"D",12)))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$g(^oddCOM({L1},"s",{L3},"D",{L5},13),$g(^%qCacheObjectKey(1,"D",13)))
</RetrievalCode>
</Data>
<Data name="Structure">
<RetrievalCode> s {Structure}=$g(^oddCOM({L1},"s",{L3},"D",{L5},22),$g(^%qCacheObjectKey(1,"D",22)))
</RetrievalCode>
</Data>
<Data name="Subscript">
<RetrievalCode> s {Subscript}=$g(^oddCOM({L1},"s",{L3},"D",{L5},23),$g(^%qCacheObjectKey(1,"D",23)))
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
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.CompiledStorageData.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledStoE869S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
