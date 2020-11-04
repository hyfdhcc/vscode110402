Class %ZEN.Mojo.Plugin.dojo1912DChartHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
	switch (identifier) {
		case '$Chart':
			documentation = {
				description:'The $Chart object represents a 2D chart. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'children',type:'array',description:'Array of child objects, each of which corresponds to a data point in the chart. Each child object can have the following properties: name, type, plotType, data, title, and options. The type property can be $Plot, $Series, or $Axis. The plotType property defaults to dojox/charting/plot2d/Grid. The data property is an array of values or of objects, as appropriate for the scenario; specify this property for a $Series. The options property is an object that contains options for this child. '},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'legend',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'theme',type:'string',description:'',refreshable:true},
					{name:'title',type:'string',description:''},
					{name:'$ignoreSelect',type:'boolean',description:'If true, suppress default generation of select handers (if any).'},				]

			};
			break;

		case '$ChartLegend':
			documentation = {
				description:'The $ChartLegend object represents a chart legend. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'outline',type:'boolean',description:''},
					{name:'selectable',type:'boolean',description:''},				]

			};
			break;

	}
	return documentation;
}

}
