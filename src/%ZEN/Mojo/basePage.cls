/// Base page for pages within Zen Mojo.
/// This pages provides a standard layout and set of base components.
Class %ZEN.Mojo.basePage Extends %ZEN.Mojo.abstractPage
{

/// This restricts mobile access to this page
/// Calls with WMOBILE=1 are only allowed if this is set to 1
Parameter ALLOWMOBILE = 0;

/// Should point to your remote server broker file
/// e.g. "http://yourcorporateserver:port/csp/yourcspapp/%25CSP.Broker.cls"
Property remoteBrokerAddress As %ZEN.Datatype.string;

/// Class name of application this page belongs to.
/// This is set by the %OnCreateApplication method.
Parameter APPLICATION = "%ZEN.Mojo.baseApplication";

/// Name of content manager "application" that supplies any coded values for this page.
/// This is also used for user event logging.
Parameter APPNAME As String [ Internal ];

/// If not "", then turn on activity logging for this application and use this value
/// as the log name.
Parameter ACTIVITYLOG As String [ Internal ];

/// Displayed name of this page.
/// Overriden by application class.
Parameter PAGENAME = "Zen Mojo";

Parameter LOGICALNAME [ Internal ] = "HOMEPAGE";

/// Starting "area" within the application.
Parameter DEFAULTAREA [ Internal ] = "home";

/// Starting "key1" within the application.
Parameter DEFAULTKEY1 [ Internal ] = "home";

/// Starting "key2" within the application.
Parameter DEFAULTKEY2 [ Internal ];

/// List of JSON providers created for this page.
/// Used by contentProvider.
Parameter PROVIDERLIST = "data,layout";

/// Starting template class for this page
/// Used by contentProvider.
/// This is overriden by application settings, if provided.
Parameter TEMPLATECLASS;

/// If this property is set to true the page will automatically dispatch
/// <METHOD>getContent</METHOD> requests to different templates based on contentProvider name
/// and key.
/// 
/// <PROPERTY>templateDispatchBaseNamespace</PROPERTY> needs to be set if this property
/// is true. The contentProvider name will be added to the <PROPERTY>templateDispatchBaseNamespace</PROPERTY>
/// used for loading a template within this xml namespace and the requested key as a classname.
/// 
/// If the <PROPERTY>templateDispatchBaseNamespace</PROPERTY> is "http://www.intersystems.com/zen/mojo/sample"
/// and the <PARAMETER>PROVIDERLIST</PARAMETER> lists "data,layout" a <METHOD>getContent</METHOD>
/// call for contentProvider 'data' and key 'home' will load a template in the xml namespace
/// "http://www.intersystems.com/zen/mojo/sample/data" and the class name "home" before the template
/// method onGetContent gets invoked. Following the same approach a <METHOD>getContent</METHOD> call
/// for contentProvider 'layout' and key 'home' will load a template in the xml namespace
/// "http://www.intersystems.com/zen/mojo/sample/layout" and the class name "home".
Property templateDispatchMode As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// If <PROPERTY>templateDispatchMode</PROPERTY> is set to true this is the 
/// base xml namespace which is used for loading templates. The name of the 
/// content provider will be added automatically.
Property templateDispatchBaseNamespace As %ZEN.Datatype.string [ InitialExpression = "http://www.intersystems.com/zen/mojo" ];

/// Current "area" we are looking at: "home", etc.
Property currArea As %ZEN.Datatype.string(ZENURL = "area") [ InitialExpression = {..#DEFAULTAREA}, Internal ];

/// Current level one "key" we are looking at. Typically this
/// corresponds to the to top-level choice of the side menu.
Property currKey1 As %ZEN.Datatype.string(ZENURL = "k1") [ InitialExpression = {..#DEFAULTKEY1}, Internal ];

/// Current level one "key" we are looking at. Typically this
/// corresponds to the to second-level choice of the side menu.
Property currKey2 As %ZEN.Datatype.string(ZENURL = "k2") [ InitialExpression = {..#DEFAULTKEY2}, Internal ];

/// If true, show the debug info window.<br/>
/// Turn this on by setting ^ISC.ZenMojo.Debug(APPNAME)=1.
Property debugMode As %ZEN.Datatype.boolean [ InitialExpression = 0, Internal ];

/// Zen Mojo Version
Property zenMojoVersion As %ZEN.Datatype.string [ InitialExpression = {##class(%ZEN.Mojo.Utils).#VERSION} ];

/// This Style block contains page-specific CSS style definitions.
/// This mostly will come from the application class.
XData Style
{
<style type="text/css">
</style>
}

/// This XML block defines the contents of this page.<br/>
/// The base page consists of 3 things:<br/>
/// 1) a contentProvider component that supplies behavior and data via template classes.<br/>
/// 2) an outer set of components displayed when this paged is view by a browser.<br/>
/// 3) an inner panel with a set of page specific components (typically driven by the contentProvider).<br/>
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" xmlns:zenmojo="http://www.intersystems.com/zen/mojo" title="" layout="none" valign="top">

<!-- contentProvider provides document data,layout, and behaviors (templates)
	 properties are set in the %OnAfterCreatePage method.
-->
<zenmojo:contentProvider id="zMojoContentProvider" OnGetCodeTable="GetCodeTable" OnGetTemplateList="GetTemplateList" />

<!-- special contentProvider to supply "sub templates". These are used to provide
	 specialized behavior within the main templates.
 -->
<zenmojo:contentProvider id="zMojoSubtemplateProvider" OnGetTemplateList="GetSubtemplateList" />

<!-- background of entire page -->
<zenmojo:mojoHtml id="zMojoBackgroundDiv" hidden="true" OnDrawContent="ZMojoDrawBackgroundDiv"/>

<!-- group of foreground components -->
<zenmojo:mojoGroup id="zMojoForegroundGroup" layout="none">

<!-- header pane -->
<zenmojo:mojoPane id="zMojoHeaderPane" paneName="pageHeader" layout="none"/>

<zenmojo:mojoGroup id="zMojoContentGroup" layout="none">
<!-- this is the content background image -->
<zenmojo:mojoHtml id="zMojoContentBackground" OnDrawContent="ZMojoDrawContentBackground" />

<!-- this is the actual content -->
<zenmojo:mojoPane id="zMojoContentPane" paneName="pageContents"/>
</zenmojo:mojoGroup>

<!-- this is the footer beneath the content -->
<zenmojo:mojoHtml id="zMojoFooterGroup" OnDrawContent="ZMojoDrawFooterGroup" />
</zenmojo:mojoGroup>

</page>
}

/// This XML block defines the header of this page.
/// Subclasses will replace this.
XData pageHeader [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" xmlns:zenmojo="http://www.intersystems.com/zen/mojo">
<zenmojo:mojoGroup layout="horizontal">
<zenmojo:mojoHtml id="zMojoHeaderImage" OnDrawContent="ZMojoDrawHeaderImage"/>
<zenmojo:mojoHtml id="zMojoQuickLinks" OnDrawContent="ZMojoDrawQuickLinks"/>
<zenmojo:mojoPane paneName="searchBox" />
<zenmojo:mojoPane paneName="searchImage" />
</zenmojo:mojoGroup>
</pane>
}

/// This XML block defines the contents of this page.
/// Subclasses will replace this.
XData pageContents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none" xmlns:zenmojo="http://www.intersystems.com/zen/mojo">
<!-- default content: overridden by subclass -->
<zenmojo:mojoHtml>
<div style="font-family:courier;font-size:100px;text-shadow:2px 2px 2px #808080, 4px 4px 6px white,-4px -4px 6px white;">Zen Mojo</div>
</zenmojo:mojoHtml>
</pane>
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
Method %OnAfterCreatePage() As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ##super()
		If $$$ISERR(tSC) Quit
		
		// check for debug mode
		If (..#APPNAME'="") {
			If +$G(^ISC.ZenMojo.Debug(..#APPNAME)) {
				Set ..debugMode = 1
			}
		}		

		// get application settings
		Set tSettings = ..%GetAppSettings()
		Do tSettings.%CopyToArray(.tArray)
		
		// get list of named links
		// assume every "link*" property is a link
		Set k = $O(tArray("link"))
		While ($E(k,1,4)="link") {
			Do ..linkList.SetAt(tArray(k),k)
			Set k = $O(tArray(k))
		}

		// find template class
		Set tProvider = ..%GetComponentById("zMojoContentProvider")
		If $IsObject(tProvider) {
			Set tProvider.templateClass = tSettings.templateClass
			Set:tProvider.templateClass="" tProvider.templateClass = ..#TEMPLATECLASS
			Set tProvider.providerList = ..#PROVIDERLIST
		}

		// subtemplate should have the same provider list
		Set tSubProvider = ..%GetComponentById("zMojoSubtemplateProvider")
		If $IsObject(tSubProvider) {
			Set tSubProvider.providerList = ..#PROVIDERLIST
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw the HTML div for the entire page background.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
Method ZMojoDrawBackgroundDiv(pSeed As %String) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		If ($IsObject($G(%application)) && ($G(%application).%IsA("%ZEN.Mojo.baseApplication"))) {
			Set tSC = %application.ZMojoDrawBackgroundDiv(..#LOGICALNAME,..currMode)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw the quick links menu
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
Method ZMojoDrawQuickLinks(pSeed As %String) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		If ($IsObject($G(%application)) && ($G(%application).%IsA("%ZEN.Mojo.baseApplication"))) {
			Set tSC = %application.ZMojoDrawQuickLinks(..#LOGICALNAME,..currMode)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw the logo in the header.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
Method ZMojoDrawHeaderImage(pSeed As %String) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		Set tSettings = ..%GetAppSettings()
		If (tSettings.imageLogo'="") {
			&html<<img id="zMojoHeaderLogo" src="#(tSettings.imageLogo)#" alt="Logo"/>>
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw the footer group.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
Method ZMojoDrawFooterGroup(pSeed As %String) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		If ($IsObject($G(%application)) && ($G(%application).%IsA("%ZEN.Mojo.baseApplication"))) {
			Set tSC = %application.ZMojoDrawFooterGroup(..#LOGICALNAME,..currMode)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Draw background of content div.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
Method ZMojoDrawContentBackground(pSeed As %String) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		Set tSettings = ..%GetAppSettings()
		If (tSettings.imageBackground'="") {
			// optional background to show
			Set tOpacity = 0.2
			Set:tSettings.opacityBackground'="" tOpacity = tSettings.opacityBackground
			&html<<div class="zMojoContentBackgroundImage" style="background-image: url(#(tSettings.imageBackground)#);opacity:#(tOpacity)#;"></div>>
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// In non-embed mode, maximum width of page content area.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
ClientMethod getMaxContentWidth() [ Language = javascript ]
{
	return 963;
}

/// Return an object containing the desired width and left (left offset) content panel.
/// This is the width and left offset for the header, content, and footer.
/// Subclasses may override this.
ClientMethod getContentWidth() [ Language = javascript ]
{
	var winWidth = zenGetWindowWidth();

	if (this.isEmbedded()) {
		// take up all space
		var width = winWidth;
		var left = 0;
	}
	else {
		var maxwid = parseInt(this.getMaxContentWidth(),10);
		var left = (winWidth>400) ? 115 : (winWidth/400)*115;
		left = (left > 0) ? left : 0;
		var right = 40;
		var width = winWidth-(left+right);
		width = (width < maxwid) ? width : maxwid;
		width = (width > 0) ? width : 0;
	}
	return {width:width,left:left};
}

/// Return the desired height of the content panel (not including the header and footer).
/// Subclasses may override this.
ClientMethod getContentHeight() [ Language = javascript ]
{
	var winHeight = zenGetWindowHeight();

	if (this.isEmbedded()) {
		// take up all space
		var height = winHeight;
	}
	else {
		var bottomPad = 25;
		var footerHgt = this.getFooterHeight() + bottomPad;
		var headerHgt = this.getHeaderHeight();
		var height = winHeight - (footerHgt+headerHgt);
		height = (height>0) ? height : 0;
	}
	return height;
}

/// Layout handler.<br/>
/// This adjusts the built-in components of the framework.
/// Use <method>adjustContentSize</method> to adjust the size of your content.
ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	if (load) {
		// don't intercept hyperevent errors - using the error callbacks will be impossible otherwise
		// intercept hyper-errors
		// cspHyperEventErrorHandler = function(err) { alert(err.serverText); };

		// set up popstate listener
		try {
			// allocate a unique "session" number for this page
			// as well as a history counter and stack
			this._historySession = Math.floor(Math.random()*1000000);
			this._historyCounter = 0;
			this._historyStack = [];

			var handler = new Function('evt','zenPage.popstateHandler(evt);');
			window.addEventListener('popstate',handler);

			history.replaceState({type:'start',session:this._historySession,counter:this._historyCounter++}, this.currArea, self.document.location);
		}
		catch(ex) {
			// ie8
		}

		// debug
		if (this.debugMode) {
			// log of content requests
			this._zenCPLog = [];
			this.showDebugWindow();
		}
	}

	var winHeight = zenGetWindowHeight();
	var winWidth = zenGetWindowWidth();

	// first set widths;
	// this will then determine the actual heights of the elements;
	var csize = this.getContentWidth();
	var cwid = csize.width ? parseInt(csize.width,10) : 100;

	var fgGroup = zen('zMojoForegroundGroup');
	if (fgGroup) {
		var fgGroupDiv = fgGroup.getEnclosingDiv();
	}
	var bgGroup = zen('zMojoContentBackground');
	if (bgGroup) {
		var bgGroupDiv = bgGroup.getEnclosingDiv();
	}
	var contentGroup = zen("zMojoContentGroup");
	if (contentGroup) {
		var contentGroupDiv = contentGroup.getEnclosingDiv();
	}
	var footerGroup = zen("zMojoFooterGroup");
	if (footerGroup) {
		var footerGroupDiv = footerGroup.getEnclosingDiv();
	}

	// foreground group:
	// this contains the header, content, and footer
	if (fgGroupDiv) {
		fgGroupDiv.style.width = cwid + 'px';
		fgGroupDiv.style.left = csize.left + 'px';
	}

	// content background
	if (bgGroupDiv) {
		bgGroupDiv.style.width = cwid + 'px';
	}

	if (footerGroupDiv) {
		footerGroupDiv.style.width = cwid + 'px';
	}

	// page contents group
	if (contentGroupDiv) {
		contentGroupDiv.style.width =  cwid + 'px';
	}

	// compute heights
	var chgt = this.getContentHeight();
	if (bgGroupDiv) {
		bgGroupDiv.style.height = chgt + 'px';
	}
	if (contentGroupDiv) {
		contentGroupDiv.style.height = chgt + 'px';
	}

	if (load) {
		// reveal background
		var bg = zen("zMojoBackgroundDiv");
		if (bg) {
			bg.setHidden(false);
		}
	}

	// hide header/footer if we are embedded
	if (load && this.isEmbedded()) {
		var header = zen("zMojoHeaderPane");
		if (header) {
			header.setHidden(true);
		}
		if (footerGroup) {
			footerGroup.setHidden(true);
		}
	}
	
	// notify application
	if (this.applicationLayoutHandler) {
		this.applicationLayoutHandler(load);
	}

	// adjust page contents
	this.adjustContentSize(load, cwid, chgt);

	if (load && fgGroupDiv) {
		// reveal foreground
		fgGroupDiv.style.opacity = 1;
	}
}

/// Return the height of the zMojoHeaderPane.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
ClientMethod getHeaderHeight() [ Language = javascript ]
{
	var hgt = 0;
	var header = zen("zMojoHeaderPane");
	if (header && !this.isEmbedded()) {
		hgt = header.getEnclosingDiv().offsetHeight;
	}
	return hgt;
}

/// Return the height of the zMojoFooterGroup.
/// This method will be removed in a future release,
/// in which it will not be necessary to override this method.
ClientMethod getFooterHeight() [ Language = javascript ]
{
	var hgt = 0;
	var footer = zen("zMojoFooterGroup");
	if (footer && !this.isEmbedded()) {
		hgt = footer.getEnclosingDiv().offsetHeight;
	}
	return hgt;
}

/// Force adjustment of content area sizes.
ClientMethod adjustSizes() [ Language = javascript ]
{
	var csize = this.getContentWidth();
	var cwid = csize.width ? parseInt(csize.width,10) : 100;
	var chgt = this.getContentHeight();
	this.adjustContentSize(false,cwid,chgt);
}

/// Adjust size of components within the content area.
ClientMethod adjustContentSize(load, width, height) [ Language = javascript ]
{
}

/// Return the content provider for this page.
ClientMethod getContentProvider() [ Language = javascript ]
{
	return zen('zMojoContentProvider');
}

/// Return the current "template" object.
ClientMethod getTemplate() [ Language = javascript ]
{
	var cp = this.getContentProvider();
	return cp ? cp.getTemplate() : null;
}

/// Load a new "template" object for a "area".
ClientMethod loadTemplateNS(ns, type, area) [ Language = javascript ]
{
	area = zenGet(area,'$default');
	var cp = this.getContentProvider();
	if (cp) {
		cp.loadTemplateNS(ns,type,area);
	}
}

/// Return the subtemplate content provider for this page.
ClientMethod getSubtemplateProvider() [ Language = javascript ]
{
	return zen('zMojoSubtemplateProvider');
}

/// Return the current "sub-template" object.
ClientMethod getSubtemplate() [ Language = javascript ]
{
	var cp = this.getSubtemplateProvider();
	return cp ? cp.getTemplate() : null;
}

/// Load a new "sub-template" object.
ClientMethod loadSubtemplateNS(ns, type, name) [ Language = javascript ]
{
	name = zenGet(name,'$default');
	var cp = this.getSubtemplateProvider();
	if (cp) {
		cp.loadTemplateNS(ns,type,name);
	}
}

/// Return content from the content provider.
/// 
/// The call sequence is:
/// 
/// 	<ol><li>Call onGetContent in the currently loaded template.</li>
/// 	<li>Check the local cache of the content provider for the providerName/key/criteria combination.</li>
/// <li>Call %OnGetJSONContent in the currently loaded template. (server call)</li></ol>
/// 
/// <p>In case one of the above methods returns anything except <var>null</var> this
/// will be used as the return value. Otherwise the next step in the call sequence is taken.</p>
/// 
/// <var>providerName</var>	Type: string.<br/>
/// 							The provider which is asked to return data.<br/><br/>
/// <var>key</var>			Type: string.<br/>
/// 							The key identifies which data bundle should be returned
/// 							by the provider.<br/><br/>
/// <var>criteria</var>		Type: JSON object.<br/>
/// 							No specific structure enforced. Can be used to
/// 							provide additional arguments to the provider.<br/><br/>
/// <var>force</var>		Type: Boolean - Defaults to false<br/>
/// 							If false, data gets returned from the local cache if present
/// 							If true, the local cache is cleared before the provider is called<br/><br/>
/// <var>notify</var>		Type: Function<br/>
/// 							If omitted a potential call to the server will be synchronous.
/// 							You can provide a notify function which gets called  every 200ms, until
/// 							the call to the server is finished and data is stored in the local cache.
/// 							The function takes one argument (final) which is false until the call is
/// 							finished and true for the final call.<br/><br/>
ClientMethod getContent(providerName, key, criteria, force, notify) [ Language = javascript ]
{
	key = zenGet(key);
	force = zenGet(force,false);
	criteria = zenGet(criteria);
	
	if (this.templateDispatchMode && this.templateDispatchBaseNamespace != '') {
		var newArea = providerName+'-'+key.split(':')[0];
		if (this.currArea !== newArea) {
			this.currArea = newArea;
			zenPage.loadTemplateNS(this.templateDispatchBaseNamespace+'/'+providerName,key.split(':')[0],newArea);
		}
	}
	
	// test for subtemplate
	var sub = this.getSubtemplate();
	if (sub) {
		var scp = this.getSubtemplateProvider();
		if (scp) {
			var content = scp.getContent(providerName,key,criteria,force,notify);
			if (content && content!='none') {
				return content;
			}
		}
	}

	var cp = this.getContentProvider();
	var content = cp.getContent(providerName,key,criteria,force,notify);
	return content;
}

/// Submit data to the server for processing.<br/>
/// <var>key</var> is a app-defined key value.<br/>
/// <var>data</var> is an object to submit.<br/>
/// <var>notify</var> is a javascript function. If supplied, the data is submitted asynchronously
/// and this function is called when the operation is complete.
ClientMethod submitData(key, data, notify) [ Language = javascript ]
{
	if (this.templateDispatchMode && this.templateDispatchBaseNamespace != '') {
		var newArea = 'data-'+key.split(':')[0];
		if (this.currArea !== newArea) {
			this.currArea = newArea;
			zenPage.loadTemplateNS(this.templateDispatchBaseNamespace+'/data',key.split(':')[0],newArea);
		}
	}
	
	// test for subtemplate
	var sub = this.getSubtemplate();
	if (sub) {
		var scp = this.getSubtemplateProvider();
		if (scp) {
			var response = scp.submitData(key,data,notify?notify:null);
			if (response && response!='none') {
				return response;
			}
		}
	}

	var cp = this.getContentProvider();
	return cp.submitData(key,data,notify?notify:null);
}

/// Return the current application "area".
ClientMethod getCurrArea() [ Language = javascript ]
{
	return this.currArea;
}

/// Version of gotoArea for keyboard events.
ClientMethod gotoAreaKB(evt, area, key1, key2, nohistory) [ Language = javascript ]
{
	evt = evt ? evt : window.event;

	if (evt&&evt.type=='keydown') {
		if (evt.keyCode == zenENTER) {
			this.gotoArea(area,zenGet(key1),zenGet(key2),zenGet(nohistory,false));
			return false;
		}
	}
	return true;
}

/// Push the given "state" onto the history stack.
ClientMethod pushState(type, area, key1, key2) [ Language = javascript ]
{
	if (history && history.pushState) {
		this._historyCounter++;
		var state = {type:type,session:this._historySession,counter:this._historyCounter,area:area,key1:zenGet(key1),key2:zenGet(key2)};
		// we can't trust the browser state; user our own stack
		this._historyStack.push(state);
		history.pushState(state, this.currArea, self.document.location);
	}
}

/// Pop the most recent "state" onto the local history stack.
/// (but do not modify the browser history).
ClientMethod popState() [ Language = javascript ]
{
	this._historyStack.pop();
}

/// Navigate to a new "area" and subsection.
/// If <var>nohistory</var> is true, then do not push this change onto the history stack.
ClientMethod gotoArea(area, key1, key2, nohistory) [ Language = javascript ]
{
	if (this.currArea!=area) {

		nohistory = zenGet(nohistory,false);
		if (!nohistory) {
			// push onto history
			this.pushState('area',this.currArea,this.currKey1,this.currKey2);
		}

		this.currArea = area;

		// get template for area
		var info = this.getTemplateForArea(area);
		if (info && info.templateClass) {
			zenPage.loadTemplateNS(info.namespace,info.templateClass,area);
		}
	}
	this.gotoSection(zenGet(key1,'home'),zenGet(key2));
}

/// Navigate to a subsection within the current "area".
ClientMethod gotoSection(key1, key2) [ Internal, Language = javascript ]
{
	key1 = zenGet(key1,'home');
	key2 = zenGet(key2,'');

	// update our keys
	this.currKey1 = key1;
	this.currKey2 = key2;

	// notify subclass in order to update components.
	this.changeAreaHandler();

	this.updateDebugWindow();
}

/// For a given "area", return the template class.<br/>
/// This methods looks up the template in the content provider template list.
ClientMethod getTemplateForArea(area) [ Language = javascript ]
{
	var info = { templateClass:'', namespace:'' };

	var cp = this.getContentProvider();
	var templateInfo = cp.getTemplateInfo();
	if (templateInfo) {
		for (var n = 0; n < templateInfo.length; n++) {
			if (templateInfo[n].name == area) {
				// get last piece of class name
				var t = templateInfo[n].template.toString().split('.');
				info.templateClass = t[t.length-1];
				info.namespace = templateInfo[n].templateNS;
				break;
			}
		}
	}
	return info;
}

/// Notification that we have moved to a new "area".<br/>
/// Implement in a subclass.
ClientMethod changeAreaHandler() [ Language = javascript ]
{
}

/// Is the current user logged in?
ClientMethod isLoggedIn() [ Internal, Language = javascript ]
{
	return false;
}

/// Invalidate cached data for the given docView component and data element within the content provider.<br/>
ClientMethod invalidate(docViewId, providerName) [ Language = javascript ]
{
	var docView = zen(docViewId);
	docView.invalidate();
	this.getContentProvider().invalidate(providerName);

	var cp = this.getSubtemplateProvider();
	if (cp) {
		cp.invalidate(providerName);
	}

	if (this.onInvalidate) {
		this.onInvalidate(docViewId, providerName);
	}

	// log
	if (zenPage._zenCPLog) {
		zenPage._zenCPLog.push({id:'invalidate',which:providerName});
		if (zenPage.updateDebugWindow) {
			zenPage.updateDebugWindow();
		}
	}
}

/// Update the given docView component.<br/>
/// Updates the content provider with name <var>providerName</var> using the
/// new data key value <var>dataKey</var>.<br/>
/// If <var>notify</var> is a function, then update asychronously and invoke the notify function
/// when complete.<br/>
ClientMethod updateView(docViewId, providerName, dataKey, criteria, notify) [ Language = javascript ]
{
	// clear the data cache
	this.getContentProvider().invalidate(providerName,dataKey);
	criteria = zenGet(criteria);

	var async = ('function' == typeof notify);

	var docView = zen(docViewId);
	if (async) {
		// update async
		// assume closure will pick up docViewId etc.
		this.getContentProvider().getContent(providerName, dataKey, criteria, true, function(final) { zenPage.notifyUpdate(final,docViewId,dataKey,criteria,notify); });
	}
	else {
		docView.setDocumentKey(dataKey,criteria);
		docView.updateLayout();
	}
}

/// Notification that async refresh is complete.
ClientMethod notifyUpdate(final, docViewId, dataKey, criteria, notify) [ Internal, Language = javascript ]
{
	var docView = zen(docViewId);
	if (final) {
		docView.setDocumentKey(dataKey,criteria);
		docView.endWait();
	}
	else {
		// show indicator after a while
		docView.startWait('please wait...');
	}

	if ('function'==typeof notify) {
		notify(final);
	}
}

/// Request to display "static" content (such as the about info).
/// This should be implemented in a subclass.
ClientMethod showArticle(docId) [ Internal, Language = javascript ]
{
	alert('Show article ' + docId);
}

/// Notification that a "popstate" event has occurred.
/// This is fired when the user presses the back button and there is a 
/// pushed state in the history stack.
ClientMethod popstateHandler(evt) [ Language = javascript ]
{
	// make sure event is from this "page session"
	if (evt && evt.state && (evt.state.session==this._historySession)) {
		// pull state from local stack
		var state = this._historyStack.pop();
		if (state) {
			// handle based on "type"
			var type = state.type;
			switch (type) {
			case 'area':
				// go back to previous area (with no history)
				this.gotoArea(state.area,state.key1,state.key2,true);
				break;
			default:
				this.onPopstateHandler(state);
				break;
			}
		}
	}
}

/// Subclass notification that a "popstate" event has occurred.
ClientMethod onPopstateHandler(evt) [ Language = javascript ]
{
}

/// Fetch a code table (via the contentProvider)
Method GetCodeTable(ByRef pParms, Output pObject As %RegisteredObject) As %Status [ Internal, ZenMethod ]
{
	Set tSC = $$$OK
	If (..#APPNAME'="") {
		Set tCodeTable = $G(pParms("key"))
		If (tCodeTable'="") {
			Set tSC = ##class(%ZEN.Mojo.SimpleContentManager).%FetchCodeTable(..#APPNAME,tCodeTable,.pObject)
		}
	}
	Quit tSC
}

/// Return array of template classes.<br/>
Method GetTemplateList(ByRef pParameters, Output pMetaData, Output pData) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		Set pMetaData = $LB("name","template","templateNS")
		Set tAdditionalMeta = ..%OnGetTemplateMeta()
		If (tAdditionalMeta '= "") && $listvalid(tAdditionalMeta) {
			Set pMetaData = pMetaData _ tAdditionalMeta
		}
		Set tSC = ..%OnGetTemplateList(.pData)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Overridden by subclasses to get an actual list of available template classes.
/// <var>pTemplates</var> should use the following structure: <br/>
/// <example>Set pTemplates(n) = $listbuild("name","Template.Class","templateNamespace")</example> <br/>
/// Additional fields may be included if <method>%OnGetTemplateMeta</method>() is overridden.
Method %OnGetTemplateList(Output pTemplates, pForLocalization As %Boolean = 0) As %Status
{
	// Set pTemplates($I(pTemplates)) = $LB("name","Template.Classname","templateNamespace")
	Quit $$$OK
}

/// Overridden by subclasses to allow extra fields to be included in the data returned
/// from <method>%OnGetTemplateList</method>(). This method should return a $list of field names.
Method %OnGetTemplateMeta() As %List
{
	Quit ""
}

/// Return a template class name from the template list given its name/area.
/// Return "" if not found.
Method %GetTemplateClassByName(pName As %String) As %String
{
	Set tClass = ""
	Set pName = $$$LOWER(pName)

	Do ..%OnGetTemplateList(.tList)
	Set k = $O(tList(""))
	While (k'="") {
		If ($$$LOWER($LG(tList(k),1))=pName) {
			Set tClass = $LG(tList(k),2)
			Quit
		}
		Set k = $O(tList(k))
	}

	Quit tClass
}

/// Return array of sub-template classes.<br/>
Method GetSubtemplateList(ByRef pParameters, Output pMetaData, Output pData) As %Status [ ZenMethod ]
{
	Set tSC = $$$OK
	Try {
		Set pMetaData = $LB("name","template","templateNS")
		Set tAdditionalMeta = ..%OnGetSubtemplateMeta()
		If (tAdditionalMeta '= "") && $listvalid(tAdditionalMeta) {
			Set pMetaData = pMetaData _ tAdditionalMeta
		}
		Set tSC = ..%OnGetSubtemplateList(.pData)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Overridden by subclasses to get an actual list of available subtemplate classes.
/// <var>pSubtemplates</var> should use the following structure: <br/>
/// <example>Set pSubtemplates(n) = $listbuild("template-name","Template.Class","templateNamespace")</example> <br/>
/// Additional fields may be included if <method>%OnGetSubtemplateMeta</method>() is overridden.
Method %OnGetSubtemplateList(Output pSubtemplates, pForLocalization As %Boolean = 0) As %Status
{
	Quit $$$OK
}

/// Overridden by subclasses to allow extra fields to be included in the data returned
/// from <method>%OnGetSubtemplateList</method>(). This method should return a $list of field names.
Method %OnGetSubtemplateMeta() As %List
{
	Quit ""
}

/// Get the list of subtemplates for a given "area".
ClientMethod getSubtemplateInfo(area) [ Language = javascript ]
{
	var list = [];
	var cp = this.getSubtemplateProvider();
	var templateInfo = cp.getTemplateInfo();
	if (templateInfo) {
		for (var n = 0; n < templateInfo.length; n++) {
			var info = templateInfo[n];
			if (info && info.name) {
				var t = info.name.toString().split('/');
				if (t[0] == area) {
					list.push(info);
				}
			}
		}
	}
	return list;
}

/// Load a "subtemplate" object.
ClientMethod loadSubtemplate(key) [ Language = javascript ]
{
	var ret = true;
	// find subtemplate for key
	var found = false;
	var cp = this.getSubtemplateProvider();
	var templateInfo = cp.getTemplateInfo();
	if (templateInfo && key) {
		ret = false;
		for (var n = 0; n < templateInfo.length; n++) {
			var info = templateInfo[n];
			if (info && info.name == key) {
				// get last piece of class name
				var t = templateInfo[n].template.toString().split('.');
				var template = t[t.length-1];
				zenPage.loadSubtemplateNS(info.templateNS,template,key);
				found = true;
				ret = true;
				break;
			}
		}
	}
	if (!found) {
		// reset
		zenPage.loadSubtemplateNS('',null);
	}
	this.updateDebugWindow();
	return ret;
}

/// Show the "debug" popup window.
ClientMethod showDebugWindow() [ Internal, Language = javascript ]
{
	var url = '_ZEN.Mojo.debugPage.zen';
	this._debugWindow = window.open(url,'debug');
	this._debugWindow.focus();
}

/// Update the "debug" popup window.
ClientMethod updateDebugWindow() [ Internal, Language = javascript ]
{
	if (this.debugMode && this._debugWindow) {
		if (!this._debugWindow.opener || !this._debugWindow.zenPage) {
			this.showDebugWindow();
		}
		else {
			this._debugWindow.zenPage.updateDetails();
		}
	}
}

/// Display a message to the user.
/// Use this in place of <b>alert</b> for messages that are supposed to be delivered
/// by the application; reserve alert for diagnostic messages.
ClientMethod showMessage(msg) [ Language = javascript ]
{
	alert(msg);
}

}
