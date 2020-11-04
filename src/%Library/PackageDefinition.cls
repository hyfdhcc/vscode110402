/// This class represents a specific <i>package</i> description contained within the 
/// <i>Cach&eacute; Dictionary.</i>
Class %Library.PackageDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the package.
Property Name As %CacheString;

/// A string containing the client name of the package.
Property ClientName As %CacheString;

/// A string containing the description of the package.
Property Description As %CacheString;

/// A string containing the global prefix of the package, used for data, id, and index locations.
Property GlobalPrefix As %CacheString;

/// A string containing the Owner's name of the package.
Property OwnerName As %CacheString;

/// A string containing the routine prefix of the package.
Property RtnPrefix As %CacheString;

/// A string containing the SQL name of the package.
Property SQLName As %CacheString;

Property list As %ListOfDataTypes [ Transient ];

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue="" q $$$ERROR($$$PackageNameRequired)
 s i%Name=initvalue
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 #define LOADVSTRING(%ivar,%global) s %ivar=$g(%global)
 n name
 s i%Name=id
 $$$LOADVSTRING(name,$$$PACKAGEname(i%Name)) i name'="" s i%Name=name
 $$$LOADVSTRING(i%ClientName,$$$PACKAGEclientname(i%Name))
 $$$LOADVSTRING(i%Description,$$$PACKAGEdescription(i%Name))
 $$$LOADVSTRING(i%GlobalPrefix,$$$PACKAGEglobalprefix(i%Name))
 $$$LOADVSTRING(i%OwnerName,$$$PACKAGEownername(i%Name))
 $$$LOADVSTRING(i%RtnPrefix,$$$PACKAGErtnprefix(i%Name))
 $$$LOADVSTRING(i%SQLName,$$$PACKAGEsqlname(i%Name))
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 #define SAVEOPTIONAL(%global,%ivar) s %global=%ivar k:%ivar="" %global
 i i%Name="" q $$$ERROR($$$PackageNameRequired)
 i id="" n sc s sc=..%IdSet(i%Name) i $$$ISERR(sc) q sc
 $$$SAVEOPTIONAL($$$PACKAGEname(i%Name),i%Name)
 $$$SAVEOPTIONAL($$$PACKAGEclientname(i%Name),i%ClientName)
 $$$SAVEOPTIONAL($$$PACKAGEdescription(i%Name),i%Description)
 $$$SAVEOPTIONAL($$$PACKAGEglobalprefix(i%Name),i%GlobalPrefix)
 $$$SAVEOPTIONAL($$$PACKAGEownername(i%Name),i%OwnerName)
 $$$SAVEOPTIONAL($$$PACKAGErtnprefix(i%Name),i%RtnPrefix)
 $$$SAVEOPTIONAL($$$PACKAGEsqlname(i%Name),i%SQLName)
 #; the top node is for system code to query
 s $$$PACKAGE(i%Name)=i%RtnPrefix
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 i id="" q $$$ERROR($$$PackageNameRequired)
 QUIT $$DeletePackageDefinition^%apiOBJ(id,"-d")
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%Name="" q $$$ERROR($$$PackageNameRequired)
 i $l(i%GlobalPrefix)>31 q $$$ERROR($$$PackageGlobalPrefixTooLong)
 q $$$OK
}

Method GetPackageList() As %ListOfDataTypes
{
 n package,packagelist,data
 i ..list=$$$NULLOREF s ..list=##class(%ListOfDataTypes).%New()
 d ..list.Clear()
 If $Get(^rINDEXCLASS)="" Do RebuildIndex^%R()
 s class="" 
 f  s class=$o(^rINDEXCLASS(class)) q:class=""  s package=$$$ClassPackageName(class) s:package'="" packagelist(package)=""
 s package="" f  s package=$$$PACKAGEnext(package) q:package=""  s packagelist($zcvt(package,"u"))=""
 s package="" f  s package=$o(packagelist(package)) q:package=""  d ..list.Insert(package)
 q ..list
}

/// The <b>SumPackage</b> query provides a list of sub-package names.
/// This query works in a hierarchical way, 
/// it returns only one level of sub-package under a specified <var>SuperPackage</var> name.
Query SubPackage() As %Query(ROWSPEC = "Name")
{
}

ClassMethod SubPackageExecute(ByRef QHandle As %Binary, SuperPackage As %String) As %Status
{
 Set QHandle=$lb($g(SuperPackage),$zcvt($g(SuperPackage),"u"))
 Quit $$$OK
}

/// <b>Fetch</b> returns the next row in the query.
ClassMethod SubPackageFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression ]
{
..SubPackageFetchRows(.QHandle,1,.Row,,.AtEnd)
}

/// <b>RoutineListFetchRows</b> returns the next <var>FetchCount</var> rows in the query.
ClassMethod SubPackageFetchRows(ByRef QHandle As %Binary, FetchCount As %Integer = 0, ByRef RowSet As %List, ByRef ReturnCount As %Integer, ByRef AtEnd As %Integer) As %Status [ ProcedureBlock = 1 ]
{
 Set supername=$list(QHandle,1)
 Set superlength=$l(supername)
 Set subpiece=$s(supername="":1,1:$l(supername,".")+1)
 If '$get(FetchCount) Set FetchCount=10000
 If $get(AtEnd) Set QHandle="" Quit $$$OK
 Set AtEnd=0
 Set RowSet=""
 Set ReturnCount=0
 i $g(^%mo("break")) break
 Set class=$list(QHandle,2) For  {
 Set class=$o(^rINDEXCLASS(class))
 Set package=$$$ClassPackageName($li(^rINDEXCLASS(class),2))
 If class="" Set AtEnd=1 Quit
 If $e(package,1,superlength)'=supername Set AtEnd=1 Quit
 If superlength,$l(package)>superlength,$e(package,superlength+1)'="." Set AtEnd=1 Quit
 Set subpackage=$p(package,".",subpiece)
 If subpackage'="" {
 Set RowSet=RowSet_$lb(subpackage)
 Set ReturnCount=ReturnCount+1
 Set header=$p($li(^rINDEXCLASS(class),2),".",1,subpiece)
 For  {
 Set next=$o(^rINDEXCLASS(class))
 If next="" Set AtEnd=1,class="" Quit
 If $p($li(^rINDEXCLASS(next),2),".",1,subpiece)'=header Quit
 Set class=next
 }
 If ReturnCount'<FetchCount Quit
 If $length(RowSet)>10000 Quit
 }
 }
 Set QHandle=$lb(supername,class)
 Quit $$$OK
}

ClassMethod SubPackageClose(QHandle As %Binary) As %Status
{
 Set QHandle=""
 Quit $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.PackageDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
