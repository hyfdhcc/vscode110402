/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>index</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.IndexDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the index belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the index.
Property Name As %CacheString;

/// A string containing a condition for the index.
Property Condition As %CacheString;

/// A string containing a comma-delimited list of properties stored with the index.
Property Data As %CacheString;

/// A string containing a description of the index.
Property Description As %CacheString;

/// A flag indicating whether the index is an extent index (1) or not (0).
/// <p>An extent index is used to differentiate members of subclasses within 
/// extents.
Property Extent As %CacheString;

/// A flag indicating whether the index is an IDKEY index (1) or not (0).
Property IdKey As %CacheString;

/// A flag indicating whether the index is internal (1) or not (0).
Property Internal As %CacheString;

/// A flag indicating whether the index is the SQL primary key (1) or not (0).
Property PrimaryKey As %CacheString;

/// A string containing a comma-delimited list of the properties the index is based upon.
Property Properties As %CacheString;

/// This attribute is obsolete.  Use 'Properties' instead.
Property Attributes As %CacheString [ Calculated ];

/// A string containing the name that this index as defined in SQL.
Property SQLName As %CacheString;

/// A string indicating the type of index to create, KEY or INDEX. A key index
/// is build using only the index attributes while an INDEX uses both the index
/// attributes and the IDKEY attributes (or system generated ID value).
Property Type As %CacheString;

/// A flag indicating whether the index is unique (1) or not (0).
Property Unique As %CacheString;

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$IndexNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$IndexNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,indexname
 i id[":"
 i  s classname=$p(id,":",1),indexname=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),indexname=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=indexname
 ;
 s i%Condition=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXcondition)
 s i%Data=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXdata)
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXdescription)
 s i%Extent=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXextent)
 s i%IdKey=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXidkey)
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXinternal)
 s i%PrimaryKey=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXprimarykey)
 s i%Properties=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXproperties)
 s i%SQLName=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXsqlname)
 s i%Type=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXtype)
 s i%Unique=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXunique)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASSindex,indexname,$$$cINDEXsequencenumber)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$IndexNameRequired)
 ;
 n classname,indexname
 s classname=i%ClassName
 s indexname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_indexname) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEstring(classname,$$$cCLASSindex,indexname,$$$cINDEXcondition,i%Condition)
 $$$SAVEstring(classname,$$$cCLASSindex,indexname,$$$cINDEXdata,i%Data)
 $$$SAVEstring(classname,$$$cCLASSindex,indexname,$$$cINDEXdescription,i%Description)
 $$$SAVEnumber(classname,$$$cCLASSindex,indexname,$$$cINDEXextent,i%Extent)
 $$$SAVEnumber(classname,$$$cCLASSindex,indexname,$$$cINDEXidkey,i%IdKey)
 $$$SAVEnumber(classname,$$$cCLASSindex,indexname,$$$cINDEXinternal,i%Internal)
 $$$SAVEnumber(classname,$$$cCLASSindex,indexname,$$$cINDEXprimarykey,i%PrimaryKey)
 $$$SAVEstring(classname,$$$cCLASSindex,indexname,$$$cINDEXproperties,i%Properties)
 $$$SAVEstring(classname,$$$cCLASSindex,indexname,$$$cINDEXsqlname,i%SQLName)
 $$$SAVEstring(classname,$$$cCLASSindex,indexname,$$$cINDEXtype,i%Type)
 $$$SAVEnumber(classname,$$$cCLASSindex,indexname,$$$cINDEXunique,i%Unique)
 $$$SAVEnumber(classname,$$$cCLASSindex,indexname,$$$cINDEXsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberSet(classname,$$$cCLASSindex,indexname,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,indexname
 s classname=$p(id,":",1)
 s indexname=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i indexname="" q $$$ERROR($$$IndexNameRequired)
 $$$defMemberKill(classname,$$$cCLASSindex,indexname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Method AttributesGet() As %CacheString
{
 QUIT ..Properties
}

Method AttributesSet(newvalue As %CacheString) As %Status
{
 s ..Properties=newvalue
 QUIT $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.IndexDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
