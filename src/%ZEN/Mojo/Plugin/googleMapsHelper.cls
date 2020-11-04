/// This plugin adds very basic support for the google maps API 3.0.
/// 
/// 1.0.5
/// 	- added support configuring simple icons for markers 
/// 
/// 1.0.4
/// 	- decoupled documentation from plugin
/// 
/// 1.0.3
/// 	- Ensure that marker gets rendered if showMarkerAtCenter is true
/// 	- Added more information to plugin documentation
/// 
/// 1.0.2
/// 	- add defensive code to ensure google maps service is loaded correctly 
/// 
Class %ZEN.Mojo.Plugin.googleMapsHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "googleMapsHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.5" ];

Property mapCounter As %ZEN.Datatype.integer(XMLPROJECTION = "NONE") [ InitialExpression = 0, Internal ];

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
		{identifier:'$map'},
		{identifier:'$marker'},
		{identifier:'$directions'},
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
	
	switch(type) {
		case '$map':
			instance.$render = this.renderGMap;
			instance.$executeCodeBeforeChildren = this.initializeGMap;
			instance.$isLoop = true;
			instance.$children = [];
			break;
		case '$marker':
			// render nothing
			instance.$render = new function() {};
			instance.$executeCodeBeforeChildren = this.initializeMarker;
			break;
		case '$directions':
			// render nothing
			instance.$render = new function() {};
			instance.$executeCodeBeforeChildren = this.initializeDirections;
			break;
	}
	
	return instance;
}

/// Render a google map
ClientMethod renderGMap() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var cHeight = zenGet(this.height);
	cHeight = (cHeight==='') ? 100 : parseInt(cHeight,10);
	var cWidth = zenGet(this.width);
	cWidth = (cWidth==='') ? 100 : parseInt(cWidth,10);
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	var plugin = this.$documentView.getPluginByLayoutObjectType(this.$type);
	plugin.mapCounter = plugin.mapCounter+1;
	
	html.push('<div id="'+docView.id+'-'+docView.currLevel+'-' + this.$documentView.getPluginByLayoutObjectType(this.$type).mapCounter + '-' + this.id + '" '+hidden+' style="width:'+cWidth+'px;height:'+cHeight+'px;position:relative;"></div>');
	return html.join('');
}

/// Returns the google map object of the current level
ClientMethod getGMap() [ Language = javascript ]
{
	return this._maps[this.$documentView.currLevel];
}

/// Triggers the resize event of the currently used map
ClientMethod resizeMap() [ Language = javascript ]
{
	var localMap = this.getGMap();
	if (typeof localMap != 'undefined') {
		google.maps.event.trigger(localMap,'resize');
	}
}

/// Triggers the refresh event of the currently used map
ClientMethod refreshMap() [ Language = javascript ]
{
	var localMap = this.getGMap();
	if (typeof localMap != 'undefined') {
		google.maps.event.trigger(localMap,'refresh');
	}
}

ClientMethod initializeGMap() [ Internal, Language = javascript ]
{
		
	var centerLatLng = new google.maps.LatLng(zenGet(this.centerLat),zenGet(this.centerLng));
	var plugin = this.$documentView.getPluginByLayoutObjectType(this.$type);
	var instance = this;
	
	var mapOptions = {
		zoom: zenGet(this.zoom,8),
		center: centerLatLng,
		mapTypeId : zenGet(this.mapTypeId,google.maps.MapTypeId.HYBRID)
	};
	
	if (typeof plugin._maps == 'undefined') {
		plugin._maps = {};
	}
  	
	map = new google.maps.Map(document.getElementById(this.$documentView.id+'-'+this.$documentView.currLevel+'-'+plugin.mapCounter+'-'+this.id),mapOptions);
	
	plugin._maps[this.$documentView.currLevel] = map;
	
	if (zenGet(instance.centerAtUser,false)) {
  		if(navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(function(position) {
				var pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
		      	map.setCenter(pos);
		      	if (zenGet(instance.showMarkerAtCenter,false)) {
			  		var marker = new google.maps.Marker({
					    position: pos,
					    map: map,
						title: zenGet(instance.centerMarkerTitle,'')
					});
		  		}
		    }, function() {});
		  } else {
		    // Browser doesn't support Geolocation
		  }	
	} else {
  		if (zenGet(instance.showMarkerAtCenter,false)) {
	  		var marker = new google.maps.Marker({
			    position: map.getCenter(),
			    map: map,
				title: zenGet(instance.centerMarkerTitle,'')
			});
  		}
	}
}

ClientMethod initializeMarker() [ Language = javascript ]
{
	var map = this.$documentView.getPluginByLayoutObjectType(this.$type)._maps[this.$documentView.currLevel];
	
	var markerObj = {
	    position: new google.maps.LatLng(zenGet(this.lat),zenGet(this.lng)),
	    map: map,
		title: zenGet(this.title,'')
	}
	
	if (zenGet(this.icon,'') != '') {
		markerObj.icon = this.icon;	
	}
	
	var marker = new google.maps.Marker(markerObj);
}

ClientMethod initializeDirections() [ Language = javascript ]
{
	var map = this.$documentView.getPluginByLayoutObjectType(this.$type)._maps[this.$documentView.currLevel];
	
	var directionsDisplay = new google.maps.DirectionsRenderer();
	var directionsService = new google.maps.DirectionsService();
	
	directionsDisplay.setMap(map);
	
	var travelMode = zenGet(this.travelMode,google.maps.DirectionsTravelMode.DRIVING);
	
	var start = new google.maps.LatLng(zenGet(this.startLat),zenGet(this.startLng));
	if (typeof this.startLat === 'undefined' || typeof this.startLng === 'undefined') {
		// if no start is defined use the center of the map
		start = map.getCenter();
	}
	
	var end = new google.maps.LatLng(zenGet(this.endLat),zenGet(this.endLng));
	var request = {
		origin:start,
	    destination:end,
	    travelMode: travelMode
	};
	directionsService.route(request, function(response, status) {
		if (status == google.maps.DirectionsStatus.OK) {
			directionsDisplay.setDirections(response);
		}
	});
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof google === 'undefined') {
		alert('Google Maps is not correctly loaded. Check your includes.');
		return false;
	}
	return true;
}

}
