Include (%DeepSee.MDX2JSON, %DeepSee)

/// Utilities used in the DeepSee rest services
Class %DeepSee.REST.REST Extends %CSP.REST
{

/// Specifies the default character set for the page.  This can be overriden using the
/// &lt;CSP:CONTENT CHARSET=&gt; tag, or by setting the <b>%response</b>.CharSet property
/// in the <method>OnPreHTTP</method> method.  If this parameter is not specified, then
/// for the default charset is utf-8.
Parameter CHARSET = "utf-8";

/// Specifies the default content type for the page.  This can be overriden using the
/// &lt;CSP:CONTENT TYPE=&gt; tag, or by setting the <b>%response</b>.ContentType property
/// in the <method>OnPreHTTP</method> method.  The default value if this parameter is
/// not set is text/html.
Parameter CONTENTTYPE = "application/json";

/// This parameter influences the CORS support. The default is an empty string meaning 'not specified'.
/// If set to true (1) then CORS processing is ON. If set to false (0) then CORS processing is OFF.
/// If left unset "" then the decision to process CORS is delegated to the setting on the URL map route.
Parameter HandleCorsRequest = 1;

/// This method Gets called prior to dispatch of the request. Put any common code here
/// that you want to be executed for EVERY request. If pContinue is set to 0, the
/// request will NOT be dispatched according to the UrlMap. If this case it's the
/// responsibility of the user to return a response.
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	// Method overridden by DTB220
	Set tSC = $$$OK
	Set pContinue = 1
	Try {
		Set tSC = ..%ValidateRequest(pUrl,pMethod)
		If $$$ISERR(tSC) Quit
		
		// DTB307 - Set the return type according to the Accept type in the request. Default is application/json.
		If ('..AcceptsContentType(..#CONTENTTYPEJSON)) {
			Set tSC=..ReportHttpStatusCode(..#HTTP406NOTACCEPTABLE),pContinue=0
			Quit 
        } 
        Else {   
			// This always returns json
			Set %response.ContentType=..#CONTENTTYPEJSON
        }
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}

	// DTB220
	If $$$ISERR(tSC) {
		Set pContinue = 0
		Do ..%ErrorToJSON(tSC)
	}
	
	Quit $$$OK
}

/// Perform specific validation for the service that will handle the request. This is used
/// as a callback in each service that extends %DeepSee.REST
ClassMethod %ValidateRequest(pUrl As %String, pMethod As %String) As %Status
{
	Quit $$$OK
}

/// Convert a %Status object that contains an error into JSON for transmission back to the client. The error will be located in the same 
/// position within the object as with any JSON MDX resultset return. If there is a reported error, the existence of other properties within the return
/// object is not guaranteed.
ClassMethod %ErrorToJSON(pStatus As %Status) As %Status
{
	// Method added by DTB220
	Set tSC = $$$OK
	Try {
		Set tProvider = ##class(%ZEN.Auxiliary.jsonMDXProvider).%New()
		
		Set tInfoBranch = tProvider.%ConstructNewDynamicObject()
		Set tInfoBranch.Error = tProvider.%StatusToDynamicObject(pStatus)
		
		Set tResultOBJ = tProvider.%ConstructNewDynamicObject()
		Set tResultOBJ.Info = tInfoBranch
	
		Set tSC = tProvider.%ObjectToJSON(tResultOBJ)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This consumes an array and attempts to create a dynamic object out of it. This object can then be further 
/// augmented or pruned, and can be used as a facility for converting the content to JSON.
ClassMethod %CreateObjectFromArray(ByRef pArray, pMetaData As %List, Output pObject) As %Status
{
	// Method added by DTB224
	Set tSC = $$$OK
	Set pObject = $$$NULLOREF
	Try {
		Set tProvider = ##class(%ZEN.Auxiliary.jsonMDXProvider).%New()
		
		If $D(pArray) {
			// Convert the array using the jsonMDXProvider
	    	Set pObject = tProvider.%ArrayToAET(pMetaData,.pArray)		// DTB261
		}
		Else {
			// Create an empty object
			Set pObject = tProvider.%ConstructNewDynamicObject()
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If pObject=$$$NULLOREF {
		Set pObject = tProvider.%ConstructNewDynamicObject()
	}

	Quit tSC
}

/// Given an instance of the jsonMDXProvider, begin executing the query and wait for results. 
/// Quit early if the value supplied by <var>pTimeout</var> is reached.
ClassMethod %WaitForProviderResults(pProvider As %ZEN.Auxiliary.jsonMDXProvider, pTimeout As %Integer) As %Status
{
	// Method added by DTB226
	Set tSC = $$$OK
	Try {
		// Loop in .01s intervals until there are results or the timeout is reached.
		Set tStart = $zh
		Set tTimeElapsed = 0
		Set tQueryStatus=0
		
		// Kick off the query execution
		Set tSC = pProvider.%Execute()
		
		While (tTimeElapsed < pTimeout)&&(tQueryStatus<100)&&($$$ISOK(tSC)) {
			Hang .01			
			// Check query status again
			Set tQueryStatus = pProvider.%ResultSet.%GetStatus()
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

/// This utility assists in constructing a standardized JSON response object from an array
/// of lists, as commonly returned by %DeepSee utilities.
/// The data in <var>pArray</var> must be organized in the form<br>
///   pArray(index) = $LB(data1,data2,data3)<br>
/// where the contents in each list are converted to name-value pairs using the list of labels provided in
/// <var>pMetaData</var>. The array of objects is placed in the Result section of the dynamic object returned
/// via <var>pResponseObj</var>. The specifc node within the Result section is labeled according to the string
/// supplied in <var>pNodeLabel</var>.<br>
/// For convenience, the method may return an instance of the <class>%ZEN.Auxiliary.jsonMDXProvider</class> used
/// to augment the response object with more dynamic objects or arrays, as well as convert the object to JSON when the 
/// response object is complete.
ClassMethod %ConstructResponseFromArray(ByRef pArray, pMetaData As %List = "", pNodeLabel = "ListItems", pFetchStatus As %Status = 1, Output pResponseObj, Output pProvider) As %Status
{
	// Method added by DTB240
	Set tSC = $$$OK
	Try {
		// Create a provider for JSON conversion tools
    	Set pProvider = ##class(%ZEN.Auxiliary.jsonMDXProvider).%New()
		
		// Object for returning items in the list
    	Set pResponseObj = pProvider.%ConstructNewDynamicObject()
    	
    	// Use consistent objects for normalized return
    	Set tInfoObj = pProvider.%ConstructNewDynamicObject()
    	Set tResultObj = pProvider.%ConstructNewDynamicObject()
    	
    	// Don't bother if the array is empty
    	If $D(pArray) {
	    	Set tSC = ..%CreateObjectFromArray(.pArray,pMetaData,.tProxyObj)
	    	If $$$ISERR(tSC) Quit
	    	
	    	Set:$IsObject(tProxyObj.children) $Property(tResultObj,pNodeLabel) = tProxyObj.children
    	}
    	
		Set tInfoObj.Error = pProvider.%StatusToDynamicObject(pFetchStatus)
		
    	Set pResponseObj.Info = tInfoObj
    	Set pResponseObj.Result = tResultObj
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// DeepSee REST APIs permit use of the "/" character in data source names and dimension specs.
/// Given a piece of a <var>pUrl</var> that begins with a data source, this searches for the first valid
/// data source name and returns it. This can be limited by type or a list of types in the comma-delimited
/// list <var>pType</var>. Currently supported datasource types are "kpi" and "cube"<br>
/// The remainder of the URL, if it exists, is returned in the <var>pRemainder</var>.
ClassMethod %ExtractDatasourceName(pUrl = "", pType = "", Output pRemainder As %String, Output pStatus As %Status) As %String
{
	Set pStatus = $$$OK
	Set tDataSource = ""
	Set pRemainder = ""
	Try {
		For tPiece=1:1:$L(pUrl,"/") {
			Set tTestDataSource = $P(pUrl,"/",1,tPiece)

			// Look for datasources of the given type and break out of the loop if discovered.
			Set tDataSourceType = "cube"
			If ($E($$$LOWER(tTestDataSource),*-4,*)=".cube")&&((pType="")||(pType["cube")) {
				Set tDataSourceType = "cube"
				Set tTestDataSource = $E(tTestDataSource,1,*-5)
				
				If ##class(%DeepSee.Utils).%CubeExists(tTestDataSource,.tSC) {
					Set tDataSource = tTestDataSource_"."_tDataSourceType
					Quit
				}
			}
			ElseIf ($E($$$LOWER(tTestDataSource),*-3,*)=".kpi")&&((pType="")||(pType["kpi")) {
				Set tDataSourceType = "kpi"
				Set tTestDataSource = $E(tTestDataSource,1,*-4)
				
				If ##class(%DeepSee.Utils).%KPIExists(tTestDataSource,.tSC) {
					Set tDataSource = tTestDataSource_"."_tDataSourceType
					Quit
				}
			}
			ElseIf ((pType="")||(pType["cube")) {
				// DTB297 - Default case, where there is no recognizable extension
				If ##class(%DeepSee.Utils).%CubeExists(tTestDataSource,.tSC) {
					Set tDataSource = tTestDataSource_"."_tDataSourceType
					Quit
				}
			}
		}
		
		If tDataSource="" {
			Set pStatus = $$$ERROR($$$GeneralError,$$$FormatText("Cannot identify dataSource in URL: %1",pUrl))
			Quit
		}
		
		Set pRemainder = $P(pUrl,"/",tPiece+1,*)
	}
	Catch ex {
		Set pStatus = ex.AsStatus()
	}
	Quit tDataSource
}

}
