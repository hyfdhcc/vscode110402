/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>class query</i> description for a compiled class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.CompiledQuery Extends %Persistent [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the query belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the query.
Property Name As %CacheString;

/// A flag indicating whether the query contains an ID column (1) or not (0).
Property ContainId As %CacheString;

/// A string containing a comma-delimited list of the columns returned by the query.
Property RowSpec As %CacheString;

/// A string containing the name of the class used for the implementation of the query.
Property Type As %CacheString;

Method %LoadData(queryId As %String) As %Status [ Private ]
{
 n classname,queryname,%sc
 i queryId[":"
 i  s classname=$p(queryId,":",1),queryname=$p(queryId,":",2)
 e  n len s len=$l(queryId,"."),classname=$p(queryId,".",1,len-1),queryname=$p(queryId,".",len)
 ;
 i $$$comMemberDefined(classname,$$$cCLASSquery,queryname)=0 q $$$ERROR($$$QueryDoesNotExist,classname_":"_queryname)
 ;
 s i%ClassName=classname
 s i%Name=queryname
 s i%Type=$$$comMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYtype)
 ;
 s i%ContainId=+$$$comMemberArrayGet(classname,$$$cCLASSquery,queryname,$$$cQUERYparameter,"CONTAINID")
 s i%RowSpec=$$$comMemberArrayGet(classname,$$$cCLASSquery,queryname,$$$cQUERYparameter,"ROWSPEC")
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 q $$$OK
}

Query QueryInfo(ClassName As %String) As %Query(ROWSPEC = "Name::QueryName,ContainId") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef QHandle As %Binary, ClassName As %String) As %Status
{
 s QHandle=$lb(0,ClassName,"")
 Quit $$$OK
}

ClassMethod QueryInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 n class,query
 s AtEnd=$li(QHandle,1),class=$li(QHandle,2),query=$li(QHandle,3),Row=""
 i AtEnd q $$$OK
 f  s query=$$$comMemberNext(class,$$$cCLASSquery,query) q:query=""  q:'$$$comMemberKeyGet(class,$$$cCLASSquery,query,$$$cQUERYprivate)
 i query="" s AtEnd=1
 e  d  i $$$comMemberNext(class,$$$cCLASSquery,query)="" s AtEnd=1
 . s Row=$lb(query)
 . s Row=Row_$lb(+$$$comMemberArrayGet(class,$$$cCLASSquery,query,$$$cQUERYparameter,"CONTAINID"))
 s QHandle=$lb(AtEnd,class,query)
 Quit $$$OK
}

ClassMethod QueryInfoClose(QHandle As %Binary) As %Status
{
 s QHandle=""
 Quit $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.CompiledQueryS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
