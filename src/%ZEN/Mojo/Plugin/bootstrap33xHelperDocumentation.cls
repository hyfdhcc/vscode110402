Class %ZEN.Mojo.Plugin.bootstrap33xHelperDocumentation Extends %ZEN.Mojo.Plugin.baseHelperDocumentation
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
		
		case '$alert':
			documentation = {
				description:'Creates an Alert element that provides contextual feedback messages for typical user actions.',

				attributes:[
					{name:'content',type:'string',refreshable:true,description:'Content of this layout object'},
					{name:'dismissable',type:'boolean',refreshable:false,description:'Determines whether the alert dialog can be closed. (False)'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'icon',type:'string',refreshable:false,description:'Insert a glyphicon in front of the alert content.'},
					{name:'theme',type:'string',refreshable:false,description:'Specifies the theme for this element [Default, danger, info, warning, Primary] (default)'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},	
					{name:'children',type:'array',refreshable:false,description:'Child elements'}		
				]
			};
			break;
			
		case '$badge':
			documentation = {
				description:'Creates a badge to highlight new or unread items.',

				attributes:[
					{name:'content',type:'string',refreshable:true,description:'Content of the badge'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},		 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}					
				]
			};
			break;

		case '$breadcrumb':
			documentation = {
				description:'Creates breadcrumbs indicate the location of current page within a navigational hierarchy.',

				attributes:[
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},					
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			};
			break;
			
		case '$break':
			documentation = {
				description:'Creates an HTML5 <br> element. It will not require any attributes.',

				attributes:[]
			
			};
			break;
					
		case '$button':

			documentation = {
				description:'Creates an HTML5 Button',
				attributes: [
					{name:'buttonType',type:'string',refreshable:false,description:'Sets the type of button. (button) [button, reset, submit]'},
					{name:'theme',type:'string',refreshable:false,description:'Sets the Theme for this button. (default) [default, primary, success, warning, danger, info]'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets additional CSS classes for this button.'},
					{name:'content',type:'string',refreshable:true,description:'Sets the label/content of the button element'},
					{name:'icon',type:'string',refreshable:false,description:'Uses a Glyphicon in the content. (See Bootstrap documentation)'},
					{name:'iconRight',type:'boolean',refreshable:false,description:'Sets the Glyphicon position to the right. (false)'},			 
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'dataToggle',type:'string',refreshable:false,description:'Hooks up the button to a type of widget[modal, collapse, dropdown, tab]'},
					{name:'dataTarget',type:'string',refreshable:false,description:'Points button to the widget that will be changed, starts with "#" and followed by the id of targeted widget'},
					{name:'blocklevel',type:'boolean',refreshable:true,description:'Determines whether this button is displayed as a full-width block - width:100%'},
					{name:'size',type:'string',refreshable:false,description:'Determines how large the button should be. [xs, s, lg]'},
					{name:'active',type:'boolean',refreshable:true,description:'Determines whether this button will be marked as "active". (False)'},
					{name:'asLink',type:'boolean',refreshable:false,description:'Renders the button as an HTML5 <a> element instead of <button> to trigger in-page functionality, rather than navigating to another document or section within the current page. (False)'},
					{name:'href',type:'string',refreshable:false,description:'Used when asLink is set to true, to specify the destination address. (#)'},
					{name:'badge',type:'string',refreshable:true,description:'Uses a badge in the content. (See Bootstrap documentation)'},
					{name:'airaLabel',type:'string',refreshable:false,description:'Defines a string value that labels the current button.'},
					{name:'caret',type:'boolean',refreshable:false,description:'Sets a caret in the button (false)'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If True, the button is disabled and no longer clickable (false)'},
					{name:'onclick',type:'string',refreshable:false,description:'Sets an onclick handler.'},
					{name:'onmouseover',type:'string',refreshable:false,description:'Sets an onmouseover handler'},
					{name:'onmouseout',type:'string',refreshable:false,description:'Sets an onmouseout handler'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'colSize',type:'string',refreshable:false,description:'Used when offset is specified, to set the size of columns that are hold for labels [xs, sm, md, lg] (sm)'},
					{name:'offset',type:'number',refreshable:false,description:'When used in horizontal form, sets the number of columns that are hold for labels [1-11]'}
				]
			};
			break;
			
		case '$buttonGroup':

			documentation = {
				description:'Creates a group whose child elements can be Buttons',
				attributes: [				 
					{name:'size',type:'string',refreshable:false,description:'Sets the size of all child buttons. Size may no longer be changed in the child buttons.'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'vertical',type:'boolean',refreshable:false,description:'Determines whether this group should be vertically aligned'},
					{name:'justified',type:'boolean',refreshable:true,description:'Determines whether all child elements are to have full width'},
					{name:'airaLabel',type:'string',refreshable:false,description:'Defines a string value that labels the current button group.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
				]
			};

			break;
		case '$buttonToolbar':

			documentation = {
				description:'Creates a toolbar from $buttonGroup elements. Each group is represented separately.',
				attributes: [		 
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'airaLabel',type:'string',refreshable:false,description:'Defines a string value that labels the current button toolbar.'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
				]
			};
			break;	
			
		case '$caret':
			
			documentation = {
				description:'Creates a caret in <span> or <b> tag.',
				attributes:[
					{name:'bold',type:'boolean',refreshable:false,description:'Put caret in a <b> tag instead of <span>. (false)'},
				]
			};
			break;
		
		case '$close':

			documentation = {
				description:'Creates a clickable X for popups and alert dialogs. It will not require any attributes.',
				attributes:[]
			};

			break;	
			
		case '$container':
		
			documentation = {
				description:'Creates a fixed-width container for proper alignment and padding.',
				attributes: [			 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
		
		case '$containerFluid':
		
			documentation = {
				description:'Creates a full-width container for proper alignment and padding.',
				attributes: [		 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
		
		case '$div':
		
			documentation = {
				description:'Creates an HTML5 <div> element.',
				attributes: [		 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'airaLabel',type:'string',refreshable:false,description:'Defines a string value that labels the current div.'},
					{name:'role',type:'string',refreshable:false,description:'Defines the role of the current div'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$dropdown':

			documentation = {
				description:'Creates a dropdown menu [top: auto].',
				attributes: [		 
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'inputGroup',type:'boolean',refreshable:false,description:'Determines whether this dropdown would be used before, after, or on both sides of any text-based <input> to extend form controls. (false)'},
					{name:'buttonGroup',type:'boolean',refreshable:false,description:'Determines whether this dropdown would be triggered by a customized button. (false)'},
					{name:'right',type:'boolean',refreshable:true,description:'Determines whether this dropdown would be right aligned. (false)'},
					{name:'asLink',type:'boolean',refreshable:false,description:'Determines whether this dropdown button would be rendered as <a> instead of <button>. (false)'},
					{name:'href',type:'string',refreshable:false,description:'Used when asLink is set to true, to specify the destination address. (#)'},
					{name:'listed',type:'boolean',refreshable:false,description:'Determines whether the dropdown button would be wrapped with <li> to use in navbar. (false)'},
					{name:'separated',type:'boolean',refreshable:false,description:'Determines whether the dropdown menu would be triggered by a split button. (false)'},
					{name:'dropup',type:'boolean',refreshable:false,description:'Determines whether the dropdown menu would be triggered above elements. (false)'},
					{name:'size',type:'string',refreshable:false,description:'Used when buttonGroup is set to be true, to determine how large the button should be. [xs, s, lg]'},
					{name:'theme',type:'string',refreshable:false,description:'Used when buttonGroup is set to be true, to set the Theme for the button. (default) [default, primary, success, warning, danger, info]'},
					{name:'content',type:'string',refreshable:true,description:'Sets the label/content of the dropdown button'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'style',type:'string',description:'Sets the style attribute for this element'}
				]
			};

			break;
			
		case '$dropdownMenuItem':

			documentation = {
				description:'Creates an item for a dropdown menu.',
				attributes: [
					{name:'header',type:'boolean',refreshable:false,description:'Determines whether this item would be a header that labels section of actions. (false)'},
					{name:'divider',type:'boolean',refreshable:false,description:'Determines whether this item would be a divider. If true, no content is needed for it. (false)'},
					{name:'disabled',type:'boolean',refreshable:true,description:'If True, this item is disabled and no longer clickable (false)'},
					{name:'href',type:'string',refreshable:false,description:'specifies the destination address. (#)'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'content',type:'string',refreshable:true,description:'Used when divider is not true, to set the label/content of the dropdown item'}
				]
			};

			break;
		
		case '$fieldset':
		
			documentation = {
				description:'Creates an HTML5 <fieldset> element.',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'disabled',type:'boolean',refreshable:false,description:'If true, all the controls within it are disabled at once(false)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
		
		case '$form':

			documentation = {
				description:'Creates a form that is compatible with Bootstrap plugins.',
				attributes:[	 
					{name:'horizontal',type:'boolean',refreshable:true,description:'Specifies whether the form elements should be positioned horizontally'},
					{name:'inline',type:'boolean',refreshable:true,description:'Specifies whether the form elements should be displayed inline'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'method',type:'string',refreshable:false,description:'Specifies how to send form-data [get, post]'},
					{name:'action',type:'string',refreshable:false,description:'Specifies where to send the form-data when a form is submitted'}
				]
			};

			break;
			
		case '$formGroup':

			documentation = {
				description:'Creates a form group that wraps inputs and input groups in a form for optimum spacing.',
				attributes:[	 
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'validation',type:'string',refreshable:false,description:'Sets the validation styles on form controls [error, warning, success]'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'feedback',type:'boolean',refreshable:true,description:'Determines whether to add an optional feedback icon in addition to the validation style. This needs to be paired with the feedbackIcon of its input or inputGroup child.'},
					{name:'size',type:'string',refreshable:false,description:'Determines how large a form ,whose horizontal attribute has been set to be true, and its label should be. (md) [xs, sm, md, lg]'}
				]
			};

			break;
			
		case '$glyphicon':
			documentation = {
				description:'Creates a Glyphicon.',
				attributes: [
					{name:'icon',type:'string',refreshable:false,description:'Sets the icon. (See Bootstrap documentation)'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'right',type:'boolean',refreshable:true,description:'Determines whether to right align this icon.'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
				]
			}
			break;
			
		case '$gridColumn':
			documentation = {
				description:'Sets the columns of the gridSystem',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'lg',type:'number',refreshable:false,description:'Determines the width of the column on large screen device [1-12]'},
					{name:'md',type:'number',refreshable:false,description:'Determines the width of the column on medium screen device [1-12]'},
					{name:'sm',type:'number',refreshable:false,description:'Determines the width of the column on small screen device [1-12]'},
					{name:'xs',type:'number',refreshable:false,description:'Determines the width of the column on extra small screen device [1-12]'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$gridSystem':
			documentation = {
				description:'Creates a grid system (row).',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$h1':
			documentation = {
				description:'Creates a header element',
				attributes:[
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},		 
					{name:'content',type:'string',refreshable:true,description:'Content of the text'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'ovSize',type:'number',refreshable:false,description:'Overwrite the size of the header (1) [1-6]'},
					{name:'subtext',type:'string',refreshable:true,description:'Content of the sub text'},
					{name:'label',type:'string',refreshable:true,description:'Content of the label'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'labelTheme',type:'string',refreshable:false,description:'Used when label is defined, to set the theme of the label (default) [default, primary, success, warning, danger, info]'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
				
		case '$image':

			documentation = {
				description:'Creates an <img> that HTML5 styles support.',
				attributes: [		 
					{name:'src',type:'string',refreshable:false,description:'Source of the image. '},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'alt',type:'string',refreshable:false,description:'Sets the alternative text if images are disabled in the browser.'},
					{name:'imgType',type:'string',refreshable:false,description:'Sets the type of image [rounded, circle, thumbnail]'},
					{name:'center',type:'boolean',refreshable:true,description:'Determines whether to center this image.'},
					{name:'responsive',type:'boolean',refreshable:true,description:'Determines whether to make this image responsive-friendly.'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'onclick',type:'string',refreshable:false,description:'Sets an onclick handler'}
				]
			};
			break;
		
		case '$input':

			documentation = {
				description:'Creates an <input> element.',
				attributes: [	 
					{name:'value',type:'string',refreshable:false,description:'Defines the value for this input (required for checkbox or radio and forbidden for file). For "button", "reset", and "submit" - it defines the text on the button; For "text" and "password"- it defines the initial (default) value of the input field; For "checkbox", "radio", "image" - it defines the value associated with the input (this is also the value that is sent on submit)'},
					{name:'name',type:'string',refreshable:false,description:'Defines the name for this input.  The name attribute is used to reference elements in a JavaScript, or to reference form data after a form is submitted.'},
					{name:'popTitle',type:'string',refreshable:false,description:'Add a tooltip to this element.'},
					{name:'autofocus',type:'boolean',refreshable:false,description:'Determines whether to auto focus on this input when page is loaded.'},
					{name:'disabled',type:'boolean',refreshable:false,description:'Determines whether to disable this input when page is loaded.'},
					{name:'readonly',type:'boolean',refreshable:false,description:'Determines whether to make this input read-only when page is loaded.'},
					{name:'placeholder',type:'string',refreshable:false,description:'Defines the context for form controls within each field'},
					{name:'inputType',type:'string',refreshable:false,description:'Specifies the type of input. This may be any HTML5 compliant type. (text) [text, textarea, password, static, datetime, select, checkbox, radio, file, button, submit, datetime-local, date, month, time, week, number, email, url, search, tel, color]'},
					{name:'label',type:'string',refreshable:true,description:'Creates a label near the input element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'ariaLabel',type:'string',refreshable:false,description:'Provide text labels so that users of screen readers and other adaptive technologies can understand what the object is used for.'},
					{name:'labelStyle',type:'string',refreshable:false,description:'Used with an inputType of checkbox or radio, to set the style for the label. '},
					{name:'inline',type:'string',refreshable:false,description:'Used on a series of checkboxes or radios for controls that appear on the same line. '},
					{name:'rows',type:'number',refreshable:false,description:'Used with an inputType of textarea, to set the number of rows for it. (3) '},
					{name:'theme',type:'string',refreshable:false,description:'Used with an inputType of button or submit, to set the Theme for the button. (default) [default, primary, success, warning, danger, info]'},
					{name:'content',type:'string',refreshable:true,description:'Content of the text. (Normally used for the inputTypes of checkbox, radio and static input)'},
					{name:'feedbackIcon',type:'string',refreshable:false,description:'Add an optional feedback icon to inputTypes other than checkbox, radio, file, submit or button. When used in formGroup, its feedback attribute has to be set to true. [ok, remove, warning-sign]'},
					{name:'hideLabel',type:'string',refreshable:true,description:'Creates a "sr-only" cssClass for the label to hide it.'},
					{name:'help',type:'string',refreshable:true,description:'Creates slightly grayed help text near the input element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'size',type:'string',refreshable:false,description:'Creates taller or shorter form controls. (md) [xs, sm, md, lg]'},
					{name:'colSize',type:'string',refreshable:false,description:'Used when offset is specified, to set the size of columns that are hold for labels [xs, sm, md, lg] (sm)'},
					{name:'offset',type:'number',refreshable:false,description:'When used in horizontal form, sets the width of columns that are hold for labels [1-11]'}
				]
			};
			break;
			
		case '$inputGroup':

			documentation = {
				description:'Extend form controls by adding text or buttons before, after, or on both sides of any text-based input.  This has to be paired with the $inputGroupAddon.',
				attributes: [
					{name:'asButton',type:'boolean',refreshable:false,description:'When a $button is used as a child, this field must be set to true.'},
					{name:'size',type:'string',refreshable:false,description:'Sets the size of all the child elements.'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'label',type:'string',refreshable:true,description:'Creates a label near the input element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'hideLabel',type:'string',refreshable:true,description:'Creates a "sr-only" cssClass for the label to hide it.'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'feedbackIcon',type:'string',refreshable:false,description:'Add an optional feedback icon to inputTypes other than checkbox, radio, file, submit or button. When used in formGroup, its feedback attribute has to be set to true. [ok, remove, warning-sign]'},
					{name:'colSize',type:'string',refreshable:false,description:'Used when offset is specified, to set the size of columns that are hold for labels [xs, sm, md, lg] (sm)'},
					{name:'offset',type:'number',refreshable:false,description:'When used in horizontal form, sets the width of columns that are hold for labels [1-11]'}
				]
			};
			break;
			
		case '$inputGroupAddon':

			documentation = {
				description:'Creates an input addon. $inputGroup is required for it!',
				attributes: [ 
					{name:'content',type:'string',refreshable:true,description:'Content of the addon'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
				]
			};
			break;
			
		case '$jumbotron':
			documentation = {
				description:'Creates a Jumbotron',
				attributes: [		 
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
		
		case '$label':
			documentation = {
				description:'Creates a label',
				attributes:[
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'theme',type:'string',refreshable:false,description:'Sets the Theme for this element (default)[default, primary, info, danger, warning]'},
					{name:'content',type:'string',refreshable:true,description:'Content of the label'}
				]
			}
			break;
					
		case '$li':

			documentation = {
				description:'Creates a <li> element.',
				attributes: [
					{name:'active',type:'boolean',refreshable:true,description:'Sets "active" status for this element (false)'},
					{name:'disabled',type:'boolean',refreshable:true,description:'Sets "disabled" status for this element (false)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'content',type:'string',refreshable:true,description:'Content of this element'}
				]
			};
			break;
			
		case '$link':

			documentation = {
				description:'Creates an <a> element.',
				attributes: [
					{name:'content',type:'string',refreshable:true,description:'Defines the clickable text.'},
					{name:'href',type:'string',refreshable:false,description:'Sets the URl to be opened with a single click'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'dataToggle',type:'string',refreshable:false,description:'Sets the data-toggle attribute. Needed for some elements.'},
					{name:'dataParant',type:'string',refreshable:false,description:'Sets the data-parent attribute. Needed for some elements.'},
					{name:'ariaExpanded',type:'string',refreshable:false,description:'Sets the aria-expanded attribute. Needed for some elements.'},
					{name:'ariaControls',type:'string',refreshable:false,description:'Sets the aria-controls attribute. Needed for some elements.'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'},
					{name:'tabindex',type:'string',refreshable:false,description:'Sets the tabindex attribute. Needed for some elements.'},
					{name:'onclick',type:'string',refreshable:false,description:'Sets an onclick handler'},
					{name:'theme',type:'string',refreshable:false,description:'Add meaning through text-colors. (default) [default, primary, info, danger, warning]'},
					{name:'textBackground',type:'string',refreshable:false,description:'Add meaning through background-colors. (default) [default, primary, info, danger, warning]'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'listed',type:'boolean',refreshable:false,description:'Determines whether to wrap this link with <li> elements (false)'},
					{name:'active',type:'boolean',refreshable:false,description:'Used when listed is true, to determine whether to set "active" status for the <li> element (false)'},
					{name:'disabled',type:'boolean',refreshable:false,description:'Used when listed is true, to determine whether to set "disabled" status for the <li> element (false)'},
					{name:'badge',type:'string',refreshable:true,description:'Uses a badge in the content. (See Bootstrap documentation)'}
				]
			};
			break;
			
		case '$listGroup':
			documentation = {
				description:'Creates a List Group.',
				attributes : [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'linked',type:'boolean',refreshable:false,description:'When the children of this element are linkified, wrap them with <div> instead of <ul>.  This needs to be paired with the linked attribute of its list group item children.  (false)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$listGroupItem':
			documentation = {
				description:'Creates an Item for a List Group.',
				attributes: [
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'theme',type:'string',refreshable:false,description:'Specifies the Theme. [Default, primary, info, warning, danger] (default)'},
					{name:'linked',type:'boolean',refreshable:false,description:'Linkify list group items by using <a> tags instead of <li>s.  This needs to be paired with the linked attribute of its list group parent.  (false)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'content',type:'string',refreshable:true,description:'Content of this element'},
					{name:'$ignoreSelect',type:'boolean',refreshable:false,values:['true','false'],refreshable:true, description:'If true, suppress default generation of select handlers (if any).'},
					{name:'label',type:'string',refreshable:true,description:'Heading of this element'},
					{name:'active',type:'boolean',refreshable:true,description:'Sets "active" status for this element (false)'},
					{name:'disabled',type:'boolean',refreshable:true,description:'Sets "disabled" status for this element (false)'},
					{name:'icon',type:'string',refreshable:false,description:'Uses a Glyphicon in the content. (See Bootstrap documentation)'},
					{name:'iconRight',type:'boolean',refreshable:true,description:'Sets the Glyphicon position to the right. (false)'},
					{name:'badge',type:'string',refreshable:true,description:'Uses a badge in the content. (See Bootstrap documentation)'}
				]
			}
			break;
			
		case '$mediaObject':

			documentation = {
				description:'Creates abstract object styles for building various types of components (like blog comments, Tweets, etc) that feature a left- or right-aligned image alongside textual content.',
				attributes: [
					{name:'srcLeft',type:'string',refreshable:false,description:'Source of the images or other media at the left of the content block. (...) '},
					{name:'altLeft',type:'string',refreshable:false,description:'Sets the alternative text if images or other media at the left of the content block are disabled in the browser. (...)'},
					{name:'hrefLeft',type:'string',refreshable:false,description:'Sets the URl to be opened with a single click on images or other media at the left of the content block. (#)'},
					{name:'alignLeft',type:'string',refreshable:false,description:'Vertical align images or other media at the left of the content block. (top) [top, middle, bottom].'},
					{name:'srcRight',type:'string',refreshable:false,description:'Source of the images or other media at the right of the content block. (...) '},
					{name:'altRight',type:'string',refreshable:false,description:'Sets the alternative text if images or other media at the right of the content block are disabled in the browser. (...)'},
					{name:'hrefRight',type:'string',refreshable:false,description:'Sets the URl to be opened with a single click on images or other media at the right of the content block. (#)'},
					{name:'alignRight',type:'string',refreshable:false,description:'Vertical align images or other media at the right of the content block. (top) [top, middle, bottom].'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'content',type:'string',refreshable:true,description:'Content of this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'heading',type:'string',refreshable:true,description:'Heading of this element'}
				]
			};
			break;
			
		case '$modal':

			documentation = {
				description:'Creates streamlined, but flexible, dialog prompts with the minimum required functionality and smart defaults.',
				attributes: [
					{name:'airaLabel',type:'string',refreshable:false,description:'Defines a string value that labels the current modal.'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'modalClass',type:'string',refreshable:false,description:'Sets the class attribute for this modal. (modal)'},
					{name:'dialogClass',type:'string',refreshable:false,description:'Sets the class attribute for the dialog. (modal-dialog)'},
					{name:'contentClass',type:'string',refreshable:false,description:'Used when content is defined, to set the class attribute for it. (modal-content)'},
					{name:'headerClass',type:'string',refreshable:false,description:'Sets the class attribute for the header. (modal-header)'},
					{name:'footerClass',type:'string',refreshable:false,description:'Sets the class attribute for the footer. (modal-footer)'},
					{name:'bodyClass',type:'string',refreshable:false,description:'Sets the class attribute for the body. (modal-body)'},
					{name:'titleClass',type:'string',refreshable:false,description:'Sets the class attribute for the title. (modal-title)'},
					{name:'content',type:'string',refreshable:true,description:'Content of this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'label',type:'string',refreshable:true,description:'Title of the content'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'},
					{name:'tabindex',type:'string',refreshable:false,description:'Sets the tabindex attribute. Needed for some elements.'},
					{name:'ariaHidden',type:'boolean',refreshable:false,description:'Determines whether the element and all of its descendants are not visible or perceivable to any user as implemented by the author. (false)'},
					{name:'animation',type:'boolean',refreshable:true,description:'Determines whether the modal would fade in to view rather than simply appear. (true)'},
					{name:'size',type:'string',refreshable:false,description:'Sets the size of all the child elements.'}
				]
			};
			break;
				
		case '$nav':
			documentation = {
				description:'Creates a nav.',
				attributes: [
					{name:'navType',type:'string',refreshable:false,description:'Type of nav. [pills, tabs] (tabs)'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'stacked',type:'boolean',refreshable:true,description:'Specifies that nav pills will be stacked vertically.'},
					{name:'justified',type:'boolean',refreshable:true,description:'The nav is drawn to the full width.'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'},
					{name:'right',type:'boolean',refreshable:true,description:'Determines whether this nav would be right aligned. (false)'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
				]
			};
			break;
			
		case '$navbar':
			documentation = {
				description:'Creates a navbar in the document above.',
				attributes: [
					{name:'brand',type:'string',refreshable:false,description:'Content of the brand'},
					{name:'brandTarget',type:'string',refreshable:false,description:'Sets the URl to be opened with a single click on the brand. (#)'},
					{name:'brandImage',type:'string',refreshable:false,description:'Used when brand is defined, to replace the navbar brand with your own image whose src is specified here.'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},	 
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'headerClass',type:'string',refreshable:false,description:'Specifies a different CSS class for the fixed header (navbar-header)'},
					{name:'navClass',type:'string',refreshable:false,description:'Specifies a different CSS class for the navbar (navbar-default)'},
					{name:'containerClass',type:'string',refreshable:false,description:'Specifies a different CSS class for the container (container-fluid)'},
					{name:'position',type:'string',refreshable:false,description:'Specifies a different position for the navbar [fixed-top, fixed-bottom, static-top]'},
					{name:'inverse',type:'boolean',refreshable:true,description:'Inverts the colors of the navbar (false)'},
					{name:'collapseDisabled',type:'boolean',refreshable:false,description:'Determines whether the collapsible feature would be disabled. (false)'}
				]
			}
			break;
		
		case '$navbarForm':
			documentation = {
				description:'Creates a form content in navbar.',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}, 
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'alignment',type:'string',refreshable:false,description:'Specifies the alignment of the form within its navbar parent. (left) [left, right]'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'}
				]
			}
			break;
				
		case '$ol':

			documentation = {
				description:'Creates a <ol> element.',
				attributes: [
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'},
					{name:'unstyled',type:'boolean',refreshable:true,description:'Determines whether to remove the default list-style and left margin on list items (immediate children only) (false)'},
					{name:'inline',type:'boolean',refreshable:true,description:'Determines whether to place all list items on a single line (false)'}
				]
			};
			break;
			
		case '$option':

			documentation = {
				description:'Creates <option> elements in a select input.',
				attributes: [	 
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'value',type:'string',refreshable:false,description:'Defines the value for this input, which is used to reference elements in a JavaScript, or to reference form data after a form is submitted.'},
					{name:'content',type:'string',refreshable:true,description:'Content of the option'}
				]
			};

			break;

		case '$pageHeader':
			documentation = {
				description:'Creates a Page header',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'header',type:'string',refreshable:true,description:'the title'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'subtext',type:'string',refreshable:true,description:'Small text next to the title'}
				]
			}
			break;
			
		case '$pager':
			documentation = {
				description:'Provides quick previous and next links for simple pagination implementations with light markup and styles. It is great for simple sites like blogs or magazines.',
				attributes: [	 
					{name:'aligned',type:'boolean',refreshable:true,description:'If True, align each link to the sides'},
					{name:'size',type:'string',refreshable:false,description:'Sets the size. [sm, lg]'},
					{name:'arrow',type:'boolean',refreshable:false,description:'If True, add left and right arrows separately to the previous page and next page buttons'},
					{name:'hrefPrev',type:'string',refreshable:false,description:'Sets the URl of the previous page. (#)'},
					{name:'hrefNext',type:'string',refreshable:false,description:'Sets the URl of the next page. (#)'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'disabledPrev',type:'boolean',refreshable:true,description:'If True, the previous page button is disabled and no longer clickable (false)'},
					{name:'disabledNext',type:'boolean',refreshable:true,description:'If True, the next page button is disabled and no longer clickable (false)'},
					{name:'contentPrev',type:'string',refreshable:true,description:'Content on the previous page button. (Previous)'},
					{name:'contentNext',type:'string',refreshable:true,description:'Content on the next page button. (Next)'}
				]
			}
			break;	
			
		case '$pagination':
			documentation = {
				description:'Provides pagination links for your site or app with the multi-page pagination component',
				attributes: [	 
					{name:'size',type:'string',refreshable:false,description:'Sets the size. [sm, lg]'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'hrefPrev',type:'string',refreshable:false,description:'Sets the URl of the previous page. (#)'},
					{name:'hrefNext',type:'string',refreshable:false,description:'Sets the URl of the next page. (#)'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'disabledPrev',type:'boolean',refreshable:true,description:'If True, the previous page button is disabled and no longer clickable (false)'},
					{name:'disabledNext',type:'boolean',refreshable:true,description:'If True, the next page button is disabled and no longer clickable (false)'}
				]
			}
			break;		
			
		case '$panel':
			documentation = {
				description:'Creates a panel.',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},	 
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'theme',type:'string',refreshable:false,description:'Sets the Theme for this element. (default) [default,primary,info,danger,warning]'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$panelBody':
			documentation = {
				description:'Creates a container body for a Panel',
				attributes : [	 
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'content',type:'string',refreshable:true,description:'Content of the panel body'}
				]
			}
			break;	
		
		case '$panelFooter':
			documentation = {
				description:'Creates a footer for a panel',
				attributes : [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'content',type:'string',refreshable:true,description:'Content of the panel footer'}
				]
			}
			break;	
			
		case '$panelHeading':
			documentation = {
				description:'Creates a header for a panel',
				attributes : [	 
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'},
					{name:'ovSize',type:'number',refreshable:false,description:'Set the size of header title [1-6]'},
					{name:'content',type:'string',refreshable:true,description:'Content of the panel header'}
				]
			}
			break;
			
		case '$progressBar':
			documentation = {
				description:'Creates a progress bar to provide up-to-date feedback on the progress of a workflow or action with simple yet flexible progress bars.',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'value',type:'number',refreshable:false,description:'Holds the value of the current progress [0-100]'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'theme',type:'string',refreshable:false,description:'Sets the theme for this element.(default) [default,primary,info,danger,warning]'},
					{name:'minWidth',type:'string',refreshable:false,description:'Sets the minimum width to ensure that the label text remains legible even for low percentages'},
					{name:'active',type:'boolean',refreshable:true,description:'Determines whether to animate the stripes right to left. (false)'},
					{name:'striped',type:'boolean',refreshable:true,description:'Determines whether to use a gradient to create a striped effect. (false)'},
					{name:'label',type:'boolean',refreshable:false,description:'Determines whether to show a visible percentage'}
				]
			}
			break;
			
		case '$raw':
			documentation = {
				description:'Creates an element that can be filled with HTML',
				attributes: [
					{name:'content',type:'string',refreshable:false,description:'any HTML'}
				]
			}
			break;
			
		case '$responsiveEmbed':
			documentation = {
				description:'Creates a Well container',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'element',type:'string',refreshable:false,description:'Determines the type of this element. (iframe) [iframe, embed, video, object]'},
					{name:'src',type:'string',refreshable:false,description:'Sets URL source of the element(skip the http part). (...)'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'descendant',type:'boolean',refreshable:true,description:'Determine whether to match the styling for other attributes. (false)'},
					{name:'ratio',type:'string',refreshable:false,description:'Sets the ratio for this element(16by9) [16by9,4by3]'}
				]
			}
			break;
			
		case '$span':
			documentation = {
				description:'Creates an HTML5 <span> element',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'content',type:'string',refreshable:true,description:'content of the span'}
				]
			}
			break;
			
		case '$table':
			documentation = {
				description:'Creates a table <table>.',
				attributes:[
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'popTitle',type:'string',refreshable:false,description:'Add a tooltip to this element.'},
					{name:'caption',type:'string',refreshable:true,description:'Optional table caption.'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'striped',type:'boolean',refreshable:true,description:'Specifies whether the rows alternate between two colors in this table - crosswalk (false)'},
					{name:'bordered',type:'boolean',refreshable:true,description:'Determines whether the grid should have edges (false)'},
					{name:'hover',type:'boolean',refreshable:true,description:'Determines whether to enable a hover state on table rows (false)'},
					{name:'condensed',type:'boolean',refreshable:true,description:'Reduces the row and column sizes by half - Padding (false)'},
					{name:'responsive',type:'boolean',refreshable:false,description:'Determines whether to make the table scroll horizontally on small devices. (false)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;	
			
		case '$tableBody':
			documentation = {
				description:'Creates a table body <tbody>.',
				attributes: [
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'style',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$tableCell':
			documentation = {
				description:'Creates a table cell <td>.',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'content',type:'string',refreshable:true,description:'Content of the cell. Child elements are still created.'},
					{name:'theme',type:'string',refreshable:false,description:'Specifies the Theme for the cell. [Default, primary, info, warning, danger] (default)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$tableColumn':
			documentation = {
				description:'Creates a column label <th>.',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'scope',type:'string',refreshable:false,description:'Sets the scope attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'content',type:'string',refreshable:true,description:'Content of the label. Child elements are still created.'},
					{name:'theme',type:'string',refreshable:false,description:'Specifies the Theme for the cell. [Default, primary, info, warning, danger] (default)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
			case '$tableFooter':
			documentation = {
				description:'Creates a table header <tfoot>.',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
			case '$tableHeader':
			documentation = {
				description:'Creates a table header <thead>.',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;
			
		case '$tableRow':
			documentation = {
				description:'Creates a table row <tr>',
				attributes: [	 
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'theme',type:'string',refreshable:false,description:'Defines the theme used for this row. [Default, primary, info, warning, danger] (default)'},
					{name:'active',type:'boolean',refreshable:true,description:'Determines whether the hover theme is permanently visible. (False)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'}
				]
			}
			break;	
		
		case '$text':

	      documentation = {
	        description:'Creates text in a paragraph <p>.',
	        attributes: [   
		          {name:'align',type:'string',refreshable:false,description:'Sets the alignment of text. [left, center, right, justify, nowrap]'},
		          {name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
		          {name:'trans',type:'string',refreshable:false,description:'Sets the transformation of text. [lowercase, uppercase, capitalize]'},
		          {name:'theme',type:'string',refreshable:false,description:'Defines the text color. [Default, primary, info, warning, danger]'},
		          {name:'textBackground',type:'string',refreshable:false,description:'Sets the text background. [Default, primary, info, warning, danger]'},
		          {name:'content',type:'string',refreshable:true,description:'Content of the text'},
		          {name:'lead',type:'boolean',refreshable:true,description:'Determines whether to make a paragraph stand out '},
		          {name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
		          {name:'children',type:'array',refreshable:false,description:'Child elements'},
		          {name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
	        ]
	      }
	      break;	
		case '$thumbnail':

			documentation = {
				description:'Extend Bootstrap grid system with the thumbnail component to easily display grids of images, videos, text, and more.',
				attributes: [	 
					{name:'href',type:'string',refreshable:false,description:'specifies the URL address to make the thumbnail clickable. '},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'src',type:'string',refreshable:false,description:'Source of the thumbnail. (...)'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'alt',type:'string',refreshable:false,description:'Sets the alternative text if thumbnails are disabled in the browser. (...)'},
					{name:'imgType',type:'string',refreshable:false,description:'Sets the type of image [rounded, circle, thumbnail]'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'}
				]
			};
			break;
			
		case '$ul':

			documentation = {
				description:'Creates a <ul> element.',
				attributes: [	 
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'},
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},
					{name:'role',type:'string',refreshable:false,description:'Sets the role attribute. Needed for some elements.'},
					{name:'unstyled',type:'boolean',refreshable:true,description:'Determines whether to remove the default list-style and left margin on list items (immediate children only) (false)'},
					{name:'inline',type:'boolean',refreshable:true,description:'Determines whether to place all list items on a single line (false)'}
				]
			};
			break;
				
		case '$well':
			documentation = {
				description:'Creates a Well container',
				attributes: [
					{name:'style',type:'string',refreshable:false,description:'Sets the style attribute for this element'},			 
					{name:'children',type:'array',refreshable:false,description:'Child elements'},
					{name:'size',type:'string',refreshable:false,description:'Sets the size. [xs, lg]'},
					{name:'key',type:'string',refreshable:false,description:'Key that identifies this layout object. The name of a key cannot include a colon (:).'},
					{name:'content',type:'string',refreshable:true,description:'Content of the well'},
					{name:'cssClass',type:'string',refreshable:false,description:'Sets the class attribute for this element'}
				]
			}
			break;
			
		}
			  return documentation;
}

}
