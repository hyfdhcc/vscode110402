Include %occReferenceStorage

/// Contains SQL mapping information for a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageSQLMapDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property Name As %CacheString;

Property Condition As %CacheString;

Property ConditionFields As %CacheString;

Property ConditionalWithHostVars As %CacheString;

Property Global As %CacheString;

Property Type As %CacheString;

Property PopulationPct As %CacheString;

Property PopulationType As %CacheString;

Property Structure As %CacheString;

Property Data As %ListOfPersistentChildObjects(CLASSNAME = 1);

Property RowIdSpec As %ListOfPersistentChildObjects(CLASSNAME = 1);

Property RowReference As %CacheString;

Property Subscript As %ListOfPersistentChildObjects(CLASSNAME = 1);

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2),i%Name=$p(initvalue,":",3)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-2),i%StorageName=$p(initvalue,".",len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapNameRequired)
 ;
 #define GR(%kind) $name(^oddDEF(i%ClassName,$$$cCLASSstorage,i%StorageName,$$$cSDEFsqlmap,i%Name,%kind))
 s i%Data=$$$oidForm($lb($$$GR($$$cSDEFSQLMAPdata),i%ClassName_":"_i%StorageName_":"_i%Name,"%StorageSQLMapDataDefinition"))
 s i%Subscript=$$$oidForm($lb($$$GR($$$cSDEFSQLMAPsubscript),i%ClassName_":"_i%StorageName_":"_i%Name,"%StorageSQLMapSubscriptDefinition"))
 s i%RowIdSpec=$$$oidForm($lb($$$GR($$$cSDEFSQLMAProwidspec),i%ClassName_":"_i%StorageName_":"_i%Name,"%StorageSQLMapRowIdSpecDefinition"))
 ;
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,storagename,mapname,i
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2),mapname=$p(id,":",3)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-2),storagename=$p(id,".",len-1),mapname=$p(id,".",len)

 s i%ClassName=classname
 s i%StorageName=storagename
 s i%Name=mapname

 s i%Condition = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPcondition)
 s i%ConditionFields = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPconditionfields)
 s i%ConditionalWithHostVars = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPconditionalwithhostvars)
 s i%RowReference = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwreference)

 s i%Global = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPglobal)
 s i%Type = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPtype)
 s i%PopulationPct = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPpopulationpct)
 s i%PopulationType = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPpopulationtype)
 s i%Structure = $$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPstructure)

 #define GR(%kind) $name(^oddDEF(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,%kind))
 s i%Data=$$$oidForm($lb($$$GR($$$cSDEFSQLMAPdata),id,"%StorageSQLMapDataDefinition"))
 s i%Subscript=$$$oidForm($lb($$$GR($$$cSDEFSQLMAPsubscript),id,"%StorageSQLMapSubscriptDefinition"))
 s i%RowIdSpec=$$$oidForm($lb($$$GR($$$cSDEFSQLMAProwidspec),id,"%StorageSQLMapRowIdSpecDefinition"))

 #; now swizzle everything in, so that they can be re-saved after the global is killed
 f i=1:1:..Data.Count() d ..Data.GetAt(i)
 f i=1:1:..Subscript.Count() d ..Subscript.GetAt(i)
 f i=1:1:..RowIdSpec.Count() d ..RowIdSpec.GetAt(i)

 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapNameRequired)
 ;
 n classname,storagename,mapname
 s classname=i%ClassName
 s storagename=i%StorageName
 s mapname=i%Name

 i id="" n sc s sc=..%IdSet(classname_":"_storagename_":"_mapname) i $$$ISERR(sc) QUIT sc

 #define SAVESUBKEYWORD(%class,%kind,%member,%keyword,%submember,%subkey,%value) i %value'=$$$tableDefaultGet(%keyword,%subkey) { $$$defStorageSubMemberKeySet(%class,%kind,%member,%keyword,%submember,%subkey,%value) } Else { $$$defStorageSubMemberKeyKill(%class,%kind,%member,%keyword,%submember,%subkey) }

 $$$defStorageSubMemberSet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,"")
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPcondition,i%Condition)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPconditionfields,i%ConditionFields)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPconditionalwithhostvars,i%ConditionalWithHostVars)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwreference,i%RowReference)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPglobal,i%Global)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPtype,i%Type)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPpopulationpct,i%PopulationPct)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPpopulationtype,i%PopulationType)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPstructure,i%Structure)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename,mapname
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 s mapname=$p(id,":",3)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 i mapname="" q $$$ERROR($$$StorageSQLMapNameRequired)
 $$$defStorageSubMemberKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)

 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageSQLMapDefinitiS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
