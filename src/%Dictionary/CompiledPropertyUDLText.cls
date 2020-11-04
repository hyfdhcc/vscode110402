Class %Dictionary.CompiledPropertyUDLText Extends %Persistent [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledProperty [ Cardinality = parent, Inverse = UDLTexts ];

/// Category
Property Category As %CacheString;

/// Holds the content of the UDL text.
Property Content As %Stream.TmpCharacter;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Speficies the COS name of the UDL text.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Position
Property Position As %CacheString;

/// SequenceNumber
Property SequenceNumber As %Integer;

/// TextType
Property TextType As %Integer;

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
 i $$$comSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3) QUIT 1
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
 i (name1="")||(name2="")||(name3="")||('$$$comSubMemberDefined(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,2)
 . s i%Name=name3
 . s i%Category=$$$comSubMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcategory)
 . s i%KeywordError=$$$comSubMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTkeyworderror)
 . s i%KeywordModified=$$$comSubMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTkeywordmodified)
 . s i%Position=$$$comSubMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTposition)
 . s i%SequenceNumber=$$$comSubMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTsequencenumber)
 . s i%TextType=$$$comSubMemberKeyGetO(origin,name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTtexttype)
 . s i%Content=""
 . f ptr=1:1:$$$comSubMemberKeyGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent) d
 . . d ..Content.WriteLine($$$comSubMemberArrayGet(name1,$$$cCLASSproperty,name2,$$$cPROPudltext,name3,$$$cUDLTEXTcontent,ptr))
 . d ..Content.Rewind()
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
<Data name="Category">
<RetrievalCode> s {Category}=$s($d(^oddCOM({L1},"a",{L3},"u",{L5},23))#2:^(23),$d(^oddCOM($g(^(2),"*"),"u",{L5},23))#2:^(23),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},"u",{L5},2),"*"),"u",{L5},23))#2:^(23),1:"comment"))
</RetrievalCode>
</Data>
<Data name="Content">
<RetrievalCode> s {Content}=""
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$s($d(^oddCOM({L1},"a",{L3},"u",{L5},12))#2:^(12),$d(^oddCOM($g(^(2),"*"),"u",{L5},12))#2:^(12),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},"u",{L5},2),"*"),"u",{L5},12))#2:^(12),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$s($d(^oddCOM({L1},"a",{L3},"u",{L5},13))#2:^(13),$d(^oddCOM($g(^(2),"*"),"u",{L5},13))#2:^(13),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},"u",{L5},2),"*"),"u",{L5},13))#2:^(13),1:0))
</RetrievalCode>
</Data>
<Data name="Position">
<RetrievalCode> s {Position}=$s($d(^oddCOM({L1},"a",{L3},"u",{L5},24))#2:^(24),$d(^oddCOM($g(^(2),"*"),"u",{L5},24))#2:^(24),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},"u",{L5},2),"*"),"u",{L5},24))#2:^(24),1:"body"))
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddCOM({L1},"a",{L3},"u",{L5},11))#2:^(11),$d(^oddCOM($g(^(2),"*"),"u",{L5},11))#2:^(11),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},"u",{L5},2),"*"),"u",{L5},11))#2:^(11),1:0))
</RetrievalCode>
</Data>
<Data name="TextType">
<RetrievalCode> s {TextType}=$s($d(^oddCOM({L1},"a",{L3},"u",{L5},22))#2:^(22),$d(^oddCOM($g(^(2),"*"),"u",{L5},22))#2:^(22),1:$s($d(^oddDEF($g(^oddCOM({L1},"a",{L3},"u",{L5},2),"*"),"u",{L5},22))#2:^(22),1:0))
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
<Subscript name="4">
<Expression>"u"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{%Dictionary.CompiledPropertyUDLText.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledPro3DD9S</StreamLocation>
<Type>%CustomStorage</Type>
}

}
