Class %Dictionary.StorageDefinition Extends (%Persistent, %Dictionary.StorageDefinitionQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.ClassDefinition [ Cardinality = parent, Inverse = Storages ];

/// Specifies the base location of counters for properties with type is %Library.Counter. Normally this would be a global reference such as ^User.PersonC. The global reference can also include one or more leading subscripts.
Property CounterLocation As %CacheString;

/// Data
Relationship Data As %Dictionary.StorageDataDefinition [ Cardinality = children, Inverse = parent ];

/// Specifies expression that is the location where data is stored for this class. Normally this would be a global reference such as ^User.PersonD. The global reference can also include one or more leading subscripts.
Property DataLocation As %CacheString;

/// Specifies the name of the DATA definition that the Class Compiler Data Structure Generator uses to place any previously unstored properties. A property is unstored if it is storable, but is not listed in any DATA definition. 
Property DefaultData As %CacheString;

/// True if this storage is deprecated.
Property Deprecated As %Boolean [ InitialExpression = 0 ];

/// Specifies a description of the storage definition. This description is displayed by the online class reference.
Property Description As %CacheString;

/// ExtentSize
Property ExtentSize As %CacheString;

/// Specifies that the storage definition cannot be modified by subclasses.
Property Final As %Boolean [ InitialExpression = 0 ];

/// IdExpression
Property IdExpression As %CacheString;

/// Specifies the system function used to allocate new id values.
Property IdFunction As %CacheString;

/// Specifies location of the ID Counter.
Property IdLocation As %CacheString;

/// Index
Relationship Indices As %Dictionary.StorageIndexDefinition [ Cardinality = children, Inverse = parent ];

/// Specifies the global used for indices for this class. If not specified, the index location is ^MyApp.MyClassI, where MyApp.MyClass is the classname. 
Property IndexLocation As %CacheString;

/// If true then do not display this item in automatic documentation.
Property Internal As %Boolean [ InitialExpression = 0 ];

/// Specifies the name of the Storage definition. This name must be a valid class member name and must not conflict with any other class member names.
Property Name As %CacheString [ Required ];

/// Property
Relationship Properties As %Dictionary.StoragePropertyDefinition [ Cardinality = children, Inverse = parent ];

/// SequenceNumber
Property SequenceNumber As %Integer [ InitialExpression = 0 ];

/// SqlChildSub
Property SqlChildSub As %CacheString;

/// SqlIdExpression
Property SqlIdExpression As %CacheString;

/// SQLMap
Relationship SQLMaps As %Dictionary.StorageSQLMapDefinition [ Cardinality = children, Inverse = parent ];

/// Specifies the name of the Row ID column projected to SQL.
Property SqlRowIdName As %CacheString;

/// Specifies the SQL RowId property. This keyword is only used by classes that have been migrated from earlier InterSystems products.
Property SqlRowIdProperty As %CacheString;

/// Specifies the internal SQL Table Number. This keyword is only used by classes that have been migrated from earlier InterSystems products.
Property SqlTableNumber As %CacheString;

/// For a serial embedded class, this keyword specifies which Data definition is used to define the serialized state of the object. This is also the default DATA definition that unstored properties will be added to by the default structure generator.
Property State As %CacheString;

/// Specifies the default global used to store any stream properties within this class. If not specified, the index location is ^MyApp.MyClassS, where MyApp.MyClass is the classname. 
Property StreamLocation As %CacheString;

/// Specifies the Storage Class used to provide persistence for this class.
Property Type As %Dictionary.CacheClassname;

/// Specifies location of the %Version Counter.
Property VersionLocation As %CacheString;

ClassMethod IdFunctionIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="increment" q $$$OK
 i val="sequence" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.StorageDefinition:IdFunction",val)
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
 s i%parent=$$$NormalizeClassname($p(name,":",1))
 s i%Name=$p(name,":",2)
 q $$$OK
}

ClassMethod %LockId(id As %String, shared As %Boolean = 0, timeout As %Integer) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2)
 QUIT $$LockClassRef^%occLock(name1,shared,.timeout)
}

ClassMethod %UnlockId(id As %String, shared As %Boolean = 0, immediate As %Boolean = 0) As %Status
{
 QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2)
 QUIT $$UnlockClassRef^%occLock(name1,shared,immediate)
}

ClassMethod %Exists(oid As %ObjectIdentity) As %Boolean
{
 s $zt="TrapExists"
 s id=$$$oidPrimary(oid) QUIT:id="" $$$ERROR($$$NullId)
 s name1=$p(id,"||",1),name2=$p(id,"||",2)
 i (name1="")||(name2="") QUIT 0
 i '$$$defClassDefined(name1)||($$$defClassKeyGet(name1,$$$cCLASSdeployed)=2) QUIT 0
 i $$$defMemberDefined(name1,$$$cCLASSstorage,name2) QUIT 1
 QUIT 0
TrapExists s $zt=""
 QUIT 0
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 s name1=$p(id,"||",1),name2=$p(id,"||",2)
 s sc=$$$OK
 s $zt="trap"
 i ..%Concurrency>0 s sc=..%LockId(id,..%Concurrency'=4) If $$$ISERR(sc) Quit sc
 i (name1="")||(name2="")||('$$$defMemberDefined(name1,$$$cCLASSstorage,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%CounterLocation=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFcounterlocation)
 . s i%DataLocation=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdatalocation)
 . s i%DefaultData=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdefaultdata)
 . s i%Deprecated=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdeprecated)
 . s i%Description=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFdescription)
 . s i%ExtentSize=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFextentsize)
 . s i%Final=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFfinal)
 . s i%IdExpression=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFidexpression)
 . s i%IdFunction=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFidfunction)
 . s i%IdLocation=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFidlocation)
 . s i%IndexLocation=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFindexlocation)
 . s i%Internal=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFinternal)
 . s i%SequenceNumber=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsequencenumber)
 . s i%SqlChildSub=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlchildsub)
 . s i%SqlIdExpression=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlidexpression)
 . s i%SqlRowIdName=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidname)
 . s i%SqlRowIdProperty=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidproperty)
 . s i%SqlTableNumber=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqltablenumber)
 . s i%State=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFstate)
 . s i%StreamLocation=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFstreamlocation)
 . s i%Type=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFtype)
 . s i%VersionLocation=$$$defMemberKeyGet(name1,$$$cCLASSstorage,name2,$$$cSDEFversionlocation)
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
 i i%parent'="",'##class(%Dictionary.ClassDefinition).%ExistsId(i%parent) q $$$ERROR($$$ReferencedObjectDoesNotExist,"ClassName")
 i 'insert DO
 . i $s(i%parent'=$p(id,"||",1,1):1,i%Name'=$p(id,"||",2):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2)
 . i '($$$defMemberDefined(name1,$$$cCLASSstorage,name2)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defMemberSet(name1,$$$cCLASSstorage,name2,"")
 . i i%CounterLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFcounterlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFcounterlocation,i%CounterLocation) }
 . i i%DataLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdatalocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdatalocation,i%DataLocation) }
 . i i%DefaultData="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdefaultdata) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdefaultdata,i%DefaultData) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdescription,i%Description) }
 . i i%ExtentSize="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFextentsize) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFextentsize,i%ExtentSize) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFfinal,i%Final) }
 . i i%IdExpression="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFidexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFidexpression,i%IdExpression) }
 . i i%IdFunction="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFidfunction) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFidfunction,i%IdFunction) }
 . i i%IdLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFidlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFidlocation,i%IdLocation) }
 . i i%IndexLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFindexlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFindexlocation,i%IndexLocation) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFinternal,i%Internal) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsequencenumber,i%SequenceNumber) }
 . i i%SqlChildSub="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlchildsub) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlchildsub,i%SqlChildSub) }
 . i i%SqlIdExpression="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlidexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlidexpression,i%SqlIdExpression) }
 . i i%SqlRowIdName="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidname) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidname,i%SqlRowIdName) }
 . i i%SqlRowIdProperty="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidproperty) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidproperty,i%SqlRowIdProperty) }
 . i i%SqlTableNumber="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqltablenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqltablenumber,i%SqlTableNumber) }
 . i i%State="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFstate) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFstate,i%State) }
 . i i%StreamLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFstreamlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFstreamlocation,i%StreamLocation) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFtype) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFtype,i%Type) }
 . i i%VersionLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFversionlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFversionlocation,i%VersionLocation) }
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,1):1,i%Name'=$p(id,"||",2):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defMemberDefined(name1,$$$cCLASSstorage,name2) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.StorageDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defMemberSet(name1,$$$cCLASSstorage,name2,"")
 . i i%CounterLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFcounterlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFcounterlocation,i%CounterLocation) }
 . i i%DataLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdatalocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdatalocation,i%DataLocation) }
 . i i%DefaultData="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdefaultdata) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdefaultdata,i%DefaultData) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFdescription,i%Description) }
 . i i%ExtentSize="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFextentsize) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFextentsize,i%ExtentSize) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFfinal,i%Final) }
 . i i%IdExpression="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFidexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFidexpression,i%IdExpression) }
 . i i%IdFunction="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFidfunction) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFidfunction,i%IdFunction) }
 . i i%IdLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFidlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFidlocation,i%IdLocation) }
 . i i%IndexLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFindexlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFindexlocation,i%IndexLocation) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFinternal,i%Internal) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsequencenumber,i%SequenceNumber) }
 . i i%SqlChildSub="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlchildsub) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlchildsub,i%SqlChildSub) }
 . i i%SqlIdExpression="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlidexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlidexpression,i%SqlIdExpression) }
 . i i%SqlRowIdName="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidname) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidname,i%SqlRowIdName) }
 . i i%SqlRowIdProperty="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidproperty) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqlrowidproperty,i%SqlRowIdProperty) }
 . i i%SqlTableNumber="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFsqltablenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFsqltablenumber,i%SqlTableNumber) }
 . i i%State="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFstate) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFstate,i%State) }
 . i i%StreamLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFstreamlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFstreamlocation,i%StreamLocation) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFtype) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFtype,i%Type) }
 . i i%VersionLocation="" { $$$defMemberKeyKill(name1,$$$cCLASSstorage,name2,$$$cSDEFversionlocation) } else { $$$defMemberKeySet(name1,$$$cCLASSstorage,name2,$$$cSDEFversionlocation,i%VersionLocation) }
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
 s name1=$p(id,"||",1),name2=$p(id,"||",2)
 If concurrency Set sc=..%LockId(id) If $$$ISERR(sc) Quit sc
 If '$$$GetddlNo30,'($$$defMemberDefined(name1,$$$cCLASSstorage,name2)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defMemberKill(name1,$$$cCLASSstorage,name2) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="CounterLocation">
<RetrievalCode> s {CounterLocation}=$s($d(^oddDEF({L1},"s",{L3},36))#2:^(36),1:"")
</RetrievalCode>
</Data>
<Data name="DataLocation">
<RetrievalCode> s {DataLocation}=$s($d(^oddDEF({L1},"s",{L3},21))#2:^(21),1:"")
</RetrievalCode>
</Data>
<Data name="DefaultData">
<RetrievalCode> s {DefaultData}=$s($d(^oddDEF({L1},"s",{L3},22))#2:^(22),1:"")
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddDEF({L1},"s",{L3},17))#2:^(17),1:0)
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddDEF({L1},"s",{L3},4))#2:^(4),1:"")
</RetrievalCode>
</Data>
<Data name="ExtentSize">
<RetrievalCode> s {ExtentSize}=$s($d(^oddDEF({L1},"s",{L3},34))#2:^(34),1:"")
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddDEF({L1},"s",{L3},7))#2:^(7),1:0)
</RetrievalCode>
</Data>
<Data name="IdExpression">
<RetrievalCode> s {IdExpression}=$s($d(^oddDEF({L1},"s",{L3},23))#2:^(23),1:"")
</RetrievalCode>
</Data>
<Data name="IdFunction">
<RetrievalCode> s {IdFunction}=$s($d(^oddDEF({L1},"s",{L3},37))#2:^(37),1:"")
</RetrievalCode>
</Data>
<Data name="IdLocation">
<RetrievalCode> s {IdLocation}=$s($d(^oddDEF({L1},"s",{L3},24))#2:^(24),1:"")
</RetrievalCode>
</Data>
<Data name="IndexLocation">
<RetrievalCode> s {IndexLocation}=$s($d(^oddDEF({L1},"s",{L3},25))#2:^(25),1:"")
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddDEF({L1},"s",{L3},14))#2:^(14),1:0)
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddDEF({L1},"s",{L3},11))#2:^(11),1:0)
</RetrievalCode>
</Data>
<Data name="SqlChildSub">
<RetrievalCode> s {SqlChildSub}=$s($d(^oddDEF({L1},"s",{L3},27))#2:^(27),1:"")
</RetrievalCode>
</Data>
<Data name="SqlIdExpression">
<RetrievalCode> s {SqlIdExpression}=$s($d(^oddDEF({L1},"s",{L3},28))#2:^(28),1:"")
</RetrievalCode>
</Data>
<Data name="SqlRowIdName">
<RetrievalCode> s {SqlRowIdName}=$s($d(^oddDEF({L1},"s",{L3},29))#2:^(29),1:"")
</RetrievalCode>
</Data>
<Data name="SqlRowIdProperty">
<RetrievalCode> s {SqlRowIdProperty}=$s($d(^oddDEF({L1},"s",{L3},30))#2:^(30),1:"")
</RetrievalCode>
</Data>
<Data name="SqlTableNumber">
<RetrievalCode> s {SqlTableNumber}=$s($d(^oddDEF({L1},"s",{L3},31))#2:^(31),1:"")
</RetrievalCode>
</Data>
<Data name="State">
<RetrievalCode> s {State}=$s($d(^oddDEF({L1},"s",{L3},32))#2:^(32),1:"")
</RetrievalCode>
</Data>
<Data name="StreamLocation">
<RetrievalCode> s {StreamLocation}=$s($d(^oddDEF({L1},"s",{L3},33))#2:^(33),1:"")
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddDEF({L1},"s",{L3},5))#2:^(5),1:"")
</RetrievalCode>
</Data>
<Data name="VersionLocation">
<RetrievalCode> s {VersionLocation}=$s($d(^oddDEF({L1},"s",{L3},35))#2:^(35),1:"")
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
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.StorageDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
