/// This class is used internally by InterSystems. You should not make direct use of it within your applications.
/// There is no guarantee made about either the behavior or future operation of this class.<p>
Class %ZEN.Mojo.Wizard.MojoWizard Extends %ZEN.Template.studioTemplate [ System = 4 ]
{

Parameter TEMPLATENAME = "Zen Mojo Site";

Parameter TEMPLATETITLE = "Zen Mojo Wizard";

Parameter TEMPLATEDESCRIPTION = "Creates a stub of a Zen Mojo application with parameters for includes, providers, application, home page and template class";

Parameter TEMPLATETYPE = "cls";

/// What type of template.
Parameter TEMPLATEMODE = "new";

Parameter TEMPLATEGROUP = "Zen";

/// Domain used for localization.
Parameter DOMAIN = "%ZEN";

/// DOCBOOK Topic Id that offers help for this template.
Parameter HELPID = "GZCP_forms";

XData templateBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="body">
<vgroup labelPosition="left" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
<html id="desc" OnDrawContent="%GetDescHTML"/>
<dataCombo label="Package Name:"
		id="ctrlPackage"
		name="Package"
		required="true"
		labelClass="zenRequired"
		title="Enter or select a package name for the new Zen page class. This is required. If the package does not exist, the wizard will create a new one for you, with this name." 
		editable="true"
		unrestricted="true"
		searchKeyLen="0"
		maxRows="500"
		dropdownWidth="20.0em"
		size="40"
		OnCreateResultSet="CreatePackageRS"
		onchange="zenPage.updateState();"
/>
<text label="Page Class Name:" 
	id="ctrlPageClassName"
	name="PageClassName"
	size="40"
	required="true"
	labelClass="zenRequired"
	title="Class name for the new Zen page class. This is required." 
	onchange="zenPage.updateState();"
/>
<text label="Page Name:" 
	id="ctrlPageName"
	name="PageName"
	size="40"
	required="false"
	labelClass="zenLabel"
	title="Name for the Mojo Page." 
	onchange="zenPage.updateState();"
/>
<dataCombo label="Page Manager:"
		id="ctrlPageManager"
		name="PageManager"
		required="true"
		labelClass="zenRequired"
		title="Select the page manager of your Zen Mojo application. This is required." 
		editable="true"
		unrestricted="false"
		searchKeyLen="0"
		maxRows="500"
		dropdownWidth="20.0em"
		size="40"
		OnCreateResultSet="PageManagerRS"
		onchange="zenPage.updateState();"
/>
<hgroup>
<listBox label="Available Helper Plugins:"
		id="ctrlHelperPlugins"
		name="HelperPlugins"
		labelClass="zenLabel"
		title="Select the helper plugins of your Zen Mojo application."
		onchange="zenPage.selectHelper(zenThis.selectedIndex);zenPage.updateState();"
/>
<spacer width="5"/>
<listBox label="Chosen Helper Plugins:"
		id="ctrlChosenHelperPlugins"
		name="chosenHelperPlugins"
		labelClass="zenLabel"
		title="Select the helper plugins of your Zen Mojo application."
		onchange="zenPage.deselectHelper(zenThis.selectedIndex);zenPage.updateState();"
/>
</hgroup>
<text
	id="ctrlHiddenChosenHelperPlugins"
	name="hiddenChosenHelperPlugins"
	hidden="true"
/>
<text label="Template Class Name:" 
	id="ctrlTemplateClassName"
	name="TempClassName"
	size="40"
	required="true"
	labelClass="zenRequired"
	title="Template Class name for the new Zen page class. This is required." 
	onchange="zenPage.updateState();"
/>

<text label="Application Class Name:" 
	id="ctrlAppClassName"
	name="AppClassName"
	size="40"
	required="false"
	labelClass="zenLabel"
	title="Class name for the Mojo Application Class." 
	onchange="zenPage.updateState();"
/>
<text label="Application Name:" 
	id="ctrlAppName"
	name="AppName"
	size="40"
	required="false"
	labelClass="zenLabel"
	title="Name for the Mojo Application." 
	onchange="zenPage.updateState();"
/>
<text label="Domain:" 
	id="ctrlDomain"
	name="Domain"
	size="40"
	title="Domain for localized text library" 
	required="false"
	labelClass="zenLabel"
	onchange="zenPage.updateState();"
/>
<!--
<text label="CSS Includes:" 
	id="ctrlCSS"
	name="CSSInc"
	size="40"
	required="false"
	labelClass="zenLabel"
	title="Comma delimited list of CSS Include files needed to run this application." 
	onchange="zenPage.updateState();"
/>
<text label="JS Includes:" 
	id="ctrlJSIncludes"
	name="JSInc"
	size="40"
	required="false"
	labelClass="zenLabel"
	title="Comma delimited list of JavaScript Include files needed to run this application." 
	onchange="zenPage.updateState();"
/>
-->
</vgroup>
</pane>
}

ClientMethod selectHelper(index) [ Language = javascript ]
{
	var me = zen('ctrlHelperPlugins');
	var other = zen('ctrlChosenHelperPlugins');
	
	var value = me.getOptionValue(index);
	me.removeOption(index);
	me.selectedIndex = -1;
	other.appendOption(value);
	
	var helpers = [];
	for (var i=0;i<other.getOptionCount();i++) {
		helpers.push(other.getOptionValue(i));
	}
	zenSetProp('ctrlHiddenChosenHelperPlugins','value',helpers.join(','));
}

ClientMethod deselectHelper(index) [ Language = javascript ]
{
	var other = zen('ctrlHelperPlugins');
	var me = zen('ctrlChosenHelperPlugins');
	
	var value = me.getOptionValue(index);
	me.removeOption(index);
	me.selectedIndex = -1;
	other.appendOption(value);
	
	var helpers = [];
	for (var i=0;i<me.getOptionCount();i++) {
		helpers.push(me.getOptionValue(i));
	}
	zenSetProp('ctrlHiddenChosenHelperPlugins','value',helpers.join(','));
}

ClientMethod hasMultiplePages() [ Language = javascript ]
{
	return false;
}

/// Return true if this template can go to the next page (i.e., enable
/// the Next button).<br>
ClientMethod canGoNext() [ Language = javascript ]
{
	return false;
}

/// Provide contents of description component on the first tab.
Method %GetDescHTML(pSeed As %String) As %Status
{
	Write $$$Text("This wizard creates a new Zen Mojo Application, Home Page and Template<br/>")
	Write $$$Text("Fill in the form below and then press Finish to generate the classes.")
	Quit $$$OK
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

/// Create the result set used by the PageManager dataCombo.
Method PageManagerRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tRS = ""
	Set tSC = $$$OK

	Set tRS = ##class(%ResultSet).%New()
	do tRS.Prepare("SELECT SUBSTRING(InitialExpression,2,LENGTH(InitialExpression)-2) FROM %Dictionary.CompiledProperty WHERE parent->Super = '%ZEN.Mojo.Plugin.basePageManager' AND name = 'pluginName'")
	Quit tRS
}

/// Create the result set used by the Helper Plugins dataList
Method HelperPluginsRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tRS = ""
	Set tSC = $$$OK

	Set tRS = ##class(%ResultSet).%New()
	do tRS.Prepare("SELECT SUBSTRING(InitialExpression,2,LENGTH(InitialExpression)-2) FROM %Dictionary.CompiledProperty WHERE parent->Super = '%ZEN.Mojo.Plugin.baseHelperPlugin' AND name = 'pluginName'")
	Quit tRS
}

ClassMethod CreateZenApp(appClassName As %String, pkgName As %String, applicationname As %String, pageName As %String) As %Status
{

	do ##class(%Dictionary.ClassDefinition).%DeleteId(pkgName_"."_appClassName)
	
	set zenApp=##class(%Dictionary.ClassDefinition).%New()
	set zenApp.Name=pkgName_"."_appClassName
	set zenApp.Super="%ZEN.Mojo.baseApplication"
	set zenApp.ProcedureBlock=1

	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="APPLICATIONNAME"
	set param.Default=applicationname
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="HOMEPAGE"
	set param.Default=pkgName_"."_pageName_".cls"
	do zenApp.Parameters.Insert(param)

	set xds=##class(%Dictionary.XDataDefinition).%New()
	set xds.parent=zenApp
	set xds.Name="Style"
	set xds.Data=##class(%Stream.TmpCharacter).%New()
	do xds.Data.Rewind()
	do xds.Data.Write(" <style type=""text/css"">"_$C(13,10)_"</style>"_$C(13,10))
	do xds.%Save()

	set ok=zenApp.%Save()
	if ok { 
		set save=$system.OBJ.Compile(zenApp.Name) 
		if save {
			set proj=..%AddToProject(zenApp.Name_ ".cls")
			set sc=..%AddToSourceControl(zenApp.Name_ ".cls")		
		}
	}

	quit ok
}

ClassMethod CreateZenMojoTemplate(tempName As %String, pkgName As %String, application As %String, domain As %String, pageName As %String, pPageManager As %String) As %Status
{

	do ##class(%Dictionary.ClassDefinition).%DeleteId(pkgName_"."_tempName)
	
	set zenApp=##class(%Dictionary.ClassDefinition).%New()
	set zenApp.Name=pkgName_"."_tempName
	set zenApp.Super="%ZEN.Mojo.Component.contentTemplate"
	set zenApp.ProcedureBlock=1
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="DOMAIN"
	set param.Default=domain
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="NAMESPACE"
	set param.Default="http://www.intersystems.com/zen/mojo/"_pageName
	do zenApp.Parameters.Insert(param)
	
	set method=##class(%Dictionary.MethodDefinition).%New()
	set method.parent=zenApp
	set method.ClientMethod=1
	set method.Name="onGetContent"
	set method.ReturnType=""
	set method.Language="javascript"
	set method.FormalSpec="providerName,key,criteria"
	set code=##class(%Stream.TmpCharacter).%New()
	do code.Rewind()
	do code.Write(" 	switch (providerName)"_$C(13,10))
	do code.Write(" 	{ "_$C(13,10))
	do code.Write(" 		case 'layout': "_$C(13,10))
	do code.Write("  			return this.getLayout(key,criteria);"_$C(13,10))
	do code.Write(" 	} "_$C(13,10))
	do code.Write($C(13,10))
	do code.Write(" 	// return null -> fetch data from server (if local cache is empty)"_$C(13,10))
	do code.Write(" 	return null;"_$C(13,10))
	set method.Implementation=code
	set method.Description="Client-side content provider method."_$C(13,10)_"<var>providerName</var> is the name of the json provider. "_$C(13,10)_"<var>key</var> is the key value associated with the request."_$C(13,10)_"<var>criteria</var> is the search criteria associated with the request."
	do method.%Save()
 
 	set method=##class(%Dictionary.MethodDefinition).%New()
	set method.parent=zenApp
	set method.ClientMethod=1
	set method.Name="getLayout"
	set method.ReturnType=""
	set method.Language="javascript"
	set method.FormalSpec="key,criteria"
	set code=##class(%Stream.TmpCharacter).%New()
	do code.Rewind()
	do code.Write(" 	var layout = {};"_$C(13,10))
	do code.Write(" 	switch(key) { "_$C(13,10))
	do code.Write(" 		case 'home' : "_$C(13,10))
	do code.Write("  			// add layout objects to the children array"_$C(13,10))
	do code.Write("			layout = {"_$C(13,10))
	do code.Write("				children:["_$C(13,10))
	
	if ((pPageManager = "chui-3.5.2-PageManager") || (pPageManager = "chuiPageManager")) {
		
		// add needed article and section for CHUI
		do code.Write("					{type:'$article',children:["_$C(13,10))
		do code.Write("						{type:'$section',children:["_$C(13,10))
		do code.Write("						]}"_$C(13,10))
		do code.Write("					]}"_$C(13,10))
		
	}
	
	do code.Write("				]"_$C(13,10))
	do code.Write(" 			}; "_$C(13,10))
	do code.Write("			break;"_$C(13,10))
	do code.Write(" 	} "_$C(13,10))
	do code.Write($C(13,10))
	do code.Write(" 	return layout;"_$C(13,10))
	set method.Implementation=code
	set method.Description="Creates the layout object for the page"
	do method.%Save()

 	set method=##class(%Dictionary.MethodDefinition).%New()
	set method.parent=zenApp
	set method.ClientMethod=1
	set method.Name="onselect"
	set method.ReturnType=""
	set method.Language="javascript"
	set method.FormalSpec="key,value,docViewId"
	set code=##class(%Stream.TmpCharacter).%New()
	do code.Rewind()
	do code.Write("	console.log('select '+key);"_$C(13,10))
	do code.Write(" 	var view = zen(docViewId);"_$C(13,10))
	do code.Write(" 	var realKey = key.split(':')[0];"_$C(13,10))
	do code.Write(" 	switch(realKey) {"_$C(13,10))
	do code.Write(" 	} "_$C(13,10))
	set method.Implementation=code
	do method.%Save()

 	set method=##class(%Dictionary.MethodDefinition).%New()
	set method.parent=zenApp
	set method.ClientMethod=1
	set method.Name="onchange"
	set method.ReturnType=""
	set method.Language="javascript"
	set method.FormalSpec="key, value, final, docViewId"
	set code=##class(%Stream.TmpCharacter).%New()
	do code.Rewind()
	do code.Write("	console.log('change ' + key + ' to ' + value);"_$C(13,10))
	do code.Write(" 	var view = zen(docViewId);"_$C(13,10))
	do code.Write(" 	switch(key) {"_$C(13,10))
	do code.Write(" 	} "_$C(13,10))
	set method.Implementation=code
	do method.%Save()
	
	set method=##class(%Dictionary.MethodDefinition).%New()
	set method.parent=zenApp
	set method.ClassMethod=1
	set method.Name="%OnGetJSONContent"
	set method.ReturnType="%Status"
	set method.FormalSpec="pProviderName:%String, pKey:%String,&pParms,*pObject:%RegisteredObject, pCriteria:%RegisteredObject, pLoad:%Boolean=0"
	set code=##class(%Stream.TmpCharacter).%New()
	do code.Rewind()
	do code.Write("	set pObject = ##class(%ZEN.proxyObject).%New()"_$C(13,10))
	do code.Write($C(13,10))
	do code.Write(" 	if (pKey = ""home"") {"_$C(13,10))
	do code.Write(" 		// construct data bag for the client here and inject into pObject"_$C(13,10))
	do code.Write(" 	} "_$C(13,10)_$C(13,10))
	do code.Write(" 	quit $$$OK")
	set method.Implementation=code
	set method.Description="Server-side method to provide content to JSON providers."_$C(13,10)_"<var>pProviderName</var> is the name of the provider."_$C(13,10)_"<var>pKey</var> is an app-defined key that is used to indicate which content is to be served."_$C(13,10)_"<var>pCriteria</var>is an object containing search criteria. This is used for searching."_$C(13,10)_"<var>pParms</var> is an array of additional parameters from the JSON provider. (not current used)."_$C(13,10)_"<var>pObject</var> is the object that will be served to the client in JSON format."_$C(13,10)_"<var>pLoad</var> is true is this is called when the page is first being served. In this case, this method will be "_$C(13,10)_"called even though there may a client-side method used to load the content."
	do method.%Save()
	
	set ok=zenApp.%Save()
	if ok { 
		set save=$system.OBJ.Compile(zenApp.Name) 
		if save {
			Do ..%AddToProject(zenApp.Name _ ".cls")
			Do ..%AddToSourceControl(zenApp.Name_ ".cls")		
		}
	}

	quit ok
}

ClassMethod CreateZenMojoHomePage(pageClass As %String, pkgName As %String, application As %String, pageName As %String, templateClass As %String, domain As %String, jsIncludes As %String, cssIncludes As %String, tPageManager As %String, tHelperPlugins As %String) As %Status
{

	do ##class(%Dictionary.ClassDefinition).%DeleteId(pkgName_"."_pageClass)
	set zenApp=##class(%Dictionary.ClassDefinition).%New()
	set zenApp.Name=pkgName_"."_pageClass
	set zenApp.Super="%ZEN.Mojo.basePage"
	set zenApp.ProcedureBlock=1

	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="APPLICATION"
	set param.Default=application
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="PAGENAME"
	set param.Default=pageName
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="TEMPLATECLASS"
	set param.Default=pkgName_"."_templateClass
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="DOMAIN"
	set param.Default=domain
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="NAMESPACE"
	set param.Default="http://www.intersystems.com/zen/mojo/"_pageName
	do zenApp.Parameters.Insert(param)
	
	set jsIncludes = ""
	set cssIncludes = ""
	kill ^||jsIncludes,^||cssIncludes,^||tempJS,^||tempCSS
	set ^||jsIncludes = ""
	set ^||cssIncludes = ""
	set firstDojoKey = -1
	set firstChartKey = -1
	
	if ((tPageManager = "chui-3.5.2-PageManager") || (tPageManager = "chuiPageManager")) {
		set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
		set ^||jsIncludes($I(^||jsIncludes))="chui-3.5.2.js"
		set ^||cssIncludes($I(^||cssIncludes))="chui-ios-3.5.2.css"
	} elseif ((tPageManager = "dojo-1.9.1-PageManager") || (tPageManager = "dojoPageManager")) {
		set ^||jsIncludes($I(^||jsIncludes))="dojo-release-1-9-1/dojo/dojo.js"
		set ^||cssIncludes($I(^||cssIncludes))="dojo-release-1-9-1/dijit/themes/claro/claro.css"
		if (firstDojoKey = -1) {
			set firstDojoKey = ^||jsIncludes
		}
	} elseif ((tPageManager = "jQM-1.3.2-PageManager") || (tPageManager = "jQMPageManager")) {
		set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
		set ^||jsIncludes($I(^||jsIncludes))="jquery.mobile-1.3.2.min.js"
		set ^||cssIncludes($I(^||cssIncludes))="jquery.mobile-1.3.2.min.css"
	} elseif (tPageManager = "jQM-1.4.3-PageManager") {
		set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
		set ^||jsIncludes($I(^||jsIncludes))="jquery.mobile-1.4.3.min.js"
		set ^||cssIncludes($I(^||cssIncludes))="jquery.mobile-1.4.3.min.css"
	} elseif (tPageManager = "jQM-1.4.5-PageManager") {
		set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
		set ^||jsIncludes($I(^||jsIncludes))="jquery.mobile-1.4.5.min.js"
		set ^||cssIncludes($I(^||cssIncludes))="jquery.mobile-1.4.5.min.css"
	} elseif (tPageManager = "mojoDefaultPageManager") {
		
	}
	
	for i=1:1:$L(tHelperPlugins,",") {
		set plugin = $P(tHelperPlugins,",",i)
		if (plugin = "charts-1.0.1-Helper") {
			set ^||jsIncludes($I(^||jsIncludes))="Chart-1.0.1.min.js"
			if (firstChartKey = -1) {
				set firstChartKey = ^||jsIncludes
			}
		} elseif ((plugin = "chui-3.5.2-Helper") || (plugin = "chuiHelper")) {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="chui-3.5.2.js"
			set ^||cssIncludes($I(^||cssIncludes))="chui-ios-3.5.2.css"
		} elseif ((plugin = "dojo-1.9.1-2DChartHelper") || (plugin = "dojo2DChartHelper")) {
			set ^||jsIncludes($I(^||jsIncludes))="dojo-release-1-9-1/dojo/dojo.js"
			set ^||cssIncludes($I(^||cssIncludes))="dojo-release-1-9-1/dijit/themes/claro/claro.css"
			if (firstDojoKey = -1) {
				set firstDojoKey = ^||jsIncludes
			}
		} elseif ((plugin = "dojo-1.9.1-DijitHelper") || (plugin = "dojoDijitHelper")) {
			set ^||jsIncludes($I(^||jsIncludes))="dojo-release-1-9-1/dojo/dojo.js"
			set ^||cssIncludes($I(^||cssIncludes))="dojo-release-1-9-1/dijit/themes/claro/claro.css"
			if (firstDojoKey = -1) {
				set firstDojoKey = ^||jsIncludes
			}
		} elseif ((plugin = "dojoGridX-1.3.0-Helper") || (plugin = "dojoGridXHelper")) {
			set ^||jsIncludes($I(^||jsIncludes))="dojo-release-1-9-1/dojo/dojo.js"
			set ^||cssIncludes($I(^||cssIncludes))="dojo-release-1-9-1/dijit/themes/claro/claro.css"
			set ^||cssIncludes($I(^||cssIncludes))="dojo-release-1-9-1/gridx/resources/claro/Gridx.css"
			if (firstDojoKey = -1) {
				set firstDojoKey = ^||jsIncludes
			}
		} elseif (plugin = "highCharts-4.0.1-Helper") {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="highcharts/js/highcharts.js"
			set ^||jsIncludes($I(^||jsIncludes))="highcharts/js/themes/skies.js"
		} elseif (plugin = "highCharts-4.0.4-Helper") {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="highcharts-4-0-4/js/highcharts.js"
			set ^||jsIncludes($I(^||jsIncludes))="highcharts-4-0-4/js/themes/skies.js"
		} elseif (plugin = "HTML5Helper") {
			
		} elseif ((plugin = "jQM-1.3.2-Helper") || (plugin = "jQMHelper")) {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="jquery.mobile-1.3.2.min.js"
			set ^||cssIncludes($I(^||cssIncludes))="jquery.mobile-1.3.2.min.css"
		} elseif (plugin = "jQM-1.4.3-Helper") {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="jquery.mobile-1.4.3.min.js"
			set ^||cssIncludes($I(^||cssIncludes))="jquery.mobile-1.4.3.min.css"
		} elseif (plugin = "jQM-1.4.5-Helper") {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-2.0.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="jquery.mobile-1.4.5.min.js"
			set ^||cssIncludes($I(^||cssIncludes))="jquery.mobile-1.4.5.min.css"
		} elseif (plugin = "mojoDefaultHelper") {
			
		} elseif ((plugin = "googleMaps-3-Helper") || (plugin = "googleMapsHelper")) {
			set ^||jsIncludes($I(^||jsIncludes)) = "https://maps.googleapis.com/maps/api/js?sensor=true"
		} elseif (plugin = "bootstrap-3.3.x-Helper") {
			set ^||jsIncludes($I(^||jsIncludes))="jquery-1.11.3.min.js"
			set ^||jsIncludes($I(^||jsIncludes))="bootstrap-3-3-5/dist/js/bootstrap.min.js"
			set ^||cssIncludes($I(^||cssIncludes))="bootstrap-3-3-5/dist/css/bootstrap.min.css"
		}
	}
	
	// resolve dependencies
	kill ^||tempJsIncludes
	if ((firstChartKey '= -1) && (firstDojoKey '= -1) && (firstDojoKey < firstChartKey)) {
		// make sure chart.js gets included before dojo.js is
		set movedChart = 0
		set key = $O(^||jsIncludes(""))
		while (key '= "") {
			set include = ^||jsIncludes(key)
			if (key = firstDojoKey) {
				set ^||tempJsIncludes(key) = ^||jsIncludes(firstChartKey)
				set movedChart = 1
			} elseif(key > firstChartKey) {
				set ^||tempJsIncludes(key+movedChart) = ^||jsIncludes(key)
			} else {
				set ^||tempJsIncludes(key+movedChart) = ^||jsIncludes(key-1)
			}
			set key = $O(^||jsIncludes(key))
		}
		kill ^||jsIncludes
		merge ^||jsIncludes = ^||tempJsIncludes
	}
	
	
	set ^||tempJS = ""
	set key = $O(^||jsIncludes(""))
	while (key '= "") {
		set include = ^||jsIncludes(key)
		if ('$D(^||tempJS(include))) {
			set ^||tempJS(include) = ""
			if (jsIncludes = "") {
				set jsIncludes = include
			} else {
				set jsIncludes = jsIncludes _ "," _ include
			}
		}
		set key = $O(^||jsIncludes(key))
	}
	
	set ^||tempCSS = ""
	set key = $O(^||cssIncludes(""))
	while (key '= "") {
		set include = ^||cssIncludes(key)
		if ('$D(^||tempCSS(include))) {
			set ^||tempCSS(include) = ""
			if (cssIncludes = "") {
				set cssIncludes = include
			} else {
				set cssIncludes = cssIncludes _ "," _ include
			}
		}
		set key = $O(^||cssIncludes(key))
	}

	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="JSINCLUDES"
	set param.Default=jsIncludes
	do zenApp.Parameters.Insert(param)
	
	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="CSSINCLUDES"
	set param.Default=cssIncludes
	do zenApp.Parameters.Insert(param)

	set param=##class(%Dictionary.ParameterDefinition).%New()
	set param.Name="PROVIDERLIST"
	set param.Default="data,layout"
	do zenApp.Parameters.Insert(param)
	
	set xds=##class(%Dictionary.XDataDefinition).%New()
	set xds.parent=zenApp
	set xds.Name="Style"
	set xds.Data=##class(%Stream.TmpCharacter).%New()
	do xds.Data.Rewind()
	do xds.Data.Write(" <style type=""text/css"">"_$C(13,10)_"</style>"_$C(13,10))
	do xds.%Save()
	
	set xds=##class(%Dictionary.XDataDefinition).%New()
	set xds.parent=zenApp
	set xds.Name="pageContents"
	set xds.XMLNamespace="http://www.intersystems.com/zen"
	set xds.Data=##class(%Stream.TmpCharacter).%New()
	do xds.Data.Rewind()
	do xds.Data.Write(" <pane"_$C(13,10)_" xmlns=""http://www.intersystems.com/zen"""_$C(13,10)_" xmlns:mojo=""http://www.intersystems.com/zen/mojo"""_$C(13,10)_" layout=""none"""_$C(13,10)_">"_$C(13,10)_" <mojo:documentView"_$C(13,10)_" id=""mainView"""_$C(13,10)_"ongetdata=""return zenPage.getContent('data',key,criteria);"""_$C(13,10)_"ongetlayout=""return zenPage.getContent('layout',key,criteria);"""_$C(13,10)_"initialDocumentKey=""home"""_$C(13,10)_"initialLayoutKey=""home"""_$C(13,10)_">"_$C(13,10)_"<mojo:"_tPageManager_">"_$C(13,10))
	for i=1:1:$L(tHelperPlugins,",") {
		if ($P(tHelperPlugins,",",i) '= "") {
			do xds.Data.Write("<mojo:"_$P(tHelperPlugins,",",i)_"/>"_$C(13,10))
		}
	}
	do xds.Data.Write("</mojo:"_tPageManager_">"_$C(13,10)_"</mojo:documentView>"_$C(13,10)_"</pane>"_$C(13,10))
	do xds.%Save()

	set ok=zenApp.%Save()
	if ok { 
		set save=$system.OBJ.Compile(zenApp.Name) 
		if save {
			Do ..%AddToProject(zenApp.Name _ ".cls")
			Do ..%AddToSourceControl(zenApp.Name_ ".cls")		
		}
	}
	quit ok
}

/// This method is called when the template is complete. Any
/// output to the principal device is returned to the Studio.
Method %OnTemplateAction() As %Status
{
	Set tPackage = ..%GetValueByName("Package")
	Set tPageClassName = ..%GetValueByName("PageClassName")
	Set tPageName = ..%GetValueByName("PageName")
	set tPageManager = ..%GetValueByName("PageManager")
	set tHelperPlugins = ..%GetValueByName("hiddenChosenHelperPlugins")
	Set tTemplateName = ..%GetValueByName("TempClassName")
	Set tAppClassName = ..%GetValueByName("AppClassName")
	Set tAppName = ..%GetValueByName("AppName")
	Set tDomain = ..%GetValueByName("Domain")
	Set tJSInc = "" ;#..%GetValueByName("JSInc")
	Set tCSSInc = "" ;#..%GetValueByName("CSSInc")
	do ..CreateMojo(tPackage,tPageClassName,tPageName,tTemplateName,tAppClassName,tAppName,tDomain,tJSInc,tCSSInc,tPageManager,tHelperPlugins)
	;
	Quit $$$OK
}

ClassMethod CreateMojo(tPackage As %String, tPageClassName As %String, tPageName As %String, tTemplateName As %String, tAppClassName As %String, tAppName As %String, tDomain As %String, tJSInc As %String, tCSSInc As %String, tPageManager As %String, tHelperPlugins As %String) As %Status
{
	try {
		#dim tFullAppClassName = tPackage_"."_tAppClassName
		if tAppClassName'="" {
			set appstat=..CreateZenApp(tAppClassName,tPackage,tAppName,tPageClassName)
		} else {
			set tFullAppClassName = ""
		}
		
		set mojostat=..CreateZenMojoHomePage(tPageClassName,tPackage,tFullAppClassName,tPageName,tTemplateName,tDomain,tJSInc,tCSSInc,tPageManager,tHelperPlugins)
		set tempstat=..CreateZenMojoTemplate(tTemplateName,tPackage,tAppClassName,tDomain, tPageName,tPageManager)
	}
	catch {
	}
	quit $$$OK
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	#dim resultSet As %ResultSet
	#dim listBox As %ZEN.Component.listBox
	
	set listBox = ..%GetComponentById("ctrlHelperPlugins")
	set resultSet = ..HelperPluginsRS()
	do resultSet.%Execute()
	
	while resultSet.%Next() {
		
		set option = ##class(%ZEN.Auxiliary.option).%New()
		set option.value = resultSet.%GetData(1)
		set option.text = option.value
		
		do ..%AddComponent(option)
		do listBox.options.Insert(option)
		
	}
	
	Quit $$$OK
}

}
