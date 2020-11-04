Class %BI.ClassMethodPropList [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Query MethodList(classname As %String) As %Query(ROWSPEC = "Name")
{
}

ClassMethod MethodListExecute(ByRef QHandle As %Binary, classname As %String, kind As %String) As %Status
{
 s kind=$$$cCLASSmethod
 s classname=$$$NormalizeClassname(classname)
 s QHandle=$lb(0,classname,kind,"")
 Quit $$$OK
}

ClassMethod MethodListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 n classname,kind,element
 s AtEnd=$li(QHandle,1),classname=$li(QHandle,2),kind=$li(QHandle,3),element=$li(QHandle,4),Row=""
 i AtEnd q $$$OK
 s element=$$$defMemberNext(classname,kind,element)
 i element="" s AtEnd=1
 e  s Row=$lb(element) i $$$defMemberNext(classname,kind,element)="" s AtEnd=1
 s QHandle=$lb(AtEnd,classname,kind,element)
 q $$$OK
}

ClassMethod MethodListClose(QHandle As %Binary) As %Status
{
 s QHandle=""
 Quit $$$OK
}

Query PropList(classname As %String) As %Query(ROWSPEC = "Name")
{
}

ClassMethod PropListExecute(ByRef QHandle As %Binary, classname As %String, kind As %String) As %Status
{
 s cdef=##class(%Dictionary.CompiledClass).%OpenId(classname) q:cdef="" '$$$OK
 s QHandle=""
 q $$$OK
 /*
 s kind=$$$cCLASSproperty
 s classname=$$$NormalizeClassname(classname)
 s QHandle=$lb(0,classname,kind,"")
 Quit $$$OK
 */
}

ClassMethod PropListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 n prop
 s prop=cdef.Properties.GetNext(.QHandle)
 i (prop'="")&&(prop.Name="%Concurrency") {s prop=cdef.Properties.GetNext(.QHandle)}
 i prop'="" {s Row=$LB(prop.Name)}
 i QHandle="" {s AtEnd=1} else {s AtEnd=0}
 q $$$OK
 /*
 n classname,kind,element
 s AtEnd=$li(QHandle,1),classname=$li(QHandle,2),kind=$li(QHandle,3),element=$li(QHandle,4),Row=""
 i AtEnd q $$$OK
 s element=$$$defMemberNext(classname,kind,element)
 i element="" s AtEnd=1
 e  s Row=$lb(element) i $$$defMemberNext(classname,kind,element)="" s AtEnd=1
 s QHandle=$lb(AtEnd,classname,kind,element)
 q $$$OK
 */
}

ClassMethod PropListClose(QHandle As %Binary) As %Status
{
 s QHandle=""
 Quit $$$OK
}

Storage Default
{
<Data name="ClassMethodPropListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BI.ClassMethodPropListD</DataLocation>
<DefaultData>ClassMethodPropListDefaultData</DefaultData>
<IdLocation>^BI.ClassMethodPropListD</IdLocation>
<IndexLocation>^BI.ClassMethodPropListI</IndexLocation>
<StreamLocation>^BI.ClassMethodPropListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
