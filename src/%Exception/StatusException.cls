Include %occErrors

/// Class to hold %Status style exceptions
/// <br>If you wish to create one with %New then the 4th argument is a $lb of data values to the error %Status, e.g.<br>
/// Set exception=##class(%Exception.StatusException).%New(Name,Code,Location,$lb(arg1,arg2,arg3,arg4))
Class %Exception.StatusException Extends %Exception.AbstractException
{

/// Container for additional exceptions in the %Status value
Property NextException As %CacheString;

/// Convert a %Status into an exception
ClassMethod CreateFromStatus(pSC As %Status) As %Exception.AbstractException
{
	#dim tException As %Exception.AbstractException
	#dim tData As %List
	#dim tInfo
	
	Set tException = $$$NULLOREF,innerexception=""
	
	Do decomposeStatus^%occSystem(pSC,.tInfo)
	If $DATA(tInfo(1)) {
		// If there's an embedded error, construct that also
		If $DATA(tInfo(1,"embeddedstatus")) {
			Set innerexception = ..CreateFromStatus(tInfo(1,"embeddedstatus"))
		}
		
		#; See if it should be a %Exception.SystemException
		If tInfo(1,"code")=$$$ERRORCODE($$$CacheError) {
			Set ze=$get(tInfo(1,"param",1)),error=$piece(ze,">")_">",loc=$piece($piece(ze,">",2)," "),extra=$piece($piece(ze,">",2)," ",2,*)
			If $extract(extra)="*" Set extra=$extract(extra,2,*)
			Set tException=##class(%Exception.SystemException).%New(error,$get(tInfo(1,"param",2)),loc,extra,innerexception,$get(tInfo(1,"stack")))
		} Else {
		
			// Build the exception object
			Set tData="" For tI=1:1:9 Set tData=tData_$LB(tInfo(1,"param",tI))
			Set tException = ..%New(tInfo(1,"code"),tInfo(1,"code"),$get(tInfo(1,"caller")),tData,innerexception)
			If $get(tInfo(1,"stack"))'="" Set tException.iStack=tInfo(1,"stack")
			If $data(tInfo(1,"tail")) Set tException.NextException=..CreateFromStatus(tInfo(1,"tail"))
		}
			
	}
	
	Quit tException
}

/// Override this method to provide a custom conversion of an exception to a status
Method OnAsStatus() As %Status [ Private ]
{
	Set ptr=0,data=i%Data
	If $listnext(data,ptr,arg1),$listnext(data,ptr,arg2),$listnext(data,ptr,arg3),$listnext(data,ptr,arg4),$listnext(data,ptr,arg5),$listnext(data,ptr,arg6),$listnext(data,ptr,arg7),$listnext(data,ptr,arg8),$listnext(data,ptr,arg9)
	Set sc=$$$ERROR(i%Code,.arg1,.arg2,.arg3,.arg4,.arg5,.arg6,.arg7,.arg8,.arg9,i%Location,i%iStack)
	If ..NextException'="" Set sc=$$$ADDSC(sc,..NextException.AsStatus())
	Quit sc
}

/// This returns a string that represents the exception. Users should feel free
/// to modify the format in subclasses
Method DisplayString(pLevel As %Integer = 0) As %String
{
	Quit $Justify("",pLevel)_$System.Status.GetErrorText(..AsStatus())
}

/// Override this method to provide a custom conversion of an exception to an SQLCODE value
Method OnAsSQLCODE() As %Integer [ Private ]
{
	if (..Code = $$$SQLCode) || (..Code = $$$SQLError) { set tSQLCODE = $ListGet(..Data,1) if 'tSQLCODE { set tSQLCODE = -400 } }
	elseif ..Code = $$$ProcedureNotFound { set tSQLCODE = -428 }
	elseif ..Code = $$$RoutineCompilationErrorWithInfo {
		set tError = $Piece($Piece($Listget(..Data,2),$$$NL,2)," : ",2)
		if $Extract(tError,1,8) = "SQLCODE=" {
			set tSQLCODE = $Extract(tError,9,*)
		}
		else {
			set tSQLCODE = -400
		}
	}
	else { set tSQLCODE = -400 }
	quit tSQLCODE
}

/// This returns a string that represents the SQL %msg string. Users should feel free
/// to modify the format and content in subclasses
/// DEPRECATED - use AsSQLMessage() instead. Override OnAsSQLMessage() to customize the value returned
/// by AsSQLMessage().
Method SQLMessageString(pLevel As %Integer = 0)
{
	Quit $Justify("",pLevel)_..Name_" "_..Code_" "_..Location_" "_..DisplayString()
}

Method OnAsSQLMessage() As %String(MAXLEN="")
{
	if ..Code = $$$RoutineCompilationErrorWithInfo {
		set tText = $Piece($Listget(..Data,2),$$$NL,2)
		set tError = $Piece(tText," : ",2)
		if $Extract(tError,1,8) = "SQLCODE=" {
			set tMessage = $Piece(tText," : ",3,*)
		}
		else {
			set tMessage = $System.Status.GetErrorText(..AsStatus())
		}
	}
	else {
		set tMessage = $System.Status.GetErrorText(..AsStatus())
	}
	quit tMessage
}

ClassMethod ThrowIfInterrupt(sc As %Status)
{
	If $$$ISOK(sc) Set sc=$$$ERROR($$$GeneralError,"Called ThrowIfInterrupt with a $$$OK status")
	Set code=$$$GETERRORCODE(sc)
	If code=$$$ERRORCODE($$$CacheError),$$$ISINTERRUPT(sc) {
		Set $zerror=$lg($lg($e(sc,3,*),1),2)
		Ztrap $zerror
	} Else {
		Return ..CreateFromStatus(sc)
	}
}

}
