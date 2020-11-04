/// This plugin adds support for the Twitter Bootstrap library. It was developed and tested with
/// Twitter Bootstrap version 3.3.x and jQuery 1.11.3.
/// 
/// 1.0.4
/// 		- NAN018 - Zen Mojo wizard refined for Twitter Bootstrap
/// 
/// 1.0.3
/// 		- NAN014 - add support for $hide and $show to twitter Boostrap
///  
/// 1.0.2
/// 		- NAN012 - Twitter Bootstrap: add support for $docorateControl
/// 
/// 1.0.1
/// 		- NAN009 - Twitter Bootstrap: add support for $refresh
/// 
/// 1.0.0
/// 		- NAN006 - Twitter Bootstrap plugin helper checkin
/// 
Class %ZEN.Mojo.Plugin.bootstrap33xHelper Extends %ZEN.Mojo.Plugin.baseHelperPlugin [ System = 3 ]
{

Property pluginName As %String [ InitialExpression = "bootstrap-3.3.x-Helper" ];

/// Milestone.Major.Minor
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.4" ];

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "bootstrap-3.3.x-Helper";

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
		{identifier:'$alert'},
		{identifier:'$badge'},
		{identifier:'$breadcrumb'},
		{identifier:'$button'},
		{identifier:'$buttonGroup'},
		{identifier:'$buttonToolbar'},
		{identifier:'$break'},
		{identifier:'$caret'},	
		{identifier:'$close'},
		{identifier:'$container'},	
		{identifier:'$containerFluid'},
		{identifier:'$div'},
		{identifier:'$dropdown'},
		{identifier:'$dropdownMenuItem'},
		{identifier:'$fieldset'},
		{identifier:'$form'},
		{identifier:'$formGroup'},
		{identifier:'$glyphicon'},
		{identifier:'$gridColumn'},
		{identifier:'$gridSystem'},
		{identifier:'$h1'},
		{identifier:'$image'},
		{identifier:'$input'},
		{identifier:'$inputGroup'},
		{identifier:'$inputGroupAddon'},
		{identifier:'$jumbotron'},
		{identifier:'$label'},
		{identifier:'$li'},
		{identifier:'$link'},
		{identifier:'$listGroup'},
		{identifier:'$listGroupItem'},
		{identifier:'$mediaObject'},
		{identifier:'$modal'},
		{identifier:'$nav'},
		{identifier:'$navbar'},
		{identifier:'$navbarForm'},
		{identifier:'$ol'},
		{identifier:'$option'},
		{identifier:'$pageHeader'},
		{identifier:'$pager'},
		{identifier:'$pagination'},
		{identifier:'$panel'},
		{identifier:'$panelBody'},
		{identifier:'$panelFooter'},
		{identifier:'$panelHeading'},
		{identifier:'$progressBar'},
		{identifier:'$raw'},
		{identifier:'$responsiveEmbed'},
		{identifier:'$span'},
		{identifier:'$table'},
		{identifier:'$tableBody'},
		{identifier:'$tableCell'},
		{identifier:'$tableColumn'},
		{identifier:'$tableHeader'},
		{identifier:'$tableFooter'},
		{identifier:'$tableRow'},
		{identifier:'$text'},
		{identifier:'$thumbnail'},
		{identifier:'$ul'},
		{identifier:'$well'}
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
		case '$breadcrumb':
		case '$buttonGroup':
		case '$buttonToolbar':
		case '$container':
		case '$containerFluid':
		case '$div':
		case '$dropdown':
		case '$formGroup':
		case '$gridColumn':
		case '$gridSystem':	
		case '$inputGroup':
		case '$inputGroupAddon':
		case '$jumbotron':
		case '$listGroup':
		case '$mediaObject':
		case '$modal':
		case '$nav':
		case '$navbar':
		case '$navbarForm':
		case '$ol':
		case '$panel':
		case '$panelBody':
		case '$panelFooter':
		case '$panelHeading':
		case '$table':
		case '$tableBody':
		case '$tableFooter':
		case '$tableHeader':
		case '$tableRow':
		case '$ul':
		case '$well':
			instance.$isLoop = true;
			instance.$children = [];
			break;
			
		// decorate control layout objects before rendering	
		case '$option':
		case '$input':	
		case '$progressBar':	
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
	}
	
	
	
	switch(type) {
		case '$onload':
			instance.$render = this.renderOnload;
			instance.$refresh = function () {};
		break;
		case '$div':
			instance.$render = this.renderDiv;
			instance.$refresh = function () {};
			break;
		case '$button':
			instance.$render = this.renderButton;
			instance.$refresh = this.refreshButton;
			break;
		case '$buttonGroup':
			instance.$render = this.renderButtonGroup;
			instance.$refresh = this.refreshButtonGroup;
			break;
		case '$buttonToolbar':
			instance.$render = this.renderButtonToolbar;
			instance.$refresh = function () {};
			break;
		case '$dropdown':
			instance.$render = this.renderDropdown;
			instance.$refresh = this.refreshDropdown;
			break;
		case '$dropdownMenuItem':
			instance.$render = this.renderDropdownMenuItem;		
			instance.$refresh = this.refreshDropdownMenuItem;
			break;
		case '$li':
			instance.$render = this.renderLi;
			instance.$refresh = this.refreshLi;
			break;
		case '$ul':
			instance.$render = this.renderUl;
			instance.$refresh = this.refreshUl;
			break;
		case '$ol':
			instance.$render = this.renderOl;
			instance.$refresh = this.refreshOl;
			break;
		case '$link':
			instance.$render = this.renderLink;
			instance.$refresh = this.refreshLink;
			break;
		case '$mediaObject':
			instance.$render = this.renderMediaObject;
			instance.$refresh = this.refreshMediaObject;
			break;
		case '$modal':
			instance.$render = this.renderModal;
			instance.$refresh = this.refreshModal;
			break;
		case '$image':
			instance.$render = this.renderImage;
			instance.$refresh = this.refreshImage;
			break;
		case '$text':
			instance.$render = this.renderText;
			instance.$refresh = this.refreshText;
			break;
		case '$caret':
			instance.$render = this.renderCaret;
			instance.$refresh = function () {};
			break;
		case '$break':
			instance.$render = this.renderBreak;
			instance.$refresh = function () {};
			break;
		case '$close':
			instance.$render = this.renderClose;
			instance.$refresh = function () {};
			break;
		case '$fieldset':
			instance.$render = this.renderFieldset;
			instance.$refresh = function () {};
			break;
		case '$form':
			instance.$render = this.renderForm;
			instance.$refresh = this.refreshForm;
			break;
		case '$formGroup':
			instance.$render = this.renderFormGroup;
			instance.$refresh = this.refreshFormGroup;
			break;
		case '$input':
			instance.$renderControl = this.renderInput;
			instance.$refresh = this.refreshInput;
			break;
			
		case '$inputGroup':
			instance.$render = this.renderInputGroup;
			instance.$refresh = this.refreshInputGroup;
			break;
		case '$inputGroupAddon':
			instance.$render = this.renderInputGroupAddon;
			instance.$refresh = this.refreshInputGroupAddon;
			break;
		case '$nav':
			instance.$render = this.renderNav;
			instance.$refresh = this.refreshNav;
			break;
		case '$navbar':
			instance.$render = this.renderNavBar;
			instance.$refresh = this.refreshNavBar;
			break;
		case '$navbarForm':
			instance.$render = this.renderNavBarForm;
			instance.$refresh = function () {};
			break;
		case '$jumbotron':
			instance.$render = this.renderJumbotron;
			instance.$refresh = function () {};
			break;
		case '$h1':
			instance.$render = this.renderH1;
			instance.$refresh = this.refreshH1;
			break;
		case '$well':
			instance.$render = this.renderWell;
			instance.$refresh = this.refreshWell;
			break;
		case '$progressBar':
			instance.$renderControl = this.renderProgressBar;
			instance.$refresh = this.refreshProgressBar
			break;
		case '$panel':
			instance.$render = this.renderPanel;
			instance.$refresh = function () {};
			break;
		case '$panelHeading':
			instance.$render = this.renderPanelHeading;
			instance.$refresh = this.refreshPanelHeading;
			break;
		case '$panelBody':
			instance.$render = this.renderPanelBody;
			instance.$refresh = this.refreshPanelBody;
			break;
		case '$panelFooter':
			instance.$render = this.renderPanelFooter;
			instance.$refresh = this.refreshPanelFooter;
			break;
		case '$listGroup':
			instance.$render = this.renderListGroup;
			instance.$refresh = function () {};
			break;
		case '$listGroupItem':
			instance.$render = this.renderListGroupItem;
			instance.$refresh = this.refreshListGroupItem;
			break;
		case '$raw':
			instance.$render = this.renderRaw;
			instance.$refresh = function () {};
			break;
		case '$responsiveEmbed':
			instance.$render = this.renderResponsiveEmbed;
			instance.$refresh = this.refreshResponsiveEmbed
			break;
		case '$badge':
			instance.$render = this.renderBadge;
			instance.$refresh = this.refreshBadge;
			break;
		case '$alert':
			instance.$render = this.renderAlert;
			instance.$refresh = this.refreshAlert;
			break;
		case '$pageHeader':
			instance.$render = this.renderPageHeaderBS;
			instance.$refresh = this.refreshPageHeaderBS;
			break;
		case '$pager':
			instance.$render = this.renderPager;
			instance.$refresh = this.refreshPager;
			break;
		case '$pagination':
			instance.$render = this.renderPagination;
			instance.$refresh = this.refreshPagination;
			break;
		case '$label':
			instance.$render = this.renderLabel;
			instance.$refresh = this.refreshLabel;
			break;
		case '$breadcrumb':
			instance.$render = this.renderBreadCrumb;
			instance.$refresh = function () {};
			break;
		case '$gridSystem':
			instance.$render = this.renderGridSystem;
			instance.$refresh = function () {};
			break;
		case '$gridColumn':
			instance.$render = this.renderGridColumn;
			instance.$refresh = function () {};
			break;
		case '$container':
			instance.$render = this.renderContainer;
			instance.$refresh = function () {};
			break;
		case '$containerFluid':
			instance.$render = this.renderContainerFluid;
			instance.$refresh = function () {};
			break;
		case '$table':
			instance.$render = this.renderTable;
			instance.$refresh = this.refreshTable;
			break;
		case '$tableRow':
			instance.$render = this.renderTableRow;
			instance.$refresh = this.refreshTableRow;
			break;
		case '$tableCell':
			instance.$render = this.renderTableCell;
			instance.$refresh = this.refreshTableCell;
			break;
		case '$tableHeader':
			instance.$render = this.renderTableHeader;
			instance.$refresh = function () {};
			break;
		case '$tableFooter':
			instance.$render = this.renderTableFooter;
			instance.$refresh = function () {};
			break;
		case '$tableColumn':
			instance.$render = this.renderTableColumn;
			instance.$refresh = this.refreshTableColumn;
			break;
		case '$tableBody':
			instance.$render = this.renderTableBody;
			instance.$refresh = function () {};
			break;
		case '$glyphicon':
			instance.$render = this.renderGlyphicon;
			instance.$refresh = this.refreshGlyphicon;
			break;
		case '$span':
			instance.$render = this.renderSpan;
			instance.$render = this.refreshSpan;
			break;
		case '$option':
			instance.$renderControl = this.renderOption;
			instance.$refresh = this.refreshOption;
			break;
		case '$thumbnail':
			instance.$render = this.renderThumbnail;
			instance.$refresh = function () {};
			break;
	}
	return instance;
}

/// find display value (resolve text, value, and coded values)
ClientMethod getDisplayText() [ Language = javascript ]
{
	var text = '';
	var type = this.$type;
	
	switch(type){
		case '$alert':
		case '$badge':
		case '$button':
		case '$dropdown':
		case '$dropdownMenuItem':
		case '$h1':
		case '$inputGroupAddon':
		case '$label':
		case '$li':
	    case '$link':
	    case '$fieldset':
	    case '$option':
	    case '$panelBody':
	    case '$panelFooter':
	    case '$panelHeading':
	    case '$raw':
	    case '$span':
	    case '$tableCell':
	    case '$tableColumn':
	    case '$text':
	    case '$well':
	    	if('undefined' != typeof this.content){
				text = this.content; 
			}
			break;

		case '$inputGroup':	
			if('undefined' != typeof this.label) {
				text = this.label;
	    	}
	    	break;
	    case '$navbar':	
			if('undefined' != typeof this.brand) {
				text = this.brand;
	    	}
	    	break;
	    case '$table':	
			if('undefined' != typeof this.caption) {
				text = this.caption;
	    	}
	    	break;
		case '$pageHeader':
			if('undefined' != typeof this.header) {
				text = this.header;
		    }
			else if('undefined' != typeof this.subtext){
				text = this.subtext; 
			}
			break;
		case '$mediaObject':
			if('undefined' != typeof this.heading) {
				text = this.heading;
		    }
			else if('undefined' != typeof this.content){
				text = this.content; 
			}
			break;
		case '$glyphicon':
			text = this.icon;
			break;
		case '$image':
		case '$thumbnail':	
			if('undefined' != typeof this.alt) {
				text = this.alt;
		    }
			break;
		case '$progressBar':
			text = this.value+'%';
			break;
		case '$input':
			if('checkbox'==this.inputType || 'radio'==this.inputType || 'static'==this.inputType){
				text = this.content;
			}
			else if('undefined' != typeof this.label) {
				text = this.label;
	    	}
	    	else if('undefined' != typeof this.value) {
				text = this.value;
	    	}
			else if('undefined' != typeof this.ariaLabel) {
				text = this.ariaLabel;
	    	}
			else if('undefined' != typeof this.placeholder){
				text = this.placeholder;
			}
			break;
		case '$listGroupItem':
		case '$modal':
			if('undefined' != typeof this.label) {
				text = this.label;
			}
			else if('undefined' != typeof this.content){
				text = this.content; 
			}
			break;

		default:
			break;
	}
	return text;
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
    // controlType can be name of HTML input type

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
	  case 'text':
	  case 'password':
	  case '':
	  default:
	  	var type = 'text';
        switch(instance.controlType) {
	        case 'password':
	            type = 'password';
	            instance.inputType = 'password'
	            break;
	        default:
	            type = zenGet(instance.controlType);
	            type = type ? type : 'text';
	            break;
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
        instance.$setValue = function(value,notify) {
            this.value = value;
            var ctrl = this.$findElement('control');
            document.getElementById(ctrl.id).checked = value ? true : false;;
            if (notify) {
                this.$documentView.eventHandler(this.$index,event,'change');
            }
        }
        instance.$getControlValue = function() {
            var ctrl = this.$findElement('control');
            return ctrl.checked;
        }
        break; 
        
    case 'static':
        instance.$setValue = function(value,notify) {
            this.value = value;
            var ctrl = this.$findElement('control');
            ctrl.value = value;
            if (notify) {
                this.$documentView.eventHandler(this.$index,event,'change');
            }
        }
        
        instance.$getValue = function() {
            var ctrl = this.$findElement('control');
            return ctrl.innerHTML;
        }
        
        instance.$getControlValue = function() {
            var ctrl = this.$findElement('control');
            return ctrl.innerHTML;
        }
        break;     

    case 'textarea':
        instance.$setValue = function(value,notify) {
            this.value = value;
            var ctrl = this.$findElement('control');
            ctrl.value = value;
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
	  
    case 'date':
	case 'time':
	case 'lookup':
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
		break;

    case 'radio':
        instance.$setValue = function(value,notify) {
            var name = zenGet(this.name);
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
                    if (item && item.controlType=='radio' && item.name==name) {
                        item.value = value;
                    }
                }
            }
        }
        break;
        
     case '$progressBar':
     	instance.$setValue = function(value,notify) {
            this.value = value;      
            var ctrl = this.$findElement('control');
            ctrl.setAttribute("aria-valuenow", value);
            ctrl.setAttribute("style", "width: "+value+"%");
            if(this.label){
	            ctrl.innerHTML = value + '%';
            }
            else{
            	$('#'+ctrl.id+' span').text(value + '%');
            }
            if (notify) {
                this.$documentView.eventHandler(this.$index,event,'change');
            }
        }
        
        instance.$getValue = function() {
            return this.value;
        }
        
        instance.$getControlValue = function() {
            return this.value;
        }
        break; 
        
	  case '$option':
        
        instance.$setValue = function(value,notify) {
            this.value = value;
            var ctrl = this.$findElement('control');
            ctrl.innerHTML = value;

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
    }
}

/// This method is supposed to check that all required libraries have been loaded.
/// Returns true for success, false otherwise.
ClientMethod onCheckLibraries() [ Language = javascript ]
{
    if (typeof $ === 'undefined') {
        alert('jQuery library is not loaded correctly. Check your includes.');
        return false;
    } else if (typeof $.fn.emulateTransitionEnd === 'undefined') {
        alert('bootstrap library is not loaded correctly. Check your includes.');
        return false;
    }
    return true;
}

ClientMethod refreshOption() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderOption() [ Internal, Language = javascript ]
{
	var html = []
	var id 			= ((zenGet(this.id)   ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var value		= zenGet(this.value)  ? ' value="'+zenGet(this.value)+'"' : '';
	var content		= zenGet(this.content)? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<option id="'+id+'"'+value+cbDataStr+extraDataStr+'>'+content);
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</option>');

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderDiv() [ Internal, Language = javascript ]
{
	var html		= [];
	var cssClass	= zenGet(this.cssClass) 		? ' class="'+zenGet(this.cssClass)+'" ' : '';
	var id 			= ((zenGet(this.id) 			? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		= zenGet(this.style) 			? ' style="'+zenGet(this.style)+'" ' : '';
	var role 		= zenGet(this.role,'') 			? ' role="'+zenGet(this.role)+'"' :'';
	var ariaLabel 	= zenGet(this.ariaLabel,'') 	? ' aria-labelledby="'+zenGet(this.ariaLabel)+'"' :'';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<div id="'+id+'" '+style+cssClass+role+ariaLabel+cbDataStr+extraDataStr+'>');
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}	
	return html.join('');
}

ClientMethod refreshGlyphicon() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.right)) {
		tbItem.addClass("pull-right");
	}
	else {
		tbItem.removeClass("pull-right");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderGlyphicon() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var icon 	= 	zenGet(this.icon);
	var id 		= ((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var right	=	zenGet(this.right) ? ' pull-right' : '';
	
	html.push('<span id="'+id+'" class="glyphicon glyphicon-'+icon+right+'"'+style+' aria-hidden="true"> </span>')
		
	return html.join('');
}

ClientMethod renderTableHeader() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass);
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	
	html.push('<thead id="'+id+'" class="'+cls+'" '+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</thead>')
	return html.join('');
}

ClientMethod renderTableFooter() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass);
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	
	html.push('<tfoot id="'+id+'" class="'+cls+'" '+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</tfoot>')
	return html.join('');
}

ClientMethod renderTableBody() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass);
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	
	html.push('<tbody id="'+id+'" class="'+cls+'" '+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</tbody>');
	
	return html.join('');
}

ClientMethod refreshTableColumn() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderTableColumn() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass);
	var id 		= 	((zenGet(this.id)   ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var content = 	zenGet(this.content)? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var style	=	zenGet(this.style)  ? ' style="'+zenGet(this.style)+'"' : '';
	var scope   =   zenGet(this.scope)  ? ' scope="'+zenGet(this.scope)+'"' : '';
	var theme 	= 	zenGet(this.theme);
	
	html.push('<th id="'+id+'" class="'+cls+theme+'"'+scope+style+'>'+content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</th>');
	
	return html.join('');
}

ClientMethod refreshTableCell() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}

	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderTableCell() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass);
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());	
	this.$id = id;
	var content = 	zenGet(this.content,false)? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var theme 	= 	zenGet(this.theme);
	var style	= 	zenGet(this.style)        ? 'style="'+zenGet(this.style)+'"' : '';
		
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<td id="'+id+'" class="'+cls+theme+'" '+style+cbDataStr+extraDataStr+'>');
	html.push(content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child =  this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</td>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshTableRow() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.active)) {
		tbItem.addClass("active");
	}
	else {
		tbItem.removeClass("active");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderTableRow() [ Internal, Language = javascript ]
{
	var html 	= [];
	var cls 	= zenGet(this.cssClass,'') + ' ';
	var id 		= ((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var theme 	= zenGet(this.theme,'');
	var active 	= zenGet(this.active) ? 'active ' : '';
	var style	= zenGet(this.style)  ? ' style="'+zenGet(this.style)+'"' : '';
	
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	
	
	html.push('<tr id="'+id+'" class="'+cls+active+theme+'"'+style+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</tr>');
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshTable() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	var tbItemCap = $('#'+this.$id+' caption');
	
	if (zenGet(this.caption) !== '') {
		tbItemCap.text(this.caption);
	}
	
	if (zenGet(this.striped)) {
		tbItem.addClass("table-striped");
	}
	else {
		tbItem.removeClass("table-striped");
	}
	
	if (zenGet(this.bordered)) {
		tbItem.addClass("table-bordered");
	}
	else {
		tbItem.removeClass("table-bordered");
	}
	
	if (zenGet(this.hover)) {
		tbItem.addClass("table-hover");
	}
	else {
		tbItem.removeClass("table-hover");
	}
	
	if (zenGet(this.condensed)) {
		tbItem.addClass("table-condensed");
	}
	else {
		tbItem.removeClass("table-condensed");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderTable() [ Internal, Language = javascript ]
{
	var html 		= 	[];
	var cls 		= 	zenGet(this.cssClass,'');
	var id 			= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var striped 	= 	zenGet(this.striped) ? ' table-striped' : '';
	var bordered 	= 	zenGet(this.bordered) ? ' table-bordered' : '';
	var hover 		= 	zenGet(this.hover) ? ' table-hover' : '';
	var condensed 	= 	zenGet(this.condensed) ? ' table-condensed' : '';
	var style		=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var title		=	zenGet(this.popTitle) ? ' title="'+zenGet(this.popTitle)+'"' : '';
	var caption		=   zenGet(this.caption,false) ? '<caption>'+this.caption+'</caption>' : '';
	var responsive  =   zenGet(this.responsive,false);
	
	if(responsive){
		html.push('<div class="table-responsive">');
	}
	html.push('<table id="'+id+'" class="table '+cls+striped+bordered+hover+condensed+'" '+title+style+'>'+caption);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</table>');
	
	if(responsive){
		html.push('</div>');
	}
	return html.join('');
}

ClientMethod refreshSpan() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderSpan() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var content = 	zenGet(this.content);
	
	html.push('<span id="'+id+'" class="'+cls+'" '+style+'>'+content);
	html.push('</span>');
	
	return html.join('');
}

ClientMethod renderContainer() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	
	html.push('<div id="'+id+'" class="container '+cls+'"'+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	return html.join('');
}

ClientMethod renderContainerFluid() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	
	html.push('<div id="'+id+'" class="container-fluid '+cls+'" '+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	return html.join('');
}

ClientMethod renderGridColumn() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var xs 		= 	zenGet(this.xs,false)? ' col-xs-'+zenGet(this.xs): '';
	var sm 		= 	zenGet(this.sm,false)? ' col-sm-'+zenGet(this.sm): '';
	var md 		= 	zenGet(this.md,false)? ' col-md-'+zenGet(this.md): '';
	var lg 		= 	zenGet(this.lg,false)? ' col-lg-'+zenGet(this.lg): '';
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';

	html.push('<div id="'+id+'" class="'+cls+xs+sm+md+lg+'" '+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	return html.join('');
}

ClientMethod renderGridSystem() [ Internal, Language = javascript ]
{
	var html 	=	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	
	html.push('<div id="'+id+'" class="row '+cls+'"'+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	return html.join('');
}

ClientMethod renderBreadCrumb() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	
	html.push('<ol id="'+id+'" class="breadcrumb '+cls+'"'+style+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</ol>');
	
	return html.join('');
}

ClientMethod refreshLabel() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderLabel() [ Internal, Language = javascript ]
{
	var html 	= 	[];	
	var content = 	zenGet(this.content,'');
	var theme 	= 	zenGet(this.theme,'default');
	var cls 	= 	' '+zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	
	html.push('<span id="'+id+'" class="label label-'+theme+cls+'"'+style+'>'+content+'</span>');
	
	return html.join('');
}

ClientMethod refreshPageHeaderBS() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+' h1');
	var tbItemSub = $('#'+this.$id+' h1 small');
	if (zenGet(this.subtext) !== '') {
		tbItemSub.text(this.subtext);
	}
	if (zenGet(this.header) !== '') {
		tbItem.text(this.header).append(tbItemSub);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderPageHeaderBS() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var title 	= 	zenGet(this.header,'');
	var subtext = 	zenGet(this.subtext,'');
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	
	html.push('<div id="'+id+'" class="page-header '+cls+'"'+style+'>');
	html.push('<h1>'+title+'<small>'+subtext+'</small></h1>');
	html.push('</div>');
	
	return html.join('');
}

ClientMethod refreshAlert() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id + ' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderAlert() [ Internal, Language = javascript ]
{
	var html		=	[];
	var content 	= 	zenGet(this.content,'')  ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var dismissable = 	zenGet(this.dismissable,false) ? ' alert-dismissable' : '';
	var cls 		= 	' ' + zenGet(this.cssClass,'');
	var id 			= 	((zenGet(this.id)        ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style)       ? ' style="'+zenGet(this.style)+'"' : '';
	var theme 		= 	zenGet(this.theme,false) ? ' alert-' + zenGet(this.theme) : '';
	var glyph 		= 	zenGet(this.icon) 		 ? ' <span class="glyphicon glyphicon-' + zenGet(this.icon) + '" aria-hidden="true"></span><span class="sr-only">'+zenGet(this.icon)+'</span> ' : '';
	
	html.push('<div id="'+id+'" role="alert" class="alert '+theme+dismissable+cls+'"'+style+'>');
	
	if (dismissable !== '') {
		html.push('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>');
	}
	html.push(glyph+content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	return html.join('');
}

ClientMethod refreshBadge() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderBadge() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var content = 	zenGet(this.content,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<span id="'+id+'" class="badge '+cls+'"'+style+cbDataStr+extraDataStr+'>');
	html.push(content);
	html.push('</span>');
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderRaw() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var raw 	= 	zenGet(this.content,'');
	
	html.push(raw);
	
	return html.join('');
}

ClientMethod refreshDropdownMenuItem() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	var tbItemAnch;
		
	if(zenGet(this.header)){
		if (zenGet(this.content) !== '') {
			tbItem.text(this.content);
		}
	}
	else{
		if (zenGet(this.content) !== '') {
			tbItemAnch = $('#'+this.$id+' a');
			tbItemAnch.text(this.content);
		}

		if (zenGet(this.disabled)) {
			tbItem.addClass("disabled");
		}
		else {
			tbItem.removeClass("disabled");
		}
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderDropdownMenuItem() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var header  =   zenGet(this.header,false);
	var divider =   zenGet(this.divider,false);
	var id 		= 	((zenGet(this.id)        ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var content = 	zenGet(this.content,'');
	var disabled=	zenGet(this.disabled,false)? ' class="disabled"' : '';
	var href	=	'';
	
		var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
	}

	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(', ');
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(', ');
	}
	
	if(header){
		html.push('<li id="'+id+'" class="dropdown-header">'+content+'</li>');
	} 
	else if(divider){
		html.push('<li id="'+id+'" class="divider"></li>');
	}
	else{
		href 	= 	zenGet(this.href,'#')
		html.push('<li id="'+id+'"'+disabled+cbDataStr+extraDataStr+'><a href="'+href+'">'+content+'</a></li>');
	}
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	
	return html.join('');
}

ClientMethod refreshProgressBar() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.striped)) {
		tbItem.addClass("progress-bar-striped");
	}
	else {
		tbItem.removeClass("progress-bar-striped");
	}
	
	if (zenGet(this.active)) {
		tbItem.addClass("active");
	}
	else {
		tbItem.removeClass("active");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderProgressBar() [ Internal, Language = javascript ]
{
	var html 	 = 	[];
	var id 		= 	((zenGet(this.id)        ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var theme    =  zenGet(this.theme,false)   ? ' progress-bar-'+zenGet(this.theme): '';
	var value    =  zenGet(this.value);
	var striped  = 	zenGet(this.striped,false) ? ' progress-bar-striped': '';
	var active   =	zenGet(this.active,false)  ? ' active' : '';
	var style	 =	zenGet(this.style,'');
	var minWidth =  zenGet(this.minWidth,false)  ? 'min-width: '+zenGet(this.minWidth)+'; ' : '';
	var label    =  zenGet(this.label,false);

	html.push('<div id="'+id+'" class="progress-bar'+theme+striped+active+'" role="progressbar" aria-valuenow="'+value+'" aria-valuemin="0" aria-valuemax="100" style="'+minWidth+'width: '+value+'%;">');
	if(label){
		html.push(value+'%');
	}
	else{
		html.push('<span class="sr-only">'+value+'% Complete');
		if(theme){
			html.push(' ('+zenGet(this.theme)+')');
		}
		html.push('</span>');
	}
	html.push('</div>');
	return html.join('');
}

ClientMethod refreshListGroupItem() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	var tbItemBadge;
	var tbItemLabel;
	var tbItemPara;
	var tbItemIcon;
	
	if (zenGet(this.disabled)) {
		tbItem.addClass("disabled");
	}
	else {
		tbItem.removeClass("disabled");
	}
	
	if (zenGet(this.active)) {
		tbItem.addClass("active");
	}
	else {
		tbItem.removeClass("active");
	}
	
	if (zenGet(this.icon) !== '') {
		tbItemIcon = $('#'+this.$id+'Icon');
		
		if (zenGet(this.iconRight)) {
			tbItemIcon.addClass("pull-right");
		}
		else {
			tbItemIcon.removeClass("pull-right");
		}
	}
	
	if (zenGet(this.badge) !== '') {
		tbItemBadge = $('#'+this.$id+' .badge');
		tbItemBadge.text(this.badge);
	}
	if (this.label) {
		tbItemLabel = $('#'+this.$id+' h4');
		tbItemLabel.text(this.label);
	}
	if (zenGet(this.content) !== '') {
		tbItemPara = $('#'+this.$id+' .content');
		tbItemPara.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderListGroupItem() [ Internal, Language = javascript ]
{
	var html 	 = 	[];
	var cls 	 = 	zenGet(this.cssClass,'');
	var theme 	 = 	zenGet(this.theme,false)		 ? ' list-group-item-' + zenGet(this.theme) : '';
	var id 		 = 	((zenGet(this.id) 				 ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id 	 =  id;
	var style	 =	zenGet(this.style) 				 ? ' style="'+zenGet(this.style)+'"' :'';
	var listType = 	zenGet(this.linked,false) 		 ? 'a':'li';
	var active   = 	zenGet(this.active,false)		 ? ' active' : '';
	var disabled = 	zenGet(this.disabled,false)		 ? ' disabled' : '';	
	var onSelect = 	zenGet(this.$ignoreSelect,false) ? '': 'onclick="$$$event(\'click\');" ';
	var linkAttr = 	zenGet(this.linked,false)    	 ? ' href="#" '+onSelect : '';
	var badge	 =	zenGet(this.badge,false)	 	 ? '<span class="badge">'+zenGet(this.badge)+'</span>' : '';
	var iconRight=  zenGet(this.iconRight,false) 	 ? ' pull-right' :'';
	var glyph 	 = 	zenGet(this.icon) 			  	 ? ' <span id="'+id+'Icon" class="glyphicon glyphicon-' + zenGet(this.icon) + iconRight+'" aria-hidden="true"></span> ' : '';
	var label    =  zenGet(this.label,false);
	var content  = 	zenGet(this.content,'')  		 ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	
	html.push('<'+listType+linkAttr+' id="'+id+'" class="list-group-item '+cls+theme+active+disabled+'" '+style+cbDataStr+extraDataStr+'>'+badge);
	
	if (this.label) {
		html.push('<h4 class="'+zenGet(this.titleClass,'list-group-item-heading')+'">'+label+'</h4>');
		html.push(glyph);
		if (this.content) {
			html.push('<p class="'+zenGet(this.contentClass,'list-group-item-text')+'">'+content+'</p>');
		}
	}
	else {
		html.push(glyph);
		if (this.content) {
			html.push(content);
		}
	}
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</'+listType+'>');
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderListGroup() [ Internal, Language = javascript ]
{
	var html 	=	[];
	var cls 	= 	zenGet(this.cssClass,'') + ' ';
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' :'';
	var listType=   zenGet(this.linked,false) ? 'div':'ul';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<'+listType+' id="'+id+'" class="list-group '+cls+'" '+style+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</'+listType+'>');
	

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshPanelFooter() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderPanelFooter() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' :'';
	var content =   zenGet(this.content,'') ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="panel-footer '+cls+'"'+style+cbDataStr+extraDataStr+'>'+content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshPanelBody() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderPanelBody() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var content = zenGet(this.content,'') ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="panel-body '+cls+'"'+style+cbDataStr+extraDataStr+'>'+content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshPanelHeading() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id + ' .content');

	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderPanelHeading() [ Internal, Language = javascript ]
{
	var html 		  = [];
	var cls 		  = zenGet(this.cssClass,'');
	var id 			  = ((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id 		  = id;
	var style		  =	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var role		  =	zenGet(this.role) ? ' role="'+zenGet(this.role)+'"' : '';
	var content 	  = zenGet(this.content,'') ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var overWriteSize = zenGet(this.ovSize,false);
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="panel-heading '+cls+'"'+role+style+cbDataStr+extraDataStr+'>');
	if(overWriteSize){
		html.push('<h'+overWriteSize+' class="panel-title">'+content+'</'+overWriteSize+'>');
	}
	else {
		html.push(content);
	}
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
		if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderPanel() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'') ;
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var theme 	= 	' panel-' + zenGet(this.theme,'default');
	var style	=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
		
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="panel '+ cls + theme +'"'+style+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshMediaObject() [ Internal, Language = javascript ]
{
	var tbItemHead = $('#'+this.$id + 'Heading');
	var tbItem = $('#'+this.$id + ' p');
	
	if (zenGet(this.heading) !== '') {
		tbItemHead.text(this.heading);
	}
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderMediaObject() [ Internal, Language = javascript ]
{
	var html 	  = 	[];
	var cls 	  = 	zenGet(this.cssClass,'');
	var id 		  = 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	  =		zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	var hrefLeft  =  	zenGet(this.hrefLeft,'#');
	var srcLeft   =		zenGet(this.srcLeft,'...');
	var altLeft   =		zenGet(this.altLeft,'...');
	var alignLeft =  	zenGet(this.alignLeft,false) ? ' media-'+zenGet(this.alignLeft) : '';
	var hrefRight =  	zenGet(this.hrefRight,'#');
	var	srcRight  =		zenGet(this.srcRight,'...');
	var	altRight  =		zenGet(this.altRight,'...');
	var alignRight= 	zenGet(this.alignRight,false) ? ' media-'+zenGet(this.alignRight) : '';
	var heading   =  	zenGet(this.heading,'');
	var content   = 	zenGet(this.content,'');
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="media '+ cls +'"'+style+cbDataStr+extraDataStr+'>');
	
	if(srcLeft !== '...'){
		html.push('<div id="'+id+'Left" class="media-left'+alignLeft+'">');
		html.push('<a href="'+hrefLeft+'"><img class="media-object" src="'+srcLeft+'" alt="'+altLeft+'"></a></div>');
	}
	
	html.push('<div id="'+id+'Body" class="media-body">');
	html.push('<h4 id="'+id+'Heading" class="media-heading">'+heading+'</h4><p>'+content+'</p>');
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	if(srcRight !== '...'){
		html.push('<div id="'+id+'Right" class="media-right'+alignRight+'">');
		html.push('<a href="'+hrefRight+'"><img class="media-object" src="'+srcRight+'" alt="'+altRight+'"></a></div>');
	}
	html.push('</div>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshResponsiveEmbed() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+'Element');
	
	if (zenGet(this.descendant)) {
		tbItem.addClass("embed-responsive-item");
	}
	else {
		tbItem.removeClass("embed-responsive-item");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderResponsiveEmbed() [ Internal, Language = javascript ]
{
	var html 	  = 	[];
	var id 		  = 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	  =		zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	var element   =  	zenGet(this.element,'iframe');
	var src       =		zenGet(this.src,'...');
	var ratio     =		zenGet(this.ratio,'16by9');
	var descendant=     zenGet(this.descendant,false) ? ' class="embed-responsive-item"' : '';

	html.push('<div id="'+id+'" class="embed-responsive embed-responsive-'+ratio+'">');	
	html.push('<'+element+descendant+' id="'+id+'Element" src="https://'+src+'"></'+element+'>');
	html.push('</div>');
	
	return html.join('');
}

ClientMethod refreshWell() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id + ' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderWell() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var size 	= 	zenGet(this.size,false) ? ' well-' + zenGet(this.size) : '';
	var id 		= 	((zenGet(this.id) 		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) 		? ' style="'+zenGet(this.style)+'"' : '';
	var content =   zenGet(this.content,'') ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<div id="'+id+'" class="well '+ cls + size +'"'+style+cbDataStr+extraDataStr+'>'+content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshH1() [ Internal, Language = javascript ]
{
	var tbItem;
	var tbItemSub;
	var tbItemLabel;
	
	if (zenGet(this.subtext) !== '') {
		tbItemSub = $('#'+this.$id+' small');
		tbItemSub.text(this.subtext);
	}
	if (this.label !== '') {
		tbItemLabel = $('#'+this.$id+' span');
		tbItemLabel.text(this.label);
	}
	if (this.content !== '') {
		tbItem = $('#'+this.$id + ' .content')
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderH1() [ Internal, Language = javascript ]
{
	var html		  =	[];
	var id 			  = ((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		  =	zenGet(this.style)         ? 'style="'+zenGet(this.style)+'"' : '';
	var cssClass 	  = zenGet(this.cssClass,'')   ? 'class="' + zenGet(this.cssClass,'')+'"' : '';
	var overWriteSize = zenGet(this.ovSize,1);
	var content 	  = zenGet(this.content,'')    ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var subtext  	  = zenGet(this.subtext,false) ? ' <small>'+zenGet(this.subtext)+'</small>' : '';
	var labelTheme 	  = zenGet(this.labelTheme,'default');
	var label  		  = zenGet(this.label,false)   ? ' <span class="label label-'+labelTheme+'">'+zenGet(this.label)+'</span>' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<h'+overWriteSize+' '+cssClass+' id="'+id+'" '+style+cbDataStr+extraDataStr+'>'+content+subtext+label);
	if (this.$children) {
		for (var n=0;n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</h'+overWriteSize+'>');
	

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderJumbotron() [ Internal, Language = javascript ]
{
	var html	=	[];
	var cls 	= 	zenGet(this.cssClass,'');
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';	
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="jumbotron ' + cls + '" '+style+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0;n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshModal() [ Internal, Language = javascript ]
{
	
	var tbItem;
	var tbItemHead;
	
	if(this.content !== '') {
		tbItem = $('#'+this.$id + ' p');
		tbItem.text(this.content);
	}
	if(this.title !== ''){
		tbItemHead = $('#'+this.$id + ' h4');
		tbItemHead.text(this.heading);
	}
	if (!zenGet(this.animation,true)) {
		tbItem.addClass("fade");
	}
	else {
		tbItem.removeClass("fade");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderModal() [ Internal, Language = javascript ]
{
	var html 			= 	[];
	var title 			= 	zenGet(this.label,'');
	var content		 	= 	zenGet(this.content,false)    ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var role 	 		= 	zenGet(this.role,false)       ? ' role="'+zenGet(this.role)+'"' : '';
	var tabindex 	 	= 	zenGet(this.tabindex,false)   ? ' tabindex="'+zenGet(this.tabindex)+'"' : '';
	var label 			= 	zenGet(this.ariaLabel,false)  ? ' aria-labelledby="'+zenGet(this.ariaLabel)+'"' : '';
	var hidden 			= 	zenGet(this.ariaHidden,false) ? 'true': 'false';
	var id 				= 	((zenGet(this.id) 			  ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var modalClass 		= 	zenGet(this.modalClass,'modal');
	var dialogClass 	= 	zenGet(this.dialogClass,'modal-dialog');
	var contentClass 	= 	zenGet(this.contentClass,'modal-content');
	var headerClass 	= 	zenGet(this.headerClass,'modal-header');
	var titleClass 		= 	zenGet(this.titleClass,'modal-title');
	var bodyClass 		= 	zenGet(this.bodyClass,'modal-body');
	var footerClass 	= 	zenGet(this.footerClass,'modal-footer');
	var style			=	zenGet(this.style) 			  ? 'style="'+zenGet(this.style)+'"' : '';
	var size			= 	zenGet(this.size,'');
	
	if(!zenGet(this.animation,true)){
		modalClass 		=   modalClass + ' fade';
	}
	if (size !=='') {
		modalClass 		=   modalClass + ' bs-example-modal-'+size;
		dialogClass		=   dialogClass + ' modal-'+size;
	}
	
	html.push('<div class="'+modalClass+'" id="'+id+'"'+tabindex+role+label+' aria-hidden="'+hidden+'">');
	html.push('<div class="'+dialogClass+'">');
	html.push('<div class="'+contentClass+'">');
	html.push('<div class="'+headerClass+'">');
	html.push('<button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true">&times;</button>');
	if (title) {
		html.push('<h4 class="'+titleClass+'">'+title+'</h4>');
	}
	html.push('</div>');
	
	html.push('<div class="'+bodyClass+'">');
	if (content) {
		html.push('<p class="'+contentClass+'">'+content+'</p>');
	}
	
	if (this.$children) {
		for (var n=0;n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	
	html.push('</div>');
	html.push('</div>');
	html.push('</div>');
	
	return html.join('');
}

ClientMethod renderNavBarForm() [ Internal, Language = javascript ]
{
	var html 			= 	[];
	var id 				= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var alignment		=	zenGet(this.alignment) ? zenGet(this.alignment) : 'left';
	var style			=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var role 	        = 	zenGet(this.role,false) ? ' role="'+zenGet(this.role)+'"' : '';
	html.push('<form id="'+id+'"'+role+' class="navbar-form navbar-'+alignment+'"'+style+'>');

	if (this.$children) {
		for (var n=0;n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</form>');
	return html.join('');
}

ClientMethod refreshNavBar() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.inverse)) {
		tbItem.addClass("navbar-inverse");
	}
	else {
		tbItem.removeClass("navbar-inverse");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderNavBar() [ Internal, Language = javascript ]
{
	var html 			= 	[];
	var brandTarget 	= 	zenGet(this.brandTarget,'#');
	var brand 			= 	zenGet(this.brand,false);
	var brandImage		=   '';
	var id 				= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var collapseId 		= 	'';
	var dataTargetId 	= 	'';
	var headerClass 	= 	zenGet(this.headerClass,'navbar-header');
	var containerClass 	= 	zenGet(this.containerClass,'container-fluid');
	var navClass 		= 	zenGet(this.navClass,'navbar-default');
	var inverse 		= 	zenGet(this.inverse,false) ? ' navbar-inverse' : '';
	var style			=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var position		=	zenGet(this.position) ? ' navbar-'+zenGet(this.position) : '';
	var collapseDisabled=   zenGet(this.collapseDisabled,false);
	
	if(!collapseDisabled) {
		collapseId 		= 	id+'-1';
		dataTargetId 	= 	'#'+collapseId;
	}
	if(brand){
		brandImage		=   zenGet(this.brandImage,false) ? '<a class="navbar-brand" href="'+brandTarget+'"><img alt="'+brand+'" src="'+zenGet(this.brandImage)+'"></a>' 
							: '<a class="navbar-brand" href="'+brandTarget+'">'+brand+'</a>';
	}
	
	html.push('<nav id="'+id+'" class="navbar '+navClass+inverse+position+'" '+style+'>');
	html.push('<div class="'+containerClass+'">');
	html.push('<div class="'+headerClass+'">');
	if(collapseDisabled){
		html.push(brandImage+'</div>');
	}
	else{
		html.push('<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="'+dataTargetId+'">');
		html.push('<span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>');
		html.push('</button>');
		html.push(brandImage+'</div>');
		html.push('<div class="collapse navbar-collapse" id="'+collapseId+'">');
	
		if (this.$children) {
			for (var n=0;n<this.$children.length;n++) {
				var child = this.$children[n];
				html.push(child.$renderItem());
			}
		}
		
		html.push('</div>');
	}
	html.push('</div>');
	html.push('</nav>');
	
	return html.join('');
}

ClientMethod refreshNav() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.stacked)) {
		tbItem.addClass("nav-stacked");
	}
	else {
		tbItem.removeClass("nav-stacked");
	}
	
	if (zenGet(this.justified)) {
		tbItem.addClass("nav-justified");
	}
	else {
		tbItem.removeClass("nav-justified");
	}
	
	if (zenGet(this.right)) {
		tbItem.addClass("navbar-right");
	}
	else {
		tbItem.removeClass("navbar-right");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderNav() [ Internal, Language = javascript ]
{
	var html 		= 	[];
	var navType 	= 	zenGet(this.navType,false)     ? 'nav-'+zenGet(this.navType) : '';
	var cls 		= 	zenGet(this.cssClass,'');
	var role		=   zenGet(this.role,false)		? ' role="'+zenGet(this.role)+'"' : '';
	var stacked 	= 	zenGet(this.stacked,false)	? ' nav-stacked'   : '';
	var justified 	= 	zenGet(this.justified,false)? ' nav-justified' : '';
	var right 		= 	zenGet(this.right,false)	? ' navbar-right'  : '';
	var id 			= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<ul id="'+id+'" class="nav '+navType+ cls+stacked+justified+right+'" '+role+style+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0;n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</ul>');
	

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshInputGroupAddon() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id + ' .content');
	
	if (zenGet(this.content) !== '') {
		tbItem.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderInputGroupAddon() [ Internal, Language = javascript ]
{
	var html	=	[];
	var content = 	zenGet(this.content) ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var id 		= 	((zenGet(this.id)    ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style)   ? 'style="'+zenGet(this.style)+'"' : '';
		
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<span id="'+id+'" class="input-group-addon" '+style+cbDataStr+extraDataStr+'>' + content);
	
	if (this.$children) {
		for (var n=0;n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</span>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshInputGroup() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id+'Label');

	if (zenGet(this.label) !== '' ) {
		tbItem.text(this.label);
		
		if (zenGet(this.hideLabel)) {
			tbItem.addClass("sr-only");
		}
		else {
			tbItem.removeClass("sr-only");
		}
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderInputGroup() [ Internal, Language = javascript ]
{
	var html		=	[];
	var size 		= 	zenGet(this.size,'') ? 'input-group-' + zenGet(this.size) : '';
	var asButton 	= 	zenGet(this.asButton,false);
	var id 			= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	var label 		= 	zenGet(this.label);
	var hideLabel	=	zenGet(this.hideLabel,false) ? ' class="sr-only"' : '';
	var colSize		=   zenGet(this.colSize,'sm');
	var offset		=   zenGet(this.offset,false);
	var feedbackIcon= 	zenGet(this.feedbackIcon,false) ? ' <span class="glyphicon glyphicon-'+zenGet(this.feedbackIcon)+' form-control-feedback" aria-hidden="true"></span><span id="'+id+'Status" class="sr-only">('+zenGet(this.feedbackIcon)+')</span>':'';

	if (label !== '') {
		if(offset){
			html.push('<label id="'+id+'Label" class="col-'+colSize+'-'+offset+' control-label" for="'+id+'" >'+label+'</label>');
			html.push('<div class="col-'+colSize+'-'+(12-offset)+'">');
		}
		else{
			html.push('<label id="'+id+'Label"'+hideLabel+' for="'+id+'" >'+label+'</label>');
		}
	}
	else if(offset){
		html.push('<div class="col-'+colSize+'-offset-'+offset+' col-'+colSize+'-'+(12-offset)+'">');
	}
	if (asButton) {
		html.push('<div id="'+id+'_parent" class="input-group-btn">');
	}
	
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	if (!asButton) {
		html.push('<div id="'+id+'" class="input-group ' + size +'" '+style+cbDataStr+extraDataStr+'>');
	}
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>'+feedbackIcon);
	if(offset){
		html.push('</div>')
	}
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	
	return html.join('');
}

ClientMethod refreshInput() [ Internal, Language = javascript ]
{
	var tbItem,tbItemHelp;
	
	if (this.inputType =='checkbox' || this.inputType == 'radio') {
		tbItem = $('#'+this.$id);
		if (zenGet(this.content) !== '') {
			tbItem[0].nextSibling.data = this.content;
		}
	} else if ( this.inputType == 'static' ) {
		tbItem = $('#'+this.$id);
		if (zenGet(this.content) !== '') {
			tbItem.text(this.content);
		}
	} else {
		tbItem = $('#'+this.$id+'Label');
		if (zenGet(this.label) !== '' ) {
			tbItem.text(this.label);
		}
		
		if (zenGet(this.hideLabel)) {
			tbItem.addClass("sr-only");
		}
		else {
			tbItem.removeClass("sr-only");
		}
	}
	if (zenGet(this.help)) {
		tbItemHelp = $('#'+this.$id+'HelpBlock');
		tbItemHelp.text(this.help);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

/// Render an input control. 
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

ClientMethod renderInput() [ Internal, Language = javascript ]
{
	var html 		= 	[];
	var tabindex 	= 	zenGet(this.tabindex,null) ? ' taborder="'+zenGet(this.tabindex)+'" ' : '';
	var value 		= 	zenGet(this.value) ? ' value="'+zenGet(this.value)+'"' : '';
	var type 		= 	zenGet(this.inputType,'text') ? ' type="'+zenGet(this.inputType,'text')+'"' :'';
	var placeholder = 	zenGet(this.placeholder) ? ' placeholder="'+zenGet(this.placeholder)+'"' : '';
	var label 		= 	zenGet(this.label);
	var hideLabel	=	zenGet(this.hideLabel,false) ? ' class="sr-only"' : '';
	var colSize		=   zenGet(this.colSize,'sm');
	var offset		=   zenGet(this.offset,false);
	var help 		= 	zenGet(this.help);
	var id 			= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style) ? ' style="'+zenGet(this.style)+'"' : '';
	var name		= 	zenGet(this.name) ? ' name="'+zenGet(this.name)+'"' : '';
	var cls			=	zenGet(this.cssClass);
	var title		=	zenGet(this.popTitle) ? ' title="'+zenGet(this.popTitle)+'"' : '';
	var content		=	zenGet(this.content);
	var checkbox	=	(zenGet(this.inputType,'text')=="checkbox");
	var radio		=	(zenGet(this.inputType,'text')=="radio");
	var file		=	(zenGet(this.inputType,'text')=="file");
	var textarea	=	(zenGet(this.inputType,'text')=="textarea");
	var static		=	(zenGet(this.inputType,'text')=="static");
	var select		=	(zenGet(this.inputType,'text')=="select");
	var button		=	(zenGet(this.inputType,'text')=="button");
	var submit		=	(zenGet(this.inputType,'text')=="submit");
	var theme		=	'';
	var checked 	=	"";
	var labelStyle	=	'';
	var autofocus	= 	zenGet(this.autofocus,false) ? ' autofocus' : ''
	var ariaDescribe=	'';
	var ariaLabel   =   zenGet(this.ariaLabel,false) ? ' aria-label="'+zenGet(this.ariaLabel)+'"' : '';
	var disabled	=	zenGet(this.disabled,false) ? ' disabled' : '';
	var readonly	=	zenGet(this.readonly,false) ? ' readonly' : '';
	var rows		=   '';
	var inline		=   '';
	var size		=   zenGet(this.size,false) ? ' input-'+zenGet(this.size) : '';
	var feedbackIcon= 	zenGet(this.feedbackIcon,false) ? ' <span class="glyphicon glyphicon-'+zenGet(this.feedbackIcon)+' form-control-feedback" aria-hidden="true"></span><span id="'+id+'Status" class="sr-only">('+zenGet(this.feedbackIcon)+')</span>':'';

	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	if (label !== '') {
		if(offset){
			html.push('<label id="'+id+'Label" class="col-'+colSize+'-'+offset+' control-label" for="'+id+'" >'+label+'</label>');
			html.push('<div class="col-'+colSize+'-'+(12-offset)+'">');
		}
		else{
			html.push('<label id="'+id+'Label"'+hideLabel+' for="'+id+'" >'+label+'</label>');
		}
	}
	else if(offset){
		html.push('<div class="col-'+colSize+'-offset-'+offset+' col-'+colSize+'-'+(12-offset)+'">');
	}
	if (checkbox || radio) {
		checked = zenGet(this.checked,false) ? ' checked' : '';
		inline = zenGet(this.inline,false) ? ' class="'+this.inputType+'-inline"' : '';
		labelStyle = zenGet(this.labelStyle,false) ? ' style="'+labelStyle+'"' : '';
		if(inline === ''){
			html.push('<div class="'+this.inputType+disabled+'" style="margin-top:0px; margin-bottom:-5px;padding-top:3px;">');
		}
		html.push('<label'+inline+labelStyle+'>');
	} 
	else if(button || submit){
		theme = zenGet(this.theme, 'default');
		cls = cls+' btn btn-'+theme;
	}
	else if(!file){
		cls = cls+' form-control'
	}
	if (help !== '') {
		ariaDescribe  =	' aria-describedby="'+id+'HelpBlock"';
	}
	if(textarea){
		rows = zenGet(this.rows, '3');
		html.push('<textarea '+tabindex+' rows="'+rows+'" id="'+id+'" class="'+cls+size+'"'+value+placeholder+ariaDescribe+ariaLabel+style+cbDataStr+extraDataStr+name+title+autofocus+disabled+readonly+'></textarea>');
	}
	else if(static) {
		html.push('<p '+tabindex+' id="'+id+'" class="'+cls+'-static'+size+'"'+value+placeholder+ariaDescribe+ariaLabel+checked+style+cbDataStr+extraDataStr+name+title+'>'+content+'</p>');
	}
	else if(select) {
		multiple = zenGet(this.multiple,false) ? ' multiple' : '';
		html.push('<select '+tabindex+' id="'+id+'"'+multiple+' class="'+cls+size+'"'+ariaDescribe+ariaLabel+checked+style+cbDataStr+extraDataStr+name+title+autofocus+disabled+readonly+'>');
	}
	else{
		html.push('<input '+tabindex+' id="'+id+'" '+type+' class="'+cls+size+'"'+value+placeholder+ariaDescribe+ariaLabel+style+cbDataStr+extraDataStr+name+title+autofocus+disabled+readonly+checked+'>'+content);
	}
	if (help !== '') {
		html.push('<span id="'+id+'HelpBlock" class="help-block">'+help+'</span>');
	}
	
	if (this.$children) {
		for (var n = 0; n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	if (checkbox || radio) {
		html.push('</label>');
		if(inline === ''){
			html.push('</div>');
		}
	}
	if(select) {
		html.push('</select>');
	}
	html.push(feedbackIcon);
	if(offset){
		html.push('</div>')
	}
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderFieldset() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var id 		= 	((zenGet(this.id) ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
	var disabled=	zenGet(this.disabled,false) ? ' disabled' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	
	html.push('<fieldset id="'+id+'" '+style+cbDataStr+extraDataStr+disabled+'>')
	
	if (this.$children) {
		for (var n = 0; n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
		
	html.push('</fieldset>')
	

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshFormGroup() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.feedback)) {
		tbItem.addClass("has-feedback");
	}
	else {
		tbItem.removeClass("has-feedback");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderFormGroup() [ Internal, Language = javascript ]
{
	var html 		= 	[];
	var id 			= 	((zenGet(this.id) 			  ? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style) 			  ? ' style="'+zenGet(this.style)+'"' : '';
	var validation 	= 	zenGet(this.validation,false) ? ' has-'+zenGet(this.validation) : '';
	var feedback	=   zenGet(this.feedback,false)   ? ' has-feedback' : '';
	var size		=   zenGet(this.size,false) 	  ? ' form-group-'+zenGet(this.size) : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="'+id+'" class="form-group'+size+validation+feedback+'"'+style+cbDataStr+extraDataStr+'>')
	
	if (this.$children) {
		for (var n = 0; n<this.$children.length;n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
		
	html.push('</div>')
	

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshForm() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.inline)) {
		tbItem.addClass("form-inline");
	}
	else {
		tbItem.removeClass("form-inline");
	}
	
	if (zenGet(this.horizontal)) {
		tbItem.addClass("form-horizontal");
	}
	else {
		tbItem.removeClass("form-horizontal");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderForm() [ Internal, Language = javascript ]
{
	var html 		= 	[];
	var inline 		= 	zenGet(this.inline) 	? 'form-inline ' : '';
	var horizontal 	= 	zenGet(this.horizontal) ? 'form-horizontal ' : '';
	var cls 		= 	zenGet(this.cssClass) 	? zenGet(this.cssClass) : '';
	var id 			= 	((zenGet(this.id)		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style) 		? ' style="'+zenGet(this.style)+'"' : '';
	var method 		= 	zenGet(this.method) 	? ' method="'+zenGet(this.method)+ '"' : ''
	var action		=	zenGet(this.action)		? ' action="' + zenGet(this.action) + '"' : '';
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<form id="'+id+'" '+cbDataStr+extraDataStr+' class="' + inline + horizontal + cls + '" '+style+method+action+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</form>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderClose() [ Internal, Language = javascript ]
{
	var html = [];
	var style = zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';
		
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<button type="button" '+cbDataStr+extraDataStr+' class="close" aria-hidden="true" '+style+'>&times;</button>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
		
	return html.join('');
}

ClientMethod renderCaret() [ Internal, Language = javascript ]
{
	var html = [];
	if(zenGet(this.bold)){
		html.push('<b class="caret"></b>');
	} else {
	html.push('<span class="caret"></span>');
	}
	return html.join('');
}

ClientMethod renderBreak() [ Internal, Language = javascript ]
{
	var html = [];
	html.push('<br>');
	return html.join('');
}

ClientMethod refreshText() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	var tbItemPara;
	
	if (zenGet(this.lead)) {
		tbItem.addClass("lead");
	}
	else {
		tbItem.removeClass("lead");
	}

	if (zenGet(this.content) !== '') {
		tbItemPara = $('#'+this.$id+' .content')
		tbItemPara.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderText() [ Internal, Language = javascript ]
{
	var html 			= 	[];
	var alignment 		= 	zenGet(this.align) 			? ' text-' + zenGet(this.align) : '';
	var transform 		= 	zenGet(this.trans) 			? ' text-' + zenGet(this.trans) : '';
	var theme			= 	zenGet(this.theme) 			? ' text-' + zenGet(this.theme) : '';
	var textBackground 	= 	zenGet(this.textBackground) ? ' bg-' + zenGet(this.textBackground) : '';
	var cssClass		=	zenGet(this.cssClass,'');
	var lead			=	zenGet(this.lead,false) 	? ' lead' : '';
	var content 		= 	zenGet(this.content)		? '<span class="content">'+zenGet(this.content)+'</span>' : '';	
	var id 				= 	((zenGet(this.id) 			? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style			=	zenGet(this.style) 			? ' style="'+zenGet(this.style)+'"' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<p id="'+id+'" class="'+cssClass+lead+alignment+transform+theme+textBackground+'"'+style+cbDataStr+extraDataStr+'>' + content);
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</p>')	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshImage() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.responsive)) {
		tbItem.addClass("img-responsive");
	}
	else {
		tbItem.removeClass("img-responsive");
	}
	
	if (zenGet(this.center)) {
		tbItem.addClass("center-block");
	}
	else {
		tbItem.removeClass("center-block");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderImage() [ Internal, Language = javascript ]
{
	var html 	=	 [];
	var src 	=	 zenGet(this.src) ? ' src="'+zenGet(this.src)+'"' : '';
	var alt 	=	 zenGet(this.alt) ? ' alt="'+zenGet(this.alt)+'"' : '...';
	var cls 	=	 zenGet(this.cssClass,'');
	var id 		=	 ((zenGet(this.id) 		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var type 	=	 zenGet(this.imgType) 	? ' img-' + zenGet(this.imgType) : '';
	var style	=	 zenGet(this.style)		? ' style="'+zenGet(this.style)+'"' : '';
	var responsive=  zenGet(this.responsive)? ' img-responsive' : '';
	var center	=	 zenGet(this.center)	?  ' center-block' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<img id="'+id+'"' + src + alt + ' class="' + cls + type +responsive+center+'"'+style+cbDataStr+extraDataStr+'>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod renderThumbnail() [ Internal, Language = javascript ]
{
	var html 	=	 [];
	var href 	=	 zenGet(this.href,false)? zenGet(this.href) : '';
	var src 	=	 zenGet(this.src,false) ? ' src="'+zenGet(this.src)+'"' : '...';
	var alt 	=	 zenGet(this.alt,false) ? ' alt="'+zenGet(this.alt)+'"' : '...';
	var cls 	=	 zenGet(this.cssClass,'');
	var id 		=	 ((zenGet(this.id) 		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var type 	=	 zenGet(this.imgtype,false) ? ' img-' + zenGet(this.imgtype) : '';
	var style	=	 zenGet(this.style,false)	? ' style="'+zenGet(this.style)+'"' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	if(href !== ''){
		html.push('<a href="'+href+'" class="thumbnail">');
	}
	else{
		html.push('<div class="thumbnail">');
	}
	html.push('<img id="'+id+'"' + src + alt + ' class="' + cls + type +'"'+style+cbDataStr+extraDataStr+'>');
	html.push('</a>');
	if (this.$children) {
		html.push('<div class="caption">');
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
		html.push('</div>');
	}
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshUl() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.unstyled)) {
		tbItem.addClass("list-unstyled");
	}
	else {
		tbItem.removeClass("list-unstyled");
	}
	
	if (zenGet(this.inline)) {
		tbItem.addClass("list-inline");
	}
	else {
		tbItem.removeClass("list-inline");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderUl() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var id 		= 	((zenGet(this.id) 		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) 		? 'style="'+zenGet(this.style)+'"' : '';
	var role	=	zenGet(this.role)		? ' role="'+zenGet(this.role)+'" ' : '';
	var cls 	= 	zenGet(this.cssClass,'');
	var unstyled=	zenGet(this.unstyled,false) ? ' list-unstyled' : '';
	var inline  =   zenGet(this.inline,false) ? ' list-inline' : '';
	
	if(cls !== '' || unstyled !== '' || inline !== ''){
		cls = ' class="'+cls+unstyled+inline+'"';
	}
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<ul' + cls + ' id="'+id+'" '+style+role+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</ul>')
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshOl() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.unstyled)) {
		tbItem.addClass("list-unstyled");
	}
	else {
		tbItem.removeClass("list-unstyled");
	}
	
	if (zenGet(this.inline)) {
		tbItem.addClass("list-inline");
	}
	else {
		tbItem.removeClass("list-inline");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderOl() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var id 		= 	((zenGet(this.id) 		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) 		? 'style="'+zenGet(this.style)+'"' : '';
	var role	=	zenGet(this.role)		? ' role="'+zenGet(this.role)+'" ' : '';
	var cls 	= 	zenGet(this.cssClass,'');
	var unstyled=	zenGet(this.unstyled,false) ? ' list-unstyled' : '';
	var inline  =   zenGet(this.inline,false) ? ' list-inline' : '';
	
	if(cls !== '' || unstyled !== '' || inline !== ''){
		cls = ' class="'+cls+unstyled+inline+'"';
	}
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}

	html.push('<ol' + cls + ' id="'+id+'" '+style+role+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</ol>')
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshLink() [ Internal, Language = javascript ]
{
	var tbItem = '';
	var tbItemBadge = '';
	
	if (zenGet(this.badge) !== '') {
		tbItemBadge = $('#'+this.$id+' .badge');
		tbItemBadge.text(this.badge);
	}
	if (zenGet(this.content) !== '') {
		tbItem = $('#'+this.$id + ' .content');
		tbItem.text(this.content).append(tbItemBadge);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderLink() [ Internal, Language = javascript ]
{
	var html 		  = 	[];
	var href 		  = 	zenGet(this.href,'#');
	var content 	  = 	zenGet(this.content,'')		? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var id 			  = 	((zenGet(this.id) 			? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var cls 		  = 	zenGet(this.cssClass,'');
	var theme		  = 	zenGet(this.theme) 			? ' text-' + zenGet(this.theme) : '';
	var textBackground=     zenGet(this.textBackground) ? ' bg-' + zenGet(this.textBackground) : '';
	var onclick 	  = 	zenGet(this.onclick,'') 	? ' onclick="'+zenGet(this.onclick)+'"' : '';
	var dataToggle 	  = 	zenGet(this.dataToggle,'') 	? ' data-toggle="'+zenGet(this.dataToggle)+'"' :'';
	var dataParent    =   	zenGet(this.dataParent,'')  ? ' data-parent="'+zenGet(this.dataParent)+'"' :'';
	var ariaExpanded  =   	zenGet(this.ariaExpanded,'')? ' aria-expanded="'+zenGet(this.ariaExpanded)+'"' :'';
	var ariaControls  =   	zenGet(this.ariaControls,'')? ' aria-controls="'+zenGet(this.ariaControls)+'"' :'';
	var style		  =		zenGet(this.style,'') 		? ' style="'+zenGet(this.style)+'"':'';
	var role		  =	 	zenGet(this.role,'')		? ' role="'+zenGet(this.role)+'"' : '';
	var tabindex	  =	 	zenGet(this.tabindex,'')	? ' tabindex="'+zenGet(this.tabindex)+'"' : '';
	var listed		  =  	zenGet(this.listed,false);
	var badge		  = 	zenGet(this.badge,false)    ? '<span class="badge">'+zenGet(this.badge)+'</span>' : '';
	var disabled	  =	  	'';
	var active		  =   	'';
	
	if(cls !== '' || theme !== '' || textBackground !== '' ){
		cls = ' class="' + cls+theme+textBackground  + '"';
	}
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = cbData.join(", ");
	}
	if(listed){
		disabled	=	zenGet(this.disabled,false)	? 'disabled ' : '';
		active 		= 	zenGet(this.active,false)   ? 'active' : '';
		html.push('<li');
		if(disabled || active){
			html.push(' class="'+disabled+active+'"');
		}
		html.push('>');
	}
	html.push('<a '+cls+role+onclick+' href="'+href+'" id="'+id+'"'+dataToggle+dataParent+ariaExpanded+ariaControls+style+cbDataStr+extraDataStr+'>' + content+badge);
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</a>');
	if(listed){
		html.push('</li>');
	}
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshLi() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	var tbItemCont;
	
	if (zenGet(this.disabled)) {
		tbItem.addClass("disabled");
	}
	else {
		tbItem.removeClass("disabled");
	}
	
	if (zenGet(this.active)) {
		tbItem.addClass("active");
	}
	else {
		tbItem.removeClass("active");
	}
	
	if (zenGet(this.content) !== '') {
		tbItemCont = $('#'+this.$id+' .content');
		tbItemCont.text(this.content);
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderLi() [ Internal, Language = javascript ]
{
	var html 		= 	[];
	var activeState = 	zenGet(this.active,'') 	? ' active' : '';
	var content 	= 	zenGet(this.content,'') ? '<span class="content">'+zenGet(this.content)+'</span>' : '';
	var disableState=	zenGet(this.disabled,'')? ' disabled' : '';
	var cls 		= 	zenGet(this.cssClass,'');
	var id 			= 	((zenGet(this.id) 		? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var style		=	zenGet(this.style) 		? ' style="'+zenGet(this.style)+'"' : '';
		
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<li class="' + cls + activeState + disableState+'" id="'+id+'"'+style+cbDataStr+extraDataStr+'>'+content);
	
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</li>');
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshDropdown() [ Internal, Language = javascript ]
{
	var tbItemMenu = $('#'+this.$id+'Menu');
	var tbItemBtn;
	
	if (zenGet(this.content) !== '') {
		tbItemBtn = $('#'+this.$id+'Button .content');
		tbItemBtn[0].innerHTML = this.content;
	}
	
	if (zenGet(this.right)) {
		tbItemMenu.addClass("dropdown-menu-right");
	}
	else {
		tbItemMenu.removeClass("dropdown-menu-right");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderDropdown() [ Internal, Language = javascript ]
{
	var html 	   = 	[];
	var id 		   = 	((zenGet(this.id,'') ? zenGet(this.id) : null) || this.$makeId());
	this.$id = id;
	var cls 	   = 	zenGet(this.cssClass,'');
	var theme      = 	zenGet(this.theme) 			? ' btn-' + zenGet(this.theme) : ' btn-default';
	var size       = 	zenGet(this.size) 			? ' btn-' + zenGet(this.size) : '';
	var content    = 	zenGet(this.content,'') 	? zenGet(this.content) : 'Dropdown ';
	var style	   =	zenGet(this.style) 			? ' style="'+zenGet(this.style)+'"' : '';
	var right	   =	zenGet(this.right,false) 	? ' dropdown-menu-right' : '';
	var asLink	   =	zenGet(this.asLink,false);
	var separated  =	zenGet(this.separated,false);
	var dropup     =    zenGet(this.dropup,false)	? ' dropup' : '';
	var href	   =	'';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}

	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(', ');
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(', ');
	}
	
	if(zenGet(this.inputGroup,false)){
		html.push('<div id="'+id+'" class="input-group-btn '+dropup+cls+'">');
	}
	else if(zenGet(this.buttonGroup,false)){
		html.push('<div id="'+id+'" class="btn-group '+dropup+cls+'" role="group">');
	}
	else if(zenGet(this.dropup,false)){
		html.push('<div id="'+id+'" class="dropup '+cls+'">');
	}
	else if(zenGet(this.listed,false)){
		html.push('<li class="dropdown '+cls+'">');
	}
	else{
		html.push('<div id="'+id+'" class="dropdown '+cls+'">');
	}
	if(separated){
		html.push('<button class="btn'+theme+size+'" type="button"><span class="content">'+content+'</span></button>');
		html.push('<button id="'+id+'Button" class="btn'+theme+size+' dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span></button>');
	}
	else if(!asLink){
		html.push('<button id="'+id+'Button" class="btn'+theme+size+' dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false"><span class="content">'+content+'</span><span class="caret"></span></button>');
	}
	else if(zenGet(this.listed,false)){
		href=zenGet(this.href,'#');
		html.push('<a href="'+href+'" id="'+id+'Button" class="dropdown-toggle" role="button" data-toggle="dropdown" aria-expanded="false"><span class="content">'+content+'</span><span class="caret"></span></a>');
	}
	else{
		href=zenGet(this.href,'#');
		html.push('<a href="'+href+'" id="'+id+'Button" class="btn'+theme+size+' dropdown-toggle" role="button" data-toggle="dropdown" aria-expanded="false"><span class="content">'+content+'</span><span class="caret"></span></a>');
	}
	html.push('<ul id="'+id+'Menu" class="dropdown-menu'+right+'" role="menu" aria-labelledby="'+id+'Button"'+style+cbDataStr+extraDataStr+'>');

	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</ul>');
	if(zenGet(this.listed,false)){
		html.push('</li>');
	}
	else{
		html.push('</div>');
	}
	
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	
	return html.join('');
}

ClientMethod renderButtonToolbar() [ Internal, Language = javascript ]
{
	var html 	= 	[];
	var id 		= 	((zenGet(this.id,'') 	? zenGet(this.id) : null) || this.$makeId());
	this.$id = id;
	var style	=	zenGet(this.style) 		? ' style="'+zenGet(this.style)+'"' : '';
	var label	=   zenGet(this.ariaLabel,false)	? ' aria-label="'+zenGet(this.ariaLabel)+'"' : '';
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	html.push('<div id="' + id + '" class="btn-toolbar" role="toolbar"'+style+label+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');

	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshButtonGroup() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	
	if (zenGet(this.justified)) {
		tbItem.addClass("btn-group-justified");
	}
	else {
		tbItem.removeClass("btn-group-justified");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderButtonGroup() [ Internal, Language = javascript ]
{
	var html 			= [];
	var id 				= ((zenGet(this.id) 			? zenGet(this.id) : null) || this.$makeId());
	this.$id = id;
	var size 			= zenGet(this.size) 			? ' btn-group-' + zenGet(this.size) + ' ' : '';
	var vertical 		= zenGet(this.vertical) 		? '-vertical' : '';
	var justified 		= zenGet(this.justified,false) 	? ' btn-group-justified' : '';
	var style 			= zenGet(this.style)	 		? ' style="'+zenGet(this.style)+'"' : '';
	var label			= zenGet(this.ariaLabel,'')		? ' aria-label="'+zenGet(this.ariaLabel)+'"' : '';
	
	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}
	
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
	
	html.push('<div id="' + id + '" class="btn-group' + vertical + size + justified + '" role="group" '+style+label+cbDataStr+extraDataStr+'>');
	
	if (this.$children) {
		for (var i = 0; i < this.$children.length; i++) {
			var child = this.$children[i];
			html.push(child.$renderItem());
		}
	}
	
	html.push('</div>');
	if (cbDataStr.length>0) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod refreshPagination() [ Internal, Language = javascript ]
{
	var tbItemPrev = $('#'+this.$id+'Prev');
	var tbItemNext = $('#'+this.$id+'Next');
	
	if (zenGet(this.disabledPrev)) {
		tbItemPrev.addClass("disabled");
	}
	else {
		tbItemPrev.removeClass("disabled");
	}
	
	if (zenGet(this.disabledNext)) {
		tbItemNext.addClass("disabled");
	}
	else {
		tbItemNext.removeClass("disabled");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderPagination() [ Internal, Language = javascript ]
{
	var html 			= [];
	var id 				= ((zenGet(this.id) 		? zenGet(this.id) : null) || this.$makeId());
	this.$id = id;
	var size 			= zenGet(this.size) 		? ' pagination-'+zenGet(this.size) : '';
	var disabledPrev	= zenGet(this.disabledPrev) ? ' class="disabled"' : '';
	var disabledNext	= zenGet(this.disabledNext) ? ' class="disabled"' : '';
	var hrefPrev		= zenGet(this.hrefPrev,'#');
	var hrefNext		= zenGet(this.hrefNext,'#');
	
	html.push('<nav><ul id="' + id + '" class="pagination'+size+'">');
	html.push('<li id="' + id + 'Prev"'+disabledPrev+'><a href="'+hrefPrev+'" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>');

	if (this.$children) {
		for (var i = 0; i < this.$children.length; i++) {
			var child = this.$children[i];
			html.push(child.$renderItem());
		}
	}
	
	html.push('<li id="' + id + 'Next"'+disabledNext+'><a href="'+hrefNext+'" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>');

	html.push('</ul></nav>');

	return html.join('');
}

ClientMethod refreshPager() [ Internal, Language = javascript ]
{
	var tbItemPrev = $('#'+this.$id+'Prev');
	var tbItemPrevCont;
	var tbItemNext = $('#'+this.$id+'Next');
	var tbItemNextCont;
	
	if (zenGet(this.contentPrev) !== '') {
		tbItemPrevCont = $('#'+this.$id+'Prev .content');
		tbItemPrevCont.text(this.contentPrev);
	}
	
	if (zenGet(this.contentNext) !== '') {
		tbItemNextCont = $('#'+this.$id+'Next .content');
		tbItemNextCont.text(this.contentNext);
	}
	
	if (zenGet(this.disabledPrev)) {
		tbItemPrev.addClass("disabled");
	}
	else {
		tbItemPrev.removeClass("disabled");
	}
	
	if (zenGet(this.disabledNext)) {
		tbItemNext.addClass("disabled");
	}
	else {
		tbItemNext.removeClass("disabled");
	}
	
	if (zenGet(this.aligned)) {
		tbItemPrev.addClass("previous");
		tbItemNext.addClass("next");
	}
	else {
		tbItemPrev.removeClass("previous");
		tbItemNext.removeClass("next");
	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderPager() [ Internal, Language = javascript ]
{
	var html 			= [];
	var id 				= ((zenGet(this.id) 	? zenGet(this.id) : null) || this.$makeId());
	this.$id = id;
	var size 			= zenGet(this.size) 	? ' pager-'+zenGet(this.size) : '';
	var arrow			= zenGet(this.arrow,false);
	var aligned			= zenGet(this.aligned,false);
	var hrefPrev		= zenGet(this.hrefPrev,'#');
	var hrefNext		= zenGet(this.hrefNext,'#');
	var contentPrev		= zenGet(this.contentPrev,'Previous');
	var contentNext		= zenGet(this.contentNext,'Next');
	var disabledPrev	= zenGet(this.disabledPrev,false);
	var disabledNext	= zenGet(this.disabledNext,false);
	
	html.push('<nav><ul id="' + id + '" class="pager'+size+'">');
	if(aligned || disabledPrev){
		html.push('<li id="' + id + 'Prev" class="');
		if(aligned){
			html.push('previous');
		}
		if(disabledPrev){
			html.push(' disabled');
		}
		html.push('">');
	}
	else{
		html.push('<li id="' + id + 'Prev">');
	}
	html.push('<a href="'+hrefPrev+'">');
	if(arrow){
		html.push('<span aria-hidden="true">&larr;</span> ');	
	}
	html.push('<span class="content">'+contentPrev+'</span></a></li>');
	
	if(aligned || disabledNext){
		html.push('<li id="' + id + 'Next" class="');
		if(aligned){
			html.push('next');
		}
		if(disabledNext){
			html.push(' disabled');
		}
		html.push('">');
	}
	else{
		html.push('<li id="' + id + 'Next">');
	}
	html.push('<a href="'+hrefNext+'"><span class="content">'+contentNext+'</span>');	
	if(arrow){
			html.push('<span aria-hidden="true">&rarr;</span>');
	}

	html.push('</a></li></ul></nav>');

	return html.join('');
}

ClientMethod refreshButton() [ Internal, Language = javascript ]
{
	var tbItem = $('#'+this.$id);
	var tbItemBadge = '';
	var tbItemCont = '';

	if (zenGet(this.blocklevel)) {
		tbItem.addClass("btn-block");
	}
	else {
		tbItem.removeClass("btn-block");
	}
	
	if (zenGet(this.disabled)) {
		tbItem.addClass("disabled");
	}
	else {
		tbItem.removeClass("disabled");
	}
	
	if (zenGet(this.active)) {
		tbItem.addClass("active");
	}
	else {
		tbItem.removeClass("active");
	}
	
	if (zenGet(this.badge)!== '') {
		tbItemBadge = $('#'+this.$id+' .badge');
		tbItemBadge.text(this.badge);
	}
	if (zenGet(this.content) !== '') {
		tbItemCont = $('#'+this.$id+' .content');
		tbItemCont.text(this.content)

	}
	
	if (zenGet(this.hidden) !== '') {this.hidden?this.$hide():this.$show();}
}

ClientMethod renderButton() [ Internal, Language = javascript ]
{
	var html = [];
	
	var documentView 	= 	this.$documentView;
	var type 			= 	zenGet(this.buttonType,'button')? zenGet(this.buttonType,'button')+'"' : '';
	var theme 			= 	zenGet(this.theme) 			  	? zenGet(this.theme) : 'default';
	var size			= 	zenGet(this.size)			 	? ' btn-' + zenGet(this.size) : '';
	var content 		= 	zenGet(this.content) 		  	? '<span class="content">'+zenGet(this.content)+'</span>' : '<span class="content">Button</span>';
	var glyph 			= 	zenGet(this.icon) 			  	? ' <span class="glyphicon glyphicon-' + zenGet(this.icon) + '" aria-hidden="true"></span> ' : '';
	var glyphpos 		= 	zenGet(this.iconRight,false) 	? 'right' : 'left';
	var id 				= 	((zenGet(this.id) 			  	? zenGet(this.id) : null)) || (this.$makeId());
	this.$id = id;
	var blocklevel		= 	zenGet(this.blocklevel,false) 	? ' btn-block' : '';
	var active			= 	zenGet(this.active,false)	  	? ' active' : '';
	var disabled		= 	zenGet(this.disabled,false)	  	? ' disabled' : '';
	var toggle          =   zenGet(this.dataToggle,false) 	? ' data-toggle="'+zenGet(this.dataToggle)+'"' : '';
	var target          =   zenGet(this.dataTarget,false) 	? ' data-target="'+zenGet(this.dataTarget)+'"' : '';
	var badge			=	zenGet(this.badge,false)	  	? '<span class="badge">'+zenGet(this.badge)+'</span>' : '';
	var label			=	zenGet(this.ariaLabel,false)  	? ' aria-label="'+zenGet(this.ariaLabel)+'"' : '';
	var asLink			=	zenGet(this.asLink,false);
	var dropdownClass 	= 	'';
	var href			=	'';
	var colSize		=   zenGet(this.colSize,'sm');
	var offset		=   zenGet(this.offset,false);
	
	if (zenGet(this.dataToggle) === 'dropdown') {
		dropdownClass 	= ' dropdown-toggle';
	}
	var caret		= zenGet(this.caret)			? 	'<span class="caret"></span>'	:	'';
	var cls 		= ' class="btn btn-' + theme + ' ' + zenGet(this.cssClass,'') + size + dropdownClass + blocklevel + active + disabled + '"';	
	var style 		= zenGet(this.style) ? 'style="'+zenGet(this.style)+'"' : '';

	var dataAttrs = [];
	var eventAttrs = [];
	if (this.key) {
		eventAttrs.push('click');
		eventAttrs.push('change');
	}

	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dataAttrLength = dataAttrs.length;
	for (var n=0; n<dataAttrLength; n++) {
		var dataAttr = dataAttrs[n];
		extraData.push(dataAttr.substr(0,4)+"-"+dataAttr.substr(4)+'="'+this[dataAttr]+'"');
	}
	if (dataAttrLength>0) {
		extraDataStr = ', '+extraData.join(", ");
	}
	var cbData = [];
	var cbDataStr = "";
	var eventAttrsLength = eventAttrs.length;
	for (var n=0; n<eventAttrsLength; n++) {
		var eventAttr = eventAttrs[n];
		cbData.push('on'+eventAttr+'="$$$event(\''+eventAttr+'\');"');
	}
	if (eventAttrsLength>0) {
		cbDataStr = ', '+cbData.join(", ");
	}
		
	if(offset){
		html.push('<div class="col-'+colSize+'-offset-'+offset+' col-'+colSize+'-'+(12-offset)+'">');
	}
	
	if(!asLink){
		html.push('<button id="' + id + '" type="' + type + cls + toggle + target + disabled + ' '+cbDataStr+extraDataStr+' '+style+label+'>' );
	} else{
		href	=	zenGet(this.href,'#');
		html.push('<a href="'+href+'"  id="' + id + '" role="' + type + cls + toggle + target + disabled + ' '+cbDataStr+extraDataStr+' '+style+label+'>' );
	}
	if (glyphpos == 'left') {
		html.push(glyph + content + badge + caret);
	} else {
		html.push(content + glyph + badge + caret);
	}
	if (this.$children) {
		for (var n=0; n<this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}
	if(asLink){
		html.push('</a>');
	}
	else{
		html.push('</button>');
	
		if (cbDataStr.length>0) {
			return (this.$documentView.injectEventHandler(html.join(''),this));
		}
	}
	if(offset){
		html.push('</div>');
	}
	return html.join('');
}

/// Opens a modal with a given key. The second argument can be used
/// to provide additional options to the popup.
ClientMethod showModal(key, options) [ Language = javascript ]
{
	if (!options) {
		options = {};
	}
	$('#'+this.$documentView.getItemByKey(key).$makeId()).modal(options);
}

/// This method is used to hide bootstrap elements
/// duration is a string or number specifying the duration of the animation.
/// callback is a function to be executed when the animation completes.
ClientMethod hideElement(duration, callback) [ Internal, Language = javascript ]
{
	switch(this.$type){
		case '$input':
			$('#'+this.$id).closest('div').hide(duration, callback);
			break;
			
		case '$dropdown':
			$('#'+this.$id+'Button').hide(duration, callback);
			break;
			
		case '$modal':
			$('#'+this.$id).modal('hide');
			break;
			
		default:
			$('#'+this.$id).hide(duration, callback);
	}
	
	// Hide labels for specific layout objects
	if (this.label && !this.fieldcontain && $('label[for="'+this.$makeId()+'"]').length>0) {
		$('label[for="'+this.$makeId()+'"]').hide(duration, callback);
	}
	
	// Hide filter for $listview
	if (this.$type == '$listview' && this.filter && $('#'+this.$makeId()).prev().hasClass('ui-listview-filter')) {
		$('#'+this.$makeId()).prev().hide(duration, callback);
	}
}

/// This method is used to show bootstrap elements
/// duration is a string or number specifying the duration of the animation.
/// callback is a function to be executed when the animation completes.
ClientMethod showElement(duration, callback) [ Internal, Language = javascript ]
{
	
	switch(this.$type){
		case '$input':
			$('#'+this.$id).closest('div').show(duration, callback);
			break;
			
		case '$dropdown':
			$('#'+this.$id+'Button').show(duration, callback);
			break;
			
		case '$modal':
			$('#'+this.$id).modal('show');
			break;
			
		default:
			$('#'+this.$id).show(duration, callback);
	}
	
	// Show labels for specific layout objects
	if (this.label && !this.fieldcontain && $('label[for="'+this.$makeId()+'"]').length>0) {
		$('label[for="'+this.$makeId()+'"]').show(duration, callback);
	}
	
	// Show filter for $listview
	if (this.$type == '$listview' && this.filter && $('#'+this.$makeId()).prev().hasClass('ui-listview-filter')) {
		$('#'+this.$makeId()).prev().show(duration, callback);
	}
}

}
