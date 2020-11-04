Class %ZEN.Mojo.PluginDocumentation.Templates.Layout.home Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	var layout = {
		children: [
			
			// defines the stores for the $Tree component
			{
				type:'$StoreMemory',key:'pagemanager-menu-store',
				data:'=[pagemanager_menu]',parentAttribute:'parent'
			},
			{
				type:'$StoreMemory',key:'helperplugins-menu-store',
				data:'=[helperplugins_menu]',parentAttribute:'parent'
			},
			{
				type:'$TreeObjectStoreModel',key:'pagemanager-model-menu',
				store:'pagemanager-menu-store',query:{id:'all'},
				mayHaveChildren:function(item){
					return !zenGet(item.openTab,true);
				}
			},
			{
				type:'$TreeObjectStoreModel',key:'helperplugins-model-menu',
				store:'helperplugins-menu-store',query:{id:'all'},
				mayHaveChildren:function(item){
					return !zenGet(item.openTab,true);
				}
			},
			
			// main layout
			{
				type:'$LayoutContainer',key:'layoutContainer-1',
				design:'headline',style:'width:100%;height:100%;',
				children:[
				
				// header
				{
					type:'$ContentPane',region:'top',
					key:'contentPane-top',
					children:[
					
					{
						type:'$span',$content:$$$Text('Zen Mojo Plugin Documentation'),
						cssClass:'headerText'
					},
				]},
				
				// body - left and right design
				{
					type:'$BorderContainer',key:'layoutContainer-2',
					region:'center',design:'headline',liveSplitters:false,
					style:'width:100%;height:100%;',
					children:[
					
					// Accordion on the left side
					{
						type:'$AccordionContainer',region:'leading',
						splitter:true,style:'width:300px;',
						children:[
						
						{
							type:'$ContentPane',title:$$$Text('Choose a Plugin'),
							key:'contentPane-1',
							children:[
							
							{
								type:'$Tree',key:'menuHelperPlugins',
								model:'helperplugins-model-menu',showRoot:false,
								persist:true
							}
						]},
						
						{
							type:'$ContentPane',title:$$$Text('Choose a Page Manager'),
							key:'contentPane-1',
							children:[
							
							{
								type:'$Tree',key:'menuPageManager',
								model:'pagemanager-model-menu',showRoot:false,
								persist:true
							}
						]},
						
					]},
					
					// dynamic main content
					{
						type:'$ContentPane',region:'center',
						key:'contentPane-center',style:'border:none;padding:0px;',
						children:[
						
						{
							type:'$TabContainer',key:'tabContainer-1',
							region:'center',style:'width:100%;height:100%;',
						}
					]},
				]}
			]}
		]
	};
	
	return layout;
}

}
