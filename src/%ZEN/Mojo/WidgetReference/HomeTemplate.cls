Class %ZEN.Mojo.WidgetReference.HomeTemplate Extends %ZEN.Mojo.Component.contentTemplate [ ProcedureBlock ]
{

Parameter DOMAIN;

/// Server-side method to provide content to JSON providers.
/// <var>pProviderName</var> is the name of the provider.
/// <var>pKey</var> is an app-defined key that is used to indicate which content is to be served.
/// <var>pCriteria</var>is an object containing search criteria. This is used for searching.
/// <var>pParms</var> is an array of additional parameters from the JSON provider. (not current used).
/// <var>pObject</var> is the object that will be served to the client in JSON format.
/// <var>pLoad</var> is true is this is called when the page is first being served. In this case, this method will be 
/// called even though there may a client-side method used to load the content.
ClassMethod %OnGetJSONContent(pProviderName As %String, pKey As %String, ByRef pParms, Output pObject As %RegisteredObject, pCriteria As %RegisteredObject, pLoad As %Boolean = 0) As %Status
{
	set pObject = ##class(%ZEN.proxyObject).%New()

 	if (pKey = "home") {
	 	set pObject.classList = ##class(%ListOfObjects).%New()
 		// construct data bag for the client here and inject into pObject
 		set statement = ##class(%SQL.Statement).%New()
		set sql = "Select parent, _Default from %Dictionary.CompiledParameter WHERE parent LIKE '%ZEN.Mojo.WidgetReference.%Application' AND (ID1 LIKE '%APPLICATIONNAME' OR ID1 LIKE '%HOMEPAGE')"
		set tsc = statement.%Prepare(sql)
		if ($$$ISERR(tsc)) {
			quit $$$OK
		}
		set result = statement.%Execute()
		
		while result.%Next() {
			set class = ##class(%ZEN.proxyObject).%New()
			
			//The first result should be the APPLICATIONNAME Parameter
			set class.pageName = result.%Get("_Default")
			
			//The second result should be the HOMEPAGE Parameter
			do result.%Next()
			set class.link = result.%Get("_Default")
			do pObject.classList.Insert(class)
		}
 	} 

 	quit $$$OK
}

/// Creates the layout object for the page
ClientMethod getLayout(key, criteria) [ Language = javascript ]
{
 	var layout = {};
 	switch(key) { 
 		case 'home' : 
  			// add layout objects to the children array
			layout = {
				children:[
					{type:'$header',caption:'Widget Reference Start Page'},
					{type:'$div',style:'width:80%;padding-left:10%;padding-top:10%;',children:[
						{type:'$listview',inset:true,filter:true,value:'=[classList]',children:[
							{type:'$listviewitem',key:'widgetReferenceLink',value:'=[link]',label:'=[pageName]',clickable:true,labelNoWrapper:false},
						]}
					]}
				]
 			}; 
			break;
 	} 

 	return layout;
}

/// Client-side content provider method.
/// <var>providerName</var> is the name of the json provider. 
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(providerName, key, criteria) [ Language = javascript ]
{
 	switch (providerName)
 	{ 
 		case 'layout': 
  			return this.getLayout(key,criteria);
 	} 

 	// return null -> fetch data from server (if local cache is empty)
 	return null;
}

ClientMethod onchange(key, value, final, docViewId) [ Language = javascript ]
{
	console.log('change ' + key + ' to ' + value);
 	var view = zen(docViewId);
 	switch(key) {
 	}
}

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	console.log(key+': '+value);
 	var view = zen(docViewId);
 	var realKey = key.split(':')[0];
 	switch(realKey) {
	 	case 'widgetReferenceLink':
	 		window.open('./'+value, '_blank');
	 		break;
 	}
}

}
