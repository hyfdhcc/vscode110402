Include (%sySystem, %PVA)

Class %Iterator.Object Extends %Iterator.Array [ System = 3 ]
{

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
    set ans = $zu(210,23, ..pvaoref , .pointer , .key , .value)
    set ..pointer = pointer
    q ans
}

}
