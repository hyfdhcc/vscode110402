Include %occReferenceStorage

/// Contains information about a specific storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property Name As %CacheString;

Property DataDefinitions As %ListOfPersistentChildObjects(CLASSNAME = 1);

Property DataLocation As %CacheString;

Property DefaultData As %CacheString;

Property Description As %CacheString;

Property Internal As %CacheString;

Property IdLocation As %CacheString;

Property IndexDefinitions As %ListOfPersistentChildObjects(CLASSNAME = 1);

Property IndexLocation As %CacheString;

Property StateSerial As %CacheString;

Property SQLBinding As %StorageSQLDefinition(CLASSNAME = 1) [ InitialExpression = {..ClassName_":"_..Name} ];

Property Type As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
 ;
 s i%DataDefinitions=$$$oidForm($lb($name($$$defMemberKeyRaw(i%ClassName,$$$cCLASSstorage,i%Name,$$$cSDEFdata)),i%ClassName_":"_i%Name,"%StorageDataDefinition"))
 s i%IndexDefinitions=$$$oidForm($lb($name($$$defMemberKeyRaw(i%ClassName,$$$cCLASSstorage,i%Name,$$$cSDEFindex)),i%ClassName_":"_i%Name,"%StorageIndexDefinition"))
 ;
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,storagename
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),storagename=$p(id,".",len)

 s i%ClassName=classname
 s i%Name=storagename

 Set i%Description=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdescription)
 Set i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFinternal)
 Set i%Type=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFtype)
 Set i%DataLocation=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdatalocation)
 Set i%DefaultData=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFdefaultdata)
 Set i%IdLocation=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFidlocation)
 Set i%IndexLocation=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFindexlocation)
 Set i%StateSerial=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFstate)

 s i%SQLBinding=$$$oidForm(id)

 s i%DataDefinitions=$$$oidForm($lb($name($$$defMemberKeyRaw(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata)),id,"%StorageDataDefinition"))
 s i%IndexDefinitions=$$$oidForm($lb($name($$$defMemberKeyRaw(classname,$$$cCLASSstorage,storagename,$$$cSDEFdata)),id,"%StorageIndexDefinition"))
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$StorageNameRequired)

 n classname,storagename
 s classname=i%ClassName
 s storagename=i%Name

 i id="" n sc s sc=..%IdSet(classname_":"_storagename) i $$$ISERR(sc) QUIT sc

 #define SAVEREQUIRED(%class,%kind,%member,%keyword,%value) $$$defMemberKeySet(%class,%kind,%member,%keyword,%value)
 #define SAVEKEYWORD(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } Else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }

 $$$defMemberSet(classname,$$$cCLASSstorage,storagename,"")
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdescription,i%Description)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFinternal,i%Internal)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdatalocation,i%DataLocation)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFdefaultdata,i%DefaultData)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFidlocation,i%IdLocation)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFindexlocation,i%IndexLocation)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFstate,i%StateSerial)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFtype,i%Type)

 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 $$$defMemberKill(classname,$$$cCLASSstorage,storagename)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
