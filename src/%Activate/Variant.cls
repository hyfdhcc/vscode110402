Include %occActivate

Class %Activate.Variant Extends %RegisteredObject [ System = 3 ]
{

/// This is the type of the variant
Property Type As %Integer;

/// This is the value of the variant
Property Value;

/// This method is passed the initial value and type of the variant
Method %OnNew(initvalue As %CacheString) As %Status [ Private ]
{
	If $Get(initvalue)'="" {
		Set i%Type=$List(initvalue,1),i%Value=$List(initvalue,2)
	}
	Quit $$$OK
}

/// This method creates a Variant of type BOOLEAN whose value is FALSE
ClassMethod FALSE() As %Activate.Variant
{
	Quit ##Class(%Activate.Variant).%New($ListBuild($$$VTBOOL,0))
}

/// This method creates a Variant of type BOOLEAN whose value is TRUE
ClassMethod TRUE() As %Activate.Variant
{
	Quit ##Class(%Activate.Variant).%New($ListBuild($$$VTBOOL,-1))
}

}
