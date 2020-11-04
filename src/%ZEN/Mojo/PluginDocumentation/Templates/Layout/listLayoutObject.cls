Class %ZEN.Mojo.PluginDocumentation.Templates.Layout.listLayoutObject Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	var layout = {
	
		children: [
		
			{type:'$span',$content:'=[description]',cssClass:'inlineText'},
			
			{type:'$TitlePane',title:$$$Text('Attribute Summary'),children:[
			
				{type:'$loop',value:'=[attributes]',children:[
					{type:'$if',value:'=[hasType]',expectedValue:true,children:[
						{type:'$img',src:'=[typeFilename]',cssClass:'typeImage',alt:'=[type]'},
					]},
					{type:'$if',value:'=[refreshable]',expectedValue:true,children:[
						{type:'$img',src:'zenmojo_images/refresh.png',cssClass:'typeImage',alt:'refreshable by $refresh()'},
					]},
					{type:'$span',$content:'=[name]',cssClass:'inlineText link'},
					{type:'$span',$content:'=[description]',cssClass:'inlineText description'}
				]}
			
			]}
		
		]	
		
	};
	
	return layout;
}

}
