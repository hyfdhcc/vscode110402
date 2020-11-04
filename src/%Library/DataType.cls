/// Cache datatype superclass.
/// <p>Note that data types do not have to inherit from this class
/// in order to be a data type but this is used by the Cache built
/// in data types.
Class %Library.DataType [ ClassType = datatype, System = 1 ]
{

/// Return $$$OK if the value is valid for the datatype, or an error code otherwise.
ClassMethod IsValid(%val As %CacheString) As %Status [ Abstract, ServerOnly = 0 ]
{
	Quit $$$OK
}

}
