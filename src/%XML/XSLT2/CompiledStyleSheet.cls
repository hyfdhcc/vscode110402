/// Implements an interface to the XSLT2 CompiledStyleSheet. %XML.XSLT2.CompiledStyleSheet should never be
/// created directly with %New(), but via the CreateFromFile() or CreateFromStream() factory methods
Class %XML.XSLT2.CompiledStyleSheet Extends %RegisteredObject
{

/// Use this method a create an instance of an %XML.XSLT2.CompiledStyleSheet from a file path name
ClassMethod CreateFromFile(source As %String, Output compiledStyleSheet As %XML.XSLT2.CompiledStyleSheet, errorHandler As %XML.XSLT.ErrorHandler = {$$$NULLOREF}) As %Status
{
	Try {
		Kill compiledStyleSheet Set compiledStyleSheet=$$$NULLOREF
		Set status=##class(%XML.XSLT2.Transformer).SetupErrorHandler(.errorHandler)
		If status'=$$$OK Quit
		
		// Parse the source
		Set compiledStyleSheet=##class(%XML.XSLT2.CompiledStyleSheet).%New()
		Set status=##class(%Net.Remote.Java.XSLTGateway).CompileXSLFile(source,compiledStyleSheet,errorHandler)
	} Catch exception {
		Set status=$$$ERROR($$$XSLTError,exception.Name_exception.Location_$Select(exception.Data'="":" *"_exception.Data,1:""))
	}
	Quit status
}

/// Use this method to create an instance of an %XML.XSLT2.CompiledStyleSheet from a binary stream
ClassMethod CreateFromStream(stream As %AbstractStream, Output compiledStyleSheet As %XML.XSLT2.CompiledStyleSheet, errorHandler As %XML.XSLT.ErrorHandler = {$$$NULLOREF}) As %Status
{
	Try {
		// Create a Stream Adapter
 		Set streamAdapter=##class(%XML.SAX.StreamAdapter).%New(stream)
 		If '$IsObject(streamAdapter) Set status=%objlasterror Quit
 		
		Set status=##class(%XML.XSLT2.Transformer).SetupErrorHandler(.errorHandler)
		If status'=$$$OK Quit
		
		Kill compiledStyleSheet Set compiledStyleSheet=$$$NULLOREF
		Set compiledStyleSheet=##class(%XML.XSLT2.CompiledStyleSheet).%New()
		
		// Parse the source
		Set status=##class(%Net.Remote.Java.XSLTGateway).CompileXSLStream(streamAdapter,compiledStyleSheet,errorHandler) 
 		Kill %objlasterror 		
	} Catch exception {
		Set status=$$$ERROR($$$XSLTError,exception.Name_exception.Location_$Select(exception.Data'="":" *"_exception.Data,1:""))
	}
	Quit status
}

Method %OnClose() As %Status [ Private, ProcedureBlock = 1 ]
{
	Quit ##class(%Net.Remote.Java.XSLTGateway).ReleaseCompiledXSLT(##this)
}

}
