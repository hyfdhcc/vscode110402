Include %occActivate

Class %Activate.IEnumVariant Extends %Activate.Interface [ System = 3 ]
{

ClassMethod %GetIID() As %String
{
	Quit "{00020404-0000-0000-C000-000000000046}"
}

/// Return a clone of this enumerator
Method Clone() As %Activate.IEnumVariant
{
 	Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXEnumClone,$ListBuild(i%%IDispatchPtr))
 	If $List(result,1)'=0 $$$ActXRaise(result)
 	Quit ..%New($List(result,2))
}

/// Get the next variant if there is one and return true otherwise return false.
Method Next(ByRef pVariant As %Activate.Variant) As %Boolean
{
	Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXEnumNext,$ListBuild(i%%IDispatchPtr))
 	If $List(result,1)'=0 $$$ActXRaise(result)
 
 	If $List(result,2) {
	 	Set pVariant=..%MakeVariantReturnValue($ListBuild("",$List(result,3),$List(result,4)))
 		Quit 1
 	} else {
	 	Set pVariant=""
	 	Quit 0
 	}
}

/// Reset the enumerator
Method Reset() [ Final ]
{
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXEnumReset,$ListBuild(i%%IDispatchPtr))
 If $List(result,1)'=0 $$$ActXRaise(result)
}

/// Skip the required number of elements, return true if all were skipped, false
/// if end of sequence was reached before skip completed
Method Skip(pCount As %Integer) As %Boolean
{
	Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXEnumSkip,$ListBuild(i%%IDispatchPtr,pCount))
 	If $List(result,1)'=0 $$$ActXRaise(result)
 	Quit $List(result,2)
}

}
