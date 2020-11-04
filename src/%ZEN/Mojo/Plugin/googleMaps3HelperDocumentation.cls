Class %ZEN.Mojo.Plugin.googleMaps3HelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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

					{name:'endLat',type:'number',refreshable:true,description:''},
					{name:'endLng',type:'number',refreshable:true,description:''},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'startLat',type:'number',refreshable:true,description:''},
					{name:'startLng',type:'number',refreshable:true,description:''},
					{name:'travelMode',type:'string',refreshable:true,description:''},				]

			};
			break;

		case '$map':
			documentation = {
				description:'The $map object represents a map. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Google Maps API.',

				attributes:[

					{name:'',type:'',description:''},
					{name:'backgroundColor',type:'string',refreshable:false,description:''},
					{name:'centerAtUser',type:'boolean',refreshable:true,description:''},
					{name:'centerLat',type:'number',refreshable:true,description:''},
					{name:'centerLng',type:'number',refreshable:true,description:''},
					{name:'centerMarkerTitle',refreshable:true,type:'string',description:''},
					{name:'centerMarkerDraggable',refreshable:true,type:'boolean',description:'If true, enables the user to drag the marker created by showMarkerAtCenter.'},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These must be of type $marker, $directions, or $infowindow.'},
					{name:'disableDefaultUI',type:'boolean',refreshable:true,description:''},
					{name:'disableDoubleClickZoom',type:'boolean',refreshable:true,description:''},
					{name:'draggable',type:'boolean',refreshable:true,description:''},
					{name:'draggableCursor',type:'string',refreshable:false,description:''},
					{name:'draggingCursor',type:'string',refreshable:false,description:''},
					{name:'height',type:'number',refreshable:false,description:'Height of the map, in pixels.'},
					{name:'hidden',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'id',type:'string',refreshable:false,description:''},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'keyboardShortcuts',type:'boolean',refreshable:true,description:''},
					{name:'mapTypeControl',type:'boolean',refreshable:true,description:''},
					{name:'mapTypeControlIds',type:'array',refreshable:true,description:''},
					{name:'mapTypeControlPosition',type:'number',refreshable:true,description:'Default is google.maps.ControlPosition.TOP_RIGHT'},
					{name:'mapTypeControlStyle',type:'number',refreshable:true,description:'Default is google.maps.MapTypeControlStyle.DEFAULT'},
					{name:'mapTypeId',type:'number',refreshable:true,description:'Default is google.maps.MapTypeId.ROADMAP'},
					{name:'navigationControl',type:'boolean',refreshable:false,description:''},
					{name:'navigationControlPosition',type:'number',refreshable:false,description:'Default is google.maps.ControlPosition.TOP_RIGHT'},
					{name:'navigationControlStyle',type:'number',refreshable:false,description:'Default is google.maps.ControlPosition.DEFAULT'},
					{name:'noClear',type:'boolean',refreshable:false,description:''},
					{name:'scaleControl',type:'boolean',refreshable:true,description:''},
					{name:'scaleControlPosition',type:'number',refreshable:false,description:'Default is google.maps.ControlPosition.BOTTOM_LEFT'},
					{name:'scrollwheel',type:'boolean',refreshable:true,description:''},
					{name:'showMarkerAtCenter',type:'boolean',refreshable:false,description:''},
					{name:'streetViewControl',type:'boolean',refreshable:true,description:''},
					{name:'value',type:'array',refreshable:false,description:'Array of objects for use by markers. Each object must have the properties lat, lng, and title.'},
					{name:'width',type:'number',refreshable:false,description:'Width of the map, in pixels.'},
					{name:'zoom',type:'number',refreshable:true,description:''},				]

			};
			break;

		case '$marker':
			documentation = {
				description:'The $marker object represents a marker on a map.  This layout object cannot be used at the top level; you must include it within the children array of $map. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Google Maps API.',

				attributes:[

					{name:'address',type:'string',refreshable:true,description:'The provided string will be geocoded to place a marker'},
					{name:'draggable',type:'boolean',refreshable:true,description:'If true, enables the user to drag the marker.'},
					{name:'icon',type:'string',refreshable:true,description:'URL of custom icon to use, if any.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lat',type:'number',refreshable:true,description:''},
					{name:'lng',type:'number',refreshable:true,description:''},
					{name:'title',type:'string',refreshable:true,description:''},				]

			};
			break;
			
		case '$infowindow':
			documentation = {
				description:'The $infowindow object represents an info window on a map.  This layout object cannot be used at the top level; you must include it within the children array of $map or within the children array of a $marker. If a child of a $marker, the $infowindow will open when the $marker is clicked.',

				attributes:[

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item. HTML tags are recognized by the Google Maps API.'},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. This array is used to generate the content of the info window, but is overridden if $content is defined.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lat',type:'number',refreshable:true,description:''},
					{name:'lng',type:'number',refreshable:true,description:''},
					{name:'zIndex',type:'number',refreshable:true,description:'All InfoWindows are displayed on the map in order of their zIndex, with higher values displaying in front of InfoWindows with lower values. By default, InfoWindows are displayed according to their latitude, with InfoWindows of lower latitudes appearing in front of InfoWindows at higher latitudes. InfoWindows are always displayed in front of markers.'},			]

			};
			break;

	}
	return documentation;
}

}
