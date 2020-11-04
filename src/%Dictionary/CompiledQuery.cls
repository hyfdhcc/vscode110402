Class %Dictionary.CompiledQuery Extends (%Persistent, %Dictionary.CompiledQueryQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.CompiledClass [ Cardinality = parent, Inverse = Queries ];

/// Cardinality
Property Cardinality As %Integer;

/// ClientInfo
Property ClientInfo As %CacheString;

/// ClientName
Property ClientName As %CacheString;

/// ColCaptions
Property ColCaptions As %CacheString;

/// ColNames
Property ColNames As %CacheString;

/// CompilerGenerated
Property CompilerGenerated As %Boolean;

/// True if this query is deprecated.
Property Deprecated As %Boolean;

/// Specifies a description of the query.
Property Description As %CacheString;

/// ExtendedInfo
Property ExtendedInfo As %CacheString;

/// Specifies that subclasses cannot override the definition of the query.
Property Final As %Boolean;

/// Specifies the list of arguments passed to the Execute method. Each argument is of the format [&amp;|*]&lt;name&gt;[:&lt;type&gt;][=&lt;default&gt;] where &amp; means pass-by-reference and * means output-only.
Property FormalSpec As %CacheString;

/// FormalSpecParsed
Property FormalSpecParsed As %CacheString;

/// Id
Property Id As %Integer;

/// InheritedId
Property InheritedId As %Boolean;

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean;

/// KeywordError
Property KeywordError As %Boolean;

/// KeywordModified
Property KeywordModified As %Boolean;

/// Method
Relationship Methods As %Dictionary.CompiledQueryMethod [ Cardinality = children, Inverse = parent ];

/// The name of the query.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// Deprecated
Property NotInheritable As %Boolean;

/// Origin
Property Origin As %CacheString;

/// Parameter
Property Parameters As array Of %CacheString;

/// ParmNames
Property ParmNames As %CacheString;

/// Deprecated.
Property Private As %Boolean;

/// SequenceNumber
Property SequenceNumber As %Integer;

/// Specifies what type of SOAP invocation is used for a web method. This keyword is ignored for non-web methods.
Property SoapBindingStyle As %CacheString;

/// Specifies what kind of SOAP encoding is used for the inputs and outputs of a web method. This keyword is ignored for non-web methods.
Property SoapBodyUse As %CacheString;

/// SoapNameSpace
Property SoapNameSpace As %CacheString;

/// If this query is projected as an SQL stored procedure, then this name is used as the name of the stored procedure.
Property SqlName As %CacheString;

/// Specifies that the query can be invoked as an SQL stored procedure.
Property SqlProc As %Boolean;

/// Specifies an SQL statement to be used for an SQL-based query.
Property SqlQuery As %CacheString;

/// SqlQueryGen
Property SqlQueryGen As %CacheString;

/// Specifies whether to project this query as an SQL View.
Property SqlView As %Boolean;

/// Specifies an SQL alias for the view projected from this query.
Property SqlViewName As %CacheString;

/// Specifies the Query class used to provide the implementation of the query interface.
Property Type As %Dictionary.CacheClassname;

/// UserActualType
Property UserActualType As %CacheString;

/// description=Specifies that this query can be invoked using the SOAP protocol. 
Property WebMethod As %Boolean;

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
 i $$$comMemberDefined(name1,$$$cCLASSquery,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$comMemberDefined(name1,$$$cCLASSquery,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Cardinality=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYcardinality)
 . s i%ClientInfo=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYclientinfo)
 . s i%ClientName=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYclientname)
 . s i%ColCaptions=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYcolcaptions)
 . s i%ColNames=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYcolnames)
 . s i%CompilerGenerated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYcompilergenerated)
 . s i%Deprecated=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYdeprecated)
 . s i%Description=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYdescription)
 . s i%ExtendedInfo=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYextendedinfo)
 . s i%Final=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYfinal)
 . s i%FormalSpec=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYformalspec)
 . s i%FormalSpecParsed=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYformalspecparsed)
 . s i%Id=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYid)
 . s i%InheritedId=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYinheritedid)
 . s i%Internal=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYinternal)
 . s i%KeywordError=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYkeyworderror)
 . s i%KeywordModified=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYkeywordmodified)
 . s i%NotInheritable=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYnotinheritable)
 . s i%Origin=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYorigin)
 . s i%ParmNames=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYparmnames)
 . s i%Private=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYprivate)
 . s i%SequenceNumber=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsequencenumber)
 . s i%SoapBindingStyle=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsoapbindingstyle)
 . s i%SoapBodyUse=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsoapbodyuse)
 . s i%SoapNameSpace=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsoapnamespace)
 . s i%SqlName=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsqlname)
 . s i%SqlProc=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsqlproc)
 . s i%SqlQuery=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsqlquery)
 . s i%SqlQueryGen=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsqlquerygen)
 . s i%SqlView=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsqlview)
 . s i%SqlViewName=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYsqlviewname)
 . s i%Type=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYtype)
 . s i%UserActualType=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYuseractualtype)
 . s i%WebMethod=$$$comMemberKeyGetO(origin,name1,$$$cCLASSquery,name2,$$$cQUERYwebmethod)
 . s sub="" f  s sub=$$$comSubMemberNext(name1,$$$cCLASSquery,name2,$$$cQUERYparameter,sub) q:sub=""  d
 . . d ..Parameters.SetAt($$$comMemberArrayGet(name1,$$$cCLASSquery,name2,$$$cQUERYparameter,sub),sub)
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
<Data name="Cardinality">
<RetrievalCode> s {Cardinality}=$s($d(^oddCOM({L1},"q",{L3},40))#2:^(40),$d(^oddCOM($g(^(2),{L1}),"q",{L3},40))#2:^(40),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},40))#2:^(40),1:0))
</RetrievalCode>
</Data>
<Data name="ClientInfo">
<RetrievalCode> s {ClientInfo}=$s($d(^oddCOM({L1},"q",{L3},21))#2:^(21),$d(^oddCOM($g(^(2),{L1}),"q",{L3},21))#2:^(21),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},21))#2:^(21),1:""))
</RetrievalCode>
</Data>
<Data name="ClientName">
<RetrievalCode> s {ClientName}=$s($d(^oddCOM({L1},"q",{L3},41))#2:^(41),$d(^oddCOM($g(^(2),{L1}),"q",{L3},41))#2:^(41),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},41))#2:^(41),1:""))
</RetrievalCode>
</Data>
<Data name="ColCaptions">
<RetrievalCode> s {ColCaptions}=$s($d(^oddCOM({L1},"q",{L3},22))#2:^(22),$d(^oddCOM($g(^(2),{L1}),"q",{L3},22))#2:^(22),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},22))#2:^(22),1:""))
</RetrievalCode>
</Data>
<Data name="ColNames">
<RetrievalCode> s {ColNames}=$s($d(^oddCOM({L1},"q",{L3},23))#2:^(23),$d(^oddCOM($g(^(2),{L1}),"q",{L3},23))#2:^(23),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},23))#2:^(23),1:""))
</RetrievalCode>
</Data>
<Data name="CompilerGenerated">
<RetrievalCode> s {CompilerGenerated}=$s($d(^oddCOM({L1},"q",{L3},10))#2:^(10),$d(^oddCOM($g(^(2),{L1}),"q",{L3},10))#2:^(10),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},10))#2:^(10),1:0))
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddCOM({L1},"q",{L3},17))#2:^(17),$d(^oddCOM($g(^(2),{L1}),"q",{L3},17))#2:^(17),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},17))#2:^(17),1:0))
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddCOM({L1},"q",{L3},4))#2:^(4),$d(^oddCOM($g(^(2),{L1}),"q",{L3},4))#2:^(4),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},4))#2:^(4),1:""))
</RetrievalCode>
</Data>
<Data name="ExtendedInfo">
<RetrievalCode> s {ExtendedInfo}=$s($d(^oddCOM({L1},"q",{L3},38))#2:^(38),$d(^oddCOM($g(^(2),{L1}),"q",{L3},38))#2:^(38),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},38))#2:^(38),1:""))
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddCOM({L1},"q",{L3},7))#2:^(7),$d(^oddCOM($g(^(2),{L1}),"q",{L3},7))#2:^(7),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},7))#2:^(7),1:0))
</RetrievalCode>
</Data>
<Data name="FormalSpec">
<RetrievalCode> s {FormalSpec}=$s($d(^oddCOM({L1},"q",{L3},24))#2:^(24),$d(^oddCOM($g(^(2),{L1}),"q",{L3},24))#2:^(24),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},24))#2:^(24),1:""))
</RetrievalCode>
</Data>
<Data name="FormalSpecParsed">
<RetrievalCode> s {FormalSpecParsed}=$s($d(^oddCOM({L1},"q",{L3},34))#2:^(34),$d(^oddCOM($g(^(2),{L1}),"q",{L3},34))#2:^(34),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},34))#2:^(34),1:""))
</RetrievalCode>
</Data>
<Data name="Id">
<RetrievalCode> s {Id}=$s($d(^oddCOM({L1},"q",{L3},6))#2:^(6),$d(^oddCOM($g(^(2),{L1}),"q",{L3},6))#2:^(6),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},6))#2:^(6),1:0))
</RetrievalCode>
</Data>
<Data name="InheritedId">
<RetrievalCode> s {InheritedId}=$s($d(^oddCOM({L1},"q",{L3},8))#2:^(8),$d(^oddCOM($g(^(2),{L1}),"q",{L3},8))#2:^(8),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},8))#2:^(8),1:0))
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddCOM({L1},"q",{L3},14))#2:^(14),$d(^oddCOM($g(^(2),{L1}),"q",{L3},14))#2:^(14),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},14))#2:^(14),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordError">
<RetrievalCode> s {KeywordError}=$s($d(^oddCOM({L1},"q",{L3},12))#2:^(12),$d(^oddCOM($g(^(2),{L1}),"q",{L3},12))#2:^(12),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},12))#2:^(12),1:0))
</RetrievalCode>
</Data>
<Data name="KeywordModified">
<RetrievalCode> s {KeywordModified}=$s($d(^oddCOM({L1},"q",{L3},13))#2:^(13),$d(^oddCOM($g(^(2),{L1}),"q",{L3},13))#2:^(13),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},13))#2:^(13),1:0))
</RetrievalCode>
</Data>
<Data name="NotInheritable">
<RetrievalCode> s {NotInheritable}=$s($d(^oddCOM({L1},"q",{L3},9))#2:^(9),$d(^oddCOM($g(^(2),{L1}),"q",{L3},9))#2:^(9),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},9))#2:^(9),1:0))
</RetrievalCode>
</Data>
<Data name="Origin">
<RetrievalCode> s {Origin}=$s($d(^oddCOM({L1},"q",{L3},2))#2:^(2),$d(^oddCOM($g(^(2),{L1}),"q",{L3},2))#2:^(2),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},2))#2:^(2),1:""))
</RetrievalCode>
</Data>
<Data name="Parameters">
<RetrievalCode> n sub s {Parameters}="",sub="" f  s sub=$o(^oddCOM({L1},"q",{L3},"P",sub)) q:sub=""  s {Parameters}={Parameters}_$lb($lb(sub,$s($d(^oddCOM({L1},"q",{L3},"P",sub))#2:^(sub),$d(^oddCOM($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},"P",sub))#2:^(sub),1:$g(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},"P",sub)))))
</RetrievalCode>
</Data>
<Data name="ParmNames">
<RetrievalCode> s {ParmNames}=$s($d(^oddCOM({L1},"q",{L3},25))#2:^(25),$d(^oddCOM($g(^(2),{L1}),"q",{L3},25))#2:^(25),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},25))#2:^(25),1:""))
</RetrievalCode>
</Data>
<Data name="Private">
<RetrievalCode> s {Private}=$s($d(^oddCOM({L1},"q",{L3},26))#2:^(26),$d(^oddCOM($g(^(2),{L1}),"q",{L3},26))#2:^(26),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},26))#2:^(26),1:0))
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddCOM({L1},"q",{L3},11))#2:^(11),$d(^oddCOM($g(^(2),{L1}),"q",{L3},11))#2:^(11),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},11))#2:^(11),1:0))
</RetrievalCode>
</Data>
<Data name="SoapBindingStyle">
<RetrievalCode> s {SoapBindingStyle}=$s($d(^oddCOM({L1},"q",{L3},35))#2:^(35),$d(^oddCOM($g(^(2),{L1}),"q",{L3},35))#2:^(35),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},35))#2:^(35),1:""))
</RetrievalCode>
</Data>
<Data name="SoapBodyUse">
<RetrievalCode> s {SoapBodyUse}=$s($d(^oddCOM({L1},"q",{L3},36))#2:^(36),$d(^oddCOM($g(^(2),{L1}),"q",{L3},36))#2:^(36),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},36))#2:^(36),1:""))
</RetrievalCode>
</Data>
<Data name="SoapNameSpace">
<RetrievalCode> s {SoapNameSpace}=$s($d(^oddCOM({L1},"q",{L3},37))#2:^(37),$d(^oddCOM($g(^(2),{L1}),"q",{L3},37))#2:^(37),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},37))#2:^(37),1:""))
</RetrievalCode>
</Data>
<Data name="SqlName">
<RetrievalCode> s {SqlName}=$s($d(^oddCOM({L1},"q",{L3},27))#2:^(27),$d(^oddCOM($g(^(2),{L1}),"q",{L3},27))#2:^(27),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},27))#2:^(27),1:""))
</RetrievalCode>
</Data>
<Data name="SqlProc">
<RetrievalCode> s {SqlProc}=$s($d(^oddCOM({L1},"q",{L3},28))#2:^(28),$d(^oddCOM($g(^(2),{L1}),"q",{L3},28))#2:^(28),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},28))#2:^(28),1:0))
</RetrievalCode>
</Data>
<Data name="SqlQuery">
<RetrievalCode> s {SqlQuery}=$s($d(^oddCOM({L1},"q",{L3},29))#2:^(29),$d(^oddCOM($g(^(2),{L1}),"q",{L3},29))#2:^(29),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},29))#2:^(29),1:""))
</RetrievalCode>
</Data>
<Data name="SqlQueryGen">
<RetrievalCode> s {SqlQueryGen}=$s($d(^oddCOM({L1},"q",{L3},39))#2:^(39),$d(^oddCOM($g(^(2),{L1}),"q",{L3},39))#2:^(39),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},39))#2:^(39),1:""))
</RetrievalCode>
</Data>
<Data name="SqlView">
<RetrievalCode> s {SqlView}=$s($d(^oddCOM({L1},"q",{L3},30))#2:^(30),$d(^oddCOM($g(^(2),{L1}),"q",{L3},30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},30))#2:^(30),1:0))
</RetrievalCode>
</Data>
<Data name="SqlViewName">
<RetrievalCode> s {SqlViewName}=$s($d(^oddCOM({L1},"q",{L3},31))#2:^(31),$d(^oddCOM($g(^(2),{L1}),"q",{L3},31))#2:^(31),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},31))#2:^(31),1:""))
</RetrievalCode>
</Data>
<Data name="Type">
<RetrievalCode> s {Type}=$s($d(^oddCOM({L1},"q",{L3},5))#2:^(5),$d(^oddCOM($g(^(2),{L1}),"q",{L3},5))#2:^(5),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},5))#2:^(5),1:""))
</RetrievalCode>
</Data>
<Data name="UserActualType">
<RetrievalCode> s {UserActualType}=$s($d(^oddCOM({L1},"q",{L3},32))#2:^(32),$d(^oddCOM($g(^(2),{L1}),"q",{L3},32))#2:^(32),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},32))#2:^(32),1:""))
</RetrievalCode>
</Data>
<Data name="WebMethod">
<RetrievalCode> s {WebMethod}=$s($d(^oddCOM({L1},"q",{L3},33))#2:^(33),$d(^oddCOM($g(^(2),{L1}),"q",{L3},33))#2:^(33),1:$s($d(^oddDEF($g(^oddCOM({L1},"q",{L3},2),{L1}),"q",{L3},33))#2:^(33),1:0))
</RetrievalCode>
</Data>
<Global>^oddCOM</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.CompiledClass.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"q"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.CompiledQuery.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.CompiledQueryS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
