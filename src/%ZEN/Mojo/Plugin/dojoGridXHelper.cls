/// This plugin adds support for the dojo library. It was developed and tested with
/// dojo version 1.9
/// 
/// 1.0.3
/// 	- decoupled documentation from plugin
/// 
/// 1.0.2
/// 	- updated documentation to reflect current state
/// 
Class %ZEN.Mojo.Plugin.dojoGridXHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "dojoGridXHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.3" ];

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
	return [
		{identifier:'$Gridx'}
	];
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	instance.$hasBlock = true;
	
	// if you want to render elements inline set renderInline:true
	if (zenGet(instance.renderInline,false)) {
		instance.$hasBlock = false;
	}
	
	instance.$showTitle = false;
	instance.$executeCodeBeforeChildren = this.linkDojoItem;
	instance.$getDojoItem = function() { return this.$dojoItem; };
	
	var defaultSetValue = function(value,notify) { 
		// set the value of the layout item
		this.value = value;
		// set the value of the dojo object
		this.$dojoItem.set('value',value);
	};
	
	var defaultGetValue = function() {
		// get the value of the dojo object
		return this.$dojoItem.get('value');
	};
	
	// external types
	switch (type) {
		case '$Gridx' :
			//instance.$dojoProps = instance.$dojoProps.concat([
			//	{attribute:'autoHeight',type:'boolean',defaultValue:''},
			//	{attribute:'autoRender',type:'boolean',defaultValue:''},
			//	{attribute:'idProperty',type:'string',defaultValue:''},
			//]);
			//instance.$dojoType = 'gridx/Grid';
			instance.$render = this.renderGridx;
			instance.$executeCodeBeforeChildren = this.setupGridx;
			//instance.$additionalRequires = ["gridx/core/model/cache/Sync"];
			break;
	}
	
	return null;
}

ClientMethod linkDojoItem() [ Language = javascript ]
{
	var registry = require("dijit/registry");
	var item = registry.byId(this.$makeId('dojo'));
	this.$dojoItem = item;
}

/// Register a dojo type for the require call by specifying the instance
ClientMethod registerDojoType(instance) [ Language = javascript ]
{
	var documentView = instance.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(instance.$type);
	
	if (typeof plugin._registeredTypes == 'undefined') {
		plugin._registeredTypes = [];
	}
	
	if (typeof plugin._registeredTypes[documentView.currLevel] == 'undefined') {
		plugin._registeredTypes[documentView.currLevel] = [];
	}
	
	var thisLevel = plugin._registeredTypes[documentView.currLevel];
	
	if (thisLevel.indexOf(instance.$dojoType) == -1) {
		thisLevel.push(instance.$dojoType);
	}
	
	if (typeof instance.$additionalRequires != 'undefined') {
		for (var i = 0; i < instance.$additionalRequires.length; i++) {
			thisLevel.push(instance.$additionalRequires[i]);
		}
	}
}

/// Register a dojo type for the require call by specifying the type as string
ClientMethod registerDojoTypeByType(type) [ Language = javascript ]
{
	var documentView = this.$documentView;
	
	if (typeof this._registeredTypes == 'undefined') {
		this._registeredTypes = [];
	}
	
	if (typeof this._registeredTypes[documentView.currLevel] == 'undefined') {
		this._registeredTypes[documentView.currLevel] = [];
	}
	
	var thisLevel = this._registeredTypes[documentView.currLevel];
	
	if (thisLevel.indexOf(type) == -1) {
		thisLevel.push(type);
	}
}

ClientMethod getDojoTypes() [ Language = javascript ]
{
	
	if (typeof this._registeredTypes == 'undefined') {
		return [];
	}
	
	if (typeof this._registeredTypes[this.$documentView.currLevel] == 'undefined') {
		return [];
	}
	
	return this._registeredTypes[this.$documentView.currLevel];
}

ClientMethod renderGridx() [ Language = javascript ]
{
	var html = [];
	var props = [];
	var attributes = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	var hasStore = false;
	
	html.push('<div id="'+this.$makeId('dojo')+'" style="'+zenGet(this.style,'')+'">');
	html.push('</div>');
	
	var content = documentView.injectEventHandler(html.join(''),this);
	return content;
}

ClientMethod setupGridx() [ Language = javascript ]
{
	var instance = this;
	var requiredModules = [];
	var hasSelectRowModule = false;
	var autoHideFilterBar = false;
	
	if (typeof instance.modules != 'undefined') {
		for (var i = 0; i < instance.modules.length; i++) {
			requiredModules.push(instance.modules[i].moduleClass);
			if (instance.modules[i].moduleClass == 'gridx/modules/select/Row') {
				hasSelectRowModule = true;
			} else if (instance.modules[i].moduleClass == 'gridx/modules/filter/FilterBar') {
				autoHideFilterBar = zenGet(instance.modules[i].autoHide,false);
			}
		}
	}
	
	if (typeof instance.barTop != 'undefined') {
		for (var i = 0; i < instance.barTop.length; i++) {
			requiredModules.push(instance.barTop[i].pluginClass);
		}
	}
	
	if (typeof instance.barBottom != 'undefined') {
		for (var i = 0; i < instance.barBottom.length; i++) {
			requiredModules.push(instance.barBottom[i].pluginClass);
		}
	}
	
	// select row is mandatory for event handling
	if (!hasSelectRowModule) {
		requiredModules.push('gridx/modules/select/Row');
	}
	
	require(['gridx/Grid','gridx/core/model/cache/Sync'].concat(requiredModules), function(Grid, Cache) {
	
		var columns = zenGet(instance.columns,[]);
		
		var store = null;
		
		if (zenGet(instance.store,'') !== '') {
			var key = zenGet(instance.store,'');
			store = instance.$documentView.getItemByKey(key).$getStore();
		} 
		
		if (!store) return;
		
		var modules = [];
		if (typeof instance.modules != 'undefined') {
			for (var i = 0; i < instance.modules.length; i++) {
				// we have to make copies of the modules
				// otherwise we would alter the instance.modules array
				// because dojo enriches them and subsequent calls
				// would fail
				modules.push(instance.$documentView.getPluginByName('dojoDijitHelper').clone(instance.modules[i]));
			}
		}
		
		var barTop = [];
		if (typeof instance.barTop != 'undefined') {
			barTop = instance.barTop;
		}
		
		var barBottom = [];
		if (typeof instance.barBottom != 'undefined') {
			barBottom = instance.barBottom;
		}
		
		// generic event handler for row select
		var eventHandler = function(rowid) {
			zenPage._$documentViewId = instance.$documentView.id;
			instance.$documentView.onselect(instance.key,rowid);
		}
		
		if (!hasSelectRowModule) {
			modules.push(
				{moduleClass:'gridx/modules/select/Row',onSelected : function(row,rowid) {eventHandler(rowid);},triggerOnCell:true}
			);
		} else {
			for (i = 0; i < modules.length; i++) {
				if (modules[i].moduleClass == 'gridx/modules/select/Row') {
					modules[i].onSelected = function(row,rowid) {eventHandler(rowid);};
					modules[i].triggerOnCell = true;
				}
			}
		}
		
		var grid = new Grid({
			cacheClass:Cache,structure:columns,store:store,
			modules:modules,barTop:barTop,barBottom:barBottom,
			headerHidden:zenGet(instance.headerHidden,false)
			},instance.$makeId('dojo'));
		grid.startup();
		
		if (autoHideFilterBar) {
			grid.filterBar.hide();
		}
		
		instance.$dojoItem = grid;
	
	});
}

/// helper function, adapted from 
/// http://stackoverflow.com/questions/728360/most-elegant-way-to-clone-a-javascript-object
/// clones object, arrays, dates, strings, numbers and booleans
/// other types are not supported
ClientMethod clone(obj) [ Language = javascript ]
{
	
	// Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof Date) {
        var copy = new Date();
        copy.setTime(obj.getTime());
        return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
        var copy = [];
        for (var i = 0, len = obj.length; i < len; i++) {
            copy[i] = this.clone(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        var copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = this.clone(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof require === 'undefined') {
		alert('Dojo library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

}
