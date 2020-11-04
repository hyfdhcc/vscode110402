/// Activate Wizard 
Class %Activate.UI.Wizard Extends %ZEN.Template.ObjectGatewayWizard.Template [ System = 4 ]
{

Parameter TEMPLATENAME = "Activate Wizard";

Parameter TEMPLATETITLE = "Activate Wizard";

Parameter TEMPLATEDESCRIPTION = "Activate Wizard";

Parameter HELPID = "BGAX_using_wizard";

/// Display title of this page <title></title>
Parameter PAGETITLE = "Activate Wizard";

Parameter PAGENAME = "Activate Wizard";

Property msgSelectRows As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Please select an object reference before clicking FINISH.")} ];

Property msgTooManyRows As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("You have selected more than 10 objects and this may take a long time to process. Are you sure you want to do this?")} ];

/// After user clicks the Finish button, the caption of button Finish becomes Exit,and isExit becomes 1.
/// If btnFinish is clicked when isExit = 1 then we exit out of the wizard.
Property isExit As %Boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css">
#table {
	height: 300px;
	overflow: auto;
	border: solid gray 1px;	
}

/* table */
table.tpTable {
	background: white;
	border: 1px solid black;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	width: 100%;
	font-size: 12px;
	
}

/* column header (th) */
table.tpTable th {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	background: #333399;
	color: white;
	font-weight: bold;
	text-align: center;
	padding: 2px;
}

/* selected column header (th) */
table.tpTable th.tpHdrSelected {
	background: #00A0EE;
}

table.tpTable td {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	padding: 1px;
}

table.tpTable tr.tpSelected td {
	border-top: 1px solid black;
	border-bottom: 2px solid black;
	padding-top: 1px;
	padding-bottom: 1px;
}

/* this is a normal, unselected row */
table.tpTable tr {
	color: black;
	white-space: nowrap;
	font-size: 0.8em;
}

/* this is a selected row */
table.tpTable tr.tpSelected {
	background: #FFFF80;
	color: black;
}

/* style for odd-rows when using zebra styling */
.tpOdd {
	background: white;
}

/* style for even-rows when using zebra styling */
.tpEven {
	background: #eeeeee;
}
.caption {
	color: black;
	font-size: 1.0em;
	font-weight: normal;
}
.labelSmall {
	color: black;
	font-size: 0.8em;
	font-weight: normal;
	text-decoration: none;
}
.hintText {
	color:gray;
	font-size:0.8em;	
}

</style>
}

/// This XML block defines the contents of the body pane of this Studio Template.
XData templateBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="body" cellStyle="padding-left:10px;">
<tabGroup id="tabGroup">
<tab>
<vgroup containerStyle="padding:20px;" label="This wizard will help you create Caché classes which provide you with access to COM Objects from within Caché." labelClass="caption" enclosingStyle="padding-top:20px;" labelPosition="left">
<text name="txtPackage" id="txtPackage" label="Enter package name:" labelStyle="font-size:0.9em;" value="Activate" hint="If left empty, default 'Activate' will be used." hintClass="hintText"/>
<spacer height="1"/>
<checkbox id="chkDetails" caption="Display details during processing" enclosingStyle="font-size:0.9em;"/>
</vgroup>
</tab>
<tab>
<label containerStyle="padding-top:20px;padding-bottom:10px;" label="Select object(s) from the list below then press FINISH to create Caché classes." labelClass="caption"/>
<tableNavigatorBar tablePaneId="table" showPageSize="true" showFilter="false" />
<tablePane id="table" caption="Available object references:"
	dataSource="columns"
	filtersDisabled="true"
	initialExecute="true"	
	multiSelect="true"
	maxRows="10000"
 	onselectrow="zenPage.rowSelected(zenThis);"
 	onmultiselect="zenPage.rowChecked(zenThis);"
 	pageSize="200"
	queryClass="%Activate.TLEnumerator"
	queryName="Enumerate"
	showZebra="true"
	showRowNumbers="false"
	showFilters="false"
	useKeys="true"
	useSnapshot="true"
	valueColumn="Path"
>
<column colName="Name" header="Name"/>
<column colName="Version" header="Version"/>
<column colName="Path" />
</tablePane>

<hidden id="NameSorted" value="0"/>
<fieldSet legend="Location" containerStyle="padding-top:6px;" cellStyle="padding:4px;">
<label id="idLocation" controlClass="labelSmall" />
</fieldSet>
<spacer height="2"/>
</tab>
<tab>
<vgroup id="idProcessing" containerStyle="padding:20px;">
<iframe id="iframe" width="650" height="380"/>
</vgroup>
</tab>
</tabGroup>
</pane>
}

/// This is called when the template is first displayed;
/// This provides a chance to set focus etc.
ClientMethod onstartHandler() [ Language = javascript ]
{
	// give focus to name
	var ctrl = zenPage.getComponentById('txtPackage');
	if (ctrl) {
		ctrl.focus();
	}
}

/// Return true if this template can go to the next page (i.e., enable
/// the Next button).<br>
ClientMethod canGoNext() [ Language = javascript ]
{
	var tabGroup = zenPage.getComponentById('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var flag = false;
	switch(tabNo) {
	case 1:
		flag = true;
		break;
	case 2:
		flag = false;
		break;
	}
	return flag;
}

/// Return true if this template can go to the previous page (i.e., enable
/// the Back button).<br>
/// This is implemented by subclasses.
ClientMethod canGoBack() [ Language = javascript ]
{
	var tabGroup = zenPage.getComponentById('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var flag = true;
	switch(tabNo) {
	case 1:
		flag = false;
		break;
	case 2:
		break;
	case 3:
		break;
	}	
	return flag
}

/// Return true if this template can Finish (i.e., enable
/// the Finish button).<br>
/// As long as you are on page 2+, Finish is enabled.
ClientMethod canFinish() [ Language = javascript ]
{
	var tabGroup = zenPage.getComponentById('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var flag = true;
	switch(tabNo) {
	case 1:
		flag = false;
		break;
	case 2:
		flag = this.hasSelected();
		if (flag == true) {
			zenPage.getComponentById("btnFinish").setProperty("caption",this.lblFinish);
			this.isExit = 0;
		}
		break;
	case 3:
		break;
		flag = false;
	}	
	zenPage.getComponentById("btnCancel").setDisabled(false);
	return flag
}

ClientMethod hasSelected() [ Language = javascript ]
{
	var selectedRows = this.getComponentById("table").selectedRows;
	var sel = selectedRows.split(",");
	var i;
	var found = false;
	for (i=0;i<sel.length;i++) {
		if (sel[i] != "") {
			found = true;
			break;
		}
	}
	return found
}

/// Set to true so btnNext and btnBack will show.
ClientMethod hasMultiplePages() [ Language = javascript ]
{
	return true;
}

/// User clicked the Finish button
ClientMethod finishTemplate() [ Language = javascript ]
{
	if (this.isExit == 1) {
		this.cancelTemplate();
		return;
	}
	var selectedRows = this.getComponentById("table").selectedRows;
	var sel = selectedRows.split(",");
	var i;
	var found = 0;
	for (i=0;i<sel.length;i++) {
		if (sel[i] != "") {
			++found;
		}
		if (found>10) break;
	}
	if (found == 0) {
		alert(this.msgSelectRows);
	} else {
		if (found > 10) {
			var ok = confirm(this.msgTooManyRows);
			if (ok == false) {
				return false;
			}
		}
		var package = zenPage.getComponentById("txtPackage").getValue();
		var details = zenPage.getComponentById("chkDetails").getValue();
		if (details) details = 1;
		else details = 0;
		if (this.CheckAllBlanks(package) == 1) package = "Activate";
		var ok = this.SetSelected(selectedRows,package,details)
		var iframe = zenPage.getComponentById('iframe');
		zenPage.getComponentById('tabGroup').showNextTab();
		iframe.setProperty("src","%25Activate.UI.WizardDone.cls");
		zenPage.getComponentById('btnFinish').setProperty("caption",this.lblExit);
		zenPage.getComponentById("btnCancel").setDisabled(true);
		this.isExit = 1;
	}
}

/// Go to the next page of the template.
ClientMethod nextPage() [ Language = javascript ]
{
	var tabGroup = zenPage.getComponentById('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	switch(tabNo) {
	case 1:
		if (zenPage.getComponentById('txtPackage') != null) {
			tabGroup.showNextTab();
			if (zenPage.getComponentById("NameSorted").getValue() == 0) {
				zenPage.getComponentById("table").headerClick('Name');
				zenPage.getComponentById("NameSorted").setValue(1);
			}
		} else {
			alert("Please enter a package name.");	
		}
		break;
	case 2:
		if (zenPage.getComponentById('table').getValue() != null) {
			tabGroup.showNextTab();
		}
		break;
	}
	zenPage.updateState();
}

/// Go to the previous page of the template.<br>
ClientMethod previousPage() [ Language = javascript ]
{
	var tabGroup = zenPage.getComponentById('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	switch(tabNo) {
	case 1:
		break;
	case 2:
		tabGroup.showPreviousTab();
		break;
	case 3:
		tabGroup.showPreviousTab();
		break;
	}
	zenPage.updateState();
}

/// User selected a row in the table. Show the location.
ClientMethod rowSelected(table) [ Language = javascript ]
{
	var path = table.getProperty('value');
	zenPage.getComponentById("idLocation").setValue(path);
}

/// User checked a checkbox in a row in the table. Show the location and update Finish button.
ClientMethod rowChecked(table) [ Language = javascript ]
{
	this.rowSelected(table);
	zenPage.updateState();
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Kill %session.Data("ActivateWizard","SelectedRows")
	If $G(%session.Data("ActivateWizard","PackageName")) '= "" Set ..%GetComponentById("txtPackage").value = %session.Data("ActivateWizard","PackageName")
	Set ..%GetComponentById("chkDetails").value = +$G(%session.Data("ActivateWizard","ShowDetails"))
	Set %session.Data("ActivateWizard","NAMESPACE") = $ZU(5)
	Quit $$$OK
}

/// Set the selected rows into %session data for the result page
/// Save the package and show details also.
Method SetSelected(selectedRows As %String, package As %String, details As %Boolean) As %Boolean [ ZenMethod ]
{
	Set %session.Data("ActivateWizard","SelectedRows") = $LISTFROMSTRING(selectedRows,",")
	Set %session.Data("ActivateWizard","PackageName") = package
	Set %session.Data("ActivateWizard","ShowDetails") = details
	Quit 1
}

ClassMethod CheckAllBlanks(string) As %Boolean [ ZenMethod ]
{
	Quit $ZStrip(string,"<>W")=""
}

/// Return false from this method to disable this template (for example based on the server platform)
ClassMethod IsEnabled() As %Boolean
{
	Quit $System.Activate.Available()
}

}
