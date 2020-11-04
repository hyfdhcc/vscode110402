/// This plugin adds support for the chocolate-chip UI library. It was developed and tested with
/// chui version 3.5.2
/// 
/// 0.5.5
/// 	- corrected rendering of $navbar
/// 
/// 0.5.4
/// 	- corrected rendering of $aside
/// 
/// 0.5.3
/// 	- decoupled documentation from plugin
/// 
/// 0.5.2
/// 	- updated documentation to reflect current state
Class %ZEN.Mojo.Plugin.chuiHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "chuiHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "0.5.5" ];

/// This method returns an array containing objects which describe all layout elements
/// the plugin supports. Each object in the list has to set the property 'identifier' in
/// order to register this layout element for this plugin.
/// In case multiple plugins register for the same feature the <CLASS>documentView</CLASS>
/// component will indicate this conflict. Use the getPluginConflicts method in order to retrieve
/// the conflicts.
/// The first plugin which registers a features will be used for dispatching in case there is
/// a conflict. If you want to change preference use the setPluginMapping method of the
/// <CLASS>documentView</CLASS>
ClientMethod getFeatures() [ Language = javascript ]
{
	var features = [
		{identifier:'$article'},
		{identifier:'$aside'},
		{identifier:'$button'},
		{identifier:'$div'},
		{identifier:'$h1'},
		{identifier:'$h2'},
		{identifier:'$h3'},
		{identifier:'$h4'},
		{identifier:'$h5'},
		{identifier:'$link'},
		{identifier:'$list'},
		{identifier:'$listitem'},
		{identifier:'$navbar'},
		{identifier:'$p'},
		{identifier:'$section'},
	];
	
	return features;
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	// no block for any component we render!
	instance.$hasBlock = false;
	instance.$showTitle = false;
	
	// indicate if this is a "loop"
	switch(type) {
		// fall through:
		case '$list':
			instance.$isLoop = true;
			instance.$children = [];
			break;
		default:
			break;
	}
	
	switch(type) {
		
		case '$article':
			instance.$render = this.renderArticle;
			break;
		case '$aside':
			instance.$render = this.renderAside;
			break;
		case '$button':
			instance.$render = this.renderButton;
			break;
		case '$div':
			instance.$render = this.renderDiv;
			break;
		case '$h1':
		case '$h2':
		case '$h3':
		case '$h4':
		case '$h5':
			instance.headerSize = type.charAt(2);
			instance.$render = this.renderH;
			break;
		case '$link':
			instance.$render = this.renderLink;
			break;
		case '$list':
			instance.$render = this.renderList;
			break;
		case '$listitem':
			instance.$render = this.renderListitem;
			break;
		case '$navbar':
			instance.$render = this.renderNavbar;
			break;
		case '$p':
			instance.$render = this.renderP;
			break;
		case '$section':
			instance.$render = this.renderSection;
			break;
		
	}
	
	return instance;
}

/// Render an article
ClientMethod renderArticle() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	var pageId = 'page'+docView.currLevel;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var title = zenGet(this.title,'') ? 'title="'+zenGet(this.title,'')+'"' : '';
	
	var currentOrNext = (docView.currLevel == 0) ? 'current' : 'next';
	
	html.push('<article id="'+pageId+'" '+hidden+' '+title+' class="'+currentOrNext+'">');

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</article>');
	
	return html.join('');
}

/// Render an aside element
ClientMethod renderAside() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false);
	var cssClass = zenGet(this.cssClass,'');
	var nav = zenGet(this.nav,true) ? 'nav' : '';
	var showDetail = zenGet(this.showDetail,false) ? 'show-detail' : '';
	
	if (!hidden) {
		html.push('<aside id="'+this.$makeId()+'" class="'+cssClass+'">');
		
		// render children within the set	
		if (this.$children) {
			for (var n = 0; n < this.$children.length; n++) {
				var child = this.$children[n];
				html.push(child.$renderItem());
			}
		}
		
		if (zenGet(this.nav,true)) {
			html.push('<span class="'+nav+'"></span>');
		} else if (zenGet(this.showDetail,false)) {
			html.push('<span class="'+showDetail+'"></span>');
		}
		
		html.push('</aside>');
	}
	
	return html.join('');
}

/// Render a button element
ClientMethod renderButton() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false);
	var caption = zenGet(this.caption,'');
	var cssClass = zenGet(this.cssClass,'') + ' button';
	
	if (!hidden) {
		html.push('<a id="'+this.$makeId()+'" class="'+cssClass+'" onclick="$$$event(\'click\');">');

		html.push(caption);

		html.push('</a>');

		var content = docView.injectEventHandler(html.join(''),this);
	}
	
	return content;
}

/// Render a div element
ClientMethod renderDiv() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false);
	var cssClass = zenGet(this.cssClass,'');
	
	if (!hidden) {
		html.push('<div id="'+this.$makeId()+'" class="'+cssClass+'">');
		
		// render children within the set
		if (this.$children) {
			for (var n = 0; n < this.$children.length; n++) {
				var child = this.$children[n];
				html.push(child.$renderItem());
			}
		}
		
		html.push('</div>');
	}
	
	return html.join('');
}

/// Render an <h> element
ClientMethod renderH() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var caption = zenGet(this.caption,'');
	var headerSize = zenGet(this.headerSize,1);
	var cssClass = zenGet(this.cssClass,'');
	
	html.push('<h'+headerSize+' id="'+this.$makeId()+'" class="'+cssClass+'" '+hidden+'>');

	html.push(caption);

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</h'+headerSize+'>');

	return html.join('');
}

/// Render a link element
ClientMethod renderLink() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false);
	var caption = zenGet(this.caption,'');
	var cssClass = zenGet(this.cssClass,'');
	
	if (!hidden) {
		html.push('<a id="'+this.$makeId()+'" href="'+zenGet(this.href,'')+'" class="'+cssClass+'" onclick="$$$event(\'click\');">');

		html.push(caption);

		html.push('</a>');

		var content = docView.injectEventHandler(html.join(''),this);
	}
	
	return content;
}

/// Render a list
ClientMethod renderList() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var caption = zenGet(this.caption,'');
	var switchedClass = zenGet(this.switched,false) ? ' switched' : '';
	var cssClass = zenGet(this.cssClass,'list') + switchedClass;
	
	if (!hidden && caption !== '') {
		html.push('<h2>'+caption+'</h2>');
	}
	
	html.push('<ul id="'+this.$makeId()+'" '+hidden+' class="'+cssClass+'">');

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}

	html.push('</ul>');

	return html.join('');
}

/// Render a listitem
ClientMethod renderListitem() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var caption = zenGet(this.caption,'');
	var navigationClass = zenGet(this.showNavigation,false) ? ' nav' : '';
	var datagoto = zenGet(this.showNavigation,false) ? ' data-goto' : '';
	var compClass = zenGet(this.complex,false) ? ' comp' : '';
	var detailClass = zenGet(this.showDetail,false) ? ' show-detail' : '';
	var cssClass = zenGet(this.cssClass,'') + navigationClass + detailClass + compClass;
	
	html.push('<li id="'+this.$makeId()+'" '+hidden+' '+datagoto+' class="'+cssClass+'" onclick="$$$event(\'click\');">');

	html.push(caption);

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}

	html.push('</li>');

	var content = docView.injectEventHandler(html.join(''),this);
	
	return content;
}

/// Render a navbar
ClientMethod renderNavbar() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	var pageId = 'page'+docView.currLevel;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';

	html.push('<nav id="'+this.$makeId()+'" '+hidden + ' class="current">');

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('<h1>'+zenGet(this.title,'')+'</h1>');
	
	html.push('</nav>');
	return html.join('');
}

/// Render an <p> element
ClientMethod renderP() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var caption = zenGet(this.caption,'');
	var cssClass = zenGet(this.cssClass,'');
	
	html.push('<p id="'+this.$makeId()+'" class="'+cssClass+'" '+hidden+'>');

	html.push(caption);

	html.push('</p>');

	return html.join('');
}

/// Render a section
ClientMethod renderSection() [ Internal, Language = javascript ]
{
	
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<section id="'+this.$makeId()+'" '+hidden+'>');

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</section>');
	
	return html.join('');
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
