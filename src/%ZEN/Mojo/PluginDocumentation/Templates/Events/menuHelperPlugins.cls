Class %ZEN.Mojo.PluginDocumentation.Templates.Events.menuHelperPlugins Extends abstractTemplate
{

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	var className = zen(docViewId).getItemByKey('helperplugins-menu-store').$getStore().query({id:value})[0].className;
	zen(docViewId).pushDocument('pluginDetail',{id:className + ' ('+ value + ')',className:className},'pluginDetail',{id:value,className:className});
}

}
