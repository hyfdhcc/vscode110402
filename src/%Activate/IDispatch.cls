Include %occActivate

Class %Activate.IDispatch Extends %Activate.Interface [ System = 3 ]
{

ClassMethod %GetIID() As %String
{
	Quit "{00020400-0000-0000-C000-000000000046}"
}

/// Get a named property. Generic objects are not directly aware of the  methods or properties that 
/// the corresponding external ActiveX object implements. This is because the external object provides 
/// a means of mapping names of methods and properties at run-time only. To access a property of a 
/// generic object you must call the GetProperty method naming the property that you wish to access. 
/// Furthermore, for properties that have parameters ( for example, the Item property exposed by 
/// ActiveX collections), you should call the GetPropertyN method where 'N' corresponds to the number 
/// of arguments to the property.
Method GetProperty(Name As %String) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,Name)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ..%MakeVariantReturnValue(result)
}

/// Same as GetProperty() but return the result as a %GlobalBinaryStream
Method GetPropertyAsStream(Name As %String, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,Name)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Get a named property with a single argument
Method GetProperty1(Name As %String, Arg1) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Quit ..%MakeVariantReturnValue(result)
}

/// Same as GetProperty1() but return the result as a %GlobalBinaryStream
Method GetProperty1AsStream(Name As %String, Arg1, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYGET,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method. Generic objects are not directly aware of the  methods or properties that the corresponding external
/// ActiveX object implements. This is because the external object provides a means of mapping names of
/// methods and properties at run-time only. To invoke a method of a generic object you must call the
/// InvokeMethod method naming the method that you wish to access. Furthermore, for methods that
/// have parameters you should call the InvokeMethodN method where 'N' corresponds to the number of 
/// arguments to the property. 
Method InvokeMethod(Name As %String) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ..%MakeVariantReturnValue(result)
}

/// Same as InvokeMethod() but return the result as a %GlobalBinaryStream
Method InvokeMethodAsStream(Name As %String, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method with 1 argument
Method InvokeMethod1(Name As %String, Arg1) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Quit ..%MakeVariantReturnValue(result)
}

/// Same as InvokeMethod1() but return the result as a %GlobalBinaryStream
Method InvokeMethod1AsStream(Name As %String, Arg1, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method with 10 arguments
Method InvokeMethod10(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set parms=parms_..%FormatVariantParam(.Arg8)
 Set parms=parms_..%FormatVariantParam(.Arg9)
 Set parms=parms_..%FormatVariantParam(.Arg10)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Do ..%CopyBack(.Arg8,$$$VTBYREF,$List(result,19),$List(result,18))
 Do ..%CopyBack(.Arg9,$$$VTBYREF,$List(result,21),$List(result,20))
 Do ..%CopyBack(.Arg10,$$$VTBYREF,$List(result,23),$List(result,22))
 Quit ..%MakeVariantReturnValue(result)
}

/// Same as InvokeMethod10() but return the result as a %GlobalBinaryStream
Method InvokeMethod10AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set parms=parms_..%FormatVariantParam(.Arg8)
 Set parms=parms_..%FormatVariantParam(.Arg9)
 Set parms=parms_..%FormatVariantParam(.Arg10)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Do ..%CopyBack(.Arg8,$$$VTBYREF,$List(result,19),$List(result,18))
 Do ..%CopyBack(.Arg9,$$$VTBYREF,$List(result,21),$List(result,20))
 Do ..%CopyBack(.Arg10,$$$VTBYREF,$List(result,23),$List(result,22))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method with 2 arguments
Method InvokeMethod2(Name As %String, Arg1, Arg2) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod2AsStream(Name As %String, Arg1, Arg2, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method with 3 arguments
Method InvokeMethod3(Name As %String, Arg1, Arg2, Arg3) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod3AsStream(Name As %String, Arg1, Arg2, Arg3, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method with 4 arguments
Method InvokeMethod4(Name As %String, Arg1, Arg2, Arg3, Arg4) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod4AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Invoke a named method with 5 arguments
Method InvokeMethod5(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod5AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

Method InvokeMethod6(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod6AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

Method InvokeMethod7(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod7AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

Method InvokeMethod8(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set parms=parms_..%FormatVariantParam(.Arg8)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Do ..%CopyBack(.Arg8,$$$VTBYREF,$List(result,19),$List(result,18))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod8AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set parms=parms_..%FormatVariantParam(.Arg8)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Do ..%CopyBack(.Arg8,$$$VTBYREF,$List(result,19),$List(result,18))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

Method InvokeMethod9(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set parms=parms_..%FormatVariantParam(.Arg8)
 Set parms=parms_..%FormatVariantParam(.Arg9)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Do ..%CopyBack(.Arg8,$$$VTBYREF,$List(result,19),$List(result,18))
 Do ..%CopyBack(.Arg9,$$$VTBYREF,$List(result,21),$List(result,20))
 Quit ..%MakeVariantReturnValue(result)
}

Method InvokeMethod9AsStream(Name As %String, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEFUNC,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(.Arg2)
 Set parms=parms_..%FormatVariantParam(.Arg3)
 Set parms=parms_..%FormatVariantParam(.Arg4)
 Set parms=parms_..%FormatVariantParam(.Arg5)
 Set parms=parms_..%FormatVariantParam(.Arg6)
 Set parms=parms_..%FormatVariantParam(.Arg7)
 Set parms=parms_..%FormatVariantParam(.Arg8)
 Set parms=parms_..%FormatVariantParam(.Arg9)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGenericStream,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Do ..%CopyBack(.Arg2,$$$VTBYREF,$List(result,7),$List(result,6))
 Do ..%CopyBack(.Arg3,$$$VTBYREF,$List(result,9),$List(result,8))
 Do ..%CopyBack(.Arg4,$$$VTBYREF,$List(result,11),$List(result,10))
 Do ..%CopyBack(.Arg5,$$$VTBYREF,$List(result,13),$List(result,12))
 Do ..%CopyBack(.Arg6,$$$VTBYREF,$List(result,15),$List(result,14))
 Do ..%CopyBack(.Arg7,$$$VTBYREF,$List(result,17),$List(result,16))
 Do ..%CopyBack(.Arg8,$$$VTBYREF,$List(result,19),$List(result,18))
 Do ..%CopyBack(.Arg9,$$$VTBYREF,$List(result,21),$List(result,20))
 Quit ..%MakeVariantReturnValue(result,Binary)
}

/// Set a named property value. Generic objects are not directly aware of the  methods or properties that the corresponding external
/// ActiveX object implements. This is because the external object provides a means of mapping names of
/// methods and properties at run-time only. To access a property of a generic object you must call the
/// SetProperty method naming the property that you wish to access. Furthermore, for properties that
/// have parameters ( for example, the Item property exposed by ActiveX collections), you should call
/// the SetPropertyN method where 'N' corresponds to the number of arguments to the property
Method SetProperty(Name As %String, Value) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYPUT,Name)
 Set parms=parms_..%FormatVariantParam(Value)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit
}

/// Set a named property value with 1 argument
Method SetProperty1(Name As %String, Arg1, Value, Binary As %Boolean = 0) [ Final ]
{
 Set parms=$ListBuild(i%%IDispatchPtr,$$$INVOKEPROPERTYPUT,Name)
 Set parms=parms_..%FormatVariantParam(.Arg1)
 Set parms=parms_..%FormatVariantParam(Value)
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXInvokeGeneric,parms)
 If $List(result,1)'=0 $$$ActXRaise(result)
 Do ..%CopyBack(.Arg1,$$$VTBYREF,$List(result,5),$List(result,4))
 Quit
}

}
