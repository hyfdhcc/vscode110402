/// This dialog lets the user add or edit the Field List for a Listing.<br>
/// An existing list (delimited by comma) may be passed in.
Class %DeepSee.UI.Dialog.FieldList Extends %DeepSee.UI.Dialog.standardDialog [ System = 4 ]
{

Parameter APPLYBUTTON = 0;

/// Cube name.
Property cubeName As %ZEN.Datatype.string(ZENURL = "CUBE");

Property ELEMENT As %ZEN.Datatype.string(ZENURL = "ELEMENT");

Property Expression As %ZEN.Datatype.string(ZENURL = "VALUE");

Property WHAT As %ZEN.Datatype.string(ZENURL = "WHAT");

Property dataSource As %ZEN.Datatype.string(ZENURL = "DATASOURCE");

Property CONTEXT As %ZEN.Datatype.string(ZENURL = "CONTEXT");

XData Style
{
<style type="text/css">
</style>
}

/// Contents of the dialog body.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding-bottom:8px;">
<vgroup labelPosition="left">
<label id="cubeName" label="Cube name:" enclosingClass="zenLabel"/>
<label id="ELEMENT" label="Element name:" enclosingClass="zenLabel"/>
</vgroup>
<label id="titleText" label="Use the form below to create and maintain a Field List. Select a field by double clicking a property from the tree." enclosingStyle="padding:2px;"/>
<hgroup cellStyle="padding:4px;" cellVAlign="top">
<dynaTree id="dataSource"  label="Source Class"
 imageContracted="images/disclosure-contracted.gif"
 imageExpanded="images/disclosure-expanded.gif"
 imageNode="images/spacer.gif"
 childIndent="10"
 ondblclick="zenPage.selectProperty(zenThis);" dragEnabled="false"
	showLines="false" showFolders="false"
	OnGetTreeInfo="GetDataSourceInfo">
<parameter id="sourceP1" paramName="dataSource" value="#(%page.dataSource)#" />
</dynaTree>
<spacer width="5px"/>
<vgroup>
<listBox id="lstFields" label="Field List" width="350px" listHeight="250px" 
onchange="zenPage.selectedRow(zenThis);"/>
<spacer height="1"/>
<textarea id="txtField" label="Edit Field:" rows="5" cols="40"
dropEnabled="false" onkeyup="zenPage.doEdit(zenThis);"/>
<button id="btnUpdate" caption="Update" disabled="true" title="Button is enabled when field is modified." onclick="zenPage.doUpdate();"/>
</vgroup>

<vgroup id="idGroupButtons">
<image src="/csp/broker/images/spacer.gif" width="16" height="16"/>
<image src="deepsee/close_a_16.png" width="16" height="16" title="Remove the selected field" onclick="zenPage.doRemove();"/>
<image src="/csp/broker/images/spacer.gif" width="16" height="16"/>
<image src="deepsee/up_16.png" width="16" height="16" title="Move the selected field up" onclick="zenPage.moveItem('up');"/>
<image src="deepsee/down_16.png" width="16" height="16" title="Move the selected field down" onclick="zenPage.moveItem('dn');"/>
</vgroup>

</hgroup>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Set value = $$$TextHTML("Unknown")
	If ..WHAT = "ListingFieldList" Set value = $$$TextHTML("Listing - Field List")
	Else  If ..WHAT = "ListingOrderBy" Set value = $$$TextHTML("Listing - Order By")
	Else  If ..WHAT = "LevelDependsOn" Set value = $$$TextHTML("Level - Depends On")
	Quit value
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Set value = ""
	If (..WHAT = "ListingFieldList") { 
		If (..CONTEXT = "ListingGroupManager") {
			Set value = $$$TextHTML("Edit field list for this listing.")
		} Else {
			Set value = $$$TextHTML("Edit field list for Architect.")
		}
	} ElseIf (..WHAT = "ListingOrderBy") { 
		If (..CONTEXT = "ListingGroupManager") {
			Set value = $$$TextHTML("Edit order by for this listing.")
		} Else {
			Set value = $$$TextHTML("Edit order by for Architect.")
		}
	} ElseIf (..WHAT = "LevelDependsOn") {
		Set value = $$$TextHTML("Edit level depends on for Architect.")
	}
	Quit value
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	try {
		var values = "";
		var fieldObj = zen('lstFields');
		var len = fieldObj.getOptionCount();
		if (len > 0) values = fieldObj.getOptionText(0);
		for (var i=1; i<len; i++) {
			values = values + "," + fieldObj.getOptionValue(i);
		}
		return encodeURIComponent(values);
		}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return '';
}

/// User edited a field. Change background color and enable Update button.
ClientMethod doEdit(editObj) [ Language = javascript ]
{
	if (zen('lstFields').getValue() != editObj.getValue()) {
		zen('btnUpdate').setDisabled(false);
		editObj.setProperty('controlStyle','background:rgb(255,243,190);');
	}
}

/// User clicked the Remove image. Remove the field from Field List box.
ClientMethod doRemove() [ Language = javascript ]
{
	var fieldObj = zen('lstFields');
	var len = fieldObj.getOptionCount();
	if (len == 0) return;
	var idx = fieldObj.getProperty("selectedIndex");
	if (idx < 0) {
		alert($$$Text("Please select the field you want to remove and try again."));
		return;
	}
	fieldObj.removeOption(idx);
	zen("txtField").setValue("");
}

/// User clicked the Update button. Update the selected row with new value.
ClientMethod doUpdate() [ Language = javascript ]
{
	var fieldValue = zen('txtField').getValue();
	var fieldObj = zen('lstFields');
	var idx = fieldObj.getProperty("selectedIndex");
	fieldObj.setOption(idx,fieldValue,fieldValue);
	zen('btnUpdate').setDisabled(true);
	zen('txtField').setProperty('controlStyle','background:white;');
}

/// User clicked the Move Up/Down image. Move the field up or down one level in the Field List box. dir = "up" or "dn".
ClientMethod moveItem(dir) [ Language = javascript ]
{
	var fieldObj = zen('lstFields');
	var len = fieldObj.getOptionCount();
	if (len == 0) return;
	var idx = fieldObj.getProperty("selectedIndex");
	if (idx < 0) {
		alert($$$Text("Please select the field you want to move and try again."));
		return;
	}
	var row = idx;
	if (dir == "up") {
		row--;
	} else {
		row++;	
	}
	if (row >= 0) fieldObj.moveOption(idx,row);
}

/// User selected a property from the tree. Get the SQLName for the selected value and put it into the Field List box.
ClientMethod selectProperty(sourceObj) [ Language = javascript ]
{
	var propFullValue = sourceObj.getNodeValue(sourceObj.getProperty("selectedIndex"));
	var result = this.GetSQLNames(this.dataSource,propFullValue,this.WHAT);
	if (result.Error != "") {
		alert(result.Error);
		return;	
	}
	var fieldObj = zen('lstFields');
	fieldObj.appendOption(result.SQLNames,result.SQLNames);
}

/// User clicked a row from the list box. Put selected value into textarea box for editing.
ClientMethod selectedRow(fieldObj) [ Language = javascript ]
{
	var textObj = zen("txtField");
	textObj.setValue(fieldObj.getValue());
	textObj.setProperty('controlStyle','background:white;');
	zen('btnUpdate').setDisabled(true);
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = $$$OK
	Try {
		Set ..%GetComponentById("cubeName").value = ..cubeName
		Set ..%GetComponentById("ELEMENT").value = ..ELEMENT
		
		// If this was launched from the Listing Group Manager, look up the source class
		Set tCubeNameU = $$$UPPER(..cubeName)
		If (..CONTEXT="ListingGroupManager")&&(tCubeNameU'="") {
			Set ..dataSource = $G(^DeepSee.Cubes("cubes",tCubeNameU,"sourceClass"))
		}

		#; Load existing fields into list
		If ..Expression '= "" {
			Set tCombo = ..%GetComponentById("lstFields")
			Set tRow = 1
			Set tItem = $P(..Expression,",",1)
		 	While (tItem'="") {
				Set tOption = ##class(%ZEN.Auxiliary.option).%New()
				Do tCombo.options.Insert(tOption)
				Do ..%AddComponent(tOption)
				Set tOption.text = tItem
				Set tOption.value = tItem
				Set tRow = tRow + 1
		 		Set tItem = $P(..Expression,",",tRow)
		 	}			
		}
		Set tHelp = $$$Text("Select a field by double clicking a property from the tree.")
		If ..WHAT = "ListingOrderBy" {
			Set ..%GetComponentById("txtField").hidden = 1
			Set ..%GetComponentById("btnUpdate").hidden = 1
			Set ..%GetComponentById("titleText").label = $$$Text("Use the form below to create and maintain the Order by list. ")_tHelp
			Set ..%GetComponentById("lstFields").label = $$$Text("Order by")
		} ElseIf ..WHAT = "LevelDependsOn" {
			Set ..%GetComponentById("dataSource").label = $$$Text("Cube Levels")
			Set ..%GetComponentById("txtField").hidden = 1
			Set ..%GetComponentById("btnUpdate").hidden = 1
			Set ..%GetComponentById("titleText").label = $$$Text("Use the form below to create and maintain the Depends on. ")_tHelp
			Set ..%GetComponentById("lstFields").label = $$$Text("Depends on")			
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Provide contents of the data source tree.
ClassMethod GetDataSourceInfo(pRoot As %String, Output pTree, ByRef pParms) As %Status
{
	Set tSC = $$$OK
	If %page.WHAT = "LevelDependsOn",pRoot="" {
		Quit ..GetDependsOnInfo(pRoot, .pTree, .pParms)	
	}
	Set tDataSource = $G(pParms("dataSource"))
	If (tDataSource '= "") {
		If $$$comClassDefined(tDataSource) {
			Set tSC = ##class(%DeepSee.Utils).%GetDataSourceTree(tDataSource,.pTree,,,,pRoot)
		}
	}
	Quit tSC
}

ClassMethod GetDependsOnInfo(pRoot As %String, Output pTree, ByRef pParms) As %Status
{
     #; each node supplies: $LB(caption, value, hasChildren, link, expanded, icon, tooltip, style)
	Set tSC = $$$OK
	Do ##class(%DeepSee.Utils).%GetCubeLevels(%page.cubeName,.p,1,1)
	Set n = $O(p(""))
	While n '= "" {
		If $lg(p(n),1)="l" {
			Set p = "["_$lg(p(n),2)_"]"_"."_"["_$lg(p(n),3)_"]"_"."_"["_$lg(p(n),4)_"]"
			Set pTree(0,"ch",n) = ""
			Set pTree(n) = $LB(p,p,0,"",0,,p)
		}
		Set n = $O(p(n)) 
	}
	Quit tSC
}

/// Get SQL Names from property name. Similar logic as in IsDate of Architect.
ClassMethod GetSQLNames(sourceClass As %String, fullName As %String, WHAT As %String) As %ZEN.proxyObject [ ZenMethod ]
{
	Try {
		Set proxy = ##class(%ZEN.proxyObject).%New()
		Set proxy.Error = ""
		Set proxy.SQLNames = ""
		Set cnt = 1
		Set prop = $P(fullName,".",cnt)
		Set tLen = $L(fullName,".")
		While prop '= "" {
			Set tStatus = ..GetPropName(sourceClass, prop, .propNames)
			If tStatus '= "" {
				Set proxy.Error = tStatus
				Set prop = ""
				Quit
			}
			Set name = $O(propNames(""))
			If name '[ "%Library",##class(%Dictionary.CompiledClass).%ExistsId(name) {
				Set source = name
			} Else {
				Set source = sourceClass	
			}
			#; JMD1500 find type of class
			Set tSourceType = "persistent"
			If $classmethod(source,"%IsA","%Library.SerialObject") {
				Set tSourceType = "serial"
			}

			Set tSQL = ##class(%DeepSee.Utils).%GetSQLColumnName(source,prop)
			#; if SQL name does not exists then use property name.
			#; JMD1500 use correct seperator
			If (WHAT = "LevelDependsOn") {
				Set tSep = "."
			}
			ElseIf (tSourceType = "serial") {
				Set tSep = "_"
			}
			Else {
				Set tSep = "->"
			}
			Set proxy.SQLNames = proxy.SQLNames _ $S(tSQL'="":tSQL,1:prop) _ $S(cnt<tLen:tSep,1:"")
			Set cnt = cnt + 1
			Set prop = $P(fullName,".",cnt)
		}
		If proxy.SQLNames = "" Set proxy.SQLNames = ##class(%DeepSee.Utils).%GetSQLColumnName(sourceClass,fullName)
		If proxy.SQLNames = "" Set proxy.SQLNames = fullName
	}
	Catch(ex) {
		Set proxy.Error = $$$Text("Error occurred in GetSQLNames: ")_$ZCVT(ex.AsStatus(),"O","JS")
	}
	Quit proxy
}

ClassMethod GetPropName(sourceClass, property, Output propNames) As %String
{
	Set Status = ""
	Set property = $TR(property,"[]","")
	Kill propNames
	&sql(declare NNN cursor for 
		select c.name 
		from %Dictionary.CompiledClass c, %Dictionary.CompiledProperty p 
		where p.parent = :sourceClass and p.name = :property and c.name = p.type
	)
	&sql(open NNN)
	If SQLCODE<0 set Status = "SQLCODE: "_SQLCODE
	For {
		&sql(fetch NNN into :name)
		Quit:SQLCODE
		Set propNames(name) = ""
	}
	If SQLCODE<0 set Status = $S(Status'="":Status _ ", ",1:"")_SQLCODE
	&sql(close NNN)
	QUIT Status
}

}
