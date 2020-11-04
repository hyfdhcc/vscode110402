Include %occActivate

Class %Activate.TLLib.ILibraries Extends %Activate.Interface [ Not ProcedureBlock, System = 3 ]
{

/// property Count
Property Count As %Integer [ Calculated ];

/// property Item
Property Item As %Activate.Variant [ Calculated ];

ClassMethod %GetIID() As %String [ Final, Language = cache ]
{
 Quit "{DAED686F-DB40-11D4-95D0-00C04F60B2F5}"
}

/// property Count
Method CountGet() As %Integer [ Final, Language = cache ]
{
 New result,parms
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,1)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvoke,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit $List(result,3)
}

/// property Item
Method ItemGet(punIndex As %Integer) As %Activate.Variant [ Final, Language = cache ]
{
 New result,parms
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,0)
 Set parms=parms_..%FormatKnownParam(.punIndex,0,3)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvoke,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ..%MakeVariantReturnValue(result)
}

}
