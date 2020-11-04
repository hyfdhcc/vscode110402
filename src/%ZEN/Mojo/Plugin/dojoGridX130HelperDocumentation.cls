Class %ZEN.Mojo.Plugin.dojoGridX130HelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
		case '$Gridx':
			documentation = {
				description:'The $Gridx object represents a Dojo GridX. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in a Dojo GridX. A $refresh call will update the body of the table with the current data of the associated store.',

				attributes:[

					{name:'barBottom',type:'array',description:''},
					{name:'barTop',type:'array',description:''},
					{name:'columns',type:'number',description:''},
					{name:'headerHidden',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'modules',type:'array',description:''},
					{name:'store',type:'boolean',description:'The key of the store to which this grid should connect.'},
					{name:'style',type:'string',description:'CSS style to apply to the div in which this grid is rendered.'},
					{name:'$ignoreSelect',type:'boolean',description:'If true, suppress default generation of select handers (if any).'},				]

			};
			break;

	}
	return documentation;
}

}
