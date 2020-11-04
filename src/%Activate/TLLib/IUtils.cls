Include %occActivate

Class %Activate.TLLib.IUtils Extends %Activate.Interface [ Not ProcedureBlock, System = 3 ]
{

/// Type Libraries Collection
Property Libraries As %Activate.TLLib.ILibraries [ Calculated ];

ClassMethod %GetIID() As %String [ Final, Language = cache ]
{
 Quit "{400C65FF-DB40-11D4-95D0-00C04F60B2F5}"
}

/// Type Libraries Collection
Method LibrariesGet() As %Activate.TLLib.ILibraries [ Final, Language = cache ]
{
 New result,parms
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,1)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvoke,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 New retval If $List(result,3)=0 Set retval=$$$NULLOREF
 Else  Do
 . Set retval=##Class(%Activate.TLLib.ILibraries).%New($List(result,3))
 . If retval=$$$NULLOREF $$$ActXRaise($ListBuild("Cannot Create Dispatch Object"))
 Quit retval
}

}
