/// This dialog lets the user edit a default value for a control within a Dashboard widget.
Class %DeepSee.UI.Dialog.DashboardEditDefaultValue Extends %DeepSee.UI.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// Dashboard name.
Property dashboardName As %ZEN.Datatype.string(ZENURL = "DASHBOARD");

/// Data source name.
Property dataSource As %ZEN.Datatype.string(ZENURL = "DATASOURCE");

/// Default value.
Property defaultValue As %ZEN.Datatype.string(ZENURL = "VALUE");

/// Current filter name.
Property filterName As %ZEN.Datatype.string(ZENURL = "FILTER");

/// Current mode: filter or setting.
Property currMode As %ZEN.Datatype.string;

XData Style
{
<style type="text/css">

</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" xmlns:deepsee="http://www.intersystems.com/deepsee" cellStyle="padding-bottom:8px;">


<html id="overview" OnDrawContent="DrawOverview"/>

<hgroup cellVAlign="top" label="Select a filter value">
<radioButton name="type" id="rbFilter" optionValue="filter" onclick="zenPage.rbChanged();"/>
<!--<selector id="controlFilter" size="50"/>-->
<combobox id="controlFilter" size="50"/>
</hgroup>
<spacer height="20"/>

<hgroup cellVAlign="top" label="Use a run-time variable">
<radioButton name="type" id="rbSetting" optionValue="setting" onclick="zenPage.rbChanged();"/>
<selector id="controlSetting" size="50"/>
</hgroup>
<spacer height="20"/>

</pane>
}

/// Draw overview content.
Method DrawOverview(pSeed As %String) As %Status
{
	Write $$$TextHTML("Provide a default value for the current control using one of the following options:"),!
	Quit $$$OK
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Default Value Editor")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Edit the default value for a dashboard control.")
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return this.defaultValue;
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		if ('filter'==this.currMode) {
			this.defaultValue = zen('controlFilter').getValue();
		}
		else {
			this.defaultValue = zen('controlSetting').getValue();
			if (''!=this.defaultValue && '@' != this.defaultValue.charAt(0)) {
				this.defaultValue = '@' + this.defaultValue;
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

/// This callback, if defined, is called when the dialog page is loaded.
ClientMethod ondialogStart() [ Language = javascript ]
{
	try {
		// determine mode
		if (this.defaultValue.charAt(0)=='@') {
			this.currMode = 'setting';
			zen('controlSetting').setValue(this.defaultValue.substr(1));
		}
		else {
			this.currMode = 'filter';
			zen('controlFilter').setValue(this.defaultValue);
		}
		
		if ('filter'==this.currMode) {
			this.defaultValue = zen('controlFilter').getValue();
		}
		else {
			this.defaultValue = zen('controlSetting').getValue();
		}

		var rbFilter = zen('rbFilter');
		rbFilter.setValue(this.currMode);
		this.updateControls();
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

/// User selected a radio button.
ClientMethod rbChanged() [ Language = javascript ]
{
	var rbFilter = zen('rbFilter');
	this.currMode = rbFilter.getValue();
	this.updateControls();
}

/// Update controls to match current state.
ClientMethod updateControls() [ Language = javascript ]
{
	if ('filter'==this.currMode) {
		zen('controlFilter').setProperty('disabled',false);
		zen('controlSetting').setProperty('disabled',true);
	}
	else {
		zen('controlFilter').setProperty('disabled',true);
		zen('controlSetting').setProperty('disabled',false);
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = $$$OK
	Try {
		Set ctrlFilter = ..%GetComponentById("controlFilter")
		Set ctrlSetting = ..%GetComponentById("controlSetting")
		
		// set search context for selectors
		Set ctrlSetting.context = "%DeepSee.Component.ContextSearch/UserSettings?context=DefaultFilterValue"
		
		// add options to filter combo
		If ((..dataSource'="")&&(..filterName'="")) {
			Set tSC = ##class(%DeepSee.Dashboard.Utils).%GetMembersForFilter(..dataSource,..filterName,.tFilters)
			If $$$ISERR(tSC) Quit

			Set k = $O(tFilters(""))
			While (k'="") {
				Set tOption = ##class(%ZEN.Auxiliary.option).%New()
				Set tOption.text = $LG(tFilters(k),1)
				Set tOption.value = $LG(tFilters(k),2)
				Do ctrlFilter.options.Insert(tOption)
				Do %page.%AddComponent(tOption)
				Set k = $O(tFilters(k))
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
