/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This class represents a specific <i>class query</i> description for a class contained 
/// within the <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.QueryDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class the query belongs to.
Property ClassName As %CacheString;

/// A string containing the name of the query.
Property Name As %CacheString;

/// A string containing the description of the query.
Property Description As %CacheString;

/// A string containing the list of arguments for the query. These are 
/// the arguments passed via the <b>Execute()</b> method of the 
/// <CLASS>%ResultSet</CLASS> class.
Property FormalSpec As %CacheString;

/// A flag indicating whether the query is internal (1) or not (0).
Property Internal As %CacheString;

/// A string containing the SQL procedure name of the query.
Property SQLName As %CacheString;

/// A flag indicating whether the query is projected as an SQL stored procedure (1) or not (0).
Property SQLProc As %CacheString;

/// The SQL statements to implement this query.
Property SQLQuery As %CacheString;

/// A flag indicating whether the query is projected as an SQL view (1) or not (0).
Property SQLView As %CacheString;

/// If the query is projected as an SQL view, this is a string containing the name of the SQL view.
Property SQLViewName As %CacheString;

/// A string containing the name of the class used for the implementation of the query.
Property Type As %CacheString;

/// An array containing any parameter definitions for the query. The array 
/// keys are the parameter names and the array values are the parameter values.
Property Parameters As array Of %CacheString;

/// Sequence number used to determine order of this item in Studio editor and in XML export format.
Property SequenceNumber As %CacheString;

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
 i initvalue[":"
 i  s i%ClassName=$p(initvalue,":",1),i%Name=$p(initvalue,":",2)
 e  n len s len=$l(initvalue,"."),i%ClassName=$p(initvalue,".",1,len-1),i%Name=$p(initvalue,".",len)
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 s i%ClassName=$$$NormalizeClassname(i%ClassName)
 i i%Name="" q $$$ERROR($$$QueryNameRequired)
 q $$$OK
}

Method %OnValidateObject() As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$QueryNameRequired)
 q $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
 n classname,queryname
 i id[":"
 i  s classname=$p(id,":",1),queryname=$p(id,":",2)
 e  n len s len=$l(id,"."),classname=$p(id,".",1,len-1),queryname=$p(id,".",len)
 s i%ClassName=classname
 s i%Name=queryname
 ;
 s i%Description=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYdescription)
 s i%Type=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYtype)
 ;
 s i%FormalSpec=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYformalspec)
 s i%Internal=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYinternal)
 s i%SQLName=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlname)
 s i%SQLProc=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlproc)
 s i%SQLQuery=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlquery)
 s i%SQLView=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlview)
 s i%SQLViewName=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlviewname)
 s i%SequenceNumber=$$$defMemberKeyGet(classname,$$$cCLASSquery,queryname,$$$cQUERYsequencenumber)
 ;
 n param
 s param="" f  s param=$$$defSubMemberNext(classname,$$$cCLASSquery,queryname,$$$cQUERYparameter,param) q:param=""  d
 . d ..Parameters.SetAt($$$defMemberArrayGet(classname,$$$cCLASSquery,queryname,$$$cQUERYparameter,param),param)
 ;
 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%ClassName="" q $$$ERROR($$$ClassNameRequired)
 i i%Name="" q $$$ERROR($$$QueryNameRequired)
 ;
 n classname,queryname
 s classname=i%ClassName
 s queryname=i%Name
 ;
 i id="" n sc s sc=..%IdSet(classname_":"_queryname) i $$$ISERR(sc) QUIT sc
 ;
 #define SAVEstring(%class,%kind,%member,%keyword,%value) i %value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 #define SAVEnumber(%class,%kind,%member,%keyword,%value) i +%value'=$$$tableDefaultGet(%kind,%keyword) { $$$defMemberKeySet(%class,%kind,%member,%keyword,+%value) } else { $$$defMemberKeyKill(%class,%kind,%member,%keyword) }
 ;
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYdescription,i%Description)
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYtype,i%Type)
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYformalspec,i%FormalSpec)
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYinternal,i%Internal)
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlname,i%SQLName)
 $$$SAVEnumber(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlproc,i%SQLProc)
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlquery,i%SQLQuery)
 $$$SAVEnumber(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlview,i%SQLView)
 $$$SAVEstring(classname,$$$cCLASSquery,queryname,$$$cQUERYsqlviewname,i%SQLViewName)
 $$$SAVEnumber(classname,$$$cCLASSquery,queryname,$$$cQUERYsequencenumber,i%SequenceNumber)
 ;
 $$$defMemberKeyKill(classname,$$$cCLASSquery,queryname,$$$cQUERYparameter)
 n p s p="" f  s p=..Parameters.Next(p) q:p=""  d
 . $$$defSubMemberSet(classname,$$$cCLASSquery,queryname,$$$cQUERYparameter,p,..Parameters.GetAt(p))
 ;
 $$$defMemberSet(classname,$$$cCLASSquery,queryname,"")
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 ;
 q $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n classname,queryname
 s classname=$p(id,":",1)
 s queryname=$p(id,":",2)
 i classname="" q $$$ERROR($$$ClassNameRequired)
 i queryname="" q $$$ERROR($$$QueryNameRequired)
 $$$defMemberKill(classname,$$$cCLASSquery,queryname)
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$H)
 q $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.QueryDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
