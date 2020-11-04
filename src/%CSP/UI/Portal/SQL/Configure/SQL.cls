Include %sqlui

/// General SQL Settings
Class %CSP.UI.Portal.SQL.Configure.SQL Extends %CSP.UI.Portal.Template [ System = 4 ]
{

Parameter AUTONS = 0;

/// Displayed name of this page.
Parameter PAGENAME = "General SQL Settings";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.SQL.Configure.SQL.zen";

Parameter HELPADDRESS = "System,Configuration,General SQL Settings";

Parameter EMSSERVICE = "Config";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.SpecialCaption {
	font-size: 11pt;
	font-weight: bold;
	padding-bottom: 10px;
	text-transform: uppercase;
}
</style>
}

XData SVGStyle
{
<style type="text/css">
.tabBarBackground { fill:white; stroke:white; }	
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true"/>

<svgFrame id="svgTabArea" height="32" layout="none" backgroundStyle="fill:white; stroke-width:2;" frameStyle="border:none;">
<tabBar id="tabBar" tabCaptions=":SQL:DDL:Optimization"
 onChange="zenPage.tabChanged(index);"/>
</svgFrame>

<vgroup id="page_1" hidden="false" enclosingStyle="padding-left:10px;padding-top:20px;" labelPosition="left">
<checkbox id="Comment" label="Retains SQL Statement as Comments in .INT Code" onchange="zenPage.doModified();"/>
<checkbox id="ECPSync" label="SQL SELECT Synchronizes ECP Cache" onchange="zenPage.doModified();"/>
<checkbox id="SaveMAC" label="Cached Query - Save Source" onchange="zenPage.doModified();"/>
<hgroup label="Identifier Translation - From" labelPosition="left" cellStyle="padding-right:2px;" >
<text id="IdTrxFrom" showLabel="false" size="33" onchange="zenPage.doModified();"/>
<text id="IdTrxTo" label="To" size="33" onchange="zenPage.doModified();"/>
</hgroup>
<select id="TimePrecision" label="Default time precision for GETDATE(), CURRENT_TIME, and CURRENT_TIMESTAMP" 
valueList="0,1,2,3,4,5,6,7,8,9" showEmpty="false"
onchange="zenPage.doModified();"/>
<text id="TCPKeepAlive" label="TCP Keep Alive interval (in seconds)" size="8" onchange="zenPage.doModified();"/>
<checkbox id="QueryProcedures" label="All Class Queries Project as Stored Procedures" onchange="zenPage.doModified();"/>
<text id="LockThreshold" label="Lock Threshold" size="8" onchange="zenPage.doModified();"/>

<spacer height="10"/>

<vgroup showLabel="false">

<vgroup id="triggerPurgeCQ" label="Changes to the following settings will trigger all cached queries to be purged in all namespaces:"
 labelClass="SpecialCaption" enclosingStyle="background:#edece4;padding:10px;" labelPosition="left">
<text id="DefaultSchema" label="Default SQL Schema Name" size="30" onchange="zenPage.doModified();"/>
<checkbox id="DelimitedIds" label="Support Delimited Identifiers" onchange="zenPage.doModified();"/>
<checkbox id="ExtrinsicFunctions" label="Allow Extrinsic Functions in SQL Statements" onchange="zenPage.doModified();"/>
</vgroup>

<spacer height="10"/>

<vgroup id="special" label="Changes to the following settings will take effect only on new processes that start after changes are saved:"
labelClass="SpecialCaption"
enclosingStyle="background:#edece4;padding:10px;" labelPosition="left">
<text id="LockTimeout" label="Lock Timeout (in seconds)" size="8" onchange="zenPage.doModified();"/>
<checkbox id="DBMSSecurity" label="SQL Security Enabled" onchange="zenPage.doModified();"/>
<checkbox id="ReferentialChecks" label="Perform Referential Integrity Checks on Foreign Keys for INSERT, UPDATE, and DELETE" onchange="zenPage.doModified();"/>
</vgroup>
</vgroup>
</vgroup>

<vgroup id="page_2" hidden="true" enclosingStyle="padding-left:10px;padding-top:20px;" labelPosition="left">
<checkbox id="DDLNo30" label="Allow DDL DROP of Non-existent Table or View" onchange="zenPage.doModified();"/>
<checkbox id="DDLNo201" label="Allow DDL CREATE TABLE or CREATE VIEW for Existing Table" onchange="zenPage.doModified();"/>
<checkbox id="DDLNo307" label="Allow Create Primary Key Through DDL When Key Exists" onchange="zenPage.doModified();"/>
<checkbox id="DDLNo315" label="Allow DDL DROP of Non-constraint" onchange="zenPage.doModified();"/>
<checkbox id="DDLNo324" label="Allow DDL CREATE INDEX for Existing Index" onchange="zenPage.doModified();"/>
<checkbox id="DDLNo333" label="Allow DDL DROP of Non-existent Index" onchange="zenPage.doModified();"/>
<checkbox id="DDLNo311" label="Allow DDL ADD Foreign Key Constraint when Foreign Key Exists" onchange="zenPage.doModified();"/>
<checkbox id="DropDelete" label="Does DDL DROP TABLE Delete the Table's Data?" onchange="zenPage.doModified();"/>
<checkbox id="IdKey" label="Are Primary Keys Created through DDL not ID Keys?" onchange="zenPage.doModified();"/>
<checkbox id="DDLFinal" label="Are classes created via DDL CREATE TABLE statement defined as Final?" onchange="zenPage.doModified();"/>
<checkbox id="DDLUseSequence" label="Do classes created by a DDL CREATE TABLE statement use $Sequence for ID assignment?" onchange="zenPage.doModified();"/>
<checkbox id="DDLDefineBitmapExtent" label="Do classes created by a DDL CREATE TABLE statement define a bitmap extent index for the class?" onchange="zenPage.doModified();"/>
</vgroup>

<vgroup id="page_3" hidden="true" enclosingStyle="padding-left:30px;padding-top:20px;" labelPosition="left">
<vgroup showLabel="false">
<vgroup id="optmization" label="System-wide SQL Query Optimizer Settings" labelClass="SpecialCaption" showLabel="true"
>

<html id="htmlNote" OnDrawContent="DrawOptNOTE"/>

<vgroup showLabel="false" enclosingStyle="background:#edece4;padding:10px 50px 10px 20px;" labelPosition="left" cellAlign="left" cellStyle="padding-bottom:6px;">

<group showLabel="false" containerStyle="padding:10px;" >
<html id="htmlWarning" OnDrawContent="DrawOptWARNING"/>
<vgroup cellStyle="padding:10px 10px 2px 0px;">
<checkbox id="FastDistinct" caption="DISTINCT optimization turned ON" onchange="zenPage.doModified();"
hint="Makes SQL queries involving DISTINCT or GROUP BY clauses run more efficiently by making better use of indices, but can affect the output case of the grouped field."/>
<checkbox id="BiasQueriesAsOutlier" caption="Bias queries as outlier" onchange="zenPage.doModified();"
hint="Check this if queries on fields with non-null outliers often refer to the outlier."/>

<label label="Checking any of the following boxes applies the specified FROM keyword to all queries system-wide, regardless of whether the keyword is specified in the individual query."/>

<checkbox id="%ALLINDEX" caption="%ALLINDEX" onchange="zenPage.doModified();"
hint="Uses all applicable indexes for the first table in the join order, regardless of cost."/>
<checkbox id="%NOFLATTEN" caption="%NOFLATTEN" onchange="zenPage.doModified();"
hint="Does not use the 'flatten subqueries' optimization."/>
<checkbox id="%NOMERGE" caption="%NOMERGE" onchange="zenPage.doModified();"
hint="Does not use the 'merge subqueries' optimization."/>
<checkbox id="%NOSVSO" caption="%NOSVSO" onchange="zenPage.doModified();"
hint="Does not use the 'Set-Valued Subquery' optimization."/>
<checkbox id="%NOUNIONOROPT" caption="%NOUNIONOROPT" onchange="zenPage.doModified();"
hint="Does not use the 'convert OR/UNION' optimization."/>
<checkbox id="%NOTOPOPT" caption="%NOTOPOPT" onchange="zenPage.doModified();"
hint="Does not use the 'TOP...ORDER BY' optimization."/>

<button caption="Restore system defaults for this tab (without saving)" 
title="Restores system default values for Optimizer settings. Click Save to commit changes." onclick="zenPage.doRestore();"/>
</vgroup>
</group>

</vgroup>

</vgroup>
</vgroup>
</vgroup>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	// subclassing because we don't want default EMS behavior
}

/// Reload system default values for Optimization. If current value differs from the default, set modified flag.
ClientMethod doRestore() [ Language = javascript ]
{
	var modified = false;
	if (!zen("FastDistinct").getValue()) {
		zen("FastDistinct").setValue(1);
		modified = true;
	}
	if (zen("%ALLINDEX").getValue()) {
		zen("%ALLINDEX").setValue(0);
		modified = true;
	}
	if (zen("%NOFLATTEN").getValue()) {
		zen("%NOFLATTEN").setValue(0);
		modified = true;
	}
	if (zen("%NOMERGE").getValue()) {
		zen("%NOMERGE").setValue(0);
		modified = true;
	}
	if (zen("%NOSVSO").getValue()) {
		zen("%NOSVSO").setValue(0);
		modified = true;
	}
	if (zen("%NOUNIONOROPT").getValue()) {
		zen("%NOUNIONOROPT").setValue(0);
		modified = true;
	}
	if (zen("%NOTOPOPT").getValue()) {
		zen("%NOTOPOPT").setValue(0);
		modified = true;
	}
	if (zen("BiasQueriesAsOutlier").getValue()) {
		zen("BiasQueriesAsOutlier").setValue(0);
		modified = true;
	}
	if (modified) {
		this.doModified();	
	}
}

ClientMethod tabChanged(index) [ Language = javascript ]
{
	this.resetMsg();
	var option;
	for ( var i=0; i<3; i++ ) {
		option = i + 1;
		if ( i == index ) {
			zen("page_"+option).setHidden(false);
		} else {
			zen("page_"+option).setHidden(true);
		}				
	}
}

/// User clicked Save. Save and return to parent page.
ClientMethod doSave() [ Language = javascript ]
{
	// if user has not changed anything, just quit.
	if (!this.pageModified) return;	
	
	var proxy = new zenProxy();

	proxy.DDLNo30 = zen("DDLNo30").getValue() ? 1 : 0;
	proxy.DDLNo201 = zen("DDLNo201").getValue() ? 1 : 0;
	proxy.DDLNo307 = zen("DDLNo307").getValue() ? 1 : 0;
	proxy.DDLNo315 = zen("DDLNo315").getValue() ? 1 : 0;
	proxy.DDLNo324 = zen("DDLNo324").getValue() ? 1 : 0;
	proxy.DDLNo333 = zen("DDLNo333").getValue() ? 1 : 0;
	proxy.DDLNo311 = zen("DDLNo311").getValue() ? 1 : 0;
	proxy.DropDelete = zen("DropDelete").getValue() ? 1 : 0;
	proxy.IdKey = zen("IdKey").getValue() ? 1 : 0;
	proxy.DDLFinal = zen("DDLFinal").getValue() ? 1 : 0;
	proxy.DDLUseSequence = zen("DDLUseSequence").getValue() ? 1 : 0;
	proxy.DDLDefineBitmapExtent = zen("DDLDefineBitmapExtent").getValue() ? 1 : 0;

	proxy.LockTimeout = zen("LockTimeout").getValue();
	proxy.LockThreshold = zen("LockThreshold").getValue();
	proxy.Comment = zen("Comment").getValue();
	proxy.DelimitedIds = zen("DelimitedIds").getValue() ? 1 : 0;
	proxy.DBMSSecurity = zen("DBMSSecurity").getValue() ? 1 : 0;
	proxy.FastDistinct = zen("FastDistinct").getValue() ? 1 : 0;
	proxy.SaveMAC = zen("SaveMAC").getValue() ? 1 : 0;
	proxy.IdTrxFrom = zen("IdTrxFrom").getValue();
	proxy.IdTrxTo = zen("IdTrxTo").getValue();
	proxy.ReferentialChecks = zen("ReferentialChecks").getValue() ? 1 : 0;
	proxy.DefaultSchema = zen("DefaultSchema").getValue();
	proxy.ExtrinsicFunctions = zen("ExtrinsicFunctions").getValue() ? 1 : 0;
	proxy.TimePrecision = zen("TimePrecision").getValue();
	proxy.TCPKeepAlive = zen("TCPKeepAlive").getValue();
	proxy.QueryProcedures = zen("QueryProcedures").getValue() ? 1 : 0;
	proxy.ECPSync = zen("ECPSync").getValue() ? 1 : 0;
	proxy.ALLINDEX = zen("%ALLINDEX").getValue() ? 1 : 0;
	proxy.NOFLATTEN = zen("%NOFLATTEN").getValue() ? 1 : 0;
	proxy.NOMERGE = zen("%NOMERGE").getValue() ? 1 : 0;
	proxy.NOSVSO = zen("%NOSVSO").getValue() ? 1 : 0;
	proxy.NOUNIONOROPT = zen("%NOUNIONOROPT").getValue() ? 1 : 0;
	proxy.NOTOPOPT = zen("%NOTOPOPT").getValue() ? 1 : 0;
	proxy.BiasQueriesAsOutlier = zen("BiasQueriesAsOutlier").getValue() ? 1 : 0;
	proxy.IsEMSReadOnly = this.IsEMSReadOnly;

	var result = this.SaveData(proxy);
	this.afterSave(result);
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {		
		// find size of window
		var winWidth = zenGetWindowWidth();	
		// set the svg and tabs the right size
		zen("svgTabArea").setProperty("width",winWidth-50);
		zen("tabBar").setProperty("width",winWidth-50);
	
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler');
	}
}

/// Save file into global.
ClassMethod SaveData(proxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.Message = ""
	Set tProxy.ErrorMessage = ""

	Try {
		Set cqChange = 0
		
		If 'proxy.IsReadOnly {
			Set tSC = ##class(Config.SQL).Get(.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		
			#; Check if any of the fields that changed should trigger clearing of CQs
			If Properties("DelimitedIds") '= proxy.DelimitedIds Set cqChange = 1
			If Properties("DefaultSchema") '= proxy.DefaultSchema Set cqChange = 1
			If Properties("FastDistinct") '= proxy.FastDistinct Set cqChange = 1
			If Properties("ExtrinsicFunctions") '= proxy.ExtrinsicFunctions, proxy.ExtrinsicFunctions = 0 Set cqChange = 1

			Set Properties("DDLNo30") = proxy.DDLNo30
			Set Properties("DDLNo201") = proxy.DDLNo201
			Set Properties("DDLNo307") = proxy.DDLNo307
			Set Properties("DDLNo315") = proxy.DDLNo315
			Set Properties("DDLNo324") = proxy.DDLNo324
			Set Properties("DDLNo333") = proxy.DDLNo333
			Set Properties("DDLNo311") = proxy.DDLNo311
			Set Properties("DropDelete") = proxy.DropDelete
			Set Properties("IdKey") = proxy.IdKey
			Set Properties("DDLFinal") = proxy.DDLFinal
			Set Properties("DDLUseSequence") = proxy.DDLUseSequence
			Set Properties("DDLDefineBitmapExtent") = proxy.DDLDefineBitmapExtent
			Set Properties("LockTimeout") = proxy.LockTimeout
			Set Properties("LockThreshold") = proxy.LockThreshold
			Set Properties("Comment") = proxy.Comment
			Set Properties("DelimitedIds") = proxy.DelimitedIds
			Set Properties("DBMSSecurity") = proxy.DBMSSecurity
			Set Properties("FastDistinct") = proxy.FastDistinct
			Set Properties("SaveMAC") = proxy.SaveMAC
			Set Properties("IdTrxFrom") = proxy.IdTrxFrom
			Set Properties("IdTrxTo") = proxy.IdTrxTo
			Set Properties("ReferentialChecks") = proxy.ReferentialChecks
			Set Properties("DefaultSchema") = proxy.DefaultSchema
			Set Properties("ExtrinsicFunctions") = proxy.ExtrinsicFunctions
			Set Properties("TimePrecision") = proxy.TimePrecision
			Set Properties("TCPKeepAlive") = proxy.TCPKeepAlive
			Set Properties("QueryProcedures") = proxy.QueryProcedures
			Set Properties("ECPSync") = proxy.ECPSync
			Set Properties("BiasQueriesAsOutlier") = proxy.BiasQueriesAsOutlier
			If +$G(^%SYS("sql","sys","parm incl outlier")) '= proxy.BiasQueriesAsOutlier Set cqChange = 2
			
			Set tSC = ##class(Config.SQL).Modify(.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		If +$G(^%SYS("HINT","%ALLINDEX")) '= proxy.ALLINDEX Set cqChange = 2
		If +$G(^%SYS("HINT","%NOFLATTEN")) '= proxy.NOFLATTEN Set cqChange = 2
		If +$G(^%SYS("HINT","%NOMERGE")) '= proxy.NOMERGE Set cqChange = 2
		If +$G(^%SYS("HINT","%NOSVSO")) '= proxy.NOSVSO Set cqChange = 2
		If +$G(^%SYS("HINT","%NOUNIONOROPT")) '= proxy.NOUNIONOROPT Set cqChange = 2
		If +$G(^%SYS("HINT","%NOTOPOPT")) '= proxy.NOTOPOPT Set cqChange = 2
		
		Set ^%SYS("HINT","%ALLINDEX") = proxy.ALLINDEX
		Set ^%SYS("HINT","%NOFLATTEN") = proxy.NOFLATTEN
		Set ^%SYS("HINT","%NOMERGE") = proxy.NOMERGE
		Set ^%SYS("HINT","%NOSVSO") = proxy.NOSVSO
		Set ^%SYS("HINT","%NOUNIONOROPT") = proxy.NOUNIONOROPT
		Set ^%SYS("HINT","%NOTOPOPT") = proxy.NOTOPOPT
		
		If cqChange > 0 {
			Set tParms("Reason") = $$$TextHTML("Reason: SQL Configuration change")
			Set tSC = ##class(%CSP.UI.System.BackgroundTask).RunTask("PurgeAllCachedQueries",$zu(5),.tParms,,.tJob)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			
			Set tmsg = $$$TextHTML("SQL settings saved.")_"<br>"_$$$TextHTML("Cached Queries will be purged for all namespaces.")
			If cqChange = 2 Set tmsg = tmsg_"&nbsp;&nbsp;"_$$$TextHTML("Please remember to compile classes with SQL and routines with Embedded SQL.")
			Set tProxy.Message = tmsg
		}
		
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set ..lblTitle = $$$Text("Use the form below to view or edit system-wide settings for SQL, DDL, and xDBC connectivity:")
	
	Set tSC = ##class(Config.SQL).Get(.Properties)
	If $$$ISERR(tSC) Quit tSC
	Set tProperty = ""
	Set tProperty = $O(Properties(tProperty)) 
	While tProperty '= ""  {
		Set Component = ..%GetComponentById(tProperty)
		If $ISO(Component) {
			Set Component.value = Properties(tProperty)
			If ..IsEMSReadOnly Set Component.disabled = 1
		}
		Set tProperty = $O(Properties(tProperty)) 
	}
	
	#; For optimizer options
	Set ..%GetComponentById("%ALLINDEX").value = +$G(^%SYS("HINT","%ALLINDEX"))
	Set ..%GetComponentById("%NOFLATTEN").value = +$G(^%SYS("HINT","%NOFLATTEN"))
	Set ..%GetComponentById("%NOMERGE").value = +$G(^%SYS("HINT","%NOMERGE"))
	Set ..%GetComponentById("%NOSVSO").value = +$G(^%SYS("HINT","%NOSVSO"))
	Set ..%GetComponentById("%NOUNIONOROPT").value = +$G(^%SYS("HINT","%NOUNIONOROPT"))
	Set ..%GetComponentById("%NOTOPOPT").value = +$G(^%SYS("HINT","%NOTOPOPT"))
	;Set ..%GetComponentById("BiasQueriesAsOutlier").value = +$G(^%SYS("sql","sys","parm incl outlier"))

	Quit 1
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("General SQL Settings")
}

ClassMethod DrawOptNOTE(pSeed) As %Status
{
	Set tMsg = $$$TextHTML("Changing any of these settings causes all cached queries to be purged in all namespaces. To ensure that any changes here affect all queries, recompile any classes with SQL and any routines with embedded SQL.")
	&html<<div style="padding:10px 10px 10px 0px;">#(tMsg)#</div>>
	Quit $$$OK
}

ClassMethod DrawOptWARNING(pSeed) As %Status
{
	Set tMsg = $$$TextHTML("CAUTION:")
	Set tMsg1 = $$$TextHTML("Changing any of these settings applies to SQL optimization system-wide.")
	Set tMsg2 = $$$TextHTML("These system-wide overrides should only be used in rare and specific circumstances.")
	Set tLink = ..Link("/csp/docbook/DocBook.UI.Page.cls?KEY=RACS_Settings#RACS_SQLGeneral_optimization")
	&html<<div style="color:#da4848;font-weight:bold;">#(tMsg)#</div>>
	&html<<ul><li>#(tMsg1)#</li>
	<li>#(tMsg2)#</li></ul>
	<div style="padding-bottom:10px;"><a class="link" target="_blank" href="#(tLink)#" style="text-decoration:underline;">#($$$TextHTML("Click here for more documentation."))#</a>
	</div>>
	Quit $$$OK
}

}
