Class %ZEN.Mojo.Plugin.charts101HelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
		{name:'height',type:'number',refreshable:false,description:'Height of the canvas for this chart.'},
		{name:'width',type:'number',refreshable:false,description:'Width of the canvas for this chart.'},
		{name:'cssClass',type:'string',refreshable:false,description:'CSS class name(s) of the canvas for this chart.'},
		{name:'style',type:'string',refreshable:false,description:'Style defintion of the canvas for this chart.'},
		{name:'data',type:'object',refreshable:true,description:'The data to be displayed by the chart. This data must be structured differently for most chart types. See http://www.chartjs.org/docs/'},
		{name:'options',type:'object',refreshable:true,description:'The options to be set on the chart. The allowed options are different for most chart types. See http://www.chartjs.org/docs/'},
		{name:'$ignoreSelect',type:'boolean',description:'If true, suppress default generation of select handers (if any).'},
	];
	
	switch (identifier) {
		case '$chart':
			defAttributes.push({name:'chartType',type:'string',refreshable:true,description:'The type of chart to render, the default is "bar".'});
			documentation = {
				description:'Displays a chart specified by chartType ($barchart by default).',
				attributes:defAttributes
			};
			break;
		
		case '$linechart':
		
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
			
		case '$doughnutchart':
		
			documentation = {
				description:'Displays a doughnut chart.',
				attributes:defAttributes
			};
			break;
			
		case '$piechart':
		
			documentation = {
				description:'Displays a pie chart.',
				attributes:defAttributes
			};
			break;
			
		case '$polarareachart':
		
			documentation = {
				description:'Displays a polar area chart.',
				attributes:defAttributes
			};
			break;
			
		case '$radarchart':
		
			documentation = {
				description:'Displays a radar chart.',
				attributes:defAttributes
			};
			break;

	}
	return documentation;
}

}
