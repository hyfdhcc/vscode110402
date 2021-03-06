Class %Dictionary.CompiledIndex Extends (%Persistent, %Dictionary.CompiledIndexQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledClass [ Cardinality = parent, Inverse = Indices ];

/// BuildPurge
Property BuildPurge As %Boolean;

/// CompilationSignature
Property CompilationSignature As %CacheString;

/// CompilerGenerated
Property CompilerGenerated As %Boolean;

/// In the case of a conditional index, specifies the condition that must be met for an entry to be included in the index.
Property Condition As %CacheString;

/// Specifies a list of properties whose values are to be stored within this index.
Property Data As %CacheString;

/// True if this index is deprecated.
Property Deprecated As %Boolean;

/// Specifies a description of the index.
Property Description As %CacheString;

/// An extent index is used to keep track of which object instances belong to a subclass. When using bitmap indices, then an extent index is automatically maintained and there is no need to define one.
Property Extent As %Boolean [ ClientName = _Extent ];

/// Final
Property Final As %Boolean;

/// Id
Property Id As %Integer;

/// Specifies that the property or properties defined for this index will be used to form the Object Identity value for this object. This value is used to uniquely locate persistent object instances. 
Property IdKey As %Boolean;

/// InheritedId
Property InheritedId As %Boolean;

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Method
Relationship Methods As %Dictionary.CompiledIndexMethod [ Cardinality = children, Inverse = parent ];

/// The name of the index.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// NotInheritable
Property NotInheritable As %Boolean;

/// Origin
Property Origin As %CacheString;

/// Parameter
Property Parameters As array Of %CacheString;

/// PosInt
Property PosInt As %Boolean;

/// Specifies that this index should be reported, via SQL, as being the Primary Key for this class. 
Property PrimaryKey As %Boolean;

/// Specifies a list of properties used to build this index. May also include a collation specification for each property.
Property Properties As %CacheString;

/// Property
Relationship PropertyCollection As %Dictionary.CompiledIndexProperty [ Cardinality = children, Inverse = parent ];

/// SequenceNumber
Property SequenceNumber As %Integer;

/// Defines an alternate name for this index when referred to via SQL.
Property SqlName As %CacheString;

/// SystemAssigned
Property SystemAssigned As %Boolean;

/// Specifies the type of the index. Type &#39;key&#39; is deprecated.
Property Type As %CacheString;

/// Specifies the FunctionalIndex class used to provide the implementation of the functional index interface.
Property TypeClass As %Dictionary.CacheClassname;

/// Specifies whether this is a unique index.  The property or properties indexed by a unique index are constrained to have unique values.  This means that no two instances can have the same collated value within the extent among the set of all objects of the class that defines the index.
Property Unique As %Boolean [ SqlFieldName = _Unique ];

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
 i $$$comMemberDefined(name1,$$$cCLASSindex,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$comMemberDefined(name1,$$$cCLASSindex,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%BuildPurge=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXbuildpurge)
 . s i%CompilationSignature=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXcompilationsignature)
 . s i%CompilerGenerated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXcompilergenerated)
 . s i%Condition=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXcondition)
 . s i%Data=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXdata)
 . s i%Deprecated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXdeprecated)
 . s i%Description=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXdescription)
 . s i%Extent=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXextent)
 . s i%Final=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXfinal)
 . s i%Id=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXid)
 . s i%IdKey=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXidkey)
 . s i%InheritedId=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXinheritedid)
 . s i%Internal=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXinternal)
 . s i%KeywordError=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXkeyworderror)
 . s i%KeywordModified=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXkeywordmodified)
 . s i%NotInheritable=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXnotinheritable)
 . s i%Origin=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXorigin)
 . s i%PosInt=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXposint)
 . s i%PrimaryKey=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXprimarykey)
 . s i%Properties=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXproperties)
 . s i%SequenceNumber=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXsequencenumber)
 . s i%SqlName=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXsqlname)
 . s i%SystemAssigned=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXsystemassigned)
 . s i%Type=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXtype)
 . s i%TypeClass=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXtypeclass)
 . s i%Unique=$$$comMemberKeyGetO(origin,name1,$$$cCLASSindex,name2,$$$cINDEXunique)
 . s sub="" f  s sub=$$$comSubMemberNext(name1,$$$cCLASSindex,name2,$$$cINDEXparameter,sub) q:sub=""  d
 . . d ..Parameters.SetAt($$$comMemberArrayGet(name1,$$$cCLASSindex,name2,$$$cINDEXparameter,sub),sub)
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
<Data name="BuildPurge">
<RetrievalCode> s {BuildPurge}=$s($d(^oddCOM({L1},"i",{L3},21))#2:^(21),$d(^oddCOM($g(^(2),{L1}),"i",{L3},21))#2:^(21),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},21))#2:^(21),1:0))
</RetrievalCode>
</Data>
<Data name="CompilationSignature">
<RetrievalCode> s {CompilationSignature}=$s($d(^oddCOM({L1},"i",{L3},22))#2:^(22),$d(^oddCOM($g(^(2),{L1}),"i",{L3},22))#2:^(22),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},22))#2:^(22),1:""))
</RetrievalCode>
</Data>
<Data name="CompilerGenerated">
<RetrievalCode> s {CompilerGenerated}=$s($d(^oddCOM({L1},"i",{L3},10))#2:^(10),$d(^oddCOM($g(^(2),{L1}),"i",{L3},10))#2:^(10),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},10))#2:^(10),1:0))
</RetrievalCode>
</Data>
<Data name="Condition">
<RetrievalCode> s {Condition}=$s($d(^oddCOM({L1},"i",{L3},23))#2:^(23),$d(^oddCOM($g(^(2),{L1}),"i",{L3},23))#2:^(23),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},23))#2:^(23),1:""))
</RetrievalCode>
</Data>
<Data name="Data">
<RetrievalCode> s {Data}=$s($d(^oddCOM({L1},"i",{L3},24))#2:^(24),$d(^oddCOM($g(^(2),{L1}),"i",{L3},24))#2:^(24),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},24))#2:^(24),1:""))
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddCOM({L1},"i",{L3},17))#2:^(17),$d(^oddCOM($g(^(2),{L1}),"i",{L3},17))#2:^(17),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},17))#2:^(17),1:0))
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddCOM({L1},"i",{L3},4))#2:^(4),$d(^oddCOM($g(^(2),{L1}),"i",{L3},4))#2:^(4),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},4))#2:^(4),1:""))
</RetrievalCode>
</Data>
<Data name="Extent">
<RetrievalCode> s {Extent}=$s($d(^oddCOM({L1},"i",{L3},25))#2:^(25),$d(^oddCOM($g(^(2),{L1}),"i",{L3},25))#2:^(25),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},25))#2:^(25),1:0))
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddCOM({L1},"i",{L3},7))#2:^(7),$d(^oddCOM($g(^(2),{L1}),"i",{L3},7))#2:^(7),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},7))#2:^(7),1:1))
</RetrievalCode>
</Data>
<Data name="Id">
<RetrievalCode> s {Id}=$s($d(^oddCOM({L1},"i",{L3},6))#2:^(6),$d(^oddCOM($g(^(2),{L1}),"i",{L3},6))#2:^(6),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},6))#2:^(6),1:0))
</RetrievalCode>
</Data>
<Data name="IdKey">
<RetrievalCode> s {IdKey}=$s($d(^oddCOM({L1},"i",{L3},26))#2:^(26),$d(^oddCOM($g(^(2),{L1}),"i",{L3},26))#2:^(26),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},26))#2:^(26),1:0))
</RetrievalCode>
</Data>
<Data name="InheritedId">
<RetrievalCode> s {InheritedId}=$s($d(^oddCOM({L1},"i",{L3},8))#2:^(8),$d(^oddCOM($g(^(2),{L1}),"i",{L3},8))#2:^(8),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},8))#2:^(8),1:0))
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddCOM({L1},"i",{L3},14))#2:^(14),$d(^oddCOM($g(^(2),{L1}),"i",{L3},14))#2:^(14),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},14))#2:^(14),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$s($d(^oddCOM({L1},"i",{L3},12))#2:^(12),$d(^oddCOM($g(^(2),{L1}),"i",{L3},12))#2:^(12),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},12))#2:^(12),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$s($d(^oddCOM({L1},"i",{L3},13))#2:^(13),$d(^oddCOM($g(^(2),{L1}),"i",{L3},13))#2:^(13),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},13))#2:^(13),1:0))
</RetrievalCode>
</Data>
<Data name="NotInheritable">
<RetrievalCode> s {NotInheritable}=$s($d(^oddCOM({L1},"i",{L3},9))#2:^(9),$d(^oddCOM($g(^(2),{L1}),"i",{L3},9))#2:^(9),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},9))#2:^(9),1:0))
</RetrievalCode>
</Data>
<Data name="Origin">
<RetrievalCode> s {Origin}=$s($d(^oddCOM({L1},"i",{L3},2))#2:^(2),$d(^oddCOM($g(^(2),{L1}),"i",{L3},2))#2:^(2),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},2))#2:^(2),1:""))
</RetrievalCode>
</Data>
<Data name="Parameters">
<RetrievalCode> n sub s {Parameters}="",sub="" f  s sub=$o(^oddCOM({L1},"i",{L3},"P",sub)) q:sub=""  s {Parameters}={Parameters}_$lb($lb(sub,$s($d(^oddCOM({L1},"i",{L3},"P",sub))#2:^(sub),$d(^oddCOM($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},"P",sub))#2:^(sub),1:$g(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},"P",sub)))))
</RetrievalCode>
</Data>
<Data name="PosInt">
<RetrievalCode> s {PosInt}=$s($d(^oddCOM({L1},"i",{L3},32))#2:^(32),$d(^oddCOM($g(^(2),{L1}),"i",{L3},32))#2:^(32),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},32))#2:^(32),1:0))
</RetrievalCode>
</Data>
<Data name="PrimaryKey">
<RetrievalCode> s {PrimaryKey}=$s($d(^oddCOM({L1},"i",{L3},27))#2:^(27),$d(^oddCOM($g(^(2),{L1}),"i",{L3},27))#2:^(27),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},27))#2:^(27),1:0))
</RetrievalCode>
</Data>
<Data name="Properties">
<RetrievalCode> s {Properties}=$s($d(^oddCOM({L1},"i",{L3},28))#2:^(28),$d(^oddCOM($g(^(2),{L1}),"i",{L3},28))#2:^(28),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},28))#2:^(28),1:""))
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddCOM({L1},"i",{L3},11))#2:^(11),$d(^oddCOM($g(^(2),{L1}),"i",{L3},11))#2:^(11),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},11))#2:^(11),1:0))
</RetrievalCode>
</Data>
<Data name="SqlName">
<RetrievalCode> s {SqlName}=$s($d(^oddCOM({L1},"i",{L3},29))#2:^(29),$d(^oddCOM($g(^(2),{L1}),"i",{L3},29))#2:^(29),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},29))#2:^(29),1:""))
</RetrievalCode>
</Data>
<Data name="SystemAssigned">
<RetrievalCode> s {SystemAssigned}=$s($d(^oddCOM({L1},"i",{L3},30))#2:^(30),$d(^oddCOM($g(^(2),{L1}),"i",{L3},30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},30))#2:^(30),1:0))
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddCOM({L1},"i",{L3},5))#2:^(5),$d(^oddCOM($g(^(2),{L1}),"i",{L3},5))#2:^(5),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},5))#2:^(5),1:""))
</RetrievalCode>
</Data>
<Data name="TypeClass">
<RetrievalCode> s {TypeClass}=$s($d(^oddCOM({L1},"i",{L3},33))#2:^(33),$d(^oddCOM($g(^(2),{L1}),"i",{L3},33))#2:^(33),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},33))#2:^(33),1:""))
</RetrievalCode>
</Data>
<Data name="_Unique">
<RetrievalCode> s {_Unique}=$s($d(^oddCOM({L1},"i",{L3},31))#2:^(31),$d(^oddCOM($g(^(2),{L1}),"i",{L3},31))#2:^(31),1:$s($d(^oddDEF($g(^oddCOM({L1},"i",{L3},2),{L1}),"i",{L3},31))#2:^(31),1:0))
</RetrievalCode>
</Data>
<Global>^oddCOM</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.CompiledClass.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"i"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.CompiledIndex.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledIndexS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
