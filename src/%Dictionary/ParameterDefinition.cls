Class %Dictionary.ParameterDefinition Extends (%Persistent, %Dictionary.ParameterDefinitionQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.ClassDefinition [ Cardinality = parent, Inverse = Parameters ];

/// Abstract
Property Abstract As %Boolean [ InitialExpression = 0 ];

/// Specifies a constraint value is used by Cache Studio to provide input validation for the parameter. Its value is not used nor enforced by the Class Compiler.
Property Constraint As %CacheString [ SqlFieldName = _Constraint ];

/// Specifies a default value for the parameter assuming the Expression keyword is blank.
Property Default As %CacheString [ SqlFieldName = _Default ];

/// True if this parameter is deprecated.
Property Deprecated As %Boolean [ InitialExpression = 0 ];

/// Specifies a description of the parameter.
Property Description As %CacheString;

/// If true then the parameter value is base64 encoded.
Property Encoded As %Boolean [ InitialExpression = 0 ];

/// An expression to seed parameter with evaluated at compile time, if specified this takes precedence over the Default keyword.
Property Expression As %CacheString;

/// Specifies that subclasses cannot override the definition of the parameter.
Property Final As %Boolean [ InitialExpression = 0 ];

/// Specifies any additional modifier flags for the parameter type.
Property Flags As %CacheString;

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean [ InitialExpression = 0 ];

/// The name of the parameter.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// SequenceNumber
Property SequenceNumber As %Integer [ InitialExpression = 0 ];

/// Specifies a type for the parameter. The type is used by Cache Studio to provide input validation for the parameter.
Property Type As %CacheString;

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
 i $$$defMemberDefined(name1,$$$cCLASSparameter,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$defMemberDefined(name1,$$$cCLASSparameter,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Abstract=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMabstract)
 . s i%Constraint=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMconstraint)
 . s i%Default=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMdefault)
 . s i%Deprecated=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMdeprecated)
 . s i%Description=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMdescription)
 . s i%Encoded=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMencoded)
 . s i%Expression=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMexpression)
 . s i%Final=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMfinal)
 . s i%Flags=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMflags)
 . s i%Internal=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMinternal)
 . s i%SequenceNumber=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMsequencenumber)
 . s i%Type=$$$defMemberKeyGet(name1,$$$cCLASSparameter,name2,$$$cPARAMtype)
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
 . i '($$$defMemberDefined(name1,$$$cCLASSparameter,name2)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defMemberSet(name1,$$$cCLASSparameter,name2,"")
 . i i%Abstract=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMabstract) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMabstract,i%Abstract) }
 . i i%Constraint="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMconstraint) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMconstraint,i%Constraint) }
 . i i%Default="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMdefault) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMdefault,i%Default) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMdescription,i%Description) }
 . i i%Encoded=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMencoded) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMencoded,i%Encoded) }
 . i i%Expression="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMexpression,i%Expression) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMfinal,i%Final) }
 . i i%Flags="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMflags) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMflags,i%Flags) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMinternal,i%Internal) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMsequencenumber,i%SequenceNumber) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMtype) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMtype,i%Type) }
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,1):1,i%Name'=$p(id,"||",2):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defMemberDefined(name1,$$$cCLASSparameter,name2) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.ParameterDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defMemberSet(name1,$$$cCLASSparameter,name2,"")
 . i i%Abstract=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMabstract) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMabstract,i%Abstract) }
 . i i%Constraint="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMconstraint) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMconstraint,i%Constraint) }
 . i i%Default="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMdefault) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMdefault,i%Default) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMdescription,i%Description) }
 . i i%Encoded=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMencoded) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMencoded,i%Encoded) }
 . i i%Expression="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMexpression) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMexpression,i%Expression) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMfinal,i%Final) }
 . i i%Flags="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMflags) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMflags,i%Flags) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMinternal,i%Internal) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMsequencenumber,i%SequenceNumber) }
 . i i%Type="" { $$$defMemberKeyKill(name1,$$$cCLASSparameter,name2,$$$cPARAMtype) } else { $$$defMemberKeySet(name1,$$$cCLASSparameter,name2,$$$cPARAMtype,i%Type) }
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
 If '$$$GetddlNo30,'($$$defMemberDefined(name1,$$$cCLASSparameter,name2)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defMemberKill(name1,$$$cCLASSparameter,name2) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Abstract">
<RetrievalCode> s {Abstract}=$s($d(^oddDEF({L1},"p",{L3},24))#2:^(24),1:0)
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddDEF({L1},"p",{L3},17))#2:^(17),1:0)
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddDEF({L1},"p",{L3},4))#2:^(4),1:"")
</RetrievalCode>
</Data>
<Data name="Encoded">
<RetrievalCode> s {Encoded}=$s($d(^oddDEF({L1},"p",{L3},27))#2:^(27),1:0)
</RetrievalCode>
</Data>
<Data name="Expression">
<RetrievalCode> s {Expression}=$s($d(^oddDEF({L1},"p",{L3},25))#2:^(25),1:"")
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddDEF({L1},"p",{L3},7))#2:^(7),1:0)
</RetrievalCode>
</Data>
<Data name="Flags">
<RetrievalCode> s {Flags}=$s($d(^oddDEF({L1},"p",{L3},23))#2:^(23),1:"")
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddDEF({L1},"p",{L3},14))#2:^(14),1:0)
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddDEF({L1},"p",{L3},11))#2:^(11),1:0)
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddDEF({L1},"p",{L3},5))#2:^(5),1:"")
</RetrievalCode>
</Data>
<Data name="_Constraint">
<RetrievalCode> s {_Constraint}=$s($d(^oddDEF({L1},"p",{L3},21))#2:^(21),1:"")
</RetrievalCode>
</Data>
<Data name="_Default">
<RetrievalCode> s {_Default}=$s($d(^oddDEF({L1},"p",{L3},22))#2:^(22),1:"")
</RetrievalCode>
</Data>
<Global>^oddDEF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.ClassDefinition.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"p"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.ParameterDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.ParameterDeC43FS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
