/// Standard template for New Report within the DeepSee Report GUI.
/// This dialog validates the classname for both lexical correctness as
/// well as availability.  If acceptable, the dialog returns its value in 
/// a JavaScript object. This takes the form of: <br />
/// 	value.pkgName : The package name <br />
/// 	value.clsName : The Cache class name <br />
/// 	value.appName : The Zen application associated with this report (if any) <br />
/// 	value.rptName : The semantic name of the report <br />
/// 	value.desc 	  : The description detail of the report (if any) <br />
Class %DeepSee.Report.UI.NewReportWizard Extends %ZEN.Dialog.standardDialog [ LegacyInstanceContext, System = 4 ]
{

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

Parameter JSINCLUDES = "zenCSLM.js";

Property skipApp As %Boolean(ZENURL = "NOAPP") [ InitialExpression = 0 ];

/// Optional name of the superclass of files created by the editor who asked for 
/// this dialog in the first place
Property super As %ZEN.Datatype.string(ZENURL = "SUPER");

/// Optional flag to indicate that interclass dependencies should be checked before
/// offering the user to option to reuse(with destructive overwrite) a given filename
Property checkUsers As %ZEN.Datatype.boolean(ZENURL = "CHECKUSERS") [ InitialExpression = 1 ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// This XML block defines the contents of the body pane of this dialog.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="body" layout="none">

<vgroup labelPosition="left" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;" >
<dataCombo label="Package Name:"
		id="ctrlPackage"
		name="Package"
		required="true"
		labelClass="zenRequired"
		title="Package name for the new page"
		editable="true"
		unrestricted="true"
		searchKeyLen="0"
		maxRows="500"
		dropdownWidth="20.0em"
		size="50"
		OnCreateResultSet="CreatePackageRS"
		onchange="zenPage.updateState();"
/>

<text label="Class Name:" 
	id="ctrlClassName"
	name="ClassName"
	size="52"
	required="true"
	labelClass="zenRequired"
	title="Class name for the new page" 
	onchange="zenPage.updateState();"
/>

<dataCombo label="Application:"
		id="ctrlApplication"
		name="Application"
		title="Class name of the application this page belongs to" 
		editable="true"
		unrestricted="true"
		searchKeyLen="0"
		multiColumn="false"
		displayColumns="1"
		valueColumn="1"
		choiceColumn="1"
		maxRows="500"
		size="50"
		dropdownWidth="20.0em"
		OnCreateResultSet="CreateApplicationRS"
		onchange="zenPage.updateState();"
/>

<text label="Report Name:" 
	id="ctrlReportName"
	name="ReportName"
	title="Name of this report" 
	size="52"
	onchange="zenPage.updateState();"
/>
<textarea label="Description:" 
	id="ctrlDescription"
	name="Description"
	rows="4"
	cols="40"
	title="Description for the new class" 
	onchange="zenPage.updateState();"
/>
</vgroup>
</pane>
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("DeepSee Reports")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit $$$TextHTML("Define a new DeepSee reporting class below.")
}

/// This class method callback is called just before the server-side page 
/// object is created.
Method %OnAfterCreatePage() As %Status
{
	// first dispatch to super class
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set tSC = $$$OK
	Try {
		// check privileges
		If ('$$CheckReportFormatDefAccess^%qdsUtils()) {
			Set %response.Redirect = ##class(%DeepSee.Utils).%GetErrorPageURL("License")
			Throw ##class(%Exception.SystemException).%New("DeepSee License")
		}

		Do %page.%SetValueById("ctrlPackage",##class(%ZEN.Utils).GetDefaultPackage())
		Do %page.%SetValueById("ctrlApplication",##class(%ZEN.Utils).GetDefaultApplication())
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Given the name of an abstract DSVR presentation class, return a CSV list of all 
/// of its children and the data collectors they rely upon.  Each record in the list 
/// is of the form PresenterClassName|CollectorClassName.  Note that CVS strings are 
/// used rather than native COS data structures to simplify data exchanges with client-
/// side JavaScript
ClassMethod GetDSVRDependencies(pCls As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tCSV = ""
	Set tOut = ""
	
	Kill tParms
	
	Set tParms("sub") = pCls
	Set tSC = ##class(%ZEN.FinderUtils).%GetClassListArray(.tParms,.tMetaData,.tData)
	If ($$$ISOK(tSC)&&$D(tMetaData)&&$D(tData)) {
		// Strip it down to just class names
		Set tCSV = ..ExtractClassNames(.tMetaData,.tData)
		If (tCSV '= "") {
   			Set tMax = $Length(tCSV,",")
   			Set tIdx = 1
   			For tLoop = tMax:-1:1 {
      			Set tClsName=$Piece(tCSV,",",tIdx)
      			Set tObj = ##class(%Dictionary.CompiledClass).%OpenId(tClsName)
      			If (tObj) {
	      			If (tIdx>1) Set tOut = tOut_","
	      			Set tA=$property(tObj,"Parameters")
        			For i=1:1:tA.Count() {
	        			Set tItem=tA.GetAt(i)
	        			If (tItem.Name = "DSSCLASS") Set tOut = tOut_tClsName_"|"_tItem.Default
        			}
      			}
				Set tIdx = tIdx+1
   			}
   		}
	}
	Quit tOut
}

/// Given the name of a data collector or data schema interface DSVR class
/// Return a CSV list of all the presentation classes that make use of it.
/// Note that CVS strings are used rather than native COS data structures 
/// to simplify data exchanges with clientside JavaScript
ClassMethod IsUsedBy(pCls As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	// Currently only presenter classes have interclass dependencies within DSVR
	Set PresenterClass = "%DeepSee.Report.dataPresenter"

	Set UserClass = ""
	Set UserClassCount = 0
	Set tCSV = ..GetDSVRDependencies(PresenterClass)
	If (tCSV '= "") {
   		Set tMax = $Length(tCSV,",")
   		Set tIdx = 1
   		For tLoop = tMax:-1:1 {
      		Set tClsRec=$Piece(tCSV,",",tIdx)
			If ($Find(tClsRec,"|"_pCls)>0) {
				Set tClsName = $Piece(tClsRec,"|")
				If (UserClassCount>0) Set UserClass = UserClass_","
				Set UserClassCount = UserClassCount + 1
				Set UserClass = UserClass_tClsName
			}
			Set tIdx = tIdx+1
   		}
   	}
	Quit UserClass
}

/// Given an array of the form returned by %GetClassListArray of %ZEN.FinderUtils,
/// reduce it down to a CSV string of just class names
ClassMethod ExtractClassNames(ByRef pMetaData, ByRef pData) As %String [ PublicList = pData ]
{
	Set tFirst = 1
	Set tLeaf = ""
	Set tSC = $$$OK
	Try {
		Set tLevel = 0
		Set tChildCount(tLevel) = 0
		Set tPropCount(tLevel) = 0

		// process top node
		Set tNode = $G(pData)
		If $ListValid(tNode) {
			For n = 1:1:$LL(tNode) {
				Set tVal = $LG(tNode,n,$C(0))
				If (tVal'=$C(0)) {
					Set tPropCount(tLevel) = tPropCount(tLevel) + 1
				}
			}
		}
		// now process children of array
		Set tKey = $Query(pData)
		If (tKey '= "") {
			Set tLevel = tLevel + 1
			Set tChildCount(tLevel) = 0
			Set tPropCount(tLevel) = 0
		}

		// loop over array
		While (tKey '= "") {
			Set tNewLevel = $ql(tKey)
			While (tLevel < tNewLevel) {
				Set tLevel = tLevel + 1
				Set tChildCount(tLevel) = 0
			}
			While (tLevel > tNewLevel) {
				Kill tPropCount(tLevel),tChildCount(tLevel)
				Set tLevel = tLevel - 1
			}

			Set tNode = $G(@tKey)
			Set tChildCount(tLevel) = tChildCount(tLevel) + 1
			Set tPropCount(tLevel) = 0
			If (tNode = "") {
				Set tPropCount(tLevel) = tPropCount(tLevel) + 1
			} Else {
				Set tNodeData = ""
				Set tKeep = 0
				For n = 1:1:$LL(tNode) {
					Set tVal = $LG(tNode,n,$C(0))
					If (tVal'=$C(0)) {
						Set tNodeMeta = $LG(pMetaData,n,"ukn")
						If (tNodeMeta = "value") Set tNodeData = tVal
						If (tVal="cls") Set tKeep = 1
						Set tPropCount(tLevel) = tPropCount(tLevel) + 1
					}
				}
				If (tKeep = 1) {
					If (tFirst = 0) {
						Set tLeaf = tLeaf_","
					}
					Else {
						Set tFirst = 0
					}
					Set tLeaf = tLeaf_tNodeData
				}
			}
			// get next item
			Set tKey = $Query(@tKey)
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
		Set tLeaf = ""
	}
	Quit tLeaf
}

/// Validate that the given class name is valid.<br>
/// Returns an error message if invalid.
ClassMethod IsValidClassName(pCls As %String) As %String [ ZenMethod ]
{
	If '$ZNAME(pCls,4) {
		Quit $$$Text("The class name is invalid.","%ZEN")
	}
	If ($Find(pCls,"MyApp.Unnamed")>0) {
		Quit $$$Text("Class names beginning with 'Unnamed' in the 'MyApp' package are reserved by the DSVR editors.  Please choose a different name.","%ZEN")
	}
	#; test for existence
	If ##class(%Dictionary.ClassDefinition).%ExistsId(pCls) {
		Quit $$$Text("The class name is already in use.","%ZEN")
	}
	
	Quit ""
}

ClassMethod ValidateParentClass(pCls) As %ZEN.Datatype.boolean [ ZenMethod ]
{
	// Internal safety check to ensure that classname checked against 
	// "Super" is bounded to known and approved values prior to authorizing 
	// an overwrite	
	Set IsValid = 0
	If (pCls = "%DeepSee.Report.dataCollector") Set IsValid = 1
	If (pCls = "%DeepSee.Report.sqlQueryDSS") Set IsValid = 1
	If (pCls = "%DeepSee.Report.dataSchemaInterface") Set IsValid = 1
	If (pCls = "%DeepSee.Report.dataPresenter") Set IsValid = 1
	
	Quit IsValid
}

/// Test to see if the given class is a product of one of DSVR's own editors
ClassMethod IsDSVRClass(pCls As %String, pParentCls As %String, pCheckUsers As %Boolean) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set IsOurs = ""
	Try {
		If ##class(%Dictionary.ClassDefinition).%ExistsId(pCls) {
			If ($Find(pCls,"MyApp.Unnamed")=0) {
				Set tCDef = ##class(%Dictionary.ClassDefinition).%OpenId(pCls)
				If $IsObject(tCDef) {
					Set super = tCDef.Super
					If ($Find(super,pParentCls)>0) {
						Set Users = ""
						If (pCheckUsers = 1) Set Users = ..IsUsedBy(pCls)
						If (Users '= "") {
							Set IsOurs = $$$Text("The given class name is already in use by a class that is actively referenced by other reports in this namespace.  Overwriting that class may render those reports unusable.  Please select 'Ok' to overwrite this class anyway, or 'Cancel' to select a new name.") 	
						}
						Else {
							Set IsOurs = $$$Text("This class name is already in use by a document produced by this editor.  Select 'OK' to overwrite this file or 'Cancel' to enter a new class name.")	
						}
					}
				}
			}
		}
	}
	Catch(ex) {
		Set IsOurs = ""
	}
	Quit IsOurs
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return(this.value);
}

/// This is called when the dialog is first displayed;
/// This provides a chance to set focus etc.
ClientMethod ondialogStart() [ Language = javascript ]
{
	// give focus to name
	var ctrl = zenPage.getComponentById('ctrlClassName');
	if (ctrl) {
		ctrl.focus();
		ctrl.select();
	}
	this.value = {};
	this.pkgCtrl = zenPage.getComponentById('ctrlPackage');
	this.clsCtrl = zenPage.getComponentById('ctrlClassName');
	this.appCtrl = zenPage.getComponentById('ctrlApplication');
	this.rptCtrl = zenPage.getComponentById('ctrlReportName');
	this.descCtrl = zenPage.getComponentById('ctrlDescription');
	if (this.skipApp) this.appCtrl.setProperty("hidden",true);
	if (parent.zenPage._popupData) {
		var p = parent.zenPage._popupData;
		if (p.pkgName) this.pkgCtrl.setValue(p.pkgName);
		if (p.clsName) this.clsCtrl.setValue(p.clsName);	
		if (p.appName) this.appCtrl.setValue(p.appName);
		if (p.rptName) this.rptCtrl.setValue(p.rptName);
		if (p.desc) this.descCtrl.setValue(p.desc);
	}
}

ClientMethod updateState() [ Language = javascript ]
{
	this.value.pkgName = this.pkgCtrl.getValue();
	this.value.clsName = this.clsCtrl.getValue();
	this.value.appName = this.appCtrl.getValue();
	this.value.rptName = this.rptCtrl.getValue();
	if (!this.value.rptName) this.value.rptName = " ";
	this.value.desc = this.descCtrl.getValue();
	if (!this.value.desc) this.value.desc = " ";
}

ClientMethod validateClassName() [ Language = javascript ]
{
	// test if class name is valid
	var pkgName = this.pkgCtrl.getValue();
	var clsName = this.clsCtrl.getValue();
	var fullName = pkgName + "." + clsName;
	var msg = this.IsValidClassName(fullName);

	if ('' != msg) {
		if ( '' != this.super && this.ValidateParentClass(this.super)==1) {
			var cMsg = this.IsDSVRClass(fullName,this.super,this.checkUsers)
			if ('' != cMsg) {
				if (confirm(cMsg)) return(true);
				zen("ctrlClassName").focus();
				return false;
			}	
		}	
		alert(msg);
		zen("ctrlClassName").focus();
		return false;
	}
	return true;
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
/// Check ClassName value. 
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	if (this.validateClassName()) {
		return(true);
	}
	return(false);
}

/// Create the result set used by the Package dataCombo.
Method CreatePackageRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tRS = ""
	Set tSC = $$$OK

	Set tRS = ##class(%ResultSet).%New()
	Set tRS.ClassName = "%ZEN.Utils"
	Set tRS.QueryName = "EnumeratePackages"
	Quit tRS
}

/// Create the result set used by the Application dataCombo.
Method CreateApplicationRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tRS = ""
	Set tSC = $$$OK

	Set tRS = ##class(%ResultSet).%New()
	Set tRS.ClassName = "%ZEN.Utils"
	Set tRS.QueryName = "EnumerateApplications"
	Quit tRS
}

}
