/// This plugin adds basic support and helper layout objects.
/// 
/// 1.0.9
/// 	- add support for $ignoreSelect
/// 
/// 1.0.8
/// 	- only inject eventHandler for $content for layout objects that define a key
/// 
/// 1.0.7
/// 	- add support for $if
/// 
/// 1.0.6
/// 	- package this plugin into the core of Zen Mojo
/// 
/// 1.0.5
/// 	- decoupled documentation from plugin 
/// 
/// 1.0.4
/// 	- removed the generated div block around $content element to allow easier styling 
/// 
/// 1.0.3
/// 	- updated documentation to reflect current state
/// 
Class %ZEN.Mojo.Plugin.mojoDefaultHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

Parameter SYSMODULE = "core";

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "mojoDefaultHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.9" ];

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
	var features = [
		{identifier:'$content'},
		{identifier:'$loop'},
		{identifier:'$if'}
	];
	
	return features;
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	
	instance.$hasBlock = false;
	
	// indicate if this is a "loop"
	switch(type) {
		case '$loop':
			instance.$isLoop = true;
			instance.$children = [];
			break;
		default:
			break;
	}
	
	switch(type) {
		case '$loop':
			instance.$render = this.renderLoop;
			break;
		case '$content':
			instance.$render = this.renderContentBlock;
			break;
		case '$if':
			instance.$render = this.renderIf;
			break;
		default:
			break;
	}
	
	return instance;
}

/// Render a loop element within a layout graph.
ClientMethod renderLoop() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	return html.join('');
}

/// Render an if element within a layout graph.
ClientMethod renderIf() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	
	if ((this.value === this.expectedValue) && this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	return html.join('');
}

/// Render a block of "native" content. $content.
ClientMethod renderContentBlock() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var cssClass = zenGet(this.cssClass,'');
	var eventHandler = zenGet(this.key) ? 'onclick="$$$event(\'click\');"' : '';
	
	if (this.$ignoreSelect) {
		eventHandler = '';
	}
	
	html.push('<div class="'+cssClass+'" style="'+zenGet(this.style)+'" '+eventHandler+'>');
	html.push(this.content);
	html.push('</div>');
	
	var content = html.join('');
	content = this.$documentView.injectEventHandler(content,this);
	return content;
}

}
