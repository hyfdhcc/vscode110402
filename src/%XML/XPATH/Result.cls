Include %occXSLT

/// Subclasses of this class represent the result of a single match following an XPATH expression evaluation
Class %XML.XPATH.Result Extends %Persistent [ StorageStrategy = custom, System = 4 ]
{

// Public Interface

/// This holds the type of the result, $$$XPATHVALUE or $$$XPATHDOM
Property Type As %Integer [ Calculated ];

// Private Implementation

/// This holds the key into ^CacheTemp which holds the results
Property target As %Integer;

Method TypeGet() As %Integer
{
	Quit $$$JobPrivateGlobalRef(i%target)
}

Method %OnClose() As %Status [ Private ]
{
	#; Tidy up temp global storage
	Kill $$$JobPrivateGlobalRef(i%target) Quit $$$OK
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%XML.XPA.ResultS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
