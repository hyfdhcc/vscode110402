Include %occReferenceStorage

/// Contains SQL storage information for a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageSQLDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property IdExpression As %CacheString;

Property RowIdName As %CacheString;

Property TableNumber As %CacheString;

Property Maps As %ListOfPersistentChildObjects(CLASSNAME = 1);

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%StorageName=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)

 #define GR(%kind) $name(^oddDEF(i%ClassName,$$$cCLASSstorage,i%StorageName,%kind))
 s i%Maps=$$$oidForm($lb($$$GR($$$cSDEFsqlmap),i%ClassName_":"_i%StorageName,"%StorageSQLMapDefinition"))

 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,storagename
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),storagename=$p(id,".",len)

 s i%ClassName=classname
 s i%StorageName=storagename
 #;
 s i%IdExpression=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlidexpression)
 s i%RowIdName=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlrowidname)
 s i%TableNumber=$$$defMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqltablenumber)

 #define GR(%element) $name(^oddDEF(classname,$$$cCLASSstorage,storagename,%element))
 s i%Maps=$$$oidForm($lb($$$GR($$$cSDEFsqlmap),id,"%StorageSQLMapDefinition"))

 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)

 n classname,storagename
 s classname=i%ClassName
 s storagename=i%StorageName

 i id="" n sc s sc=..%IdSet(classname_":"_storagename) i $$$ISERR(sc) QUIT sc

 #define SAVEKEYWORD(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) $$$defMemberKeySet(%class,%kind,%member,%keyword,%value)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlidexpression,i%IdExpression)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlrowidname,i%RowIdName)
 $$$SAVEKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqltablenumber,i%TableNumber)

 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 $$$defMemberKeyKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlidexpression)
 $$$defMemberKeyKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlrowidname)
 $$$defMemberKeyKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqltablenumber)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageSQLDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
