/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>foreign key</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.ForeignKeyDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the foreign key belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the foreign key.
Property Name As %CacheString;

/// A string containing the description of the foreign key.
Property Description As %CacheString;

/// A flag indicating whether this trigger is internal (1) or not (0).
Property Internal As %CacheString;

/// The DELETE referential action: NOACTION, CASCADE, SETDEFAULT, SETNULL.
Property OnDelete As %CacheString;

/// The UPDATE referential action: NOACTION, CASCADE, SETDEFAULT, SETNULL.
Property OnUpdate As %CacheString;

/// A string containing a comma-delimited list of attributes in the class that 
/// form the foreign key reference.
Property Properties As %CacheString;

/// This attribute is obsolete.  Use 'Properties' instead.
Property Attributes As %CacheString [ Calculated ];

/// A string containing the name of the foreign class.
Property ReferencedClass As %CacheString;

/// A string containing the name of the foreign index. If omitted, it defaults to the index declared to be IDKEY.
Property ReferencedKey As %CacheString;

/// A string containing the name of this FOREIGNKEY constraint as defined to SQL.
Property SQLName As %CacheString;

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$KeyNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$KeyNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,keyname
 i id[":"
 i  s classname=$p(id,":",1),keyname=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),keyname=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=keyname
 ;
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYdescription)
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYinternal)
 s i%OnDelete=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYondelete)
 s i%OnUpdate=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYonupdate)
 s i%Properties=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYproperties)
 s i%ReferencedClass=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYreferencedclass)
 s i%ReferencedKey=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYreferencedkey)
 s i%SQLName=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYsqlname)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASSfkey,keyname,$$$cFKEYsequencenumber)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$KeyNameRequired)
 ;
 n classname,keyname
 s classname=i%ClassName
 s keyname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_keyname) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYdescription,i%Description)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYinternal,i%Internal)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYondelete,i%OnDelete)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYonupdate,i%OnUpdate)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYproperties,i%Properties)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYreferencedclass,i%ReferencedClass)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYreferencedkey,i%ReferencedKey)
 $$$SAVEstring(classname,$$$cCLASSfkey,keyname,$$$cFKEYsqlname,i%SQLName)
 $$$SAVEnumber(classname,$$$cCLASSfkey,keyname,$$$cFKEYsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberSet(classname,$$$cCLASSfkey,keyname,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,keyname
 s classname=$p(id,":",1)
 s keyname=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i keyname="" q $$$ERROR($$$KeyNameRequired)
 $$$defMemberKill(classname,$$$cCLASSfkey,keyname)
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
<StreamLocation>^%Library.ForeignKeyDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
