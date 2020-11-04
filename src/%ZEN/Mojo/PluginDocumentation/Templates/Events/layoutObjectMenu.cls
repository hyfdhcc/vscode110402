Class %ZEN.Mojo.PluginDocumentation.Templates.Events.layoutObjectMenu Extends abstractTemplate
{

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	var docView = zen(docViewId);
	var tree = docView.getItemByKey(key);
	var store = tree.$dojoItem.model.store;
	
	var item = store.query({id:value})[0];
	
	if (zenGet(item.openTab,true)) {
		
		var tc = zen('mainView').getItemByKey('tabContainer-1').$dojoItem;
		var tabIsOpen = false;
		
		if (tc.hasChildren()) {
			var openTabs = tc.getChildren();
			
			for (var i = 0; i < openTabs.length; i++) {
				if (openTabs[i].title == value) {
					// open!
					tabIsOpen = true;
					tc.selectChild(openTabs[i],true);
				}
			}
		}
		
		if (!tabIsOpen) {
			var nv = docView.getPluginByName(zenPage._usedDojoDijitPlugin).createDocumentView('listLayoutObject','listLayoutObject','newView_'+value);
			nv.setDocumentKey('listLayoutObject',{id:value});
			nv.setLayoutKey('listLayoutObject',{id:value});
			nv.documentClass = 'embeddedDocument';
			docView.getPluginByName(zenPage._usedDojoDijitPlugin).addTabWithDocumentView(docView,'tabContainer-1',1,value,nv);
		}
	}
}

}
