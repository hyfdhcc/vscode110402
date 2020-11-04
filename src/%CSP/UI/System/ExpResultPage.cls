Include (%sqlui, %syAudit)

/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>Final processing of actions for Explorer's compile, export, etc.
Class %CSP.UI.System.ExpResultPage Extends %CSP.Page [ System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

ClassMethod OnPage() As %Status
{
	Set tMode = $G(%request.Data("Mode",1))
	Set tNamespace = $G(%request.Data("Namespace",1))  // import
	If tNamespace = "" Set tNamespace = $G(%request.Data("$ID1",1))
	If tNamespace = "" Set tNamespace = $G(%request.Data("$NAMESPACE",1))
	// Note: 
	// When Compact/IntegrityCheck Globals, $ID1 is DBDirectory
	// When Deleting errors $ID1 is Namespace that contains the error to be deleted
	Set cbState = $G(%request.Data("cbState",1))
	If $E(cbState) = "," Set cbState = $E(cbState,2,$L(cbState))
	Do ##class(%CSP.UI.System.ExpResultPane).LocalizePage(.msgPage)
	Set header = $G(msgPage(tMode),"UNKNOWN")

	&html<<html>
	<head>
	<title>#($$$TextHTML("Final Result"))#</title>
	<link rel="stylesheet" type="text/css" href='#(..Link("/csp/sys/intersystems.css"))#'>
	>
	&html<
	<style>
pre {
	border: 1px black solid;
	background: white;
	padding: 10px;
}	
	</style>
	<script language="javascript">
	function closerefresh()
	{
		// refresh the opener then close self
		// YSD1696 for Safari, you need to close the parent and refresh the parent's parent.
		var refreshpage = document.getElementById("refreshpage").value;
		if (opener) {
			if (opener != null) {
				if (refreshpage.length > 0) {
					if (opener.opener != null) {
						opener.opener.document.location.href = refreshpage;
						opener.close();
					} else {
						opener.document.location.href = refreshpage;
						window.close();
					}
				}
			}
		} else {
			var Mode = document.getElementById("Mode").value;
			if ((Mode == "EnableEnsNamespace")||(Mode == "CopyMapsFrom")) {
				var url = encodeURI(refreshpage);
				document.location.href = url;
			} else {
				window.close();
			}
		}
	}
	</script>
	>

	&html<</head>
	<body onLoad="self.focus();" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">>
	Set tSub = ""
	Set msgDatabase = $$$TextHTML("Database")
	Set msgNamespace = $$$TextHTML("Namespace")
	Set msgUser = $$$TextHTML("User")
	Set msgBegin = $$$TextHTML("Begin at")
	If tMode'["Integrity" Set tSub = $S(tMode["Compact":msgDatabase,tMode'["Integrity":msgNamespace,1:"")_": "_$zconvert(tNamespace,"O","HTML")_"&nbsp;&nbsp;&nbsp;&nbsp;"
	//Set refreshpage = $G(%request.Data("refreshpage",1))
	set refreshpage = ##class(%CSP.Portal.Utils).GetValidatedLink($G(%request.Data("refreshpage",1)))
	If refreshpage = "" {
		If tMode["Integrity" {
			Set refreshpage = ..Link("/csp/sys/op/UtilSysOpDatabases.csp",,1)_"Recent=1"
		} Else {
			If ((tMode [ "EnableEnsNamespace") || (tMode [ "CopyMapsFrom")) {
				Set refreshpage = ..Link("%CSP.UI.Portal.Namespaces.zen",,1)_"Recent=1"	
			} Else {
				If tSub'="" {
					Set refreshpage = ..Link("/csp/sys/op/%CSP.UI.Portal.DatabaseFreespace.zen")
				} Else {
					Set refreshpage = ..Link("%CSP.Portal.Home.zen")	
				}
			}
		}
	}
	//&html<<h1>#(header)#</h1>
	Do ##class(%CSP.Util.AutoPage).DrawTitle(header)	
	&html<<form style="padding-left:10px;">
	<input type="hidden" name="Mode" id="Mode" value="#(..EscapeHTML(tMode))#">
	<input type="hidden" name="refreshpage" id="refreshpage" value="#(..EscapeHTML(refreshpage))#">
	<br><div class="Text">#(tSub)##(msgUser)#: #(%session.Username)# &nbsp;&nbsp;&nbsp;&nbsp;#(msgBegin)#&nbsp;#($zdt($h,3))#</div>
	>
		//Set %response.TraceDump=1
	//Do ..DrawCloseButton(1)
	&html<<hr>>
	Do %response.Flush()

	If (tMode [ "AuditEvent") {
		
		&html<<pre>>
		Do ..AuditEvent(tMode,cbState)
		&html<</pre>>
		
	} ElseIf (tMode = "CompileAll") {

		&html<<pre>>
		Do ..CompileAll(tNamespace)
		&html<</pre>>

	} ElseIf (tMode [ "Compile") {
		
		&html<<pre>>
		Do ..Compile(tNamespace, cbState)	
		&html<</pre>>
		
	} ElseIf (tMode = "DeleteRoutine") {
			
		&html<<pre>>
		Do ..Delete(tNamespace, cbState)
		&html<</pre>>
		
	} ElseIf (tMode = "DeleteJournal") {
			
		&html<<pre>>
		Do ..DeleteJournal(cbState)
		&html<</pre>>

	} ElseIf (tMode = "DeleteQuery") {

		&html<<pre>>
		Do ..DeleteQuery(tNamespace,cbState)
		&html<</pre>>

	} ElseIf (tMode [ "DeleteError") {

		&html<<pre>>
		Do ..DeleteError(tNamespace,cbState,tMode)
		&html<</pre>>	
		
	} ElseIf (tMode [ "Delete") {
		
		&html<<pre>>
		Do ..Delete(tNamespace,cbState)
		&html<</pre>>
		
	
	} ElseIf (tMode = "ExportGlobal") {
		Set tItems = ""
		Set length = $L(cbState,",") - 1
		For tInd = 1:1:length Set tItems = tItems _ $P(cbState,",",tInd)_".gbl" _ $S(tInd<length:",",1:"")
		Do %response.Flush()
		
		&html<<pre>>
		Do ..Export(tMode, tNamespace, tItems)
		&html<</pre>>
	
	} ElseIf (tMode [ "Export") {
		
		&html<<pre>>
		Do ..Export(tMode, tNamespace, cbState)
		&html<</pre>>

	} ElseIf (tMode [ "Import") {
			
		&html<<pre>>
		Do ..Import(tMode, tNamespace, cbState)
		&html<</pre>>

	} ElseIf (tMode = "LanguageMode") {
		
		&html<<pre>>
		Do ..SetLangMode(tNamespace, cbState)
		&html<</pre>>

	}  ElseIf (tMode = "CompactGlobals") {
		
		&html<<pre>>
		Do ..CompactGlobals(tNamespace, cbState)
		&html<</pre>>
		
	} ElseIf (tMode = "IntegrityCheck") {
		// Globals
		
		&html<<pre>>
		Do ..IntegrityCheck(tNamespace, cbState)
		&html<</pre>>
		
	} ElseIf (tMode [ "IntegrityCheck") {
		// Databases
		Set tStopAfterError = $S($G(%request.Data("StopAfterError",1))="on":1,1:0)		
		&html<<pre>>
		If tMode [ "background" {
			Do ..IntegrityCheckBack(cbState, tStopAfterError)
		} Else {
			Do ..IntegrityCheckDatabase(cbState)
		}
		Do %response.Flush()
		&html<</pre>>
	} ElseIf (tMode [ "Find") {
		Set FindWhat = $G(%request.Data("FindWhat",1))
		If FindWhat = "" {
			&html<<h2>No string entered. Nothing to find.</h2>>
		} Else {
			Do ..FindString(tNamespace, tMode, cbState, FindWhat)
		}
	} ElseIf (tMode [ "EnableEnsNamespace") {
		&html<<pre>>
		Do ..EnableEnsNamespace(tNamespace,$G(%request.Data("CopyMapsFrom",1)))
		&html<</pre>>
	} ElseIf (tMode [ "CopyMapsFrom") {
		&html<<pre>>
		Do ..CopyMapsFrom(tNamespace,$G(%request.Data("CopyMapsFrom",1)))
		&html<</pre>>
	}
	&html<<div class="Text">#($$$TextHTML("End at"))# #($zdt($h,3))#</div>>
	&html<<hr>>
	Do ..DrawCloseButton(2)
	&html<</form><br>
<script language="javascript">
	// resize self after processing is done
	//var wid = 600;
	//var hgt = 400;
	//self.document.getElementById("btn_Close1").disabled = false;
	//self.document.getElementById("btn_Close2").disabled = false;
	//if (self.opener != null) {
	//	wid = opener.screen.width * 0.50;
	//	hgt = opener.screen.height * 0.50;
	//}
	//self.resizeTo(wid,hgt);
	self.focus();
	// close opener
	//if (self.opener != null) {
	//	self.opener.popupClose();
	//}
</script>

	</body>
	</html>>
	Quit $$$OK
}

/// Delete global
ClassMethod AuditEvent(tMode, cbState)
{
	Set $ZT = "Trap"
	Do {
		If tMode [ "Import" ! (tMode [ "Export") {
			Set FileName = $G(%request.Data("filename",1))
			If FileName = "" Write !,$$$TextHTML("File name is empty!")# Quit		
		}
		If tMode [ "Import" {
 			Write !,$$$TextHTML("Import from file"),": ",$zconvert(FileName,"O","HTML"),!
 			Set Status=##Class(Security.Events).Import(.NumCopied,FileName)
 			If '$$$ISOK(Status) {
	 			Do ShowError^%apiCSP(Status)
			} Else {
				Write !,$zconvert(NumCopied,"O","HTML")_" "_$$$TextHTML("Event records imported.")
 			} 
			Quit
		}
		If tMode [ "Export" {
			If $ZCVT($E(FileName,$L(FileName)-3,$L(FileName)),"U")'=".XML" Set FileName=FileName_".XML"
			Write !,$$$TextHTML("Export audit events to file"),": ",$zconvert(FileName,"O","HTML"),!		
		}
		Set tRow = 0
		Set tName = $P(cbState,",",1)
		While tName '= "" {
			If $G(tSel(tName)) = "" {			
				If tMode [ "Delete" {
	 				Set Status = ##Class(Security.Events).Delete(tName)
 					If '$$$ISOK(Status) {
	 					Do ShowError^%apiCSP(Status)
 					} Else {
	 					Write !,$$$TextHTML("Audit event deleted: "),$zconvert(tName,"O","HTML")
 					}				
				} ElseIf tMode [ "Reset" {
					Set EventSources = $P(tName,"/",1)
					Set EventTypes = $P(tName,"/",2)
					Set EventNames = $P(tName,"/",3)
				 	Set Status = ##Class(Security.Events).Clear(EventSources,EventTypes,EventNames)
 					If '$$$ISOK(Status) {
						Do ShowError^%apiCSP(Status)
 					} Else {
						Write !,..EscapeHTML(tName)," - ",$$$TextHTML("reset counter done.")
 					}					
				} ElseIf tMode [ "Change Status" {
					If ##Class(Security.Events).Exists(tName,,,.Event,.Status) {
						Set Event.Enabled = $S(Event.Enabled=1:0,1:1)
						Set Status = Event.%Save()
 						If '$$$ISOK(Status) {
							Do ShowError^%apiCSP(Status)
 						} Else {
							Write !,..EscapeHTML(tName)," - status changed."
 						}					
						Kill Event						
					}
				} Else {
					//Flag = 0 no delete
					Set EventSources = $P(tName,"/",1)
					Set EventTypes = $P(tName,"/",2)
					Set EventNames = $P(tName,"/",3)
 					Set Status=##Class(Security.Events).Export(.NumCopied,FileName,0,EventSources,EventTypes,EventNames)
 					If '$$$ISOK(Status) {
						Do ShowError^%apiCSP(Status)
 					} Else {
						Write !,"Exporting ",$zconvert(tName,"O","HTML"),"... ",$zconvert(NumCopied,"O","HTML")_" records completed."
 					} 					
				}
				Set tSel(tName) = 1
			}
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Delete routines
ClassMethod Delete(namespace As %String, cbState As %String)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 0   
		//If namespace '= "" zn namespace
		$$$ChangeNamespace
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		Set dflag = +$G(%request.Data("dflag",1))
		Kill err
		While tName '= "" {
			/// YSD789 This next statement may be removed when FT1 and Latest merge.
			If tName [ "." Set tType =  $ZCVT($E(tName,$L(tName)-2,$L(tName)),"L")
			Else  Set tType = "prj"
			If tType = "log" ! (tType = "txt") {
				Write !,"Deleting ",$zconvert(tName,"O","HTML"),"...... "
				Set tSC = ##class(%File).Delete(tName)
			} ElseIf tType = "mac" ! (tType = "int") ! (tType = "mvb") !(tType="mvi") {
				Write !,"Deleting ",$zconvert(tName,"O","HTML"),"...... "
				Set tSC = ##class(%Routine).Delete(tName,dflag)
				Do ..DoneMsg(tSC)
			} ElseIf tType = "pkg" {  		// Package
					Do $System.OBJ.DeletePackage(tName)
			} ElseIf tType = "prj" {		// Project
					Write !,"Deleting project ",$zconvert(tName,"O","HTML"),"...... "
					Set tSC = $System.OBJ.DeleteProject($E(tName,1,$L(tName)-4))  //strip off ".prj"
					Do ..DoneMsg(tSC)
			} ElseIf tType = "gbl" {		// Global
					Set tGblName = $P(tName,".gbl",1) Set:tGblName="" tGblName=$P(tName,".GBL",1)
					//Do ..DeleteGlobal(namespace, tGblName)
			} Else { 
				Write !,"Deleting ",$zconvert(tName,"O","HTML")
				Set tSC = ##class(%RoutineMgr).Delete(tName)
				Do ..DoneMsg(tSC)
			}
			//} ElseIf tType = "csr" {		// Rule
			//		Write !,"Deleting rule ",tName
			//		Do $System.CSP.DeleteRule(tName)
			//} ElseIf tType = "cls" {				// Class
			//		Do $System.OBJ.Delete($E(tName,1,$L(tName)-4))

			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
		Do ..DrawErrorLog(.err)
		//Write !,"Done."
	} While(0)
Done
	Quit
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Delete journal file
ClassMethod DeleteJournal(cbState)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		While tName '= "" {
			Write !,$$$FormatText($$$Text("Deleting %1"),tName)
			Set tSC = ##class(%SYS.Journal.File).PurgeOne(tName)
			//Write !,"tSC = ",tSC
			//Write !,"tName = ",$G(tName)
			If tSC '= 1 Do ..DoneMsg(tSC)
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write ..EscapeHTML($ZE),!
	Goto Done
}

/// Delete cached queries
ClassMethod DeleteQuery(namespace, cbState)
{
	Set $ZT = "Trap"
	Set io = $$$GETIO
	$$$SETIO("HTML")
	Do {
		//If namespace '= "" zn namespace
		$$$ChangeNamespace
		Set dflag = $G(%request.Data("dflag",1))
		If dflag = 0 {
			Set tRow = 1
			Set tName = $P(cbState,",",1)
			While tName '= "" {
				Write !,$$$FormatText($$$Text("Deleting %1"),$zconvert(tName,"O","HTML"))
				Set tSC = ##class(%SQL.Manager.API).PurgeQuery(tName)
				If tSC '= 1 Do ..DoneMsg(tSC)
				Set tRow = tRow + 1
				Set tName = $P(cbState,",",tRow)
			} 
		} ElseIf dflag = 1 {
			// delete ALL quries
			Set tSC = ##class(%SQL.Manager.API).PurgeAllQueries(0)
			Do ..DoneMsg(tSC)
		} ElseIf dflag = 2 {
			// if user deleted days (to be funny) then use 7 days
			Set days = $G(%request.Data("Days",1),7)
			Set tSC = ##class(%SQL.Manager.API).PurgeAllQueries(days)
			Do ..DoneMsg(tSC)
		} ElseIf dflag = 3 {
			Set SchemaName = $G(%request.Data("SchemaName",1))
			Set TableName = $G(%request.Data("TableName",1))
			If SchemaName '= "",TableName '= "" {
				Set sName = SchemaName _ "." _ TableName
				Set tSC = ##class(%SQL.Manager.API).PurgeQueriesForTable(sName)
				Do ..DoneMsg(tSC)			
			}
		}
	} While(0)
Done
	$$$SETIO(io)
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

ClassMethod DeleteError(namespace, cbState, tMode)
{
	Set $ZT = "Trap"
	Set io = $$$GETIO
	$$$SETIO("HTML")
	Do {			
		If tMode["ODBC",namespace'="",$zu(5) '= namespace ZN namespace
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		Set date = $G(%request.Data("$ID2",1))
		While tName '= "" {
			Set tSC = 1
			If tMode [ "ByNamespace" {
				Write !,$$$FormatText($$$Text("Deleting errors in %1"),$zconvert(tName,"O","HTML"))
				If tMode = "DeleteErrorODBCByNamespace" {
					ZN tName
					do KillLastErrorAll^%SYS.SQLSRV(tName)
				} Else {
					Set tSC = ##class(SYS.ApplicationError).DeleteByNamespace(tName)
				}
			} ElseIf tMode [ "ByDate" {
				Write !,$$$FormatText($$$Text("Deleting errors in %1 %2"),$zconvert(namespace,"O","HTML"),$zconvert(tName,"O","HTML"))
				Set tSC = ##class(SYS.ApplicationError).DeleteByDate(namespace,tName)
			} ElseIf tMode [ "ByError" {
				If tMode = "DeleteErrorODBCByError" {
					Write !,$$$FormatText($$$Text("Deleting errors in %1 %2"),$zconvert(namespace,"O","HTML"),$zconvert(tName,"O","HTML"))
					do KillLastErrorOne^%SYS.SQLSRV(tName)
				} Else {
					Write !,$$$FormatText($$$Text("Deleting errors in %1 %2 %3"),$zconvert(namespace,"O","HTML"),$zconvert(date,"O","HTML"),$zconvert(tName,"O","HTML"))
					Set tSC =  ##class(SYS.ApplicationError).DeleteByError(namespace,date,tName)
				}
			}		
			Do ..DoneMsg(tSC)
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
		Do %response.Flush()
	} While(0)
Done
	$$$SETIO(io)
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

ClassMethod SetLangMode(namespace, cbState)
{
	Set $ZT = "Trap"
	Set io = $$$GETIO
	$$$SETIO("HTML")
	Do {			
		Set tRow = 0   
		//If namespace '= "" zn namespace
		$$$ChangeNamespace
		Set langmode = $G(%request.Data("langmode",1),0)
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		Write !,$$$FormatText($$$Text("Set Language Mode to %1"),..LangMode(langmode))
		While tName '= "" {
			Write !,?5,$zconvert(tName,"O","HTML")
			Set tTS = ##class(%Routine).%New(tName)
			Set tTS.LanguageMode = langmode
			Set tSC = tTS.Save()
			If 'tSC Do ..DoneMsg(tSC)
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
	} While(0)
Done
	$$$SETIO(io)
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Export classes/routines/globals
ClassMethod Export(tMode, namespace, cbState)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 0   
		//If namespace '= "" zn namespace
		$$$ChangeNamespace
		Set FileName = $G(%request.Data("RemoteFileName",1))
		If FileName = "" Set FileName = $G(%request.Data("FileName",1))
		If FileName = "" Write !,$$$TextHTML("File name is empty!") Quit
		Kill err
		Set ExportFormat = $G(%request.Data("ExportFormat",1))
		Set ExportAll = $G(%request.Data("ExportAll",1))
		If tMode [ "Application" {
			Set Flag = 0   // no deletion
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Set Status = ##Class(Security.Applications).Export(.NumCopied,FileName,Flag,cbState)
			Kill EscapeObj
			If Status '= 1 Set err=1,err(1)=$System.Status.GetErrorText(Status) Do ..DrawErrorLog()
			Else  Write !,$$$TextHTML("Total applications exported"),": ",NumCopied
			Quit
		}
		If ExportAll = "ExportAll" {
			If $ZCVT($E(FileName,$L(FileName)-3,$L(FileName)),"U")'=".XML" Set FileName=FileName_".XML"
			Write !!,$$$TextHTML("Export all classes to file: "),$zconvert(FileName,"O","HTML")
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Do $System.OBJ.ExportAllClasses(.FileName,"cdk",.err)
			Kill EscapeObj
			Write !
			Do ..DrawErrorLog(.err)
			Quit		
		} ElseIf ExportAll = "ExportAllInd" {
			Write !!,$$$TextHTML("Export all classes individually to directory: "),$zconvert(FileName,"O","HTML")
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Do $System.OBJ.ExportAllClassesIndividual(FileName,"cdk",.err)
			Kill EscapeObj
			Write !
			Do ..DrawErrorLog(.err)
			Quit					
		} 
		
		Set tItems = cbState

		If tItems '= "" {
			Set FileName = ..GetExpExt(ExportFormat,FileName)
			//Write !,"Export items: ",tItems
			Write !,$$$TextHTML("Export to file"),": ",$zconvert(FileName,"O","HTML")
			Write !,$$$TextHTML("Export format"),": ",$zconvert(ExportFormat,"O","HTML"),!
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			If ExportFormat = "XML" Do $System.OBJ.Export(tItems,.FileName)
			Else  If ExportFormat = "CDL" Do $System.OBJ.ExportCDL(tItems,.FileName)
			Else  If ExportFormat = "RO" Do Export^%apiRTN(tItems,FileName,,,,.err)
			Else  If ExportFormat = "GO" Do ..ExportGlobalGO(tItems,FileName)
			Kill EscapeObj
		} Else {
			Set tType =9
			Set tName = $O(Selected(tType,""))
			Set tRow = 1
			// Because we can only export one package at a time, we add a numeric extention at the end
			While tName '= "" {
				If tRow > 1 Set tFileName = FileName_"."_tRow
				Else  Set tFileName = FileName
				Write !!,$$$FormatText($$$Text("Export package %1 to file %2"),$zconvert(tName,"O","HTML"),$zconvert(tFileName,"O","HTML"))
				//&html<<a href="#(tFileName)#">#(tFileName)#</a>>
				Write !,$$$TextHTML("Export format: "),$zconvert(ExportFormat,"O","HTML")
				Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
				If ExportFormat = "XML" Do $System.OBJ.ExportPackage(tName,.tFileName)
				Else  Do $System.OBJ.ExportCDLPackage(tName,.tFileName)
				Kill EscapeObj
				Set tRow = tRow + 1
				Set tName =$O(Selected(tType,tName))
			}
		}
		Do ..DrawErrorLog(.err)
} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Validate export extension. Append correct extension if not valid.
ClassMethod GetExpExt(ExportFormat As %String, FileName As %String) As %String
{
	If ExportFormat = "XML" {
		If $E(FileName,$L(FileName)) = "." Quit FileName_"xml"
		If $ZCVT($E(FileName,$L(FileName)-3,$L(FileName)),"l") '= ".xml" Quit FileName _ ".xml"
	}
	If ExportFormat = "RO" {
		If FileName '[ "." Quit FileName_".rsa"
		If $E(FileName,$L(FileName)) = "." Quit FileName_"rsa"
	}
	If ExportFormat = "GO" {
		If FileName '[ ".gsa" Quit FileName_".gsa"	
		If $E(FileName,$L(FileName)) = "." Quit FileName_"gsa"
	}
	Quit FileName
}

/// Export Global in %GO format
ClassMethod ExportGlobalGO(tItems, FileName)
{
	Set $ZT = "Trap"
	Do {
		Set OutputFormat = $G(%request.Data("OutputFormat",1),5)  //default is Cache = 5
		Set RecordFormat = $G(%request.Data("RecordFormat",1),"V")  //default is Variable Length Record = 1
		Write !,"Output Format: ",$zconvert(OutputFormat,"O","HTML")
		Write !,"Record Format: ",$zconvert(RecordFormat,"O","HTML"),!
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		Set tSC = ##class(%Global).Export("", tItems, FileName, OutputFormat, RecordFormat, "d")
		Kill EscapeObj
		Do %response.Flush()
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Find string in globals or routines (this method is obsolete)
ClassMethod FindString(tNamespace, tMode, tItems, FindWhat)
{
	Set $ZT = "Trap"
	Set io = $$$GETIO
	$$$SETIO("HTML")
	Do {
		Write !
		Set MatchCase = $G(%request.Data("MatchCase",1),0)
		Write !,"<pre>"
		Write !,"Find String: ",FindWhat
		Write !,"Match Case: ",$S(MatchCase=1:"Yes",1:"No")
		Write !,"</pre>"
		If tNamespace '= "%SYS" $$$ChangeNamespace
		If tMode [ "Global" {
			Set tRS = ##class(%ResultSet).%New("%Global:Find")
			Write "<table class='DetailTable'><tr><th>Name</th><th>Value</th></tr>",!
		} Else {
			Set tRS =  ##class(%ResultSet).%New("%Routine:Find")
		}
		Set tInd = 1
		Set tItem = $P(tItems,",",tInd)
		If tMode [ "Global" {
			Set TotalFound = 0
			While tItem '= ""  {
				If $E(tItem) '= "^" Set tItem = "^"_tItem
				Set tSC = tRS.Execute(tItem, FindWhat, MatchCase)
				If $$$ISERR(tSC) {
					&html<<tr><td colspan="2" nowrap>#($ZCVT($System.Status.GetErrorText(tSC),"O","HTML"))#</td></tr>>
				} Else {
					Set bgstyle = $S(tInd#2:"EvenRow",1:"OddRow")
					While tRS.Next() {
						&html<<tr class="#(bgstyle)#"><td nowrap>#($ZCVT(tRS.GetData(1),"O","HTML"))#</td><td nowrap>#($ZCVT(tRS.GetData(2),"O","HTML"))#</td></tr>>
						Set TotalFound = TotalFound + 1
					}
					Do %response.Flush()
				}
				Set tInd = tInd + 1
				Set tItem = $P(tItems,",",tInd)
			}
			&html<<tr><td colspan="2">Total lines matched: #(TotalFound)#</td></tr>>
			&html<</table><br>>
		} Else {   // Routines
		While tItem '= ""  {
			Set TotalFound = 0
			&html<<table class='DetailTable'><tr><th>#(tItem)#</th><th>Matched</th></tr>>
			Set ext = $ZCVT($E(tItem,$L(tItem)-2,$L(tItem)),"L")
			If ext '= "mac",ext'="int",ext'="inc",ext'="bas",ext'="mvb",ext'="mvi" {
				&html<<tr><td colspan="2" nowrap>Find String for this file is skipped.</td></tr>>
			} Else {	
				Set tSC = tRS.Execute(tItem, FindWhat, MatchCase)
				If $$$ISERR(tSC) {
					&html<<tr><td colspan="2" nowrap>#($ZCVT($System.Status.GetErrorText(tSC),"O","HTML"))#</td></tr>>
				} Else {
					While tRS.Next() {
						Set bgstyle = $S(tRS.GetData(2)=1:"EvenRow",1:"OddRow")	
						Set TotalFound = TotalFound + 1
						&html<<tr class="#(bgstyle)#"><td nowrap>#($ZCVT(tRS.GetData(1),"O","HTML"))#</td><td nowrap>#($ZCVT(tRS.GetData(2),"O","HTML"))#</td></tr>>
					}
				}
			}
			&html<<tr><td colspan="2">Total lines matched: #(TotalFound)#</td></tr>>
			&html<</table><br>>
			Do %response.Flush()
			Set tInd = tInd + 1
			Set tItem = $P(tItems,",",tInd)
		}
		}
	} While(0)
Done
	$$$SETIO(io)
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Compile all classes
ClassMethod CompileAll(namespace)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 0   
		//If namespace '= "" zn namespace
		$$$ChangeNamespace
		Kill err
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		Do $System.OBJ.CompileAll(,.err)
		Kill EscapeObj
		Do ..DrawErrorLog(.err)
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Import
ClassMethod Import(tMode, namespace, FileName)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 0   
		If namespace '= "" zn namespace
		Set SaveTo = $G(%request.Data("SaveTo",1))
		If SaveTo = "Remote" Set FileName = $G(%request.Data("RemoteFileName",1))
		Else  Set FileName = $G(%request.Data("FileName",1))
		If FileName = "" Write !,$$$TextHTML("File name is empty!") Quit
		Kill err
		If tMode [ "Applications" {
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Set Status = ##Class(Security.Applications).Import(.NumCopied,FileName)
			Kill EscapeObj
			If Status '= 1 Set err=1,err(1)=$System.Status.GetErrorText(Status)
			Else  Write !,$$$FormatText($$$Text("Total applications imported: %1"),NumCopied)
		} Else {
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Do $System.OBJ.Load(FileName,"cdk",.err)
			Kill EscapeObj
		}
		Kill EscapeObj ; To remove the oref and turn off redirection.
		If $G(err) > 0 Do ..DrawErrorLog()
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Compile classes/routines
ClassMethod Compile(namespace As %String, cbState As %String)
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		Set tRow = 0   
		//If namespace '= "" zn namespace
		$$$ChangeNamespace
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		Kill err
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		While tName '= "" {
			Set tType =  $ZCVT($E(tName,$L(tName)-2,$L(tName)),"L")
				If tType = "cls" {	// Compile Class
					Do $System.OBJ.Compile($E(tName,1,$L(tName)-4),"cdk",.err)
				} ElseIf tType = "mac" ! (tType = "int") ! (tType = "bas") ! (tType = "mvb") ! (tType="mvi") {
					Set tSC = $$CompileRoutine^%apiRTN(tName,"cdk")
					//Do ..DoneMsg(tSC)
				} ElseIf tType = "csp" {
					Do $System.CSP.LoadPage(tName,"cd")
				} ElseIf tType = "csr" {
					Do $System.CSP.LoadRule(tName,"cd")
				} ElseIf tType = 10 {
					Write !,"Loading ",tName
					Do $System.CSP.LoadPageDir(tName,"cdk")
				} ElseIf tType = "pkg" {  		// Compile Package
					Write !,"Compiling pacakge: ",tName
					Set tSC = $System.OBJ.CompilePackage(tName,"cdk",.err)
					//Do ..DoneMsg()
				} Else { 
					Write !,"Compile unavailable for ",tName
				}
			//}
			Do %response.Flush()
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		} 
		Kill EscapeObj ; To remove the oref and turn off redirection.
		Do ..DrawErrorLog(.err)
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write "Error trap: ",$ZE,!
	Goto Done
}

/// Compact
ClassMethod CompactGlobals(dbDir, cbState)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 0
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		While tName '= "" {
			If $G(tSel(tName)) = "" {
				Write !,"Compact ",tName
				Set tGlb = ##Class(%GlobalEdit).Open(tName,dbDir)
				Set tSC = tGlb.Compact(90,.CurrSize,.NewSize)
				If 'tSC Do ..DoneMsg(tSC)
				Else  Write "  Old size = ",CurrSize," New size = ",NewSize
				Set tSel(tName) = 1
			}
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		}
		Kill EscapeObj
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Integrity Check for Globals (no longer being used in SMP)
ClassMethod IntegrityCheck(dbDir, cbState)
{
	Set $ZT = "Trap"
	Do {			
		Set tRow = 0
		Set tRow = 1
		Set tName = $P(cbState,",",1)
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		While tName '= "" {
			If $G(tSel(tName)) = "" {
				Set tGlb = ##Class(%GlobalEdit).CheckGlobalIntegrity(dbDir,tName)				
				If tGlb '= "" {
					Write !,tName
					Do $SYSTEM.OBJ.DisplayError(tGlb)
					Write !," "
					Do %response.Flush()
				}
				Set tSel(tName) = 1
			}
			Set tRow = tRow + 1
			Set tName = $P(cbState,",",tRow)
		}
		Kill EscapeObj
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write ..EscapeHTML($ZE),!
	Goto Done
}

/// Integrity Check Database Background
ClassMethod IntegrityCheckBack(cbState, pStopAfterError)
{
	Set $ZT = "Trap"
	Set TotalRows = $G(%request.Data("TotalRows",1))
	Set FileName = $G(%request.Data("RemoteFileName",1))
	If FileName = "" Write !,$$$TextHTML("File name is empty!") Quit
	Do {
		Set cnt = 0
		Set DBArray = ""
		For tRow = 1:1:TotalRows {
			Set tName = "cb_"_tRow
			Set tDir = $G(%request.Data(tName,1))
			If tDir '= "" Set cnt = cnt + 1,$li(DBArray,cnt) = %request.Data(tName,1)
		}
		#; If more than one db checked, then make sure to delete the globals that might be left there
		If cnt > 1 Kill %session.Data("GlobalInteg")
		If DBArray '= "" {
			#; If only one db checked and globals exist, then build them into list and pass to server method.
			Set DBGlbList = ""
			Set cnt = 0
			Set tDir = $li(DBArray,1)
			Set tGbl = $O(%session.Data("GlobalInteg",tDir,""))
			While tGbl '= "" {
				Set cnt = cnt + 1
				Set $li(DBGlbList,cnt) = tGbl
				Set tGbl = $O(%session.Data("GlobalInteg",tDir,tGbl))
			}
			Kill %session.Data("GlobalInteg")
			Set tSC = ##class(SYS.Database).SilentIntegrityCheck(FileName, DBArray, DBGlbList, pStopAfterError)
			If tSC = 1 Write !,$$$TextHTML("Job started in the background"),".",!,$$$FormatText($$$Text("Result will be saved in file %1"),FileName)
		} Else {
			Write !,$$$TextHTML("No database selected.")
			//Set tSC = ##class(SYS.Database).SilentIntegrityCheck(FileName)
			//If tSC = 1 Write !,"Job started in the background.",!,"Result will be saved in file ",FileName
		}
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write ..EscapeHTML($ZE),!
	Goto Done
}

/// Integrity Check Database Forground (no longer being used in SMP)
ClassMethod IntegrityCheckDatabase(cbState)
{
	Set $ZT = "Trap"
	Set io = $$$GETIO
	$$$SETIO("HTML")
	Do {
		Set cnt = 0
		Set DBArray = ""
		For tRow = 1:1:$L(cbState,",") Set tName = $P(cbState,",",tRow) If tName'="" Set cnt = cnt + 1,$li(DBArray,cnt) = tName
		If DBArray '= "" {
			Write !,"Check selected databases",!
			Set tSC = ##class(SYS.Database).IntegrityCheck(DBArray)
		} Else {
			Write !,"No database selected.",!
			//Set tSC = ##class(SYS.Database).IntegrityCheck()
		}
	} While(0)
Done
	$$$SETIO(io)
	Quit	
Trap
	Set $ZT=""	
	Write $ZE,!
	Goto Done
}

/// Method to enable Ensemble namespace when adding a new namespace.
ClassMethod EnableEnsNamespace(pNamespace As %String, pCopyMapsFrom As %String)
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
		Set tSC = ##class(%Library.EnsembleMgr).EnableNamespace(pNamespace,1)
		Kill EscapeObj
		If $$$ISERR(tSC) Write !,..EscapeHTML($System.Status.GetErrorText(tSC))
		If pCopyMapsFrom '= "" {
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Set tSC = ##class(Config.Namespaces).CopyMaps(pCopyMapsFrom,pNamespace)
			Kill EscapeObj
			If $$$ISERR(tSC) Write !,..EscapeHTML($System.Status.GetErrorText(tSC))	
		}
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write ..EscapeHTML($ZE),!
	Goto Done
}

/// Method to copy mappings for a Cache instance when adding a new namespace.
ClassMethod CopyMapsFrom(pNamespace As %String, pCopyMapsFrom As %String)
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		If pCopyMapsFrom '= "" {
			Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
			Set tSC = ##class(Config.Namespaces).CopyMaps(pCopyMapsFrom,pNamespace)
			Kill EscapeObj
			If $$$ISERR(tSC) Write !,..EscapeHTML($System.Status.GetErrorText(tSC))
			Else  Write !,$$$TextHTML("Done")		
		}
	} While(0)
Done
	Quit	
Trap
	Set $ZT=""	
	Write ..EscapeHTML($ZE),!
	Goto Done
}

/// Write common message after action is commited.
ClassMethod DoneMsg(tSC)
{
	Write " "
	If tSC = 1 Write $$$TextHTML("Done")
	Else  Write ..EscapeHTML($System.Status.GetErrorText(tSC))
}

ClassMethod DrawCloseButton(Index As %Integer)
{
	Set tId = "btn_Close"_Index
	&html<
		<input type="button" value='#($$$Text("Close"))#' name="#(tId)#" id="#(tId)#" onclick="closerefresh();">
		>
}

/// Write out error log
ClassMethod DrawErrorLog(err)
{
	If $G(err) > 0 {
		Write !,"Error Log: "
		Set errcnt = $o(err(""))
		While errcnt '= "" {
			Write !,errcnt,?10,$g(err(errcnt))
			Set errname = ""
			For  Set errname = $O(err(errcnt,errname)) Quit:errname=""  Write !,?5,..EscapeHTML(errname),?25,..EscapeHTML($G(err(errcnt,errname)))
			Set errcnt = $o(err(errcnt))	
		}
		Write !
	}
}

/// Construct file Open parameters
///  bWrite = open file for write access
///  bVariable = read/write Variablelength/Stream record (True="V"\False="S")
///  sEncoding = character encoding for \k???\ syntax
/// 
///  Return parameters string
ClassMethod GetOpenParms(bWrite As %Boolean, bVariable As %Boolean, sEncoding As %String) As %String
{
    
    Set sReturn = ""
    
    //determine encoding
    If sEncoding '= "<Device Default>", sEncoding '= "" {
        Set sReturn = "k\" _ sEncoding _ "\"
    }
    //determine record format
    If bVariable {  //variable length records
        Set sReturn = sReturn _ "V"
    } Else { //stream format records
        Set sReturn = sReturn _ "S"
    }
    //read/write access
    If bWrite {
        Set sReturn = "WN" _ sReturn
    } Else {
        Set sReturn = "R" _ sReturn
    }
    //done
    Set GetOpenParms = ":(" _ $C(34) _ sReturn _ $C(34) _ ")"
	Quit GetOpenParms
}

ClassMethod HelpTextCancel()
{
	If $G(%request.Data("OK",1)) = "" &html<<div class="div">Click the <b>OK</b> button to proceed, or click the <b>Close</b> button to close this window.</div>>
}

/// Return Language Mode Description
ClassMethod LangMode(langmode As %Integer = 0) As %String
{
	If langmode = 0 Quit "Cache"
	If langmode = 1 Quit "DSM-11"
	If langmode = 2 Quit "DTM"
	If langmode = 3 Quit "Ipsum"
	If langmode = 4 Quit "Cobra"
	If langmode = 5 Quit "DSM-VMS"
	If langmode = 6 Quit "DSM-J"
	If langmode = 7 Quit "DTM-J"
	If langmode = 8 Quit "MSM"
	Quit ""
}

/// Ensure the user has either %Admin_Operate:USE or %Admin_Manage:USE.
/// Extend response timeout to allow the requested task to complete.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	If '($system.Security.Check($$$AdminManageResourceName,"USE") || $system.Security.Check($$$AdminOperateResourceName,"USE")) Quit 0
	// Allow one hour for whatever it is doing to prevent time out
	Set %response.Timeout = 3600
	Quit 1
}

}
