Include %sqlui

/// <p>This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. 
/// There is no guarantee made about either the behavior or future operation of this class.</p>
/// SQL Statement Details view and freeze plan for Management Portal
Class %CSP.UI.Portal.Dialog.SQLStatementDetails Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.Dialog.SQLStatementDetails.zen";

/// Displayed name of this page.
Parameter PAGENAME = "SQLStatementDetails";

/// If true, then this dialog displays an Apply button.
Parameter APPLYBUTTON As BOOLEAN = 1;

/// Security requirement
Parameter RESOURCE = "%Development";

Property NAMESPACE As %ZEN.Datatype.string(ZENURL = "NAMESPACE");

/// Schema name, may or may not be available.
Property SCHEMA As %ZEN.Datatype.string(ZENURL = "SCHEMA");

Property STMTHASH As %ZEN.Datatype.string(ZENURL = "STMTHASH");

Property FrozenSettingHasChanged As %Boolean [ InitialExpression = 0 ];

/// When editing, this is passed in.
/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title instructions */
div.Description	{
	font-size: 0.9em; 
	padding: 5px;
}
</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />

<pane paneName="dialogBody" id="body" />

<hgroup id="footer" width="100%" cellAlign="right">
<hgroup id="buttonHolder" cellAlign="right">
<button id="btnClose" controlClass="commandButton" caption="Close" onclick="zenPage.dialogCancel();" />
<spacer width="5" />
</hgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:4 6 4 10;" align="center" containerStyle="background: light grey">
<spacer height="2"/>
<label id="idRespond" enclosingClass="note" containerStyle="padding-top:10px;padding-left:4px;" hidden="true"/>
<group id="editGroup" labelPosition="left" cellStyle="padding-bottom:5px;" valign="middle" align="center">
<label align="center" value="Statement Details" />
<fieldSet id="statementError" hidden="true" valign="middle" align="center">
<hgroup id="planGroupErr"  valign="middle"  align="center" labelPosition="left" cellAlign="even">
<label align="center" value="Statement with this hash not present" containerStyle="padding-top:10px;"/>
</hgroup>
</fieldSet>
<fieldSet id="statementGroup1" hidden="false" valign="middle" align="center">
<hgroup id="planGroup1"  valign="middle"  labelPosition="left" cellAlign="even">
<text id="txtHash" label="Statement Hash" size="30" hidden="false" readOnly="true" value="test" title="The computed hash value for the statement used as the ID in the SQL Statement Index."/>
<text id="txtPlanState" label="Plan State" size="30"  hidden="false" readOnly="true" title="Describes if the plan for this statement has been frozen and if so which type of freeze it was."/>
<text id="txtPlanTS" label="Plan Timestamp" size="30"  hidden="false" readOnly="true" title="This is the timestamp for when this plan was last saved."/>
<text id="txtPlanVersion" label="Plan Version" size="30"  hidden="false" readOnly="true" title="This is the version that was installed when this plan was last saved."/>
<button id="btnRefreshPage" caption="Refresh Page" onclick="zenPage.doRefreshPage();" title="Click this button to freeze the contents of this page."/>
</hgroup>
</fieldSet>
<label align="center" value="Compile Settings" containerStyle="padding-top:10px;"/>
<fieldSet id="statementGroup2" align="center">
<vgroup id="compOptionGroup"  labelPosition="left" cellAlign="even" >
<text id="txtCompileMode" label="Select Mode"   size="30"  hidden="false" readOnly="true" title="SELECTMODE the statement was compiled with."/>
<text id="txtDefaultSchema" label="Default Schema(s)" size="30"  hidden="false" readOnly="true" title="Comma separated list of default schema named defined for the process that compiled this statement."/>
<text id="txtSchemaPath" label="Schema Path" size="30"  hidden="false" readOnly="true" title="Comma separated list of schema names specified as the schema path for the compilation of this statement."/>
<hgroup id="planGroup2"  valign="middle"  labelPosition="left" cellAlign="even">
<text id="txtPlanError" label="Plan Error" size="30"  hidden="true" readOnly="true" title="Error recorded for this frozen plan." controlStyle="color:red; background: yellow;"/>
<button id="btnClearPlanError" caption="Clear Error" onclick="zenPage.doClearPlanError();" title="Click this button to clear the plan error and attempt to use the frozen plan again.  If the problem that results in the plan error has not been corrected, the error will remain.  If the problem has been corrected, the error state will be cleared and the plan can once again be used."/>
</hgroup>
</vgroup>
</fieldSet>
<!-- Show Statement Location Details -->
<label align="center" value="Statement is defined in the following routines" containerStyle="padding-top:10px;"/>
<fieldSet id="statementGroup3" align="center">
<hgroup id="statementGroup3b">
<tablePane id="tblLocations"
queryClass="%SQL.Manager.Catalog"
queryName="StatementLocations"
initialExecute="true"
maxRows="1000"
showZebra="true"
useSnapshot="false"
fixedHeaders="false"
showRowSelector="false"
cellSpacing="2"
align="center"
>
<column colName="ROUTINE" header="Routine" title="Routine name this statement is defined in."/>
<column colName="CONTAINER_TYPE" header="Type" title="Class Method, MAC Routine, etc.  Type of object this statement is defined in."/>
<column colName="COMPILE_DATETIME" header="Last Compile Time" title="Date and time of when this routine was last compiled."/>
<column linkCaption="Compile Routine" id="compileRoutine" 
link="javascript:zenPage.doCompileRoutine('#(%query.ROUTINE)#','#(%page.NAMESPACE)#');" 
cellTitle="Compile the routine that contains this SQL statement."
/>
<condition colName="CONTAINER_TYPE" predicate="EQ" value="Class Method" cellStyle="disabled" targetCol="Compile Routine"/>
<parameter value="#(%page.STMTHASH)#"/>
</tablePane>
<image id="imgRefresh3" src="csp/broker/deepsee/ds2_refresh_44.png" width="16" height="16" title="Refresh routine listing" onclick="zenPage.doRefreshTable('tblLocations');"  disabled="false"/>
</hgroup>
</fieldSet>
<label align="center" value="Statement uses the following relations" containerStyle="padding-top:10px;"/>
<fieldSet id="statementGroup4" align="center">
<hgroup id="statementGroup4b">
<tablePane id="tblRelations"
queryClass="%SQL.Manager.Catalog"
queryName="StatementRelations"
initialExecute="true"
maxRows="1000"
showZebra="true"
useSnapshot="false"
fixedHeaders="false"
showRowSelector="false"
cellSpacing="5"
align="center"
>
<column colName="TABLE_NAME" header="Table or View Name" title="Table or view name or relation used by this statement."/>
<column colName="TABLE_TYPE" header="Type" title="Type of this relation: Table or View."/>
<column colName="COMPILE_DATETIME" header="Last Compile Time" title="Date and time of when this class was last compiled."/>
<column colName="CLASSNAME" header="Classname" hidden="false" title="Name of the class that projected this table or view definition."/>
<column linkCaption="Compile Class" id="compileClass" 
link="javascript:zenPage.doCompileClass('#(%query.CLASSNAME)#','#(%page.NAMESPACE)#');" 
cellTitle="Compile the class that projected this SQL relation." 
/>
<parameter value="#(%page.STMTHASH)#"/>
</tablePane>
<image id="imgRefresh4" src="csp/broker/deepsee/ds2_refresh_44.png" width="16" height="16" title="Refresh table/view listing" onclick="zenPage.doRefreshTable('tblRelations');"  disabled="false"/>
</hgroup>
</fieldSet>
<fieldSet id="statementGroup5" hidden="true">
<textarea id="StatementText"  showLabel="false" label="Statement Text" rows="10" cols="80" hidden="true"
readOnly="true"/>
</fieldSet>
<label align="center" value="Statement Actions" containerStyle="padding-top:10px;"/>
<fieldSet id="statementGroup6" width="100%" align="center">
<hgroup id="buttons" align="center">
<button id="btnFreezePlan" caption="Freeze Plan" onclick="zenPage.doFreezePlan();" title="Click this button to freeze this query plan for the statement.  Plans in a state of Unfrozen/Parallel, or statements that reference an external table may not be frozen."/>
<button id="btnUnFreezePlan" caption="Un-Freeze Plan" onclick="zenPage.doUnFreezePlan();" title="Click this button to un-freeze the frozen query plan for the statement."/>
</hgroup>
</fieldSet>
<label id="labelPlanLabel" align="center" value="Statement Text and Query Plan" containerStyle="padding-top:10px;" />
<fieldSet id="statementGroup7" width="100%" >
<html id="htmlPlan" OnDrawContent="DrawShowPlan"/>
</fieldSet>
</group>
</pane>
}

ClassMethod DrawShowPlan(foo) As %Status
{
	set pText=1,pText(1)=%session.Data($Username,"SQL","StatementText")
	&html<
    <style type="text/css">
   pre { white-space: normal; }
   </style>>
	&html<<table cellpadding="0" cellspacing="1" border="0" width="100%">>
	&html<<tr bgcolor="#818181"><td valign="top" align="center">>

	if '$g(%session.Data($Username,"SQL","StatementPlanError")) {	// No frozen plan error
		if $case($e($$$StripLeadingWhiteSpace($$$UPPER(pText(1))),1,6),"UPDATE":1,"DELETE":1,:0),pText(1)[" WHERE CURRENT OF " {
			Set tPlan = ##class(%SQL.Manager.ShowPlan).ShowPlanError(.pText,$$$Text("There is no Query Plan for positioned UPDATE or DELETE statements"))
		}
		else {
			set SelectMode=$g(%session.Data($Username,"SQL","StatementSelectMode")) set:SelectMode="Logical" SelectMode=""
			Set tPlan = ##class(%SQL.Manager.ShowPlan).ShowPlan(.pText,$g(%session.Data($Username,"SQL","StatementPackages")),0,+$g(%session.Data($Username,"SQL","StatementPlanFrozen")),SelectMode,,$g(%session.Data($Username,"SQL","StatementSchemaPath")))
		}
	}
	else {
		Set tPlan = ##class(%SQL.Manager.ShowPlan).ShowPlanError(.pText)
	}

	&html<#(tPlan)#>
	&html<</table>>
	
	Quit $$$OK
}

Method FreezePlan() As %String [ PublicList = SQLCODE, ZenMethod ]
{
	#dim hash,%msg,packages,sql,switch,tmsg As %String
	#dim returnVal As %Integer
	
	new SQLCODE
	set hash=..STMTHASH
	set:hash[" " hash=$tr(hash," ","+")
	if $$HasExternalTable^%SYS.SQLSRV(hash) {
		set tmsg=%msg
		QUIT tmsg
	}
	Set returnVal=$$FreezePlan^%SYS.SQLSRV(hash)
	if returnVal {
		set state=$$$Text("Frozen/Explicit")
		set ..%GetComponentById("txtPlanState").value = state
		Set ..%GetComponentById("txtPlanState").size = $l(state)
		set ..%GetComponentById("btnFreezePlan").disabled = 1
		set ..%GetComponentById("btnUnFreezePlan").disabled = 0
		set %session.Data($Username,"SQL","StatementPlanFrozen")=1
		set tmsg=""
	}
	else {
		set tmsg="ERROR:  SQLCODE = "_$g(SQLCODE,"<NOT DEFINED>")_", %msg = "_$g(%msg,"<NOT DEFINED>")
	}
	QUIT tmsg
}

ClientMethod doFreezePlan() [ Language = javascript ]
{
	var ok = this.FreezePlan();
	if (ok != "") alert(ok);
	zen('statementGroup2').refreshContents();
	zen('statementGroup7').refreshContents();
	this.FrozenSettingHasChanged = 1;
	zenPage.xmlns
}

Method UnFreezePlan() As %String [ ZenMethod ]
{
	#dim hash,%msg,tmsg As %String
	#dim returnVal,SQLCODE As %Integer
	
	new %msg
	set hash=..STMTHASH
	set:hash[" " hash=$tr(hash," ","+")
	Set returnVal=$$UnfreezePlan^%SYS.SQLSRV(hash)
	if returnVal {
		set state=$$$Text("Unfrozen")
		set ..%GetComponentById("txtPlanState").value = state
		Set ..%GetComponentById("txtPlanState").size = $l(state)
		set ..%GetComponentById("btnFreezePlan").disabled = $$HasExternalTable^%SYS.SQLSRV(hash)	// if there is an external table, disable btnFreezePlan
		set ..%GetComponentById("btnUnFreezePlan").disabled = 1
		Set ..%GetComponentById("txtPlanError").value = ""
		Set ..%GetComponentById("txtPlanError").disabled = 1
		Set ..%GetComponentById("txtPlanError").hidden = 1
		set %session.Data($Username,"SQL","StatementPlanError")=0
		set %session.Data($Username,"SQL","StatementPlanFrozen")=0
		set tmsg=""
	}
	else {
		set tmsg="ERROR:  ,SQLCODE = "_$g(SQLCODE,"<NOT DEFINED>")_", %msg = "_$g(%msg,"<NOT DEFINED>")
	}
	QUIT tmsg
}

ClientMethod doUnFreezePlan() [ Language = javascript ]
{
	var ok = this.UnFreezePlan();
	if (ok != "") alert(ok);
	zen('statementGroup2').refreshContents();
	zen('statementGroup7').refreshContents();
	this.FrozenSettingHasChanged = 1;
}

ClientMethod doRefreshTable(tablename) [ Language = javascript ]
{
		var table = zen(tablename);
		table.refreshContents();
}

Method CompileClassSetClassname(classname As %String) As %String [ ZenMethod ]
{
	kill %session.Data($Username,"SQLStatementClass")
	set %session.Data($Username,"SQLStatementClass","selectedRows",1)=classname_".cls"
	set %session.Data($Username,"SQLStatementClass","selectedRows")=1
	set %session.Data($Username,"SQLStatementClass","TotalSelected")=1
	QUIT 1
}

ClientMethod doCompileClass(classname, namespace) [ Language = javascript ]
{
	var ok = this.CompileClassSetClassname(classname);
	var parms = {
			MODE:"models",
			FILETYPE:"SQLStatementClass",
			COMPILEALL:0,
			$NAMESPACE:namespace
	};
	
	zenLaunchPopupWindow('%CSP.UI.Portal.Dialog.Compile.zen','Compile','status,scrollbars,resizable=yes,width=610,height=700',parms);
}

Method CompileRoutineSetRoutineName(rtnname As %String) As %String [ ZenMethod ]
{
	kill %session.Data($Username,"SQLStatementRoutine")
	set %session.Data($Username,"SQLStatementRoutine","selectedRows",1)=rtnname_".mac"
	set %session.Data($Username,"SQLStatementRoutine","selectedRows")=1
	set %session.Data($Username,"SQLStatementRoutine","TotalSelected")=1
	QUIT 1
}

ClientMethod doCompileRoutine(rtnname, namespace) [ Language = javascript ]
{
	var ok = this.CompileRoutineSetRoutineName(rtnname);
	var parms = {
			MODE:"models",
			FILETYPE:"SQLStatementRoutine",
			COMPILEALL:0,
			$NAMESPACE:namespace
	};
	
	zenLaunchPopupWindow('%CSP.UI.Portal.Dialog.Compile.zen','Compile','status,scrollbars,resizable=yes,width=610,height=700',parms);
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$Text("SQL Statement Details")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

/// This client event is fired when the a popup page launched from this page fires an action.
/// action - StatementRefresh is for when returning from compiling a routine or class.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	switch(action) {
	case 'StatementRefresh':
		this.doRefreshTable('tblLocations');
		this.doRefreshTable('tblRelations');
		var ok = this.RefreshStatementMetadata();
		zen('statementGroup1').refreshContents();
		break;
	default:
	}
}

/// This client event is fired when the Refresh button is clicked
ClientMethod doRefreshPage() [ Language = javascript ]
{
	zen('statementGroup7').refreshContents();
	var ok = this.RefreshStatementMetadata();
	this.doRefreshTable('tblLocations');
	this.doRefreshTable('tblRelations');
	zen('statementGroup1').refreshContents();
	zen('statementGroup2').refreshContents();
	zen('statementGroup7').refreshContents();
}

/// This client event is fired when the ClearPlanError button is clicked
ClientMethod doClearPlanError() [ Language = javascript ]
{
	var ok = this.ClearPlanError();
	zen('statementGroup7').refreshContents();
	var ok = this.RefreshStatementMetadata();
	this.doRefreshTable('tblLocations');
	this.doRefreshTable('tblRelations');
	zen('statementGroup1').refreshContents();
	zen('statementGroup2').refreshContents();
	zen('statementGroup7').refreshContents();
}

Method ClearPlanError() As %Status [ ZenMethod ]
{
	set hash=..STMTHASH
		// For reasons unknown to me, then the hash is used as the 
	set:hash[" " hash=$tr(hash," ","+")
	do UpdateSQLIndex^%SYS.SQLSRV(hash,"")	// Clear the error in the statement index
	Set ..%GetComponentById("txtPlanError").value = ""
	Set ..%GetComponentById("txtPlanError").disabled = 1
	Set ..%GetComponentById("txtPlanError").hidden = 1
	Set ..%GetComponentById("btnClearPlanError").hidden = 1
	Set %session.Data($Username,"SQL","StatementPlanError") = 0
	Quit $$$OK
}

/// This callback, if defined, is called when the user presses the Cancel (on this page, "Close") button.
/// If this returns false, then the dialog is not cancelled.
ClientMethod ondialogCancel() [ Language = javascript ]
{
	try {
            if (this.FrozenSettingHasChanged) {
                        this.firePopupAction('ok',1);
            }
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

Method RefreshStatementMetadata() As %Status [ ZenMethod ]
{
	set hash=..STMTHASH
		// For reasons unknown to me, then the hash is used as the 
	set:hash[" " hash=$tr(hash," ","+")
	Do ##class(%SQL.Manager.Catalog).GetStatementInfo(hash,,,,.PlanState,,,, .PlanTS, .PlanVersion, .PlanError)
	if $case(PlanState,1:1,:0) || ($$HasExternalTable^%SYS.SQLSRV(hash)) {	// Frozen, or has external table and cannot be frozen
		Set ..%GetComponentById("btnFreezePlan").disabled = 1
		Set ..%GetComponentById("btnUnFreezePlan").disabled = 0
	}
	elseif $case(PlanState,3:1,"":1,:0) {	// Plan State is not defined (INSERT?), or "Unfrozen/Parallel"
		Set ..%GetComponentById("btnFreezePlan").disabled = 1
		Set ..%GetComponentById("btnUnFreezePlan").disabled = 1
	}
	else {
		Set ..%GetComponentById("btnFreezePlan").disabled = 0
		Set ..%GetComponentById("btnUnFreezePlan").disabled = 1
	}
	Set DisplayPlanState=$case(PlanState,1:$$$Text("Frozen/Explicit"),3:$$$Text("Unfrozen/Parallel"),:$$$Text("Unfrozen"))
	Set ..%GetComponentById("txtPlanState").value = DisplayPlanState
	Set ..%GetComponentById("txtPlanState").size = $l(DisplayPlanState)
	if PlanVersion'="" {
		set v=$SYSTEM.Version.GetMajor(PlanVersion)_"."_$SYSTEM.Version.GetMinor(PlanVersion)_"."_$case($SYSTEM.Version.GetPoint(PlanVersion),"":0,:$SYSTEM.Version.GetPoint(PlanVersion))_"."_$SYSTEM.Version.GetBuildNumber(PlanVersion)
		Set ..%GetComponentById("txtPlanVersion").value = v
		Set ..%GetComponentById("txtPlanVersion").disabled = 1
		Set ..%GetComponentById("txtPlanVersion").size = $l(v)
		Set ..%GetComponentById("txtPlanVersion").title = $$$Text("This is the version that was installed when this plan was last saved.  The entire version string for this plan is: ")_PlanVersion
	}
	else {
		Set ..%GetComponentById("txtPlanVersion").hidden = 1
	}
	if PlanError'="" {	// display plan error
		Set ..%GetComponentById("txtPlanError").value = PlanError
		Set ..%GetComponentById("txtPlanError").disabled = 1
		Set ..%GetComponentById("txtPlanError").hidden = 0
		Set ..%GetComponentById("txtPlanError").size = $l(PlanError)+3
		Set ..%GetComponentById("btnClearPlanError").hidden = 0
	}
	else {	// No plan error
		Set ..%GetComponentById("txtPlanError").value = ""
		Set ..%GetComponentById("txtPlanError").disabled = 1
		Set ..%GetComponentById("txtPlanError").hidden = 1
		Set ..%GetComponentById("btnClearPlanError").hidden = 1
	}
	if PlanTS="" {	// never frozen
		Set ..%GetComponentById("txtPlanTS").value = ""
		Set ..%GetComponentById("txtPlanTS").disabled = 1
		Set ..%GetComponentById("txtPlanTS").hidden = 1
	}
	else {
		Set ..%GetComponentById("txtPlanTS").value = PlanTS
		Set ..%GetComponentById("txtPlanTS").disabled = 1
		Set ..%GetComponentById("txtPlanTS").hidden = 0
		Set ..%GetComponentById("txtPlanTS").size = $l(PlanTS)
	}
	Set %session.Data($Username,"SQL","StatementPlanError") = (PlanError'="")
	Quit $$$OK
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set %page.SCHEMA = ..SCHEMA
	set hash=..STMTHASH
		// For reasons unknown to me, then the hash is used as the 
	set:hash[" " hash=$tr(hash," ","+")

	Set ret=##class(%SQL.Manager.Catalog).GetStatementInfo(hash, .RoutineList, .RelationList, .Statement, .PlanState, .DefaultSchema, .SchemaPath, .SelectMode, .PlanTS, .PlanVersion, .PlanError)
	If 'ret {
		Set ..%GetComponentById("statementError").hidden = 0
	}
	if $case(PlanState,1:1,:0)  || ($$HasExternalTable^%SYS.SQLSRV(hash)) {	// Frozen, or has external table and cannot be frozen
		Set ..%GetComponentById("btnFreezePlan").disabled = 1
		Set ..%GetComponentById("btnUnFreezePlan").disabled = 0
	}
	elseif $case(PlanState,3:1,"":1,:0) {	// Plan State is not defined (INSERT?), or "Unfrozen/Parallel"
		Set ..%GetComponentById("btnFreezePlan").disabled = 1
		Set ..%GetComponentById("btnUnFreezePlan").disabled = 1
	}
	else {
		Set ..%GetComponentById("btnFreezePlan").disabled = 0
		Set ..%GetComponentById("btnUnFreezePlan").disabled = 1
	}
	set SelectMode=$case($$$LOWER(SelectMode),"%runtime":"Runtime","%odbc":"ODBC","%external":"Display","%intext":"IntExt","%fdbms":"FDBMS",:"Logical")
	Set DisplayPlanState=$case(PlanState,1:$$$Text("Frozen/Explicit"),3:$$$Text("Unfrozen/Parallel"),:$$$Text("Unfrozen"))
	Set ..%GetComponentById("txtHash").value = hash
	Set ..%GetComponentById("txtHash").disabled = 0
	Set ..%GetComponentById("txtHash").size = $l(hash)+8
	Set ..%GetComponentById("txtCompileMode").value = SelectMode
	Set ..%GetComponentById("txtCompileMode").disabled = 1
	Set ..%GetComponentById("txtCompileMode").size = $l(SelectMode)+10
	Set ..%GetComponentById("txtDefaultSchema").value = DefaultSchema
	Set ..%GetComponentById("txtDefaultSchema").disabled = 1
	Set ..%GetComponentById("txtDefaultSchema").size = $l(DefaultSchema)+10
	Set ..%GetComponentById("txtSchemaPath").value = SchemaPath
	Set ..%GetComponentById("txtSchemaPath").disabled = 1
	Set ..%GetComponentById("txtSchemaPath").size = $l(SchemaPath)+10
	Set ..%GetComponentById("txtPlanState").value = DisplayPlanState
	Set ..%GetComponentById("txtPlanState").disabled = 1
	Set ..%GetComponentById("txtPlanState").size = 3
	if PlanVersion'="" {
		set v=$SYSTEM.Version.GetMajor(PlanVersion)_"."_$SYSTEM.Version.GetMinor(PlanVersion)_"."_$case($SYSTEM.Version.GetPoint(PlanVersion),"":0,:$SYSTEM.Version.GetPoint(PlanVersion))_"."_$SYSTEM.Version.GetBuildNumber(PlanVersion)
		Set ..%GetComponentById("txtPlanVersion").value = v
		Set ..%GetComponentById("txtPlanVersion").disabled = 1
		Set ..%GetComponentById("txtPlanVersion").size = $l(v)
		Set ..%GetComponentById("txtPlanVersion").title = $$$Text("This is the version that was installed when this plan was last saved.  The entire version string for this plan is: ")_PlanVersion
	}
	else {
		Set ..%GetComponentById("txtPlanVersion").hidden = 1
	}
	if PlanError'="" {	// display plan error
		Set ..%GetComponentById("txtPlanError").value = PlanError
		Set ..%GetComponentById("txtPlanError").disabled = 1
		Set ..%GetComponentById("txtPlanError").hidden = 0
		Set ..%GetComponentById("txtPlanError").size = $l(PlanError)+3
		Set ..%GetComponentById("btnClearPlanError").hidden = 0
	}
	else {	// No plan error
		Set ..%GetComponentById("txtPlanError").value = ""
		Set ..%GetComponentById("txtPlanError").disabled = 1
		Set ..%GetComponentById("txtPlanError").hidden = 1
		Set ..%GetComponentById("btnClearPlanError").hidden = 1
	}
	if PlanState {
		Set ..%GetComponentById("txtPlanTS").value = PlanTS
		Set ..%GetComponentById("txtPlanTS").disabled = 1
		Set ..%GetComponentById("txtPlanTS").size = $l(PlanTS)
	}
	elseif PlanTS="" {	// never frozen
		Set ..%GetComponentById("txtPlanTS").value = ""
		Set ..%GetComponentById("txtPlanTS").disabled = 1
		Set ..%GetComponentById("txtPlanTS").hidden = 1
	}
	else {
		Set ..%GetComponentById("txtPlanTS").value = PlanTS
		Set ..%GetComponentById("txtPlanTS").disabled = 1
		Set ..%GetComponentById("txtPlanTS").hidden = 0
		Set ..%GetComponentById("txtPlanTS").size = $l(PlanTS)
		//Set ..%GetComponentById("txtPlanTS").label = $$$Text("Unfrozen Timestamp")
	}
	Set %session.Data($Username,"SQL","StatementText") = $g(Statement)
	Set %session.Data($Username,"SQL","StatementPlanError") = (PlanError'="")
	Set %session.Data($Username,"SQL","StatementPlanFrozen") = PlanState
	Set %session.Data($Username,"SQL","StatementSelectMode") = SelectMode
	Set %session.Data($Username,"SQL","StatementSchemaPath") = $listfromstring(SchemaPath)
	if $g(DefaultSchema)'="" {
		set tmp=$listfromstring(DefaultSchema),packages=""
		for i=1:1:$ll(tmp) { set packages=packages_$lb($$GetPackage^%apiDDL($lg(tmp,i),1)) }
		Set %session.Data($Username,"SQL","StatementPackages") = packages
	}
	else {
		Set %session.Data($Username,"SQL","StatementPackages") = ""
	}
	Quit $$$OK
}

}
