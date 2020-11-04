/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>method</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.MethodDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A flag indicating if this method is abstract (1) or not (0).
Property Abstract As %CacheString;

/// A string containing the name of the class the method belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the method.
Property Name As %CacheString;

/// For call methods, a string containing the name of the routine to call.
Property Call As %CacheString [ Calculated ];

/// A flag indicating whether the method is a class method (1) or an instance method (0).
Property ClassMethod As %CacheString;

/// The implementation for the method.
Property Code As %CacheString [ Calculated ];

/// A string containing the code mode of the method.
Property CodeMode As %CacheString [ InitialExpression = "code" ];

/// A string containing the description of the method.
Property Description As %CacheString;

Property Expression As %CacheString [ Calculated ];

/// A flag indicating whether the method is final (1) or not (0).
Property Final As %CacheString;

/// A string containing the list of arguments for the method.
Property FormalSpec As %CacheString;

/// For a method generator, a string containing the name of another method generator 
/// which should be called before this one when compiling.
Property GenerateAfter As %CacheString;

/// The implementation of the method generator for this method.
Property Generator As %CacheString [ Calculated ];

/// The implementation of the method generator for this method.
Property Implementation As %CacheString;

/// A flag indicating whether the method is internal (1) or not (0).
Property Internal As %CacheString;

/// This is for internal use.
Property Language As %CacheString [ InitialExpression = "cache" ];

/// This is for internal use.
Property NotForProperty As %CacheString;

/// This is for internal use.
Property NotInheritable As %CacheString;

/// A string containing the name of another method which should be placed 
/// before this method in generated code.
Property PlaceAfter As %CacheString;

/// A flag indicating whether the method is private (1) or public (0).
Property Private As %CacheString;

/// Set to true of the implementation is too large to load into the property as
/// you can not save this class, but you may look at the other properties
Property ReadOnly As %CacheString [ InitialExpression = 0 ];

/// A string containing the return type (a class name) for the method. If there is 
/// no return type it contains a null string ("").
Property ReturnType As %CacheString;

/// A string containing the name of this method when projected as an SQLPROCEDURE.
Property SQLName As %CacheString;

/// A flag indicating whether the method can be called as an SQL stored procedure (1) or not (0). 
/// A stored procedure must marked as a class method.
Property SQLProc As %CacheString;

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$MethodNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$MethodNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,methodname
 i id[":"
 i  s classname=$p(id,":",1),methodname=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),methodname=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=methodname
 ;
 s i%Abstract=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHabstract)
 s i%ClassMethod=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHclassmethod)
 s i%CodeMode=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHcodemode)
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHdescription)
 s i%Final=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHfinal)
 s i%FormalSpec=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHformalspec)
 s i%GenerateAfter=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHgenerateafter)
 n %sc,codesize,line,lineCount,ptr,methodtoolarge
 s %sc=$$$OK,methodtoolarge=0
 s codesize=0,i%Implementation=$$$defMemberArrayGet(classname,$$$cCLASSmethod,methodname,$$$cMETHimplementation,1)
 f ptr=2:1:$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHimplementation) d  q:$$$ISERR(%sc)||methodtoolarge
 . s line=$$$defMemberArrayGet(classname,$$$cCLASSmethod,methodname,$$$cMETHimplementation,ptr)
 . s codesize=$l(i%Implementation)+$l(line)
 . i codesize>32700 s i%Implementation="",i%ReadOnly=1,methodtoolarge=$$$ERROR($$$MethodTooLarge),methodtoolarge=1 q
 . s i%Implementation=i%Implementation_$$$NL_line
 Quit:$$$ISERR(%sc) %sc
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHinternal)
 s i%Language=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHlanguage)
 s i%NotForProperty=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHnotforproperty)
 s i%NotInheritable=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHnotinheritable)
 s i%PlaceAfter=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHplaceafter)
 s i%Private=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHprivate)
 s i%ReturnType=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHreturntype)
 s i%SQLName=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHsqlname)
 s i%SQLProc=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHsqlproc)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASSmethod,methodname,$$$cMETHsequencenumber)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$MethodNameRequired)
 i i%ReadOnly Quit $$$ERROR($$$NoSaveReadOnlyMethod)
 ;
 n classname,methodname
 s classname=i%ClassName
 s methodname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_methodname) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHabstract,i%Abstract)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHclassmethod,i%ClassMethod)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHcodemode,i%CodeMode)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHdescription,i%Description)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHfinal,i%Final)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHformalspec,i%FormalSpec)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHgenerateafter,i%GenerateAfter)
#if 0 ; DLP761+
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHimplementation,i%Implementation)
#else ; DLP761=
 n lineCount,line
 s lineCount=$l(i%Implementation,$$$NL)
 i $p(i%Implementation,$$$NL,lineCount)="" s lineCount=lineCount-1
 f line=1:1:lineCount $$$defMemberArraySet(classname,$$$cCLASSmethod,methodname,$$$cMETHimplementation,line,$p(i%Implementation,$$$NL,line))
 $$$defMemberKeySet(classname,$$$cCLASSmethod,methodname,$$$cMETHimplementation,lineCount)
#endif ; DLP761-
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHinternal,i%Internal)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHlanguage,i%Language)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHnotforproperty,i%NotForProperty)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHnotinheritable,i%NotInheritable)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHplaceafter,i%PlaceAfter)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHprivate,i%Private)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHreturntype,i%ReturnType)
 $$$SAVEstring(classname,$$$cCLASSmethod,methodname,$$$cMETHsqlname,i%SQLName)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHsqlproc,i%SQLProc)
 $$$SAVEnumber(classname,$$$cCLASSmethod,methodname,$$$cMETHsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberSet(classname,$$$cCLASSmethod,methodname,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,methodname
 s classname=$p(id,":",1)
 s methodname=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i methodname="" q $$$ERROR($$$MethodNameRequired)
 $$$defMemberKill(classname,$$$cCLASSmethod,methodname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Method CallGet() As %CacheString
{
 i i%CodeMode'=$$$cMETHCODEMODECALL QUIT ""
 QUIT i%Implementation
}

Method CallSet(value As %CacheString) As %Status
{
 s i%Implementation=value
 s i%CodeMode=$$$cMETHCODEMODECALL
 QUIT
}

Method CodeGet() As %CacheString
{
 i i%CodeMode'=$$$cMETHCODEMODECODE QUIT ""
 QUIT i%Implementation
}

Method CodeSet(value As %CacheString) As %Status
{
 s i%Implementation=value
 s i%CodeMode=$$$cMETHCODEMODECODE
 QUIT
}

Method ExpressionGet() As %CacheString
{
 i i%CodeMode'=$$$cMETHCODEMODEEXPRESSION QUIT ""
 QUIT i%Implementation
}

Method ExpressionSet(value As %CacheString) As %Status
{
 s i%Implementation=value
 s i%CodeMode=$$$cMETHCODEMODEEXPRESSION
 QUIT
}

Method GeneratorGet() As %CacheString
{
 i i%CodeMode'=$$$cMETHCODEMODEGENERATOR QUIT ""
 QUIT i%Implementation
}

Method GeneratorSet(value As %CacheString) As %Status
{
 s i%Implementation=value
 s i%CodeMode=$$$cMETHCODEMODEGENERATOR
 QUIT
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.MethodDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
