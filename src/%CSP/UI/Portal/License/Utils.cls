Include %sySystem

Class %CSP.UI.Portal.License.Utils [ Abstract, System = 4 ]
{

/// Domain used for localization.
Parameter DOMAIN = "%Utility";

Property RestartMsg As %String [ InitialExpression = {$$$Text("System Restart Required - The cache.key in MGR will not take effect until restart.")} ];

ClientMethod doPrint(filename) [ Language = javascript ]
{
	var url = zenLink("%CSP.UI.Portal.License.Print.zen?Filename="+encodeURIComponent(filename));
	zenLaunchPopupWindow(url,'Print','status,scrollbars,resizable=yes');
}

ClassMethod GetLicenseInfo(Output ret As %Library.ArrayOfDataTypes) As %Status
{
	Set ret = ""
	Set tRS = ##class(%ResultSet).%New("%SYSTEM.License:Key")
	Set tSC = tRS.Execute(1)
	If $$$ISERR(tSC) Quit tSC

	If tRS.Next() Set oLicenseCapacity = tRS.GetData(2)
	If tRS.Next() Set oCustomerName = tRS.GetData(2)
	If tRS.Next() Set oOrderNumber = tRS.GetData(2)
	If tRS.Next() Set oExpirationDate = tRS.GetData(2)
	If tRS.Next() Set oAuthorizationKey = tRS.GetData(2)
	If tRS.Next() Set oMachineID = tRS.GetData(2)
	If tRS.Next() Set oApplicationKey = tRS.GetData(2)
	Set HasApplications = ##class(%SYSTEM.License).IsApplicationAuthorizationKey("*",oAuthorizationKey)
	Set HasApplications2 = ##class(%SYSTEM.License).IsApplication("*")
	If (HasApplications '= "") || (HasApplications2 '= "") {
		For n = 1:1:$L(HasApplications,",") {
			Set AppKey = $P(HasApplications,",",n)
			If AppKey '= "" {
				Set ApplicationKey(AppKey) = ##class(%SYSTEM.License).IsApplicationAuthorizationKey(AppKey,oAuthorizationKey)
			}
		}
		For n = 1:1:$L(HasApplications2,",") {
			Set AppKey = $P(HasApplications2,",",n)
			If AppKey '= "" {
				Set ApplicationKey(AppKey) = 1
			}
		}
	}
	Set ret("LicenseCapacity") = $G(oLicenseCapacity)
	Set ret("CustomerName") = $G(oCustomerName)
	Set ret("OrderNumber") = $G(oOrderNumber)
	Set ret("ExpirationDate") = $G(oExpirationDate)
	Set ret("AuthorizationKey") = $G(oAuthorizationKey)
	Set ret("MachineID") = $G(oMachineID)
	Set ret("FileType") = $SYSTEM.License.KeyFileType()
	Set ApplicationKey = ""
	If $O(ApplicationKey("")) '= "" {
		Do tRS.Execute(2)		
		While tRS.Next() {
			Set tField = tRS.Data("Field")
			Set tValue = tRS.Data("Value")
			If tValue = "",$E(tField)="[" {
				Set:ApplicationKey'="" ApplicationKey = ApplicationKey _ "<br/>"
				If (ApplicationKey="") {
					Set ApplicationKey = ApplicationKey_tField
				} Else {
					Set ApplicationKey = ApplicationKey_"<br/>"_tField
				}
				Continue
			}
			Set ApplicationKey = ApplicationKey_"<br/>"_tField_"="_..EscapeHTML(tValue)
		}
	}
	Set ret("ApplicationKey") = ApplicationKey
	
	Quit $$$OK
}

/// Draw HTML for the current activated license on the system. 
/// This method is called by LicensePrint also.
ClassMethod DrawLicense(pSeed As %String) As %Status
{
	Set tSC = ..GetLicenseInfo(.licArray)
	If $$$ISERR(tSC) Quit tSC

	&html<<table class="tpTable">
	<tr>
	<td class="caption" nowrap>#($$$TextHTML("License Capacity"))#</td>
	<td class="normal" nowrap>&nbsp;#($ZCVT(licArray("LicenseCapacity"),"O","HTML"))#</td>
	</tr>
	<tr>
	<td class="caption" nowrap>#($$$TextHTML("Customer Name"))#</td>
	<td class="normal" nowrap>&nbsp;#($ZCVT(licArray("CustomerName"),"O","HTML"))#</td>
	</tr>
	<tr>
	<td class="caption" nowrap>#($$$TextHTML("Order Number"))#</td>
	<td class="normal" nowrap>&nbsp;#($ZCVT(licArray("OrderNumber"),"O","HTML"))#</td>
	</tr>
	<tr>
	<td class="caption" nowrap>#($$$TextHTML("Expiration Date"))#</td>
	<td class="normal" nowrap>&nbsp;#($ZCVT(licArray("ExpirationDate"),"O","HTML"))#</td>
	</tr>
	<tr>
	<td class="caption" nowrap>#($$$TextHTML("Authorization Key"))#</td>
	<td class="normal" nowrap>&nbsp;#($ZCVT(licArray("AuthorizationKey"),"O","HTML"))#</td>
	</tr>
	<tr>
	<td class="caption" nowrap>#($$$TextHTML("Machine ID"))#</td>
	<td class="normal" nowrap>&nbsp;#($ZCVT(licArray("MachineID"),"O","HTML"))#</td>
	</tr>>
	If licArray("ApplicationKey") '= "" {
		&html<<tr>
		<td class="caption" nowrap valign="top">#($$$TextHTML("Application Key"))#</td>
		<td>#(licArray("ApplicationKey"))#</td>
		</tr>>	
	}
	&html<</table>>
	
	Quit $$$OK
}

/// Draw HTML for the license file in the License Key File field. This may or may not be activated.
/// This method is called by LicensePrint also.
ClassMethod DrawFile(pFile As %String, isPrint As %Boolean = 0) As %Status
{
	If pFile = "" Quit $$$OK
	
	#; Check if file is cache.key!
	Set tmsg = ""
	#; Check if path entered is a directory
	If ##class(%File).DirectoryExists(pFile) {
		Set tmsg = $$$TextHTML("Path entered is not a license key file.")
	} ElseIf '##class(%File).Exists(pFile) {
		Set tmsg = $$$TextHTML("File does not exist.")
	} Else {
		Set tSC = ##class(%SYSTEM.License).IsValidKey(pFile,.RequiresRestart,.RestartReason)
		If $$$ISERR(tSC) {
			Set tmsg = ..EvalResult(tSC)
		}
	}
	If tmsg '= "" {
		Set errorClass = $CASE(isPrint,1:"rednote",:"errorNote")
		&html<<span class="#(errorClass)#" style="display:inline-block;">#(tmsg)#</span>>
		Quit $$$OK
	}

 	Set stream = ##class(%Stream.FileCharacter).%New()
 	Set stream.Filename = pFile
 	Do stream.Rewind()
	&html<<div style="padding:2px;background:#fff;"><pre>>
 	While 'stream.AtEnd {
 		Set line = stream.ReadLine()
 		&html<#($ZCVT(line,"O","HTML"))#<br/>>
	}
	&html<</pre></div>>
	Kill stream	
	
	If ((RestartReason '= "") && isPrint) {
		Set noteClass = $CASE(isPrint,1:"caption",:"note")
		&html<<span class="#(noteClass)#" style="margin-top:5px;display:inline-block;">>
		&html<#($$$FormatText($$$Text("System restart will be required for this key: %1"),$zconvert(RestartReason,"O","HTML")))#>
		&html<</span>>
	}
	Quit $$$OK
}

}
