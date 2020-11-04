Class %ZEN.Mojo.PluginDocumentation.Templates.Layout.pageManagerDetail Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	
	var layout = {
		children: [
			
			{type:'$p',$content:'=[description]'}
			
		]
	};
	
	return layout;
}

}
