Class %ZEN.Mojo.Plugin.mojoDefaultHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
	switch (identifier) {		case '$content':
			documentation = {
				description:'The $content object represents a block of content. You can specify the following properties of this object. ',

				attributes:[

					{name:'content',type:'string',description:'Specify custom HTML to display within this block. Zen Mojo does not perform any escaping for this property. If you include HTML tags, it is your responsibility to ensure that the resulting HTML is well-formed.'},
					{name:'cssClass',type:'string',description:'Specify the CSS class to use for this block.'},
					{name:'key',type:'string',description:'Key that identifies this layout object.  Note that the name of a key cannot include a colon (:).'},
					{name:'style',type:'string',description:'Specify the CSS style to use for this block.'},
					{name:'$ignoreSelect',type:'boolean',description:'If true, suppress default generation of select handers (if any).'},				]

			};
			break;

		case '$if':
			documentation = {
				description:'The $if object displays or hides its child objects, based on a comparison. If value===expectedValue, the child objects are displayed; otherwise they are not. You can specify the following properties of this object. ',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to display (or not), depending on the comparison.'},
					{name:'expectedValue',type:'',description:'Reference value for the comparison. The expectedValue property can have any JavaScript type.'},
					{name:'key',type:'string',description:'Key that identifies this layout object.  Note that the name of a key cannot include a colon (:).'},
					{name:'value',type:'',description:'Value to compare to expectedValue. The value property can have any JavaScript type.'},				]

			};
			break;

		case '$loop':
			documentation = {
				description:'The $loop object represents an array of child layout objects. You can specify the following properties of this object. ',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'key',type:'string',description:'Key that identifies this layout object.  Note that the name of a key cannot include a colon (:).'},				]

			};
			break;

	}
	return documentation;
}

}
