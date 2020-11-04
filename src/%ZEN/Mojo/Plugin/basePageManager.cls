/// This is the base class for all page managers that can be registered at the <CLASS>documentView</CLASS>
/// component. Plugins are intended to take care of the <CLASS>documentView</CLASS> rendering behavior.
/// Additionally they can be enriched with helper plugins that implement supported layout objects.
Class %ZEN.Mojo.Plugin.basePageManager Extends %ZEN.Component.object [ Abstract, System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

/// The unique name of the PageManager. All features of this component will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "basePageManager" ];

/// A version string of the base page manager. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "0.0.0" ];

/// If any plugin sets this flag to true the <CLASS>documentView</CLASS> component will not inject the
/// HTML into the DOM and will not update when a document level gets popped.
/// The plugin will be responsible to do the rendering using the callbacks
/// <METHOD>afterRenderDocument</METHOD> and <METHOD>afterPopDocument</METHOD>
Property suppressRender As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

/// If any plugin sets this flag to true the event handler of the <CLASS>documentView</CLASS> component
/// will not stop the propagation of the event
Property suppressStopPropagation As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

/// If any plugin sets this flag to true the renderDocument method of the <CLASS>documentView</CLASS> component
/// will not call the code execution and the plugin is responsible for doing this
Property suppressCodeExecution As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

Property helperPlugins As list Of %ZEN.Mojo.Plugin.baseHelperPlugin(XMLPROJECTION = "ELEMENT", XMLREF = 1, XMLTYPECONSTRAINT = "CHOICE") [ Internal ];

ClientMethod getPluginByName(pluginName) [ Language = javascript ]
{
	
	if (this.pluginName == pluginName) {
		return this;
	}
	
	for (var i=0; i < this.helperPlugins.length; i++) {
		if (this.helperPlugins[i].pluginName == pluginName) {
			return this.helperPlugins[i];
		}
	}
	
	return null;
}

/// This method gets called by the <CLASS>documentView</CLASS> component when it get's rendered the first
/// time. It is used to link the plugin with the <CLASS>documentView</CLASS> component.
ClientMethod registerPlugins(documentView) [ Final, Language = javascript ]
{
	this.$documentView = documentView;
	
	// register helper plugins
	for (var i=0; i < this.helperPlugins.length; i++) {
		this.helperPlugins[i].registerPlugin(documentView,this);
	}
	
	documentView.pluginMap = new Array();
	documentView.pluginConflicts = new Array();
	
	// build plugin feature map
	for (var i=0; i < this.helperPlugins.length; i++) {
		var pluginFeatures = this.helperPlugins[i].getFeatures();
		// merge the plugin map into the documentView map
		for (var j=0; j < pluginFeatures.length; j++) {
			if (documentView.pluginMap[pluginFeatures[j].identifier]==undefined) {
				documentView.pluginMap[pluginFeatures[j].identifier] = this.helperPlugins[i].pluginName;
			} else {
				documentView._hasConflicts = true;
				if (documentView.pluginConflicts[pluginFeatures[j].identifier]==undefined) {
					documentView.pluginConflicts[pluginFeatures[j].identifier] = new Array();
					documentView.pluginConflicts[pluginFeatures[j].identifier].push(documentView.pluginMap[pluginFeatures[j].identifier]);
				}
				documentView.pluginConflicts[pluginFeatures[j].identifier].push(this.helperPlugins[i].pluginName);
			}
		}
	}
}

/// This method checks that all libraries are loaded for the page manager and the
/// corresponding helper plugins
ClientMethod checkLibraries() [ Final, Language = javascript ]
{
	var success = this.onCheckLibraries();
	
	if (!success) {
		alert('Not all libraries for page manager ' + this.pluginName + ' have been loaded correctly!');
	}
	
	for (var i=0; i < this.helperPlugins.length; i++) {
		var plugin = this.helperPlugins[i];
		
		if (!plugin.onCheckLibraries()) {
			alert('Not all libraries for helper plugin ' + plugin.pluginName + ' have been loaded correctly!');
			success = false;
		}
	}
	
	return success;
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	return true;
}

/// Returns a string which gets injected as attributes to the <div> holding the document.
ClientMethod getDocumentAttributes(docView, displayMode) [ Language = javascript ]
{
	return '';
}

/// Gets called after the HTML for the current document got rendered and is successfully
/// injected into the DOM. If <PROPERTY>suppressRender</PROPERTY> is set to true for any
/// registered plugin the HTML is generated but not injected!
ClientMethod afterRenderDocument(docView, displayMode, html) [ Language = javascript ]
{
	return null;
}

/// Gets called after a document level was popped from the stack. The rendering for the transition
/// already started, except <PROPERTY>suppressRender</PROPERTY> is set to true by any plugin.
ClientMethod afterPopDocument(docView, render) [ Language = javascript ]
{
	return null;
}

}
