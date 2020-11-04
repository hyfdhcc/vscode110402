Include (%sqlui, %syNLS)

/// This is the Zen version of the About page for System Management Portal.
Class %CSP.UI.Portal.About Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Class name of application this page belongs to.
/// Parameter APPLICATION = "%CSP.UI.Portal.Application";
/// Displayed name of this page.
Parameter PAGENAME = "About This System";

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// This Style block contains page-specific CSS style definitions.
XData CSS3Style
{
<style type="text/css">

TABLE.InfoTable	{ 
	background: rgb(237,236,228);
	border: 10px solid #E0E0E0;
	color: rgb(67,67,67);
	font-size: 12px;
	margin-left: 20px; 
	margin-right: 20px;
	border-radius: 5px;	
}
table.InfoTable th.title { 
	border-bottom: gray solid 1px; 
	font-weight: normal;
	font-size: 20px;
	background: rgb(156,154,140); 
	color: #FFFAE7;
	text-align: left;
	padding: 6px;
	padding-left: 5px;
	padding-right: 5px;
}
table.InfoTable td.data { 
	border-bottom: gray solid 1px; 
	border-right: gray solid 1px;
	font-size: 0.8em;
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;
}

table.InfoTable td.caption { 
	font-weight: bold;	
	border-bottom: gray solid 1px; 
	border-left: gray solid 1px; 
	border-right: gray solid 1px;
	font-size: 0.8em;
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;

}
</style>
}

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
TABLE.InfoTable	{ 
	background: rgb(237,236,228);
	border: 1px solid black;
	color: rgb(67,67,67);
	font-size: 12px;
	margin-left: 20px; 
	margin-right: 20px;
	-moz-border-radius: 5px;
	border-radius: 5px;	
}
table.InfoTable th.title { 
	border-bottom: gray solid 1px; 
	font-weight: normal;
	font-size: 20px;
	background: rgb(156,154,140); 
	color: #FFFAE7;
	text-align: left;
	padding: 6px;
	padding-left: 5px;
	padding-right: 5px;
}
table.InfoTable td.data { 
	border-bottom: gray solid 1px; 
	border-right: gray solid 1px;
	font-size: 0.8em;
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;
}

table.InfoTable td.caption { 
	font-weight: bold;	
	border-bottom: gray solid 1px; 
	border-left: gray solid 1px; 
	border-right: gray solid 1px;
	font-size: 0.8em;
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;

}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px" cellAlign="center">
<!--JMD1492-->
<button caption="Back" controlClass="commandButton" enclosingStyle="padding-left:20px;" onclick="history.back();"/>
<html OnDrawContent="DrawSysInfo"/>
</pane>
}

/// Get the (localized) title string for the page.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("About This System")
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit ..%OnGetTitle()
}

ClassMethod DrawSysInfo(pSeed As %String) As %Status
{
	Set Cluster = ##Class(%SYS.ClusterInfo).NodeStatus()
	If Cluster = "This system is not part of a cluster" Set Cluster = $$$TextHTML("This system is not part of a cluster")
	Set Mirror = ##class(%CSP.UI.System.Mirror).MemberStatus()
	Set EMS = $$GetEMSStatus^%SYS.CONFIG()
	Set Global = ##Class(%SYS.System).GetGlobalCache()
	Set Routine = ##Class(%SYS.System).GetRoutineCache()
	try {
		#; if HealthShare is installed get the version otherwise catch to the standard version code
		Set Version = ##class(%ZHSLIB.HealthShareMgr).VersionInfo()
	} Catch {
		Set Version = $System.Version.GetVersion()
	}
	Set Configuration = $p($zu(86),"*")
	Set Journal = ##class(%SYS.Journal.System).GetCurrentFileName()
	Set Port = ##class(%SQL.Manager.API).GetPort()
	Set LicensedTo = $$CustomerName^%SYS.LICENSE
	Set TimeSince = $ZDT(..TimeSince(),3)
	Set License = $$GetLicenseServer^%SYS.LICENSE()
	Set DBEncKeyID = $$$GetDBEncKeyID
	If DBEncKeyID = "" Set DBEncKeyID = $$$Text("Not available. Encryption is not activated.")
	Set webportstatus = ##class(%RoutineMgr).GetWebServerPort(.WebPort)
	If webportstatus = 0 Set WebPort = $ZCVT($$$FormatText($$$Text("%1 web server is not active."),WebPort),"O","HTML")
	Set NLSLOCALE = $ZCVT($$$LOCALENAME,"U")
	Set VersionTitle = $$$Text("This is the installed Cach&eacute; version.")
	Set ConfigurationTitle = $$$Text("Current active configuration file name.")
	Set GlobalTitle = $$$Text("Allocated Memory for Database Cache.")
	Set RoutineTitle = $$$Text("Allocated Memory for Routine Cache.")
	Set JournalTitle = $$$Text("Current journal file name.")
	Set PortTitle = $$$Text("The superserver controls all Cach&eacute; services and answers all process requests.")
	Set WebPortTitle = $$$Text("Port the Cach&eacute; web server is running.")
	Set LicenseTitle = $$$Text("License server is used to allocate the Cach&eacute; license units authorized by the license key.")
	Set LicensedToTitle = $$$Text("This is the Customer Name in your license key.")
	Set ClusterTitle = $$$Text("Status of shared disk cluster configurations for certain systems.")
	Set MirrorTitle = $$$Text("State of Mirroring on this system.")
	Set EMSTitle = $$$Text("Whether this instance is managed by Enterprise Manager.")
	Set TimeSinceTitle = $$$Text("Last Cach&eacute; starting time.")
	Set DBEncKeyIDTitle = $$$Text("Encryption status or Encryption key id if activated.")
	Set NLSLOCALETitle = $$$Text("NLS Locale")
	Set lblSystem = $$$Text("System Overview")
	Set PreferredLanguage = $$$Text("Select language locale for this session of the System Management Portal.")
	&html<<form method="post">>
	&html<<br><table class="InfoTable" border="0" cellspacing="0" cellpadding="0" >>
  	&html<<tr><th class="title" height="30" colspan=2>#(lblSystem)#>
    &html<</th></tr>>
	&html<<tr><td class="caption" title="#(VersionTitle)#">#($$$Text("Version"))#:</td><td class="data">#(Version)#</td></tr>>	
	&html<<tr><td class="caption" title="#(ConfigurationTitle)#">#($$$Text("Configuration"))#:</td><td class="data">#(Configuration)#</td></tr>>
	&html<<tr><td class="caption" title="#(GlobalTitle)#">#($$$Text("Database Cache (MB)"))#:</td><td class="data">#(Global)#</td></tr>>
	&html<<tr><td class="caption" title="#(RoutineTitle)#">#($$$Text("Routine Cache (MB)"))#:</td><td class="data">#(Routine)#</td></tr>>
	&html<<tr><td class="caption" title="#(JournalTitle)#">#($$$Text("Journal file"))#:</td><td class="data">#(Journal)#</td></tr>>
	&html<<tr><td class="caption" title="#(PortTitle)#">#($$$Text("Superserver Port"))#:</td><td class="data">#(Port)#</td></tr>>
	&html<<tr><td class="caption" title="#(WebPortTitle)#">#($$$Text("Web Server Port"))#:</td><td class="data">#(WebPort)#</td></tr>>
	&html<<tr><td class="caption" title="#(LicenseTitle)#">#($$$Text("License Server Address/Port"))#:</td><td class="data">#(License)#</td></tr>>
	&html<<tr><td class="caption" title="#(LicensedToTitle)#">#($$$Text("Licensed to"))#:</td><td class="data">#(LicensedTo)#</td></tr>>
	&html<<tr><td class="caption" title="#(ClusterTitle)#">#($$$Text("Cluster support"))#:</td><td class="data">#(Cluster)#</td></tr>>
	&html<<tr><td class="caption" title="#(MirrorTitle)#">#($$$Text("Mirroring"))#:</td><td class="data">#(Mirror)#</td></tr>>
	&html<<tr><td class="caption" title="#(EMSTitle)#">#($$$Text("Enterprise Manager status"))#:</td><td class="data">#(EMS)#</td></tr>>
	&html<<tr><td class="caption" title="#(TimeSinceTitle)#">#($$$Text("Time System Started"))#:</td><td class="data">#(TimeSince)#</td></tr>>
	&html<<tr><td class="caption" title="#(DBEncKeyIDTitle)#">#($$$Text("Encryption Key Identifier"))#:</td><td class="data">#(DBEncKeyID)#</td></tr>>
	&html<<tr><td class="caption" title="#(NLSLOCALETitle)#">#($$$Text("NLS Locale"))#:</td><td class="data">#(NLSLOCALE)#</td></tr>>
	&html<<tr><td class="caption">#($$$Text("Preferred language for this session:"))#</td><td class="data"><select name="PrefLang" id="PrefLang" onchange="return zenPage.callChangeLang(this.value);">>
	Set trLang("cs") = $$$Text("Czech")
	Set trLang("de") = $$$Text("German")
	Set trLang("en") = $$$Text("English")
	Set trLang("en-us") = $$$Text("English (United States)")
	Set trLang("es") = $$$Text("Spanish")
	Set trLang("fr") = $$$Text("French")
	Set trLang("it") = $$$Text("Italian")
	Set trLang("ja") = $$$Text("Japanese")
	Set trLang("ko") = $$$Text("Korean")
	Set trLang("nl") = $$$Text("Dutch")
	Set trLang("pt") = $$$Text("Portuguese")
	Set trLang("pt-br") = $$$Text("Portuguese (Brazil)")
	Set trLang("ru") = $$$Text("Russian")
	Set trLang("uk") = $$$Text("Ukrainian")
	Set trLang("zh") = $$$Text("Chinese")
	Set trLang("zh-cn") = $$$Text("Chinese (PRC)")
	Set trLang("zh-tw") = $$$Text("Chinese (Taiwan)")
    Set tlanguages = $$GetLanguages^%occMessages("%Utility","s")
    Set tlanglen = $listlength(tlanguages)
    Set tFound = 0
    &html<<option value="" selected>#($$$Text("-- Select a language --"))#</option>>
	For ti = 1:1:tlanglen {
		Set tlang = $list(tlanguages,ti)
		Set:tlang=%response.Language tFound = 1
		&html<<option value="#(tlang)#" #($S(tlang=%response.Language:"selected",1:""))#>#($S($D(trLang(tlang)):trLang(tlang),1:tlang))#</option>>
	}
	&html<</select>>
	If tFound = 0 {
		&html<<br/>#($$$FormatText($$$Text("'%1', which is your current NLS language, is not a supported localization language."),%response.Language))#>	
	}
	&html<</td></tr></table></form>>
	Do ##class(%CSP.Util.MenuPane).WriteCopyright()
	Quit 1
}

/// Returns last Cache start time.
ClassMethod TimeSince() As %String
{
 Set Secs = $p($zh,".")
 Set today = $h
 Set days = Secs\86400
 Set seconds = Secs#86400
 Set daystart = +today-days
 Set timestart = +$p(today,",",2) - seconds
 If timestart<0 s daystart = daystart - 1,timestart = 86400-(seconds-+$P(today,",",2))
 Quit daystart_","_timestart
}

/// User clicked to change preferred language.
ClientMethod callChangeLang(preflang As %String) [ Language = javascript ]
{
	var ok = this.ChangeLang(preflang);
	self.document.location.reload();
}

/// Change preferred language for this session and page
ClassMethod ChangeLang(preflang As %String) As %Boolean [ ZenMethod ]
{
	If $G(preflang) '= "" {
        Set %session.Language = preflang  ; change for the session
        Set %response.Language = preflang ; and for this page.
    }
    #; need to do this so it won't flash.
    Quit 1
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))

	// JMD1492 - special case for DeepSee User Portal
	If ($G(%request.Data("USERPORTAL",1))=1) {
		Set tPageName = $$$Text("DeepSee","%DeepSee")
		Set tURL = "_DeepSee.UserPortal.Home.zen"
		Set pLink($I(pLink)) = $LB(tPageName,tURL)
		Set tPageName = ..%OnGetPageName()
		Set tURL = ""
		Set pLink($I(pLink)) = $LB(tPageName,tURL)
	}
	Else {
		Set tPageName = $$$Text("System","%Utility")
		Set tURL = $$$GetHomePage
		Set pLink($I(pLink)) = $LB(tPageName,tURL)

		Set tPageName = ..%OnGetPageName()
		Set tURL = $ZCVT($classname(),"O","URL")_".zen"_$S(NAMESPACE="":"",1:"?$NAMESPACE="_NAMESPACE)
		Set pLink($I(pLink)) = $LB(tPageName,tURL)
	}
	Quit $$$OK
}

Method %OnGetSmallMenu(Output pMenu)
{
	// JMD1492 - special case for DeepSee User Portal
	If ($G(%request.Data("USERPORTAL",1))=1) {
		Set tMenu = ..%GetComponentById("mainMenu")
		If (tMenu) {
			Set tMenu.hidden = 1
		}
		Quit
	}
	Do ##super(.pMenu)
}

}
