/// Implements an interface to the XSLT 2.0 Parser. XML contained in a file 
/// or binary stream may be transformed
Class %XML.XSLT2.Transformer Extends %RegisteredObject
{

/// This method transforms a source file according to an XSL stylesheet and writes the output
/// to the specified output file. If errors occur during processing, callbacks will be made to
/// the supplied error handler. If an error handler is not supplied then the default is to use
/// a newly created instance of %XML.XSLT.ErrorHandler.  The pParams argument is either a CoS
/// array, or %ArrayOfDataTypes of name/value pairs to be passed as $ variables.
ClassMethod TransformFile(pSource As %String, pXSL As %String, pOutput As %String, pErrorHandler As %XML.XSLT.ErrorHandler = {$$$NULLOREF}, ByRef pParams = {$$$NULLOREF}, pCallbackHandler = {$$$NULLOREF}, pResolver As %XML.SAX.EntityResolver = {$$$NULLOREF}) As %Status
{
	Set status=..SetupErrorHandler(.pErrorHandler)
	If status'=$$$OK Quit status
	Set paramList=..BuildParams(.pParams)
	Quit ##class(%Net.Remote.Java.XSLTGateway).TransformFileFile(pSource,pXSL,pOutput,pErrorHandler,pCallbackHandler,paramList,pResolver)
}

/// This method transforms a source file according to an XSL stylesheet and writes the output
/// to the specified output file. If errors occur during processing, callbacks will be made to
/// the supplied error handler. If an error handler is not supplied then the default is to use
/// a newly created instance of %XML.XSLT.ErrorHandler.  The pParams argument is either a CoS
/// array, or %ArrayOfDataTypes of name/value pairs to be passed as $ variables.
ClassMethod TransformFileWithCompiledXSL(pSource As %String, pXSL As %XML.XSLT2.CompiledStyleSheet, pOutput As %String, pErrorHandler As %XML.XSLT.ErrorHandler = {$$$NULLOREF}, ByRef pParams = {$$$NULLOREF}, pCallbackHandler = {$$$NULLOREF}, pResolver As %XML.SAX.EntityResolver = {$$$NULLOREF}) As %Status
{
	Set status=..SetupErrorHandler(.pErrorHandler)
	If status'=$$$OK Quit status
	Set paramList=..BuildParams(.pParams)
	Quit ##class(%Net.Remote.Java.XSLTGateway).TransformFileCompiled(pSource,pXSL,pOutput,pErrorHandler,pCallbackHandler,paramList,pResolver)
}

/// This method transforms a source stream according to an XSL stylesheet and writes the output
/// to the supplied binary stream. If errors occur during processing, callbacks will be made to the 
/// supplied error handler. If an error handler is not supplied then the default is to use a newly created 
/// instance of %XML.XSLT.ErrorHandler.  The pParams argument is either a CoS
/// array, or %ArrayOfDataTypes of name/value pairs to be passed as $ variables.
ClassMethod TransformStream(pSource As %AbstractStream, pXSL As %AbstractStream, ByRef pOutput As %BinaryStream = {$$$NULLOREF}, pErrorHandler As %XML.XSLT.ErrorHandler = {$$$NULLOREF}, ByRef pParams = {$$$NULLOREF}, pCallbackHandler = {$$$NULLOREF}, pResolver As %XML.SAX.EntityResolver = {$$$NULLOREF}) As %Status
{
	Set status=$$$OK
	Try {
		// Create a Stream Adapter for Source
 		Set tSource=##class(%XML.SAX.StreamAdapter).%New(pSource)
 		If '$IsObject(tSource) Set status=%objlasterror Quit
 		
 		// Create a Stream Adapter for XSL
 		Set tXSL=##class(%XML.SAX.StreamAdapter).%New(pXSL)
 		If '$IsObject(tXSL) Set status=%objlasterror Quit
 		
		Set status=..SetupErrorHandler(.pErrorHandler)
		If status'=$$$OK Quit
		
		// For certain output streams we must manipulate the translate table
		Set translateTable=""
		Set status=..SetupOutput(.pOutput,.translateTable)
		If status'=$$$OK Quit

		Set paramList=..BuildParams(.pParams)
		Set status=##class(%Net.Remote.Java.XSLTGateway).TransformStream(tSource,tXSL,pOutput,pErrorHandler,pCallbackHandler,paramList,pResolver)
		
		// Restore the translation table if necessary
		If translateTable'="" Set pOutput.TranslateTable=translateTable
	} Catch exception {
		Set status=##class(%Net.Remote.Java.XSLTGateway).%SetStatus(exception)
	}
	Quit status
}

/// This method transforms a source stream according to an XSL stylesheet and writes the output
/// to the supplied binary stream. If errors occur during processing, callbacks will be made to the 
/// supplied error handler. If an error handler is not supplied then the default is to use a newly created 
/// instance of %XML.XSLT.ErrorHandler.  The pParams argument is either a CoS
/// array, or %ArrayOfDataTyoes of name/value pairs to be passed as $ variables.
ClassMethod TransformStreamWithCompiledXSL(pSource As %AbstractStream, pXSL As %XML.XSLT2.CompiledStyleSheet, ByRef pOutput As %BinaryStream = {$$$NULLOREF}, pErrorHandler As %XML.XSLT.ErrorHandler = {$$$NULLOREF}, ByRef pParams = {$$$NULLOREF}, pCallbackHandler = {$$$NULLOREF}, pResolver As %XML.SAX.EntityResolver = {$$$NULLOREF}) As %Status
{
	Set status=$$$OK	
	Try {
		// Create a Stream Adapter for Source
 		Set tSource=##class(%XML.SAX.StreamAdapter).%New(pSource)
 		If '$IsObject(tSource) Set status=%objlasterror Quit
 		
		Set status=..SetupErrorHandler(.pErrorHandler)
		If status'=$$$OK Quit
				
		// For certain output streams we must manipulate the translate table
		Set translateTable=""
		Set status=..SetupOutput(.pOutput,.translateTable)
		If status'=$$$OK Quit
		
		Set paramList=..BuildParams(.pParams)
		Set status=##class(%Net.Remote.Java.XSLTGateway).TransformStream(tSource,pXSL,pOutput,pErrorHandler,pCallbackHandler,paramList,pResolver)
		
		// Restore the translation table if necessary
		If translateTable'="" Set pOutput.TranslateTable=translateTable
	} Catch exception {
		Set status=##class(%Net.Remote.Java.XSLTGateway).%SetStatus(exception)
	}
	Quit status
}

ClassMethod BuildParams(ByRef pParams) As %List [ Private ]
{
	#dim tParamList As %List
	#dim tKey As %String
	Set (tParamList,tKey) = ""
	For {
		Set tKey=$Order(pParams(tKey)) If tKey="" Quit
		Set tParamList=tParamList_$ListBuild(tKey,$Get(pParams(tKey)))
	}
	Quit tParamList
}

ClassMethod SetupErrorHandler(ByRef errorHandler As %XML.XSLT.ErrorHandler) As %Status
{
	Set status=$$$OK
	If '$IsObject(errorHandler) {
		// If one has not been supplied, create an instance of an error handler
		Kill %objlasterror
		Set errorHandler=##class(%XML.XSLT.ErrorHandler).%New()
		If '$IsObject(errorHandler) {
			Set status=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"%XML.XSLT.ErrorHandler"))
		}
	} Else {
		// Ensure the the supplied error handler is a subclass of %XML.XSLT.ErrorHandler
		If errorHandler.%IsA("%XML.XSLT.ErrorHandler")=0 {
			Set status=$$$ERROR($$$InvalidErrorHandler)
		}
	}
	Quit status
}

ClassMethod SetupOutput(ByRef output As %BinaryStream, Output translateTable As %ObjectHandle) As %Status
{
	Set status=$$$OK
	If '$IsObject(output) {
		// If an output stream has not been supplied, create an instance of a global binary stream
		// and use that instead
		Kill %objlasterror
		Set output=##class(%GlobalBinaryStream).%New()
		If '$IsObject(output) {
			Set status=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"%GlobalBinaryStream"))
			Quit
		}	
	} else {
		// Special case for %FileCharacterStream
		If output.%IsA("%FileCharacterStream") {
			Set translateTable=output.TranslateTable,output.TranslateTable="RAW"
		}
	}
	Quit status
}

}
