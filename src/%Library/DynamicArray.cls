Include (%occInclude, %PVA, %Dynamic, %sySystem, %syGluedef)

/// Dynamic Array type class
Class %Library.DynamicArray Extends %Library.DynamicAbstractObject [ Final ]
{

Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
    try {
	d $zu(210,7,$$$PVTYPEARRAY)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q $$$OK
}

/// Property dispatch method to catch references to
/// virtual properties. <br>
/// This should not be called directly.<br>
Method %DispatchGetProperty(propertyName As %String) [ Internal, ServerOnly = 1 ]
{
    try {
    	set ans = $zu(210,10, .propertyName)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

/// Property dispatch method to catch references to
/// virtual properties.<br>
/// This should not be called directly.<br>
Method %DispatchSetProperty(propertyName As %String(MAXLEN=""), value As %String) [ Internal, ServerOnly = 1 ]
{
    try {
	set ans= $zu(210,17, .propertyName, .value)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

/// Returns the value of the last member of the array. The value is then removed from the array.  Nothing is removed if the array is empty.
/// <p>
/// Note:  Any of the 4 situations causes %Pop() to return the empty string, "":
/// <ul>
/// <li> (1) Popping from an empty array
/// <li> (2) Last member is the empty string
/// <li> (3) Last member is the value null
/// <li> (4) Last member is unassigned
/// </ul>
/// <p>
/// If you want to differentiate between these 4 cases then you must test the array and its last element before calling the %Pop method.
/// <p>
/// <b>Returns</b> The value of the last member of the array.
/// <br>If the array is empty, the method returns the empty string, "".
/// 
Method %Pop() As %CacheString
{
    try {
    	set ans = $zu(210,24)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

/// Remove the element at the specified index position from the %DynamicArray.  If the
/// value of the %DynamicArray element is an embedded %DynamicArray or %DynamicObject, delete all
/// subordinate nodes as well.  All %DynamicArray elements following the removed
/// element will have their subscript position decremented by 1.
/// <p>
/// <b>pos</b> Index position within the %DynamicArray of the element you wish to remove
/// <p>
/// <b>Returns</b> The value of the removed %DynamicArray element.
Method %Remove(pos) As %DynamicAbstractObject
{
    try {
	set ans = $zu(210,19, .pos)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

/// Given the index position of a value in an array, return the actual value that corresponds to the index
/// If the value does not exist, a null string "" is returned. You can differentiate between an unassigned value
/// that returns a "" string and a real "" string using %GetTypeOf().
/// <p>
/// <b>key</b> The index position of the value you wish to retrieve, indexes begin at position 0. This must be passed as a canonical integer value.
/// <p>
/// <b>Returns</b> The value of the data as defined by index position 'key'.
/// If the value does not exist, a null string "" is returned. You can differentiate between an unassigned value
/// that returns a "" string and a real "" string using %GetTypeOf()
Method %Get(key) As %CacheString
{
    
    try {
	set ans = $zu(210,10, .key)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

/// INTERNAL ONLY!
/// <br><p>
/// The %GetTypeCodeOf(key) method is for internal use only.  The
/// actions taken by this method may change in the future as additional
/// capabilities are added to %DynamicAbstractObject class objects.
/// 
Method %GetTypeCodeOf(key) As %Integer [ Internal ]
{
    
    try {
	set ans= $zu(210,11, .key)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

Method %GetIterator() As %Iterator.Array
{
    return ##class(%Iterator.Array).%New($this)
}

/// Tests if a key is defined within an array
/// <p>
/// <b>key</b> The index position of the value you wish to test, indexes begin at position 0. This must be passed as a canonical integer value.
/// <p>
/// <b>Returns</b> A boolean value to show if a value is defined (1) or not (0).
Method %IsDefined(key) As %Boolean
{
    	try {
	    set type = $zu(210,11, .key)
	} catch { do $$$APPERROR1($$$LASTERROR) }
	return $case(type,$$$PVVALUEUNASSIGNED:0,$$$PVVALUEEOF:0,:1)
}

/// <p>
/// Given a new value, append it to the end of the current array, increasing the length of the array. 
/// </p>
/// <p>
/// <b>value</b> The new value to push. 
/// </p>
/// <p>
/// <b>type</b> OPTIONAL, the type of the value to push. 
/// </p>
/// <p>If the type argument is present then it must be one
/// of the following strings:
/// <br> "null"                  - JSON null, must be ""
/// <br> "boolean"               - Either 0 or nonzero integer
/// <br> "number"                - Convert to numeric value
/// <br> "string"                - Convert to text string
/// </p>
/// <p>
/// <b>Returns</b> An oref referencing the current modified array, allowing calls to %Push() to be chained. 
/// </p>
Method %Push(value, type) As %DynamicAbstractObject
{
	try {
#IF 1 ; // This can be removed once $zu(210,20) accepts a type argument
		if $Get(type) = "" {
			set ans = $zu(210,20, .value)
		} else {
			set key = ..%Size()
			set ans = $zu(210,17,.key,.value,.type)
		}
#ELSE ; // This should be the implementation of push, actually, push should be implemented as a CPP method but that is for later. 
		set ans = $zu(210,20, .value,.type)
#ENDIF ;
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	return ans
}

/// Create a new value or update an existing value. 
/// <p>
/// <b>key</b> The index position of the value you wish to create , indexes begin at position 0. This must be passed as a canonical integer value.
/// <p>
/// <b>value</b> The new value with which to update the previous value or create a new value.
/// <p>
/// <b>type</b> OPTIONAL, the type of the value being assigned. 
/// </p>
/// <p>If the type argument is present then it must be one
/// of the following strings:
/// <br> "null"                  - JSON null, must be ""
/// <br> "boolean"               - Either 0 or nonzero integer
/// <br> "number"                - Convert to numeric value
/// <br> "string"                - Convert to text string
/// </p>
/// <p>
/// <b>Returns</b> An object to the current modified array, allowing calls to $set() to be nested.
Method %Set(key, value, type) As %DynamicAbstractObject
{
	try {
		set ans = $zu(210,17, .key, .value,.type)
	} catch { do $$$APPERROR1($$$LASTERROR) }
	return ans
}

}
