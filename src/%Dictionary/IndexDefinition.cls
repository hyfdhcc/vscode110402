Class %Dictionary.IndexDefinition Extends (%Persistent, %Dictionary.IndexDefinitionQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.ClassDefinition [ Cardinality = parent, Inverse = Indices ];

/// In the case of a conditional index, specifies the condition that must be met for an entry to be included in the index.
Property Condition As %CacheString;

/// Specifies a list of properties whose values are to be stored within this index.
Property Data As %CacheString;

/// True if this index is deprecated.
Property Deprecated As %Boolean [ InitialExpression = 0 ];

/// Specifies a description of the index.
Property Description As %CacheString;

/// An extent index is used to keep track of which object instances belong to a subclass. When using bitmap indices, then an extent index is automatically maintained and there is no need to define one.
Property Extent As %Boolean [ ClientName = _Extent, InitialExpression = 0 ];

/// Specifies that the property or properties defined for this index will be used to form the Object Identity value for this object. This value is used to uniquely locate persistent object instances. 
Property IdKey As %Boolean [ InitialExpression = 0 ];

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean [ InitialExpression = 0 ];

/// The name of the index.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Parameter
Property Parameters As array Of %CacheString;

/// Specifies that this index should be reported, via SQL, as being the Primary Key for this class. 
Property PrimaryKey As %Boolean [ InitialExpression = 0 ];

/// Specifies a list of properties used to build this index. May also include a collation specification for each property.
Property Properties As %CacheString;

/// SequenceNumber
Property SequenceNumber As %Integer [ InitialExpression = 0 ];

/// Defines an alternate name for this index when referred to via SQL.
Property SqlName As %CacheString;

/// Specifies the type of the index. Type &#39;key&#39; is deprecated.
Property Type As %CacheString;

/// Specifies the FunctionalIndex class used to provide the implementation of the functional index interface.
Property TypeClass As %Dictionary.CacheClassname;

/// Specifies whether this is a unique index.  The property or properties indexed by a unique index are constrained to have unique values.  This means that no two instances can have the same collated value within the extent among the set of all objects of the class that defines the index.
Property Unique As %Boolean [ InitialExpression = 0, SqlFieldName = _Unique ];

ClassMethod TypeIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="bitmap" q $$$OK
 i val="bitslice" q $$$OK
 i val="index" q $$$OK
 i val="collatedkey" q $$$OK
 i val="key" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.IndexDefinition:Type",val)
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
 i $$$defMemberDefined(name1,$$$cCLASSindex,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$defMemberDefined(name1,$$$cCLASSindex,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Condition=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXcondition)
 . s i%Data=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXdata)
 . s i%Deprecated=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXdeprecated)
 . s i%Description=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXdescription)
 . s i%Extent=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXextent)
 . s i%IdKey=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXidkey)
 . s i%Internal=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXinternal)
 . s i%PrimaryKey=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXprimarykey)
 . s i%Properties=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXproperties)
 . s i%SequenceNumber=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXsequencenumber)
 . s i%SqlName=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXsqlname)
 . s i%Type=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXtype)
 . s i%TypeClass=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXtypeclass)
 . s i%Unique=$$$defMemberKeyGet(name1,$$$cCLASSindex,name2,$$$cINDEXunique)
 . s sub="" f  s sub=$$$defSubMemberNext(name1,$$$cCLASSindex,name2,$$$cINDEXparameter,sub) q:sub=""  d
 . . d ..Parameters.SetAt($$$defMemberArrayGet(name1,$$$cCLASSindex,name2,$$$cINDEXparameter,sub),sub)
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
 . i '($$$defMemberDefined(name1,$$$cCLASSindex,name2)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defMemberSet(name1,$$$cCLASSindex,name2,"")
 . i i%Condition="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXcondition) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXcondition,i%Condition) }
 . i i%Data="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXdata) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXdata,i%Data) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXdescription,i%Description) }
 . i i%Extent=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXextent) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXextent,i%Extent) }
 . i i%IdKey=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXidkey) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXidkey,i%IdKey) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXinternal,i%Internal) }
 . i i%PrimaryKey=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXprimarykey) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXprimarykey,i%PrimaryKey) }
 . i i%Properties="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXproperties) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXproperties,i%Properties) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXsequencenumber,i%SequenceNumber) }
 . i i%SqlName="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXsqlname) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXsqlname,i%SqlName) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXtype) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXtype,i%Type) }
 . i i%TypeClass="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXtypeclass) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXtypeclass,i%TypeClass) }
 . i i%Unique=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXunique) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXunique,i%Unique) }
 . $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXparameter)
 . s sub="" f  s sub=..Parameters.Next(sub) q:sub=""  d
 . . $$$defSubMemberSet(name1,$$$cCLASSindex,name2,$$$cINDEXparameter,sub,..Parameters.GetAt(sub))
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,1):1,i%Name'=$p(id,"||",2):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defMemberDefined(name1,$$$cCLASSindex,name2) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.IndexDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defMemberSet(name1,$$$cCLASSindex,name2,"")
 . i i%Condition="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXcondition) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXcondition,i%Condition) }
 . i i%Data="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXdata) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXdata,i%Data) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXdescription,i%Description) }
 . i i%Extent=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXextent) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXextent,i%Extent) }
 . i i%IdKey=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXidkey) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXidkey,i%IdKey) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXinternal,i%Internal) }
 . i i%PrimaryKey=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXprimarykey) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXprimarykey,i%PrimaryKey) }
 . i i%Properties="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXproperties) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXproperties,i%Properties) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXsequencenumber,i%SequenceNumber) }
 . i i%SqlName="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXsqlname) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXsqlname,i%SqlName) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXtype) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXtype,i%Type) }
 . i i%TypeClass="" { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXtypeclass) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXtypeclass,i%TypeClass) }
 . i i%Unique=0 { $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXunique) } else { $$$defMemberKeySet(name1,$$$cCLASSindex,name2,$$$cINDEXunique,i%Unique) }
 . $$$defMemberKeyKill(name1,$$$cCLASSindex,name2,$$$cINDEXparameter)
 . s sub="" f  s sub=..Parameters.Next(sub) q:sub=""  d
 . . $$$defSubMemberSet(name1,$$$cCLASSindex,name2,$$$cINDEXparameter,sub,..Parameters.GetAt(sub))
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
 If '$$$GetddlNo30,'($$$defMemberDefined(name1,$$$cCLASSindex,name2)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defMemberKill(name1,$$$cCLASSindex,name2) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Condition">
<RetrievalCode> s {Condition}=$s($d(^oddDEF({L1},"i",{L3},23))#2:^(23),1:"")
</RetrievalCode>
</Data>
<Data name="Data">
<RetrievalCode> s {Data}=$s($d(^oddDEF({L1},"i",{L3},24))#2:^(24),1:"")
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddDEF({L1},"i",{L3},17))#2:^(17),1:0)
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddDEF({L1},"i",{L3},4))#2:^(4),1:"")
</RetrievalCode>
</Data>
<Data name="Extent">
<RetrievalCode> s {Extent}=$s($d(^oddDEF({L1},"i",{L3},25))#2:^(25),1:0)
</RetrievalCode>
</Data>
<Data name="IdKey">
<RetrievalCode> s {IdKey}=$s($d(^oddDEF({L1},"i",{L3},26))#2:^(26),1:0)
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddDEF({L1},"i",{L3},14))#2:^(14),1:0)
</RetrievalCode>
</Data>
<Data name="Parameters">
<RetrievalCode> n sub s {Parameters}="",sub="" f  s sub=$o(^oddDEF({L1},"i",{L3},"P",sub)) q:sub=""  s {Parameters}={Parameters}_$lb($lb(sub,$g(^oddDEF({L1},"i",{L3},"P",sub))))
</RetrievalCode>
</Data>
<Data name="PrimaryKey">
<RetrievalCode> s {PrimaryKey}=$s($d(^oddDEF({L1},"i",{L3},27))#2:^(27),1:0)
</RetrievalCode>
</Data>
<Data name="Properties">
<RetrievalCode> s {Properties}=$s($d(^oddDEF({L1},"i",{L3},28))#2:^(28),1:"")
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddDEF({L1},"i",{L3},11))#2:^(11),1:0)
</RetrievalCode>
</Data>
<Data name="SqlName">
<RetrievalCode> s {SqlName}=$s($d(^oddDEF({L1},"i",{L3},29))#2:^(29),1:"")
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddDEF({L1},"i",{L3},5))#2:^(5),1:"")
</RetrievalCode>
</Data>
<Data name="TypeClass">
<RetrievalCode> s {TypeClass}=$s($d(^oddDEF({L1},"i",{L3},33))#2:^(33),1:"")
</RetrievalCode>
</Data>
<Data name="_Unique">
<RetrievalCode> s {_Unique}=$s($d(^oddDEF({L1},"i",{L3},31))#2:^(31),1:0)
</RetrievalCode>
</Data>
<Global>^oddDEF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.ClassDefinition.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"i"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.IndexDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.IndexDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
