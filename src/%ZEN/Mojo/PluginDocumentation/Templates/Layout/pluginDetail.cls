Class %ZEN.Mojo.PluginDocumentation.Templates.Layout.pluginDetail Extends abstractTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	var layout = {
		children: [
			
			// defines the store for the $Tree component
			{
				type:'$StoreMemory',key:'menu-store',
				data:'=[main_menu]',parentAttribute:'parent'
			},
			{
				type:'$TreeObjectStoreModel',key:'model-menu',
				store:'menu-store',query:{id:'all'},
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
						type:'$img',src:'images/black_left_arrow.png',
						style:'display:inline;top: inherit;position:absolute;padding-top:10px;',
						key:'backImage'
					},
					
					{
						type:'$span',$content:criteria.id,
						cssClass:'headerText',style:'display:inline;'
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
							type:'$ContentPane',title:$$$Text('Layout Objects'),
							key:'contentPane-1',
							children:[
							
							{
								type:'$Tree',key:'layoutObjectMenu',
								model:'model-menu',showRoot:false,
								persist:true
							},
							
						]},
						
						{
							type:'$ContentPane',title:$$$Text('Legend'),
							key:'contentPane-1',
							children:[
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/array.png',cssClass:'typeImage',alt:'Array'},
								{type:'$span',$content:'Array',cssClass:'inlineText link'}
							]},
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/boolean.png',cssClass:'typeImage',alt:'Boolean'},
								{type:'$span',$content:'Boolean',cssClass:'inlineText link'}
							]},
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/date.png',cssClass:'typeImage',alt:'Date'},
								{type:'$span',$content:'Date',cssClass:'inlineText link'}
							]},
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/function.png',cssClass:'typeImage',alt:'Function'},
								{type:'$span',$content:'Function',cssClass:'inlineText link'}
							]},
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/number.png',cssClass:'typeImage',alt:'Number'},
								{type:'$span',$content:'Number',cssClass:'inlineText link'}
							]},
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/object.png',cssClass:'typeImage',alt:'Object'},
								{type:'$span',$content:'Object',cssClass:'inlineText link'}
							]},
							
							{type:'$div',children:[
								{type:'$img',src:'zenmojo_images/string.png',cssClass:'typeImage',alt:'String'},
								{type:'$span',$content:'String',cssClass:'inlineText link'}
							]}
						]}
						
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
