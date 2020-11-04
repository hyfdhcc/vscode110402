Class %iKnow.Objects.StoredProcBase Extends %SQL.CustomResultSet [ Abstract, System = 4 ]
{

Property lineNumber As %Integer;

Property text As %String;

Property ZCursorId As %Integer [ Private ];

Method %OpenCursor(cursor As %String) As %Library.Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set ..ZCursorId = cursor
		d init^%iKnow.Objects.IO(..ZCursorId)
		d start^%iKnow.Objects.IO()
		
		set ..lineNumber = 0
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

Method %Next(ByRef sc As %Library.Status) As %Library.Integer [ PlaceAfter = %Execute ]
{
	set sc = $$$OK
	#dim ex As %Exception.AbstractException
	#dim result As %Integer = 0
	#dim nLines As %Integer

	Try {
		if (..ZCursorId = "") {
			Quit
		}
		
		set ..lineNumber = ..lineNumber + 1
		
		set nLines = $$getLineCount^%iKnow.Objects.IO()
		
		if (..lineNumber > nLines) {
			set result = 0
			Quit
		}
		
		set ..text = $$getLine^%iKnow.Objects.IO(..lineNumber)
		if ((..lineNumber = nLines) && (..text = "")) {
			set result = 0
			Quit
		}
		set result = 1
		
		set ..%ROWCOUNT = ..%ROWCOUNT + 1
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit result
}

Method %CloseCursor() As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		d stop^%iKnow.Objects.IO()
		set ..ZCursorId = ""
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

}
