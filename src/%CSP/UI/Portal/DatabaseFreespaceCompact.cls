/// Zen page for System Management Portal - Show Databases Freespace
Class %CSP.UI.Portal.DatabaseFreespaceCompact Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Cleanup";

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.DatabaseFreespaceCompact.zen";

Parameter HELPADDRESS = "Home,Databases,Freespace,Compact";

Parameter PARENTPAGE = "/csp/sys/op/%CSP.UI.Portal.DatabaseFreespace.zen";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

/// ID for edit. DBName for this page.
Property PID As %String(ZENURL = "DBName");

/// DBDirectory passed in.
Property Directory As %String(ZENURL = "Directory");

/// Total available freespace.
Property FreeSpace As %String;

/// Amount free at end
Property EndFree As %Integer;

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<html id="idHTMLResult" OnDrawContent="DrawResult" hidden="true"/>
<form>
<group id="form" cellStyle="padding:2px;" enclosingClass="EditForm" enclosingStyle="margin-left:3px;padding-top:2px;font-family: Verdana, Arial, Helvetica, sans-serif;" labelPosition="left" hidden="false">
 <label id="DatabaseName" label="Database Name:" value="#(%page.PID)#" enclosingClass="normal"/>
 <label id="Directory" label="Directory:" value="#(%page.Directory)#" enclosingClass="normal"/>
 <label id="Size" label="Current size:" enclosingClass="normal"/>
 <label id="FreeSpace" label="Total available freespace:" enclosingClass="normal"/>
 <label id="EndFree" label="Freespace at end of file:" enclosingClass="normal"/>
 <text id="txtTarget" label="" size="10" hintClass="helpText"/> 
 <label id="Warning" controlClass="redText"/> 
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

	Set %page.lblTitle = $$$Text("To compact freespace in the selected database, fill out the following form and press [ OK ]:")
	
	Set msg = ..GetFreeSpace(%page.Directory,.FreeSpace,.EndFree,.CurrSize)
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
		Set %page.FreeSpace = FreeSpace
		Set %page.EndFree = EndFree
		Set ..%GetComponentById("Size").value = CurrSize_" MB"
		Set txtTarget = ..%GetComponentById("txtTarget")
		Set msg = ""
		If ..FreeSpace = 0 {
			Set msg = $$$TextHTML("No freespace to compact")
		} ElseIf  ..FreeSpace '> ..EndFree {
			Set msg = $$$TextHTML("All freespace is already compacted")
		}
		If msg '= "" {
			Set txtTarget.hidden = 1
			Set ..%GetComponentById("Warning").value = msg
			Set ..%GetComponentById("btnOK").disabled = 1
			Set ..%GetComponentById("btnOK").controlClass = "commandButtonDisabled"
		} Else {
			Set txtTarget.label = $$$Text("Target freespace (in MB) at end of file:")
			Set txtTarget.hint = $$$FormatText($$$Text("Specify a number between %1 and %2."),%page.EndFree,%page.FreeSpace)
		}
		Set ..%GetComponentById("FreeSpace").value = %page.FreeSpace_" MB"
		Set ..%GetComponentById("EndFree").value = %page.EndFree_" MB"
	}

	Quit $$$OK
}

/// Return available FreeSpace
ClassMethod GetFreeSpace(Directory As %String, Output FreeSpace As %Integer, Output EndFree As %Integer, Output CurrSize As %Integer) As %String
{
	Try {
		Set tObj = ##Class(SYS.Database).%OpenId(Directory,,.tSC)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		If (tObj.Mounted '= 1) {
			Set msg = "Not Mounted"
		} ElseIf $$$NotAllowDBCompTrunDefrag(tObj) {
			Set msg = "ReadOnly"
		} Else {
			Set CurrSize = tObj.Size
			Set tSC = tObj.GetFreeSpace(Directory,.FreeSpace)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			Set tSC = ##class(SYS.Database).FileCompact(tObj.Directory,0,.EndFree)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			#; YSD2365 - return converted integer only
			Set FreeSpace = FreeSpace\1
			Set msg = $$$OK
		}
	} Catch Error {
		Set msg = $$$Text("Error occurred in GetFreeSpace:")_" "_..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
	}
	Quit msg
}

/// User clicked "OK" to cleanup. Call server method to job off in the background.
ClientMethod doFinish(isFinish) [ Language = javascript ]
{
	var DatabaseName = this.PID;
	var Directory = this.Directory;
	var FreeSpace = this.FreeSpace;
	var EndFree = this.EndFree;
	var Target = zenPage.getComponentById("txtTarget").getValue();
	if (!this.validate(Target,EndFree,FreeSpace)) return;
	var job = this.StartCompact(DatabaseName,Directory,Target);
	var html = zenPage.getComponentById('idHTMLResult');
	html.setHidden(false);
	html.seed = job;
	html.refreshContents();
	zen("btnOK").setProperty("disabled",true);
	zen("btnOK").setProperty("controlClass","commandButtonDisabled");
	zen("btnCancel").setProperty("disabled",true);
	zen("btnCancel").setProperty("controlClass","commandButtonDisabled");
	zen("btnDone").setProperty("disabled",false);
	zen("btnDone").setProperty("controlClass","commandButton");
}

/// Make sure that the Target size is smaller than that of the current available freespace
ClientMethod validate(target, sizemin, sizemax) As %Boolean [ Language = javascript ]
{
	var ok = true;
	if (target == "") ok = false;
	else if (!(target.match(/\d/))) ok = false;
	else if (parseInt(target) > parseInt(sizemax)) ok = false;
	else if (parseInt(target) < parseInt(sizemin)) ok = false;
	else if (parseInt(target) < 0) ok = false;
	if (!ok) {
		alert($$$Text('Please enter a number that is within the range of the total available freespace.'));
		zen("txtTarget").focus();
	}
	return ok
}

/// Start background job to compact a selected directory
ClassMethod StartCompact(DBName, Directory, Target) As %String [ ZenMethod ]
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		Kill tParms
		Set tParms("NAMESPACE") = "%SYS"
		Set tParms("DBName") = DBName
		Set tParms("Directory") = Directory
		Set tParms("Target") = Target
 		Set tSC = ##class(%CSP.UI.System.BackgroundTask).RunTask("CompactDBSpace",tParms("NAMESPACE"),.tParms,,.tJob)
	} While (0)
Done
	If $$$ISERR(tSC) Quit $System.Status.GetErrorText(tSC)
	Quit +$G(tJob)
Trap
	Set $ZT=""	
	Quit "Error occurred in StartCompact: "_$ZE
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
		Write !,$$$TextHTML("Compact freespace in database.")
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
	If ..PID'="" Quit $$$FormatText($$$Text("Compact: %1"),$ZCVT(..PID,"O","HTML"))
	Quit ..LocatorHeader
}

Method %OnGetPageName() As %String
{
	 Quit $$$Text("Compact")
}

Method DrawAbortError(seed As %String) As %Status
{
	If seed = 1 {
		Set text = $$$TextHTML("Unable to continue. Database is not mounted or is read-only.")
	} Else {
		Set text = $ZCVT(seed,"O","HTML")
	}
	&html<<div class="ErrorBox">#(text)#</div>>
	Quit $$$OK
}

}
