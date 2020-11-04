Include (%occInclude, %PVA, %Dynamic, %sySystem, %syGluedef)

/// Dynamic Entity base class.
/// 
Class %Library.DynamicAbstractObject Extends %Library.SystemBase [ Abstract, System = 1 ]
{

/// Returns true (1) if instances of this class are also instances of the isclass parameter.
/// That is 'isclass' is a primary superclass of this object.
ClassMethod %IsA(isclass As %String) As %Integer
{
	$$$SystemMethod(Is:0)
}

/// Returns true (1) if this class is inherited either via primary or secondary inheritance from 'isclass'.
ClassMethod %Extends(isclass As %String) As %Integer
{
	$$$SystemMethod(Is:1)
}

/// Return the namespace this oref was created in.
/// This also returns the namespace this class was first referenced in if calling class
/// methods.
ClassMethod %OriginalNamespace() As %String
{
	$$$SystemMethod(ClsNS)
}

/// Return true if this instance is the latest version of this class, and false
/// if the class has been recompiled so there is a newer version on disk
ClassMethod %ClassIsLatestVersion() As %Boolean
{
	Quit $piece($system.CLS.DumpContext(),"^",11)'=0
}

// The following methods may be implemented to resolve unknown methods and properties:

Method %OnClose() As %Status
{
	try {
		do $zutil(210,1)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
    quit $$$OK
}

/// Find out the type of value. 
/// <p><b>Returns</b> One of the following strings are returned.
/// <br> "null"                  - JSON null
/// <br> "boolean"               - Either "true" or "false"
/// <br> "number"                - Any numeric value
/// <br> "oref"                  - A reference to another Cache object
/// <br> "object"                - A nested object
/// <br> "array"                 - A nested array 
/// <br> "string"                - Normal text string
/// <br> "unassigned"            - The value is unassigned
/// 
Method %GetTypeOf(key) As %String
{
    return $CASE(..%GetTypeCodeOf(key),
		$$$PVVALUENULL:"null",
		$$$PVVALUETRUE:"boolean",
		$$$PVVALUEFALSE:"boolean",
		$$$PVVALUEINTEGERPOS:"number",
		$$$PVVALUEINTEGERNEG:"number",
		$$$PVVALUEARRAY:"array",
		$$$PVVALUEOBJECT:"object",
		$$$PVVALUETEXT:"string",
		$$$PVVALUENUMBER:"number",
		$$$PVVALUEOVERFLOW:"illegalvalue",
		$$$PVVALUECACHENUMERIC:"number",
		$$$PVVALUEOREF:"oref",
		$$$PVVALUEUNASSIGNED:"unassigned",
		$$$PVVALUELONGPOS:"number",
		$$$PVVALUELONGNEG:"number",
		$$$PVVALUEBYTE:"string",
		$$$PVVALUEDOUBLE:"number",
		$$$PVVALUESINGLE:"number",
		$$$PVVALUEUTF8:"string",
		$$$PVVALUEEOF:"unassigned",
		:"UNKNOWN")
}

/// Find the size of an %DynamicArray or a %DynamicObject.
/// <p>
/// <b>Returns</b> An integer showing the size of the array or object. In the
/// case of an array, the size includes unassigned entries within the array.  In
/// the case of an object, the size only includes elements that have assigned
/// values.
Method %Size() As %Integer
{
    try {
	return $zu(210,40)
    } catch { do $$$APPERROR1($$$LASTERROR) }
}

/// Given a JSON source, parse the source and return an object of type %DynamicAbstractObject. If an error occurs during parsing,
/// an exception will be thrown.
/// <p><b>str</b> The input can be from a number of sources
/// <p>
///    (1) A string value containing the source.
/// <br>
///    (2) A stream object to read the source from.
/// <br>
///    (3) A file URI where the source can be read. The file must be encoded as UTF-8.
/// <p>
/// <b>Returns</b> An object of type %DynamicAbstractObject containing the parsed JSON. 
/// <p>
/// <b>NOTE:</b> RFC 7159 specifies that the default encoding for JSON values 
/// uses UTF-8.  For non-UNICODE instances of Cache, this implies that it <i>may</i>
/// be necessary to explicitly convert individual values via a call to $ZCONVERT (e.g. $zcvt(value,"I","UTF8") ) or entire streams by setting the TranslateTable attribute
/// of the stream to "UTF8"
/// <EXAMPLE>
///    set filename = "c:/iscsrc/json/greg4.json"
///    set stream = ##class(%Stream.FileCharacter).%New()
///    set sc = stream.LinkToFile(filename)
///    if ('sc) { w "Error on linking file "_filename,!   q }
///    try {
///        set obj = ##class(%DynamicAbstractObject).%FromJSON(stream)
///    } catch ex {
///        w "Error. Unable to parse file "_filename,!
///        w "Error type   "_ex.Name,!
///        w "Error code   "_ex.Code,!
///        w "Error location "_ex.Location,!
///        set obj = ""
///    }
///    q obj
/// </EXAMPLE>
/// <p>
/// <EXAMPLE>
///    set src = "{""name"" : ""greg"", ""weight"" : 220 }"
///    set obj = ##class(%DynamicAbstractObject).%FromJSON(src)
/// </EXAMPLE>
ClassMethod %FromJSON(str) As %DynamicAbstractObject
{
		// If the source is a stream, rewind to the start
	if ($isobject($g(str))) {
		try {
			do str.Rewind()
		} catch {
		}
		if (str.AtEnd) && (str.Size=0) {
			throw ##class(%Exception.General).%New("Unable to read any data from stream")
		}
	}
	set genvar1="",genvar2=""
	try { 
		set ans = $zu(210,0,.str,0,.keymap,.genvar1,.genvar2)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	if ans {
			// Try this as a file stream if str is not an object and the leading character doesn't indicate a JSON array or object
		if ('$isObject(str)) && ('$Find("{[",$Extract($zstrip(str,"<W")))) {
			set stream = ##class(%Stream.FileCharacter).%New()
			set stream.TranslateTable = "UTF8"
			set sc = stream.LinkToFile(str)
			throw:'sc ##class(%Exception.General).%New("%FromJSON - unable to link file "_str)
			do stream.Rewind()
			try { 
				set ans = $zu(210,0,.stream,0,.keymap ,.genvar1,.genvar2)
			} catch {
				do $$$APPERROR1($$$LASTERROR)
			}
		}
	}
	if (ans = 0) {
			// Finished okay
		return genvar1
	}
		// An error occurred
	throw ##class(%Exception.General).%New($lg(genvar2,4),$lg(genvar2,1),"Line "_$lg(genvar2,5)_" Offset "_$lg(genvar2,7))
}

/// INTERNAL ONLY!
/// <br><p>
/// The %FromJSONStats(...) method is for internal use only.  The
/// actions taken by this method may change in the future as additional
/// capabilities are added to %DynamicAbstractObject class objects.
/// 
ClassMethod %FromJSONStats(str, stats) As %DynamicAbstractObject [ Internal ]
{
		// If the source is a stream, rewind to the start
	if ($isobject($g(str))) {
		try {
			do str.Rewind()
		} catch {
		}
		if (str.AtEnd) && (str.Size=0) {
			throw ##class(%Exception.General).%New("Unable to read any data from stream")
		}
	}
	set genvar1="",genvar2=""
	try { 
		set ans = $zu(210,0,.str,16,.keymap,.genvar1,.genvar2)
	} catch {
		do $$$APPERROR1($$$LASTERROR)
	}
	if ans {
			// Try this as a file stream if str is not an object and the leading character doesn't indicate a JSON array or object
		if ('$isObject(str)) && ('$Find("{[",$Extract($zstrip(str,"<W")))) {
			set stream = ##class(%Stream.FileCharacter).%New()
			set stream.TranslateTable = "UTF8"
			set sc = stream.LinkToFile(str)
			throw:'sc ##class(%Exception.General).%New("%FromJSON - unable to link file "_str)
			do stream.Rewind()
			try { 
				set ans = $zu(210,0,.stream,16,.keymap,.genvar1,.genvar2)
			} catch {
				do $$$APPERROR1($$$LASTERROR)
			}
		}
	}
	if (ans = 0) {
			// Finished okay
		set stats = genvar2
		return genvar1
	}
		// An error occurred
	set stats = genvar2
	throw ##class(%Exception.General).%New($lg(genvar2,4),$lg(genvar2,1),"Line "_$lg(genvar2,5)_" Offset "_$lg(genvar2,7))
}

/// Convert a %DynamicAbstractObject into a JSON string.
/// <p> 
/// <b>outstrm</b> is optional. There are a number of possibilities: 
/// <br>(1) Parameter <b>outstrm</b> is not defined and the method is called via 'DO'. In this case the JSON string is written to the current output device. 
/// <br>(2) Parameter <b>outstrm</b> is not defined and the method is called as an expression. In this case the JSON string becomes the value of the expression. 
/// <br>(3) Parameter <b>outstrm</b> is defined. If it is %Stream object then the JSON string will be written to the stream. If <var>outstrm</var> is not an object 
/// and is not null then it is presumed to be a fully qualified file specification. In that case, a <class>%Stream.FileCharacter</class> stream is created, linked to that file 
/// and the JSON string is written to that stream. On completion, this stream is saved. The full path to the file must be defined. If <var>outstrm</var> is an object but is not 
/// an instance of %Stream.Object then an exception will be thrown. 
/// <p>
/// <b>NOTE:</b> RFC 7159 specifies that the default encoding for JSON values 
/// uses UTF-8.  For non-UNICODE instances of Cache, this implies that it <i>may</i>
/// be necessary to explicitly convert individual values via a call to $ZCONVERT (e.g. $zcvt(value,"I","UTF8") ) or entire streams by setting the TranslateTable attribute
/// of the stream to "UTF8"
/// <EXAMPLE>
/// set obj = {"title" : "MR" , "lastname" : "JONES"}
/// set obj.firstname = "JIMMY"
/// do obj.%ToJSON()
/// {"title":"MR","lastname":"JONES","firstname":"JIMMY"}
/// set source = obj.%ToJSON()
/// write source
/// {"title":"MR","lastname":"JONES","firstname":"JIMMY"}
/// </EXAMPLE>
/// 
Method %ToJSON(outstrm As %Stream.Object) As %String
{
	if $D(outstrm) {
		if $isobject(outstrm) {
			if '(outstrm.%IsA("%Stream.Object")) {
				throw ##class(%Exception.General).%New("%ToJSON - argument passed is not an instance of %Stream.Object")
			}
			try {
				set ans = $zu(210,27,outstrm)
			} catch {
				do $$$APPERROR1($$$LASTERROR)
			}
		} elseif outstrm '= "" {
				// Write to a file stream.
			set stream = ##class(%Stream.FileCharacter).%New()
			set stream.TranslateTable = "UTF8"
			set sc = stream.LinkToFile(outstrm)
			throw:'sc ##class(%Exception.General).%New("%FromJSON - unable to link file "_outstrm)
			do stream.Rewind()
			try {
				set ans = $zu(210,27,stream)
				$$$THROWONERROR(sc,stream.%Save())
			} catch {
				do $$$APPERROR1($$$LASTERROR)
			}
		} else {
				#; 'outstrm' must be an object
			do $$$APPERROR1($$$ERVALUE)
		}
	} else {
		try { 
			set ans = $zu(210,27,$QUIT)
		} catch {
			do $$$APPERROR1($$$LASTERROR)
		}
	}
	return ans
}

Method %GetObjectType() As %Integer [ Internal ]
{
	#; Get the type of the top object
	try {
	    set ans = $zu(210,6) 
	} catch { do $$$APPERROR1($$$LASTERROR) }
	return ans
}

/// <p>
/// Perform an iteration of all the values in a %DynamicAbstractObject subclass.
/// <p>
/// In the example below, we will output all values contained in a %DynamicObject.
/// <EXAMPLE>
///    set iter = obj.%GetIterator()
///    while iter.%GetNext(.key , .value ) {
///       write "key = "_key_" , value = "_value,!
///    }
/// </EXAMPLE>
Method %GetIterator() As %Iterator.AbstractIterator [ Abstract ]
{
}

/// INTERNAL ONLY!
/// <br><p>
/// The %SetKeyNameMap(keynamemap) method is for internal use only.  The
/// actions taken by this method may change in the future as additional
/// capabilities are added to %DynamicAbstractObject class objects.
/// 
Method %SetKeyNameMap(keynamemap) As %DynamicAbstractObject [ Internal ]
{
    try {
	d $zu(210,30,keynamemap)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    q ""
}

/// INTERNAL ONLY!
/// <br><p>
/// The %GetKeyNameMap(keynamemap) method is for internal use only.
/// It returns a copy of the Key Name Map associated with an %DynamicAbstractObject.
/// The formats and semantics of a Key Name Map are known only to the routines
/// and methods that implement the %DynamicAbstractObject class and other Dynamic
/// Entity classes.  These formats, semantics, routines and methods may change
/// in the future as additional capabilities are added to %DynamicAbstractObject
/// class objects.
/// 
Method %GetKeyNameMap() As %DynamicAbstractObject [ Internal ]
{
    
    try {
	set ans = $zu(210,31)
    } catch { do $$$APPERROR1($$$LASTERROR) }
    return ans
}

}
