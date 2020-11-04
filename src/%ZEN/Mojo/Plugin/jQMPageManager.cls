/// This plugin adds support for the jQueryMobile library. It was developed and tested with
/// jQM version 1.3.2 and jQuery 1.10.2.
/// 
/// - 1.0.3
/// 	added support for setting a global theme using the property jQueryTheme
/// 
Class %ZEN.Mojo.Plugin.jQMPageManager Extends %ZEN.Mojo.Plugin.basePageManager [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "jQMPageManager" ];

/// A version string of the base page manager. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.3" ];

/// Current jQuery theme for the page. Don't change them after initial set, but use the changeTheme method of the helper plugin instead
Property jQueryTheme As %ZEN.Datatype.string [ InitialExpression = "c" ];

/// jQM animation used between document push and pop transitions
Property jQueryAnimation As %ZEN.Datatype.string [ InitialExpression = "slide" ];

/// If any plugin sets this flag to true the <CLASS>documentView</CLASS> component will not inject the
/// HTML into the DOM and will not update when a document level gets popped.
/// The plugin will be responsible to do the rendering using the callbacks
/// <METHOD>afterRenderDocument</METHOD> and <METHOD>afterPopDocument</METHOD>
Property suppressRender As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 1 ];

/// If any plugin sets this flag to true the event handler of the <CLASS>documentView</CLASS> component
/// will not stop the propagation of the event
Property suppressStopPropagation As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 1 ];

Property isInTransition As %ZEN.Datatype.boolean(XMLPROJECTION = "NONE") [ InitialExpression = 0, Internal ];

/// gets called when a page transition to another document has finished
Property onPageShow As %ZEN.Datatype.eventHandler;

/// Returns a string which gets injected as attributes to the <div> holding the document.
ClientMethod getDocumentAttributes(docView, displayMode) [ Language = javascript ]
{
	var pageId = 'page'+displayMode+docView.currLevel;
	return 'data-role="page" data-url="'+pageId+'" parentindex="'+docView.index+'" data-theme="'+this.jQueryTheme+'" id="'+pageId+'"';
}

/// Gets called after the HTML for the current document got rendered and is successfully
/// injected into the DOM. If <PROPERTY>suppressRender</PROPERTY> is set to true for any
/// registered plugin the HTML is generated but not injected!
ClientMethod afterRenderDocument(docView, displayMode, html) [ Language = javascript ]
{
	var pageId = 'page'+displayMode+docView.currLevel;
	
	/*
	if($('#'+pageId).length > 0) {
		// ...remove it after jqm finished the transition
		setTimeout(function(pageId){
			//console.log('remove #'+pageId);
			$('#'+pageId).remove();
		},2000,[pageId]);
	}
	*/
	
	//$.mobile.initializePage();
	var newPage = $(html.join(''));
	newPage.appendTo( $.mobile.pageContainer );
	newPage.page();
	
	if (!this._pageshowAdded) {
		
		this._pageshowAdded = true;
		
		$(document).on('pageshow', 'div', function(event, data){
	   		// transition ended
	   		//console.log('goto done'+this.getAttribute('parentindex'));
	   		var doc = zenPage.getComponent(this.getAttribute('parentindex'));
	   		var plugin = doc.getPluginByName('jQMPageManager');
	   		
	   		var levelTarget = event.target.id.replace(/\D/g,'');
	   		var levelSource = data.prevPage[0].id.replace(/\D/g,'');
	   		var isTargetLayout = event.target.id.indexOf('layout') > -1;
	   		var isSourceLayout = data.prevPage[0].id.indexOf('layout') > -1;
	   		
	   		// moving back from data to layout view
	   		if (isTargetLayout && !isSourceLayout) {
		   		$('#pagedata'+parseInt(levelSource)).remove();
	   		}
	   		
	   		// we are going backwards or updating
	   		if (levelTarget <= levelSource && doc.displayMode == 'layout') {
		   		//data.prevPage[0].remove();
		   		$('#page'+doc.displayMode+parseInt(levelSource)).remove();
		   		//$('#'+data.prevPage[0].id).remove();
		   		if (levelSource - levelTarget > 1) {
			   		// popAll call! remove all the other intermediate levels
			   		for (var i = (parseInt(levelTarget) + 1); i < levelSource; i++) {
				   		console.log("removing " + i);
				   		$('#page'+doc.displayMode+i).remove();
			   		}
		   		}
	   		}
	   		
	   		if (doc && plugin.isInTransition) {
		   		plugin.isInTransition = false;
		   		//console.log('looking for callback');
				
		   		if (plugin.onPageShow && (plugin.onPageShow != '')) {
			   		//console.log('calling callback');
		   			zenInvokeCallbackMethod(plugin.onPageShow,plugin,'onPageShow','layoutkey',doc.getLayoutKey(),'documentkey',doc.getDocumentKey());
		   		}
			}
		});
		
		$(document).on('pagebeforechange', function(e,ob) {
	    	if(ob.toPage && (typeof ob.toPage==="string")) {
		    	var doc = zenPage.getComponent($('div[parentindex]')[0].getAttribute('parentindex'));
		    	if (ob.toPage.split('#pagelayout')[1] < doc.currLevel) {
		       		if (doc.currLevel > 0) {
			       		// implement our own handler for back button in case
			       		// we have a document stack
			       		//console.log("blocking the back " + ob.toPage);
			       		e.preventDefault();
		       			doc.popDocument();
		       		}
		    	}
	    	} else {
		    	//console.log('pagebeforechange: '+ob.toPage[0].id);
		    	// in case the target page has no id we prevent switching to it - this prevents a glitch
		    	if (ob.toPage[0].id == '') {
			    	//console.log('empty');
			    	e.preventDefault();
		    	}
	    	}
		});
	
	}
	
	
	this.isInTransition = true;
	//console.log('goto' + pageId);
	$.mobile.changePage(newPage,{transition: this.jQueryAnimation, reverse:zenGet(this.$jQMNextAnimationReverse,false)});
	this.$jQMNextAnimationReverse = false;
}

/// Gets called after a document level was popped from the stack. The rendering for the transition
/// already started, except <PROPERTY>suppressRender</PROPERTY> is set to true by any plugin.
ClientMethod afterPopDocument(docView, render) [ Language = javascript ]
{
	if (zenGet(render,false)) {
		this.$jQMNextAnimationReverse = true;
		docView._layout[docView.currLevel] = null;
		docView.renderDocument();
	} else {
	
		var pageId = '#page'+docView.displayMode+docView.currLevel;
		var page = $(pageId);
		this.isInTransition = true;
		//console.log('flipping back');
		$.mobile.changePage(page,{transition: this.jQueryAnimation, reverse:true});
		
	}
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof $ === 'undefined') {
		alert('jQuery library is not loaded correctly. Check your includes.');
		return false;
	} else if (typeof $.mobile === 'undefined') {
		alert('jQueryMobile library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

}
