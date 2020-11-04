Class %WebStress.Portal.NoResults Extends %WebStress.Portal.standardPage [ System = 4 ]
{

/// 
/// Set this to the appropriate application class.
Parameter APPLICATION = "%WebStress.Portal.Application";

/// 
/// Set this to the correct domain.
Parameter DOMAIN = "%WebStress";

/// 
/// Name of this page.
Parameter PAGENAME = "Webstress Portal";

XData Style
{
<style type="text/css">



</style>
}

XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>

<jsonProvider id="json" OnGetArray="GetFinderArray" OnSubmitContent="SubmitTest"/>

<html id="grid" />

</pane>
}

Method GetFinderArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{

	set tSC=$$$OK

	Set pMetaData = $LB("id","code","description","deleteme")

	set rs=##class(%SQL.Statement).%New(2,"%WebStress_Tables")

	set q="Select ID,Code,Description from NoResults"

	set x=rs.%Prepare(q)

	if x {

		set data=rs.%Execute()

		while data.%Next() {

			set pData(data.%ROWCOUNT)=$LB(data.id,data.Code,data.Description,0)

		}

	}

	Quit tSC
}

ClientMethod renderGrid() [ Language = javascript ]
{

	var griddiv=zen('grid').getEnclosingDiv();

	var json=zen('json');

	var model=json.getContentObject();

	var html=new Array();

	html[html.length]='<table class=tpTable><tbody class=tpBody><trow><th>ID</th><th>Code</th><th>Description</th></tr>';

	if (model&&model.children) {

		for (var n=0;n<model.children.length;n++) {

			var item=model.children[n];

			if (item.deleteme==1) {

			}

			else {

				var row = '<tr class=tpRow>';

				row=row+'<td>'+item.id+'</td>';

				row=row+'<td><input type=text id=code'+n+' size=20 value="'+item.code+'"/></td>';

				row=row+'<td><input type=text id=desc'+n+' size=50 value="'+item.description+'"/></td>';

				html[html.length]=row+'<td><input type=button class=commandButton value="Delete" onclick="zenPage.removeResult('+n+')"></td></tr>';

			}

		}

	}

	html[html.length]='<tr class=tpRow><td><input type=button class=commandButton value="Add Row" onclick="zenPage.addResult()"></td><td><input type=button class=commandButton value="Save Grid" onclick="zenPage.saveResults()"></td><td><input type=button class=commandButton value="Populate Table" onclick="zenPage.tablePopulate()"></td></tr></tbody></table>';

	griddiv.innerHTML=html.join('');
}

ClientMethod addResult() [ Language = javascript ]
{

	var json=zen('json')

	var model=json.getContentObject();

	var item=new Object();

	item.id='';

	item.code='';

	item.description='';

	item.deleteme='0';

	if (model&&model.children) {

		model.children[model.children.length]=item;

	}

	else {

		var model=new Object();

		model.children=new Array();

		model.children[model.children.length]=item;

		json.setContentObject(model)

	}

	zenPage.renderGrid();
}

ClientMethod saveResults() [ Language = javascript ]
{

	

	var json=zen('json')

	var model=json.getContentObject();

	if (model&&model.children) {

		for (var n=0;n<model.children.length;n++) {

			var item=model.children[n];

			if (item.deleteme==0) {

				item.code=self.document.getElementById('code'+n).value;

				item.description=self.document.getElementById('desc'+n).value;;

			}

		}

	}

	else {

		return

	}

	var ok=json.submitContent('save','%ZEN.proxyObject')

	if (!ok) {

		alert(json.getError());

	}

	else {

		json.reloadContents();

		zenPage.renderGrid();

	}
}

Method SubmitTest(pCommand As %String, pProvider As %ZEN.Auxiliary.jsonProvider, pSubmitObject As %RegisteredObject, Output pResponseObject As %RegisteredObject) As %Status
{

  Set tSC = $$$OK

  If ($IsObject(pSubmitObject)) {

   	for i=1:1:pSubmitObject.children.Count() {

	   	set result=pSubmitObject.children.GetAt(i)

	   	if result.deleteme=0 {

	   		if result.id="" {

		   		set ref=##class(%WebStress.Tables.NoResults).%New()

	   		}

	   		else {

		   		set ref=##class(%WebStress.Tables.NoResults).%OpenId(result.id)

	   		}

	   		if $IsObject(ref) {

	   			set ref.Code=result.code

	   			set ref.Description=result.description

	   			set save=ref.%Save()

	   		}

	   	}

	   	else {

	   		do ##class(%WebStress.Tables.NoResults).%DeleteId(result.id)

	   	}

   	}

  }

  Quit tSC
}

ClientMethod removeResult(id) [ Language = javascript ]
{

	var json=zen("json");

	var model=json.getContentObject();

	var item=model.children[id];

	item.deleteme='1';

	zenPage.renderGrid();
}

/// 
/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	zenPage.renderGrid();
}

ClientMethod tablePopulate() [ Language = javascript ]
{

	zenPage.Populate();

	json=zen("json");

	json.reloadContents();

	zenPage.renderGrid();
}

/// 
/// Return the array of links to show in the locator bar.<br/>
/// 
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{

	// default: make *this* page the complete list

	Set tPageName = $$$ZENVAL(..title)

	Set tPageName = $P(tPageName," ",$L(tPageName," "))

	Set pLink(1) = $LB(tPageName,$ZCVT(..%ClassName(1),"O","URL")_".zen?CSPSHARE=1")

	Quit $$$OK
}

/// 
/// This class method callback is called just before the server-side page 
/// 
/// object is created.
Method %OnAfterCreatePage() As %Status
{

	Set tSC = ##super()



	Quit tSC
}

/// 
/// Get the (localized) title string for the page.
/// 
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$Text("WebStress Portal")
}

Method Populate() As %Status [ ZenMethod ]
{
	quit ##class(%WebStress.Tables.NoResults).Populate()
}

}