Class %ZEN.Mojo.Plugin.highCharts401HelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
{

/// returns an object containing information about the requested identifier (e.g. $loop).
/// The object contains an array holding an object for each supported attribute and a documentation
/// EXAMPLE:
/// 
/// {
/// 	description: 'Description of the identifier e.g. $loop',
/// 	attributes: [
/// 			{name:'value',type:'string',description:'Holds the value of the html element'}
/// 		]
/// }
/// 
/// Valid types are: string,number,boolean,date,object,array and function
ClientMethod getDocumentation(identifier) [ Language = javascript ]
{
	var documentation = {attributes:[]};
	var defAttributes = [
		{name:'height',type:'string',refreshable:false,description:'CSS height of the placeholder div for this chart. Defaults to px or %(if less than 100) if a number is provided.'},
		{name:'width',type:'string',refreshable:false,description:'CSS width of the placeholder div for this chart. Defaults to px or %(if less than 100) if a number is provided.'},
		{name:'cssClass',type:'string',refreshable:false,description:'CSS class name(s) of the placeholder div for this chart.'},
		{name:'style',type:'string',refreshable:false,description:'Style defintion of the placeholder div for this chart.'},
		{name:'options',type:'object',refreshable:true,description:'This object can define all data to be displayed by the chart. Some of the data can be specified in the other attributes, but the will be overridden by this attribute. See http://api.highcharts.com/highcharts for specific documentation.'},
		{name:'title',type:'string',refreshable:true,description:'The title to be displayed above the chart'},
		{name:'subtitle',type:'string',refreshable:true,description:'The subtitle to be displayed below the title'},
		{name:'xAxis',type:'object',refreshable:true,description:'Can be defined as an object, array or string. An array will define the xAxis categories, a string will define the xAxis title, and an object can do either.'},
		{name:'yAxis',type:'object',refreshable:true,description:'Can be defined as an object, array or string. An array will define the yAxis categories, a string will define the yAxis title, and an object can do either.'},
		{name:'series',type:'array',refreshable:true,description:'Must be defined as an array of datasets. Each element in the series attribute represents a separate dataset.'},
		{name:'seriesNames',type:'array',refreshable:true,description:'Must be defined as an array of strings. Each element will label its corresponding dataset in the series attribute.'},
		{name:'$ignoreSelect',type:'boolean',description:'If true, suppress default generation of select handers (if any).'},
	];
	
	switch (identifier) {		
		
		case '$chart':
			
			defAttributes.push({name:'chartType',type:'string',description:'The type of chart to render, the default is "bar".'});
			documentation = {
				description:'Displays a chart specified by chartType.',
				attributes:defAttributes
			};
			break;
		
		default:
			documentation = {
				description:'Displays a ' + identifier.substring(1,identifier.length-5) + ' chart.',
				attributes:defAttributes
			};
			break;
		
		/*case '$linechart':
			documentation = {
				description:'Displays a line chart.',
				attributes:defAttributes
			};
			break;
		case '$barchart':
			documentation = {
				description:'Displays a bar chart.',
				attributes:defAttributes
			};
			break;
		case '$columnchart':
			documentation = {
				description:'Displays a column chart.',
				attributes:defAttributes
			};
			break;
		case '$areachart':
			documentation = {
				description:'Displays an area chart.',
				attributes:defAttributes
			};
			break;
		case '$piechart':
			documentation = {
				description:'Displays a pie chart.',
				attributes:defAttributes
			};
			break;
		*/
	}
	return documentation;
}

}
