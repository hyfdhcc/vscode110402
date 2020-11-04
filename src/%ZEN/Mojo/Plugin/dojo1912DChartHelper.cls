/// This plugin adds support for the dojo library. It was developed and tested with
/// dojo version 1.9
/// 
/// 1.0.8
/// 	- NAN026 - add support for $hide and $show to dojo plugin
/// 
/// 1.0.7
/// 	- add support for $ignoreSelect
/// 
/// 1.0.6
/// 	- implement $refresh logic
/// 
/// 1.0.5
/// 	- introducing library version in the classname
/// 
/// 1.0.3
/// 	- decoupled documentation from plugin
/// 
/// 1.0.2
/// 	- updated documentation to reflect current state
/// 
Class %ZEN.Mojo.Plugin.dojo1912DChartHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "dojo-1.9.1-2DChartHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.8" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "dojo-1.9.1-2DChartHelper";

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
		{identifier:'$Chart'},
		{identifier:'$ChartLegend'},
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
	instance.$hide = this.hideChart;
	instance.$show = this.showChart;
			
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
	
	// dojox types
	switch (type) {
		case '$Chart':
			instance.$render = this.renderChart;
			instance.$refresh = this.refreshChart;			
			instance.$executeCodeBeforeChildren = this.setupChart;
			instance.$dojoType = 'dojox/charting/Chart';
			instance.$hasBlock = false;
			break;
		case '$ChartLegend':
			instance.$render = this.renderChartLegend;
			instance.$refresh = this.refreshChartLegend;
			instance.$hasBlock = false;
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

// ** render methods **

ClientMethod renderChart() [ Language = javascript ]
{
	var html = [];
	var props = [];
	var attributes = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	
	html.push('<div id="'+this.$makeId('dojo')+'" style="'+zenGet(this.style,'')+'">');
	html.push('</div>');
	var content = documentView.injectEventHandler(html.join(''),this);
	return content;
}

ClientMethod renderChartLegend() [ Language = javascript ]
{
	var html = [];
	var props = [];
	var attributes = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	
	html.push('<div id="'+this.$makeId('dojo')+'">');
	html.push('</div>');
	
	var content = documentView.injectEventHandler(html.join(''),this);
	return content;
}

ClientMethod setupChart(update) [ Language = javascript ]
{
	var instance = this;
	var requiredModules = [];
	var hasLegend = zenGet(instance.legend,'') == '' ? false : true; 
	var legendInstance = null;
	
	// include theme
	requiredModules.push(zenGet(instance.theme,'dojox/charting/themes/Claro'));

	// include legend
	if (hasLegend) {
		legendInstance = instance.$documentView.getItemByKey(instance.legend);
		if (legendInstance.selectable) {
			requiredModules.push("dojox/charting/widget/SelectableLegend");
		} else {
			requiredModules.push("dojox/charting/widget/Legend");
		}
	}
	
	// resolve requires for plots
	if (instance.$children) {
		for (var i = 0; i < instance.$children.length; i++) {
			var child = instance.$children[i];
			if (child.type=='$Plot') {
				requiredModules.push(zenGet(child.plotType,'dojox/charting/plot2d/Default'));
				var childOptions = child.options;
				if (childOptions && zenGet(childOptions.markers,false)) {
					requiredModules.push("dojox/charting/plot2d/Markers");
				}
				if (childOptions && zenGet(childOptions.tooltip,false)) {
					requiredModules.push("dojox/charting/action2d/Tooltip");
				}
				if (childOptions && zenGet(childOptions.highlight,false)) {
					requiredModules.push("dojox/charting/action2d/Highlight");
				}
				if (childOptions && zenGet(childOptions.shake,false)) {
					requiredModules.push("dojox/charting/action2d/Shake");
				}
				if (childOptions && zenGet(childOptions.moveSlice,false)) {
					requiredModules.push("dojox/charting/action2d/MoveSlice");
				}
				if (childOptions && zenGet(childOptions.magnify,false)) {
					requiredModules.push("dojox/charting/action2d/Magnify");
				}
				if (childOptions && zenGet(childOptions.mousezoomandpan,false)) {
					requiredModules.push("dojox/charting/action2d/MouseZoomAndPan");
				}
				if (childOptions && zenGet(childOptions.touchzoomandpan,false)) {
					requiredModules.push("dojox/charting/action2d/TouchZoomAndPan");
				}
				if (childOptions && typeof zenGet(childOptions.animate,null) === 'object') {
					requiredModules.push("dojo/fx/easing");
				}
			}
		}		
	}
	
	// use default axis for now
	requiredModules.push("dojox/charting/axis2d/Default");
	
	// now do the work
	require(['dojox/charting/Chart'].concat(requiredModules), function(Chart, Theme) {
		
		var chart;
		
		if (update) {
			 chart = instance.$dojoItem;	
		} else {
			chart = new Chart(instance.$makeId('dojo'),zenGet(instance.title,null));
		}
		
		// chaining
		chart.setTheme(Theme);
		
		if (instance.$children) {
			for (var i = 0; i < instance.$children.length; i++) {
				var child = instance.$children[i];
				switch (child.type) {
				
					case '$Plot':
						
						var childOptions = child.options;
						var animate = childOptions ? zenGet(childOptions.animate,null) : null; 
						
						// replace easing string with the function
						if (animate != null && typeof animate === 'object') {
							if (animate.easing) {
								var Easing = require("dojo/fx/easing");
								animate.easing = Easing[animate.easing];
							}
						}
						
						var Type = require(child.plotType);
						var options = {
							type:Type,
							animate:animate
						};
						
						if (childOptions) {
							for (attr in childOptions) {
								if (attr != 'animate') {
									options[attr] = childOptions[attr];
								} else {
									options.animate = animate;
								}
							}
						}
						
						chart.addPlot(zenGet(child.name,'default'), options);
						
						// must be called before render is called.
						if (childOptions && zenGet(childOptions.tooltip,false)) {
							var Tooltip = require("dojox/charting/action2d/Tooltip");
							new Tooltip(chart,zenGet(child.name,'default'),zenGet(childOptions.tooltipOptions,{}));
						}
						
						if (childOptions && zenGet(childOptions.highlight,false)) {
							var Highlight = require("dojox/charting/action2d/Highlight");
							new Highlight(chart,zenGet(child.name,'default'),zenGet(childOptions.highlightOptions,{}));
						}
						
						if (childOptions && zenGet(childOptions.magnify,false)) {
							var Magnify = require("dojox/charting/action2d/Magnify");
							new Magnify(chart,zenGet(child.name,'default'),zenGet(childOptions.magnifyOptions,{}));
						}
						
						if (childOptions && zenGet(childOptions.moveSlice,false)) {
							var MoveSlice = require("dojox/charting/action2d/MoveSlice");
							new MoveSlice(chart,zenGet(child.name,'default'));
						}
						
						if (childOptions && zenGet(childOptions.shake,false)) {
							var Shake = require("dojox/charting/action2d/Shake");
							new Shake(chart,zenGet(child.name,'default'),zenGet(childOptions.shakeOptions,{}));
						}
						
						if (childOptions && zenGet(childOptions.mousezoomandpan,false)) {
							var MZaP = require("dojox/charting/action2d/MouseZoomAndPan");
							new MZaP(chart,zenGet(child.name,'default'),zenGet(childOptions.mousezoomandpanOptions,{}));
						}
						
						if (childOptions && zenGet(childOptions.touchzoomandpan,false)) {
							var TZaP = require("dojox/charting/action2d/TouchZoomAndPan");
							new TZaP(chart,zenGet(child.name,'default'),zenGet(childOptions.touchzoomandpanOptions,{}));
						}
						
						if (!instance.$ignoreSelect) {
							// setup event handler
							var onEvent = function(event) {
								if (event && event.type == "onclick") {
									instance.$documentView.onselect(instance.key,event);
								}
							}
							
							if (child.plotType != 'dojox/charting/plot2d/Grid') {
								chart.connectToPlot(zenGet(child.name,'default'),{},onEvent);
							}
						}
						
						break;
				
					case '$Series':
						chart.addSeries(child.title,child.data,child.options);
						break;
					
					case '$Axis':
						chart.addAxis(child.name,child.options);
						break;
				}
			}
		}
		
		chart.render();
		
		if (hasLegend) {
			
			var Legend = null;
			
			if (legendInstance.selectable) {
				Legend = require("dojox/charting/widget/SelectableLegend");
			} else {
				Legend = require("dojox/charting/widget/Legend");
			}
			var legend = new Legend({chart:chart,outline:zenGet(legendInstance.outline,false)},legendInstance.$makeId('dojo'));
			
		}
		
		instance.$dojoItem = chart;
	});
}

ClientMethod refreshChart() [ Language = javascript ]
{
	var props = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	
	var chart = this.$dojoItem;
	
	require([zenGet(this.theme,'dojox/charting/themes/Claro')], function(theme){
  		chart.setTheme(theme);
	});
	
	if (this.$children) {
		for (var i = 0; i < this.$children.length; i++) {
			var child = this.$children[i];
			switch (child.type) {
				case '$Series':
					chart.updateSeries(child.title,child.data,true);
					break;
			}
		}
	}
	
	chart.render();
}

ClientMethod refreshChartLegend() [ Language = javascript ]
{
	// noop currently
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

/// This method is used to hide chart/chart legend
ClientMethod hideChart() [ Internal, Language = javascript ]
{

	var props = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	
	dojo.query('#'+this.$makeId('dojo')).style('display','none');
}

/// This method is used to show chart/chart legend
ClientMethod showChart() [ Internal, Language = javascript ]
{
  	var props = [];
  	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	
	dojo.query('#'+this.$makeId('dojo')).style('display','block');
}

}
