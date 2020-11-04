/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>This page is invoked from the System Management Portal to invoke the Ensemble Portal.
/// If "ensemble" namespace exists then use it as default. Otherwise use the first one found from %SYS("Ensemble","InstalledNamespace").</p>
Class %CSP.Util.EnsStart Extends %CSP.Page [ ServerOnly = 1, System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Return total number of namespaces that installed Ensemble,
/// and array of the namespaces if any.
ClassMethod GetNamespaces(ByRef Namespaces As %String = "") As %Integer
{
	Set Namespace = ""
	For Total = 0:1  Set Namespace = $O(^%SYS("Ensemble","InstalledNamespace",Namespace)) Quit:Namespace=""  Set Namespaces($zconvert(Namespace,"l"))=""
	Quit Total
}

/// Return 1 or 0 to indicate whether Ensemble is installed
ClassMethod IsEnsembleInstalled() As %Boolean
{
	Quit $D(^%SYS("Ensemble","InstalledNamespace"))>0
}

/// Event handler for <B>PreHTTP</B> event: this is invoked before
/// the HTTP headers for a CSP page have been sent. 
/// <p> 
/// When User clicks Ensemble from the Management Portal, this page will be invoked, and one of the following will happen
/// <ol><li>If there is only one Ensemble namespace then we redirect the page to the Ensemble Home page</li>
/// <li>If there are more than one Ensemble namespaces then we display this page and prompt the user to select a namespace.</li> 
/// <li>If no Ensemble namespaces are found (it should not happen as the Ensemble link would not be available from the Management Portal) the OK button is disabled.</li>
/// </ol>
/// </p>
ClassMethod OnPreHTTP() As %Boolean
{
	Set Total = $G(%request.Data("Total",1),..GetNamespaces(.Namespaces))
	Set Namespace = "ensemble"
	If '$D(Namespaces(Namespace)) Set Namespace = $O(Namespaces(""))
	// If only one Ensemble installed then redirect to it directly
	If Total > 0 {
		Set Url = ##class(%EnsembleMgr).DetermineMgmtURLForNamespace(Namespace)
		Set:Url="" Url="/csp/"_..EscapeURL(Namespace)_"/UtilEnsHome.csp"
		Set %response.Redirect = ..Link(Url)
	}
	
	Quit $$$OK
}

/// Form for user to log in to a specific Ensemble namespace.
/// <p>User should enter username (_SYSTEM as default provided), password and select a namespace.
ClassMethod OnPage() As %Status
{
	Set msgStartTitle = $$$Text("Ensemble Management Portal")
	Set msgSelect = $$$Text("Please select a namespace:")
	Set cmdOK = $$$Text(" OK ")
	Set cmdCancel = $$$Text("Cancel")
	Set refreshpage = $G(%request.Data("refreshpage",1))
	If refreshpage = "" Set refreshpage = $G(%request.CgiEnvs("HTTP_REFERER"))
	Set refreshpage = ##class(%CSP.Portal.Utils).GetValidatedLink(refreshpage)
	If refreshpage = "" {
        Set refreshpage = ..Link("/csp/sys/%25CSP.Portal.Home.zen")
    }

	&html<
<head>
<style type="text/css">
body		{ color: black; background: #DDDDFF; 
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 1.0em;
				margin: 0px;
			 }
table.LayoutMain {
	margin: 0px;
	padding: 0px;
}
	
table.LayoutMain TR {
	vertical-align: top;
}
td.Title { font-family: Verdana, Arial, Helvetica, sans-serif;
				text-decoration: none;
				text-align: center;
				font-weight: none; 
				font-size: 1.6em;
				color: white;
				background: blue;
				margin: 0px;
				padding: 5px;
			filter: 
				progid:DXImageTransform.Microsoft.Gradient(GradientType=2, StartColorStr='#6060FF', EndColorStr='#000020');
			 }
DIV.TitleText {
	font-size: 1.4em;
	font-family: "Lucida Sans Unicode" "Courier New";
	font-weight: bold;
	color: white;
	width: 80%;
	filter:
		progid:DXImageTransform.Microsoft.dropShadow(color=#404040, OffX=2, OffY=2, Positive=2);
}

TABLE.AutoForm	{ border: black solid 1px; font-size: 0.8em;
					background: #DDEEFF;
					width: 30%;
					margin-left: 20px; margin-right: 20px;
			filter:
				progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr='#A0A0FF', EndColorStr='#E0E0FF')
				progid:DXImageTransform.Microsoft.dropShadow(color=#404040, OffX=2, OffY=2, Positive=2);
			}
TD.AutoFormCaption {
			text-align: right;
			}


TD.AutoFormButton {
			padding-top: 10px;
			text-align: right;
			}

DIV.text1	{	font-size: 0.8em; 
				margin-left: 20px; margin-right: 40px;
				margin-top: 20px;
				margin-bottom: 20px;
			}

DIV.text1:first-letter	{font-size: 1.4em;  }

</style>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="self.document.theForm.Namespace.focus();">
<table border="0" class="LayoutMain" width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr><td colspan="2" class="Title" width="100%">
<div class="TitleText">#(msgStartTitle)#</div>
</td></tr>
<tr height="100%">
<td class="LayoutContentCol"><br>
<div align="center">
<form method="get" name="theForm">
<input type="hidden" name="refreshpage" value="#($zconvert(refreshpage,"O","HTML"))#">
<table class="AutoForm">
<tr class="AutoForm" valign="center">
<td class="AutoFormCaption" nowrap>&nbsp; #(msgSelect)#</td>
<td nowrap>
<select name="Namespace">
>
	Set Total = ..GetNamespaces(.Namespaces)
	Set name = $O(Namespaces(""))
	Set selname = $G(%request.Data("Namespace",1),name)
	While name '= "" {
		&html<<option value="#($zconvert(name,"O","HTML"))#" #($S(name=selname:"selected",1:""))#>#($ZCVT(name,"O","HTML"))#</option>>
		Set name = $O(Namespaces(name))
	}
	&html<
</select>
</td>
<input type="hidden" name="Total" value="#(Total)#">
</tr>
<tr><td class="AutoFormLabel">&nbsp;</td>
<td class="AutoFormButton">
<input class="AutoFormButton" type="submit" 
						name="$AUTOFORM_LOGIN" 
						value="#(cmdOK)#" #($S(Total=0:"disabled",1:""))#>&nbsp;
<input type="button" name="btnCancel" value="#(cmdCancel)#" onclick="document.location='#($zconvert(refreshpage,"O","HTML"))#'">
</td></tr>

</table>
</form>
</div>
</td>
</tr></table>
	>
	Quit $$$OK
}

}
