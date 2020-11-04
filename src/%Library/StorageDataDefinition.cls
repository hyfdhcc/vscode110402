Include %occReferenceStorage

/// Contains information about a data definition within a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageDataDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property Name As %CacheString;

Property Structure As %CacheString;

Property Subscript As %CacheString;

Property Value As %CacheString;

Property ValueList As %ListOfPersistentChildObjects(CLASSNAME = 1);

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2),i%Name=$p(initvalue,":",3)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-2),i%StorageName=$p(initvalue,".",len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
 ;
 s i%ValueList=$$$oidForm($lb($name($$$defSubMemberKeyRaw(i%ClassName,$$$cCLASSstorage,i%StorageName,$$$cSDEFdata,i%Name,$$$cSDEFDATAvalue)),i%ClassName_":"_i%StorageName_":"_i%Name,"%StorageDataValueDefinition"))
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
 n classname,storagename,dataname,i
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2),dataname=$p(id,":",3)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-2),storagename=$p(id,".",len-1),dataname=$p(id,".",len)
 ;
 s i%ClassName=classname
 s i%StorageName=storagename
 s i%Name=dataname

 Set i%Structure=$$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAstructure)
 Set i%Subscript=$$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAsubscript)
 Set i%Value=$$$defStorageSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAattribute)

 s i%ValueList=$$$oidForm($lb($name($$$defSubMemberKeyRaw(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAvalue)),id,"%StorageDataValueDefinition"))

 #; now swizzle everything in, so that they can be re-saved after the global is killed
 f i=1:1:..ValueList.Count() d ..ValueList.GetAt(i)

 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)

 n classname,storagename,dataname
 s classname=i%ClassName
 s storagename=i%StorageName
 s dataname=i%Name

 i id="" n sc s sc=..%IdSet(classname_":"_storagename_":"_dataname) i $$$ISERR(sc) QUIT sc

 #define SAVESUBKEYWORD(%class,%kind,%member,%keyword,%submember,%subkey,%value) i %value'=$$$tableDefaultGet(%keyword,%subkey) { $$$defStorageSubMemberKeySet(%class,%kind,%member,%keyword,%submember,%subkey,%value) } Else { $$$defStorageSubMemberKeyKill(%class,%kind,%member,%keyword,%submember,%subkey) }

 $$$defStorageSubMemberSet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,"")
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAattribute,i%Value)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAstructure,i%Structure)
 $$$SAVESUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAsubscript,i%Subscript)

 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)

 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename,dataname
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 s dataname=$p(id,":",3)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 i dataname="" q $$$ERROR($$$StorageNameRequired)
 $$$defStorageSubMemberKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageDataDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
