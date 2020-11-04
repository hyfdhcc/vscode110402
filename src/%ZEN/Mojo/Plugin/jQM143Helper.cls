/// This plugin adds support for the jQueryMobile library. It was developed and tested with
/// jQM version 1.4.3 and jQuery 1.10.2.
/// 
/// 1.0.10
/// 	- NAN003 - jQM: re-factor refreshItem()
/// 
/// 1.0.9
///     - NAN002 - jQM: Optimize $hide and $show
/// 
/// 1.0.8
///     - NAN001 - jQM: Overwrite $getDisplayText()
/// 
/// 1.0.7
///     - JBE067 - jQM: Add support for $ignoreSelect, $ignoreChange, and $ignoreEvent
/// 
/// 1.0.6
///     - JBE057 - jQM: Add support for $refresh
/// 
/// 1.0.5
///     - jQM: Fix $hide, $show, and the hidden attribute (JBE038)
/// 
/// 1.0.4
///     - jQM: Add support for $pagecontent to fix panel issues (JBE035)
/// 
/// 1.0.3
///     - jQM: Fix Hiding and Showing elements (JBE034)
/// 
/// 1.0.2
///     - Merging with jQM132Helper (JBE026)
/// 
/// 1.0.1
///     - Merging with jQM132Helper
/// 
/// 1.0.0
///     - initial check in
/// 
Class %ZEN.Mojo.Plugin.jQM143Helper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "jQM-1.4.3-Helper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.10" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "jQM-1.4.3-Helper";

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
        {identifier:'$pagecontent'},
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
    instance.$hide = this.hideElement;
    instance.$show = this.showElement;
    instance.$getDisplayText = this.getDisplayText;
    
    // Initialize an array of IDs to be hidden in the onloadHandler
    this.$pageManager.hiddenArray = [];
    
    switch(type) {
        // indicate if this is a "loop"
        // fall through:
        case '$collapsible':
        case '$collapsibleset':
        case '$navbar':
        case '$listview':
            instance.$isLoop = true;
            instance.$children = [];
            break;
        
        // decorate control layout objects before rendering
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
        default:
            break;
    }
    
    switch(type) {
        
        // Render and refresh control layout objects
        default:
            instance.$renderControl = this.renderInput;
            instance.$refresh = this.refreshInput;
            break;
        case '$button':
            instance.$renderControl = this.renderButton;
            instance.$refresh = this.refreshButton;
            break;
        case '$checkbox':
            instance.$renderControl = this.renderCheckbox;
            instance.$refresh = this.refreshCheckboxRadio;
            break;
        case '$link':
            instance.$renderControl = this.renderLink;
            instance.$refresh = this.refreshLink;
            break;
        case '$radio-button':
            instance.$renderControl = this.renderRadioButton;
            instance.$refresh = this.refreshCheckboxRadio;
            break;
        case '$select':
            instance.$renderControl = this.renderSelect;
            instance.$refresh = this.refreshSelect;
            break;
        case '$textarea':
            instance.$renderControl = this.renderTextArea;
            instance.$refresh = this.refreshInput;
            break;
        
        // Render all other layout objects
        case '$collapsible':
            instance.$render = this.renderCollapsible;
            instance.$refresh = this.refreshCollapsible;
            break;
        case '$collapsibleset':
            instance.$render = this.renderCollapsibleSet;
            instance.$refresh = this.refreshCollapsibleSet;
            break;
        case '$controlgroup':
            instance.$render = this.renderControlGroup;
            instance.$refresh = this.refreshControlGroup;
            break;
        case '$fieldset':
            instance.$render = this.renderFieldSet;
            instance.$refresh = this.refreshFieldSet;
            break;
        case '$footer':
            instance.$render = this.renderFooter;
            instance.$refresh = this.refreshFooter;
            break;
        case '$grid':
            instance.$render = this.renderGrid;
            instance.$refresh = this.refreshGrid;
            break;
        case '$header':
            instance.$render = this.renderHeader;
            instance.$refresh = this.refreshHeader;
            break;
        case '$listview':
            instance.$render = this.renderListView;
            instance.$refresh = this.refreshListView;
            break;
        case '$listviewitem':
            instance.$render = this.renderListViewItem;
            instance.$refresh = this.refreshListViewItem;
            break;
        case '$navbar':
            instance.$render = this.renderNavBar;
            instance.$refresh = this.refreshNavBar;
            break;
        case '$navbaritem':
            instance.$render = this.renderNavBarItem;
            instance.$refresh = this.refreshNavBarItem;
            break;
        case '$panel':
            instance.$render = this.renderPanel;
            instance.$refresh = this.refresh;
            break;
        case '$pagecontent':
            instance.$render = this.renderContentBlock;
            instance.$refresh = function () {};
            break;
        case '$popup':
            instance.$render = this.renderPopup;
            instance.$refresh = this.refreshPopup;
            break;
        
    }
    
    return instance;
}

/// Render a div with data-role="content" for use with $panel.
ClientMethod renderContentBlock() [ Internal, Language = javascript ]
{
    // note: *this* is a layout object
    var html = [];
    var docView = this.$documentView;
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    var onSelect = zenGet(this.$ignoreSelect,false) ? '': 'onclick="$$$event(\'click\');"';
    
    var cssClass = zenGet(this.cssClass,'');
    
    html.push('<div data-role="content" id="'+this.$makeId()+'" class="'+cssClass+'" style="'+zenGet(this.style,'')+' '+hidden+'" '+onSelect+'>');
    // render children within the content block
    if (this.$children) {
        for (var n = 0; n < this.$children.length; n++) {
            var child = this.$children[n];
            html.push(child.$renderItem());
        }
    }
    html.push('</div>');
    
    content = html.join('');
    content = this.$documentView.injectEventHandler(content,this);
    return content;
}

/// Render an input control. The control type is based on item.controlType property.
ClientMethod renderControl() [ Internal, Language = javascript ]
{
    // note: *this* is a layout object
    var html = [];

    var docView = this.$documentView;

    // render the control
    // the $renderControl function is specific to controlType.
    // this is set by the createLayoutObject method
    this.idAlias = {control:''};
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
    //var dataContentTheme = zenGet(this.dataContentTheme,false) ? 'data-content-theme="'+this.dataContentTheme+'"' : 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"';
    var dataContentTheme = zenGet(this.dataContentTheme,false) ? 'data-content-theme="'+this.dataContentTheme+'"' : '';
    if (!dataContentTheme && this.$parent && this.$parent.$parent) { //Check to see if dataContentTheme is defined on a parent before using the default.
        dataContentTheme = zenGet(this.$parent.$parent.dataContentTheme,false) ? this.$parent.$parent.dataContentTheme : 'data-content-theme="'+this.$documentView.getPluginByLayoutObjectType(this.$type).jQueryCollapsibleTheme+'"';
    }
    var expanded = zenGet(this.expanded,false) ? 'data-collapsed="false"' : 'data-collapsed="true"';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var collapsedicon = (zenGet(this.collapsedicon,'').length > 0) ? 'data-collapsed-icon="'+zenGet(this.collapsedicon)+'"' : '';
    var expandedicon = (zenGet(this.expandedicon,'').length > 0) ? 'data-expanded-icon="'+zenGet(this.expandedicon)+'"' : '';
    var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
    var inset = (zenGet(this.inset,true)) ? 'data-inset="true"' : 'data-inset="false"';
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    
    html.push('<fieldset data-role="collapsible" id="'+this.$makeId()+'" '+dataTheme+' '+dataContentTheme+' '+expanded+' '+mini+' '+inset+' '+dataiconpos+' '+collapsedicon+' '+expandedicon+' class="'+zenGet(this.cssClass,'')+'" style="'+hidden+'">');

    if (this.label) {
        html.push('<legend>');
            html.push(zenEscapeXML(zenGet(this.label.toString())));
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
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    
    html.push('<div data-role="collapsible-set" id="'+this.$makeId()+'" '+dataTheme+' '+dataContentTheme+' '+corners+' '+mini+' '+inset+' '+dataiconpos+' '+collapsedicon+' '+expandedicon+'class="'+zenGet(this.cssClass,'')+'" style="'+hidden+'">');

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
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    
    html.push('<div data-role="controlgroup" id="'+this.$makeId()+'" '+hz+' style="'+hidden+'">');

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
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    
    html.push('<fieldset data-role="controlgroup" '+'id="'+this.$makeId()+'" '+hz+' '+mini+' '+dataiconpos+' style="'+hidden+'">');
    
    if (this.label) {
        html.push('<legend id="'+this.$makeId('legend')+'">');
            html.push(zenEscapeXML(zenGet(this.label.toString())));
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
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    var cssClass = zenGet(this.cssClass,false) ? 'class="'+zenGet(this.cssClass)+'"' : '';
    
    html.push('<div data-role="footer" id="'+this.$makeId()+'" '+dataTheme+' '+fixed+' '+cssClass+' data-id="'+docView.id+'footer" style="'+hidden+'">');

    if (this.content) {
        html.push(this.content);
    }
    else {
        if (this.caption || this.captionContent) {
            var captionClass = zenGet((this.caption ? this.captionClass : this.captionContentClass),'');
            html.push('<h1 id="'+this.$makeId('caption')+'" class="'+captionClass+'" style="'+zenGet(this.captionStyle)+'">');
            if (this.captionContent) {
                html.push(this.captionContent);
            }
            else {
                html.push(zenEscapeXML(zenGet(this.caption.toString())));
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
    var style = zenGet(this.style,'');
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
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

        html.push('<div id="'+this.$makeId()+'" class="'+topClass[columnCount]+' '+barTheme+' '+zenGet(this.cssClass,'')+'" style="'+style+' '+hidden+'">');
        for (var n = 0; n < this.$children.length; n++) {
            var child = this.$children[n];
            html.push('<div class="'+innerClass[n%(columnCount)]+'" id="'+this.$makeId(n.toString())+'">');
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
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    var renderAtBack = zenGet(this.updateLayoutOnBack,false) ? true : false;
    var backhidden = zenGet(this.backhidden,false) ? 'display: none;' : ''; 
    var backdataicon = (zenGet(this.backdataicon,'').length > 0) ? 'data-icon="'+zenGet(this.backdataicon)+'"' : 'data-icon="arrow-l"';
    var backdataiconpos = (zenGet(this.backdataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.backdataiconpos)+'"' : '';
    var backinline = zenGet(this.backinline) ? 'data-inline="true"' : '';
    var backcorners = zenGet(this.backcorners,true) ? 'data-corners="true"' : 'data-corners="false"';
    var backshadow = zenGet(this.backshadow,true) ? 'data-shadow="true"' : 'data-shadow="false"';
    var backtheme = zenGet(this.backtheme,false) ? 'data-theme="'+zenGet(this.backtheme)+'"' : '';
    var backcaption = zenEscapeXML(zenGet(this.backcaption,$$$Text('Back')).toString());
    var suppressBackButton = zenGet(this.suppressBackButton,false);
    
    var headerClass = zenGet(this.headerClass,'');
    html.push('<div data-role="header" id="'+this.$makeId()+'" '+dataTheme+' '+fixed+' data-id="'+docView.id+'Header" class="'+headerClass+'" style="'+zenGet(this.style)+' '+zenGet(this.captionStyle)+' '+hidden+'">');
    // back arrow
    if (docView.currLevel>0 && !suppressBackButton) {
        var handler = this.isMobile ? 'ontouchstart' : 'onclick';
        html.push('<a href="#" id="'+this.$makeId('back')+'" '+backtheme+' '+backdataicon+' '+backdataiconpos+' '+backinline+' '+backcorners+' '+backshadow+' style="'+backhidden+'" '+handler+'="zenPage.getComponent('+docView.index+').popDocument('+renderAtBack+');">'+backcaption+'</a>');
    }
    if (this.content) {
        html.push(this.content);
    }
    else {
        if (this.caption || this.captionContent) {
            var captionClass = zenGet((this.caption ? this.captionClass : this.captionContentClass),'');
            html.push('<h1 id="'+this.$makeId('caption')+'" class="'+captionClass+'" style="'+zenGet(this.captionStyle)+'">');
            if (this.captionContent) {
                html.push(this.captionContent);
            }
            else {
                html.push(zenEscapeXML(zenGet(this.caption.toString())));
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
    var autodividers = (zenGet(this.autodividers,false)) ? 'data-autodividers="true"' : '';
    var style = zenGet(this.style,'');
    
    if (zenGet(this.hidden,false)) {
        docView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }
    
    var listType = zenGet(this.ordered,false) ? 'ol':'ul';
    html.push('<'+listType+' data-role="listview" id="'+this.$makeId()+'" '+inset+' '+filter+' '+filterplaceholder+' '+filterreveal+' '+filtertheme+' '+dividertheme+' '+counttheme+' '+dataTheme+' '+splittheme+' '+spliticon+' '+autodividers+' class="'+zenGet(this.cssClass,'')+'" style="'+style+'">');


    // render children within the listview
    if (this.$children) {
        for (var n = 0; n < this.$children.length; n++) {
            var child = this.$children[n];
            html.push(child.$renderItem());
        }
    }
    
    html.push('</'+listType+'>');

    return html.join('');
}

/// Render a listviewitem
ClientMethod renderListViewItem() [ Internal, Language = javascript ]
{
    // note: *this* is a layout object
    var html = [];
    var docView = this.$documentView;
    
    var id = zenGet(this.id,false) ? this.id : this.$makeId();
    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var divider = zenGet(this.divider) ? 'data-role="list-divider"' : '';
    var count = zenGet(this.count) ? '<span class="ui-li-count">'+this.count+'</span>' : '';
    var dataicon = zenGet(this.dataicon,false) ? 'data-icon="'+zenGet(this.dataicon)+'"' : '';
    var thumbnail = zenGet(this.thumbnail,false) ? '<img src="'+this.thumbnail+'">' : '';
    var icon = zenGet(this.icon,false) ? '<img src="'+this.icon+'" class="ui-li-icon">' : '';
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    var onSelect = zenGet(this.$ignoreSelect,false) ? '': 'onclick="$$$event(\'click\');"';
    
    if (zenGet(this.hidden,false)) {
        docView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }
    
    html.push('<li id="'+id+'" '+divider+' '+dataicon+' '+dataTheme+' style="'+hidden+'">');

    if (zenGet(this.clickable,false)) {
        html.push('<a href="#" id="'+this.$makeId('listviewitem')+'" '+onSelect+'>');
    }

    if (zenGet(this.thumbnail,false)) {
        html.push(thumbnail);
    }
    
    if (zenGet(this.icon,false)) {
        html.push(icon);
    }

    if (this.label) {
        if (zenGet(this.labelNoWrapper,true)) {
            html.push(zenEscapeXML(zenGet(this.label).toString()));
        } else {
            html.push('<h2>'+zenEscapeXML(zenGet(this.label).toString())+'</h2>');
        }
    }
    
    if (this.content) {
        html.push('<p style:"white-space:normal;" class:"'+zenGet(this.contentClass,'li-content-class')+'">'+zenEscapeXML(zenGet(this.content).toString())+'</p>');
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
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    
    html.push('<div data-role="navbar" id="'+this.$makeId()+'" '+dataiconpos+' style="'+hidden+'">');
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
    this.idAlias = {};
    
    var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
    var icon = (zenGet(this.icon,'').length > 0) ? 'data-icon="'+zenGet(this.icon)+'"' : '';
    var active = (zenGet(this.active,false)) ? 'ui-btn-active' : '';
    var persist = (zenGet(this.persist,false)) ? 'ui-state-persist' : '';
    var caption = zenEscapeXML(zenGet(this.caption,'').toString());
    var dataTheme = zenGet(this.dataTheme) ? 'data-theme="'+this.dataTheme+'"' : '';
    var onSelect = zenGet(this.$ignoreSelect,false) ? '': 'onclick="$$$event(\'click\');"';
    
    if (zenGet(this.hidden,false)) {
        docView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }
    
    //onclick="$$$event(\'click\');"
    this.idAlias['navbaritem']='';
    html.push('<li><a href="#" id="'+this.$makeId()+'" class="'+active+' '+persist+'" '+icon+' '+dataiconpos+' '+dataTheme+' '+onSelect+'>'+caption+'</a></li>');
    
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
    var id = zenGet(this.id,false) ? docView.currLevel+'-'+this.id : this.$makeId();
    
    html.push('<div data-role="panel" id="'+id+'" '+animate+' '+fixed+' '+position+' '+displayMode+' '+dataTheme+' '+dismissible+'>');

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
    var targetPanel = $('#'+this.$documentView.currLevel+'-'+id);
    if (targetPanel.length<1) {
        // Assume the id parameter is actually a key
        var targetPanel = $('#'+this.$documentView.getItemByKey(id).$makeId());
    }
    targetPanel.panel('open');
}

/// Closes a panel with the supplied id
ClientMethod closePanel(id) [ Language = javascript ]
{
    var targetPanel = $('#'+this.$documentView.currLevel+'-'+id);
    if (targetPanel.length<1) {
        // Assume the id parameter is actually a key
        var targetPanel = $('#'+this.$documentView.getItemByKey(id).$makeId());
    }
    targetPanel.panel('close');
}

/// Toggles a panel with the supplied id
ClientMethod togglePanel(id) [ Language = javascript ]
{
    var targetPanel = $('#'+this.$documentView.currLevel+'-'+id);
    if (!targetPanel || !targetPanel[0]) {
        // Assume the id parameter is actually a key
        var targetPanel = $('#'+this.$documentView.getItemByKey(id).$makeId());
    }
    targetPanel.panel('toggle');
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
    
    html.push('<div data-role="popup" data-transition="'+zenGet(this.transition,'flow')+'" id="'+this.$makeId()+'" class="'+cssClass+'" '+dataTheme+' '+dataOverlayTheme+' '+corners+' '+dismissible+' '+shadow+'>');

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
    $('#'+this.$documentView.getItemByKey(key).$makeId()).popup('open',options);
}

ClientMethod closePopup(key) [ Language = javascript ]
{
    $('#'+this.$documentView.getItemByKey(key).$makeId()).popup('close');
}

/// Define functions for Control elements.
ClientMethod decorateControl(instance) [ Internal, Language = javascript ]
{
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
            instance.inputType = 'password'
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
        
        // Additional functions for dual/range sliders
        if (instance.value2&&instance.inputType=='range') {
            instance.$setValue2 = function(value,notify) {
                this.value = value;
                var ctrl = this.$findElement('control2');
                ctrl.value = value;
                if (type == 'range') $('#'+ctrl.id).slider('refresh');
                if (notify) {
                    this.$documentView.eventHandler(this.$index,event,'change');
                }
            }
            
            instance.$getValue2 = function() {
                var ctrl = this.$findElement('control2');
                return ctrl.value;
            }
            instance.$getControlValue2 = function() {
                var ctrl = this.$findElement('control2');
                return ctrl.value;
            }
        }
        
        break; 

    case 'checkbox':
    case '$checkbox':
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

    case '$radio-button':
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
    
    case '$link':
    case '$button':
        break;
    }
}

/// Update a button layout object in place
ClientMethod refreshButton() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.corners) !== '') {options['corners'] = this.corners?true:false;}
    if (zenGet(this.dataicon) !== '') {options['icon'] = this.dataicon;}
    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    if (zenGet(this.dataiconshadow) !== '') {options['iconshadow'] = this.dataiconshadow?true:false;}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.disabled) !== '') {options['disabled'] = this.disabled?true:false;}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    if (zenGet(this.shadow) !== '') {options['shadow'] = this.shadow?true:false;}
    if (zenGet(this.style) !== '') {this.$findElement().setAttribute('style',zenGet(this.style));}
    
    if (zenGet(this.caption) !== '') {
        this.$setValue(zenGet(this.caption));
    }
    else if (zenGet(this.content) !== '') {
        this.$setValue(zenGet(this.content));
    }
    if (zenGet(this.inline) !== '') {
        options['inline'] = this.inline?true:false;
        this.inline?jqmItem.parent().css('display','inline-block'):jqmItem.parent().css('display','block');
    }
    jqmItem.button('option',options).button('refresh');
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a checkbox or radio-button layout object in place
ClientMethod refreshCheckboxRadio() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.disabled) !== '') {options['disabled'] = this.disabled?true:false;}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    if (zenGet(this.controlStyle) !== '') {this.$findElement().setAttribute('style',zenGet(this.controlStyle));}
    if (zenGet(this.label) !== '' && $('label[for = '+this.$makeId()+']').length > 0) {$('label[for = '+this.$makeId()+']').text(this.label);}
    
    if (zenGet(this.value) !== '' || zenGet(this.checked) !== '') {
         jqmItem.prop('checked',zenGet(this.value,this.checked)?true:false);
    }
    jqmItem.checkboxradio('option',options).checkboxradio('refresh');
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a collapsible layout object in place
ClientMethod refreshCollapsible() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.collapsedicon) !== '') {options['collapsedIcon'] = this.collapsedicon;}
    if (zenGet(this.dataContentTheme) !== '') {options['contentTheme'] = this.dataContentTheme;}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    if (zenGet(this.expanded) !== '') {options['collapsed'] = this.expanded?false:true;}
    if (zenGet(this.expandedicon) !== '') {options['expandedIcon'] = this.expandedicon;}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    
    if (zenGet(this.label) !== '') {
        jqmItem.collapsible('destroy');
        if (jqmItem.children('legend').length > 0) {jqmItem.children('legend').text(this.label);}
        jqmItem.collapsible();
    }
    jqmItem.collapsible('option',options);
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a collapsible set layout object in place
ClientMethod refreshCollapsibleSet() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.collapsedicon) !== '') {options['collapsedIcon'] = this.collapsedicon;}
    if (zenGet(this.corners) !== '') {options['corners'] = this.corners?true:false;}
    if (zenGet(this.dataContentTheme) !== '') {options['contentTheme'] = this.dataContentTheme;}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    if (zenGet(this.expandedicon) !== '') {options['expandedIcon'] = this.expandedicon;}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    
    if (zenGet(this.label) !== '') {
        jqmItem.collapsible('destroy');
        if (jqmItem.children('legend').length > 0) {jqmItem.children('legend').text(this.label);}
        jqmItem.collapsible();
    }
    jqmItem.collapsible('option',options);
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a control group layout object in place
ClientMethod refreshControlGroup() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.horizontal) !== '') {options['type'] = this.horizontal?'horizontal':'vertical';}
    
    jqmItem.controlgroup('option',options);
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a field set layout object in place
ClientMethod refreshFieldSet() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    if (zenGet(this.horizontal) !== '') {options['type'] = this.horizontal?'horizontal':'vertical';}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    
    if (zenGet(this.label) !== '') {
        jqmItem.controlgroup('destroy');
        if (jqmItem.children('legend').length > 0) {jqmItem.children('legend').text(this.label);}
        jqmItem.controlgroup();
    }
    jqmItem.controlgroup('option',options);
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a footer layout object in place
ClientMethod refreshFooter() [ Internal, Language = javascript ]
{
    var jqmItem = $('#'+this.$makeId());
    
    var caption = zenGet(this.captionContent,this.caption);
    if (caption !== '' && jqmItem.children('h1').length > 0) {
        jqmItem.children('h1').text(caption);
    }
    jqmItem.toolbar('refresh');
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a grid layout object in place
ClientMethod refreshGrid() [ Internal, Language = javascript ]
{
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.style) !== '') {this.$findElement().setAttribute('style',zenGet(this.style));}
    
    var parent = jqmItem.parent();
    jqmItem.replaceWith(this.$render());
    parent.enhanceWithin();
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a header layout object in place
ClientMethod refreshHeader() [ Internal, Language = javascript ]
{
    var jqmItem = $('#'+this.$makeId());
    
    if (zenGet(this.style) !== '') {this.$findElement().setAttribute('style',zenGet(this.style));}
    
    var caption = zenGet(this.captionContent,this.caption);
    if (caption !== '' && jqmItem.children('h1').length > 0) {
        jqmItem.children('h1').text(caption);
    }
    jqmItem.toolbar('refresh');
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a link layout object in place
ClientMethod refreshLink() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    if (zenGet(this.controlStyle) !== '') {this.$findElement().setAttribute('style',zenGet(this.controlStyle));}
    
    var parent = jqmItem.parent();
    jqmItem.replaceWith(this.$render());
    parent.enhanceWithin();
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a list view layout object in place
ClientMethod refreshListView() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.style) !== '') {this.$findElement().setAttribute('style',zenGet(this.style));}
    
    if (jqmItem.prev().hasClass('ui-filterable')) {
        jqmItem.prev().remove();
    }
    jqmItem.replaceWith(this.$render());
    $('#'+this.$makeId()).listview();
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a list view item layout object in place
ClientMethod refreshListViewItem() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dataicon) !== '') {options['icon'] = this.dataicon;}
    if (zenGet(this.label) !== '' && $('label[for = '+this.$makeId()+']').length > 0) {$('label[for = '+this.$makeId()+']').text(this.label);}
    if (zenGet(this.style) !== '') {this.$findElement().setAttribute('style',zenGet(this.style));}
    
    var parent = jqmItem.parent();
    jqmItem.replaceWith(this.$render());
    parent.listview('refresh');
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a navbar layout object in place
ClientMethod refreshNavBar() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());

    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    
    var parent = jqmItem.parent();
    jqmItem.replaceWith(this.$render());
    parent.enhanceWithin();
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a navbaritem layout object in place
ClientMethod refreshNavBarItem() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());

    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dataiconpos) !== '') {options['iconpos'] = this.dataiconpos;}
    
    var jqmNavbar = jqmItem.closest('div[data-role="navbar"]');
    var navbarParent = jqmNavbar.parent();
    if (this.$parent && this.$parent.$parent) {
        var zmNavbar = this.$parent.$parent;
        jqmNavbar.replaceWith(zmNavbar.$render());
        navbarParent.enhanceWithin();
    }
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a panel layout object in place
ClientMethod refreshPanel() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());

    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dismissible) !== '') {options['dismissible'] = this.dismissible;}
    
    if (zenGet(this.animate) !== '') {options['animate'] = this.animate;}
    if (zenGet(this.displayMode) !== '') {options['display'] = this.displayMode;}   
    jqmItem.panel('option',options);
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update an input layout object in place
ClientMethod refreshInput() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());

    if (zenGet(this.clearButton) !== '') {options['clearBtn'] = this.clearButton?true:false;}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dataTrackTheme) !== '') {options['trackTheme'] = this.dataTrackTheme;}
        
    if (zenGet(this.controlStyle) !== '') {this.$findElement().setAttribute('style',zenGet(this.controlStyle));}
    if (zenGet(this.disabled) !== '') {options['disabled'] = this.disabled?true:false;}
    if (zenGet(this.highlight) !== '') {options['highlight'] = this.highlight?true:false;}
    if (zenGet(this.label) !== '' && $('label[for = '+this.$makeId()+']').length > 0) {$('label[for = '+this.$makeId()+']').text(this.label);}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    
    if(this.inputType == 'range') {jqmItem.slider('option',options);}
    else{
	    var htmlItem = this.$findElement();
		if (zenGet(this.autocapitalize) !== '') {
			this.autocapitalize?htmlItem.removeAttribute('autocapitalize'):htmlItem.setAttribute('autocapitalize','off');
		}
		if (zenGet(this.autocorrect) !== '') {
			this.autocorrect?htmlItem.removeAttribute('autocorrect'):htmlItem.setAttribute('autocorrect','off');
		}
		if (zenGet(this.pattern) !== '') {
			this.pattern?htmlItem.setAttribute('pattern',this.pattern):htmlItem.removeAttribute('pattern');
		}
		if (zenGet(this.readOnly) !== '') {
			this.readOnly?htmlItem.setAttribute('readOnly','yes'):htmlItem.removeAttribute('readOnly');
		}
		if (zenGet(this.required) !== '') {
			this.required?htmlItem.setAttribute('required','yes'):htmlItem.removeAttribute('required');
		}
		if (zenGet(this.spellcheck) !== '') {
			this.spellcheck?htmlItem.removeAttribute('spellcheck'):htmlItem.setAttribute('spellcheck','false');
		}
        jqmItem.textinput('option',options);
    }
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a popup layout object in place
ClientMethod refreshPopup() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());

    if (zenGet(this.corners) !== '') {options['corners'] = this.corners?true:false;}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dismissible) !== '') {options['dismissible'] = this.dismissible;}
    if (zenGet(this.shadow) !== '') {options['shadow'] = this.shadow?true:false;}
    
    if (zenGet(this.transition) !== '') {options['transition'] = this.transition;}
    jqmItem.popup('option',options);
    
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Update a select layout object in place
ClientMethod refreshSelect() [ Internal, Language = javascript ]
{
    var options = {};
    var jqmItem = $('#'+this.$makeId());

    if (zenGet(this.controlStyle) !== '') {this.$findElement().setAttribute('style',zenGet(this.controlStyle));}
    if (zenGet(this.dataTheme) !== '') {options['theme'] = this.dataTheme;}
    if (zenGet(this.dataTrackTheme) !== '') {options['trackTheme'] = this.dataTrackTheme;}
    if (zenGet(this.dataicon) !== '') {options['icon'] = this.dataicon;}
    if (zenGet(this.disabled) !== '') {options['disabled'] = this.disabled?true:false;}
    if (zenGet(this.label) !== '' && $('label[for = '+this.$makeId()+']').length > 0) {$('label[for = '+this.$makeId()+']').text(this.label);}
    if (zenGet(this.mini) !== '') {options['mini'] = this.mini?true:false;}
    
    if(this.slider) {jqmItem.slider('option',options);}
    else{
    	jqmItem.html(this.$buildOptions());
    	jqmItem.selectmenu('option',options).selectmenu('refresh', true);
    }
    if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Render a button
ClientMethod renderButton() [ Internal, Language = javascript ]
{
    var html = [];

    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var dataicon = (zenGet(this.dataicon,'').length > 0) ? 'data-icon="'+zenGet(this.dataicon)+'"' : '';
    var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
    var dataiconshadow = (zenGet(this.dataiconshadow,false)) ? 'data-iconshadow="'+zenGet(this.dataiconshadow)+'"' : '';
    var inline = zenGet(this.inline) ? 'data-inline="true"' : '';
    var corners = zenGet(this.corners,true) ? 'data-corners="true"' : 'data-corners="false"';
    var shadow = zenGet(this.shadow,true) ? 'data-shadow="true"' : 'data-shadow="false"';
    var cssClass = zenGet(this.cssClass,false) ? 'class="'+zenGet(this.cssClass)+'"' : '';
    var onSelect = zenGet(this.$ignoreSelect,false) ? '': 'onclick="$$$event(\'click\');"';
    
    if (zenGet(this.hidden,false)) {
        this.$documentView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }

    var caption = zenEscapeXML(zenGet(this.caption).toString());
    if (zenGet(this.content)) {
        caption = this.content;
    }
    html.push('<input type="button" value="'+caption+'" id="'+this.$makeId()+'" '+mini+' '+cssClass+' '+dataTheme+' '+dataicon+' '+dataiconpos+' '+dataiconshadow+' '+inline+' '+corners+' '+shadow+' '+onSelect);
    if (zenGet(this.disabled)) {
        html.push('disabled ');
    }
    html.push('>');
    
    return html.join('');
}

/// Render a checkbox
ClientMethod renderCheckbox() [ Internal, Language = javascript ]
{
    var html = [];
    // !!!
    var value = zenGet(this.value);
    var text = zenGet(this.text);
    var content = zenGet(this.content);
    var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
    var onChange = zenGet(this.$ignoreChange,false) ? '': 'onchange="$$$event(\'change\');"';
    
    if (zenGet(this.hidden,false)) {
        this.$documentView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }

    if (zenGet(this.fieldcontain,false)) {
        html.push('<div data-role="fieldcontain">');
        html.push('<fieldset data-role="controlgroup">');
        var label = zenGet(this.label);
        if (label!=='') {
            html.push('<legend for="'+this.$makeId()+'">');
            html.push(zenEscapeXML(label.toString()));
            html.push('</legend>');
        }
    }

    var label = zenGet(this.label);
    if (label!=='') {
        html.push('<label for="'+this.$makeId()+'">');
        html.push(zenEscapeXML(label.toString()));
        html.push('</label>');
    }

    var checked = value ? 'checked="1"' : '';
    html.push('<input type="checkbox" id="'+this.$makeId()+'" '+mini+' '+dataiconpos+' '+dataTheme+' class="'+zenGet(this.controlClass,'dvCtrlCheckbox')+'" style="'+zenGet(this.controlStyle)+'" '+dis+' '+checked+' '+onChange+' />');

    if (zenGet(this.fieldcontain,false)) {
        html.push('</fieldset>');
        html.push('</div>');
    }

            return html.join('');
}

/// Render an input element
ClientMethod renderInput() [ Internal, Language = javascript ]
{
    var html = [];
    var reqd = zenGet(this.required) ? 'required="yes"' : '';
    var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
    var ro = zenGet(this.readOnly) ? 'readOnly="yes"' : '';
    var text = this.$getDisplayText();
    var list = (this.codeTable||this.valueList) ? 'list="'+this.$makeId('datalist')+'"' : '';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var highlight = zenGet(this.highlight,false) ? 'data-highlight="true"' : 'data-highlight="false"';
    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var dataTrackTheme = zenGet(this.dataTrackTheme,false) ? 'data-track-theme="'+this.dataTrackTheme+'"' : '';
    var autocapitalize = zenGet(this.autocapitalize,true) ? '' : 'autocapitalize="off"';
    var autocorrect = zenGet(this.autocorrect,true) ? '' : 'autocorrect="off"';
    var spellcheck = zenGet(this.spellcheck,true) ? '' : 'spellcheck="false"';
    var clearButton = zenGet(this.clearButton,false) ? 'data-clear-btn="true"' : '';
    var pattern = zenGet(this.pattern,false) ? 'pattern="'+zenGet(this.pattern)+'"' : '';
    var value2 = zenGet(this.value2,false);
    var type = zenGet(this.inputType,'text');
    var onChange = zenGet(this.$ignoreChange,false) ? '': 'onchange="$$$event(\'change\');"';
    var onEvent = zenGet(this.$ignoreEvent,false) ? '': 'onkeyup="$$$event(\'keyup\');"';
    
    if (zenGet(this.hidden,false)) {
        this.$documentView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }
        
    if (zenGet(this.fieldcontain,false)) {
        html.push('<div data-role="fieldcontain">');
    }
    
    var dualRange = value2&&type=='range';
    if (dualRange) {
        highlight = zenGet(this.highlight,true) ? 'data-highlight="true"' : 'data-highlight="false"';
        html.push('<div data-role="rangeslider" '+highlight+' '+dataTheme+' '+dataTrackTheme+' '+mini+'>');
    }
    
    var label = zenGet(this.label);
    if (label!=='') {
        html.push('<label for="'+this.$makeId()+'">');
        html.push(zenEscapeXML(label.toString()));
        html.push('</label>');
    }
    
    html.push('<input type="'+type+'" id="'+this.$makeId()+'" '+mini+' '+dataTheme+' '+dataTrackTheme+' '+highlight+' '+autocapitalize + ' ' + autocorrect + ' ' + spellcheck + ' ' + clearButton + ' ' + pattern + ' class="'+zenGet(this.controlClass,'dvCtrlText')+'" placeholder="'+zenEscapeXML(zenGet(this.placeHolder).toString())+'" '+reqd+' '+dis+' '+ro+' '+list+' size="'+zenGet(this.size)+'" value="'+zenEscapeXML(text.toString())+'" style="'+zenGet(this.controlStyle)+'" min='+zenGet(this.min)+' max='+zenGet(this.max)+' step='+zenGet(this.step,1)+' '+onChange+' '+onEvent+'/>');
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
    
    if (dualRange) {
        this.idAlias['control2']='2';
        html.push('<input type="'+type+'" id="'+this.$makeId('2')+'" '+mini+' '+dataTheme+' '+dataTrackTheme+' '+highlight+' '+autocapitalize + ' ' + autocorrect + ' ' + spellcheck + ' ' + clearButton + ' ' + pattern + ' class="'+zenGet(this.controlClass,'dvCtrlText')+'" placeholder="'+zenEscapeXML(zenGet(this.placeHolder).toString())+'" '+reqd+' '+dis+' '+ro+' '+list+' size="'+zenGet(this.size)+'" value="'+zenEscapeXML(value2.toString())+'" style="'+zenGet(this.controlStyle)+'" min='+zenGet(this.min)+' max='+zenGet(this.max)+' step='+zenGet(this.step,1)+' '+onChange+' '+onEvent+'/>');
        html.push('</div>');
    }
    
    if (zenGet(this.fieldcontain,false)) {
        html.push('</div>');
    }
    
    return html.join('');
}

/// Render a link
ClientMethod renderLink() [ Internal, Language = javascript ]
{
    var html = [];
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var onSelect = zenGet(this.$ignoreSelect,false) ? '': 'onclick="$$$event(\'click\');return false;"';
    
    html.push('<a id="'+this.$makeId()+'" '+mini+' '+dataTheme+' class="'+zenGet(this.controlClass,'dvCtrlLink')+'" style="'+zenGet(this.controlStyle)+' '+hidden+'" href="#" '+onSelect+'>');
    if (this.image) {
        html.push('<img src="'+this.image+'" class="'+zenGet(this.imageClass)+'" style="'+zenGet(this.imageStyle)+'" alt="'+zenEscapeXML(zenGet(this.caption).toString())+'"/>');
    }
    else {
        html.push(zenEscapeXML(zenGet(this.caption).toString()));
    }
    html.push('</a>');
    
    return html.join('');
}

/// Render a radio button
ClientMethod renderRadioButton() [ Internal, Language = javascript ]
{
    var html = [];
    var value = zenGet(this.value);
    var optionValue = zenGet(this.optionValue);
    var text = zenGet(this.text);
    var content = zenGet(this.content);
    var dis = zenGet(this.disabled) ? 'disabled="disabled"' : '';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var onChange = zenGet(this.$ignoreChange,false) ? '': 'onchange="$$$event(\'change\');"';
    
    if (zenGet(this.hidden,false)) {
        this.$documentView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }
    
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
        html.push('<div data-role="fieldcontain">');
    }
    
    var label = zenGet(this.label);
    if (label!=='') {
        html.push('<label for="'+this.$makeId()+'">');
        html.push(zenEscapeXML(label.toString()));
        html.push('</label>');
    }
    
    html.push('<input type="radio" id="'+this.$makeId()+'" '+mini+' '+dataTheme+' class="'+zenGet(this.controlClass,'dvCtrlRadio')+'" name="'+name+'" value="'+optionValue+'" style="'+zenGet(this.controlStyle)+'" '+dis+' '+checked+' '+onChange+'/>');
    html.push('<label for="'+this.$makeId()+'" class="'+zenGet(this.captionClass,'dvCtrlRadioCaption')+'" style="'+zenGet(this.captionStyle)+'" >' + content + '</label>');
    
    if (zenGet(this.fieldcontain,false)) {
        html.push('</div>');
    }
    
    return html.join('');
}

/// Render a select
ClientMethod renderSelect() [ Internal, Language = javascript ]
{
    var html = [];
    this.$buildOptions = this.$documentView.getPluginByLayoutObjectType('$select').buildOptions;

    // resolve list of options
    /*var list = this.$documentView.resolveOptionList(this);
    var value = '';
    if ('object' == typeof this.value) {
        if ('undefined' != this.value.value) {
            value = this.value.value;
        }
    }
    else if ('undefined' != typeof this.value) {
        value = this.value;
    }*/
    var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
    var slider = zenGet(this.slider) ? 'data-role="slider"' : '';
    var dataicon = (zenGet(this.dataicon,'').length > 0) ? 'data-icon="'+zenGet(this.dataicon)+'"' : '';
    var dataiconpos = (zenGet(this.dataiconpos,'').length > 0) ? 'data-iconpos="'+zenGet(this.dataiconpos)+'"' : '';
    var dataTheme = zenGet(this.dataTheme,false) ? 'data-theme="'+this.dataTheme+'"' : '';
    var dataTrackTheme = zenGet(this.dataTrackTheme,false) ? 'data-track-theme="'+this.dataTrackTheme+'"' : '';
    var inline = zenGet(this.inline) ? 'data-inline="true"' : '';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var nativeMenu = zenGet(this.nativeMenu,true) ? '' : 'data-native-menu="false"';
    var multiple = zenGet(this.multiple,false) ? 'multiple="multiple"' : '';
    var onChange = zenGet(this.$ignoreChange,false) ? '': 'onchange="$$$event(\'change\');"';
    
    if (zenGet(this.hidden,false)) {
        this.$documentView.getPluginByLayoutObjectType(this.$type).$pageManager.hiddenArray.push(this);
    }

    if (zenGet(this.fieldcontain,false)) {
        html.push('<div data-role="fieldcontain">');
    }

    var label = zenGet(this.label);
    if (label!=='') {
        html.push('<label for="'+this.$makeId()+'">');
        html.push(zenEscapeXML(label.toString()));
        html.push('</label>');
    }

    html.push('<select id="'+this.$makeId()+'" '+slider+' '+mini+' '+dataicon+' '+dataiconpos+' '+dataTheme+' '+dataTrackTheme+' '+inline+' '+nativeMenu+' '+multiple+' class="'+zenGet(this.controlClass,'dvCtrlText')+'" '+dis+' size="'+zenGet(this.size)+/*'" value="'+zenEscapeXML(value.toString())+*/'" style="'+zenGet(this.controlStyle)+'" '+onChange+'>');
    html.push(this.$buildOptions());
    /*if (list && list.length) {
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
            if (typeof optgroup.valueList == 'object' && !optgroup.valueList.length) {  //Handle cases where valueList is an object, not an array or string
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
    }*/

    html.push('</select>');

    if (zenGet(this.fieldcontain,false)) {
        html.push('</div>');
    }

    return html.join('');
}

/// Build the option list for a select widget
ClientMethod buildOptions() [ Internal, Language = javascript ]
{
    var html = [];
    var list = this.$documentView.resolveOptionList(this);
    var value = '';
    if ('object' == typeof this.value) {
        if ('undefined' != this.value.value) {
            value = this.value.value;
        }
    }
    else if ('undefined' != typeof this.value) {
        value = this.value;
    }

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
            if (typeof optgroup.valueList == 'object' && !optgroup.valueList.length) {  //Handle cases where valueList is an object, not an array or string
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
    
    return html.join('');
}

/// Render a textarea
ClientMethod renderTextArea() [ Internal, Language = javascript ]
{
    var html = [];
    var reqd = zenGet(this.required) ? 'required="yes"' : '';
    var dis = zenGet(this.disabled) ? 'disabled="yes"' : '';
    var mini = zenGet(this.mini) ? 'data-mini="true"' : '';
    var hidden = zenGet(this.hidden,false) ? 'display: none;' : '';
    var autocapitalize = zenGet(this.autocapitalize,true) ? '' : 'autocapitalize="off"';
    var autocorrect = zenGet(this.autocorrect,true) ? '' : 'autocorrect="off"';
    var spellcheck = zenGet(this.spellcheck,true) ? '' : 'spellcheck="false"';
    var onChange = zenGet(this.$ignoreChange,false) ? '': 'onchange="$$$event(\'change\');"';

    if (zenGet(this.fieldcontain,false)) {
        html.push('<div class="ui-field-contain" style="'+hidden+'">');
        hidden = '';
    }

    var label = zenGet(this.label);
    if (label!=='') {
        html.push('<label for="'+this.$makeId()+'" style="'+hidden+'">');
        html.push(zenEscapeXML(label.toString()));
        html.push('</label>');
    }

    html.push('<textarea id="'+this.$makeId()+'" '+mini+' '+autocapitalize + ' ' + autocorrect + ' ' + spellcheck + ' class="'+zenGet(this.controlClass,'dvCtrlText')+'" '+dis+' '+reqd+' style="'+zenGet(this.controlStyle)+' '+hidden+'" placeHolder="'+zenEscapeXML(zenGet(this.placeHolder).toString())+'" type="text" rows="'+zenGet(this.rows)+'" cols="'+zenGet(this.cols)+'" '+onChange+'>'+zenEscapeXML(zenGet(this.value).toString())+'</textarea>');

    if (zenGet(this.fieldcontain,false)) {
        html.push('</div>');
    }

    return html.join('');
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

/// This method is used to hide jQM elements
/// duration is a string or number specifying the duration of the animation.
/// callback is a function to be executed when the animation completes.
ClientMethod hideElement(duration, callback) [ Internal, Language = javascript ]
{
    if (this.fieldcontain && $('#'+this.$makeId()).closest('div[data-role="fieldcontain"]').length > 0) {
        $('#'+this.$makeId()).closest('div[data-role="fieldcontain"]').hide(duration, callback);    
    } 
    else {
        switch(this.$type){
            case '$button':
            case '$checkbox':
            case '$input':
            case '$password':
            case '$string':
            case '$text':
            case '$select':
            case '$radiobutton':
                $('#'+this.$makeId()).closest('div').hide(duration, callback);
                break;
            case '$navbaritem':
                $('#'+this.$makeId()).closest('li').hide(duration, callback);
                break;
            case '$popup':
                $('#'+this.$makeId()).popup('close');
                break;
            case '$panel':
                if(this.id)
                    $('#'+this.$documentView.currLevel+'-'+this.id).panel('close');
                else
                    $('#'+this.$documentView.getItemByKey(this.key).$makeId()).panel('close');
                break;
            default:
                $('#'+this.$makeId()).hide(duration, callback);
        }
    }
    
    // Hide labels for specific layout objects
    if (this.label && !this.fieldcontain && $('label[for="'+this.$makeId()+'"]').length>0) {
        $('label[for="'+this.$makeId()+'"]').hide(duration, callback);
    }
    
    // Hide filter for $listview
    if (this.$type == '$listview' && this.filter && $('#'+this.$makeId()).prev()[0].className == 'ui-filterable') {
        $('#'+this.$makeId()).prev().hide(duration, callback);
    }
}

/// This method is used to show jQM elements
/// duration is a string or number specifying the duration of the animation.
/// callback is a function to be executed when the animation completes.
ClientMethod showElement(duration, callback) [ Internal, Language = javascript ]
{
    
    if (this.fieldcontain && $('#'+this.$makeId()).closest('div[data-role="fieldcontain"]').length > 0) {
        $('#'+this.$makeId()).closest('div[data-role="fieldcontain"]').show(duration, callback);    
    } 
    else {
        switch(this.$type){
            case '$button':
            case '$checkbox':
            case '$input':
            case '$password':
            case '$string':
            case '$text':
            case '$select':
            case '$radiobutton':
                $('#'+this.$makeId()).closest('div').show(duration, callback);
                break;
            case '$navbaritem':
                $('#'+this.$makeId()).closest('li').show(duration, callback);
                break;
            case '$popup':
                $('#'+this.$makeId()).popup('open',{});
                break;
            case '$panel':
                if(this.id)
                    $('#'+this.$documentView.currLevel+'-'+this.id).panel('open');
                else
                    $('#'+this.$documentView.getItemByKey(this.key).$makeId()).panel('open');
                break;
            default:
                $('#'+this.$makeId()).show(duration, callback);
        }
    }
    
    // Show labels for specific layout objects
    if (this.label && !this.fieldcontain && $('label[for="'+this.$makeId()+'"]').length>0) {
        $('label[for="'+this.$makeId()+'"]').show(duration, callback);
    }
    
    // Show filter for $listview
    if (this.$type == '$listview' && this.filter && $('#'+this.$makeId()).prev()[0].className == 'ui-filterable') {
        $('#'+this.$makeId()).prev().show(duration, callback);
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

/// find display value (resolve text, value, and coded values)
ClientMethod getDisplayText() [ Language = javascript ]
{
    var text = '';
    var type = this.$type;
    
    switch(type){
        case '$button':
        case '$link':
        case '$navbaritem':
            text = this.caption;
            break;
        case '$checkbox':
        case '$collapsible':
        case '$fieldset':
        case '$listviewitem':
            if('undefined' != typeof this.label) {
                text = this.label;
            }
            break;
        case '$footer':
        case '$header':
            if('undefined' != typeof this.caption) {
                text = this.caption;
            }
            else if('undefined' != typeof this.captionContent){
                text = this.captionContent; 
            }
            else if ('undefined' != typeof this.content) {
                text = this.content;
            }
            break;
        case '$radio-button':
            if('undefined' != typeof this.label) {
                text = this.label;
            }
            else if('undefined' != typeof this.content){
                text = this.content; 
            }
            break;
        case '$select':
            if('undefined' != typeof this.valueList){
                if('undefined' != typeof this.value){
                    for( var v in this.valueList ){
                        if(this.valueList[v].value === this.value){
                            text = this.valueList[v].text;
                            break;
                        }
                    }
                } else {
                    text = this.valueList[0].text;
                }               
            }
            else if('undefined' != typeof this.optGroups){
                text = this.optGroups[this.value].text;
            }
            break;
        case '$control':
        case '$input':
        case '$password':
        case '$string':
        case '$text':
        case '$textarea':
            if ('undefined' != typeof this.value) {
                text = this.value;
            }
            break;
        default:
            break;
    }
    return text;
}

}
