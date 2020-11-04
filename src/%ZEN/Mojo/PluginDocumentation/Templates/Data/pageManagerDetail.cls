Class %ZEN.Mojo.PluginDocumentation.Templates.Data.pageManagerDetail Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	//console.log('get content data ' + key);
	return null;
}

/// Server-side method to provide content to JSON providers.<br/>
/// <var>pProviderName</var> is the name of the provider.<br/>
/// <var>pKey</var> is an app-defined key that is used to indicate which content is to be served.<br/>
/// <var>pCriteria</var>is an object containing criteria. If provided it as a %ZEN.proxyObject<br/>
/// <var>pParms</var> is an array of additional parameters from the JSON provider. (not current used).<br/>
/// <var>pResponse</var> is the object that will be served to the client in JSON format.<br/>
/// <var>pLoad</var> is true is this is called when the page is first being served. In this case, this method will be 
/// called even though there may a client-side method used to load the content.<br/>
ClassMethod %OnGetJSONContent(pProviderName As %String, pKey As %String, ByRef pParms, Output pResponse As %RegisteredObject, pCriteria As %RegisteredObject, pLoad As %Boolean = 0) As %Status
{
	set pResponse = ##class(%ZEN.proxyObject).%New()
	
	set class = ##class(%Dictionary.CompiledClass).%OpenId(pCriteria.id)
	
	if ($ISO(class)) {
		
		set pResponse.description = class.Description
		
	} else {
	
		set pResponse.description = ""
			
	}
	
	Quit $$$OK
}

}
