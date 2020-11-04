Include %occReferenceStorage

/// Contains information about an index definition within a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageIndexDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property Name As %CacheString;

Property IndexLocation As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2),i%Name=$p(initvalue,":",3)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-2),i%StorageName=$p(initvalue,".",len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
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
 n classname,storagename,indexname,i
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2),indexname=$p(id,":",3)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-2),storagename=$p(id,".",len-1),indexname=$p(id,".",len)

 s i%ClassName=classname
 s i%StorageName=storagename
 s i%Name=indexname

 Set i%IndexLocation=$$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFindex,indexname,$$$cSDEFIDXlocation)
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
 ;
 n classname,storagename,indexname
 s classname=i%ClassName
 s storagename=i%StorageName
 s indexname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_storagename_":"_indexname) i $$$ISERR(sc) QUIT sc

 #define SAVESUBKEYWORD(%class,%kind,%member,%keyword,%submember,%subkey,%value) i %value'=$$$tableDefaultGet(%keyword,%subkey) { $$$defStorageSubMemberKeySet(%class,%kind,%member,%keyword,%submember,%subkey,%value) } Else { $$$defStorageSubMemberKeyKill(%class,%kind,%member,%keyword,%submember,%subkey) }

 $$$defStorageSubMemberSet(classname,$$$cCLASSstorage,storagename,$$$cSDEFindex,indexname,"")
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFindex,indexname,$$$cSDEFIDXlocation,i%IndexLocation)

 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)

 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename,Indexname
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 s indexname=$p(id,":",3)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 i indexname="" q $$$ERROR($$$StorageNameRequired)

 $$$defStorageSubMemberKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFindex,indexname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageIndexDefinitioS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
