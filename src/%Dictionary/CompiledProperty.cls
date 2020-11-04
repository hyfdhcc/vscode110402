Class %Dictionary.CompiledProperty Extends (%Persistent, %Dictionary.CompiledPropertyQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledClass [ Cardinality = parent, Inverse = Properties ];

/// List of aliases for this property.
Property Aliases As %CacheString;

/// Specifies that the property has no in-memory storage allocated for it when the object containing it is instantiated.
Property Calculated As %Boolean;

/// Specifies the cardinality of a relationship property. The Cardinality keyword is required for relationship properties. It is ignored by non-relationship properties. 
Property Cardinality As %CacheString;

/// ClientName
Property ClientName As %CacheString;

/// Specifies that a property is a collection property as well as what type of collection it is.
Property Collection As %CacheString;

/// CompilerGenerated
Property CompilerGenerated As %Boolean;

/// List of properties referenced by the SQLCOMPUTECODE.
Property ComputeDependency As %CacheString;

/// List of properties to be computed when this property changes.
Property ComputeTriggers As %CacheString;

/// True if this property is deprecated.
Property Deprecated As %Boolean;

/// Specifies a description of the property.
Property Description As %CacheString;

/// Deprecated
Property DirectRefOnGet As %Boolean;

/// Deprecated
Property DirectRefOnSet As %Boolean;

/// Specifies that subclasses cannot override the definition of this property.
Property Final As %Boolean;

/// Id
Property Id As %Integer;

/// Specifies that this property is the identity for this class. Identity properties can be set in new objects only and the default is set by incrementing a counter.
Property Identity As %Boolean [ SqlFieldName = _Identity ];

/// InheritedId
Property InheritedId As %Boolean;

/// Specifies an initial value for the property.
Property InitialExpression As %CacheString;

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean;

/// Specifies the name of the inverse side of a relationship. That is, the name of the corresponding relationship property in the related class. The inverse property must exist in the related class and have the correct Cardinality value. The Inverse keyword is required for relationship properties. It is ignored by non-relationship properties.
Property Inverse As %CacheString;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Method
Relationship Methods As %Dictionary.CompiledPropertyMethod [ Cardinality = children, Inverse = parent ];

/// Specifies that an attribute has the characteristics of a multidimensional array.
Property MultiDimensional As %Boolean;

/// The name of the property.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Deprecated.
Property NoModBit As %Boolean;

/// Deprecated.
Property NotInheritable As %Boolean;

/// Specifies what referential action to take when the key value is deleted from the foreign table.
Property OnDelete As %CacheString;

/// Origin
Property Origin As %CacheString;

/// Parameter
Property Parameters As array Of %CacheString;

/// Specifies that the property is private. Private properties can only be used by instance methods of this class or its subclasses.
Property Private As %Boolean;

/// Specifies that the property is readonly.
Property ReadOnly As %Boolean;

/// Specifies that a property is a relationship property. 
Property Relationship As %Boolean;

/// In the case of a persistent class, specifies that the value of the property must be given a value before it can be stored to disk.
Property Required As %Boolean;

/// RuntimeType
Property RuntimeType As %CacheString;

/// SequenceNumber
Property SequenceNumber As %Integer;

/// Specifies that a property will not be projected to a Java or C++ client.
Property ServerOnly As %CacheString;

/// Deprecated.
Property SqlCollation As %CacheString;

/// Explicitly sets the SQL Column number for this property. This is provided for legacy application support.
Property SqlColumnNumber As %CacheString;

/// Specifies Cache ObjectScript code that evaluates to a computed field value. 
Property SqlComputeCode As %CacheString;

/// Specifies that this property is an SQL computed field.
Property SqlComputed As %Boolean;

/// Specifies one or more properties whose modification triggers the recalculation of this computed field within SQL.
Property SqlComputeOnChange As %CacheString;

/// In the case of a persistent class, specifies the column name used to identify the property in its SQL projection. By default, the SQL column name is the same as the property name.
Property SqlFieldName As %CacheString;

/// Specifies the delimiter character used within SQL for lists. This is provided for legacy application support.
Property SqlListDelimiter As %CacheString;

/// specifies the representation to be used for a list.
Property SqlListType As %CacheString;

/// Storable
Property Storable As %Boolean;

/// In the case of a persistent class, specifies that the property is not stored in the database.
Property Transient As %Boolean;

/// Specifies the name of the class associated with the property, which can be a data type class, a persistent class, or an embeddable serial class.
Property Type As %Dictionary.CacheClassname;

/// UDLText
Relationship UDLTexts As %Dictionary.CompiledPropertyUDLText [ Cardinality = children, Inverse = parent ];

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
 i $$$comMemberDefined(name1,$$$cCLASSproperty,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$comMemberDefined(name1,$$$cCLASSproperty,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Aliases=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPaliases)
 . s i%Calculated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPcalculated)
 . s i%Cardinality=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPcardinality)
 . s i%ClientName=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPclientname)
 . s i%Collection=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPcollection)
 . s i%CompilerGenerated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPcompilergenerated)
 . s i%ComputeDependency=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPcomputedependency)
 . s i%ComputeTriggers=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPcomputetriggers)
 . s i%Deprecated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPdeprecated)
 . s i%Description=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPdescription)
 . s i%DirectRefOnGet=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPdirectrefonget)
 . s i%DirectRefOnSet=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPdirectrefonset)
 . s i%Final=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPfinal)
 . s i%Id=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPid)
 . s i%Identity=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPidentity)
 . s i%InheritedId=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPinheritedid)
 . s i%InitialExpression=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPinitialexpression)
 . s i%Internal=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPinternal)
 . s i%Inverse=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPinverse)
 . s i%KeywordError=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPkeyworderror)
 . s i%KeywordModified=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPkeywordmodified)
 . s i%MultiDimensional=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPmultidimensional)
 . s i%NoModBit=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPnomodbit)
 . s i%NotInheritable=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPnotinheritable)
 . s i%OnDelete=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPondelete)
 . s i%Origin=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPorigin)
 . s i%Private=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPprivate)
 . s i%ReadOnly=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPreadonly)
 . s i%Relationship=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPrelationship)
 . s i%Required=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPrequired)
 . s i%RuntimeType=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPruntimetype)
 . s i%SequenceNumber=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsequencenumber)
 . s i%ServerOnly=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPserveronly)
 . s i%SqlCollation=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqlcollation)
 . s i%SqlColumnNumber=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqlcolumnnumber)
 . s i%SqlComputeCode=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputecode)
 . s i%SqlComputed=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputed)
 . s i%SqlComputeOnChange=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputeonchange)
 . s i%SqlFieldName=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqlfieldname)
 . s i%SqlListDelimiter=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqllistdelimiter)
 . s i%SqlListType=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPsqllisttype)
 . s i%Storable=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPstorable)
 . s i%Transient=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPtransient)
 . s i%Type=$$$comMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPtype)
 . s sub="" f  s sub=$$$comSubMemberNext(name1,$$$cCLASSproperty,name2,$$$cPROPparameter,sub) q:sub=""  d
 . . d ..Parameters.SetAt($$$comMemberArrayGet(name1,$$$cCLASSproperty,name2,$$$cPROPparameter,sub),sub)
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
<Data name="Aliases">
<RetrievalCode> s {Aliases}=$s($d(^oddCOM({L1},"a",{L3},58))#2:^(58),$d(^oddCOM($g(^(2),{L1}),"a",{L3},58))#2:^(58),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},58))#2:^(58),1:""))
</RetrievalCode>
</Data>
<Data name="Calculated">
<RetrievalCode> s {Calculated}=$s($d(^oddCOM({L1},"a",{L3},23))#2:^(23),$d(^oddCOM($g(^(2),{L1}),"a",{L3},23))#2:^(23),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},23))#2:^(23),1:0))
</RetrievalCode>
</Data>
<Data name="Cardinality">
<RetrievalCode> s {Cardinality}=$s($d(^oddCOM({L1},"a",{L3},24))#2:^(24),$d(^oddCOM($g(^(2),{L1}),"a",{L3},24))#2:^(24),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},24))#2:^(24),1:""))
</RetrievalCode>
</Data>
<Data name="ClientName">
<RetrievalCode> s {ClientName}=$s($d(^oddCOM({L1},"a",{L3},26))#2:^(26),$d(^oddCOM($g(^(2),{L1}),"a",{L3},26))#2:^(26),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},26))#2:^(26),1:""))
</RetrievalCode>
</Data>
<Data name="Collection">
<RetrievalCode> s {Collection}=$s($d(^oddCOM({L1},"a",{L3},27))#2:^(27),$d(^oddCOM($g(^(2),{L1}),"a",{L3},27))#2:^(27),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},27))#2:^(27),1:""))
</RetrievalCode>
</Data>
<Data name="CompilerGenerated">
<RetrievalCode> s {CompilerGenerated}=$s($d(^oddCOM({L1},"a",{L3},10))#2:^(10),$d(^oddCOM($g(^(2),{L1}),"a",{L3},10))#2:^(10),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},10))#2:^(10),1:0))
</RetrievalCode>
</Data>
<Data name="ComputeDependency">
<RetrievalCode> s {ComputeDependency}=$s($d(^oddCOM({L1},"a",{L3},54))#2:^(54),$d(^oddCOM($g(^(2),{L1}),"a",{L3},54))#2:^(54),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},54))#2:^(54),1:""))
</RetrievalCode>
</Data>
<Data name="ComputeTriggers">
<RetrievalCode> s {ComputeTriggers}=$s($d(^oddCOM({L1},"a",{L3},55))#2:^(55),$d(^oddCOM($g(^(2),{L1}),"a",{L3},55))#2:^(55),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},55))#2:^(55),1:""))
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddCOM({L1},"a",{L3},17))#2:^(17),$d(^oddCOM($g(^(2),{L1}),"a",{L3},17))#2:^(17),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},17))#2:^(17),1:0))
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddCOM({L1},"a",{L3},4))#2:^(4),$d(^oddCOM($g(^(2),{L1}),"a",{L3},4))#2:^(4),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},4))#2:^(4),1:""))
</RetrievalCode>
</Data>
<Data name="DirectRefOnGet">
<RetrievalCode> s {DirectRefOnGet}=$s($d(^oddCOM({L1},"a",{L3},29))#2:^(29),$d(^oddCOM($g(^(2),{L1}),"a",{L3},29))#2:^(29),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},29))#2:^(29),1:0))
</RetrievalCode>
</Data>
<Data name="DirectRefOnSet">
<RetrievalCode> s {DirectRefOnSet}=$s($d(^oddCOM({L1},"a",{L3},30))#2:^(30),$d(^oddCOM($g(^(2),{L1}),"a",{L3},30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},30))#2:^(30),1:0))
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddCOM({L1},"a",{L3},7))#2:^(7),$d(^oddCOM($g(^(2),{L1}),"a",{L3},7))#2:^(7),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},7))#2:^(7),1:0))
</RetrievalCode>
</Data>
<Data name="Id">
<RetrievalCode> s {Id}=$s($d(^oddCOM({L1},"a",{L3},6))#2:^(6),$d(^oddCOM($g(^(2),{L1}),"a",{L3},6))#2:^(6),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},6))#2:^(6),1:0))
</RetrievalCode>
</Data>
<Data name="InheritedId">
<RetrievalCode> s {InheritedId}=$s($d(^oddCOM({L1},"a",{L3},8))#2:^(8),$d(^oddCOM($g(^(2),{L1}),"a",{L3},8))#2:^(8),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},8))#2:^(8),1:0))
</RetrievalCode>
</Data>
<Data name="InitialExpression">
<RetrievalCode> s {InitialExpression}=$s($d(^oddCOM({L1},"a",{L3},31))#2:^(31),$d(^oddCOM($g(^(2),{L1}),"a",{L3},31))#2:^(31),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},31))#2:^(31),1:""""""))
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddCOM({L1},"a",{L3},14))#2:^(14),$d(^oddCOM($g(^(2),{L1}),"a",{L3},14))#2:^(14),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},14))#2:^(14),1:0))
</RetrievalCode>
</Data>
<Data name="Inverse">
<RetrievalCode> s {Inverse}=$s($d(^oddCOM({L1},"a",{L3},32))#2:^(32),$d(^oddCOM($g(^(2),{L1}),"a",{L3},32))#2:^(32),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},32))#2:^(32),1:""))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$s($d(^oddCOM({L1},"a",{L3},12))#2:^(12),$d(^oddCOM($g(^(2),{L1}),"a",{L3},12))#2:^(12),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},12))#2:^(12),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$s($d(^oddCOM({L1},"a",{L3},13))#2:^(13),$d(^oddCOM($g(^(2),{L1}),"a",{L3},13))#2:^(13),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},13))#2:^(13),1:0))
</RetrievalCode>
</Data>
<Data name="MultiDimensional">
<RetrievalCode> s {MultiDimensional}=$s($d(^oddCOM({L1},"a",{L3},33))#2:^(33),$d(^oddCOM($g(^(2),{L1}),"a",{L3},33))#2:^(33),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},33))#2:^(33),1:0))
</RetrievalCode>
</Data>
<Data name="NoModBit">
<RetrievalCode> s {NoModBit}=$s($d(^oddCOM({L1},"a",{L3},53))#2:^(53),$d(^oddCOM($g(^(2),{L1}),"a",{L3},53))#2:^(53),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},53))#2:^(53),1:0))
</RetrievalCode>
</Data>
<Data name="NotInheritable">
<RetrievalCode> s {NotInheritable}=$s($d(^oddCOM({L1},"a",{L3},9))#2:^(9),$d(^oddCOM($g(^(2),{L1}),"a",{L3},9))#2:^(9),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},9))#2:^(9),1:0))
</RetrievalCode>
</Data>
<Data name="OnDelete">
<RetrievalCode> s {OnDelete}=$s($d(^oddCOM({L1},"a",{L3},59))#2:^(59),$d(^oddCOM($g(^(2),{L1}),"a",{L3},59))#2:^(59),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},59))#2:^(59),1:""))
</RetrievalCode>
</Data>
<Data name="Origin">
<RetrievalCode> s {Origin}=$s($d(^oddCOM({L1},"a",{L3},2))#2:^(2),$d(^oddCOM($g(^(2),{L1}),"a",{L3},2))#2:^(2),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},2))#2:^(2),1:""))
</RetrievalCode>
</Data>
<Data name="Parameters">
<RetrievalCode> n sub s {Parameters}="",sub="" f  s sub=$o(^oddCOM({L1},"a",{L3},"P",sub)) q:sub=""  s {Parameters}={Parameters}_$lb($lb(sub,$s($d(^oddCOM({L1},"a",{L3},"P",sub))#2:^(sub),$d(^oddCOM($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},"P",sub))#2:^(sub),1:$g(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},"P",sub)))))
</RetrievalCode>
</Data>
<Data name="Private">
<RetrievalCode> s {Private}=$s($d(^oddCOM({L1},"a",{L3},35))#2:^(35),$d(^oddCOM($g(^(2),{L1}),"a",{L3},35))#2:^(35),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},35))#2:^(35),1:0))
</RetrievalCode>
</Data>
<Data name="ReadOnly">
<RetrievalCode> s {ReadOnly}=$s($d(^oddCOM({L1},"a",{L3},52))#2:^(52),$d(^oddCOM($g(^(2),{L1}),"a",{L3},52))#2:^(52),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},52))#2:^(52),1:0))
</RetrievalCode>
</Data>
<Data name="Relationship">
<RetrievalCode> s {Relationship}=$s($d(^oddCOM({L1},"a",{L3},36))#2:^(36),$d(^oddCOM($g(^(2),{L1}),"a",{L3},36))#2:^(36),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},36))#2:^(36),1:0))
</RetrievalCode>
</Data>
<Data name="Required">
<RetrievalCode> s {Required}=$s($d(^oddCOM({L1},"a",{L3},37))#2:^(37),$d(^oddCOM($g(^(2),{L1}),"a",{L3},37))#2:^(37),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},37))#2:^(37),1:0))
</RetrievalCode>
</Data>
<Data name="RuntimeType">
<RetrievalCode> s {RuntimeType}=$s($d(^oddCOM({L1},"a",{L3},40))#2:^(40),$d(^oddCOM($g(^(2),{L1}),"a",{L3},40))#2:^(40),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},40))#2:^(40),1:""))
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddCOM({L1},"a",{L3},11))#2:^(11),$d(^oddCOM($g(^(2),{L1}),"a",{L3},11))#2:^(11),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},11))#2:^(11),1:0))
</RetrievalCode>
</Data>
<Data name="ServerOnly">
<RetrievalCode> s {ServerOnly}=$s($d(^oddCOM({L1},"a",{L3},57))#2:^(57),$d(^oddCOM($g(^(2),{L1}),"a",{L3},57))#2:^(57),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},57))#2:^(57),1:""))
</RetrievalCode>
</Data>
<Data name="SqlCollation">
<RetrievalCode> s {SqlCollation}=$s($d(^oddCOM({L1},"a",{L3},42))#2:^(42),$d(^oddCOM($g(^(2),{L1}),"a",{L3},42))#2:^(42),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},42))#2:^(42),1:""))
</RetrievalCode>
</Data>
<Data name="SqlColumnNumber">
<RetrievalCode> s {SqlColumnNumber}=$s($d(^oddCOM({L1},"a",{L3},43))#2:^(43),$d(^oddCOM($g(^(2),{L1}),"a",{L3},43))#2:^(43),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},43))#2:^(43),1:""))
</RetrievalCode>
</Data>
<Data name="SqlComputeCode">
<RetrievalCode> s {SqlComputeCode}=$s($d(^oddCOM({L1},"a",{L3},44))#2:^(44),$d(^oddCOM($g(^(2),{L1}),"a",{L3},44))#2:^(44),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},44))#2:^(44),1:""))
</RetrievalCode>
</Data>
<Data name="SqlComputeOnChange">
<RetrievalCode> s {SqlComputeOnChange}=$s($d(^oddCOM({L1},"a",{L3},46))#2:^(46),$d(^oddCOM($g(^(2),{L1}),"a",{L3},46))#2:^(46),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},46))#2:^(46),1:""))
</RetrievalCode>
</Data>
<Data name="SqlComputed">
<RetrievalCode> s {SqlComputed}=$s($d(^oddCOM({L1},"a",{L3},45))#2:^(45),$d(^oddCOM($g(^(2),{L1}),"a",{L3},45))#2:^(45),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},45))#2:^(45),1:0))
</RetrievalCode>
</Data>
<Data name="SqlFieldName">
<RetrievalCode> s {SqlFieldName}=$s($d(^oddCOM({L1},"a",{L3},47))#2:^(47),$d(^oddCOM($g(^(2),{L1}),"a",{L3},47))#2:^(47),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},47))#2:^(47),1:""))
</RetrievalCode>
</Data>
<Data name="SqlListDelimiter">
<RetrievalCode> s {SqlListDelimiter}=$s($d(^oddCOM({L1},"a",{L3},48))#2:^(48),$d(^oddCOM($g(^(2),{L1}),"a",{L3},48))#2:^(48),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},48))#2:^(48),1:""))
</RetrievalCode>
</Data>
<Data name="SqlListType">
<RetrievalCode> s {SqlListType}=$s($d(^oddCOM({L1},"a",{L3},49))#2:^(49),$d(^oddCOM($g(^(2),{L1}),"a",{L3},49))#2:^(49),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},49))#2:^(49),1:""))
</RetrievalCode>
</Data>
<Data name="Storable">
<RetrievalCode> s {Storable}=$s($d(^oddCOM({L1},"a",{L3},50))#2:^(50),$d(^oddCOM($g(^(2),{L1}),"a",{L3},50))#2:^(50),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},50))#2:^(50),1:0))
</RetrievalCode>
</Data>
<Data name="Transient">
<RetrievalCode> s {Transient}=$s($d(^oddCOM({L1},"a",{L3},51))#2:^(51),$d(^oddCOM($g(^(2),{L1}),"a",{L3},51))#2:^(51),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},51))#2:^(51),1:0))
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddCOM({L1},"a",{L3},5))#2:^(5),$d(^oddCOM($g(^(2),{L1}),"a",{L3},5))#2:^(5),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},5))#2:^(5),1:""))
</RetrievalCode>
</Data>
<Data name="_Identity">
<RetrievalCode> s {_Identity}=$s($d(^oddCOM({L1},"a",{L3},56))#2:^(56),$d(^oddCOM($g(^(2),{L1}),"a",{L3},56))#2:^(56),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},2),{L1}),"a",{L3},56))#2:^(56),1:0))
</RetrievalCode>
</Data>
<Global>^oddCOM</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.CompiledClass.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"a"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.CompiledProperty.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledPropertyS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
