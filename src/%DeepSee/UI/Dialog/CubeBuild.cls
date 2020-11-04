/// This dialog builds facts and indices for a DeepSee cube and displays the output.
/// !!! % complete, view log file, show errors, make non-modal!!!
Class %DeepSee.UI.Dialog.CubeBuild Extends %DeepSee.UI.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// Cube class name.
Property cubeClass As %ZEN.Datatype.string(ZENURL = "CLASS");

/// Cube name.
Property cubeName As %ZEN.Datatype.string(ZENURL = "CUBE");

/// The maximum number of records for be built defined for the selected cube
Property maxFacts As %ZEN.Datatype.string(ZENURL = "maxFacts");

/// The maximum number of records to be built for the the selected cube in this session (overrides maxFacts)
Property TempMaxFacts As %ZEN.Datatype.string;

/// Id used to track progress.
Property trackingId As %ZEN.Datatype.string;

XData Style
{
<style type="text/css">
#status .statusTable {
	background: white;
	border: 1px solid #404040;
	width: 500px;
}

#status .statusTable td {
	padding: 2px;
	padding-right: 5px;
	padding-left: 5px;
	border-right: 1px solid #808080;
	border-bottom: 1px solid #808080;
}

</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding-bottom:8px;">
<vgroup cellStyle="padding-bottom: 4px;">
<label id="cubeName" label="Cube Name" value="#(%page.cubeName)#" controlClass="labelValue"/>
<text id="TempMaxFacts" label="Maximum Number of Records to Build" value="#(%page.TempMaxFacts)#" size="5"
hint="If blank or zero, DeepSee builds all the records."/>
<radioSet id="buildOption" label="Build Option" value="all" valueList="all,incremental" displayList="Build Everything,Incremental Update" hidden="true"/>
</vgroup>
<html id="status"/>
<timer id="timer" ontimeout="zenPage.updateStatus();"/>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Build Cube")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Build the fact table and indices for this cube.")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return '';
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		this.startBuild();
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return false;
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	zen("btnOK").focus();
	zen("btnOK").setProperty("caption",$$$Text("Build"));
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = $$$OK
	Try {
		Set ..TempMaxFacts = $G(%session.Data($Username,"TempMaxFacts"))
		If ..maxFacts '= "" {
			#; if user defined maxFacts for the cube definition then change the hint
			Set ..%GetComponentById("TempMaxFacts").hint = $$$TextHTML("If blank or zero, DeepSee builds all the records.")_" (maxFacts = "_$ZCVT(..maxFacts,"O","HTML") _")"
			If ..TempMaxFacts = "" Set ..TempMaxFacts = ..maxFacts
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Start the index build.
ClientMethod startBuild() [ Language = javascript ]
{
	var option = zen('buildOption').getValue();
	switch(option) {
	case 'all':
		zen('btnOK').setDisabled(true);
		this.trackingId = this.BuildCube(this.cubeName,zen("TempMaxFacts").getValue());
		if (this.trackingId!='') {
			zen('timer').timeout = 500;
			zen('timer').startTimer();
		}
		else {
			zen('btnOK').setDisabled(false);
		}
		break;
	case 'incremental':
		break;
	}
	return;
}

/// Start the build cube process in the background.
/// Return the tracking id.
ClassMethod BuildCube(pCubeName As %String, pTempMaxFacts As %Integer) As %String [ ZenMethod ]
{
	Set tTrackingId = ""
	Set tJobTimeOut = 10
	#; If user entered blank then use and save it as blank. Otherwise use and save the numeric 
	Set tTempMaxFacts = $S(pTempMaxFacts="":"",1:+pTempMaxFacts)
	Set %session.Data($Username,"TempMaxFacts") = tTempMaxFacts
	#; Reset text value if the numeric value differs from user's input.
	If pTempMaxFacts '= tTempMaxFacts {
		&js<zen("TempMaxFacts").setValue('#(tTempMaxFacts)#');>	
	}
	Job ##class(%DeepSee.Utils).%BuildCube(pCubeName,1,0,0,tTempMaxFacts,1)::tJobTimeOut
	If '$Test {
		&js<alert('Unable to start background job.');>
		Set tTrackingId = ""
	}
	Else {
		Set tTrackingId = $ZChild
	}
	Quit tTrackingId
}

/// Get the current status of the background task.
ClassMethod CheckStatus(pTrackingId As %String) As %String [ ZenMethod ]
{
	Set tOutput = ""
	Set tIsComplete = 0

	// status is ($J,step) = $LB(phase,count,pct,errors)
	Set tStep = $O(^CacheTemp.DeepSeeTracking(pTrackingId,""),1,info)
	While (tStep'="") {
		Set tIsActive = $O(^CacheTemp.DeepSeeTracking(pTrackingId,tStep))=""
		Set tPhase = $LG(info,1)
		Set:tPhase="complete"!(tPhase="error") tIsComplete = 1
		Set tMsg = $Case(tPhase,"delete":$$$Text("Deleting facts"),"facts":$$$Text("Building facts"),"indices":$$$Text("Building indices"),"aggs":$$$Text("Computing aggregates"),"iknow":$$$Text("Processing iKnow measures"),"error":$$$Text("Error"),:$$$Text("Complete"))
		Set tCount = $LG(info,2)
		Set tPct = $LG(info,3)
		Set tErr = $LG(info,4)
		If (tCount="") {
			Set tCount = "&nbsp;"
		}
		Else {
			Set tCount = $FN(tCount,",") _ " " _ $$$Text("fact(s)")
		}
		If (tPct="") {
			Set tPct = "&nbsp;"
		}
		Else {
			Set tPct = $FN(tPct,",",2) _ "%"
		}
		Set tOutput = tOutput _ "<tr style="""_$S(tErr'="":"color:#da4848;",tIsActive:"font-weight:bold;",1:"background:#E0E0F0;")_""">"
		Set tOutput = tOutput _ "<td>"_tMsg_"</td>"
		If tErr = "" {
			Set tOutput = tOutput _ "<td align=""right"">"_tCount_"</td>"
			Set tOutput = tOutput _ "<td align=""right"">"_tPct_"</td>"
			Set tOutput = tOutput _ "<td>"_$S(tIsActive:"&nbsp;",1:$$$Text("Complete"))_"</td>"
			Set tOutput = tOutput _ "<td>&nbsp;</td>"
		} Else {
			/// Write out errors
			Set tOutput = tOutput _ "<td colspan=""4"">"_$ZCVT(tErr,"O","HTML")_"</td>"
		}
		Set tOutput = tOutput _ "</tr>"
		Set tStep = $O(^CacheTemp.DeepSeeTracking(pTrackingId,tStep),1,info)
	}
	If (tOutput'="") {
		Set tOutput = "<div>"_$$$Text("Status")_ "</div><table class=""statusTable"" cellspacing=""0"" width=""100%"">" _ tOutput _ "</table>"
	}

	If (tIsComplete) {
		Kill ^CacheTemp.DeepSeeTracking(pTrackingId)
	}
	Quit tOutput
}

/// Update the status area.
ClientMethod updateStatus() [ Language = javascript ]
{
	var status = this.CheckStatus(this.trackingId);
	var html = zen('status');
	if (status != '') {
		html.setContent(status);
		zen('timer').timeout = 250;
		zen('timer').startTimer();
	}
	else {
		this.trackingId = '';
		zen('btnOK').setDisabled(false);
		// when build finished, set focus on OK button so [Enter] key will exit easily.
		zen("btnCancel").setProperty("caption",$$$Text("Done"));
		zen("btnCancel").focus();
	}
	return;
}

}
