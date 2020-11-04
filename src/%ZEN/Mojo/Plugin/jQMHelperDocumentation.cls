Class %ZEN.Mojo.Plugin.jQMHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
{

/// returns an object containing information about the requested identifier (e.g. $loop).
/// The object contains an array holding an object for each supported attribute and a documentation
/// EXAMPLE:
/// 
/// {
/// 	description: 'Description of the identifier e.g. $loop',
/// 	attributes: [
/// 			{name:'value',type:'string',description:'Holds the value of the html element'}
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

					{name:'caption',type:'string',description:'Caption for the button, if content is null.'},
					{name:'content',type:'string',description:'Caption for the button.'},
					{name:'corners',type:'boolean',description:'Corresponds to the data-corners attribute.'},
					{name:'cssClass',type:'string',description:'Specifies the CSS class to use for the <button> element.'},
					{name:'dataicon',type:'string',description:'Corresponds to the data-icon attribute.'},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataiconshadow',type:'boolean',description:'Corresponds to the data-iconshadow attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'disabled',type:'boolean',description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inline',type:'boolean',description:'Corresponds to the data-inline attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'shadow',type:'boolean',description:'Corresponds to the data-shadow attribute.'},				]

			};
			break;

		case '$checkbox':
			documentation = {
				description:'The $checkbox object represents a JQuery Mobile Checkbox widget, which corresponds to an HTML <input> element of type=""checkbox"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'content',type:'string',description:''},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'disabled',type:'boolean',description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'text',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$collapsible':
			documentation = {
				description:'The $collapsible object represents a JQuery Mobile Collapsible widget, which corresponds to an HTML <div> element with data-role=""collapsible"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'collapsedicon',type:'string',description:'Corresponds to the data-collapsed-icon attribute.'},
					{name:'cssClass',type:'string',description:''},
					{name:'dataContentTheme',type:'string',description:'Corresponds to the data-content-theme attribute. If this is not specified, Zen Mojo uses the value of the jQueryCollapsibleTheme property of the plugin.'},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'expanded',type:'boolean',description:'Corresponds to the data-collapsed attribute.'},
					{name:'expandedicon',type:'string',description:'Corresponds to the data-expanded-icon attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inset',type:'boolean',description:'Corresponds to the data-inset attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:'Used as the legend of this layout object.'},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},				]

			};
			break;

		case '$collapsibleset':
			documentation = {
				description:'The $collapsibleset object represents a JQuery Mobile Collapsibleset widget, which corresponds to an HTML <div> element with data-role=""collapsible-set"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'collapsedicon',type:'string',description:'Corresponds to the data-collapsed-icon attribute.'},
					{name:'corners',type:'boolean',description:'Corresponds to the data-corners attribute.'},
					{name:'cssClass',type:'string',description:''},
					{name:'dataContentTheme',type:'string',description:'Corresponds to the data-content-theme attribute. If this is not specified, Zen Mojo uses the value of the jQueryCollapsibleTheme property of the plugin.'},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'expandedicon',type:'string',description:'Corresponds to the data-expanded-icon attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inset',type:'boolean',description:'Corresponds to the data-inset attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},				]

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

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'horizontal',type:'boolean',description:'If this property is true, Zen Mojo sets data-type=""horizontal"" for this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$fieldset':
			documentation = {
				description:'The $fieldset object represents an HTML <fieldset> element with data-role=""controlgroup"", which is a commonly used container. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'horizontal',type:'boolean',description:'If this property is true, Zen Mojo sets data-type=""horizontal"" for this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},				]

			};
			break;

		case '$footer':
			documentation = {
				description:'The $footer object represents a JQuery Mobile Footer widget, which corresponds to an HTML <div>  element with data-role=""footer"". The data-id for this element is docviewid+\'footer\' where docviewid is the id of the containing documentView. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'caption',type:'string',description:'Title to display if content and captionContent are both null.'},
					{name:'captionClass',type:'string',description:''},
					{name:'captionContent',type:'string',description:'Title to display if content is null.'},
					{name:'captionContentClass',type:'string',description:''},
					{name:'captionStyle',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'content',type:'string',description:'Default title of the footer, before any child layout objects.'},
					{name:'cssClass',type:'string',description:'Specifies the CSS class to use.'},
					{name:'fixed',type:'boolean',description:'If this property is true, Zen Mojo sets data-position=""fixed"" for this layout object.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$grid':
			documentation = {
				description:'The $grid object represents a representation of a grid of objects, using JQuery Mobile conventions. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'barTheme',type:'string',description:'Specifies the theme to use if showBox is true.'},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'columnCount',type:'number',description:'Specifies the number of columns in the grid. Specify 1, 2, 3, 4, or 5. If you specify a number greater than 5, Zen Mojo creates 5 columns.'},
					{name:'cssClass',type:'string',description:'Specifies the CSS class to use.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'showBox',type:'boolean',description:' If this property is false (the default), the grid is used only for layout and has no associated theme (grid is transparent). If this property is true, Zen Mojo applies a theme to the grid. This is barTheme or (if barTheme is not set) the global jQueryBarTheme.'},
					{name:'style',type:'string',description:''},				]

			};
			break;

		case '$header':
			documentation = {
				description:'The $header object represents a JQuery Mobile Header widget, which corresponds to an HTML <div> element with data-role=""header"". The id and data-id attributes are both equal to docviewid+\'Header\' where docviewid is the id of the containing documentView. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'backcaption',type:'string',description:'Specifies the caption of the back button (""Back"" by default, localized)'},
					{name:'backcorners',type:'boolean',description:'Corresponds to the data-corners attribute used for the back button.'},
					{name:'backdataicon',type:'string',description:'Corresponds to the data-icon attribute used for the back button.'},
					{name:'backdataiconpos',type:'string',description:'Corresponds to the data-icon-pos attribute used for the back button.'},
					{name:'backHidden',type:'boolean',description:'Controls whether the back button is hidden'},
					{name:'backinline',type:'boolean',description:'If this property is true, Zen Mojo sets data-inline=""true"" for the back button.'},
					{name:'backshadow',type:'boolean',description:'Corresponds to the data-shadow attribute used for the back button.'},
					{name:'backtheme',type:'',description:'Corresponds to the data-theme attribute used for the back button.'},
					{name:'caption',type:'string',description:'Title to display if content and captionContent are both null.'},
					{name:'captionClass',type:'string',description:''},
					{name:'captionContent',type:'string',description:'Title to display if content is null.'},
					{name:'captionContentClass',type:'string',description:''},
					{name:'captionStyle',type:'string',description:'Used in the CSS style of the header (combined with style property).'},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'content',type:'string',description:'Default title of the header before any child layout objects.'},
					{name:'fixed',type:'boolean',description:'If this property is true, Zen Mojo sets data-position=""fixed"" for this layout object.'},
					{name:'headerClass',type:'string',description:'Used for the CSS class of the header.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'isMobile',type:'boolean',description:'Controls which handler is used for the back button. If this property is true, Zen Mojo uses ontouchstart; otherwise, it uses onlick.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'style',type:'string',description:'Used in the CSS style of the header (combined with captionStyle property).'},
					{name:'suppressBackButton',type:'boolean',description:'If this property is true, Zen Mojo will not add a back button automatically. If this property is false, Zen Mojo does add a back button to the header if the current level is > 0.'},
					{name:'updateLayoutOnBack',type:'boolean',description:'If this property is true, Zen Mojo pops the document off the stack when the user presses the back button.'},				]

			};
			break;

		case '$input':
			documentation = {
				description:'The $input object represents a generic JQuery Mobile control. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autocapitalize',type:'boolean',description:''},
					{name:'autocorrect',type:'boolean',description:''},
					{name:'clearButton',type:'boolean',description:'Corresponds to the data-clear-btn attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'dataTrackTheme',type:'string',description:'Corresponds to the data-track-theme attribute.'},
					{name:'disabled',type:'boolean',description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'highlight',type:'boolean',description:'Corresponds to the data-highlight attribute.'},
					{name:'inputType',type:'string',description:'Type of control.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'pattern',type:'boolean',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'spellcheck',type:'boolean',description:''},
					{name:'value2',type:'boolean',description:'Add another sliding button to the control, if it is a slider.'},
					{name:'valueList',type:'',description:'This property can be an array of objects, each of which has ""value"", ""text"", and optional ""disabled"" properties.  Or the property can be a string containing a comma-separated list of values.'},				]

			};
			break;

		case '$link':
			documentation = {
				description:'The $link object represents corresponds to an HTML <a> element. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'caption',type:'string',description:'Specifies the caption for this item.'},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'image',type:'string',description:''},
					{name:'imageClass',type:'string',description:''},
					{name:'imageStyle',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},				]

			};
			break;

		case '$listview':
			documentation = {
				description:'The $listview object represents a JQuery Mobile Listview widget, which corresponds to an HTML <ol> element or <ul> element or with data-role=""listview"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autodividers',type:'boolean',description:'Corresponds to the data-autodividers attribute.'},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'counttheme',type:'string',description:'Corresponds to the data-count-theme attribute.'},
					{name:'cssClass',type:'string',description:''},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'dividertheme',type:'string',description:'Corresponds to the data-divider-theme attribute.'},
					{name:'filter',type:'boolean',description:'Corresponds to the data-filter attribute.'},
					{name:'filterplaceholder',type:'',description:'Corresponds to the data-filter-placeholder attribute.'},
					{name:'filterreveal',type:'boolean',description:'Corresponds to the data-filter-reveal attribute.'},
					{name:'filtertheme',type:'string',description:'Corresponds to the data-filter-theme attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'inset',type:'boolean',description:'Corresponds to the data-inset attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'ordered',type:'boolean',description:'Controls whether the list is an ordered list or an unordered list.'},
					{name:'spliticon',type:'string',description:'Corresponds to the data-split-icon attribute.'},
					{name:'splittheme',type:'string',description:'Corresponds to the data-split-theme attribute.'},
					{name:'style',type:'string',description:'Controls the CSS style of the list.'},				]

			};
			break;

		case '$listviewitem':
			documentation = {
				description:'The $listviewitem object represents an HTML <li> element to be used as a child of a Listview widget. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'clickable',type:'boolean',description:'If this property is true, Zen Mojo enables the onclick event for this item.'},
					{name:'content',type:'string',description:'Specifies the content of this item.'},
					{name:'count',type:'number',description:'Specifies an optional count to display on this item. This count is shown in a bubble on the right side of the item.'},
					{name:'dataicon',type:'string',description:'Corresponds to the data-icon attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'divider',type:'',description:'If this property is true, Zen Mojo sets data-role=""list-divider"" for this layout object.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'id',type:'string',description:'Specifies the id of this object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:'Specifies a label to include within a <h2> for this item.'},
					{name:'labelNoWrapper',type:'boolean',description:'If this attribute is false, Zen Mojo wraps the label (if any) in an HTML <h2> element. If this attribute is true, Zen Mojo includes the label (if any) as is.'},
					{name:'thumbnail',type:'string',description:'Specifies an optional image file to display with the item.'},				]

			};
			break;

		case '$navbar':
			documentation = {
				description:'The $navbar object represents a JQuery Mobile Navbar widget, which corresponds to an HTML <div>  element with data-role=""navbar"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$navbaritem':
			documentation = {
				description:'The $navbaritem object represents represents an HTML <li> element to be used as a child of a Navbar widget. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'active',type:'boolean',description:'If this attribute is true, Zen Mojo adds ui-btn-active to the class attribute for the item.'},
					{name:'caption',type:'string',description:'Specifies the caption for this item.'},
					{name:'dataiconpos',type:'string',description:'Corresponds to the data-iconpos attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'icon',type:'string',description:'Corresponds to the data-icon attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'persist',type:'boolean',description:'If this attribute is true, Zen Mojo adds ui-state-persist to the class attribute for the item.'},				]

			};
			break;

		case '$panel':
			documentation = {
				description:'The $panel object represents a JQuery Mobile Panel widget, which corresponds to a <div> element with data-role=""panel"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'animate',type:'boolean',description:'Corresponds to the data-animate attribute.'},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'dismissable',type:'boolean',description:'Corresponds to the data-dismissable attribute.'},
					{name:'displayMode',type:'string',description:'Corresponds to the data-display-mode attribute.'},
					{name:'fixed',type:'boolean',description:'Corresponds to the data-position-fixed attribute.'},
					{name:'id',type:'',description:'Specifies the id of this object. Use this id when you invoke the openPanel(),  closePanel(), or togglePanel() methods of this plugin.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'position',type:'string',description:'Corresponds to the data-position attribute.'},				]

			};
			break;

		case '$password':
			documentation = {
				description:'The $password object represents an HTML <input> element of type=""password"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autocapitalize',type:'boolean',description:''},
					{name:'autocorrect',type:'boolean',description:''},
					{name:'codeTable',type:'',description:''},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'fieldContain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element that has data-role=""fieldcontain"".'},
					{name:'format',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'highlight',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'max',type:'number',description:''},
					{name:'min',type:'number',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'size',type:'number',description:''},
					{name:'spellcheck',type:'boolean',description:''},
					{name:'step',type:'number',description:''},
					{name:'text',type:'string',description:''},
					{name:'value',type:'string',description:''},
					{name:'valueList',type:'array',description:''},				]

			};
			break;

		case '$popup':
			documentation = {
				description:'The $popup object represents a JQuery Mobile Popup widget, which corresponds to a <div> element with data-role=""popup"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'content',type:'string',description:'Specifies the content of this item.'},
					{name:'corners',type:'boolean',description:'Corresponds to the data-corners attribute.'},
					{name:'cssClass',type:'string',description:''},
					{name:'dataOverlayTheme',type:'boolean',description:'Corresponds to the data-overlay-theme attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'dismissable',type:'boolean',description:'Corresponds to the data-dismissable attribute.'},
					{name:'key',type:'string',description:'Specifies the key of this Popup. The id for this Popup is currLevel-key, where currLevel is the currLevel of the documentView.'},
					{name:'shadow',type:'boolean',description:'Corresponds to the data-shadow attribute.'},
					{name:'transition',type:'string',description:'Corresponds to the data-transition attribute.'},				]

			};
			break;

		case '$radio-button':
			documentation = {
				description:'The $radio-button object represents an HTML <input> element of type=""radio"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'captionClass',type:'string',description:''},
					{name:'captionStyle',type:'string',description:''},
					{name:'content',type:'string',description:''},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'disabled',type:'boolean',description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'name',type:'string',description:''},
					{name:'optionValue',type:'string',description:''},
					{name:'text',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$select':
			documentation = {
				description:'The $select object represents a JQuery Mobile Select widget, which corresponds to an HTML <select> element, optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'dataicon',type:'string',description:'Corresponds to the data-icon attribute.'},
					{name:'dataTheme',type:'string',description:'Corresponds to the data-theme attribute.'},
					{name:'dataTrackTheme',type:'string',description:'Corresponds to the data-track-theme attribute.'},
					{name:'disabled',type:'boolean',description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'disabledList',type:'string',description:'Use this property if you specify a comma-separated list for valueList in the optGroups array. If specified, disabledList should be a comma-separated list of true and false values, to control which options are disabled.'},
					{name:'fieldcontain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'multiple',type:'boolean',description:''},
					{name:'optGroups',type:'array',description:'Options and their labels to be presented as a group, with the options indented. Each element of the array should be an object with the string property ""label"" and the ""valueList"" property.  If you omit the ""label"" property, no option group is created, but the options will appear. The ""valueList"" property can be an array of objects, each of which has ""value"", ""text"", and optional ""disabled"" properties.  Or the ""valueList"" property can be a string containing a comma-separated list of values.'},
					{name:'size',type:'number',description:''},
					{name:'slider',type:'boolean',description:'If this property is true, Zen Mojo adds data-role=""slider"" to the rendered element.'},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$string':
			documentation = {
				description:'The $string object represents an HTML <input> element of type=""string"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autocapitalize',type:'boolean',description:''},
					{name:'autocorrect',type:'boolean',description:''},
					{name:'codeTable',type:'',description:''},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'fieldContain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element that has data-role=""fieldcontain"".'},
					{name:'format',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'highlight',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'max',type:'number',description:''},
					{name:'min',type:'number',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'size',type:'number',description:''},
					{name:'spellcheck',type:'boolean',description:''},
					{name:'step',type:'number',description:''},
					{name:'text',type:'string',description:''},
					{name:'value',type:'string',description:''},
					{name:'valueList',type:'array',description:''},				]

			};
			break;

		case '$text':
			documentation = {
				description:'The $text object represents an HTML <input> element of type=""text"", optionally wrapped in a <div> element that has data-role=""fieldcontain"". You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autocapitalize',type:'boolean',description:''},
					{name:'autocorrect',type:'boolean',description:''},
					{name:'codeTable',type:'',description:''},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'fieldContain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element that has data-role=""fieldcontain"".'},
					{name:'format',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'highlight',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'max',type:'number',description:''},
					{name:'min',type:'number',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'size',type:'number',description:''},
					{name:'spellcheck',type:'boolean',description:''},
					{name:'step',type:'number',description:''},
					{name:'text',type:'string',description:''},
					{name:'value',type:'string',description:''},
					{name:'valueList',type:'array',description:''},				]

			};
			break;

		case '$textarea':
			documentation = {
				description:'The $textarea object represents an HTML <textarea> element with an optional, associated <label> element. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the JQuery Mobile API.',

				attributes:[

					{name:'autocapitalize',type:'boolean',description:''},
					{name:'autocorrect',type:'boolean',description:''},
					{name:'cols',type:'number',description:''},
					{name:'controlClass',type:'string',description:''},
					{name:'controlStyle',type:'string',description:''},
					{name:'disabled',type:'boolean',description:'If this property is true, Zen Mojo disables this object by adding the HTML disabled attribute.'},
					{name:'fieldcontain',type:'boolean',description:'If this property is true, Zen Mojo encloses this layout object in a <div> element with data-role=""fieldcontain"".'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object by including the HTML hidden attribute.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'mini',type:'boolean',description:'Corresponds to the data-mini attribute.'},
					{name:'placeHolder',type:'string',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'rows',type:'number',description:''},
					{name:'spellcheck',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

	}
	return documentation;
}

}
