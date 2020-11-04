/// A content template defines a set of data and layout documents and custom behaviors (code).
Class %ZEN.Mojo.Component.contentTemplate Extends (%ZEN.Component.component, %ZEN.Mojo.localizableObject) [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

/// This component is not visible.
Parameter DEFAULTVISIBLE = 0;

/// Server-side method to provide content to JSON providers.
ClassMethod %GetJSONContent(pProviderName As %String, pKey As %String, ByRef pParms, Output pObject As %RegisteredObject) As %Status [ Final, Internal ]
{
	Set tSC = $$$OK
	Try {
		// convert criteria to object
		Set tSearchTerms = $G(pParms("criteria"))
		Set tCriteria = ""
		If (tSearchTerms'="") {
			Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ParseJSON(tSearchTerms,,.tCriteria)
			If $$$ISERR(tSC) Quit
		}

		// test for initial call v. client call
		Set tLoad = ($G(%zenContext)="page")
		Set tSC = ..%OnGetJSONContent(pProviderName,pKey,.pParms,.pObject,tCriteria,tLoad)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
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
	// override in subclass
	Quit $$$OK
}

/// Submit data handler for content provider.
ClassMethod %SubmitDataHandler(pKey As %String, pID As %String, pSubmitObject As %RegisteredObject, ByRef pResponseObject As %RegisteredObject) As %Status [ Final, Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tSC = ..%OnSubmitData(pKey,pID,pSubmitObject,.pResponseObject)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Submit data handler for content provider.<br/>
/// Overridden by subclasses.
ClassMethod %OnSubmitData(pKey As %String, pID As %String, pSubmitObject As %RegisteredObject, ByRef pResponseObject As %RegisteredObject) As %Status
{
	Set tSC = $$$OK
	Try {
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Client-side method to get the given content object.
/// <var>providerName</var> is the name of json provider.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod getContent(providerName, key, criteria) [ Final, Internal, Language = javascript ]
{
	return this.onGetContent(providerName,key,criteria);
}

/// Client-side content provider method.
/// <var>providerName</var> is the name of the json provider.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(providerName, key, criteria) [ Language = javascript ]
{
	return null;
}

/// Notification that this template was dynamically loaded.
ClientMethod onLoadTemplate() [ Language = javascript ]
{
}

/// Notification that a select event has happened
ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
}

/// Notification that a change event has happened
ClientMethod onchange(key, value, final, docViewId) [ Language = javascript ]
{
}

/// Notification that an event has happened
/// All events except select and change are handled here
ClientMethod onevent(eventType, key, value, docViewId) [ Language = javascript ]
{
}

}
