/// Base class for  Management Portal dialogs.
Class %CSP.Portal.standardDialog Extends %ZEN.Dialog.standardDialog [ Abstract, System = 4 ]
{

Parameter DOMAIN = "%Utility";

Parameter APPLYBUTTON = 1;

Parameter EMSSERVICE As STRING;

/// 1 if we are on an EMS manager and viewing group data or on a managed instance, 0 otherwise.
Property IsEMSReadOnly As %Boolean [ InitialExpression = {##class(%SYS.EMS).IsReadOnly($classname())} ];

/// Set to 1 in %OnAfterCreatePage if a URI parameter is invalid. Used to disable command buttons in onloadHandler().
Property InvalidParam As %Boolean [ InitialExpression = 0 ];

/// Keeps track of the first form field that failed during validation.
Property FirstFailed As %String;

Property ValidationErrorMsg As %String [ InitialExpression = {$$$Text("There was a problem with the form. See the highlighted fields below.")} ];

/// Provide HTML for html title box.<br>
Method %DrawTitle(pSeed As %String) As %Status
{
	#; draw html title box
	Set tTitle = ..%OnGetTitle()
	Set tProp = ..%OnGetSubtitle()
	
	Set tIcon = "portal/icon_sysadmin.png"

	&html<<table class="stdTitle" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		<td align="left" width="40"><img src="#(tIcon)#"/></td>
		<td align="left" width="90%" style="padding-left:20px;">
		<div style="font-size: 0.8em;">#(tTitle)#</div>
		<div style="font-size: 0.6em; font-style: italic;">#(tProp)#</div></td>
		<td>&nbsp;</td></tr></table>>
	Quit $$$OK
}

/// Return tmsg. 1 means success. Otherwise error message in HTML.
ClassMethod EvalResult(pSC) As %String
{
	Quit ##class(%CSP.UI.Portal.Template).EvalResult(pSC)
}

/// Clear message from idRespond html (usually placed above the editing portion of the page, but could be anywhere).
ClientMethod resetMsg() [ Language = javascript ]
{
	zen("idRespond").setValue('');
 	zen("idRespond").setHidden(true);
}

/// Display message in idRespond html (usually placed above the editing portion of the page, but could be anywhere).
/// isErr: if 1 is passed in then the color will be changed to red; 
///        If 0 is passed in then the color is changed to #4D3926;
///        If nothing is passed in, then the color is unchanged. This allows developers to set their own style/class and still be able to use showMsg.
ClientMethod showMsg(msg, isErr) [ Language = javascript ]
{
	try {
	 	if (typeof(isErr) != "undefined") {
		 	var noteClass = (isErr == 1) ? "errorNote" : "note";
		 	zen("idRespond").setProperty("enclosingClass",noteClass);
	 	}
		zen("idRespond").setValue(msg);
	 	zen("idRespond").setHidden(false);
	}
  	catch(ex) {
		alert("showMsg ERROR: " + ex);
	}
}

/// Validate the control value. pass is either "true" or "false" indicating if there is already a field that failed validation. 
/// Type is "N" for numeric or "S" for string. If numeric, if checkRange is true, we additionally validate that the number is 
/// between minVal and maxVal, inclusive.
ClientMethod validateRequired(ctl, pass, type, checkRange, minVal, maxVal) As %Boolean [ Language = javascript ]
{
	var ok = true;
	var value = ctl.getValue();
	switch (type) {
		/// contains at least one numeric character
		case "N":
			if (!(value.match(/\d/))) {
				ok = false;
			} else if (checkRange == true) {
				if (isNaN(value)) {
					// fail if not numeric
					ok = false;
				} else if ((value < minVal) || (value > maxVal)) {
					// fail if not in range
					ok = false;
				}
			}
			break;
		case "S":
		/// contains at least one character after striping all blanks
			if (zenTrim(value) == '') {
				ok = false;
			}
			break;
	}
	if (ok == false) {
		ctl.setProperty("hintClass","redText");
		ctl.setProperty("controlClass","zenInvalid");
		if (pass) {
			this.FirstFailed = ctl.getProperty("id");
		}
	} else {
		ctl.setProperty("hintClass","helpText");
		ctl.setProperty("controlClass","");
	}
	return ok;
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if (this.IsEMSReadOnly || this.InvalidParam) {
		var btnArray = ['btnOK','btnApply','btnFinish'];
		for (var i=0;i<btnArray.length;i++) {
			var btn = zen(btnArray[i]);
			if (btn) {
				zen(btnArray[i]).setProperty('controlClass','commandButtonDisabled');
				zen(btnArray[i]).setProperty('onclick','return false;');
			}
		}
	}
}

/// Be sure to do ##super() when overriding.
Method %OnAfterCreatePage() As %Status
{

	If ##class(%SYS.EMS).IsEMSManagerSMP() {
		Set %zenPageError = $$$ERROR($$$EMSNoSMP)
	}
	
	Quit $$$OK
}

}
