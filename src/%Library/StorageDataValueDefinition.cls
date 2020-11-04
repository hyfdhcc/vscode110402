Include %occReferenceStorage

/// Contains information about a data value definition within a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageDataValueDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property DataName As %CacheString;

Property Name As %CacheString;

Property Value As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2),i%DataName=$p(initvalue,":",3),i%Name=$p(initvalue,":",4)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-3),i%StorageName=$p(initvalue,".",len-2),i%DataName=$p(initvalue,".",len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%DataName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
 ;
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%DataName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,storagename,dataname,valuename
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2),dataname=$p(id,":",3),valuename=$p(id,":",4)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-3),storagename=$p(id,".",len-2),dataname=$p(id,".",len-1),valuename=$p(id,".",len)
 ;
 s i%ClassName=classname
 s i%StorageName=storagename
 s i%DataName=dataname
 s i%Name=valuename

 Set i%Value=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAvalue,valuename,$$$cSDEFDATAVALvalue)

 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%DataName="" q $$$ERROR($$$StorageNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)

 n classname,storagename,mapname,dataname
 s classname=i%ClassName
 s storagename=i%StorageName
 s dataname=i%DataName
 s valuename=i%Name

 i id="" n sc s sc=..%IdSet(classname_":"_storagename_":"_dataname_":"_valuename) i $$$ISERR(sc) QUIT sc

 #define SAVESUBSUBKEYWORD(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey,%value) i %value'=$$$tableDefaultGet(%subkey,%subsubkey) { $$$defStorageSubSubMemberKeySet(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey,%value) } Else { $$$defStorageSubSubMemberKeyKill(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey) }

 $$$defStorageSubSubMemberSet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAvalue,valuename,"")
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAvalue,valuename,$$$cSDEFDATAVALvalue,i%Value)

 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename,dataname,valuename
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 s dataname=$p(id,":",3)
 s valuename=$p(id,":",4)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 i dataname="" q $$$ERROR($$$StorageNameRequired)
 i valuename="" q $$$ERROR($$$StorageNameRequired)

 $$$defStorageSubSubMemberKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata,dataname,$$$cSDEFDATAvalue,valuename)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageDataValueDefinS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
