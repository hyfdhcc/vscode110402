/// System Management Portal - System Operations - Locks 
Class %CSP.UI.Portal.Locks Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.Locks.zen";

Parameter HELPADDRESS = "Home,Locks";

/// Displayed name of this page.
Parameter PAGENAME = "Locks";

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

XData Style
{
<style type="text/css">
/* additonal style for table pane */
table.tpTable th {
	border-right: 1px solid #F1F0E7;
	border-bottom: 1px solid #F1F0E7;
}

table.tpTable td {
	border-right: 1px solid #F1F0E7;
	border-top: 1px solid #F1F0E7;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px;padding-top:10px;">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<group>
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<checkbox id="DisplayRoutine" caption="Display Owner's Routine Information" onchange="zenPage.displayroutine(zenThis.getValue())"/>
<tableNavBar showFilter="true" showPageSize="true" tablePaneId="table" showMaxRows="true"
onfilterChange="zenPage.filterChanged(value);"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
title="Enter an string to filter the list"
/>
<tablePane id="table" 
queryClass="%SYS.LockQuery"
queryName="WebListFilter"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="true"
valueColumn="DeleteID"
useSnapshot="true"
>
<column colName="Removable" hidden="true"/>
<column colName="DeleteID" hidden="true"/>
<column colName="CanBeExamined" hidden="true"/>
<column colName="RemoteOwner" hidden="true"/>
<column colName="PidInternal" hidden="true"/>

<column colName="Pid" header="Owner" link="%25CSP.UI.Portal.ProcessDetails.zen?PID=#(%query.Pid)#&amp;DISPLAYID=#(%query.Pid)#&amp;$ID1=#(%query.Pid)#"/>
<column colName="ModeCount" header="ModeCount"/>
<column colName="Reference" header="Reference"/>
<column colName="Directory" header="Directory"/>
<column colName="System" header="System"/>
<column colName="RoutineInfo" header="Routine"/>

<column linkCaption="Remove" link="javascript:zenPage.doRemove('#(%query.DeleteID)#',0,'#(%query.RemoteOwner)#');" linkConfirm="Are you sure you want to delete this lock?"/>
<column linkCaption="Remove_all_locks_for_process" link="javascript:zenPage.doRemove('#(%query.PidInternal)#',1,'#(%query.RemoteOwner)#');" linkConfirm="Are you sure you want to delete all locks for process '%1'?"/>
<column linkCaption="Remove_all_locks_from_remote_client" link="javascript:zenPage.doRemoveRemote('#(%query.PidInternal)#',1,'#(%query.RemoteOwner)#');" linkConfirm="Are you sure you want to delete all locks from remote client '%1'?"/>

<condition colName="CanBeExamined" predicate="EQ" value="0" targetCol="Pid" cellStyle="disabled"/> 
<condition colName="RemoteOwner" predicate="EQ" value="0" targetCol="Remove_all_locks_from_remote_client" cellStyle="disabled"/> 
<condition colName="RemoteOwner" predicate="EQ" value="1" targetCol="Remove_all_locks_for_process" cellStyle="disabled"/> 

<parameter value="#(%page.Filter)#"/>
<parameter value="1"/>

 </tablePane>
 </group>
</pane>
}

/// User entered something in to the filter. Re-load the table with filter value.
ClientMethod filterChanged(value) [ Language = javascript ]
{
	var table = zen("table");
	if (value=="*") value="";
	table.parameters[0].value = value;
	table.executeQuery();
	table.currColumn = this.CurrentColumn;
	table.sortOrder = this.CurrentSort;
	this.updateTime();
	this.Filter = value;
	this.UpdateTableNavState(value,this.TablePageSize,this.TableMaxRows);
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set ..%GetComponentById("Text1").value = $$$Text("The following is a list of the current Locks:")
	i ..Filter="*" s ..Filter=""
	Quit $$$OK
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_$S(NAMESPACE="":"",1:"?$NAMESPACE="_..EscapeURL(NAMESPACE)))
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()
	
	Quit $$$OK
}

/// Add to the contents of the tool ribbon.
Method OnDrawRibbon() As %Status
{
	Do ..DrawAutoRefresh(..%OnGetPageName())
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Manage Locks")
}

/// To remove all remote add "C" as preface.
ClientMethod doRemoveRemote(DeleteID, RemoveAll, RemoteOwner) [ Language = javascript ]
{
	this.doRemove("C"+DeleteID, RemoveAll, RemoteOwner);
}

/// Remove a lock. If "RemoveAll" is 1 then all locks for that process is removed.
/// If RemoveAll is 0, then DeleteID is the lock reference.
/// If RemoveAll is 1, then DeleteID is the Pid/Client or Owner.
ClientMethod doRemove(DeleteID, RemoveAll, RemoteOwner) [ Language = javascript ]
{
	if (DeleteID == "") {
		return;
	} else {
		// if it is a local process, then check if the lock is in open transaction and confirm with user if it is.
		if (RemoteOwner == false) {
			var inTrans = this.InTransaction(DeleteID);
			if (inTrans != 1) {
				if (!confirm(inTrans)) return;
			}
		}
		var result = this.RemoveLocks(DeleteID, RemoveAll);
		if (result.ok == 1) {
			if (result.Message != "") {
				this.showMsg(result.Message,0);
			} else {
				var table = zen("table");
				table.executeQuery();
			}
		} else {
			this.showMsg(result.ErrorMessage,1);
		}
	}
}

/// Update table.
ClientMethod updateView() [ Language = javascript ]
{
	window.location.reload();
}

/// Toggle for displaying routine information.
ClientMethod displayroutine(value) [ Language = javascript ]
{
	var table = zen("table");
	table.parameters[1].value = !value;
	table.executeQuery();
}

/// This method is called to check whether a local lock is currently in an option transaction. 
ClassMethod InTransaction(DeleteID) As %String [ ZenMethod ]
{
	If $zu(61,19,DeleteID) = 0 Quit 1
	Quit $$$TextJS("This lock is currently in an open transaction. Are you sure you want to delete it?")
}

/// Remove locks from server. If RemoveAllLocksForProcess, then DeleteID is PID. OW DeleteID contains three pieces lock reference delimited by comma.
ClassMethod RemoveLocks(DeleteID, RemoveAllLocksForProcess) As %ZEN.proxyObject [ ZenMethod ]
{
	Set $ZT="Error"
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 1
	Set tProxy.Message = ""
	Set LocksNotRemoved = ""
	If RemoveAllLocksForProcess {
		Set sta = ##class(SYS.Lock).DeleteAllLocks(DeleteID)
		If $$$ISERR(sta) Set tProxy.ok = 0,tProxy.ErrorMessage = $$$FormatText($$$Text("Unable to remove locks for process %1."),DeleteID)
	} Else {
		Set sta = ##class(SYS.Lock).DeleteOneLock(DeleteID,"",1)
		If $$$ISERR(sta) Set tProxy.ok = 0,tProxy.ErrorMessage = $$$FormatText($$$Text("Unable to remove lock. Lock reference: %1, error=%2."),DeleteID,$SYSTEM.Status.GetErrorText(sta))		
	}
	Quit tProxy
Error	///
	Set $ZT="" Do BACK^%ETN
	Set tProxy.ok = 0
	Set tProxy.ErrorMessage = $ZCVT($ZE,"O","HTML")
	Quit tProxy
}

}
