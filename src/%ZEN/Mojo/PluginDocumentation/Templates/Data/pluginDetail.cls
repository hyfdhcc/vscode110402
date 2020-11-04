Class %ZEN.Mojo.PluginDocumentation.Templates.Data.pluginDetail Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	var plugin = zenCreateComponent('http://www.intersystems.com/zen/mojo',criteria.id);
	
	var features = plugin.getFeatures();

	var data = {
		main_menu:[
			{id:'all',name:'All'}
		]
	};
	
	var compare = function compare(a,b) {
		if (a.identifier < b.identifier)
			return -1;
		if (a.identifier > b.identifier)
			return 1;
		return 0;
	}
	
	features.sort(compare);
	
	for (var i = 0; i < features.length; i++) {
		var object = features[i];
		data.main_menu.push({id:object.identifier,name:object.identifier,parent:'all'});
	}
	return data;
}

}
