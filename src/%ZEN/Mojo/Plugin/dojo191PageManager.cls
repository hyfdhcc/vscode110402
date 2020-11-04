/// This plugin adds support for the dojo library. It was developed and tested with
/// dojo version 1.9
Class %ZEN.Mojo.Plugin.dojo191PageManager Extends %ZEN.Mojo.Plugin.basePageManager [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "dojo-1.9.1-PageManager" ];

/// A version string of the base page manager. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.2" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "dojo-1.9.1-PageManager";

/// The css class which get's applied to the body.
Property bodyClass As %ZEN.Datatype.string [ InitialExpression = "claro" ];

/// If any plugin sets this flag to true the event handler of the <CLASS>documentView</CLASS> component
/// will not stop the propagation of the event
Property suppressStopPropagation As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 1 ];

/// If any plugin sets this flag to true the renderDocument method of the <CLASS>documentView</CLASS> component
/// will not call the code execution and the plugin is responsible for doing this
Property suppressCodeExecution As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 1 ];

Property onPageShow As %ZEN.Datatype.eventHandler;

/// Gets called after the HTML for the current document got rendered and is successfully
/// injected into the DOM. If <PROPERTY>suppressRender</PROPERTY> is set to true for any
/// registered plugin the HTML is generated but not injected!
ClientMethod afterRenderDocument(docView, displayMode, html) [ Language = javascript ]
{
	if (document.body.classList) { //Compatability for IE9
		document.body.classList.add(zenGet(this.bodyClass,'claro'));
	} else if (document.body.className.indexOf(zenGet(this.bodyClass,'claro')) < 0) { //Check if class is already present before adding
		document.body.className = document.body.className + ' ' + zenGet(this.bodyClass,'claro');
	}
	
	// destroy dijit items that are on the same level
	require(["dijit/registry"],function(registry) {
		var items = registry.toArray();
		for (var i = 0; i < items.length; i++) {
			var item = registry.byId(items[i].id);
			if (item) {
				if (item.id.split('_')[1] == docView.index && item.id.split('_')[2] == docView.currLevel) {
					//console.log(item.id);
					item.destroyRecursive();
				}
			}
		}
	});
	
	if (!zenGet(this.$getHTML,false)) {
		
		var panel = docView.getPanelDiv(docView.currLevel);
		panel.innerHTML = html.join('');
		
		var types = [];
		for (var i=0; i < this.helperPlugins.length; i++) {
			if (this.helperPlugins[i].getDojoTypes && typeof this.helperPlugins[i].getDojoTypes == 'function') {
				types = types.concat(this.helperPlugins[i].getDojoTypes());
			}
				
		}
		
		require(["dojo/parser", "dojo/ready", "dojo/dom","dijit/registry","dojo/aspect"].concat(types),
	    function(parser, ready, dom){
	        ready(function(){
	            parser.parse(dom.byId(docView.getPanelDiv(docView.currLevel).id));
		        docView.pageManager.afterParse(docView);
	        });
	    });
	    
	} else {
		
		this.$HandOverHTML = html.join('');
		
	}
	return null;
}

ClientMethod afterParse(docView) [ Language = javascript ]
{
	// we have to execute the code again, after the parsing, otherwise linking is not correct!
	docView.executeCode('',docView.getSourceData(),docView.getLayout());
	
	if (docView.$isEmbedded) {
		// resize
		docView.$parentDocView.pageManager.resizeDocumentViewWithinContentPane(docView,docView.$contentPane);
	}
	
	if (this.onPageShow!='') {
		returnValue = zenInvokeCallbackMethod(this.onPageShow,this,'onPageShow','key',docView.getLayoutKey());
	}
}

/// works only for content panes that where created in a static way
ClientMethod injectDocumentViewIntoContentPane(documentView, key) [ Language = javascript ]
{
	
	var cp1 = this.$documentView.getItemByKey(key).$dojoItem;
	
	if (cp1.$documentView) {
		console.log('this is already linked!');
		var oldDocView = cp1.$documentView;

		// destroy dijit items that are on the same level
		var registry = require("dijit/registry");
		var items = registry.toArray();
		for (var i = 0;i < items.length;i++) {
			var item = registry.byId(items[i].id);
			if (item) {
				if (item.id.split('_')[1] == oldDocView.index && item.id.split('_')[2] == oldDocView.currLevel) {
					console.log(item.id);
					item.destroyRecursive();
				}
			}
		}
	}
	cp1.$plugin = this;
	cp1.$documentView = documentView;
	cp1.$key = key;
	
	documentView.$isEmbedded = true;
	documentView.$originalPlugin = this;
	documentView.$documentView = documentView;
	documentView.$parentDocView = documentView;
	documentView.$contentPane = cp1;
	
	cp1.set('content','<div class="" id="'+documentView.id+'" zen="'+documentView.index+'"></div>');
	
	// subscribe to resize events
	var aspect = require("dojo/aspect");
	
	aspect.after(cp1, "_layoutChildren", function() {
        this.$plugin.resizeDocumentViewWithinContentPane(this.$documentView,this);
        //this.$plugin.resizeDocumentViewWithinKey(this.$documentView,this.$key);
    });
    
    
	// render
	documentView.renderContents();
	//this.resizeDocumentViewWithinKey(documentView,key);
}

/// deprecated?
ClientMethod resizeDocumentViewWithinKey(documentView, key) [ Language = javascript ]
{
	documentView.setSize(documentView.$originalPlugin.$documentView.getItemByKey(key).$findElement('dojo').style.width.split('px')[0]-1,documentView.$originalPlugin.$documentView.getItemByKey(key).$findElement('dojo').style.height.split('px')[0]-1);
	var layout = documentView._lastGraph;
	
	if (layout && layout.$children) {
		for (var i=0; i < layout.$children.length; i++) {
			if (layout.$children[i].$dojoItem)  {
				layout.$children[i].$dojoItem.resize();
			}
		}
	}
}

ClientMethod resizeDocumentViewWithinContentPane(documentView, cp) [ Language = javascript ]
{
	//cp.resize();
	documentView.setSize(cp.get('domNode').style.width.split('px')[0],cp.get('domNode').style.height.split('px')[0]);
	//cp.resize();
	
	var layout = documentView._lastGraph;
	
	if (layout && layout.$children) {
		for (var i=0; i < layout.$children.length; i++) {
			if (layout.$children[i].$dojoItem)  {
				layout.$children[i].$dojoItem.resize();
			}
		}
	}
}

ClientMethod createDocumentView(layoutKey, dataKey, id) [ Language = javascript ]
{
	var mainView = this.$documentView;
	
	var ZENMOJONS = ZENNS + '/mojo'
	var newView = zenPage.createComponentNS(ZENMOJONS,'documentView');
	newView.id = id;
	newView.developerMode = mainView.developerMode;
	newView.ongetlayout = mainView.ongetlayout;
	newView.ongetdata = mainView.ongetdata;
	newView.maxPanels = mainView.maxPanels;
	newView.$isEmbedded = true;
	
	newView.setLayoutKey(layoutKey);
	newView.setDocumentKey(dataKey);
	
	zenPage.setComponentId(newView,id);
	
	// copy plugins
	
	for (var i = 0; i < mainView.plugins.length; i++) {
		var plugin = mainView.plugins[i];
		var pluginCopy = zenPage.createComponentNS(ZENMOJONS,plugin._type);
		newView.plugins.push(pluginCopy);
	}
	
	return newView;
}

ClientMethod addTabWithDocumentView(docView, tabKey, tabId, tabTitle, newDocView) [ Language = javascript ]
{
	var layoutItem = docView.getItemByKey(tabKey);
	var tab = layoutItem.$dojoItem;
	
	if (layoutItem.$dojoType != 'dijit/layout/TabContainer') {
		return;
	}
	
	require(["dijit/layout/TabContainer", "dijit/layout/ContentPane", "dojo/domReady!"], function(TabContainer, ContentPane){
	    var cp1 = new ContentPane({
	         title: tabTitle,
	         closable:true,
	         selected:true,
	         content: '<div class="" id="'+newDocView.id+'" zen="'+newDocView.index+'"></div>',
	         style:'width:100%;height:100%;'
	    });
	    tab.addChild(cp1);
	    tab.selectChild(cp1);
	    tab.startup();
	    tab.resize();
	    cp1.resize();
	    
	    newDocView.$contentPane = cp1;
	    newDocView.$parentDocView = docView; 
	    
	    cp1.$plugin = newDocView.pageManager;
		cp1.$documentView = newDocView;
	    
	    var aspect = require("dojo/aspect");
		
		aspect.after(cp1, "_layoutChildren", function() {
	        this.$plugin.resizeDocumentViewWithinContentPane(this.$documentView,this);
	    });
	    
		// render
		newDocView.renderContents();
	});
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof require === 'undefined') {
		alert('Dojo library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

}
