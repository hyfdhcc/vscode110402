Class %Dictionary.MethodDefinition Extends (%Persistent, %Dictionary.MethodDefinitionQuery) [ StorageStrategy = custom, System = 2 ]
{

/// Pointer to the containing parent object
Relationship parent As %Dictionary.ClassDefinition [ Cardinality = parent, Inverse = Methods ];

/// Specifies that this is an abstract method. An abstract method has no implementation and has no executable code generated for it. Abstract methods exist solely for the purpose of defining a method signature or interface that can be overridden and implemented within one or more subclasses. 
Property Abstract As %Boolean [ InitialExpression = 0 ];

/// Specifies that the method is a class method.  Instance methods can only be invoked via an instantiated object while class methods can be directly invoked without an object instance. 
Property ClassMethod As %Boolean [ InitialExpression = 0 ];

/// If true this method is only available on the server, and is to be projected as a client method.
Property ClientMethod As %Boolean [ InitialExpression = 0 ];

/// ClientName
Property ClientName As %CacheString;

/// Specifies how a given method is implemented: as a routine call, lines of code to be compiled, an expression, or a method that will generate the resulting method or object.
Property CodeMode As %CacheString [ InitialExpression = "code" ];

/// True if this method is deprecated.
Property Deprecated As %Boolean [ InitialExpression = 0 ];

/// Specifies a description of the method.
Property Description As %CacheString;

/// Specifies the SQL procedure name in the foreign database.
Property ExternalProcName As %CacheString;

/// Specifies that subclasses cannot override the implementation of the method.
Property Final As %Boolean [ InitialExpression = 0 ];

/// When true we always regenerate this method into each subclass even if normal rules would allow us to call the superclass implementation.
Property ForceGenerate As %Boolean [ InitialExpression = 0 ];

/// Specifies the list of arguments. Each argument is of the format [&amp;|*]&lt;name&gt;[:&lt;type&gt;][=&lt;default&gt;] where &amp; means pass-by-reference and * means output-only.
Property FormalSpec As %CacheString;

/// In the case of a method generator method, specifies that the generator should be invoked after the listed methods are generated.
Property GenerateAfter As %CacheString;

/// Hash
Property Hash As %CacheString;

/// The code that is executed when the method is invoked. In the case of an expression method, this is an expression. In the case of a call method, this is the name of a Cache routine to call.
Property Implementation As %Stream.TmpCharacter;

/// If true, then do not display this item in automatic documentation.
Property Internal As %Boolean [ InitialExpression = 0 ];

/// The language used to implement this method.
Property Language As %CacheString [ SqlFieldName = _Language ];

/// The name of the method.
Property Name As %Dictionary.CacheIdentifier [ Required ];

/// If true and in a datatype method, this prevents the * Set %val=..prop Set $this=&quot;&quot; * that is added to the property method so you can override things like the Get/Set methods.
Property NoContext As %Boolean [ InitialExpression = 0 ];

/// Deprecated.
Property NotForProperty As %Boolean [ InitialExpression = 0 ];

/// Specifies that this method is not inherited in subclasses.
Property NotInheritable As %Boolean [ InitialExpression = 0 ];

/// Specifies that the class compiler should place this method after the listed methods in the routine it creates for the class.
Property PlaceAfter As %CacheString;

/// Specifies that the method is private. Private methods can only be invoked by instance methods of this class or its subclasses.
Property Private As %Boolean [ InitialExpression = 0 ];

/// Specifies that this method uses procedure block for method code.
Property ProcedureBlock As %CacheString;

/// Specifies the public list.  This keyword is used only if the ProcedureBlock keyword is set to true.
Property PublicList As %CacheString;

/// If true this method may return zero, one, or more Resultsets in the %sqlcontext.
Property ReturnResultsets As %Boolean [ InitialExpression = 0 ];

/// Specifies the data type of the value returned by a call to the method. Setting ReturnType to an empty string specifies that there is no return value.
Property ReturnType As %Dictionary.CacheClassname;

/// A comma separated list of any parameters on the ReturnType keyword.
Property ReturnTypeParams As %CacheString;

/// SequenceNumber
Property SequenceNumber As %Integer [ InitialExpression = 0 ];

/// Specifies that a method will not be projected to a Java or C++ client.
Property ServerOnly As %CacheString;

/// Lets you specify the HTTP SOAP action that must be used when invoking this web service method as a web method. For SOAP 1.1, the SOAP action is obtained from the SOAPAction HTTP header. For SOAP 1.2, it is obtained from the Content-Type HTTP header.
Property SoapAction As %CacheString [ InitialExpression = "[default]" ];

/// Specifies what type of SOAP invocation is used for a web method. This keyword is ignored for non-web methods.
Property SoapBindingStyle As %CacheString;

/// Specifies what kind of SOAP encoding is used for the inputs and outputs of a web method. This keyword is ignored for non-web methods.
Property SoapBodyUse As %CacheString;

/// Specifies the name of the child element of the body of the response message for a web service method.
Property SoapMessageName As %CacheString;

/// Overrides the SOAPNAMESPACE class parameter for this web service or web service client.
Property SoapNameSpace As %CacheString;

///  This keyword will reflects the expected element name for top element of the SOAP body in the SOAP request.  This element is needed to distinguish between multiple requests which have the same SoapAction but different top level body elements.
Property SoapRequestMessage As %CacheString;

/// Overrides the SOAPTYPENAMESPACE class parameter for this web service or web service client.
Property SoapTypeNameSpace As %CacheString;

/// If this method is projected as an SQL stored procedure, then this name is used as the name of the stored procedure.
Property SqlName As %CacheString;

/// Specifies that the method can be invoked as an SQL stored procedure. Only class methods can be called as SQL stored procedures.
Property SqlProc As %Boolean [ InitialExpression = 0 ];

/// If &#39;procedure&#39; then this is equivalent to SqlProc keyword and means class method can be called as an SQL procedure. If &#39;function&#39; then this class method can be called as an SQL function.
Property SqlRoutine As %CacheString;

/// Specifies that a method can be invoked as a web method using the SOAP protocol.
Property WebMethod As %Boolean [ InitialExpression = 0 ];

/// Specifies that the method should be projected to the web client for use in the Zen framework.
Property ZenMethod As %Boolean [ InitialExpression = 0 ];

ClassMethod CodeModeIsValid(val As %String) As %Status
{
 i val="call" q $$$OK
 i val="code" q $$$OK
 i val="expression" q $$$OK
 i val="generator" q $$$OK
 i val="objectgenerator" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.MethodDefinition:CodeMode",val)
}

ClassMethod ProcedureBlockIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="0" q $$$OK
 i val="1" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.MethodDefinition:ProcedureBlock",val)
}

ClassMethod ServerOnlyIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="0" q $$$OK
 i val="1" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.MethodDefinition:ServerOnly",val)
}

ClassMethod SoapBindingStyleIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="document" q $$$OK
 i val="rpc" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.MethodDefinition:SoapBindingStyle",val)
}

ClassMethod SoapBodyUseIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="literal" q $$$OK
 i val="encoded" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.MethodDefinition:SoapBodyUse",val)
}

ClassMethod SqlRoutineIsValid(val As %String) As %Status
{
 i val="" q $$$OK
 i val="procedure" q $$$OK
 i val="function" q $$$OK
 q $$$ERROR($$$DatatypeValidationFailed,"%Dictionary.MethodDefinition:SqlRoutine",val)
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
 i $$$defMemberDefined(name1,$$$cCLASSmethod,name2) QUIT 1
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
 i (name1="")||(name2="")||('$$$defMemberDefined(name1,$$$cCLASSmethod,name2)) s sc=$$$ERROR($$$LoadObjectNotFound,$classname(),id)
 i $$$ISOK(sc),$$$defClassKeyGet(name1,$$$cCLASSdeployed)=2 s sc=$$$ERROR($$$ClassIsStub,name1)
 i $$$ISOK(sc),$$$defClassVersionGet(name1)'=$$$CLASSDEFINITIONVERSION s sc=$$$ERROR($$$OneClassDictionaryVersionMismatch,name1)
 i $$$ISOK(sc) d
 . s i%parent=$p(id,"||",1,1)
 . s i%Name=name2
 . s i%Abstract=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHabstract)
 . s i%ClassMethod=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHclassmethod)
 . s i%ClientMethod=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHclientmethod)
 . s i%ClientName=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHclientname)
 . s i%CodeMode=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHcodemode)
 . s i%Deprecated=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHdeprecated)
 . s i%Description=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHdescription)
 . s i%ExternalProcName=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHexternalprocname)
 . s i%Final=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHfinal)
 . s i%ForceGenerate=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHforcegenerate)
 . s i%FormalSpec=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHformalspec)
 . s i%GenerateAfter=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHgenerateafter)
 . s i%Hash=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHhash)
 . s i%Internal=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHinternal)
 . s i%Language=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHlanguage)
 . s i%NoContext=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHnocontext)
 . s i%NotForProperty=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHnotforproperty)
 . s i%NotInheritable=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHnotinheritable)
 . s i%PlaceAfter=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHplaceafter)
 . s i%Private=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHprivate)
 . s i%ProcedureBlock=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHprocedureblock)
 . s i%PublicList=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHpubliclist)
 . s i%ReturnResultsets=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHreturnresultsets)
 . s i%ReturnType=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHreturntype)
 . s i%ReturnTypeParams=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHreturntypeparams)
 . s i%SequenceNumber=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsequencenumber)
 . s i%ServerOnly=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHserveronly)
 . s i%SoapAction=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapaction)
 . s i%SoapBindingStyle=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbindingstyle)
 . s i%SoapBodyUse=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbodyuse)
 . s i%SoapMessageName=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapmessagename)
 . s i%SoapNameSpace=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapnamespace)
 . s i%SoapRequestMessage=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoaprequestmessage)
 . s i%SoapTypeNameSpace=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsoaptypenamespace)
 . s i%SqlName=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlname)
 . s i%SqlProc=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlproc)
 . s i%SqlRoutine=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlroutine)
 . s i%WebMethod=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHwebmethod)
 . s i%ZenMethod=$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHzenmethod)
 . s i%Implementation=""
 . f ptr=1:1:$$$defMemberKeyGet(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation) d
 . . d ..Implementation.WriteLine($$$defMemberArrayGet(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation,ptr))
 . d ..Implementation.Rewind()
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
 . i '($$$defMemberDefined(name1,$$$cCLASSmethod,name2)) s insert=1 q
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . $$$defMemberSet(name1,$$$cCLASSmethod,name2,"")
 . i i%Abstract=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHabstract) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHabstract,i%Abstract) }
 . i i%ClassMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHclassmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHclassmethod,i%ClassMethod) }
 . i i%ClientMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHclientmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHclientmethod,i%ClientMethod) }
 . i i%ClientName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHclientname) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHclientname,i%ClientName) }
 . i i%CodeMode="code" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHcodemode) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHcodemode,i%CodeMode) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHdescription,i%Description) }
 . i i%ExternalProcName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHexternalprocname) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHexternalprocname,i%ExternalProcName) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHfinal,i%Final) }
 . i i%ForceGenerate=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHforcegenerate) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHforcegenerate,i%ForceGenerate) }
 . i i%FormalSpec="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHformalspec) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHformalspec,i%FormalSpec) }
 . i i%GenerateAfter="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHgenerateafter) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHgenerateafter,i%GenerateAfter) }
 . i i%Hash="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHhash) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHhash,i%Hash) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHinternal,i%Internal) }
 . i i%Language="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHlanguage) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHlanguage,i%Language) }
 . i i%NoContext=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHnocontext) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHnocontext,i%NoContext) }
 . i i%NotForProperty=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHnotforproperty) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHnotforproperty,i%NotForProperty) }
 . i i%NotInheritable=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHnotinheritable) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHnotinheritable,i%NotInheritable) }
 . i i%PlaceAfter="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHplaceafter) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHplaceafter,i%PlaceAfter) }
 . i i%Private=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHprivate) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHprivate,i%Private) }
 . i i%ProcedureBlock="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHprocedureblock) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHprocedureblock,i%ProcedureBlock) }
 . i i%PublicList="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHpubliclist) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHpubliclist,i%PublicList) }
 . i i%ReturnResultsets=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHreturnresultsets) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHreturnresultsets,i%ReturnResultsets) }
 . i i%ReturnType="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHreturntype) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHreturntype,i%ReturnType) }
 . i i%ReturnTypeParams="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHreturntypeparams) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHreturntypeparams,i%ReturnTypeParams) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsequencenumber,i%SequenceNumber) }
 . i i%ServerOnly="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHserveronly) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHserveronly,i%ServerOnly) }
 . i i%SoapAction="[default]" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapaction) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapaction,i%SoapAction) }
 . i i%SoapBindingStyle="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbindingstyle) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbindingstyle,i%SoapBindingStyle) }
 . i i%SoapBodyUse="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbodyuse) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbodyuse,i%SoapBodyUse) }
 . i i%SoapMessageName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapmessagename) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapmessagename,i%SoapMessageName) }
 . i i%SoapNameSpace="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapnamespace) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapnamespace,i%SoapNameSpace) }
 . i i%SoapRequestMessage="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoaprequestmessage) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoaprequestmessage,i%SoapRequestMessage) }
 . i i%SoapTypeNameSpace="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoaptypenamespace) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoaptypenamespace,i%SoapTypeNameSpace) }
 . i i%SqlName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsqlname) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlname,i%SqlName) }
 . i i%SqlProc=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsqlproc) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlproc,i%SqlProc) }
 . i i%SqlRoutine="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsqlroutine) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlroutine,i%SqlRoutine) }
 . i i%WebMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHwebmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHwebmethod,i%WebMethod) }
 . i i%ZenMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHzenmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHzenmethod,i%ZenMethod) }
 . $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation)
 . d ..Implementation.Rewind() s ..Implementation.LineTerminator=$c(10)
 . f line=1:1 q:..Implementation.AtEnd  d
 . . s linetext=..Implementation.ReadLine($$$MaxLocalLength) i $e(linetext,*)=$c(13) s linetext=$e(linetext,1,*-1)
 . . $$$defMemberArraySet(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation,line,linetext)
 . $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation,line-1)
 i insert DO
 . i 'idassigned s id=i%parent_"||"_i%Name i 1
 . e  i $s(i%parent'=$p(id,"||",1,1):1,i%Name'=$p(id,"||",2):1,1:0) s sc=$$$ERROR($$$OidPreviouslyAssigned,$classname(),id) q
 . s name1=$p(id,"||",1),name2=$p(id,"||",2)
 . i ..%Concurrency s sc=..%LockId(id) s lock=$$$ISOK(sc) i 'lock q
 . i $$$defMemberDefined(name1,$$$cCLASSmethod,name2) s sc=$$$ERROR($$$IDKeyNotUnique,"%Dictionary.MethodDefinition",$zreference,"") q
 . i 'idassigned s sc=..%IdSet(id) q:$$$ISERR(sc)  s:$$$txON $$$txOIDASSIGNED($this)=""
 . $$$defMemberSet(name1,$$$cCLASSmethod,name2,"")
 . i i%Abstract=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHabstract) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHabstract,i%Abstract) }
 . i i%ClassMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHclassmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHclassmethod,i%ClassMethod) }
 . i i%ClientMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHclientmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHclientmethod,i%ClientMethod) }
 . i i%ClientName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHclientname) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHclientname,i%ClientName) }
 . i i%CodeMode="code" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHcodemode) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHcodemode,i%CodeMode) }
 . i i%Deprecated=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHdeprecated) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHdeprecated,i%Deprecated) }
 . i i%Description="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHdescription) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHdescription,i%Description) }
 . i i%ExternalProcName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHexternalprocname) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHexternalprocname,i%ExternalProcName) }
 . i i%Final=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHfinal) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHfinal,i%Final) }
 . i i%ForceGenerate=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHforcegenerate) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHforcegenerate,i%ForceGenerate) }
 . i i%FormalSpec="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHformalspec) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHformalspec,i%FormalSpec) }
 . i i%GenerateAfter="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHgenerateafter) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHgenerateafter,i%GenerateAfter) }
 . i i%Hash="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHhash) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHhash,i%Hash) }
 . i i%Internal=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHinternal) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHinternal,i%Internal) }
 . i i%Language="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHlanguage) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHlanguage,i%Language) }
 . i i%NoContext=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHnocontext) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHnocontext,i%NoContext) }
 . i i%NotForProperty=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHnotforproperty) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHnotforproperty,i%NotForProperty) }
 . i i%NotInheritable=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHnotinheritable) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHnotinheritable,i%NotInheritable) }
 . i i%PlaceAfter="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHplaceafter) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHplaceafter,i%PlaceAfter) }
 . i i%Private=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHprivate) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHprivate,i%Private) }
 . i i%ProcedureBlock="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHprocedureblock) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHprocedureblock,i%ProcedureBlock) }
 . i i%PublicList="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHpubliclist) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHpubliclist,i%PublicList) }
 . i i%ReturnResultsets=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHreturnresultsets) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHreturnresultsets,i%ReturnResultsets) }
 . i i%ReturnType="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHreturntype) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHreturntype,i%ReturnType) }
 . i i%ReturnTypeParams="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHreturntypeparams) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHreturntypeparams,i%ReturnTypeParams) }
 . i i%SequenceNumber=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsequencenumber) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsequencenumber,i%SequenceNumber) }
 . i i%ServerOnly="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHserveronly) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHserveronly,i%ServerOnly) }
 . i i%SoapAction="[default]" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapaction) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapaction,i%SoapAction) }
 . i i%SoapBindingStyle="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbindingstyle) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbindingstyle,i%SoapBindingStyle) }
 . i i%SoapBodyUse="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbodyuse) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapbodyuse,i%SoapBodyUse) }
 . i i%SoapMessageName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapmessagename) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapmessagename,i%SoapMessageName) }
 . i i%SoapNameSpace="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoapnamespace) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoapnamespace,i%SoapNameSpace) }
 . i i%SoapRequestMessage="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoaprequestmessage) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoaprequestmessage,i%SoapRequestMessage) }
 . i i%SoapTypeNameSpace="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsoaptypenamespace) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsoaptypenamespace,i%SoapTypeNameSpace) }
 . i i%SqlName="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsqlname) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlname,i%SqlName) }
 . i i%SqlProc=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsqlproc) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlproc,i%SqlProc) }
 . i i%SqlRoutine="" { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHsqlroutine) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHsqlroutine,i%SqlRoutine) }
 . i i%WebMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHwebmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHwebmethod,i%WebMethod) }
 . i i%ZenMethod=0 { $$$defMemberKeyKill(name1,$$$cCLASSmethod,name2,$$$cMETHzenmethod) } else { $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHzenmethod,i%ZenMethod) }
 . d ..Implementation.Rewind() s ..Implementation.LineTerminator=$c(10)
 . f line=1:1 q:..Implementation.AtEnd  d
 . . s linetext=..Implementation.ReadLine($$$MaxLocalLength) i $e(linetext,*)=$c(13) s linetext=$e(linetext,1,*-1)
 . . $$$defMemberArraySet(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation,line,linetext)
 . $$$defMemberKeySet(name1,$$$cCLASSmethod,name2,$$$cMETHimplementation,line-1)
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
 If '$$$GetddlNo30,'($$$defMemberDefined(name1,$$$cCLASSmethod,name2)) Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),id)
 If $$$ISOK(sc) $$$defMemberKill(name1,$$$cCLASSmethod,name2) Do UpdClsDef^%occLibrary(name1)
 If concurrency Do ..%UnlockId(id)
 Quit sc
}

Storage custom
{
<SQLMap name="Master">
<Data name="Abstract">
<RetrievalCode> s {Abstract}=$s($d(^oddDEF({L1},"m",{L3},21))#2:^(21),1:0)
</RetrievalCode>
</Data>
<Data name="ClassMethod">
<RetrievalCode> s {ClassMethod}=$s($d(^oddDEF({L1},"m",{L3},23))#2:^(23),1:0)
</RetrievalCode>
</Data>
<Data name="ClientMethod">
<RetrievalCode> s {ClientMethod}=$s($d(^oddDEF({L1},"m",{L3},70))#2:^(70),1:0)
</RetrievalCode>
</Data>
<Data name="ClientName">
<RetrievalCode> s {ClientName}=$s($d(^oddDEF({L1},"m",{L3},24))#2:^(24),1:"")
</RetrievalCode>
</Data>
<Data name="CodeMode">
<RetrievalCode> s {CodeMode}=$s($d(^oddDEF({L1},"m",{L3},25))#2:^(25),1:"code")
</RetrievalCode>
</Data>
<Data name="Deprecated">
<RetrievalCode> s {Deprecated}=$s($d(^oddDEF({L1},"m",{L3},17))#2:^(17),1:0)
</RetrievalCode>
</Data>
<Data name="Description">
<RetrievalCode> s {Description}=$s($d(^oddDEF({L1},"m",{L3},4))#2:^(4),1:"")
</RetrievalCode>
</Data>
<Data name="ExternalProcName">
<RetrievalCode> s {ExternalProcName}=$s($d(^oddDEF({L1},"m",{L3},63))#2:^(63),1:"")
</RetrievalCode>
</Data>
<Data name="Final">
<RetrievalCode> s {Final}=$s($d(^oddDEF({L1},"m",{L3},7))#2:^(7),1:0)
</RetrievalCode>
</Data>
<Data name="ForceGenerate">
<RetrievalCode> s {ForceGenerate}=$s($d(^oddDEF({L1},"m",{L3},71))#2:^(71),1:0)
</RetrievalCode>
</Data>
<Data name="FormalSpec">
<RetrievalCode> s {FormalSpec}=$s($d(^oddDEF({L1},"m",{L3},27))#2:^(27),1:"")
</RetrievalCode>
</Data>
<Data name="GenerateAfter">
<RetrievalCode> s {GenerateAfter}=$s($d(^oddDEF({L1},"m",{L3},29))#2:^(29),1:"")
</RetrievalCode>
</Data>
<Data name="Hash">
<RetrievalCode> s {Hash}=$s($d(^oddDEF({L1},"m",{L3},66))#2:^(66),1:"")
</RetrievalCode>
</Data>
<Data name="Implementation">
<RetrievalCode> s {Implementation}=""
</RetrievalCode>
</Data>
<Data name="Internal">
<RetrievalCode> s {Internal}=$s($d(^oddDEF({L1},"m",{L3},14))#2:^(14),1:0)
</RetrievalCode>
</Data>
<Data name="NoContext">
<RetrievalCode> s {NoContext}=$s($d(^oddDEF({L1},"m",{L3},33))#2:^(33),1:0)
</RetrievalCode>
</Data>
<Data name="NotForProperty">
<RetrievalCode> s {NotForProperty}=$s($d(^oddDEF({L1},"m",{L3},34))#2:^(34),1:0)
</RetrievalCode>
</Data>
<Data name="NotInheritable">
<RetrievalCode> s {NotInheritable}=$s($d(^oddDEF({L1},"m",{L3},9))#2:^(9),1:0)
</RetrievalCode>
</Data>
<Data name="PlaceAfter">
<RetrievalCode> s {PlaceAfter}=$s($d(^oddDEF({L1},"m",{L3},38))#2:^(38),1:"")
</RetrievalCode>
</Data>
<Data name="Private">
<RetrievalCode> s {Private}=$s($d(^oddDEF({L1},"m",{L3},39))#2:^(39),1:0)
</RetrievalCode>
</Data>
<Data name="ProcedureBlock">
<RetrievalCode> s {ProcedureBlock}=$s($d(^oddDEF({L1},"m",{L3},40))#2:^(40),1:"")
</RetrievalCode>
</Data>
<Data name="PublicList">
<RetrievalCode> s {PublicList}=$s($d(^oddDEF({L1},"m",{L3},41))#2:^(41),1:"")
</RetrievalCode>
</Data>
<Data name="ReturnResultsets">
<RetrievalCode> s {ReturnResultsets}=$s($d(^oddDEF({L1},"m",{L3},64))#2:^(64),1:0)
</RetrievalCode>
</Data>
<Data name="ReturnType">
<RetrievalCode> s {ReturnType}=$s($d(^oddDEF({L1},"m",{L3},42))#2:^(42),1:"")
</RetrievalCode>
</Data>
<Data name="ReturnTypeParams">
<RetrievalCode> s {ReturnTypeParams}=$s($d(^oddDEF({L1},"m",{L3},62))#2:^(62),1:"")
</RetrievalCode>
</Data>
<Data name="SequenceNumber">
<RetrievalCode> s {SequenceNumber}=$s($d(^oddDEF({L1},"m",{L3},11))#2:^(11),1:0)
</RetrievalCode>
</Data>
<Data name="ServerOnly">
<RetrievalCode> s {ServerOnly}=$s($d(^oddDEF({L1},"m",{L3},59))#2:^(59),1:"")
</RetrievalCode>
</Data>
<Data name="SoapAction">
<RetrievalCode> s {SoapAction}=$s($d(^oddDEF({L1},"m",{L3},67))#2:^(67),1:"[default]")
</RetrievalCode>
</Data>
<Data name="SoapBindingStyle">
<RetrievalCode> s {SoapBindingStyle}=$s($d(^oddDEF({L1},"m",{L3},53))#2:^(53),1:"")
</RetrievalCode>
</Data>
<Data name="SoapBodyUse">
<RetrievalCode> s {SoapBodyUse}=$s($d(^oddDEF({L1},"m",{L3},54))#2:^(54),1:"")
</RetrievalCode>
</Data>
<Data name="SoapMessageName">
<RetrievalCode> s {SoapMessageName}=$s($d(^oddDEF({L1},"m",{L3},68))#2:^(68),1:"")
</RetrievalCode>
</Data>
<Data name="SoapNameSpace">
<RetrievalCode> s {SoapNameSpace}=$s($d(^oddDEF({L1},"m",{L3},61))#2:^(61),1:"")
</RetrievalCode>
</Data>
<Data name="SoapRequestMessage">
<RetrievalCode> s {SoapRequestMessage}=$s($d(^oddDEF({L1},"m",{L3},73))#2:^(73),1:"")
</RetrievalCode>
</Data>
<Data name="SoapTypeNameSpace">
<RetrievalCode> s {SoapTypeNameSpace}=$s($d(^oddDEF({L1},"m",{L3},65))#2:^(65),1:"")
</RetrievalCode>
</Data>
<Data name="SqlName">
<RetrievalCode> s {SqlName}=$s($d(^oddDEF({L1},"m",{L3},45))#2:^(45),1:"")
</RetrievalCode>
</Data>
<Data name="SqlProc">
<RetrievalCode> s {SqlProc}=$s($d(^oddDEF({L1},"m",{L3},46))#2:^(46),1:0)
</RetrievalCode>
</Data>
<Data name="SqlRoutine">
<RetrievalCode> s {SqlRoutine}=$s($d(^oddDEF({L1},"m",{L3},74))#2:^(74),1:"")
</RetrievalCode>
</Data>
<Data name="WebMethod">
<RetrievalCode> s {WebMethod}=$s($d(^oddDEF({L1},"m",{L3},51))#2:^(51),1:0)
</RetrievalCode>
</Data>
<Data name="ZenMethod">
<RetrievalCode> s {ZenMethod}=$s($d(^oddDEF({L1},"m",{L3},52))#2:^(52),1:0)
</RetrievalCode>
</Data>
<Data name="_Language">
<RetrievalCode> s {_Language}=$s($d(^oddDEF({L1},"m",{L3},32))#2:^(32),1:"")
</RetrievalCode>
</Data>
<Global>^oddDEF</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{%Dictionary.ClassDefinition.Name}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"m"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{%Dictionary.MethodDefinition.Name}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^%Dictionary.MethodDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
