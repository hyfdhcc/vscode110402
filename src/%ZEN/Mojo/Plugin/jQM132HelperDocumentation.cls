Class %ZEN.Mojo.Plugin.jQM132HelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
{

/// returns an object containing information about the requested identifier (e.g. $loop).
/// The object contains an array holding an object for each supported attribute and a documentation
/// EXAMPLE:
/// 
/// {
/// 	description: 'Description of the identifier e.g. $loop',
/// 	attributes: [
/// 			{name:'value',type:'string',refreshable:true,description:'Holds the value of the html element'}
/// 		]
/// }
/// 
/// Valid types are: string,number,boolean,date,object,array and function
ClientMethod getDocumentation(identifier) [ Language = javascript ]
{
	var documentation = {attributes:[]};
	switch (identifier) {
		case '$button':
			documentation = {
				description:'The $button object represents a JQuery Mobile Button widget, which corresponds to an HTML <button> element. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreSelect',type:'boolean',refreshable:false,description:'If true, suppress default generation of select handlers.'},
					{name:'caption',type:'string',refreshable:true,description:'Caption for the button, if content is null.'},
					{name:'content',type:'string',refreshable:true,description:'Caption for the button.'},
					{name:'corners',type:'boolean',refreshable:true,description:'Corresponds to the data-corners attribute.'},
					{name:'cssClass',type:'string',refreshable:false,description:'Specifies the CSS class to use for the <button> element.'},
					{name:'dataicon',type:'string',refreshable:true,description:'Corresponds to the data-icon attribute.'},
					{name:'dataiconpos',type:'string',refreshable:true,description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataiconshadow',type:'boolean',refreshable:true,description:'Corresponds to the data-iconshadow attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inline',type:'boolean',refreshable:true,description:'Corresponds to the data-inline attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'shadow',type:'boolean',refreshable:true,description:'Corresponds to the data-shadow attribute.'},				]

			};
			break;

		case '$checkbox':
			documentation = {
				description:'The $checkbox object represents a JQuery Mobile Checkbox widget, which corresponds to an HTML <input> element of type=""checkbox"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:false,description:'If true, suppress default generation of onchange handlers.'},
					{name:'content',type:'string',refreshable:true,description:'Not in use'},
					{name:'controlClass',type:'string',refreshable:false,description:'Specifies the CSS class to use for the main element.'},
					{name:'controlStyle',type:'string',refreshable:true,description:'Specifies the CSS style for the main element.'},
					{name:'dataiconpos',type:'string',refreshable:true,description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'text',type:'string',refreshable:true,description:''},
					{name:'value',type:'string',refreshable:true,description:''},				]

			};
			break;

		case '$collapsible':
			documentation = {
				description:'The $collapsible object represents a JQuery Mobile Collapsible widget, which corresponds to an HTML <div> element with data-role=""collapsible"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',refreshable:true,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'collapsedicon',type:'string',refreshable:true,description:'Corresponds to the data-collapsed-icon attribute.'},
					{name:'cssClass',type:'string',refreshable:true,description:''},
					{name:'dataContentTheme',type:'string',refreshable:true,description:'Corresponds to the data-content-theme attribute. If this is not specified, Zen Mojo uses the value of the jQueryCollapsibleTheme property of the plugin.'},
					{name:'dataiconpos',type:'string',refreshable:true,description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'expanded',type:'boolean',refreshable:true,description:'Corresponds to the data-collapsed attribute.'},
					{name:'expandedicon',type:'string',refreshable:true,description:'Corresponds to the data-expanded-icon attribute.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inset',type:'boolean',refreshable:true,description:'Corresponds to the data-inset attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:'Used as the legend of this layout object.'},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'value',type:'array',refreshable:true,description:'Not in use'},				]

			};
			break;

		case '$collapsibleset':
			documentation = {
				description:'The $collapsibleset object represents a JQuery Mobile Collapsibleset widget, which corresponds to an HTML <div> element with data-role=""collapsible-set"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',refreshable:true,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'collapsedicon',type:'string',refreshable:true,description:'Corresponds to the data-collapsed-icon attribute.'},
					{name:'corners',type:'boolean',refreshable:true,description:'Corresponds to the data-corners attribute.'},
					{name:'cssClass',type:'string',refreshable:true,description:''},
					{name:'dataContentTheme',type:'string',refreshable:true,description:'Corresponds to the data-content-theme attribute. If this is not specified, Zen Mojo uses the value of the jQueryCollapsibleTheme property of the plugin.'},
					{name:'dataiconpos',type:'string',refreshable:true,description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'expandedicon',type:'string',refreshable:true,description:'Corresponds to the data-expanded-icon attribute.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inset',type:'boolean',refreshable:true,description:'Corresponds to the data-inset attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},				]

			};
			break;

		case '$control':
			documentation = {
				description:'The $control object is deprecated. Use $button, $text, $input, and other layout objects instead. This object has no properties.'			};
			break;

		case '$controlgroup':
			documentation = {
				description:'The $controlgroup object represents a JQuery Mobile Controlgroup widget, which corresponds to an HTML <div> element with data-role=""controlgroup"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'horizontal',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo sets data-type=""horizontal"" for this layout object.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$fieldset':
			documentation = {
				description:'The $fieldset object represents an HTML <fieldset> element with data-role=""controlgroup"", which is a commonly used container. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dataiconpos',type:'string',refreshable:false,description:'Corresponds to the data-iconpos attribute.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'horizontal',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo sets data-type=""horizontal"" for this layout object.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},				]

			};
			break;

		case '$footer':
			documentation = {
				description:'The $footer object represents a JQuery Mobile Footer widget, which corresponds to an HTML <div>  element with data-role=""footer"". The data-id for this element is docviewid+\'footer\' where docviewid is the id of the containing documentView. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'caption',type:'string',refreshable:true,description:'Title to display if content and captionContent are both null.'},
					{name:'captionClass',type:'string',refreshable:false,description:''},
					{name:'captionContent',type:'string',refreshable:true,description:'Title to display if content is null.'},
					{name:'captionContentClass',type:'string',refreshable:false,description:''},
					{name:'captionStyle',type:'string',refreshable:false,description:''},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'content',type:'string',refreshable:false,description:'Default title of the footer, before any child layout objects.'},
					{name:'cssClass',type:'string',refreshable:false,description:'Specifies the CSS class to use.'},
					{name:'fixed',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo sets data-position=""fixed"" for this layout object.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$grid':
			documentation = {
				description:'The $grid object represents a representation of a grid of objects, using JQuery Mobile conventions. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'barTheme',type:'string',refreshable:false,description:'Specifies the theme to use if showBox is true.'},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'columnCount',type:'number',refreshable:false,description:'Specifies the number of columns in the grid. Specify 1, 2, 3, 4, or 5. If you specify a number greater than 5, Zen Mojo creates 5 columns.'},
					{name:'cssClass',type:'string',refreshable:false,description:'Specifies the CSS class to use.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'showBox',type:'boolean',refreshable:false,description:' If this property is false (the default), the grid is used only for layout and has no associated theme (grid is transparent). If this property is true, Zen Mojo applies a theme to the grid. This is barTheme or (if barTheme is not set) the global jQueryBarTheme.'},
					{name:'style',type:'string',refreshable:true,description:''},				]

			};
			break;

		case '$header':
			documentation = {
				description:'The $header object represents a JQuery Mobile Header widget, which corresponds to an HTML <div> element with data-role=""header"". The id and data-id attributes are both equal to docviewid+\'Header\' where docviewid is the id of the containing documentView. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'backcaption',type:'string',refreshable:false,description:'Specifies the caption of the back button (""Back"" by default, localized)'},
					{name:'backcorners',type:'boolean',refreshable:false,description:'Corresponds to the data-corners attribute used for the back button.'},
					{name:'backdataicon',type:'string',refreshable:false,description:'Corresponds to the data-icon attribute used for the back button.'},
					{name:'backdataiconpos',type:'string',refreshable:false,description:'Corresponds to the data-icon-pos attribute used for the back button.'},
					{name:'backHidden',type:'boolean',refreshable:false,description:'Controls whether the back button is hidden'},
					{name:'backinline',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo sets data-inline=""true"" for the back button.'},
					{name:'backshadow',type:'boolean',refreshable:false,description:'Corresponds to the data-shadow attribute used for the back button.'},
					{name:'backtheme',type:'',refreshable:false,description:'Corresponds to the data-theme attribute used for the back button.'},
					{name:'caption',type:'string',refreshable:true,description:'Title to display if content and captionContent are both null.'},
					{name:'captionClass',type:'string',refreshable:false,description:''},
					{name:'captionContent',type:'string',refreshable:true,description:'Title to display if content is null.'},
					{name:'captionContentClass',type:'string',description:''},
					{name:'captionStyle',type:'string',refreshable:false,description:'Used in the CSS style of the header (combined with style property).'},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'content',type:'string',refreshable:false,description:'Default title of the header before any child layout objects.'},
					{name:'fixed',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo sets data-position=""fixed"" for this layout object.'},
					{name:'headerClass',type:'string',refreshable:false,description:'Used for the CSS class of the header.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'isMobile',type:'boolean',refreshable:false,description:'Controls which handler is used for the back button. If this property is true, Zen Mojo uses ontouchstart; otherwise, it uses onlick.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'style',type:'string',refreshable:true,description:'Used in the CSS style of the header (combined with captionStyle property).'},
					{name:'suppressBackButton',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo will not add a back button automatically. If this property is false, Zen Mojo does add a back button to the header if the current level is > 0.'},
					{name:'updateLayoutOnBack',type:'boolean',description:'If this property is true, Zen Mojo pops the document off the stack when the user presses the back button.'},				]

			};
			break;

		case '$input':
			documentation = {
				description:'The $input object represents a generic JQuery Mobile control. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:true,description:'If true, suppress default generation of onchange handlers.'},
					{name:'$ignoreEvent',type:'boolean',refreshable:true,description:'If true, suppress default generation of keyup handlers.'},
					{name:'autocapitalize',type:'boolean',refreshable:true,description:''},
					{name:'autocorrect',type:'boolean',refreshable:true,description:''},
					{name:'clearButton',type:'boolean',refreshable:true,description:'Corresponds to the data-clear-btn attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'dataTrackTheme',type:'string',refreshable:true,description:'Corresponds to the data-track-theme attribute.'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'highlight',type:'boolean',refreshable:false,description:'Corresponds to the data-highlight attribute.'},
					{name:'inputType',type:'string',refreshable:false,description:'Type of control.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:false,description:'Corresponds to the data-mini attribute.'},
					{name:'pattern',type:'boolean',refreshable:true,description:''},
					{name:'readOnly',type:'boolean',refreshable:true,description:''},
					{name:'required',type:'boolean',refreshable:true,description:''},
					{name:'spellcheck',type:'boolean',refreshable:true,description:''},
					{name:'value2',type:'boolean',refreshable:false,description:'Add another sliding button to the control, if it is a slider.'},
					{name:'valueList',type:'',refreshable:false,description:'This property can be an array of objects, each of which has ""value"", ""text"", and optional ""disabled"" properties.  Or the property can be a string containing a comma-separated list of values.'},				]

			};
			break;

		case '$link':
			documentation = {
				description:'The $link object represents corresponds to an HTML <a> element. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreSelect',type:'boolean',refreshable:false,description:'If true, suppress default generation of select handlers.'},
					{name:'caption',type:'string',refreshable:false,description:'Specifies the caption for this item.'},
					{name:'controlClass',type:'string',refreshable:false,description:''},
					{name:'controlStyle',type:'string',refreshable:false,description:''},
					{name:'dataTheme',type:'string',refreshable:false,description:'Corresponds to the data-theme attribute.'},
					{name:'hidden',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'image',type:'string',refreshable:false,description:''},
					{name:'imageClass',type:'string',refreshable:false,description:''},
					{name:'imageStyle',type:'string',refreshable:false,description:''},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mini',type:'boolean',refreshable:false,description:'Corresponds to the data-mini attribute.'},				]

			};
			break;

		case '$listview':
			documentation = {
				description:'The $listview object represents a JQuery Mobile Listview widget, which corresponds to an HTML <ol> element or <ul> element or with data-role=""listview"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autodividers',type:'boolean',refreshable:true,description:'Corresponds to the data-autodividers attribute.'},
					{name:'children',type:'array',refreshable:true,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'counttheme',type:'string',refreshable:true,description:'Corresponds to the data-count-theme attribute.'},
					{name:'cssClass',type:'string',refreshable:true,description:''},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'dividertheme',type:'string',refreshable:true,description:'Corresponds to the data-divider-theme attribute.'},
					{name:'filter',type:'boolean',refreshable:true,description:'Corresponds to the data-filter attribute.'},
					{name:'filterplaceholder',type:'',refreshable:true,description:'Corresponds to the data-filter-placeholder attribute.'},
					{name:'filterreveal',type:'boolean',refreshable:true,description:'Corresponds to the data-filter-reveal attribute.'},
					{name:'filtertheme',type:'string',refreshable:true,description:'Corresponds to the data-filter-theme attribute.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inset',type:'boolean',refreshable:true,description:'Corresponds to the data-inset attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'ordered',type:'boolean',refreshable:true,description:'Controls whether the list is an ordered list or an unordered list.'},
					{name:'spliticon',type:'string',refreshable:true,description:'Corresponds to the data-split-icon attribute.'},
					{name:'splittheme',type:'string',refreshable:true,description:'Corresponds to the data-split-theme attribute.'},
					{name:'style',type:'string',refreshable:true,description:'Controls the CSS style of the list.'},
					{name:'value',type:'array',refreshable:true,description:'An array of objects, each of which has the attributes label and key.'},				]

			};
			break;

		case '$listviewitem':
			documentation = {
				description:'The $listviewitem object represents an HTML <li> element to be used as a child of a Listview widget. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreSelect',type:'boolean',refreshable:true,description:'If true, suppress default generation of select handlers.'},
					{name:'children',type:'array',refreshable:true,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'clickable',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo enables the onclick event for this item.'},
					{name:'content',type:'string',refreshable:true,description:'Specifies the content of this item.'},
					{name:'count',type:'number',refreshable:true,description:'Specifies an optional count to display on this item. This count is shown in a bubble on the right side of the item.'},
					{name:'dataicon',type:'string',refreshable:true,description:'Corresponds to the data-icon attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'divider',type:'',refreshable:true,description:'If this property is true, Zen Mojo sets data-role=""list-divider"" for this layout object.'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:'Specifies a label to include within a <h2> for this item.'},
					{name:'labelNoWrapper',type:'boolean',refreshable:true,description:'If this attribute is false, Zen Mojo wraps the label in an HTML <h2> element. If this attribute is true, Zen Mojo includes the label as is.'},
					{name:'thumbnail',type:'string',refreshable:true,description:'Specifies an optional image file to display with the item.'},				]

			};
			break;

		case '$navbar':
			documentation = {
				description:'The $navbar object represents a JQuery Mobile Navbar widget, which corresponds to an HTML <div>  element with data-role=""navbar"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dataiconpos',type:'string',refreshable:false,description:'Corresponds to the data-iconpos attribute.'},
					{name:'hidden',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$navbaritem':
			documentation = {
				description:'The $navbaritem object represents represents an HTML <li> element to be used as a child of a Navbar widget. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreSelect',type:'boolean',refreshable:false,description:'If true, suppress default generation of select handlers.'},
					{name:'active',type:'boolean',refreshable:false,description:'If this attribute is true, Zen Mojo adds ui-btn-active to the class attribute for the item.'},
					{name:'caption',type:'string',refreshable:false,description:'Specifies the caption for this item.'},
					{name:'dataiconpos',type:'string',refreshable:false,description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',refreshable:false,description:'Corresponds to the data-theme attribute.'},
					{name:'hidden',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'icon',type:'string',refreshable:false,description:'Corresponds to the data-icon attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'persist',type:'boolean',refreshable:false,description:'If this attribute is true, Zen Mojo adds ui-state-persist to the class attribute for the item.'},				]

			};
			break;
		
		case '$pagecontent':
			documentation = {
				description:'The $pagecontent object must be used to enclose all layout objects other than $footer, $header, and $panel. This will make the $panel transition properly.',
				
				attributes:[
					{name:'$ignoreSelect',type:'boolean',refreshable:false,description:'If true, suppress default generation of select handlers.'},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',refreshable:false,description:''},
					{name:'style',type:'string',refreshable:false,description:''},
				]
			};
			break;
		
		case '$panel':
			documentation = {
				description:'The $panel object represents a JQuery Mobile Panel widget, which corresponds to a <div> element with data-role=""panel"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'animate',type:'boolean',refreshable:false,description:'Corresponds to the data-animate attribute.'},
					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dataTheme',type:'string',refreshable:false,description:'Corresponds to the data-theme attribute.'},
					{name:'dismissable',type:'boolean',refreshable:false,description:'Corresponds to the data-dismissable attribute.'},
					{name:'displayMode',type:'string',refreshable:true,description:'Corresponds to the data-display-mode attribute.'},
					{name:'fixed',type:'boolean',refreshable:false,description:'Corresponds to the data-position-fixed attribute.'},
					{name:'id',type:'',refreshable:false,description:'Deprecated. Use the key attribute instead.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'position',type:'string',refreshable:false,description:'Corresponds to the data-position attribute.'},				]

			};
			break;

		case '$password':
			documentation = {
				description:'The $password object represents an HTML <input> element of type=""password"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:true,description:'If true, suppress default generation of onchange handlers.'},
					{name:'$ignoreEvent',type:'boolean',refreshable:true,description:'If true, suppress default generation of keyup handlers.'},
					{name:'autocapitalize',type:'boolean',refreshable:true,description:''},
					{name:'autocorrect',type:'boolean',refreshable:true,description:''},
					{name:'codeTable',type:'',refreshable:true,description:''},
					{name:'controlClass',type:'string',refreshable:true,description:''},
					{name:'controlStyle',type:'string',refreshable:true,description:''},
					{name:'disabled',type:'boolean',refreshable:true,description:''},
					{name:'fieldContain',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element that has data-role=""fieldcontain"".'},
					{name:'format',type:'string',refreshable:true,description:''},
					{name:'hidden',type:'boolean',refreshable:true,description:''},
					{name:'highlight',type:'boolean',refreshable:true,description:''},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'max',type:'number',refreshable:true,description:''},
					{name:'min',type:'number',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',refreshable:true,description:''},
					{name:'readOnly',type:'boolean',refreshable:true,description:''},
					{name:'required',type:'boolean',refreshable:true,description:''},
					{name:'size',type:'number',refreshable:true,description:''},
					{name:'spellcheck',type:'boolean',refreshable:true,description:''},
					{name:'step',type:'number',refreshable:true,description:''},
					{name:'text',type:'string',refreshable:true,description:''},
					{name:'value',type:'string',refreshable:true,description:''},
					{name:'valueList',type:'array',refreshable:true,description:''},				]

			};
			break;

		case '$popup':
			documentation = {
				description:'The $popup object represents a JQuery Mobile Popup widget, which corresponds to a <div> element with data-role=""popup"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',refreshable:false,description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'content',type:'string',refreshable:false,description:'Specifies the content of this item.'},
					{name:'corners',type:'boolean',refreshable:true,description:'Corresponds to the data-corners attribute.'},
					{name:'cssClass',type:'string',refreshable:false,description:''},
					{name:'dataOverlayTheme',type:'string',refreshable:true,description:'Corresponds to the data-overlay-theme attribute.'},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'dismissable',type:'boolean',refreshable:true,description:'Corresponds to the data-dismissable attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Specifies the key of this Popup. The id for this Popup is currLevel-key, where currLevel is the currLevel of the documentView.'},
					{name:'shadow',type:'boolean',refreshable:true,description:'Corresponds to the data-shadow attribute.'},
					{name:'transition',type:'string',refreshable:true,description:'Corresponds to the data-transition attribute.'},				]

			};
			break;

		case '$radio-button':
			documentation = {
				description:'The $radio-button object represents an HTML <input> element of type=""radio"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:false,description:'If true, suppress default generation of onchange handlers.'},
					{name:'captionClass',type:'string',refreshable:false,description:''},
					{name:'captionStyle',type:'string',refreshable:false,description:''},
					{name:'checked',type:'boolean',refreshable:true,desctiption:''},
					{name:'content',type:'string',refreshable:false,description:''},
					{name:'controlClass',type:'string',refreshable:false,description:''},
					{name:'controlStyle',type:'string',refreshable:true,description:''},
					{name:'dataTheme',type:'string',refreshable:true,description:'Corresponds to the data-theme attribute.'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'name',type:'string',refreshable:false,description:''},
					{name:'optionValue',type:'string',refreshable:false,description:''},
					{name:'text',type:'string',refreshable:false,description:''},			]

			};
			break;

		case '$select':
			documentation = {
				description:'The $select object represents a JQuery Mobile Select widget, which corresponds to an HTML <select> element, optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:false,description:'If true, suppress default generation of onchange handlers.'},
					{name:'controlClass',type:'string',refreshable:false,description:''},
					{name:'controlStyle',type:'string',refreshable:true,description:''},
					{name:'dataicon',type:'string',refreshable:false,description:'Corresponds to the data-icon attribute.'},
					{name:'dataTheme',type:'string',refreshable:false,description:'Corresponds to the data-theme attribute.'},
					{name:'dataTrackTheme',type:'string',refreshable:false,description:'Corresponds to the data-track-theme attribute.'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'disabledList',type:'string',refreshable:false,description:'Use this property if you specify a comma-separated list for valueList in the optGroups array. If specified, disabledList should be a comma-separated list of true and false values, to control which options are disabled.'},
					{name:'fieldcontain',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:false,description:'Corresponds to the data-mini attribute.'},
					{name:'multiple',type:'boolean',refreshable:false,description:''},
					{name:'optGroups',type:'array',refreshable:true,description:'Options and their labels to be presented as a group, with the options indented. Each element of the array should be an object with the string property ""label"" and the ""valueList"" property.  If you omit the ""label"" property, no option group is created, but the options will appear. The ""valueList"" property can be an array of objects, each of which has ""value"", ""text"", and optional ""disabled"" properties.  Or the ""valueList"" property can be a string containing a comma-separated list of values.'},
					{name:'size',type:'number',refreshable:false,description:''},
					{name:'slider',type:'boolean',refreshable:false,description:'If this property is true, Zen Mojo adds data-role=""slider"" to the rendered element.'},
					{name:'value',type:'string',refreshable:false,description:''},
					{name:'valueList',type:'array',description:'Array of objects. Each object must have the properties value and text.'},				]

			};
			break;

		case '$string':
			documentation = {
				description:'The $string object represents an HTML <input> element of type=""string"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:true,description:'If true, suppress default generation of onchange handlers.'},
					{name:'$ignoreEvent',type:'boolean',refreshable:true,description:'If true, suppress default generation of keyup handlers.'},
					{name:'autocapitalize',type:'boolean',refreshable:true,description:''},
					{name:'autocorrect',type:'boolean',refreshable:true,description:''},
					{name:'codeTable',type:'',refreshable:true,description:''},
					{name:'controlClass',type:'string',refreshable:true,description:''},
					{name:'controlStyle',type:'string',refreshable:true,description:''},
					{name:'disabled',type:'boolean',refreshable:true,description:''},
					{name:'fieldContain',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element that has data-role=""fieldcontain"".'},
					{name:'format',type:'string',refreshable:true,description:''},
					{name:'hidden',type:'boolean',refreshable:true,description:''},
					{name:'highlight',type:'boolean',refreshable:true,description:''},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'max',type:'number',refreshable:true,description:''},
					{name:'min',type:'number',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',refreshable:true,description:''},
					{name:'readOnly',type:'boolean',refreshable:true,description:''},
					{name:'required',type:'boolean',refreshable:true,description:''},
					{name:'size',type:'number',refreshable:true,description:''},
					{name:'spellcheck',type:'boolean',refreshable:true,description:''},
					{name:'step',type:'number',refreshable:true,description:''},
					{name:'text',type:'string',refreshable:true,description:''},
					{name:'value',type:'string',refreshable:true,description:''},
					{name:'valueList',type:'array',refreshable:true,description:''},				]

			};
			break;

		case '$text':
			documentation = {
				description:'The $text object represents an HTML <input> element of type=""text"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:true,description:'If true, suppress default generation of onchange handlers.'},
					{name:'$ignoreEvent',type:'boolean',refreshable:true,description:'If true, suppress default generation of keyup handlers.'},
					{name:'autocapitalize',type:'boolean',refreshable:true,description:''},
					{name:'autocorrect',type:'boolean',refreshable:true,description:''},
					{name:'codeTable',type:'',refreshable:true,description:''},
					{name:'controlClass',type:'string',refreshable:true,description:''},
					{name:'controlStyle',type:'string',refreshable:true,description:''},
					{name:'disabled',type:'boolean',refreshable:true,description:''},
					{name:'fieldContain',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element that has data-role=""fieldcontain"".'},
					{name:'format',type:'string',refreshable:true,description:''},
					{name:'hidden',type:'boolean',refreshable:true,description:''},
					{name:'highlight',type:'boolean',refreshable:true,description:''},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'max',type:'number',refreshable:true,description:''},
					{name:'min',type:'number',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',refreshable:true,description:''},
					{name:'readOnly',type:'boolean',refreshable:true,description:''},
					{name:'required',type:'boolean',refreshable:true,description:''},
					{name:'size',type:'number',refreshable:true,description:''},
					{name:'spellcheck',type:'boolean',refreshable:true,description:''},
					{name:'step',type:'number',refreshable:true,description:''},
					{name:'text',type:'string',refreshable:true,description:''},
					{name:'value',type:'string',refreshable:true,description:''},
					{name:'valueList',type:'array',refreshable:true,description:''},				]

			};
			break;

		case '$textarea':
			documentation = {
				description:'The $textarea object represents an HTML <textarea> element with an optional, associated <label> element. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'$ignoreChange',type:'boolean',refreshable:true,description:'If true, suppress default generation of onchange handlers.'},
					{name:'autocapitalize',type:'boolean',refreshable:true,description:''},
					{name:'autocorrect',type:'boolean',refreshable:true,description:''},
					{name:'cols',type:'number',refreshable:true,description:''},
					{name:'controlClass',type:'string',refreshable:true,description:''},
					{name:'controlStyle',type:'string',refreshable:true,description:''},
					{name:'disabled',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',refreshable:true,description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',refreshable:true,description:''},
					{name:'mini',type:'boolean',refreshable:true,description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',refreshable:true,description:''},
					{name:'required',type:'boolean',refreshable:true,description:''},
					{name:'rows',type:'number',refreshable:true,description:''},
					{name:'spellcheck',type:'boolean',refreshable:true,description:''},
					{name:'value',type:'string',refreshable:true,description:''},				]

			};
			break;

	}
	return documentation;
}

}
