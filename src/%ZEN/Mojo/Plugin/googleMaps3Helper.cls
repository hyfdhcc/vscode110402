/// This plugin adds very basic support for the google maps API 3.0.
/// 
/// 1.0.9
/// 	- JBE069 - GoogleMaps3: Adding support for $infowindow
/// 
/// 1.0.8
/// 	- JBE066 - GoogleMaps: Add support for $refresh
/// 
/// 1.0.7
/// 	- support retrieval of markers
/// 
/// 1.0.6
/// 	- introducing library version in the classname
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
Class %ZEN.Mojo.Plugin.googleMaps3Helper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "googleMaps-3-Helper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.9" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "googleMaps-3-Helper";

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
		{identifier:'$infowindow'},
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
			var plugin = this;
			instance.$render = this.renderGMap;
			instance.$executeCodeBeforeChildren = this.initializeGMap;
			instance.$refresh = this.refreshGMap;
			instance.$isLoop = true;
			instance.$children = [];
			break;
		case '$marker':
			// render nothing
			instance.$render = new function() {};
			instance.$executeCodeBeforeChildren = this.initializeMarker;
			instance.$refresh = this.refreshMarker;
			break;
		case '$directions':
			// render nothing
			instance.$render = new function() {};
			instance.$executeCodeBeforeChildren = this.initializeDirections;
			instance.$refresh = this.refreshDirections;
			break;
		case '$infowindow':
			instance.$render = new function() {};
			instance.$executeCodeBeforeChildren = this.initializeInfoWindow;
			instance.$refresh = this.refreshInfoWindow;
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
	
	// This should be changed to this.$makeId()
	var id = docView.id+'-'+docView.currLevel+'-' + this.$documentView.getPluginByLayoutObjectType(this.$type).mapCounter + '-' + this.id;
	this.$id = id;
	
	html.push('<div id="'+id+'" '+hidden+' style="width:'+cWidth+'px;height:'+cHeight+'px;position:relative;"></div>');
	return html.join('');
}

/// Returns the google map object of the current level
/// Returns null if the map object does not exist
ClientMethod getGMap() [ Language = javascript ]
{
	if (typeof this._maps == 'undefined' || typeof this._maps[this.$documentView.currLevel] == 'undefined') {return null;}
	return this._maps[this.$documentView.currLevel];
}

/// Triggers the resize event of the currently used map
ClientMethod resizeMap() [ Language = javascript ]
{
	var localMap = this.getGMap();
	if (localMap != null) {
		google.maps.event.trigger(localMap,'resize');
	}
}

/// Triggers the refresh event of the currently used map
ClientMethod refreshMap() [ Language = javascript ]
{
	var localMap = this.getGMap();
	if (localMap != null) {
		google.maps.event.trigger(localMap,'refresh');
	}
}

ClientMethod initializeGMap() [ Internal, Language = javascript ]
{
    var instance = this;
    var plugin = this.$documentView.getPluginByLayoutObjectType(this.$type);
	var map;
	if (typeof plugin._markers == 'undefined') {plugin._markers = {};}
	if (typeof instance._markers == 'undefined') {instance._markers = [];}
	plugin._markers[this.$documentView.currLevel] = [];
	
	if (zenGet(instance.centerLat) && zenGet(instance.centerLng)) {
        map = plugin.initializeMapCenterLatLng(instance.centerLat, instance.centerLng, instance, plugin);
    } else if (zenGet(instance.address)) {
	    map = plugin.initializeMapCenterLatLng(51.48, 0, instance, plugin);
        plugin.centerMapAddress(instance.address, map);
    } else {
	    map = plugin.initializeMapCenterLatLng(51.48, 0, instance, plugin);
        alert('No coordinates or address.');
    }
	
    if (zenGet(instance.centerAtUser)) {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition( function (position) {
				var pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
				map.setCenter(pos);
				if (zenGet(instance.showMarkerAtCenter,false)) {
			  		var marker = new google.maps.Marker({
					    position: pos,
					    map: map,
						title: zenGet(instance.centerMarkerTitle,''),
						draggable: zenGet(instance.centerMarkerDraggable,false)
					});
					plugin._markers[plugin.$documentView.currLevel].push(marker);
					//Pushing a simple object to maintain indices of map._markers, but will not duplicate during $refresh
					instance._markers.push({centerMarker:true,$refresh:function(){}});
					
		  		}
            }, function() {
                alert('Error: The Geolocation service failed.');
            });
        } else {
            alert('This browser either does not support geolocation or the feature is not turned on.');
        } 
    } else {
  		if (zenGet(instance.showMarkerAtCenter,false)) {
	  		var marker = new google.maps.Marker({
			    position: map.getCenter(),
			    map: map,
				title: zenGet(instance.centerMarkerTitle,''),
				draggable: zenGet(instance.centerMarkerDraggable,'')
			});
			plugin._markers[plugin.$documentView.currLevel].push(marker);
			//Pushing a simple object to maintain indices of map._markers, but will not duplicate during $refresh
			instance._markers.push({centerMarker:true,$refresh:function(){}});
  		}
	}
}

ClientMethod initializeMapCenterLatLng(lat, lng, instance, plugin) [ Language = javascript ]
{
    var centerLatLng = new google.maps.LatLng(lat,lng);

    var mapOptions = plugin.buildMapOptions(instance,centerLatLng);

    if (typeof plugin._maps == 'undefined') {plugin._maps = {};}
    if (typeof plugin._zmaps == 'undefined') {plugin._zmaps = {};}
    var map = new google.maps.Map(document.getElementById(instance.$documentView.id+'-'+instance.$documentView.currLevel+'-'+plugin.mapCounter+'-'+instance.id),mapOptions);
    plugin._maps[instance.$documentView.currLevel] = map;
    plugin._zmaps[instance.$documentView.currLevel] = instance;
    
    return map;
}

ClientMethod buildMapOptions(instance, centerLatLng) [ Internal, Language = javascript ]
{
	var mapOptions = {
        backgroundColor:zenGet(instance.backgroundColor,'lightgray'),
        center:centerLatLng,
        disableDefaultUI:zenGet(instance.disableDefaultUI,false),
        disableDoubleClickZoom:zenGet(instance.disableDoubleClickZoom,false),
        draggable:zenGet(instance.draggable,true),
        draggableCursor:zenGet(instance.draggableCursor,'move'),
        draggingCursor:zenGet(instance.draggingCursor,'move'),
        keyboardShortcuts:zenGet(instance.keyboardShortcuts,true),
        mapTypeControl:zenGet(instance.mapTypeControl,true),
        mapTypeControlOptions: {
            mapTypeIds:zenGet(instance.mapTypeControlIds,[
                google.maps.MapTypeId.HYBRID,
                google.maps.MapTypeId.ROADMAP,
                google.maps.MapTypeId.SATELLITE]),
            position:zenGet(instance.mapTypeControlPosition,google.maps.ControlPosition.TOP_RIGHT),
            style:zenGet(instance.mapTypeControlStyle,google.maps.MapTypeControlStyle.DEFAULT),
        },
        mapTypeId:zenGet(instance.mapTypeId,google.maps.MapTypeId.ROADMAP),
        navigationControl:zenGet(instance.navigationControl,true),
        navigationControlOptions: {
            position:zenGet(instance.navigationControlPosition,google.maps.ControlPosition.TOP_RIGHT),
            style:zenGet(instance.navigationControlStyle,google.maps.ControlPosition.DEFAULT),
        },
        noClear:zenGet(instance.noClear,false),
        scaleControl:zenGet(instance.scaleControl,false),
        scaleControlOptions: {
            position:zenGet(instance.scaleControlPosition,google.maps.ControlPosition.BOTTOM_LEFT),
        },
        scrollwheel:zenGet(instance.scrollwheel,true),
        streetViewControl:zenGet(instance.streetViewControl,true),
        zoom:zenGet(instance.zoom, 8)
    };
    
    return mapOptions;
}

ClientMethod centerMapAddress(address, map) [ Language = javascript ]
{
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( {'address':address}, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.setCenter(results[0].geometry.location)
        } else {
            alert(status);
        }
    });
}

ClientMethod refreshGMap() [ Internal, Language = javascript ]
{
    var instance = this;
    var plugin = this.$documentView.getPluginByLayoutObjectType(this.$type);
	var map;
	
	if (zenGet(instance.centerLat) && zenGet(instance.centerLng)) {
        map = plugin.refreshMapCenterLatLng(instance.centerLat, instance.centerLng, instance, plugin);
    } else if (zenGet(instance.address)) {
	    map = plugin.refreshMapCenterLatLng(51.48, 0, instance, plugin);
        plugin.centerMapAddress(instance.address, map);
    } else {
	    map = plugin.refreshMapCenterLatLng(51.48, 0, instance, plugin);
        alert('No coordinates or address.');
    }
	
    if (zenGet(instance.centerAtUser)) {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition( function (position) {
				var pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
				map.setCenter(pos);
				if (zenGet(instance.showMarkerAtCenter,false)) {
					var centerMarker;
					for (var i=0;i<instance._markers.length;i++) {
						if (instance._markers[i].centerMarker) {
							centerMarker = plugin._markers[instance.$documentView.currLevel][i];
						}
					}
					if (centerMarker) {
						centerMarker.setMap(null);
						centerMarker.position = pos;
						centerMarker.title = zenGet(instance.centerMarkerTitle,'');
						centerMarker.draggable = zenGet(instance.centerMarkerDraggable,false);
						centerMarker.setMap(map);
					}
		  		}
            }, function() {
                alert('Error: The Geolocation service failed.');
            });
        } else {
            alert('This browser either does not support geolocation or the feature is not turned on.');
        } 
    } else {
  		if (zenGet(instance.showMarkerAtCenter,false)) {
	  		var centerMarker;
			for (var i=0;i<instance._markers.length;i++) {
				if (instance._markers[i].centerMarker) {
					centerMarker = plugin._markers[instance.$documentView.currLevel][i];
				}
			}

			if (centerMarker) {
				centerMarker.setMap(null);
				centerMarker.position = map.getCenter();
				centerMarker.title = zenGet(instance.centerMarkerTitle,'');
				centerMarker.draggable = zenGet(instance.centerMarkerDraggable,false);
				centerMarker.setMap(map);
			}
  		}
	}
}

ClientMethod refreshMapCenterLatLng(lat, lng, instance, plugin) [ Language = javascript ]
{
    var centerLatLng = new google.maps.LatLng(lat,lng);
    var map = plugin._maps[instance.$documentView.currLevel];
    plugin._zmaps[instance.$documentView.currLevel] = instance;
    
    var mapOptions = plugin.buildMapOptions(instance,centerLatLng);
    
    map.setOptions(mapOptions);

    return map;
}

/// Returns an array of google map marker objects of the current level
/// Returns null if the map object does not exist
ClientMethod getMarkers() [ Language = javascript ]
{
	if (typeof this._markers == 'undefined' || typeof this._markers[this.$documentView.currLevel] == 'undefined') {return null;}
	return this._markers[this.$documentView.currLevel];
}

ClientMethod initializeMarker() [ Language = javascript ]
{
	var plugin = this.$documentView.getPluginByLayoutObjectType(this.$type)
	var map = plugin._maps[this.$documentView.currLevel];
	var zmap = plugin._zmaps[this.$documentView.currLevel];
	var drag = zenGet(this.draggable,false) ? true:false;
	var title = zenGet(this.title,'');
	
	if (zenGet(this.lat) && zenGet(this.lng)) {
		var marker = new google.maps.Marker({
	    	position: new google.maps.LatLng(this.lat,this.lng),
	    	map: map,
			title: title,
			draggable: drag
		});
		
		if (zenGet(this.icon,'') != '') {
			marker.icon = this.icon;	
		}
		
		plugin._markers[plugin.$documentView.currLevel].push(marker);
		zmap._markers.push(this);
		this.$marker = marker;
				
	} else if (zenGet(this.address,false)) {
		var geocoder = new google.maps.Geocoder();
		var instance = this;
		var icon = this.icon;
		var marker = new google.maps.Marker({
          	map: null,
          	draggable: drag,
          	title: title
      	});
      	plugin._markers[plugin.$documentView.currLevel].push(marker);
      	zmap._markers.push(instance);
      	instance.$marker = marker;
      	
    	geocoder.geocode( {'address':this.address}, function (results, status) {
        	if (status == google.maps.GeocoderStatus.OK) {
	        	marker.setPosition(results[0].geometry.location);
	        	marker.setMap(map);
      			
      			if (zenGet(icon,'') != '') {
					marker.icon = icon;	
				}
        	} else {
            	alert(status);
        	}
    	});
	}
}

ClientMethod refreshMarker() [ Language = javascript ]
{
	var plugin = this.$documentView.getPluginByLayoutObjectType(this.$type)
	var map = plugin._maps[this.$documentView.currLevel];
	var zmap = plugin._zmaps[this.$documentView.currLevel];
	var drag = zenGet(this.draggable,false) ? true:false;
	var title = zenGet(this.title,'');
	
	this.$marker.setMap(null)
	
	if (zenGet(this.lat) && zenGet(this.lng)) {
	    this.$marker.position = new google.maps.LatLng(this.lat,this.lng);
	    //this.$marker.map = map;
		this.$marker.title = title;
		this.$marker.draggable = drag;
		
		if (zenGet(this.icon,'') != '') {
			this.$marker.icon = this.icon;	
		}
		
		this.$marker.setMap(map);
				
	} else if (zenGet(this.address,false)) {
		var geocoder = new google.maps.Geocoder();
		var instance = this;
		var icon = this.icon;
    	geocoder.geocode( {'address':this.address}, function (results, status) {
        	if (status == google.maps.GeocoderStatus.OK) {
	        	//instance.$marker.map = map;
          		instance.$marker.position = results[0].geometry.location;
          		instance.$marker.draggable = drag;
          		instance.$marker.title = title;
      			
      			if (zenGet(icon,'') != '') {
					instance.$marker.icon = icon;	
				}
      			
      			instance.$marker.setMap(map);
        	} else {
            	alert(status);
        	}
    	});
	}
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
	
	this.$directionsDisplay = directionsDisplay;
	this.$directionsService = directionsService;
}

ClientMethod refreshDirections() [ Language = javascript ]
{
	var map = this.$documentView.getPluginByLayoutObjectType(this.$type)._maps[this.$documentView.currLevel];
	
	var directionsDisplay = this.$directionsDisplay;
	var directionsService = this.$directionsService;
	
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

ClientMethod initializeInfoWindow() [ Internal, Language = javascript ]
{
	var map = this.$documentView.getPluginByLayoutObjectType(this.$type)._maps[this.$documentView.currLevel];
	var marker = false;
	var options = {};
	
	if (this.$parent) {
		if (this.$parent.$type == '$marker') {
			marker = this.$parent.$marker;
		} else if (this.$parent.$parent && this.$parent.$parent.$type == '$marker') {
			marker = this.$parent.$parent.$marker;
		}
	}
	
	var content = '';
	if (zenGet(this.$content)) {
		content = this.$content;
	} else if (this.$children) {
		for (var i = 0; i<this.$children.length; i++) {
			content = content + this.$children[i].$render();
		}
	}
	options.content = content;
	
	if (zenGet(this.zIndex) !== '') {
		options.zIndex = this.zIndex;
	}
	
	options.position = new google.maps.LatLng(zenGet(this.lat,0),zenGet(this.lng,0));
	
	var infowindow = new google.maps.InfoWindow(options);
    
    if (marker) {
	    this.$marker = marker;
    	google.maps.event.addListener(marker, 'click', function() {
    		infowindow.open(map,marker);
		});
    }
    
    this.$infowindow = infowindow;
}

ClientMethod refreshInfoWindow() [ Internal, Language = javascript ]
{
	var map = this.$documentView.getPluginByLayoutObjectType(this.$type)._maps[this.$documentView.currLevel];
	var marker = false;
	var options = {};
	
	var content = '';
	if (zenGet(this.$content)) {
		content = this.$content;
	} else if (this.$children) {
		for (var i = 0; i<this.$children.length; i++) {
			content = content + this.$children[i].$render();
		}
	}
	options.content = content;
	
	if (zenGet(this.zIndex) !== '') {
		options.zIndex = this.zIndex;
	}
	
	options.position = new google.maps.LatLng(zenGet(this.lat,0),zenGet(this.lng,0));
    
    this.$infowindow.setOptions(options);
}

/// This method opens an info window specified by its key.
/// If the key of a marker is specified as well, the info window will open on that marker.
ClientMethod openInfoWindow(infoKey, markerKey) [ Language = javascript ]
{
	var map = this._maps[this.$documentView.currLevel];
	var infowindow = this.$documentView.getItemByKey(infoKey);
	var marker = this.$documentView.getItemByKey(markerKey);
	if(!marker) {marker = infowindow.$marker;}
	else {
		marker = marker.$marker; // Get the google maps marker
		infowindow.$marker = marker;
	}
	
	if (infowindow) {
		if (marker) {
			infowindow.$infowindow.open(map,marker);
		}
		else {
			infowindow.$infowindow.open(map);
		}
	}
}

/// This method closes an info window specified by its key.
ClientMethod closeInfoWindow(infoKey) [ Language = javascript ]
{
	var infowindow = this.$documentView.getItemByKey(infoKey);
	
	if (infowindow) {
		infowindow.$infowindow.close();
	}
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
