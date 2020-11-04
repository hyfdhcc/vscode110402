/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>SQL trigger</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.TriggerDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the SQL trigger belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the SQL trigger.
Property Name As %CacheString;

/// A string containing the code for the SQL trigger.
Property Code As %CacheString;

/// A string containing a description of the SQL trigger.
Property Description As %CacheString;

/// A string containing the name of event the trigger is associated with. 
/// This can be "INSERT", "UPDATE", or "DELETE".
Property Event As %CacheString;

/// A flag indicating whether the trigger is internal (1) or not (0).
Property Internal As %CacheString;

/// A number indicating the order in which the trigger should be fired.
Property Order As %CacheString;

/// A string containing the name of event modifier for the trigger. 
/// This can be "BEFORE" or "AFTER".
Property Time As %CacheString [ InitialExpression = "BEFORE" ];

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$TriggerNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$TriggerNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,triggername
 i id[":"
 i  s classname=$p(id,":",1),triggername=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),triggername=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=triggername
 ;
 s i%Code=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERcode)
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERdescription)
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERinternal)
 s i%Order=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERorder)
 s i%Time=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERtime)
 s i%Event=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERevent)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERsequencenumber)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$TriggerNameRequired)
 ;
 n classname,triggername
 s classname=i%ClassName
 s triggername=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_triggername) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEstring(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERcode,i%Code)
 $$$SAVEstring(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERdescription,i%Description)
 $$$SAVEstring(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERinternal,i%Internal)
 $$$SAVEstring(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERorder,i%Order)
 $$$SAVEstring(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERtime,i%Time)
 $$$SAVEstring(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERevent,i%Event)
 $$$SAVEnumber(classname,$$$cCLASStrigger,triggername,$$$cTRIGGERsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberSet(classname,$$$cCLASStrigger,triggername,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,triggername
 s classname=$p(id,":",1)
 s triggername=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i triggername="" q $$$ERROR($$$TriggerNameRequired)
 $$$defMemberKill(classname,$$$cCLASStrigger,triggername)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.TriggerDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
