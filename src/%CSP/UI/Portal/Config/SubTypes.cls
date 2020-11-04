/// Zen page for System Management Portal - Configure Device SubTypes
Class %CSP.UI.Portal.Config.SubTypes Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav, %CSP.UI.Portal.Config.AdvancedList) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Config.SubTypes.zen";

Parameter HELPADDRESS = "Home,Configuration,Device Settings,SubTypes";

Parameter EMSSERVICE = "Config";

/// Displayed name of this page.
Parameter PAGENAME = "Device Subtypes";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property EditPage As %String [ InitialExpression = {..Link("%25CSP.UI.Portal.Config.SubType.zen")} ];

Property Subject As %String [ InitialExpression = "SubTypes" ];

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<vgroup id="fld0">
<tableNavBar showFilter="false" showMaxRows="true" showPageSize="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table"
pageSize="0"
maxRows="1000"
fixedHeaders="false"
showValueInTooltip="true"
showZebra="true"
valueColumn="Name"
useSnapshot="true"
ondblclick="zenPage.editItem('',false,false)"
queryClass="Config.DeviceSubTypes"
queryName="List"
dataSource="columns"
>
<parameter value="*"/>
<parameter value=""/>
<parameter value="0"/>
<parameter value="0"/>
<column colName="Name" header="Name"/>
<column linkCaption="Edit" id="LinkEdit" link="javascript:zenPage.editItem('#(%query.Name)#',false,false);" />
<column linkCaption="Delete" id="LinkDelete" link="javascript:zenPage.deleteItem('#(%query.Name)#');" linkConfirm="Are you sure you want to delete definition '%1'?" hidden="#(%page.IsEMSReadOnly)#"/>
 </tablePane>
 </vgroup>
 </pane>
}

/// Subclass can override.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC	
	Do ..%GetNavTableState()
	Set ..lblTitle = $$$Text("The following is a list of sub types defined for this system:")

	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$TextHTML("Device Subtypes")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set caption = $$$TextHTML("Create New Device Subtype")
	Set pCommands(1) = $LB("btnNew",caption,caption,"zenPage.doNew(false);")

	Quit $$$OK
}

}