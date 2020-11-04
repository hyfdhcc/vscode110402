/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// This is the base class for the family of class definition classes. 
/// It provides basic functionality used by the class definition classes.
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.AbstractDefinition Extends %Persistent [ Abstract, NoExtent, Not ProcedureBlock, System = 2 ]
{

Method GetTransientState() As %String [ CodeMode = generator ]
{
 n prop,runtimetype
 s %code=0
 $$$GENERATE(" n state,array,key,one s state=""""")
 s prop="" f  s prop=$$$comMemberNext(%class,$$$cCLASSproperty,prop) q:prop=""  d
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated) q
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPtransient) q
 . $$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)
 . i $$$classIsDataType(runtimetype) $$$GENERATE(" s one=..lb(i%"_prop_"),state=state_one") q
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)="%Collection.ArrayOfDT" d  q
 . . $$$GENERATE(" s array="""" s key="""" f  s key=.."_prop_".Next(key) q:key=""""  s array=array_..lb(key)_..lb(.."_prop_".GetAt(key))")
 . . $$$GENERATE(" s one=..lb(array),state=state_one")
 . $$$GENERATE(" i .."_prop_"=$$$NULLOREF s one=..lb(..lb(0)),state=state_one")
 . $$$GENERATE(" e  s one=..lb(..lb(1)_..lb(.."_prop_".GetTransientState())),state=state_one")
 $$$GENERATE(" QUIT state")
 QUIT $$$OK
}

Method SetTransientState(state) [ CodeMode = generator ]
{
 n prop,count,runtimetype
 s %code=0,count=0
 $$$GENERATE(" n array,i")
 s prop="" f  s prop=$$$comMemberNext(%class,$$$cCLASSproperty,prop) q:prop=""  d
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated) q
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPtransient) q
 . s count=count+1
 . $$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)
 . i $$$classIsDataType(runtimetype) $$$GENERATE(" s i%"_prop_"=..li(state,"_count_")") q
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)="%Collection.ArrayOfDT" d  q
 . . $$$GENERATE(" s array=..li(state,"_count_")")
 . . $$$GENERATE(" f i=1:2:..ll(array) d .."_prop_".SetAt(..li(array,i+1),..li(array,i))")
 . i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcollection)="" d  q
 . . $$$GENERATE(" i ..li(..li(state,"_count_"),1) d .."_prop_"NewObject() d .."_prop_".SetTransientState(..li(..li(state,"_count_"),2))")
 . e  d
 . . $$$GENERATE(" i ..li(..li(state,"_count_"),1) d .."_prop_".SetTransientState(..li(..li(state,"_count_"),2))")
 $$$GENERATE(" QUIT")
 QUIT $$$OK
}

ClassMethod lb(str) As %String
{
 q $l(str)_" "_str
}

ClassMethod li(alist, piece) As %String
{
 i $g(alist)="" q ""
 s piece=$g(piece,1)
 n len,ptr,cnt,i,l,return
 s len=$l(alist),ptr=1,return=""
 f cnt=1:1 d  q:cnt=piece  q:ptr>len
 . f i=ptr:1:len+1 q:$e(alist,i)=" "
 . i i>len s ptr=len+2 q
 . s l=$e(alist,ptr,i-1)
 . i cnt=piece s return=$e(alist,i+1,i+l) q
 . s ptr=i+l+1
 q return
}

ClassMethod ll(alist) As %String
{
 i $g(alist)="" q 0
 n len,ptr,cnt,i,l
 s len=$l(alist),ptr=1
 f cnt=1:1 d  q:ptr>len
 . f i=ptr+1:1:len+1 q:$e(alist,i)=" "
 . i i>len s ptr=len+2 q
 . s l=$e(alist,ptr,i-1)
 . s ptr=i+l+1
 i ptr'=(len+1) q -1
 q cnt
}

Storage Default
{
<Data name="AbstractDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^%Library.AbstractDefinitionD</DataLocation>
<DefaultData>AbstractDefinitionDefaultData</DefaultData>
<IdLocation>^%Library.AbstractDefinitionD</IdLocation>
<IndexLocation>^%Library.AbstractDefinitionI</IndexLocation>
<StreamLocation>^%Library.AbstractDefinitionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
