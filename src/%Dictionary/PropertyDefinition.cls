Class %Dictionary.PropertyDefinition Extends (%Persistent, %Dictionary.PropertyDefinitionQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.ClassDefinition [ Cardinality = parent, Inverse = Properties ];

/// List of aliases for this property.
Property Aliases As %CacheString;

/// Specifies that the property has no in-memory storage allocated for it when the object containing it is instantiated.
Property Calculated As %Boolean [ InitialExpression = 0 ];

/// Specifies the cardinality of a relationship property. The Cardinality keyword is required for relationship properties. It is ignored by non-relationship properties. 
Property Cardinality As %CacheString;

/// ClientName
Property ClientName As %CacheString;

/// Specifies that a property is a collection property as well as what type of collection it is.
Property Collection As %CacheString;

/// True if this property is deprecated.
Property Deprecated As %Boolean [ InitialExpression = 0 ];

/// Specifies a description of the property.
Property Description As %CacheString;

/// Specifies that subclasses cannot override the definition of this property.
Property Final As %Boolean [ InitialExpression = 0 ];

/// Specifies that this property is the identity for this class. Identity properties can be set in new objects only and the default is set by incrementing a counter.
Property Identity As %Boolean [ InitialExpression = 0, SqlFieldName = _Identity ];

/// Specifies an initial value for the property.
Property InitialExpression As %CacheString [ InitialExpression = """""" ];

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean [ InitialExpression = 0 ];

/// Specifies the name of the inverse side of a relationship. That is, the name of the corresponding relationship property in the related class. The inverse property must exist in the related class and have the correct Cardinality value. The Inverse keyword is required for relationship properties. It is ignored by non-relationship properties.
Property Inverse As %CacheString;

/// Specifies that an attribute has the characteristics of a multidimensional array.
Property MultiDimensional As %Boolean [ InitialExpression = 0 ];

/// The name of the property.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Deprecated.
Property NoModBit As %Boolean [ InitialExpression = 0 ];

/// Deprecated.
Property NotInheritable As %Boolean [ InitialExpression = 0 ];

/// Specifies what referential action to take when the key value is deleted from the foreign table.
Property OnDelete As %CacheString;

/// Parameter
Property Parameters As array Of %CacheString;

/// Specifies that the property is private. Private properties can only be used by instance methods of this class or its subclasses.
Property Private As %Boolean [ InitialExpression = 0 ];

/// Specifies that the property is readonly.
Property ReadOnly As %Boolean [ InitialExpression = 0 ];

/// Specifies that a property is a relationship property. 
Property Relationship As %Boolean [ InitialExpression = 0 ];

/// In the case of a persistent class, specifies that the value of the property must be given a value before it can be stored to disk.
Property Required As %Boolean [ InitialExpression = 0 ];

/// SequenceNumber
Property SequenceNumber As %Integer [ InitialExpression = 0 ];

/// Specifies that a property will not be projected to a Java or C++ client.
Property ServerOnly As %CacheString;

/// Deprecated.
Property SqlCollation As %CacheString;

/// Explicitly sets the SQL Column number for this property. This is provided for legacy application support.
Property SqlColumnNumber As %CacheString;

/// Specifies Cache ObjectScript code that evaluates to a computed field value. 
Property SqlComputeCode As %CacheString;

/// Specifies that this property is an SQL computed field.
Property SqlComputed As %Boolean [ InitialExpression = 0 ];

/// Specifies one or more properties whose modification triggers the recalculation of this computed field within SQL.
Property SqlComputeOnChange As %CacheString;

/// In the case of a persistent class, specifies the column name used to identify the property in its SQL projection. By default, the SQL column name is the same as the property name.
Property SqlFieldName As %CacheString;

/// Specifies the delimiter character used within SQL for lists. This is provided for legacy application support.
Property SqlListDelimiter As %CacheString;

/// specifies the representation to be used for a list.
Property SqlListType As %CacheString;

/// In the case of a persistent class, specifies that the property is not stored in the database.
Property Transient As %Boolean [ InitialExpression = 0 ];

/// Specifies the name of the class associated with the property, which can be a data type class, a persistent class, or an embeddable serial class.
Property Type As %Dictionary.CacheClassname;

/// UDLText
Relationship UDLTexts As %Dictionary.PropertyUDLTextDefinition [ Cardinality = children, Inverse = parent ];

ClassMethod CardinalityIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="one" q $$$OK
 i val="many" q $$$OK
 i val="parent" q $$$OK
 i val="children" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyDefinition:Cardinality",val)
}

ClassMethod CollectionIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="array" q $$$OK
 i val="list" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyDefinition:Collection",val)
}

ClassMethod OnDeleteIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="cascade" q $$$OK
 i val="noaction" q $$$OK
 i val="setdefault" q $$$OK
 i val="setnull" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyDefinition:OnDelete",val)
}

ClassMethod ServerOnlyIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="0" q $$$OK
 i val="1" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyDefinition:ServerOnly",val)
}

ClassMethod SqlCollationIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="ALPHAUP" q $$$OK
 i val="PLUS" q $$$OK
 i val="MINUS" q $$$OK
 i val="SPACE" q $$$OK
 i val="EXACT" q $$$OK
 i val="UPPER" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyDefinition:SqlCollation",val)
}

ClassMethod SqlListTypeIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="DELIMITED" q $$$OK
 i val="LIST" q $$$OK
 i val="SUBNODE" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyDefinition:SqlListType",val)
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
 i $$$defMemberDefined(name1,$$$cCLASSproperty,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$defMemberDefined(name1,$$$cCLASSproperty,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Aliases=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPaliases)
 . s i%Calculated=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPcalculated)
 . s i%Cardinality=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPcardinality)
 . s i%ClientName=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPclientname)
 . s i%Collection=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPcollection)
 . s i%Deprecated=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPdeprecated)
 . s i%Description=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPdescription)
 . s i%Final=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPfinal)
 . s i%Identity=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPidentity)
 . s i%InitialExpression=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPinitialexpression)
 . s i%Internal=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPinternal)
 . s i%Inverse=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPinverse)
 . s i%MultiDimensional=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPmultidimensional)
 . s i%NoModBit=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPnomodbit)
 . s i%NotInheritable=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPnotinheritable)
 . s i%OnDelete=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPondelete)
 . s i%Private=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPprivate)
 . s i%ReadOnly=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPreadonly)
 . s i%Relationship=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPrelationship)
 . s i%Required=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPrequired)
 . s i%SequenceNumber=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsequencenumber)
 . s i%ServerOnly=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPserveronly)
 . s i%SqlCollation=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcollation)
 . s i%SqlColumnNumber=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcolumnnumber)
 . s i%SqlComputeCode=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputecode)
 . s i%SqlComputed=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputed)
 . s i%SqlComputeOnChange=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputeonchange)
 . s i%SqlFieldName=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlfieldname)
 . s i%SqlListDelimiter=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqllistdelimiter)
 . s i%SqlListType=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPsqllisttype)
 . s i%Transient=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPtransient)
 . s i%Type=$$$defMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPtype)
 . s sub="" f  s sub=$$$defSubMemberNext(name1,$$$cCLASSproperty,name2,$$$cPROPparameter,sub) q:sub=""  d
 . . d ..Parameters.SetAt($$$defMemberArrayGet(name1,$$$cCLASSproperty,name2,$$$cPROPparameter,sub),sub)
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
 . i '($$$defMemberDefined(name1,$$$cCLASSproperty,name2)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defMemberSet(name1,$$$cCLASSproperty,name2,"")
 . i i%Aliases="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPaliases) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPaliases,i%Aliases) }
 . i i%Calculated=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPcalculated) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPcalculated,i%Calculated) }
 . i i%Cardinality="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPcardinality) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPcardinality,i%Cardinality) }
 . i i%ClientName="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPclientname) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPclientname,i%ClientName) }
 . i i%Collection="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPcollection) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPcollection,i%Collection) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPdescription,i%Description) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPfinal,i%Final) }
 . i i%Identity=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPidentity) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPidentity,i%Identity) }
 . i i%InitialExpression="""""" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPinitialexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPinitialexpression,i%InitialExpression) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPinternal,i%Internal) }
 . i i%Inverse="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPinverse) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPinverse,i%Inverse) }
 . i i%MultiDimensional=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPmultidimensional) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPmultidimensional,i%MultiDimensional) }
 . i i%NoModBit=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPnomodbit) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPnomodbit,i%NoModBit) }
 . i i%NotInheritable=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPnotinheritable) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPnotinheritable,i%NotInheritable) }
 . i i%OnDelete="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPondelete) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPondelete,i%OnDelete) }
 . i i%Private=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPprivate) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPprivate,i%Private) }
 . i i%ReadOnly=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPreadonly) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPreadonly,i%ReadOnly) }
 . i i%Relationship=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPrelationship) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPrelationship,i%Relationship) }
 . i i%Required=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPrequired) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPrequired,i%Required) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsequencenumber,i%SequenceNumber) }
 . i i%ServerOnly="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPserveronly) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPserveronly,i%ServerOnly) }
 . i i%SqlCollation="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcollation) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcollation,i%SqlCollation) }
 . i i%SqlColumnNumber="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcolumnnumber) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcolumnnumber,i%SqlColumnNumber) }
 . i i%SqlComputeCode="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputecode) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputecode,i%SqlComputeCode) }
 . i i%SqlComputed=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputed) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputed,i%SqlComputed) }
 . i i%SqlComputeOnChange="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputeonchange) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputeonchange,i%SqlComputeOnChange) }
 . i i%SqlFieldName="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlfieldname) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlfieldname,i%SqlFieldName) }
 . i i%SqlListDelimiter="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqllistdelimiter) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqllistdelimiter,i%SqlListDelimiter) }
 . i i%SqlListType="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqllisttype) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqllisttype,i%SqlListType) }
 . i i%Transient=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPtransient) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPtransient,i%Transient) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPtype) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPtype,i%Type) }
 . $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPparameter)
 . s sub="" f  s sub=..Parameters.Next(sub) q:sub=""  d
 . . $$$defSubMemberSet(name1,$$$cCLASSproperty,name2,$$$cPROPparameter,sub,..Parameters.GetAt(sub))
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,1):1,i%Name'=$p(id,"||",2):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defMemberDefined(name1,$$$cCLASSproperty,name2) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.PropertyDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defMemberSet(name1,$$$cCLASSproperty,name2,"")
 . i i%Aliases="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPaliases) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPaliases,i%Aliases) }
 . i i%Calculated=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPcalculated) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPcalculated,i%Calculated) }
 . i i%Cardinality="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPcardinality) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPcardinality,i%Cardinality) }
 . i i%ClientName="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPclientname) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPclientname,i%ClientName) }
 . i i%Collection="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPcollection) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPcollection,i%Collection) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPdescription,i%Description) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPfinal,i%Final) }
 . i i%Identity=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPidentity) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPidentity,i%Identity) }
 . i i%InitialExpression="""""" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPinitialexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPinitialexpression,i%InitialExpression) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPinternal,i%Internal) }
 . i i%Inverse="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPinverse) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPinverse,i%Inverse) }
 . i i%MultiDimensional=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPmultidimensional) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPmultidimensional,i%MultiDimensional) }
 . i i%NoModBit=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPnomodbit) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPnomodbit,i%NoModBit) }
 . i i%NotInheritable=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPnotinheritable) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPnotinheritable,i%NotInheritable) }
 . i i%OnDelete="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPondelete) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPondelete,i%OnDelete) }
 . i i%Private=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPprivate) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPprivate,i%Private) }
 . i i%ReadOnly=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPreadonly) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPreadonly,i%ReadOnly) }
 . i i%Relationship=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPrelationship) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPrelationship,i%Relationship) }
 . i i%Required=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPrequired) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPrequired,i%Required) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsequencenumber,i%SequenceNumber) }
 . i i%ServerOnly="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPserveronly) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPserveronly,i%ServerOnly) }
 . i i%SqlCollation="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcollation) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcollation,i%SqlCollation) }
 . i i%SqlColumnNumber="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcolumnnumber) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcolumnnumber,i%SqlColumnNumber) }
 . i i%SqlComputeCode="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputecode) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputecode,i%SqlComputeCode) }
 . i i%SqlComputed=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputed) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputed,i%SqlComputed) }
 . i i%SqlComputeOnChange="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputeonchange) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlcomputeonchange,i%SqlComputeOnChange) }
 . i i%SqlFieldName="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqlfieldname) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqlfieldname,i%SqlFieldName) }
 . i i%SqlListDelimiter="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqllistdelimiter) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqllistdelimiter,i%SqlListDelimiter) }
 . i i%SqlListType="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPsqllisttype) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPsqllisttype,i%SqlListType) }
 . i i%Transient=0 { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPtransient) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPtransient,i%Transient) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPtype) } else { $$$defMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPtype,i%Type) }
 . $$$defMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPparameter)
 . s sub="" f  s sub=..Parameters.Next(sub) q:sub=""  d
 . . $$$defSubMemberSet(name1,$$$cCLASSproperty,name2,$$$cPROPparameter,sub,..Parameters.GetAt(sub))
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
 If '$$$GetddlNo30,'($$$defMemberDefined(name1,$$$cCLASSproperty,name2)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defMemberKill(name1,$$$cCLASSproperty,name2) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Aliases">
<RetrievalCode> s {Aliases}=$s($d(^oddDEF({L1},"a",{L3},58))#2:^(58),1:"")
</RetrievalCode>
</Data>
<Data name="Calculated">
<RetrievalCode> s {Calculated}=$s($d(^oddDEF({L1},"a",{L3},23))#2:^(23),1:0)
</RetrievalCode>
</Data>
<Data name="Cardinality">
<RetrievalCode> s {Cardinality}=$s($d(^oddDEF({L1},"a",{L3},24))#2:^(24),1:"")
</RetrievalCode>
</Data>
<Data name="ClientName">
<RetrievalCode> s {ClientName}=$s($d(^oddDEF({L1},"a",{L3},26))#2:^(26),1:"")
</RetrievalCode>
</Data>
<Data name="Collection">
<RetrievalCode> s {Collection}=$s($d(^oddDEF({L1},"a",{L3},27))#2:^(27),1:"")
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddDEF({L1},"a",{L3},17))#2:^(17),1:0)
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddDEF({L1},"a",{L3},4))#2:^(4),1:"")
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddDEF({L1},"a",{L3},7))#2:^(7),1:0)
</RetrievalCode>
</Data>
<Data name="InitialExpression">
<RetrievalCode> s {InitialExpression}=$s($d(^oddDEF({L1},"a",{L3},31))#2:^(31),1:"""""")
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddDEF({L1},"a",{L3},14))#2:^(14),1:0)
</RetrievalCode>
</Data>
<Data name="Inverse">
<RetrievalCode> s {Inverse}=$s($d(^oddDEF({L1},"a",{L3},32))#2:^(32),1:"")
</RetrievalCode>
</Data>
<Data name="MultiDimensional">
<RetrievalCode> s {MultiDimensional}=$s($d(^oddDEF({L1},"a",{L3},33))#2:^(33),1:0)
</RetrievalCode>
</Data>
<Data name="NoModBit">
<RetrievalCode> s {NoModBit}=$s($d(^oddDEF({L1},"a",{L3},53))#2:^(53),1:0)
</RetrievalCode>
</Data>
<Data name="NotInheritable">
<RetrievalCode> s {NotInheritable}=$s($d(^oddDEF({L1},"a",{L3},9))#2:^(9),1:0)
</RetrievalCode>
</Data>
<Data name="OnDelete">
<RetrievalCode> s {OnDelete}=$s($d(^oddDEF({L1},"a",{L3},59))#2:^(59),1:"")
</RetrievalCode>
</Data>
<Data name="Parameters">
<RetrievalCode> n sub s {Parameters}="",sub="" f  s sub=$o(^oddDEF({L1},"a",{L3},"P",sub)) q:sub=""  s {Parameters}={Parameters}_$lb($lb(sub,$g(^oddDEF({L1},"a",{L3},"P",sub))))
</RetrievalCode>
</Data>
<Data name="Private">
<RetrievalCode> s {Private}=$s($d(^oddDEF({L1},"a",{L3},35))#2:^(35),1:0)
</RetrievalCode>
</Data>
<Data name="ReadOnly">
<RetrievalCode> s {ReadOnly}=$s($d(^oddDEF({L1},"a",{L3},52))#2:^(52),1:0)
</RetrievalCode>
</Data>
<Data name="Relationship">
<RetrievalCode> s {Relationship}=$s($d(^oddDEF({L1},"a",{L3},36))#2:^(36),1:0)
</RetrievalCode>
</Data>
<Data name="Required">
<RetrievalCode> s {Required}=$s($d(^oddDEF({L1},"a",{L3},37))#2:^(37),1:0)
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddDEF({L1},"a",{L3},11))#2:^(11),1:0)
</RetrievalCode>
</Data>
<Data name="ServerOnly">
<RetrievalCode> s {ServerOnly}=$s($d(^oddDEF({L1},"a",{L3},57))#2:^(57),1:"")
</RetrievalCode>
</Data>
<Data name="SqlCollation">
<RetrievalCode> s {SqlCollation}=$s($d(^oddDEF({L1},"a",{L3},42))#2:^(42),1:"")
</RetrievalCode>
</Data>
<Data name="SqlColumnNumber">
<RetrievalCode> s {SqlColumnNumber}=$s($d(^oddDEF({L1},"a",{L3},43))#2:^(43),1:"")
</RetrievalCode>
</Data>
<Data name="SqlComputeCode">
<RetrievalCode> s {SqlComputeCode}=$s($d(^oddDEF({L1},"a",{L3},44))#2:^(44),1:"")
</RetrievalCode>
</Data>
<Data name="SqlComputeOnChange">
<RetrievalCode> s {SqlComputeOnChange}=$s($d(^oddDEF({L1},"a",{L3},46))#2:^(46),1:"")
</RetrievalCode>
</Data>
<Data name="SqlComputed">
<RetrievalCode> s {SqlComputed}=$s($d(^oddDEF({L1},"a",{L3},45))#2:^(45),1:0)
</RetrievalCode>
</Data>
<Data name="SqlFieldName">
<RetrievalCode> s {SqlFieldName}=$s($d(^oddDEF({L1},"a",{L3},47))#2:^(47),1:"")
</RetrievalCode>
</Data>
<Data name="SqlListDelimiter">
<RetrievalCode> s {SqlListDelimiter}=$s($d(^oddDEF({L1},"a",{L3},48))#2:^(48),1:"")
</RetrievalCode>
</Data>
<Data name="SqlListType">
<RetrievalCode> s {SqlListType}=$s($d(^oddDEF({L1},"a",{L3},49))#2:^(49),1:"")
</RetrievalCode>
</Data>
<Data name="Transient">
<RetrievalCode> s {Transient}=$s($d(^oddDEF({L1},"a",{L3},51))#2:^(51),1:0)
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddDEF({L1},"a",{L3},5))#2:^(5),1:"")
</RetrievalCode>
</Data>
<Data name="_Identity">
<RetrievalCode> s {_Identity}=$s($d(^oddDEF({L1},"a",{L3},56))#2:^(56),1:0)
</RetrievalCode>
</Data>
<Global>^oddDEF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.ClassDefinition.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"a"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.PropertyDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.PropertyDef88F9S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
