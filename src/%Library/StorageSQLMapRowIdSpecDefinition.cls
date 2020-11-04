Include %occReferenceStorage

/// Contains SQL row Id information for a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageSQLMapRowIdSpecDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property MapName As %CacheString;

Property Name As %CacheString;

Property Field As %CacheString;

Property Expression As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2),i%MapName=$p(initvalue,":",3),i%Name=$p(initvalue,":",4)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-3),i%StorageName=$p(initvalue,".",len-2),i%MapName=$p(initvalue,".",len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%MapName="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapRowIdSpecNameRequired)
 ;
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%MapName="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapRowIdSpecNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,storagename,mapname,rowspecname
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2),mapname=$p(id,":",3),rowspecname=$p(id,":",4)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-3),storagename=$p(id,".",len-2),mapname=$p(id,".",len-1),rowspecname=$p(id,".",len)
 s i%ClassName=classname
 s i%StorageName=storagename
 s i%MapName=mapname
 s i%Name=rowspecname
 s i%Field=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwidspec,rowspecname,$$$cSDEFSQLMAPROWIDSPECfield)
 s i%Expression=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwidspec,rowspecname,$$$cSDEFSQLMAPROWIDSPECexpression)
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%MapName="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapRowIdSpecNameRequired)

 n classname,storagename,mapname,rowspecname
 s classname=i%ClassName
 s storagename=i%StorageName
 s mapname=i%MapName
 s rowspecname=i%Name

 i id="" n sc s sc=..%IdSet(classname_":"_storagename_":"_mapname_":"_rowspecname) i $$$ISERR(sc) QUIT sc

 #define SAVESUBSUBKEYWORD(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey,%value) i %value'=$$$tableDefaultGet(%subkey,%subsubkey) { $$$defStorageSubSubMemberKeySet(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey,%value) } Else { $$$defStorageSubSubMemberKeyKill(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey) }

 $$$defStorageSubSubMemberSet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwidspec,rowspecname,"")
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwidspec,rowspecname,$$$cSDEFSQLMAPROWIDSPECfield,i%Field)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwidspec,rowspecname,$$$cSDEFSQLMAPROWIDSPECexpression,i%Expression)

 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename,mapname,rowspecname
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 s mapname=$p(id,":",3)
 s rowspecname=$p(id,":",4)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 i mapname="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i rowspecname="" q $$$ERROR($$$StorageSQLMapRowIdSpecNameRequired)
 $$$defStorageSubSubMemberKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAProwidspec,rowspecname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageSQLMapRowIdSpeS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
