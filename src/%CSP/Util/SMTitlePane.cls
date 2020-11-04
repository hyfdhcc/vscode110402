Include (%sqlui, %sySystem)

/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>System Management Title Pane
Class %CSP.Util.SMTitlePane Extends %CSP.Util.Pane [ ServerOnly = 1, System = 4 ]
{

/// A collection of Links used to draw the locator within the title pane.
Property Locator As list Of Link;

/// Control whether or not User/Namespace is displayed or not.
Property ShowUsrNsp As %Boolean [ InitialExpression = 1 ];

/// Draw the HTML to display a title pane for this object.
Method DrawBODY(pInstance As PageInstance) As %Status
{
	Set $ZT = "Trap"

 	i $ZS<$$$MAXBBSZ { d $ZU(163,$$$MAXBBSZ) }
	Do ..DrawMenuStyleJS()
	Set actionText = $ZCVT(..Text,"O","HTML")
	Set IsLogout = $G(%request.Data("LOGOUT",1)) = 1
	
	Set homelink = "HREF="""_$P(##class(%CSP.Page).Link("/csp/sys/%25CSP.Portal.Home.zen"),"?",1)_"?isGoHome=1"_""""
	// test if user can use About box
	Set aboutPage = ##class(%CSP.Page).Link("_CSP.UI.Portal.About.zen")
	Set aboutLink = "HREF="""_aboutPage_""""
	Set aboutStyle = ""
	
	// if you are here without privilege, then no about
	If ('$System.Security.Check("%Admin_Manage","USE") &&
		'$System.Security.Check("%Admin_Operate","USE") &&
		'$System.Security.Check("%Admin_Secure","USE") &&
		'$System.Security.Check("%Development","USE") &&
		'$System.Security.Check("%DB_CACHESYS","READ")) {
		Set aboutLink = ""
		Set aboutStyle = "color: gray;"
	}
	
	// Call this method once to establish remote namespace asynchronous connection
	/* YSD844 If $G(%session.Data("$REMOTECONCALLED")) = "" {
		Set tSC = $$Connect^%SYS.NAMESPACE()
		If $$$ISERR(tSC) Set %session.Data("$REMOTECONCALLED") = 0 &html<<div class="ErrorBox">#($ZCVT($System.Status.GetErrorText(tSC),"O","HTML"))#</div>>
		Else  Set %session.Data("$REMOTECONCALLED") = 1
	} */
	Set ServerName = $zu(110)
	Set InstanceName = $P($zu(86),"*",2)
	Set IsEMSSetUp = ##class(%SYS.EMS).IsEMSSetUp()
	If IsEMSSetUp {
		Set EMSState = ##class(%SYS.EMS).GetInstanceState(.isManaged,.services)
		Set EMSServices = ""
		If isManaged {
			Set EMSServices = $$$Text("Managed Services:")_" "_services
		}
	}

	// YSD918 - Set %session.Data("$NAMESPACE") for future use
	Set defaultNS = $G(%session.Data("$NAMESPACE"))
	If defaultNS = "" Set defaultNS = ##class(%CSP.Util.TitlePane).GetDefaultNamespace()
	
	Set HomePage = ##class(%CSP.Page).Link("/csp/sys/UtilHome.csp")
	// find help URL for this page
	Set tHelp(1) = "MgtPortal"
	Set tHelp(2) = pInstance.Address
	Set helpURL = ##class(%CSP.Util.Librarian).FindDocBookLink(.tHelp)
	#; YSD1581 Remove the $NAMESPACE from the URL returned
	If helpURL [ "?$NAMESPACE=" Set helpURL = $P(helpURL,"?$NAMESPACE=",1)_"');"
	#; YSD1653 Set link1 = $P(##class(%CSP.Page).Link("/csp/sys/%25CSP.Login.cls"),"?",1)
	#; YSD2331 Set link1 = $P(##class(%CSP.Page).Link($ZCVT($$LoginPage^%SYS.cspServer("/csp/sys/%CSP.Portal.Home.zen"),"O","URL")),"?",1)
	Set link2 = $P(##class(%CSP.Page).Link("/csp/sys/%25CSP.Portal.Home.zen"),"?",1)
	Set logXURL = link2_"?CacheLogout=end"
	Set cmdHome = $$$TextHTML("Home")
	Set cmdAbout = $$$TextHTML("About")
	Set cmdHelp = $$$TextHTML("Help")
	Set cmdLogX = $$$TextHTML("Logout")
	
	Set cmdJumpTask = $$$TextHTML("Go to")
	Set msgJumpTask = $$$TextHTML("Go directly to the selected task")
	
	Set msgHome = $$$TextHTML("Go to the Home page")
	Set msgAbout = $$$TextHTML("Display the System Overview page")
	Set msgHelp = $$$TextHTML("Display help for this page")
	Set msgLogX = $$$TextHTML("End this session")

	Set cmdNamespace = $$$TextHTML("Namespace")	
	Set cmdServer = $$$TextHTML("Server")
	Set cmdInstance = $$$TextHTML("Instance")
	Set cmdLicense = $$$TextHTML("Licensed to")
	Set cmdUser = $$$TextHTML("User")

	Set msgServer = $$$TextHTML("Name of the machine this system is running on")
	Set msgInstance = $ZCVT($ZV,"O","HTML")
	Set msgLicense = $$$TextHTML("Name associated with current system license")

	If (IsLogout) {
		// show login command
		Set cmdLogX = $$$TextHTML("Login")
		Set logXURL = HomePage
		Set msgLogX = $$$TextHTML("Start a new Management Portal session")
	}
	Set ProductName = $$$TextHTML("Management Portal")
	Set home = %request.URL
	If home '= "" Set ProductName = ##class(%CSP.UI.Portal.Template).%GetProductName()
	&html<
	<noscript><div class="ErrorBox">#($$$TextHTML("WARNING: Your browser does not support JavaScript or it is disabled! The System Management Portal requires JavaScript be enabled to work properly."))# </div></noscript>>	
	&html<
	<tr><td>
	<table id="group_1" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr valign="top">
	<td>
	<div style="position:relative; top:0px; left:0px">
	<div class="portalTitle" style="background-color:rgb(232,231,226);">
	<div style="position:absolute; top:2px; left:20px">
	<div id="menuBar" class="csMenuBar" >	
	<div id="menuName" class="csMenuBarItem" caption='#($$$TextHTML("Menu"))#'>
	<div id="menuHolder" class="contextMenu">>
	#; layout children using the default layout.
	Do ##class(%ZEN.Portal.Application).GetContextLinks(.tLinks)
	Do ##class(%ZEN.Portal.standardPage).CheckContextLinks(.tLinks)
	Set item = $O(tLinks(""))
	While item '= "" {
		Set tCaption = $LG(tLinks(item),1)
		Set tURL = $LG(tLinks(item),2)
		Set tFinalURL = ##class(%CSP.Page).Link(tURL)
		If tURL '= tFinalURL {
			Set tEsp = $P(tFinalURL,"?",2)
			Set tURL = $P(tFinalURL,"?")_"?"_$zconvert(tEsp,"O","JS")
		}
		If (tCaption = "") {
			&html<<div class="csMenuSeparator"/></div>>
		} Else {
			&html<<div class="csMenuItem" onselect="self.document.location='#(tURL)#'" caption="#(tCaption)#"></div>>
		}
		Set item = $O(tLinks(item))
	}
	#; close contextMenu:
	&html<</div></div></div>>
	#; close csMenuBar at Menu level
	&html<</div>
	</div>>
	&html<
<script language="javascript">
//YSD2331: this was needed to restyle new "Menu" 
onloadHandler();
</script>
	>
	&html<
	<div class="portalTitleMenuBox">
	<a class="portalTitleLink" title="#(msgHome)#" #(homelink)#>#(cmdHome)#</a>
	<span>|</span>

	<a class="portalTitleLink" title="#(msgAbout)#" #(aboutLink)#>#(cmdAbout)#</a>
	<span>|</span>
	<a class="portalTitleLink" title="#(msgHelp)#" href="#(helpURL)#">#(cmdHelp)#</a>
	<span>|</span>
	<a class="portalTitleLink" title="#(msgLogX)#" href="#(logXURL)#">#(cmdLogX)#</a>
	<img height="1px" width="32px" src="images/spacer.gif"/>
	>

	Set homeCaption = $$$TextHTML("System")
	If home '[ "/csp/sys/" Set homeCaption = ProductName
	Set tCount = ..Locator.Count()
	Merge tID = pInstance.IDValues
	Set productLink = ##class(%CSP.Page).Link("/csp/sys/%25CSP.Portal.Home.zen",,1)
	Set tEsp = $P(productLink,"?",2)
	If tEsp '= "" {
		Set productLink = $P(productLink,"?")_"?"_$zconvert(tEsp,"O","JS")
	}
	If (tCount > 0) {
		For i = 1:1:tCount {
			Set tLink = ..Locator.GetAt(i)
			If i = 1 {			
				&html<<a class="portalTitleLink" href="#(productLink)#">#($S(homeCaption'="":homeCaption,1:$zconvert(tLink.Caption,"O","HTML")))#</a>>
			} Else {
				Set link = pInstance.MakeLink(tLink.HREF,.tID)
				Set tEsp = $P(link,"?",2)
				If tEsp '= "" {
					Set link = $P(link,"?")_"?"_$zconvert(tEsp,"O","JS")
				}
				&html<<span>&gt;&nbsp;</span><a class="portalTitleLink" href="#(link)#">#($zconvert(tLink.Caption,"O","HTML"))#</a>>
			}
		} 
	}
	&html<</div>>
	#; end of <div> portalTitleMenuBox

	Set tSystemMode = $G(^%SYS("SystemMode"))
	Set tSystemStyle = ""
	Set tSystemMsg = ""
	If (tSystemMode = "LIVE") {
		Set tSystemMsg = $$$TextHTML("This is a Live System")
		Set tSystemStyle = "text-align: center; background: red; color: white; font-size:12pt; padding:2px; border: 1px solid #404040; -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "TEST") {
		Set tSystemMsg = $$$TextHTML("This is a Test System")
		Set tSystemStyle = "text-align: center; background: #D0D0D0; color: #404040; font-size:12pt; padding:2px; border: 1px solid #404040; -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "FAILOVER") {
		Set tSystemMsg = $$$TextHTML("This is a Failover System")
		Set tSystemStyle = "text-align: center; background: #D0D0D0; color: #404040; font-size:12pt; padding:2px; border: 1px solid #404040;"
	}
	ElseIf (tSystemMode = "DEVELOPMENT") {
		Set tSystemMsg = $$$TextHTML("This is a Development System")
		Set tSystemStyle = "text-align: center; color: #404040; font-size:10pt; padding:2px;"
	}
	ElseIf (tSystemMode '= "") {
		// show value as a string
		Set tSystemMsg = $ZCVT(tSystemMode,"O","HTML")
		Set tSystemStyle = "text-align: center; color: #404040; font-size:10pt; padding:2px;"
	}
	#; handle long names and IE 9 background color problem
	Set tTitleStyle = "style='background-color:rgb(53,107,141);'"
	If ($L(actionText)>28) {
		// smaller font
		Set tTitleStyle = tTitleStyle_"font-size:12px;"
	}
	If ($L(actionText)>100) {
		// aaa...bbb
		Set actionText = $ZSTRIP($E(actionText,1,40),"<>W")_"..."_$ZSTRIP($E(actionText,$L(actionText)-40,$L(actionText)),"<>W")
	}

	&html<<div class="portalTitleTabBox" #(tTitleStyle)# id="titleTab">#(actionText)#<span id="modifiedIndicator">&nbsp;</span></div>

	<div class="portalTitleInfoBox">
		<table border="0" cellspacing="0" cellpadding="1">
		<tr>
		<td align="right" class="portalTitleInfoLabel" title="#(msgServer)#">#(cmdServer)#:</td>
		<td class="portalTitleInfoVal" style="background: #60A060; color: white;">#(ServerName)#&nbsp;</td>
		<td align="right" class="portalTitleInfoLabel">#(cmdNamespace)#:</td>
		<td class="portalTitleInfoVal">#($ZU(5))#</td>
		<td align="left" colspan="4" nowrap="1" class="portalTitleInfoVal" style="#(tSystemStyle)#">#(tSystemMsg)#</td>
		</tr>

		<tr>
		<td align="right" nowrap="1" class="portalTitleInfoLabel">#(cmdUser)#:</td><td class="portalTitleInfoVal" nowrap="1">#($Username)#&nbsp;</td>
		<td align="right" nowrap="1" class="portalTitleInfoLabel" title="#(msgLicense)#">#(cmdLicense)#:</td><td class="portalTitleInfoVal" nowrap="1">#($ZCVT($$CustomerName^%SYS.LICENSE,"O","HTML"))#&nbsp;</td>
		<td align="right" nowrap="1" class="portalTitleInfoLabel" title="#(msgInstance)#">#(cmdInstance)#:</td><td class="portalTitleInfoVal" nowrap="1">#($P($zu(86),"*",2))#&nbsp;</td>>
		If IsEMSSetUp {
			&html<<td align="right" class="portalTitleInfoLabel" nowrap="1" title="#(EMSServices)#">#($$$TextHTML("Enterprise Manager Status"))#:</td><td class="portalTitleInfoVal" nowrap="1" title="#(EMSServices)#">#($ZCVT(EMSState,"O","HTML"))#&nbsp;</td>>
		} Else {
			&html<<td colspan="2">>
		}
		&html<</tr>
		</table>
	</div>>

	/// end of portalTitleInfoBox
	Set tPower = $$$TextHTML("Powered by Zen")
	&html<
	<div class="portalLogoBox">
	<div class="portalLogo" title="#(tPower)#">#(ProductName)#</div>
<div class="portalLogoSub">by InterSystems</div>
	</div>>
	/// end of portalLogoBox
	
	&html<</div></div>>
	/// end of portalTitle

	&html<
	</td>
	</tr>
	</table>
	</td>
	</tr>
	>
Done
	Quit $$$OK
Trap
	Set $ZT=""	
	Write !,$$$Text("Error occurred"),": ",$ZE,!
	Goto Done
}

/// Draw username or server name depend on setup.
Method DrawUsername()
{
	Set msgUser = $$$TextHTML("User")
	Set msgServer = $$$TextHTML("Server")
	Set msgInstance = $$$TextHTML("Instance")
	Set hlpUser = $$$TextHTML("Name of user logged into this session")

	if (..ShowUsrNsp) {		
		If (%session.Username '= "") {
		#; YSD1899
			Set linkUser = ##class(%CSP.Page).Link("/csp/sys/UtilUserChangePassword.csp")
			&html<<tr><td title="#(hlpUser)#" class="quote-name" style="text-align: left;">
			<span style="color:#FFFAE7; font-size:8pt; padding-right:5px;">#(msgUser)#:</span><b>>
			If $ZU(5) = "%SYS" &html<<a href="javascript:launchPopupWindow('#(linkUser)#');" style="color:#990000;">>
			&html<#(%session.Username)#>
			If $ZU(5) = "%SYS" &html<</a>>
			&html<</b></td></tr>>
		}
	}
	else {
		/* YSD2289
		// Use SERVER and Instance otherwise
		set defaultServer = $G(%session.Data("SERVER"))
		set:defaultServer="" defaultServer = $System.Server.HostName(),%session.Data("SERVER") = defaultServer 
		&html<<tr><td class="quote-name">#(msgServer)#: #(defaultServer)#</td></tr>>

		set defaultCfg = $G(%session.Data("CONFIG"))
		set:defaultCfg="" defaultCfg = $p($zu(86),"*",2),%session.Data("CONFIG") = defaultCfg
		&html<<tr><td class="quote-name">#(msgInstance)#: #(defaultCfg)#</td></tr>>
		*/
	}
}

/// Handle ShowUsrNsp
Method OnGenerateCode() As %String
{
	Set code = ""

	// ShowUsrNsp
	If (..ShowUsrNsp '= "") {
		Set code = code _ " Set tPane.ShowUsrNsp = " _ +..ShowUsrNsp _ $$$EOL
	}

	Quit code
}

/// Draw CSS style and JS functions for Context Menu.
Method DrawMenuStyleJS()
{
	&html<
	<style type="text/css"> 
.csMenuBar {
	 display:block;
	 background-color:white;
	 border:1px solid gray;
	 height:18px; 
	 width:50px;
}

.csMenuBarItem {
    display:inline;
    cursor:pointer;
    font: 12px arial;
    background: white;
    color: black;
}

.csMenuItem {
    position:absolute;
    cursor:pointer;
    font:12px arial;
    background:white;
    color:black;
    height:20px;
}

.csActiveMenuItem {
    position:absolute;
    cursor:pointer;
    font:12px arial;
	background: #f6f5f3;
	color: #404040;
    height:20px;
}

.contextMenu {
     display:none;
     position:absolute;
     background-color: white;
     border:2px outset #b0b0b0;
     padding: 2px;
     width:150px;
  }

  .shadow {
      background-image: url(/csp/broker/images/shadow.png);
  }
</style>
<script language="javascript" type="text/javascript" src="#(##class(%CSP.Page).Link("/csp/broker/zenCSLM.js"))#"></script>
<script language="javascript" type="text/javascript" src="#(##class(%CSP.Page).Link("/csp/broker/zenMenus.js"))#"></script>
<script language="javascript">
function showMenu()
{
	var menuHolder = document.getElementById("menuHolder");
	var show = "block";
	if (menuHolder.style.display=="block") show = "none";
	menuHolder.style.display = show;
}

function onloadHandler()
{
	// dispatch to get correct disabled handling
    ZMS.initialize();
    ZMS.DownArrowIcon = '#(##class(%CSP.Page).Link("/csp/broker/images/DownArrow.png"))#';
    ZMS.SmallDownArrowIcon = '#(##class(%CSP.Page).Link("/csp/broker/images/SmDownArrow.png"))#';
    ZMS.UpArrowIcon = '#(##class(%CSP.Page).Link("/csp/broker/images/UpArrow.png"))#';
    ZMS.RightArrowIcon = '#(##class(%CSP.Page).Link("/csp/broker/images/RtArrow.png"))#';
    ZMS.CheckmarkIcon = '#(##class(%CSP.Page).Link("/csp/broker/images/Checkmark.png"))#';
    var styleStr = "'display:none; position:absolute; top:0px; left:0px; width:100%; height: 100%; z-index:1;'";
    ZMS.mouseTrap = ZLM.simulateTag("div id='menuMouseTrap' style=" + styleStr + " onclick='ZMS.closeMenu(event);' oncontextmenu='ZMS.ignore(event);' onmouseup='ZMS.ignore(event);'");
    document.body.appendChild(ZMS.mouseTrap);
   
    //SAM133 document.oncontextmenu = ZMS.ignore;

    ZLM.initKeyboardHandler();
    ZLM.registerShortCut("escape", "ZMS.closeMenu(null);", "page");
    ZLM.pushKeyContext("page");
    var items = ZLM.getElementsByClassPrefix("csMenuItem", document.body);
    for (var i = 0; i < items.length; i++) {
        ZMS.createMenuItemSubtree(items[i]);
    }
	var menus = ZLM.getElementsByClassPrefix("contextMenu", document.body);
	for (var i = 0; i < menus.length; i++) {
	    ZMS.estimateContextMenuSize(menus[i]);
	    ZMS.setContextMenuSize(menus[i]);
	}

    var bars = ZLM.getElementsByClassPrefix("csMenuBar", document.body);
    for (var i = 0; i < bars.length; i++) {
        ZMS.sizeMenuBar(bars[i]);
        //debug ZLM.dumpDOMTreeGeometry(bars[i]);
    }
    for (var i = 0; i < bars.length; i++) {
        ZMS.organizeMenuBar(bars[i]);
    }

    ZMS.initialized = 1;
    /* YSD2588
    if (ZLM.isIE) {
	 	var m = document.getElementById("menuName");
	 	m.style.top = "-7px";
	 	m.style.left = "7px";
	}
	*/
    ZLM.refreshLayout(); 
    
    var m = document.getElementById("menuName");
    if (!ZLM.isIE && !ZLM.isFF) {
	    for (var k=m.firstChild;k!=null;k=k.nextSibling) {
		    if (k.className && k.className=="csActiveMenuItem") {
			    k.style.position="absolute";
			    k.style.top="0px";
			    k.style.left="0px";
			    k.style.width="100%";
			    k.style.height="100%";
		    }
	    }
    }
}
</script>
 >
}

/// Overwritten by subclasses to draw anything this pane needs for the HEAD section.
Method DrawHEAD(pInstance As PageInstance) As %Status
{
	&html<<link rel="shortcut icon" href="portal/sysoperate.ico">>
	Quit $$$OK
}

}
