Class %ZEN.Mojo.WidgetReference.jQM132Template Extends %ZEN.Mojo.WidgetReference.jQM132BaseTemplate
{

Parameter DOMAIN = "WidgetReference";

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	this.invokeSuper('onselect',arguments);

 	var view = zen(docViewId);
 	var realKey = key.split(':')[0];
 	switch(realKey) {
	 	
	 	case 'show-popup':
	 	
	 		view.getPluginByName('jQM-1.3.2-Helper').showPopup(value);
	 		
	 		break;
	 		
	 	case 'show-popup-origin':
	 		currentControl = view.getItemByKey(key);
	 		view.getPluginByName('jQM-1.3.2-Helper').showPopup(value,{positionTo:"#"+currentControl.$makeId('control')});
	 		
	 		break;
	 		
	 	case 'show-popup-onobject':
	 		targetPopup = view.getItemByKey(value);
	 		targetObject = view.getItemByKey(targetPopup.value);
	 		view.getPluginByName('jQM-1.3.2-Helper').showPopup(value,{positionTo:"#"+targetObject.$makeId()});
	 		
	 		break;
	 		
	 	case 'close-popup':
	 		
	 		view.getPluginByName('jQM-1.3.2-Helper').closePopup(value,{transition:'fade'});
	 		
	 		break;
	 	
	 	case 'toggle-panel':
			
			view.getPluginByName('jQM-1.3.2-Helper').togglePanel(value);
			
			break;
 	}
}

ClientMethod getData(key, criteria) [ Language = javascript ]
{
	
	var data = {};
	
	switch (key) {
	
		case 'home':
		
			data = {
				headerTitle:'Zen Mojo Widget Reference',
				referenceTitle:'jQuery Mobile 1.3.2 Widget reference',
				referenceDescription:'Test drive every component in the library, and easily build pages by copying and pasting the markup configuration you need.',
				linkAddress:'http://demos.jquerymobile.com/1.3.2/',
				link:'jQuery Mobile 1.3.2 widget reference',
				widgets:[
					{widgetname:'$button',widgetOriginalName:'Buttons',widgetvalue:'button'},
					{widgetname:'$checkbox',widgetOriginalName:'Checkboxes',widgetvalue:'checkbox'},
					{widgetname:'$collapsible',widgetOriginalName:'Collapsibles',widgetvalue:'collapsible'},
					{widgetname:'$collapsibleset',widgetOriginalName:'Accordions',widgetvalue:'collapsibleset'},
					{widgetname:'$fieldset',widgetOriginalName:'Controlgroups',widgetvalue:'fieldset'},
					{widgetname:'Flip switch($select)',widgetOriginalName:'Flip switches',widgetvalue:'flipswitch'},
					{widgetname:'$footer',widgetOriginalName:'Footer toolbars',widgetvalue:'footer'},
					{widgetname:'Form elements',widgetOriginalName:'Form elements',widgetvalue:'formelement'},
					{widgetname:'$grid',widgetOriginalName:'Grids',widgetvalue:'grid'},
					{widgetname:'$header',widgetOriginalName:'Header toolbar',widgetvalue:'header'},
					{widgetname:'Icons',widgetOriginalName:'Icons',widgetvalue:'icon'},
					{widgetname:'$listview',widgetOriginalName:'Listviews',widgetvalue:'listview'},
					{widgetname:'$navbar',widgetOriginalName:'Navbars',widgetvalue:'navbar'},
					//{widgetname:'$panel',widgetOriginalName:'Panels',widgetvalue:'panel'},
					{widgetname:'$popup',widgetOriginalName:'Popup',widgetvalue:'popup'},
					{widgetname:'$radio-button',widgetOriginalName:'Radio buttons',widgetvalue:'radiobutton'},
					{widgetname:'$select',widgetOriginalName:'Select',widgetvalue:'select'},
					{widgetname:'Slider($input)',widgetOriginalName:'Sliders',widgetvalue:'slider'},
					{widgetname:'$text, $textarea, & $input',widgetOriginalName:'Text inputs & textarea',widgetvalue:'text'},
					//{widgetname:'$empty-template',widgetOriginalName:'Empty Template',widgetvalue:'emptytemplate'},
				]};
	
			break;
		
		case 'button':
			
			data = this.getDataButton();
			
			break;
		
		case 'checkbox':
		
			data = this.getDataCheckBox();
			
			break;
			
		case 'collapsible':
		
			data = this.getDataCollapsible();
			
			break;
		
		case 'collapsibleset':
		
			data = this.getDataCollapsibleSet();
			
			break;
			
		case 'fieldset':
		
			data = this.getDataFieldSet();
			
			break;
			
		case 'flipswitch':
		
			data = this.getDataFlipSwitch();
			
			break;
			
		case 'footer':
		
			data = this.getDataFooter();
			
			break;
			
		case 'formelement':
		
			data = this.getDataFormElement();
			
			break;
			
		case 'grid':
		
			data = this.getDataGrid();
			
			break;
		
		case 'header':
		
			data = this.getDataHeader();
			
			break;
			
		case 'icon':
			
			data = this.getDataIcon();
			
			break;
		
		case 'listview':
		
			data = this.getDataListView();
		
			break;
		
		case 'navbar':
			
			data = this.getDataNavbar();
			
			break;
			
		case 'panel':
		
			data = this.getDataPanel();
			
			break;
		
		case 'popup':
		
			data = this.getDataPopup();
			
			break;
			
		case 'radiobutton':
		
			data = this.getDataRadioButton();
		
			break;
			
		case 'select':
			
			data = this.getDataSelect();
			
			break;
		
		case 'slider':
		
			data = this.getDataSlider();
			
			break;
			
		case 'text':
			
			data = this.getDataText();
			
			break;
			
		case 'emptytemplate':
			
			data = this.getDataEmptyTemplate();
			
			break;
	}
	
	return data;
}

ClientMethod getDataEmptyTemplate() [ Language = javascript ]
{
	var data = {
		widgetname:'Empty Template',
		description:'Description of this widget.',
		headercontent:'Empty Template Header',
		link:'jQuery Mobile EmptyTemplate documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				
				{line:"]}"}
			],
			dynamicCode:[
				{line:"Only staticCode is format checked."}
			],
			dynamicData:[
				{line:"Only staticCode is format checked."}
			],
			css:[
				{line:"Only staticCode is format checked."}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataButton() [ Language = javascript ]
{
	var data = {
		widgetname:'Buttons',
		description:'Buttons are core widgets in jQuery Mobile and are used within a wide range of'+
					' other plugins. The button can be created using the \'$button\' layout object.',
		headercontent:'Buttons and $button',
		link:'jQuery Mobile Button documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/buttons/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic markup',
			description : 'To create a single button, add a '+this.addBoldTag('$button')+' layout object'+
						' and a corresponding '+this.addBoldTag('caption')+' attribute to define the'+
						' text on the button. By default, all buttons in the body content are styled'+
						' as block-level elements so they fill the width of the screen.',
			
			staticCode:[
				{line:"{type:'$button',caption:'This is a button'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Inline',
			description : 'If you have multiple buttons that should sit side-by-side on the same line,'+
						' add the '+this.addBoldTag('inline:true')+' attribute to each button. This will'+
						' style the buttons to be the width of their content so the buttons sit on the'+
						' same line.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'True',inline:true},"},
				{line:"{type:'$button',caption:'False',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'Buttons can be manually assigned any of the button color swatches from the'+
						' theme to add visual contrast with their container by adding the '+
						this.addBoldTag('dataTheme')+' attribute to the '+this.addBoldTag('$button')+
						' layout object and specifying a swatch letter. When a button is added to a container,'+
						' it is automatically assigned a theme swatch letter that matches its parent bar'+
						' or content box to visually integrate the button into the parent container.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'A',inline:true,dataTheme:'a'},"},
				{line:"{type:'$button',caption:'B',inline:true,dataTheme:'b'},"},
				{line:"{type:'$button',caption:'C',inline:true,dataTheme:'c'},"},
				{line:"{type:'$button',caption:'D',inline:true,dataTheme:'d'},"},
				{line:"{type:'$button',caption:'E',inline:true,dataTheme:'e'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini',
			description : 'For a more compact version that is useful in toolbars and tight spaces, add the '+
						this.addBoldTag('mini:true')+' attribute to the button to create a mini version.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Cancel',inline:true,mini:true},"},
				{line:"{type:'$button',caption:'Place order',inline:true,dataTheme:'b',dataicon:'check',mini:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icons',
			description : 'An icon can be added to a button by adding the '+this.addBoldTag('dataicon')+
						' attribute on the '+this.addBoldTag('$button')+' specifying an icon to display'+
						' such as '+this.addBoldTag('\'plus\'')+'.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'plus',caption:'Plus'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'minus',caption:'Minus'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'delete',caption:'Delete'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'arrow-l',caption:'Arrow left'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'arrow-r',caption:'Arrow right'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'arrow-u',caption:'Arrow up'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'arrow-d',caption:'Arrow down'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'check',caption:'Check'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'gear',caption:'Gear'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'refresh',caption:'Refresh'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'forward',caption:'Forward'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'back',caption:'Back'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'grid',caption:'Grid'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'star',caption:'Star'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'alert',caption:'Alert'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'info',caption:'Info'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'home',caption:'Home'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'search',caption:'Search'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'bars',caption:'Bars'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'edit',caption:'Edit'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon position',
			description : 'By default, all icons in buttons are placed to the left of the button text.'+
						' This default may be overridden using the '+this.addBoldTag('dataiconpos')+
						' attribute to set the icon to the right ('+this.addBoldTag('\'right\'')+'),'+
						' above ('+this.addBoldTag('\'top\'')+') or below ('+this.addBoldTag('\'bottom\'')+
						') the text. You can also create an icon-only button, by setting the '+
						this.addBoldTag('dataiconpos')+' attribute to '+this.addBoldTag('\'notext\'')+
						'. The button plugin will hide the text on-screen, but add it as a title attribute'+
						' on the link to provide context for screen readers and devices that support tooltips.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',inline:true,caption:'Text only'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'left',dataicon:'arrow-l',caption:'Left'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'right',dataicon:'arrow-r',caption:'Right'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'top',dataicon:'arrow-u',caption:'Top'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'bottom',dataicon:'arrow-d',caption:'Bottom'},"},
				{line:"{type:'$button',inline:true,dataiconpos:'notext',dataicon:'delete',caption:'Icon only'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Vertical group',
			description : 'To visually group a set of buttons to form a single block, use a '+
						this.addBoldTag('$fieldset')+' as a container - the framework will create a'+
						' vertical button group, remove all margins, drop shadows between the buttons,'+
						' and only round the first and last buttons of the set to create the effect that'+
						' they are grouped together.',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$button',caption:'Timeline'},"},
				{line:"{type:'$button',caption:'Mentions'},"},
				{line:"{type:'$button',caption:'Retweets'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal',
			description : 'By adding the '+this.addBoldTag('horizontal:true')+' attribute to the '+
						this.addBoldTag('$fieldset')+' container, you can create a horizontal-style group'+
						' that floats the buttons side-by-side and sets the width to only be large enough'+
						' to fit the content.',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',caption:'Yes'},"},
				{line:"{type:'$button',caption:'No'},"},
				{line:"{type:'$button',caption:'Maybe'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Mini horizontal grouped buttons, icon-only:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',dataTheme:'b',dataiconpos:'notext',dataicon:'plus',caption:'Add'},"},
				{line:"{type:'$button',dataTheme:'b',dataiconpos:'notext',dataicon:'delete',caption:'Delete'},"},
				{line:"{type:'$button',dataTheme:'b',dataiconpos:'notext',dataicon:'grid',caption:'More'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Corners & shadows',
			description : 'There are attributes for controlling the rounded corners ('+
						this.addBoldTag('corners')+'), drop shadow ('+this.addBoldTag('shadow')+
						'), and icon shadow for the highlight under the icon disc ('+
						this.addBoldTag('dataiconshadow')+').',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',dataTheme:'b',dataicon:'gear',caption:'Default'},"},
				{line:"{type:'$button',dataTheme:'b',dataicon:'gear',caption:'No rounded corners',corners:false},"},
				{line:"{type:'$button',dataTheme:'b',dataicon:'gear',caption:'No button shadow',shadow:false},"},
				{line:"{type:'$button',dataTheme:'b',dataicon:'gear',dataiconshadow:'false',caption:'No icon disc shadow'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Disabled',
			description : 'Buttons can be disabled by adding the '+this.addBoldTag('disabled:true')+
						' attribute.',
			
			staticCode:[
				{line:"{type:'$button',disabled:true,caption:'Disabled'}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataCheckBox() [ Language = javascript ]
{
	var data = {
		widgetname:'Checkboxes',
		description:'Checkboxes are used to provide a list of options where more than one can be selected.',
		headercontent:'Checkboxes and $checkbox',
		link:'jQuery Mobile Checkbox documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/checkbox/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic markup',
			description : 'To create a single checkbox, add a '+this.addBoldTag('$checkbox')+' layout object and a corresponding '+this.addBoldTag('label')+' attribute. Adding the '+this.addBoldTag('value:true')+' attribute will render the checkbox already checked.',
			
			staticCode:[
				{line:"{type:'$checkbox',label:'Standard Checkbox',value:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini size',
			description : 'For a more compact version that is useful in toolbars and tight spaces, add the '+this.addBoldTag('mini:true')+' attribute to the '+this.addBoldTag('$checkbox')+' to create a mini version.',
			
			staticCode:[
				{line:"{type:'$checkbox',label:'Mini Checkbox','mini':true,value:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Vertical group',
			description : 'Typically, there are multiple checkboxes listed under a question title. To visually integrate multiple checkboxes into a grouped button set, wrap the checkboxes in a '+this.addBoldTag('$fieldset')+'. The framework will automatically remove all margins between buttons and round only the top and bottom corners of the set.',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal group',
			description : 'Checkboxes can also be used for grouped button sets where more than one button can be selected at once, such as the bold, italic and underline button group seen in word processors. To make a horizontal button set, add the attribute '+this.addBoldTag('horizonal:true')+' to the '+this.addBoldTag('$fieldset')+'.',
			
			staticCode:[
				{line:"{type:'$fieldset','horizontal':true,children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon position',
			description : 'To swap the position of the check icon from the default position on the left, add the '+this.addBoldTag('dataiconpos')+' attribute to the '+this.addBoldTag('$fieldset')+' specifying it\'s value as '+this.addBoldTag('\'right\'')+'.',
			
			staticCode:[
				{line:"{type:'$fieldset',dataiconpos:'right',children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'To set the theme, add the '+this.addBoldTag('dataTheme')+' attribute to each of the individual '+this.addBoldTag('$checkbox')+' objects.',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$checkbox',label:'One',dataTheme:'a'},"},
				{line:"{type:'$checkbox',label:'Two',dataTheme:'a'},"},
				{line:"{type:'$checkbox',label:'Three',dataTheme:'a'}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataCollapsible() [ Language = javascript ]
{
	var data = {
		widgetname:'Collapsible',
		description:'Collapsibles are simple widgets that allow you to expand or collapse content when tapped and are useful in mobile to provide a compact presentation of content.',
		headercontent:'Collapsibles and $collapsible',
		link:'jQuery Mobile Collapsible documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/collapsibles/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic collapsible',
			description : 'To create a collapsible block of content, add a '+this.addBoldTag('$collapsible')+' layout object and a corresponding '+this.addBoldTag('label')+' attribute. The framework will style the label to look like a clickable button and add a "+" icon to the left to indicate it\'s expandable. Inside the '+this.addBoldTag('children')+' attribute, add any layout objects you want to be collapsible. The framework will wrap these objects in a container that will be hidden/shown when the heading is clicked.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',children:["},
				{line:"{type:'$p','$content':'I am the collapsible content. By default I am closed, but you can click the header to open me.'}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'To provide a stronger visual connection between the collapsible header and content, add the '+this.addBoldTag('dataContentTheme')+' attribute to the '+this.addBoldTag('$collapsible')+' and specify a theme swatch letter. This applies the swatch\'s border and flat background color (not the gradient) to the content block, removes the rounded corners from the bottom of the header, and gives the bottom of the content block rounded corners to visually group these elements. Adding the '+this.addBoldTag('dataTheme')+' attribute to the '+this.addBoldTag('$collapsible')+' changes the background and font color of the heading depending upon which swatch letter is specified.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',dataTheme:'b',dataContentTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am the collapsible content with a themed content block set to d.'}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Expanded',
			description : 'To expand the content when the page loads, add the '+this.addBoldTag('expanded:true')+' attribute to the '+this.addBoldTag('$collapsible')+'.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',dataTheme:'b',dataContentTheme:'d',expanded:true,children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'List item 1',clickable:true},"},
				{line:"{type:'$listviewitem',label:'List item 2',clickable:true},"},
				{line:"{type:'$listviewitem',label:'List item 3',clickable:true}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Mini sized',
			description : 'For a more compact version that is useful in toolbars and tight spaces, add the '+this.addBoldTag('mini:true')+' attribute to the '+this.addBoldTag('$collapsible')+' to create a mini version.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',dataTheme:'b',dataContentTheme:'a',mini:true,children:["},
				{line:"{type:'$listview',mini:true,children:["},
				{line:"{type:'$listviewitem',label:'List item 1',clickable:true},"},
				{line:"{type:'$listviewitem',label:'List item 2',clickable:true},"},
				{line:"{type:'$listviewitem',label:'List item 3',clickable:true}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icons',
			description : 'The default icons of collapsible headings can be overridden by using the '+this.addBoldTag('collapsedicon')+' and '+this.addBoldTag('expandedicon')+' attributes. In the example below, '+this.addBoldTag('collapsedicon:\'arrow-d\'')+' and '+this.addBoldTag('expandedicon:\'arrow-u\'')+'.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',dataTheme:'b',dataContentTheme:'d',collapsedicon:'arrow-d',expandedicon:'arrow-u',children:["},
				{line:"{type:'$listview',mini:true,children:["},
				{line:"{type:'$listviewitem',label:'Read-only list item 1'},"},
				{line:"{type:'$listviewitem',label:'Read-only list item 2'},"},
				{line:"{type:'$listviewitem',label:'Read-only list item 3'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon positioning',
			description : 'The default icon positioning of collapsible headings can be overridden by using the '+this.addBoldTag('dataiconpos')+' attribute. In the below case, '+this.addBoldTag('dataiconpos:\'right\'')+'.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'I am a header',dataTheme:'b',dataContentTheme:'d',dataiconpos:'right',children:["},
				{line:"{type:'$p','$content':'Behold, the icon is now on the right.'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Non-inset collapsible',
			description : 'By default, collapsibles have an inset appearance. To make them full width without corner styling add the '+this.addBoldTag('inset:false')+' attribute to the '+this.addBoldTag('$collapsible')+'.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',dataTheme:'c',dataContentTheme:'d',inset:false,children:["},
				{line:"{type:'$p','$content':'I am the collapsible content. By default I am closed, but you can click the header to open me.'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Set of individual collapsibles',
			description : 'This is an example of a series of individual collapsibles. The difference between this and a '+this.addBoldTag('$collapsibleset')+' (Accordian) is that multiple collapsible rows can be open at once.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$collapsible',label:'Pets',inset:false,dataTheme:'b',dataContentTheme:'d',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Canary'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Cat'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Dog'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Gerbil'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Iguana'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Mouse'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Farm Animals',inset:false,dataTheme:'b',dataContentTheme:'d',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Chicken'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Cow'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Duck'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Horse'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Pig'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Sheep'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Wild Animals',inset:false,dataTheme:'b',dataContentTheme:'d',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Aardvark'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Alligator'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Ant'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Bear'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Beaver'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Courgar'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Dingo'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Set of individual collapsibles with custom CSS',
			description : 'To avoid "double" borders the framework removes the top border of collapsibles that are immediately preceded by another collapsible. Negating this using custom CSS requires adding the '+this.addBoldTag('cssClass')+' attribute to the containing '+this.addBoldTag('$div')+' and writing a corresponding css class in either the Homepage or Application class. The borders width has been set to "2px" to make the "double" border effect more obvious.',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'demo-borders-collapsible',children:["},
				{line:"{type:'$collapsible',label:'Pets',inset:false,dataTheme:'e',dataContentTheme:'d',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Canary'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Cat'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Dog'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Gerbil'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Iguana'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Mouse'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Farm Animals',inset:false,dataTheme:'e',dataContentTheme:'d',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Chicken'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Cow'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Duck'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Horse'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Pig'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Sheep'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-borders-collapsible .ui-collapsible .ui-collapsible-heading .ui-btn {"},
				{line:"border-top-width: 2px !important;"},
				{line:"border-bottom-width: 2px;"},
				{line:"}"},
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataCollapsibleSet() [ Language = javascript ]
{
	var data = {
		widgetname:'Accordions',
		description:'An accordion is created in jQuery Mobile by grouping a series of individual collapsibles into a set.',
		headercontent:'Accordions and $collapsibleset',
		link:'jQuery Mobile Accordion documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/accordions/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Markup',
			description : 'Collapsible sets start with the same markup as individual collapsibles which have a '+this.addBoldTag('$collapsible')+' layout object followed by the collapsible content. By wrapping the collapsibles in a '+this.addBoldTag('$collapsibleset')+' they will be visually grouped and will behave like an accordion so only one section can be open at a time.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Section 1',children:["},
				{line:"{type:'$p','$content':'I am the collapsible content for section 1'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Section 2',children:["},
				{line:"{type:'$p','$content':'I am the collapsible content for section 2'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Section 3',children:["},
				{line:"{type:'$p','$content':'I am the collapsible content for section 3'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Inset vs. full width',
			description : 'For full width collapsibles without corner styling add the '+this.addBoldTag('inset:false')+' attribute to the set. This makes the collapsible set look more like an expandable listview.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',inset:false,children:["},
				{line:"{type:'$collapsible',label:'Animals',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Cats'},"},
				{line:"{type:'$listviewitem',label:'Dogs'},"},
				{line:"{type:'$listviewitem',label:'Lizards'},"},
				{line:"{type:'$listviewitem',label:'Snakes'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Cars',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Acura'},"},
				{line:"{type:'$listviewitem',label:'Audi'},"},
				{line:"{type:'$listviewitem',label:'BMW'},"},
				{line:"{type:'$listviewitem',label:'Cadillac'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Planets',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Earth'},"},
				{line:"{type:'$listviewitem',label:'Jupiter'},"},
				{line:"{type:'$listviewitem',label:'Mars'},"},
				{line:"{type:'$listviewitem',label:'Mercury'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini',
			description : 'For a more compact version that is useful in tight spaces, add the '+this.addBoldTag('mini:true')+' attribute to the '+this.addBoldTag('$collapsibleset')+'.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',mini:true,dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'I am a mini collapsible',children:["},
				{line:"{type:'$p','$content':'This is good for tight spaces.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'I am another mini',children:["},
				{line:"{type:'$p','$content':'Here is some collapsible content.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Last one',children:["},
				{line:"{type:'$p','$content':'Final bit of collapsible content.'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icons',
			description : 'The default icons of collapsible headings can be overridden by using the '+this.addBoldTag('collapsedicon')+' and '+this.addBoldTag('expandedicon')+' attributes, either at the '+this.addBoldTag('$collapsibleset')+' level or on any of its '+this.addBoldTag('$collapsible')+' children individually.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',expandedicon:'arrow-d',collapsedicon:'arrow-r',dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Icon set on the set',children:["},
				{line:"{type:'$p','$content':'Specify the open and close icons on the set to apply it to all the collapsibles within.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Icon set on the set',children:["},
				{line:"{type:'$p','$content':'This collapsible also gets the icon from the set.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Icon set on this collapsible',expandedicon:'delete',collapsedicon:'gear',children:["},
				{line:"{type:'$p','$content':'The icons here are applied to this collapsible specifically, thus overriding the set icons.'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon position',
			description : 'The default icon positioning of collapsible headings can be overridden by using the '+this.addBoldTag('dataiconpos')+' attribute, either at the '+this.addBoldTag('$collapsibleset')+' level or on any of its '+this.addBoldTag('$collapsible')+' children individually.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',dataiconpos:'right',dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Right',children:["},
				{line:"{type:'$p','$content':'Inherits icon positioning from dataiconpos attribute on the set.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Left',dataiconpos:'left',children:["},
				{line:"{type:'$p','$content':'Set via dataiconpos attribute on the collapsible.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Bottom',dataiconpos:'bottom',children:["},
				{line:"{type:'$p','$content':'Set via dataiconpos attribute on the collapsible.'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Top',dataiconpos:'top',children:["},
				{line:"{type:'$p','$content':'Set via dataiconpos attribute on the collapsible.'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Corners',
			description : 'Add the '+this.addBoldTag('corners:false')+' attribute to get an inset collapsible set without rounded corners.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',corners:false,dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Section 1',children:["},
				{line:"{type:'$p','$content':'Collapsible content'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Section 2',children:["},
				{line:"{type:'$p','$content':'Collapsible content'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Section 3',children:["},
				{line:"{type:'$p','$content':'Collapsible content'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'Add a '+this.addBoldTag('dataTheme')+' attribute to the '+this.addBoldTag('$collapsibleset')+' to set the color of each collapsible header in a set. Add the '+this.addBoldTag('dataContentTheme')+' attribute to specify the color of the collapsible content.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',dataTheme:'a',dataContentTheme:'a',children:["},
				{line:"{type:'$collapsible',label:'Theme a',children:["},
				{line:"{type:'$p','$content':'Content theme a'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Theme a',children:["},
				{line:"{type:'$p','$content':'Content theme a'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'To have individual sections in a group styled differently, add '+this.addBoldTag('dataTheme')+' and '+this.addBoldTag('useContentTheme')+' attributes to specific collapsibles.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Section header, swatch b',dataTheme:'b',dataContentTheme:'b',children:["},
				{line:"{type:'$p','$content':'Collapsible content, swatch b'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Section header, swatch a',dataTheme:'a',dataContentTheme:'a',children:["},
				{line:"{type:'$p','$content':'Collapsible content, swatch a'}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Section header, swatch e',dataTheme:'e',dataContentTheme:'e',children:["},
				{line:"{type:'$p','$content':'Collapsible content, swatch e'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataFieldSet() [ Language = javascript ]
{
	var data = {
		widgetname:'Fieldsets',
		description:'Fieldsets are used to visually group a set of buttons to form a single block that looks contained like a navigation component.',
		headercontent:'Controlgroups and $fieldsets',
		link:'jQuery Mobile Controlgroup documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/controlgroups/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Vertical fieldset',
			description : 'By default, when using a '+this.addBoldTag('$fieldset')+' as a container the framework will create a vertical group, remove all margins, drop shadows between the buttons, and only round the first and last buttons of the set to create the effect that they are grouped together.',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$button',caption:'No icon'},"},
				{line:"{type:'$button',dataiconpos:'left',dataicon:'delete',caption:'Left'},"},
				{line:"{type:'$button',dataiconpos:'right',dataicon:'delete',caption:'Right'},"},
				{line:"{type:'$button',dataiconpos:'top',dataicon:'delete',caption:'Top'},"},
				{line:"{type:'$button',dataiconpos:'bottom',dataicon:'delete',caption:'Bottom'},"},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'delete',caption:'Icon only'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini sized',
			description : 'For a more compact '+this.addBoldTag('$fieldset')+', add the '+this.addBoldTag('mini:true')+' attribute to the '+this.addBoldTag('$fieldset')+' to create a mini version of the contained layout objects.',
			
			staticCode:[
				{line:"{type:'$fieldset',mini:true,children:["},
				{line:"{type:'$button',caption:'No icon'},"},
				{line:"{type:'$button',dataiconpos:'left',dataicon:'delete',caption:'Left'},"},
				{line:"{type:'$button',dataiconpos:'right',dataicon:'delete',caption:'Right'},"},
				{line:"{type:'$button',dataiconpos:'top',dataicon:'delete',caption:'Top'},"},
				{line:"{type:'$button',dataiconpos:'bottom',dataicon:'delete',caption:'Bottom'},"},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'delete',caption:'Icon only'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal fieldset',
			description : 'Add the '+this.addBoldTag('horizontal:true')+' attribute to a '+this.addBoldTag('$fieldset')+' to arrange the contained layout objects horizontally.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',caption:'No icon'},"},
				{line:"{type:'$button',dataiconpos:'left',dataicon:'delete',caption:'Left'},"},
				{line:"{type:'$button',dataiconpos:'right',dataicon:'delete',caption:'Right'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',dataiconpos:'top',dataicon:'delete',caption:'Top'},"},
				{line:"{type:'$button',dataiconpos:'top',dataicon:'delete',caption:'Top'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',dataiconpos:'bottom',dataicon:'delete',caption:'Bottom'},"},
				{line:"{type:'$button',dataiconpos:'bottom',dataicon:'delete',caption:'Bottom'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'delete',caption:'Icon only'},"},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'delete',caption:'Icon only'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',dataiconpos:'left',dataicon:'home',caption:'Home'},"},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'search',caption:'Search'},"},
				{line:"{type:'$select',valueList:["},
				{line:"{text:'Select...'},"},
				{line:"{text:'One'},"},
				{line:"{text:'Two'},"},
				{line:"{text:'Three'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal, mini sized:',
			description : '',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',caption:'No icon'},"},
				{line:"{type:'$button',dataiconpos:'left',dataicon:'delete',caption:'Left'},"},
				{line:"{type:'$button',dataiconpos:'right',dataicon:'delete',caption:'Right'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',dataiconpos:'top',dataicon:'delete',caption:'Top'},"},
				{line:"{type:'$button',dataiconpos:'top',dataicon:'delete',caption:'Top'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',dataiconpos:'bottom',dataicon:'delete',caption:'Bottom'},"},
				{line:"{type:'$button',dataiconpos:'bottom',dataicon:'delete',caption:'Bottom'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'delete',caption:'Icon only'},"},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'delete',caption:'Icon only'}"},
				{line:"]},"},
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',dataiconpos:'left',dataicon:'home',caption:'Home'},"},
				{line:"{type:'$button',dataiconpos:'notext',dataicon:'search',caption:'Search'},"},
				{line:"{type:'$select',valueList:["},
				{line:"{text:'Select...'},"},
				{line:"{text:'One'},"},
				{line:"{text:'Two'},"},
				{line:"{text:'Three'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Radio Button',
			description : 'Vertical:',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$radio-button',name:'radio-1',text:'One',checked:1},"},
				{line:"{type:'$radio-button',name:'radio-1',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-1',text:'Three'}"},
				{line:"]}"}
			]
		},

		{
			/* --- --- */
			header : '',
			description : 'Vertical, mini sized:',
			
			staticCode:[
				{line:"{type:'$fieldset',mini:true,children:["},
				{line:"{type:'$radio-button',name:'radio-2',text:'One',checked:true},"},
				{line:"{type:'$radio-button',name:'radio-2',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-2',text:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$radio-button',name:'radio-3',text:'One',checked:1},"},
				{line:"{type:'$radio-button',name:'radio-3',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-3',text:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal, mini sized:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$radio-button',name:'radio-4',text:'One',checked:true},"},
				{line:"{type:'$radio-button',name:'radio-4',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-4',text:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Checkbox',
			description : 'Vertical:',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Vertical, mini sized',
			
			staticCode:[
				{line:"{type:'$fieldset',mini:true,children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal, mini sized:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$checkbox',label:'One'},"},
				{line:"{type:'$checkbox',label:'Two'},"},
				{line:"{type:'$checkbox',label:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Select',
			description : 'Vertical:',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Vertical, mini sized:',
			
			staticCode:[
				{line:"{type:'$fieldset',mini:true,children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal, mini sized:',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataFlipSwitch() [ Language = javascript ]
{
	var data = {
		widgetname:'Flip switch',
		description:'Flip switches are used for boolean style inputs like true/false or on/off in a compact UI element.',
		headercontent:'Flip switches and $select',
		link:'jQuery Mobile Flip switch documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/sliders/switch.html'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic switch',
			description : 'To create a basic flip switch, add a '+this.addBoldTag('$select')+' layout object with the '+this.addBoldTag('slider:true')+' attribute and a '+this.addBoldTag('valueList')+' attribute with two child objects. The child objects should define the '+this.addBoldTag('value')+' and '+this.addBoldTag('text')+' attributes. To label the flip switch, specify the '+this.addBoldTag('label')+' attribute.',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'To change the appearance of the flip switch, specify a theme swatch using the '+this.addBoldTag('dataTheme')+' and '+this.addBoldTag('dataTrackTheme')+' attributes.',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',dataTheme:'a',dataTrackTheme:'e',valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Mini',
			description : 'For a more compact version that is useful in toolbars and tight spaces, add the '+this.addBoldTag('mini:true')+' attribute to the '+this.addBoldTag('$select')+' to create a mini version.',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',mini:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Disabled',
			description : 'Flip switches can be disabled via the '+this.addBoldTag('disabled:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',disabled:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Fieldcontain',
			description : 'Labels can be set inline with controls by adding the '+this.addBoldTag('fieldcontain:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',fieldcontain:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Fieldcontain, mini',
			description : '',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',fieldcontain:true,mini:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"}
			],
		},

		{
			/* --- --- */
			header : 'Grid',
			description : 'We make the grid blocks 100% width below 28em with custom CSS.',
			
			staticCode:[
				{line:"{type:'$grid',columnCount:2,cssClass:'demo-flip-slider-grid',children:["},
				{line:"{type:'$input',inputType:'range',highlight:true,label:'Slider',min:'0',max:'100',value:'50'},"},
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]},"},
				{line:"{type:'$input',inputType:'range',highlight:true,label:'Slider',min:'0',max:'100',value:'50',mini:true},"},
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',mini:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:"@media all and (max-width: 28em){"},
    			{line:".demo-flip-slider-grid .ui-block-a,"},
   				{line:".demo-flip-slider-grid .ui-block-b {"},
   			    {line:"width: 100%;"},
       			{line:"clear: left;"},
    			{line:"}"},
				{line:"}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataFooter() [ Language = javascript ]
{
	var data = {
		widgetname:'$footer',
		description:'The footer is a toolbar at the bottom of the page that can contain a wide range of content, from form elements to navbars.',
		headercontent:'Footers and $footer',
		link:'jQuery Mobile Footer documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/footers/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Footer markup',
			description : 'To create a footer, add a '+this.addBoldTag('$footer')+' layout object. The footer will be fixed to the bottom of the page unless you add the '+this.addBoldTag('fixed:false')+' attribute. To save space, buttons in toolbars are automatically set to inline styling so the button is only as wide as the text and icons it contains. By default, toolbars don\'t have any padding to accommodate nav bars and other widgets. To include padding on the bar, add the '+this.addBoldTag('cssClass:\'ui-bar\'')+' attribute to the footer.',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'ui-bar',children:["},
				{line:"{type:'$button',dataicon:'plus',caption:'Add'},"},
				{line:"{type:'$button',dataicon:'arrow-u',caption:'Up'},"},
				{line:"{type:'$button',dataicon:'arrow-d',caption:'Down'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'The footer toolbar will be themed with the "a" swatch by default (black in the default theme) but you can easily set the theme swatch color using the '+this.addBoldTag('dataTheme')+' attribute.',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'ui-bar',dataTheme:'b',children:["},
				{line:"{type:'$button',dataicon:'plus',caption:'Add'},"},
				{line:"{type:'$button',dataicon:'arrow-u',caption:'Up'},"},
				{line:"{type:'$button',dataicon:'arrow-d',caption:'Down'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Grouped buttons',
			description : 'To group buttons together into a button set, wrap the links in a '+this.addBoldTag('$fieldset')+' object. The '+this.addBoldTag('horizontal:true')+' attribute has also been added in this example to create a horizontally grouped set of buttons:',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'ui-bar',children:["},
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$button',dataicon:'plus',caption:'Add'},"},
				{line:"{type:'$button',dataicon:'arrow-u',caption:'Up'},"},
				{line:"{type:'$button',dataicon:'arrow-d',caption:'Down'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Adding form elements',
			description : 'Form elements and other content can also be added to toolbars. Here is an example of a select menu inside a footer bar. We recommend using mini-sized form elements in toolbars by adding the '+this.addBoldTag('mini:true')+' attribute:',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'ui-bar',children:["},
				{line:"{type:'$select',label:'Shipping',mini:true,valueList:["},
				{line:"{value:'1',text:'Standard - 7 day'},"},
				{line:"{value:'2',text:'Rush - 3 day'},"},
				{line:"{value:'3',text:'Express - next day'},"},
				{line:"{value:'4',text:'Overnight'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		/*{
			/* --- Unfinished --- /
			header : 'Fixed & Persistent footers',
			description : 'Should I create this section?',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				
				{line:"]}"}
			]
		},*/
		
	];
	
	return data;
}

ClientMethod getDataFormElement() [ Language = javascript ]
{
	var data = {
		widgetname:'Form Elements',
		description:'All form widgets begin with native form elements with rich HTML semantics that are enhanced to make them more attractive and finger-friendly.',
		headercontent:'Form Elements in Zen Mojo',
		link:'jQuery Mobile Form Elements documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/forms/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Buttons',
			description : 'Buttons are core widgets in jQuery Mobile and are used within a wide range of other plugins.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'This is a button!'},"},
				{line:"{type:'$button',caption:'And this is a button!',dataTheme:'b',dataicon:'delete'},"},
				{line:"{type:'$button',caption:'And even this is a button!',dataTheme:'e',dataicon:'grid',dataiconpos:'right',mini:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Inline buttons',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Inline and icon',inline:true,dataicon:'star'},"},
				{line:"{type:'$button',caption:'Mini + theme',inline:true,dataTheme:'b',mini:true},"},
				{line:"{type:'$button',caption:'Hidden text becomes help text',inline:true,dataTheme:'e',dataicon:'plus',dataiconpos:'notext',mini:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Horizontal, grouped buttons',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,mini:true,children:["},
				{line:"{type:'$button',caption:'Add',dataTheme:'b',dataicon:'plus'},"},
				{line:"{type:'$button',caption:'Delete',dataTheme:'b',dataicon:'delete'},"},
				{line:"{type:'$button',caption:'More',dataTheme:'b',dataicon:'grid'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Sliders',
			description : 'Sliders are used to enter numeric values along a numeric continuum by dragging a handle or entering in a value.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Slider with '+this.addBoldTag('highlight:true')+' and '+this.addBoldTag('step:50')+' attributes.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',highlight:true,step:50,min:0,max:1000,value:60}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Slider with '+this.addBoldTag('highlight:true')+', '+this.addBoldTag('mini:true')+', '+this.addBoldTag('dataTheme')+', and '+this.addBoldTag('dataTrackTheme')+' attributes.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',highlight:true,mini:true,dataTheme:'e',dataTrackTheme:'a',min:0,max:100,value:40}"}

			]
		},
		
		/*{
			/* --- Unfinished (This seems to fail in a similar way that $panel does) --- /
			header : 'Range slider',
			description : 'Range sliders offer two handles to set a min and max value along a numeric continuum.(Not implemented yet)',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,value2:60}"}

			]
		},
		
		/*{
			/* --- Unfinished --- /
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				
				{line:"]}"}
			]
		},*/
		
		{
			/* --- --- */
			header : 'Flip switch',
			description : 'Flip switches are used for boolean style inputs like true/false or on/off in a compact UI element.',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',label:'Flip switch',valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$select',slider:'true',mini:true,label:'Mini flip switch',value:'on',valueList:["},
				{line:"{value:'off',text:'No'},"},
				{line:"{value:'on',text:'Yes'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Checkboxes',
			description : 'Checkboxes are used to provide a list of options where more than one can be selected. ',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Checkboxes, vertical controlgroup',children:["},
				{line:"{type:'$checkbox',label:'Cheetos',value:true},"},
				{line:"{type:'$checkbox',label:'Doritos'},"},
				{line:"{type:'$checkbox',label:'Fritos'},"},
				{line:"{type:'$checkbox',label:'Sun Chips'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Checkboxes in a mini, horizontal controlgroup',mini:true,horizontal:true,children:["},
				{line:"{type:'$checkbox',label:'b'},"},
				{line:"{type:'$checkbox',label:'i',value:true},"},
				{line:"{type:'$checkbox',label:'u'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Radio buttons',
			description : 'Radio buttons are used to provide a list of options where only a single option can be selected.',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Radio buttons, vertical controlgroup',children:["},
				{line:"{type:'$radio-button',name:'radio-form-1',text:'Cat',checked:1},"},
				{line:"{type:'$radio-button',name:'radio-form-1',text:'Dog'},"},
				{line:"{type:'$radio-button',name:'radio-form-1',text:'Hamster'},"},
				{line:"{type:'$radio-button',name:'radio-form-1',text:'Lizard'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Radio buttons in a mini, horizontal controlgroup',mini:true,horizontal:true,children:["},
				{line:"{type:'$radio-button',name:'radio-form-2',text:'List',checked:1},"},
				{line:"{type:'$radio-button',name:'radio-form-2',text:'Grid'},"},
				{line:"{type:'$radio-button',name:'radio-form-2',text:'Gallery'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Selects',
			description : 'The select menu is used to offer a list of options in a compact picker. Ours is based on a native select element, which is hidden from view and replaced with a custom-styled select button. Tapping it opens the native menu or a custom styled version.',
			
			staticCode:[
				{line:"{type:'$select',label:'Select, native menu',valueList:["},
				{line:"{value:'1',text:'Standard - 7 day'},"},
				{line:"{value:'2',text:'Rush - 3 day'},"},
				{line:"{value:'3',text:'Express - next day'},"},
				{line:"{value:'4',text:'Overnight'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$select',label:'Mini select, inline',mini:true,inline:true,valueList:["},
				{line:"{value:'1',text:'Standard - 7 day'},"},
				{line:"{value:'2',text:'Rush - 3 day'},"},
				{line:"{value:'3',text:'Express - next day'},"},
				{line:"{value:'4',text:'Overnight'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'By default, the '+this.addBoldTag('nativeMenu')+' attribute is set to '+this.addBoldTag('true')+'. Setting this to '+this.addBoldTag('false')+' will use the custom jQM menu.',
			
			staticCode:[
				{line:"{type:'$select',label:'Custom select menu',nativeMenu:false,valueList:["},
				{line:"{text:'Custom menu example'},"},
				{line:"{value:'standard',text:'Standard - 7 day'},"},
				{line:"{value:'rush',text:'Rush - 3 day'},"},
				{line:"{value:'express',text:'Express - next day'},"},
				{line:"{value:'overnight',text:'Overnight'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$select',label:'Multi-select with optgroups, custom icon and position',nativeMenu:false,dataicon:'grid',dataiconpos:'left',multiple:true,optGroups:["},
				{line:"{text:'Choose a few options'},"},
				{line:"{label:'USPS',valueList:["},
				{line:"{value:'standard',text:'Standard - 7 day'},"},
				{line:"{value:'rush',text:'Rush - 3 day'},"},
				{line:"{value:'express',text:'Express - next day'},"},
				{line:"{value:'overnight',text:'Overnight'}"},
				{line:"]},"},
				{line:"{label:'FedEx',valueList:["},
				{line:"{value:'firstOvernight',text:'First Overnight'},"},
				{line:"{value:'expressSaver',text:'Express Saver'},"},
				{line:"{value:'ground',text:'Ground'}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Text inputs & Textareas',
			description : 'Text inputs and textareas are coded with standard HTML elements, then enhanced by jQuery Mobile to make them more attractive and useable on a mobile device.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input'},"},
				{line:"{type:'$textarea',label:'Textarea'},"},
				{line:"{type:'$input',label:'Number',inputType:'number'},"},
				{line:"{type:'$input',label:'[0-9]* pattern'},"},
				{line:"{type:'$input',label:'Date',inputType:'date'},"},
				{line:"{type:'$input',label:'Tel',inputType:'tel'},"},
				{line:"{type:'$input',label:'Search',inputType:'search',placeHolder:'Placeholder text...'},"},
				{line:"{type:'$input',label:'File',inputType:'file'},"},
				{line:"{type:'$password',label:'Password'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Disabling form elements',
			description : 'All jQuery Mobile widgets can be disabled in the markup by adding the '+this.addBoldTag('disabled:true')+' attribute to the layout object. Each form widget also has standard disable and enable methods that are documented with each form widget.',
			
			staticCode:[
				{line:"{type:'$text',label:'Text input',fieldcontain:true,disabled:true}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Fieldcontainer',
			description : 'To improve the styling of labels and form elements on wider screens, add the '+this.addBoldTag('fieldcontain:true')+' attribute to each label/form element or on their container (if the container supports the attribute). This framework aligns the input and associated label side-by-side, and breaks to stacked block-level elements below ~448px. The framework will also add a thin bottom border to act as a field separator.',
			
			staticCode:[
				{line:"{type:'$text',label:'Text input',fieldcontain:true}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$select',label:'Native select',fieldcontain:true,valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataGrid() [ Language = javascript ]
{
	var data = {
		widgetname:'Grids',
		description:'The jQuery Mobile framework provides a simple way to build CSS-based columns that can also be responsive.',
		headercontent:'Grids and $grid',
		link:'jQuery Mobile Grid documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/grids/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Grid basics',
			description : 'Grids are 100% width, completely invisible (no borders or backgrounds) and don\'t have padding or margins, so they shouldn\'t interfere with the styles of elements placed inside them. Within the grid container, child elements are assigned '+this.addBoldTag('ui-block-a/b/c/d')+' in a sequential manner which makes each "block" element float side-by-side, forming the grid.',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$p','$content':'A single layout object in a grid is unaffected by the grid.'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Two column grids',
			description : 'To build a two-column (50/50%) layout, create a '+this.addBoldTag('$grid')+' layout object and add two child containers inside. On the blocks below, we\'re adding two classes: '+this.addBoldTag('ui-bar')+' to add the default bar padding and '+this.addBoldTag('ui-bar-e')+' to apply the background gradient and font styling for the '+this.addBoldTag('\'e\'')+' toolbar theme swatch. For illustration purposes, we\'ve added one more class: '+this.addBoldTag('demo-grid-60px')+' to set each block to a standard height of 60px.',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$div','$content':'Block A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block B',cssClass:'ui-bar ui-bar-e demo-grid-60px'}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-grid-two {"},
				{line:"height:60px;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'A '+this.addBoldTag('$grid')+' is used here to stretch two buttons inside to 50% of its container width:',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$button',caption:'Cancel',dataTheme:'c'},"},
				{line:"{type:'$button',caption:'Submit',dataTheme:'b'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Three-column grids',
			description : 'Below is a grid layout configuration that uses 3 child container elements to create a three-column layout (33/33/33%).',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$div','$content':'Block A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block B',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block C',cssClass:'ui-bar ui-bar-e demo-grid-60px'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'And an example of a 3 column grid with buttons inside:',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$button',caption:'Hmm',dataTheme:'c'},"},
				{line:"{type:'$button',caption:'No',dataTheme:'a'},"},
				{line:"{type:'$button',caption:'Yes',dataTheme:'b'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Four-column grids',
			description : 'A four-column, 25/25/25/25% grid is created by adding a fourth layout object.',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$div','$content':'Block A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block B',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block C',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block D',cssClass:'ui-bar ui-bar-e demo-grid-60px'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Five-column grids',
			description : 'A five-column, 20/20/20/20/20% grid is created by adding a fifth layout object.',
			
			staticCode:[
				{line:"{type:'$grid',children:["},
				{line:"{type:'$div','$content':'Block A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block B',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block C',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block D',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'Block E',cssClass:'ui-bar ui-bar-e demo-grid-60px'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Multiple row grids',
			description : 'Grids are designed to wrap to multiple rows of items. For example, if you specify a 3-column grid by using the attribute '+this.addBoldTag('columnCount:3')+' on a grid that has nine child blocks, it will wrap to 3 rows of 3 items each.',
			
			staticCode:[
				{line:"{type:'$grid',columnCount:3,children:["},
				{line:"{type:'$div','$content':'A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'B',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'C',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'B',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'C',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'A',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'B',cssClass:'ui-bar ui-bar-e demo-grid-60px'},"},
				{line:"{type:'$div','$content':'C',cssClass:'ui-bar ui-bar-e demo-grid-60px'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Grid solo class',
			description : 'The framework adds left and right margins to buttons in a grid.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$grid',children:["},
				{line:"{type:'$button',caption:'Previous',dataTheme:'c'},"},
				{line:"{type:'$button',caption:'Next',dataTheme:'c'}"},
				{line:"]},"},
				{line:"{type:'$grid',children:["},
				{line:"{type:'$button',caption:'More',dataTheme:'b'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Breakpoint preset',
			description : 'To apply a preset breakpoint to stack grids below 35em (560px), add the '+this.addBoldTag('cssClass:\'ui-responsive\'')+' attribute to the grid container.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$h3','$content':'Grid A (50/50)'},"},
				{line:"{type:'$grid',cssClass:'ui-responsive',children:["},
				{line:"{type:'$div','$content':'Block A',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'Block B',cssClass:'ui-body ui-body-d'}"},
				{line:"]},"},
				{line:"{type:'$h3','$content':'Grid B (33/33/33)'},"},
				{line:"{type:'$grid',cssClass:'ui-responsive',children:["},
				{line:"{type:'$div','$content':'Block A',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'Block B',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'Block C',cssClass:'ui-body ui-body-d'}"},
				{line:"]},"},
				{line:"{type:'$h3','$content':'Grid C (25/25/25/25)'},"},
				{line:"{type:'$grid',cssClass:'ui-responsive',children:["},
				{line:"{type:'$div','$content':'A',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'B',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'C',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'D',cssClass:'ui-body ui-body-d'}"},
				{line:"]},"},
				{line:"{type:'$h3','$content':'Grid D (20/20/20/20/20)'},"},
				{line:"{type:'$grid',cssClass:'ui-responsive',children:["},
				{line:"{type:'$div','$content':'A',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'B',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'C',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'D',cssClass:'ui-body ui-body-d'},"},
				{line:"{type:'$div','$content':'E',cssClass:'ui-body ui-body-d'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataHeader() [ Language = javascript ]
{
	var data = {
		widgetname:'Headers',
		description:'The header is a toolbar at the top of the page that usually contains the page title text and optional buttons positioned to the left and/or right of the title for navigation or actions.',
		headercontent:'Headers and $header',
		link:'jQuery Mobile Header documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/headers/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Header Markup',
			description : 'To create a header, add a '+this.addBoldTag('$header')+' layout object. The header will be fixed to the top of the page unless you add the '+this.addBoldTag('fixed:false')+' attribute.  A back button is automatically added to the header, but the button can be omitted by using the '+this.addBoldTag('suppressBackButton:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,caption:'Page Title'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'The header toolbar will be themed with the '+this.addBoldTag('\'a\'')+' swatch by default (black in the default theme) but you can easily set the theme swatch using the '+this.addBoldTag('dataTheme')+' attribute.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,dataTheme:'b',caption:'Page Title'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Buttons',
			description : 'The header plugin looks for immediate children of the header container, and automatically sets the first button in the left button slot and the second button in the right. In this example, the \'Cancel\' button will appear in the left slot and \'Save\' will appear in the right slot based on their sequence in the source order.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,caption:'Page Title',children:["},
				{line:"{type:'$button','caption':'Cancel',dataicon:'delete'},"},
				{line:"{type:'$button',caption:'Save',dataicon:'check'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Making buttons visually stand out',
			description : 'Buttons automatically adopt the swatch color of the bar they sit in, so a button in a header bar with the '+this.addBoldTag('\'a\'')+' color will also be styled as '+this.addBoldTag('\'a\'')+' colored buttons. To make a button visually stand out add a '+this.addBoldTag('dataTheme')+' attribute to set the button swatch for contrast.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,caption:'Page Title',children:["},
				{line:"{type:'$button','caption':'Cancel',dataicon:'delete'},"},
				{line:"{type:'$button',caption:'Save',dataicon:'check',dataTheme:'b'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Button position classes',
			description : 'The button position can also be controlled by adding classes to the '+this.addBoldTag('$button')+' layout objects, rather than relying on source order. This is especially useful if you only want a button in the right slot. To specify the button position, add the '+this.addBoldTag('cssClass')+' attribute of '+this.addBoldTag('ui-btn-left')+' or '+this.addBoldTag('ui-btn-right')+' to the '+this.addBoldTag('$button')+'.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,caption:'Page Title',children:["},
				{line:"{type:'$button',caption:'Options',dataicon:'gear',cssClass:'ui-btn-right'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Buttons in toolbars without a heading',
			description : 'The heading in the header bar has some margin that will give the bar its height. If you choose not to use a heading, you will need to add the '+this.addBoldTag('cssClass:\'ui-title\'')+' attribute so that the bar can have a reasonable height and display properly.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,children:["},
				{line:"{type:'$button',caption:'Options',dataicon:'gear',cssClass:'ui-btn-right'},"},
				{line:"{type:'$div',cssClass:'ui-title'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Adding Back buttons',
			description : 'The Zen Mojo jQMHelper automatically generates a "back" button on a '+this.addBoldTag('$header')+' when the header\'s '+this.addBoldTag('suppressBackButton')+' attribute is '+this.addBoldTag('false')+' (default) and the Zen Mojo document stack is not empty. This back button navigates to the previous document view on the stack.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,caption:'Header with back button'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Customizing the back button text',
			description : 'Use the '+this.addBoldTag('backcaption')+' attribute to configure the back button text.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,caption:'Modified back button caption',backcaption:'Previous'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Default back button style',
			description : 'Use the '+this.addBoldTag('backtheme')+' attribute to configue the back button style.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,caption:'Modified back button theme',backtheme:'e'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Custom header configurations',
			description : 'If you need to create a header that doesn\'t follow the default configuration, simply wrap your custom styled markup in any container, such as a '+this.addBoldTag('$div')+'. The plugin won\'t apply the automatic button logic to the wrapped content inside the header container so you can write custom styles for laying out the content in your header.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,children:["},
				{line:"{type:'$div','$content':'I am a header with a mini, inline button wrapped inside a',cssClass:'ui-bar',children:["},
				{line:"{type:'$button','caption':'div',mini:true,inline:true}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'It\'s also possible to create custom bars without using the '+this.addBoldTag('$header')+' layout object at all. For example, start with any container and add the '+this.addBoldTag('cssClass:\'ui-bar\'')+' attribute to apply standard bar padding and add the '+this.addBoldTag('ui-bar-b')+' class to assign the bar swatch styles from your theme. (The '+this.addBoldTag('b')+' can be any swatch letter.)',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'ui-bar ui-bar-b',children:["},
				{line:"{type:'$p','$content':'I am just a div with bar classes and a mini, inline',children:["},
				{line:"{type:'$button','caption':'Button',mini:true,inline:true}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Note that '+this.addBoldTag('.ui-bar')+' should not be added to header or footer bars that span the full width of the page, as the additional padding will cause a full-width element to break out of its parent container. To add padding inside of a full-width toolbar, wrap the toolbar\'s contents in an element and apply the padding to that element instead.',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'ui-bar ui-bar-e',children:["},
				{line:"{type:'$h3','$content':'This is an alert message.',cssClass:'demo-header-styleone'},"},
				{line:"{type:'$div',cssClass:'demo-header-styletwo',children:["},
				{line:"{type:'$button',caption:'Dismiss',dataicon:'delete',dataiconpos:'notext'}"},
				{line:"]},"},
				{line:"{type:'$p','$content':'And here is some additional text in a paragraph.',cssClass:'demo-header-stylethree'}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-header-styleone {"},
				{line:"width: 92%;"},
				{line:"margin-bottom: 5px !important;"},
				{line:"margin-top:15px !important;"},
				{line:"display: inline-block;"},
				{line:"}"},
				{line:".demo-header-styletwo {"},
				{line:"position: absolute;"},
				{line:"width: 8%;"},
				{line:"right: 0px;"},
				{line:"margin-top: 0px;"},
				{line:"display: inline-block;"},
				{line:"}"},
				{line:".demo-header-stylethree {"},
				{line:"margin: 0.3em 0px 1em;"},
				{line:"font-size: 85%;"},
				{line:"}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataIcon() [ Language = javascript ]
{
	var data = {
		widgetname:'Icons',
		description:'A set of built-in icons in jQuery Mobile can be applied to buttons, collapsibles, lists and more.',
		headercontent:'Icons in Zen Mojo',
		link:'jQuery Mobile Icon documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/icons/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Icon set',
			description : 'The following '+this.addBoldTag('dataicon')+' attributes can be referenced to create the icons shown below:',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Bars = bars',dataicon:'bars'},"},
				{line:"{type:'$button',caption:'Edit = edit',dataicon:'edit'},"},
				{line:"{type:'$button',caption:'Left arrow = arrow-l',dataicon:'arrow-l'},"},
				{line:"{type:'$button',caption:'Right arrow = arrow-r',dataicon:'arrow-r'},"},
				{line:"{type:'$button',caption:'Up arrow = arrow-u',dataicon:'arrow-u'},"},
				{line:"{type:'$button',caption:'Down arrow = arrow-d',dataicon:'arrow-d'},"},
				{line:"{type:'$button',caption:'Delete = delete',dataicon:'delete'},"},
				{line:"{type:'$button',caption:'Plus = plus',dataicon:'plus'},"},
				{line:"{type:'$button',caption:'Minus = minus',dataicon:'minus'},"},
				{line:"{type:'$button',caption:'Check = check',dataicon:'check'},"},
				{line:"{type:'$button',caption:'Gear = gear',dataicon:'gear'},"},
				{line:"{type:'$button',caption:'Refresh = refresh',dataicon:'refresh'},"},
				{line:"{type:'$button',caption:'Forward = forward',dataicon:'forward'},"},
				{line:"{type:'$button',caption:'Back = back',dataicon:'back'},"},
				{line:"{type:'$button',caption:'Grid = grid',dataicon:'grid'},"},
				{line:"{type:'$button',caption:'Star = star',dataicon:'star'},"},
				{line:"{type:'$button',caption:'Alert = alert',dataicon:'alert'},"},
				{line:"{type:'$button',caption:'Info = info',dataicon:'info'},"},
				{line:"{type:'$button',caption:'Home = home',dataicon:'home'},"},
				{line:"{type:'$button',caption:'Search = search',dataicon:'search'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon positioning',
			description : 'By default, all icons in buttons are placed to the '+this.addBoldTag('left')+' of the button text. This default may be overridden using the '+this.addBoldTag('dataiconpos')+' attribute to set the icon to the '+this.addBoldTag('right')+', above ('+this.addBoldTag('top')+') or below ('+this.addBoldTag('bottom')+') the text.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Left',dataicon:'arrow-l',dataiconpos:'left'},"},
				{line:"{type:'$button',caption:'Right',dataicon:'arrow-r',dataiconpos:'right'},"},
				{line:"{type:'$button',caption:'Top',dataicon:'arrow-u',dataiconpos:'top'},"},
				{line:"{type:'$button',caption:'Bottom',dataicon:'arrow-d',dataiconpos:'bottom'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon-only positioning',
			description : 'You can also create an icon-only button, by setting the '+this.addBoldTag('dataiconpos')+' attribute to '+this.addBoldTag('notext')+'. The button plugin will hide the text on-screen, but add it as a title attribute on the link to provide context for screen readers and devices that support tooltips.',
			
			staticCode:[
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext'}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Removing the disc and shadow',
			description : 'There is dark semi-opaque disc behind each icon to ensure good contrast when placed on any background color. If you prefer to not have this disc, it can be removed by adding the '+this.addBoldTag('cssClass:\'ui-icon-nodisc\'')+' attribute to the element\'s container. Set '+this.addBoldTag('dataiconshadow:\'false\'')+' to disable the icon shadow.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$div',cssClass:'ui-icon-nodisc',children:["},
				{line:"{type:'$button',caption:'No disc or shadow',dataicon:'arrow-r',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b'},"},
				{line:"{type:'$button',caption:'No disc',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'b'}"},
				{line:"]},"},
				{line:"{type:'$button',caption:'Standard',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'b'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Example of the class being applied to a wrapper.',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'ui-icon-nodisc',children:["},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataiconshadow:'false',dataTheme:'b',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Black vs. white icon sets',
			description : 'The white vs. black icon sprite is set at the theme level but you can override which is used by adding the '+this.addBoldTag('cssClass:\'ui-icon-alt\'')+' attribute to the layout object\'s container. This also changes the color that is used for the discs.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$div',cssClass:'ui-icon-alt',children:["},
				{line:"{type:'$button',caption:'Black icons and white, transparent disc',dataicon:'home',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Difficult to see white disk on white theme',dataicon:'home',dataiconpos:'notext',inline:true}"},
				{line:"]},"},
				{line:"{type:'$button',caption:'Standard, white icons and gray, transparent disc',dataicon:'home',dataiconpos:'notext',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Example of the class being applied to a wrapper.',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'ui-icon-alt',children:["},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataTheme:'c',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Example of the '+this.addBoldTag('ui-icon-alt')+' class applied to a '+this.addBoldTag('$listview')+' to change to the black icons for each list item.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,cssClass:'ui-icon-alt',children:["},
				{line:"{type:'$listviewitem',label:'Acura',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Audi',clickable:true},"},
				{line:"{type:'$listviewitem',label:'BMW',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cadillac',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Ferrari',clickable:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Example of the class being applied to a '+this.addBoldTag('$collapsible')+'.',
			
			staticCode:[
				{line:"{type:'$collapsible',label:'Heading',cssClass:'ui-icon-alt',dataContentTheme:'d',collapsedicon:'arrow-r',expandedicon:'arrow-d',children:["},
				{line:"{type:'$p','$content':'I am the collapsible content. By default I am closed, but you can click the header to open me.'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Custom Icons',
			description : 'To use custom icons, specify a '+this.addBoldTag('dataicon')+' value that has a unique name like '+this.addBoldTag('myapp-email')+' and the button plugin will generate a class by prefixing '+this.addBoldTag('ui-icon-')+' to the '+this.addBoldTag('dataicon')+' value and apply it to the button: '+this.addBoldTag('ui-icon-myapp-email')+'. You can then write a CSS rule in your stylesheet that targets the '+this.addBoldTag('ui-icon-myapp-email')+' class to specify the icon background source. To maintain visual consistency with the rest of the icons, create a white icon 18x18 pixels saved as a PNG-8 with alpha transparency.',
			
			staticCode:[
				{line:"{type:'$p','$content':'View the css section for the css sample code.'}"}
			],
			css:[
				{line:".ui-icon-myapp-email {"},
				{line:'background-image: url("app-icon-email.png");'},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'This will create the standard resolution icon, but many devices now have very high resolution displays, like the retina display on the iPhone 4. To add a HD icon, create an icon that is 36x36 pixels (exactly double the 18 pixel size), and add second a rule that uses the '+this.addBoldTag('-webkit-min-device-pixel-ratio: 2')+' media query to target a rule only to high resolution displays. Specify the background image for the HD icon file and set the background size to 18x18 pixels which will fit the 36 pixel icon into the same 18 pixel space. The media query block can wrap multiple icon rules.',
			
			staticCode:[
				{line:"{type:'$p','$content':'View the css section for the css sample code.'}"}
			],
			css:[
				{line:'@media only screen and (-webkit-min-device-pixel-ratio: 2) {'},
				{line:'.ui-icon-myapp-email {'},
				{line:'background-image: url("app-icon-email-highres.png");'},
				{line:'background-size: 18px 18px;'},
				{line:'}'},
				{line:'...more HD icon rules go here...'},
				{line:'}'}
			]
		},
		
		{
			/* --- --- */
			header : 'Icons and themes',
			description : 'The semi-transparent black circle behind the white icon ensures good contrast on any background color so it works well with the jQuery Mobile theming system. Here are examples of the same icons sitting on top of a range of different color swatches with themed buttons.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$p','$content':'Swatch a themed buttons'},"},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataTheme:'a',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataTheme:'a',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Swatch b themed buttons',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataTheme:'b',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataTheme:'b',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Swatch c themed buttons',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataTheme:'c',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataTheme:'c',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Swatch d themed buttons',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataTheme:'d',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataTheme:'d',inline:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Swatch e themed buttons',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Bars',dataicon:'bars',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Edit',dataicon:'edit',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Arrow left',dataicon:'arrow-l',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Arrow right',dataicon:'arrow-r',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Arrow up',dataicon:'arrow-u',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Arrow down',dataicon:'arrow-d',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Delete',dataicon:'delete',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Plus',dataicon:'plus',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Minus',dataicon:'minus',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Check',dataicon:'check',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Gear',dataicon:'gear',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Refresh',dataicon:'refresh',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Forward',dataicon:'forward',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Back',dataicon:'back',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Grid',dataicon:'grid',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Star',dataicon:'star',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Alert',dataicon:'alert',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Info',dataicon:'info',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Home',dataicon:'home',dataiconpos:'notext',dataTheme:'e',inline:true},"},
				{line:"{type:'$button',caption:'Search',dataicon:'search',dataiconpos:'notext',dataTheme:'e',inline:true}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataListView() [ Language = javascript ]
{
	var data = {
		widgetname:'Listviews',
		description:'A listview is coded by a $listview layout object and has a wide range of features.',
		headercontent:'Listviews and $listview',
		link:'jQuery Mobile List View documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/listviews/'
	};
	
	data.sections = [
			
		{
			/* --- --- */
			header : 'Read-only, unordered',
			description : 'A simple unordered '+this.addBoldTag('$listview')+'.',
			
			staticCode:[
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Acura'},"},
				{line:"{type:'$listviewitem',label:'Audi'},"},
				{line:"{type:'$listviewitem',label:'BMW'},"},
				{line:"{type:'$listviewitem',label:'Cadillac'},"},
				{line:"{type:'$listviewitem',label:'Ferrari'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',value:'=[carCompanies]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]'}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{carCompanies:["},
				{line:"{name:'Acura'},"},
				{line:"{name:'Audi'},"},
				{line:"{name:'BMW'},"},
				{line:"{name:'Cadillac'},"},
				{line:"{name:'Ferrari'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Read-only, ordered',
			description : 'A simple ordered list. Use '+this.addBoldTag('ordered:true')+' to make the list render as an ordered list.',
			
			staticCode:[
				{line:"{type:'$listview',ordered:true,children:["},
				{line:"{type:'$listviewitem',label:'Acura'},"},
				{line:"{type:'$listviewitem',label:'Audi'},"},
				{line:"{type:'$listviewitem',label:'BMW'},"},
				{line:"{type:'$listviewitem',label:'Cadillac'},"},
				{line:"{type:'$listviewitem',label:'Ferrari'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',ordered:true,value:'=[carCompanies]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]'}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{carCompanies:["},
				{line:"{name:'Acura'},"},
				{line:"{name:'Audi'},"},
				{line:"{name:'BMW'},"},
				{line:"{name:'Cadillac'},"},
				{line:"{name:'Ferrari'}"},
				{line:"]}"},
			]
		},

		{
			/* --- --- */
			header : 'Linked',
			description : 'Using the attribute '+this.addBoldTag('clickable:true')+' on a '+this.addBoldTag('$listviewitem')+' makes it clickable; a right arrow indicator makes this clear.',
			
			staticCode:[
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Acura',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Audi',clickable:true},"},
				{line:"{type:'$listviewitem',label:'BMW',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cadillac',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Ferrari',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',value:'=[carCompanies]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{carCompanies:["},
				{line:"{name:'Acura'},"},
				{line:"{name:'Audi'},"},
				{line:"{name:'BMW'},"},
				{line:"{name:'Cadillac'},"},
				{line:"{name:'Ferrari'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Inset',
			description : 'Adding the '+this.addBoldTag('inset:true')+' attribute to the '+this.addBoldTag('$listview')+', applies the inset appearance which is useful for mixing a listview with other content on a page.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Acura',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Audi',clickable:true},"},
				{line:"{type:'$listviewitem',label:'BMW',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cadillac',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Ferrari',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',inset:true,value:'=[carCompanies]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{carCompanies:["},
				{line:"{name:'Acura'},"},
				{line:"{name:'Audi'},"},
				{line:"{name:'BMW'},"},
				{line:"{name:'Cadillac'},"},
				{line:"{name:'Ferrari'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Filter',
			description : 'To make a '+this.addBoldTag('$listview')+' filterable, simply add the '+this.addBoldTag('filter:true')+' attribute to the list. jQM will then append a search box above the list and add the behavior to filter out list items that don\'t contain the current search string as the user types. The input\'s placeholder text defaults to "Filter items...". To configure the placeholder text in the search input, use the '+this.addBoldTag('filterplaceholder')+' attribute. By default the search box will inherit its theme from its parent. The search box theme can be configured using the data attribute '+this.addBoldTag('filtertheme')+' on your '+this.addBoldTag('$listview')+'.',
			
			staticCode:[
				{line:"{type:'$listview',filter:true,filterplaceholder:'Search fruits...',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Apple',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Banana',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cherry',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cranberry',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Grape',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Orange',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',filter:true,filterplaceholder:'Search fruits...',inset:true,value:'=[fruits]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{fruits:["},
				{line:"{name:'Apple'},"},
				{line:"{name:'Banana'},"},
				{line:"{name:'Cherry'},"},
				{line:"{name:'Cranberry'},"},
				{line:"{name:'Grape'},"},
				{line:"{name:'Orange'}"},
				{line:"]}"},
			],
			css:[
				{line:".ui-listview-filter {"},
				{line:"margin: 0px;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Filter with different theme',
			description : 'By default, the search box will inherit its theme from its parent. The search box theme can be configured using the data attribute '+this.addBoldTag('filtertheme')+' on your '+this.addBoldTag('$listview')+'.',
			
			staticCode:[
				{line:"{type:'$listview',filter:true,filterplaceholder:'Search fruits...',filtertheme:'a',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Apple',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Banana',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cherry',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cranberry',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Grape',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Orange',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',filter:true,filterplaceholder:'Search fruits...',filtertheme:'a',inset:true,value:'=[fruits]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{fruits:["},
				{line:"{name:'Apple'},"},
				{line:"{name:'Banana'},"},
				{line:"{name:'Cherry'},"},
				{line:"{name:'Cranberry'},"},
				{line:"{name:'Grape'},"},
				{line:"{name:'Orange'}"},
				{line:"]}"},
			],
			css:[
				{line:".ui-listview-filter {"},
				{line:"margin: 0px;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Filter reveal',
			description : 'The filter reveal feature makes it easy to build a simple autocomplete with local data. When a filterable list has the '+this.addBoldTag('filterreveal:\'true\'')+' attribute, it will auto-hide all the list items when the search field is blank. The '+this.addBoldTag('filterplaceholder')+' attribute can be added to specify the placeholder text for the filter.',
			
			staticCode:[
				{line:"{type:'$listview',filter:true,filterplaceholder:'Search fruits...',filterreveal:true,inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Apple',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Banana',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cherry',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cranberry',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Grape',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Orange',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',filter:true,filterplaceholder:'Search fruits...',filterreveal:true,inset:true,value:'=[fruits]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{fruits:["},
				{line:"{name:'Apple'},"},
				{line:"{name:'Banana'},"},
				{line:"{name:'Cherry'},"},
				{line:"{name:'Cranberry'},"},
				{line:"{name:'Grape'},"},
				{line:"{name:'Orange'}"},
				{line:"]}"},
			],
			css:[
				{line:".ui-listview-filter {"},
				{line:"margin: 0px;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'List dividers',
			description : this.addBoldTag('$listviewitems')+' can be turned into dividers to organize and group the list items. This is done by adding the '+this.addBoldTag('divider:true')+' to any '+this.addBoldTag('$listviewitem')+'. These items are styled with the bar swatch '+this.addBoldTag('\'b\'')+' by default (blue in the default theme) but you can specify a theme for dividers by adding the '+this.addBoldTag('dividertheme')+' attribute to the '+this.addBoldTag('$listview')+' (unordered and ordered) and specifying a theme swatch letter. You can override the divider theme for a specific divider by adding the '+this.addBoldTag('dataTheme')+' attribute to the '+this.addBoldTag('$listviewitem')+'. Please note that dividers are not clickable in this sample.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,dividertheme:'d',children:["},
				{line:"{type:'$listviewitem',label:'Mail',divider:true},"},
				{line:"{type:'$listviewitem',label:'Inbox',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Outbox',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Contacts',divider:true},"},
				{line:"{type:'$listviewitem',label:'Friends',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Work',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',inset:true,dividertheme:'d',value:'=[listitems]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',divider:'=[divider]',clickable:'=[clickable]'}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{listitems:["},
				{line:"{name:'Mail',divider:true},"},
				{line:"{name:'Inbox',clickable:true},"},
				{line:"{name:'Outbox',clickable:true},"},
				{line:"{name:'Contacts',divider:true},"},
				{line:"{name:'Friends',clickable:true},"},
				{line:"{name:'Work',clickable:true}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- Unfinished (autodivederSelector?) --- */
			header : 'Autodividers',
			description : 'A '+this.addBoldTag('$listview')+' can be configured to automatically generate dividers for its items by adding the '+this.addBoldTag('autodividers:true')+' attribute to any '+this.addBoldTag('$listview')+'. By default, the text used to create dividers is the uppercased first letter of the item\'s text. Alternatively you can specify divider text by setting the '+this.addBoldTag('autodividersSelector')+' option on the '+this.addBoldTag('$listview')+' programmatically(Not implemented yet). This feature is designed to work seamlessly with the filter.',
			
			staticCode:[
				{line:"{type:'$listview',filter:true,autodividers:true,inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Adam Kinkaid',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Alex Wickerham',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Avery Johnson',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Bob Cabot',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Caleb Booth',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cristopher Adams',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Culver James',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',filter:true,autodividers:true,inset:true,value:'=[listitems]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{listitems:["},
				{line:"{name:'Adam Kinkaid'},"},
				{line:"{name:'Alex Wickerham'},"},
				{line:"{name:'Avery Johnson'},"},
				{line:"{name:'Bob Cabot'},"},
				{line:"{name:'Caleb Booth'},"},
				{line:"{name:'Cristopher Adams'},"},
				{line:"{name:'Culver James'},"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Count bubbles',
			description : 'To add a count indicator to the right of the '+this.addBoldTag('$listviewitem')+', specifiy the count with the '+this.addBoldTag('count')+' attribute. The theme for count bubbles can be set by adding the '+this.addBoldTag('counttheme')+' attribute to the '+this.addBoldTag('$listview')+' and specifying a swatch letter.',
			
			staticCode:[
				{line:"{type:'$listview',counttheme:'c',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Inbox',count:12,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Outbox',count:'0',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Drafts',count:4,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Sent',count:328,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Trash',count:62,clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',counttheme:'c',inset:true,value:'=[listitems]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',count:'=[count]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{listitems:["},
				{line:"{name:'Inbox',count:12},"},
				{line:"{name:'Outbox',count:0},"},
				{line:"{name:'Drafts',count:4},"},
				{line:"{name:'Sent',count:328},"},
				{line:"{name:'Trash',count:62}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Icons: Standard',
			description : 'The default icon for each '+this.addBoldTag('$listviewitem')+' containing the attribute '+this.addBoldTag('clickable:true')+' is '+this.addBoldTag('arrow-r')+'. To override this, set the '+this.addBoldTag('dataicon')+' attribute on the desired list item to the name of a standard icon. To prevent icons from appearing altogether, set the dataicon attribute to '+this.addBoldTag('\'false\'')+'. With a bit of custom styling it\'s also possible to use third party icons.',
			
			staticCode:[
				{line:"{type:'$listview',counttheme:'c',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'custom-icon',dataicon:'skull-listview',id:'skull',clickable:true},"},
				{line:"{type:'$listviewitem',label:'dataicon=delete',dataicon:'delete',clickable:true},"},
				{line:"{type:'$listviewitem',label:'dataicon=gear',dataicon:'gear',clickable:true},"},
				{line:"{type:'$listviewitem',label:'dataicon=info',dataicon:'info',clickable:true},"},
				{line:"{type:'$listviewitem',label:'dataicon=false',dataicon:'false',clickable:true}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$listview',counttheme:'c',inset:true,value:'=[listitems]',children:["},
				{line:"{type:'$listviewitem',label:'=[name]',dataicon:'=[dataicon]',id:'=[iconid]',clickable:true}"},
				{line:"]}"},
			],
			dynamicData:[
				{line:"{listitems:["},
				{line:"{name:'custom-icon',dataicon:'skull-listview',iconid:'skull'},"},
				{line:"{name:'dataicon=delete',dataicon:'delete'},"},
				{line:"{name:'dataicon=gear',dataicon:'gear'},"},
				{line:"{name:'dataicon=info',dataicon:'info'},"},
				{line:"{name:'dataicon=false',dataicon:'false'}"},
				{line:"]}"},
			],
			css:[
				{line:"/* Most layout objects generate their own ids, $listviewitem is an exception */"},
				{line:".ui-icon-skull-listview {"},
  				{line:'background-image: url("zenmojo_images/glyphish-icons/21-skull.png");'},
 				{line:"background-position: 3px 3px;"},
  				{line:"background-size: 70%;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Icons: 16x16',
			description : 'To use standard 16x16 pixel icons in list items, add the '+this.addBoldTag('icon')+' attribute to the '+this.addBoldTag('$listviewitem')+' and specify a 16x16 icon in the '+this.addBoldTag('(installdir)/csp/broker/')+' directory. A larger image will be scaled down to 16x16 pixels.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'array',icon:'zenmojo_images/array.png',clickable:true},"},
				{line:"{type:'$listviewitem',label:'boolean',icon:'zenmojo_images/boolean.png',clickable:true},"},
				{line:"{type:'$listviewitem',label:'date',icon:'zenmojo_images/date.png',clickable:true},"},
				{line:"{type:'$listviewitem',label:'function',icon:'zenmojo_images/function.png',clickable:true},"},
				{line:"{type:'$listviewitem',label:'number',icon:'zenmojo_images/number.png',clickable:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Thumbnails',
			description : 'To add thumbnails to the left of a list item, simply add the '+this.addBoldTag('thumbnail')+' attribute to a '+this.addBoldTag('$listviewitem')+' specifying an image located in '+this.addBoldTag('(instaldir)/csp/broker')+'. The framework will scale the image down to 80 pixels square.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Einstein',labelNoWrapper:false,clickable:true,content:'Original dimensions 84x117',thumbnail:'images/einstein.jpg'},"},
				{line:"{type:'$listviewitem',label:'Color disk',labelNoWrapper:false,clickable:true,content:'Original dimensions 255x255',thumbnail:'images/rgbdisk_255.png'},"},
				{line:"{type:'$listviewitem',label:'Edit',labelNoWrapper:false,clickable:true,content:'Dimensions 38x16',thumbnail:'images/MacEditB3.png'}"},
				{line:"]}"},
			]
		},
		
		{
			/* ---  --- */
			header : 'Split buttons',
			description : 'To make a split list item, simply add a '+this.addBoldTag('$link')+' layout object to the '+this.addBoldTag('children')+' attribute of the '+this.addBoldTag('$listviewitem')+'. To adjust the split button icon, add the '+this.addBoldTag('spliticon')+' attribute to the '+this.addBoldTag('$listview')+'. Add the '+this.addBoldTag('dataicon')+' attribute to individual list items to set the icon separately from other listview items and override the '+this.addBoldTag('spliticon')+' set at the '+this.addBoldTag('$listview')+' level. The theme swatch color of the split button defaults to '+this.addBoldTag('\'b\'')+' (blue in the default theme) but can be set by specifying a swatch letter with the '+this.addBoldTag('splittheme')+' attribute at the '+this.addBoldTag('$listview')+' level or for individual splits with the '+this.addBoldTag('dataTheme')+' attribute at the '+this.addBoldTag('$link')+' level.',
			
			staticCode:[
				{line:"{type:'$listview',spliticon:'gear',splittheme:'d',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Einstein',labelNoWrapper:false,dataicon:'plus',clickable:true,content:'Original dimensions 84x117',thumbnail:'images/einstein.jpg',children:["},
				{line:"{type:'$link',dataTheme:'a'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Color disk',labelNoWrapper:false,clickable:true,content:'Original dimensions 255x255',thumbnail:'images/rgbdisk_255.png',children:["},
				{line:"{type:'$link'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Edit',labelNoWrapper:false,clickable:true,content:'Dimensions 38x16',thumbnail:'images/MacEditB3.png',children:["},
				{line:"{type:'$link'}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Formatted content',
			description : 'To add text hierarchy, use headings to increase font emphasis and use paragraphs to reduce emphasis. Supplemental information can be added to the right of each list item by adding content to a layout object with a '+this.addBoldTag('cssClass:\'ui-li-aside\'')+' attribute inside a '+this.addBoldTag('$listviewitem')+'. Add the '+this.addBoldTag('labelNoWrapper:false')+' attribute to the '+this.addBoldTag('$listviewitem')+' to add spacing between the label and child elements.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,children:["},
				{line:"{type:'$listviewitem',label:'Friday, October 8, 2010',count:2,divider:true},"},
				{line:"{type:'$listviewitem',label:'Stephen Weber',labelNoWrapper:false,clickable:true,content:'You have been invited to a meeting at Filament Group in Boston, MA',children:["},
				{line:"{type:'$p','$content':'Hey Stephen, if you are available at 10am tomorrow, we have got a meeting with the jQuery team.'},"},
				{line:"{type:'$p','$content':'6-24PM',cssClass:'ui-li-aside'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'jQuery Team',labelNoWrapper:false,clickable:true,content:'Boston Conference Planning',children:["},
				{line:"{type:'$p','$content':'In preparation for the upcoming conference in Boston, we need to start gathering a list of sponsors and speakers.'},"},
				{line:"{type:'$p','$content':'9-18AM',cssClass:'ui-li-aside'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Thursday, October 7, 2010',count:1,divider:true},"},
				{line:"{type:'$listviewitem',label:'Avery Walker',labelNoWrapper:false,clickable:true,content:'Re; Dinner Tonight',children:["},
				{line:"{type:'$p','$content':'Sure, lets plan on meeting at Highland Kitchen at 8pm tonight. Cant wait!'},"},
				{line:"{type:'$p','$content':'4-48PM',cssClass:'ui-li-aside'}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'The list item color scheme can be changed to any button color theme swatch by adding the '+this.addBoldTag('dataTheme')+' attribute to the '+this.addBoldTag('$listview')+' or an individual '+this.addBoldTag('$listviewitem')+'. The theme for list dividers can be set by adding the '+this.addBoldTag('dividertheme')+' attribute to the '+this.addBoldTag('$listview')+'. The theme for count bubbles can be set by adding the '+this.addBoldTag('counttheme')+' to the '+this.addBoldTag('$listview')+' or an individual '+this.addBoldTag('$listviewitem')+'.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,dataTheme:'d',counttheme:'b',dividertheme:'e',children:["},
				{line:"{type:'$listviewitem',label:'Divider',divider:true},"},
				{line:"{type:'$listviewitem',label:'Inbox',count:12,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Outbox',count:'0',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Divider2',dataTheme:'a',divider:true},"},
				{line:"{type:'$listviewitem',label:'Sent',count:328,counttheme:'e',clickable:true}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'To specify the swatch for the split button, add the '+this.addBoldTag('splittheme')+' attribute to the '+this.addBoldTag('$listview')+' and specify a swatch letter. This can also be added to an individual '+this.addBoldTag('$link')+' inside a '+this.addBoldTag('$listviewitem')+' by adding the '+this.addBoldTag('dataTheme')+' attribute(see second listview item). The icon for the split button can be set at the list level by adding the '+this.addBoldTag('dataspliticon')+' attribute to the '+this.addBoldTag('$listview')+' or at the '+this.addBoldTag('$listviewitem')+' level by adding the '+this.addBoldTag('dataicon')+' attribute.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,dataTheme:'a',splittheme:'d',spliticon:'plus',children:["},
				{line:"{type:'$listviewitem',label:'Broken Bells',clickable:true,labelNoWrapper:false,children:["},
				{line:"{type:'$link'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Phoenix',labelNoWrapper:false,clickable:true,children:["},
				{line:"{type:'$link',dataTheme:'e'}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'The white icon sprite is used by default in the theme. Adding the '+this.addBoldTag('cssClass:\'ui-icon-alt\'')+' attribute to the '+this.addBoldTag('$listview')+' switches to the black sprite and gets rid of the dark disc.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,cssClass:'ui-icon-alt',children:["},
				{line:"{type:'$listviewitem',label:'Acura',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Audi',clickable:true},"},
				{line:"{type:'$listviewitem',label:'BMW',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cadillac',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Ferrari',clickable:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Forms',
			description : 'Any form element can be placed inside a listview for a grouped presentation.',
			
			staticCode:[
				{line:"{type:'$listview',inset:true,children:["},
				{line:"{type:'$listviewitem',children:["},
				{line:"{type:'$text',label:'Text Input',fieldcontain:true}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',children:["},
				{line:"{type:'$textarea',label:'Textarea',fieldcontain:true,rows:8,cols:40}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',children:["},
				{line:"{type:'$select',slider:'true',label:'Flip switch',fieldcontain:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',children:["},
				{line:"{type:'$input',inputType:'range',label:'Slider',fieldcontain:true,min:0,max:100,value:0}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',children:["},
				{line:"{type:'$select',label:'Select shipping method',fieldcontain:true,valueList:["},
				{line:"{value:'1',text:'Standard - 7 day'},"},
				{line:"{value:'2',text:'Rush - 3 day'},"},
				{line:"{value:'3',text:'Express - next day'},"},
				{line:"{value:'4',text:'Overnight'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',children:["},
				{line:"{type:'$grid',children:["},
				{line:"{type:'$button',caption:'Cancel',dataTheme:'d'},"},
				{line:"{type:'$button',caption:'Submit',dataTheme:'a'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Collapsible listview',
			description : 'This is an example of a listview wrapped in a '+this.addBoldTag('$collapsible')+' layout object.',
			
			staticCode:[
				{line:"{type:'$collapsible',dataTheme:'b',dataContentTheme:'c',label:'Choose a car model...',children:["},
				{line:"{type:'$listview',filter:true,children:["},
				{line:"{type:'$listviewitem',label:'Acura',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Audi',clickable:true},"},
				{line:"{type:'$listviewitem',label:'BMW',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Cadillac',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Chrysler',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Dodge',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Ferrari',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Ford',clickable:true},"},
				{line:"{type:'$listviewitem',label:'GMC',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Honda',clickable:true}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Grouped collapsible with listviews',
			description : 'You can also use listviews inside a '+this.addBoldTag('$collapsibleset')+' (accordion) to visually group the list and ensure that only a single item can be open at once.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',dataTheme:'b',dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Filtered list',children:["},
				{line:"{type:'$listview',filter:true,filtertheme:'a',children:["},
				{line:"{type:'$listviewitem',label:'Adam Kindaid',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Alex Wickerham',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Avery Johnson',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Bob Cabot',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Caleb Booth',clickable:true}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Formatted text',children:["},
				{line:"{type:'$listview',dividertheme:'d',children:["},
				{line:"{type:'$listviewitem',label:'Friday, October 8, 2010',count:2,divider:true},"},
				{line:"{type:'$listviewitem',label:'Stephen Weber',labelNoWrapper:false,clickable:true,content:'You have been invited to a meeting at Filament Group in Boston, MA',children:["},
				{line:"{type:'$p','$content':'Hey Stephen, if you are available at 10am tomorrow, we have got a meeting with the jQuery team.'},"},
				{line:"{type:'$p','$content':'6-24PM',cssClass:'ui-li-aside'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'jQuery Team',labelNoWrapper:false,clickable:true,content:'Boston Conference Planning',children:["},
				{line:"{type:'$p','$content':'In preparation for the upcoming conference in Boston, we need to start gathering a list of sponsors and speakers.'},"},
				{line:"{type:'$p','$content':'9-18AM',cssClass:'ui-li-aside'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Thumbnails and split button',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Einstein',labelNoWrapper:false,dataicon:'gear',clickable:true,content:'Original dimensions 84x117',thumbnail:'images/einstein.jpg',children:["},
				{line:"{type:'$a'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Color disk',labelNoWrapper:false,clickable:true,content:'Original dimensions 255x255',thumbnail:'images/rgbdisk_255.png',children:["},
				{line:"{type:'$link'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Edit',labelNoWrapper:false,clickable:true,content:'Dimensions 38x16',thumbnail:'images/MacEditB3.png',children:["},
				{line:"{type:'$a'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Full width collapsible listview',
			description : 'Setting '+this.addBoldTag('inset:\'false\'')+' on a '+this.addBoldTag('$collapsible')+' or a '+this.addBoldTag('$collapsibleset')+' makes the collapsible full width (non-inset), like a full width listview.',
			
			staticCode:[
				{line:"{type:'$collapsibleset',inset:false,dataTheme:'c',dataContentTheme:'d',children:["},
				{line:"{type:'$collapsible',label:'Mailbox',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',label:'Inbox',count:12,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Outbox',count:'0',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Drafts',count:4,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Sent',count:328,clickable:true},"},
				{line:"{type:'$listviewitem',label:'Trash',count:62,clickable:true}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Calendar',children:["},
				{line:"{type:'$listview',dividertheme:'d',children:["},
				{line:"{type:'$listviewitem',label:'Friday, October 8, 2010',count:2,divider:true},"},
				{line:"{type:'$listviewitem',label:'Stephen Weber',labelNoWrapper:false,clickable:true,content:'You have been invited to a meeting at Filament Group in Boston, MA',children:["},
				{line:"{type:'$p','$content':'Hey Stephen, if you are available at 10am tomorrow, we have got a meeting with the jQuery team.'},"},
				{line:"{type:'$p','$content':'6-24PM',cssClass:'ui-li-aside'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'jQuery Team',labelNoWrapper:false,clickable:true,content:'Boston Conference Planning',children:["},
				{line:"{type:'$p','$content':'In preparation for the upcoming conference in Boston, we need to start gathering a list of sponsors and speakers.'},"},
				{line:"{type:'$p','$content':'9-18AM',cssClass:'ui-li-aside'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Thursday, October 7, 2010',count:1,divider:true},"},
				{line:"{type:'$listviewitem',label:'Avery Walker',labelNoWrapper:false,clickable:true,content:'Re; Dinner Tonight',children:["},
				{line:"{type:'$p','$content':'Sure, lets plan on meeting at Highland Kitchen at 8pm tonight. Cant wait!'},"},
				{line:"{type:'$p','$content':'4-48PM',cssClass:'ui-li-aside'}"},
				{line:"]},"},
				{line:"{type:'$listviewitem',label:'Wednesday, October 6, 2010',count:3,divider:true},"},
				{line:"{type:'$listviewitem',label:'Amazon.com',labelNoWrapper:false,clickable:true,content:'4-for-3 Books for Kids',children:["},
				{line:"{type:'$p','$content':'As somone who has purchased childrens books from our 4-for-3 Store, you may be interested in these featured books.'},"},
				{line:"{type:'$p','$content':'12-47PM',cssClass:'ui-li-aside'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',label:'Contacts',children:["},
				{line:"{type:'$listview',dividertheme:'d',autodividers:true,children:["},
				{line:"{type:'$listviewitem',label:'Adam Kindaid',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Alex Wickerham',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Avery Johnson',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Bob Cabot',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Caleb Booth',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Christopher Adams',clickable:true},"},
				{line:"{type:'$listviewitem',label:'Culver James',clickable:true}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataNavbar() [ Language = javascript ]
{
	var data = {
		widgetname:'Navbars',
		description:'jQuery Mobile has a very basic navbar widget that is useful for providing up to 5 buttons with optional icons in a bar.',
		headercontent:'Navbars and $navbar',
		link:'jQuery Mobile Navbar documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/navbar/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Navbar basics',
			description : 'To create a Navbar, add a '+this.addBoldTag('$navbar')+' layout object with at least one '+this.addBoldTag('$navbaritem')+' contained in the '+this.addBoldTag('children')+' attribute. The text on the '+this.addBoldTag('$navbaritem')+' is defined by its '+this.addBoldTag('caption')+' attribute. Use the '+this.addBoldTag('active:true')+' attribute to give a '+this.addBoldTag('$navbaritem')+' an active appearance. A '+this.addBoldTag('$navbar')+' with 1 item will render it with 100% width.',
			
			staticCode:[
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One',active:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'The navbar items are set to divide the space evenly so in this case, each button is 1/2 the width of the container:',
			
			staticCode:[
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One',active:true},"},
				{line:"{type:'$navbaritem',caption:'Two'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Adding a third item will automatically make each button 1/3 the width of the container:',
			
			staticCode:[
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One',active:true},"},
				{line:"{type:'$navbaritem',caption:'Two'},"},
				{line:"{type:'$navbaritem',caption:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'Adding a fourth item will automatically make each button 1/4 the width of the container:',
			
			staticCode:[
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One',active:true},"},
				{line:"{type:'$navbaritem',caption:'Two'},"},
				{line:"{type:'$navbaritem',caption:'Three'},"},
				{line:"{type:'$navbaritem',caption:'Four'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'The navbar maxes out with 5 items, each 1/5 the width of the browser window:',
			
			staticCode:[
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One',active:true},"},
				{line:"{type:'$navbaritem',caption:'Two'},"},
				{line:"{type:'$navbaritem',caption:'Three'},"},
				{line:"{type:'$navbaritem',caption:'Four'},"},
				{line:"{type:'$navbaritem',caption:'Five'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Multi-row',
			description : 'If more than 5 items are added, the navbar will simply wrap to multiple lines of two across:',
			
			staticCode:[
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One',active:true},"},
				{line:"{type:'$navbaritem',caption:'Two'},"},
				{line:"{type:'$navbaritem',caption:'Three'},"},
				{line:"{type:'$navbaritem',caption:'Four'},"},
				{line:"{type:'$navbaritem',caption:'Five'},"},
				{line:"{type:'$navbaritem',caption:'Six'},"},
				{line:"{type:'$navbaritem',caption:'Seven'},"},
				{line:"{type:'$navbaritem',caption:'Eight'},"},
				{line:"{type:'$navbaritem',caption:'Nine'},"},
				{line:"{type:'$navbaritem',caption:'Ten'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Navbars in headers',
			description : 'If you want to add a '+this.addBoldTag('$navbar')+' to the top of the page, you can still have a page title and buttons. Just add the navbar container inside the '+this.addBoldTag('$header')+' layout object, right after buttons in the source order.',
			
			staticCode:[
				{line:"{type:'$header',fixed:false,suppressBackButton:true,caption:'I am a header',headerClass:'demo-navbar-oh',children:["},
				{line:"{type:'$button',caption:'Options',dataicon:'gear',cssClass:'ui-btn-right'},"},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One'},"},
				{line:"{type:'$navbaritem',caption:'Two'},"},
				{line:"{type:'$navbaritem',caption:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Navbars in footers',
			description : 'If you want to add a '+this.addBoldTag('$navbar')+' to the bottom of the page so it acts more like a tab bar, simply wrap the navbar in a '+this.addBoldTag('$footer')+' layout object',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,caption:'I am the footer',cssClass:'demo-navbar-oh',children:["},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'One'},"},
				{line:"{type:'$navbaritem',caption:'Two'},"},
				{line:"{type:'$navbaritem',caption:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icons',
			description : 'Icons can be added to navbar items by adding the '+this.addBoldTag('icon')+' attribute specifying a standard mobile icon to each '+this.addBoldTag('$navbaritem')+'. By default, icons are added above the text ('+this.addBoldTag('dataiconpos:\'top\'')+'). The following examples add icons to a navbar in a footer.',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'demo-navbar-oh',children:["},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'Summary',icon:'grid'},"},
				{line:"{type:'$navbaritem',caption:'Favs',icon:'star',active:true},"},
				{line:"{type:'$navbaritem',caption:'Setup',icon:'gear'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon position',
			description : 'The icon position is set on the '+this.addBoldTag('$navbar')+' instead of on an individual '+this.addBoldTag('$navbaritem')+' for visual consistency. For example, to place the icons below the labels, add the  '+this.addBoldTag('dataiconpos:\'bottom\'')+' attribute to the '+this.addBoldTag('$navbar')+' container.',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'demo-navbar-oh',children:["},
				{line:"{type:'$navbar',dataiconpos:'bottom',children:["},
				{line:"{type:'$navbaritem',caption:'Summary',icon:'grid'},"},
				{line:"{type:'$navbaritem',caption:'Favs',icon:'star',active:true},"},
				{line:"{type:'$navbaritem',caption:'Setup',icon:'gear'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : this.addBoldTag('dataiconpos:\'left\''),
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'demo-navbar-oh',children:["},
				{line:"{type:'$navbar',dataiconpos:'left',children:["},
				{line:"{type:'$navbaritem',caption:'Summary',icon:'grid'},"},
				{line:"{type:'$navbaritem',caption:'Favs',icon:'star',active:true},"},
				{line:"{type:'$navbaritem',caption:'Setup',icon:'gear'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : this.addBoldTag('dataiconpos:\'right\''),
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'demo-navbar-oh',children:["},
				{line:"{type:'$navbar',dataiconpos:'right',children:["},
				{line:"{type:'$navbaritem',caption:'Summary',icon:'grid'},"},
				{line:"{type:'$navbaritem',caption:'Favs',icon:'star',active:true},"},
				{line:"{type:'$navbaritem',caption:'Setup',icon:'gear'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : '3rd party icon sets',
			description : 'You can add any of the popular icon libraries like Glyphish to achieve the iOS style tab that has large icons stacked on top of text labels. All that is required is a bit of custom styles to link to the icons and position them in the navbar.  You will need the proper image assets in '+this.addBoldTag('(installdir)/broker/csp/')+'.  Here is an example using Glyphish icons and custom styles in our navbar:',
			
			staticCode:[
				{line:"{type:'$footer',cssClass:'nav-glyphish-example demo-navbar-oh',dataTheme:'d',fixed:false,children:["},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'Chat',icon:'chat-navbar'},"},
				{line:"{type:'$navbaritem',caption:'Email',icon:'email-navbar'},"},
				{line:"{type:'$navbaritem',caption:'Danger',icon:'danger-navbar'},"},
				{line:"{type:'$navbaritem',caption:'Beer',icon:'beer-navbar'},"},
				{line:"{type:'$navbaritem',caption:'Coffee',icon:'coffee-navbar'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".ui-icon-chat-navbar {"},
				{line:'background:url("zenmojo_images/glyphish-icons/09-chat-2.png") 50% 50% no-repeat;'},
				{line:"background-size: 24px 22px;"},
				{line:"}"},
				{line:".ui-icon-email-navbar {"},
				{line:'background:url("zenmojo_images/glyphish-icons/18-envelope.png") 50% 50% no-repeat;'},
				{line:"background-size: 24px 16px;"},
				{line:"}"},
				{line:".ui-icon-danger-navbar {"},
				{line:'background:url("zenmojo_images/glyphish-icons/21-skull.png") 50% 50% no-repeat;'},
				{line:"background-size: 22px 24px;"},
				{line:"}"},
				{line:".ui-icon-beer-navbar {"},
				{line:'background:url("zenmojo_images/glyphish-icons/88-beer-mug.png") 50% 50% no-repeat;'},
				{line:"background-size: 22px 27px;"},
				{line:"}"},
				{line:".ui-icon-coffee-navbar {"},
				{line:'background:url("zenmojo_images/glyphish-icons/100-coffee.png") 50% 50% no-repeat;'},
				{line:"background-size: 20px 24px;"},
				{line:"}"},
				{line:".nav-glyphish-example .ui-btn .ui-icon {"},
				{line:"width: 30px!important;"},
				{line:"height: 27px!important;"},
				{line:"margin-left: -15px !important;"},
				{line:"box-shadow: none!important;"},
				{line:"-moz-box-shadow: none!important;"},
				{line:"-webkit-box-shadow: none!important;"},
				{line:"-webkit-border-radius: 0 !important;"},
				{line:"border-radius: 0 !important;"},
				{line:"}"},
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Themes',
			description : 'Navbars inherit the theme swatch from their parent container, just like buttons. If a navbar is placed in the header or footer toolbar, it will inherit the default toolbar swatch '+this.addBoldTag('\'a\'')+' for bars unless you add the '+this.addBoldTag('dataTheme')+' attribute. Here are a few examples of navbars in various container swatches that automatically inherit their parent\'s swatch letter. Note that in these examples, instead of using a '+this.addBoldTag('dataTheme')+' attribute, we\'re manually adding the swatch classes to apply the body swatch ('+this.addBoldTag('ui-body-a')+') and the class to add the standard body padding ('+this.addBoldTag('ui-body')+') using the '+this.addBoldTag('cssClass')+' attribute, but the inheritance works the same way:',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'ui-body-a ui-body',children:["},
				{line:"{type:'$h3','$content':'Swatch a'},"},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'A',icon:'grid'},"},
				{line:"{type:'$navbaritem',caption:'B',icon:'star'},"},
				{line:"{type:'$navbaritem',caption:'C',icon:'gear'},"},
				{line:"{type:'$navbaritem',caption:'D',icon:'arrow-l'},"},
				{line:"{type:'$navbaritem',caption:'E',icon:'arrow-r'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$div',cssClass:'ui-body-d ui-body',children:["},
				{line:"{type:'$h3','$content':'Swatch d'},"},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'A',icon:'grid'},"},
				{line:"{type:'$navbaritem',caption:'B',icon:'star'},"},
				{line:"{type:'$navbaritem',caption:'C',icon:'gear'},"},
				{line:"{type:'$navbaritem',caption:'D',icon:'arrow-l'},"},
				{line:"{type:'$navbaritem',caption:'E',icon:'arrow-r'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'To set the theme color for a '+this.addBoldTag('$navbaritem')+', add the '+this.addBoldTag('dataTheme')+' attribute to an individual '+this.addBoldTag('$navbaritem')+' and specify a theme swatch. Note that applying a theme swatch to the navbar container is not supported.',
			
			staticCode:[
				{line:"{type:'$footer',fixed:false,cssClass:'demo-navbar-oh',children:["},
				{line:"{type:'$navbar',children:["},
				{line:"{type:'$navbaritem',caption:'A',icon:'grid',dataTheme:'a'},"},
				{line:"{type:'$navbaritem',caption:'B',icon:'star',dataTheme:'b'},"},
				{line:"{type:'$navbaritem',caption:'C',icon:'gear',dataTheme:'c'},"},
				{line:"{type:'$navbaritem',caption:'D',icon:'arrow-l',dataTheme:'d'},"},
				{line:"{type:'$navbaritem',caption:'E',icon:'arrow-r',dataTheme:'e'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-navbar-oh {"},
				{line:"overflow: hidden;"},
				{line:"}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataPanel() [ Language = javascript ]
{
	var data = {
		widgetname:'Panels',
		description:'Flexible by design, panels can be used for navigation, forms, inspectors and more.',
		headercontent:'Panels and $panel',
		link:'jQuery Mobile Panel documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/panels/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Panel examples',
			description : 'The position of the panel on the screen is set by the position attribute. The default value of the attribute is left, meaning it will appear from the left edge of the screen. Specify position:\'right\' for it to appear from the right edge instead. The display mode of the panel is set by the displayMode attribute. The value of the attribute defaults to \'reveal\', meaning the panel will sit under the page and reveal as the page slides away. Specify displayMode:\'overlay\' for the panel to appear on top of the page contents. A third mode, displayMode:\'push\' animates both the panel and page at the same time.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$p','$content':'Left panel examples'},"},
				{line:"{type:'$button',caption:'Overlay',inline:true,mini:true,key:'toggle-left-panel-overlay'},"},
				{line:"{type:'$button',caption:'Reveal',inline:true,mini:true,key:'toggle-left-panel-reveal'},"},
				{line:"{type:'$button',caption:'Push',inline:true,mini:true,key:'toggle-left-panel-push'},"},
				{line:"{type:'$p','$content':'Right panel examples'},"},
				{line:"{type:'$button',caption:'Overlay',inline:true,mini:true,key:'toggle-right-panel',value:'overlay'},"},
				{line:"{type:'$button',caption:'Reveal',inline:true,mini:true,key:'toggle-right-panel',value:'reveal'},"},
				{line:"{type:'$button',caption:'Push',inline:true,mini:true,key:'toggle-right-panel',value:'push'}"},
				/*{line:"{type:'$panel',displayMode:'push',id:'leftPanel',children:["},
				{line:"{type:'$h3','$content':'leftPanel header content'}"},
				{line:"]}"},*/
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$panel',children:["},
				//{line:"{type:'$panel'}"},
				{line:"]}"}
			]
		},
		
		/*{
			/* --- --- /
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				
				{line:"]}"}
			]
		},*/
	];
	
	return data;
}

ClientMethod getDataPopup() [ Language = javascript ]
{
	var data = {
		widgetname:'Popup',
		description:'The popup widget can be used for various types of popups. From a small tooltip popup to a large photo lightbox.',
		headercontent:'Popups and $popup',
		link:'jQuery Mobile Popup documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/popup/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Popup basics',
			description : 'To create a popup, add a '+this.addBoldTag('$popup')+' layout object and add any content to its '+this.addBoldTag('children')+' attribute. Make sure to include a relevant key so that the popup can be opened when a specific action occurs, such as tapping a button. The code responsible for opening these popups is located in the '+this.addBoldTag('onselect(key, value, docViewId)')+' ClientMethod (see the Zen Mojo Code section for the '+this.addBoldTag('onselect')+' code). A '+this.addBoldTag('$popup')+' has to be nested inside the same layout as the object that calls it.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Show popup',key:'show-popup',value:'popup-basics',inline:true},"},
				{line:"{type:'$popup',key:'popup-basics',children:["},
				{line:"{type:'$p','$content':'This is a completely basic popup, no options set.'}"},
				{line:"]}"},
				{line:"]}"}
			],
			zenMojoCode:[
				{line:"ClientMethod onselect(key, value, docViewId) [ Language = javascript ] {"},
				{line:"console.log('select '+key);"},
 				{line:"var view = zen(docViewId);"},
 				{line:"var realKey = key.split(':')[0];"},
 				{line:"switch(realKey) {"},
	 			{line:"case 'show-popup':"},
	 			{line:"&nbsp;&nbsp;view.getPluginByName('jQM-1.3.2-Helper').showPopup(value);"},
	 			{line:"&nbsp;&nbsp;break;"},
 				{line:"}"},
				{line:"}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Tooltip',
			description : 'A tooltip can be created by adding the '+this.addBoldTag('dataTheme')+' attribute to a basic popup and adding padding via the '+this.addBoldTag('cssClass:\'ui-content\'')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$p','$content':'A paragraph with a tooltip.',cssClass:'ui-body-d ui-bar ui-icon-alt',children:["},
				{line:"{type:'$button',caption:'Learn More',key:'show-popup',value:'popup-tooltip',dataicon:'info',dataiconpos:'notext',dataTheme:'e',inline:true}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-tooltip',cssClass:'demo-popup-tooltip',dataTheme:'e',children:["},
				{line:"{type:'$p','$content':'Here is a tiny popup being used like a tooltip. The text will wrap to multiple lines as needed.'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Photo lightbox',
			description : 'A lightbox for displaying images can be created easily by placing an image in a popup. In this example, a close button is added to the markup by adding a '+this.addBoldTag('$button')+' layout object to the '+this.addBoldTag('$popup')+'. The '+this.addBoldTag('dataOverlayTheme:\'a\'')+' attribute adds a dark backdrop behind the photos.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$link',key:'show-popup',value:'popup-lightbox1',image:'../docbook/Cache.png',imageClass:'demo-popup-photolink-link'},"},
				{line:"{type:'$link',key:'show-popup',value:'popup-lightbox2',image:'images/rgbdisk_255.png',imageClass:'demo-popup-photolink-link'},"},
				{line:"{type:'$link',key:'show-popup',value:'popup-lightbox3',image:'../docbook/InterSystems-small.jpg',imageClass:'demo-popup-photolink-link'},"},
				{line:"{type:'$popup',key:'popup-lightbox1',transition:'fade',dataOverlayTheme:'a',corners:false,cssClass:'demo-popup-photolink-popup',children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-lightbox1',label:'Close',cssClass:'ui-btn-right',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$img',src:'../docbook/Cache.png'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-lightbox2',transition:'fade',dataOverlayTheme:'a',corners:false,cssClass:'demo-popup-photolink-popup',children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-lightbox2',label:'Close',cssClass:'ui-btn-right',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$img',src:'images/rgbdisk_255.png'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-lightbox3',transition:'fade',dataOverlayTheme:'a',corners:false,cssClass:'demo-popup-photolink-popup',children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-lightbox3',label:'Close',cssClass:'ui-btn-right',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$img',src:'../docbook/InterSystems-small.jpg'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-popup-photolink-link {"},
				{line:"width: 30%;"},
				{line:"margin-left: 5px;"},
				{line:"}"},
				{line:".demo-popup-photolink-popup {"},
				{line:"max-width: 90% !important;"},
				{line:"max-height: 90% !important;"},
				{line:"margin-left: 5%;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Menu',
			description : 'A menu can be created by adding a '+this.addBoldTag('$listview')+' inside a popup.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Actions',key:'show-popup',value:'popup-menu',inline:true,dataicon:'gear',dataTheme:'e'},"},
				{line:"{type:'$popup',key:'popup-menu',transition:'slideup',children:["},
				{line:"{type:'$listview',dataTheme:'d',inset:true,cssClass:'demo-popup-menu',children:["},
				{line:"{type:'$listviewitem',divider:true,dataTheme:'e',label:'Choose an action'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'View details'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Edit'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Disable'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Delete'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-popup-menu {"},
				{line:"min-width: 210px;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Nested menu',
			description : 'A nested menu can be created by placing '+this.addBoldTag('$listview')+' layout objects into an accordion('+this.addBoldTag('$collapsibleset')+' and '+this.addBoldTag('$collapsible')+') inside a popup.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Choose a creature...',key:'show-popup',value:'popup-nestedmenu',inline:true,dataicon:'bars',dataTheme:'b'},"},
				{line:"{type:'$popup',key:'popup-nestedmenu',transition:'pop',children:["},
				{line:"{type:'$collapsibleset',dataTheme:'b',dataContentTheme:'c',cssClass:'demo-popup-nestedmenu',children:["},
				{line:"{type:'$collapsible',inset:false,label:'Farm Animals',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Chicken'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Cow'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Duck'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Sheep'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',inset:false,label:'Pets',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Cat'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Dog'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Iguana'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Mouse'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',inset:false,label:'Ocean Creatures',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Fish'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Octopus'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Shark'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Starfish'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$collapsible',inset:false,label:'Wild Animals',children:["},
				{line:"{type:'$listview',children:["},
				{line:"{type:'$listviewitem',clickable:true,label:'Lion'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Monkey'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Tiger'},"},
				{line:"{type:'$listviewitem',clickable:true,label:'Zebra'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-popup-nestedmenu {"},
				{line:"margin: 0px;"},
				{line:"width: 250px;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Form',
			description : 'You can place a form inside a popup. When it opens, focus will be restricted to elements inside the popup.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Sign in',key:'show-popup',value:'popup-form',inline:true,dataicon:'check',dataTheme:'a'},"},
				{line:"{type:'$popup',key:'popup-form',transition:'pop',dataTheme:'a',cssClass:'ui-corner-all',children:["},
				{line:"{type:'$div',cssClass:'demo-popup-form',children:["},
				{line:"{type:'$h3','$content':'Please sign in'},"},
				{line:"{type:'$text',placeHolder:'username',dataTheme:'a'},"},
				{line:"{type:'$password',placeHolder:'password',dataTheme:'a'},"},
				{line:"{type:'$button',caption:'Sign in',key:'close-popup',value:'popup-form',dataicon:'check',dataTheme:'b'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-popup-form {"},
				{line:"padding: 10px 20px;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Dialog',
			description : 'Standard dialog markup can be placed into a popup. To create a modal style dialog, add the '+this.addBoldTag('dismissible:false')+' attribute to the popup to prevent the click-outside-to-close behavior so people need to interact with popup buttons to close it.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Delete page...',key:'show-popup',value:'popup-dialog',inline:true,dataicon:'delete',dataTheme:'b'},"},
				{line:"{type:'$popup',key:'popup-dialog',dismissible:false,transition:'pop',dataTheme:'c',dataOverlayTheme:'a',cssClass:'demo-popup-dialog',children:["},
				{line:"{type:'$header',suppressBackButton:true,fixed:false,dataTheme:'a',headerClass:'ui-corner-top',children:["},
				{line:"{type:'$h1','$content':'Delete Page?'}"},
				{line:"]},"},
				{line:"{type:'$div',cssClass:'ui-corner-bottom ui-content',children:["},
				{line:"{type:'$h3',cssClass:'ui-title','$content':'Are you sure you want to delete this page?'},"},
				{line:"{type:'$p','$content':'This action cannot be undone.'},"},
				{line:"{type:'$button',caption:'Cancel',key:'close-popup',value:'popup-dialog',inline:true,dataTheme:'c'},"},
				{line:"{type:'$button',caption:'Delete',key:'close-popup',value:'popup-dialog',inline:true,dataTheme:'b'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-popup-dialog {"},
				{line:"max-width: 400px;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Adding padding',
			description : 'For popups with formatted text, padding is needed. The '+this.addBoldTag('cssClass:\'ui-content\'')+' attribute can be added to the popup to add the standard 15px of padding. When padding is added, we apply a few style rules to negate the top margin for the first heading or paragraph in the popup and do the same for the last element\'s bottom margin.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Popup with padding',key:'show-popup',value:'popup-padding',inline:true},"},
				{line:"{type:'$popup',key:'popup-padding',cssClass:'ui-content',children:["},
				{line:"{type:'$p','$content':'This is a popup with the ui-content class added to the popup container.'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Closing popups',
			description : 'By default popups can be closed either by clicking outside the popup widget or by pressing the Esc key. To prevent this, the '+this.addBoldTag('dismissible:false')+' attribute can be added to the popup. To add an explicit close button to a popup, add a button into the popup container with a key attribute and position via the '+this.addBoldTag('cssClass')+' attribute. Proper calls to '+this.addBoldTag('closePopup(key)')+' must then be provided in the '+this.addBoldTag('onselect(key, value, docViewId)')+' method to enable the closing event. (see the Zen Mojo Code section for the '+this.addBoldTag('onselect')+' code)',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Right close button',key:'show-popup',value:'popup-closing1',inline:true},"},
				{line:"{type:'$button',caption:'Left close button',key:'show-popup',value:'popup-closing2',inline:true},"},
				{line:"{type:'$button',caption:'Undismissible Popup',key:'show-popup',value:'popup-closing3',inline:true},"},
				{line:"{type:'$popup',key:'popup-closing1',cssClass:'ui-content demo-popup-closing',transition:'none',children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-closing1',label:'Close',cssClass:'ui-btn-right',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$p','$content':'I have a close button at the top right corner by using the ui-btn-right class.'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-closing2',cssClass:'ui-content demo-popup-closing',transition:'none',children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-closing2',label:'Close',cssClass:'ui-btn-left',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$p','$content':'I have a close button at the top left corner by using the ui-btn-left class.'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-closing3',cssClass:'ui-content demo-popup-closing',transition:'none',dismissible:false,children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-closing3',label:'Close',cssClass:'ui-btn-left',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$p','$content':'I have the dismissible attribute set to false. I am not closeable by clicking outside of me.'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:".demo-popup-closing {"},
				{line:"max-width: 280px;"},
				{line:"}"},
			],
			zenMojoCode:[
				{line:"ClientMethod onselect(key, value, docViewId) [ Language = javascript ] {"},
				{line:"console.log('select '+key);"},
 				{line:"var view = zen(docViewId);"},
 				{line:"var realKey = key.split(':')[0];"},
 				{line:"switch(realKey) {"},
				{line:"case 'show-popup':"},
	 			{line:"&nbsp;&nbsp;view.getPluginByName('jQM-1.3.2-Helper').showPopup(value);"},
	 			{line:"&nbsp;&nbsp;break;"},
				{line:"case 'close-popup':"},
	 			{line:"&nbsp;&nbsp;view.getPluginByName('jQM-1.3.2-Helper').closePopup(value);"},
	 			{line:"&nbsp;&nbsp;break;"},
	 			{line:"}"},
	 			{line:"}"}
			]
		},
		
		{
			/* --- Unfinished (Positioning not implemented yet; Is this a good enough work-around?) --- */
			header : 'Position',
			description : 'By default, popups open centered vertically and horizontally within the window. If a popup should appear centered over the object resposible for showing the popup, you will need to add code to the '+this.addBoldTag('onselect()')+' ClientMethod (See Zen Mojo Code section). It\'s also possible to position a popup over any layout object by adding a '+this.addBoldTag('#')+' before the '+this.addBoldTag('id')+' of the desired layout object.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$h3','$content':'I am an HTML header',key:'popup-position-h3'},"},
				{line:"{type:'$button',caption:'Position to window',key:'show-popup',value:'popup-position-window',inline:true},"},
				{line:"{type:'$button',caption:'Position to origin',key:'show-popup-origin',value:'popup-position-origin',inline:true},"},
				{line:"{type:'$button',caption:'Position to #position-header',key:'show-popup-onobject',value:'popup-position-onobject',inline:true},"},
				{line:"{type:'$popup',key:'popup-position-window',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am positioned to the window'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-position-origin',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am positioned over the origin'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-position-onobject',value:'popup-position-h3',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am positioned over the h3 layout object in this section. If the header is not scrolled into view, collision detection will place the popup so it is in view.'}"},
				{line:"]}"},
				{line:"]}"}
			],
			zenMojoCode:[
				{line:"ClientMethod onselect(key, value, docViewId) [ Language = javascript ] {"},
				{line:"console.log('select '+key);"},
 				{line:"var view = zen(docViewId);"},
 				{line:"var realKey = key.split(':')[0];"},
 				{line:"switch(realKey) {"},
				{line:"case 'show-popup':"},
		 		{line:"&nbsp;&nbsp;view.getPluginByName('jQM-1.3.2-Helper').showPopup(value);"},
			 	{line:"&nbsp;&nbsp;break;"},
			 	{line:"case 'show-popup-origin':"},
			 	{line:"&nbsp;&nbsp;currentControl = view.getItemByKey(key);"},
			 	{line:"&nbsp;&nbsp;view.getPluginByName('jQM-1.3.2-Helper').showPopup(value,{positionTo:'#'+currentControl.$makeId('control')});"},
			 	{line:"&nbsp;&nbsp;break;"},
			 	{line:"case 'show-popup-onobject':"},
			 	{line:"&nbsp;&nbsp;targetPopup = view.getItemByKey(value);"},
			 	{line:"&nbsp;&nbsp;targetObject = view.getItemByKey(targetPopup.value);"},
			 	{line:"&nbsp;&nbsp;view.getPluginByName('jQM-1.3.2-Helper').showPopup(value,{positionTo:'#'+targetObject.$makeId()});"},
			 	{line:"&nbsp;&nbsp;break;"},
			 	{line:"}"},
	 			{line:"}"}
			]
		},
		
		{
			/* --- Unfinished (Reverse transitions rarely work) --- */
			header : 'Transitions',
			description : 'By default, popups use the '+this.addBoldTag('\'flow\'')+' transition. To set the transition used for a popup, add the '+this.addBoldTag('transition')+' attribute to the '+this.addBoldTag('$popup')+' layout object. The reverse transition will be used when closing the popup(Not implemented yet?). For performance reasons on mobile devices, we recommend using simpler transitions like '+this.addBoldTag('\'pop\'')+', '+this.addBoldTag('\'fade\'')+' or '+this.addBoldTag('\'none\'')+' for smooth and fast popup animations.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'No transition',key:'show-popup',value:'popup-transition-none',inline:true},"},
				{line:"{type:'$button',caption:'Pop',key:'show-popup',value:'popup-transition-pop',inline:true},"},
				{line:"{type:'$button',caption:'Fade',key:'show-popup',value:'popup-transition-fade',inline:true},"},
				{line:"{type:'$button',caption:'Flip',key:'show-popup',value:'popup-transition-flip',inline:true},"},
				{line:"{type:'$button',caption:'Turn',key:'show-popup',value:'popup-transition-turn',inline:true},"},
				{line:"{type:'$button',caption:'Flow',key:'show-popup',value:'popup-transition-flow',inline:true},"},
				{line:"{type:'$button',caption:'Slide',key:'show-popup',value:'popup-transition-slide',inline:true},"},
				{line:"{type:'$button',caption:'Slidefade',key:'show-popup',value:'popup-transition-slidefade',inline:true},"},
				{line:"{type:'$button',caption:'Slide up',key:'show-popup',value:'popup-transition-slideup',inline:true},"},
				{line:"{type:'$button',caption:'Slide down',key:'show-popup',value:'popup-transition-slidedown',inline:true},"},
				{line:"{type:'$popup',key:'popup-transition-none',transition:'none',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-pop',transition:'pop',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-fade',transition:'fade',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-flip',transition:'flip',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-turn',transition:'turn',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-flow',transition:'flow',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-slide',transition:'slide',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-slidefade',transition:'slidefade',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-slideup',transition:'slideup',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-transition-slidedown',transition:'slidedown',cssClass:'ui-content',dataTheme:'d',children:["},
				{line:"{type:'$p','$content':'I am a simple popup'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'The '+this.addBoldTag('$popup')+' layout object has two theme-related options: '+this.addBoldTag('dataTheme')+' and '+this.addBoldTag('dataOverlayTheme')+'. The '+this.addBoldTag('dataTheme')+' option refers to the theme of the popup itself, whereas '+this.addBoldTag('dataOverlayTheme')+' controls the semi-opaque layer behind the popup. The theme is inherited from the page; specify '+this.addBoldTag('dataTheme:\'none\'')+' for a popup with a transparent background.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$button',caption:'Theme A',key:'show-popup',value:'popup-theme1',inline:true},"},
				{line:"{type:'$button',caption:'Theme none, no shadow',key:'show-popup',value:'popup-theme2',inline:true},"},
				{line:"{type:'$button',caption:'Overlay theme A',key:'show-popup',value:'popup-theme3',inline:true},"},
				{line:"{type:'$button',caption:'Theme E + overlay A',key:'show-popup',value:'popup-theme4',inline:true},"},
				{line:"{type:'$popup',key:'popup-theme1',transition:'none',cssClass:'ui-content',dataTheme:'a',children:["},
				{line:"{type:'$p','$content':'I have dataTheme A set on me'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-theme2',transition:'none',cssClass:'ui-content',dataTheme:'none',shadow:false,children:["},
				{line:"{type:'$button',key:'close-popup',value:'popup-theme2',label:'Close',cssClass:'ui-btn-right',dataiconpos:'notext',dataicon:'delete',dataTheme:'a'},"},
				{line:"{type:'$img',src:'deepsee/add_64.png'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-theme3',transition:'none',cssClass:'ui-content',dataOverlayTheme:'a',children:["},
				{line:"{type:'$p','$content':'I have dataOverlayTheme A set on me'}"},
				{line:"]},"},
				{line:"{type:'$popup',key:'popup-theme4',transition:'none',cssClass:'ui-content',dataTheme:'e',dataOverlayTheme:'a',children:["},
				{line:"{type:'$p','$content':'I have dataTheme E and dataOverlayTheme A set on me'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataRadioButton() [ Language = javascript ]
{
	var data = {
		widgetname:'Radio buttons',
		description:'Radio buttons are used to provide a list of options where only a single option can be selected.',
		headercontent:'Radio buttons and $radio-button',
		link:'jQuery Mobile Radio Button documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/radiobuttons/'
	};
	
	data.sections = [
			
		{
			/* --- --- */
			header : 'Basic markup',
			description : 'To create a set of radio buttons, add a '+this.addBoldTag('$radio-button')+' layout object and use the '+this.addBoldTag('text')+' attribute to label the buttons. Only one out of every '+this.addBoldTag('$radio-button')+' layout object with the same '+this.addBoldTag('name')+' attribute can be selected at one time.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$radio-button',name:'radio-1',text:'One'},"},
				{line:"{type:'$radio-button',name:'radio-1',text:'Two'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$loop',value:'=[data]',children:["},
				{line:"{type:'$radio-button',name:'radio-1',text:'=[number]'}"},
				{line:"]}"}
			],
			dynamicData:[
				{line:"{data:["},
				{line:"{number:'One'}"},
				{line:"{number:'Two'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Vertical group',
			description : 'To visually integrate multiple radio buttons into a vertically grouped button set use a '+this.addBoldTag('$fieldset')+' layout object as a container. The framework will automatically remove all margins between buttons and round only the top and bottom corners of the set.',
			
			staticCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$radio-button',name:'radio-2',text:'One',checked:1},"},
				{line:"{type:'$radio-button',name:'radio-2',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-2',text:'Three'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$fieldset',children:["},
				{line:"{type:'$loop',value:'=[data]',children:["},
				{line:"{type:'$radio-button',name:'radio-2',text:'=[number]',checked:'=[checkedstatus]'}"},
				{line:"]}"},
				{line:"]}"}
			],
			dynamicData:[
				{line:"{data:["},
				{line:"{number:'One',checkedstatus:1}"},
				{line:"{number:'Two'}"},
				{line:"{number:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal group',
			description : 'Radio buttons can also be used for grouped button sets arranged horizontally, such as the bold, italic and underline button group seen in word processors. To make a horizontal button set, add the attribute '+this.addBoldTag('horizonal:true')+' to the '+this.addBoldTag('$fieldset')+'.',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$radio-button',name:'radio-3',text:'One',checked:true},"},
				{line:"{type:'$radio-button',name:'radio-3',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-3',text:'Three'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$fieldset',horizontal:true,children:["},
				{line:"{type:'$loop',value:'=[data]',children:["},
				{line:"{type:'$radio-button',name:'radio-3',text:'=[number]',checked:'=[checkedstatus]'}"},
				{line:"]}"},
				{line:"]}"}
			],
			dynamicData:[
				{line:"{data:["},
				{line:"{number:'One',checkedstatus:'true'}"},
				{line:"{number:'Two'}"},
				{line:"{number:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini size',
			description : 'For a more compact version that is useful in toolbars and tight spaces, add the '+this.addBoldTag('mini:true')+' attribute to the '+this.addBoldTag('$fieldset')+' or an individual '+this.addBoldTag('$radio-button')+' to create a mini version.',
			
			staticCode:[
				{line:"{type:'$fieldset',mini:true,children:["},
				{line:"{type:'$radio-button',name:'radio-4',text:'One',checked:true},"},
				{line:"{type:'$radio-button',name:'radio-4',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-4',text:'Three'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$fieldset',mini:true,children:["},
				{line:"{type:'$loop',value:'=[data]',children:["},
				{line:"{type:'$radio-button',name:'radio-4',text:'=[number]',checked:'=[checkedstatus]'}"},
				{line:"]}"},
				{line:"]}"}
			],
			dynamicData:[
				{line:"{data:["},
				{line:"{number:'One',checkedstatus:'true'}"},
				{line:"{number:'Two'}"},
				{line:"{number:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Icon position',
			description : 'To swap the position of the radio icon to the right from the default position on the left, add the '+this.addBoldTag('dataiconpos:\'right\'')+' attribute to the '+this.addBoldTag('$fieldset')+'.',
			
			staticCode:[
				{line:"{type:'$fieldset',dataiconpos:'right',children:["},
				{line:"{type:'$radio-button',name:'radio-5',text:'One',checked:true},"},
				{line:"{type:'$radio-button',name:'radio-5',text:'Two'},"},
				{line:"{type:'$radio-button',name:'radio-5',text:'Three'}"},
				{line:"]}"}
			],
			dynamicCode:[
				{line:"{type:'$fieldset',dataiconpos:'right',children:["},
				{line:"{type:'$loop',value:'=[data]',children:["},
				{line:"{type:'$radio-button',name:'radio-5',text:'=[number]',checked:'=[checkedstatus]'}"},
				{line:"]}"},
				{line:"]}"}
			],
			dynamicData:[
				{line:"{data:["},
				{line:"{number:'One',checkedstatus:'true'}"},
				{line:"{number:'Two'}"},
				{line:"{number:'Three'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'To set the theme, add the '+this.addBoldTag('dataTheme')+' attribute to each of the individual '+this.addBoldTag('$radio-button')+' objects.',
			
			staticCode:[
				{line:"{type:'$fieldset',horizontal:true,mini:true,label:'Horizontal, mini sized',children:["},
				{line:"{type:'$radio-button',name:'radio-6',text:'One',dataTheme:'a',checked:true},"},
				{line:"{type:'$radio-button',name:'radio-6',text:'Two',dataTheme:'b'},"},
				{line:"{type:'$radio-button',name:'radio-6',text:'Three',dataTheme:'c'}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataSelect() [ Language = javascript ]
{
	var data = {
		widgetname:'Select menu',
		description:'The select menu is based on a native select element, which is hidden from view and replaced with a custom-styled select button. Tapping it opens the native menu.',
		headercontent:'Select and $select',
		link:'jQuery Mobile Select documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/selects/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic select',
			description : 'To create a basic select menu, add a '+this.addBoldTag('$select')+' layout object with a '+this.addBoldTag('valueList')+' defined. Define '+this.addBoldTag('value')+' and '+this.addBoldTag('text')+' properties for each object in the '+this.addBoldTag('valueList')+' attribute. Alternatively, the '+this.addBoldTag('valueList')+' can be defined as a string of comma separated values(csv) with an optional '+this.addBoldTag('displayList')+' similarly defined. To add a label, specify the '+this.addBoldTag('label')+' attribute. The '+this.addBoldTag('fieldcontain:true')+' attribute will place the label on the same line as the control.',
			
			staticCode:[
				{line:"{type:'$select',label:'Basic',fieldcontain:true,valueList:["},
				{line:"{value:'1',text:'The 1st Option'},"},
				{line:"{value:'2',text:'The 2nd Option'},"},
				{line:"{value:'3',text:'The 3rd Option'},"},
				{line:"{value:'4',text:'The 4th Option'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : '',
			description : 'The same '+this.addBoldTag('$select')+' specifying the '+this.addBoldTag('valueList')+' and '+this.addBoldTag('displayList')+' as a csv string instead of an array of objects.',
			
			staticCode:[
				{line:"{type:'$select',label:'Basic',fieldcontain:true,valueList:'1, 2, 3, 4',displayList:'The 1st Option, The 2nd Option, The 3rd Option, The 4th Option'}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Mini',
			description : 'Usage example of the '+this.addBoldTag('mini:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$select',label:'Mini sized',mini:true,valueList:["},
				{line:"{value:'1',text:'The 1st Option'},"},
				{line:"{value:'2',text:'The 2nd Option'},"},
				{line:"{value:'3',text:'The 3rd Option'},"},
				{line:"{value:'4',text:'The 4th Option'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Icon position',
			description : 'Usage example of the '+this.addBoldTag('dataiconpos')+' attribute.',
			
			staticCode:[
				{line:"{type:'$select',label:'Icon left',dataiconpos:'left',valueList:["},
				{line:"{value:'1',text:'The 1st Option'},"},
				{line:"{value:'2',text:'The 2nd Option'},"},
				{line:"{value:'3',text:'The 3rd Option'},"},
				{line:"{value:'4',text:'The 4th Option'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Selected option',
			description : 'Usage example of the '+this.addBoldTag('value')+' attribute on the '+this.addBoldTag('$select')+'.',
			
			staticCode:[
				{line:"{type:'$select',label:'3rd option selected',value:3,valueList:["},
				{line:"{value:'1',text:'The 1st Option'},"},
				{line:"{value:'2',text:'The 2nd Option'},"},
				{line:"{value:'3',text:'The 3rd Option'},"},
				{line:"{value:'4',text:'The 4th Option'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Disabled option',
			description : 'Usage example of the '+this.addBoldTag('disabled')+' attribute in the '+this.addBoldTag('valueList')+'.',
			
			staticCode:[
				{line:"{type:'$select',label:'3rd option disabled',valueList:["},
				{line:"{value:'1',text:'The 1st Option'},"},
				{line:"{value:'2',text:'The 2nd Option'},"},
				{line:"{value:'3',text:'The 3rd Option',disabled:1},"},
				{line:"{value:'4',text:'The 4th Option'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Optgroup',
			description : 'To use optgroups in the '+this.addBoldTag('$select')+' layout object, use the '+this.addBoldTag('optGroups')+' attribute instead of the '+this.addBoldTag('valueList')+'. Each element in the '+this.addBoldTag('optGroups')+' array should have a '+this.addBoldTag('label')+' property to name the optgroup and a '+this.addBoldTag('valueList')+' array with '+this.addBoldTag('value')+' and '+this.addBoldTag('text')+' pairs. If no '+this.addBoldTag('label')+' is provided for an element in the '+this.addBoldTag('optGroups')+' array, that '+this.addBoldTag('valueList')+' will be rendered as normal options without an indentation.',
			
			staticCode:[
				{line:"{type:'$select',label:'Optgroup (if supported)',optGroups:["},
				{line:"{text:'Choose...'},"},
				{line:"{label:'Group 1',valueList:["},
				{line:"{value:'1',text:'The 1st Option'},"},
				{line:"{value:'2',text:'The 2nd Option'},"},
				{line:"{value:'3',text:'The 3rd Option'},"},
				{line:"{value:'4',text:'The 4th Option'}"},
				{line:"]},"},
				{line:"{label:'Group 2',valueList:["},
				{line:"{value:'5',text:'The 5th Option'},"},
				{line:"{value:'6',text:'The 6th Option'},"},
				{line:"{value:'7',text:'The 7th Option'}"},
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Vertical group',
			description : 'Add multiple '+this.addBoldTag('$select')+' layout objects to a '+this.addBoldTag('$fieldset')+' to create a grouped set.',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Vertical controlgroup',children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Vertical group, mini',
			description : 'The '+this.addBoldTag('mini:true')+' attribute can be added to each '+this.addBoldTag('$select')+' individually, or to the '+this.addBoldTag('$fieldset')+' container.',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Vertical controlgroup, mini sized',mini:true,children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal group',
			description : 'Add the '+this.addBoldTag('horizontal:true')+' attribute to the '+this.addBoldTag('$fieldset')+' to give the control group an inline appearance.',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Horizontal controlgroup',horizontal:true,children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Horizontal group, mini',
			description : '',
			
			staticCode:[
				{line:"{type:'$fieldset',label:'Horizontal controlgroup, mini sized',horizontal:true,mini:true,children:["},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]},"},
				{line:"{type:'$select',valueList:["},
				{line:"{value:'1',text:'One'},"},
				{line:"{value:'2',text:'Two'},"},
				{line:"{value:'3',text:'Three'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataSlider() [ Language = javascript ]
{
	var data = {
		widgetname:'Sliders',
		description:'Sliders are used to enter numeric values along a continuum and can also be dual handle range sliders(not implemented yet) or flip switches($select).',
		headercontent:'Sliders and $input',
		link:'jQuery Mobile Slider documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/sliders/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic slider',
			description : 'To create a basic slider, add a '+this.addBoldTag('$input')+' layout object with the '+this.addBoldTag('inputType:\'range\'')+' attribute. Define the '+this.addBoldTag('min')+', '+this.addBoldTag('max')+', and '+this.addBoldTag('value')+' attributes to complete the slider. To add a label, specify the '+this.addBoldTag('label')+' attribute.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Step attribute',
			description : 'Add the '+this.addBoldTag('step')+' attribute to define the step value.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:10,value:5,step:0.1}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Higlight',
			description : 'Add the '+this.addBoldTag('highlight:true')+' attribute to show the track highlight. (default is '+this.addBoldTag('false')+')',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,highlight:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Theme',
			description : 'Add the '+this.addBoldTag('dataTheme')+' attribute to change the color of the sliding control and value indicator. Add the '+this.addBoldTag('dataTrackTheme')+' attribute to change the color of the track.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,dataTheme:'a',dataTrackTheme:'e'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini sized',
			description : 'For a more compact version that is useful in toolbars and tight spaces, add the '+this.addBoldTag('mini:true')+' attribute to the slider to create a mini version.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,mini:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Disabled',
			description : 'Add the '+this.addBoldTag('disabled:true')+' attribute to disable the slider.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,disabled:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Fieldcontain',
			description : 'Add the '+this.addBoldTag('fieldcontain:true')+' attribute to make the label and slider appear on the same line.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,fieldcontain:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Fieldcontain, mini sized',
			description : '',
			
			staticCode:[
				{line:"{type:'$input',inputType:'range',label:'Slider',min:0,max:100,value:50,mini:true,fieldcontain:true}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Grid',
			description : 'We make the grid blocks 100% width below 28em with custom CSS.',
			
			staticCode:[
				{line:"{type:'$grid',columnCount:2,cssClass:'demo-flip-slider-grid',children:["},
				{line:"{type:'$input',inputType:'range',highlight:true,label:'Slider',min:'0',max:'100',value:'50'},"},
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]},"},
				{line:"{type:'$input',inputType:'range',highlight:true,label:'Slider',min:'0',max:'100',value:'50',mini:true},"},
				{line:"{type:'$select',slider:'true',label:'Flip toggle switch',mini:true,valueList:["},
				{line:"{value:'off',text:'Off'},"},
				{line:"{value:'on',text:'On'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:"@media all and (max-width: 28em){"},
    			{line:".demo-flip-slider-grid .ui-block-a,"},
   				{line:".demo-flip-slider-grid .ui-block-b {"},
   			    {line:"width: 100%;"},
       			{line:"clear: left;"},
    			{line:"}"},
				{line:"}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataText() [ Language = javascript ]
{
	var data = {
		widgetname:'Text inputs',
		description:'Text inputs and textareas are coded with standard HTML elements, then enhanced by jQuery Mobile to make them more attractive and useable on a mobile device.',
		headercontent:'Text inputs, $text, $textarea, and $input',
		link:'jQuery Mobile Text input documentation',
		linkAddress:'http://demos.jquerymobile.com/1.3.2/widgets/textinputs/'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Text',
			description : 'To create a text field, add a '+this.addBoldTag('$text')+' layout object and use the '+this.addBoldTag('label')+' attribute to label the field.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input'},"},
				{line:"{type:'$text',label:'Text input with a clear button',clearButton:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Search',
			description : 'To create a search field, add an '+this.addBoldTag('$input')+' layout object with the '+this.addBoldTag('inputType:\'search\'')+' attribute.',
			
			staticCode:[
				{line:"{type:'$input',inputType:'search',label:'Search'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Textarea',
			description : 'To create a textarea, add a '+this.addBoldTag('$textarea')+' layout object with a corresponding '+this.addBoldTag('label')+' attribute.',
			
			staticCode:[
				{line:"{type:'$textarea',label:'Textarea'}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Number',
			description : 'To create a text field that only accepts numbers, add an '+this.addBoldTag('$input')+' layout object with the '+this.addBoldTag('inputType:\'number\'')+' attribute. (Field support varies from browser to browser)',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$input',inputType:'number',label:'Number, no clear button'},"},
				{line:"{type:'$input',inputType:'number',label:'Number with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'number',step:0.01,label:'Number, step=0.01'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Pattern',
			description : 'Another way create a text field that only accepts numbers is to add an '+this.addBoldTag('$input')+' or '+this.addBoldTag('$text')+' layout object with the '+this.addBoldTag('pattern')+' attribute specified as a regualar expression. (Field support varies from browser to browser)',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$input',pattern:'-?[0-8]*',label:'Pattern(number with no 9s), no clear button'},"},
				{line:"{type:'$input',pattern:'-?[0-8]*',label:'Pattern(number with no 9s) with a clear button',clearButton:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Other field types',
			description : 'The '+this.addBoldTag('$input')+' layout object supports many different data fields. Use the '+this.addBoldTag('inputType')+' attribute to define which data type to look for. (Field support varies from browser to browser)',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$input',inputType:'date',label:'Date'},"},
				{line:"{type:'$input',inputType:'date',label:'Date with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'month',label:'Month'},"},
				{line:"{type:'$input',inputType:'month',label:'Month with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'week',label:'Week'},"},
				{line:"{type:'$input',inputType:'week',label:'Week with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'time',label:'Time'},"},
				{line:"{type:'$input',inputType:'time',label:'Time with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'datetime',label:'Datetime'},"},
				{line:"{type:'$input',inputType:'datetime',label:'Datetime with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'datetime-local',label:'Datetime-local'},"},
				{line:"{type:'$input',inputType:'datetime-local',label:'Datetime-local with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'tel',label:'Telephone'},"},
				{line:"{type:'$input',inputType:'tel',label:'Telephone with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'email',label:'Email'},"},
				{line:"{type:'$input',inputType:'email',label:'Email with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'url',label:'URL'},"},
				{line:"{type:'$input',inputType:'url',label:'URL with a clear button',clearButton:true},"},
				{line:"{type:'$input',inputType:'color',label:'Color'},"},
				{line:"{type:'$input',inputType:'color',label:'Color with a clear button',clearButton:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* ---  --- */
			header : 'Password',
			description : 'To create a password field, add a '+this.addBoldTag('$password')+' layout object or an '+this.addBoldTag('$input')+' object with the '+this.addBoldTag('inputType:\'password\'')+'.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$password',label:'$password'},"},
				{line:"{type:'$input',inputType:'password',label:'$input'},"},
				{line:"{type:'$password',label:'$password with a clear button',clearButton:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* ---  --- */
			header : 'File',
			description : 'To create a text field for selecting files, add an '+this.addBoldTag('$input')+' layout object with the '+this.addBoldTag('inputType:\'file\'')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$input',inputType:'file',label:'File, no clear button'},"},
				{line:"{type:'$input',inputType:'file',label:'File with a clear button',clearButton:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Mini',
			description : 'Examples using the '+this.addBoldTag('mini:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input',mini:true},"},
				{line:"{type:'$text',label:'Text input with a clear button',clearButton:true,mini:true},"},
				{line:"{type:'$input',inputType:'search',label:'Search',mini:true},"},
				{line:"{type:'$textarea',label:'Textarea',mini:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Placeholder',
			description : 'Examples using the '+this.addBoldTag('placeHolder')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input',placeHolder:'placeHolder'},"},
				{line:"{type:'$text',label:'Text input with a clear button',clearButton:true,placeHolder:'placeHolder'},"},
				{line:"{type:'$input',inputType:'search',label:'Search',placeHolder:'placeHolder'},"},
				{line:"{type:'$textarea',label:'Textarea',placeHolder:'placeHolder'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Value',
			description : 'Examples using the '+this.addBoldTag('value')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input',value:'value'},"},
				{line:"{type:'$text',label:'Text input with a clear button',clearButton:true,value:'value'},"},
				{line:"{type:'$input',inputType:'search',label:'Search',value:'value'},"},
				{line:"{type:'$textarea',label:'Textarea',value:'value'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Disabled',
			description : 'Examples using the '+this.addBoldTag('disabled:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input',disabled:true},"},
				{line:"{type:'$text',label:'Text input with a clear button',clearButton:true,disabled:true},"},
				{line:"{type:'$input',inputType:'search',label:'Search',disabled:true},"},
				{line:"{type:'$textarea',label:'Textarea',disabled:true}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Fieldcontain',
			description : 'Examples using the '+this.addBoldTag('fieldcontain:true')+' attribute.',
			
			staticCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$text',label:'Text input',fieldcontain:true},"},
				{line:"{type:'$text',label:'Text input with a clear button',clearButton:true,fieldcontain:true},"},
				{line:"{type:'$input',inputType:'search',label:'Search',fieldcontain:true},"},
				{line:"{type:'$textarea',label:'Textarea',fieldcontain:true}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

}
