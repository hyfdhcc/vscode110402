/// This class is used internally by InterSystems. You should not make direct use of it within your applications.
/// There is no guarantee made about either the behavior or future operation of this class.<p>
/// A content provider supplies a given base page with the information needed to 
/// display dynamic content including data and layout documents and client-side behaviors.<br/>
/// Basically this is a composite group containing multiple JSON providers and logic for
/// client-side caching of the data served by the providers.<br/>
/// The list of provider to create is defined by the <property>providerList</property>.<br/>
/// There is always a pre-defined JSON provider, named "$code" to handle coded values.<br/>
/// In addition to the JSON providers, this component creates an instance of a
/// <class>%ZEN.Mojo.Component.contentTemplate</class> class. This provides a way to
/// inject dynamic behavior (i.e. methods) into a page without having to reload the entire page.
Class %ZEN.Mojo.Component.contentProvider Extends %ZEN.Component.composite [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

Parameter SYSMODULE = "core";

/// This component is not visible.
Parameter DEFAULTVISIBLE = 0;

/// Initial template class.
Property templateClass As %ZEN.Datatype.className;

/// Names of loaded contentTemplate classes supplying the content, indexed by key.
Property templateClassArray As array Of %ZEN.Datatype.className(XMLPROJECTION = "none");

/// Loaded template object(s), indexed by key.
Property templateObjectArray As array Of contentTemplate(XMLPROJECTION = "none");

/// Name (key) of current template object.
Property currTemplate As %ZEN.Datatype.string [ InitialExpression = "$default" ];

/// Csv-list of json providers to create.
Property providerList As %ZEN.Datatype.csv;

/// Similar to the JSON provider's OnGetTargetObject callback. This callback is 
/// invoked to fetch the contents of a given code table.
Property OnGetCodeTable As %ZEN.Datatype.delegator(FORMALSPEC = "&pParameters:%String,*pObject:%RegisteredObject", RETURNTYPE = "%Status", ZENENCRYPT = 0);

/// Similar to the JSON provider's OnGetArray callback. This callback is 
/// invoked to fetch a list of available template classes along with a logical name and other data.
/// This information can be used to drive an application menu from a set of templates.
Property OnGetTemplateList As %ZEN.Datatype.delegator(FORMALSPEC = "&pParameters:%String,*pMetaData,*pData", RETURNTYPE = "%Status", ZENENCRYPT = 0);

/// Add children to this component.
Method %OnAfterCreateComposite() As %Status [ Final ]
{
	Set tSC = $$$OK
	Try {
		// Instantiate the initial template class
		If (..templateClass'="") {
			Set tTemplateObject = $classmethod(..templateClass,"%New")
			Do:$IsObject($G(%page)) %page.%AddComponent(tTemplateObject)
			Do ..templateClassArray.SetAt(..templateClass,"$default")
			Do ..templateObjectArray.SetAt(tTemplateObject,"$default")
		}

		// create any json-providers we need
		Set tSC = ..%OnGetProviderList(.tList)
		If $$$ISERR(tSC) Quit

		Set k = $O(tList(""))
		While (k'="") {
			Set tInfo = $G(tList(k))
			Set tName = $LG(tInfo,1)
			Set tClass = $LG(tInfo,2,"%ZEN.Mojo.Component.mojoJsonProvider")
			Set tProvider = $classmethod(tClass,"%New")
			Set tProvider.id = tName
			Set tProvider.OnGetTargetObject = "GetJSONContent"
			Do ..%AddChild(tProvider)

			// tack on some handy parameters
			// data name (*which*)
			Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
			Set tParm.value = tName
			Do tProvider.parameters.SetAt(tParm,"name")
			Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

			// key value for request: set by client
			Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
			Set tParm.value = ""
			Do tProvider.parameters.SetAt(tParm,"key")
			Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

			// optional search criteria for request: 
			// this is a json-string set by client
			Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
			Set tParm.value = ""
			Do tProvider.parameters.SetAt(tParm,"criteria")
			Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

			// target class
			Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
			Set tParm.value = ..templateClass
			Do tProvider.parameters.SetAt(tParm,"templateClass")
			Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

			// next item
			Set k = $O(tList(k))
		}

		// -------------------------------------
		// add special provider for coded values
		Set tProvider = ##class(%ZEN.Mojo.Component.mojoJsonProvider).%New()
		Set tProvider.id = "$code"
		Set tProvider.OnGetTargetObject = "GetJSONCodeTable"
		Do ..%AddChild(tProvider)

		// key value for request: set by client
		// this is the name of the code table to fetch
		Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
		Set tParm.value = ""
		Do tProvider.parameters.SetAt(tParm,"key")
		Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

		// allCodes value for request: set by client
		// this is a csv list of all codes to fetch (to allow for multiple fetches in one trip)
		Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
		Set tParm.value = ""
		Do tProvider.parameters.SetAt(tParm,"allCodes")
		Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

		// -------------------------------------
		// add special provider for list of templates
		Set tProvider = ##class(%ZEN.Mojo.Component.mojoJsonProvider).%New()
		Set tProvider.id = "$templateList"
		Set tProvider.OnGetArray = "GetTemplateList"
		Do ..%AddChild(tProvider)

		// -------------------------------------
		// add special provider for submitting data
		// this lets it all go through one channel.
		Set tProvider = ##class(%ZEN.Mojo.Component.mojoJsonProvider).%New()
		Set tProvider.id = "$submit"
		Set tProvider.OnSubmitContent = "SubmitJSONContent"
		Do ..%AddChild(tProvider)

		// target class
		Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
		Set tParm.value = ..templateClass
		Do tProvider.parameters.SetAt(tParm,"templateClass")
		Do:$IsObject($G(%page)) %page.%AddComponent(tParm)

		// id value for submit object: set by client
		Set tParm = ##class(%ZEN.Auxiliary.parameter).%New()
		Set tParm.value = ""
		Do tProvider.parameters.SetAt(tParm,"id")
		Do:$IsObject($G(%page)) %page.%AddComponent(tParm)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Return a list defining what JSON providers should be created by this provider.<br/>
/// Returns:<br/>
/// pList(n) = $LB(name,[class])<br/>
Method %OnGetProviderList(Output pList As %List) As %Status
{
	Kill pList
	For n = 1:1:$L(..providerList,",") {
		Set pList($I(pList)) = $LB($P(..providerList,",",n))
	}
	Quit $$$OK
}

/// Load (if needed) and use a new template class with a given namespace and type (local class name).<br/>
/// If <var>key</key> is supplied, use this to keep a cached version of this
/// template object.
ClientMethod loadTemplateNS(ns, type, key) [ Final, Language = javascript ]
{
	key = zenGet(key,'$default');
	var load = true;

	// if type is null, unload the current template
	if (type == null) {
		this.currTemplate = null;
		return;
	}

	// do we have this already
	this.currTemplate = key;
	if (this.templateObjectArray[this.currTemplate]) {
		// assume there are not 2 templates with same name & different ns
		if (this.templateObjectArray[this.currTemplate]._type == type) {
			load = false;
		}
	}

	if (load) {
		var templateObject = zenPage.createComponentNS(ns,type);
		var templateClass = templateObject ? templateObject._serverClass : '';
		this.templateObjectArray[this.currTemplate] = templateObject;
		this.templateClassArray[this.currTemplate] = templateClass;
	}

	var templateObject = this.templateObjectArray[this.currTemplate];
	var templateClass = this.templateClassArray[this.currTemplate];

	// reset default as well
	this.templateClass = templateClass;

	// fix up jsonProvider parameters
	for (var n = 0; n < this.children.length; n++) {
		var child = this.children[n];
		if (child.parameters && child.parameters['templateClass'] && child.OnGetTargetObject) {
			child.parameters['templateClass'].value = templateClass;
			// !!! this causes too many trips !!!
			// but taking it out causes stale data !!!
			child.reloadContents();
		}
	}

	// notify
	if (templateObject && templateObject.onLoadTemplate) {
		templateObject.onLoadTemplate();
	}
}

/// Return the current template object.
ClientMethod getTemplate() [ Final, Language = javascript ]
{
	return this.currTemplate ? this.templateObjectArray[this.currTemplate] : null;
}

/// Return the current template class.
ClientMethod getTemplateClass() [ Final, Language = javascript ]
{
	return this.currTemplate ? this.templateClassArray[this.currTemplate] : '';
}

/// Get the given content object.<br/>
/// <var>which</var> is the name of json provider.
/// <var>key</var> is a key value<br/>
/// <var>force</var> is an optional argument, which if true, forces a server reload of data
/// that comes from a json provider. Otherwise such data is held in a local cache.<br/>
/// 
/// Data is obtained as follows:<br/>
/// First, a call is made to the associated template object's <method>getContent</method>
/// method (if present). This call is passed the <var>which</var> and <var>key</var>
/// arguments. If this call returns a non-null value, then this value is returned.
/// If not, then the local cache is checked (unless <var>force</var> is true). If there
/// is an object in the local cache under the same templateClass, which, and key values, then this
/// value is returned.<br/>
/// Otherwise a request is made via the jsonProvider specified by <var>which</var>.
/// If <var>force</var> is true, the jsonProvider is told to reload its contents from the
/// server. The content object object returned from the json provider is then added to the local
/// cache and this value is returned.<br/>
/// If <var>notify</var> is supplied, then the server update will be performed async (if supported)
/// and notify if a function to call when the update is complete.
/// 
ClientMethod getContent(which, key, criteria, force, notify) [ Final, Language = javascript ]
{
	var content = null;
	var defer = false;
	force = zenGet(force,false);
	criteria = zenGet(criteria);

	if (!which) {
		return null;
	}

	// for debug log
	var action = {id:this.id,which:which,key:key?key:'null',criteria:criteria,force:force,content:null,
				template:'', criteria:criteria,
				fromTemplate:false, fromCache:false,reload:false,defer:false};

	// check template object first (and always)
	// note: changing the template class will invalidate all cached data (except for code tables).
	var templateObject = this.getTemplate();
	if (!content && templateObject && templateObject.getContent) {
		content = templateObject.getContent(which,key,criteria);
	}
	
	// convert criteria object to string
	if (criteria && 'object' == typeof criteria) {
		criteria = JSON.stringify(criteria);
	}

	if (content) {
		action.fromTemplate = true;
		action.template = templateObject._type;
	}
	else {
		// use provider
		// check local cache; 
		var cacheKey = key ? key : 'null';
		var cacheCriteria = criteria ? criteria : 'null';

		if (!force && this._localCache && this._localCache[which] && this._localCache[which][cacheKey]) {
			content = this._localCache[which][cacheKey][cacheCriteria];
		}

		if (content) {
			action.fromCache = true;
		}
		else {
			var json = this.getChildById(which);
			if (json && json.getContentObject) {
				// copy key into json parameters
				if (json.parameters.key) {
					json.parameters.key.value = key;
				}
				if (json.parameters.criteria) {
					json.parameters.criteria.value = criteria;
				}
				var defer = false;
				var reload = force;
				if (!this._lastKey) {
					reload = true;
				}					
				else if (!reload && (this._lastKey && (this._lastKey[which] != key))||(this._lastCriteria && (this._lastCriteria[which] != criteria))) {
					reload = true;
				}
				if (reload) {
					action.reload = true;
					if (notify && json.reloadContentsAsynch) {
						// set up notify function
						var index = this.index;
						var func = function(final) { zenPage.getComponent(index).contentNotify(final,which,key,criteria,notify); }
						json.reloadContentsAsynch(func,200);
						defer = true;
						content = null;
					}
					else {
						json.reloadContents();
						if (json.error) {
							alert(json.error);
						}
					}
				}
				if (!defer) {
					content = json.getContentObject();
					// remember last key/criteria by provider
					if (!this._lastKey) {
						this._lastKey = {};
						this._lastCriteria = {};
					}
					this._lastKey[which] = key;
					this._lastCriteria[which] = criteria;
				}
			}
		}

		if (!defer) {
			// update local cache
			if (!this._localCache) {
				this._localCache = {};
			}
			if (!this._localCache[which]) {
				this._localCache[which] = {};
			}
			if (!this._localCache[which][cacheKey]) {
				this._localCache[which][cacheKey] = {};
			}
			this._localCache[which][cacheKey][cacheCriteria] = content;
			if (notify) {
				notify(true);
			}
		}
	}

	// log request and update
	if (zenPage._zenCPLog) {
		action.content = content;
		action.defer = defer;
		zenPage._zenCPLog.push(action);
		if (zenPage.updateDebugWindow) {
			zenPage.updateDebugWindow();
		}
	}

	return content;
}

/// Internal notification after async reload of contents.
ClientMethod contentNotify(final, which, key, criteria, notify) [ Internal, Language = javascript ]
{
	// !!! invoke user notify in all cases !!!
	if (final) {
		var json = this.getChildById(which);
		if (json && json.getContentObject) {
			var content = json.getContentObject();

			// remember last key/criteria by provider
			if (!this._lastKey) {
				this._lastKey = {};
				this._lastCriteria = {};
			}
			this._lastKey[which] = key;
			this._lastCriteria[which] = criteria;

			// update local cache
			var cacheKey = key ? key : 'null';
			var cacheCriteria = criteria ? criteria : 'null';

			if (!this._localCache) {
				this._localCache = {};
			}
			if (!this._localCache[which]) {
				this._localCache[which] = {};
			}
			if (!this._localCache[which][cacheKey]) {
				this._localCache[which][cacheKey] = {};
			}
			this._localCache[which][cacheKey][cacheCriteria] = content;
		}
	}
	if (notify) {
		notify(final);
	}
}

/// Invalidate the data cache for the given "provider" and key value.
ClientMethod invalidate(which, key) [ Language = javascript ]
{
	if (!which) {
		delete this._localCache;
	}
	else if (this._localCache && this._localCache[which]) {
		if (!key) {
			delete this._localCache[which];
		}
		else {
			delete this._localCache[which][key];
		}
	}

	if (this._lastKey) {
		delete this._lastKey[which];
		delete this._lastCriteria[which];
	}
}

/// Fetch the code table with name <var>key</var>.
/// If <var>force</var>, invalidate the cached value and fetch again.
ClientMethod fetchCodeTable(key, force) [ Final, Language = javascript ]
{
	var codes = null;
	var force = zenGet(force,false);
	if (!key) {
		return null;
	}

	var ckey = key;
	if (!force && this._codeTables) {
		codes = this._codeTables[ckey];
	}

	if (!codes) {
		var json = this.getChildById('$code');
		if (json && json.getContentObject) {
			// copy key into json parameters
			if (json.parameters.key) {
				json.parameters.key.value = key;
			}

			// if not in cache; always reload
			json.reloadContents();
			var data = json.getContentObject();
			if (data && data.codes) {
				codes = data.codes;
			}
		}

		// update code table cache
		if (!this._codeTables) {
			this._codeTables = {};
		}
		this._codeTables[ckey] = codes;
	}
	return codes;
}

/// Submit data to the server for processing.<br/>
/// <var>key</var> is a app-defined key value.<br/>
/// <var>data</var> is an object to submit.<br/>
/// <var>notify</var> is a javascript function. If supplied, the data is submitted asynchronously
/// and this function is called when the operation is complete.<br/>
ClientMethod submitData(key, data, notify) [ Final, Language = javascript ]
{
	var notify = zenGet(notify);
	var response = null;
	// SWI050 - initialize data object if undefined
	if (typeof data === 'undefined' ) {
		data = {};
	}

	var json = this.getChildById('$submit');
	if (json && json.getContentObject) {
		// set json parameters
		if (json.parameters.id) {
			// first test _id, then id
			if (data && 'undefined'!=typeof data._id) {
				json.parameters.id.value = data._id;
			}
			else if (data && 'undefined'!=typeof data.id) {
				json.parameters.id.value = data.id;
			}
			else {
				json.parameters.id.value = '';
			}
		}
		if (json.parameters.templateClass) {
			json.parameters.templateClass.value = this.getTemplateClass();
		}

		json.setContentObject(data);

		// note: if there is a _class property in data, then it will determine
		// what type of object is created on the server.
		json.submitContent(key,'%ZEN.proxyObject',notify,250);
		if (json.error) {
			// !!! dispatch to error handler?
			alert('Error: ' + json.error);
		}

		response = json.getContentObject();
		if (response && response.action=='none') {
			// not handled
			response = null;
		}
	}

	// subsequent call to reload will wipe out the response object
	// return it, in case the caller wants it.
	return response;
}

/// Server-side method to provide content to JSON providers.
ClassMethod GetJSONContent(ByRef pParms, Output pObject As %RegisteredObject) As %Status [ Final, ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		// dispatch to template
		Set tName = $G(pParms("name"))
		Set tKey = $G(pParms("key"))
		Set tTemplateClass = $G(pParms("templateClass"))
		If (tTemplateClass'="") {
			Set tSC = $classmethod(tTemplateClass,"%GetJSONContent",tName,tKey,.pParms,.pObject)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Server-side method to load code tables as JSON.
Method GetJSONCodeTable(ByRef pParms, Output pObject As %RegisteredObject) As %Status [ Final, ZenMethod ]
{
	Set tSC = ..%ValidateCallback("OnGetCodeTable")
	Quit:$$$ISERR(tSC) tSC
	
	Try {
		// invoke callback
		Set tHost = $G(%page)
		If ($IsObject(tHost) && (..OnGetCodeTable '= "")) {
			Set tSC = $method(tHost,..OnGetCodeTable,.pParms,.pObject)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Invoke the OnGetTemplateList callback.
Method GetTemplateList(ByRef pParms, Output pMetaData, Output pData) As %Status [ Final, ZenMethod ]
{
	Set tSC = ..%ValidateCallback("OnGetTemplateList")
	Quit:$$$ISERR(tSC) tSC
	
	Try {
		// invoke callback
		Set tHost = $G(%page)
		If ($IsObject(tHost) && (..OnGetTemplateList '= "")) {
			Set tSC = $method(tHost,..OnGetTemplateList,.pParms,.pMetaData,.pData)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Submit handler for $submit json provider.
/// This is called when the app calls <method>submitData</method>.
Method SubmitJSONContent(pCommand As %String, pProvider As %ZEN.Auxiliary.jsonProvider, pSubmitObject As %RegisteredObject, ByRef pResponseObject As %RegisteredObject) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		// pCommand is key
		Set tKey = pCommand

		Set tID = ""
		Set tParm = pProvider.parameters.GetAt("id")
		If $IsObject(tParm) {
			Set tID = tParm.value
		}

		// dispatch to template
		Set tTemplateClass = ""
		Set tParm = pProvider.parameters.GetAt("templateClass")
		If $IsObject(tParm) {
			Set tTemplateClass = tParm.value
		}

		If (tTemplateClass'="") {
			// default response
			Set pResponseObject = ##class(%ZEN.proxyObject).%New()
			Set pResponseObject.action = "none"

			Set tSC = $classmethod(tTemplateClass,"%SubmitDataHandler",tKey,tID,pSubmitObject,.pResponseObject)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method %ValidateCallback(pCallbackName) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
	Set tMethod = $Property($this,pCallbackName)
	If ($IsObject(tHost) && (tMethod '= "")) {
		$$$comMemberKeyGetLvar(tZENMETHOD,tHost.%ClassName(1),$$$cCLASSmethod,tMethod,$$$cMETHzenmethod)
		If ('tZENMETHOD) {
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Attempt to call non-ZENMethod: %1",tHost.%ClassName(1)_":"_tMethod))
		}
	}
	Quit tSC
}

/// Return the templateInfo list.
ClientMethod getTemplateInfo() [ Final, Language = javascript ]
{
	var info = null;
	var json = this.getChildById('$templateList');
	if (json && json.getContentObject) {
		var data = json.getContentObject();
		if (data && data.children) {
			info = data.children;
		}
	}
	return info;
}

/// Does the actual work of laying out the children of this group.
/// <var>pTuple</var> indicates the current tuple number in the
/// case of a repeatingGroup.
Method %LayoutChildren(pTuple As %Integer = "") [ Final, Private ]
{
	Set $ZT = "Trap"
	#; dispatch to Layout Manager to provide HTML layout
	#; if a *built-in* method; dispatch directly
	If (..layout = "vertical") {
		Do ##class(%ZEN.LayoutManager).vertical($this,pTuple)
	}
	ElseIf (..layout = "horizontal") {
		Do ##class(%ZEN.LayoutManager).horizontal($this,pTuple)
	}
	ElseIf ((..layout = "")||(..layout = "none")) {
		#; no layout
		Do ##class(%ZEN.LayoutManager).default($this,pTuple)
	}
	Else {
		#; dispatch to "%ZEN.LayoutManager:method"
		Set tLayoutClass = "%ZEN.LayoutManager"
		Set tLayoutMethod = ..layout
		Do $zobjclassmethod(tLayoutClass,tLayoutMethod,$this,pTuple)
	}
Done
	Quit
Trap
	Set $ZT=""
	Set tSC = $$$ERROR($$$GeneralError,$ZE)
	Do ##class(%ZEN.Utils).%DisplayErrorHTML($this,tSC)
	Goto Done
}

/// Specifies how components within this group should be layed out. (VALUELIST = ",vertical,horizontal")
Property layout As %ZEN.Datatype.string(MAXLEN = 250, ZENENCRYPT = 0) [ InitialExpression = {..#DEFAULTLAYOUT} ];

}
