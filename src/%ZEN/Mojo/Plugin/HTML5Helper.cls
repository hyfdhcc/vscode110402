/// This plugin adds support for the base HTML 5 standard.
/// 1.0.6
/// 	- decoupled documentation from plugin
/// 1.0.7
/// 	- corrected typo in the spelling of the "strong" tag
/// 1.0.8
/// 	- deprecated use of $key and $children in favor of key and children
/// 1.0.9
/// 	- corrected extra comma delimiter issue in callback generator
/// 1.0.10
/// 	- added logic to support $extra
/// 1.0.11
/// 	- added custom setter to deal with $select under IE11
/// 1.0.12
/// 	- added remapping for forInput attribute to refernce via keys rather than ids
/// 1.0.13
/// 	- added support for $toggleVisibility() method
/// 1.0.14
/// 	- added logic to address missing properties in early IE versions
/// 	- for defaultShow() and defaultHide() methods
/// 1.1.0
/// 	- revised basic layout object creation to reduce plug-in footprint
/// 	- added $getAttributes method to all objects along with various purely internal methods
/// 	- revised the default setAttribute method to deal with camelcase issues between HTML and Javascript attribute names
/// 	- added support for $refresh()
/// 	- added support for $ignoreClick, $ignoreChange, and $ignoreEvent
/// 1.1.1
/// 	- more revisions to reduce plug-in footprint
/// 1.1.2
/// 	- Rebranded $ignoreClick as $ignoreSelect for consistency with other modules
/// 1.1.3
/// 	- Minor fixes to address refresh issues when the system has been given potentially
/// 	- conflicting directives such as style='display:block' while hidden=true
/// 1.1.4
/// 	- Revised refresh logic to address conflicts between updates to 
/// 	- $contents versus children specifications
/// 1.1.5
/// 	- Revide projection of data attributes to require the prefix of 'data-' 
/// 	- in accordance with HTML5 standards
Class %ZEN.Mojo.Plugin.HTML5Helper Extends %ZEN.Mojo.Plugin.baseHelperPlugin
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "HTML5Helper" ];

/// A version string of the base helper plugin. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.1.5" ];

/// This method returns an array containing objects which
/// describe the all layout and ADA assistive elements
/// the plug-in supports.  Each object in the list has to
/// set the property 'identifier' in order to register the
/// element for this plug-in.
/// Should multiple plug-ins attempt to register the same
/// feature, the documentView component will indicate the
/// conflict.  Use the getPluginConflicts method in order to
/// retrieve the conflicts.
/// The first plugin which registers a feature will be used
/// for dispatching in case there is a conflict.  If you want to
/// change preference, use the setPluginPreference method of the
/// documentView.
ClientMethod getFeatures() [ Language = javascript ]
{
	var features = [
		{identifier:'$a'},
		{identifier:'$abbr'},
		{identifier:'$address'},
		{identifier:'$area'},
		{identifier:'$article'},
		{identifier:'$aside'},
		{identifier:'$audio'},
		{identifier:'$b'},
		{identifier:'$bdi'},
		{identifier:'$bdo'},
		{identifier:'$blockquote'},
		{identifier:'$br'},
		{identifier:'$button'},
		{identifier:'$canvas'},
		{identifier:'$caption'},
		{identifier:'$cite'},
		{identifier:'$code'},
		{identifier:'$col'},
		{identifier:'$colgroup'},
		{identifier:'$datalist'},
		{identifier:'$dd'},
		{identifier:'$del'},
		{identifier:'$details'},
		{identifier:'$dfn'},
		{identifier:'$dialog'},
		{identifier:'$div'},
		{identifier:'$dl'},
		{identifier:'$dt'},
		{identifier:'$em'},
		{identifier:'$embed'},
		{identifier:'$fieldset'},
		{identifier:'$figcaption'},
		{identifier:'$figure'},
		{identifier:'$footer'},
		{identifier:'$form'},
		{identifier:'$h1'},
		{identifier:'$h2'},
		{identifier:'$h3'},
		{identifier:'$h4'},
		{identifier:'$h5'},
		{identifier:'$h6'},
		{identifier:'$header'},
		{identifier:'$hr'},
		{identifier:'$i'},
		{identifier:'$iframe'},
		{identifier:'$img'},
		{identifier:'$input'},
		{identifier:'$ins'},
		{identifier:'$kbd'},
		{identifier:'$keygen'},
		{identifier:'$label'},
		{identifier:'$legend'},
		{identifier:'$li'},
		{identifier:'$main'},
		{identifier:'$map'},
		{identifier:'$mark'},
		{identifier:'$menu'},
		{identifier:'$meter'},
		{identifier:'$nav'},
		{identifier:'$object'},
		{identifier:'$ol'},
		{identifier:'$optgroup'},
		{identifier:'$option'},
		{identifier:'$output'},
		{identifier:'$p'},
		{identifier:'$param'},
		{identifier:'$pre'},
		{identifier:'$progress'},
		{identifier:'$q'},
		{identifier:'$rp'},
		{identifier:'$rt'},
		{identifier:'$ruby'},
		{identifier:'$s'},
		{identifier:'$samp'},
		{identifier:'$section'},
		{identifier:'$select'},
		{identifier:'$small'},
		{identifier:'$source'},
		{identifier:'$span'},
		{identifier:'$strong'},
		{identifier:'$sub'},
		{identifier:'$summary'},
		{identifier:'$sup'},
		{identifier:'$table'},
		{identifier:'$tbody'},
		{identifier:'$td'},
		{identifier:'$textarea'},
		{identifier:'$tfoot'},
		{identifier:'$th'},
		{identifier:'$thead'},
		{identifier:'$time'},
		{identifier:'$tr'},
		{identifier:'$track'},
		{identifier:'$u'},
		{identifier:'$ul'},
		{identifier:'$var'},
		{identifier:'$video'},
		{identifier:'$wbr'}
	];
	return features;
}

/// Create a layout object for a document view.
/// These objects form the layoutgraph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObjects(type, instance) [ Language = javascript ]
{
	var defaultSetValue = function(value,notify) {
		// set the value of the layout item
		this.value = value;
		this.$setAttribute('value',value);
	};
	var defaultGetValue = function() {
		return (this.$getAttribute('value'));
	};
	// for now, turn off all block renders
	instance.$hasBlock = false;
	instance.showTitle = false;
	switch(type) {
		case '__looperDefault':
			instance.$isLoop = true;
			instance.children = [];
			instance.$children = instance.children;
			break;
		default:
			break;
	}
	instance.$_renderAttributeString = this.genericRenderAttributeStr;
	instance.$setAttribute = this.defaultSetAttribute;
	instance.$getAttribute = this.defaultGetAttribute;
	instance.$show = this.defaultShow;
	instance.$hide = this.defaultHide;
	instance.$toggleVisibility = this.defaultToggleVisibility;
	instance.$refresh = this.defaultRefresh;
	switch(type) {
		case '$a':
			instance.$getAttributes = this.getAttributesA;
			instance.$render = this.renderA;
			break;
		case '$abbr':
			instance.$getAttributes = this.getAttributesAbbr;
			instance.$render = this.renderAbbr;
			break;
		case '$address':
			instance.$getAttributes = this.getAttributesAddress;
			instance.$render = this.renderAddress;
			break;
		case '$area':
			instance.$getAttributes = this.getAttributesArea;
			instance.$render = this.renderArea;
			break;
		case '$article':
			instance.$getAttributes = this.getAttributesArticle;
			instance.$render = this.renderArticle;
			break;
		case '$aside':
			instance.$getAttributes = this.getAttributesAside;
			instance.$render = this.renderAside;
			break;
		case '$audio':
			instance.$getAttributes = this.getAttributesAudio;
			instance.$render = this.renderAudio;
			break;
		case '$b':
			instance.$getAttributes = this.getAttributesB;
			instance.$render = this.renderB;
			break;
		case '$bdi':
			instance.$getAttributes = this.getAttributesBdi;
			instance.$render = this.renderBdi;
			break;
		case '$bdo':
			instance.$getAttributes = this.getAttributesBdo;
			instance.$render = this.renderBdo;
			break;
		case '$blockquote':
			instance.$getAttributes = this.getAttributesBlockquote;
			instance.$render = this.renderBlockquote;
			break;
		case '$br':
			instance.$getAttributes = this.getAttributesBr;
			instance.$render = this.renderBr;
			break;
		case '$button':
			instance.$getAttributes = this.getAttributesButton;
			instance.$render = this.renderButton;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$canvas':
			instance.$getAttributes = this.getAttributesCanvas;
			instance.$render = this.renderCanvas;
			break;
		case '$caption':
			instance.$getAttributes = this.getAttributesCaption;
			instance.$render = this.renderCaption;
			break;
		case '$cite':
			instance.$getAttributes = this.getAttributesCite;
			instance.$render = this.renderCite;
			break;
		case '$code':
			instance.$getAttributes = this.getAttributesCode;
			instance.$render = this.renderCode;
			break;
		case '$col':
			instance.$getAttributes = this.getAttributesCol;
			instance.$render = this.renderCol;
			break;
		case '$colgroup':
			instance.$getAttributes = this.getAttributesColgroup;
			instance.$render = this.renderColgroup;
			break;
		case '$datalist':
			instance.$getAttributes = this.getAttributesDatalist;
			instance.$render = this.renderDatalist;
			break;
		case '$dd':
			instance.$getAttributes = this.getAttributesDd;
			instance.$render = this.renderDd;
			break;
		case '$del':
			instance.$getAttributes = this.getAttributesDel;
			instance.$render = this.renderDel;
			break;
		case '$details':
			instance.$getAttributes = this.getAttributesDetails;
			instance.$render = this.renderDetails;
			break;
		case '$dfn':
			instance.$getAttributes = this.getAttributesDfn;
			instance.$render = this.renderDfn;
			break;
		case '$dialog':
			instance.$getAttributes = this.getAttributesDialog;
			instance.$render = this.renderDialog;
			break;
		case '$div':
			instance.$getAttributes = this.getAttributesDiv;
			instance.$render = this.renderDiv;
			break;
		case '$dl':
			instance.$getAttributes = this.getAttributesDl;
			instance.$render = this.renderDl;
			break;
		case '$dt':
			instance.$getAttributes = this.getAttributesDt;
			instance.$render = this.renderDt;
			break;
		case '$em':
			instance.$getAttributes = this.getAttributesEm;
			instance.$render = this.renderEm;
			break;
		case '$embed':
			instance.$getAttributes = this.getAttributesEmbed;
			instance.$render = this.renderEmbed;
			break;
		case '$fieldset':
			instance.$getAttributes = this.getAttributesFieldset;
			instance.$render = this.renderFieldset;
			break;
		case '$figcaption':
			instance.$getAttributes = this.getAttributesFigcaption;
			instance.$render = this.renderFigcaption;
			break;
		case '$figure':
			instance.$getAttributes = this.getAttributesFigure;
			instance.$render = this.renderFigure;
			break;
		case '$footer':
			instance.$getAttributes = this.getAttributesFooter;
			instance.$render = this.renderFooter;
			break;
		case '$form':
			instance.$getAttributes = this.getAttributesForm;
			instance.$render = this.renderForm;
			break;
		case '$h1':
			instance.$getAttributes = this.getAttributesH1;
			instance.$render = this.renderH1;
			break;
		case '$h2':
			instance.$getAttributes = this.getAttributesH2;
			instance.$render = this.renderH2;
			break;
		case '$h3':
			instance.$getAttributes = this.getAttributesH3;
			instance.$render = this.renderH3;
			break;
		case '$h4':
			instance.$getAttributes = this.getAttributesH4;
			instance.$render = this.renderH4;
			break;
		case '$h5':
			instance.$getAttributes = this.getAttributesH5;
			instance.$render = this.renderH5;
			break;
		case '$h6':
			instance.$getAttributes = this.getAttributesH6;
			instance.$render = this.renderH6;
			break;
		case '$header':
			instance.$getAttributes = this.getAttributesHeader;
			instance.$render = this.renderHeader;
			break;
		case '$hr':
			instance.$getAttributes = this.getAttributesHr;
			instance.$render = this.renderHr;
			break;
		case '$i':
			instance.$getAttributes = this.getAttributesI;
			instance.$render = this.renderI;
			break;
		case '$iframe':
			instance.$getAttributes = this.getAttributesIframe;
			instance.$render = this.renderIframe;
			break;
		case '$img':
			instance.$getAttributes = this.getAttributesImg;
			instance.$render = this.renderImg;
			break;
		case '$input':
			instance.$getAttributes = this.getAttributesInput;
			instance.$render = this.renderInput;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$ins':
			instance.$getAttributes = this.getAttributesIns;
			instance.$render = this.renderIns;
			break;
		case '$kbd':
			instance.$getAttributes = this.getAttributesKbd;
			instance.$render = this.renderKbd;
			break;
		case '$keygen':
			instance.$getAttributes = this.getAttributesKeygen;
			instance.$render = this.renderKeygen;
			break;
		case '$label':
			instance.$getAttributes = this.getAttributesLabel;
			instance.$render = this.renderLabel;
			break;
		case '$legend':
			instance.$getAttributes = this.getAttributesLegend;
			instance.$render = this.renderLegend;
			break;
		case '$li':
			instance.$getAttributes = this.getAttributesLi;
			instance.$render = this.renderLi;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$main':
			instance.$getAttributes = this.getAttributesMain;
			instance.$render = this.renderMain;
			break;
		case '$map':
			instance.$getAttributes = this.getAttributesMap;
			instance.$render = this.renderMap;
			break;
		case '$mark':
			instance.$getAttributes = this.getAttributesMark;
			instance.$render = this.renderMark;
			break;
		case '$menu':
			instance.$getAttributes = this.getAttributesMenu;
			instance.$render = this.renderMenu;
			break;
		case '$meter':
			instance.$getAttributes = this.getAttributesMeter;
			instance.$render = this.renderMeter;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$nav':
			instance.$getAttributes = this.getAttributesNav;
			instance.$render = this.renderNav;
			break;
		case '$object':
			instance.$getAttributes = this.getAttributesObject;
			instance.$render = this.renderObject;
			break;
		case '$ol':
			instance.$getAttributes = this.getAttributesOl;
			instance.$render = this.renderOl;
			break;
		case '$optgroup':
			instance.$getAttributes = this.getAttributesOptgroup;
			instance.$render = this.renderOptgroup;
			break;
		case '$option':
			instance.$getAttributes = this.getAttributesOption;
			instance.$render = this.renderOption;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$output':
			instance.$getAttributes = this.getAttributesOutput;
			instance.$render = this.renderOutput;
			break;
		case '$p':
			instance.$getAttributes = this.getAttributesP;
			instance.$render = this.renderP;
			break;
		case '$param':
			instance.$getAttributes = this.getAttributesParam;
			instance.$render = this.renderParam;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$pre':
			instance.$getAttributes = this.getAttributesPre;
			instance.$render = this.renderPre;
			break;
		case '$progress':
			instance.$getAttributes = this.getAttributesProgress;
			instance.$render = this.renderProgress;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			break;
		case '$q':
			instance.$getAttributes = this.getAttributesQ;
			instance.$render = this.renderQ;
			break;
		case '$rp':
			instance.$getAttributes = this.getAttributesRp;
			instance.$render = this.renderRp;
			break;
		case '$rt':
			instance.$getAttributes = this.getAttributesRt;
			instance.$render = this.renderRt;
			break;
		case '$ruby':
			instance.$getAttributes = this.getAttributesRuby;
			instance.$render = this.renderRuby;
			break;
		case '$s':
			instance.$getAttributes = this.getAttributesS;
			instance.$render = this.renderS;
			break;
		case '$samp':
			instance.$getAttributes = this.getAttributesSamp;
			instance.$render = this.renderSamp;
			break;
		case '$section':
			instance.$getAttributes = this.getAttributesSection;
			instance.$render = this.renderSection;
			break;
		case '$select':
			instance.$getAttributes = this.getAttributesSelect;
			instance.$render = this.renderSelect;
			instance.$setValue = defaultSetValue;
			instance.$getValue = defaultGetValue;
			instance.$setAttribute = this.setAttributeSelect;
			break;
		case '$small':
			instance.$getAttributes = this.getAttributesSmall;
			instance.$render = this.renderSmall;
			break;
		case '$source':
			instance.$getAttributes = this.getAttributesSource;
			instance.$render = this.renderSource;
			break;
		case '$span':
			instance.$getAttributes = this.getAttributesSpan;
			instance.$render = this.renderSpan;
			break;
		case '$strong':
			instance.$getAttributes = this.getAttributesStrong;
			instance.$render = this.renderStrong;
			break;
		case '$sub':
			instance.$getAttributes = this.getAttributesSub;
			instance.$render = this.renderSub;
			break;
		case '$summary':
			instance.$getAttributes = this.getAttributesSummary;
			instance.$render = this.renderSummary;
			break;
		case '$sup':
			instance.$getAttributes = this.getAttributesSup;
			instance.$render = this.renderSup;
			break;
		case '$table':
			instance.$getAttributes = this.getAttributesTable;
			instance.$render = this.renderTable;
			break;
		case '$tbody':
			instance.$getAttributes = this.getAttributesTbody;
			instance.$render = this.renderTbody;
			break;
		case '$td':
			instance.$getAttributes = this.getAttributesTd;
			instance.$render = this.renderTd;
			break;
		case '$textarea':
			instance.$getAttributes = this.getAttributesTextarea;
			instance.$render = this.renderTextarea;
			break;
		case '$tfoot':
			instance.$getAttributes = this.getAttributesTfoot;
			instance.$render = this.renderTfoot;
			break;
		case '$th':
			instance.$getAttributes = this.getAttributesTh;
			instance.$render = this.renderTh;
			break;
		case '$thead':
			instance.$getAttributes = this.getAttributesThead;
			instance.$render = this.renderThead;
			break;
		case '$time':
			instance.$getAttributes = this.getAttributesTime;
			instance.$render = this.renderTime;
			break;
		case '$tr':
			instance.$getAttributes = this.getAttributesTr;
			instance.$render = this.renderTr;
			break;
		case '$track':
			instance.$getAttributes = this.getAttributesTrack;
			instance.$render = this.renderTrack;
			break;
		case '$u':
			instance.$getAttributes = this.getAttributesU;
			instance.$render = this.renderU;
			break;
		case '$ul':
			instance.$getAttributes = this.getAttributesUl;
			instance.$render = this.renderUl;
			break;
		case '$var':
			instance.$getAttributes = this.getAttributesVar;
			instance.$render = this.renderVar;
			break;
		case '$video':
			instance.$getAttributes = this.getAttributesVideo;
			instance.$render = this.renderVideo;
			break;
		case '$wbr':
			instance.$getAttributes = this.getAttributesWbr;
			instance.$render = this.renderWbr;
			break;
	}
	return instance;
}

ClientMethod defaultSetAttribute(attr, value) [ Internal, Language = javascript ]
{
	var div = this.$findElement();
	if (!div) return;
	switch(attr) {
		case 'hidden':
			if (value) this.$hide();
			else this.$show();
			break;
		case 'accesskey':
			div.accessKey = value;
			break;
		case 'cssClass':
			div.className = value;
			break;
		case 'contenteditable':
			div.contentEditable = value;
			break;
		case 'tabindex':
			div.tabIndex = value;
			break;
		case 'colspan':
			div.colSpan = value;
			break;
		case 'crossorigin':
			div.crossOrigin = value;
			break;
		case 'datetime':
			div.dateTime = value;
			break;
		case 'defaultTrack':
			div.htmlDefault = value;
			break;
		case 'forInput':
			div.htmlFor = value;
			break;
		case 'formaction':
			div.formAction = value;
			break;
		case 'formenctype':
			div.formEnctype = value;
			break;
		case 'formmethod':
			div.formMethod = value;
			break;
		case 'formnovalidate':
			div.formNoValidate = value;
			break;
		case 'formtarget':
			div.formTarget = value;
			break;
		case 'ismap':
			div.isMap = value;
			break;
		case 'maxlength':
			div.maxLength = value;
			break;
		case 'novalidate':
			div.noValidate = value;
			break;
		case 'readonly':
			div.readOnly = value;
			break;
		case 'rowspan':
			div.rowSpan = value;
			break;
		case 'mimeType':
			div.type = value;
			break;
		case 'buttonType':
			div.type = value;
			break;
		case 'inputType':
			div.type = value;
			break;
		case 'menuType':
			div.type = value;
			break;
		case 'numberingScheme':
			div.type = value;
			break;
		case 'usemap':
			div.useMap = value;
			break;
		default:
			div.setAttribute(attr,value);
			break;
	};
}

ClientMethod defaultGetAttribute(attr) [ Internal, Language = javascript ]
{
	var div = this.$findElement();
	if (!div) return(null);
	var rValue = null;
	switch(attr) {
		case 'accesskey':
			rValue = div.accessKey;
			break;
		case 'cssClass':
			rValue = div.className;
			break;
		case 'contenteditable':
			rValue = div.contentEditable;
			break;
		case 'tabindex':
			rValue = div.tabIndex;
			break;
		case 'colspan':
			rValue = div.colSpan;
			break;
		case 'crossorigin':
			rValue = div.crossOrigin;
			break;
		case 'datetime':
			rValue = div.dateTime;
			break;
		case 'defaultTrack':
			rValue = div.htmlDefault;
			break;
		case 'forInput':
			rValue = div.htmlFor;
			break;
		case 'formaction':
			rValue = div.formAction;
			break;
		case 'formenctype':
			rValue = div.formEnctype;
			break;
		case 'formmethod':
			rValue = div.formMethod;
			break;
		case 'formnovalidate':
			rValue = div.formNoValidate;
			break;
		case 'formtarget':
			rValue = div.formTarget;
			break;
		case 'ismap':
			rValue = div.isMap;
			break;
		case 'maxlength':
			rValue = div.maxLength;
			break;
		case 'novalidate':
			rValue = div.noValidate;
			break;
		case 'readonly':
			rValue = div.readOnly;
			break;
		case 'rowspan':
			rValue = div.rowSpan;
			break;
		case 'mimeType':
			rValue = div.type;
			break;
		case 'buttonType':
			rValue = div.type;
			break;
		case 'inputType':
			rValue = div.type;
			break;
		case 'menuType':
			rValue = div.type;
			break;
		case 'numberingScheme':
			rValue = div.type;
			break;
		case 'usemap':
			rValue = div.useMap;
			break;
		default:
			rValue = div[attr];
			break;
	};
	return rValue;
}

ClientMethod defaultShow() [ Internal, Language = javascript ]
{
	var div = this.$findElement();
	if (!div) return;
	if (!div.hidden) {
		if (div.style && div.style.display!='none') return;
	}
	div.hidden = false;
	if (this._styleDisplay) div.style.display = this._styleDisplay;
	else div.style.display = '';
}

ClientMethod defaultHide() [ Internal, Language = javascript ]
{
	var div = this.$findElement();
	if (!div) return;
	if (div.hidden || div.style.display=='none') return;
	this._styleDisplay = div.style.display;
	div.hidden = true;
	div.style.display = 'none';
	if (this.style) {
		var sa = this.style.split(';');
		for (var idx = sa.length-1;idx>=0;idx--) {
			if (sa[idx]) {
				var attr = sa[idx].split(' ').join('');
				if (attr && attr.indexOf('display')==0) {
					sa[idx]='';
				}
			}
		}
		this.style = sa.join(';');
	}
}

ClientMethod defaultToggleVisibility() [ Internal, Language = javascript ]
{
	var div = this.$findElement();
	if (!div) return;
	if (div.hidden) {
		this.$show();
	} else {
		this.$hide();
	}
}

ClientMethod genericRenderAttributeStr(obj, attrs, isControl) [ Internal, Language = javascript ]
{
	var aStr = [];
	var fal = attrs.length;
	for (var j=0;j<fal;j++) {
		var attr = attrs[j];
		if (!attr.special) {
			var instanceName = attr.instanceName;
			if (!instanceName) instanceName=attr.name;
			if (attr.unary) {
				aStr.push(zenGet(obj[instanceName],false) ? attr.name+' ':'');
			}
			else {
				if (attr.remapToKey) {
					aStr.push(zenGet(obj[instanceName],false) ? attr.name+'="'+obj.$documentView.getItemByKey(zenGet(obj[instanceName],'')).$makeId()+'" ' : '');
				}
				else {
					aStr.push(zenGet(obj[instanceName],false) ? attr.name+'="'+zenGet(obj[instanceName],'')+'" ' : '');
				}
			}
		}
	}
	var rawExtras = obj.$extra;
	var rawExtraStr = '';
	if (rawExtras) {
		if (typeof(rawExtras)=='string') { // Assume we're preprocessed
			rawExtraStr = ' '+rawExtras+' ';
		}
		else if (typeof(rawExtras)=='object') { // walk the object
			var rea = [];
			for (var p in rawExtras) rea.push(p+'="'+rawExtras[p]+'"');
			rawExtraStr = rea.join(' ');
		}
	}
	aStr.push(' '+rawExtraStr+' ');
	var dataAttrs = [];
	var eventAttrs = [];
	if (obj.key) {
		if (!obj.$ignoreSelect) eventAttrs.push('click');
		if ((isControl)&&(!obj.$ignoreChange)) eventAttrs.push('change');
	}
	for (var prop in obj) {
		if (prop.indexOf("data-")==0) dataAttrs.push(prop);
		else if ((prop.indexOf("on")==0)&&(!obj.$ignoreEvent)) eventAttrs.push(prop.substring(2));
	}
	var extraData = [];
	var extraDataStr = "";
	var dal = dataAttrs.length;
	for (var j=0;j<dal;j++) {
		var da = dataAttrs[j];
		extraData.push(da+'="'+obj[da]+'"');
	}
	if (dal>0) extraDataStr = " "+extraData.join(" ");
	var cbData = [];
	var cbDataStr = "";
	var eal = eventAttrs.length;
	for (var j=0;j<eal;j++) {
		var ea = eventAttrs[j];
		cbData.push('on'+ea+'="$$$event(\''+ea+'\');"');
	}
	if (eal>0) cbDataStr = " "+cbData.join(" ");
	aStr.push(extraDataStr+cbDataStr);
	if (zenGet(obj.hidden,false)) {
		var style='';
		var append = true;
		if (obj.style && obj.style.length>0) {
			var packedStyle = obj.style.split(' ').join('');
			var sa = packedStyle.split(';');
			for (var i=0;i<sa.length;i++) {
				if (sa[i].indexOf('display')==0) {
					var va = sa[i].split(':');
					obj._styleDisplay = va[1];
					sa[i]='display:none';
					append = false;
				}
			}
			if (append) sa.push('display:none');
			style = 'style="'+sa.join(';')+'" ';
		}
		else {
			style = 'style="display:none;" ';
		}
		append = true;
		for (var idx = aStr.length-1;idx>=0;idx--) {
			if (aStr[idx] && aStr[idx].indexOf('style')==0) {
				aStr[idx] = style;
				append = false;
				idx = -1;
			}
		}
		if (append) aStr.push(style);
	}
	var tempContent = zenGet(obj.$content);
	if ( typeof(tempContent) === 'array' ||  typeof(tempContent) === 'object') {
		tempContent = tempContent.toString();
	}
	var content = zenEscapeXML(tempContent);
	return({attrs:(aStr.join(' ')),content:(content),hasEvents:(eal>0)});
}

ClientMethod defaultRefresh() [ Internal, Language = javascript ]
{
	var attrs = this.$getAttributes();
	var div = this.$findElement();
	var fal = attrs.length;
	for (var j=0;j<fal;j++) {
		var attr = attrs[j];
		var attrName = attr.name;
		if (attr.instanceName) attrName=attr.instanceName;
		if (!attr.special && typeof(this[attrName])!='undefined') {
			if (attr.unary) {
				var newValue = zenGet(this[attrName],false);
				this.$setAttribute(attr.name, newValue);
				if (!newValue) div.removeAttribute(attr.name);
			}
			else {
				if (attr.remapToKey) {
					this.$setAttribute(attr.name,this.$documentView.getItemByKey(zenGet(this[attrName],'')).$makeId());
				}
				else {
					this.$setAttribute(attr.name, zenGet(this[attrName],''));
				}
			}
		}
	}
	var rawExtras = this.$extra;
	if (rawExtras) {
		if (typeof(rawExtras)=='string') { 
			var packedExtras = rawExtras.split(' ').join('');
			var pairs = packedExtras.split(';');
			var len = pairs.length;
			var reo = {};
			for (var i=0;i<len;i++) {
				var va = pairs[i].split('=');
				reo[va[0]] = va[1];
			}
			rawExtras = reo;
		}
		for (var p in rawExtras) this.$setAttribute(p,rawExtras[p]);
	}
	var cbRoot = "zenPage.getComponent("+this.$documentView.index+").eventHandler("+this.$index+",event,";
	if (this.key) {
		var clickCB = cbRoot+"'click');";
		var changeCB = cbRoot+"'change');";
		if (this.$ignoreSelect) div.setAttribute('onclick','');
		else {
			div.setAttribute('onclick',clickCB);
		}
		if (this.$_isControl) {
			if (this.$ignoreChange) div.setAttribute('onchange','');
			else {
				div.setAttribute('onchange',changeCB);
			}
		}
	}
	var eventAttrs = [];
	var dataAttrs = [];
	for (var prop in this) {
		if (prop.indexOf("data")==0) dataAttrs.push(prop);
		else if (prop.indexOf("on")==0) eventAttrs.push(prop.substring(2));
	}
	var dal = dataAttrs.length;
	for (var j=0;j<dal;j++) {
		var da = dataAttrs[j];
		div[da] = this[da];
	}
	var eal = eventAttrs.length;
	for (var j=0;j<eal;j++) {
		var ea = eventAttrs[j];
		var cb = cbRoot+"'"+ea+"');";
		if (this.$ignoreEvent) cb = '';
		div.setAttribute('on'+ea,cb);
	}
	if (typeof(this.hidden)!='undefined') {
		if (zenGet(this.hidden,false)) {
			this.$hide();
		}
		else {
			this.$show();
		}
	}
	if (this.$content || this.$content=='') {
		var tempContent = zenGet(this.$content);
		if ( typeof(tempContent) === 'array' ||  typeof(tempContent) === 'object') {
			tempContent = tempContent.toString();
		}
		for (var i = div.childNodes.length-1;i>=0;i--) {
			var kid = div.childNodes[i];
			if (kid.nodeType==3) div.removeChild(kid);
		}
		var k = document.createTextNode(tempContent);
		div.insertBefore(k,div.childNodes[0]);
	}
}

ClientMethod getAttributesA() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'download' },
		{name:'href' },
		{name:'hreflang' },
		{name:'media' },
		{name:'rel' },
		{name:'target' },
		{name:'type', instanceName:'mimeType' }
	];
	return(attrs);
}

ClientMethod renderA() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<a id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</a>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesAbbr() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderAbbr() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<abbr id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</abbr>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesAddress() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderAddress() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<address id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</address>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesArea() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'alt' },
		{name:'coords' },
		{name:'download' },
		{name:'href' },
		{name:'hreflang' },
		{name:'media' },
		{name:'rel' },
		{name:'shape' },
		{name:'target' },
		{name:'type', instanceName:'mimeType' }
	];
	return(attrs);
}

ClientMethod renderArea() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<area id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</area>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesArticle() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderArticle() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<article id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</article>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesAside() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderAside() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<aside id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</aside>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesAudio() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'autoplay', unary:1 },
		{name:'controls', unary:1 },
		{name:'loop', unary:1 },
		{name:'muted', unary:1 },
		{name:'preload' },
		{name:'src' }
	];
	return(attrs);
}

ClientMethod renderAudio() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<audio id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</audio>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesB() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderB() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<b id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</b>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesBdi() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderBdi() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<bdi id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</bdi>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesBdo() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'dir' }
	];
	return(attrs);
}

ClientMethod renderBdo() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<bdo id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</bdo>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesBlockquote() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'cite' }
	];
	return(attrs);
}

ClientMethod renderBlockquote() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<blockquote id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</blockquote>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesBr() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderBr() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<br id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</br>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesButton() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'autofocus', unary:1 },
		{name:'disabled', unary:1 },
		{name:'form' },
		{name:'formaction' },
		{name:'formenctype' },
		{name:'formmethod' },
		{name:'formnovalidate', unary:1 },
		{name:'formtarget' },
		{name:'name' },
		{name:'type', instanceName:'buttonType' },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderButton() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),1);
	this.$_isControl = 1;
	var html = ['<button id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</button>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesCanvas() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'height' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderCanvas() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<canvas id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</canvas>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesCaption() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderCaption() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<caption id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</caption>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesCite() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderCite() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<cite id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</cite>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesCode() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderCode() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<code id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</code>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesCol() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'span' }
	];
	return(attrs);
}

ClientMethod renderCol() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<col id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</col>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesColgroup() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderColgroup() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<colgroup id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</colgroup>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDatalist() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderDatalist() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<datalist id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</datalist>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDd() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderDd() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<dd id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</dd>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDel() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'cite' },
		{name:'datetime' }
	];
	return(attrs);
}

ClientMethod renderDel() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<del id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</del>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDetails() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'open', unary:1 }
	];
	return(attrs);
}

ClientMethod renderDetails() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<details id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</details>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDfn() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderDfn() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<dfn id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</dfn>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDialog() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'open', unary:1 }
	];
	return(attrs);
}

ClientMethod renderDialog() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<dialog id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</dialog>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDiv() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderDiv() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<div id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</div>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDl() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderDl() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<dl id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</dl>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesDt() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderDt() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<dt id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</dt>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesEm() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderEm() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<em id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</em>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesEmbed() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'height' },
		{name:'src' },
		{name:'type', instanceName:'mimeType' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderEmbed() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<embed id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</embed>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesFieldset() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'disabled', unary:1 },
		{name:'form' },
		{name:'name' }
	];
	return(attrs);
}

ClientMethod renderFieldset() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<fieldset id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</fieldset>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesFigcaption() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderFigcaption() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<figcaption id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</figcaption>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesFigure() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderFigure() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<figure id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</figure>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesFooter() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderFooter() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<footer id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</footer>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesForm() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'accept-charset', instanceName:'acceptCharset' },
		{name:'action' },
		{name:'autocomplete' },
		{name:'enctype' },
		{name:'method' },
		{name:'name' },
		{name:'novalidate', unary:1 },
		{name:'target' }
	];
	return(attrs);
}

ClientMethod renderForm() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<form id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</form>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesH1() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderH1() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<h1 id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</h1>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesH2() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderH2() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<h2 id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</h2>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesH3() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderH3() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<h3 id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</h3>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesH4() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderH4() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<h4 id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</h4>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesH5() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderH5() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<h5 id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</h5>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesH6() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderH6() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<h6 id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</h6>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesHeader() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderHeader() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<header id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</header>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesHr() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderHr() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<hr id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</hr>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesI() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderI() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<i id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</i>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesIframe() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'height' },
		{name:'name' },
		{name:'sandbox' },
		{name:'seamless', unary:1 },
		{name:'src' },
		{name:'srcdoc' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderIframe() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<iframe id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</iframe>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesImg() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'alt' },
		{name:'crossorigin' },
		{name:'height' },
		{name:'ismap', unary:1 },
		{name:'src' },
		{name:'usemap' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderImg() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<img id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</img>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesInput() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'accept' },
		{name:'alt' },
		{name:'autocomplete' },
		{name:'autofocus', unary:1 },
		{name:'checked', unary:1 },
		{name:'disabled', unary:1 },
		{name:'form' },
		{name:'formaction' },
		{name:'formenctype' },
		{name:'formmethod' },
		{name:'formnovalidate', unary:1 },
		{name:'formtarget' },
		{name:'height' },
		{name:'list', remapToKey:1 },
		{name:'max' },
		{name:'maxlength' },
		{name:'min' },
		{name:'multiple', unary:1 },
		{name:'name' },
		{name:'pattern' },
		{name:'placeholder' },
		{name:'readonly', unary:1 },
		{name:'required', unary:1 },
		{name:'size' },
		{name:'src' },
		{name:'step' },
		{name:'type', instanceName:'inputType' },
		{name:'value' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderInput() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),1);
	this.$_isControl = 1;
	var html = ['<input id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</input>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesIns() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'cite' },
		{name:'datetime' }
	];
	return(attrs);
}

ClientMethod renderIns() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<ins id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</ins>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesKbd() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderKbd() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<kbd id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</kbd>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesKeygen() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'autofocus', unary:1 },
		{name:'challenge', unary:1 },
		{name:'disabled', unary:1 },
		{name:'form' },
		{name:'keyType' },
		{name:'name' }
	];
	return(attrs);
}

ClientMethod renderKeygen() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<keygen id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</keygen>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesLabel() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'for', instanceName:'forInput', remapToKey:1 },
		{name:'form' }
	];
	return(attrs);
}

ClientMethod renderLabel() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<label id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</label>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesLegend() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderLegend() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<legend id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</legend>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesLi() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderLi() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<li id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</li>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesMain() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderMain() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<main id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</main>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesMap() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'name' }
	];
	return(attrs);
}

ClientMethod renderMap() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<map id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</map>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesMark() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderMark() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<mark id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</mark>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesMenu() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'label' },
		{name:'type', instanceName:'menuType' }
	];
	return(attrs);
}

ClientMethod renderMenu() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<menu id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</menu>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesMeter() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'form' },
		{name:'high' },
		{name:'low' },
		{name:'max' },
		{name:'min' },
		{name:'optimum' },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderMeter() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<meter id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</meter>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesNav() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderNav() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<nav id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</nav>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesObject() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'data' },
		{name:'form' },
		{name:'height' },
		{name:'name' },
		{name:'type', instanceName:'mimeType' },
		{name:'usemap' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderObject() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<object id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</object>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesOl() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'reversed', unary:1 },
		{name:'start' },
		{name:'type', instanceName:'numberingScheme' }
	];
	return(attrs);
}

ClientMethod renderOl() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<ol id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</ol>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesOptgroup() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'disabled', unary:1 },
		{name:'label' }
	];
	return(attrs);
}

ClientMethod renderOptgroup() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<optgroup id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</optgroup>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesOption() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'disabled', unary:1 },
		{name:'label' },
		{name:'selected', unary:1 },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderOption() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<option id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</option>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesOutput() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'for', instanceName:'forInput', remapToKey:1 },
		{name:'form' },
		{name:'name' }
	];
	return(attrs);
}

ClientMethod renderOutput() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<output id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</output>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesP() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderP() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<p id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</p>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesParam() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'name' },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderParam() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<param id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</param>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesPre() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderPre() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<pre id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</pre>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesProgress() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'max' },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderProgress() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<progress id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</progress>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesQ() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'cite' }
	];
	return(attrs);
}

ClientMethod renderQ() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<q id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</q>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesRp() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderRp() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<rp id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</rp>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesRt() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderRt() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<rt id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</rt>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesRuby() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderRuby() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<ruby id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</ruby>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesS() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderS() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<s id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</s>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSamp() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSamp() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<samp id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</samp>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSection() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSection() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<section id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</section>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSelect() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'autofocus', unary:1 },
		{name:'disabled', unary:1 },
		{name:'form' },
		{name:'multiple', unary:1 },
		{name:'name' },
		{name:'required', unary:1 },
		{name:'size' },
		{name:'value' }
	];
	return(attrs);
}

ClientMethod renderSelect() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),1);
	this.$_isControl = 1;
	var html = ['<select id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</select>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod setAttributeSelect(attr, value) [ Internal, Language = javascript ]
{
	var div = this.$findElement();
	if (!div) return;
	switch(attr) {
		case 'accesskey':
			div.accessKey = value;
			break;
		case 'cssClass':
			div.className = value;
			break;
		case 'contenteditable':
			div.contentEditable = value;
			break;
		case 'tabindex':
			div.tabIndex = value;
			break;
		case 'value':
			div.value = value;
			var arr = div.options;
			if (arr && arr.length) {
				for(var idx=0;idx<arr.length;idx++) {
					var p=arr[idx];
					if(p.value==value) {
						p.selected=true;
					}
				}
			}
			break;
		default:
			div[attr] = value;
			break;
	};
}

ClientMethod getAttributesSmall() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSmall() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<small id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</small>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSource() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'media' },
		{name:'src' },
		{name:'type', instanceName:'mimeType' }
	];
	return(attrs);
}

ClientMethod renderSource() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<source id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</source>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSpan() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSpan() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<span id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</span>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesStrong() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderStrong() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<strong id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</strong>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSub() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSub() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<sub id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</sub>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSummary() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSummary() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<summary id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</summary>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesSup() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderSup() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<sup id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</sup>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTable() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'sortable', unary:1 }
	];
	return(attrs);
}

ClientMethod renderTable() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<table id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</table>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTbody() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderTbody() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<tbody id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</tbody>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTd() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'colspan' },
		{name:'headers' },
		{name:'rowspan' }
	];
	return(attrs);
}

ClientMethod renderTd() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<td id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</td>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTextarea() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'autofocus', unary:1 },
		{name:'cols' },
		{name:'disabled', unary:1 },
		{name:'form' },
		{name:'maxlength' },
		{name:'name' },
		{name:'placeholder' },
		{name:'readonly', unary:1 },
		{name:'required', unary:1 },
		{name:'rows' },
		{name:'wrap' }
	];
	return(attrs);
}

ClientMethod renderTextarea() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),1);
	this.$_isControl = 1;
	var html = ['<textarea id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</textarea>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTfoot() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderTfoot() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<tfoot id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</tfoot>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTh() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'colspan' },
		{name:'headers' },
		{name:'rowspan' }
	];
	return(attrs);
}

ClientMethod renderTh() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<th id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</th>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesThead() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderThead() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<thead id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</thead>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTime() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'datetime' }
	];
	return(attrs);
}

ClientMethod renderTime() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<time id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</time>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTr() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderTr() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<tr id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</tr>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesTrack() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'default', instanceName:'defaultTrack', unary:1 },
		{name:'kind' },
		{name:'label' },
		{name:'src' },
		{name:'srclang' }
	];
	return(attrs);
}

ClientMethod renderTrack() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<track id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</track>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesU() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderU() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<u id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</u>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesUl() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderUl() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<ul id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</ul>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesVar() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderVar() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<var id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</var>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesVideo() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' },
		{name:'autoplay', unary:1 },
		{name:'controls', unary:1 },
		{name:'height' },
		{name:'loop', unary:1 },
		{name:'muted', unary:1 },
		{name:'poster' },
		{name:'preload' },
		{name:'src' },
		{name:'width' }
	];
	return(attrs);
}

ClientMethod renderVideo() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<video id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</video>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

ClientMethod getAttributesWbr() [ Internal, Language = javascript ]
{
	var attrs = [
		{name:'accesskey' },
		{name:'class', instanceName:'cssClass' },
		{name:'contenteditable' },
		{name:'dir' },
		{name:'draggable' },
		{name:'hidden', unary:1 },
		{name:'id', special:1 },
		{name:'lang' },
		{name:'spellcheck' },
		{name:'style' },
		{name:'tabindex' },
		{name:'title' },
		{name:'translate' }
	];
	return(attrs);
}

ClientMethod renderWbr() [ Internal, Language = javascript ]
{
	this.id = this.$makeId();
	var attrObj = this.$_renderAttributeString(this,this.$getAttributes(),0);
	this.$_isControl = 0;
	var html = ['<wbr id="'+this.id+'" ',attrObj.attrs,' >',attrObj.content];
	if (!this.children) this.children = this.$children;
	if (this.children) {
		for (var n = 0; n < this.children.length;n++) {
			var child = this.children[n];
			html.push(child.$renderItem());
		}
	}
	html.push('</wbr>');
	if (attrObj.hasEvents) {
		return (this.$documentView.injectEventHandler(html.join(''),this));
	}
	return html.join('');
}

}
