Class %Dictionary.PropertyUDLTextDefinition Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.PropertyDefinition [ Cardinality = parent, Inverse = UDLTexts ];

/// Category
Property Category As %CacheString [ InitialExpression = "comment" ];

/// Holds the content of the UDL text.
Property Content As %Stream.TmpCharacter;

/// Speficies the COS name of the UDL text.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Position
Property Position As %CacheString [ InitialExpression = "body" ];

/// SequenceNumber
Property SequenceNumber As %Integer [ InitialExpression = 0 ];

/// TextType
Property TextType As %Integer [ InitialExpression = 0 ];

ClassMethod CategoryIsValid(val As %String) As %Status
{
 i val="comment" q $$$OK
 i val="error" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyUDLTextDefinition:Category",val)
}

ClassMethod PositionIsValid(val As %String) As %Status
{
 i val="body" q $$$OK
 i val="header" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.PropertyUDLTextDefinition:Position",val)
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
 i $$$defSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3) QUIT 1
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
 i (name1="")||(name2="")||(name3="")||('$$$defSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%Category=$$$defSubMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcategory)
 . s i%Position=$$$defSubMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTposition)
 . s i%SequenceNumber=$$$defSubMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTsequencenumber)
 . s i%TextType=$$$defSubMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTtexttype)
 . s i%Content=""
 . f ptr=1:1:$$$defSubMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent) d
 . . d ..Content.WriteLine($$$defSubMemberArrayGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent,ptr))
 . d ..Content.Rewind()
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
 i i%parent'="",'##class(%Dictionary.PropertyDefinition).%ExistsId(i%parent) q $$$ERROR($$$ReferencedObjectDoesNotExist,"ClassName")
 i 'insert DO
 . i $s(i%parent'=$p(id,"||",1,2):1,i%Name'=$p(id,"||",3):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 . i '($$$defSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defSubMemberSet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,"")
 . i i%Category="comment" { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcategory) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcategory,i%Category) }
 . i i%Position="body" { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTposition) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTposition,i%Position) }
 . i i%SequenceNumber=0 { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTsequencenumber) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTsequencenumber,i%SequenceNumber) }
 . i i%TextType=0 { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTtexttype) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTtexttype,i%TextType) }
 . $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent)
 . d ..Content.Rewind() s ..Content.LineTerminator=$c(10)
 . f line=1:1 q:..Content.AtEnd  d
 . . s linetext=..Content.ReadLine($$$MaxLocalLength) i $e(linetext,*)=$c(13) s linetext=$e(linetext,1,*-1)
 . . $$$defSubMemberArraySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent,line,linetext)
 . $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent,line-1)
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,2):1,i%Name'=$p(id,"||",3):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2),name3=$p(id,"||",3)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.PropertyUDLTextDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defSubMemberSet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,"")
 . i i%Category="comment" { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcategory) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcategory,i%Category) }
 . i i%Position="body" { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTposition) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTposition,i%Position) }
 . i i%SequenceNumber=0 { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTsequencenumber) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTsequencenumber,i%SequenceNumber) }
 . i i%TextType=0 { $$$defSubMemberKeyKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTtexttype) } else { $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTtexttype,i%TextType) }
 . d ..Content.Rewind() s ..Content.LineTerminator=$c(10)
 . f line=1:1 q:..Content.AtEnd  d
 . . s linetext=..Content.ReadLine($$$MaxLocalLength) i $e(linetext,*)=$c(13) s linetext=$e(linetext,1,*-1)
 . . $$$defSubMemberArraySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent,line,linetext)
 . $$$defSubMemberKeySet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent,line-1)
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
 If '$$$GetddlNo30,'($$$defSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defSubMemberKill(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Category">
<RetrievalCode> s {Category}=$s($d(^oddDEF({L1},"a",{L3},"u",{L5},23))#2:^(23),1:"comment")
</RetrievalCode>
</Data>
<Data name="Content">
<RetrievalCode> s {Content}=""
</RetrievalCode>
</Data>
<Data name="Position">
<RetrievalCode> s {Position}=$s($d(^oddDEF({L1},"a",{L3},"u",{L5},24))#2:^(24),1:"body")
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddDEF({L1},"a",{L3},"u",{L5},11))#2:^(11),1:0)
</RetrievalCode>
</Data>
<Data name="TextType">
<RetrievalCode> s {TextType}=$s($d(^oddDEF({L1},"a",{L3},"u",{L5},22))#2:^(22),1:0)
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
<Subscript name="4">
<Expression>"u"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.PropertyUDLTextDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.PropertyUDL2866S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
