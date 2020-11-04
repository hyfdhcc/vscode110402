Class %ZEN.Mojo.Plugin.dojoDijitHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
		case '$AccordionContainer':
			documentation = {
				description:'The $AccordionContainer object represents a Dojo Dijit AccordionContainer. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'duration',type:'number',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'persist',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$BorderContainer':
			documentation = {
				description:'The $BorderContainer object represents a Dojo Dijit BorderContainer. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'design',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'gutters',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'liveSplitters',type:'boolean',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'persist',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$Button':
			documentation = {
				description:'The $Button object represents a Dojo Dijit Button. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type attribute of the Button object.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showLabel',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$CheckBox':
			documentation = {
				description:'The $CheckBox object represents a Dojo Dijit CheckBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'checked',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showLabel',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$CheckedMenuItem':
			documentation = {
				description:'The $CheckedMenuItem object represents a Dojo Dijit CheckedMenuItem. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accelKey',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'checked',type:'boolean',description:''},
					{name:'checkedChar',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'role',type:'string',description:''},
					{name:'shortcutKey',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$ColorPalette':
			documentation = {
				description:'The $ColorPalette object represents a Dojo Dijit ColorPalette. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'cellClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'defaultTimeout',type:'number',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'palette',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'timeoutChangeRate',type:'number',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$ComboBox':
			documentation = {
				description:'The $ComboBox object represents a Dojo Dijit ComboBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoComplete',type:'boolean',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'fetchProperties',type:'object',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'hasDownArrow',type:'boolean',description:''},
					{name:'highlightMatch',type:'string',description:''},
					{name:'ignoreCase',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'labelType',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowerCase',type:'boolean',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'pageSize',type:'number',description:''},
					{name:'pattern',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'query',type:'object',description:''},
					{name:'queryExpression',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'searchAttr',type:'string',description:''},
					{name:'searchDelay',type:'number',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'store',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$ComboButton':
			documentation = {
				description:'The $ComboButton object represents a Dojo Dijit ComboButton. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'name',type:'string',description:''},
					{name:'optionsTitle',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showLabel',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$ContentPane':
			documentation = {
				description:'The $ContentPane object represents a Dojo Dijit ContentPane. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$CurrencyTextBox':
			documentation = {
				description:'The $CurrencyTextBox object represents a Dojo Dijit CurrencyTextBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'currency',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'editOptions',type:'object',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type attribute of the CurrencyTextBox  object.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'pattern',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'rangeMessage',type:'string',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$DataList':
			documentation = {
				description:'The $DataList object represents a Dojo Dijit DataList. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'renderOptions',type:'object',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'valueList',type:'string',description:''},				]

			};
			break;

		case '$DateTextBox':
			documentation = {
				description:'The $DateTextBox object represents a Dojo Dijit DateTextBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'datePackage',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownDefaultValue',type:'string',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'hasDownArrow',type:'boolean',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type attribute of the Date object.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'rangeMessage',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$Dialog':
			documentation = {
				description:'The $Dialog object represents a Dojo Dijit Dialog. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'autofocus',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'draggable',type:'boolean',description:''},
					{name:'duration',type:'number',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxRatio',type:'number',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refocus',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$DojoxContentPane':
			documentation = {
				description:'The $DojoxContentPane object represents a Dojo Dijit DojoxContentPane. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'adjustPaths',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cleanContent',type:'boolean',description:''},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'executeScripts',type:'boolean',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'renderStyles',type:'boolean',description:''},
					{name:'scriptHasHooks',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$DropDownButton':
			documentation = {
				description:'The $DropDownButton object represents a Dojo Dijit DropDownButton. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'name',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showLabel',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$DropDownMenu':
			documentation = {
				description:'The $DropDownMenu object represents a Dojo Dijit DropDownMenu. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'autofocus',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'multiCharSearchDuration',type:'number',description:''},
					{name:'passivePopupDelay',type:'number',description:''},
					{name:'popupDelay',type:'number',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$Editor':
			documentation = {
				description:'The $Editor object represents a Dojo Dijit Editor. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'customUndo',type:'boolean',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'disableSpellCheck',type:'boolean',description:''},
					{name:'editActionInterval',type:'number',description:''},
					{name:'extraPlugins',type:'object',description:''},
					{name:'focusOnLoad',type:'boolean',description:''},
					{name:'height',type:'string',description:''},
					{name:'inheritWidth',type:'boolean',description:''},
					{name:'isTabIdent',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'minHeight',type:'string',description:''},
					{name:'name',type:'object',description:''},
					{name:'plugins',type:'object',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'styleSheets',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'updateInterval',type:'number',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$Fieldset':
			documentation = {
				description:'The $Fieldset object represents a Dojo Dijit Fieldset. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'duration',type:'number',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'open',type:'boolean',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'toggleable',type:'boolean',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$FilteringSelect':
			documentation = {
				description:'The $FilteringSelect object represents a Dojo Dijit FilteringSelect. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoComplete',type:'boolean',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'fetchProperties',type:'object',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'hasDownArrow',type:'boolean',description:''},
					{name:'highlightMatch',type:'string',description:''},
					{name:'ignoreCase',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'labelAttr',type:'object',description:''},
					{name:'labelType',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'pageSize',type:'number',description:''},
					{name:'pattern',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'query',type:'object',description:''},
					{name:'queryExpr',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'searchAttr',type:'string',description:''},
					{name:'searchDelay',type:'number',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'store',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$Form':
			documentation = {
				description:'The $Form object represents a Dojo Dijit Form. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accept',type:'object',description:''},
					{name:'accept-charset',type:'string',description:''},
					{name:'action',type:'object',description:''},
					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'encType',type:'object',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'method',type:'object',description:''},
					{name:'name',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'target',type:'object',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$HorizontalRule':
			documentation = {
				description:'The $HorizontalRule object represents a Dojo Dijit HorizontalRule. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'container',type:'string',description:''},
					{name:'count',type:'number',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'ruleStyle',type:'string',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$HorizontalRuleLabels':
			documentation = {
				description:'The $HorizontalRuleLabels object represents a Dojo Dijit HorizontalRuleLabels. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'container',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'labels',type:'object',description:''},
					{name:'labelStyle',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maximum',type:'number',description:''},
					{name:'minimum',type:'number',description:''},
					{name:'name',type:'string',description:''},
					{name:'numericMargin',type:'number',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'ruleStyle',type:'string',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$HorizontalSlider':
			documentation = {
				description:'The $HorizontalSlider object represents a Dojo Dijit HorizontalSlider. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'clickSelect',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'discreteValues',type:'number',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maximum',type:'number',description:''},
					{name:'minimum',type:'number',description:''},
					{name:'name',type:'string',description:''},
					{name:'pageIncrement',type:'number',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showButtons',type:'boolean',description:''},
					{name:'slideDuration',type:'number',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$InlineEditBox':
			documentation = {
				description:'The $InlineEditBox object represents a Dojo Dijit InlineEditBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'autoSave',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'buttonCancel',type:'string',description:''},
					{name:'buttonSave',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'editing',type:'boolean',description:''},
					{name:'editor',type:'string',description:''},
					{name:'editorParams',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'noValueIndicator',type:'string',description:''},
					{name:'renderAsHtml',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},
					{name:'width',type:'string',description:''},				]

			};
			break;

		case '$LayoutContainer':
			documentation = {
				description:'The $LayoutContainer object represents a Dojo Dijit LayoutContainer. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'design',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$LinkPane':
			documentation = {
				description:'The $LinkPane object represents a Dojo Dijit LinkPane. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'templateString',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$Menu':
			documentation = {
				description:'The $Menu object represents a Dojo Dijit Menu. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'autofocus',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'contextMenuForWindow',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'leftClickToOpen',type:'boolean',description:''},
					{name:'multiCharSearchDuration',type:'number',description:''},
					{name:'passivePopupDelay',type:'number',description:''},
					{name:'popupDelay',type:'number',description:''},
					{name:'refocus',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selector',type:'object',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$MenuBar':
			documentation = {
				description:'The $MenuBar object represents a Dojo Dijit MenuBar. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'autofocus',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'contextMenuForWindow',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'multiCharSearchDuration',type:'number',description:''},
					{name:'passivePopupDelay',type:'number',description:''},
					{name:'popupDelay',type:'number',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$MenuBarItem':
			documentation = {
				description:'The $MenuBarItem object represents a Dojo Dijit MenuBarItem. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accelKey',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'shortcutKey',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$MenuItem':
			documentation = {
				description:'The $MenuItem object represents a Dojo Dijit MenuItem. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accelKey',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'shortcutKey',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$MenuSeparator':
			documentation = {
				description:'The $MenuSeparator object represents a Dojo Dijit MenuSeparator. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$MultiSelect':
			documentation = {
				description:'The $MultiSelect object represents a Dojo Dijit MultiSelect. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'multiple',type:'boolean',description:''},
					{name:'name',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'size',type:'number',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$NumberSpinner':
			documentation = {
				description:'The $NumberSpinner object represents a Dojo Dijit NumberSpinner. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'defaultTimeout',type:'number',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'editOptions',type:'object',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'largeDelta',type:'number',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'minimumTimeout',type:'number',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'pattern',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'rangeMessage',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'smallDelta',type:'number',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'timeoutChangeRate',type:'number',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$NumberTextBox':
			documentation = {
				description:'The $NumberTextBox object represents a Dojo Dijit NumberTextBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'editOptions',type:'object',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'pattern',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'rangeMessage',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$PopupMenuBarItem':
			documentation = {
				description:'The $PopupMenuBarItem object represents a Dojo Dijit PopupMenuBarItem. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accelKey',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'shortcutKey',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$PopupMenuItem':
			documentation = {
				description:'The $PopupMenuItem object represents a Dojo Dijit PopupMenuItem. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accelKey',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'shortcutKey',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$ProgressBar':
			documentation = {
				description:'The $ProgressBar object represents a Dojo Dijit ProgressBar. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'indeterminate',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maximum',type:'number',description:''},
					{name:'places',type:'number',description:''},
					{name:'progress',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$RadioButton':
			documentation = {
				description:'The $RadioButton object represents a Dojo Dijit RadioButton. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'checked',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showLabel',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$RadioMenuItem':
			documentation = {
				description:'The $RadioMenuItem object represents a Dojo Dijit RadioMenuItem. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'accelKey',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'checked',type:'boolean',description:''},
					{name:'checkedChar',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'group',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'role',type:'string',description:''},
					{name:'shortcutKey',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$Select':
			documentation = {
				description:'The $Select object represents a Dojo Dijit Select. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'emptyLabel',type:'string',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'labelAttr',type:'object',description:''},
					{name:'lang',type:'string',description:''},
					{name:'loadChildrenOnOpen',type:'boolean',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'multiCharSearchDuration',type:'number',description:''},
					{name:'multiple',type:'boolean',description:''},
					{name:'name',type:'string',description:''},
					{name:'onFetch',type:'function',description:''},
					{name:'options',type:'object',description:''},
					{name:'query',type:'object',description:''},
					{name:'queryOptions',type:'object',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'sortByLabel',type:'boolean',description:''},
					{name:'store',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$SimpleTextarea':
			documentation = {
				description:'The $SimpleTextarea object represents a Dojo Dijit SimpleTextarea. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cols',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'rows',type:'number',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$SplitContainer':
			documentation = {
				description:'The $SplitContainer object represents a Dojo Dijit SplitContainer. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'activeSizing',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'orientation',type:'string',description:''},
					{name:'persist',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizerWidth',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$StackContainer':
			documentation = {
				description:'The $StackContainer object represents a Dojo Dijit StackContainer. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'persist',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$StoreMemory':
			documentation = {
				description:'The $StoreMemory object represents a Dojo Dijit StoreMemory. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'data',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'idProperty',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'parentAttribute',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$TabContainer':
			documentation = {
				description:'The $TabContainer object represents a Dojo Dijit TabContainer. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'nested',type:'boolean',description:''},
					{name:'persist',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabPosition',type:'string',description:''},
					{name:'tabStrip',type:'boolean',description:''},
					{name:'templateString',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'useMenu',type:'boolean',description:''},
					{name:'useSlider',type:'boolean',description:''},				]

			};
			break;

		case '$Textarea':
			documentation = {
				description:'The $Textarea object represents a Dojo Dijit Textarea. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cols',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'rows',type:'number',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$TextBox':
			documentation = {
				description:'The $TextBox object represents a Dojo Dijit TextBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$TimeTextBox':
			documentation = {
				description:'The $TimeTextBox object represents a Dojo Dijit TimeTextBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'autoWidth',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'datePackage',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'dropDownDefaultValue',type:'string',description:''},
					{name:'dropDownPosition',type:'object',description:''},
					{name:'forceWidth',type:'boolean',description:''},
					{name:'hasDownArrow',type:'boolean',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxHeight',type:'number',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'rangeMessage',type:'string',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$TitlePane':
			documentation = {
				description:'The $TitlePane object represents a Dojo Dijit TitlePane. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'duration',type:'number',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'open',type:'boolean',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'toggleable',type:'boolean',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$ToggleButton':
			documentation = {
				description:'The $ToggleButton object represents a Dojo Dijit ToggleButton. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'checked',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showLabel',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$Toolbar':
			documentation = {
				description:'The $Toolbar object represents a Dojo Dijit Toolbar. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'multiCharSearchDuration',type:'number',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$ToolbarSeparator':
			documentation = {
				description:'The $ToolbarSeparator object represents a Dojo Dijit ToolbarSeparator. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$Tooltip':
			documentation = {
				description:'The $Tooltip object represents a Dojo Dijit Tooltip. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'connectId',type:'string',description:''},
					{name:'defaultPosition',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'position',type:'object',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selector',type:'object',description:''},
					{name:'showDelay',type:'number',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$TooltipDialog':
			documentation = {
				description:'The $TooltipDialog object represents a Dojo Dijit TooltipDialog. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'closable',type:'boolean',description:''},
					{name:'content',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'doLayout',type:'boolean',description:''},
					{name:'errorMessage',type:'string',description:''},
					{name:'extractContent',type:'boolean',description:''},
					{name:'href',type:'string',description:''},
					{name:'iconClass',type:'string',description:''},
					{name:'ioArgs',type:'object',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'layoutPriority',type:'string',description:''},
					{name:'loadingMessage',type:'string',description:''},
					{name:'maxSize',type:'number',description:''},
					{name:'minSize',type:'number',description:''},
					{name:'parseOnLoad',type:'boolean',description:''},
					{name:'parserScope',type:'string',description:''},
					{name:'preload',type:'boolean',description:''},
					{name:'preventCache',type:'boolean',description:''},
					{name:'refreshOnShow',type:'boolean',description:''},
					{name:'region',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'selected',type:'boolean',description:''},
					{name:'showTitle',type:'boolean',description:''},
					{name:'sizeMin',type:'number',description:''},
					{name:'sizeShare',type:'number',description:''},
					{name:'splitter',type:'boolean',description:''},
					{name:'stopParser',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$Tree':
			documentation = {
				description:'The $Tree object represents a Dojo Dijit Tree. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'active',type:'boolean',description:''},
					{name:'autoExpand',type:'boolean',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'betweenThreshold',type:'number',description:''},
					{name:'checkAcceptance',type:'object',description:''},
					{name:'checkItemAcceptance',type:'object',description:''},
					{name:'childSelector',type:'string',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'dndParams',type:'object',description:''},
					{name:'dragThreshold',type:'number',description:''},
					{name:'getIconClass',type:'function',description:''},
					{name:'getIconStyle',type:'function',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'lang',type:'string',description:''},
					{name:'model',type:'string',description:''},
					{name:'multiCharSearchDuration',type:'number',description:''},
					{name:'onDndCancel',type:'boolean',description:''},
					{name:'onDndDrop',type:'boolean',description:''},
					{name:'openOnClick',type:'boolean',description:''},
					{name:'openOnDblClick',type:'boolean',description:''},
					{name:'path',type:'object',description:''},
					{name:'PathError',type:'object',description:''},
					{name:'paths',type:'object',description:''},
					{name:'persist',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'searchContainerNode',type:'boolean',description:''},
					{name:'selectedItem',type:'object',description:''},
					{name:'selectedItems',type:'object',description:''},
					{name:'showRoot',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$TreeObjectStoreModel':
			documentation = {
				description:'The $TreeObjectStoreModel object represents a Dojo Dijit TreeObjectStoreModel. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'baseClass',type:'string',description:''},
					{name:'dir',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'labelAttr',type:'object',description:''},
					{name:'labelType',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'mayHaveChildren',type:'function',description:''},
					{name:'query',type:'object',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'store',type:'string',description:''},
					{name:'style',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},				]

			};
			break;

		case '$ValidationTextBox':
			documentation = {
				description:'The $ValidationTextBox object represents a Dojo Dijit ValidationTextBox. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'inputType',type:'string',description:'Corresponds to the type option.'},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'invalidMessage',type:'string',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'lowercase',type:'boolean',description:''},
					{name:'maxLength',type:'string',description:''},
					{name:'message',type:'string',description:''},
					{name:'missingMessage',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'pattern',type:'string',description:''},
					{name:'placeHolder',type:'string',description:''},
					{name:'promptMessage',type:'string',description:''},
					{name:'propercase',type:'boolean',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'regExp',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'required',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'selectOnClick',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'tooltipPosition',type:'object',description:''},
					{name:'trim',type:'boolean',description:''},
					{name:'uppercase',type:'boolean',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$VerticalRule':
			documentation = {
				description:'The $VerticalRule object represents a Dojo Dijit VerticalRule. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'container',type:'string',description:''},
					{name:'count',type:'number',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'name',type:'string',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'ruleStyle',type:'string',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$VerticalRuleLabels':
			documentation = {
				description:'The $VerticalRuleLabels object represents a Dojo Dijit VerticalRuleLabels. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'constraints',type:'object',description:''},
					{name:'container',type:'string',description:''},
					{name:'count',type:'number',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'labels',type:'object',description:''},
					{name:'labelStyle',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maximum',type:'number',description:''},
					{name:'minimum',type:'number',description:''},
					{name:'name',type:'string',description:''},
					{name:'numericMargin',type:'number',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'ruleStyle',type:'string',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

		case '$VerticalSlider':
			documentation = {
				description:'The $VerticalSlider object represents a Dojo Dijit VerticalSlider. You can specify the following properties of this object. Except where noted, these properties correspond to options of the same name defined in the Dojo API.',

				attributes:[

					{name:'alt',type:'string',description:''},
					{name:'baseClass',type:'string',description:''},
					{name:'children',type:'array',description:'Child layout objects to contain within this widget. These can be layout objects defined by the same plugin (most common), layout objects defined by other plugins, or a mix.'},
					{name:'clickSelect',type:'boolean',description:''},
					{name:'cssStateNodes',type:'object',description:''},
					{name:'dir',type:'string',description:''},
					{name:'disabled',type:'boolean',description:''},
					{name:'discreteValues',type:'number',description:''},
					{name:'intermediateChanges',type:'boolean',description:''},
					{name:'key',type:'string',description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'label',type:'string',description:''},
					{name:'lang',type:'string',description:''},
					{name:'maximum',type:'number',description:''},
					{name:'minimum',type:'number',description:''},
					{name:'name',type:'string',description:''},
					{name:'pageIncrement',type:'number',description:''},
					{name:'readOnly',type:'boolean',description:''},
					{name:'renderInline',type:'boolean',description:''},
					{name:'scrollOnFocus',type:'boolean',description:''},
					{name:'showButtons',type:'boolean',description:''},
					{name:'slideDuration',type:'number',description:''},
					{name:'style',type:'string',description:''},
					{name:'tabIndex',type:'string',description:''},
					{name:'title',type:'string',description:''},
					{name:'tooltip',type:'string',description:''},
					{name:'value',type:'string',description:''},				]

			};
			break;

	}
	return documentation;
}

}
