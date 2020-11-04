/// System Management Portal - SQL Tuen Table page.
Class %CSP.UI.Portal.SQL.TuneTable Extends (%CSP.UI.Template.Property, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "SQL Tune Table";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Development";

Property SCHEMANAME As %String(ZENURL = "SCHEMANAME");

Property TABLENAME As %String(ZENURL = "TABLENAME");

/// Current extent size when the page is loaded. Used to compare with the textbox value.
Property CurrentSize As %Integer;

Property lblCurrentTableSize As %ZEN.Datatype.string [ InitialExpression = {$$$TextHTML("Current Table Extentsize: ")} ];

Property IsTuned As %Boolean [ InitialExpression = 0 ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
.ribbonTitle {
	background: #D2CFDF;
}
.note {
	color: rgb(218,72,72);	
}

/* custom font size for tableNavigatorBar */
.tnbrPagingButtons {
	font-size: 10px;
}
.tnbrFound {
	font-size: 10px;
}
/* @doc="Filter and page size control." */
.tnbrFilter {
	font-size: 10px;
}
.detailLabel {
	margin: 2px;
}

</style>
}

XData SVGStyle
{
<style type="text/css">
.tabBarBackground { fill:white; stroke:white; }	
</style>
}

/// Contents of this page:
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" 
	width="100%" height="100%"
	title="#(%page.StdTitle)#"
>
<group layout="none">

<html id="htmlTitle" OnDrawContent="DrawSQLTitle"/>

</group>

<group width="100%" valign="top">
<pane paneName="contentPane" width="100%"/>
</group>

</page>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:10px;">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true"/>
<button caption="Close" controlClass="commandButton" title="Exit this dialog" onclick="zenPage.doClose();" valign="bottom"/>

<hgroup valign="top">
<vgroup id="editorPane" valign="top" >
<svgFrame id="svgTabArea" height="32" layout="none" backgroundStyle="fill:white; stroke-width:2; border:none;">
<tabBar id="tabBar" tabCaptions=":Selectivity:Map BlockCount"
 onChange="zenPage.tabChanged(index);"/>
</svgFrame>
<vgroup id="page_1" hidden="false" enclosingStyle="padding:10px;">
<hgroup labelPosition="left" enclosingStyle="padding-top:10px;">
<label id="expTableSize"/>
<link id="linkOptions" caption="edit" title="edit the table extentsize" href="javascript:zenPage.toggleOptions();" />
<spacer width="2"/>
<hgroup id="idExtentSize" labelPosition="left" hidden="true" containerStyle="border:1px dashed rgb(67,67,67);">
<text id="txtExtentSize" label="Enter my own Table Extentsize:" title="Tune Table will calculate if left alone." labelStyle="padding-left:4px;" size="6"/>
<button id="btnSaveExtentSize" caption="Save" onclick="zenPage.doSaveTableSize();"/>
</hgroup>
<button id="btnTuneTable" caption="Tune Table" controlClass="commandButton" onclick="zenPage.doTuneTable();" valign="bottom"/>
</hgroup>
<vgroup labelPosition="left" enclosingStyle="padding-top:6px;padding-bottom:10px;">
<checkbox id="chkKeepClassUpToDate" label="Keep class up to date:" />
</vgroup>
<hgroup valign="top" labelPosition="left">
<tableNavBar showPageSize="true" showMaxRows="true" tablePaneId="table1"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value,'table1');" onMaxRowsChange="zenPage.navMaxRowsChanged(value,'table1');"
/>
</hgroup>
<tablePane id="table1"
queryClass="%SQL.Manager.Catalog" 
queryName="FieldCurrentSelectivity"
fixedHeaders="false"
maxRows="1000"
multiSelect="false"
onselectrow="zenPage.doSelectRow(1);"
OnExecuteResultSet="ExecuteRS"
pageSize="20"
showZebra="true"
useSnapshot="true"
valign="top"
valueColumn="FIELD_NAME"
>
<column colName="FIELD_NAME" header="Field Name" title="Click a row to edit selectivity"/>
<column colName="NOTES" header="Notes"/>
<column colName="SELECTIVITY" header="Selectivity"/>
<column colName="OUTLIER_SELECTIVITY" header="Outlier Selectivity" />
<column colName="OUTLIER_VALUE" header="Outlier Value" />
<column colName="AVERAGE_FIELD_SIZE" header="Average Field Size" />
<parameter value=""/>
<parameter value=""/>
</tablePane>
</vgroup>
<vgroup id="page_2" hidden="true" enclosingStyle="padding:10px;">
<hgroup valign="top" labelPosition="left" cellStyle="padding:2px;">
<tableNavBar showPageSize="true" showMaxRows="true" tablePaneId="table2"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value,'table2');" onMaxRowsChange="zenPage.navMaxRowsChanged(value,'table2');"
/>
</hgroup>
<tablePane id="table2"
queryClass="%SQL.Manager.Catalog" 
queryName="MapBlockCount"
fixedHeaders="false"
maxRows="1000"
multiSelect="false"
onselectrow="zenPage.doSelectRow(2);"
OnExecuteResultSet="ExecuteRS"
pageSize="20"
showZebra="true"
useSnapshot="true"
valign="top"
valueColumn="SQL_MAP_NAME"
>
<column colName="SQL_MAP_NAME" header="SQL Map Name"/>
<column colName="BLOCK_COUNT" header="BlockCount"/>
<column colName="BLOCK_COUNT_TYPE" header="Source of BlockCount"/>
<parameter value=""/>
<parameter value=""/>
</tablePane>
</vgroup>
</vgroup>
<spacer width="2"/>
<vgroup id="propertyPane" valign="top">
<html id="propertyTitle"></html>
<tabGroup id="propertyTabs" showTabBar="true">
<tab id="tabDetails" caption="Details">
<spacer height="3"/>
<vgroup id="defaultDetails" label="Select an item to view details"/>
<html id="htmlPropertyTitle" OnDrawContent="DrawPropertyTitle" seed=""></html>

<vgroup id="propertyForm1" cellStyle="padding:4px 10px 4px 10px;" hidden="true">
<hgroup align="center">
<button id="btnSave1" caption="Save" title="Save changes" controlClass="commandButton" onclick="zenPage.doSave('1');"/>
</hgroup>
<text id="txtItemSelectivity" label="Selectivity" hint="Enter a selectivity value"/>
<text id="txtItemOutSelectivity" label="Outlier Selectivity" hint="Enter a percentage from > 0 though 99.999%"/>
<text id="txtItemOutValue" label="Outlier Value" hint="Enter a datavalue - use double quotes for a string"/>
<text id="txtItemAverageFieldSize" label="Average Field Size" hint="Enter the average field size for this field's data"/>
</vgroup>

<vgroup id="propertyForm2" cellStyle="padding:4px 10px 4px 10px" hidden="true">
<hgroup align="center">
<button id="btnSave2" caption="Save" title="Save changes" controlClass="commandButton" onclick="zenPage.doSave('2');"/>
</hgroup>
<text id="txtItemBlockCount" label="BlockCount" hint="Enter a number greater than or equal to 1 or leave it empty for Tune Table to calculate it."/>
</vgroup>

</tab>
</tabGroup>
</vgroup>
</hgroup>
</pane>
}

ClientMethod doSelectRow(option) [ Language = javascript ]
{
	this.resetMsg();
	try {
		var table = zen("table"+option);
		var selectedIndex = table.getProperty("selectedIndex");
		if (selectedIndex == -1) return;
		var itemId = table.getValue();
		zen("propertyForm"+option).setHidden(false);
		var html = zen("htmlPropertyTitle");
		html.setProperty('seed',itemId);

		var rowData = table.getRowData(selectedIndex);
		if (!rowData) return;
		if (option == 1) {
			zen("txtItemSelectivity").setValue(rowData["SELECTIVITY"]);
			zen("txtItemOutSelectivity").setValue(rowData["OUTLIER_SELECTIVITY"]);
			zen("txtItemOutValue").setValue(rowData["OUTLIER_VALUE"]);
			zen("txtItemAverageFieldSize").setValue(rowData["AVERAGE_FIELD_SIZE"]);
		} else {
			zen("txtItemBlockCount").setValue(rowData["BLOCK_COUNT"]);
		}
	} catch(ex) {
		zenExceptionHandler(ex,arguments,'Error');
	}
}

ClientMethod doTuneTable() [ Language = javascript ]
{
	this.resetMsg();
	this.clearForm();
	var LastSize = zen("txtExtentSize").getValue();
	var keep = zen("chkKeepClassUpToDate").getValue() ? 1 : 0;
	var proxy = this.SetSelValues(this.CurrentSize,LastSize,keep,this.SCHEMANAME,this.TABLENAME);
	if (proxy.ErrorMessage.length > 0) {
		this.showMsg(proxy.ErrorMessage,1);	
	}
	var table = zen("table1");
	table.executeQuery(0);
	var table = zen("table2");
	table.executeQuery(0);
	if (LastSize != proxy.ExtentSize) {
		zen("txtExtentSize").setValue(proxy.ExtentSize);
		zen("expTableSize").setProperty("label",this.lblCurrentTableSize + proxy.ExtentSize);
	}
	this.IsTuned = 1;
}

ClientMethod doSave(option) [ Language = javascript ]
{
	this.resetMsg();
	var table = zen("table"+option);
	var selectedIndex = table.getProperty("selectedIndex");
	if (selectedIndex == -1) return;
	var itemId = table.getValue();
	var ok = "";
	var keep = zen("chkKeepClassUpToDate").getValue() ? 1 : 0;
	switch(option) {
		case '1':
			var selectivity = zen("txtItemSelectivity").getValue();
			var outSelectivity = zen("txtItemOutSelectivity").getValue();
			var outValue = zen("txtItemOutValue").getValue();
			var outAverageFieldSize = zen("txtItemAverageFieldSize").getValue();
			var ok = this.SaveData(this.SCHEMANAME, this.TABLENAME, keep, itemId, selectivity, outSelectivity, outValue, outAverageFieldSize);
			this.IsTuned = 1;
			break;
		case '2':
			var blockCount = zen("txtItemBlockCount").getValue();
			var pass = true;
			if (blockCount!=""&&!this.validateRequired(zen('txtItemBlockCount'),pass,"N",true,1)) pass = false;
			if (!pass) return;
			var ok = this.SaveMap(this.SCHEMANAME, this.TABLENAME, keep, itemId, blockCount);
			this.IsTuned = 1;
			break;
	}
	if (ok != 1) {
		this.showMsg(ok,1);	
	} else {
		// do not clear the previous selection so if user wants to change the number again they don't 
		// have to click the row again.
		//table.setProperty("selectedIndex",-1);
		table.executeQuery(0);
		return;	
	}
}

ClientMethod doSaveTableSize() [ Language = javascript ]
{
	this.resetMsg();
	var tableSize = zen("txtExtentSize").getValue();
	var keep = zen("chkKeepClassUpToDate").getValue() ? 1 : 0;
	var ok = this.SaveTableSize(this.SCHEMANAME, this.TABLENAME, tableSize, keep);
	if (ok != 1) {
		this.showMsg(ok,1);	
	} else {
		// update the Current Table Extentsize
		zen("expTableSize").setProperty("label",this.lblCurrentTableSize + tableSize);
	}
}

ClientMethod doClose() [ Language = javascript ]
{
            if (!this.IsTuned) {
                        zenPage.cancelPopup();
            } else {
                        this.firePopupAction('ok',1);
            }
}

/// Clear form 
ClientMethod clearForm() [ Language = javascript ]
{
	zen("table1").setProperty("selectedIndex",-1);
	zen("txtItemSelectivity").setValue('');
	zen("txtItemOutSelectivity").setValue('');
	zen("txtItemOutValue").setValue('');
	zen("txtItemAverageFieldSize").setValue('');
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {		
		if (this.SCHEMANAME == "") return;
		this.adjustSizes();				
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler');
	}
}

ClientMethod tabChanged(index) [ Language = javascript ]
{
	this.resetMsg();
	var option;
	for ( var i=0; i<2; i++ ) {
		option = i + 1;
		if ( i == index ) {
			var table = zen("table"+option);
			var selectedItem = table.getValue();
			// if user has not selected any item from the table then do not show propertyForm yet.
			zen("propertyForm"+option).setHidden(selectedItem>-1);
			// show table under selected tab now
			zen("page_"+option).setHidden(false);
			// display selected item name as propertyForm title
			var html = zen("htmlPropertyTitle");
			html.seed = selectedItem;
			html.refreshContents();
		} else {
			// hide other tabs and propertyForm
			zen("page_"+option).setHidden(true);
			zen("propertyForm"+option).setHidden(true);
		}				
	}
}

/// Show or hide Edit Table Extentsize fields.
ClientMethod toggleOptions() [ Language = javascript ]
{
	var group = zen("idExtentSize");
	var newOption = !group.getProperty("hidden");
	group.setHidden(newOption);
}

ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var propDiv = zen('propertyPane').getEnclosingDiv();
		var editDiv = zen('editorPane').getEnclosingDiv();

		propDiv.style.display = 'block';

		propWidth = (winWidth<900) ? 250 : 280;
		var editorWid = winWidth - propDiv.offsetWidth - 15;
		editorWid = Math.max(editorWid,100);
		propDiv.style.width = propWidth + 'px';
		editDiv.style.width = editorWid + 'px';
		
		var propHeight = winHeight - 180;
		propHeight = Math.max(propHeight,100);
		propDiv.style.height = propHeight + 'px';

		var tabBodyHgt = winHeight - 220;
		tabBodyHgt = (tabBodyHgt < 1 ? 1 : tabBodyHgt);
		zen('propertyTabs').setBodySize(tabBodyHgt,propDiv.offsetWidth-2);

		zen("svgTabArea").setProperty("width",editorWid-2);
		zen("tabBar").setProperty("width",editorWid-2);
		
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Set tPageName = ..%GetPageName()
	For n = 1,2 Do ..%GetNavTableState(tPageName_"^table"_n)
	
	Set ..%GetComponentById("Text1").value = $$$TextHTML("Tune Table is a utility that examines the data in a table and returns information about the ExtentSize (the number of rows in the table) and the Selectivity of each field (the percentage of rows returned for a given value). It also generates the BlockCount for each SQL map.")
	Set %page.CurrentSize = ##class(%SQL.Manager.Catalog).GetCurrentTableExtentSize(%page.SCHEMANAME,%page.TABLENAME)
	Set ..%GetComponentById("txtExtentSize").value = %page.CurrentSize
	Set ..%GetComponentById("expTableSize").label = %page.lblCurrentTableSize _ %page.CurrentSize
	Quit $$$OK
}

Method DrawSQLTitle(pSeed) As %Status
{
	Set tDict = "<h2>"_$zconvert(%page.SCHEMANAME,"O","HTML")_"."_$zconvert(%page.TABLENAME,"O","HTML")_"</h2>"
	Set tNamespace = $$$TextHTML("Namespace: ")_..EscapeHTML($zu(5))
	Set tImg = ..Link("/csp/broker/portal/sql_query_48.gif")
	Set tTitle = $$$TextHTML("Tune Table")
	&html<<table width="100%" border="0" cellspacing="2">
	<tr><td>&nbsp;&nbsp;<img id="imgLogo" src="#(tImg)#" height="70"/></td>
	<td><div width=10/>&nbsp;&nbsp;</td>
	<td width="40%">#(tDict)#</td><td>#(tNamespace)#</td>
	<td class="ribbonTitle" style="height:70px;width:250px;">&nbsp;&nbsp;<nobr>#(tTitle)#</nobr>&nbsp;&nbsp;</td>
	</tr>
	<tr>
	<td colspan="6"><div style="border-top:1px solid black;">&nbsp;</div></td>
	</tr>
	</table>>
	Quit $$$OK
}

/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("SQL Tune Table")
}

ClassMethod SaveData(SchemaName, TableName, KeepClassUpToDate, field, selectivity, outSelectivity, outValue, AverageFieldSize) As %String [ ZenMethod ]
{
	Set tSC = ##Class(%SQL.Manager.Catalog).SetFieldSelectivity(SchemaName, TableName, field, selectivity, KeepClassUpToDate, outSelectivity, outValue, AverageFieldSize)	
	If $$$ISERR(tSC) Set tSC = $$$HTMLErrorMsg(tSC)
	Quit tSC
}

ClassMethod SaveMap(SchemaName, TableName, KeepClassUpToDate, field, blockCount) As %String [ ZenMethod ]
{
	Set tSC = ##Class(%SQL.Manager.Catalog).SetMapBlockCount(SchemaName, TableName, field, blockCount, KeepClassUpToDate)				
	If $$$ISERR(tSC) Set tSC = $$$HTMLErrorMsg(tSC)
	Quit tSC
}

/// Method for executing the process query.
Method ExecuteRS(pRS As %Library.ResultSet, Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %Boolean
{
	Set tSC = pRS.Execute(%page.SCHEMANAME,%page.TABLENAME) 
	Quit tSC
}

/// User clicked Tune Table button. Now calculate table extentsize and selectivity and save.
ClassMethod SetSelValues(CurrentSize, ExtentSize, KeepClassUpToDate, SCHEMANAME, TABLENAME) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""
	Set tProxy.ExtentSize = ExtentSize
	Set NewExtentSize = ExtentSize
	If CurrentSize = ExtentSize {
		Set NewExtentSize = ##Class(%SQL.Manager.Catalog).GetCalcTableExtentSize(SCHEMANAME, TABLENAME)
			// If NewExtentSize=0, there is no data in the table, don't bother computing SELECTIVITY or MapBlockCounts
		if NewExtentSize=0 {
			set tProxy.ErrorMessage = "Table "_SCHEMANAME_"."_TABLENAME_" has no data, no tuning will be performed"
			Quit tProxy
		}
			//Update table extentsize
    		Set tSC = ##Class(%SQL.Manager.Catalog).SetTableExtentSize(SCHEMANAME, TABLENAME, NewExtentSize, KeepClassUpToDate)
		If $$$ISERR(tSC) {
			Set tProxy.ErrorMessage = $$$HTMLErrorMsg(tSC)
		} 
		Else {
			Set tProxy.ExtentSize = NewExtentSize	
		}
	}	
	Set Result = ##class(%ResultSet).%New("%SQL.Manager.Catalog:FieldCalcSelectivity")
	Set tSC = Result.Execute(SCHEMANAME,TABLENAME)
	While Result.Next() {
		Set field = Result.Get("FIELD_NAME")
		Set selectivity = Result.Get("SELECTIVITY")
		Set outselectivity = Result.Get("OUTLIER_SELECTIVITY")
		Set outvalue = Result.Get("OUTLIER_VALUE")
		Set averagefieldsize = Result.Get("AVERAGE_FIELD_SIZE")
		#; When FieldCalcSelectivity is used, it is calculated but not saved into definition. Now we save it.
   		Set tSC = ##Class(%SQL.Manager.Catalog).SetFieldSelectivity(SCHEMANAME, TABLENAME, field, selectivity, KeepClassUpToDate, outselectivity, outvalue, averagefieldsize)
		If $$$ISERR(tSC) {
			Set tProxy.ErrorMessage = tProxy.ErrorMessage _ $S(tProxy.ErrorMessage'="":"<br/>",1:"") _ $$$HTMLErrorMsg(tSC)
		}
	}
		#; Now compute/store Map BlockCounts
	set tExtent=$$$GetExtentNameFromTableName(SCHEMANAME,TABLENAME)
	set tSC=$$ComputeMapBlocks^%qarTune(tExtent,KeepClassUpToDate,1,0,"",0,)
	If $$$ISERR(tSC) {
		Set tProxy.ErrorMessage = tProxy.ErrorMessage _ $S(tProxy.ErrorMessage'="":"<br/>",1:"") _ $$$HTMLErrorMsg(tSC)
	}
	Set EventDesc = "Tune Table"
	Set EventData = SCHEMANAME _ "."_TABLENAME
	$$$SMPAuditChange
	Quit tProxy
}

/// This is called when user clicks Save for Table Extentsize they edited.
ClassMethod SaveTableSize(SCHEMANAME, TABLENAME, ExtentSize, KeepClassUpToDate) As %String [ ZenMethod ]
{
	Try {
		Set tSC = ##Class(%SQL.Manager.Catalog).SetTableExtentSize(SCHEMANAME, TABLENAME, ExtentSize, KeepClassUpToDate)
		If $$$ISERR(tSC) Set tSC = $$$HTMLErrorMsg(tSC)	
	}
	Catch(ex) {
		Set tSC = $$$TextHTML("Save table extentsize failed.")
	}
	Quit tSC
}

Method DrawPropertyTitle(pPropertyForm) As %Status
{
	If pPropertyForm = "" Quit $$$OK
	&html<<center><div class="detailLabel">#(..EscapeHTML(pPropertyForm))#</div></center>>
	Quit $$$OK
}

/// Overriden to add tabId and tableId to the page name to distinguish the type for the page.
ClientMethod navPageSizeChanged(value, tableId) [ Language = javascript ]
{
	this.TablePageSize = value;
	this.UpdateTableNavState(this.Filter,value,this.TableMaxRows,tableId);
}

/// Overriden to add tabId and tableId to the page name to distinguish the type for the page.
ClientMethod navMaxRowsChanged(value, tableId) [ Language = javascript ]
{
	this.TableMaxRows = value;
	this.UpdateTableNavState(this.Filter,this.TablePageSize,value,tableId);
}

/// Used to Save tableNavBar values, add MapType to the page name to distinguish the type for the page.
ClassMethod UpdateTableNavState(pFilter As %String, pPageSize As %Integer, pMaxRows As %Integer, ptableId As %String) [ ZenMethod ]
{
	Set $$$CacheTempMgt($Username,..%GetPageName()_"^"_ptableId,"TableNavState") = $lb(pFilter,pPageSize,pMaxRows)
}

}
