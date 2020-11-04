/// This plugin adds support for the dojo library. It was developed and tested with
/// dojo version 1.9
/// 
/// 1.0.10
/// 	- NAN026 - add support for $hide and $show to dojo plugin
/// 
/// 1.0.9
/// 	- minor fixes to $refresh logic
/// 
/// 1.0.8
/// 	- add support for $ignoreSelect and $ignoreChange
/// 
/// 1.0.7
/// 	- implement $refresh logic
/// 
/// 1.0.6
/// 	- correcting event handling in Firefox	
/// 
/// 1.0.5
/// 	- introducing library version in the classname
/// 
/// 1.0.4
/// 	- corrected apostrophe escaping for $StoreMemory
/// 
/// 1.0.3
/// 	- corrected some attribute settings to provide proper default values
/// 
/// 1.0.2
/// 	- decoupled documentation from plugin
/// 
Class %ZEN.Mojo.Plugin.dojo191DijitHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String(XMLPROJECTION = "NONE") [ InitialExpression = "dojo-1.9.1-DijitHelper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.10" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "dojo-1.9.1-DijitHelper";

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
	return [
		{identifier:'$AccordionContainer',},
		{identifier:'$BorderContainer'},
		{identifier:'$Button'},
		{identifier:'$CheckBox'},
		{identifier:'$CheckedMenuItem'},
		{identifier:'$ColorPalette'},
		{identifier:'$ComboBox'},
		{identifier:'$ComboButton'},
		{identifier:'$ContentPane'},
		{identifier:'$DojoxContentPane'},
		{identifier:'$CurrencyTextBox'},
		{identifier:'$DataList'},
		{identifier:'$DateTextBox'},
		{identifier:'$Dialog'},
		{identifier:'$DropDownButton'},
		{identifier:'$DropDownMenu'},
		{identifier:'$Editor'},
		{identifier:'$Fieldset'},
		{identifier:'$FilteringSelect'},
		{identifier:'$Form'},
		{identifier:'$HorizontalRule'},
		{identifier:'$HorizontalRuleLabels'},
		{identifier:'$HorizontalSlider'},
		{identifier:'$InlineEditBox'},
		{identifier:'$LayoutContainer'},
		{identifier:'$LinkPane'},
		{identifier:'$Menu'},
		{identifier:'$MenuBar'},
		{identifier:'$MenuBarItem'},
		{identifier:'$MenuItem'},
		{identifier:'$MenuSeparator'},
		{identifier:'$MultiSelect'},
		{identifier:'$NumberSpinner'},
		{identifier:'$NumberTextBox'},
		{identifier:'$PopupMenuBarItem'},
		{identifier:'$PopupMenuItem'},
		{identifier:'$ProgressBar'},
		{identifier:'$RadioButton'},
		{identifier:'$RadioMenuItem'},
		{identifier:'$Select'},
		{identifier:'$SimpleTextarea'},
		{identifier:'$SplitContainer'},
		{identifier:'$StackContainer'},
		{identifier:'$StoreMemory'},
		{identifier:'$TabContainer'},
		{identifier:'$Textarea'},
		{identifier:'$TextBox'},
		{identifier:'$TimeTextBox'},
		{identifier:'$TitlePane'},
		{identifier:'$ToggleButton'},
		{identifier:'$Toolbar'},
		{identifier:'$ToolbarSeparator'},
		{identifier:'$Tooltip'},
		{identifier:'$TooltipDialog'},
		{identifier:'$Tree'},
		{identifier:'$TreeObjectStoreModel'},
		{identifier:'$ValidationTextBox'},
		{identifier:'$VerticalRule'},
		{identifier:'$VerticalRuleLabels'},
		{identifier:'$VerticalSlider'},
	];
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	instance.$hasBlock = true;
	
	// if you want to render elements inline set renderInline:true
	if (zenGet(instance.renderInline,false)) {
		instance.$hasBlock = false;
	}
	
	instance.$showTitle = false;
	instance.$executeCodeBeforeChildren = this.linkDojoItem;
	instance.$getDojoItem = function() { return this.$dojoItem; };
	
	var defaultSetValue = function(value,notify) { 
		// set the value of the layout item
		this.value = value;
		// set the value of the dojo object
		this.$dojoItem.set('value',value);
	};
	
	var defaultGetValue = function() {
		// get the value of the dojo object
		return this.$dojoItem.get('value');
	};
	
	// indicate if this is a "loop"
	switch(type) {
		// fall through:
		case '$AccordionContainer':
		case '$BorderContainer':
		case '$ContentPane':
		case '$DojoxContentPane':
		case '$LayoutContainer':
			instance.$isLoop = true;
			instance.$children = [];
			break;
		default:
			break;
	}
	
	// use generic renderer
	instance.$render = this.renderGeneric;
	
	// use generic refresh
	instance.$refresh = this.refreshGeneric;
	
	// use generic hide
	instance.$hide = this.hideGeneric;
	
	// use generic show
	instance.$show = this.showGeneric;
	
	// apply value to instance
	instance.$applyChangeToInstance = function() {
		var length = this.$dojoProps.length;
		for (var i=0;i<length;i++) {
			var prop = this.$dojoProps[i];
			if (prop.synced) {
				var attributeName = prop.attribute;
				var value;
				if (prop.targetAttribute) {
					value = this.$dojoItem.get(prop.targetAttribute); 
				} else {
					value = this.$dojoItem.get(prop.attribute);
					
				}
				console.log('Updating ' + attributeName + ' to ' + value);
				this[attributeName] = value;
			}
		}		
	};
	
	// basic attributes to set
	instance.$dojoProps = [
		{attribute:'baseClass',type:'string',defaultValue:''},
		{attribute:'dir',type:'string',defaultValue:''},
		{attribute:'lang',type:'string',defaultValue:''},
		{attribute:'style',type:'string',defaultValue:''},
		{attribute:'title',type:'string',defaultValue:''},
		{attribute:'tooltip',type:'string',defaultValue:''},
	];
	
	// basic attributes for layout elements that can be a child of a layout element itself
	// like a container or a pane.
	var $dojoPropsBasicLayout = [
		{attribute:'closable',type:'boolean',defaultValue:''},
		{attribute:'disabled',type:'boolean',defaultValue:''},
		{attribute:'iconClass',type:'string',defaultValue:''},
		{attribute:'layoutPriority',type:'string',defaultValue:''},
		{attribute:'maxSize',type:'number',defaultValue:''},
		{attribute:'minSize',type:'number',defaultValue:''},
		{attribute:'region',type:'string',defaultValue:''},
		{attribute:'selected',type:'boolean',defaultValue:'',synced:true},
		{attribute:'sizeMin',type:'number',defaultValue:''},
		{attribute:'sizeShare',type:'number',defaultValue:''},
		{attribute:'showTitle',type:'boolean',defaultValue:''},
		{attribute:'splitter',type:'boolean',defaultValue:''},
	];
	
	// layout elements
	switch (type) {
		case '$AccordionContainer':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'duration',type:'number',defaultValue:''},
				{attribute:'persist',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/AccordionContainer';
			instance.$hasBlock = false;
			break;
		case '$BorderContainer':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'design',type:'string',defaultValue:''},
				{attribute:'gutters',type:'boolean',defaultValue:''},
				{attribute:'liveSplitters',type:'boolean',defaultValue:''},
				{attribute:'persist',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/BorderContainer';
			instance.$hasBlock = false;
			break;
		case '$ContentPane':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/ContentPane';
			instance.$hasBlock = false;
			break;
		case '$LayoutContainer':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'design',type:'string',defaultValue:''},
				{attribute:'region',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/LayoutContainer';
			instance.$hasBlock = false;
			break;
		case '$LinkPane':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
				{attribute:'templateString',type:'string',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$wrapperType = 'a';
			instance.$dojoType = 'dijit/layout/LinkPane';
			instance.$hasBlock = false;
			break;
		case '$SplitContainer':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'activeSizing',type:'string',defaultValue:''},
				{attribute:'orientation',type:'string',defaultValue:''},
				{attribute:'persist',type:'boolean',defaultValue:''},
				{attribute:'sizerWidth',type:'number',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/SplitContainer';
			instance.$hasBlock = false;
			break;
		case '$StackContainer':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'persist',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/StackContainer';
			instance.$hasBlock = false;
			break;
		case '$TabContainer':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'nested',type:'boolean',defaultValue:''},
				{attribute:'persist',type:'boolean',defaultValue:''},
				{attribute:'tabPosition',type:'string',defaultValue:''},
				{attribute:'tabStrip',type:'boolean',defaultValue:''},
				{attribute:'templateString',type:'string',defaultValue:''},
				{attribute:'useMenu',type:'boolean',defaultValue:''},
				{attribute:'useSlider',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/layout/TabContainer';
			instance.$hasBlock = false;
			break;
	}
	
	// basic attributes for form elements
	var $dojoPropsBasicForm = [
		{attribute:'alt',type:'string',defaultValue:''},
		{attribute:'disabled',type:'boolean',defaultValue:false},
		{attribute:'intermediateChanges',type:'boolean',defaultValue:false},
		{attribute:'label',type:'string',defaultValue:''},
		{attribute:'name',type:'string',defaultValue:''},
		{attribute:'scrollOnFocus',type:'boolean',defaultValue:true},
		{attribute:'tabIndex',type:'string',defaultValue:''},
		{attribute:'value',type:'string',defaultValue:'',synced:true},
	];
	
	// form elements
	switch (type) {
		case '$Button':
			instance.$dojoProps = instance.$dojoProps.concat([				
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'showLabel',type:'boolean',defaultValue:true},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'button'},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$wrapperType = 'button';
			instance.$dojoType = 'dijit/form/Button';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$CheckBox':
			instance.$dojoProps = instance.$dojoProps.concat([	
				{attribute:'checked',type:'boolean',defaultValue:'',synced:true},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:false},
				{attribute:'showLabel',type:'boolean',defaultValue:true},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/CheckBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$ComboBox':
			instance.$dojoProps = instance.$dojoProps.concat([	
				{attribute:'autoComplete',type:'boolean',defaultValue:''},
				{attribute:'autoWidth',type:'boolean',defaultValue:''},	
				{attribute:'constraints',type:'object',defaultValue:{}},				
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'fetchProperties',type:'object',defaultValue:{}},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'hasDownArrow',type:'boolean',defaultValue:''},
				{attribute:'highlightMatch',type:'string',defaultValue:''},	
				{attribute:'ignoreCase',type:'boolean',defaultValue:''},			
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'labelType',type:'string',defaultValue:''},
				{attribute:'lowerCase',type:'boolean',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},	
				{attribute:'message',type:'string',defaultValue:''},	
				{attribute:'missingMessage',type:'string',defaultValue:''},		
				{attribute:'pageSize',type:'number',defaultValue:''},
				{attribute:'pattern',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},	
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'query',type:'object',defaultValue:{}},		
				{attribute:'queryExpression',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},		
				{attribute:'regExp',type:'string',defaultValue:''},		
				{attribute:'required',type:'boolean',defaultValue:''},	
				{attribute:'searchAttr',type:'string',defaultValue:''},
				{attribute:'searchDelay',type:'number',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'store',type:'store',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},									
				{attribute:'trim',type:'boolean',defaultValue:false},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderLeadingLabelSpan = true;
			instance.$innerRender = this.renderOptions;
			instance.$wrapperType = 'select';
			instance.$wrapperTypeStore = 'input'
			instance.$dojoType = 'dijit/form/ComboBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$ComboButton':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autoWidth',type:'boolean',defaultValue:''},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'optionsTitle',type:'string',defaultValue:''},
				{attribute:'showLabel',type:'boolean',defaultValue:true},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderLabelSpan = true;
			instance.$wrapperType = 'button';
			instance.$dojoType = 'dijit/form/ComboButton';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$CurrencyTextBox':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'currency',type:'string',defaultValue:''},
				{attribute:'editOptions',type:'object',defaultValue:{}},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'pattern',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'rangeMessage',type:'string',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'text'},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/CurrencyTextBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$DataList':
			instance.$registerPublic = true;
			instance.$innerRender = this.renderOptions;
			instance.$wrapperType = 'select';
			instance.$dojoType = 'dijit/form/DataList';
			break;
		case '$DateTextBox':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autoWidth',type:'boolean',defaultValue:''},			
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'datePackage',type:'string',defaultValue:''},
				{attribute:'dropDownDefaultValue',type:'string',defaultValue:''},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'hasDownArrow',type:'boolean',defaultValue:''},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'rangeMessage',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'text'},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/DateTextBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$DropDownButton':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'autoWidth',type:'boolean',defaultValue:''},				
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'showLabel',type:'boolean',defaultValue:true},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderLabelSpan = true;
			instance.$wrapperType = 'div';
			instance.$dojoType = 'dijit/form/DropDownButton';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$FilteringSelect':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'autoComplete',type:'boolean',defaultValue:''},
				{attribute:'autoWidth',type:'boolean',defaultValue:''},						
				{attribute:'constraints',type:'object',defaultValue:{}},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'fetchProperties',type:'object',defaultValue:{}},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'hasDownArrow',type:'boolean',defaultValue:''},
				{attribute:'highlightMatch',type:'string',defaultValue:''},
				{attribute:'ignoreCase',type:'boolean',defaultValue:''},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'labelAttr',type:'object',defaultValue:{}},
				{attribute:'labelType',type:'object',defaultValue:{}},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'pageSize',type:'number',defaultValue:''},
				{attribute:'pattern',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'string',defaultValue:''},
				{attribute:'query',type:'object',defaultValue:{}},
				{attribute:'queryExpr',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'searchAttr',type:'string',defaultValue:''},
				{attribute:'searchDelay',type:'number',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'store',type:'store',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$innerRender = this.renderOptions;
			instance.$wrapperType = 'select';
			instance.$wrapperTypeStore = 'input'
			instance.$dojoType = 'dijit/form/FilteringSelect';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$Form':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'accept',type:'object',defaultValue:''},				
				{attribute:'accept-charset',type:'string',defaultValue:''},
				{attribute:'action',type:'object',defaultValue:{}},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'encType',type:'object',defaultValue:{}},
				{attribute:'method',type:'object',defaultValue:{}},
				{attribute:'target',type:'object',defaultValue:{}},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$hasBlock = false;
			instance.$wrapperType = 'div';
			instance.$dojoType = 'dijit/form/Form';
			break;
		case '$HorizontalRule':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'container',type:'string',defaultValue:''},				
				{attribute:'count',type:'number',defaultValue:''},
				{attribute:'ruleStyle',type:'string',defaultValue:''},
			]);
			instance.$hasBlock = false;
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoType = 'dijit/form/HorizontalRule';
			break;
		case '$HorizontalRuleLabels':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'container',type:'string',defaultValue:''},				
				{attribute:'count',type:'number',defaultValue:''},
				{attribute:'labels',type:'object',defaultValue:{}},
				{attribute:'labelStyle',type:'string',defaultValue:''},	
				{attribute:'maximum',type:'number',defaultValue:''},			
				{attribute:'minimum',type:'number',defaultValue:''},	
				{attribute:'numericMargin',type:'number',defaultValue:''},										
				{attribute:'ruleStyle',type:'string',defaultValue:''},
			]);
			instance.$hasBlock = false;
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$wrapperType = 'ol';
			instance.$dojoType = 'dijit/form/HorizontalRuleLabels';
			break;
		case '$HorizontalSlider':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'clickSelect',type:'boolean',defaultValue:''},				
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'discreteValues',type:'string',defaultValue:''},
				{attribute:'maximum',type:'number',defaultValue:''},			
				{attribute:'minimum',type:'number',defaultValue:''},
				{attribute:'pageIncrement',type:'number',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'showButtons',type:'boolean',defaultValue:''},
				{attribute:'slideDuration',type:'number',defaultValue:''},			
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$dojoType = 'dijit/form/HorizontalSlider';
			instance.$renderLeadingLabelSpan = true;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$MultiSelect':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'multiple',type:'boolean',defaultValue:true},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'size',type:'number',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$wrapperAttributes = [
				{attribute:'multiple',value:'multiple',defaultValue:true},
			];
			instance.$renderForLabel = true;
			instance.$innerRender = this.renderOptions;
			instance.$wrapperType = 'select';
			instance.$dojoType = 'dijit/form/MultiSelect';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$NumberSpinner':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'defaultTimeout',type:'number',defaultValue:''},
				{attribute:'editOptions',type:'object',defaultValue:{}},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'largeDelta',type:'number',defaultValue:''},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'minimumTimeout',type:'number',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'pattern',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'rangeMessage',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'smallDelta',type:'number',defaultValue:''},
				{attribute:'timeoutChangeRate',type:'number',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:''},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/NumberSpinner';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$NumberTextBox':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'editOptions',type:'object',defaultValue:{}},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'pattern',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'rangeMessage',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:''},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/NumberTextBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$RadioButton':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'checked',type:'boolean',defaultValue:'',synced:true},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'showLabel',type:'boolean',defaultValue:true},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'radio'},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$wrapperAttributes = [
				{attribute:'checked',value:'checked',defaultValue:false},
				{attribute:'name',value:'name',defaultValue:''},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/RadioButton';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$Select':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'autoWidth',type:'boolean',defaultValue:''},						
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'emptyLabel',type:'string',defaultValue:''},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'labelAttr',type:'object',defaultValue:{}},
				{attribute:'loadChildrenOnOpen',type:'boolean',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'multiCharSearchDuration',type:'number',defaultValue:''},
				{attribute:'multiple',type:'boolean',defaultValue:''},
				{attribute:'onFetch',type:'function',defaultValue:''},
				{attribute:'options',type:'object',defaultValue:{}},
				{attribute:'query',type:'object',defaultValue:{}},
				{attribute:'queryOptions',type:'object',defaultValue:{}},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'sortByLabel',type:'boolean',defaultValue:''},
				{attribute:'store',type:'string',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$innerRender = this.renderOptions;
			instance.$wrapperType = 'select';
			instance.$dojoType = 'dijit/form/Select';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$SimpleTextarea':
			instance.$dojoProps = instance.$dojoProps.concat([		
				{attribute:'cols',type:'string',defaultValue:''},	
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'rows',type:'number',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderLeadingLabelSpan = true;
			instance.$wrapperType = 'textarea';
			instance.$dojoType = 'dijit/form/SimpleTextarea';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$Textarea':
			instance.$dojoProps = instance.$dojoProps.concat([		
				{attribute:'cols',type:'string',defaultValue:''},	
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'rows',type:'number',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderLeadingLabelSpan = true;
			instance.$wrapperType = 'textarea';
			instance.$dojoType = 'dijit/form/Textarea';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$TextBox':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'text'},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/TextBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$TimeTextBox':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autoWidth',type:'boolean',defaultValue:''},			
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'datePackage',type:'string',defaultValue:''},
				{attribute:'dropDownDefaultValue',type:'string',defaultValue:''},
				{attribute:'dropDownPosition',type:'object',defaultValue:{}},
				{attribute:'forceWidth',type:'boolean',defaultValue:''},
				{attribute:'hasDownArrow',type:'boolean',defaultValue:''},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxHeight',type:'number',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'rangeMessage',type:'string',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'text'},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/TimeTextBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$ToggleButton':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'checked',type:'boolean',defaultValue:'',synced:true},	
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'iconClass',type:'string',defaultValue:'dijitCheckBoxIcon'},
				{attribute:'showLabel',type:'boolean',defaultValue:true},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'button'},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$wrapperType = 'button';
			instance.$dojoType = 'dijit/form/ToggleButton';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$ValidationTextBox':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'invalidMessage',type:'string',defaultValue:''},
				{attribute:'lowercase',type:'boolean',defaultValue:''},
				{attribute:'maxLength',type:'string',defaultValue:''},
				{attribute:'message',type:'string',defaultValue:''},
				{attribute:'missingMessage',type:'string',defaultValue:''},
				{attribute:'pattern',type:'string',defaultValue:''},
				{attribute:'placeHolder',type:'string',defaultValue:''},
				{attribute:'promptMessage',type:'string',defaultValue:''},
				{attribute:'propercase',type:'boolean',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'regExp',type:'string',defaultValue:''},
				{attribute:'required',type:'boolean',defaultValue:''},
				{attribute:'selectOnClick',type:'boolean',defaultValue:''},
				{attribute:'tooltipPosition',type:'object',defaultValue:{}},
				{attribute:'trim',type:'boolean',defaultValue:''},
				{targetAttribute:'type',attribute:'inputType',type:'string',defaultValue:'text'},
				{attribute:'uppercase',type:'boolean',defaultValue:''},
				
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$renderForLabel = true;
			instance.$wrapperType = 'input';
			instance.$dojoType = 'dijit/form/ValidationTextBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$VerticalRule':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'container',type:'string',defaultValue:''},				
				{attribute:'count',type:'number',defaultValue:''},
				{attribute:'ruleStyle',type:'string',defaultValue:''},
			]);
			instance.$hasBlock = false;
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoType = 'dijit/form/VerticalRule';
			break;
		case '$VerticalRuleLabels':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'constraints',type:'object',defaultValue:{}},			
				{attribute:'container',type:'string',defaultValue:''},				
				{attribute:'count',type:'number',defaultValue:''},
				{attribute:'labels',type:'object',defaultValue:{}},
				{attribute:'labelStyle',type:'string',defaultValue:''},	
				{attribute:'maximum',type:'number',defaultValue:''},			
				{attribute:'minimum',type:'number',defaultValue:''},	
				{attribute:'numericMargin',type:'number',defaultValue:''},										
				{attribute:'ruleStyle',type:'string',defaultValue:''},
			]);
			instance.$hasBlock = false;
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$wrapperType = 'ol';
			instance.$dojoType = 'dijit/form/VerticalRuleLabels';
			break;
		case '$VerticalSlider':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'clickSelect',type:'boolean',defaultValue:''},				
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'discreteValues',type:'string',defaultValue:''},
				{attribute:'maximum',type:'number',defaultValue:''},			
				{attribute:'minimum',type:'number',defaultValue:''},
				{attribute:'pageIncrement',type:'number',defaultValue:''},
				{attribute:'readOnly',type:'boolean',defaultValue:''},
				{attribute:'showButtons',type:'boolean',defaultValue:''},
				{attribute:'slideDuration',type:'number',defaultValue:''},			
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicForm);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$dojoType = 'dijit/form/VerticalSlider';
			instance.$renderLeadingLabelSpan = true;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
	}
	
	// generic elements
	switch (type) {
		case '$CheckedMenuItem':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'accelKey',type:'string',defaultValue:''},
				{attribute:'checked',type:'boolean',defaultValue:'',synced:true},
				{attribute:'checkedChar',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'role',type:'string',defaultValue:''},
				{attribute:'shortcutKey',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'}
			];
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/CheckedMenuItem';
			instance.$hasBlock = false;
			break;
		case '$ColorPalette':
			instance.$dojoProps = instance.$dojoProps.concat([			
				{attribute:'cellClass',type:'string',defaultValue:''},				
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'defaultTimeout',type:'number',defaultValue:''},
				{attribute:'palette',type:'string',defaultValue:''},			
				{attribute:'tabIndex',type:'string',defaultValue:''},
				{attribute:'timeoutChangeRate',type:'number',defaultValue:''},	
				{attribute:'value',type:'string',defaultValue:'',synced:true},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$dojoType = 'dijit/ColorPalette';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$Dialog':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autofocus',type:'boolean',defaultValue:''},
				{attribute:'closable',type:'boolean',defaultValue:''},
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'draggable',type:'boolean',defaultValue:''},
				{attribute:'duration',type:'number',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'maxRatio',type:'number',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refocus',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
			]);
			// don't need to register the dialog public, because we can call <docView>.getItemByKey(<key>).$dojoItem.show()
			//instance.$registerPublic = true;
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoType = 'dijit/Dialog';
			instance.$hasBlock = false;
			break;
		case '$DropDownMenu':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autofocus',type:'boolean',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'multiCharSearchDuration',type:'number',defaultValue:''},
				{attribute:'passivePopupDelay',type:'number',defaultValue:''},
				{attribute:'popupDelay',type:'number',defaultValue:''},
				{attribute:'selected',type:'object',defaultValue:{}},
				{attribute:'tabIndex',type:'string',defaultValue:''},
			]);
			instance.$dojoType = 'dijit/DropDownMenu';
			instance.$hasBlock = false;
			break;
		case '$Editor':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'customUndo',type:'boolean',defaultValue:''},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'disableSpellCheck',type:'boolean',defaultValue:''},
				{attribute:'editActionInterval',type:'number',defaultValue:''},
				{attribute:'extraPlugins',type:'object',defaultValue:{}},
				{attribute:'focusOnLoad',type:'boolean',defaultValue:''},
				{attribute:'height',type:'string',defaultValue:''},
				{attribute:'inheritWidth',type:'boolean',defaultValue:''},
				{attribute:'isTabIndent',type:'boolean',defaultValue:''},
				{attribute:'minHeight',type:'string',defaultValue:''},
				{attribute:'name',type:'object',defaultValue:{}},
				{attribute:'plugins',type:'object',defaultValue:{}},
				{attribute:'styleSheets',type:'string',defaultValue:''},
				{attribute:'updateInterval',type:'number',defaultValue:''},
				{attribute:'value',type:'string',defaultValue:'',synced:true},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$innerRender = this.renderP;
			instance.$dojoType = 'dijit/Editor';
			instance.$hasBlock = false;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$Fieldset':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'duration',type:'number',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'open',type:'boolean',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
				{attribute:'tabIndex',type:'string',defaultValue:''},
				{attribute:'toggleable',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoType = 'dijit/Fieldset';
			instance.$hasBlock = false;
			break;
		case '$InlineEditBox':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autoSave',type:'boolean',defaultValue:''},
				{attribute:'buttonCancel',type:'string',defaultValue:''},
				{attribute:'buttonSave',type:'string',defaultValue:''},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'editor',type:'editor',defaultValue:''},
				{attribute:'editing',type:'boolean',defaultValue:''},
				{attribute:'editorParams',type:'object',defaultValue:{}},
				{attribute:'noValueIndicator',type:'string',defaultValue:''},
				{attribute:'renderAsHtml',type:'boolean',defaultValue:''},
				{attribute:'value',type:'string',defaultValue:'',synced:true},
				{attribute:'width',type:'String',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
				{dojoEvt:'onChange',zenMojoEvt:'change'},
			];
			instance.$dojoType = 'dijit/InlineEditBox';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$Menu':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autoFocus',type:'boolean',defaultValue:''},
				{attribute:'contextMenuForWindow',type:'boolean',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'leftClickToOpen',type:'boolean',defaultValue:''},
				{attribute:'multiCharSearchDuration',type:'number',defaultValue:''},
				{attribute:'passivePopupDelay',type:'number',defaultValue:''},
				{attribute:'popupDelay',type:'number',defaultValue:''},
				{attribute:'refocus',type:'boolean',defaultValue:''},
				{attribute:'selector',type:'object',defaultValue:{}},
				{attribute:'tabIndex',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/Menu';
			instance.$hasBlock = false;
			break;
		case '$MenuBar':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'autoFocus',type:'boolean',defaultValue:''},
				{attribute:'contextMenuForWindow',type:'boolean',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'multiCharSearchDuration',type:'number',defaultValue:''},
				{attribute:'passivePopupDelay',type:'number',defaultValue:''},
				{attribute:'popupDelay',type:'number',defaultValue:''},
				{attribute:'tabIndex',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/MenuBar';
			instance.$hasBlock = false;
			break;
		case '$MenuBarItem':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'accelKey',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'shortcutKey',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/MenuBarItem';
			instance.$hasBlock = false;
			break;
		case '$MenuItem':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'accelKey',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'shortcutKey',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/MenuItem';
			instance.$hasBlock = false;
			break;
		case '$MenuSeparator':
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/MenuSeparator';
			instance.$hasBlock = false;
			break;
		case '$PopupMenuBarItem':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'accelKey',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'shortcutKey',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/PopupMenuBarItem';
			instance.$hasBlock = false;
			break;
		case '$PopupMenuItem':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'accelKey',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'shortcutKey',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/PopupMenuItem';
			instance.$hasBlock = false;
			break;
		case '$ProgressBar':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'indeterminate',type:'boolean',defaultValue:''},
				{attribute:'label',type:'object',defaultValue:{}},
				{attribute:'maximum',type:'number',defaultValue:''},
				{attribute:'places',type:'number',defaultValue:''},
				{attribute:'progress',type:'string',defaultValue:'',synced:true},
				{attribute:'value',type:'string',defaultValue:'',synced:true},
			]);
			instance.$dojoType = 'dijit/ProgressBar';
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$RadioMenuItem':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'accelKey',type:'string',defaultValue:''},
				{attribute:'checked',type:'boolean',defaultValue:'',synced:true},
				{attribute:'checkedChar',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'disabled',type:'boolean',defaultValue:''},
				{attribute:'group',type:'string',defaultValue:''},
				{attribute:'iconClass',type:'string',defaultValue:''},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'role',type:'string',defaultValue:''},
				{attribute:'shortcutKey',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/RadioMenuItem';
			instance.$hasBlock = false;
			break;
		case '$TitlePane':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'duration',type:'number',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'open',type:'boolean',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
				{attribute:'tabIndex',type:'string',defaultValue:''},
				{attribute:'toggleable',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoType = 'dijit/TitlePane';
			instance.$hasBlock = false;
			break;
		case '$Toolbar':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'multiCharSearchDuration',type:'number',defaultValue:''},
				{attribute:'tabIndex',type:'string',defaultValue:''},
			]);
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/Toolbar';
			instance.$hasBlock = false;
			break;
		case '$ToolbarSeparator':
			instance.$dojoEvents = [
				{dojoEvt:'onClick',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/ToolbarSeparator';
			instance.$hasBlock = false;
			break;
		case '$Tooltip':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'connectId',type:'connectId',defaultValue:''},
				{attribute:'defaultPosition',type:'object',defaultValue:{}},
				{attribute:'label',type:'string',defaultValue:''},
				{attribute:'position',type:'object',defaultValue:{}},
				{attribute:'selector',type:'object',defaultValue:{}},
				{attribute:'showDelay',type:'number',defaultValue:''},
			]);
			instance.$renderLabelSpan = true;
			instance.$dojoType = 'dijit/Tooltip';
			instance.$hasBlock = false;
			break;
		case '$TooltipDialog':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$dojoType = 'dijit/TooltipDialog';
			instance.$hasBlock = false;
			break;
		case '$Tree':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'active',type:'boolean',defaultValue:''},
				{attribute:'autoExpand',type:'boolean',defaultValue:''},
				{attribute:'betweenThreshold',type:'number',defaultValue:''},
				{attribute:'checkAcceptance',type:'object',defaultValue:{}},
				{attribute:'checkItemAcceptance',type:'object',defaultValue:{}},
				{attribute:'childSelector',type:'string',defaultValue:''},
				{attribute:'cssStateNodes',type:'object',defaultValue:{}},
				{attribute:'dndParams',type:'object',defaultValue:{}},
				{attribute:'dragThreshold',type:'number',defaultValue:''},
				{attribute:'getIconClass',type:'function',defaultValue:''},
				{attribute:'getIconStyle',type:'function',defaultValue:''},
				{attribute:'model',type:'model',defaultValue:{}},
				{attribute:'multiCharSearchDuration',type:'number',defaultValue:''},
				{attribute:'onDndCancel',type:'object',defaultValue:{}},
				{attribute:'onDndDrop',type:'object',defaultValue:{}},
				{attribute:'openOnClick',type:'boolean',defaultValue:''},
				{attribute:'openOnDblClick',type:'boolean',defaultValue:''},
				{attribute:'path',type:'object',defaultValue:{}},
				{attribute:'PathError',type:'object',defaultValue:{}},
				{attribute:'paths',type:'object',defaultValue:{}},
				{attribute:'persist',type:'boolean',defaultValue:''},
				{attribute:'searchContainerNode',type:'boolean',defaultValue:''},
				{attribute:'selectedItem',type:'object',defaultValue:{}},
				{attribute:'selectedItems',type:'object',defaultValue:{}},
				{attribute:'showRoot',type:'boolean',defaultValue:''},
				{attribute:'tabIndex',type:'string',defaultValue:''},
			]);
			instance.$dojoCustomEvents = [
				{dojoEvt:'onClick',customEvt:'zen(zenPage._$documentViewId).getItemByKey(\''+instance.key+'\').value = item.id;$$$event(\'click\');',args:['item','node','event']},
			];
			instance.$dojoType = 'dijit/Tree';
			instance.$hasBlock = false;
			break;	
		case '$TreeObjectStoreModel':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'labelAttr',type:'string',defaultValue:''},
				{attribute:'labelType',type:'string',defaultValue:''},
				{attribute:'mayHaveChildren',type:'function',defaultValue:''},
				{attribute:'query',type:'object',defaultValue:{}},
				{attribute:'store',type:'store',defaultValue:{}},
			]);
			
			//instance.$executeCodeAfterChildren = this.observeStore;
			instance.$registerPublic = true;
			instance.$getModel = function() { return eval(instance.$makeId('dojo')); };
			instance.$dojoType = 'dijit/tree/ObjectStoreModel';
			instance.$hasBlock = false;
			break;
	}
	
	// dojo types
	switch (type) {
		case '$StoreMemory':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'data',type:'object',defaultValue:{}},
				{attribute:'idProperty',type:'string',defaultValue:''},
			]);
			instance.$innerRender = this.renderStoreMethods;
			instance.$registerPublic = true;
			instance.$dojoType = 'dojo/store/Memory';
			instance.$hasBlock = false;
			instance.$getStore = function() { return eval(instance.$makeId('dojo')); };
			break;
	}
	
	// dojox types
	switch (type) {
		case '$DojoxContentPane':
			instance.$dojoProps = instance.$dojoProps.concat([
				{attribute:'adjustPaths',type:'boolean',defaultValue:''},
				{attribute:'cleanContent',type:'boolean',defaultValue:''},
				{attribute:'content',type:'string',defaultValue:''},
				{attribute:'doLayout',type:'boolean',defaultValue:''},
				{attribute:'errorMessage',type:'string',defaultValue:''},
				{attribute:'executeScripts',type:'boolean',defaultValue:''},
				{attribute:'extractContent',type:'boolean',defaultValue:''},
				{attribute:'href',type:'string',defaultValue:''},
				{attribute:'ioArgs',type:'object',defaultValue:{}},
				{attribute:'loadingMessage',type:'string',defaultValue:''},
				{attribute:'parseOnLoad',type:'boolean',defaultValue:''},
				{attribute:'parserScope',type:'string',defaultValue:''},
				{attribute:'preload',type:'boolean',defaultValue:''},
				{attribute:'preventCache',type:'boolean',defaultValue:''},
				{attribute:'refreshOnShow',type:'boolean',defaultValue:''},
				{attribute:'renderStyles',type:'boolean',defaultValue:''},
				{attribute:'scriptHasHooks',type:'boolean',defaultValue:''},
				{attribute:'stopParser',type:'boolean',defaultValue:''},
			]);
			instance.$dojoProps = instance.$dojoProps.concat($dojoPropsBasicLayout);
			instance.$dojoEvents = [
				//{dojoEvt:'onShow',zenMojoEvt:'click'},
			];
			instance.$registerPublic = true;
			instance.$dojoType = 'dojox/layout/ContentPane';
			instance.$hasBlock = false;
			break;
	}
	
	return null;
}

ClientMethod observeStore() [ Internal, Language = javascript ]
{
	// still prototype
	require(["dojo/store/Observable"], function(Observable) {
		var store = new Observable(this.$getModel().store);
		this.$getModel().set('store',store);
	});
}

ClientMethod linkDojoItem() [ Language = javascript ]
{
	var registry = require("dijit/registry");
	var item = registry.byId(this.$makeId('dojo'));
	this.$dojoItem = item;
}

/// Register a dojo type for the require call by specifying the instance
ClientMethod registerDojoType(instance) [ Language = javascript ]
{
	var documentView = instance.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(instance.$type);
	
	if (typeof plugin._registeredTypes == 'undefined') {
		plugin._registeredTypes = [];
	}
	
	if (typeof plugin._registeredTypes[documentView.currLevel] == 'undefined') {
		plugin._registeredTypes[documentView.currLevel] = [];
	}
	
	var thisLevel = plugin._registeredTypes[documentView.currLevel];
	
	if (thisLevel.indexOf(instance.$dojoType) == -1) {
		thisLevel.push(instance.$dojoType);
	}
	
	if (typeof instance.$additionalRequires != 'undefined') {
		for (var i = 0; i < instance.$additionalRequires.length; i++) {
			thisLevel.push(instance.$additionalRequires[i]);
		}
	}
}

/// Register a dojo type for the require call by specifying the type as string
ClientMethod registerDojoTypeByType(type) [ Language = javascript ]
{
	var documentView = this.$documentView;
	
	if (typeof this._registeredTypes == 'undefined') {
		this._registeredTypes = [];
	}
	
	if (typeof this._registeredTypes[documentView.currLevel] == 'undefined') {
		this._registeredTypes[documentView.currLevel] = [];
	}
	
	var thisLevel = this._registeredTypes[documentView.currLevel];
	
	if (thisLevel.indexOf(type) == -1) {
		thisLevel.push(type);
	}
}

ClientMethod getDojoTypes() [ Language = javascript ]
{
	
	if (typeof this._registeredTypes == 'undefined') {
		return [];
	}
	
	if (typeof this._registeredTypes[this.$documentView.currLevel] == 'undefined') {
		return [];
	}
	
	return this._registeredTypes[this.$documentView.currLevel];
}

ClientMethod addProp(properties, instance, property, propertyToAdd, type, defaultValue, refreshMode) [ Language = javascript ]
{
	var add = '';
	switch (type) {
		case 'boolean':
			add = (zenGet(instance[propertyToAdd],defaultValue) === true || zenGet(instance[propertyToAdd],defaultValue) === false) ? property + ':' + zenGet(instance[propertyToAdd],defaultValue) : '';
			if (add == '') {
				add = (zenGet(instance[propertyToAdd],defaultValue) === 1) ? property + ':' + true : '';
			}
			if (add == '') {
				add = (zenGet(instance[propertyToAdd],defaultValue) === 0) ? property + ':' + false : '';
			}
			break;
		case 'object':
			if (typeof zenGet(instance[propertyToAdd],defaultValue) === 'object') {
				add = (JSON.stringify(zenGet(instance[propertyToAdd],defaultValue)) !== '{}') ? property + ':' + JSON.stringify(zenGet(instance[propertyToAdd],defaultValue)).replace(/\"([^(\")"]+)\":/g,"$1:").replace(/'/g,"\\'").replace(/"/g,"\'") + '' : '';
			}
			break;
		case 'function':
			if (typeof zenGet(instance[propertyToAdd],defaultValue) === 'function') {
				add = (zenGet(instance[propertyToAdd],defaultValue) !== '') ? property + ':' + zenGet(instance[propertyToAdd],defaultValue) : '';
			} else if (typeof zenGet(instance[propertyToAdd],defaultValue) === 'string' && zenGet(instance[propertyToAdd],defaultValue).indexOf('function') > -1) {
				// this is a string function (may come from server)	
				var tempFunctionString = 'var tempFunction = ' + zenGet(instance[propertyToAdd],defaultValue);
				eval(tempFunctionString);
				add = property + ':' + tempFunction;
			}
			break;
		case 'number':
			add = (zenGet(instance[propertyToAdd],defaultValue) !== '') ? property + ':' + zenGet(instance[propertyToAdd],defaultValue) + '' : '';
			break;
		case 'connectId':
		case 'store':
		case 'model':
			if (zenGet(instance[propertyToAdd],defaultValue) !== '') {
				var key = zenGet(instance[propertyToAdd],defaultValue);
				var htmlId = instance.$documentView.getItemByKey(key).$makeId('dojo');
				add = property + ':' + htmlId;
			} 
			break;
		case 'editor':
			if (zenGet(instance[propertyToAdd],defaultValue) !== '') {
				this.registerDojoTypeByType(zenGet(instance[propertyToAdd],defaultValue));
			}
			//fallthrough
		default:
		case 'string':
			if (!refreshMode) {
				add = (zenGet(instance[propertyToAdd],defaultValue) !== '') ? property + ':\'' + zenEscapeJS(zenGet(instance[propertyToAdd],defaultValue)) + '\'' : '';
			} else {
				add = (zenGet(instance[propertyToAdd],defaultValue) !== '') ? property + ':' + zenEscapeJS(zenGet(instance[propertyToAdd],defaultValue)) : '';
			}
			break;
	}
	
	if (add != '') {
		properties.push(add);
	}
}

// ** render methods **

ClientMethod renderGeneric() [ Language = javascript ]
{
	var html = [];
	var props = [];
	var attributes = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	var hasStore = false;
	
	plugin.registerDojoType(this);
	
	if (this.$dojoProps) {
		for (var i = 0; i < this.$dojoProps.length; i++) {
			var prop = this.$dojoProps[i];
			var targetAttribute = zenGet(prop.targetAttribute,'') ? prop.targetAttribute : prop.attribute;
			plugin.addProp(props,this,targetAttribute,prop.attribute,prop.type,prop.defaultValue);
			if (prop.type == "store" && (zenGet(this[prop.attribute],prop.defaultValue) !== '')) {hasStore = true;}
		}
	}
	
	if (this.$dojoEvents) {
		var	pre = 'zenPage._$documentViewId = \'' + documentView.id + '\'; ';
		for (i = 0; i < this.$dojoEvents.length; i++) {
			var event = this.$dojoEvents[i];
			if ((event.dojoEvt==='onClick' && !this.$ignoreSelect) || (event.dojoEvt==='onChange' && !this.$ignoreChange)) {
				props.push(event.dojoEvt+':function(event) {'+pre+'$$$event(\''+event.zenMojoEvt+'\');}');
			}
		}
	}
	
	if (this.$dojoCustomEvents) {
		var	pre = 'zenPage._$documentViewId = \'' + documentView.id + '\'; ';
		for (i = 0; i < this.$dojoCustomEvents.length; i++) {
			var event = this.$dojoCustomEvents[i];
			var args = [];
			if (event.args) {
				for (var j = 0; j < event.args.length; j++) {
					args.push(event.args[j]);
				}	
			}
			if ((event.dojoEvt==='onClick' && !this.$ignoreSelect) || (event.dojoEvt==='onChange' && !this.$ignoreChange)) {
				props.push(event.dojoEvt+':function('+args.join(',')+') {'+pre+event.customEvt+'}');
			}
		}
	}
	
	if (this.$wrapperAttributes) {
		for (i = 0; i < this.$wrapperAttributes.length; i++) {
			var attribute = this.$wrapperAttributes[i];
			attributes.push(attribute.attribute + '="'+zenGet(this[attribute.value],zenGet(attribute.defaultValue,''))+'"');
		}
	}
	
	if (zenGet(this.$registerPublic,false)) {
		attributes.push('data-dojo-id="'+this.$makeId('dojo')+'"');
	}
	
	var wrapperType = (hasStore) ? zenGet(this.$wrapperTypeStore,'div') : zenGet(this.$wrapperType,'div');
	var labelClass = zenGet(this.labelClass,'');
	
	if (zenGet(this.$renderLeadingLabelSpan,false)) {
		html.push('<span id="'+this.$makeId('dojoLabel')+'" class="' + labelClass + '">'+zenEscapeXML(zenGet(this.label))+'</span>');
	}
	
	if (zenGet(this.$renderForLabel,false)) {
		html.push('<label id="'+this.$makeId('dojoLabel')+'" for="'+this.$makeId('dojo')+'" class="' + labelClass + '">'+zenEscapeXML(zenGet(this.label))+'</label>');
	}
	
	html.push('<'+wrapperType+' id="'+this.$makeId('dojo')+'" data-dojo-type="'+this.$dojoType+'" data-dojo-props="'+props.join()+'" '+attributes.join(' ')+' style="' + zenGet(this.style,'') + '">');
	
	if (zenGet(this.$renderLabelSpan,false)) {
		html.push('<span id="'+this.$makeId('dojoLabel')+'" class="' + labelClass + '">'+zenEscapeXML(zenGet(this.label))+'</span>');
	}
	
	if (this.$innerRender && !hasStore) {
		html.push(this.$innerRender());
	} else if (this.$innerRenderStore && hasStore) {
		html.push(this.$innerRenderStore());
	}
	
	// render children within the container
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</'+wrapperType+'>');
	
	var content = documentView.injectEventHandler(html.join(''),this);
	return content;
}

/// render inline script methods needed for the store api
ClientMethod renderStoreMethods() [ Language = javascript ]
{
	var html = [];
	html.push('<script type="dojo/method" data-dojo-event="getChildren" data-dojo-args="object">');
	html.push('return this.query({'+this.parentAttribute+': object.id});');
	html.push('</script>');
	return html.join('');
}

/// render <p> tags containing the value
ClientMethod renderP() [ Language = javascript ]
{
	var html = [];
	html.push('<p>');
	html.push(this.value);
	html.push('</p>');
	return html.join('');
}

/// render <option> tags based on the option list of the instance
ClientMethod renderOptions() [ Language = javascript ]
{
	var html = [];
	var values = (typeof this.value != 'undefined') ? this.value.split(',') : [];
	var list = this.$documentView.resolveOptionList(this);
	if (list && list.length) {
		for (var n = 0; n < list.length; n++) {
			var option = list[n];
			var selected = (values.indexOf(option.value.toString()) > -1) ? 'selected="selected"' : '';
			html.push('<option value="'+zenEscapeXML(option.value.toString())+'" '+selected+'>'+zenEscapeXML(option.text.toString())+'</option>');
		}
	}
	return html.join('');
}

ClientMethod refreshGeneric() [ Language = javascript ]
{
	var props = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	
	if (this.$dojoProps) {
		for (var i = 0; i < this.$dojoProps.length; i++) {
			var prop = this.$dojoProps[i];
			var targetAttribute = zenGet(prop.targetAttribute,'') ? prop.targetAttribute : prop.attribute;
			var name = targetAttribute;
			var value = this[prop.attribute];
			if (this[prop.attribute] !== undefined) {
				//console.log(name+':'+value);
				if (this.$type === '$StoreMemory') {
					if (prop.attribute === 'data') {
						this.$getStore().setData(value);
					}
				} else {
					if (name !== 'connectId') {
						this.$dojoItem.set(name,value);
					}
				}
				if (prop.attribute === 'label') {
					var labelEl = this.$findElement('dojoLabel');
					if (labelEl) {
						labelEl.innerHTML = zenEscapeXML(zenGet(this.label));
					}
				}
			}
		}
	}
}

/// works only for content panes that where created in a static way
ClientMethod injectDocumentViewIntoContentPane(documentView, key) [ Language = javascript ]
{
	
	var cp1 = this.$documentView.getItemByKey(key).$dojoItem;
	
	if (cp1.$documentView) {
		console.log('this is already linked!');
		var oldDocView = cp1.$documentView;

		// destroy dijit items that are on the same level
		var registry = require("dijit/registry");
		var items = registry.toArray();
		for (var i = 0;i < items.length;i++) {
			var item = registry.byId(items[i].id);
			if (item) {
				if (item.id.split('_')[1] == oldDocView.index && item.id.split('_')[2] == oldDocView.currLevel) {
					console.log(item.id);
					item.destroyRecursive();
				}
			}
		}
	}
	cp1.$plugin = this;
	cp1.$documentView = documentView;
	cp1.$key = key;
	
	documentView.$isEmbedded = true;
	documentView.$originalPlugin = this;
	documentView.$documentView = documentView;
	documentView.$parentDocView = documentView;
	documentView.$contentPane = cp1;
	
	cp1.set('content','<div class="" id="'+documentView.id+'" zen="'+documentView.index+'"></div>');
	
	// subscribe to resize events
	var aspect = require("dojo/aspect");
	
	aspect.after(cp1, "_layoutChildren", function() {
        this.$plugin.resizeDocumentViewWithinContentPane(this.$documentView,this);
        //this.$plugin.resizeDocumentViewWithinKey(this.$documentView,this.$key);
    });
    
    
	// render
	documentView.renderContents();
	//this.resizeDocumentViewWithinKey(documentView,key);
}

/// deprecated?
ClientMethod resizeDocumentViewWithinKey(documentView, key) [ Language = javascript ]
{
	documentView.setSize(documentView.$originalPlugin.$documentView.getItemByKey(key).$findElement('dojo').style.width.split('px')[0]-1,documentView.$originalPlugin.$documentView.getItemByKey(key).$findElement('dojo').style.height.split('px')[0]-1);
	var layout = documentView._lastGraph;
	
	if (layout && layout.$children) {
		for (var i=0; i < layout.$children.length; i++) {
			if (layout.$children[i].$dojoItem)  {
				layout.$children[i].$dojoItem.resize();
			}
		}
	}
}

ClientMethod resizeDocumentViewWithinContentPane(documentView, cp) [ Language = javascript ]
{
	//cp.resize();
	documentView.setSize(cp.get('domNode').style.width.split('px')[0],cp.get('domNode').style.height.split('px')[0]);
	//cp.resize();
	
	var layout = documentView._lastGraph;
	
	if (layout && layout.$children) {
		for (var i=0; i < layout.$children.length; i++) {
			if (layout.$children[i].$dojoItem)  {
				layout.$children[i].$dojoItem.resize();
			}
		}
	}
}

ClientMethod createDocumentView(layoutKey, dataKey, id) [ Language = javascript ]
{
	var mainView = this.$documentView;
	
	var ZENMOJONS = ZENNS + '/mojo'
	var newView = zenPage.createComponentNS(ZENMOJONS,'documentView');
	newView.id = id;
	newView.developerMode = mainView.developerMode;
	newView.ongetlayout = mainView.ongetlayout;
	newView.ongetdata = mainView.ongetdata;
	newView.maxPanels = mainView.maxPanels;
	newView.pluginMap = mainView.pluginMap;
	newView.$isEmbedded = true;
	
	newView.setLayoutKey(layoutKey);
	newView.setDocumentKey(dataKey);
	
	zenPage.setComponentId(newView,id);
	
	// copy plugins
	
	newView.pageManager = zenPage.createComponentNS(ZENMOJONS,mainView.pageManager.pluginName);
	
	for (var i = 0; i < mainView.pageManager.helperPlugins.length; i++) {
		var plugin = mainView.pageManager.helperPlugins[i];
		var pluginCopy = zenPage.createComponentNS(ZENMOJONS,plugin.pluginName);
		newView.pageManager.helperPlugins.push(pluginCopy);
	}
	
	return newView;
}

ClientMethod addTabWithDocumentView(docView, tabKey, tabId, tabTitle, newDocView) [ Language = javascript ]
{
	var layoutItem = docView.getItemByKey(tabKey);
	var tab = layoutItem.$dojoItem;
	
	if (layoutItem.$dojoType != 'dijit/layout/TabContainer') {
		return;
	}
	
	require(["dijit/layout/TabContainer", "dijit/layout/ContentPane", "dojo/domReady!"], function(TabContainer, ContentPane){
	    var cp1 = new ContentPane({
	         title: tabTitle,
	         closable:true,
	         selected:true,
	         content: '<div class="" id="'+newDocView.id+'" zen="'+newDocView.index+'"></div>',
	         style:'width:100%;height:100%;'
	    });
	    tab.addChild(cp1);
	    tab.selectChild(cp1);
	    tab.startup();
	    tab.resize();
	    cp1.resize();
	    
	    newDocView.$contentPane = cp1;
	    newDocView.$parentDocView = docView; 
	    
	    cp1.$plugin = newDocView.getPluginByLayoutObjectType(layoutItem.type);
		cp1.$documentView = newDocView;
	    
	    var aspect = require("dojo/aspect");
		
		aspect.after(cp1, "_layoutChildren", function() {
	        this.$plugin.resizeDocumentViewWithinContentPane(this.$documentView,this);
	    });
	    
		// render
		newDocView.renderContents();
	});
}

/// helper function, adapted from 
/// http://stackoverflow.com/questions/728360/most-elegant-way-to-clone-a-javascript-object
/// clones object, arrays, dates, strings, numbers and booleans
/// other types are not supported
ClientMethod clone(obj) [ Language = javascript ]
{
	
	// Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof Date) {
        var copy = new Date();
        copy.setTime(obj.getTime());
        return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
        var copy = [];
        for (var i = 0, len = obj.length; i < len; i++) {
            copy[i] = this.clone(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        var copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = this.clone(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
	if (typeof require === 'undefined') {
		alert('Dojo library is not loaded correctly. Check your includes.');
		return false;
	}
	return true;
}

/// This method is used to hide generic
ClientMethod hideGeneric() [ Internal, Language = javascript ]
{

	var props = [];
	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	console.log(this.$makeId('dojo'));

	switch (this.type) {
		case '$Button':
		case '$CheckBox':
		case '$ComboBox':
		case '$ComboButton':
		case '$CurrencyTextBox':
		case '$DataList':
		case '$DateTextBox':
		case '$DropDownButton':
		case '$FilteringSelect':
		case '$Form':
		case '$HorizontalRule':
		case '$HorizontalRuleLabels':
		case '$HorizontalSlider':
		case '$MultiSelect':
		case '$NumberSpinner':
		case '$NumberTextBox':
		case '$RadioButton':
		case '$Select':
		case '$SimpleTextarea':
		case '$Textarea':
		case '$TextBox':
		case '$TimeTextBox':
		case '$ToggleButton':
		case '$ValidationTextBox':
		case '$VerticalRule':
		case '$VerticalRuleLabels':
		case '$VerticalSlider':
			var element = this;
			require([ 'dojo/dom-style', 'dijit/registry' ], function (domStyle, registry) {
			    domStyle.set(registry.byId(element.$makeId('dojo')).domNode, 'display', 'none');
			});
			break;
		default:
			dojo.query('#'+this.$makeId('dojo')).style('display','none');
	}
	
	// Hide labels for specific layout objects
	if (this.label) {
		dojo.query('#'+this.$makeId('dojoLabel')).style('display','none');
	}
}

/// This method is used to show generic
ClientMethod showGeneric() [ Internal, Language = javascript ]
{
  	var props = [];
  	var documentView = this.$documentView;
	var plugin = documentView.getPluginByLayoutObjectType(this.$type);
	switch (this.type) {
		case '$Button':
		case '$CheckBox':
		case '$ComboBox':
		case '$ComboButton':
		case '$CurrencyTextBox':
		case '$DataList':
		case '$DateTextBox':
		case '$DropDownButton':
		case '$FilteringSelect':
		case '$Form':
		case '$HorizontalRule':
		case '$HorizontalRuleLabels':
		case '$HorizontalSlider':
		case '$MultiSelect':
		case '$NumberSpinner':
		case '$NumberTextBox':
		case '$RadioButton':
		case '$Select':
		case '$SimpleTextarea':
		case '$Textarea':
		case '$TextBox':
		case '$TimeTextBox':
		case '$ToggleButton':
		case '$ValidationTextBox':
		case '$VerticalRule':
		case '$VerticalRuleLabels':
		case '$VerticalSlider':
			var element = this;
			require([ 'dojo/dom-style', 'dijit/registry' ], function (domStyle, registry) {
			    domStyle.set(registry.byId(element.$makeId('dojo')).domNode, 'display', '');
			});
			break;
		default:
			dojo.query('#'+this.$makeId('dojo')).style('display','block');
	}
	
	// Show labels for specific layout objects
	if (this.label) {
		dojo.query('#'+this.$makeId('dojoLabel')).style('display','');
	}
}

}
