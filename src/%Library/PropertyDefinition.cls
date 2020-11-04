/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>property</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.PropertyDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the property belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the property.
Property Name As %CacheString;

/// A flag indicating whether the property is calculated (1) or not (0).
Property Calculated As %CacheString;

/// If the property is a relationship, this is a string contains the cardinality of
/// the relationship. Cardinality = 'one' indicates the child side of the relationship while
/// Cardinality = 'many' indicates the parent. Cardinality = 'child' and 'parent' mean the same
/// but also indicate a dependent relationship.
Property Cardinality As %CacheString;

/// If the property is a collection, this is a string containing the name of 
/// the collection type. If the property is not a collection (single-valued) it 
/// contains a null string ("").
Property Collection As %CacheString;

/// A string containing the description of the property.
Property Description As %CacheString;

/// A flag indicating whether the property is final (1) or not (0).
Property Final As %CacheString;

/// A string containing the initial value expression for the property.
Property InitialExpression As %CacheString [ InitialExpression = """""" ];

/// A flag indicating whether the property is internal (1) or not (0).
Property Internal As %CacheString;

/// A string containing the name of the inverse relationship in the related class.
Property Inverse As %CacheString;

/// A flag indicating whether the property is multi-dimensional (1) or not (0).
Property MultiDimensional As %CacheString;

/// A flag indicating whether the property is private (1) or public (0).
Property Private As %CacheString;

/// A flag indicating whether the property is a readonly (1) or writeable (0).
Property ReadOnly As %CacheString;

/// A flag indicating whether the property is a relationship (1) or attribute (0).
Property Relationship As %CacheString;

/// A flag indicating whether the property is required (1) or not (0).
Property Required As %CacheString;

/// A string containing the name of the class this method belongs to.
Property SqlCollation As %CacheString;

/// The column number used when projecting the property as an SQL table.
Property SqlColumnNumber As %CacheString;

/// For an SQL-computed field this is a string containing any SQL compute code for the field.
Property SqlComputeCode As %CacheString;

/// A flag indicating whether the property is SQL-computed (1) or not (0).
Property SqlComputed As %CacheString;

Property SqlComputeOnChange As %CacheString;

/// A string containing an optional SQL name for the property. This is the name with 
/// which the property is projected to SQL.
Property SqlFieldName As %CacheString;

Property SqlListDelimiter As %CacheString;

Property SqlListType As %CacheString;

/// A flag indicating whether the property is transient (1) or not (0).
Property Transient As %CacheString;

/// A string containing the type (class name) of the field.
Property Type As %CacheString;

/// An array containing any parameter definitions for the property. The array 
/// keys are the parameter names and the array values are the parameter values.
Property Parameters As array Of %CacheString;

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$PropertyNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$PropertyNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,propertyname
 i id[":"
 i  s classname=$p(id,":",1),propertyname=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),propertyname=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=propertyname
 ;
 s i%Final=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPfinal)
 s i%Calculated=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPcalculated)
 s i%Cardinality=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPcardinality)
 s i%Collection=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPcollection)
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPdescription)
 s i%InitialExpression=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPinitialexpression)
 s i%Inverse=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPinverse)
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPinternal)
 s i%MultiDimensional=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPmultidimensional)
 s i%Private=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPprivate)
 s i%ReadOnly=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPreadonly)
 s i%Relationship=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPrelationship)
 s i%Required=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPrequired)
 s i%SqlCollation=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcollation)
 s i%SqlColumnNumber=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcolumnnumber)
 s i%SqlComputeCode=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcomputecode)
 s i%SqlComputed=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcomputed)
 s i%SqlComputeOnChange=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcomputeonchange)
 s i%SqlFieldName=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlfieldname)
 s i%SqlListDelimiter=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqllistdelimiter)
 s i%SqlListType=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqllisttype)
 s i%Transient=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPtransient)
 s i%Type=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPtype)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPsequencenumber)
 ;
 n param
 s param="" f  s param=$$$defSubMemberNext(classname,$$$cCLASSproperty,propertyname,$$$cPROPparameter,param) q:param=""  d
 . d ..Parameters.SetAt($$$defMemberArrayGet(classname,$$$cCLASSproperty,propertyname,$$$cPROPparameter,param),param)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$PropertyNameRequired)
 ;
 n classname,propertyname
 s classname=i%ClassName
 s propertyname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_propertyname) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPcalculated,i%Calculated)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPcardinality,i%Cardinality)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPcollection,i%Collection)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPdescription,i%Description)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPinitialexpression,i%InitialExpression)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPinverse,i%Inverse)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPinternal,i%Internal)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPfinal,i%Final)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPmultidimensional,i%MultiDimensional)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPprivate,i%Private)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPreadonly,i%ReadOnly)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPrelationship,i%Relationship)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPrequired,i%Required)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcollation,i%SqlCollation)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcolumnnumber,i%SqlColumnNumber)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcomputecode,i%SqlComputeCode)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcomputed,i%SqlComputed)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlcomputeonchange,i%SqlComputeOnChange)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqlfieldname,i%SqlFieldName)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqllistdelimiter,i%SqlListDelimiter)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPsqllisttype,i%SqlListType)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPtransient,i%Transient)
 $$$SAVEstring(classname,$$$cCLASSproperty,propertyname,$$$cPROPtype,i%Type)
 $$$SAVEnumber(classname,$$$cCLASSproperty,propertyname,$$$cPROPsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberKeyKill(classname,$$$cCLASSproperty,propertyname,$$$cPROPparameter)
 n p s p="" f  s p=..Parameters.Next(p) q:p=""  d
 . $$$defSubMemberSet(classname,$$$cCLASSproperty,propertyname,$$$cPROPparameter,p,..Parameters.GetAt(p))
 ;
 $$$defMemberSet(classname,$$$cCLASSproperty,propertyname,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,propertyname
 s classname=$p(id,":",1)
 s propertyname=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i propertyname="" q $$$ERROR($$$PropertyNameRequired)
 $$$defMemberKill(classname,$$$cCLASSproperty,propertyname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.PropertyDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
