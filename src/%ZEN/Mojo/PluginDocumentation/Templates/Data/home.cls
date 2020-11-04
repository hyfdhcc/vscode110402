Class %ZEN.Mojo.PluginDocumentation.Templates.Data.home Extends abstractTemplate
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
/// <var>pWhich</var> is the name of the provider.<br/>
/// <var>pKey</var> is an app-defined key that is used to indicate which content is to be served.<br/>
/// <var>pCriteria</var>is an object containing search criteria. This is used for searching.<br/>
/// <var>pParms</var> is an array of additional parameters from the JSON provider. (not current used).<br/>
/// <var>pObject</var> is the object that will be served to the client in JSON format.<br/>
/// <var>pLoad</var> is true is this is called when the page is first being served. In this case, this method will be 
/// called even though there may a client-side method used to load the content.<br/>
ClassMethod %OnGetJSONContent(pWhich As %String, pKey As %String, ByRef pParms, Output pObject As %RegisteredObject, pCriteria As %RegisteredObject, pLoad As %Boolean = 0) As %Status
{
	
	#dim tSC As %Status = $$$OK
	#dim statementResult As %SQL.StatementResult
	
	set pObject = ##class(%ZEN.proxyObject).%New()
	
	set pObject."pagemanager_menu" = ##class(%ListOfObjects).%New()
	
	set menuEntry = ##class(%ZEN.proxyObject).%New()
	set menuEntry.id = "all"
	set menuEntry.name = "all"
	do pObject."pagemanager_menu".Insert(menuEntry)
		
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare("SELECT parent FROM %Dictionary.CompiledProperty WHERE Name = 'pluginName' AND parent->Super = '%ZEN.Mojo.Plugin.basePageManager'")
	if $$$ISERR(tSC) Quit $$$OK
	
	set statementResult = statement.%Execute()
	
	while statementResult.%Next() {
	
		set menuEntry = ##class(%ZEN.proxyObject).%New()
		set menuEntry.id = $P(statementResult.%Get("parent"),".",$L(statementResult.%Get("parent"),"."))
		set menuEntry.className = statementResult.%Get("parent")
		
		set obj = ##class(%Dictionary.CompiledClass).%OpenId(statementResult.%Get("parent"))
		
		for i=1:1:obj.Parameters.Count() {
			if (obj.Parameters.GetAt(i).Name = "XMLNAME") {
				if (obj.Parameters.GetAt(i).Default '= "") {
					set menuEntry.name = obj.Parameters.GetAt(i).Default
					set menuEntry.id = obj.Parameters.GetAt(i).Default
				} else {
					set menuEntry.name = $P(statementResult.%Get("parent"),".",$L(statementResult.%Get("parent"),"."))	
				}
				quit
			}
			do obj.Parameters.%UnSwizzleAt(i)
		}

		set menuEntry.parent = "all"
		
		do pObject."pagemanager_menu".Insert(menuEntry)	
		
	}
	
	set pObject."helperplugins_menu" = ##class(%ListOfObjects).%New()
	
	set menuEntry = ##class(%ZEN.proxyObject).%New()
	set menuEntry.id = "all"
	set menuEntry.name = "all"
	do pObject."helperplugins_menu".Insert(menuEntry)
		
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare("SELECT parent FROM %Dictionary.CompiledProperty WHERE Name = 'pluginName' AND parent->Super = '%ZEN.Mojo.Plugin.baseHelperPlugin'")
	if $$$ISERR(tSC) Quit $$$OK
	
	set statementResult = statement.%Execute()
	
	while statementResult.%Next() {
	
		set menuEntry = ##class(%ZEN.proxyObject).%New()
		set menuEntry.id = $P(statementResult.%Get("parent"),".",$L(statementResult.%Get("parent"),"."))
		set menuEntry.className = statementResult.%Get("parent")
		
		set obj = ##class(%Dictionary.CompiledClass).%OpenId(statementResult.%Get("parent"))
		
		for i=1:1:obj.Parameters.Count() {
			if (obj.Parameters.GetAt(i).Name = "XMLNAME") {
				if (obj.Parameters.GetAt(i).Default '= "") {
					set menuEntry.name = obj.Parameters.GetAt(i).Default
					set menuEntry.id = obj.Parameters.GetAt(i).Default
				} else {
					set menuEntry.name = $P(statementResult.%Get("parent"),".",$L(statementResult.%Get("parent"),"."))	
				}
				quit
			}
			do obj.Parameters.%UnSwizzleAt(i)
		}
		
		set menuEntry.parent = "all"
		
		do pObject."helperplugins_menu".Insert(menuEntry)	
		
	}
	
	Quit $$$OK
}

}
