/// System Management Portal - System Operations - Database Details 
Class %CSP.UI.Portal.DatabaseDetails Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.DatabaseDetails.zen";

Parameter HELPADDRESS = "Home,Databases,Database Info";

/// Displayed name of this page.
Parameter PAGENAME = "Operation DatabaseDetails";

Parameter PARENTPAGE = "/csp/sys/op/%CSP.UI.Portal.OpDatabases.zen";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

/// Database Directory
Property PID As %String(ZENURL = "$ID1");

/// Database Name
Property DBName As %String(ZENURL = "DBName");

/// this page's link with PID and DBName
Property DatabaseDetailsPage As %String;

/// Server-side reference to the pane object so that the head and body sections can be added to the page correctly.
Property %Pane As %CSP.Util.Pane [ ServerOnly = 1 ];

/// Flag to indicate whether <property>%Pane</property>'s OnDrawHEAD() method has been executed.
Property paneDone As %Boolean;

XData Style
{
<style type="text/css">
/* override the image because this form is too tall */
.EditForm {
	background-image: url('');
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px;padding-top:10px;">
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>

<group id="page_1" width="100%">
<html id="detailBlock" OnDrawContent="DrawDetails"/>
</group>

</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	$$$SetRefreshTimer

	Set tPage = ##class(%CSP.Util.PageInstance).%New()
	Set ..%Pane=..GetDetailPane(tPage)

	Set ..LocatorHeader = $$$FormatText($$$Text("Database %1"),..DBName)

	Quit $$$OK
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = $$$Text("Databases")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set tURL = $ZCVT($className(),"O","URL")_".zen?$ID1="_..EscapeURL(..PID)_"&DBName="_..EscapeURL(..DBName)_$S(NAMESPACE="":"",1:"&$NAMESPACE="_..EscapeURL(NAMESPACE))
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	Set ..DatabaseDetailsPage = tURL

	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	Quit $$$OK
}

/// Add to the contents of the tool ribbon.
Method OnDrawRibbon() As %Status
{
	Do ..DrawAutoRefresh(..%GetPageName())
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Database Details")
}

/// For auto-refresh on this page.
ClientMethod updateView() [ Language = javascript ]
{
	document.location = this.DatabaseDetailsPage;
}

/// Draw the contents of the diagram header, in the HTMLDashboard style.
Method DrawDetails(pSeed As %String) As %Status
{
	Set tPage = ##class(%CSP.Util.PageInstance).%New()
	If '$IsObject(..%Pane) Set ..%Pane=..GetDetailPane(tPage)
	If '..paneDone {
		Do ..%Pane.DrawHEAD(tPage)
		Set ..paneDone = 1
	}
	Set tSC = ..%Pane.DrawBODY(tPage)
	Quit tSC
}

/// Add the HEAD section for <property>%Pane</property> and override some CSS styles if HTML5 is enabled.
/// Without these overrides, the font size is calculated to be 0.8px and padding is calculated to be 0 for the header cells..
Method %OnDrawHTMLHead() As %Status
{
	If $IsObject(..%Pane) {
		Set tPage = ##class(%CSP.Util.PageInstance).%New()
		Do ..%Pane.DrawHEAD(tPage)
		Set ..paneDone = 1
	}
	If ..cssLevel >= 3 {
		&html<<style type="text/css">
.HTMLMeterLabel, .HTMLMeterLabelSELECTED, .ValueMeterValue, .BarOn {
	font-size: 12.8px;
}
table.group td.HTMLGroupLabel {
	padding: 2px 2px 2px 20px;
}
</style>>
	}
	Quit $$$OK
}

/// Set properties for HTMLDashboardPane to draw details.
ClassMethod GetDetailPane(pInstance As %CSP.Util.PageInstance) As %CSP.Util.Pane [ Language = cache ]
{
	
	Set tPane = ##class(%CSP.Util.HTMLDashboardPane).%New()
	Set tPane.Text = "" 
	Set tPane.MetricClass = "SYS.Metrics"
	Set tPane.MetricMethod = "GetDatabaseMetrics"
	Set tPane.Orientation = "horizontal"
	Set tPane.ShowLegend = 0
	Set tPane.ShowIcons = 0
	#; Must set RefreshRate here otherwise the select row does not work. Though we do not intend use the built-in auto-refresh feature on this page (we have our own refresh control), thus the big number.
	Set tPane.RefreshRate = "6000000"
 
	#; First Group on the left containing "General Information"
	Set tGroup1 = ##class(%CSP.Util.HTMLGroup).%New()
	Do tPane.Meters.Insert(tGroup1)
	Set tGroup1.Dashboard = tPane
	Set tGroup1.Orientation = "horizontal"
	Set tGroup1.Width = 500
	Set tGroup1.Height = 20

	#; Group 11: "General Information"
	Set tGroup11 = ##class(%CSP.Util.HTMLGroup).%New()
	Do tGroup1.InsertMeter(tGroup11)
	Set tGroup11.Label=$$$Text("General Information")
	Set tGroup11.Orientation = "vertical"
	Set tGroup11.Width = 500
	Set tGroup11.Style="background: silver; border: 1px black solid;"

	// Add horizontal spacer in between two column groups
	Set tSpacer = ##class(%CSP.Util.HTMLSpacer).%New()
 	Do tGroup1.Meters.Insert(tSpacer)
	Set tSpacer.Width = 20

	#; Second Group on right containing "Database Size"
	Set tGroup2 = ##class(%CSP.Util.HTMLGroup).%New()
	Do tGroup1.InsertMeter(tGroup2)
	Set tGroup2.Dashboard = tPane
	Set tGroup2.Orientation = "vertical"
	Set tGroup2.Width = 500
	Set tGroup2.Height = 20

	#; Group 21: "Execution Details"
	Set tGroup21 = ##class(%CSP.Util.HTMLGroup).%New()
	Do tGroup2.InsertMeter(tGroup21)
	Set tGroup21.Label=$$$Text("Database Size")
	Set tGroup21.Orientation = "vertical"
	Set tGroup21.Width = 500
	Set tGroup21.Style="background: silver; border: 1px black solid;"

	// Add vertical spacer in between two groups
	Set tSpacer = ##class(%CSP.Util.HTMLSpacer).%New()
	Do tGroup2.Meters.Insert(tSpacer)
	Set tSpacer.Height = 20

	#; *************** LOAD DETAILS TO GROUPS ************************ ;#
 
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Directory"),"Directory",500,"",$$$Text("Name of directory where this database resides.")))
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Resource Name"),"ResourceName",500,"",$$$Text("Resource name assigned to this database.")))
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Mounted"),"Mounted",500,"",$$$Text("Indicates that this database is mounted.")))
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Read Only"),"ReadOnlyMounted",500,"",$$$Text("Indicates that this database is mounted as Read Only.")))
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Cluster Mounted"),"ClusterMounted",500,"",$$$Text("Indicates whether this database is mounted within a cluster.")))
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Encrypted"),"EncryptedDB",500,"",$$$Text("Indicates whether this database is encrypted.")))
 	Do tGroup11.InsertMeter(..BuildMeter($$$Text("Encryption Key ID"),"EncryptionKeyID",500,"",$$$Text("Indicates encryption key ID.")))

	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Block Size"),"BlockSize",500,"",$$$Text("Block size (bytes) for this database.")))
 	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Blocks"),"Blocks",500,"",$$$Text("Current number of blocks within this database.")))
 	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Max Size"),"MaxSize",500,"",$$$Text("Maximum size (Mbytes) allowed for this database.")))
 	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Size"),"Size",500,"",$$$Text("Current size (Mbytes) of this database.")))
 	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Expansion Size"),"ExpansionSize",500,"",$$$Text("Amount (Mbytes) this database will expand by.")))
 	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Last Expansion Time"),"LastExpansionTime",500,"",$$$Text("Last time this database expanded.")))
 	Do tGroup21.InsertMeter(..BuildMeter($$$Text("Full"),"Full",500,"",$$$Text("Indicates that this database is full.")))

 Quit tPane
}

}
