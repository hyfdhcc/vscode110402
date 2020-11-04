/// System Management Portal - Security Management - System Audit Events 
Class %CSP.UI.Portal.Audit.SystemEvents Extends %CSP.UI.Portal.Audit.EventsTemplate [ System = 4 ]
{

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.Audit.SystemEvents.zen";

Parameter HELPADDRESS = "System Administration,Security,Auditing,Configure System Events";

/// Displayed name of this page.
Parameter PAGENAME = "System Audit Events";

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px;padding-top:10px;">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<group>
<tableNavBar showFilter="true" showPageSize="true" tablePaneId="table" showMaxRows="true" maxRows="1000" 
onfilterChange="zenPage.filterChanged(value);"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
 title="To filter: enter one or more characters of any column followed by [Tab]."/>
<tablePane id="table" cellSpacing="2"
queryClass="Security.Events"
queryName="ListAll"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="false"
valueColumn="EventName"
useSnapshot="true"
>
<parameter value="*"/>
<parameter value="*"/>
<parameter value="#(%page.Filter)#"/>
<parameter value="1"/>
<parameter value="1"/>
<column colName="EventName" header="Event Name"/>
<column colName="Enabled"/>
<column colName="Total"/>
<column colName="Written"/>
<column colName="EnabledBoolean" hidden="true"/>
<column id="Reset" link="javascript:zenPage.doReset('#(%query.EventName)#');" linkCaption="Reset" style="text-align:center;" linkConfirm="Are you sure you want to reset the counter to zero?"/>
<column id="ChangeStatus" link="javascript:zenPage.doChangeStatus('#(%query.EventName)#');" linkCaption="Change Status" style="text-align:center;" hidden="#(%page.IsEMSReadOnly)#"/>
<condition colName="EnabledBoolean" predicate="EQ" value="1" rowStyle="background-color:#C5E5C9;"/> 
 </tablePane>
 </group>
</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	Set ..lblTitle = $$$Text("The following is a list of system audit events:")
	
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("System Audit Events ")
}

}
