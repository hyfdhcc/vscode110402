/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>Pane for Databases 
Class %CSP.UI.System.JournalPane Extends %CSP.Util.TablePane [ System = 4 ]
{

/// This method creates the %ResultSet object
/// that is used for the table pane.<br>
/// A subclass can override this to customize the 
/// table displayed by this pane.<br>
/// <var>pID</var> is array of page variables...
Method CreateResultSet(ByRef pID As %String, ByRef pRS As %ResultSet) As %Status
{
	Set tSC = $$$OK
	
	/// default version: use associated class query
	If (..SQLQuery '= "") {
		Set pRS = ##class(%ResultSet).%New()
		Set tSC = pRS.Prepare(..SQLQuery)
	}
	Else {
		Set pRS = ##class(%ResultSet).%New(..Query)
		If ('pRS.QueryIsValid()) {
			Quit $$$ERROR($$$GeneralError,"Invalid Query: " _ ..Query)
		}
	}

	Quit tSC
}

/// Show Last Update box
Method DrawLastUpdate()
{
	// Get text line for page; subclass can customize this behavior
	Set tText = ..GetDescriptiveText()

	Set msgUpdate = $$$Text("Last update: ")
	Set msgAuto = $$$Text("Auto")
	Set hlpUpdate = $$$Text("Click here to refresh this table.")
	Set hlpTime = $$$Text("Time when the contents of this page were last refreshed.")
	Set hlpAuto = $$$Text("If checked, then contents of this page will automatically refresh.")

	// show descriptive text
	&html<<table border="0" cols="2" cellpadding="3" width="80%"><tr>
		<td align="left" class="Text1">#($ZCVT(tText,"O","HTML"))#</td>
		<td align="left" class="Text" nowrap width="30%" style='cursor:pointer;' valign="bottom">>
		
	If ..ShowLastUpdate {
		&html<
		<div align="left" width="100%" style="border: 1px solid darkblue; background: white; padding: 0px; vertical-align: middle;">
		<span style="color: darkblue; font-size: 8pt;padding: 2px; vertical-align: middle;">
		<a title="#($ZCVT(hlpUpdate,"O","HTML"))#" onclick="refreshTable();">&#032;#($ZCVT(msgUpdate,"O","HTML"))#</a>
		<span id="lastupdate" title="#($ZCVT(hlpTime,"O","HTML"))#" style="font-weight: bold;">#($ZDT($ZU(188),3,,3))#</span>&#032;
		<input id="cbAuto" title="#($ZCVT(hlpAuto,"O","HTML"))#" style="vertical-align: middle; font-size: 0.5em;" type="checkbox" #($Case(..AutoRefresh,1:"checked",:""))# onclick="setAutoRefresh(this.checked);"><span title="#($ZCVT(hlpAuto,"O","HTML"))#" onclick="cspToggleCheckbox('cbAuto');">#($ZCVT(msgAuto,"O","HTML"))#&#032;</span>
		</span>
		</div>>
	}
	&html<</td></tr>>
		Do ..DrawChoices()
	&html<</table>>
}

/// Draw Mirrored choices for primary and backup failover members, for this pane below the tTitle and above the table.
Method DrawChoices()
{
	If $System.Mirror.GetInfo() [",DEFINED," {
		If $SYSTEM.Mirror.IsMember() {
			Set link1 = $$$TextHTML("All Journal Files")
			Set link2 = $$$TextHTML("Mirror Journal Files")
			Set url1 = ##class(%CSP.Page).Link("UtilSysJournals.csp")
			Set url2 = ##class(%CSP.Page).Link("UtilSysJournalsMirror.csp")
			&html<
			<tr><td colspan="2"><a href="#(url1)#">#(link1)#</a>&nbsp;&nbsp;<a href="#(url2)#">#(link2)#</a>
			</td></tr>
			>
		} 
	}
}

}
