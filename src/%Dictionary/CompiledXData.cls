Class %Dictionary.CompiledXData Extends (%Persistent, %Dictionary.CompiledXDataQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledClass [ Cardinality = parent, Inverse = XDatas ];

/// The data stream.
Property Data As %Stream.TmpCharacter;

/// True if this XDATA is deprecated.
Property Deprecated As %Boolean;

/// Specifies a description of the XData.
Property Description As %CacheString;

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Mime type of XData block.
Property MimeType As %CacheString;

/// The name of the xData block.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Origin
Property Origin As %CacheString;

/// The schema definition of the data.
Property SchemaSpec As %CacheString;

/// SequenceNumber
Property SequenceNumber As %Integer;

/// The default XML NameSpace for the XDATA.
Property XMLNamespace As %CacheString;

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

/// The object representation of this XData block after correlating the XML and importing it
Property Object As %RegisteredObject [ Calculated ];

Method ObjectGet() As %RegisteredObject
{
 q ##class(%Studio.SASchemaUtil).returnCorrelated($this)
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
 i $$$comMemberDefined(name1,$$$cCLASSxdata,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$comMemberDefined(name1,$$$cCLASSxdata,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Deprecated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAdeprecated)
 . s i%Description=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAdescription)
 . s i%Internal=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAinternal)
 . s i%KeywordError=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAkeyworderror)
 . s i%KeywordModified=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAkeywordmodified)
 . s i%MimeType=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAmimetype)
 . s i%Origin=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAorigin)
 . s i%SchemaSpec=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAschemaspec)
 . s i%SequenceNumber=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAsequencenumber)
 . s i%XMLNamespace=$$$comMemberKeyGetO(origin,name1,$$$cCLASSxdata,name2,$$$cXDATAxmlnamespace)
 . s i%Data=""
 . f ptr=1:1:$$$comMemberKeyGet(name1,$$$cCLASSxdata,name2,$$$cXDATAdata) d
 . . d ..Data.WriteLine($$$comMemberArrayGet(name1,$$$cCLASSxdata,name2,$$$cXDATAdata,ptr))
 . d ..Data.Rewind()
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
<Data name="Data">
<RetrievalCode> s {Data}=""
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddCOM({L1},"x",{L3},17))#2:^(17),$d(^oddCOM($g(^(2),{L1}),"x",{L3},17))#2:^(17),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},17))#2:^(17),1:0))
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddCOM({L1},"x",{L3},4))#2:^(4),$d(^oddCOM($g(^(2),{L1}),"x",{L3},4))#2:^(4),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},4))#2:^(4),1:""))
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddCOM({L1},"x",{L3},14))#2:^(14),$d(^oddCOM($g(^(2),{L1}),"x",{L3},14))#2:^(14),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},14))#2:^(14),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$s($d(^oddCOM({L1},"x",{L3},12))#2:^(12),$d(^oddCOM($g(^(2),{L1}),"x",{L3},12))#2:^(12),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},12))#2:^(12),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$s($d(^oddCOM({L1},"x",{L3},13))#2:^(13),$d(^oddCOM($g(^(2),{L1}),"x",{L3},13))#2:^(13),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},13))#2:^(13),1:0))
</RetrievalCode>
</Data>
<Data name="MimeType">
<RetrievalCode> s {MimeType}=$s($d(^oddCOM({L1},"x",{L3},24))#2:^(24),$d(^oddCOM($g(^(2),{L1}),"x",{L3},24))#2:^(24),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},24))#2:^(24),1:"text/xml"))
</RetrievalCode>
</Data>
<Data name="Origin">
<RetrievalCode> s {Origin}=$s($d(^oddCOM({L1},"x",{L3},2))#2:^(2),$d(^oddCOM($g(^(2),{L1}),"x",{L3},2))#2:^(2),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},2))#2:^(2),1:""))
</RetrievalCode>
</Data>
<Data name="SchemaSpec">
<RetrievalCode> s {SchemaSpec}=$s($d(^oddCOM({L1},"x",{L3},22))#2:^(22),$d(^oddCOM($g(^(2),{L1}),"x",{L3},22))#2:^(22),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},22))#2:^(22),1:""))
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddCOM({L1},"x",{L3},11))#2:^(11),$d(^oddCOM($g(^(2),{L1}),"x",{L3},11))#2:^(11),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},11))#2:^(11),1:0))
</RetrievalCode>
</Data>
<Data name="XMLNamespace">
<RetrievalCode> s {XMLNamespace}=$s($d(^oddCOM({L1},"x",{L3},23))#2:^(23),$d(^oddCOM($g(^(2),{L1}),"x",{L3},23))#2:^(23),1:$s($d(^oddDEF($g(^oddCOM({L1},"x",{L3},2),{L1}),"x",{L3},23))#2:^(23),1:""))
</RetrievalCode>
</Data>
<Global>^oddCOM</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.CompiledClass.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"x"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.CompiledXData.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledXDataS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
