Class %ZEN.Mojo.PluginDocumentation.Templates.Data.listLayoutObject Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(providerName, key, criteria) [ Language = javascript ]
{
	var temp = zen('mainView').getDocumentCriteria().className.split('.');
	var className = temp[temp.length-1];
	className = className + 'Documentation';
	var pluginDoc = zenCreateComponent('http://www.intersystems.com/zen/mojo',className);
	
	var documentation = {};
	
	if (pluginDoc) {
	
		documentation = pluginDoc.getDocumentation(criteria.id);
		
		if (!documentation.attributes) {
			documentation.attributes = [];
		}
		
		for (var i = 0; i < documentation.attributes.length; i++) {
			var attribute = documentation.attributes[i];
			attribute.typeFilename = 'zenmojo_images/' + attribute.type + '.png';
			attribute.hasType = zenGet(attribute.type,'') == '' ? false : true;
		}
		
		var compare = function compare(a,b) {
			if (a.name < b.name)
				return -1;
			if (a.name > b.name)
				return 1;
			return 0;
		}
		
		documentation.attributes.sort(compare);
	
	}
	
	return documentation;
}

}
