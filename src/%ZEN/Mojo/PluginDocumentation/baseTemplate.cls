Class %ZEN.Mojo.PluginDocumentation.baseTemplate Extends %ZEN.Mojo.Component.contentTemplate
{

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return.
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
	var content = null;
	
	switch (which) {
	
		case 'layout':
		
			return this.getLayout(key,criteria);
		
			break;
		
		case 'data':
		
			return this.getData(key,criteria);
			
			break;
		
	}
	
	return null;
}

ClientMethod getData(key, criteria) [ Language = javascript ]
{
	var data = null;
	
	switch (key) {
	
		case 'pluginDetail':
		
			var temp = criteria.id.split('.');
			var className = temp[temp.length-1];
			var plugin = zenCreateComponent('http://www.intersystems.com/zen/mojo',className);
			
			var features = plugin.getFeatures();
		
			data = {
				main_menu:[
					{id:'all',name:'All'}
				]
			};
			
			for (var i = 0; i < features.length; i++) {
				var object = features[i];
				data.main_menu.push({id:object.identifier,name:object.identifier,parent:'all'});
			}
		
			break;
			
	}
	
	return data;
}

ClientMethod getLayout(key, criteria) [ Language = javascript ]
{
	
	var layout = {};
	
	switch (key) {
	
		case 'home':
		
			layout = {
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
								type:'$para',content:$$$Text('Zen Mojo Plugin Documentation'),
								paraClass:'headerText'
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
									type:'$ContentPane',title:$$$Text('Choose a plugin'),
									key:'contentPane-1',
									children:[
									
									{
										type:'$Tree',key:'pluginMenu',
										model:'model-menu',showRoot:false,
										persist:true
									},
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
			
			break;
			
		case 'pluginDetail':
		
			layout = {
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
								type:'$image',src:'images/black_left_arrow.png',
								blockStyle:'display:inline;',style:'display:inline;',
								imageStyle:'top: inherit;position:absolute;',
								key:'backImage'
							},
							
							{
								type:'$para',content:criteria.id,
								paraClass:'headerText',blockStyle:'display:inline;'
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
		
			break;
			
		case 'list-layout-object':
		
			layout = {
				
				children:[
				
				]
			};
		
			break;
		
	}
	
	return layout;
}

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	console.log('select: ' + key + ' value: ' + value);
	
	var docView = zen(docViewId);
	
	switch (key) {
		case 'backImage':
		
			zen('mainView').popDocument();
			
			break;
			
		case 'pluginMenu':
			
			zen('mainView').pushDocument('pluginDetail',{id:value},'pluginDetail',{id:value});
			
			break;
			
		case 'layoutObjectMenu':

			var tree = docView.getItemByKey(key);
			var store = tree.$dojoItem.model.store;
			
			var item = store.query({id:value})[0];
			
			if (zenGet(item.openTab,true)) {
				
				var tc = zen('mainView').getItemByKey('tabContainer-1').$dojoItem;
				var tabIsOpen = false;
				
				if (tc.hasChildren()) {
					var openTabs = tc.getChildren();
					
					for (var i = 0; i < openTabs.length; i++) {
						if (openTabs[i].title == value) {
							// open!
							tabIsOpen = true;
							tc.selectChild(openTabs[i],true);
						}
					}
				}
				
				if (!tabIsOpen) {
					var nv = docView.getPluginByName('dojo').createDocumentView('list-layout-object','list-layout-object','newView_'+value);
					nv.setDocumentKey('list-layout-object',{id:value});
					nv.setLayoutKey('list-layout-object',{id:value});
					docView.getPluginByName('dojo').addTabWithDocumentView(docView,'tabContainer-1',1,value,nv);
				}
			}
			
			break;	
	}
}

/// Server-side method to provide content to JSON providers.<br/>
/// <var>pWhich</var> is the name of the provider.<br/>
/// <var>pKey</var> is an app-defined key that is used to indicate which content is to be served.<br/>
/// <var>pCriteria</var>is an object containing search criteria. This is used for searching.<br/>
/// <var>pParms</var> is an array of additional parameters from the JSON provider. (not current used).<br/>
/// <var>pObject</var> is the object that will be served to the client in JSON format.<br/>
/// <var>pLoad</var> is true is this is called when the page is first being served. In this case, this method will be 
/// called even though there may a client-side method used to load the content.<br/>
ClassMethod %OnGetJSONContent(pWhich As %String, pKey As %String, ByRef pParms, Output pObject As %RegisteredObject, pCriteria As %RegisteredObject, pLoad As %Boolean = 0) As %Status
{
	
	#dim tSC As %Status = $$$OK
	#dim statementResult As %SQL.StatementResult
	
	set pObject = ##class(%ZEN.proxyObject).%New()
	
	if (pKey="home") {
		set pObject."main_menu" = ##class(%ListOfObjects).%New()
		
		
		set menuEntry = ##class(%ZEN.proxyObject).%New()
		set menuEntry.id = "all"
		set menuEntry.name = "all"
		do pObject."main_menu".Insert(menuEntry)
			
		set statement = ##class(%SQL.Statement).%New()
		set tSC = statement.%Prepare("SELECT parent FROM %Dictionary.CompiledProperty WHERE Name = 'pluginName' AND parent->Super = '%ZEN.Mojo.Plugin.basePlugin'")
		if $$$ISERR(tSC) Quit $$$OK
		
		set statementResult = statement.%Execute()
		
		while statementResult.%Next() {
		
			set menuEntry = ##class(%ZEN.proxyObject).%New()
			set menuEntry.id = statementResult.%Get("parent")
			set menuEntry.name = $P(statementResult.%Get("parent"),".",$L(statementResult.%Get("parent"),"."))
			set menuEntry.parent = "all"
			
			do pObject."main_menu".Insert(menuEntry)	
			
		}
		
	}
	
	Quit $$$OK
}

}
