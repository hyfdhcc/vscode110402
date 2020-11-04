Include %occReferenceStorage

/// Contains SQL subscript information for a storage definition for a class within the 
/// <i>Cach&eacute; Dictionary</i>.
Class %Library.StorageSQLMapSubscriptDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 3 ]
{

Property ClassName As %CacheString;

Property StorageName As %CacheString;

Property MapName As %CacheString;

Property Name As %CacheString;

Property AccessType As %CacheString;

Property Delimiter As %CacheString;

Property Expression As %CacheString;

Property NextCode As %CacheString;

Property StartValue As %CacheString;

Property StopExpression As %CacheString;

Property StopValue As %CacheString;

Property InvalidCondition As %ListOfPersistentChildObjects(CLASSNAME = 1);

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%StorageName=$p(initvalue,":",2),i%MapName=$p(initvalue,":",3),i%Name=$p(initvalue,":",4)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-3),i%StorageName=$p(initvalue,".",len-2),i%MapName=$p(initvalue,".",len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%MapName="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapSubscriptNameRequired)

 s i%InvalidCondition=$$$oidForm($lb($name(^oddDEF(i%ClassName,$$$cCLASSstorage,i%StorageName,"sql","map",i%MapName,"subscript",i%Name,$$$cSDEFSQLMAPSUBinvalidcondition)),i%ClassName_":"_i%StorageName_":"_i%MapName_":"_i%Name,"%StorageSQLMapSubInvCondDef"))
 ;
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%MapName="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapSubscriptNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,storagename,mapname,subsname
 i id[":"
 i  s classname=$p(id,":",1),storagename=$p(id,":",2),mapname=$p(id,":",3),subsname=$p(id,":",4)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-3),storagename=$p(id,".",len-2),mapname=$p(id,".",len-1),subsname=$p(id,".",len)
 ;
 s i%ClassName=classname
 s i%StorageName=storagename
 s i%MapName=mapname
 s i%Name=subsname

 s i%AccessType=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBaccesstype)
 s i%Delimiter=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBdelimiter)
 s i%Expression=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBexpression)
 s i%StartValue=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBstartvalue)
 s i%StopExpression=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBstopexpression)
 s i%NextCode=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBnextcode)
 s i%StopValue=$$$defStorageSubSubMemberKeyGet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBstopvalue)

 s i%InvalidCondition=$$$oidForm($lb($name(^oddDEF(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBinvalidcondition)),id,"%StorageSQLMapSubInvCondDef"))

 #; now swizzle everything in, so that they can be re-saved after the global is killed
 f i=1:1:..InvalidCondition.Count() d ..InvalidCondition.GetAt(i)

 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%StorageName="" q $$$ERROR($$$StorageNameRequired)
 i i%MapName="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i i%Name="" q $$$ERROR($$$StorageSQLMapSubscriptNameRequired)
 ;
 n classname,storagename,mapname,subsname
 s classname=i%ClassName
 s storagename=i%StorageName
 s mapname=i%MapName
 s subsname=i%Name

 #define SAVESUBSUBKEYWORD(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey,%value) i %value'=$$$tableDefaultGet(%subkey,%subsubkey) { $$$defStorageSubSubMemberKeySet(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey,%value) } Else { $$$defStorageSubSubMemberKeyKill(%class,%kind,%member,%keyword,%submember,%subkey,%subsubmember,%subsubkey) }

 i id="" n sc s sc=..%IdSet(classname_":"_storagename_":"_mapname_":"_subsname) i $$$ISERR(sc) QUIT sc

 $$$defStorageSubSubMemberSet(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,"")
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBstartvalue,i%StartValue)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBstopexpression,i%StopExpression)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBstopvalue,i%StopValue)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBaccesstype,i%AccessType)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBdelimiter,i%Delimiter)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBexpression,i%Expression)
 $$$SAVESUBSUBKEYWORD(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname,$$$cSDEFSQLMAPSUBnextcode,i%NextCode)

 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,storagename,mapname,subsname
 s classname=$p(id,":",1)
 s storagename=$p(id,":",2)
 s mapname=$p(id,":",3)
 s subsname=$p(id,":",4)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i storagename="" q $$$ERROR($$$StorageNameRequired)
 i mapname="" q $$$ERROR($$$StorageSQLMapNameRequired)
 i subsname="" q $$$ERROR($$$StorageSQLMapSubscriptNameRequired)

 $$$defStorageSubSubMemberKill(classname,$$$cCLASSstorage,storagename,$$$cSDEFsqlmap,mapname,$$$cSDEFSQLMAPsubscript,subsname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.StorageSQLMapSubscripS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
