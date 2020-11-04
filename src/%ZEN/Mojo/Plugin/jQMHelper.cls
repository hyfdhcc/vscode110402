/// This plugin adds support for the jQueryMobile library. It was developed and tested with
/// jQM version 1.3.2 and jQuery 1.10.2.
/// 
/// 1.0.15
/// 	- support additional missing attributes (JBE011)
/// 
/// 1.0.14
/// 	- introducing library version in the classname
/// 
/// 1.0.13
/// 	- support additional missing attributes (SWI081)
/// 
/// 1.0.12
/// 	- support passing of options to showPopup method
/// 
/// 1.0.11
/// 	- improved grid functionality and added the columnCount attribute
/// 
/// 1.0.10
/// 	- decoupled documentation from plugin
/// 1.0.9
/// 	- support theming of $navbaritem via the dataTheme attribute
/// 
/// 1.0.8
/// 	- remove useContentTheme for $collapsible, $collapsibleset and add support for data-content-theme with attribute dataContentTheme
/// 
/// 1.0.7
/// 	- moved the jQueryTheme property to the jQMPageManager
/// 
/// 1.0.6
/// 	- added missing attributes to some widgets  
/// 
/// 1.0.5
/// 	- added support for 16x16 icons for listview items. Also cleaned up the documentation
/// 	  for the $listviewitem element. Added contentClass to allow styling of the content
/// 	  attribute.
/// 
/// 1.0.4
/// 	- added suppressBackButton attribute to $header. 
/// 
/// 1.0.3
/// 	- updated documentation to reflect current state
/// 
Class %ZEN.Mojo.Plugin.jQMHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "jQMHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.15" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "jQMHelper";

/// Current jQuery theme for header and footer. Don't change them after initial set, but use the changeTheme method instead
Property jQueryHeaderTheme As %ZEN.Datatype.string [ InitialExpression = "a" ];

/// Current jQuery theme for grids and bars. Don't change them after initial set, but use the changeTheme method instead
Property jQueryBarTheme As %ZEN.Datatype.string [ InitialExpression = "a" ];

/// Current jQuery theme for collapsible set. Don't change them after initial set, but use the changeTheme method instead
Property jQueryCollapsibleTheme As %ZEN.Datatype.string [ InitialExpression = "a" ];

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
		{identifier:'$collapsible'},
		{identifier:'$collapsibleset'},
		{identifier:'$control'},
		{identifier:'$controlgroup'},
		{identifier:'$fieldset'},
		{identifier:'$footer'},
		{identifier:'$grid'},
		{identifier:'$header'},
		{identifier:'$listview'},
		{identifier:'$listviewitem'},
		{identifier:'$navbar'},
		{identifier:'$navbaritem'},
		{identifier:'$panel'},
		{identifier:'$popup'},
		
		// alias for $control
		{identifier:'$input'},
		{identifier:'$string'},
		{identifier:'$text'},
		{identifier:'$password'},
		{identifier:'$checkbox'},
		{identifier:'$textarea'},
		{identifier:'$select'},
		{identifier:'$button'},
		{identifier:'$radio-button'},
		{identifier:'$link'},
		
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
	
	// indicate if this is a "loop"
	switch(type) {
		// fall through:
		case '$collapsible':
		case '$collapsibleset':
		case '$navbar':
		case '$listview':
			instance.$isLoop = true;
			instance.$children = [];
			break;
		default:
			break;
	}
	
	switch(type) {
		
		case '$string':
		case '$text':
		case '$password':
		case '$checkbox':
		case '$textarea':
		case '$select':
		case '$button':
		case '$radio-button':
		case '$link':
		case '$input':
			
			instance.type = '$control';
			if (type != '$input') {
				instance.controlType = type;
			} else {
				instance.controlType = zenGet(instance.inputType,'');
			}
		
		case '$control':
			// array of event handlers
			instance.$eventHandlers = {};

			// fill in $renderControl and other properties
			this.decorateControl(instance);

			instance.$render = this.renderControl;
			break;
		
			
		case '$collapsible':
			instance.$render = this.renderCollapsible;
			break;
		case '$collapsibleset':
			instance.$render = this.renderCollapsibleSet;
			break;
		case '$controlgroup':
			instance.$render = this.renderControlGroup;
			break;
		case '$fieldset':
			instance.$render = this.renderFieldSet;
			break;
		case '$footer':
			instance.$render = this.renderFooter;
			break;
		case '$grid':
			instance.$render = this.renderGrid;
			break;
		case '$header':
			instance.$render = this.renderHeader;
			break;
		case '$listview':
			instance.$render = this.renderListView;
			break;
		case '$listviewitem':
			instance.$render = this.renderListViewItem;
			break;
		case '$navbar':
			instance.$render = this.renderNavBar;
			break;
		case '$navbaritem':
			instance.$render = this.renderNavBarItem;
			break;
		case '$panel':
			instance.$render = this.renderPanel;
			break;
		case '$popup':
			instance.$render = this.renderPopup;
			break;
		
	}
	
	return instance;
}

/// Render an input control. The control type is based on item.controlType property.
ClientMethod renderControl() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];

	var docView = this.$documentView;

	// render the control
	// the $renderControl function is specific to controlType.
	// this is set by the decorateControl method (called by createLayoutObject)
	var content = this.$renderControl();

	content = docView.injectEventHandler(content,this);
	
	html.push(content);

	return html.join('');
}

/// Render a collapsible
ClientMethod renderCollapsible() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
	//var dataContentTheme = zenGet(this.useContentTheme,false) ? 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"' : '';
	//var dataContentTheme = 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"';
	var dataContentTheme = zenGet(this.dataContentTheme,false) ? 'data-content-theme="'+this.dataContentTheme+'"' : 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"';
	var expanded = zenGet(this.expanded,false) ? 'data-collapsed="false"' : 'data-collapsed="true"';
	var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
	var collapsedicon = (zenGet(this.collapsedicon,'').length > 0) ? 'data-collapsed-icon="'+zenGet(this.collapsedicon)+'"' : '';
	var expandedicon = (zenGet(this.expandedicon,'').length > 0) ? 'data-expanded-icon="'+zenGet(this.expandedicon)+'"' : '';
	var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
	var inset = (zenGet(this.inset,true)) ? 'data-inset="true"' : 'data-inset="false"';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<fieldset data-role="collapsible" '+hidden+' '+dataTheme+' '+dataContentTheme+' '+expanded+' '+mini+' '+inset+' '+dataiconpos+' '+collapsedicon+' '+expandedicon+' class="'+zenGet(this.cssClass,'')+'">');

	if (this.label) {
		html.push('<legend>');
			html.push(zenEscapeXML(zenGet(this.label)));
		html.push('</legend>');
	}

	// render children within the collapsible
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</fieldset>');
	return html.join('');
}

/// Render a collapsible set
ClientMethod renderCollapsibleSet() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
	//var dataContentTheme = zenGet(this.useContentTheme,false) ? 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"' : '';
	var dataContentTheme = 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"';
	dataContentTheme = zenGet(this.dataContentTheme,false) ? 'data-content-theme="'+this.dataContentTheme+'"' : dataContentTheme;
	var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
	var collapsedicon = (zenGet(this.collapsedicon,'').length > 0) ? 'data-collapsed-icon="'+zenGet(this.collapsedicon)+'"' : '';
	var expandedicon = (zenGet(this.expandedicon,'').length > 0) ? 'data-expanded-icon="'+zenGet(this.expandedicon)+'"' : '';
	var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
	var inset = (zenGet(this.inset,true)) ? 'data-inset="true"' : 'data-inset="false"';
	var corners = (zenGet(this.corners,true)) ? 'data-corners="true"' : 'data-corners="false"';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<div data-role="collapsible-set" '+hidden+' '+dataTheme+' '+dataContentTheme+' '+corners+' '+mini+' '+inset+' '+dataiconpos+' '+collapsedicon+' '+expandedicon+'class="'+zenGet(this.cssClass,'')+'">');

	// render children within the set
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	return html.join('');
}

/// Render a controlgroup
ClientMethod renderControlGroup() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hz = zenGet(this.horizontal,false) ? 'data-type="horizontal"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<div data-role="controlgroup" '+hz+' '+hidden+'>');

	// render children within the controlgroup
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	return html.join('');
}

/// Render a fieldset
ClientMethod renderFieldSet() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var hz = zenGet(this.horizontal,false) ? 'data-type="horizontal"' : '';
	var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
	var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<fieldset data-role="controlgroup" '+hz+' '+mini+' '+dataiconpos+' '+hidden+'>');

	if (this.label) {
		html.push('<legend>');
			html.push(zenEscapeXML(zenGet(this.label)));
		html.push('</legend>');
	}

	// render children within the fieldset
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</fieldset>');
	return html.join('');
}

/// Render a footer.
ClientMethod renderFooter() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;

	var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : 'data-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryHeaderTheme+'"';
	var fixed = zenGet(this.fixed,true) ? 'data-position="fixed"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var cssClass = zenGet(this.cssClass,false) ? 'class="'+zenGet(this.cssClass)+'"' : '';
	
	html.push('<div data-role="footer" '+dataTheme+' '+fixed+' '+hidden+' '+cssClass+' data-id="'+docView.id+'footer">');

	if (this.content) {
		html.push(this.content);
	}
	else {
		if (this.caption || this.captionContent) {
			var captionClass = zenGet((this.caption ? this.captionClass : this.captionContentClass),'');
			html.push('<h1 class="'+captionClass+'" style="'+zenGet(this.captionStyle)+'">');
			if (this.captionContent) {
				html.push(this.captionContent);
			}
			else {
				html.push(zenEscapeXML(zenGet(this.caption)));
			}
			html.push('</h1>');
		}
	}

	// render children within the footer
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	return html.join('');
}

/// Render a grid
ClientMethod renderGrid() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var topClass = ['','ui-grid-solo','ui-grid-a','ui-grid-b','ui-grid-c','ui-grid-d'];
	var innerClass = ['ui-block-a','ui-block-b','ui-block-c','ui-block-d','ui-block-e'];
	var style = zenGet(this.style,false) ? 'style="'+this.style+'"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	//var displayClass = zenGet(this.showBox,false) ? 'ui-bar ui-bar-'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryBarTheme : "";
	var barTheme = zenGet(this.barTheme,false) ? 'ui-bar ui-bar-'+this.barTheme : 'ui-bar ui-bar-'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryBarTheme;

	if (!zenGet(this.showBox,false)) {
		// set no bar theme
		barTheme = '';
	}

	// render children within the grid
	if (this.$children) {
		
		var columnCount = zenGet(this.columnCount,this.$children.length)
		columnCount = Math.min(columnCount,innerClass.length);

		html.push('<div class="'+topClass[columnCount]+' '+hidden+' '+barTheme+' '+zenGet(this.cssClass,'')+'" '+style+'>');
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push('<div class="'+innerClass[n%(columnCount)]+'">');
			html.push(child.$renderItem());
			html.push('</div>');
		}
		html.push('</div>');
	}
	
	return html.join('');
}

/// Render a basic header bar.<br/>
/// The header text is specified by <var>caption</var>.<br/>
ClientMethod renderHeader() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : 'data-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryHeaderTheme+'"';
	var fixed = zenGet(this.fixed,true) ? 'data-position="fixed"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var renderAtBack = zenGet(this.updateLayoutOnBack,false) ? true : false;
	var backhidden = zenGet(this.backhidden,false) ? 'hidden' : ''; 
    var backdataicon = (zenGet(this.backdataicon,'').length > 0) ? 'data-icon="'+zenGet(this.backdataicon)+'"' : 'data-icon="arrow-l"';
	var backdataiconpos = (zenGet(this.backdataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.backdataiconpos)+'"' : '';
    var backinline = zenGet(this.backinline) ? 'data-inline="true"' : '';
    var backcorners = zenGet(this.backcorners,true) ? 'data-corners="true"' : 'data-corners="false"';
    var backshadow = zenGet(this.backshadow,true) ? 'data-shadow="true"' : 'data-shadow="false"';
    var backtheme = zenGet(this.backtheme,false) ? 'data-theme="'+zenGet(this.backtheme)+'"' : '';
	var backcaption = zenEscapeXML(zenGet(this.backcaption,$$$Text('Back')));
	var suppressBackButton = zenGet(this.suppressBackButton,false);
	
	var headerClass = zenGet(this.headerClass,'');
	html.push('<div id="'+docView.id+'Header" data-role="header" '+dataTheme+' '+fixed+' '+hidden+' data-id="'+docView.id+'Header" class="'+headerClass+'" style="'+zenGet(this.style)+zenGet(this.captionStyle)+'">');
	// back arrow
	if (docView.currLevel>0 && !suppressBackButton) {
		var handler = this.isMobile ? 'ontouchstart' : 'onclick';
		html.push('<a href="#" '+backtheme+' '+backhidden+' '+backdataicon+' '+backdataiconpos+' '+backinline+' '+backcorners+' '+backshadow+' '+handler+'="zenPage.getComponent('+docView.index+').popDocument('+renderAtBack+');">'+backcaption+'</a>');
	}
	if (this.content) {
		html.push(this.content);
	}
	else {
		if (this.caption || this.captionContent) {
			var captionClass = zenGet((this.caption ? this.captionClass : this.captionContentClass),'');
			html.push('<h1 class="'+captionClass+'" style="'+zenGet(this.captionStyle)+'">');
			if (this.captionContent) {
				html.push(this.captionContent);
			}
			else {
				html.push(zenEscapeXML(zenGet(this.caption)));
			}
			html.push('</h1>');
		}
	}
	// render children within the header
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');

	return html.join('');
}

/// Render a listview
ClientMethod renderListView() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var inset = (zenGet(this.inset,false)) ? 'data-inset="true"' : 'data-inset="false"';
	var filter = (zenGet(this.filter,false)) ? 'data-filter="true"' : 'data-filter="false"';
	var filterreveal = (zenGet(this.filterreveal,false)) ? 'data-filter-reveal="true"' : 'data-filter-reveal="false"';
	var filterplaceholder = (zenGet(this.filterplaceholder)) ? 'data-filter-placeholder="'+this.filterplaceholder+'"' : '';
	var filtertheme = (zenGet(this.filtertheme)) ? 'data-filter-theme="'+this.filtertheme+'"' : '';
	var dividertheme = (zenGet(this.dividertheme)) ? 'data-divider-theme="'+this.dividertheme+'"' : '';
	var counttheme = (zenGet(this.counttheme)) ? 'data-count-theme="'+this.counttheme+'"' : '';
	var splittheme = (zenGet(this.splittheme)) ? 'data-split-theme="'+this.splittheme+'"' : '';
	var spliticon = zenGet(this.spliticon,false) ? 'data-split-icon="'+zenGet(this.spliticon)+'"' : '';
	var dataTheme = (zenGet(this.dataTheme)) ? 'data-theme="'+this.dataTheme+'"' : '';
	// don't show filter if listview is hidden
	if (zenGet(this.hidden,false)) {
		filter = 'data-filter="false"';
	}
	var autodividers = (zenGet(this.autodividers,false)) ? 'data-autodividers="true"' : '';
	var style = zenGet(this.style,false) ? 'style="'+this.style+'"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	if (zenGet(this.ordered,false)) {
		html.push('<ol data-role="listview" '+inset+' '+filter+' '+filterplaceholder+' '+filterreveal+' '+filtertheme+' '+dividertheme+' '+counttheme+' '+dataTheme+' '+splittheme+' '+spliticon+' '+autodividers+' '+style+' '+hidden+' class="'+zenGet(this.cssClass,'')+'">');
	} else {
		html.push('<ul data-role="listview" '+inset+' '+filter+' '+filterplaceholder+' '+filterreveal+' '+filtertheme+' '+dividertheme+' '+counttheme+' '+dataTheme+' '+splittheme+' '+spliticon+' '+autodividers+' '+style+' '+hidden+' class="'+zenGet(this.cssClass,'')+'">');
	}

	// render children within the listview
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	if (zenGet(this.ordered,false)) {
		html.push('</ol>');
	} else {
		html.push('</ul>');
	}
	return html.join('');
}

/// Render a listviewitem
ClientMethod renderListViewItem() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var id = zenGet(this.id,false) ? 'id="'+this.id+'"' : '';
	var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
	var divider = zenGet(this.divider) ? 'data-role="list-divider"' : '';
	var count = zenGet(this.count) ? '<span class="ui-li-count">'+this.count+'</span>' : '';
	var dataicon = zenGet(this.dataicon,false) ? 'data-icon="'+zenGet(this.dataicon)+'"' : '';
	var thumbnail = zenGet(this.thumbnail,false) ? '<img src="'+this.thumbnail+'">' : '';
	var icon = zenGet(this.icon,false) ? '<img src="'+this.icon+'" class="ui-li-icon">' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<li '+id+' '+divider+' '+dataicon+' '+hidden+' '+dataTheme+'>');

	if (zenGet(this.clickable,false)) {
		html.push('<a href="#" id="'+this.$makeId('listviewitem')+'" onclick="$$$event(\'click\');">');
	}

	if (zenGet(this.thumbnail,false)) {
		html.push(thumbnail);
	}
	
	if (zenGet(this.icon,false)) {
		html.push(icon);
	}

	if (this.label) {
		if (zenGet(this.labelNoWrapper,true)) {
			html.push(zenEscapeXML(zenGet(this.label)));
		} else {
			html.push('<h2>'+zenEscapeXML(zenGet(this.label))+'</h2>');
		}
	}
	
	if (this.content) {
		html.push('<p style:"white-space:normal;" class:"'+zenGet(this.contentClass,'li-content-class')+'">'+zenEscapeXML(zenGet(this.content))+'</p>');
	}

	// render children within the listviewitem
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	if (zenGet(this.count)) {
		html.push(count);
	}
	
	if (zenGet(this.clickable,false)) {
		html.push('</a>');
	}
	
	html.push('</li>');
	
	var content = docView.injectEventHandler(html.join(''),this);
	
	return content;
}

/// Render a navbar
ClientMethod renderNavBar() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	
	html.push('<div data-role="navbar" '+dataiconpos+' '+hidden+'>');
	html.push('<ul>');

	// render children within the navbar
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</ul>');
	html.push('</div>');
	return html.join('');
}

/// Render a navbaritem
ClientMethod renderNavBarItem() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
	var icon = (zenGet(this.icon,'').length > 0) ? 'data-icon="'+zenGet(this.icon)+'"' : '';
	var active = (zenGet(this.active,false)) ? 'ui-btn-active' : '';
	var persist = (zenGet(this.persist,false)) ? 'ui-state-persist' : '';
	var caption = zenEscapeXML(zenGet(this.caption,''));
	var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
	var dataTheme = zenGet(this.dataTheme) ? 'data-theme="'+this.dataTheme+'"' : '';
	
	//onclick="$$$event(\'click\');"
	html.push('<li '+hidden+'><a href="#" id="'+this.$makeId('navbaritem')+'" class="'+active+' '+persist+'" '+icon+' '+dataiconpos+' ' + dataTheme + ' onclick="$$$event(\'click\');">'+caption+'</a></li>');
	
	/// $$$event handling
	
	var content = docView.injectEventHandler(html.join(''),this);
	
	return content;
}

/// Render a panel
/// Note: Currently this needs to be a sibling of content, header and footer!
ClientMethod renderPanel() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	
	var animate = zenGet(this.animate,true) ? 'data-animate="true"' : 'data-animate="false"';
	var fixed = zenGet(this.fixed,false) ? 'data-position-fixed="true"' : 'data-position-fixed="false"';
	var position = zenGet(this.position) ? 'data-position="'+this.position+'"' : '';
	var displayMode = zenGet(this.displayMode) ? 'data-display="'+this.displayMode+'"' : '';
	var dataTheme = zenGet(this.dataTheme) ? 'data-theme="'+this.dataTheme+'"' : '';
	var dismissible = zenGet(this.dismissible,true) ? 'data-dismissible="true"' : 'data-dismissible="false"';
	
	html.push('<div data-role="panel" id="'+docView.currLevel+'-'+this.id+'" '+animate+' '+fixed+' '+position+' '+displayMode+' '+dataTheme+' '+dismissible+'>');

	// render children within the panel
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	return html.join('');
}

/// Opens a panel with the supplied id
ClientMethod openPanel(id) [ Language = javascript ]
{
	$('#'+this.$documentView.currLevel+'-'+id).panel('open');
}

/// Closes a panel with the supplied id
ClientMethod closePanel(id) [ Language = javascript ]
{
	$('#'+this.$documentView.currLevel+'-'+id).panel('close');
}

/// Toggles a panel with the supplied id
ClientMethod togglePanel(id) [ Language = javascript ]
{
	$('#'+this.$documentView.currLevel+'-'+id).panel('toggle');
}

/// Render a popup
ClientMethod renderPopup() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	var docView = this.$documentView;
	var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
	var cssClass = zenGet(this.cssClass,false) ? zenGet(this.cssClass) : '';
	var dataOverlayTheme = zenGet(this.dataOverlayTheme,false) ? 'data-overlay-theme="'+this.dataOverlayTheme+'"' : '';
	var corners = zenGet(this.corners,true) ? '' : 'data-corners="false"';
	var dismissible = zenGet(this.dismissible,true) ? 'data-dismissible="true"' : 'data-dismissible="false"';
	var shadow = zenGet(this.shadow,true) ? 'data-shadow="true"' : 'data-shadow="false"';
	
	html.push('<div data-role="popup" data-transition="'+zenGet(this.transition,'flow')+'" id="'+docView.currLevel+'-'+this.key+'" class="'+cssClass+'" '+dataTheme+' '+dataOverlayTheme+' '+corners+' '+dismissible+' '+shadow+'>');

	if (this.content) {
		html.push(this.content);
	}

	// render children within the form
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	return html.join('');
}

/// Opens a popup with a given key. The second argument can be used
/// to provide additional options to the popup.
ClientMethod showPopup(key, options) [ Language = javascript ]
{
	if (!options) {
		options = {};
	}
	$('#'+this.$documentView.currLevel+'-'+key).popup('open',options);
}

ClientMethod closePopup(key) [ Language = javascript ]
{
	$('#'+this.$documentView.currLevel+'-'+key).popup('close');
}

/// Fill out an instance object for a $control element.
ClientMethod decorateControl(instance) [ Internal, Language = javascript ]
{
	// decorate control instance based on controlType
	// the main thing is the $renderControl method, which emits HTML for the control.
	// The special token, $$$event, is replaced with a call to the built-in document event dispatcher.
	// $$$event('eventType');

	// default setter/getter functions
	var defSetValue = function(val,notify) {
		// apply to internal
		this.value = val;
		delete this.text;
		var ctrl = this.$findElement('control');
		if (ctrl) {
			if ('object'==typeof val) {
				ctrl.value = this.$getDisplayText();
			}
			else {
				ctrl.value = val;
			}
		}
		if (notify) {
			this.$documentView.eventHandler(this.$index,event,'change');
		}
	};
	// $getControlValue
	var defGetValue = function() {
		var value = '';
		var ctrl = this.$findElement('control');
		if (ctrl) {
			value = ctrl.value;
		}
		return value;
	};

	var defSetHint = function(hint) {
		this.hint = hint;
		var div = this.$findElement('hint');
		if (div) {
			div.innerHTML = hint;
			div.className = 'dvHint';
		}
		var ctrl = this.$findElement('control');
		if (ctrl) {
			ctrl.className = '';
		}
	};

	var defSetError = function(msg) {
		var div = this.$findElement('hint');
		if (div) {
			if (msg) {
				div.innerHTML = msg;
				div.className = 'dvHintError';
			}
			else {
				div.innerHTML = zenGet(this.hint);
				div.className = 'dvHint';
			}
		}
	};

	var controlType = zenGet(instance.controlType);

	// built-in controls
	// controlType can be '$xxx' or name of HTML input type

	// some common aliases
	switch (controlType) {
	case 'button':
		instance.controlType = '$button';
		break;
	case 'textarea':
		instance.controlType = '$textarea';
		break;
	case 'select':
		instance.controlType = '$select';
		break;
	}

	instance.$setHint = defSetHint;
	instance.$setError = defSetError;

	// default apply
	// note: coded value could be lost
	instance.$applyChangeToInstance = function() {
		this.value = this.$getControlValue();
	}
	instance.$setValue = defSetValue;
	instance.$getControlValue = defGetValue;

	instance.$disable = function(disable) {
		var ctrl = this.$findElement('control');
		if (ctrl) {
			ctrl.disabled = disable ? true : false;
		}
	}

	controlType = zenGet(instance.controlType);
	switch(controlType) {
	case '$string':
	case '$text':
	case '$password':
	case '':
	default:
		var type = 'text';
		// some built-in types
		switch(instance.controlType) {
		case '$password':
			type = 'password';
			break;
		case '$string':
		case '$text':
			type = 'text';
			break;
		default:
			type = zenGet(instance.controlType);
			type = type ? type : 'text';
			break;
		}

		instance.$renderControl = function() {
			var html = [];
			var reqd = zenGet(this.required) ? 'required="yes"' : '';
			var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
			var ro = zenGet(this.readOnly) ? 'readOnly="yes"' : '';
			var text = this.$getDisplayText();
			var list = (this.codeTable||this.valueList) ? 'list="'+this.$makeId('datalist')+'"' : '';
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var highlight = zenGet(this.highlight,false) ? 'data-highlight="true"' : 'data-highlight="false"';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
			var dataTrackTheme = zenGet(this.dataTrackTheme,false) ? 'data-track-theme="'+this.dataTrackTheme+'"' : '';
			var autocapitalize = zenGet(this.autocapitalize,true) ? '' : 'autocapitalize="off"';
			var autocorrect = zenGet(this.autocorrect,true) ? '' : 'autocorrect="off"';
			var spellcheck = zenGet(this.spellcheck,true) ? '' : 'spellcheck="false"';
			var clearButton = zenGet(this.clearButton,false) ? 'data-clear-btn="true"' : '';
			var pattern = zenGet(this.pattern,false) ? 'pattern="'+zenGet(this.pattern)+'"' : '';
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('<div data-role="fieldcontain" '+hidden+'>');
			}
			
			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('control')+'" '+hidden+'>');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}
			
			html.push('<input type="'+type+'" id="'+this.$makeId('control')+'" '+mini+' '+hidden+' '+dataTheme+' '+dataTrackTheme+' '+highlight+' '+autocapitalize + ' ' + autocorrect + ' ' + spellcheck + ' ' + clearButton + ' ' + pattern + ' class="'+zenGet(this.controlClass,'dvCtrlText')+'" placeholder="'+zenEscapeXML(zenGet(this.placeHolder).toString())+'" '+reqd+' '+dis+' '+ro+' '+list+' size="'+zenGet(this.size)+'" value="'+zenEscapeXML(text.toString())+'" style="'+zenGet(this.controlStyle)+'" min='+zenGet(this.min)+' max='+zenGet(this.max)+' step='+zenGet(this.step,1)+' onchange="$$$event(\'change\');" onkeyup="$$$event(\'keyup\');" />');
			if (this.codeTable || this.valueList) {
				var list = this.$documentView.resolveOptionList(this);
				html.push('<datalist id="'+this.$makeId('datalist')+'" style="display: none;">');
				if (list) {
					for (var n = 0; n < list.length; n++) {
						html.push('<option value="'+zenEscapeXML(list[n].value.toString())+'"/>');
					}
				}
				html.push('</datalist>');
			}
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('</div>');
			}
			
			return html.join('');
		};

		// function to apply list of options
		instance.$setOptionList = function(options) {
			var datalist = this.$findElement('datalist');
			var html = [];
			if (options && options.length) {
				// use values, not text
				for (var n = 0; n < options.length; n++) {
					html.push('<option value="'+zenEscapeXML(options[n].value)+'">'+zenEscapeXML(options[n].text)+'</option>');
				}
			}
			datalist.innerHTML = html.join('');
		}

		if ((type == 'password') && instance.enterTriggerTarget) {
			instance.$eventHandlers.keyup = function(evt) {
				if (this.enterTriggerTarget && evt && (evt.keyCode == zenENTER)) {
					var enterTarget = this.$documentView.getItemByKey(this.enterTriggerTarget);
					if (enterTarget) {
						var docView = this.$documentView;
						var enterIndex = enterTarget.$index;
						setTimeout(function() { docView.eventHandler(enterIndex,{},'click'); }, 0)
					}
				}
			};
		}
		
		instance.$setValue = function(value,notify) {
			this.value = value;
			var ctrl = this.$findElement('control');
			ctrl.value = value;
			if (type == 'range') $('#'+ctrl.id).slider('refresh');
			if (notify) {
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		}
		
		instance.$getValue = function() {
			var ctrl = this.$findElement('control');
			return ctrl.value;
		}
		
		instance.$getControlValue = function() {
			var ctrl = this.$findElement('control');
			return ctrl.value;
		}
		
		break; 

	case 'checkbox':
	case '$checkbox':
		instance.$renderControl = function() {
			var html = [];
			// !!!
			var value = zenGet(this.value);
			var text = zenGet(this.text);
			var content = zenGet(this.content);
			var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
			var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('<div data-role="fieldcontain" '+hidden+'>');
				html.push('<fieldset data-role="controlgroup">');
				var label = zenGet(this.label);
				if (label!=='') {
					html.push('<legend for="'+this.$makeId('control')+'">');
					html.push(zenEscapeXML(label.toString()));
					html.push('</legend>');
				}
			}
			
			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('control')+'" '+hidden+'>');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}
			
			var checked = value ? 'checked="1"' : '';
			html.push('<input type="checkbox" id="'+this.$makeId('control')+'" '+mini+' '+hidden+' '+dataiconpos+' '+dataTheme+' class="'+zenGet(this.controlClass,'dvCtrlCheckbox')+'" style="'+zenGet(this.controlStyle)+'" '+dis+' '+checked+' onchange="$$$event(\'change\');"/>');
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('</fieldset>');
				html.push('</div>');
			}
			
			return html.join('');
		};

		instance.$setValue = function(value,notify) {
			this.value = value;
			var ctrl = this.$findElement('control');
			ctrl.checked = value ? true : false;
			$('#'+ctrl.id).checkboxradio('refresh');
			if (notify) {
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		}
		instance.$getControlValue = function() {
			var ctrl = this.$findElement('control');
			return ctrl.checked;
		}
		break; 

	case 'textarea':
	case '$textarea':
		instance.$renderControl = function() {
			var html = [];
			var reqd = zenGet(this.required) ? 'required="yes"' : '';
			var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			var autocapitalize = zenGet(this.autocapitalize,true) ? '' : 'autocapitalize="off"';
			var autocorrect = zenGet(this.autocorrect,true) ? '' : 'autocorrect="off"';
			var spellcheck = zenGet(this.spellcheck,true) ? '' : 'spellcheck="false"';
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('<div data-role="fieldcontain">');
			}
			
			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('control')+'" '+hidden+'>');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}
			
			html.push('<textarea id="'+this.$makeId('control')+'" '+mini+' '+hidden+' '+autocapitalize + ' ' + autocorrect + ' ' + spellcheck + ' class="'+zenGet(this.controlClass,'dvCtrlText')+'" '+dis+' '+reqd+' style="'+zenGet(this.controlStyle)+'" placeHolder="'+zenEscapeXML(zenGet(this.placeHolder))+'" type="text" rows="'+zenGet(this.rows)+'" cols="'+zenGet(this.cols)+'" onchange="$$$event(\'change\');">'+zenEscapeXML(zenGet(this.value))+'</textarea>');
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('</div>');
			}
			
			return html.join('');
		};
		
		instance.$setValue = function(value,notify) {
			this.value = value;
			var ctrl = this.$findElement('control');
			ctrl.value = value;
			if (type == 'range') $('#'+ctrl.id).slider('refresh');
			if (notify) {
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		}
		
		instance.$getValue = function() {
			var ctrl = this.$findElement('control');
			return ctrl.value;
		}
		
		instance.$getControlValue = function() {
			var ctrl = this.$findElement('control');
			return ctrl.value;
		}
		
		break;  

	case '$select':
		// html select control
		instance.$renderControl = function() {
			var html = [];

			// resolve list of options
			var list = this.$documentView.resolveOptionList(instance);
			var value = '';
			if ('object' == typeof this.value) {
				if ('undefined' != this.value.value) {
					value = this.value.value;
				}
			}
			else if ('undefined' != typeof this.value) {
				value = this.value;
			}
			var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
			var slider = zenGet(this.slider) ? 'data-role="slider"' : '';
			var dataicon = (zenGet(this.dataicon,'').length > 0) ? 'data-icon="'+zenGet(this.dataicon)+'"' : '';
			var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
			var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
			var dataTrackTheme = zenGet(this.dataTrackTheme,false) ? 'data-track-theme="'+this.dataTrackTheme+'"' : '';
			var inline = zenGet(this.inline) ? 'data-inline="true"' : '';
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			var nativeMenu = zenGet(this.nativeMenu,true) ? '' : 'data-native-menu="false"';
			var multiple = zenGet(this.multiple,false) ? 'multiple="multiple"' : '';
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('<div data-role="fieldcontain" '+hidden+'>');
			}
			
			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('control')+'" '+hidden+'>');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}
			
			html.push('<select id="'+this.$makeId('control')+'" '+slider+' '+mini+' '+hidden+' '+dataicon+' '+dataiconpos+' '+dataTheme+' '+dataTrackTheme+' '+inline+' '+nativeMenu+' '+multiple+' class="'+zenGet(this.controlClass,'dvCtrlText')+'" '+dis+' size="'+zenGet(this.size)+'" value="'+zenEscapeXML(value)+'" style="'+zenGet(this.controlStyle)+'" onchange="$$$event(\'change\');">');
			if (list && list.length) {
				for (var n = 0; n < list.length; n++) {
					var option = list[n];
					var selected = option.value==value?'selected="yes"':'';
					var disabled = zenGet(option.disabled,false)
					if (disabled==0 || disabled=='false') {disabled=0} //Handle cases where disabled is interpreted as a string, but is intended to be false
					disabled = disabled ? 'disabled="disabled"' : '';
					html.push('<option '+selected+' '+disabled+' value="'+zenEscapeXML(option.value.toString())+'">'+zenEscapeXML(option.text.toString())+'</option>');
				}
			}
			else if (typeof this.optGroups == 'object') {
				oglist = this.optGroups;
				if (!oglist.length) { //Handle case where only one OptGroup is provided as an object or string instead of an array
					oglist = [oglist]
				}
				for (var n = 0; n < oglist.length; n++) {
					optgroup = oglist[n];
					if (typeof optgroup.valueList == 'object' && !optgroup.valueList.length) {	//Handle cases where valueList is an object, not an array or string
						optgroup.valueList = [optgroup.valueList]
					}	
					else if (typeof optgroup.valueList == 'undefined') { //Handle cases where valueList is undefined
						if ((typeof optgroup == 'object' && optgroup.length) || optgroup.value != 'undefined') { //Check to make sure the current optgroup is either an array of options or an option
							optgroup.valueList = []
							optgroup.valueList.push(optgroup)
						}
					}
					
					if (typeof optgroup.valueList == 'object' || typeof optgroup.valueList == 'string') { //Last check to make sure that a valid optgroup or valueList was provided
						list = this.$documentView.resolveOptionList(optgroup);
						if (optgroup.label && optgroup.label.length > 0) {html.push('<optgroup label="'+zenEscapeXML(optgroup.label.toString())+'">');}
						for (var m = 0; m < list.length; m++) {
							var option = list[m];
							var selected = option.value==value?'selected="yes"':'';
							var disabled = zenGet(option.disabled,false)
							if (disabled==0 || disabled=='false') {disabled=0}
							disabled = disabled ? 'disabled="disabled"' : '';
							html.push('<option '+selected+' '+disabled+' value="'+zenEscapeXML(option.value.toString())+'">'+zenEscapeXML(option.text.toString())+'</option>');
						}
						if (optgroup.label && optgroup.label.length > 0) {html.push('</optgroup>');}
					}
				}
			}
			
			html.push('</select>');
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('</div>');
			}
			
			return html.join('');
		};

		instance.$setValue = function(val,notify) {
			this.value = val;
			var ctrl = this.$findElement('control');
			if (ctrl) {
				if ('object'==typeof val) {
					ctrl.value = val.value;
				}
				else {
					ctrl.value = val;
				}
				if (this.slider) {
					$('#'+ctrl.id).slider('refresh');
				} else {
					$('#'+ctrl.id).selectmenu('refresh');
				}
			}
			if (notify) {
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		};

		instance.$getControlValue = function() {
			var ctrl = this.$findElement('control');
			return ctrl.value;
		}

		// apply change of control to instance value
		instance.$applyChangeToInstance = function() {
			var ctrl = this.$findElement('control');
			if (this.codeTable) {
				// use coded value
				var option = ctrl.options[ctrl.selectedIndex];
				this.value = {$code:this.codeTable, value:option.value, text:option.text};
			}
			else {
				this.value = this.$getControlValue();
			}
		}

		// function to apply list of options
		instance.$setOptionList = function(options) {
			var select = this.$findElement('control');
			select.options.length = 0;
			if (options && options.length) {
				for (var n = 0; n < options.length; n++) {
					select.options[select.options.length] = new Option(options[n].text,options[n].value);
				}
			}
		}
		break; 

	case '$date':
	case '$time':
	case '$lookup':
		// lookup and date controls
		instance.$renderControl = function() {
			var html = [];
			var text = this.$getDisplayText();
			var onchange = 'onchange="$$$event(\'lookup\');"';
			var readOnly = zenGet(this.readOnly);
			if (this.controlType=='$date') {
				var defImage = 'deepsee/ds2_calendar_44.png';
				readOnly = true;
				var type = readOnly ? 'text' : 'search';
				var onchange = 'onchange="$$$event(\'change\');"';
			}
			else if (this.controlType=='$time') {
				var defImage = 'deepsee/ds2_clock_44.png';
				// readOnly = true;
				var type = readOnly ? 'text' : 'search';
				var onchange = 'onchange="$$$event(\'change\');"';
			}
			else {
				var defImage = 'deepsee/ds2_magnify_44.png';
				var type = readOnly ? 'text' : 'search';
			}
			var readOnly = readOnly ? 'readOnly="yes"' : '';

			var lookupImage = zenGet(this.lookupImage,defImage);
			html.push('<table class="dvLookupTable" cellpadding="0" cellspacing="0" border="0"><tr>');
			html.push('<td><input type="'+type+'" placeHolder="'+this.placeHolder+'" id="'+this.$makeId('control')+'" class="'+zenGet(this.controlClass,'dvCtrlText')+'" size="'+zenGet(this.size)+'" value="'+zenEscapeXML(text.toString())+'" style="'+zenGet(this.controlStyle)+'" '+onchange+' '+readOnly+'/></td>');
			html.push('<td><image src="'+lookupImage+'" class="dvLookupImage" onclick="$$$event(\'lookup\');" /></td>');
			html.push('</tr></table>');
			return html.join('');
		};

		// event handler(s)
		instance.$eventHandlers.lookup = function(evt) {

			if ((this.controlType=='$date')||(this.controlType=='$time')) {
				// show popup calendar or time selector
				var ctrl = this.$findElement('control');
				if (ctrl) {
					this.$documentView.showPopup(ctrl,this.key,this.controlType);
				}
				return;
			}

			// get lookup data
			var data = null;
			if (this.codeTable) {
				// use a code table
				var codes = this.$documentView.fetchCodeTable(this.codeTable);
				if (codes) {
					data = {children:codes};
				}
			}
			else {
				// use callback
				data = this.$documentView.fetchLookupData(zenGet(this.key));
			}

			// in-line lookup: get layout from callback and push it
			var layout = null;
			if (this.$documentView.onlookup!='') {
				layout = zenInvokeCallbackMethod(this.$documentView.onlookup,this,'onlookup','key',zenGet(this.key),'value',this.$getControlValue());
				if (!layout) {
					// user has handled event; skip the rest
					return;
				}
			}

			if (!layout || 'object'!=typeof layout) {
				// use built-in list
				layout = { children:[
					{type:'$header', caption:zenGet(this.lookupCaption), subcaption:zenGet(this.lookupSubcaption)},
					{type:'$table',value:'=[children]', key:'$lookupSelect',
						blockClass:'dvLookupTable',
						active:true,
						children:[
						{type:'$para',text:'=[text]'},
					]}
				]};
			}

			// establish *this* as the current control
			// where the lookup result will be applied to
			// !!! change pushDocument to use synthetic layout !!!
			this.$documentView.pushCurrentControl(this);
			this.$documentView.pushDocument(layout,data);
		}

		if (controlType=='$lookup') {
			// do nothing: change is handled by $lookupSelect logic
			instance.$applyChangeToInstance = function() {}
		}
		break; 
	case '$button':
		instance.$renderControl = function() {
			var html = [];
			
			var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var dataicon = (zenGet(this.dataicon,'').length > 0) ? 'data-icon="'+zenGet(this.dataicon)+'"' : '';
			var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
			var dataiconshadow = (zenGet(this.dataiconshadow,false)) ? 'data-iconshadow="'+zenGet(this.dataiconshadow)+'"' : '';
			var inline = zenGet(this.inline) ? 'data-inline="true"' : '';
			var corners = zenGet(this.corners,true) ? 'data-corners="true"' : 'data-corners="false"';
			var shadow = zenGet(this.shadow,true) ? 'data-shadow="true"' : 'data-shadow="false"';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			var cssClass = zenGet(this.cssClass,false) ? 'class="'+zenGet(this.cssClass)+'"' : '';
			
			var caption = zenEscapeXML(zenGet(this.caption));
			if (zenGet(this.content)) {
				caption = this.content;
			}
			html.push('<button type="button" data-role="button" id="'+this.$makeId('control')+'" '+mini+' '+cssClass+' '+hidden+' '+dataTheme+' '+dataicon+' '+dataiconpos+' '+dataiconshadow+' '+inline+' '+corners+' '+shadow+' onclick="$$$event(\'click\');" ');
			if (zenGet(this.disabled)) {
				html.push('disabled ');
			}
			html.push('>');
			html.push(caption);
			html.push('</button>');
			return html.join('');
		};
		break; 

	case '$radio-button':
		instance.$renderControl = function() {
			var html = [];
			var value = zenGet(this.value);
			var optionValue = zenGet(this.optionValue);
			var text = zenGet(this.text);
			var content = zenGet(this.content);
			var dis = zenGet(this.disabled) ? 'disabled="disabled"' : '';
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
			
			if (''===content) {
				content = zenEscapeXML(text.toString());
			}
			// we do not set the initial value of a radio-button; layout has
			// to set the checked flag!
			var checked = zenGet(this.checked) ? 'checked="1"' : '';
			var name = zenGet(this.name);
			if (name) {
				// qualify name
				name = this.$documentView.index+':'+this.$documentView.currLevel+':'+name;
			}
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('<div data-role="fieldcontain" '+hidden+'>');
			}
			
			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('control')+'">');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}
			
			html.push('<input type="radio" id="'+this.$makeId('control')+'" '+mini+' '+hidden+' '+dataTheme+' class="'+zenGet(this.controlClass,'dvCtrlRadio')+'" name="'+name+'" value="'+optionValue+'" style="'+zenGet(this.controlStyle)+'" '+dis+' '+checked+' onclick="$$$event(\'change\');"/>');
			html.push('<label for="'+this.$makeId('control')+'" '+hidden+' class="'+zenGet(this.captionClass,'dvCtrlRadioCaption')+'" style="'+zenGet(this.captionStyle)+'" >' + content + '</label>');
			
			if (zenGet(this.fieldcontain,false)) {
				html.push('</div>');
			}
			
			return html.join('');
		};

		instance.$setValue = function(value,notify) {
			var name = zenGet(this.name);
			if (name) {
				// qualify name
				name = this.$documentView.index+':'+this.$documentView.currLevel+':'+name;
			}
			if (name) {
				var buttons = document.getElementsByName(name);
				for (var n = 0; n < buttons.length; n++) {
					if (buttons[n].value == value) {
						buttons[n].checked = true;
						break;
					}
 				}
 			}
			this.$applyChangeToInstance();
			if (notify) {
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		}
		instance.$getControlValue = function() {
			var value = '';
			var name = zenGet(this.name);
			if (name) {
				// qualify name
				name = this.$documentView.index+':'+this.$documentView.currLevel+':'+name;
			}
			if (name) {
				var buttons = document.getElementsByName(name);
				for (var n = 0; n < buttons.length; n++) {
					if (buttons[n].checked == true) {
						value = buttons[n].value;
						break;
					}
 				}
 			}
 			return value;
		}

		instance.$applyChangeToInstance = function() {
			var value = this.$getControlValue();
			var docView = this.$documentView;

			// apply value to all buttons in the group
			var name = zenGet(this.name);

			if (name && docView._layoutIndex[docView.currLevel]) {
				for (var n in docView._layoutIndex[docView.currLevel]) {
					var item = docView._layoutIndex[docView.currLevel][n];
					if (item && item.controlType=='$radio-button' && item.name==name) {
						item.value = value;
					}
				}
			}
		}

		break;

	case '$choice':
	case '$choice-multi':
		// multiple choice component
		// !!!! fix !!!!
		instance.$renderControl = function() {
			var html = [];
			var disabled = zenGet(this.disabled,false);
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';

			// show small set of choices as buttons
			var valueList = zenGet(this.valueList);
			var displayList = zenGet(this.displayList);
			displayList = displayList=='' ? valueList : displayList;
			var isMulti = (this.controlType=='choice-multi');

			var vlist = valueList ? valueList.toString().split(',') : [];
			var dlist = displayList ? displayList.toString().split(',') : [];
			var count = vlist.length;

			// if there is an imageList, use it
			if (this.imageList) {
				var imageList = this.imageList.toString().split(',');
				var imageStyle = zenGet(this.imageStyle);
				if (imageStyle != '') imageStyle = ' style="' + imageStyle + '"';
				var imageClass = zenGet(this.imageStyle);
				if (imageClass != '') imageClass = ' class="' + imageClass + '"';
				for (var xi = 0; xi < count; xi++) {
					if (imageList[xi]) {
						dlist[xi] = '<img src="'+imageList[xi]+'"'+imageClass+imageStyle+' alt="'+(dlist[xi]?dlist[xi]:zenEscapeXML($$$Text('Choice')))+'"/>';
					}
				}
			}

			// list of styles to apply to choices
			var styleList = zenGet(this.choiceStyles).toString().split('^');
			if (isMulti) {
				var currValues = {};
				var cv = value.toString().split(',');
				for (var n = 0; n < cv.length; n++) {
					currValues[cv[n]] = true;
				}
			}

			var itemHgt = parseInt(zenGet(this.itemHeight,30),10);
			var itemWid = parseInt(zenGet(this.itemWidth,50),10);
			var wrapperClass = zenGet(this.wrapperClass,'dvCtrlChoiceWrapper');
			
			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('control')+'" '+hidden+'>');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}
			
			html.push('<div id='+this.$makeId('control')+' '+hidden+' style="position:relative;height:'+itemHgt+'px;width:'+(itemWid*count)+'px;" class="'+wrapperClass+'">');
			if (count > 0) {
				var x = 0;
				for (var n = 0; n< count; n++) {
					var st = zenGet(this.controlStyle);
					if (n==0) {
						st += 'border-top-left-radius:5px;border-bottom-left-radius:5px;';
					}
					if (n==(count-1)) {
						st += 'border-top-right-radius:5px;border-bottom-right-radius:5px;';
					}
					if (styleList[n]) {
						st += styleList[n];
					}

					var cls = 'dvCtrlChoice';
					var test = zenGet(vlist[n]);
					if (isMulti) {
						if (test&&currValues[test]) {
							cls = 'dvCtrlChoiceSelected';
						}
					}
					else {
						if (test==zenGet(this.value)) {
							cls = 'dvCtrlChoiceSelected';
						}
					}
					cls = disabled ? (cls+'Disabled') : cls;

					html.push('<div value="'+zenEscapeXML(test)+'" id="'+this.$makeId('choice_'+n)+'" class="'+cls+'" style="left:'+x+'px;height:'+itemHgt+'px;width:'+itemWid+'px;border:1px solid #808080;'+st+'"');
					if (!disabled) {
						html.push('onclick="$$$event(\'select\','+n+');" tabindex="0"');
					}
					html.push('>'+zenGet(dlist[n])+'</div>');
					x += itemWid;
				}
			}
			html.push('</div>');
			return html.join('');
		};
	
		// event handler(s)
		instance.$eventHandlers.select = function(evt,v1) {
			// user select of choice choice
			this.$notify = false;
			var multi = this.controlType == '$choice-multi';
			var newValue = '';

			var valueList = [];
			if (this.valueList) {
				valueList = this.valueList.toString().split(',');
			}

			// unselect
			if (!multi) {
				for (var n = 0; n < 99; n++) {
					var div = this.$findElement('choice_'+n);
					if (div) {
						div.className = 'dvCtrlChoice';
					}
					else {
						break;
					}
				}
			}

			// select/toggle new item
			var div = this.$findElement('choice_'+v1);
			if (div) {
				if (multi) {
					div.className = (div.className=='dvCtrlChoiceSelected') ? 'dvCtrlChoice' : 'dvCtrlChoiceSelected';

					// compute newValue
					var vals = [];
					for (var n = 0; n < valueList.length; n++) {
						var div = this.$findElement('choice_'+n);
						if (div) {
							if (div.className=='dvCtrlChoiceSelected') {
								vals[vals.length] = valueList[n];
							}
						}
						else {
							break;
						}
					}
					newValue = vals.join(',');
				}
				else {
					div.className = 'dvCtrlChoiceSelected';
					newValue = valueList[v1];

				}
			}
			// invoke callback
			var key = zenGet(this.$key);
			if (this.value != newValue) {
				this.value = newValue;
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		};
		break;

	case '$radio-set':
		// set of radio buttons component
		instance.$renderControl = function() {
			var html = [];

			// resolve list of options
			// if null, then the list will be processed later by $setOptionList
			var list = this.$documentView.resolveOptionList(instance);
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';

			var label = zenGet(this.label);
			if (label!=='') {
				html.push('<label for="'+this.$makeId('rset')+'" '+hidden+'>');
				html.push(zenEscapeXML(label.toString()));
				html.push('</label>');
			}

			html.push('<div id="'+this.$makeId('rset')+'" '+hidden+'>');
			if (list) {
				html.push(this.$getOptionListHTML(list));
			}
			html.push('</div>');
			html.push('<br/>');		// !!!
			return html.join('');
		};

		// function to apply list of options
		instance.$setOptionList = function(options) {
			this.$findElement('rset').innerHTML = this.$getOptionListHTML(options);
		}

		// internal function to create set of buttons
		instance.$getOptionListHTML = function(options) {
			var html = [];
			if (options && options.length) {
				var disabled = zenGet(this.disabled,false);
				var value = '';
				if ('object' == typeof this.value) {
					if ('undefined' != this.value.value) {
						value = this.value.value;
					}
				}
				else if ('undefined' != this.value) {
					value = this.value;
				}

				// list of styles to apply to choices
				var styleList = zenGet(this.choiceStyles).toString().split('^');

				for (var n = 0; n < options.length; n++) {
					html.push('<ol class="dvCtrlRadioList">');
					for (var n = 0; n < options.length; n++) {
						var option = options[n];
						var st = zenGet(this.controlStyle);
						if (styleList[n]) {
							st += styleList[n];
						}

						var checked = ''
						var cls = 'dvCtrlRadio';
						var test = zenGet(options[n].value);
						if (test==value) {
							checked = 'checked';
						}
						cls = disabled ? (cls+'Disabled') : cls;

						html.push('<li>');
						html.push('<input type="radio" '+checked+' name="'+this.$makeId('name')+'" id="'+this.$makeId('choice_'+n)+'" class="'+cls+'" style="'+st+'"');
						if (!disabled) {
							// note: we can't use $$$event here as it won't be processed
							html.push(' onclick="zenPage.getComponent('+this.$documentView.index+').eventHandler('+this.$index+',event,\'change\','+n+');"');
						}
						html.push('/>');
						// key=key/value;
						// key is not qualified
						var keyAttr = 'undefined' != typeof this.key ? ('key="'+this.key+'/'+test+'"') : '';
						html.push('<label class="dvCtrlRadioCaption" '+keyAttr+' for="'+this.$makeId('choice_'+n)+'">');
						if (options[n].image) {
							html.push('<image src="'+options[n].image+'" style="'+zenGet(this.imageStyle)+'"/>');
						}
						else {
							html.push(zenGet(options[n].text));
						}
						html.push('</label>');
						html.push('</li>');
					}
				}
			}
			return html.join('');
		}

		instance.$setValue = function(value,notify) {
			this.value = value;

			// !!! check for code table !!!
			var valueList = [];
			if (this.valueList) {
				valueList = this.valueList.toString().split(',');
			}

			for (var n = 0; n < 999; n++) {
				var ctrl = this.$findElement('choice_'+n);
				if (!ctrl) {
					break;
				}
				if (valueList[n] === value) {
					ctrl.checked = true;
					break;
				}
			}
			if (notify) {
				this.$documentView.eventHandler(this.$index,event,'change');
			}
		}

		instance.$getControlValue = function() {
			var value = '';
			var valueList = null;
			if (this.codeTable) {
				valueList = this.$documentView.fetchCodeTable(this.codeTable);
			}
			else if (this.valueList) {
				valueList = this.valueList.toString().split(',');
			}
			// find value: assume code list is cached!
			for (var n = 0; n < 9999; n++) {
				var ctrl = this.$findElement('choice_'+n);
				if (!ctrl) {
					break;
				}
				if (ctrl.checked) {
					value = 'undefined' != typeof valueList[n] ? valueList[n] : '';
					break;
				}
			}
			return value;
		}
		break;

	case '$link':
		instance.$renderControl = function() {
			var html = [];
			var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
			var hidden = zenGet(this.hidden,false) ? 'hidden' : '';
			var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
			
			html.push('<a id="'+this.$makeId('control')+'" '+mini+' '+hidden+' '+dataTheme+' class="'+zenGet(this.controlClass,'dvCtrlLink')+'" style="'+zenGet(this.controlStyle)+'" href="#" onclick="$$$event(\'click\');return false;">');
			if (this.image) {
				html.push('<img src="'+this.image+'" class="'+zenGet(this.imageClass)+'" style="'+zenGet(this.imageStyle)+'" alt="'+zenEscapeXML(zenGet(this.caption))+'"/>');
			}
			else {
				html.push(zenEscapeXML(zenGet(this.caption)));
			}
			html.push('</a>');
			return html.join('');
		};
		break;
	}
}

ClientMethod changeTheme(newTheme = "c", headerTheme = "a", barTheme = "a") [ Language = javascript ]
{
	//alert("In refresh");
	var rmbtnClasses = '';
	var rmhfClasses = '';
	var rmbdClassess = '';
	var arr = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"  ];

	$.each(arr,function(index, value){
	    rmbtnClasses = rmbtnClasses + " ui-btn-up-"+value + " ui-btn-hover-"+value;
	    rmhfClasses = rmhfClasses + " ui-bar-"+value;
	    rmbdClassess = rmbdClassess + " ui-body-"+value;
	});

	 // reset all the buttons widgets
	 $.mobile.activePage.find('.ui-btn').not('.ui-li-divider').removeClass(rmbtnClasses).addClass('ui-btn-up-' + newTheme).attr('data-theme', newTheme);

	 // reset all grids
	 $.mobile.activePage.find('.ui-bar').not('.ui-li-divider').removeClass(rmhfClasses).addClass('ui-bar-' + barTheme).attr('data-theme', barTheme);

	 // reset the header/footer widgets
	 $.mobile.activePage.find('.ui-header, .ui-footer').removeClass(rmhfClasses).addClass('ui-bar-' + headerTheme).attr('data-theme', headerTheme);

	 // reset the page widget
	 $.mobile.activePage.removeClass(rmbdClassess).addClass('ui-body-' + newTheme).attr('data-theme', newTheme);

	 // target the list divider elements, then iterate through them and
	 // change its theme (this is the jQuery Mobile default for
	 // list-dividers)
	 $.mobile.activePage.find('.ui-li-divider').each(function(index, obj) {
	 $(this).removeClass(rmhfClasses).addClass('ui-bar-' + newTheme).attr('data-theme',newTheme);

	 })
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
