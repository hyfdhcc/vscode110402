Class %ZEN.Mojo.Plugin.baseHelperPlugin Extends %ZEN.Component.object [ Abstract, System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

/// The unique name of the helper plugin. All features of this component will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "baseHelperPlugin" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "0.0.0" ];

/// This method gets called by the <CLASS>documentView</CLASS> component when it get's rendered the first
/// time. It is used to link the plugin with the <CLASS>documentView</CLASS> component.
ClientMethod registerPlugin(documentView, pageManager) [ Final, Language = javascript ]
{
	this.$documentView = documentView;
	this.$pageManager = pageManager;
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	return true;
}

/// Implemented by subclasses.
/// This method returns an array containing objects which describe all layout elements
/// the plugin supports. Each object in the list has to set the property 'identifier' in
/// order to register this layout element for this plugin.
/// In case multiple plugins register for the same feature the <CLASS>documentView</CLASS>
/// component will indicate this conflict. Use the getPluginConflicts method in order to retrieve
/// the conflicts.
/// The first plugin which registers a features will be used for dispatching in case there is
/// a conflict. If you want to change preference use the setPluginMapping method of the
/// <CLASS>documentView</CLASS>
ClientMethod getFeatures() [ Language = javascript ]
{
	return [];
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	return null;
}

}
