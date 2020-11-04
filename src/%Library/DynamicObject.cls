Include (%occInclude, %occDynamicDispatch, %PVA)

/// Dynamic Object type class.
Class %Library.DynamicObject Extends %Library.DynamicAbstractObject [ Final ]
{

Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
    	try {
	    d $zu(210,7,$$$PVTYPEOBJECT)
	} catch { do $$$APPERROR1($$$LASTERROR) }
	return $$$OK
}

///  Property dispatch method to catch references to 
///  virtual properties. <br>
///  This should not be called directly.<br>
Method %DispatchGetProperty(propertyName As %String(MAXLEN="")) [ Internal, ServerOnly = 1 ]
{
    try {
	set ans = $zu(210,4,.propertyName)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ans
}

///  Property dispatch method to catch references to 
///  virtual properties.<br>
///  This should not be called directly.<br>
Method %DispatchSetProperty(propertyName As %String(MAXLEN=""), value As %String(MAXLEN="")) [ Internal, ServerOnly = 1 ]
{
	try {
		set ans = $zu(210,5, .propertyName, .value)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	return ans
}

/// Given the key value of a key/value pair in an object, return the actual value that corresponds to the key value.
/// If the value does not exist, a null string "" is returned. You can differentiate between an unassigned value
/// that returns a "" string and a real "" string using %GetTypeOf().
/// <p>
/// <b>key</b> The key name of the value you wish to retrieve
/// <p>
/// <b>Returns</b> The value of the data as defined by key.
/// If the value does not exist, a null string "" is returned. You can differentiate between an unassigned value
/// that returns a "" string and a real "" string using %GetTypeOf()
Method %Get(key) As %CacheString
{
	
    try {
	set ans = $zu(210,4,.key)
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
		set ans = $zutil(210,13, .key)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	return ans
}

Method %GetIterator() As %Iterator.Object
{
	return ##class(%Iterator.Object).%New($this)
}

/// Tests if a key is defined within an object.
/// <p>
/// <b>key</b> The key name of the value you wish to test
/// <p>
/// <b>Returns</b> A boolean value to show if a value is defined (1) or not (0).
Method %IsDefined(key) As %Boolean
{
	try {
		set type = $zu(210,13, .key)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	return $case(type,$$$PVVALUEUNASSIGNED:0,$$$PVVALUEEOF:0,:1)
}

/// Remove the element with the named key from the %DynamicObject. If the value of the
/// element is an embedded %DynamicArray or %DynamicObject, remove all subordinate nodes as well.
/// <p>
/// <b>key</b> The key name of the %DynamicObject element you wish to remove
/// <p>
/// <b>Returns</b> The value of the removed %DynamicObject element
Method %Remove(key) As %DynamicAbstractObject
{
	try {
		set ans = $zu(210,21, .key)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	return ans
}

/// Create a new value or update an existing value. 
/// <p>
/// <b>key</b> The key name of the value you wish to create or update.
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
/// <b>Returns</b> An object to the current modified object, allowing calls to set() to be nested.
Method %Set(key, value, type) As %DynamicAbstractObject
{
	try {
		set ans = $zu(210,5, .key, .value, .type)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	return ans
}

}
