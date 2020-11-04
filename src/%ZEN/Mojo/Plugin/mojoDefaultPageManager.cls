/// This is the default mojo page manager. Currently it does implement no specific logic
/// to change the behavior of the documentView component, though it may in the future.
/// 
/// 1.0.2
/// 	- support an onPageShow callback which gets called, when a transition to another page has started.  
Class %ZEN.Mojo.Plugin.mojoDefaultPageManager Extends %ZEN.Mojo.Plugin.basePageManager
{

/// The unique name of the Plugin. All features of this plugin will be registered using
/// this identifier.
Property pluginName As %String [ InitialExpression = "mojoDefaultPageManager" ];

/// A version string of the base page manager. Major/Minor/Build
Property version As %String(XMLPROJECTION = "NONE") [ InitialExpression = "1.0.2" ];

/// gets called when a page transition to another document has started
Property onPageShow As %ZEN.Datatype.eventHandler;

/// Gets called after the HTML for the current document got rendered and is successfully
/// injected into the DOM. If <PROPERTY>suppressRender</PROPERTY> is set to true for any
/// registered plugin the HTML is generated but not injected!
ClientMethod afterRenderDocument(docView, displayMode, html) [ Language = javascript ]
{
	if (this.onPageShow && (this.onPageShow != '')) {
		zenInvokeCallbackMethod(this.onPageShow,this,'onPageShow','layoutkey',this.$documentView.getLayoutKey(),'documentkey',this.$documentView.getDocumentKey());
	}
}

}
