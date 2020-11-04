/// This plugin adds support for the Chart.js library. It was developed and tested with
/// Chart.js version 1.0.1-beta.4.
/// 
/// 1.0.4
/// 	- NAN025 - add support for $hide and $show to charts plugin
///  
/// 1.0.3
/// 	- add support for $ignoreSelect
/// 
/// 1.0.2
/// 	- JBE061 - Charts: Add support for $refresh
/// 
/// 1.0.1
/// 	- Global Availability
/// 
/// 0.1.2
/// 	- support event handlers for all chart types
/// 
/// 0.1.1
/// 	- correct minor bug: one canvas attribute did not close a double quote.
Class %ZEN.Mojo.Plugin.charts101Helper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "charts-1.0.1-Helper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.4" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "charts-1.0.1-Helper";

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
		{identifier:'$linechart'},
		{identifier:'$barchart'},
		{identifier:'$doughnutchart'},
		{identifier:'$piechart'},
		{identifier:'$polarareachart'},
		{identifier:'$radarchart'},
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

	instance.$render = this.renderChart;
	instance.$hide = this.hideChart;
	instance.$show = this.showChart;
	instance.$executeCodeBeforeChildren = this.initializeChart;
	instance.$refresh = function(){
		instance.$chart.destroy();
		instance.$executeCodeBeforeChildren();
	}
	
	switch(type) {
		
		case '$linechart':
			instance.chartType = 'line';
			break;
		case '$barchart':
			instance.chartType = 'bar';
			break;
		case '$doughnutchart':
			instance.chartType = 'doughnut';
			break;
		case '$piechart':
			instance.chartType = 'pie';
			break;
		case '$polarareachart':
			instance.chartType = 'polar';
			break;
		case '$radarchart':
			instance.chartType = 'radar';
			break;
		case '$chart':
			if (!instance.chartType) { instance.chartType='bar'; }
			else if (instance.chartType == 'polararea') { instance.chartType='polar'; }
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
	cHeight = (cHeight==='') ? 100 : parseInt(cHeight,10);
	var cWidth = zenGet(this.width);
	cWidth = (cWidth==='') ? 100 : parseInt(cWidth,10);
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var cssClass = zenGet(this.cssClass,false)? this.cssClass+'"': '';
	
	html.push('<canvas id="'+this.$makeId('charts')+'" width="'+cWidth+'" height="'+cHeight+'" '+hidden+' class="'+cssClass+'" style="'+zenGet(this.style,'')+'">');
	html.push('</canvas>');

	return html.join('');
}

ClientMethod initializeChart() [ Internal, Language = javascript ]
{
	var data = zenGet(this.data,false) ? this.data:'';
	var options = zenGet(this.options,false) ? this.options:{};
	var eventHandler = function(evt){};
	
	if (data) {
		
		var ctx = this.$findElement('charts').getContext('2d');
		
		var instance = this;
		
		switch (this.chartType) {
			case 'line':
				this.$chart = new Chart(ctx).Line(data,options);
				eventHandler = function(evt) {
					var activeElements = instance.$chart.getPointsAtEvent(evt);
					instance.$documentView.onselect(instance.key,activeElements);
				};
				break;
			case 'bar':
				this.$chart = new Chart(ctx).Bar(data,options);
				eventHandler = function(evt) {
					var activeElements = instance.$chart.getBarsAtEvent(evt);
					instance.$documentView.onselect(instance.key,activeElements);
				};
				break;
			case 'doughnut':
				this.$chart = new Chart(ctx).Doughnut(data,options);
				eventHandler = function(evt) {
					var activeElements = instance.$chart.getSegmentsAtEvent(evt);
					instance.$documentView.onselect(instance.key,activeElements);
				};
				break;
			case 'pie':
				this.$chart = new Chart(ctx).Pie(data,options);
				eventHandler = function(evt) {
					var activeElements = instance.$chart.getSegmentsAtEvent(evt);
					instance.$documentView.onselect(instance.key,activeElements);
				};
				break;
			case 'polar':
				this.$chart = new Chart(ctx).PolarArea(data,options);
				eventHandler = function(evt) {
					var activeElements = instance.$chart.getSegmentsAtEvent(evt);
					instance.$documentView.onselect(instance.key,activeElements);
				};
				break;
			case 'radar':
				this.$chart = new Chart(ctx).Radar(data,options);
				eventHandler = function(evt) {
					var activeElements = instance.$chart.getPointsAtEvent(evt);
					instance.$documentView.onselect(instance.key,activeElements);
				};
				break;
			default:
				console.log('chartType "' + this.chartType + '" not recognized.');
				break;
		}
		if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
	}
	
	if (this.$chart && !this.$ignoreSelect) {
		this.$findElement('charts').onclick = eventHandler;
	}
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof Chart != 'function') {
		alert('Chart.js library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

/// This method adds data to the chart specified by key.
/// The third parameter of this method is supposed to be a dataset index in
/// doughnut, pie, and polar charts.
ClientMethod addData(key, data, labelOrIndex) [ Language = javascript ]
{
	var instance = this.$documentView.getItemByKey(key);
	
	instance.$chart.addData(data,labelOrIndex);
}

/// This method removes data from the chart specified by key.
/// The index variable only applies to doughnut, pie, and polar charts.
/// If index is not specified, the last data element is removed.
/// The other charts simply remove the first variable.
ClientMethod removeData(key, index) [ Language = javascript ]
{
	var instance = this.$documentView.getItemByKey(key);

	instance.$chart.removeData(index);
}

/// This method updates and re-renders the chart specified by key.
ClientMethod update(key) [ Language = javascript ]
{
	var instance = this.$documentView.getItemByKey(key);
	instance.$chart.update();
}

/// This method is used to hide chart
/// duration is a string or number specifying the duration of the animation.
/// callback is a function to be executed when the animation completes.
ClientMethod hideChart(duration, callback) [ Internal, Language = javascript ]
{

	$('#'+this.$makeId('charts')).hide(duration, callback);
}

/// This method is used to show chart
/// duration is a string or number specifying the duration of the animation.
/// callback is a function to be executed when the animation completes.
ClientMethod showChart(duration, callback) [ Internal, Language = javascript ]
{

	$('#'+this.$makeId('charts')).show(duration, callback);
}

}
