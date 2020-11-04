Include (%sySystem, %PVA)

Class %Iterator.Array Extends %Iterator.AbstractIterator [ System = 3 ]
{

Method %OnNew(oref As %Library.DynamicAbstractObject) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set i%pointer = -1
	set ..pvaoref = oref
	return $$$OK
}

/// getNext() advances the iterator and returns true if the iterator is positioned on a valid 
/// element, false if it is beyond the last element. The key for the element is returned in the 
/// first output argument and the value in the second. To call this method, pass the key and 
/// value arguments by reference to receive their return values. 
/// To iterate over an array, use the following pattern: 
/// while iterator.getNext(.key,.value) {
/// 	// key and value now contain the key for the element and value contains the value. 
/// }
/// 
Method %GetNext(Output key, Output value) As %Integer
{
    set pointer = ..pointer
    set ans = $zu(210,22,(..pvaoref+0), .pointer, .value)
    set ..pointer = pointer
    set key = pointer
    q ans
}

}
