/// Zen page for System Management Portal - Show Databases Freespace
Class %CSP.UI.Portal.DatabaseFreespaceCleanup Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Cleanup";

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.DatabaseFreespaceCleanup.zen";

Parameter HELPADDRESS = "Home,Databases,Freespace,Truncate";

Parameter PARENTPAGE = "/csp/sys/op/%CSP.UI.Portal.DatabaseFreespace.zen";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

/// ID for edit. DBName for this page.
Property PID As %String(ZENURL = "DBName");

/// DBDirectory passed in.
Property Directory As %String(ZENURL = "Directory");

/// Current size.
Property Size As %String;

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<html id="idHTMLResult" OnDrawContent="DrawResult" hidden="true"/>
<form>
<group id="form" cellStyle="padding:2px;" enclosingClass="EditForm" enclosingStyle="margin-left:3px;padding-top:2px;font-family: Verdana, Arial, Helvetica, sans-serif;" labelPosition="left" hidden="false">
 <label id="DatabaseName" label="Database Name:" value="#(%page.PID)#" enclosingClass="normal"/>
 <label id="Directory" label="Directory:" value="#(%page.Directory)#" enclosingClass="normal"/>
 <label id="Size" label="Size: " value="" enclosingClass="normal"/>
 <text id="txtTarget" label="" size="10" value="0" hint="" hintClass="helpText"/> 
 <html><hr size="1"/></html>
<hgroup cellAlign="right">
<hgroup cellStyle="padding:2px;">
 <button id="btnOK" caption=" OK " controlClass="commandButton" onclick="zenPage.doFinish();"/>
 <button id="btnCancel" caption="Cancel" controlClass="commandButton" onclick="zenPage.doCancel();"/>
 <button id="btnDone" caption="Done" controlClass="commandButtonDisabled" onclick="zenPage.doCancel();" disabled="true"/>
 </hgroup>
 </hgroup>
 </group>
 </form>
  <html id="idError" OnDrawContent="DrawAbortError" hidden="true"/>
  <button id="btnExit" caption="Cancel" onclick="zenPage.doCancel();" hidden="true"/>
</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set %page.lblTitle = $$$Text("To truncate unused space in the selected directory, fill out the following form and press [ OK ]:")

	Set msg = ..GetSize(%page.Directory,.Size)
	If (msg '= 1) {
		Set ErrorComp = ..%GetComponentById("idError")
		If (msg = "Not Mounted") || (msg = "ReadOnly") {
			Set ErrorComp.seed = 1
		} Else {
			Set ErrorComp.seed = msg
		}
		Set ErrorComp.hidden = 0
		Set ..%GetComponentById("form").hidden = 1
		Set ..%GetComponentById("btnExit").hidden = 0
	} Else {
		Set %page.Size = Size
		Set ..%GetComponentById("Size").value = %page.Size_" MB"
		Set txtTarget = ..%GetComponentById("txtTarget")
		Set txtTarget.label = $$$Text("Target file size (MB):")
		Set txtTarget.hint = $$$Text("Specify the target size for the file, or 0 to remove all unused space.")
	}

	Quit $$$OK
}

/// Return current size since the size may have changed since the table was drawn
ClassMethod GetSize(Directory As %String, Output Size As %Integer) As %String
{
	Try {
		Set tObj = ##Class(SYS.Database).%OpenId(Directory,,.tSC)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		If (tObj.Mounted '= 1) {
			Set msg = "Not Mounted"
		} ElseIf $$$NotAllowDBCompTrunDefrag(tObj) {
			Set msg = "ReadOnly"
		} Else {
			Set Size = tObj.Size
			Set msg = $$$OK
		}
	} Catch Error {
		Set msg = $$$Text("Error occurred in GetSize:")_" "_..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
	}
	Quit msg
}

/// User clicked "OK" to cleanup. Call server method to job off in the background.
ClientMethod doFinish(isFinish) [ Language = javascript ]
{
	var DatabaseName = this.PID;
	var Directory = this.Directory;
	var Size = this.Size;
	var Target = zenPage.getComponentById("txtTarget").getValue();
	if (!this.validate(Size,Target)) return;
	var job = this.StartCleanup(DatabaseName,Directory,Target);
	var html = zenPage.getComponentById('idHTMLResult');
	html.setHidden(false);
	//YSD2132 html.setProperty('seed',job);
	html.seed = job;
	html.refreshContents();
	zen("btnOK").setProperty("disabled",true);
	zen("btnOK").setProperty("controlClass","commandButtonDisabled");
	zen("btnCancel").setProperty("disabled",true);
	zen("btnCancel").setProperty("controlClass","commandButtonDisabled");
	zen("btnDone").setProperty("disabled",false);
	zen("btnDone").setProperty("controlClass","commandButton");
}

/// Make sure that the Target size is smaller than that of the current size.
ClientMethod validate(size, target) As %Boolean [ Language = javascript ]
{
	var ok = true;
	if ((target != "") && (target == 0)) {
		return ok;
	} else {
		if (target == "") ok = false;
	    else if (!(target.match(/\d/))) ok = false;
		else if (parseInt(target) >= parseInt(size)) ok = false;
	}
	if (!ok) {
		alert($$$Text('Please enter a number that is less than the current size. To remove all unused space, enter 0.'));
		zenPage.getComponentById("txtTarget").focus();
	}
	return ok
}

/// Start background job to cleanup a selected directory
ClassMethod StartCleanup(DBName, Directory, Target) As %String [ ZenMethod ]
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		Kill tParms
		Set tParms("NAMESPACE") = "%SYS"
		Set tParms("DBName") = DBName
		Set tParms("Directory") = Directory
		Set tParms("Target") = Target
 		Set tSC = ##class(%CSP.UI.System.BackgroundTask).RunTask("CleanDBSpace",tParms("NAMESPACE"),.tParms,,.tJob)
	} While (0)
Done
	If $$$ISERR(tSC) Quit $System.Status.GetErrorText(tSC)
	Quit +$G(tJob)
Trap
	Set $ZT=""	
	Quit "Error occurred in StartCleanup: "_$ZE
}

/// Actually write out result.
/// When the page is first opened, seed is null.
/// When it's called from Prepare, seed = action^the selected locale.
Method DrawResult(seed As %String) As %Status
{
	If seed = "" Quit $$$OK
	Set $ZT = "Trap"
	Do {
		&html<<pre class="brownnote">>
		Write !,$$$TextHTML("Truncate unused space in database.")
		Write !,$$$FormatText($$$Text("Background job, %1, started."),$zconvert(seed,"O","HTML"))
		Set tLink = ..Link("/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen")
		Set msg = $$$TextHTML("Click here to view the background tasks page.")
		&html<<br><a href="#(tLink)#" target="newWin">#(msg)#</a>>
		&html<</pre>>

	} While(0)
Done
	Quit $$$OK
Trap
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Databases")
	Set tURL = $ZCVT("%CSP.UI.Portal.OpDatabases","O","URL")_".zen"_$S(NAMESPACE="":"",1:"?$NAMESPACE="_$ZCVT(NAMESPACE,"O","URL"))
	Set pLink($I(pLink)) = $LB(tPageName,tURL)


	Set tPageName = $$$Text("Freespace")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($classname(),"O","URL")_".zen?DBName="_$ZCVT($G(%request.Data("DBName",1)),"O","URL")_"&Directory="_$ZCVT($G(%request.Data("Directory",1)),"O","URL"))
	Quit $$$OK
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	If ..PID'="" Quit $$$FormatText($$$Text("Truncate: %1"),$ZCVT(..PID,"O","HTML"))
	Quit ..LocatorHeader
}

Method %OnGetPageName() As %String
{
	 Quit $$$Text("Truncate")
}

Method DrawAbortError(seed As %String) As %Status
{
	If seed = 1 {
		Set text = $$$TextHTML("Unable to continue. Database is not mounted or is read-only.")
	} Else {
		Set text = $zconvert(seed,"O","HTML")
	}
	&html<<div class="ErrorBox">#(text)#</div>>
	Quit $$$OK
}

}
