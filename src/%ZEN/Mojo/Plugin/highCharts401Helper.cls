/// This plugin adds support for the HighCharts library. It was developed and tested with
/// HighCharts version 4.0.1 and jQuery 2.0.3.
/// 
/// 1.0.3
/// 	- add support for $ignoreSelect
/// 
/// 1.0.2
/// 	- JBE062 - highCharts: Add support for $refresh for HighCharts
/// 
/// 1.0.1
/// 	- Global Availability
/// 
/// 0.1.1
/// 	- Adjust renderChart() to allow non-pixel width and height.
Class %ZEN.Mojo.Plugin.highCharts401Helper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "highCharts-4.0.1-Helper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.3" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "highCharts-4.0.1-Helper";

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
		{identifier:'$chart'},
		
		/* Shortcuts for most common chart types */
		{identifier:'$areachart'},
		{identifier:'$arearangechart'}, //Requires highcharts-more.js
		{identifier:'$areasplinechart'},
		{identifier:'$areasplinerangechart'}, //Requires highcharts-more.js
		{identifier:'$barchart'},
		{identifier:'$boxplotchart'},
		{identifier:'$bubblechart'}, //Requires highcharts-more.js
		{identifier:'$columnchart'},
		{identifier:'$columnrangechart'}, //Requires highcharts-more.js
		{identifier:'$errorbarchart'},
		{identifier:'$funnelchart'},
		{identifier:'$gaugechart'}, //Requires highcharts-more.js
		{identifier:'$heatmapchart'},
		{identifier:'$linechart'},
		{identifier:'$piechart'},
		{identifier:'$pyramidchart'},
		{identifier:'$scatterchart'},
		{identifier:'$serieschart'},
		{identifier:'$solidgaugechart'}, //Requires highcharts-more.js
		{identifier:'$splinechart'},
		{identifier:'$waterfallchart'},
	];
	
	return features;
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	// no block for any component we render!
	instance.$hasBlock = false;
	
	// Do not create a title div even though there is a title attribute
	instance.$showTitle = false;

	instance.$render = this.renderChart;
	instance.$executeCodeBeforeChildren = this.initializeChart;
	instance.$refresh = function(){
		instance.$chart.destroy();
		instance.$executeCodeBeforeChildren();
	}
	
	switch(type) {
		
		case '$areachart':
			instance.chartType = 'area';
			break;
		case '$arearangechart':
			instance.chartType = 'arearange';
			break;
		case '$areasplinechart':
			instance.chartType = 'areaspline';
			break;
		case '$areasplinerangechart':
			instance.chartType = 'areasplinerange';
			break;
		case '$barchart':
			instance.chartType = 'bar';
			break;
		case '$boxplotchart':
			instance.chartType = 'boxplot';
			break;
		case '$bubblechart':
			instance.chartType = 'bubble';
			break;
		case '$columnchart':
			instance.chartType = 'column';
			break;
		case '$columnrangechart':
			instance.chartType = 'columnrange';
			break;
		case '$errorbarchart':
			instance.chartType = 'errorbar';
			break;
		case '$funnelchart':
			instance.chartType = 'funnel';
			break;
		case '$gaugechart':
			instance.chartType = 'gauge';
			break;
		case '$heatmapchart':
			instance.chartType = 'heatmap';
			break;
		case '$linechart':
			instance.chartType = 'line';
			break;
		case '$piechart':
			instance.chartType = 'pie';
			break;
		case '$pyramidchart':
			instance.chartType = 'pyramid';
			break;
		case '$scatterchart':
			instance.chartType = 'scatter';
			break;
		case '$serieschart':
			instance.chartType = 'series';
			break;
		case '$solidgaugechart':
			instance.chartType = 'solidgauge';
			break;
		case '$splinechart':
			instance.chartType = 'spline';
			break;
		case '$waterfallchart':
			instance.chartType = 'waterfall';
			break;
	}
	
	return instance;
}

/// Render a placeholder for all kinds of charts
ClientMethod renderChart() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;

	var cHeight = zenGet(this.height);
	//cHeight = (cHeight==='') ? 100 : parseInt(cHeight,10);
	var cWidth = zenGet(this.width);
	//cWidth = (cWidth==='') ? 100 : parseInt(cWidth,10);
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var cssClass = zenGet(this.cssClass,false)? 'class="'+this.cssClass+'"': '';
	
	if (typeof cHeight == 'number' || parseInt(cHeight,10) == cHeight) {
		if (cHeight > 100) {
			cHeight = cHeight.toString() + 'px';
		} else {
			cHeight = cHeight.toString() + '%';
		}
	}
	if (typeof cWidth == 'number' || parseInt(cWidth,10) == cWidth) {
		if (cWidth > 100) {
			cWidth = cWidth.toString() + 'px';
		} else {
			cWidth = cWidth.toString() + '%';
		}
	}
	
	html.push('<div id="'+this.$makeId('highcharts')+'" '+hidden+' '+cssClass+' style="width:'+cWidth+';height:'+cHeight+';'+zenGet(this.style,'')+'">');
	html.push('</div>');

	return html.join('');
}

ClientMethod initializeChart() [ Internal, Language = javascript ]
{
   	var instance = this;
   	var options = (zenGet(instance.options,false)? instance.options: {});
   	
   	if (zenGet(instance.title,false)) {
		if (!options.title) { options.title = {}; }
		options.title.text = instance.title; 	
	}
   	if (zenGet(instance.subtitle,false)) {
		if (!options.subtitle) { options.subtitle = {}; }
		options.subtitle.text = instance.subtitle; 	
	}
		
	switch (typeof instance.xAxis) {
		case 'object':
			if (instance.xAxis instanceof Array) {
				if (!options.xAxis) { options.xAxis = {}; }
				options.xAxis.categories = instance.xAxis;
			}
			else {
				options.xAxis = instance.xAxis;
			}
			break;
		case 'string':
			if (!options.xAxis) { options.xAxis = {}; }
			options.xAxis.title = { text: instance.yAxis };
			break;
	}
	
	switch (typeof instance.yAxis) {
		case 'object':
			if (instance.yAxis instanceof Array) {
				if (!options.yAxis) { options.yAxis = {}; }
				options.yAxis.categories = instance.yAxis;
			}
			else {
				options.yAxis = instance.yAxis;
			}
			break;
		case 'string':
			if (!options.yAxis) { options.yAxis = {}; }
			options.yAxis.title = { text: instance.yAxis };
			break;
	}
	
	if (!options.series) {options.series = [];}
	for (var i = 0; i < (instance.series? instance.series.length: 0); i++) {
		options.series.push({
			name: (zenGet(instance.seriesNames, false)? zenGet(instance.seriesNames[i], ''): ''),
			data: instance.series[i]
		});
	}
	 
	if (!options.chart) { options.chart = {}; }
	options.chart.renderTo = instance.$makeId('highcharts');
	
	// Do not overwrite user's chartype if they defined it in the options
	options.chart.type = zenGet(instance.chartType, zenGet(options.chart.type,'line'));
	
	
	if (!this.$ignoreSelect) {
		// Assign event handler
		instance = this;
		defaultEventHandler = function(evt) {
			instance.$documentView.onselect(instance.key,{chartX:evt.chartX,chartY:evt.chartY});
		};
		
		pointEventHandler = function(evt) {
			var findIndexByPoint = function(data, point) {
				for (var i = 0; i < data.length; i++) {
					if (data[i] == point) {
						return i;
					}
				}
				return -1;
			}
			instance.$documentView.onselect(instance.key,{seriesIndex:evt.point.series.index,dataIndex:findIndexByPoint(evt.point.series.data, evt.point)});
		}
		// Check if the click event is defined. Do not overwrite existing implementation.
		if (typeof options.chart.events == 'undefined') {
			options.chart.events = {click:defaultEventHandler};
		} else if (typeof options.chart.events.click == 'undefined') {
			options.chart.events.click = defaultEventHandler;
		}
		
		if (typeof options.plotOptions == 'undefined') {
			options.plotOptions = {series:{point:{events:{click:pointEventHandler}}}};
		} else if (typeof options.plotOptions.series == 'undefined') {
			options.plotOptions.series = {point:{events:{click:pointEventHandler}}};
		} else if (typeof options.plotOptions.series.point == 'undefined') {
			options.plotOptions.series.point = {events:{click:pointEventHandler}};
		} else if (typeof options.plotOptions.series.point.events == 'undefined') {
			options.plotOptions.series.point.events = {click:pointEventHandler};
		} else if (typeof options.plotOptions.series.point.events.click == 'undefined') {
			options.plotOptions.series.point.events.click = pointEventHandler;
		}
	}
	
	instance.$chart = new Highcharts.Chart(options);
	
	// Get function for the Highcharts Chart object
	instance.getChart = function() {
		if (this.$chart) { return this.$chart }
		return null;
	}
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof $ === 'undefined') {
		alert('jQuery library is not loaded correctly. Check your includes.');
		return false;
	} else 
	if (typeof Highcharts != 'object') {
		alert('HighCharts library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

}
