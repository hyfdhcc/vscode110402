Class %ZEN.Mojo.Plugin.chuiHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
		case '$article':
			documentation = {
				description:'The $article object represents an HTML5 <article> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'title',type:'string',description:'Sets the title of the article. May be used for the navigation title by $navbar.'},				]

			};
			break;

		case '$aside':
			documentation = {
				description:'The $aside object represents an HTML5 <aside> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'nav',type:'boolean',description:''},
					{name:'showDetail',type:'boolean',description:''},					]

			};
			break;

		case '$button':
			documentation = {
				description:'The $button object represents an HTML5 button, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$div':
			documentation = {
				description:'The $div object represents an HTML5 <div> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$h1':
			documentation = {
				description:'The $h1 object represents an HTML5 <h1> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$h2':
			documentation = {
				description:'The $h2 object represents an HTML5 <h2> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$h3':
			documentation = {
				description:'The $h3 object represents an HTML5 <h3> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$h4':
			documentation = {
				description:'The $h4 object represents an HTML5 <h4> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$h5':
			documentation = {
				description:'The $h5 object represents an HTML5 <h5> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$link':
			documentation = {
				description:'The $link object represents an HTML5 link, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'href',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$list':
			documentation = {
				description:'The $list object represents an HTML5 <ul> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'switched',type:'boolean',description:''},				]

			};
			break;

		case '$listitem':
			documentation = {
				description:'The $listitem object represents an HTML5 <li> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'complex',type:'boolean',description:''},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'showDetail',type:'boolean',description:''},
					{name:'showNavigation',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$navbar':
			documentation = {
				description:'The $navbar object represents an HTML5 <nav> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'title',type:'string',description:''},				]

			};
			break;

		case '$p':
			documentation = {
				description:'The $p object represents an HTML5 <p> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'caption',type:'string',description:''},
					{name:'cssClass',type:'string',description:''},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

		case '$section':
			documentation = {
				description:'The $section object represents an HTML5 <section> tag, as rendered by the ChocolateChip-UI framework. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Chocolate-Chip UI API.',

				attributes:[

					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'hidden',type:'boolean',description:'If this property is true, Zen Mojo hides this layout object.'},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},				]

			};
			break;

	}
	return documentation;
}

}
