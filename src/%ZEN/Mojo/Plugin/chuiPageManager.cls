/// This plugin adds support for the chocolate-chip UI library. It was developed and tested with
/// chui version 3.5.2
Class %ZEN.Mojo.Plugin.chuiPageManager Extends %ZEN.Mojo.Plugin.basePageManager [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "chuiPageManager" ];

/// A version string of the base page manager. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "0.5.3" ];

/// If any plugin sets this flag to true the <CLASS>documentView</CLASS> component will not inject the
/// HTML into the DOM and will not update when a document level gets popped.
/// The plugin will be responsible to do the rendering using the callbacks
/// <METHOD>afterRenderDocument</METHOD> and <METHOD>afterPopDocument</METHOD>
Property suppressRender As %Boolean(XMLPROJECTION = "NONE") [ InitialExpression = 1 ];

/// gets called when a page transition to another document has finished
Property onPageShow As %ZEN.Datatype.eventHandler;

/// Gets called after the HTML for the current document got rendered and is successfully
/// injected into the DOM. If <PROPERTY>suppressRender</PROPERTY> is set to true for any
/// registered plugin the HTML is generated but not injected!
ClientMethod afterRenderDocument(docView, displayMode, html) [ Language = javascript ]
{
	var pageId = 'page'+docView.currLevel;
	var panel = docView.getPanelDiv(docView.currLevel);
	var body = document.body;
	var article = document.getElementById(pageId);
	
	if (article) {
		//article.parentNode.remove();
		var doc = article.parentNode;
		doc.parentNode.removeChild(doc);
		body.innerHTML = body.innerHTML + html.join('');
		var plugin = this;
		$('#'+pageId).on('navigationend', function() {
       		if (plugin.onPageShow && (plugin.onPageShow != '')) {
	   			zenInvokeCallbackMethod(plugin.onPageShow,plugin,'onPageShow','layoutkey',docView.getLayoutKey(),'documentkey',docView.getDocumentKey());
	   		}
  		})
	} else {
		body.innerHTML = body.innerHTML + html.join('');
		var plugin = this;
		$('#'+pageId).on('navigationend', function() {
       		if (plugin.onPageShow && (plugin.onPageShow != '')) {
	   			zenInvokeCallbackMethod(plugin.onPageShow,plugin,'onPageShow','layoutkey',docView.getLayoutKey(),'documentkey',docView.getDocumentKey());
	   		}
  		})
		$.UIGoToArticle('#'+pageId);
	}
}

/// Gets called after a document level was popped from the stack. The rendering for the transition
/// already started, except <PROPERTY>suppressRender</PROPERTY> is set to true by any plugin.
ClientMethod afterPopDocument(docView, render) [ Language = javascript ]
{
	if (zenGet(render,false)) {
		docView._layout[docView.currLevel] = null;
		docView.renderDocument();
	} else {
	
		var pageId = '#page'+docView.currLevel;
		var nextpageId = 'page'+(docView.currLevel+1);
		var plugin = this;
		$(pageId).on('navigationend', function() {
       		if (plugin.onPageShow && (plugin.onPageShow != '')) {
	   			zenInvokeCallbackMethod(plugin.onPageShow,plugin,'onPageShow','layoutkey',docView.getLayoutKey(),'documentkey',docView.getDocumentKey());
	   		}
  		})
		$.UIGoToArticle(pageId);
		var article = document.getElementById(nextpageId);
		if (article) {
			//article.parentNode.remove();
			var doc = article.parentNode;
			doc.parentNode.removeChild(doc);
		}
		
	}
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof $ === 'undefined') {
		alert('jQuery library is not loaded correctly. Check your includes.');
		return false;
	} else if (typeof $.UIGoToArticle === 'undefined') {
		alert('Chocolate Chip UI library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

}
