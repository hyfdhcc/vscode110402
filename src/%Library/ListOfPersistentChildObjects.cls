/// This is a customized collection class used by the class definition classes. 
/// It is not intended for use in applications.
Class %Library.ListOfPersistentChildObjects Extends (, %ListOfObjects, %Persistent) [ ClassType = persistent, ClientDataType = HANDLE, Inheritance = right, Not ProcedureBlock, ServerOnly = 0, StorageStrategy = Custom, System = 3 ]
{

Property GlobalReference As %CacheString;

Property OidPrefix As %CacheString;

Property Filters As %CacheString;

/***********************************************************************\
	| id format is $lb(globalreference,oidprefix,elementtype)               |
	\***********************************************************************/
Method %LoadData(id As %String) As %Status [ Private ]
{
 n exclude,filter,i,kind,name
 s i%GlobalReference=$li(id,1)
 s i%OidPrefix=$li(id,2)
 s i%ElementType=$li(id,3)
 s i%Filters=$lg(id,4)
 s i%Size=0
 k i%Data,i%Oref
 n sub s sub="" f  s sub=$o(@i%GlobalReference@(sub)) q:sub=""  d
 . s exclude=0
 . i i%Filters'="" f i=1:1:$l(i%Filters,",") d  q:exclude
 . . s filter=$p(i%Filters,",",i),kind=$e(filter,1),name=$e(filter,2,$l(filter))
 . . i kind="-",$g(@i%GlobalReference@(sub,name)) s exclude=1 q
 . . i kind="+",'$g(@i%GlobalReference@(sub,name)) s exclude=1 q
 . i exclude q
 . d ..InsertObject($$$oidForm(i%OidPrefix_":"_sub))
 q $$$OK
}

/***********************************************************************\
	| %SaveData() first swizzles all objects in, then kill the root global	|
	| then it calls each object to save itsself								|
	\***********************************************************************/
Method %SaveData(id As %String) As %Status [ Private ]
{
 i i%GlobalReference="" q $$$ERROR($$$GlobalReferenceInvalid,"""")
 i i%OidPrefix="" q $$$ERROR($$$OidPrefixInvalid)
 i i%ElementType="" q $$$ERROR($$$ElementTypeInvalid)
 n sc,i,exclude,filter,kind,name
 i id="" s sc=..%IdSet($lb(i%GlobalReference,i%OidPrefix,i%ElementType)) i $$$ISERR(sc) q sc
 #; swizzle everything in now
 s i="" f  s i=..Next(i) q:i=""  d ..GetAt(i)
 #; delete each element in the collection
 n sub s sub="" f  s sub=$o(@i%GlobalReference@(sub)) q:sub=""  d
 . s exclude=0
 . i i%Filters'="" f i=1:1:$l(i%Filters,",") d  q:exclude
 . . s filter=$p(i%Filters,",",i),kind=$e(filter,1),name=$e(filter,2,$l(filter))
 . . i kind="-",$g(@i%GlobalReference@(sub,name)) s exclude=1 q
 . . i kind="+",'$g(@i%GlobalReference@(sub,name)) s exclude=1 q
 . i exclude q
 . s sc=$classmethod(i%ElementType,"%Delete",$$$oidForm(i%OidPrefix_":"_sub))
 #; now save each element
 s sc=$$$OK,i="" f  s i=..Next(i) q:i=""  d  q:$$$ISERR(sc)
 . s sc=$method(..GetAt(i),"%Save")
 q sc
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 i $li(id)="" q $$$ERROR($$$GlobalReferenceInvalid,"""")
 k @$li(id)
 q $$$OK
}

Method GetTransientState() As %String
{
 #define lb(%string)        ##class(%AbstractDefinition).lb(%string)
 #define ll(%string)        ##class(%AbstractDefinition).ll(%string)
 #define li(%string,%piece) ##class(%AbstractDefinition).li(%string,%piece)
 n i,state,one s state=""
 s state=state_$$$lb(i%GlobalReference)
 s state=state_$$$lb(i%OidPrefix)
 s state=state_$$$lb(i%ElementType)
 s i="" f  s i=..Next(i) q:i=""  d
 . s one=$$$lb($$$lb($$$oidPrimary(..GetObjectAt(i)))_$$$lb($method(..GetAt(i),"GetTransientState")))
 . s state=state_one
 QUIT state
}

Method SetTransientState(state)
{
 #define lb(%string)        ##class(%AbstractDefinition).lb(%string)
 #define ll(%string)        ##class(%AbstractDefinition).ll(%string)
 #define li(%string,%piece) ##class(%AbstractDefinition).li(%string,%piece)
 i state="" Quit
 n i,oid,onestate,oref
 s i%GlobalReference=$$$li(state,1)
 s i%OidPrefix=$$$li(state,2)
 s i%ElementType=$$$li(state,3)
 d ..Clear()
 f i=4:1:$$$ll(state) d
 . s oid=$$$oidForm($$$li($$$li(state,i),1)),onestate=$$$li($$$li(state,i),2)
 . s oref=$classmethod(i%ElementType,"%New",oid)
 . d oref.SetTransientState(onestate)
 . d ..Insert(oref)
 Quit
}

Storage Custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.ListOfPersisB30S</StreamLocation>
<Type>%CompleteCustomStorage</Type>
}

}
