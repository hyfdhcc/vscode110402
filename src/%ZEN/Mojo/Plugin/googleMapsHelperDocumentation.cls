Class %ZEN.Mojo.Plugin.googleMapsHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
		case '$directions':
			documentation = {
				description:'The $directions object represents directions between two map points. This layout object cannot be used at the top level; you must include it within the children array of $map. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Google Maps API.',

				attributes:[

					{name:'endLat',type:'number',description:''},
					{name:'endLng',type:'number',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'startLat',type:'number',description:''},
					{name:'startLng',type:'number',description:''},
					{name:'travelMode',type:'string',description:''},				]

			};
			break;

		case '$map':
			documentation = {
				description:'The $map object represents a map. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Google Maps API.',

				attributes:[

					{name:'centerAtUser',type:'boolean',description:''},
					{name:'centerLat',type:'number',description:''},
					{name:'centerLng',type:'number',description:''},
					{name:'centerMarkerTitle',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These must be of type $marker or $directions.'},
					{name:'height',type:'number',description:'Height of the map, in pixels.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'id',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mapTypeId',type:'string',description:''},
					{name:'showMarkerAtCenter',type:'boolean',description:''},
					{name:'value',type:'array',description:'Array of objects for use by markers. Each object must have the properties lat, lng, and title.'},
					{name:'width',type:'number',description:'Width of the map, in pixels.'},
					{name:'zoom',type:'number',description:''},				]

			};
			break;

		case '$marker':
			documentation = {
				description:'The $marker object represents a marker on a map.  This layout object cannot be used at the top level; you must include it within the children array of $map. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Google Maps API.',

				attributes:[

					{name:'icon',type:'string',description:'URL of custom icon to use, if any.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lat',type:'number',description:''},
					{name:'lng',type:'number',description:''},
					{name:'title',type:'string',description:''},				]

			};
			break;

	}
	return documentation;
}

}
