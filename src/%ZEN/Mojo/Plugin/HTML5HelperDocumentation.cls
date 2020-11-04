Class %ZEN.Mojo.Plugin.HTML5HelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
{

/// 
/// returns an object containing information about the requested identifier (e.g. $loop).
/// 
/// The object contains an array holding an object for each supported attribute and a documentation
/// 
/// EXAMPLE:
/// 
/// 
/// 
/// {
/// 
/// 	description: 'Description of the identifier e.g. $loop',
/// 
/// 	attributes: [
/// 
/// 		{name:'value',type:'string',refreshable:true,description:'Holds the value of the html element'}
/// 
/// 	]
/// 
/// }
/// 
/// 
/// 
/// Valid types are: string,number,boolean,date,object,array and function
ClientMethod getDocumentation(identifier) [ Language = javascript ]
{

	var documentation = {attributes:[]};

	switch (identifier) {

		case '$a':

			documentation = {

				description:'A layout object with type:$a represents an HTML 5 <a> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'download',type:'string',refreshable:true, description:'Specifies that the target will be downloaded when a user clicks on the item'},

					{name:'href',type:'string',refreshable:true, description:'Specifies the hyperlink target for the element'},

					{name:'hreflang',type:'string',refreshable:true, description:'Specifies the language of the target URL'},

					{name:'media',type:'string',refreshable:true, description:'Specifies the type of media resource'},

					{name:'rel',type:'string',values:['alternate','author','bookmark','help','license','next','nofollow','noreferrer','prefetch','prev','search','tag'],refreshable:true, description:'Specifies the relationship between the current document and the linked document'},

					{name:'target',type:'string',values:['_blank','_parent','_self','_top'],refreshable:true, description:'Specifies where to open the linked document'},

					{name:'mimeType',type:'string',refreshable:true, description:'Specifies the MIME type of the linked document'}

				]

			};

			break;

		case '$abbr':

			documentation = {

				description:'A layout object with type:$abbr represents an HTML 5 <abbr> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$address':

			documentation = {

				description:'A layout object with type:$address represents an HTML 5 <address> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$area':

			documentation = {

				description:'A layout object with type:$area represents an HTML 5 <area> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'alt',type:'string',refreshable:true, description:'Specifies an alternate text when an image cannot be rendered'},

					{name:'coords',type:'string',refreshable:true, description:'Specifies the coordinates of the area'},

					{name:'download',type:'string',refreshable:true, description:'Specifies that the target will be downloaded when a user clicks on the item'},

					{name:'href',type:'string',refreshable:true, description:'Specifies the hyperlink target for the element'},

					{name:'hreflang',type:'string',refreshable:true, description:'Specifies the language of the target URL'},

					{name:'media',type:'string',refreshable:true, description:'Specifies the type of media resource'},

					{name:'rel',type:'string',values:['alternate','author','bookmark','help','license','next','nofollow','noreferrer','prefetch','prev','search','tag'],refreshable:true, description:'Specifies the relationship between the current document and the linked document'},

					{name:'shape',type:'string',values:['default','rect','circle','poly'],refreshable:true, description:'Specifies the shape of the area'},

					{name:'target',type:'string',values:['_blank','_parent','_self','_top'],refreshable:true, description:'Specifies where to open the linked document'},

					{name:'mimeType',type:'string',refreshable:true, description:'Specifies the MIME type of the linked document'}

				]

			};

			break;

		case '$article':

			documentation = {

				description:'A layout object with type:$article represents an HTML 5 <article> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$aside':

			documentation = {

				description:'A layout object with type:$aside represents an HTML 5 <aside> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$audio':

			documentation = {

				description:'A layout object with type:$audio represents an HTML 5 <audio> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'autoplay',type:'boolean',refreshable:true, description:'Specifies that the media will start playing as soon as it is ready'},

					{name:'controls',type:'boolean',refreshable:true, description:'Specifies that controls should be displayed (such as a play/pause button etc).'},

					{name:'loop',type:'boolean',refreshable:true, description:'Specifies that the media will start over again, every time it is finished'},

					{name:'muted',type:'boolean',refreshable:true, description:'Specifies that the audio output should be muted'},

					{name:'preload',type:'string',values:['auto','metadata','none'],refreshable:true, description:'Specifies if and how the author thinks the media should be loaded when the page loads'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'}

				]

			};

			break;

		case '$b':

			documentation = {

				description:'A layout object with type:$b represents an HTML 5 <b> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$bdi':

			documentation = {

				description:'A layout object with type:$bdi represents an HTML 5 <bdi> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$bdo':

			documentation = {

				description:'A layout object with type:$bdo represents an HTML 5 <bdo> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'dir',type:'string',values:['ltr','rtl'],refreshable:true, description:'Required. Specifies the text direction of the text inside the element'}

				]

			};

			break;

		case '$blockquote':

			documentation = {

				description:'A layout object with type:$blockquote represents an HTML 5 <blockquote> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'cite',type:'string',refreshable:true, description:'Specifies the source of the quotation'}

				]

			};

			break;

		case '$br':

			documentation = {

				description:'A layout object with type:$br represents an HTML 5 <br> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$button':

			documentation = {

				description:'A layout object with type:$button represents an HTML 5 <button> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'autofocus',type:'boolean',refreshable:true, description:'Specifies that the control should automatically get focus when the page loads'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'formaction',type:'string',refreshable:true, description:'Specifies where to send the form-data when a form is submitted. Only for type of "submit"'},

					{name:'formenctype',type:'string',values:['text//plain','multipart//form-data','application//x-www-form-urlencoded'],refreshable:true, description:'Specifies how form-data should be encoded before sending it to a server. Only for type of "submit"'},

					{name:'formmethod',type:'string',values:['get','post'],refreshable:true, description:'Specifies how to send the form-data (which HTTP method to use). Only for type of "submit"'},

					{name:'formnovalidate',type:'boolean',refreshable:true, description:'Specifies that the form-data should not be validated on submission. Only for type of "submit"'},

					{name:'formtarget',type:'string',values:['_blank','_self','_parent','_top'],refreshable:true, description:'Specifies where to display the response after submitting the form. Only for type of "submit"'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'buttonType',type:'string',values:['button','submit','reset'],refreshable:true, description:'Specifies the type of button'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$canvas':

			documentation = {

				description:'A layout object with type:$canvas represents an HTML 5 <canvas> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$caption':

			documentation = {

				description:'A layout object with type:$caption represents an HTML 5 <caption> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$cite':

			documentation = {

				description:'A layout object with type:$cite represents an HTML 5 <cite> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$code':

			documentation = {

				description:'A layout object with type:$code represents an HTML 5 <code> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$col':

			documentation = {

				description:'A layout object with type:$col represents an HTML 5 <col> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'span',type:'string',refreshable:true, description:'Specifies the number of columns a <col> element should span'}

				]

			};

			break;

		case '$colgroup':

			documentation = {

				description:'A layout object with type:$colgroup represents an HTML 5 <colgroup> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$datalist':

			documentation = {

				description:'A layout object with type:$datalist represents an HTML 5 <datalist> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$dd':

			documentation = {

				description:'A layout object with type:$dd represents an HTML 5 <dd> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$del':

			documentation = {

				description:'A layout object with type:$del represents an HTML 5 <del> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'cite',type:'string',refreshable:true, description:'Specifies the source of the quotation'},

					{name:'datetime',type:'string',refreshable:true, description:'Gives the date-time being specified. Otherwise, the date-time is given by the element contents'}

				]

			};

			break;

		case '$details':

			documentation = {

				description:'A layout object with type:$details represents an HTML 5 <details> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'open',type:'boolean',refreshable:true, description:'Specifies that the element is active and fully available to the user'}

				]

			};

			break;

		case '$dfn':

			documentation = {

				description:'A layout object with type:$dfn represents an HTML 5 <dfn> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$dialog':

			documentation = {

				description:'A layout object with type:$dialog represents an HTML 5 <dialog> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'open',type:'boolean',refreshable:true, description:'Specifies that the element is active and fully available to the user'}

				]

			};

			break;

		case '$div':

			documentation = {

				description:'A layout object with type:$div represents an HTML 5 <div> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$dl':

			documentation = {

				description:'A layout object with type:$dl represents an HTML 5 <dl> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$dt':

			documentation = {

				description:'A layout object with type:$dt represents an HTML 5 <dt> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$em':

			documentation = {

				description:'A layout object with type:$em represents an HTML 5 <em> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$embed':

			documentation = {

				description:'A layout object with type:$embed represents an HTML 5 <embed> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'mimeType',type:'string',refreshable:true, description:'Specifies the MIME type of the linked document'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$fieldset':

			documentation = {

				description:'A layout object with type:$fieldset represents an HTML 5 <fieldset> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'}

				]

			};

			break;

		case '$figcaption':

			documentation = {

				description:'A layout object with type:$figcaption represents an HTML 5 <figcaption> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$figure':

			documentation = {

				description:'A layout object with type:$figure represents an HTML 5 <figure> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$footer':

			documentation = {

				description:'A layout object with type:$footer represents an HTML 5 <footer> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$form':

			documentation = {

				description:'A layout object with type:$form represents an HTML 5 <form> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'acceptCharset',type:'string',refreshable:true, description:'Specifies the character encodings that are to be used for the form submission'},

					{name:'action',type:'string',refreshable:true, description:'Specifies where to send the form-data when a form is submitted'},

					{name:'autocomplete',type:'string',values:['on','off'],refreshable:true, description:'Specifies whether a form should have autocomplete on or off'},

					{name:'enctype',type:'string',values:['text//plain','multipart//form-data','application//x-www-form-urlencoded'],refreshable:true, description:'Specifies how the form-data should be encoded when submitting it to the server (only for method="post")'},

					{name:'method',type:'string',values:['get','post'],refreshable:true, description:'Specifies the HTTP method to use when sending form-data'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'novalidate',type:'boolean',refreshable:true, description:'Specifies that the form should not be validated when submitted'},

					{name:'target',type:'string',values:['_blank','_parent','_self','_top'],refreshable:true, description:'Specifies where to display the response that is received after submitting the form'}

				]

			};

			break;

		case '$h1':

			documentation = {

				description:'A layout object with type:$h1 represents an HTML 5 <h1> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$h2':

			documentation = {

				description:'A layout object with type:$h2 represents an HTML 5 <h2> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$h3':

			documentation = {

				description:'A layout object with type:$h3 represents an HTML 5 <h3> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$h4':

			documentation = {

				description:'A layout object with type:$h4 represents an HTML 5 <h4> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$h5':

			documentation = {

				description:'A layout object with type:$h5 represents an HTML 5 <h5> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$h6':

			documentation = {

				description:'A layout object with type:$h6 represents an HTML 5 <h6> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$header':

			documentation = {

				description:'A layout object with type:$header represents an HTML 5 <header> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$hr':

			documentation = {

				description:'A layout object with type:$hr represents an HTML 5 <hr> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$i':

			documentation = {

				description:'A layout object with type:$i represents an HTML 5 <i> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$iframe':

			documentation = {

				description:'A layout object with type:$iframe represents an HTML 5 <iframe> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'sandbox',type:'string',values:['','allow-forms','allow-same-origin','allow-scripts','allow-top-navigation'],refreshable:true, description:'Enables a set of extra restrictions for the content in the <iframe>'},

					{name:'seamless',type:'boolean',refreshable:true, description:'Specifies that the <iframe> should look like it is a part of the containing document'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'srcdoc',type:'string',refreshable:true, description:'Specifies the HTML content of the page to show in the <iframe>'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$img':

			documentation = {

				description:'A layout object with type:$img represents an HTML 5 <img> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'alt',type:'string',refreshable:true, description:'Specifies an alternate text when an image cannot be rendered'},

					{name:'crossorigin',type:'string',values:['anonymous','use-credentials'],refreshable:true, description:'Allow images from third-party sites that allow cross-origin access to be used with canvas'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'ismap',type:'boolean',refreshable:true, description:'Specifies an image as a server-side image-map'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'usemap',type:'string',refreshable:true, description:'Specifies an image as a client-side image-map'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$input':

			documentation = {

				description:'A layout object with type:$input represents an HTML 5 <input> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'accept',type:'string',values:['audio//*','video//*','image//*'],refreshable:true, description:'Specifies the types of files that the server accepts (only for file inputTypes)'},

					{name:'alt',type:'string',refreshable:true, description:'Specifies an alternate text when an image cannot be rendered'},

					{name:'autocomplete',type:'string',values:['on','off'],refreshable:true, description:'Specifies whether a form should have autocomplete on or off'},

					{name:'autofocus',type:'boolean',refreshable:true, description:'Specifies that the control should automatically get focus when the page loads'},

					{name:'checked',type:'boolean',refreshable:true, description:'Specifies that a control should be pre-selected when the page loads (for type="checkbox" or type="radio")'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'formaction',type:'string',refreshable:true, description:'Specifies where to send the form-data when a form is submitted. Only for type of "submit"'},

					{name:'formenctype',type:'string',values:['text//plain','multipart//form-data','application//x-www-form-urlencoded'],refreshable:true, description:'Specifies how form-data should be encoded before sending it to a server. Only for type of "submit"'},

					{name:'formmethod',type:'string',values:['get','post'],refreshable:true, description:'Specifies how to send the form-data (which HTTP method to use). Only for type of "submit"'},

					{name:'formnovalidate',type:'boolean',refreshable:true, description:'Specifies that the form-data should not be validated on submission. Only for type of "submit"'},

					{name:'formtarget',type:'string',values:['_blank','_self','_parent','_top'],refreshable:true, description:'Specifies where to display the response after submitting the form. Only for type of "submit"'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'list',type:'string',refreshable:true, description:'Refers to the key of a <datalist> element that contains pre-defined options for an <input> element'},

					{name:'max',type:'string',refreshable:true, description:'Specifies the maximum value of the range'},

					{name:'maxlength',type:'string',refreshable:true, description:'Specifies the maximum number of characters allowed in the element'},

					{name:'min',type:'string',refreshable:true, description:'Specifies the minimum value of the range'},

					{name:'multiple',type:'boolean',refreshable:true, description:'Specifies that multiple options can be selected at once'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'pattern',type:'string',refreshable:true, description:'Specifies a regular expression that the value of an <input> element is checked against'},

					{name:'placeholder',type:'string',refreshable:true, description:'Specifies a short hint that describes the expected value of the element'},

					{name:'readonly',type:'boolean',refreshable:true, description:'Specifies that the text should be read-only from the user perspective'},

					{name:'required',type:'boolean',refreshable:true, description:'Specifies that a value is required or must be filled out'},

					{name:'size',type:'string',refreshable:true, description:'Specifies the width, in characters, of the element'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'step',type:'string',refreshable:true, description:'Specifies the legal number intervals for an input field'},

					{name:'inputType',type:'string',values:['button','checkbox','color','date','datetime','datetime-local','email','file','hidden','image','month','number','password','radio','range','reset','search','submit','tel','text','time','url','week'],refreshable:true, description:'Specifies the type input tag element to display'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$ins':

			documentation = {

				description:'A layout object with type:$ins represents an HTML 5 <ins> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'cite',type:'string',refreshable:true, description:'Specifies the source of the quotation'},

					{name:'datetime',type:'string',refreshable:true, description:'Gives the date-time being specified. Otherwise, the date-time is given by the element contents'}

				]

			};

			break;

		case '$kbd':

			documentation = {

				description:'A layout object with type:$kbd represents an HTML 5 <kbd> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$keygen':

			documentation = {

				description:'A layout object with type:$keygen represents an HTML 5 <keygen> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'autofocus',type:'boolean',refreshable:true, description:'Specifies that the control should automatically get focus when the page loads'},

					{name:'challenge',type:'boolean',refreshable:true, description:'Specifies that the value of the element should be challenged when submitted'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'keyType',type:'string',values:['rsa','dsa','ec'],refreshable:true, description:'Specifies the security algorithm of the key'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'}

				]

			};

			break;

		case '$label':

			documentation = {

				description:'A layout object with type:$label represents an HTML 5 <label> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'forInput',type:'string',refreshable:true, description:'Specifies which form element a label is bound to by key name'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'}

				]

			};

			break;

		case '$legend':

			documentation = {

				description:'A layout object with type:$legend represents an HTML 5 <legend> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$li':

			documentation = {

				description:'A layout object with type:$li represents an HTML 5 <li> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$main':

			documentation = {

				description:'A layout object with type:$main represents an HTML 5 <main> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$map':

			documentation = {

				description:'A layout object with type:$map represents an HTML 5 <map> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'}

				]

			};

			break;

		case '$mark':

			documentation = {

				description:'A layout object with type:$mark represents an HTML 5 <mark> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$menu':

			documentation = {

				description:'A layout object with type:$menu represents an HTML 5 <menu> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'label',type:'string',refreshable:true, description:'Specifies a visible label for the element'},

					{name:'menuType',type:'string',values:['context','toolbar','list'],refreshable:true, description:'Specifies which type of menu to display. Default value is "list"'}

				]

			};

			break;

		case '$meter':

			documentation = {

				description:'A layout object with type:$meter represents an HTML 5 <meter> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'high',type:'string',refreshable:true, description:'Specifies the range that is considered to be a high value'},

					{name:'low',type:'string',refreshable:true, description:'Specifies the range that is considered to be a low value'},

					{name:'max',type:'string',refreshable:true, description:'Specifies the maximum value of the range'},

					{name:'min',type:'string',refreshable:true, description:'Specifies the minimum value of the range'},

					{name:'optimum',type:'string',refreshable:true, description:'Specifies what value is the optimal value for the gauge'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$nav':

			documentation = {

				description:'A layout object with type:$nav represents an HTML 5 <nav> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$object':

			documentation = {

				description:'A layout object with type:$object represents an HTML 5 <object> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'data',type:'string',refreshable:true, description:'Specifies the URL of the resource to be used by the object'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'mimeType',type:'string',refreshable:true, description:'Specifies the MIME type of the linked document'},

					{name:'usemap',type:'string',refreshable:true, description:'Specifies an image as a client-side image-map'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$ol':

			documentation = {

				description:'A layout object with type:$ol represents an HTML 5 <ol> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'reversed',type:'boolean',refreshable:true, description:'Specifies that the list order should be descending (9,8,7...)'},

					{name:'start',type:'string',refreshable:true, description:'Specifies the start value of an ordered list'},

					{name:'numberingScheme',type:'string',values:['1','A','a','I','i'],refreshable:true, description:'Specifies the kind of marker to use in the list'}

				]

			};

			break;

		case '$optgroup':

			documentation = {

				description:'A layout object with type:$optgroup represents an HTML 5 <optgroup> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'label',type:'string',refreshable:true, description:'Specifies a visible label for the element'}

				]

			};

			break;

		case '$option':

			documentation = {

				description:'A layout object with type:$option represents an HTML 5 <option> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'label',type:'string',refreshable:true, description:'Specifies a visible label for the element'},

					{name:'selected',type:'boolean',refreshable:true, description:'Specifies that an option should be pre-selected when the page loads'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$output':

			documentation = {

				description:'A layout object with type:$output represents an HTML 5 <output> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'forInput',type:'string',refreshable:true, description:'Specifies which form element a label is bound to by key name'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'}

				]

			};

			break;

		case '$p':

			documentation = {

				description:'A layout object with type:$p represents an HTML 5 <p> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$param':

			documentation = {

				description:'A layout object with type:$param represents an HTML 5 <param> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$pre':

			documentation = {

				description:'A layout object with type:$pre represents an HTML 5 <pre> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$progress':

			documentation = {

				description:'A layout object with type:$progress represents an HTML 5 <progress> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'max',type:'string',refreshable:true, description:'Specifies the maximum value of the range'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$q':

			documentation = {

				description:'A layout object with type:$q represents an HTML 5 <q> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'cite',type:'string',refreshable:true, description:'Specifies the source of the quotation'}

				]

			};

			break;

		case '$rp':

			documentation = {

				description:'A layout object with type:$rp represents an HTML 5 <rp> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$rt':

			documentation = {

				description:'A layout object with type:$rt represents an HTML 5 <rt> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$ruby':

			documentation = {

				description:'A layout object with type:$ruby represents an HTML 5 <ruby> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$s':

			documentation = {

				description:'A layout object with type:$s represents an HTML 5 <s> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$samp':

			documentation = {

				description:'A layout object with type:$samp represents an HTML 5 <samp> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$section':

			documentation = {

				description:'A layout object with type:$section represents an HTML 5 <section> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$select':

			documentation = {

				description:'A layout object with type:$select represents an HTML 5 <select> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'autofocus',type:'boolean',refreshable:true, description:'Specifies that the control should automatically get focus when the page loads'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'multiple',type:'boolean',refreshable:true, description:'Specifies that multiple options can be selected at once'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'required',type:'boolean',refreshable:true, description:'Specifies that a value is required or must be filled out'},

					{name:'size',type:'string',refreshable:true, description:'Specifies the width, in characters, of the element'},

					{name:'value',type:'string',refreshable:true, description:'Specifies the nominal value of the element'}

				]

			};

			break;

		case '$small':

			documentation = {

				description:'A layout object with type:$small represents an HTML 5 <small> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$source':

			documentation = {

				description:'A layout object with type:$source represents an HTML 5 <source> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'media',type:'string',refreshable:true, description:'Specifies the type of media resource'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'mimeType',type:'string',refreshable:true, description:'Specifies the MIME type of the linked document'}

				]

			};

			break;

		case '$span':

			documentation = {

				description:'A layout object with type:$span represents an HTML 5 <span> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$strong':

			documentation = {

				description:'A layout object with type:$strong represents an HTML 5 <strong> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$sub':

			documentation = {

				description:'A layout object with type:$sub represents an HTML 5 <sub> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$summary':

			documentation = {

				description:'A layout object with type:$summary represents an HTML 5 <summary> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$sup':

			documentation = {

				description:'A layout object with type:$sup represents an HTML 5 <sup> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$table':

			documentation = {

				description:'A layout object with type:$table represents an HTML 5 <table> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'sortable',type:'boolean',refreshable:true, description:'Specifies that the table should be sortable'}

				]

			};

			break;

		case '$tbody':

			documentation = {

				description:'A layout object with type:$tbody represents an HTML 5 <tbody> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$td':

			documentation = {

				description:'A layout object with type:$td represents an HTML 5 <td> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'colspan',type:'string',refreshable:true, description:'Specifies the number of columns a header cell should span'},

					{name:'headers',type:'string',refreshable:true, description:'Specifies one or more header cells a cell is related to'},

					{name:'rowspan',type:'string',refreshable:true, description:'Sets the number of rows a cell should span'}

				]

			};

			break;

		case '$textarea':

			documentation = {

				description:'A layout object with type:$textarea represents an HTML 5 <textarea> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'autofocus',type:'boolean',refreshable:true, description:'Specifies that the control should automatically get focus when the page loads'},

					{name:'cols',type:'string',refreshable:true, description:'Specifies the visible width of a text area'},

					{name:'disabled',type:'boolean',refreshable:true, description:'Specifies that an input control should be disabled'},

					{name:'form',type:'string',refreshable:true, description:'Specifies one or more forms the control belongs to'},

					{name:'maxlength',type:'string',refreshable:true, description:'Specifies the maximum number of characters allowed in the element'},

					{name:'name',type:'string',refreshable:true, description:'Specifies the logical name to be associated with the value of the element'},

					{name:'placeholder',type:'string',refreshable:true, description:'Specifies a short hint that describes the expected value of the element'},

					{name:'readonly',type:'boolean',refreshable:true, description:'Specifies that the text should be read-only from the user perspective'},

					{name:'required',type:'boolean',refreshable:true, description:'Specifies that a value is required or must be filled out'},

					{name:'rows',type:'string',refreshable:true, description:'Specifies the visible number of lines in a text area'},

					{name:'wrap',type:'string',values:['hard','soft'],refreshable:true, description:'Specifies how the text in a text area is to be wrapped when submitted in a form'}

				]

			};

			break;

		case '$tfoot':

			documentation = {

				description:'A layout object with type:$tfoot represents an HTML 5 <tfoot> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$th':

			documentation = {

				description:'A layout object with type:$th represents an HTML 5 <th> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'colspan',type:'string',refreshable:true, description:'Specifies the number of columns a header cell should span'},

					{name:'headers',type:'string',refreshable:true, description:'Specifies one or more header cells a cell is related to'},

					{name:'rowspan',type:'string',refreshable:true, description:'Sets the number of rows a cell should span'}

				]

			};

			break;

		case '$thead':

			documentation = {

				description:'A layout object with type:$thead represents an HTML 5 <thead> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$time':

			documentation = {

				description:'A layout object with type:$time represents an HTML 5 <time> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'datetime',type:'string',refreshable:true, description:'Gives the date-time being specified. Otherwise, the date-time is given by the element contents'}

				]

			};

			break;

		case '$tr':

			documentation = {

				description:'A layout object with type:$tr represents an HTML 5 <tr> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$track':

			documentation = {

				description:'A layout object with type:$track represents an HTML 5 <track> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'defaultTrack',type:'boolean',refreshable:true, description:'Specifies that the track is to be enabled if the user preferences do not indicate that another track would be more appropriate'},

					{name:'kind',type:'string',values:['captions','chapters','descriptions','metadata','subtitles'],refreshable:true, description:'Specifies the kind of text track'},

					{name:'label',type:'string',refreshable:true, description:'Specifies a visible label for the element'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'srclang',type:'string',refreshable:true, description:''}

				]

			};

			break;

		case '$u':

			documentation = {

				description:'A layout object with type:$u represents an HTML 5 <u> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$ul':

			documentation = {

				description:'A layout object with type:$ul represents an HTML 5 <ul> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$var':

			documentation = {

				description:'A layout object with type:$var represents an HTML 5 <var> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

		case '$video':

			documentation = {

				description:'A layout object with type:$video represents an HTML 5 <video> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'},

					{name:'autoplay',type:'boolean',refreshable:true, description:'Specifies that the media will start playing as soon as it is ready'},

					{name:'controls',type:'boolean',refreshable:true, description:'Specifies that controls should be displayed (such as a play/pause button etc).'},

					{name:'height',type:'string',refreshable:true, description:'Specifies the height of the element in pixels'},

					{name:'loop',type:'boolean',refreshable:true, description:'Specifies that the media will start over again, every time it is finished'},

					{name:'muted',type:'boolean',refreshable:true, description:'Specifies that the audio output should be muted'},

					{name:'poster',type:'string',refreshable:true, description:'Specifies an image to be shown while the video is downloading, or until the user hits the play button'},

					{name:'preload',type:'string',values:['auto','metadata','none'],refreshable:true, description:'Specifies if and how the author thinks the media should be loaded when the page loads'},

					{name:'src',type:'string',refreshable:true, description:'Specifies the address of the document to embed'},

					{name:'width',type:'string',refreshable:true, description:'Specifies the width of the element in pixels'}

				]

			};

			break;

		case '$wbr':

			documentation = {

				description:'A layout object with type:$wbr represents an HTML 5 <wbr> element',

				attributes:[

					{name:'children',type:'array',refreshable:false, description:'An array of layout objects. These can be layout objects defined by the same plugin, layout objects defined by other plugins, or a mix.'},

					{name:'$content',type:'string',refreshable:true, description:'Custom text content to display within this item.'},

					{name:'$extra',type:'object',refreshable:true, description:'Additional attribute-value pairs to project as part of this item.'},

					{name:'$ignoreChange',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of onchange handlers (if any).'},

					{name:'$ignoreSelect',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},

					{name:'$ignoreEvent',type:'boolean',values:['true','false'],refreshable:true, description:'If true, suppress DOM projection of any custom event handlers.'},

					{name:'key',type:'string',refreshable:false, description:'Unique key that identifies this layout object'},

					{name:'accesskey',type:'string',refreshable:true, description:'Specifies a shortcut key to activate or focus an element'},

					{name:'cssClass',type:'string',refreshable:true, description:'Specifies a classname for an element (refers to a class in a style sheet)'},

					{name:'contenteditable',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the content of an element is editable or not'},

					{name:'dir',type:'string',values:['ltr','rtl','auto'],refreshable:true, description:'Specifies the text direction for the content in an element'},

					{name:'draggable',type:'string',values:['true','false','auto'],refreshable:true, description:'Specifies whether an element is draggable or not'},

					{name:'hidden',type:'boolean',refreshable:true, description:'Specifies that an element is not yet, or is no longer, relevant'},

					{name:'lang',type:'string',refreshable:true, description:'Specifies the language of the element contents'},

					{name:'spellcheck',type:'string',values:['true','false'],refreshable:true, description:'Specifies whether the element is to have its spelling and grammar checked or not'},

					{name:'style',type:'string',refreshable:true, description:'Specifies an inline CSS style for an element'},

					{name:'tabindex',type:'string',refreshable:true, description:'Specifies the tabbing order of an element'},

					{name:'title',type:'string',refreshable:true, description:'Specifies extra information about an element'},

					{name:'translate',type:'string',values:['yes','no'],refreshable:true, description:'Specifies whether the content of an element should be translated or not'}

				]

			};

			break;

	}

	return documentation;
}

}
