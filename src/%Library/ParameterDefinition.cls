/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>class parameter</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.ParameterDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the method belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the class parameter.
Property Name As %CacheString;

/// A string containing the default value for the class parameter.
Property Default As %CacheString;

/// A string containing the description for the class parameter.
Property Description As %CacheString;

/// A flag indicating whether the class parameter is final (1) or not (0).
Property Final As %CacheString;

/// A flag indicating whether the class parameter is internal (1) or not (0).
Property Internal As %CacheString;

/// This is for internal use only.
Property Flags As %CacheString;

/// This is for internal use only.
Property Constraint As %CacheString;

/// This is for internal use only.
Property Type As %CacheString;

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$ParameterNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$ParameterNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,paramname
 i id[":"
 i  s classname=$p(id,":",1),paramname=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),paramname=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=paramname
 ;
 s i%Default=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMdefault)
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMdescription)
 s i%Final=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMfinal)
 s i%Flags=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMflags)
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMinternal)
 s i%Constraint=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMconstraint)
 s i%Type=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMtype)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASSparameter,paramname,$$$cPARAMsequencenumber)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$ParameterNameRequired)
 ;
 n classname,paramname
 s classname=i%ClassName
 s paramname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_paramname) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEstring(classname,$$$cCLASSparameter,paramname,$$$cPARAMdefault,i%Default)
 $$$SAVEstring(classname,$$$cCLASSparameter,paramname,$$$cPARAMdescription,i%Description)
 $$$SAVEnumber(classname,$$$cCLASSparameter,paramname,$$$cPARAMfinal,i%Final)
 $$$SAVEstring(classname,$$$cCLASSparameter,paramname,$$$cPARAMflags,i%Flags)
 $$$SAVEstring(classname,$$$cCLASSparameter,paramname,$$$cPARAMinternal,i%Internal)
 $$$SAVEstring(classname,$$$cCLASSparameter,paramname,$$$cPARAMconstraint,i%Constraint)
 $$$SAVEstring(classname,$$$cCLASSparameter,paramname,$$$cPARAMtype,i%Type)
 $$$SAVEnumber(classname,$$$cCLASSparameter,paramname,$$$cPARAMsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberSet(classname,$$$cCLASSparameter,paramname,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,paramname
 s classname=$p(id,":",1)
 s paramname=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i paramname="" q $$$ERROR($$$ParameterNameRequired)
 $$$defMemberKill(classname,$$$cCLASSparameter,paramname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.ParameterDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
