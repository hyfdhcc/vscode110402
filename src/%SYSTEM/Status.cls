Include %occInclude

/// This is a helper class that is used to construct and display/decompose status code
Class %SYSTEM.Status Extends Help [ Abstract, System = 3 ]
{

/// Return an error status code with the error as specified by the <var>errorcode</var>.
/// Some error codes accept addition parameters as embedded message in the error text.
ClassMethod Error(errorcode As %Integer, message1 As %String, message2 As %String, message3 As %String) As %Status [ CodeMode = expression ]
{
$$Error^%apiOBJ(errorcode,.message1,.message2,.message3)
}

/// Return a new status code that is the combination of the two status codes.
/// For example, if both <var>statuscode1</var> and <var>statuscode2</var> contain errors,
/// then the new status code will contain 2 error messages.
ClassMethod AppendStatus(statuscode1 As %Status, statuscode2 As %Status) As %Status [ CodeMode = expression ]
{
$$AppendStatus^%occSystem(statuscode1,statuscode2)
}

ClassMethod EmbedStatus(statuscode1 As %Status, statuscode2 As %Status) As %Status [ CodeMode = expression ]
{
$$EmbedStatus^%apiOBJ(statuscode1,statuscode2)
}

/// Returns 1 if the <var>statuscode</var> contains errors.  Otherwise, it returns 0.
ClassMethod IsError(statuscode As %Status) As %Boolean [ CodeMode = expression ]
{
'statuscode
}

/// Returns 1 if the <var>statuscode</var> does not contain errors.  Otherwise, it returns 0.
ClassMethod IsOK(statuscode As %Status) As %Boolean [ CodeMode = expression ]
{
''statuscode
}

/// Display the error text for <var>statuscode</var>.
ClassMethod DisplayError(statuscode As %Status) As %Status [ CodeMode = expression ]
{
$$DisplayError^%occSystem(statuscode)
}

/// Returns the error text and error information for <var>statuscode</var>.
/// The information is returned through the <var>errorlist</var> parameter.
/// If the <var>qspec</var> parameter contains "d" flag, then the error text is also displayed to the screen.
/// The user can also specify the language in which the error text is returned using <var>language</var> parameter.
ClassMethod DecomposeStatus(statuscode As %Status, ByRef errorlist, qspec, language) As %Status [ CodeMode = expression ]
{
$$DecomposeStatus^%apiOBJ(statuscode,.errorlist,.qspec,.language)
}

/// Returns the error codes for <var>statuscode</var> in a comma delimited list.
ClassMethod GetErrorCodes(statuscode As %Status) As %String
{
	If $$$ISOK(statuscode) Quit ""
	Set Status=$$DecomposeStatus^%apiOBJ(statuscode,.errorlist)
	Set String=""
	For i=1:1:errorlist Set String=String_$get(errorlist(i,"code"),$$$ERRORCODE($$$UnknownError))_","
	If String="" Set String=$$$ERRORCODE($$$UnknownError)_","
	Quit $extract(String,1,$length(String)-1)
}

/// Returns the error text for <var>statuscode</var>.
/// If there is more than one error in the <var>statuscode</var>, then the multiple error text
/// strings are separated by &lt;CRLF&gt;.
/// The user can also specify the language in which the error text is returned using <var>language</var> parameter.
ClassMethod GetErrorText(statuscode As %Status, language) As %String [ CodeMode = expression ]
{
$$GetErrorText^%apiOBJ(statuscode,.language)
}

/// Returns the error text for the error in the <var>statuscode</var> at position <var>index</var>.
/// The user can also specify the language in which the error text is returned using <var>language</var> parameter.
ClassMethod GetOneErrorText(statuscode As %Status, index As %Integer, language) As %Boolean [ CodeMode = expression ]
{
$$GetOneErrorText^%apiOBJ(statuscode,.index,.language)
}

/// Returns the inner text for the error in the <var>statuscode</var> at position <var>index</var>,.
/// without the error domain,id or source.
/// The user can also specify the language in which the error text is returned using <var>language</var> parameter.
ClassMethod GetOneStatusText(statuscode As %Status, index As %Integer, language) As %Boolean [ CodeMode = expression ]
{
$$GetOneStatusText^%apiOBJ(statuscode,.index,.language)
}

/// Return true if the domain/msgid of <var>statuscode</var> equals any of the following error code domain/msgid arguments
ClassMethod Equals(statuscode As %Status, statusids...) As %Boolean [ CodeMode = expression ]
{
$$StatusEqualsArray^%apiOBJ(statuscode,.statusids)
}

/// Returns the success status code.
ClassMethod OK() As %Status [ CodeMode = expression ]
{
$$$OK
}

/// Return an SQLCODE equivalent to the statuscode. <var>message</var> contains the status text. Precise error code to SQLCODE value are
/// only possible for SQLCODE errors - $$$SQLCode and $$$SQLError. All other error numbers translate to -400.
ClassMethod StatusToSQLCODE(statuscode As %Status, Output message As %Library.String(MAXLEN=500), language) As %Integer [ CodeMode = expression ]
{
$$StatusToSQLCODE^%apiOBJ(.statuscode,.message,.language)
}

}
