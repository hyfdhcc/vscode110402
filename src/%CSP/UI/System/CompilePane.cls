/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>This pane handles displaying, selecting, and compiling classes and routines.
Class %CSP.UI.System.CompilePane Extends %CSP.Util.ExpPane [ System = 4 ]
{

Method CreateResultSet(ByRef pRS As %ResultSet) As %Status
{
	Set tSC = $$$OK
	Set Query = "%RoutineMgr:StudioOpenDialog"
	If %request.PageName [ "Routine" {
		Set SEARCHMASK = ..GetSearchMask()
		#;YSD1759 If SEARCHMASK '[ ";" Set Query = "%Routine:RoutineList"
	}
	Set pRS = ##class(%ResultSet).%New(Query)
	If ('pRS.QueryIsValid()) {
		Quit $$$ERROR($$$GeneralError,"Invalid Query: " _ Query)
	}
	Quit tSC
}

/// This can be overridden by subclasses
Method ExecuteResultSet(pRS As %ResultSet, SEARCHMASK As %String) As %Status
{
	Set tSC = $$$OK
	Set $ZT="Trap"
	Set showSystemItems = $S($G(%request.Data("showSystemItems",1))="on":1,1:"")
	If %request.PageName [ "Class" {
		If $E(SEARCHMASK,$L(SEARCHMASK)-3,$L(SEARCHMASK))'=".cls" Set SEARCHMASK = SEARCHMASK_".cls"
		Set tSC = pRS.Execute(SEARCHMASK,,,showSystemItems,1,1)  //flat is set to 1,NotStudio is set to 1
	} Else {
		#;YSD1759 Set tSC = pRS.Execute(SEARCHMASK,1,1)
		Set tNewSpec = ..GetMask(SEARCHMASK)
		Set tSC = pRS.Execute(tNewSpec,,,showSystemItems,1,1)
	}
Done
	Quit tSC
Trap
	Set $ZT=""
	If $ZE["<PROTECT>" Set tSC = $$$ERROR(940)
	Else  Set tSC = $$$ERROR($$$GeneralError,$ZE)
	Goto Done
}

/// Overwritten by subclasses to draw anything this pane needs for the BODY section.
Method DrawBODY(pInstance As PageInstance) As %Status
{
	&html<
<script language="JavaScript">

// if ischecked == true and if oldflags does not contain it already, then add it
// if ischecked == false then remove it from the oldflags
function updateflags(thisobj)
{
	var oldflags = document.getElementById("Flags").value;
	var newflags = oldflags;
	var thischecked = thisobj.checked;
	var thisvalue = thisobj.value;
	var thislen = thisvalue.length;
	var begindex = oldflags.indexOf(thisvalue);
	if (thischecked == true) {
		if (begindex == -1) {
			newflags = oldflags + thisvalue;
		}
	} else {
		if (begindex > -1) {
			newflag = oldflags.split(thisvalue);
			newflags = "";
			var piecelen = newflag.length
			for (var i = 0; i < piecelen; i++) {
				newflags += newflag[i]; 
			}
		} 
	}
	document.getElementById("Flags").value = newflags;
}
// remove all optimization level flags
// then add the new selected value
function updateoptflags()
{
	var oldflags = document.getElementById("Flags").value;
	var newflags = oldflags;
	var newflag;
	if (oldflags.indexOf("-o") > -1) {
		newflag = oldflags.split("-o");
		newflags = "";
		var thislength = newflag.length;
		for (var i = 0; i < thislength; i++) {
			newflags = newflags + newflag[i]; 
		}
	} 
	if (oldflags.indexOf("o1") > -1) {
		newflag = oldflags.split("o1");
		newflags = "";
		var thislength = newflag.length;
		for (var i = 0; i < thislength; i++) {
			newflags = newflags + newflag[i]; 
		}
	} 
	if (oldflags.indexOf("o3") > -1) {
		newflag = oldflags.split("o3");
		newflags = "";
		var thislength = newflag.length;
		for (var i = 0; i < thislength; i++) {
			newflags = newflags + newflag[i]; 
		}
	} 
	var thisobj = document.expform.Optimization;
	for (var i = 0; i < 3; i++) {
		if (thisobj[i].checked == true) {
			newflags += thisobj[i].value;
		}
	}
	document.getElementById("Flags").value = newflags;
}

function validateAll()
{
	return confirm('#($$$TextJS("Are you sure you want to compile all classes in this namespace?"))#');
	
}
</script>
	>

	&html<<div class="Text1">#(..GetDescriptiveText())#</div>>
	Set msgBackground = $$$TextHTML("Check here to run compile in the background")	
	Do ..DrawCommandForm(pInstance)

	&html<<form name="expform" method="post" action="#(%request.PageName)#?$NAMESPACE=#($ZU(5))#" >>
	If $G(%request.Data("OK",1)) = "" ,$G(%request.Data("CompileAll",1)) = "" {
	&html<<p class="ltcaption"><input type="checkbox" name="chkBackground" #($S($G(%request.Data("chkBackground",1))'="":"checked",1:""))#>#(msgBackground)#</p>>			
	}
	&html<<input type="hidden" name="$NAMESPACE" value="#($ZU(5))#">>	
	
	Set SEARCHMASK = ..DrawSearchField("Com")

	If $G(%request.Data("OK",1)) '= "" ! ($G(%request.Data("CompileAll",1)) '= "") {
		If %request.PageName["Class" {
			// Save only the ones that user selected
			If $G(%request.Data("co_1",1)) '= "" Set v=%request.Data("co_1",1) &html<<input type="hidden" name="co_1" value='#($zconvert(v,"O","HTML"))#'>>
			If $G(%request.Data("co_2",1)) '= "" Set v=%request.Data("co_2",1) &html<<input type="hidden" name="co_2" value='#($zconvert(v,"O","HTML"))#'>>
			If $G(%request.Data("co_3",1)) '= "" Set v=%request.Data("co_3",1) &html<<input type="hidden" name="co_3" value='#($zconvert(v,"O","HTML"))#'>>
			If $G(%request.Data("co_4",1)) '= "" Set v=%request.Data("co_4",1) &html<<input type="hidden" name="co_4" value='#($zconvert(v,"O","HTML"))#'>>
			Set Flags = $G(%request.Data("Flags",1))
			Set Optimization = $G(%request.Data("Optimization",1)) 
			&html<<input type="hidden" name="Flags" value='#($zconvert(Flags,"O","HTML"))#'>>	
			&html<<input type="hidden" name="Optimization" value='#($zconvert(Optimization,"O","HTML"))#'>>	

		}
		// Perform Compile Now
		Do ..DrawCompile()
	} Else {
		Set tSC = ..CreateResultSet(.pRS)
		If $$$ISERR(tSC) {
			&html<#($ZCVT($System.Status.DisplayErrorText(tSC),"O","HTML"))#>
		} Else {
			Set tSC = ..ExecuteResultSet(.pRS,SEARCHMASK)
			If %request.PageName["Class" Do ..DrawOptions()
			Do ..DrawTable(pRS)
			Do ##class(%CSP.Util.ExpPane).WriteBackupMsg(SEARCHMASK)
		}
	}
	Quit $$$OK
}

Method DrawCompile()
{
	Set $ZT = "Trap"
	Do {
		Set CompileAll = $G(%request.Data("CompileAll",1)) '= ""
		Set CompileClass = %request.PageName [ "Class"
		Set TotalRows = +$G(%request.Data("TotalRows",1))
		If TotalRows = 0,'CompileAll &html<<p nowrap>#($$$Text("No match found."))#</p>>
		Set lblLoading = $$$Text("Loading ")
		Set chkBackground = $G(%request.Data("chkBackground",1))
		Set Flags = $G(%request.Data("Flags",1))
		Set tName = ""
		Set (tRow,tTotal) = 0
		Kill err

		If chkBackground '= "" {
			While tRow < TotalRows {
				Set tRow = tRow + 1
				Set tId = "cb_"_tRow
				If $G(%request.Data(tId,1))'="" {
					Set tTotal = tTotal + 1
					Set tItems(%request.Data(tId,1)) = ""
					//Set $li(tParms("Columns"),tTotal) = %request.Data(tId,1)
				}
			}
			Set tParms("TotalColumns") = tTotal
			Set tParms("Flags") = Flags
			Set tParms("CompileAll") = CompileAll
			Set tParms("CompileClass") = CompileClass
			Set msg1 = $$$TextHTML("This task will be run in the background.")
			Set msg2 = $$$TextHTML("Click here to view the background tasks page.")
			Set linkpage = ##class(%CSP.Page).Link("/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen")
		 	If CompileAll!('CompileAll&&(tTotal>0)) {
			 	Set status = ##class(%CSP.UI.System.BackgroundTask).RunTask("Compile",$zu(5),.tParms,.tItems,.tJob)
				If $$$ISERR(status) Do ##class(%CSP.UI.System.ExportPane).LogMsg($System.Status.GetErrorText(status))
			 	&html<<h2>#(msg1)#&nbsp;<a href="#(linkpage)#">#(msg2)#</a></h2>>
		 	}				
		} Else {
			&html<<pre>>
			If CompileClass {
				If CompileAll {
					Do $System.OBJ.CompileAll(Flags,.err)
				} Else {
					While tRow < TotalRows {
						Set tRow = tRow + 1
						Set tId = "cb_"_tRow
						If $G(%request.Data(tId,1))'="" {
							Set tTotal = tTotal + 1
							Set tItems(%request.Data(tId,1)) = ""
						}
				  }
				  If tTotal > 0 Do $System.OBJ.CompileList(.tItems,Flags,.err)
				}	
			} Else {
			  While tRow < TotalRows {
				Set tRow = tRow + 1
				Set tId = "cb_"_tRow
				If $G(%request.Data(tId,1))'="" {
					Set tTotal = tTotal + 1
					Set tName = %request.Data(tId,1)
					Set tType =  $ZCVT($E(tName,$L(tName)-2,$L(tName)),"L")
					If tType = "cls" {	// Compile Class
						Do $System.OBJ.Compile($E(tName,1,$L(tName)-4),Flags,.err)
					} ElseIf tType = "mac" ! (tType = "int") ! (tType = "bas") ! (tType = "mvb") ! (tType="mvi") {
						#;YSD2501 Set tSC = $$CompileRoutine^%apiRTN(tName,"cdk")
						Set tRtnObj = ##class(%RoutineMgr).%OpenId(tName)
						If $IsObject(tRtnObj) {
							Set tSC = tRtnObj.Compile("cdk")
							#;YSD2501 Do ..DoneMsg(tSC)
						}
					} ElseIf tType = "csp" {
						Do $System.CSP.LoadPage(tName,"cd")
					} ElseIf tType = "csr" {
						Do $System.CSP.LoadRule(tName,"cd")
					} ElseIf tType = 10 {
						Write !,lblLoading,tName
						Do $System.CSP.LoadPageDir(tName,"cdk")
					} ElseIf tType = "pkg" {  		// Compile Package
						Write !,$$$Text("Compiling pacakge: "),tName
						Set tSC = $System.OBJ.CompilePackage(tName,"cdk",.err)
					} Else { 
						Write !,$$$Text("Compile unavailable for "),tName
					}
					Do %response.Flush()
				}
			  } 
			}
			If $G(tTotal) < 1,'CompileAll Write !,$$$Text("Nothing selected.")
			Else  Write !!,$$$Text("Completed at "),$ZDT($h,3)
			&html<</pre>>
		}
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write "Error trap: ",$ZE,!
	Goto Done
}

Method DrawButtons(ColMax As %Integer)
{
	&html<<tr><td colspan="#(ColMax)#" align="left"><input type="button" name="SelectAll" value='#($$$Text("Select All"))#' onclick="toggleCheckboxes(true);">>
	&html<<input type="button" name="UnselectAll" value='#($$$Text("Unselect All"))#' onclick="toggleCheckboxes(false);">>
	&html<<input type="submit" name="OK" id="OK" value='#($$$Text("Compile"))#'>>
	If %request.PageName["Class" &html<<input type="submit" name="CompileAll" id="CompileAll" value='#($$$Text("Compile All"))#' onclick="return validateAll();">>
	&html<</td></tr>>
}

/// Draws all compile options
Method DrawOptions()
{
	Set Compile(1) = $$$TextHTML("Keep generated source code"),Flag(1)="k"
	Set Compile(2) = $$$TextHTML("Compile dependent classes"),Flag(2)="rby"
	Set Compile(3) = $$$TextHTML("Do not compile up-to-date items"),Flag(3)="u"
	Set Compile(4) = $$$TextHTML("Compile in-use classes"),Flag(4)="fv"
	Set Opt(1) = $$$TextHTML("No optimization"),OFlag(1)="-o"
	Set Opt(2) = $$$TextHTML("Optimize properties"),OFlag(2)="o1"
	Set Opt(3) = $$$TextHTML("Optimize within class and calls to library classes"),OFlag(3)="o3"
	If $G(%request.Data("Flags",1)) '= "" {
		Set Checked(1) = $S($G(%request.Data("co_1",1))=Flag(1):"checked",1:"")
		Set Checked(2) = $S($G(%request.Data("co_2",1))=Flag(2):"checked",1:"")
		Set Checked(3) = $S($G(%request.Data("co_3",1))=Flag(3):"checked",1:"")
		Set Checked(4) = $S($G(%request.Data("co_4",1))=Flag(4):"checked",1:"")
		Set selectedOpt = $G(%request.Data("Optimization",1))
		For o=1:1:3 Set OChecked(o) = $S(selectedOpt = OFlag(o):"checked",1:"")
	} Else {
		Set Checked(1) = "checked"
		Set Checked(2) = ""
		Set Checked(3) = "checked"
		Set Checked(4) = ""
		Set OChecked(1)=""
		Set OChecked(2)="checked"
		Set OChecked(3)=""
	}
	
	Set lblFlags = $$$TextHTML("Flags")
	Set Flags = $G(%request.Data("Flags",1),"cuko1")
	Set tRow = 1
	&html<<p class="ltcaption">#($$$TextHTML("Compile Options"))#: </p>>
	&html<<table class="Options"><tr><td>>
	&html<<table class="Option">>
	&html<<tr><th nowrap>#($$$Text("Compile Flags"))#</th></tr>>
	While tRow < 5 {
		Set tId = "co_"_tRow
		&html<<tr><td nowrap><input type="checkbox" name="#(tId)#" id="#(tId)#" value="#(Flag(tRow))#" onclick="updateflags(this);" #(Checked(tRow))#>#(Compile(tRow))#</td></tr>>
		Set tRow = tRow + 1
	}
	&html<</table>>
	&html<<td><table class="vline"><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr></table>>
	&html<<td><table class="Option">>
	&html<<tr><th>#($$$TextHTML("Optimization Level"))#</th></tr>>
	Set tRow = 1
	While tRow < 4 {
		Set tId = "cp_"_tRow
		&html<<tr><td nowrap><input type="radio" name="Optimization" id="#(tId)#" value="#(OFlag(tRow))#" onclick="updateoptflags();" #(OChecked(tRow))#>#(Opt(tRow))#</td></tr>>
		Set tRow = tRow + 1
	}
	&html<<tr><td>&nbsp;</td></tr>>
	&html<</table></tr><tr><td colspan="4"><hr size="1" color="gray"></td></tr>>
	&html<<tr><td class="ltcaption" colspan="4">>
	&html<#(lblFlags)#:&nbsp;<input type="text" size="20" name="Flags" id="Flags" value='#($zconvert(Flags,"O","HTML"))#'>>
	&html<</tr></table><br>>
}

/// Method to Compile in the background 
ClassMethod Compile(ByRef pParms As %String, ByRef tItems As %String) As %Status
{
#define LogError If $O(err("")) '="" Set HasError=1 Set errno = "" For  Set errno = $O(err(errno)) Quit:errno=""  Do ##class(%CSP.UI.SQL.LinkWizardResultPage).LogMsg(err(errno))
#define LogDone  Else  Do ##class(%CSP.UI.System.ExportPane).LogMsg($$$FormatText($$$Text("Completed at %1"),$ZDT($H)),msgDone)
#define LogMsg   If $$$ISERR(tSC) Set HasError=1 Do ##class(%CSP.UI.SQL.LinkWizardResultPage).LogMsg($System.Status.GetErrorText(tSC))	
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Set msgDone = $$$Text("Done")
	Set HasError = 0
	Do {
		Set Flags = $G(pParms("Flags"))_"-d"
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		If pParms("CompileClass") = 1 {
			If pParms("CompileAll") {
				Do $System.OBJ.CompileAll(Flags,.err)
			} Else {
				Do $System.OBJ.CompileList(.tItems,Flags,.err)
			}
			$$$LogError
		} Else {
			Set tName = $O(tItems(""))
			While tName '= "" {
				Set tType =  $ZCVT($E(tName,$L(tName)-2,$L(tName)),"L")
				If tType = "cls" {	// Compile Class
					Do $System.OBJ.Compile($E(tName,1,$L(tName)-4),Flags,.err)
					$$$LogError
				} ElseIf tType = "mac" ! (tType = "int") ! (tType = "bas") ! (tType = "mvb") ! (tType="mvi") {
					#;YSD2501 Set tSC = $$CompileRoutine^%apiRTN(tName,Flags_"k")
						Set tRtnObj = ##class(%RoutineMgr).%OpenId(tName)
						If $IsObject(tRtnObj) {
							Set tSC = tRtnObj.Compile("k")
							$$$LogMsg
						}
				} ElseIf tType = "csp" {
					Set tSC = $System.CSP.LoadPage(tName,Flags)
					$$$LogMsg
				} ElseIf tType = "csr" {
					Set tSC = $System.CSP.LoadRule(tName,Flags)
					$$$LogMsg
				} ElseIf tType = 10 {
					Set tSC = $System.CSP.LoadPageDir(tName,Flags_"k")
					$$$LogMsg
				} ElseIf tType = "pkg" {  		// Compile Package
					Set tSC = $System.OBJ.CompilePackage(tName,Flags_"k",.err)
					$$$LogError
				} Else {
					Set HasError=1
					Do ##class(%CSP.UI.SQL.LinkWizardResultPage).LogMsg($$$Text("Unknown file extension: ")_tName)
				}
				Set tName = $O(tItems(tName))
			}
		}
		Kill EscapeObj ; To remove the oref and turn off redirection.
		If HasError = 1 Set ^|"%SYS"|CacheTemp.MgtPortalTask($J,"Status") = $$$Text("ERROR")
		Else  $$$LogDone
	} While(0)
Done
	Quit tSC
Trap
	Set $ZT=""
	Do ##class(%CSP.UI.System.ExportPane).LogMsg($ZE)
	Goto Done
}

}
