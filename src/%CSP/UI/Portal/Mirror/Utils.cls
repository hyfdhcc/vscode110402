Include (%sySecurity, %syMirror)

/// Utility class for System Management Portal mirorring pages
Class %CSP.UI.Portal.Mirror.Utils [ Abstract, System = 4 ]
{

Parameter DOMAIN = "%Utility";

Property DisableRemove As %Boolean [ InitialExpression = 0 ];

Property DisableSave As %Boolean [ InitialExpression = 0 ];

Property ModifiedPrivateAddress As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property ShowVAI As %ZEN.Datatype.boolean [ InitialExpression = {$ZCVT($ZV,"U")["HP-UX"} ];

Property SSLLink As %ZEN.Datatype.string;

Property SSLDefined As %ZEN.Datatype.boolean [ InitialExpression = {$$$SSLDefined} ];

Property CurrentFOCmpMode As %Integer [ InitialExpression = 0 ];

Property CurrentASYNCmpMode As %Integer [ InitialExpression = 0 ];

/// make Superserver address the default for Private address, if user has not manually changed the Private address.
ClientMethod updateAddress(val, isZen) [ Language = javascript ]
{
	if (!this.ModifiedPrivateAddress) {
		if (isZen) {
			zen("MirrorAddress").setValue(val);
		} else {
			document.getElementById("ThisMemberPrivateAddress").value = val;
		}
	}
}

/// User modified compression mode.
ClientMethod CompressMode(val, isAsync) [ Language = javascript ]
{
	if (isAsync && (this.CurrentASYNCmpMode != val)) {
		this.CurrentASYNCmpMode = val;
		zenPage.doModified();
	} else if (!isAsync && (this.CurrentFOCmpMode != val)) {
		this.CurrentFOCmpMode = val;
		zenPage.doModified();
	}
}

/// user modified Private Address
ClientMethod modifiedAddress() [ Language = javascript ]
{
	this.ModifiedPrivateAddress = true;
	zenPage.doModified();
}

ClientMethod cleanInput(field) [ Language = javascript ]
{
	field.setValue(field.getValue().toUpperCase().replace(/ /g,''));
}

/// show/hide advanced or connectivity setting box
ClientMethod toggle(id) [ Language = javascript ]
{
	var current = zen(id).getProperty("hidden");
	zen(id).setHidden(!current);
}

/// show/hide SSL/TLS Config link. value = 1 is to show.
ClientMethod toggleSSL(value) [ Language = javascript ]
{
	zen("idWarnSSL").setHidden(value);
}

ClientMethod openSSL() [ Language = javascript ]
{
	zenLaunchPopupWindow(zenPage.SSLLink,'SSL','resizable,width=1000,height=700');
}

/// user selected a VIP from drop-down. put it into the textbox and show when ShowVAI is true.
ClientMethod selectVIP(value, useZen) [ Language = javascript ]
{
	zenPage.doModified();
	if (useZen) {
		zen("VirtualAddressInterface").setValue(value);
		if ((value != "")&&(zenPage.ShowVAI == 1)) {
			zen("idVAI").setHidden(false);
			zen("VirtualAddressInterface").setProperty("disabled", 0);
			zen("VirtualAddressInterface").focus();
		} else {
			zen("idVAI").setHidden(true);
		}
	} else {
		document.getElementById("VirtualAddressInterface").value = value;
		if ((value != "")&&(zenPage.ShowVAI == 1)) {
			document.getElementById("idVAI").style.display="block";
			document.getElementById("VirtualAddressInterface").disabled = 0;
			document.getElementById("VirtualAddressInterface").focus();
		} else {
			document.getElementById("idVAI").style.display="none";
		}
	}
}

/// This method is called by Mirror pages to return linkSSL and labelSSL by reference
/// If both %MirrorClient and %MirrorServer are defined, we will return "View Mirror..." link text.
/// Otherwise it is "Create...".
ClassMethod GetSSLLink(Output linkSSL As %String, Output lblSSL As %String) As %Status
{
	Set tSC = $$$OK
 	Try {
	 	Set SSLDefined = $$$SSLDefined
	 	If SSLDefined '= 1 Set SSLDefined = 0
	 	Set linkSSL = ..Link("/csp/sys/sec/%CSP.UI.Portal.Mirror.Dialog.SSL.zen",,1)_"isNew="_'+SSLDefined
	 	Set lblSSL = $S(SSLDefined=1:$$$TextHTML("Edit SSL/TLS"),1:$$$TextHTML("Set up SSL/TLS"))
 	} Catch Error {
	 	Set tSC = Error.AsStatus()
 	}
 	Quit tSC
}

/// This method is called by Mirror pages to build drop-down list for Interfaces
ClassMethod DrawNetworkInterface(pSeed As %String) As %Status
{
	Set selectOption = ""
	If pSeed = 1 {
		Set onchange = "zenPage.selectVIP(this.value,false);"
		Set selectText = $$$Text("--- Select one ---")
	} Else {
		If (pSeed '= "") {
			Set selectOption = pSeed
		}
		Set onchange = "zenPage.selectVIP(this.value,true);"
		Set selectText = $$$Text("--- Select one if Virtual IP is defined ---")
	}
	&html<<select id="VIPNetworkInterface" label="Network Interface:" onchange="#(onchange)#" />>
	&html<<option value="">#(selectText)#</option>>
	Set tList = ##class(%SYSTEM.INetInfo).GetListOfConfiguredInterfaces()
 	Set tItem = 1
 	While $listget(tList,tItem) '= "" {
 		Set value = $listget($listget(tList,tItem),1)
 		Set select = $select(selectOption = value:"selected",1:"")
 		&html<<option value="#(value)#" #(select)#>#($zconvert(value,"O","HTML"))#</option>>
 		Set tItem = tItem + 1
 	}
	&html<</select>>
	Quit $$$OK
}

Method SSLverification(mirrorname As %String) As %String [ ZenMethod ]
{
	Set mirname=$zcvt(mirrorname,"U")
	Set rc=##class(SYS.MirrorConfiguration).VerifyMirrorSSLCertificates(mirname,1)
	If '$$$ISOK(rc) {
		Quit $SYSTEM.Status.GetErrorText(rc)
	}
	Quit $$$Text("SSL certificates verification succeeded.")
}

Method InitialSSLverification(mirrorname As %String, instance As %String, ipaddr As %String, port As %String) As %String [ ZenMethod ]
{
	Set mirname=$zcvt(mirrorname,"U")
	Set SystemName=$$$GetDefaultSystemName
	Set RetrieveInfo=$LB(SystemName,0,instance,ipaddr,port)
	Set rc=##class(SYS.MirrorConfiguration).VerifyMirrorSSLCertificates(mirname,0,RetrieveInfo)
	If '$$$ISOK(rc) {
		Quit $SYSTEM.Status.GetErrorText(rc)
	}
	Quit ""
}

Method DisplayError(error As %Status) As %Status
{
	Set ..%GetComponentById("errmsg").value = ..EvalResult(error)
	Set ..%GetComponentById("errmsg").hidden = 0
	Set ..%GetComponentById("fld").hidden = 1
	Set ..DisableSave = 1
	Set ..DisableRemove = 1
	Quit $$$OK
}

ClassMethod AnyDNUpdates(MirrorName As %String) As %Integer [ ZenMethod ]
{
	s rs=##class(%ResultSet).%New("SYS.Mirror:PendingDNUpdates")
	d rs.Execute(MirrorName)
	Quit rs.Next()
}

}
