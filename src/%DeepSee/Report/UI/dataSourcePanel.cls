/// %DeepSee.Report.UI.dataSourcePanel
Class %DeepSee.Report.UI.dataSourcePanel Extends %ZEN.Component.composite [ System = 4 ]
{

Property enclosingClass As %ZEN.Datatype.cssClass [ InitialExpression = "zruDataSource" ];

/// The nominal title for this pane
Property title As %ZEN.Datatype.caption [ InitialExpression = "Data Source" ];

/// The nominal command for changing data sources
Property msgChange As %ZEN.Datatype.caption [ InitialExpression = "Change" ];

/// The default tool tip for the change source command
Property hlpChange As %ZEN.Datatype.caption [ InitialExpression = "Change the data source for this report" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.zruDataSource {
	position:relative;
	left:0px; top:0px;
	width:180px;
	height:100%;
	background: #ffffff;
	font: 12px Arial;
	color: #000077;	
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="zruDataSource" >
<html id="header"  enclosingClass="zruHeaderDiv"/>
<dynaTree id="dataSourceTree" 
	imageContracted="images/arrow1R.gif"
	imageExpanded="images/arrow1D.gif"
	ondblclick="zenThis.composite.treeDoubleClick(zenThis);"
	imageNode=""
	showLines="false" showFolders="false" dragEnabled="true"
	OnGetTreeInfo="GetDataSourceInfo">
<parameter id="sourceP1" paramName="dataSource" value="#(%page.dataSource)#" />

</dynaTree>
</composite>
}

/// Provide contents of the data source tree.
ClassMethod GetDataSourceInfo(pRoot As %String, Output pTree, ByRef pParms) As %Status
{
	Set tSC = $$$OK
	Set tDataSource = $G(pParms("dataSource"))
	;# NEED TO SPLIT THINGS HERE TO SEE IF WE WANT QUERY BASED OR FIELD BASED 
	;# SET MANAGEMENT
	
	If (tDataSource '= "") {
		If $$$comClassDefined(tDataSource) {
	;# TODO CHANGE TO USE LOCAL %GetDataSourceTree() to pick up data types as well
	;#		Set tSC = ##class(%DeepSee.Utils).%GetDataSourceTree(tDataSource,.pTree,,,,pRoot)
			Set tSC = ..%GetDataSourceTree(tDataSource,.pTree,,,,pRoot)
		}
	}
	Quit tSC
}

/// Return the properties of a cube data source in a format that can be consumed
/// by a Zen dynaTree control.<br/>
/// <var>pRoot</var> is used to specify that an incremental load of children is requested; if provided it is the spec of a parent node.<br/>
ClassMethod %GetDataSourceTree(pClass As %String, Output pTree, ByRef pParms, pLevel As %Integer = 0, pParentRef As %String = "", pRoot As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		If (pClass = "") {
			If (pLevel = 0) {
				Set n = $I(pTree)
				Set pTree(n) = $LB($$$Text("No Data Source","%DeepSee"),"",0,,,,,"color:red;")
				Set pTree(0,"ch",n) = ""
			}
			Quit
		}

		// special case: test for worksheets and kpis
		Set tExt = $P(pClass,".",$L(pClass,"."))
		If ((tExt="kpi")||(tExt="metric")||(tExt="worksheet")) {
			If (tExt="kpi") {
				Set tName = $P(pClass,".",1,$L(pClass,".")-1)
				Set tKPIClass = ##class(%DeepSee.Utils).%GetKPIClass(tName)
				Set tName = ""
			}
			ElseIf (tExt="worksheet") {
				Set tName = pClass
				Set tKPIClass = "%DeepSee.KPIWorksheet"
			}
			Else {
				Set tName = pClass
				Set tKPIClass = "Ens.BusinessMetricKPI"
			}

			New %datacontroller
			Set tCriteria = ##class(%ZEN.proxyObject).%New()
			Set tSC = ##class(%DeepSee.AbstractKPI).%CreateLocalController(.tController,tKPIClass,tName,tCriteria)
			If $$$ISERR(tSC) Quit
			Set %datacontroller = tController

			Set tSC = tController.%GetModelPropertyInfo(.tPropInfo)
			If $$$ISERR(tSC) Quit

			// sort prop info; remove % properties
			Set tProp = $O(tPropInfo(""))
			While (tProp'="") {
				If (tProp '[ "%") {
					Set tInfo(tPropInfo(tProp)) = tProp
				}
				Set tProp = $O(tPropInfo(tProp))
			}

			Set k = $O(tInfo(""))
			While (k'="") {
				Set n = $I(pTree)
				Set tName = tInfo(k)
				Set tDisplayName = tName
				Set pTree(n) = $LB(tDisplayName,tName)
				Set pTree(0,"ch",n) = ""
				Set k = $O(tInfo(k))
			}
			Quit
		}

		If '$$$defClassDefined(pClass) {
			If (pLevel = 0) {
				Set n = $I(pTree)
				Set pTree(n) = $LB($$$FormatText($$$Text("Class not found '%1'","%DeepSee"),pClass),"",0,,,,,"color:red;")
				Set pTree(0,"ch",n) = ""
			}
			Else {
				Set tSC = $$$ERROR($$$GeneralError,"Class not found: "_pClass)
			}
			Quit
		}
		If '$$$comClassDefined(pClass) {
			If (pLevel = 0) {
				Set n = $I(pTree)
				Set pTree(n) = $LB($$$FormatText($$$Text("Class not compiled '%1'","%DeepSee"),pClass),"",0,,,,,"color:red;")
				Set pTree(0,"ch",n) = ""
			}
			Else {
				Set tSC = $$$ERROR($$$GeneralError,"Class not compiled:"_pClass)
			}
			Quit
		}

		If (pRoot '= "") {
			// incremental load of children
			// follow chain in pRoot
			Set tPropName = ""
			Set tType = pClass
			For p=1:1:$L(pRoot,".") {
				Set tPropName = $P(pRoot,".",p)
				Set tType = $$$comMemberKeyGet(tType,$$$cCLASSproperty,tPropName,$$$cPROPtype)
			}
			Set tRef = pParentRef _ $S(pParentRef="":"",1:".") _ pRoot
			Set tSC = ..%GetDataSourceTree(tType, .pTree, .pParms, pLevel + 1,tRef)
			If $$$ISERR(tSC) Quit
			Quit
		}
		
		Set tClsType = $$$getClassType(pClass)
		Set tTopNode = ""
		Set tTopHasChildren = 0
		If (pLevel = 0) {
			// Add class to top of tree

			// check type of class
			If (tClsType '= "persistent") {
				// see if this is a DataConnector
				If ('$zobjclassmethod(pClass,"%IsA","%DeepSee.DataConnector")) {
					Set n = $I(pTree)
					Set pTree(n) = $LB($$$FormatText($$$Text("Data source must be persistent: '%1'","%DeepSee"),pClass),"",0,,,,,"color:red;")
					Set pTree(0,"ch",n) = ""
					Quit
				}
				Else {
					// Ask data connector for list of properties
					Set tSC = $zobjclassmethod(pClass,"%GetPropertyInfo",.tPropInfo)
					If $$$ISERR(tSC) Quit

					Set k = $O(tPropInfo(""))
					While (k'="") {
						Set n = $I(pTree)
						Set tName = $LG(tPropInfo(k),1)
						Set tDisplayName = $LG(tPropInfo(k),2)
						Set pTree(n) = $LB(tDisplayName,tName)
						Set pTree(0,"ch",n) = ""
						Set k = $O(tPropInfo(k))
					}

					Quit
				}
			}

			Set n = $I(pTree)
			Set tTopNode = n
			Set tExpanded = 1
			Set pTree(n) = $LB(pClass,"",tTopHasChildren,,tExpanded)
			Set pTree(0,"ch",n) = ""
		}

		Set tRootNo = +$G(pTree)
		If (tClsType = "persistent") {
			// Add %ID to list of properties
			Set n = $I(pTree)
			Set tRef = pParentRef _ $S(pParentRef="":"",1:".") _ "%ID"
			Set pTree(n) = $LB("%ID",tRef,0,,,,"%ID::ID") 
			Set pTree(tRootNo,"ch",n) = ""
			Set tTopHasChildren = 1
		}

		Set tRS = ##class(%ResultSet).%New("%Dictionary.CompiledClass.MemberSummary")
		Set tSC = tRS.%Execute(pClass,"a")
		While (tRS.Next()) {
			Set tPropName = tRS.Data("Name")
			// Get info on the property
			Set tType = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tPropName,$$$cPROPtype)
			Set tPrivate = +$$$comMemberKeyGet(pClass,$$$cCLASSproperty,tPropName,$$$cPROPprivate)
			Set tTransient = +$$$comMemberKeyGet(pClass,$$$cCLASSproperty,tPropName,$$$cPROPtransient)
			
			// Not found in DS.Utils version...
			Set tMulti = +$$$comMemberKeyGet(pClass,$$$cCLASSproperty,tPropName,$$$cPROPmultidimensional)
			$$$comMemberKeyGetLvar(tCollection,pClass,$$$cCLASSproperty,tPropName,$$$cPROPcollection)
			$$$comMemberKeyGetLvar(tSQLName,pClass,$$$cCLASSproperty,tPropName,$$$cPROPsqlfieldname)

			If (('tPrivate)&&('tTransient)&&('tMulti)&&(tCollection="")) {
				Set tClsType = $$$getClassType(tType)
				Set tRef = pParentRef _ $S(pParentRef="":"",1:".") _ tPropName
				// NOT FOUND IN DS Utils...
				Set tDispName = tPropName
				Set tSQLRef = tRef
				if (tSQLName'= "") { // Modification to use SQL name when available
					Set tSQLRef = pParentRef _ $S(pParentRef="":"",1:".") _ tSQLName
					Set tDispName = tSQLName
				}
				// ENF
				Set n = $I(pTree)
		#;		Set pTree(n) = $LB(tPropName,tRef,0) // This was the original
				If (tClsType = "persistent") {
					Set tType = "@"_tType
				}
				If (tClsType = "serial") {
					Set tType = "!"_tType
				}
				Set pTree(n) = $LB(tPropName,tRef,0,,,,tSQLRef_":"_tType_":"_tDispName) // Note Type Addition
				Set pTree(tRootNo,"ch",n) = ""
				Set tTopHasChildren = 1

				If ((tClsType = "persistent")||(tClsType = "serial")) {
					// mark that there are child nodes
					Set $List(pTree(n),3) = 1 	
				}
			}
			If $$$ISERR(tSC) Quit
		}		
		// mark is top node has children
		If ((tTopNode'="")&&(tTopHasChildren)) {
			Set $List(pTree(tTopNode),3) = 1
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClientMethod drawHeader(title, msgChange, hlpChange) [ Language = javascript ]
{
	var h=[];
	h.push('<span class="zruHeaderTitle"><nobr>'+title+'</nobr></span>');
	if (msgChange) {
		h.push('&nbsp;<a class="zruHeaderLink" href="#" title="'+hlpChange+'" onclick="zenPage.changeDataSource();return false;">'+msgChange+'</a>');
	}
	var d = this.getChildById("header").getEnclosingDiv();
	d.innerHTML=h.join("");
}

ClientMethod getTopLevelItems() [ Language = javascript ]
{
	var t = this.getChildById("dataSourceTree");
	var a = [];
	var idx = 0;
	var done = false;
	while (!done) {
		var anchor = t.findElement('a_' + idx);
		if (anchor) {
			var cosName = anchor.getAttribute('zenText');
			var sqlName = cosName;
			var titleStr = anchor.getAttribute('title');
			if (titleStr && titleStr.length>0) {
				var parts = titleStr.split(":");
				sqlName=parts[2];
				cosType=parts[1];
			}
			var icon = t.findElement('icon_' + idx);
			if (icon) {
				if (icon.className=='dynaTreeIcon') a.push({cosN:cosName,cosT:cosType,sqlN:sqlName});
			}
		}
		else done = true;
		idx++;
	}
	return(a);
}

ClassMethod IsSQLReservedWord(word As %String) As %ZEN.Datatype.boolean [ ZenMethod ]
{
	Set rtn = 0
	if ($SYSTEM.SQL.IsReservedWord(word)) Set rtn = 1
	Quit rtn
}

ClientMethod resolveNestedReference(nodeNum) [ Language = javascript ]
{
	var t = this.getChildById("dataSourceTree");
	var ref = "";
	var idx = nodeNum;
	while (idx>0) {
		var anchor = t.findElement('a_' + idx);
		if (anchor) {
			var cosName = anchor.getAttribute('zenText');
			var sqlName = cosName;
			var titleStr = anchor.getAttribute('title');
			if (titleStr && titleStr.length>0) {
				var a = titleStr.split(":");
				sqlName=titleStr.split(":")[2];
				sqlName = a[2];
				if (this.IsSQLReservedWord(sqlName)) sqlName += '"'+sqlName+'"';
				var nType = a[1].charAt(0);
				if (nType=="@") ref = sqlName+"->"+ref;
				else if (nType=="!") ref = sqlName+"_"+ref;
				else ref = sqlName;
				idx = parseInt(anchor.getAttribute('zenparent'));				
			}
		}
	}
	return(ref);
}

ClientMethod getNodeTypeInfo(nodeNum) [ Language = javascript ]
{
	var t = this.getChildById("dataSourceTree");
	var ref = "";
	var idx = nodeNum;
	if (idx>0) {
		var anchor = t.findElement('a_' + idx);
		if (anchor) {
			var titleStr = anchor.getAttribute('title');
			if (titleStr && titleStr.length>0) {
				var a = titleStr.split(":");
				var typeName = a[1];
				var nType = typeName.charAt(0);
				if (nType=="@" || nType=="!") typeName = typeName.substring(1);
			}
		}
	}
	return(typeName);
}

ClientMethod enableDDD() [ Language = javascript ]
{
	var t = this.getChildById("dataSourceTree").getEnclosingDiv();
	ZLM.enableDataDragDrop(t);
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.drawHeader(this.title,this.msgChange,this.hlpChange);
	this.enableDDD();
}

ClientMethod onRefreshContents() [ Language = javascript ]
{
	this.drawHeader(this.title,this.msgChange,this.hlpChange);
	this.enableDDD();
}

/// User has double-clicked on an element in the (data source) tree control.
ClientMethod treeDoubleClick(tree) [ Language = javascript ]
{
	//TODO RESTORE THIS FUNCTIONALITY
	/*
	var text = tree.getNodeText(tree.selectedIndex);
	var value = tree.getNodeValue(tree.selectedIndex);
	if (value && '' !== value) {
		var field = {};
		field.name = text;
		field.sourceProperty = value;
		alert("want to add: "+field);
//		this.addDataField(field);
	}
	*/
}

}
