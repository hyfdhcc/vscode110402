/// This component provides an way to display a "document" -- data supplied as a graph of JavaScript
/// objects and rendered using a model supplied by another object graph.
Class %ZEN.Mojo.Component.documentView Extends (%ZEN.Component.component, %ZEN.Component.dataView) [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

Parameter SYSMODULE = "core";

Parameter DEFAULTENCLOSINGCLASS = "dvEnclosingClass";

/// Specify how the data for this component should be displayed.<br/>
/// "layout" - use the layout template to display the document data.<br/>
/// "data" - show a generic view of the data with no layout applied.<br/>
/// "html" - display the data as html with no conversion.<br/>
/// "iframe" - display the data (within the contentProperty property) using an iframe.<br/>
Property displayMode As %ZEN.Datatype.string(VALUELIST = ",layout,data,html,iframe") [ InitialExpression = "layout", Internal ];

/// If <property>displayMode</property> is "html" and the component data is an object, this 
/// is the name of the property within the data object to display.
Property contentProperty As %ZEN.Datatype.string [ Internal ];

/// Style for overall document.
Property documentStyle As %ZEN.Datatype.style [ Internal ];

/// Keep track of the current displayed level of content.
Property currLevel As %ZEN.Datatype.integer(XMLPROJECTION = "none") [ InitialExpression = 0 ];

/// Maximum number of allowed panels.
Property maxPanels As %ZEN.Datatype.integer [ InitialExpression = 5 ];

/// Number of panels displayed at the same time.
Property panelsPerFrame As %ZEN.Datatype.integer [ InitialExpression = 1, Internal ];

/// Minimum width of panels within the document view.<br/>
/// If defined, this is used as the min-width setting for the dvInnerPanel div that
/// wraps each panel.<br/>
/// Note, you must specify units for this property.
Property minContentWidth As %ZEN.Datatype.length;

/// Minimum height of panels within the document view.<br/>
/// If defined, this is used as the min-height setting for the dvInnerPanel div that
/// wraps each panel.<br/>
/// Note, you must specify units for this property.
Property minContentHeight As %ZEN.Datatype.length;

/// Style for blocks (sections) within the document.
/// A block encloses a title and paragraph or a table.
Property blockStyle As %ZEN.Datatype.style [ Internal ];

/// Style for titles within the document.
Property titleStyle As %ZEN.Datatype.style [ Internal ];

/// Style for paragraphs within the document.
Property paraStyle As %ZEN.Datatype.style [ Internal ];

/// Style for tables within the document.
Property tableStyle As %ZEN.Datatype.style [ Internal ];

/// Display borders for tables.
Property tableBorder As %ZEN.Datatype.boolean [ InitialExpression = 0, Internal ];

/// Style for header rows within tables.
Property headerRowStyle As %ZEN.Datatype.style [ Internal ];

/// Style for odd rows within tables.
Property oddRowStyle As %ZEN.Datatype.style [ Internal ];

/// Style for even rows within tables.
/// Note: Setting this will interfere with row hover style.
Property evenRowStyle As %ZEN.Datatype.style [ Internal ];

/// CSS class for blocks (sections) within the document.
/// A block encloses a title and paragraph or a table.
Property blockClass As %ZEN.Datatype.cssClass [ Internal ];

/// CSS class for titles within the document.
Property titleClass As %ZEN.Datatype.cssClass [ Internal ];

/// CSS class for paragraphs within the document.
Property paraClass As %ZEN.Datatype.cssClass [ Internal ];

/// CSS class for tables within the document.
Property tableClass As %ZEN.Datatype.cssClass [ Internal ];

/// CSS class for header rows within tables.
Property headerRowClass As %ZEN.Datatype.cssClass [ Internal ];

/// CSS class for odd rows within tables.
Property oddRowClass As %ZEN.Datatype.cssClass [ Internal ];

/// CSS class for even rows within tables.
/// Note: Setting this may interfere with row hover style.
Property evenRowClass As %ZEN.Datatype.cssClass [ Internal ];

/// onload event handler:
/// If defined, this event provides notification that the documentView is being rendered.
Property onload As %ZEN.Datatype.eventHandler;

/// onrender event handler:
/// If defined, this event provides notification that a document is being rendered.
Property onrender As %ZEN.Datatype.eventHandler;

/// ongetlayout event handler:
/// If defined, this event returns the layout model for the document.
Property ongetlayout As %ZEN.Datatype.eventHandler;

/// ongetdata event handler:
/// If defined, this event returns the source data to be displayed within this component.
Property ongetdata As %ZEN.Datatype.eventHandler;

/// onresolvemethod event handler:
/// If defined, this event is called whenever "=[$method.xxx]" is encountered.
/// <var>which</var> will be the name of the "method".<br/>
/// <var>context</var> will contain the associated "context" object.<br/>
Property onresolvemethod As %ZEN.Datatype.eventHandler;

/// onfetchcodetable event handler:
/// If defined, this event loads a code table for use by a coded value (such a drop down list)
/// or by a $lookup control.
Property onfetchcodetable As %ZEN.Datatype.eventHandler [ Internal ];

/// onfetchlookupdata event handler:
/// If defined, this event loads data to be displayed by a $lookup control.
Property onfetchlookupdata As %ZEN.Datatype.eventHandler [ Internal ];

/// ongetHTML event handler:
/// This provides HTML content for the doc view.
/// If defined, this content is used instead of the normal layout.
Property ongetHTML As %ZEN.Datatype.eventHandler [ Internal ];

/// onlookup event handler:
/// This event is invoked when the user selects the lookup icon for a $lookup control.<br/>
/// If this event returns a object value, it is used as a layout model and data to display a set of
/// choices for the $lookup control. If the event returns null, then the built-in handling for the 
/// lookup is skipped. Return true if you want the built-in handling.
Property onlookup As %ZEN.Datatype.eventHandler [ Internal ];

/// HTML content to display. This may contain simple expressions.
Property content As %ZEN.Datatype.html [ Internal ];

/// Optional.
/// User-defined seed value. This is an optional parameter that
/// is passed on to the <method>OnDrawContent</method> callback
/// method.<br>
Property seed As %ZEN.Datatype.string(ZENEXPRESSION = 1) [ Internal ];

/// If true, then effects, such as fading and sliding, are enabled.
Property effectsEnabled As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// Effect used for fading.
Property fadeEffect As %ZEN.Datatype.string(XMLPROJECTION = "none") [ InitialExpression = "fade", Internal ];

/// Color used for fade effects.
Property fadeColor As %ZEN.Datatype.string [ InitialExpression = "rgb(120,120,160)", Internal ];

/// Duration (number of 25ms steps) used for fade effects.
Property fadeSteps As %ZEN.Datatype.integer [ InitialExpression = 12, Internal ];

/// Image to use for back arrow in nested pane.
Property imageBackArrow As %ZEN.Datatype.uri [ InitialExpression = "deepsee/ds2_arrow_west_44_w.png", Internal ];

/// Optional.
/// Name of Server-side callback method that provides HTML content
/// for this component.<br>
/// If defined, this callback is invoked on the server when this 
/// component is drawn. It provides HTML content by using &html or
/// by using the WRITE command.<br>
/// This must be the name of a server-only method in the page
/// class that contains this view component.
Property OnDrawContent As %ZEN.Datatype.delegator(FORMALSPEC = "seed:%ZEN.Datatype.string", RETURNTYPE = "%Status", ZENENCRYPT = 0);

/// onresolvepluginconflicts event handler:
/// If defined, this event fires after plugin registration has finished
/// and multiple plugins registered for a layout object type.
/// If no conflict occured the event is not fired.
Property onresolvepluginconflicts As %ZEN.Datatype.eventHandler;

/// Set true if we are running on a mobile device.
Property isMobile As %ZEN.Datatype.boolean [ Internal ];

/// If true, show developer diagnostics.
Property developerMode As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Optional starting value of layout key (set on the client).
Property initialLayoutKey As %ZEN.Datatype.string;

/// Optional starting value of document key (set on the client).
Property initialDocumentKey As %ZEN.Datatype.string;

/// The page manager of the documentView. This is required.
/// The page manager can hold a set of helper plugins to add additional support for layout objects.
Property pageManager As %ZEN.Mojo.Plugin.basePageManager(XMLPROJECTION = "ELEMENT", XMLREF = 1, XMLTYPECONSTRAINT = "CHOICE") [ Internal ];

/// Defines the style sheet used by this component.
XData Style
{
<style type="text/css">

input[type="search"] {
  -webkit-appearance: textfield;
}

/* enclosing div */
.dvEnclosingClass {
	position: relative;
	overflow: hidden;
	background: none;
	border: 1px solid rgba(200,200,200,0.5);
}

/* frame for panels */
.dvFrame {
	position: relative;
	overflow: hidden;
	background: none;
	border-right: 1px solid #808080;
}

/* content panel within frame */
.dvPanel {
	overflow: auto;
	position: absolute;
	top: 0px;
	-webkit-overflow-scrolling: touch;
}

.dvPanel:hover {
	overflow: auto;
}

/* wrapper of content within dvPanel */
.dvInnerPanel {
}

/* outermost div for document */
.dvDocument {
}

.dvCanvas {
	position: absolute;
	top: 0px;
	left: 0px;
	z-index: 2;
	display: none;
}

.dvEnclosingClass iframe {
	position: absolute;
	border: none;
	top: 0px;
	left: 0px;
}

.dvTooltip {
	position: absolute;
	z-index: 10;
	min-height: 20px;
	min-width: 20px;
	border-radius: 5px;
	border: 1px solid #D8D4AC;
	box-shadow: 2px 2px 2px black;
	padding: 5px;

	overflow: hidden;
	background: white;
	background: linear-gradient(to bottom, #FFFFFF 0%, #F6F6F6 47%, #EDEDED 100%);
}

.dvBody {
	color: #575757;
	padding: 10px;
	position: absolute;
	top: 0px;
	left: 0px;
	opacity: 0.0;

	transition-property: opacity;
	transition-duration: 0.75s;
	transition-timing-function: ease;
}

.dvBlock {
}

.dvCellInner {
	overflow: hidden;
}

.dvGenericTitle {
	padding-top: 10px;
	color: #606060;
	font-size: 20px;
	font-weight: bold;
}

.dvGenericValue {
	color: #404040;
	font-size: 20px;
	font-family: courier new;
}

div:focus {
    outline-color: #9ECAED;
}

ol.dvCtrlRadioList {
	padding: 0px;
	margin: 0px;
}

ol.dvCtrlRadioList li {
	list-style: none;
	float: left;
}

.dvCtrlRadio {
}

.dvCtrlRadioCaption {
	color: #404040;
	font-size: 14px;
	padding-left: 3px;
	padding-right: 10px;
    -webkit-user-select: none;
    -moz-user-select: none;
    -o-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

.dvCtrlRadioCaption:hover {
	color: darkred;
}
.dvCtrlRadioCaption:active {
	/*text-shadow: 1px 1px 8px #808080, -1px -1px 8px #808080;*/
}

.dvCtrlText {
}

.dvCtrlCheckbox {
}

.dvLookupTable {
}

img.dvLookupImage {
	vertical-align: middle;
	height: 18px;
	padding-left: 2px;
	cursor: pointer;

	opacity: 0.6;
	transition-property: opacity;
	transition-duration: 0.75s;
	transition-timing-function: ease;
}

img.dvLookupImage:hover {
	opacity: 1.0;
}

img.dvLookupImage:active {
	background: rgba(120,120,120,0.3);
	box-shadow: 0px 0px 10px rgb(120,120,120);
}

.dvCtrlLink {
	color: #404040;
}

.dvCtrlLink:hover {
	color: #804040;
}

.dvCtrlLink:active {
	text-shadow: 1px 1px 8px #808080, -1px -1px 8px #808080;
}

.dvCtrlLink img {
	opacity: 0.8;
}

.dvCtrlLink:hover img {
	opacity: 1.0;
}

.dvCtrlLink:active img {
	background: white;
}

/* choice button */
.dvCtrlChoice,
.dvCtrlChoiceSelected,
.dvCtrlChoiceDisabled,
.dvCtrlChoiceSelectedDisabled {
	white-space: nowrap;
	position: absolute;
	height: 16px;
	color: #808080;
	font-size: 10px;
	font-weight: bold;
	padding-top: 2px;
	text-align: center;
	overflow: hidden;

	background: #F5F6F6;
    -webkit-user-select: none;
    -moz-user-select: none;
    -o-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

.dvCtrlChoice,
.dvCtrlChoiceSelected {
	color: #404040;
	background: #F5F6F6;
	background: linear-gradient(to bottom,  #F5F6F6 0%, #DBDCE2 21%, #B8BAC6 49%, #DDDFE3 80%, #F5F6F6 100%);

	transition-property: background;
	transition-duration: 0.5s;
	transition-timing-function: ease;
}

.dvCtrlChoiceSelected,.dvCtrlChoiceSelectedDisabled {
	background: rgb(53,107,141);
	color: white;
}

.dvCtrlChoice:hover {
	background: #FFEEAA;
}

.dvCtrlChoiceSelected:hover {
	background: rgb(73,127,161);
	color: white;
}

img.dvDiscIcon {
	height: 20px;
	opacity: 0.5;
}

img.dvDiscIcon:hover {
	height: 20px;
	opacity: 1.0;
}

img.dvDiscIcon:active {
	border-radius: 10px;
	background: rgba(200,200,250,0.5);
	box-shadow: 2px 2px 20px #D0D0F0, -2px -2px 20px #F0D0D0;
}

.dvDevIcon {
	height: 12px;
	opacity: 0.3;
}

.dvDevIcon:hover {
	opacity: 1.0;
}

.dvTimePopup {
	padding:10px;
	max-width: 420px;
	overflow: hidden;
}

table.dvTimePopupHours {
	border-top: 1px solid #808080;
	border-left: 1px solid #808080;
}

table.dvTimePopupMinutes {
	width: 100%;
	background: white;
	border-top: 1px solid #808080;
	border-left: 1px solid #808080;
}

table.dvTimePopupHours td,
table.dvTimePopupMinutes td {
	border-right: 1px solid #808080;
	border-bottom: 1px solid #808080;
	padding: 2px;
	white-space: nowrap;
	font-size: 12px;
	text-align: center;
	min-width: 30px;
	max-width: 40px;
}

table.dvTimePopupHours td.dvTime:hover,
table.dvTimePopupMinutes td.dvTime:hover {
	background: #FFEEAA;
}

td.dvTimeSelected {
	background: #202020;
	color: white;
}

.dvTimePopupIcon {
	padding: 2px;
	padding-right: 5px;
	height: 16px;
	opacity: 0.6;
}

.dvTimePopupIcon:hover {
	opacity: 1.0;
}

.dvWaitMessage {
	padding: 20px;
	color: #808080;
}

</style>
}

/// Mimic behavior of HTML component.
Method %DrawHTML() [ Internal ]
{
	Set tUserContent = 0
	Set tSC = ..%DrawContent(.tUserContent)
	If $$$ISERR(tSC) {
		Do ##class(%ZEN.Utils).%DisplayErrorHTML(##this,tSC)
		Quit
	}

	If (..content '= "") {
		// render contents directly (with no addition enclosing elements)
		// if there are #()# expressions, ignore them!
		Write ..content
		Set tUserContent = 1
	}

	If ('tUserContent) {
		// default to auto-render on client load
		Do ##super()
	}
}

/// Invoke user method to provide contents for this HTML component.
Method %DrawContent(ByRef pImplemented As %Boolean) As %Status [ Internal ]
{
	Set pImplemented = 0
	Set tSC = ..%ValidateCallback("OnDrawContent")
	Quit:$$$ISERR(tSC) tSC

	Try {
		#; if user callback is defined, use that
		Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
		If ($IsObject(tHost) && (..OnDrawContent '= "")) {
			Set tSeed = $$$ZENVAL(..seed)
			Set tObj = ##class(%ZEN.proxyObject).%Create(tSeed)
			If $IsObject(tObj) {
				Set tSeed = tObj
			}
			Set pImplemented = 1
			Set tSC = $method(tHost,..OnDrawContent,tSeed)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method %ValidateCallback(pCallbackName) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
	Set tMethod = $Property($this,pCallbackName)
	If ($IsObject(tHost) && (tMethod '= "")) {
		$$$comMemberKeyGetLvar(tZENMETHOD,tHost.%ClassName(1),$$$cCLASSmethod,tMethod,$$$cMETHzenmethod)
		If ('tZENMETHOD) {
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Attempt to call non-ZENMethod: %1",tHost.%ClassName(1)_":"_tMethod))
		}
	}
	Quit tSC
}

/// Convenient method for getting the content of this component.
/// This is equivalent to calling getProperty('content').
ClientMethod getContent(content) [ Internal, Language = javascript ]
{
	return this.content;
}

/// Convenient method for setting the content of this component.
/// This is equivalent to calling setProperty('content',content).
ClientMethod setContent(content) [ Internal, Language = javascript ]
{
	this.setProperty('content',content);
}

/// Push a new level (panel) onto the document.<br/>
/// The new level uses the given layout key and criteria and data key and criteria
/// to fetch its layout and data.<br/>
/// If <var>dataKey</var> is not provided, then the data from the current level is used.
ClientMethod pushDocument(layoutKey, layoutCriteria, dataKey, dataCriteria) [ Language = javascript ]
{
	// !!! detect old calls !!!
	if ('object' == typeof layoutKey) {
		throw 'invalid call';
		return;
	}
	
	if (!this.content && this.currLevel < (parseInt(this.maxPanels,10)-1)) {
		this.currLevel++;
		this._layout[this.currLevel] = null;
		this._data[this.currLevel] = null;
		this._layoutKey[this.currLevel] = layoutKey;
		this._layoutCriteria[this.currLevel] = layoutCriteria;
		this._renderCounter[this.currLevel] = 0;

		if ('undefined' != typeof this._dataKey) {
			this._dataKey[this.currLevel] = dataKey;
			this._dataCriteria[this.currLevel] = dataCriteria;
		}
		else {
			this._data[this.currLevel] = this._data[this.currLevel-1];
			this._dataKey[this.currLevel] = this._dataKey[this.currLevel-1];
			this._dataCriteria[this.currLevel] = this._dataCriteria[this.currLevel-1];
		}

		this.renderDocument();
		if (!this.getSuppressRender()) {
			this.updateFrameOffset(true);

			var panel = this.findElement('panel_'+this.currLevel);
			if (panel) {
				panel.scrollTop = 0;
				panel.scrollLeft = 0;
			}
		}
	}
}

/// Pop the top-most layout (and data content) off of the document.
/// If <var>render</var> is true, re-render the newly revealed panel.
/// If <var>clearDataCache</var> is also true, then clear the cached data for the revealed panel.
ClientMethod popDocument(render, clearDataCache) [ Language = javascript ]
{
	if (!this.content && this.currLevel > 0) {
		// clear all cached data at the old level
		this._layout[this.currLevel] = null;
		this._data[this.currLevel] = null;
		this._layoutKey[this.currLevel] = '';
		this._layoutCriteria[this.currLevel] = '';
		this._dataKey[this.currLevel] = '';
		this._dataCriteria[this.currLevel] = '';

		this.currLevel--;
		
		// check if the page manager wants to suppress rendering when a document is popped from the stack
		if (!this.getSuppressRender()) {
			if (zenGet(render,false)) {
				this._layout[this.currLevel] = null;
				if (zenGet(clearDataCache,false)) {
					this._data[this.currLevel] = null;
				}
				this.renderDocument();
			}
			this.updateFrameOffset(true);
		}
		
		this.pageManager.afterPopDocument(this,render);
	}
}

/// Pop n documents from the document stack.
/// If <var>render</var> is true, re-render the newly revealed panel.
/// If <var>clearDataCache</var> is also true, then clear the cached data for the revealed panel.
ClientMethod popDocuments(number, render, clearDataCache) [ Language = javascript ]
{
	number = parseInt(number);
	if (number >= 0) {
		
	} else {
		// this skips "NaN" as well
		return;
	}
	if (number > this.currLevel) {
		// cap
		number = this.currLevel;
	}
	if (!this.content && this.currLevel > 0) {
		for (var n = this.currLevel; n > (this.currLevel-number); n--) {
			// clear all cached data at the old levels
			this._layout[n] = null;
			this._data[n] = null;
			this._layoutKey[n] = '';
			this._layoutCriteria[n] = '';
			this._dataKey[n] = '';
			this._dataCriteria[n] = '';
		}
		this.currLevel = this.currLevel - number;
		
		// check if the page manager wants to suppress rendering when a document is popped from the stack
		if (!this.getSuppressRender()) {
			if (zenGet(render,true)) {
				this._layout[this.currLevel] = null;
				if (zenGet(clearDataCache,false)) {
					this._data[this.currLevel] = null;
				}
				this.renderDocument();
				this.updateFrameOffset(true);
			}
			else {
				this.updateFrameOffset(false);
			}
		}
		
		this.pageManager.afterPopDocument(this,render);
	}
}

/// Pop all "levels" from the document.
/// If <var>render</var> is true, re-render the newly revealed panel.
/// If <var>clearDataCache</var> is also true, then clear the cached data for the revealed panel.
ClientMethod popAll(render, clearDataCache) [ Language = javascript ]
{
	if (!this.content && this.currLevel > 0) {
		for (var n = this.currLevel; n > 0; n--) {
			// clear all cached data at the old levels
			this._layout[n] = null;
			this._data[n] = null;
			this._layoutKey[n] = '';
			this._layoutCriteria[n] = '';
			this._dataKey[n] = '';
			this._dataCriteria[n] = '';
		}
		this.currLevel = 0;
		
		// check if the page manager wants to suppress rendering when a document is popped from the stack
		if (!this.getSuppressRender()) {
			if (zenGet(render,true)) {
				this._layout[this.currLevel] = null;
				if (zenGet(clearDataCache,false)) {
					this._data[this.currLevel] = null;
				}
				this.renderDocument();
				this.updateFrameOffset(true);
			}
			else {
				this.updateFrameOffset(false);
			}
		}
		
		this.pageManager.afterPopDocument(this,render);
	}
}

/// checks if the page manager wants to stop code execution
ClientMethod getSuppressCodeExecution() [ Internal, Language = javascript ]
{
	if (zenGet(this.pageManager.suppressCodeExecution,false)) {
		return true;
	}
	return false;
}

/// checks if the page manager wants to suppress rendering and updating the frame offset
ClientMethod getSuppressRender() [ Internal, Language = javascript ]
{
	if (zenGet(this.pageManager.suppressRender,false)) {
		return true;
	}
	return false;
}

/// checks if the page manager wants to suppress event StopPropagation
ClientMethod getSuppressStopPropagation() [ Internal, Language = javascript ]
{
	if (zenGet(this.pageManager.suppressStopPropagation,false)) {
		return true;
	}
	return false;
}

/// Update horizontal offset of the main frame to match the current "level".
ClientMethod updateFrameOffset(slide) [ Internal, Language = javascript ]
{
	var frame = this.findElement('frame');
	if (frame) {
		var panelsPerFrame = parseInt(this.panelsPerFrame,10);
		panelsPerFrame = (panelsPerFrame>=1) ? panelsPerFrame : 1;
		var depth = this.currLevel-panelsPerFrame+1;
		depth = depth < 0 ? 0 : depth;

		var enc = this.getEnclosingDiv();
		var width = parseInt(enc.style.width,10);

		// turn transition on/off
		var transitionProps = [ 'transition', 'WebkitTransition', 'MozTransition', 'msTransition' ];
		var transitionProp = null;
		for (var i = 0; i < transitionProps.length; i++) {
			if (typeof frame.style[transitionProps[i]] != 'undefined') {
				transitionProp = transitionProps[i];
				break;
			}
		}
		if (slide && this.effectsEnabled) {
			frame.style[transitionProp] = 'all 0.4s ease';
		}
		else {
			frame.style[transitionProp] = '';
		}
		var x = (-(width/panelsPerFrame)*depth);
		if (this.isMobile && (typeof frame.style.webkitTransform == 'string')) {
			// hardware accel
			frame.style.webkitTransform = 'translate3d('+x+'px, 0, 0)';		
		}
		else {
			frame.style.left = x + 'px';
		}

		// attach to transition event per browser
		if (frame.addEventListener) {
			this._transEvent = new Function('zenPage.getComponent('+this.index+').transitionHandler();');
			frame.addEventListener('transitionend', this._transEvent,false);
		}
	}
}

/// Notifcation that a css transition has finished.
ClientMethod transitionHandler() [ Internal, Language = javascript ]
{
	// remove all content below the current level
	// remove the handler
	var frame = this.findElement('frame');
	if (frame && frame.removeEventListener && this._transEvent) {
		var panelsPerFrame = parseInt(this.panelsPerFrame,10);
		panelsPerFrame = (panelsPerFrame>=1) ? panelsPerFrame : 1;
		var depth = this.currLevel-panelsPerFrame+1;
		depth = depth < 0 ? 0 : depth;

		for (var n = depth+1; n<parseInt(this.maxPanels,10); n++) {
			var panel = this.getPanelDiv(n);
			if (panel) {
				panel.innerHTML = '';
			}
		}
		frame.removeEventListener('transitionend', this._transEvent);
		this._transEvent = null;
	}
}

/// Set the actual width and height of this component.
/// The containing page should call this to set the size of this component.
ClientMethod setSize(width, height) [ Language = javascript ]
{
	var enc = this.getEnclosingDiv();
	if (enc == null) return;

	var maxPanels = parseInt(this.maxPanels,10);
	var panelsPerFrame = parseInt(this.panelsPerFrame,10);
	panelsPerFrame = (panelsPerFrame>=1) ? panelsPerFrame : 1;

	// outer div
	enc.style.width = width + 'px';
	enc.style.height = height + 'px';
	enc.style.overflow = 'hidden';
	
	// compute width for each "panel"
	var panelWidth = Math.floor(width/panelsPerFrame);

	// frame
	var frame = this.findElement('frame');
	if (frame) {
		frame.style.width = panelWidth*parseInt(this.maxPanels,10) + 'px';
		frame.style.height = height + 'px';
	}

	// panel(s)
	for (var n = 0;n<maxPanels;n++) {
		var panel = this.findElement('panel_'+n);
		if (panel) {
			panel.style.left = panelWidth*n + 'px';
			panel.style.width = panelWidth + 'px';
			panel.style.height = (height) + 'px';
		}
	}

	// canvas
	var canvas = this.findElement('canvas');
	if (canvas) {
		canvas.style.width = (width) + 'px';
		canvas.style.height = (height) + 'px';
	}
	this.updateFrameOffset(false);
}

/// Client-side method to render this control.
ClientMethod renderContents() [ Internal, Language = javascript ]
{
	if (!this._loaded) {
		this._loaded = true;
		if (this.onload!='') {
			zenInvokeCallbackMethod(this.onload,this,'onload');
		}
		
		//IE9 compatability
		if (!window.console) window.console = {};
		if (!window.console.log) window.console.log = function () {};
	}
	
	// test if we have not been rendered yet
	var enc = this.getEnclosingDiv();
	if (enc == null) return;

	// check for start values
	if (this.initialDocumentKey) {
		this.setDocumentKey(this.initialDocumentKey);
		this.initialDocumentKey = '';
	}
	if (this.initialLayoutKey) {
		this.setLayoutKey(this.initialLayoutKey);
		this.initialLayoutKey = '';
	}

	if (zenPage.isMobile && zenPage.isMobile()) {
		//!!!this.isMobile = true;
	}
	else {
		this.isMobile = false;
	}

	if (!this._layoutIndex) {
		// context for rendering
		// one per *level*
		this._indexCounter = [];
		this._renderCounter = [0];
		this._layoutIndex = [];
		this._keyIndex = [];

		this._notifyResize = [];

		// data & layout
		this._layout = [];
		this._data = [];
	}
	if (!this._layoutKey) {
		this._layoutKey = [];
		this._layoutCriteria = [];
	}
	if (!this._dataKey) {
		this._dataKey = [];
		this._dataCriteria = [];
	}

	enc.scrollTop = 0;
	enc.scrollLeft = 0;

	var userContent = this.content;
	if (!userContent && this.ongetHTML!='') {
		userContent = zenInvokeCallbackMethod(this.ongetHTML,this,'ongetHTML');
	}

	// if there is user content; it takes precedence
	if (userContent) {
		// place content into enclosing div
		enc.innerHTML = userContent;
		this._hasSkeleton = false;
		return;
	}

	if (!this._hasPluginsRegistered) {
		this.registerPlugins();
	}
	
	if (!this._checkedLibraries) {
		this.checkLibraries();
	}

	if (!this._hasSkeleton) {
		this.renderSkeleton();
		// make sure size of elements is set
		this.setSize(enc.offsetWidth,enc.offsetHeight);
	}
	this.renderDocument();
}

/// Render the main elements of the component;
/// This includes a wrapping div and a canvas overlay.
/// User content is placed within the wrapping div.
ClientMethod renderSkeleton() [ Internal, Language = javascript ]
{
	var enc = this.getEnclosingDiv();
	var html = [];
	this._hasSkeleton = true;
	var maxPanels = parseInt(this.maxPanels,10);

	// frame for panels
	html.push('<div id="'+this.makeId('frame')+'" class="dvFrame">');

	// content holders (panels within frame)
	for (var n = 0; n < maxPanels; n++) {
		html.push('<div id="'+this.makeId('panel_'+n)+'" class="dvPanel">');
		html.push('</div>');
	}

	html.push('</div>');

	// (hidden) canvas overlay for effects
	var cw = enc.offsetWidth-20;
	var ch = enc.offsetHeight-20;

	if (this.effectsEnabled && this.browserSupportsCanvas()) {
		html.push('<canvas id="'+this.makeId('canvas')+'" class="dvCanvas" width="'+cw+'" height="'+ch+'"></canvas>');
	}

	enc.innerHTML = html.join('');
}

/// Find the div panel element for the given "level".
ClientMethod getPanelDiv(level) [ Internal, Language = javascript ]
{
	level = zenGet(level,0);
	var div = this.findElement('panel_'+level);
	return div;
}

/// Do the actual work of rendering the document.
ClientMethod renderDocument() [ Internal, Language = javascript ]
{
	// test if we have not been rendered yet
	var enc = this.getEnclosingDiv();
	if (enc == null) return;

	var layout = this.getLayout();
	var data = this.getSourceData();

	if (this.onrender) {
		zenInvokeCallbackMethod(this.onrender,this,'onrender');
	}

	// clear list of svgFrames
	this._svgFrames = [];
	this._chartData = {};
	this._chartLabels = {};
	this._chartEventData = {};
	this._charts = {};
	this._chartControllers = {};

	this._codeTables = {};
	
	var displayMode = this.displayMode;
	// check for local override
	if (layout && 'undefined' != typeof layout.displayMode && displayMode!='data') {
		displayMode = layout.displayMode;
	}

	// build DHTML for the component
	var html = [];
	
	// ask page manager for additional document attributes
	var pluginDocumentAttr = [];
	pluginDocumentAttr.push(this.pageManager.getDocumentAttributes(this,displayMode));

	var docStyle = this.getBaseStyle('documentStyle');
	var docClass = this.getBaseClass('documentClass');
	if (docClass === '') docClass = 'dvDocument';
	html.push('<div ' + (docClass == '' ? '' : 'class="' + docClass + '" ') + (docStyle == '' ? '' : 'style="'+docStyle+'" ') + ' ' + pluginDocumentAttr.join('')+'>');

	switch (displayMode) {
	case 'html':
		if (data) {
			if (this.contentProperty) {
				html.push(data[this.contentProperty]);
			}
			else {
				html.push(data);
			}
		}
		break;
	case 'iframe':
		if (data) {
			if (this.contentProperty) {
				html.push('<iframe id="'+this.makeId('iframe')+'" src="'+this.contentProperty+'"/>');
			}
			else {
				html.push('No contentProperty defined.');
			}
		}
		break;
	case 'data':
		// generic view: for design time
		var counter = {count:0};
		html.push('<div style="background:white;">');
		html.push('<div style="color:#404040;padding:2px;background:#D0E0D0;">Data</div>');
		html.push('<div>documentKey:<b>'+this.getDocumentKey()+'</b></div>');
		html.push(this.renderGeneric(data,0,counter));
		html.push('<div style="color:#404040;padding:2px;background:#D0E0D0;">Layout</div>');
		html.push('<div>layoutKey:<b>'+this.getLayoutKey()+'</b></div>');
		html.push(this.renderGeneric(layout,0,counter));
		html.push('</div>');
		break;
	case 'layout':
	default:
		if (layout && layout.children) {
			var key = '';
			html.push(this.renderLayout(key,data,layout));
		}
		else {
			html.push('<div style="padding:10px;">');
			html.push('No layout defined.');
			if (this.currLevel>0) {
				html.push(' (' + this.currLevel + ')');
				// show "back" button if we are nested
				html.push('<br/><a href="#" onclick="zenPage.getComponent('+this.index+').popDocument();" tabindex="0">Back</a>');
			}
			html.push('</div>');
		}
		break;
	}

	// tack on developer tools
	if (this.developerMode) {
		html.push(this.getDeveloperHTML());
	}

	html.push('</div>');

	// put content into panel
	// wrap panel with dvInnerPanel div
	// find out if content specifies a min content width
	var dvStyle = '';
	var minWidth = this.minContentWidth;
	var minHeight = this.minContentHeight;
	if (layout && zenGet(layout.minContentWidth)) {
		minWidth = layout.minContentWidth;
	}
	if (layout && zenGet(layout.minContentHeight)) {
		minHeight = layout.minContentHeight;
	}

	if (minWidth) {
		dvStyle = dvStyle + 'min-width:' + minWidth + ';';
	}
	if (minHeight) {
		dvStyle = dvStyle + 'min-height:' + minHeight + ';';
	}

	// apply panel style and class if present
	var panelClass = '';
	if (layout) {
		panelClass = zenGet(layout.panelClass,'dvInnerPanel');
		dvStyle += zenGet(layout.panelStyle);
	}

	if (!this.getSuppressRender()) {
		var panel = this.getPanelDiv(this.currLevel);
		panel.innerHTML = '<div '+(panelClass == '' ? '' : 'class="'+panelClass+'" ') + (dvStyle == '' ? '' : 'style="'+dvStyle+'" ') + '>' + html.join('') + '</div>';
	}

	// render inline svg frames
	for (var n = 0; n < this._svgFrames.length; n++) {
		var frame = this._svgFrames[n];
		frame.svgLoadHandler(window);

		/* !!!!
		// if this is "auto" size, adjust the frame
		var parent = frame.findElement('zenRoot').parentNode;
		if (parent) {
			// !!!
			var th = 24;
			frame.setFrameSize(parent.offsetWidth,parent.offsetHeight-th);
			// assume first child is a chart
			var chart = frame.children[0];
			chart.setProperty('width',parent.offsetWidth);
			chart.setProperty('height',parent.offsetHeight-th);
		}
		*/
	}

	// resolve all references to code tables
	var codeList = [];
	var codeNames = {};
	// list all referenced tables
	for (var c in this._codeTables) {
		if (this._codeTables[c] && !codeNames[this._codeTables[c]]) {
			codeList.push(this._codeTables[c]);
			codeNames[this._codeTables[c]] = true;
		}
	}
	var allCodes = codeList.join(',');
	if (allCodes) {
		for (var c in this._codeTables) {
			var instance = null;
			if (this._layoutIndex[this.currLevel][c]) {
				instance = this._layoutIndex[this.currLevel][c];
			}
			if (instance && instance.$setOptionList) {
				instance.$setOptionList(this.fetchCodeTable(instance.codeTable,allCodes));
				allCodes = '';	// only pass to first call
			}
		}
	}

	// !!! add level to frame id
	var iframe = this.findElement('iframe');
	if (iframe) {
		// resize
		iframe.style.width = (enc.offsetWidth-4) + 'px';
		iframe.style.height = (enc.offsetHeight-4) + 'px';
	}

	this.raiseResizeEvents();
	
	// call after render document for page manager
	this.pageManager.afterRenderDocument(this,displayMode,html);
	
	// now rendering is done, so execute any additional code plugins may need
	if (!this.getSuppressCodeExecution()) {
		switch (displayMode) {
			case 'layout':
				if (layout && layout.children) {
					var key = '';
					this.executeCode(key,data,layout);
				}
				break;
		}
	}
}

/// Raise resize events for all elements that registered for them (by setting notifyOnResize true).
ClientMethod raiseResizeEvents() [ Internal, Language = javascript ]
{
	if (this._inresize) return;
	var layout = this.getLayout();

	// send resize notifications (onevent)
	if (this._notifyResize && this._notifyResize[this.currLevel]) {
		this._inresize = true;
		for (var n = 0; n < this._notifyResize[this.currLevel].length; n++) {
			var inst = this._notifyResize[this.currLevel][n];
			this.onevent('resize',zenGet(inst.$key),inst);
		}
		this._inresize = false;
	}
}

/// Return "developer" diagnostic content.
ClientMethod getDeveloperHTML() [ Internal, Language = javascript ]
{
	var html = [];

	html.push('<br style="clear:both;" />');
	html.push('<div style="border-top:1px solid #D0D0D0;padding:4px;padding-left:40px;">');
	if (this.currLevel>0) {
		html.push('<input type="image" src="deepsee/ds2_arrow_west_44_w.png" style="height:12px;" value=" Pop " onclick="zenPage.getComponent('+this.index+').popDocument();" alt="Go back" tabindex="0"/>&nbsp;');
	}

	if (this.displayMode=='data') {
		html.push('<input type="image" src="deepsee/ds2_gear_44.png" class="dvDevIcon" value=" Show Layout " alt="Show Layout" onclick="zenPage.getComponent('+this.index+').setProperty(\'displayMode\',\'layout\');" tabindex="0"/>');
	}
	else {
		html.push('<input type="image" src="deepsee/ds2_gear_44.png" class="dvDevIcon" value=" Show Data " alt="Show Data" onclick="zenPage.getComponent('+this.index+').setProperty(\'displayMode\',\'data\');" tabindex="0"/>&nbsp;');
	}

	if (this.isMobile) {
		html.push(' [mobile]');
	}

	html.push('</div>');
	return html.join('');
}

/// Display a "fade" effect using the canvas.
/// <var>direction</var> is "in" or "out".
/// <var>notify</var> is a callback function to invoke when complete.
ClientMethod startFade(direction, notify) [ Internal, Language = javascript ]
{
	if (this._fadeTimer) {
		// kill current fade
		window.clearTimeout(this._fadeTimer);
		this._fadeTimer = null;
	}
	
	// make sure current data is displayed
	if (direction=='in') {
		this.render();
	}

	this._fadeCounter = 0;
	this._fadeNotify = notify;
	this.fadeHandler(direction);
}

/// Animate fade of canvas.
ClientMethod fadeHandler(direction) [ Internal, Language = javascript ]
{
	var enc = this.getEnclosingDiv();
	if (enc == null) return;

	// draw into canvas
	var canvas = this.findElement('canvas');
	var delay = 25;
	
	if (canvas) {
		var cw = enc.offsetWidth;
		var ch = enc.offsetHeight;

		if (this._fadeCounter==0) {
			canvas.style.display = 'block';
			canvas.width = cw;
			canvas.height = ch;

			if (this.fadeEffect=='fade-flakes') {
				if (!this._flakes || direction=='out') {
					this._flakes = new Array(1000);
					for (var n = 0; n < 1000; n++) {
						this._flakes[n] = {	x:(Math.random()*cw/2)+(Math.random()*cw/2),
											y:(Math.random()*ch/2)+(Math.random()*ch/2),
											dx:Math.random()*10-5,
											dy:Math.random()*10-5,
											};
					}
				}
			}
			else if (this.fadeEffect=='fade-tiles') {
				if (!this._tiles || direction=='out') {
					this._tiles = [];
					var tcount = 20;
					var twid = cw/tcount;
					var thgt = ch/tcount;
					if (twid>thgt) {
						thgt = twid;
					}
					else {
						twid = thgt;
					}
					for (var r = 0; r < tcount; r++) {
						this._tiles[r] = [];
						for (var c = 0; c < tcount; c++) {
							this._tiles[r][c] = {x:c*twid,y:r*thgt,width:twid,height:thgt};
						}
					}
				}
			}
			else {
				delete this._tiles;
				delete this._flakes;
			}
		}

		var ctx = canvas.getContext('2d');
		ctx.clearRect(0,0,cw,ch);

		var max = parseInt(this.fadeSteps,10);
		this._fadeCounter++;
		var pct = this._fadeCounter/max;
		pct = (direction=='out') ? pct*1.5 : (1-pct);
		pct = (pct < 0) ? 0 : pct;
		pct = (pct > 1) ? 1 : pct;

		if (this._tiles) {
			//pct = 0;
		}

		ctx.globalAlpha = pct;
		ctx.fillStyle = this.fadeColor;
		ctx.fillRect(0,0,cw,ch);

		// "flakes"
		if (this._flakes) {
			for (var n = 0; n < this._flakes.length; n++) {
				var flake = this._flakes[n];
				ctx.beginPath();
				ctx.rect(Math.round(flake.x),Math.round(flake.y), 3, 3);
				ctx.fillStyle = n%4?'rgba(100,100,250,0.5)':'rgba(250,250,250,0.9)';
				ctx.fill();
				flake.x += flake.dx;
				flake.y += flake.dy;
				flake.dx *= 1.05;
				flake.dy *= 1.05;
			}
		}

		// "tiles"
		if (this._tiles) {
			ctx.globalAlpha = 1;
			for (var r = 0; r < this._tiles.length; r++) {
				for (var c = 0; c < this._tiles[r].length; c++) {
					var tile = this._tiles[r][c];
					if (tile.on) {
						ctx.beginPath();
						ctx.rect(tile.x,tile.y, Math.ceil(tile.width)-1, Math.ceil(tile.height)-1);
						ctx.fillStyle = 'rgb(255,255,255)';
						ctx.fill();
					}
					else if (Math.random()>0.83) {
						tile.on = (direction=='out') ? true : false;
					}
				}
			}
		}

		// static
		/*
		var imgData = ctx.getImageData(0, 0, cw, ch);
		for (var i=0; i<imgData.data.length; i+=(4*(Math.floor(Math.random()*500)+1))) {
			imgData.data[i]=255;
			imgData.data[i+1]=255;
			imgData.data[i+2]=255;
		}		
		ctx.putImageData(imgData,0,0);
		*/

		if (this._fadeCounter < max) {
			// repeat
			this._fadeTimer = window.setTimeout('zenPage.getComponent('+this.index+').fadeHandler(\''+direction+'\');',delay);
		}
		else {
			this._fadeTimer = null;
			if (direction=='in') {
				// done
				canvas.style.display = 'none';
			}
			// notify
			if (this._fadeNotify && 'function' == typeof this._fadeNotify) {
				this._fadeNotify();
			}
		}
	}
}

/// Put the document view into a "wait state".
ClientMethod startWait(msg, delay) [ Internal, Language = javascript ]
{
	if (this._waiting) return;

	if (this._fadeTimer) {
		// kill current fade/wait
		window.clearTimeout(this._fadeTimer);
		this._fadeTimer = null;
	}

	if (msg) {
		var panel = this.getPanelDiv(this.currLevel);
		panel.innerHTML = '<div class="dvWaitMessage">' + msg + '</div>';
	}

	this._waiting = true;
	this._waitCounter = 0;

	// remember size of docView
	var enc = this.getEnclosingDiv();
	this._docWid = enc.offsetWidth;
	this._docHgt = enc.offsetHeight;

	// start waiting (after a short pause)
	delay = zenGet(delay,250);
	this._fadeTimer = window.setTimeout('zenPage.getComponent('+this.index+').waitHandler();',delay);
}

/// Animate wait state using canvas.
ClientMethod waitHandler() [ Internal, Language = javascript ]
{
	var enc = this.getEnclosingDiv();
	if (enc == null) return;

	// draw into canvas
	var canvas = this.findElement('canvas');
	var delay = 50;

	if (canvas) {
		var ctx = canvas.getContext('2d');
		var cw = enc.offsetWidth;
		var ch = enc.offsetHeight;

		if (cw!=this._docWid || ch!=this._docHgt) {
			this._waitCounter = 0;
			this._docWid = enc.offsetWidth;
			this._docHgt = enc.offsetHeight;
		}

		if (this._waitCounter==0) {
			canvas.style.display = 'block';
			canvas.width = cw;
			canvas.height = ch;
			ctx.clearRect(0,0,cw,ch);
		}

		// "spinning spots"
		var speed = 10;
		var cx = Math.floor(cw/2);
		var cy = Math.floor(ch/2);

		var rad = 100;
		var radInner = rad * 0.9;

		var angle = ((this._waitCounter*speed)/180 * Math.PI) + Math.PI;
		var lx = cx + Math.cos(angle)*rad;
		var ly = cy + Math.sin(angle)*rad;
		var lxi = cx + Math.cos(angle)*radInner;
		var lyi = cy + Math.sin(angle)*radInner;

		var angle2 = angle - Math.PI;
		var lx2 = cx + Math.cos(angle2)*(rad+2);
		var ly2 = cy + Math.sin(angle2)*(rad+2);
		var lx2i = cx + Math.cos(angle2)*(radInner-2);
		var ly2i = cy + Math.sin(angle2)*(radInner-2);

		ctx.lineWidth = rad/10 + 2;
		ctx.lineCap = 'round';

		ctx.strokeStyle = 'rgba(255,255,255,0.8)';

		ctx.beginPath();
		ctx.moveTo(lx2i,ly2i);
		ctx.lineTo(lx2,ly2);
		ctx.stroke();

		var r = Math.floor((Math.sin(this._waitCounter/120)+1)*90);
		var g = Math.floor((Math.sin(this._waitCounter/76)+1)*80);
		var b = Math.floor((Math.cos(this._waitCounter/322)+1)*112);
		ctx.strokeStyle = 'rgb('+r+','+g+','+b+')';
		ctx.lineWidth = rad/10;

		ctx.beginPath();
		ctx.moveTo(lxi,lyi);
		ctx.lineTo(lx,ly);
		ctx.stroke();

		this._waitCounter++;
		this._fadeTimer = window.setTimeout('zenPage.getComponent('+this.index+').waitHandler();',delay);
	}
}

/// End the document "wait state".
ClientMethod endWait(render) [ Internal, Language = javascript ]
{
	render = zenGet(render,true);
	if (this._fadeTimer) {
		// kill current fade/wait
		window.clearTimeout(this._fadeTimer);
		this._fadeTimer = null;
	}
	this._waiting = false;

	var canvas = this.findElement('canvas');
	if (canvas) {
		canvas.style.display = 'none';
	}

	// delay and render
	if (render) {
		window.setTimeout('zenPage.getComponent('+this.index+').render();',10);
	}
}

/// Render the HTML for a "generic" view of the given source data.
ClientMethod renderGeneric(data, level, counter) [ Internal, Language = javascript ]
{
	var html = [];
	if (!data) {
		html.push('null');
	}
	else {
		var indent = level * 10;
		var bg = counter.count%2==0 ? 'none' : '#F0F0F0';
		html.push('<div style="font-size:12px;padding-left:'+indent+'px;background:'+bg+';">{');

		for (var p in data) {
			counter.count++;
			html.push('<span class="dvGenericTitle">' + p + ':</span>');
			var val = data[p];
			if (val===null || val==='') {
				html.push('<span class="dvGenericValue" style="color:#D08080;">' + (val===null?'null':'\'\'') + '</span><br/>');
			}
			else if (typeof val == 'object') {
				if ('undefined' != typeof val.length) {
					// array
					html.push('[');
					for (var n = 0; n < val.length; n++) {
						var val2 = val[n];
						if (typeof val2 == 'object') {
							html.push(this.renderGeneric(val2,level+1,counter));
						}
						else {
							html.push('<span class="dvGenericValue" style="color:#8080D0;">\'' + zenEscapeXML(val2) + '\'</span><br/>');
						}
					}
					html.push(']');
				}
				else {
					html.push(this.renderGeneric(data[p],level+1,counter));
				}
			}
			else if (typeof val === 'function') {
				html.push('<span class="dvGenericValue">\'' + zenEscapeXML(data[p].toString()) + '\'</span><br/>');
			}
			else {
				html.push('<span class="dvGenericValue">\'' + zenEscapeXML(data[p]) + '\'</span><br/>');
			}
		}
		html.push('}</div>');
	}
	return html.join('');
}

/// Update the current layout.<br/>
/// <var>effect</var> is the name of an optional transitional effect to apply:
/// e.g. ("fade").
ClientMethod updateLayout(effect) [ Language = javascript ]
{
	effect = zenGet(effect);
	var handled = false;
	if (effect && this.effectsEnabled && this.browserSupportsCanvas()) {
		switch(effect) {
		case 'fade':
		case 'fade-flakes':
		case 'fade-tiles':
			this.fadeEffect = effect;
			this.startFade('out',zenPage.getComponent(this.index).updateLayoutFadeHandler);
			handled = true;
			break;
		}
	}

	if (!handled) {
		// remove cached layout
		if (this._layout && this._layout[this.currLevel]) {
			delete this._layout[this.currLevel];
		}
		this.render();
	}
}

/// Internal fade handler for updateLayout.
ClientMethod updateLayoutFadeHandler(effect) [ Internal, Language = javascript ]
{
	if (this._layout && this._layout[this.currLevel]) {
		delete this._layout[this.currLevel];
	}
	this.startFade('in',null);
}

/// Get the layout model the defines the layout and display of the document.
ClientMethod getLayout() [ Language = javascript ]
{
	if (this._layout && this._layout[this.currLevel]) {
		return this._layout[this.currLevel];
	}
	
	// special built-in layouts
	var layoutKey = this.getLayoutKey();
	switch (layoutKey) {
	case '$lookupLayout':
		if (this._lookupLayout) {
			return this._lookupLayout;
		}
		break;
	}

	// See if there is user-supplied data to drive the control
	var layout = null;
	if (this.ongetlayout!='' && !this._inGetLayout) {
		// prevent loop
		this._inGetLayout = true;
		// pass along layout key and "criteria"
		layout = zenInvokeCallbackMethod(this.ongetlayout,this,'ongetlayout','key',layoutKey,'criteria',this.getLayoutCriteria());
		delete this._inGetLayout;
	}
	if (this._layout) {
		this._layout[this.currLevel] = layout;
	}
	return layout;
}

/// Get the source data for the document.<br/>
/// This may come from: (a) the layout object (if it defines a sourceData property),
/// (b) the data cache for the current level, or (c) by calling the ongetdata callback.
ClientMethod getSourceData() [ Language = javascript ]
{
	// layout *could* supply its own data
	var layout = this.getLayout();
	if (layout && layout.sourceData) {
		return layout.sourceData;
	}
	
	// special built-in data
	var docKey = this.getDocumentKey();
	switch (docKey) {
	case '$lookupData':
		if (this._lookupData) {
			return this._lookupData;
		}
		break;
	}

	if (this._data && this._data[this.currLevel]) {
		return this._data[this.currLevel];
	}

	// See if there is user-supplied data.
	var model = null;
	if (this.ongetdata!='') {
		// pass along document key and "criteria"
		model = zenInvokeCallbackMethod(this.ongetdata,this,'ongetdata','key',docKey,'criteria',this.getDocumentCriteria());
	}
	return model;
}

/// Invalidate all cached data and layout for this document view.
ClientMethod invalidate() [ Language = javascript ]
{
	if (this._data) {
		for (var n = this.currLevel; n >= 0; n--) {
			this._layout[n] = null;
			this._data[n] = null;
		}
	}
}

/// Set the document data "key", <var>key</var> and optional search criteria,
/// <var>criteria</var> (json format), for the current level.<br/>
/// Invalidate any data cached for the current level.
ClientMethod setDocumentKey(key, criteria, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	if (!this._dataKey) {
		this._dataKey = [];
		this._dataCriteria = [];
	}
	this._dataKey[level] = key;
	this._dataCriteria[level] = zenGet(criteria);

	// invalidate local cache
	if (this._data && this._data[level]) {
		this._data[level] = null;
	}
	if (this._waiting) {
		this.endWait();
	}
}

/// Reset the scrolling of the current pane.
ClientMethod resetScroll() [ Internal, Language = javascript ]
{
	var div = this.getPanelDiv(this.currLevel);
	if (div) {
		div.scrollTop = 0;
		div.scrollLeft = 0;
	}
}

/// Set the document layout "key", <var>key</var> and optional search criteria,
/// <var>criteria</var> (json format), for the current level.<br/>
/// Invalidate any data cached for the current level.
ClientMethod setLayoutKey(key, criteria, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	if (!this._layoutKey) {
		this._layoutKey = [];
		this._layoutCriteria = [];
	}
	
	this._layoutKey[level] = key;
	this._layoutCriteria[level] = zenGet(criteria);

	// invalidate local cache
	if (this._layout && this._layout[level]) {
		this._layout[level] = null;
	}
	if (this._waiting) {
		this.endWait();
	}
}

/// Get the document data "key" for the current level.
ClientMethod getDocumentKey() [ Language = javascript ]
{
	var key = '';
	if (this._dataKey && this._dataKey[this.currLevel]) {
		key = this._dataKey[this.currLevel];
	}
	return key;
}

/// Get the document "criteria" for the current level.
/// Criteria is an object or string value that is used to further qualify the
/// data for this document. For example, you can use criteria to hold the search terms for
/// a search results document.
ClientMethod getDocumentCriteria() [ Language = javascript ]
{
	var criteria = '';
	if (this._dataCriteria && this._dataCriteria[this.currLevel]) {
		criteria = this._dataCriteria[this.currLevel];
	}
	return criteria;
}

/// Get the layout "key" for the current level.
ClientMethod getLayoutKey() [ Language = javascript ]
{
	var key = '';
	if (this._layoutKey && this._layoutKey[this.currLevel]) {
		key = this._layoutKey[this.currLevel];
	}
	return key;
}

/// Get the layout "criteria" for the current level.
ClientMethod getLayoutCriteria() [ Language = javascript ]
{
	var criteria = '';
	if (this._layoutCriteria && this._layoutCriteria[this.currLevel]) {
		criteria = this._layoutCriteria[this.currLevel];
	}
	return criteria;
}

/// Get the current level (indicates how many layers have been
/// pushed on the view).
ClientMethod getLevel() [ Language = javascript ]
{
	return this.currLevel;
}

ClientMethod executeCode(key, data, layout) [ Internal, Language = javascript ]
{
	var graph = this._lastGraph;
	
	var instance = null;
	if (key) {
		instance = this.getItemByKey(key);
	}

	if (instance) {
		// only execute code for *key* and its children
		instance.$executeCodeTraversal();
	}	
	else {
		// execute code for the graph and all children
		if (graph) {
			graph.$executeCodeTraversal();
		}
	}
}

/// Render and return HTML for the given layout template.
ClientMethod renderLayout(key, data, layout) [ Internal, Language = javascript ]
{
	var html = [];

	// *key* is the top level key for this layout
	// *data* is the user-supplied document referenced by the layout
	// *layout* is a document describing the layout
	// graph is a graph of "layout" objects creating from the layout document
	// _layoutIndex is an index of internal item # to layout objects
	// _keyIndex is an index of item key to layout objects

	// if *key* is '', then render the entire document
	// otherwise create the layout graph but only render the *key* instance
	// and its children.

	// cache layout and data while rendering
	var oldLayout = null;
	if (this._layout[this.currLevel]) {
		oldLayout = this._layout[this.currLevel];
	}
	this._layout[this.currLevel] = layout;

	var oldData = null;
	if (this._data[this.currLevel]) {
		oldData = this._data[this.currLevel];
	}
	this._data[this.currLevel] = data;

	// create graph of layout objects
	// resolve all data and style references
	
	// index of index#-to-control instances
	if (!key) {
		this._indexCounter[this.currLevel] = 0;
		this._layoutIndex[this.currLevel] = {};
	}

	// index of keys-to-control instances
	this._keyIndex[this.currLevel] = {};

	// set of items with notifyOnResize enabled
	this._notifyResize[this.currLevel] = [];

	var context = null;
	var graph = this.createLayoutGraph(layout,data,context);
	this._lastGraph = graph;

	var instance = null;
	if (key) {
		instance = this.getItemByKey(key);
	}

	if (instance) {
		// only render *key* and its children
		html.push(instance.$renderItem());
	}	
	else {
		// have root layout object render itself and its children
		html.push(graph.$renderItem({data:data,context:null}));
	}

	// restore
	this._layout[this.currLevel] = oldLayout;
	this._data[this.currLevel] = oldData;

	return html.join('');
}

/// Create a graph of layout objects based on the given layout document.
/// This will flatten out all data-driven loops, resolve all data expressions, and 
/// resolve all named style reference.
ClientMethod createLayoutGraph(layout, data, context) [ Internal, Language = javascript ]
{
	var graph = this.createLayoutObject('$root',layout,data,context);
	if (layout && layout.children) {
		this.addArrayToGraph(graph,layout.children,data,context);
	}
	return graph;
}

/// Add the array of layout items to the given parent (graph).
ClientMethod addArrayToGraph(parent, array, data, context) [ Internal, Language = javascript ]
{
	if (parent && !parent.$children) {
		parent.$children = [];
	}
	for (var n = 0; n < array.length; n++) {
		var item = array[n];
		if (item) {
			var type = zenGet(item.type);
			var instance = this.createLayoutObject(type,item,data,context);
			if (parent) {
				parent.$children.push(instance);
				instance.$parent = parent;
			}

			// flatten out loops
			if (instance.$isLoop) {
				// loop; one instance per element
				var loop = zenGet(instance.value);
				if (('string'== typeof loop) || (loop !== null && typeof loop.length == 'undefined')) {
					// wrap single value within a loop
					loop = [loop];
				}
				
				// if *sortBy* use it to sort the result
				// sortBy is PropName followed by optional:desc
				// sortBy can also sort by multiple fields; in this case "/" separates them
				if (instance.sortBy) {
					var sortData = instance.sortBy.toString().split('/');
					var sortSequence = [];
					for (var i = 0; i < sortData.length; i++) {
						var sortDetails = sortData[i].split(':');
						var sortItem = {
							prop: sortDetails[0],
							asc: (sortDetails.length < 2) || (String(sortDetails[1]).toLowerCase() != 'desc')
						};
						sortSequence.push(sortItem);
					}
					var sortCount = sortSequence.length;
					loop.sort(function(a,b) { 
						for (var i=0; i < sortCount; i++) {
							var sortData = sortSequence[i];
							var a1 = a[sortData.prop];
							var b1 = b[sortData.prop];
							if ((parseFloat(a1)!=a1) || (parseFloat(b1)!=b1)) {
								a1 = a1 ? a1.toString().toLowerCase() : '';
								b1 = b1 ? b1.toString().toLowerCase() : '';
							}
							else {
								a1 = parseFloat(a1);
								b1 = parseFloat(b1);
							}
							// if we can sort, then return this value
							if (a1<b1) return (sortData.asc ? -1 : 1);
							if (a1>b1) return (sortData.asc ? 1: -1);
						}
						// if we fall through then the values are equal
						return 0;
					});
				}

				// establish a new, inner context
				for (var j = 0; j < loop.length; j++) {
					var context2 = {};
					if (zenGet(instance.value)!=='') {
						if (instance.$path) {
							context2.$path = instance.$path;
						}
						context2.$parent = context;
						context2.$loopValue = loop[j];
						context2.$loopIndex = j;
						context2.$loopNumber = j+1;
						context2.$loop = loop;
						context2.$loopKey = (context && 'undefined'!=typeof context.$loopKey) ? (context.$loopKey+':'+j) : j;
					}
					else {
						// pass on current context
						context2 = context;
					}

					// flatten list of children;
					var list = this.getChildList(data,item,context2);

					// add a loop container and then add the list to it
					var container = this.createLayoutObject('$loop');
					instance.$children.push(container);
					container.$parent = instance;
					this.addArrayToGraph(container,list,data,context2);
				}
			}
			else if (item.children) {
				var context2 = context;
				if (item.context) context2 = item.context;
				this.addArrayToGraph(instance,item.children,data,context2);
			}
		}
	}
}

/// Return the list of children of this item, folding out any 'loop'
/// items into the parent list.
ClientMethod getChildList(data, item, context) [ Internal, Language = javascript ]
{
	try {
	var list = [];
	if (item && item.children && item.children.length) { 
		for (var n = 0; n < item.children.length; n++) {
			var child = item.children[n];
			if (child) {
				if (zenGet(child.type)=='$loop') {
					// flatten
					var clist = this.processLoop(data,child,context);
					for (var j = 0; j < clist.length; j++) {
						list.push(clist[j]);
					}
				}
				else {
					list.push(child);
				}
			}
		}
	}
	}
	catch(ex) {
		alert(ex.message);
	}
	return list;
}

/// Materialize the set of items within a 'loop' item.
/// Return a list of layout items to be rendered.
ClientMethod processLoop(data, item, context) [ Internal, Language = javascript ]
{
	// new list
	var list = [];

	context = (item&&item.context)?item.context:context;

	// loop; one item per collection element (no table used)
	var loop = this.evalNode(data,zenGet(item.value),context,item);

	if (('string'== typeof loop) || (loop !== null && typeof loop.length == 'undefined')) {
		// wrap single value within a loop
		loop = [loop];
	}
	for (var j = 0; j < loop.length; j++) {
		// establish a new, inner context
		var context2 = {};

		if (zenGet(item.value)!=='') {
			if (item.$path) {
				context2.$path = item.$path;
			}
			context2.$parent = context;
			context2.$loopValue = loop[j];
			context2.$loopIndex = j;
			context2.$loopNumber = j+1;
			context2.$loop = loop;
			context2.$loopKey = (context && 'undefined'!=typeof context.$loopKey) ? (context.$loopKey+':'+j) : j;
		}
		else {
			// pass on current context
			context2 = context;
		}

		// fold the children of each element into the list
		if (item && item.children && item.children.length) {
			for (var n = 0; n < item.children.length; n++) {
				var child = item.children[n];
				if (child) {
					var type = zenGet(child.type);
					if (type=='$loop') {
						var clist = this.processLoop(data,child,context2);
						for (var k = 0; k < clist.length; k++) {
							var child2 = clist[k];
							if (child2)  {
								var processedChild = {type:zenGet(child2.type), 
													value:zenGet(child2.value),
													context:child2.context,
													title:zenGet(child2.title),
													children:(child2.children?child2.children:null)};
								list.push(processedChild);
								// copy everything else
								for (var p in child2) {
									if (child2[p] && !processedChild[p]) {
										processedChild[p] = child2[p];
									}
								}					
							}
						}
					}
					else {
						var processedChild = {type:type, 
										value:zenGet(child.value),
										context:context2,
										title:zenGet(child.title),
										children:(child.children?child.children:null)};
						list.push(processedChild);
						// copy everything else
						for (var p in child) {
							if (child[p] && !processedChild[p]) {
								processedChild[p] = child[p];
							}
						}					
					}
				}
			}
		}
	}

	return list;
}

/// Render a table given the meta data describing it.
ClientMethod generateTable(instance, info, flip, active) [ Internal, Language = javascript ]
{
	// if true, *flip* will swap rows and columns
	// if true, *active* will add select handling to the table rows

	// info contains the meta data:
	// info = {
	// 	style:''
	// 		colStyles:[], hasRowHeaders:true|false
	// 		rows:[{type:"row|hdr", rowHdr:name, columns:[]}]
	// 		}

	/*
	var info = {
		tableBorder:true:false,
		hasRowHeaders:true,
		rows:[
		{type:'hdr',columns:['Column 1','Column 2','Column 3']},
		{type:'row',rowHdr:'Row 1', hdrStyle:'', columns:[1,2,3], styles:['color:red;']},
		{type:'row',rowHdr:'Row 2', hdrStyle:'', columns:[4,5,6], styles:['','color:red;']},
		{type:'row',rowHdr:'Row 3', hdrStyle:'', columns:[7,8,9], styles:['color:red;']},
		]
	}
	*/	
	active = zenGet(active,false);
	var selectedIndex = parseInt(zenGet(instance.selectedIndex),10);
	selectedIndex = isNaN(selectedIndex) ? '' : selectedIndex;

	if (flip) {
		info = this.flipTable(info);
	}
	var html = [];

	var zebra = zenGet(info.showZebra,true);
	var tableBorder = zenGet(info.tableBorder);
	var tableClass = zenGet(info.tableClass,'dvTable');
	var hrStyle = this.getBaseStyle('headerRowStyle');
	var hrClass = this.getBaseClass('headerRowClass');
	var thStyle = '';
	var tdStyle = '';
	var tableStyle = zenGet(info.style);
	if (tableBorder) {
		thStyle = 'border-right: 1px solid #808080;border-bottom: 1px solid #808080;' + thStyle;
		tdStyle = 'border-right: 1px solid #808080;border-bottom: 1px solid #808080;' + tdStyle;
		tableStyle = 'border-left: 1px solid #808080;border-top: 1px solid #808080;' + tableStyle;
	}

	var evenClass = this.getBaseClass('evenRowClass');
	var oddClass = this.getBaseClass('oddRowClass');
	var evenStyle = zebra ? this.getBaseStyle('evenRowStyle') : '';
	var oddStyle = zebra ? this.getBaseStyle('evenOddStyle') : '';
	var summary = zenGet(instance.summary,'data table');

	if (info.rows && info.rows.length) {
		// add active="1" to html so that we can style active tables
		html.push('<table summary="'+summary+'" class="'+tableClass+'" '+(active?'active="1"':'')+' border="0" cellspacing="0" cellpadding="0" style="'+tableStyle+'">');
		var rowIndex = 0;
		for (var r = 0; r < info.rows.length; r++) {
			var rowInfo = info.rows[r];
			if (rowInfo) {
				switch (rowInfo.type) {
				case 'hdr':
					html.push('<tr ' + (hrClass?'class="'+hrClass+'" ':'') + (hrStyle?'style="'+hrStyle+'" ':'') + ' headerRow="1">');

					if (info.hasRowHeaders) {
						var headerStyle = '';
						if (thStyle) headerStyle += thStyle;
						if (rowInfo.hdrStyle) headerStyle += rowInfo.hdrStyle;
						html.push('<th '+(rowInfo.hdrClass?'class="'+rowInfo.hdrClass+'" ':'') + (headerStyle?'style="'+headerStyle+'" ':'') + '>');
						html.push(rowInfo.rowHdr ? rowInfo.rowHdr : '&nbsp;');
						html.push('</th>');
					}

					if (rowInfo.columns && rowInfo.columns.length) {
						for (var c = 0; c < rowInfo.columns.length; c++) {
							var cellStyle = (rowInfo.styles&&rowInfo.styles[c]) ? rowInfo.styles[c] : '';
							cellStyle = (rowInfo.hdrStyle?rowInfo.hdrStyle:'') + cellStyle;
							var cellClass = (rowInfo.classes && rowInfo.classes[c]) ? rowInfo.classes[c] : '';
							var classAttr = (cellClass ? 'class="'+cellClass+'" ' : '');
							cellStyle = thStyle + cellStyle;
							html.push('<th ' + classAttr + (cellStyle?'style="'+cellStyle+'" ':'') + '>');
							var chdr = zenGet(rowInfo.columns[c]);
							// check special '$checkbox' token
							if (chdr=='$checkbox') {
								chdr = '<input type="checkbox" onclick="alert(\'click\');"/>';
							}
							html.push(chdr ? chdr : '&nbsp;');
							html.push('</th>');
						}
					}
					html.push('</tr>');
					break;
				case 'row':
				default:
					var rcls = r%2==0 ? oddClass : evenClass;
					var rstyle = '';
					if (zebra) {
						rstyle = r%2==0 ? oddStyle : evenStyle;
						rcls += ' ' + (r%2==0 ? 'dvOddRow' : 'dvEvenRow');
					}
					if (selectedIndex===rowIndex) {
						rcls = 'dvSelectedRow';
					}
					var activate = '';
					if (active && instance) {
						activate = (this.isMobile?'ontouchstart':'onclick') + '="zenPage.getComponent('+instance.$documentView.index+').eventHandler('+instance.$index+',event,\'click\','+rowIndex+');"';
						if (!this.isMobile) {
							activate += ' tabindex="0"';
							activate += ' onkeydown="return zenPage.getComponent('+instance.$documentView.index+').eventHandler('+instance.$index+',event,\'click\','+rowIndex+');"';
						}
					}
					html.push('<tr id="'+instance.$makeId('tr_'+rowIndex)+'" '+(rcls?'class="'+rcls+'" ':'')+(rstyle?'style="'+rstyle+'" ':'')+activate+'>');
					if (info.hasRowHeaders) {
						var hdrStyle = (rowInfo.hdrStyle?rowInfo.hdrStyle:'');
						if (thStyle) hdrStyle = thStyle + hdrStyle;
						var hdrClass = (rowInfo.hdrClass?'class="'+rowInfo.hdrClass+'" ':'');
						html.push('<th '+hdrClass+(hdrStyle?'style="'+hdrStyle+'" ':'')+'>&nbsp;');
						html.push(rowInfo.rowHdr ? rowInfo.rowHdr : '&nbsp;');
						html.push('</th>');
					}
					if (rowInfo.columns && rowInfo.columns.length) {
						for (var c = 0; c < rowInfo.columns.length; c++) {
							var cellStyle = (rowInfo.styles&&rowInfo.styles[c]) ? rowInfo.styles[c] : '';
							if (tdStyle) cellStyle = tdStyle + cellStyle;
							if (rstyle) cellStyle = rstyle + cellStyle;
							var cellClass = (rowInfo.classes && rowInfo.classes[c]) ? rowInfo.classes[c] : '';
							html.push('<td '+(cellClass?'class="'+cellClass+'" ':'')+(cellStyle?'style="'+cellStyle+'" ':'')+'>');
							html.push(rowInfo.columns[c]?rowInfo.columns[c]:'&nbsp;');
							html.push('</td>');
						}
					}

					html.push('</tr>');
					rowIndex++;
					break;
				}
			}
		}
		html.push('</table>');
	}

	return html.join('');
}

/// Rotate the meta data for a table 90 degrees.
/// Assume only one header row.
ClientMethod flipTable(info) [ Internal, Language = javascript ]
{
	var hasColHdrs = false;
	var hasRowHdrs = false;
	var newRows = [];
	var colHdrs = [];

	if (info.rows && info.rows.length) {
		for (var r = 0; r < info.rows.length; r++) {
			var rowInfo = info.rows[r];
			if (rowInfo.rowHdr && rowInfo.rowHdr!=='') {
				hasColHdrs = true;
				colHdrs[r] = rowInfo.rowHdr;
			}
			else {
				colHdrs[r] = '';
			}
			if (rowInfo.columns && rowInfo.columns.length) {
				for (var c = 0; c < rowInfo.columns.length; c++) {
					if (!newRows[c]) {
						newRows[c] = {type:'row', columns:[],styles:[],classes:[]};
					}
					if (rowInfo.type=='hdr') {
						hasRowHdrs = true;
						newRows[c].rowHdr = rowInfo.columns[c];
						newRows[c].hdrStyle = (rowInfo.styles&&rowInfo.styles[c])?rowInfo.styles[c]:'';
						newRows[c].hdrClass = (rowInfo.classes && rowInfo.classes[c]) ? rowInfo.classes[c] : '';
					}
					else {
						newRows[c].columns.push(rowInfo.columns[c]);
						newRows[c].styles.push((rowInfo.styles&&rowInfo.styles[c])?rowInfo.styles[c]:'');
						newRows[c].classes.push((rowInfo.classes && rowInfo.classes[c]) ? rowInfo.classes[c] : '');
					}
				}
			}
		}
	}

	var newInfo = { hasRowHeaders:hasRowHdrs, rows:newRows, tableBorder:zenGet(info.tableBorder), tableClass:zenGet(info.tableClass) };
	if (hasColHdrs) {
		newInfo.rows.splice(0,0,{type:'hdr',columns:colHdrs});
	}

	return newInfo;
}

/// Notification that a dashboard has loaded.
ClientMethod dashboardLoaded(index) [ Internal, Language = javascript ]
{
	if (this._layoutIndex && this._layoutIndex[this.currLevel]) {
		var inst = this._layoutIndex[this.currLevel][index];
		if (inst) {
			// html progress version
			var div = inst.$findElement('loading');
			if (div) {
				div.style.display = 'none';
			}
		}
	}
	this.endWait(false);
}

/// Element click handler for time charts.
ClientMethod chartElementClick(idx, key) [ Internal, Language = javascript ]
{
	var chart = this._charts[idx];
	if (chart) {
		// alert via onselect
		// make chart available to caller
		this._targetChart = chart;
		this.onselect(key,chart.getSelectedItem());
		delete this._targetChart;
	}
}

/// Return the chart, if any, that raised the current onselect event.
ClientMethod getTargetChart() [ Internal, Language = javascript ]
{
	return this._targetChart ? this._targetChart : null;
}

/// Time range handler for time charts.
ClientMethod chartRangeChange(idx, final) [ Internal, Language = javascript ]
{
	// update chart range
	var chart = this._charts[idx];
	if (chart) {
		var items = chart.getSeriesSize();
		if (final || items<200) {
			var rangeControl = this._chartControllers[idx]
			if (rangeControl) {
				chart.setTimeRange(rangeControl.startRange,rangeControl.endRange,final);
			}
		}
	}
}

/// Evaluate a display value expression and return the result.<br/>
/// <var>data</var> is the data source object supplying the data.<br/>
/// <var>expr</var> is the expression. If is starts with "=", it is interpreted as an expression.<br/>
/// An expression can refer to a property within the data source object:<br/>
/// "=[prop]" evaluates to sourceData.prop<br/>
/// "=[propA.propB]" evaluates to sourceData.propA.propB (if propA is not an object, return "")<br/>
/// "=[prop[0]]" evaluates to sourceData.prop[0]<br/>
/// <var>context</var> is current context object (which modifies the reference to the data source object).<br/>
/// <var>item</var> is the layout object that contains the expression.<br/>
ClientMethod evalNode(data, expr, context, item, datapath, ifnull, instance) [ Internal, Language = javascript ]
{
	var value = '';
	// trim?
	expr = zenGet(expr);

	var prop = expr.toString();
	var propList = null;
	var isNot = false;
	// path to later *set* this value
	var path = null;
	var matchedProp = null;
	// Regular expression to match =[path], =![path], =[[literals]] or =![[literals]]
	// Note that path may include numeric positions path[n].abc[0]
	// Because we sue the expression with exec(), we don't want the contents in the literal to be included in the results
	var regX = /\u003D(\!?)\[((?:[\w.\$]+(?:(?:\[\d+\])|[\w.\$]+)*)|\[(?:[\w,.\$])+\])\]/m;
	// Regular expression to match subproperties
	var propSubRegX = new RegExp('([\w\$]+)\[(\d+)\]','m');
	var sourceRoot = data;
	if (context) {
		sourceRoot = context.$loopValue;
	}
	var allEmpty = true;
	var matchCount = 0;
	var source = null;
	var tempVal = '';
	var subMatch = null;
	var subIndex = null;
	var propName = null;
	var propCount = 0;
	var fullMatch;

	var match = regX.exec(prop);
	while (match) {
		matchCount++;
		path = null;
		if (match.index > 0) {
			value += prop.substring(0,match.index);
		}
		fullMatch = match[0];
		prop = prop.substring(match.index + fullMatch.length);
		isNot = (match[1] == '!');
		matchedProp = match[2];
		// check for [literal] case
		if ((matchedProp.charAt(0) == '[') && (matchedProp.charAt(matchedProp.length - 1) == ']')) {
			value = matchedProp.substring(1,matchedProp.length-1).split(',');
		}
		else {
			propList = matchedProp.split('.');
			if (propList.length > 0) {
				tempVal = '';
				// $method--> invoke callback
				if (propList[0] == '$method') {
					tempVal = '$method';
					if (this.onresolvemethod != '') {
						propList.splice(0,1);
						var which = propList.join('.');
						tempVal = zenInvokeCallbackMethod(this.onresolvemethod,this,'onresolvemethod','context',context ? context : {$instance:instance},'which',which);
					}
				}
				else {
					source = sourceRoot;
					path = null;
					propCount = propList.length;
					for (var n = 0; n < propCount; n++) {
						propName = propList[n];
						
						subIndex = '';
						// check for prop[n]
						subMatch = propSubRegX.exec(propName);
						if (subMatch) {
							propName = subMatch[1];
							subIndex = subMatch[2];
						}

						switch (propName) {
							case '$root':
								source = data;
								path = '';
								break;
							case '$loopValue':
								if (path === null) {
									if (context && context.$path) {
										path = context.$path;
										if (context.$loopIndex !== '') {
											path += '[' + context.$loopIndex + ']';
										}
									}
									else {
										path = '';
									}
								}
								break;
							case '$loop':
							case '$loopIndex':
							case '$loopNumber':
								source = context ? context[propName] : '';
								break;
							default:
								if (!source) {
									source = '';
								}
								else {
									if (path === null) {
										if (context && context.$path) {
											path = context.$path;
											if (context.$loopIndex !== '') {
												path += '[' + context.$loopIndex + ']';
											}
										}
										else {
											path = '';
										}
									}
									source = zenGet(source[propName]);
									path += "['" + propName + "']";
									if ((source !== '') && (subIndex !== '')) {
										source = zenGet(source[subIndex]);
										path += '[' + subIndex + ']';
									}
								}

								break;
						}
						if ((n < (propCount - 1)) && (typeof source != 'object')) {
							source = '';
						}
						if (source === '') {
							break;
						}
					}
					tempVal = source;
				}
				if (isNot) {
					// tempVal could be an object
					value = (tempVal && (tempVal !== '') && (tempVal !==0) && (tempVal !== '0')) ? false : true;
					
				}
				else {
					switch (typeof tempVal) {
						case 'boolean':
						case 'object':
							value = tempVal;
							break;
						case 'number':
							if (value === '') {
								value = tempVal;
							}
							else {
								value += tempVal;
							}
							break;
						case 'string':
							value += tempVal;
							break;
					}
					if (tempVal !== '') {
						allEmpty = false;
					}
				}
			}
		}

		match = regX.exec(prop);
	}
	
	// return path
	if (matchCount > 0 && datapath && path) {
		datapath.path = path;
	}
	
	// be careful about handling non-strings here
	if (prop != '') {
		value += prop;
	}

	// null replacement
	if (ifnull) {
		if ((value==='') || ((matchCount > 0) && allEmpty)) {
			if (ifnull == '$hide') {
				value = '';
			}
			else {
				value = this.evalNode(data,ifnull,item.context?item.context:context,item,datapath?datapath:null,'');
			}
		}
	}
	return value;
}

/// Given a data object, a path, and a value, resolve the path and set the value
/// into the data object.<br/>
/// A path takes the form:<br/>
/// ['firstName']<br/>
/// ['doctors'][2]<br/>
/// ['doctors'][2]['name']<br/>
ClientMethod applyValueToPath(data, path, value) [ Internal, Language = javascript ]
{
	if (!path) {
		return;
	}

	// first, split the path
	var tokens = [];
	var currToken = '';
	var state = 0;
	path = path.toString();
	for (var p = 0; p < path.length; p++) {
		var ch = path.charAt(p);
		switch (state) {
		case 0:
			// look for [
			if (ch=='[') {
				currToken = '';
				state = 1;
			}
			break;
		case 1:
			// look for ]
			if (ch==']') {
				tokens.push(currToken);
				currToken = '';
				state = 0;
			}
			else {
				currToken += ch;
			}
			break;
		}
	}

	// now apply tokens
	var context = data;
	if (context === null) {
		context = {};
	}
	var lastContext = null;
	var lastProp = null;
	for (var n = 0; n < tokens.length; n++) {
		var token = tokens[n];
		if (token.toString().charAt(0)=='\'' && token.toString().charAt(token.length-1)=='\'') {
			// prop name
			token = token.substring(1,token.length-1);
			if (context===null && lastProp) {
				lastContext[lastProp] = {};
			}

			if (n==tokens.length-1) {
				context[token] = value;
			}
			else {
				lastProp = token;
				lastContext = context;
				context = context[token];
			}
		}
		else {
			// collection index
			token = parseInt(token,10);
			if (context===null && lastProp) {
				lastContext[lastProp] = [];
			}

			if (n==tokens.length-1) {
				context[token] = value;
			}
			else {
				lastProp = token;
				lastContext = context;
				context = context[token];
			}
		}
	}
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Internal, Language = javascript ]
{
	switch(property) {
	case 'content':
		var div = this.getEnclosingDiv();
		value = value ? value : '';
		this.content = value.toString();
		// n.b. NO support for #()# expressions
		div.innerHTML = value;

		// reset layout
		this._hasSkeleton = false;
		this.currLevel = 0;
		delete this._layoutIndex;
		break;
	case 'seed':
		if (this.seed != value) {
			this.seed = value;
			this.render();
		}
		break;

	case 'developerMode':
	case 'displayMode':
	case 'contentProperty':
		this[property] = value;
		this.render();
		break;

	case 'fadeSteps':
	case 'fadeColor':
		this[property] = value;
		break;

	case 'documentStyle':
	case 'titleStyle':
	case 'blockStyle':
	case 'paraStyle':
	case 'tableStyle':
	case 'headerRowStyle':
	case 'oddRowStyle':
	case 'evenRowStyle':
	case 'tableBorder':
		this[property] = value;
		this.render();
		break;
	default:
		this.invokeSuper('setProperty',arguments);
		break;
	}
}

/// Get the value of the given base style.
/// First see if the layout defines the given style, else default to the
/// property of this component.
ClientMethod getBaseStyle(property) [ Internal, Language = javascript ]
{
	var style = '';
	switch(property) {
	case 'documentStyle':
	case 'titleStyle':
	case 'blockStyle':
	case 'paraStyle':
	case 'tableStyle':
	case 'headerRowStyle':
	case 'oddRowStyle':
	case 'evenRowStyle':
	case 'tableBorder':
		style = this[property];
		var layout = this.getLayout();
		if (layout) {
			style = zenGet(layout[property],style);
		}
		break;
	}
	return style;
}

ClientMethod getBaseClass(property) [ Internal, Language = javascript ]
{
	var baseClass = '';
	switch(property) {
	case 'documentClass':
	case 'titleClass':
	case 'blockClass':
	case 'paraClass':
	case 'tableClass':
	case 'headerRowClass':
	case 'oddRowClass':
	case 'evenRowClass':
		baseClass = this[property];
		var layout = this.getLayout();
		if (layout) {
			baseClass = zenGet(layout[property],baseClass);
		}
		break;
	}
	return baseClass;
}

/// Format a date (yyyy-mm-dd) for display.
ClientMethod formatDate(date) [ Internal, Language = javascript ]
{
	if (!date) return '';
	var text = '';
	var t = date.toString().split('-');
	var year = t[0] ? parseInt(t[0],10) : '';
	var month = t[1] ? parseInt(t[1],10) : '';
	var day = t[2] ? parseInt(t[2],10) : '';

	var today = new Date();
	var d = new Date(year,month-1,day);
	if (d.getFullYear() == today.getFullYear() &&
		d.getMonth() == today.getMonth() && 
		d.getDate() == today.getDate()) {
		text = $$$Text('Today');
	}
	else if (d.getFullYear() == today.getFullYear() &&
		d.getMonth() == today.getMonth() && 
		(d.getDate()+1) == today.getDate()) {
		// !!! end of month !!!
		text = $$$Text('Yesterday');
	}
	else {
		var months = _zenResource['zenMonthNames'].split(',');
		text = months[month-1] + ' ' + day;
	}
	return text;
}

/// Render the root element of a layout graph.
ClientMethod renderRoot() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];
	if (this.$children) {
		for (var n = 0; n < this.$children.length; n++) {
			var child = this.$children[n];
			html.push(child.$renderItem());
		}
	}

	return html.join('');
}

/// check that all libraries are loaded
ClientMethod checkLibraries() [ Internal, Language = javascript ]
{
	this._checkedLibraries = true;
	
	this.pageManager.checkLibraries();
}

///  register plugins
ClientMethod registerPlugins() [ Internal, Language = javascript ]
{
	this._hasConflicts = false;
	
	this._hasPluginsRegistered = true;
	
	this.pageManager.registerPlugins(this);
	
	// in case there are any plugin conflicts invoke the callback method for resolving
	if (this._hasConflicts) {
		
		zenInvokeCallbackMethod(this.onresolvepluginconflicts,this,'onresolvepluginconflicts','conflicts',this.getPluginConflicts());
		
	}
}

ClientMethod getPluginMap() [ Internal, Language = javascript ]
{
	return this.pluginMap;
}

/// Set the plugin which maps to the layout object type (e.g. '$loop')
ClientMethod setPluginMapping(identifier, pluginName) [ Language = javascript ]
{
	// check that the plugin is used by this documentView
	if (this.getPluginByName(pluginName) == undefined) {
		return;
	}
	
	// only set the plugin preference if the plugin registered for this identifier!
	if (this.pluginMap[identifier]!=undefined) {
		this.pluginMap[identifier] = pluginName;
	}
}

/// Get the plugin which maps to the given layout object type (e.g. '$loop')
ClientMethod getPluginMapping(identifier) [ Language = javascript ]
{
	return this.pluginMap[identifier];
}

ClientMethod getPluginConflicts() [ Language = javascript ]
{
	return this.pluginConflicts;
}

/// returns a plugin for a given plugin name.
/// returns null if no plugin is registered for this name
ClientMethod getPluginByName(pluginName) [ Language = javascript ]
{
	return this.pageManager.getPluginByName(pluginName);
}

/// returns the plugin for a given layout object type (e.g. "$loop")
/// returns null if no plugin is registered for this layout object type
ClientMethod getPluginByLayoutObjectType(identifier) [ Language = javascript ]
{
	return this.getPluginByName(this.getPluginMapping(identifier));
}

/// Render one item within a layout graph.
/// This handles the outer content for the item.
ClientMethod renderItem() [ Internal, Language = javascript ]
{
	// note: *this* is a layout object
	var html = [];

	// test for hidden attr
	var hidden = zenGet(this.hidden,false);

	// test for ifnull=$hide
	var ifnull = (zenGet(this.ifnull)=='$hide');

	var docView = this.$documentView;

	// wrap item within a block
	if (this.$hasBlock) {
		// is this item active?
		var activate = '';
		var value = zenGet(this.value);
		if (!this.$isLoop && this.active && !zenGet(this.disabled,false)) {
			// for loops, active applies to the elements of the loop
			activate = (this.isMobile?'ontouchstart':'onclick') + '="zenPage.getComponent('+docView.index+').eventHandler('+this.$index+',event,\'click\',\''+value+'\');"';
			if (!this.isMobile) {
	 			activate += ' tabindex="0"';
				activate += ' onkeydown="return zenPage.getComponent('+docView.index+').eventHandler('+this.$index+',event,\'click\',\''+value+'\');"';
			}
 		}
		var blockStyle = zenGet(this.blockStyle);
		var text = zenGet(this.text);
		var content = zenGet(this.content);
		if (hidden || (ifnull && value==''&& text==''&& content=='')) {
			blockStyle += 'display:none;';
		}

		var tooltip = '';
		if (this.tooltip) {
			tooltip = 'title="'+zenEscapeXML(this.tooltip)+'"';
		}
		
		// $type attr is a diagnostic only
		// key and category attr is to allow css selector to target this block
		// key is not qualified
		var keyAttr = 'undefined' != typeof this.key ? (' key="'+this.key+'"') : '';
		var catAttr = 'undefined' != typeof this.category ? (' category="'+this.category+'"') : '';
		html.push('<div class="'+zenGet(this.blockClass,'dvBlock')+'" id="'+this.$makeId()+'"'+keyAttr+catAttr+' $type="'+this.$type+'" '+activate+' style="'+blockStyle+'" '+tooltip+'>');
	}

	// add title
	var titleHTML = '';
	if (this.$showTitle) {
		var title = zenGet(this.title);
		if (title) {
			var tcls = zenGet(this.titleClass,this.$titleClass);
			titleHTML = '<div class="'+(tcls)+'" style="'+zenGet(this.titleStyle)+'">' + zenEscapeXML(title) + '</div>';
		}
	}
	if (titleHTML) {
		html.push(titleHTML);
	}

	// get inner contents of element
	if (this.$render && 'function'==typeof this.$render) {
		html.push(this.$render());
	}
	else if (null !== this.$render) {
		html.push('<span style="color:red;">Invalid $render function</span>: ' + this.$type);
	}

	// end of block
	if (this.$hasBlock) {
		html.push('</div>');
	}
	return html.join('');
}

ClientMethod injectEventHandler(content, instance) [ Language = javascript ]
{
	/// $$$event handling
	
	// resolve any special variables within the HTML
	// $$$event(evtType)
	if (content.toString().indexOf('$$$event')>=0) {
		// replace $$$event.evtType with:
		// zenPage.getComponent('+docView.index+').eventHandler(index,event,evtType,args...);
		var t = content.toString().split('$$$event(');
		for (var n = 1; n < t.length; n++) {
			var t2 = t[n].split(')');
			var evtType = t2[0];
			// evtType may be a list of arguments...
			t2[0] = 'zenPage.getComponent('+this.index+').eventHandler(' + instance.$index + ',event,' + evtType;
			t[n] = t2.join(')');
		}
		content = t.join('');
	}
	
	return content;
}

/// Generic event handler for controls.
/// All $$$events flow through here.
ClientMethod eventHandler(index, evt, evtType, v1, v2) [ Internal, Language = javascript ]
{
	evt = evt ? evt : window.event;

	if (evt&&evt.type=='keydown' && evtType=='click') {
		if (evt.keyCode != zenENTER) {
			return true;
		}
	}

	// hold on to event
	this.lastEvent = evt;

	// find layout instance.
	var instance = null;
	if (this._layoutIndex[this.currLevel][index]) {
		instance = this._layoutIndex[this.currLevel][index];
	}

	var notify = true;
	var ret = true;
	var final = false;
	final = (evtType=='change');

	// check for override of handler
	if (evtType && instance && instance.$eventHandlers && instance.$eventHandlers[evtType]) {
		var handler = instance.$eventHandlers[evtType];
 		if ('function'==typeof handler) {
	 		// provide context for event handler
	 		// pass up to 2 additional args
	 		instance.$eventMethod = handler;
	 		instance.$notify = notify;
	 		ret = instance.$eventMethod(evt,v1,v2);

	 		// test variable to prevent notify
	 		notify = instance.$notify;
	 		instance.$eventMethod = null;
 		}
	}

	// apply control change to instance
	if (evtType=='change') {
		instance.$applyChangeToInstance();
	}
	// test for auto-apply
	// this has to happen *before* we notify
	if ((evtType=='change') && instance.apply) {
		var data = this.getSourceData();
		this.applyValueToPath(data,instance.$path,instance.value);
	}

	// get qualified key and value from instance
	var key = instance ? zenGet(instance.$key) : '';
	var value = '';
	if (instance) {
		if (instance.$isLoop) {
			// value is loop index
			value = zenGet(v1);
		}
		else {
			value = instance.$getValue();
		}
	}

	// check for *built-in* handlers
	switch(key) {
	case '$popDocument':
		// pop current level
		notify = false;
		this.popDocument();
		break;
	case '$lookupSelect':
		// user has selected an item in a lookup list
		// v1 is index of selected choice
		var currControl = this.getCurrentControl();
		if (currControl && currControl.$setValue) {
			var data = this.getSourceData();
			var value = (data && data.children) ? data.children[v1] : '';
			if ('object' == typeof value && !value.$code && currControl.codeTable) {
				// add code table to value
				value.$code = currControl.codeTable;
			}

			// pop before set to make sure index values are correct
			this.popDocument();
			currControl.$setValue(value,true);
			this.popCurrentControl();
		}
		else {
			this.popDocument();
		}
		if (currControl) {
			// give back focus to the control - was lost because of push/pop
			currControl.$findElement('control').focus();
		}
		notify = false;
		break;
	}
	
	// check if propagation is allowed from the client side
	var propagation = false;
	
	// check for callbacks
	if (notify) {

		switch (evtType) {
		case 'change':
		case 'keyup':
			if (evtType=='keyup' && evt.keyCode==13) {
				// skip
			}
			else {
				propagation=this.onchange(key,final?value:instance.$getControlValue(),final,evt);
			}
			break;
		case 'select':
		case 'click':
			propagation=this.onselect(key,value,evt);
			break;
		default:
			propagation=this.onevent(evtType,key,value,evt);
			break;
		}
		if(!propagation){
			if (evt && evt.stopPropagation) {
				evt.stopPropagation();
			}
		}
	}
	
	// stop propagation
	if (!propagation) {
		if (evt && evt.stopPropagation && !this.getSuppressStopPropagation()) {
			evt.stopPropagation();
		}
	}
	
	return ret;
}

/// Create (and cache) the base object used for layout objects.
ClientMethod createLayoutObjectBase() [ Internal, Language = javascript ]
{
	if (!this._layoutBase) {
		// base "class" for layout objects
		// all built-in properties start with "$"
		// all resolved properties from the layout document will be folded in
		// as objects are created.
		this._layoutBase = function(view) {

			// pointer to container
			this.$documentView = view;

			// associated item in layout
			this.$item = null;
			this.$type = '';

			// process item as loop
			this.$isLoop = false;

			// show a title; css class
			this.$showTitle = true;
			this.$titleClass = 'dvTitle';

			// wrap item within a block
			this.$hasBlock = true;

			// function to render entire component
			this.$renderItem = function() { return 'renderItem';},

			// user-function to render inner part of component
			this.$render = function() { return '('+this.$type+')';},

			// function to traverse graph for $executeCodeXXX
			this.$executeCodeTraversal = function() {
				this.$executeCodeBeforeChildren();
				if (this.$children) {
					for (var n = 0; n < this.$children.length; n++) {
						var child = this.$children[n];
						child.$executeCodeTraversal();
					}
				}
				this.$executeCodeAfterChildren();
			};

			// function to execute code for a component after its html got inserted into the dom - gets called before the children code
			this.$executeCodeBeforeChildren = function() {/*console.log('executeCodeBeforeChildren: ' + this.$type);*/};

			// function to execute code for a component after its html got inserted into the dom - gets called after the children code
			this.$executeCodeAfterChildren = function() {/*console.log('executeCodeAfterChildren: ' + this.$type);*/};


			// array of children
			this.$children = null;

			this.$getChild = function(idx) { return this.$children ? this.$children[idx] : null; };

			// set size
			this.$setSize = function(w,h) { alert("Not implemented");};

			// make id function
			// this is used to assign ids to the element and any sub elements it may contain
			this.$makeId = function(which) { 
				var id = this.$id ? this.$id : 'dv_'+this.$documentView.index+'_'+this.$documentView.currLevel + '_' + this.$index + '_' + this.$renderCount;
				return  id+((which&&(which!==''))?('_'+which):'');
				},

			// find element function
			this.$findElement = function(which) { 
				if (this.idAlias && typeof this.idAlias === 'object' && this.idAlias[which]!==undefined) {
					which = this.idAlias[which];
				}
				return document.getElementById(this.$makeId(which?which:''));
			},

			// find layout object by key function
			this.$getObjectByKey = function(key) { 
				var instance = null;
				var dv = this.$documentView;
				if (key && dv) {
					instance = dv.getItemByKey(key);
				}
				return instance;
			},
			
			// find display value (resolve text, value, and coded values)
			this.$getDisplayText = function() {
				var text = ''
				var format = zenGet(this.format);
				if ('undefined'!=typeof this.text) {
					text = this.text;
					format = '';
				}
				else {
					if ('object'==typeof this.value) {
						if ('undefined'!=typeof this.value.text) {
							text = this.value.text;
							format = '';
						}
						else if ('undefined'!=typeof this.value.value) {
							text = this.value.value;
						}
					}
					else if ('undefined'!=typeof this.value) {
						text = this.value;
					}
				}
				if (format && text) {
					if (format == '$date') {
						text = this.$documentView.formatDate(text);
					}
					else {
						text = zenFormatNumber(text,format);
					}
				}
				return text;
			}

			// setter
			this.$setValue = function(value,notify) { this.value = value; };

			// getter ('text','value' or normal (which could be a coded value))
			this.$getValue = function(which) { 
				if (which && 'undefined'!=typeof this.value) {
					if ('object'==typeof this.value) {
						switch(which) {
						case 'text':
							return  ('undefined'!=typeof this.value.text) ? this.value.text : (('undefined'!=typeof this.value.value) ? this.value.value : '');
						case 'value':
							return ('undefined'!=typeof this.value.value) ? this.value.value : '';
						}
					}
					else {
						switch(which) {
						case 'text':
							return  ('undefined'!=typeof this.text) ? this.text : this.value;
						case 'value':
							return this.value;
						}
					}
				}
				return ('undefined'!=typeof this.value) ? this.value : '';
			};

			// get current value in control
			this.$getControlValue = function() { return ''; };

			// apply change in control value to instance value
			this.$applyChangeToInstance = function() { };

			// hide/show this item
			this.$hide = function(hide) {
				var div = this.$findElement();
				if (div) {
					div.style.display = hide ? 'none' : ''; 
				}
			};

			// disable/enable this item
			this.$disable = function(disabled) {
			};
		}
	}
	// return an instance of the base object
	return new this._layoutBase(this);
}

/// Create a layout object for a document item.
/// These objects form the layout graph used to render the document.
/// Each layout object contains the context and code needed to render itself.
ClientMethod createLayoutObject(type, item, data, context) [ Internal, Language = javascript ]
{
	var instance = this.createLayoutObjectBase();
	instance.$item = item ? item : null;
	instance.$type = type;

	context = (item&&item.context)?item.context:context;

	// qualified key: key:loop#:loop#...
	if (item && item.key && item.key!=='') {
		instance.$key = item.key;
		if (context && 'undefined' != typeof context.$loopKey && context.$loopKey!=='') {
			instance.$key = instance.$key + ':' + context.$loopKey;
		}
	}

	// index
	if (this._layoutIndex[this.currLevel]) {
		//instance.$index = this._layoutIndex[this.currLevel].length;
		//this._layoutIndex[this.currLevel].push(instance);
		// !!! may sure index matches rendered item!
		// use global counter for indices
		instance.$index = this._indexCounter[this.currLevel]++;
		instance.$renderCount = this._renderCounter[this.currLevel]++;
		this._layoutIndex[this.currLevel][instance.$index] = instance;
		if (instance.$key && instance.$key!=='') {
			this._keyIndex[this.currLevel][instance.$key] = instance;
		}
	}

	// notifyOnResize
	if (item && item.notifyOnResize) {
		this._notifyResize[this.currLevel].push(instance);
	}

	// copy all layout properties into instance object
	var namedStyles = null;
	if (item) {
		// remember path for resolving value (needed for apply logic)
		var path = null;

		for (var p in item) {
			if (p!='children') {
				var val = item[p];
				val = (('undefined'==typeof val)||(val===null) ? '' : val);
				// resolve all expressions
				var datapath = (p=='value') ? {} : null;
				var ifnull = (p=='value'||p=='text'||p=='content') ? zenGet(item.ifnull) : '';
				if (val.toString().charAt(0)=='=' && val.toString().indexOf('$method')==-1) {
					val = this.evalNode(data,val,context,item,datapath,ifnull,instance);
					if (p=='value' && datapath.path) {
						path = datapath.path;
					}
				}
				else if (typeof val == 'object') {
					var valObj = val;
					for (var nestP in val) {
						var nestVal = val[nestP];
						if (typeof nestVal == 'string') {
							if (nestVal.charAt(0)== '=') {
								nestVal = this.evalNode(data,nestVal,context,item,datapath,ifnull,instance);
							}
							valObj[nestP] = nestVal;
						}
					}
					val = valObj;
				}

				instance[p] = val;
			}
		}
		
		// resolve all method callbacks
		for (var p in item) {
			if (p!='children') {
				var val = item[p];
				val = (('undefined'==typeof val)||(val===null) ? '' : val);
				// resolve all expressions
				var datapath = (p=='value') ? {} : null;
				var ifnull = (p=='value'||p=='text'||p=='content') ? zenGet(item.ifnull) : '';
				if (val.toString().length >= 9 && val.toString().charAt(0)=='=' && val.toString().indexOf('$method')>-1) {
					val = this.evalNode(data,val,context,item,datapath,ifnull,instance);
					if (p=='value' && datapath.path) {
						path = datapath.path;
					}
					instance[p] = val;
				}
				
			}
			
		}
		
		if (path!=='') {
			instance.$path = path;
		}

		// allow item to turn off its wrapping block
		if (zenGet(item.hasBlock,true)==false) {
			instance.$hasBlock = false;
		}
		
	}

	// set up renderItem method
	switch(type) {
	case '$root':
		instance.$renderItem = this.renderRoot;
		break;
	default:
		instance.$renderItem = this.renderItem;
		break;
	}
	
	//dispatch to the plugin responsible for this type
	if (this.getPluginMapping(type) != undefined) {
		this.getPluginByLayoutObjectType(type).createLayoutObjects(type,instance);
	}

	// keep non-duplicates and delete duplicates in $extra
	if (instance.$extra && typeof instance.$extra === 'object') {
		for (var p in instance.$extra) {
			if (!instance[p]) {
				// no duplicate - we can use it in the instance
				// no copy at the moment 
				//instance[p] = instance.$extra[p];
			} else {
				// duplicate
				delete instance.$extra[p];
			}
		}
	}
	return instance;
}

/// Resolve the value of a named style.
ClientMethod resolveNamedStyle(namedStyle) [ Internal, Language = javascript ]
{
	var style = '';
	if (namedStyle) {
		var layout = this.getLayout();
		if (layout && layout.namedStyles) {
			// n.b. there can be a + delimited list of named styles
			var t = namedStyle.toString().split('+');
			for (var n = 0; n < t.length; n++) {
				if (t[n] && layout.namedStyles[t[n]]) {
					style += layout.namedStyles[t[n]]; 
				}
			}
		}
	}
	return style;
}

/// Find a layout object given its (qualified) key value and optional level.
ClientMethod getItemByKey(key, level) [ Language = javascript ]
{
	var instance = null;
	level = zenGet(level,this.currLevel);
	if (this._keyIndex && this._keyIndex[level] && this._keyIndex[level][key]) {
		instance = this._keyIndex[level][key];
	}
	return instance;
}

/// Return the (internal) value of a the control with the given key.
ClientMethod getControlValue(key, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	var value = '';
	if (instance && instance.$getValue) {
		value = instance.$getValue();
	}
	return value;
}

/// Set the value of a the item with the given key.<br/>
ClientMethod setItemValue(key, value, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	this.setControlValue(key,value,level);
}

/// Hide or show the item with the given key.<br/>
ClientMethod hideItem(key, hide, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	if (instance && instance.$hide) {
		instance.$hide(hide);
	}
}

/// Disable or enable the item with the given key.<br/>
ClientMethod disableItem(key, disable, level) [ Internal, Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	if (instance && instance.$disable) {
		instance.$disable(disable);
	}
}

/// Set the value of a the control with the given key.<br/>
/// Does not fire a change event.
ClientMethod setControlValue(key, value, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	if (instance && instance.$setValue) {
		instance.$setValue(value,false);
		if (instance.$applyChangeToInstance) {
			instance.$applyChangeToInstance();
			if (instance.apply) {
				var data = this.getSourceData();
				this.applyValueToPath(data,instance.$path,instance.value);
			}
		}
	}
}

/// Set the hint text for the given control.
ClientMethod setControlHint(key, hint, level) [ Internal, Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	if (instance && instance.$setHint) {
		instance.$setHint(zenGet(hint));
	}
}

/// Set the error text for the given control.
/// By default, will also focus on the control.
ClientMethod setControlError(key, error, level, focus) [ Internal, Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	error = zenGet(error);
	focus = (typeof focus == 'undefined' ? (error !== '') : !!focus);
	var instance = this.getItemByKey(key,level);
	if (instance && instance.$setError) {
		instance.$setError(zenGet(error));
	}
	if (focus) {
		this.focusElement(key,level);
	}
}

/// Helper method to focus on a specified element. If the element
/// has a control, we will focus on that, otherwise we will focus on the main div.
ClientMethod focusElement(key, level) [ Internal, Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	if (instance && instance.$findElement) {
		var control = instance.$findElement('control');
		if (control) {
			control.focus();
		}
		else {
			var div = instance.$findElement();
			if (div) {
				div.focus();
			}
		}
	}
}

/// Given a key value and optional level, find the wrapping div
/// element for a layout object (if applicable) or return null;
ClientMethod getItemDivByKey(key, level) [ Internal, Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var instance = this.getItemByKey(key,level);
	var div = null;
	if (instance) {
		div = instance.$findElement();
	}
	return div;
}

/// Given a key value and optional level, refresh the associated layout object
ClientMethod refreshItem(key, level) [ Language = javascript ]
{
	level = zenGet(level,this.currLevel);
	var item = this.getItemByKey(key,level);
	
	if (item && item.$refresh) {
		item.$refresh();	
	} else if (item.$hasBlock) {
		var div = this.getItemDivByKey(key,level);

		if (div) {
			var layout = this.getLayout();
			var data = this.getSourceData();
			div.innerHTML = this.renderLayout(key,data,layout);
		}
	}
}

/// Given a display instance, build a list of possible option values
/// (such as might be displayed by a dropdown control).
ClientMethod resolveOptionList(instance) [ Internal, Language = javascript ]
{
	var list = null;

	if (instance.codeTable) {
		// options come from a code table
		// add this to the list and let docView resolve this later
		instance.$documentView._codeTables[instance.$index] = instance.codeTable;
	}
	else if (instance.valueList) {
		var list = [];
		// is this an array?
		if (typeof instance.valueList == 'object') {
			if (instance.valueList.length) {
				for (var n = 0; n < instance.valueList.length; n++) {
					var value = zenGet(instance.valueList[n].value);
					var text = zenGet(instance.valueList[n].text,value);
					var disabled = zenGet(instance.valueList[n].disabled,0);
					list.push({value:value,text:text,disabled:disabled});
				}
			}
		}
		else {
			// csv
			var tv = instance.valueList.toString().split(',');
			if (instance.displayList) {
				var td = instance.displayList.toString().split(',');
			}
			else {
				var td = tv;
			}
			var ti = null;
			if (instance.imageList) {
				var ti = instance.imageList.toString().split(',');
			}
			var tdis = null;
			if (instance.disabledList) {
				var tdis = instance.disabledList.toString().split(',');
			}

			for (var n = 0; n < tv.length; n++) {
				if (ti && tdis) {
					list.push({value:tv[n],text:td[n],image:ti[n],disabled:tdis[n]});
				}
				else if (tdis) {
					list.push({value:tv[n],text:td[n],disabled:tdis[n]});
				}
				else if (ti) {
					list.push({value:tv[n],text:td[n],image:ti[n]});
				}
				else {
					list.push({value:tv[n],text:td[n]});
				}
			}
		}
	}
	return list;
}

/// Show/hide a tooltip with the given msg.
/// Set msg to '' to hide the tooltip.
ClientMethod showTooltip(msg, ctrl) [ Internal, Language = javascript ]
{
	if (this._tooltip) {
	    document.body.removeChild(this._tooltip);
	    this._tooltip = null;
	}
	if (msg) {

		var x = 100;
		var y = 100;

		var tooltip = document.createElement('div');
		tooltip.className = 'dvTooltip';
		tooltip.innerHTML = msg;
	    document.body.appendChild(tooltip);

		if (ctrl) {
			x = zenGetLeft(ctrl) - (tooltip.offsetWidth + 20);
			y = zenGetTop(ctrl);
		}
		tooltip.style.left = x + 'px';
		tooltip.style.top = y + 'px';

	    this._tooltip = tooltip;
	}
}

/// Fetch the options for the given code table.<br/>
/// <var>allCodes</var> is csv-list of all code tables referenced in the current document.
/// It is passed along with the first call to this function to allow for pre-fetching.
ClientMethod fetchCodeTable(code, allCodes) [ Internal, Language = javascript ]
{
	var codes = [];
	/*
		{$code:'usstates',value:'MA',text:'Massachusetts'},
		{$code:'usstates',value:'WA',text:'Washington'},
		{$code:'usstates',value:'WY',text:'Wyoming'},
	*/

	if (this.onfetchcodetable!='') {
		codes = zenInvokeCallbackMethod(this.onfetchcodetable,this,'onfetchcodetable','code',code,'allCodes',allCodes);
	}
	return codes;
}

/// Fetch data to drive a set of choices for a "lookup" control.
/// <var>key</var> is the key of the control requesting the data.
/// This is different than fetchCodeTable in that it may return arbitrary
/// data instead of a code table.
ClientMethod fetchLookupData(key, value) [ Internal, Language = javascript ]
{
	var data = null;
	/*{ children:[
		{value:'MA',text:'Massachusetts'},
		{text:'Washington'},
		{value:'WY',text:'Wyoming'},
	  ]}
	*/

	if (this.onfetchlookupdata!='') {
		data = zenInvokeCallbackMethod(this.onfetchlookupdata,this,'onfetchlookupdata','key',key,'value',value);
	}
	return data;
}

/// Make the given control (layout instance) the target of actions (such as selections
/// from a lookup list).
ClientMethod pushCurrentControl(instance) [ Internal, Language = javascript ]
{
	if (!this._controlStack) {
		this._controlStack = [];
	}
	this._controlStack.push(instance);
}

/// Remove the current control from the control stack.
ClientMethod popCurrentControl() [ Internal, Language = javascript ]
{
	if (this._controlStack) {
		this._controlStack.pop();
	}
}

/// Get the current control from the control stack.
ClientMethod getCurrentControl() [ Internal, Language = javascript ]
{
	var instance = null;
	if (this._controlStack && this._controlStack.length) {
		instance = this._controlStack[this._controlStack.length-1];
	}
	return instance;
}

/// Convert a spec string into a spec object.
ClientMethod evalSpec(spec) [ Internal, Language = javascript ]
{
	var specObject = null;
	if (spec == '') {
		specObject = {};
	}
	else if (typeof spec == 'object') {
		specObject = spec;
	}
	else {
		// evaluate json
		try {
			eval('specObject = ' + spec);
		}
		catch(ex) {
			specObject = ex.message;
		}
	}
	return specObject;
}

/// Get text to display (for book cover).
/// Resolve any $vars using the context array if present.
ClientMethod getText(text, context) [ Internal, Language = javascript ]
{
	text = zenGet(text);
	if (text==='') {
		text = '&nbsp;';
	}
	else if (context && (context[text]||context[text]==='')) {
		text = zenEscapeXML(context[text]);
	}
	else {
		text = zenEscapeXML(text);
	}
	return text;
}

/// Display a modal popup for a control.
ClientMethod showPopup(ctrl, key, type, content) [ Internal, Language = javascript ]
{
	var value = key ? this.getControlValue(key) : '';

	// find position of control
	var left = zenGetLeft(ctrl) - zenGetLeftScroll(ctrl);
	// adjust for window scroll bars
	left += zenGetPageScrollLeft(this.window);

	// find position of control element
	var iHgt = ctrl.offsetHeight;
	var wScrollTop = zenGetPageScrollTop();
	var top;
	var obj = zenGetPageOffsets(ctrl);

	var dHgt = 200; //have to use default height of popup, as it hasn't been rendered so far
	var hgt = zenGetWindowHeight();
	var uSpace = obj.top - wScrollTop;	
	var dSpace = hgt-uSpace-iHgt-2;

	if (dHgt>dSpace) { // dropdown won't fit as is
		if (dSpace>uSpace) {
			top = obj.top+iHgt;
		}
		else {
			top = obj.top-dHgt;
		}
	}		
	else {  // Dropdown is fine where it is but need to be in page coordinates
		top = obj.top+iHgt;
	}

	switch (type) {
	case '$date':
		var group = zenPage.createComponent('modalGroup');
		group.setProperty('onaction','zenPage.getComponent('+this.index+').applyPopupValue(\''+key+'\',group);');

		// additional parameters for calendar
		// !!!
		var item = this.getItemByKey(key);
		var calParms = (item && item.calParms) ? item.calParms : {};
		/*
		if ('' != this.minDate) {
			var minD = zenParseDate(this.minDate);
			if (-1 != minD) {
				var year = parseInt(minD.substr(0,4),10);
				calParms['minDate'] = this.minDate;
				calParms['startYear'] = year;
			}
		}
		if ('' != this.maxDate) {
			var maxD = zenParseDate(this.maxDate);
			if (-1 != maxD) {
				var year = parseInt(maxD.substr(0,4),10);
				calParms['maxDate'] = this.maxDate;
				calParms['endYear'] = year;
			}
		}

		// provide canonical value for calendar
		if ('' != value) {
			value = this.unformatValue(value);
			value = (-1 == value) ? '' : value;
		}
		*/

		if ('' == value) {
			// missing value, show current month
			var now = new Date();
			calParms['year'] = now.getFullYear();
			calParms['month'] = now.getMonth() + 1;
		}

		//calParms['dayList'] = this.dayList;
		//calParms['monthList'] = this.monthList;
		//calParms['firstDayOfWeek'] = this.firstDayOfWeek;

		//if (this.showTime) {
		//	calParms['timeCaption'] = this.timeCaption;
		//	calParms['showTime'] = this.showTime;
		//}

		// show the calendar
		group.show('Calendar','calendar',value,top,left,null,null,calParms);
		break;
	case '$time':
		var group = this._timeGroup;
		if (!group) {
			group = zenPage.createComponent('modalGroup');
		}
		this._timeGroup = group;

		// callback to get contents of the popup
		this._allMinutes = false;
		this._currHour = '';
		this._currMinute = '';
		if (value!=='') {
			var t = value.toString().split(':');
			var h = parseInt(t[0],10);
			this._currHour = isNaN(h) ? '' : h;
			var m = parseInt(t[1],10);
			this._currMinute = isNaN(m) ? '' : m;
			if (this._currMinute && this._currMinute%5!=0) {
				this._allMinutes = true;
			}
		}
		var func = new Function('group','return zenPage.getComponent('+this.index+').getPopupContent(group,\''+key+'\');');
		group.show('Time','callback',func,top,left);
		break;
	case '$custom':
		// show user content
		// do not document this for now!
		var group = this._contentGroup;
		if (!group) {
			group = zenPage.createComponent('modalGroup');
		}
		this._contentGroup = group;
		this._contentGroupContent = zenGet(content);

		var func = new Function('group','return {style:\'width:auto;background:#F8F8F8;\',content:zenPage.getComponent('+this.index+')._contentGroupContent};');
		group.show('Content','callback',func,top,left);
		break;	
		
	default:
		alert('Unsupport popup type ' + type)
		break;
	}
}

/// Apply the value from the popup to its control.
ClientMethod applyPopupValue(key, group) [ Internal, Language = javascript ]
{
	var value = '';
	var instance = this.getItemByKey(key,this.currLevel);
	switch(instance.controlType) {
	case '$date':
		value = group.getValue();
		// !!! format
		break;
	case '$time':
		zenPage.endModal();
		var post = '';
		value = zenGet(this._currHour);
		if (value !== '') {
			/*
			if (value<12) {
				value = value==0?12:value;
				post = 'am';
			}
			else {
				value = value>12?value-12:value;
				post = 'pm';
			}
			*/
			var m = zenGet(this._currMinute);
			m = (m=='')?'00':(m<10)?'0'+m:m;
			value = value + ':' + m;
		}
		value += post;
		break;
	}

	this.setControlValue(key,value);

	// fire onchange
	this.eventHandler(instance.$index,null,'change');
}

/// Return the content for the popup/dropdown.
ClientMethod getPopupContent(group, key) [ Internal, Language = javascript ]
{
	var html = [];

	// time selector
	html.push('<div class="dvTimePopup">');

	html.push('<div id="'+this.makeId('timeTable')+'">');
	html.push(this.getTimeTableHTML());
	html.push('</div>');

	// buttons
	html.push('<table summary="list of buttons" border="0" cellspacing="0" cellpadding="0" style="width:100%;"><tr>');
	html.push('<td style="width:70%;"><a style="text-decoration:none;color:#404040;font-size:12px;" href="#" onclick="zenPage.getComponent('+this.index+').resetTime();return false;" alt="Reset">Reset</a></td>');
	html.push('<td style="text-align:center;"><input type="image" class="dvTimePopupIcon" src="deepsee/ds2_clock_44.png" onclick="zenPage.getComponent('+this.index+').toggleMinutes();"/></td>');
	html.push('<td style="text-align:center;"><input type="image" class="dvTimePopupIcon" src="deepsee/ds2_check_44.png" onclick="zenPage.getComponent('+this.index+').applyPopupValue(\''+key+'\');" alt="Select"/></td>');
	html.push('<td style="text-align:center;"><input type="image" class="dvTimePopupIcon" src="deepsee/ds2_x_44.png" onclick="zenPage.endModal();" alt="Close"/></td>');
	html.push('</tr></table>');

	html.push('</div>');

	var info = {
		style:'width:auto;background:#F0F0F0;',
		content: html.join('')
	};
	return info;
}

/// Return the content popup time table.
ClientMethod getTimeTableHTML() [ Internal, Language = javascript ]
{
	var html = [];

	var currHour = zenGet(this._currHour);
	var currMinute = zenGet(this._currMinute);
	var allMinutes = zenGet(this._allMinutes,false);

	// hours
	html.push('<table summary="list of hours" class="dvTimePopupHours" border="0" cellspacing="0" cellpadding="0">');
	for (var r=0;r<2;r++) {
		var post = r==0 ? 'am' : 'pm';
		html.push('<tr>');
		for (var n=0;n<12;n++) {
			var h = (r*12)+n;
			var cls = (h===currHour) ? 'dvTimeSelected' : 'dvTime';
			html.push('<td class="'+cls+'" onclick="zenPage.getComponent('+this.index+').hourClick('+h+');" tabindex="0">' + h + '</td>');
		}
		html.push('</tr>');
	}
	html.push('</table>');

	// minutes
	html.push('<table summary="list of minutes" class="dvTimePopupMinutes" border="0" cellspacing="0" cellpadding="0">');
	if (allMinutes) {
		for (var r=0;r<6;r++) {
			html.push('<tr>');
			for (var n=0;n<10;n++) {
				var m = (r*10) + n;
				var dm = ':' + ((m<10) ? '0'+m : m);
				var cls = (m===currMinute) ? 'dvTimeSelected' : 'dvTime';
				html.push('<td class="'+cls+'" onclick="zenPage.getComponent('+this.index+').minuteClick('+m+');" tabindex="0">' + dm + '</td>');
			}
			html.push('</tr>');
		}
	}
	else {
		for (var r=0;r<2;r++) {
			html.push('<tr>');
			for (var n=0;n<6;n++) {
				var m = (r*30) + (n*5);
				var dm = ':' + ((m<10) ? '0'+m : m);
				var cls = (m===currMinute) ? 'dvTimeSelected' : 'dvTime';
				html.push('<td class="'+cls+'" onclick="zenPage.getComponent('+this.index+').minuteClick('+m+');" tabindex="0">' + dm + '</td>');
			}
			html.push('</tr>');
		}
	}
	html.push('</table>');

	return html.join('');
}

/// Click handler for hour in time popup.
ClientMethod hourClick(hour) [ Internal, Language = javascript ]
{
	this._currHour = hour;
	var div = this.findElement('timeTable');
	div.innerHTML = this.getTimeTableHTML();
}

/// Click handler for minute in time popup.
ClientMethod minuteClick(minute) [ Internal, Language = javascript ]
{
	if (this._currHour=='') {
		this._currHour = 0;
	}
	this._currMinute = minute;
	var div = this.findElement('timeTable');
	div.innerHTML = this.getTimeTableHTML();
}

/// Clear time in the time popup.
ClientMethod resetTime() [ Internal, Language = javascript ]
{
	this._currHour = '';
	this._currMinute = '';
	var div = this.findElement('timeTable');
	div.innerHTML = this.getTimeTableHTML();
}

/// Toggle minutes display in the time popup.
ClientMethod toggleMinutes() [ Internal, Language = javascript ]
{
	this._allMinutes = !this._allMinutes;
	this._currMinute = '';
	var div = this.findElement('timeTable');
	div.innerHTML = this.getTimeTableHTML();
}

/// User press on header back arrow.
ClientMethod backArrowHandler(evt) [ Internal, Language = javascript ]
{
	evt = evt ? evt : window.event;

	this.popDocument(true);
	// alert via onselect
	this.onselect('$cancel','');
}

/// returns true if the browser supports canvas, false otherwise
ClientMethod browserSupportsCanvas() As %Boolean [ Language = javascript ]
{
	return !!document.createElement('canvas').getContext;
}

/// user selected something within this component
ClientMethod onselect(key, value, event) [ Internal, Language = javascript ]
{
	var event = event || null;
	
	if (zenPage.templateDispatchMode && zenPage.templateDispatchBaseNamespace != '') {
		var newArea = 'events-'+key.split(':')[0];
		if (zenPage.currArea !== newArea) {
			zenPage.currArea = newArea;
			zenPage.loadTemplateNS(zenPage.templateDispatchBaseNamespace+'/events',key.split(':')[0],newArea);
		}
	}
	
	var template = zenPage.getTemplate();
	return (template && template.onselect) ? template.onselect(key,value,this.id,event) : null;
}

/// a layout object within this component changed its value
ClientMethod onchange(key, value, final, event) [ Internal, Language = javascript ]
{
	var event = event || null;
	
	if (zenPage.templateDispatchMode && zenPage.templateDispatchBaseNamespace != '') {
		var newArea = 'events-'+key.split(':')[0];
		if (zenPage.currArea !== newArea) {
			zenPage.currArea = newArea;
			zenPage.loadTemplateNS(zenPage.templateDispatchBaseNamespace+'/events',key.split(':')[0],newArea);
		}
	}
	
	var template = zenPage.getTemplate();
	return (template && template.onchange) ? template.onchange(key,value,final,this.id,event) : null;
}

/// a generic event occured within this component
ClientMethod onevent(eventType, key, value, event) [ Internal, Language = javascript ]
{
	var event = event || null;
	
	if (zenPage.templateDispatchMode && zenPage.templateDispatchBaseNamespace != '') {
		var newArea = 'events-'+key.split(':')[0];
		if (zenPage.currArea !== newArea) {
			zenPage.currArea = newArea;
			zenPage.loadTemplateNS(zenPage.templateDispatchBaseNamespace+'/events',key.split(':')[0],newArea);
		}
	}
	
	var template = zenPage.getTemplate();
	return (template && template.onevent) ? template.onevent(eventType,key,value,this.id,event) : null;
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	if (!window.console) window.console = {};
	if (!window.console.log) window.console.log = function () {};
}

}
