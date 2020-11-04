/// Dialog for checking in files to Perforce
Class %Studio.SourceControl.UI Extends %CSP.StudioTemplateSuper [ System = 4 ]
{

/// This Parameter should be updated when synced from Perforce
Parameter SrcVer = "$Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/cls/Studio/SourceControl/UI.xml#1 $";

/// Revision number of this class when compiled as part of the //custom_ccrs/_common/config/... branch.  
/// This version will not be updated (by design) when the class is integrated to other branches.
/// This allows the user to tell what version of the Studio client tools are in use.
Parameter Version = 56;

/// Do not accept the default SECURITYRESOURCE from the superclass as this page handles it's own security to allow TrakCare use-cases
/// <p>NOTE - this parameter is not enforced until 3012.2
Parameter SECURITYRESOURCE;

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
	New $ROLES
	Do ..UpdateSession()
	Set action=$ZCVT($get(%request.Data("action",1)),"L")
	Set tEnsInclude = $select(##class(%Library.EnsembleMgr).IsEnsembleInstalled(): "<script type=""text/javascript"" src=""ensemble/Ens_SourceControl.js""></script>", 1: "")
	Set tMeta = $select(action="diff": "<meta http-equiv=""X-UA-Compatible"" content=""IE=edge"" />", 1: "")
	&html<<html>
			<head>
				<title>Source Control #($get(%request.Data("action",1)))#</title>
				#(tMeta)#
				#(tEnsInclude)#
			</head>
			<body style="background-color: #EEEEEE;">
			<span STYLE="position: absolute; right: 10px; text-align: right; font-size:.7em" >
				Server: #($zu(110))#<BR/>
				Instance: #($piece($zu(86),"*",2))#<BR/>
				Namespace: #($zu(5))#<BR/>
				User: #($USERNAME)#<BR/>
				#($select($data(^SYS("SourceControl","ItemSetConfig","Org")):"Org: "_^SYS("SourceControl","ItemSetConfig","Org")_"<BR/>",1:""))#
				#($select($data(^SYS("SourceControl","ItemSetConfig","System")):"Sys: "_^SYS("SourceControl","ItemSetConfig","System")_"<BR/>",1:""))#
				#($select($data(^SYS("SourceControl","ItemSetConfig","Environment")):"Env: "_^SYS("SourceControl","ItemSetConfig","Environment")_"<BR/>",1:""))#
				#($select($data(%request.Data("User",1)):"",1:"<A HREF='"_..SelfLink()_"?action=Logout'>Logout</A>"))#	<!--Don't show logout link when accessed via Studio-->
			</span>
	>
	&html<<pre style="font-size:0.6em">> Do ##class(ISC).CheckIndexes() &html<</pre>>
	#define StandardActions $LB("menu","checkin","download","load","bundle","upload","itemsetlog","summary","refresh","dscheckpoint","diff","validatediff")
	#define RequireSources $LB("checkin","download","load","bundle","upload","itemsetlog","refresh","dscheckpoint")
	
	If action="" {
		Do ..MenuDisplay()
	} ElseIf (('$data(^Sources))&&($LF($$$RequireSources,action))) {
		&html<
			%Studio.SourceControl.UI cannot be used as ^Sources is not defined in #($zu(5))#<P>
			<A HREF='#(..SelfLink())#'>Source Control Menu</A>>				
	} ElseIf $LF($$$StandardActions,action) {
		If (..InstanceVersion() = "2010.1")&&($zu(23,1)=32) { Set oldcol=$zu(23,1,5) }		; Spanish2 collation on 2010.1 must be avoided
		Try {
			Do $zobjclassmethod(..%ClassName(1),$ZCVT(action,"W")_"Display")
		} Catch err {
			Do $system.Status.DisplayError(err.AsStatus())
		}
		If $data(oldcol) { Set oldcol=$zu(23,1,oldcol) }
	} Else {
		Write "Unrecognized Action",!	
	}
	//Write "<pre>",! Do $SYSTEM.OBJ.Dump(%request),$SYSTEM.OBJ.Dump(%session) Write "</pre>",!
	&html<	</body>
		</html>
	>
	Quit $$$OK
}

ClassMethod UpdateSession()
{
	If $data(%request.Data("item",1)) Do %session.Set("item",%request.Data("item",1))
	If $data(%request.Data("User",1)) Do %session.Set("CacheUser",%request.Data("User",1))
	Do $system.Security.Login(%session.Get("CacheUser"))
}

ClassMethod MenuDisplay()
{
	&html<<H2>Source Control Menu</H2>>
	If %session.RunNamespace'="" {
		&html<<H4>Available Controls</H4>
				<UL>
		>
		If ('##class(%Studio.SourceControl.ISC).Disconnected()) {
			&html<<LI><A HREF='#(..SelfLink())#?action=Checkin'>Check In</A> - Check changes directly into Perforce</LI>>
		}
		If $get(^SYS("SourceControl","ItemSetConfig","Enabled")) {
			&html<
				<LI><A HREF='#(..SelfLink())#?action=Download'>ItemSet Download</A> - Download an ItemSet from CCR Server</LI>
				<LI><A HREF='#(..SelfLink())#?action=Load'>ItemSet Load</A> - Load ItemSet contents into Environment</LI>
				<LI><A HREF='#(..SelfLink())#?action=Bundle'>ItemSet Bundle</A> - Bundle uncommitted changes into an ItemSet</LI>
				<LI><A HREF='#(..SelfLink())#?action=Upload'>ItemSet Upload</A> - Upload a created ItemSet to CCR Server</LI>
				<LI><A HREF='#(..SelfLink())#?action=ItemSetLog'>View ItemSet Log</A> - find and display the log for an ItemSet</LI>
				<LI><A HREF='#(..SelfLink())#?action=Summary'>Configuration Summary</A> - display CCR client configuration details</LI>
			>
		}	
		&html<
			<LI><A HREF='#(..SelfLink())#?action=Refresh'>Refresh from Branch</A> - sync (optional) then reload and compile all contents from disk</LI>
		>
		If (##class(%Dictionary.CompiledClass).%ExistsId("%DeepSee.UserLibrary.Utils")) {
			&html<
				<LI><A HREF='#(..SelfLink())#?action=DSCheckpoint'>DS Checkpoint</A> - Check out and export all DeepSee II items which have changed since the last checkpoint</LI>
			>
		}
		&html<</UL>>
		Set locked=##class(%Studio.SourceControl.ISC).Locked()
		If (locked) {
			&html<
				<SPAN STYLE="font-size:.7em" >
				<STRONG>
				NOTE - Configuration is <FONT color='red'>#($select(locked=2:"ADMINLOCKED",1:"LOCKED"))#</FONT>;
				</STRONG>
			>
			If (locked<2) { Write "<br>Use the <code>##class(%Studio.SourceControl.ISC).Unlock()</code> method to change Lock state for this namespace",! }
			&html<
				</SPAN>
			>			
		}
		If $get(^SYS("SourceControl","ItemSetConfig","Enabled")) {
			&html<
				<H4>
					Current CCR Configuration 
					<A href="https://ccr.intersystems.com/ccr/create.csp?SiteCode=#($G(^SYS("SourceControl","ItemSetConfig","Org")))#&SystemCode=#($G(^SYS("SourceControl","ItemSetConfig","System")))#&BypassPREP=1" target='_blank'>[create new CCR]</A>
				</H4>
				<TABLE>
					<TR>
						<TD align='right'><label id="cOrg" >Organization</label></TD>
						<TD align='left'><code>#($get(^SYS("SourceControl","ItemSetConfig","Org")))#</code></TD>
						<TD></TD>
					</TR>
					<TR>
						<TD align='right'><label id="cSystem" >System</label></TD>
						<TD align='left'><code>#($get(^SYS("SourceControl","ItemSetConfig","System")))#</code></TD>
						<TD></TD>
					</TR>
					<TR>
						<TD align='right'><label id="cEnv" >Environment</label></TD>
						<TD align='left'><code>#($G(^SYS("SourceControl","ItemSetConfig","Environment")))#</code></TD>
						<TD></TD>
					</TR>
				</TABLE>
			>			
		}
	}
	&html<<H4>Current Namespace: <code>#($S(%session.RunNamespace="":"[no namespace selected]",1:"<strong>"_$ZCVT(%session.RunNamespace,"U")_"</strong>"))#</code></H4>
		<P>Switch to Namespace:</P>
		<UL>
	>
	Set rset=##class(%ResultSet).%New("%SYS.Namespace:List")
	Set sc=rset.Prepare()
	Set sc=rset.Execute()	
	While (rset.Next()) {
		Set namespace=rset.Data("Nsp")
		Try {
			If $data(^|namespace|Sources) {
				; adding "Namespace" to the url will cause %CSP.StudioTeamplateSuper to change %session.RunNamespace to that value
				&html<<LI><CODE><A HREF='#(..SelfLink())#?Namespace=#(namespace)#'>#(namespace)#</A></CODE></LI>>
			}
		} Catch (err) { /*ignore errors from unmounted DBs */ }
	}
	&html<</UL>>
}

ClassMethod CheckinDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))		//if there was no submit button passed, show the initial form
	If $data(DisplayForm) Set tShowForm=DisplayForm		//if an explicit directive on showing the form was passed, follow that instruction
	If (tShowForm) {
		#; Display input form
		&html<<h2>Perforce Checkin</h2><p>>
		If '##class(%Studio.SourceControl.ISC).Disconnected() {
			Set ret=##class(%Studio.SourceControl.ISC).GetCredentials(.user,,.workspace)
			If (('##class(%Studio.SourceControl.ISC).DefaultCredentialsDefined())&&('..PerforceLoggedIn())&&('$data(%request.Data("p4P")))) {
				&html<Enter password for Perforce user: <code>'#($get(user))#'</code>
					<form name="P4Pass" method="POST">
						<input id="p4P" name="p4P" type='password' size='8'><p>
						<input type="hidden" name="action" value="Checkin">
						<input type="submit" name="setpass" value="Proceed">
					</form>
					<script language='javascript'>
					document.getElementById("p4P").focus();
					</script>
				>
			} Else {
				If $data(%request.Data("p4P")) {
					Set sc=..PerforceLogin(%request.Data("p4P",1))
					If $$$ISERR(sc) { 
						Do ..ShowError(sc)
						Quit
					}
				}
				Kill args Set args($i(args))="opened",args($i(args))="-c",args($i(args))="default"
				If $get(workspace)'="" Set args($i(args))="-C",args($i(args))=workspace
				If $get(user)'="" Set args($i(args))="-u",args($i(args))=user
				Set sc=##class(%Studio.SourceControl.ISC).SecureP4Cmd(.args,.opened)	
				If $$$ISERR(sc) {
					If ($system.Status.GetErrorText(sc)["P4PASSWD") {
						Do ..PerforceLogin() ; somehow an invalid ticket has been cached; force login logic with no password set which will clear the cached ticket
						&html<
							<script language='javascript'>
								window.location.href='#(..SelfLink())#?action=Checkin';
							</script>
						>
					} Else {
						Do ..ShowError(sc)
					}
					Quit
				}
				If $get(opened)<1 {
					Write "Nothing in default changelist to submit for Perforce user: <code>'"_$get(user)_"'</code>",!
					Quit
				} Else {
					Kill args Set args($i(args))="info"
					Set sc=##class(%Studio.SourceControl.ISC).SecureP4Cmd(.args,.clientInfo)
					If $$$ISERR(sc) Do ..ShowError(sc)
					If $get(clientInfo)<1 {
						Set srcRoot=$get(^%SYS("SourceRoot",$zutil(5)),$get(^%SYS("SourceRoot"),"C:\Perforce\"))
					} Else {
						Set srcRoot=clientInfo(1,"clientRoot")
					}
					&html<<br/><br/>Select files to submit for Perforce user: <code>'#($get(user))#'</code><br/>
						<form name="P4Submit">
							<DIV style="overflow:scroll; height=15em; border-style: inset;">
					>
					Set checkFound=0
					For i=1:1:$get(opened) {
						If '$data(opened(i,"depotFile")) Continue
						Set checked=$select((%session.Get("item")'="")&&(opened(i,"depotFile")[%session.Get("item")):" checked",1:"")
						If (checked'="") { Set checkFound=1 }
						Write "<input type='checkbox' name='",..EscapeHTML(opened(i,"depotFile")),"'",checked," onclick='javascript:document.getElementById(""submitBtn"").disabled = false;'>",!
						Write ..EscapeHTML(opened(i,"action"))_": "_..EscapeHTML(opened(i,"depotFile"))
						Set file=##class(%File).NormalizeFilename(srcRoot_$P(opened(i,"clientFile"),opened(i,"client"),2))
						Set backupfile=##class(%File).NormalizeFilename(file_".bak")
						If ##class(%File).Exists(file)&&##class(%File).Exists(backupfile) {
							&html<&nbsp;&nbsp;&nbsp;<a href='#(..SelfLink())#?action=Diff&file=#(..EscapeURL(file))#&return=Checkin'>diff</a>>
						}
						Write "<br>",!
					}
					Set disabled=$select(checkFound:"",1:" disabled")
					&html<	
						</DIV>	
							Description (required):<br>
							<textarea name="Comment" cols=90 rows=8 wrap=physical></textarea><br/>
							Perforce Job (optional):
							<input name="job" size='8' value='#($get(%request.Data("job",1)))#'><p>
							<input type="hidden" name="action" value="Checkin">
							<input type="hidden" name="client" value="#($get(workspace))#">
							<input type="hidden" name="user" value="#($get(user))#">
							<input type="submit" name="submit" id="submitBtn" value="Submit" #(disabled)#>
						</form>
					>
				}
			}
		} Else {
			Write "Instance is in Disconnected mode.  Check-in commands cannot be sent to Perforce.",!
			Quit	
		}
	} ElseIf ('tShowForm) {
		Do ..PerforceLoggedIn() ;refresh the login credentials in the process if applicable
		#; Process form submission
		Set description=$translate($get(%request.Data("Comment",1)),$char(13))
		If $zstrip(description,"<>W")="" {
			&html<<DIV Style='color: red;'>You must enter a description</DIV>>
			Do ..CheckinDisplay(1)
			Quit
		}
		Set client=$get(%request.Data("client",1))
		Set user=$get(%request.Data("user",1))
		Set job=$zstrip($get(%request.Data("job",1)),"<>W")
		Set file=##class(%FileCharacterStream).%New()
		Set file.Filename=^Sources_"submit"_$J_".txt"
		Do file.WriteLine("Change:	new")
		Do file.WriteLine("")
		Do file.WriteLine("Jobs: "_job)
		Do file.WriteLine("")
		Do file.WriteLine("Client: "_client)
		Do file.WriteLine("")
		Do file.WriteLine("User: "_user)
		Do file.WriteLine("")
		Do file.WriteLine("Status: new")
		Do file.WriteLine("")
		Do file.WriteLine("Description:")
		For line=1:1:$length(description,$char(10)) {
			Do file.WriteLine("	"_$piece(description,$char(10),line))
		}
		Do file.WriteLine("")
		Do file.WriteLine("Files:")
		Set i=""
		For  {
			Set i=$order(%request.Data(i)) Quit:i=""
			If $extract(i,1,2)'="//"||(%request.Data(i,1)'="on") Continue
			Do file.WriteLine("	"_i)
		}
		Do file.SaveStream()
		Do file.Rewind()
		&html<<H3>Submit Details:</H3><p>>
		While 'file.AtEnd {
			Write file.ReadLine()_"<BR/>"
		}
		&html<<H3>Command Issued:</H3><p>>
		Kill args Set args($i(args))="submit",args($i(args))="-i"
		Set sc=##class(%Studio.SourceControl.ISC).SecureRunCmd("p4",.args,.output,,,file.Filename)
		Do file.Clear()
		If $$$ISERR(sc) {
			Do ..ShowError(sc) 
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
			Quit
		}
		&html<<H3>Change Submitted:</H3><p>>
		For i=1:1:output If $data(output(i),line) Write line,"<br>",!
		Quit		
	}
}

ClassMethod DownloadDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))				//if there was no submit button passed, show the initial form
	Set tShowForm=tShowForm&&('$data(%request.Data("ccr")))		//see if a ccr was passed
	Set tShowForm=tShowForm&&('$data(%request.Data("id")))		//see if an id of the ItemSet on the Server was passed
	If $data(DisplayForm) Set tShowForm=DisplayForm				//if an explicit directive on showing the form was passed, follow that instruction
	Set sc=$$$OK
	If (tShowForm) {
		#; Display input form
		&html<
			<FORM ACTION="" method=post name="download">
				<H2>Download ItemSet</H2>
				<P>Fill in the fields to download the latest ItemSet for a given CCR and load it into this namespace.
				<TABLE>
					<TR>
						<TD align='right'><label id="cCCR">CCR</label></TD>
						<TD><input id="ccr" name="ccr" value="#($G(^SYS("SourceControl","ItemSetConfig","Org")))#xxxx"></input></TD>
					</TR>
					<TR>
						<TD align='right'><label>Access Token</label></TD>
						<TD><input id="token" name="token" value="[retrieve from CCR]"></input></TD>
					</TR>
					<TR>
						<TD></TD>
						<TD><input type="Submit" id="Submit" name="submit" value="List ItemSets" title="List ItemSets"></input></TD>
					</TR>
				</TABLE>
			</FORM>	
		>
	} ElseIf ('tShowForm) {
		#; Process form submission
		&html<<H2>ItemSet Download</H2>>
		Set ccr=$zstrip($zcvt($get(%request.Data("ccr",1)),"U"),"<>W")
		Set ISid=$get(%request.Data("id",1))
		If (ISid="") {
			Set env=$get(^SYS("SourceControl","ItemSetConfig","Environment"))
			Set token=$zstrip($get(%request.Data("token",1)),"<>W")
			Set sc=##class(%Studio.SourceControl.ItemSet).WSList(ccr,env,token,.rs)
			If $$$ISERR(sc) Write ..EscapeHTML($System.Status.GetErrorText(sc)) Set abort=1
			If '$isobject(rs) Write "<PRE>ERROR: DataSet not returned from Web Service</PRE>" Set abort=1
			Set cnt=0
			If $get(abort) quit
			&html<
				<H3>ItemSet Selection</H3>
				<FORM ACTION="" method=post name="download">
					<P>Select an ItemSet for Download
					<TABLE>
						<TR>
							<TD colSpan=2>
								<TABLE border=1>
									<THEAD>
										<TR>
											<TH NOWRAP align='left'>ID</TH>
											<TH NOWRAP align='left'>Name</TH>
											<TH NOWRAP align='left'>Timestamp</TH>
											<TH NOWRAP align='left'>&nbsp;</TH>
										</TR>
									</THEAD>
			>
			While (rs.Next()) {
				Set cnt=$I(cnt)
				Set lastID=rs.Get("ID")
				Set link=..SelfLink()_"?action=Download&id="_lastID_"&ccr="_ccr_"&token="_token
				&html<
					<TR>
						<TD>#(lastID)#</TD>
						<TD>#(rs.Data("Name"))#</TD>
						<TD>#(rs.Data("CreateTimestamp"))#</TD>
						<TD><A HREF="#(link)#">download</A></TD>
					</TR>
				>
			}
			&html<</TABLE>>
			If (cnt=0) {
				&html<No ItemSets for CCR '#(ccr)#' to download>
			} ElseIf (cnt=1) {
				Set ISid=lastID
				&html<
					<P>Only one ItemSet exists for that CCR, downloading ItemSet #(lastID)#...
					<script language='Javascript'>
					setTimeout("window.location = '#(link)#'",2000);
					</script>
				>
			}
		} ElseIf (ISid'="") {
			Set ret=##class(%Studio.SourceControl.ISC).GetCredentials(.user,,.workspace)
			If $data(%request.Data("p4P")) {
				Set sc=..PerforceLogin(%request.Data("p4P",1))
				If $$$ISERR(sc) { Set badPassword=1, passwordSC=sc }
			}
			If ($get(badPassword)) {
				&html<
					Perforce returned the following error:<br/>
					#(..EscapeHTML($system.Status.GetErrorText(sc)))#
				>	
			} ElseIf (('##class(%Studio.SourceControl.ISC).Disconnected())&&('##class(%Studio.SourceControl.ISC).DefaultCredentialsDefined())&&('..PerforceLoggedIn())) {
				&html<
					Environment is configured as Connected to Perforce, so p4 sync will be called for items in ItemSet.<br/>
					Enter password for Perforce user: <code>'#($get(user))#'</code>
					<form name="P4Pass" method="POST">
						<input id="p4P" name="p4P" type='password' size='8' tabindex='1'><p>
						<input type="hidden" name="action" value="Download">
						<input type="hidden" name="id" value="#(ISid)#">
						<input type="hidden" name="token" value="#($get(%request.Data("token",1)))#">
						<input type="hidden" name="ccr" value="#($get(%request.Data("ccr",1)))#">
						<input type="submit" name="setpass" value="Proceed">
					</form>
					<script language='javascript'>
					document.getElementById("p4P").focus();
					</script>
				>
			} Else {
				&html<	
					<H3>ItemSet Download</H3>
					<P>Download Results:
					<PRE>
				>
				Do {
					Write !
					Set env=$G(^SYS("SourceControl","ItemSetConfig","Environment"))
					Set token=$zstrip($G(%request.Data("token",1)),"<>W")
					Write "Attempting to download ItemSet XML for ItemSet "_ISid_" from Server...",!
					Set sc=##class(%Studio.SourceControl.ItemSet).WSDownload(ccr,env,token,,ISid,.tFilename)
					If $$$ISERR(sc) Write ..EscapeHTML($system.Status.GetErrorText(sc)),! Continue 

					Write "ItemSet XML downloaded successfully:",!,"   ",tFilename,!
					Write "Download() of ItemSet XML to file system is complete.",!,!

					Set sc=##class(%Studio.SourceControl.ItemSet).Import(tFilename,.obj)
					If $$$ISERR(sc) Write ..EscapeHTML($system.Status.GetErrorText(sc)),! Continue 

					Set pNewID=obj.%Id()
					Write "New ItemSet Object created on system with local ID="_pNewID,!
					Write $C(9),"CCR:",obj.CCR,!
					Write $C(9),"Created By:",obj.CreatedBy,!
					Write $C(9),"Source:",obj.Source,!
					Write $C(9),"Target:",obj.Target,!
					Write "Import() of ItemSet object to DB is complete.",!,!
	
					Write "Creating preview of loading Payload to file system...",!
					Set sc=obj.LoadToOS(,,,.tReadWrite,1)
					Set output=..ConvertStreamToHTML(obj.Log)
					While ('output.AtEnd) {
						Write output.Read(8000)
					}
					If $$$ISERR(sc) { Continue }
					&html<
						Preview of Load Complete.
						</PRE>
						<FORM ACTION="" method=post name="download" action='#(..SelfLink())#'>
							<TABLE>
								<TR>
									<TD colspan='3'>
										Click the button below to Load the contents of this ItemSet into the #($zu(5))# namespace
									</TD>
								</TR>
								<TR>
									<TD>&nbsp;
										<input id="action" name="action" type="hidden" value="Load">
										<input id="id" name="id" type="hidden" value="#(obj.%Id())#">
									</TD>
									<TD>
										<input type="Submit" id="submit" name="submit" value="Load ItemSet" title="Load ItemSet" onclick="needToConfirm = false;" ></input>
									</TD>
								</TR>
							</TABLE>
						</FORM>			
						<script language="JavaScript">
						var needToConfirm = true;
						window.onbeforeunload = confirmExit;
						function confirmExit()
						{
							if (needToConfirm)
								return "You have attempted to leave this page but have not Loaded the ItemSet yet (this is only a preview).  Click 'Load ItemSet' to finish your task.\n\nAre you sure you want to exit this page without Loading the ItemSet?";
						}
						</script>
					>
				} While (0)
			}
		}
		If $$$ISERR(sc) {
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
		}
	}
}

ClassMethod LoadDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))				//if there was no submit button passed, show the initial form
	Set tShowForm=tShowForm&&('$data(%request.Data("id")))		//see if an id of a local ItemSet was passed
	If $data(DisplayForm) Set tShowForm=DisplayForm				//if an explicit directive on showing the form was passed, follow that instruction
	If (tShowForm) {
		#; Display input form
		&html<
			<FORM ACTION="" method=post name="download">
				<H2>Load ItemSet</H2>
				<P>Enter the ID of the ItemSet whose contents you wish to Load into the #($zu(5))# Namespace
				<TABLE>
					<TR>
						<TD align='right'><label>ItemSet ID</label></TD>
						<TD><input id="id" name="id"></input></TD>
					</TR>
					<TR>
						<TD></TD>
						<TD><input type="Submit" id="submit" name="submit" value="Load ItemSet" title="Load ItemSet"></input></TD>
					</TR>
				</TABLE>
			</FORM>	
		>
	} ElseIf ('tShowForm) {
		#; Process form submission
		If (('##class(%Studio.SourceControl.ISC).Disconnected())&&('##class(%Studio.SourceControl.ISC).DefaultCredentialsDefined())&&('..PerforceLoggedIn())) {
			//TODO - refactor when above Form is refactored to allow ItemSet loading from random location on OS
			Write "ItemSet cannot be loaded into Connected namespace unless user is logged in!!"  
		}
		Set objId=$get(%request.Data("id",1))
		&html<
			<H2>ItemSet Load</H2>
			<P>Load Results:
			<PRE>
		>
		Do %session.Set("CHANGECONTROL.BYPASS",1)
		Do {
			If objId="" Write "ERROR:  No ItemSet Id passed to page" Continue
			Set obj=##class(%Studio.SourceControl.ItemSet).%OpenId(objId)
			If '$isobject(obj) Write "ERROR:  No ItemSet Id passed to page" Continue
			
			Write !,"Loading files to the OS from Payload file...",!
			Set sc=obj.LoadToOS(,,.itemlist,,,1)
			Set output=..ConvertStreamToHTML(obj.LogHistory)
			While ('output.AtEnd) {
				Write output.Read(8000)
			}
			If $$$ISERR(sc) Continue

			Write !,"Loading of Payload contents to file system is complete.",!
			Set pCompile=2 //might want to prompt for this on previous page in the future; use 2 to indicate that compile should not happen if it includes the %Studio.SourceControl.ItemSet class
			Set sc=obj.LoadToNS(,.itemlist,0,pCompile,.incPercent)
			Set output=..ConvertStreamToHTML(obj.Log)
			While ('output.AtEnd) {
				Write output.Read(8000)
			}
			If $$$ISERR(sc) Continue	
		} while (0)
		Do %session.Kill("CHANGECONTROL.BYPASS")
		If $$$ISERR(sc) w !,"WARNING: Errors occurred during Load().  Most recent error:",!,..EscapeHTML($system.Status.GetErrorText(sc)),!,"Please carefully examine session details",!,!
		Write "******   ItemSet Load() Method Complete: "_objId_"   ******",!,!

		Write $TRANSLATE($JUSTIFY(" ",80)," ","="),!
		Write "ItemSet Import Summary:",!
		Write "     ItemSet Name:        ",obj.Name,!
		Write "     New ItemSet Id:      ",objId,!
		If $$$ISERR(sc) {
			Write "WARNING: Errors occurred during Load().",!
			Write "     Most recent error:",!,..EscapeHTML($system.Status.GetErrorText(sc)),!
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
		}
		&html<</PRE>>
		If $G(incPercent)&&(##class(%Studio.SourceControl.ItemSet).CACHELIBReadOnly()) {
			&html<
				NOTE: This ItemSet contains %routines or %classes which must be loaded to CACHELIB<BR>
				Please change CACHELIB to Read/Write and then try Loading ItemSet again: <A HREF="#(..SelfLink())#?action=Load&id=#(objId)#">Reload ItemSet #(objId)#</A>
			>
		}
	}
}

ClassMethod BundleDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))				//if there was no submit button passed, show the initial form
	If $data(DisplayForm) Set tShowForm=DisplayForm				//if an explicit directive on showing the form was passed, follow that instruction
	If (tShowForm) {
		#; Display input form
		&html<
			<H2>Bundle and Upload ItemSet</H2>
			<P>Select the Uncommitted Changes to Bundled into an ItemSet.<BR/>
				Then, fill in the fields at the bottom to upload the ItemSet <BR/>
				to the CCR Server and submit the selected changes into Perforce.
			<FORM ACTION="" method=post name="filter">
				<TABLE>
					<TR>
						<TD><H3>Filter Uncommitted Changes by:</H3></TD>
						<TD>
		>
		If ($L($G(%request.Data("SourceFilter",1)))+$L($G(%request.Data("ChangedByFilter",1)))+$L($G(%request.Data("CCRFilter",1)))>0) &html<<A HREF='javascript:clearFilter();'>[view all]</A>>
		&html<
						</TD>
					</TR>
					<TR>
						<TD align='right'><label id="cSourceFilter">Source</label></TD>
						<TD><input id="SourceFilter" name="SourceFilter" size=10 value="#($G(%request.Data("SourceFilter",1)))#"></input></TD>
					</TR>
					<TR>
						<TD align='right'><label id="cChangedByFilter">Changed By</label></TD>
						<TD>
							<input id="ChangedByFilter" name="ChangedByFilter" size=10 value="#($G(%request.Data("ChangedByFilter",1)))#"></input>
							<A HREF="Javascript:filterByMe('#($USERNAME)#');">[me]</A>
						</TD>
					</TR>
					<TR>
						<TD align='right'><label id="cCCRFilter">CCR</label></TD>
						<TD><input id="CCRFilter" name="CCRFilter" size=10 value="#($G(%request.Data("CCRFilter",1)))#"></input></TD>
					</TR>
					<TR>
						<TD align='right'>&nbsp;</TD>
						<TD><input type="Button" id="Filter" name="Filter" value="Filter" title="Filter Uncommitted Change list" onclick="javascript:document.filter.submit()"></input></TD>
					</TR>
				</TABLE>
			</FORM>
			<FORM ACTION="" method=post name="uncommitted">
				<TABLE>
					<TR>
						<TD><H3>Uncommitted Queue:</H3></TD>
					</TR>
					<TR>
						<TD colSpan=3>
							<TABLE width='100%'>
								<TR>
									<TD valign=top style='padding-left:0;'>
										<TABLE cellspacing=2 BGCOLOR='#BBBBBB'>
											<THEAD>
												<TR align='left' BGCOLOR='#CCCCCC'>
													<TH style='display:none;'></TH>
													<TH id=1 NOWRAP><input name="allbox" type="checkbox" value="Check All" onclick="CheckAll(document.uncommitted);" /></TH>
													<TH id=2 NOWRAP>Last Changed</TH>
													<TH id=3 NOWRAP>Source</TH>
													<TH id=4 NOWRAP>CCR</TH>
													<TH id=5 NOWRAP>Changed By</TH>
													<TH id=6 NOWRAP>Action</TH>
													<TH id=7 NOWRAP>Name</TH>
													<TH id=8 NOWRAP>Internal Name</TH>
													<TH id=8 NOWRAP>&nbsp;</TH>
												</TR>
											</THEAD>
			>
			Set sourceFilter=$G(%request.Data("SourceFilter",1))
			Set userFilter=$G(%request.Data("ChangedByFilter",1))
			Set ccrFilter=$G(%request.Data("CCRFilter",1))
			Set query = "SELECT ID, UpdatedTime, Source, CCR, ChangedBy, Action, Name, InternalName, ItemFile, ExternalName, BackupName FROM %Studio_SourceControl.Change "
			Set query = query_"WHERE Committed='0' "
			If sourceFilter'="" Set query = query_"AND Source='"_sourceFilter_"' "
			If userFilter'="" Set query = query_"AND ChangedBy='"_userFilter_"' "
			If ccrFilter'="" Set query = query_"AND CCR='"_ccrFilter_"' "
			Set query = query_"ORDER BY UpdatedTime DESC"
			Set rset=##class(%ResultSet).%New("%DynamicQuery:SQL")
			Set sc=rset.Prepare(query)
			Set sc=rset.Execute()	
			Set i=0
			Kill uniqueList,deleteList
			Merge selected=%request.Data("check")
			Set cnt=$O(selected(""),1,key)
			While (cnt'="") {
				Set idxList=$get(idxList)_$LB(key)
				Set cnt=$O(selected(cnt),1,key)
			}
			Kill selected			
			While (rset.Next()) {
				Set i=$I(i)
	  			Set rowColor=$S(i#2:"#DDDDDD",1:"#CCCCCC")
				If $USERNAME=rset.Data("ChangedBy") {
					Set userCheckIds("check|"_i)=""
				}
				Set checked=$select($listfind($get(idxList),i):" checked",1:"")
				Set checkBoxHTML="<input name='check' value='"_i_"' id='check|"_i_"' type='checkbox' onclick='Javascript:checkbox();' "_checked_">"
				Set internalName=$S($LV(rset.Data("InternalName")):$LTS(rset.Data("InternalName"),"@"),1:rset.Data("InternalName"))
	  			Set itemName=$S($LV(rset.Data("Name")):$LTS(rset.Data("Name"),"@"),1:rset.Data("Name"))
	  			Set diffcode=""
	  			If (rset.Data("ExternalName")'="")&&(rset.Data("BackupName")'="") {
		  			Set file=rset.Data("ExternalName")
		  			If ##class(%File).Exists(file) && ##class(%File).Exists(rset.Data("BackupName")) {
		  				Set diffcode="<a href='"_..SelfLink()_"?action=Diff&file="_..EscapeURL(file)_"&return=Bundle'>diff</a>"
		  			} 
	  			}
	  			&html<
	  				<TR BGCOLOR="#(rowColor)#" title="#(rset.Data("ItemFile"))#" NOWRAP>
						<TD style='display:none;'><input id="ChangeId" name="ChangeId" type="hidden" value="#(rset.Data("ID"))#"></TD>
						<TD>#(checkBoxHTML)#</TD>
						<TD>#(rset.Data("UpdatedTime"))#</TD>
						<TD>#(rset.Data("Source"))#</TD>
						<TD><a href='https://ccr.intersystems.com/ccr/view.csp?RID=#(rset.Data("CCR"))#' target='_blank'>#(rset.Data("CCR"))#</a></TD>
						<TD>#(rset.Data("ChangedBy"))#</TD>
						<TD>#(rset.Data("Action"))#</TD>
						<TD>#(itemName)#</TD>
						<TD>#(internalName)#</TD>
						<TD>#(diffcode)#</TD>
	  				</TR>
				>
			}
			&html<
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
			>
			If (i>0) {
				&html<
					<TR>
						<TD><input type="button" id="Mine" name="Mine" value="Select Mine" title="Select Mine" onclick="CheckMine();"></input>(#($USERNAME)#)</TD>
						<TD></TD>
						<TD></TD>
					</TR>
					<TR>
						<TD></TD>
						<TD align='right'><label id="cCCR">CCR</label></TD>
						<TD><input id="ccr" name="ccr" size='16' value="#($select($data(%request.Data("ccr",1)):$get(%request.Data("ccr",1)),1:$G(^SYS("SourceControl","ItemSetConfig","Org"))_"xxxx"))#"></input></TD>
					</TR>
					<TR>
						<TD></TD>
						<TD align='right'><label id="cPath" >Upload ItemSet</label></TD>
						<TD><input name='upload' id='upload' value='1' type='checkbox' checked></TD>
					</TR>
					<TR>
						<TD></TD>
						<TD align='right'><label id="cPath" >Access Token</label></TD>
						<TD><input id="token" name="token" size='16' value="#($select($data(%request.Data("token",1)):$get(%request.Data("token",1)),1:"[retrieve from CCR]"))#"></input></TD>
					</TR>
					<TR>
						<TD></TD>
						<TD></TD>
						<TD><input type="submit" name="submit" value="Bundle Changes" title="Bundle changes into an ItemSet"></input></TD>
					</TR>
					<TR>
						<TD colspan='3'><label id="cPath" >Path:</label>&nbsp;<code>#(^Sources)#</code></TD>
					</TR>
					<!--tr><td><pre><script language='cache' runat='server'> zw </script></pre></td></tr-->
				>
			} Else {
				&html<
					<TR>
						<TD colspan='3'>
							No uncommitted changes exist in this namespace
						</TD>
					</TR>						
				>
			}
			&html<
				</TABLE>
			</FORM>	
			<script language="javascript">
			function checkbox() {
				CheckCheckAll(document.uncommitted);
			}
			function CheckAll(fmobj) {
			  for (var i=0;i<fmobj.elements.length;i++) {
			    var e = fmobj.elements[i];
			    if ((e.name != 'upload') && (e.name != 'allbox') && (e.type=='checkbox') && (!e.disabled) ) {
			      e.checked = fmobj.allbox.checked;
			    }
			  }
			}
			function CheckCheckAll(fmobj) {
			  var TotalBoxes = 0;
			  var TotalOn = 0;
			  for (var i=0;i<fmobj.elements.length;i++) {
			    var e = fmobj.elements[i];
			    if ((e.name != 'upload') && (e.name != 'allbox') && (e.type=='checkbox')) {
			      TotalBoxes++;
			      if (e.checked) {
			       TotalOn++;
			      }
			    }
			  }
			  if (TotalBoxes==TotalOn) {
			    fmobj.allbox.checked=true;
			  }
			  else {
			   fmobj.allbox.checked=false;
			  }
			}
			function filterByMe(user) {
				var el=document.getElementById('ChangedByFilter');
				el.value=user;
				document.filter.submit();	
			}
			function clearFilter() {
				var el1=document.getElementById('CCRFilter');
				var el2=document.getElementById('ChangedByFilter');
				var el3=document.getElementById('SourceFilter');
				el1.value="";
				el2.value="";
				el3.value="";
				document.filter.submit();	
			}
			</script>
		>
		Write "<script language='javascript'>"
		Write "function CheckMine(fmobj) {",!
		Set id=""
		Set id=$O(userCheckIds(id))
		While (id'="") {
			Write "var el = document.getElementById('"_id_"');",!
			Write "el.checked=true;",!
			Set id=$O(userCheckIds(id))
		}
		Write "}",!
		Write "</script"_">"
	} ElseIf ('tShowForm) {
		#; Process form submission
		Set ccr=$zcvt($zstrip($get(%request.Data("ccr",1)),"<>W"),"U")
		Set token=$zstrip($get(%request.Data("token",1)),"<>W")
		Merge selected=%request.Data("check")
		Set failed=0
		If (ccr="")||($length(ccr)<8)||($extract(ccr,5,8)="XXXX") {
			Set failed=1, errMessage="You must enter a valid CCR to Bundle an ItemSet"
		} ElseIf ($data(%request.Data("upload",1)))&&((token="")||(token="[retrieve from CCR]")) {
			Set failed=1, errMessage="You must enter a valid token to Upload an ItemSet"
		} ElseIf ('$data(selected)) {
			Set failed=1, errMessage="You must select at least one item to Bundle into the ItemSet"	
		}
		Kill selected
		If (failed) {
			&html<<DIV Style='color: red;'>#(errMessage)#</DIV>>
			Do ..BundleDisplay(1)
			Quit
		}
		&html<
			<H2>Bundle ItemSet Results</H2>
			<PRE>
		>
		Write !
		Do {
			Set log=##class(%GlobalCharacterStream).%New()
			Set env=$G(^SYS("SourceControl","ItemSetConfig","Environment"))
			Set token=$zstrip($get(%request.Data("token",1)),"<>W")
			//First confirm that the access token is valid if an upload will be attempted
			If $d(%request.Data("upload",1)) {
				Set sc=##class(%Studio.SourceControl.ItemSet).WSList(ccr,env,token,.rs)
				If $$$ISERR(sc) {
					Set uploadStatus=$SYSTEM.Status.GetErrorText(sc)
					If uploadStatus["#6059" {
						Do log.WriteLine("NOTE:  Connectivity to CCR Server cannot be established")
						Do log.WriteLine("ItemSet will need to be uploaded to CCR Server from another machine")
					} Else {
						Do log.WriteLine($SYSTEM.Status.GetErrorText(sc)) Continue
					}
				}
			}
			Kill exportedlist,committedRows
			Merge selected=%request.Data("check")
			Merge ChangeIds=%request.Data("ChangeId")
			Do log.WriteLine($TRANSLATE($JUSTIFY(" ",80)," ","-")) 
			Do log.WriteLine("Processing list of changes to Bundle into an ItemSet") 
			Set cnt=$O(selected(""),1,key), cntIncluded=0
			While (cnt'="") {
				Set changeId=ChangeIds(key)
				Kill change
				Set change=##class(%Studio.SourceControl.Change).%OpenId(changeId)
				If '$isobject(change) {
					Do log.WriteLine($C(9)_"ERROR: Id='"_changeId_"' does not correspond to a %Studio.SourceControl.Change object") 
				} ElseIf change.Committed {
					Do log.WriteLine($C(9)_"ERROR: "_change.Name_" has already been committed") 
				} Else {
					Set cntIncluded=$I(cntIncluded)
					Set exportedlist(change.ItemFile)=change.Action
					Do log.WriteLine($C(9)_"Including "_change.Name_" stored in "_change.ItemFile)
				}
				Set cnt=$O(selected(cnt),1,key)
			}
			Do log.WriteLine($C(9)_cntIncluded_" changed items selected for inclusion") 
			If (cntIncluded>0) {
				Do log.WriteLine($TRANSLATE($JUSTIFY(" ",80)," ","="))
				Do log.WriteLine("Creating new Itemset...")
				Set objItemSet=##class(%Studio.SourceControl.ItemSet).%New()
				Set sc=objItemSet.Create(.exportedlist,ccr,$USERNAME,env,"Server",ccr,env)
				Do log.MoveToEnd() Do log.CopyFrom(objItemSet.LogHistory)
				If $$$ISERR(sc) Do log.WriteLine($SYSTEM.Status.GetErrorText(sc)) Kill objItemSet Continue
				Set pNewID=objItemSet.%Id()
				Do log.WriteLine("New ItemSet Object created on system with local ID="_pNewID)
				Do log.WriteLine("")

				Do log.WriteLine("Exporting ItemSet to XML ...")
				Set sc=objItemSet.ExportToFile(.file)
				Do log.MoveToEnd() Do log.CopyFrom(objItemSet.Log)
				If $$$ISERR(sc) Do log.WriteLine($SYSTEM.Status.GetErrorText(sc)) continue

				Do log.WriteLine("ItemSet [%Id="_objItemSet.%Id()_"] created, and exported as XML:")
				Do log.WriteLine($C(9)_objItemSet.ItemSetFile)
				Do log.WriteLine("")
			
				Do log.WriteLine("Removing items from local pending list, and changing files to ReadOnly...")
				Set sc=##class(%Studio.SourceControl.Change).RemoveUncommitted(.exportedlist,0)
				If $$$ISERR(sc) Do log.WriteLine($SYSTEM.Status.GetErrorText(sc)) Continue
				Do log.WriteLine("Local list and files have been updated.")
				Do log.WriteLine("")
			}
		} While (0)
		If $$$ISERR(sc) {
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
		}
		Do log.WriteLine($TRANSLATE($JUSTIFY(" ",80)," ","="))
		If $isobject($G(objItemSet)) {
			Do log.WriteLine("ItemSet Bundle Summary:")
			Do log.WriteLine("     ItemSet Created:     "_objItemSet.Name)
			Do log.WriteLine("     ItemSet File:        "_objItemSet.ItemSetFile)
			Do log.WriteLine("     Number of Items:     "_cntIncluded)
			Do log.WriteLine("     Upload Status:       "_$S($d(%request.Data("upload",1)):"Pending...",1:"Skipped"))
		}
		Else {
			Do log.WriteLine("ItemSet Bundle Summary:")
			Do log.WriteLine("     ERROR:  No ItemSet was created")
			If $G(cntIncluded)=0 Do log.WriteLine("     No items were selected to Bundle")
		}
		Do log.Rewind() 
		Set output=..ConvertStreamToHTML(log)
		While ('output.AtEnd) {
			Write output.Read(8000)
		}
		If $isobject($G(objItemSet)) {
			Do objItemSet.LogHistory.MoveToEnd() Do objItemSet.LogHistory.CopyFrom(log)
			Set sc=objItemSet.LogHistory.%Save()
			If $$$ISERR(sc) Write ..EscapeHTML($system.Status.GetErrorText(sc)),!
		}
		&html<</PRE>>
		If $d(%request.Data("upload",1))&&$isobject($G(objItemSet)) {
			&html<	
				<FORM ACTION="" method=post name="upload" action='#(..SelfLink())#'>
					<TABLE>
						<TR>
							<TD colspan='2'>Click the button below to Upload this ItemSet to the CCR Server</TD>
						</TR>
						<TR>
							<TD>&nbsp;
								<input id="action" name="action" type="hidden" value="Upload">
								<input id="ccr" name="ccr" type="hidden" value="#(ccr)#">
								<input id="token" name="token" type="hidden" value="#(token)#">
								<input id="file" name="file" type="hidden" value="#(objItemSet.ItemSetFile)#">
								<input id="id" name="id" type="hidden" value="#(objItemSet.%Id())#">
							</TD>
							<TD><input type="Submit" id="submit" name="submit" value="Upload ItemSet" title="Upload ItemSet"></input></TD>
						</TR>
					</TABLE>
				</FORM>			
			>
		}
	}
}

ClassMethod UploadDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))				//if there was no submit button passed, show the initial form
	Set tShowForm=tShowForm&&('$data(%request.Data("ccr")))		//see if a ccr has been passed for the upload
	Set tShowForm=tShowForm&&('$data(%request.Data("token")))	//see if a token has been passed for the upload
	Set tShowForm=tShowForm&&('$data(%request.Data("file")))	//see if a file has been passed for the upload
	If $data(DisplayForm) Set tShowForm=DisplayForm				//if an explicit directive on showing the form was passed, follow that instruction
	Do ##class(%Studio.SourceControl.ItemSet).GetPathTranslation(.rootDir,.path)
	Set exportDirectory=##class(%File).NormalizeDirectory(rootDir_"ItemSets")
	Set exportDirectory=##class(%File).NormalizeDirectory(exportDirectory_"Export")
	Set ccrOrg = $G(^SYS("SourceControl","ItemSetConfig","Org"))
	Set exportDirectory=##class(%File).NormalizeDirectory(exportDirectory_ccrOrg)
	
	If (tShowForm) {
		#; Display input form
		&html<
			<H2>Upload ItemSet</H2>
			<FORM ACTION="" method=post name="upload" action='#(..SelfLink())#'>
				<TABLE>
					<TR>
						<TD colspan='2'>Fill in the details below to Upload an ItemSet to the CCR Server</TD>
					</TR>
					<TR>
						<TD align='right' colspan='2'>Please enter the filename of the ItemSet located in <code>#(exportDirectory)#</code> </TD>
					</TR>
					<TR>
						<TD align='right'>ItemSet File</TD>
						<TD><input id="file" type='text' name="file" size='35'></TD>
					</TR>
					<TR>
						<TD align='right'>Token</TD>
						<TD><input id="token" name="token"></input></TD>
					</TR>
					<TR>
						<TD><input id="action" name="action" type="hidden" value="Upload"></TD>
						<TD><input type="Submit" id="submit" name="submit" value="Upload ItemSet" title="Upload ItemSet"></input></TD>
					</TR>
				</TABLE>
			</FORM>			
		>
	} ElseIf ('tShowForm) {
		#; Process form submission
		Set failed=0
		Set token=$zstrip($get(%request.Data("token",1)),"<>W")
		Set file=$get(%request.Data("file",1))
		If ('##class(%File).Exists(file)) {
			// now assuming that file is NOT a full path and filename.  Therefore add path.
			Set file = ##class(%File).NormalizeFilename(exportDirectory_file)
		}

		&SQL(SELECT id INTO :ISId from %Studio_SourceControl.ItemSet WHERE ItemSetFile = :file)
		Set objItemSet=##class(%Studio.SourceControl.ItemSet).%OpenId(ISId)
		If ($isobject(objItemSet)) {
			Set ccr=objItemSet.CCR
		} Else {
			Set failed=1, errMessage="<code>"_file_"</code> did not match ItemSetFile for any of the rows in the %Studio_SourceControl.ItemSet table "
		}
		If (token="")||(token="[retrieve from CCR]") {
			Set failed=1, errMessage="You must enter a valid token to Upload an ItemSet"
		} ElseIf (file="")||('##class(%File).Exists(file)) {
			Set failed=1, errMessage="<code>"_file_"</code> does not exist and cannot be uploaded"
		}
		If (failed) {
			&html<<DIV Style='color: red;'>#(errMessage)#</DIV>>
			Do ..UploadDisplay(1)
			Quit
		}
		&html<
			<H2>Upload ItemSet Results</H2>
			<PRE>
		>
		Write !
		Set log=##class(%GlobalCharacterStream).%New()
		Set env=$G(^SYS("SourceControl","ItemSetConfig","Environment"))
		Do log.WriteLine("")
		Do log.WriteLine("******   ItemSet Upload() Method   ******")
		Do log.WriteLine("Attempting to upload ItemSet to CCR Server for "_ccr_"...")
		Set sc=##class(%Studio.SourceControl.ItemSet).Upload(0, ccr, token, file) 
		If $$$ISOK(sc) {
			Set uploadStatus="Success!"
		} Else {
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
			Set uploadStatus=$SYSTEM.Status.GetErrorText(sc)
			If uploadStatus["#6059" {
				Do log.WriteLine("NOTE:  Connectivity to CCR Server cannot be established")
				Do log.WriteLine("Please Upload ItemSet to CCR Server from another machine:")
				Do log.WriteLine($C(9)_file)
			} ElseIf uploadStatus["#5922" {
				// "<ZSOAP> ERROR Trapped: ERROR #5922: Timed out waiting for response" thrown
				Set uploadStatus="Check-in in progress; please see your CCR for final results"
			}
		}
		Do log.WriteLine("ItemSet Upload Summary:")
		Do log.WriteLine("     ItemSet File:        "_file)
		Do log.WriteLine("     Upload Status:       "_$G(uploadStatus))
		Do log.WriteLine("")
		Do log.WriteLine("******   ItemSet Upload() Method Complete   ******")
		Do log.Rewind() 
		Set output=..ConvertStreamToHTML(log)
		While ('output.AtEnd) {
			Write output.Read(8000)
		}
		If $isobject($G(objItemSet)) {
			Do objItemSet.LogHistory.MoveToEnd() Do objItemSet.LogHistory.CopyFrom(log)
			Set sc=objItemSet.LogHistory.%Save()
			If $$$ISERR(sc) Write ..EscapeHTML($system.Status.GetErrorText(sc)),!
		}
		&html<</PRE>>
	}
}

ClassMethod ItemsetlogDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))				//if there was no submit button passed, show the initial form
	Set tShowForm=tShowForm&&('$data(%request.Data("ccr")))		//see if a ccr was passed
	Set tShowForm=tShowForm&&('$data(%request.Data("id")))		//see if an id was passed
	If $data(DisplayForm) Set tShowForm=DisplayForm				//if an explicit directive on showing the form was passed, follow that instruction
	If (tShowForm) {
		#; Display input form
		&html<
			<h2>ItemSet Log Display</h2>
			<form name="LogView" Action="">
				CCR: <input name="ccr" size='8'><p>
				<input type="hidden" name="action" value="ItemSetLog">
				<input type="submit" name="submit" value="Submit">
			</form>
		>
	} ElseIf ('tShowForm) {
		#; Process form submission
		Set ccr=$zstrip($zcvt($get(%request.Data("ccr",1)),"U"),"<>W")
		Set ISid=$get(%request.Data("id",1))
		If (ccr="")&&(ISid="") {
			&html<<DIV Style='color: red;'>You must enter a ccr</DIV>>
			Do ..ItemsetlogDisplay(1)
			Quit
		}
		If (ISid="") {
			&html<<H3>List of ItemSet Logs for #(ccr)#</H3><p>>
			Set sql="Select ID, Name, CreateTimestamp FROM %Studio_SourceControl.ItemSet WHERE CCR=?"
			Set cnt=0, query=##class(%ResultSet).%New("%DynamicQuery:SQL")
			Set sc=query.Prepare(sql) If $$$ISERR(sc) Do $System.OBJ.DisplayError(sc) Quit
			Set sc=query.Execute(ccr) If $$$ISERR(sc) Do $System.OBJ.DisplayError(sc) Quit
			&html<
				<TABLE border='1'>
					<THEAD>
						<TR>
							<TH NOWRAP align='left'>ID</TH>
							<TH NOWRAP align='left'>Name</TH>
							<TH NOWRAP align='left'>Timestamp</TH>
							<TH NOWRAP align='left'>&nbsp;</TH>
						</TR>
					</THEAD>
			>
			While (query.Next()) {	
				Set cnt=$I(cnt)
				Set lastID=query.Get("ID")
				&html<<TR><TD>>
				Do query.%Print("</TD><TD>")
				&html<</TD><TD><A HREF="#(..SelfLink())#?action=ItemSetLog&id=#(lastID)#">view log</A></TD></TR>>
			}
			&html<</TABLE>>
			If (cnt=0) {
				&html<No ItemSets for CCR '#(ccr)#' in #($zu(5))# namespace>
			} ElseIf (cnt=1) {
				Set ISid=lastID
				&html<Only one ItemSet exists for that CCR, displaying log...>
			}
		} 
		If (ISid'="") {
			&html<<H3>ItemSet Log for ID=#(ISid)#</H3>>
			&html<<PRE>>
			Set sc=##class(%Studio.SourceControl.ItemSet).DisplayLog(ISid)
			&html<</PRE>>
		}
		Quit		
	}
}

ClassMethod SummaryDisplay()
{
	&html<<H2>CCR Configuration Summary</H2>>
	&html<<PRE>>
	Do Summary^%buildccr
	&html<</PRE>>
}

ClassMethod RefreshDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))		//if there was no submit button passed, show the initial form
	If $data(DisplayForm) Set tShowForm=DisplayForm		//if an explicit directive on showing the form was passed, follow that instruction
	&html<<h2>CCR Namespace Refresh</h2><p>>
	If (tShowForm) {
		#; Display input form
		If ('##class(%Studio.SourceControl.ISC).Disconnected()) {
			Set ret=##class(%Studio.SourceControl.ISC).GetCredentials(.user,,.workspace)
		}
		If ('##class(%Studio.SourceControl.ISC).Disconnected()&&(('##class(%Studio.SourceControl.ISC).DefaultCredentialsDefined())&&('$data(%request.Data("p4P"))))) {
			&html<Enter password for Perforce user: <code>'#($get(user))#'</code>
				<form name="P4Pass" method="POST">
					<input name="p4P" type='password' size='8'><p>
					<input type="hidden" name="action" value="Refresh">
					<input type="submit" name="setpass" value="Proceed">
				</form>
			>
		} Else {
			If $data(%request.Data("p4P")) Set %stP=$System.Encryption.Base64Encode(%request.Data("p4P",1))
			&html<
				<p>	This will refresh the contents of the namespace with the exported contents of the local Perforce workspace on disk </p>
				<p> Source is located in #(^Sources)# </p>
				<p> Click below to proceed: </p>
				<form name="P4Submit">
			>
			If $data(%request.Data("p4P")) { &html<<input type="hidden" name="studioP" value="#(%stP)#">> }
			If '##class(%Studio.SourceControl.ISC).Disconnected() { &html<<div>Sync branch from Perforce <input name='sync' id='sync' value='1' type='checkbox' checked></div>> }
			&html<
					<input type="hidden" name="action" value="Refresh">
					<input type="hidden" name="client" value="#($get(workspace))#">
					<input type="hidden" name="user" value="#($get(user))#">
					<input type="submit" name="submit" value="Refresh">
				</form>
			>
		}
	} ElseIf ('tShowForm) {
		#; Process form submission
		Set client=$get(%request.Data("client",1))
		Set user=$get(%request.Data("user",1))
		Set sync=$data(%request.Data("sync",1))
		If $data(%request.Data("studioP")) { Set %stP=%request.Data("studioP",1) }
		&html<
			<H3>Refresh Details:</H3><p>
			<pre>
		>
		Try {
			Set sc=$$$OK
			Set sc=$$RefreshNamespace^%buildccrRefresh(0,sync)
		} Catch err {
			If (err.Name="<NOROUTINE>") {
				Write !,"ERROR: Refresh^%buildccr requires the %buildccrRefresh routine."
				Write !,"       Please install %buildccrRefresh.MAC and try again."
			}
		}
		If $$$ISERR(sc) {
			Write !,"Refresh encountered one or more errors:"
			Write !,..EscapeHTML($system.Status.GetErrorText(sc))
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
		}
		&html<
			</pre>
		>
		Quit		
	}
}

/// runs the DSCheckpointExport() method
ClassMethod DscheckpointDisplay(DisplayForm As %Boolean)
{
	Set tShowForm='$data(%request.Data("submit"))		//if there was no submit button passed, show the initial form
	If $data(DisplayForm) { Set tShowForm=DisplayForm }		//if an explicit directive on showing the form was passed, follow that instruction
	If (tShowForm) {
		#; Display input form
		&html<<h2>DeepSee II Checkpoint Export</h2><p>>
		If (('##class(%Studio.SourceControl.ISC).DefaultCredentialsDefined())&&('..PerforceLoggedIn())&&('$data(%request.Data("p4P")))) {
			&html<Enter password for Perforce user: <code>'#($get(user))#'</code>
				<form name="P4Pass" method="POST">
					<input id="p4P" name="p4P" type='password' size='8'><p>
					<input type="hidden" name="action" value="DSCheckpoint">
					<input type="submit" name="setpass" value="Proceed">
				</form>
				<script language='javascript'>
				document.getElementById("p4P").focus();
				</script>
			>
		} Else {
			If $data(%request.Data("p4P")) {
				Set sc=..PerforceLogin(%request.Data("p4P",1))
				If $$$ISERR(sc) { 
					Do ..ShowError(sc)
					Quit
				}
			}
			&html<
				<H3>DSCheckpoint Preview:</H3><p>
				<pre>
			>
			Do ##class(%Studio.SourceControl.ISC).DSCheckpointExport(1,1,0,0)
			&html<
				</pre>
				<p> Click below to proceed: </p>
				<form name="DSSubmit">
			>
			&html<
					<input type="hidden" name="action" value="DSCheckpoint">
					<input type="submit" name="submit" value="Checkpoint Items">
				</form>
			>
		}
	} ElseIf ('tShowForm) {
		Do ..PerforceLoggedIn() ;refresh the login credentials in the process if applicable
		#; Process form submission
		&html<
			<H3>DSCheckpoint Details:</H3><p>
			<pre>
		>
		Set sc=##class(%Studio.SourceControl.ISC).DSCheckpointExport(0,1,0,0)
		&html<
			</pre>
		>
		If $$$ISOK(sc) {
			Set checkpointStatus="Success!"
		} Else {
			&html<
				<script language='javascript'>
				document.bgColor='#FFB2B2';
				</script>
			>
			Set checkpointStatus=$SYSTEM.Status.GetErrorText(sc)
		}
		&html<
			Status: #(checkpointStatus)#		
		>
		Quit		
	}
}

/// Displays a diff between the file passes in the file url parameter and file_".bak" if it exists
ClassMethod DiffDisplay()
{
	If ..DiffEnabled() {
		&html<<h2>Quick Diff</h2><p>>
		Do ..WriteDiffJS()
		Set abort=0
		If '$data(%request.Data("file",1)) Set abort=1, msg="No item to diff was passed to page"
		Set file=##class(%File).NormalizeFilename($get(%request.Data("file",1)))
		Set filelabel="File"
		If ('abort) {
			Set backupfile=##class(%File).NormalizeFilename(file_".bak")
			Set backuplabel="Original File"
			If '##class(%File).Exists(backupfile) Set abort=1, msg=backupfile_" does not exist"
		}
		If ('abort) {
			For filecheck=$ZCVT(file,"L"),$ZCVT(backupfile,"L") {
				Set fileallowed=0
				If $data(^Sources) {
					If filecheck[$ZCVT(^Sources,"L") Set fileallowed=1
				}
				If $data(^%SYS("TempDir")) {
					If filecheck[$ZCVT(^%SYS("TempDir"),"L") Set fileallowed=1
				}
				If 'fileallowed Set abort=1, msg=filecheck_" is not accessible for a diff" Quit
			}
		}
		If abort {
			Write "Illegal diff request: "_$get(msg)
		} Else {
			Set original=##class(%FileCharacterStream).%New()
			Set original.Filename=backupfile
			Set new=##class(%FileCharacterStream).%New()
			Set new.Filename=file
			&html<
				#(filelabel)#: #(file)#<BR/>
				#(backuplabel)#: #(backupfile)#<BR/>
		
				<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
				var dmp = new diff_match_patch();
				function launch() {
				  var text1 = document.getElementById('text1').value;
				  var text2 = document.getElementById('text2').value;
				  dmp.Diff_Timeout = parseFloat(document.getElementById('timeout').value);
				  dmp.Diff_EditCost = parseFloat(document.getElementById('editcost').value);

				  var ms_start = (new Date()).getTime();
				  var d = dmp.diff_main(text1, text2);
				  var ms_end = (new Date()).getTime();

				  if (document.getElementById('semantic').checked) {
				    dmp.diff_cleanupSemantic(d);
				  }
				  if (document.getElementById('efficiency').checked) {
				    dmp.diff_cleanupEfficiency(d);
				  }
				  var ds = dmp.diff_prettyHtml(d);
				  var ds_noPara=ds.replace(/&para;/g,'');		//remove paragraph symbols from html output
				  var key = 'Key: <INS STYLE="background:#E6FFE6;">added</INS>&nbsp;<DEL STYLE="background:#FFE6E6;">deleted</DEL>';
				  adjustDiffOutputHeight();
				  document.getElementById('outputdiv').innerHTML = key + '&nbsp;(diff time: ' + (ms_end - ms_start) / 1000 + 's)' + '<HR><code id="diff_code" style="white-space: pre-wrap;">' + ds_noPara + '</code>';
				  initDiffTracking();
				}
				function showDiv(Id) {
					var el=document.getElementById(Id);
					if (el.style.display != "none") {
						//items are currently displayed, so hide them
						el.style.display = "none";
					}
					else {
						//items are currently hidden, so display them
						el.style.display = "";
					}
				}
				/// helper function to adjust the height of the diff output so that it fits
				/// inside the current window - the only scrolling should be inside the diff
				function adjustDiffOutputHeight() {
					var outputDiv = document.getElementById('outputdiv');
					var windowHeight = window.innerHeight;
					if (outputDiv && windowHeight) {
						// check if we need to leave room for the "back" link below the output
						var returnLinkHeight = 0;
						var returnLinkPara = document.getElementById('return_link');
						if (returnLinkPara) {
							returnLinkHeight = Math.max(returnLinkPara.offsetHeight,returnLinkPara.clientHeight);
							returnLinkHeight+= 25;
						}
						var outputTop = getElementTop(outputDiv);
						var outputHeight = windowHeight - outputTop - returnLinkHeight - 10;
						outputDiv.style.height = outputHeight + 'px';
					}
				}
				// helper function to get the position of el relative to the top of the window
				function getElementTop(el) {
					var top = 0;
					while (el) {
						top += el.offsetTop;
						el = el.offsetParent;
					}
					return top;
				}
				/// initialize the variables that keep track of where we are in the diff
				/// all of this data is stored in window.diffTracking
				function initDiffTracking() {
					window.diffTracking = {
						elements: buildElementMap(),
						currPos: -1,
						currEl: null,
						outputTop: getElementTop(document.getElementById('outputdiv'))
					};
					var diffNav = document.getElementById('diff_nav');
					if (diffNav) {
						diffNav.style.display = '';
					}
					nextDiff();
				}
				/// Constructor for a helper object to help iterate over the INS and DEL elements
				/// found in the diff output. The main reason for the abstraction is to keep only one version
				/// of the next() function that finds the next element and extracts the numeric value
				/// stored in the title attribute of the underlying diff element. (This looks like the character
				/// position of the diff in the file, but it is sequential even if it is not.)
				function elData(nodeList) {
					this.nodeList = (nodeList ? nodeList : null);
					this.atEnd = !this.nodeList;
					this.pos = -1;
					this.index = -1;
					this.el = null;
					/// Function to shift to the next element and determine what its numeric index is.
					/// The index is needed for sorting and working out when an insertion and deletion occur
					/// at the "same" point in the document.
					this.next = function() {
						if (this.atEnd || (!this.nodeList)) return false;
						var newIndex = -1;
						if (this.pos == this.nodeList.length) {
							this.atEnd = true;
						}
						else {
							this.pos++;
							this.el = this.nodeList.item(this.pos);
							if (this.el) {
								var title = this.el.getAttribute('title');
								if (title.substring(0,2) == 'i=') {
									title = parseInt(title.substring(2),10);
									if (!isNaN(title)) {
										newIndex = title;
									}
								}
							}
							else {
								this.atEnd = true;
							}
						}
						this.index = newIndex;
						return this.atEnd;
					};
				}
				/// Function to identify all the insertions (INS elements) and deletions (DEL elements)
				/// in the diff output, and then build a sequential map of all the diffs.
				/// The sequencing uses the title attribute to sequence the two kinds of elements,
				/// and does a special grouping when a delete and an insert share the same index as we
				/// want to show those as a single diff when possible.
				/// Note that the "map" returned from this function includes references to the actual
				/// DOM elements so that we can rapidly change the element's style and shift focus to it.
				function buildElementMap() {
					var map = [];
					try {
						var codeEl = document.getElementById('diff_code');
						if (codeEl) {
							var insData = new elData(codeEl.getElementsByTagName('ins'));
							var delData = new elData(codeEl.getElementsByTagName('del'));
							insData.next();
							delData.next();
							while (insData.el || delData.el) {
								if (insData.index > -1) {
									if ((insData.index < delData.index) || (delData.index == -1)) {
										map.push(insData.el);
										insData.next();
									}
									else if (delData.index == insData.index) {
										delData.el._pairEl = insData.el;
										map.push(delData.el);
										delData.next();
										insData.next();
									}
									else { // (delData.index < insData.index)
										map.push(delData.el);
										delData.next();
									}
								}
								else if ((delData.index > -1) && ((delData.index < insData.index) || (insData.index == -1))) {
									map.push(delData.el);
									delData.next();
								}
								else {
									alert('Failed to process diff list');
									map = [];
									break;
								}
							}
						}
					} catch (ex) {
						alert('Exception in buildElementMap: ' + (window.JSON ? JSON.stringify(ex) : ex));
					}
					return map;
				}
				/// Function to update the next and previous diff buttons based on the data in window.diffTracking
				function updateDiffButtons() {
					var diffTracking = window.diffTracking;
					if (!diffTracking) return;

					var nextButton = document.getElementById('diff_nav_next');
					if (nextButton) {
						nextButton.disabled = (!diffTracking.elements) || (diffTracking.currPos >= (diffTracking.elements.length - 1)) || (diffTracking.currPos < 0);
					}
					var prevButton = document.getElementById('diff_nav_prev');
					if (prevButton) {
						prevButton.disabled = (!diffTracking.elements) || (diffTracking.currPos <= 0)
					}
					var diffPos = document.getElementById('diff_pos');
					if (diffPos) {
						var posText = 'No diffs';
						if (diffTracking.elements && (diffTracking.elements.length > 0)) {
							posText = '' + (diffTracking.currPos + 1) + ' of ' + diffTracking.elements.length;
						}
						diffPos.innerHTML = posText;
					}
				}
				/// Function to "jump" to the next or previous diff.
				/// In addition to calling updatNodeStyle(), it also shifts the scroll position
				/// of the page to bring the diff into focus.
				function shiftDiff(back) {
					var diffTracking = window.diffTracking;
					if ((!diffTracking) || (!diffTracking.elements)) return;

					var shift = (back ? -1 : 1);
					var newPos = diffTracking.currPos + shift;
					if (newPos < 0) {
						newPos = 0;
					}
					else if (newPos >= diffTracking.elements.length) {
						newPos = diffTracking.elements.length - 1;
					}
					if (diffTracking.currEl) {
						updateNodeStyle(diffTracking.currEl,false);
						if (diffTracking.currEl._pairEl) {
							updateNodeStyle(diffTracking.currEl._pairEl,false);
						}
					}
					diffTracking.currPos = newPos;
					updateDiffButtons();

					var outputDiv = document.getElementById('outputdiv');
					var newEl = diffTracking.elements[newPos];
					diffTracking.currEl = newEl;
					if (newEl) {
						updateNodeStyle(newEl,true);
						if (newEl._pairEl) updateNodeStyle(newEl._pairEl,true);
						if (outputDiv) {
							// leave a 40px buffer so you can see the code before and after the diff
							var newScrollTop = newEl.offsetTop - diffTracking.outputTop - 40;
							outputDiv.scrollTop = (newScrollTop < 0 ? 0 : newScrollTop);
						}
					}
				}
				/// Helper function to update node's style based on whether it should be highlighted
				/// or simply shown as a diff that isn't in focus.
				function updateNodeStyle(node,highlight) {
					if ((!node) || (!node.nodeName)) return;
					var styles = { backgroundColor: '', fontWeight: '' };
					if (highlight) {
						styles.fontWeight = 'bolder';
						switch(node.nodeName) {
							case 'INS':
								styles.backgroundColor = '#99EB99';
								break;
							case 'DEL':
								styles.backgroundColor = '#FF8080';
								break;
						}
					}
					else {
						styles.backgroundColor = node._oldBG;
					}
					node._oldBG = node.style.backgroundColor;
					for (var prop in styles) {
						node.style[prop] = styles[prop];
					}
				}
				function nextDiff() {
					shiftDiff(false);
				}
				function prevDiff() {
					shiftDiff(true);
				}
				</SCRIPT>

				<FORM action="#" onsubmit="return false">
				<TABLE WIDTH="100%">
					<TR id="files" style='display: none' title='display of files to be diffed'>
						<TD WIDTH="50%">
							<H4>#(filelabel)#:</H4>
							#(file)#<BR>
							<TEXTAREA ID="text2" STYLE="width: 100%;word-break:break-all;" ROWS=30>
			>
			While 'new.AtEnd {
				Write ..EscapeHTML(new.ReadLine()),!
			}
			&html<
							</TEXTAREA>
						</TD>
						<TD WIDTH="50%">
							<H4>#(backuplabel)#:</H4>
							#(backupfile)#<BR>
							<TEXTAREA ID="text1" STYLE="width: 100%;word-break:break-all;" ROWS=30>
			>
			While 'original.AtEnd {
				Write ..EscapeHTML(original.ReadLine()),!
			}
			&html<
							</TEXTAREA>
						</TD>
					</TR>
					<TR>
						<TD colspan='2'>
							<A HREF='javascript:showDiv("files");'>show files</A>
						</TD>
					</TR>
					<TR id="controls" style='display: none' title='additional diff controls'>
						<TD colspan='2'>
							<H4>Diff timeout:</H4>
							<P><INPUT TYPE="text" SIZE=3 MAXLENGTH=5 VALUE="0" ID="timeout"> seconds<BR>
							If the mapping phase of the diff computation takes longer than this, then the computation
							is truncated and the best solution to date is returned.  While guaranteed to be correct,
							it may not be optimal.  A timeout of '0' allows for unlimited computation.</P>
							<H4>Post-diff cleanup:</H4>
							<DL>
							<DT><INPUT TYPE="radio" NAME="cleanup" ID="semantic">
							<LABEL FOR="semantic">Semantic Cleanup</LABEL></DT>
							<DD>Increase human readability by factoring out commonalities which are likely to be
							coincidental.</DD>
							<DT><INPUT TYPE="radio" NAME="cleanup" ID="efficiency" CHECKED>
							<LABEL FOR="efficiency">Efficiency Cleanup</LABEL>,
							edit cost: <INPUT TYPE="text" SIZE=3 MAXLENGTH=5 VALUE="4" ID="editcost">
							<DD>Increase computational efficiency by factoring out short commonalities which are
							not worth the overhead.  The larger the edit cost, the more agressive the cleanup.</DD>
							<DT><INPUT TYPE="radio" NAME="cleanup" ID="raw">
							<LABEL FOR="raw">No Cleanup</LABEL></DT>
							<DD>Raw output.</DD>
							</DL>
						</TD>
					</TR>
					<TR>
						<TD colspan='2'>
							<A HREF='javascript:showDiv("controls");'>additional options</A>
						</TD>
					</TR>
				</TABLE>
				<P><INPUT TYPE="button" onClick="launch()" VALUE="Compute Diff">&nbsp;&nbsp;&nbsp;(Please be patient as diffs can be computationally intensive)<span id="diff_nav" style="display: none; padding-left: 20px;"><input type="button" id="diff_nav_prev" onclick="prevDiff();" value="Previous Diff" />&nbsp;&nbsp;<input type="button" id="diff_nav_next" onclick="nextDiff();" value="Next Diff" />&nbsp;&nbsp;<span id="diff_pos">&nbsp;</span></span></P>
				</FORM>
				<DIV ID="outputdiv" style="background-color:white; overflow-y:auto;"></DIV>
			>
		}
		If $data(%request.Data("return",1)) {
			&html<<p id="return_link"><a href='#(..SelfLink())#?action=#($get(%request.Data("return",1)))#'>back</a>>
		}
	} Else {
		&html<Diff function is disabled>	
	}
}

/// Returns boolean value indicated whether or not the diff UI can be displayed
/// <P>Set ^SYS("SourceControl","UIConfig","DisableDiff")=1 to disable diff for a specific namespace
/// <P>Set ^%SYS("SourceControl","UIConfig","DisableDiff")=1 to disable diff for the entire instance
ClassMethod DiffEnabled() As %Boolean [ CodeMode = expression ]
{
'($G(^SYS("SourceControl","UIConfig","DisableDiff"))||$G(^%SYS("SourceControl","UIConfig","DisableDiff")))
}

ClassMethod ConvertStreamToHTML(pStream) As %Stream.GlobalCharacter
{
 	Set newStream=##class(%Stream.GlobalCharacter).%New()
 	If '$isobject(pStream) quit newStream
 	Do pStream.Rewind()
 	While ('pStream.AtEnd) {
 		Set chunk=pStream.Read(500)
 		Set chunk=..EscapeHTML(chunk)
 		//make errors obvious
 		Set chunk=$REPLACE(chunk,"ERROR","<STRONG><font color='red'>ERROR</font></STRONG>")
 	/*	//convert $C(10) to "<BR/>"
 		s chunk=$REPLACE(chunk,$C(10),"<BR/>")
 		//convert " " to "&nbsp;"
 		s chunk=$REPLACE(chunk," ","&nbsp;")*/
 		//write it into the new stream
 		Do newStream.Write(chunk)
 	}
 	Do newStream.Rewind()
 	Quit newStream
}

/// Link to this page
ClassMethod SelfLink() [ CodeMode = expression ]
{
..EscapeURL(..%ClassName(1)_".cls")
}

/// This method displays validation logic for the included diff_match_patch diff JS
/// To use, you must put the following into <Install Directory>/CSP/sys:
/// 	//custom_ccrs/_common/config/internal/testing/manual_tests/UI.diff_match_patch_test.html
/// 	//custom_ccrs/_common/config/internal/testing/manual_tests/diff_match_patch_test.js
/// NOTE: The above files are not to be distributed in product; they are only for manually validating the diff functionality
/// Access this test via http://localhost:<port>/csp/sys/%25Studio.SourceControl.UI.cls?action=validatediff
ClassMethod ValidateDiffDisplay() [ Internal ]
{
	&html<<H2>Quick Diff Validation</H2>
		(If this page is blank, then UI.diff_match_patch_test.html and diff_match_patch_test.js are missing from the CSP application's root directory)
	>
	Do ..WriteDiffJS()
	Do ..Include("UI.diff_match_patch_test.html")
}

/// Pages inheriting from %CSP.Page don't have a %GetParameter() method until 2010.2.  This method allows access to the parameter values in the class from  outside of the class
ClassMethod GetParameter(Parameter) As %String [ CodeMode = objectgenerator ]
{
	Set ver=$$$CacheVersionMajor_"."_$$$CacheVersionMinor
	If (ver<2010.1) {
 		Do %code.WriteLine(" $$$comMemberKeyGetLvar(ParmValue,..%ClassName(1),$$$cCLASSparameter,Parameter,$$$cPARAMdefault)")
 		Do %code.WriteLine(" Quit ParmValue")
	} ElseIf (ver=2010.1) { 
 		Do %code.WriteLine(" Quit $zobjparam(Parameter)")
	} Else {
		Do %code.WriteLine(" Quit $Parameter(,Parameter)")
	}
 	Quit $$$OK
}

/// CSP Applications allowed to access this UI.
/// <p>To add web applications to the return list, set <code>^%SYS("SourceControl","AllowedApps")=$lb(app1,app2,...)</code>.
/// NOTE: app1, app2, etc must have a trailing '/', e.g. <code>^%SYS("SourceControl","AllowedApps")=$lb("/csp/users/")</code>
ClassMethod AllowedApps() As %String [ CodeMode = expression ]
{
$listbuild("/csp/sys/","/isc/studio/templates/")_$select($listvalid($get(^%SYS("SourceControl","AllowedApps"))):$get(^%SYS("SourceControl","AllowedApps")),1:"")
}

/// Accepts the password for the current Perforce user (defined by $USERNAME) and validates password by attempting to log into Perforce and obtain a IP-bound ticket<br/>
/// If login is successful, ticket is stored in the session to be reused on later calls to Perforce<br/>
/// If <var>Password</var> is not defined, then the locally cached ticket will be cleared
ClassMethod PerforceLogin(Password) As %Status
{
	Set sc=$$$OK
	If ('$data(Password)) {
		Kill %session.Data("stP")
		Kill %stP
		Quit sc		
	}
	Set file=##class(%FileCharacterStream).%New()
	Set sc=file.WriteLine(Password)
	Set %stP=$System.Encryption.Base64Encode(Password)
	Kill args Set args($i(args))="login",args($i(args))="-p"
	Set sc=##class(%Studio.SourceControl.ISC).SecureRunCmd("p4",.args,.out,0,,file.Filename)
	/* 
		expected output of 'out' for correct login (sc will be an error for incorrect password or other error):
			out=2
			out(1)="Enter password: "
			out(2)="1F312B20CBC503C72DDA242EB267D2AE"
			
		NOTE - if Perforce ever changes this format the parsing logic below will break (I could not use the p4 -s flag because errors didn't get sent to errout so sc didn't contain any errors
	*/
	If ($$$ISOK(sc))&&($get(out)>1) {
		Set i="", i=$order(out(i),1,line)
		While (i'="")&&(line'["Enter password:"){
			Set i=$order(out(i),1,line)
		}
		Set i=$order(out(i),1,line)
		Set token=line
		Set %session.Data("stP")=$System.Encryption.Base64Encode(token)
		Set %stP=%session.Data("stP")
	} Else {
		Kill %session.Data("stP")
		Kill %stP
	}
	Quit sc
}

/// Returns true if the user has a valid Perforce ticket in the CSP session, otherwise returns false.<br/>
/// This als inializes the process ticket variable, so this must be called whenever a server-side method requiring Perforce access is invoked
ClassMethod PerforceLoggedIn() As %Boolean
{
	Set %stP=$get(%session.Data("stP"))
	Quit ($length($get(%stP))>0)
}

/// Ensure that this page is only accessible through approved CSP Applications
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	Set action=$ZCVT($get(%request.Data("action",1)),"L")
	If (action="logout") { // User logging out
		Set %session.EndSession = 1
		Set %response.Redirect = ..SelfLink()
		Quit $$$OK
	}
	Set ret=0
	If $LF(..AllowedApps(),%request.Application) {
		//Allow access if the request is coming through one of the allowed CSP applications
		Set ret=1
	} ElseIf ((action="diff")&&(..DiffEnabled())) {
		//Allow access if the request is for the the 'diff' functionality, diff is enabled for this namespace
		Set ret=1
	} Else {
		Set %response.Redirect="/csp/sys/"_..EscapeURL(%request.PageName)
		Set ret=0
	}
	Set %response.Timeout = 300 // increase cspgateway timeout for long ItemSet loads 
	Quit ret
}

/// Handles all compile-time logic for this class
ClassMethod OnToolsCompile() [ CodeMode = objectgenerator, Internal ]
{
 	For i = 1:1:%class.Parameters.Count() {
        If %class.Parameters.GetAt(i).Name = "SrcVer" Set valSrcVer = %class.Parameters.GetAt(i).Default
        If %class.Parameters.GetAt(i).Name = "Version" Set indexVersion=i
    }
    If $D(indexVersion)&&($G(valSrcVer)["//custom_ccrs/_common/config/") {
	    Set %class.Parameters.GetAt(indexVersion).Default = $P($G(valSrcVer),"#",2)+1
	    Do %class.Parameters.GetAt(indexVersion).%Save()
    }
    Quit $$$OK
}

/// Returns value the Major.Minor version for this instance, so it can be used in comparison code which makes sure certain features are used in appropriate versions
ClassMethod InstanceVersion() As %Numeric [ CodeMode = expression ]
{
$P($SYSTEM.Version.GetNumber(),".",1,2)
}

/// //////////////////////////////////////////////////////////////////////////////////////////////////////////
/// diff-match-patch 
/// -------------------------------------------
/// Obtained from: http://code.google.com/p/google-diff-match-patch/
/// Used under Apache License 2.0
/// -------------------------------------------
/// JS function used originally contained in diff_match_patch_20100825.zip\diff_match_patch_20100825\javascript\diff_match_patch.js 
/// //////////////////////////////////////////////////////////////////////////////////////////////////////////
ClassMethod WriteDiffJS() [ Internal ]
{
	Write "<script language='javascript'>",!
	Write "(function(){var a;function diff_match_patch(){function b(){for(var c=0,e=1,d=2;e!=d;){c++;e=d;d<<=1}return c}this.Diff_Timeout=1;this.Diff_EditCost=4;this.Diff_DualThreshold=32;this.Match_Threshold=0.5;this.Match_Distance=1E3;this.Patch_DeleteThreshold=0.5;this.Patch_Margin=4;this.Match_MaxBits=b()}a=diff_match_patch.prototype;",!
	Write "a.diff_main=function(b,c,e){if(b==null||c==null)throw Error(""Null input. (diff_main)"");if(b==c)return[[0,b]];if(typeof e==""undefined"")e=true;var d=e,f=this.diff_commonPrefix(b,c);e=b.substring(0,f);b=b.substring(f);c=c.substring(f);f=this.diff_commonSuffix(b,c);var h=b.substring(b.length-f);b=b.substring(0,b.length-f);c=c.substring(0,c.length-f);b=this.diff_compute(b,c,d);e&&b.unshift([0,e]);h&&b.push([0,h]);this.diff_cleanupMerge(b);return b};",!
	Write "a.diff_compute=function(b,c,e){var d;if(!b)return[[1,c]];if(!c)return[[-1,b]];d=b.length>c.length?b:c;var f=b.length>c.length?c:b,h=d.indexOf(f);if(h!=-1){d=[[1,d.substring(0,h)],[0,f],[1,d.substring(h+f.length)]];if(b.length>c.length)d[0][0]=d[2][0]=-1;return d}if(d=this.diff_halfMatch(b,c)){var g=d[0];b=d[1];f=d[2];c=d[3];d=d[4];g=this.diff_main(g,f,e);e=this.diff_main(b,c,e);return g.concat([[0,d]],e)}if(e&&(b.length<100||c.length<100))e=false;if(e){g=this.diff_linesToChars(b,c);b=g[0];c=g[1];",!
	Write "g=g[2]}(d=this.diff_map(b,c))||(d=[[-1,b],[1,c]]);if(e){this.diff_charsToLines(d,g);this.diff_cleanupSemantic(d);d.push([0,""""]);c=b=e=0;for(f=g="""";e<d.length;){switch(d[e][0]){case 1:c++;f+=d[e][1];break;case -1:b++;g+=d[e][1];break;case 0:if(b>=1&&c>=1){g=this.diff_main(g,f,false);d.splice(e-b-c,b+c);e=e-b-c;for(b=g.length-1;b>=0;b--)d.splice(e,0,g[b]);e+=g.length}b=c=0;f=g="""";break}e++}d.pop()}return d};",!
	Write "a.diff_linesToChars=function(b,c){function e(i){for(var k="""",j=0,l=-1,m=d.length;l<i.length-1;){l=i.indexOf(""\n"",j);if(l==-1)l=i.length-1;var n=i.substring(j,l+1);j=l+1;if(f.hasOwnProperty?f.hasOwnProperty(n):f[n]!==undefined)k+=String.fromCharCode(f[n]);else{k+=String.fromCharCode(m);f[n]=m;d[m++]=n}}return k}var d=[],f={};d[0]="""";var h=e(b),g=e(c);return[h,g,d]};",!
	Write "a.diff_charsToLines=function(b,c){for(var e=0;e<b.length;e++){for(var d=b[e][1],f=[],h=0;h<d.length;h++)f[h]=c[d.charCodeAt(h)];b[e][1]=f.join("""")}};",!
	Write "a.diff_map=function(b,c){var e=(new Date).getTime()+this.Diff_Timeout*1E3,d=b.length,f=c.length,h=d+f-1,g=this.Diff_DualThreshold*2<h,i=[],k=[],j={},l={};j[1]=0;l[1]=0;for(var m,n,o,p={},t=false,s=(d+f)%2,r=0;r<h;r++){if(this.Diff_Timeout>0&&(new Date).getTime()>e)return null;i[r]={};for(var q=-r;q<=r;q+=2){m=q==-r||q!=r&&j[q-1]<j[q+1]?j[q+1]:j[q-1]+1;n=m-q;if(g){o=m+"",""+n;if(s&&p[o]!==undefined)t=true;s||(p[o]=r)}for(;!t&&m<d&&n<f&&b.charAt(m)==c.charAt(n);){m++;n++;if(g){o=m+"",""+n;if(s&&p[o]!==",!
	Write "undefined)t=true;s||(p[o]=r)}}j[q]=m;i[r][m+"",""+n]=true;if(m==d&&n==f)return this.diff_path1(i,b,c);else if(t){k=k.slice(0,p[o]+1);e=this.diff_path1(i,b.substring(0,m),c.substring(0,n));return e.concat(this.diff_path2(k,b.substring(m),c.substring(n)))}}if(g){k[r]={};for(q=-r;q<=r;q+=2){m=q==-r||q!=r&&l[q-1]<l[q+1]?l[q+1]:l[q-1]+1;n=m-q;o=d-m+"",""+(f-n);if(!s&&p[o]!==undefined)t=true;if(s)p[o]=r;for(;!t&&m<d&&n<f&&b.charAt(d-m-1)==c.charAt(f-n-1);){m++;n++;o=d-m+"",""+(f-n);if(!s&&p[o]!==undefined)t=",!
	Write "true;if(s)p[o]=r}l[q]=m;k[r][m+"",""+n]=true;if(t){i=i.slice(0,p[o]+1);e=this.diff_path1(i,b.substring(0,d-m),c.substring(0,f-n));return e.concat(this.diff_path2(k,b.substring(d-m),c.substring(f-n)))}}}}return null};",!
	Write "a.diff_path1=function(b,c,e){for(var d=[],f=c.length,h=e.length,g=null,i=b.length-2;i>=0;i--)for(;;)if(b[i][f-1+"",""+h]!==undefined){f--;if(g===-1)d[0][1]=c.charAt(f)+d[0][1];else d.unshift([-1,c.charAt(f)]);g=-1;break}else if(b[i][f+"",""+(h-1)]!==undefined){h--;if(g===1)d[0][1]=e.charAt(h)+d[0][1];else d.unshift([1,e.charAt(h)]);g=1;break}else{f--;h--;if(c.charAt(f)!=e.charAt(h))throw Error(""No diagonal.  Can't happen. (diff_path1)"");if(g===0)d[0][1]=c.charAt(f)+d[0][1];else d.unshift([0,c.charAt(f)]);",!
	Write "g=0}return d};",!
	Write "a.diff_path2=function(b,c,e){for(var d=[],f=0,h=c.length,g=e.length,i=null,k=b.length-2;k>=0;k--)for(;;)if(b[k][h-1+"",""+g]!==undefined){h--;if(i===-1)d[f-1][1]+=c.charAt(c.length-h-1);else d[f++]=[-1,c.charAt(c.length-h-1)];i=-1;break}else if(b[k][h+"",""+(g-1)]!==undefined){g--;if(i===1)d[f-1][1]+=e.charAt(e.length-g-1);else d[f++]=[1,e.charAt(e.length-g-1)];i=1;break}else{h--;g--;if(c.charAt(c.length-h-1)!=e.charAt(e.length-g-1))throw Error(""No diagonal.  Can't happen. (diff_path2)"");if(i===0)d[f-",!
	Write "1][1]+=c.charAt(c.length-h-1);else d[f++]=[0,c.charAt(c.length-h-1)];i=0}return d};a.diff_commonPrefix=function(b,c){if(!b||!c||b.charAt(0)!=c.charAt(0))return 0;for(var e=0,d=Math.min(b.length,c.length),f=d,h=0;e<f;){if(b.substring(h,f)==c.substring(h,f))h=e=f;else d=f;f=Math.floor((d-e)/2+e)}return f};",!
	Write "a.diff_commonSuffix=function(b,c){if(!b||!c||b.charAt(b.length-1)!=c.charAt(c.length-1))return 0;for(var e=0,d=Math.min(b.length,c.length),f=d,h=0;e<f;){if(b.substring(b.length-f,b.length-h)==c.substring(c.length-f,c.length-h))h=e=f;else d=f;f=Math.floor((d-e)/2+e)}return f};",!
	Write "a.diff_halfMatch=function(b,c){function e(j,l,m){for(var n=j.substring(m,m+Math.floor(j.length/4)),o=-1,p="""",t,s,r,q;(o=l.indexOf(n,o+1))!=-1;){var u=h.diff_commonPrefix(j.substring(m),l.substring(o)),v=h.diff_commonSuffix(j.substring(0,m),l.substring(0,o));if(p.length<v+u){p=l.substring(o-v,o)+l.substring(o,o+u);t=j.substring(0,m-v);s=j.substring(m+u);r=l.substring(0,o-v);q=l.substring(o+u)}}return p.length>=j.length/2?[t,s,r,q,p]:null}var d=b.length>c.length?b:c,f=b.length>c.length?c:b;if(d.length<",!
	Write "10||f.length<1)return null;var h=this,g=e(d,f,Math.ceil(d.length/4));d=e(d,f,Math.ceil(d.length/2));var i;if(!g&&!d)return null;else i=d?g?g[4].length>d[4].length?g:d:d:g;var k;if(b.length>c.length){g=i[0];d=i[1];f=i[2];k=i[3]}else{f=i[0];k=i[1];g=i[2];d=i[3]}i=i[4];return[g,d,f,k,i]};",!
	Write "a.diff_cleanupSemantic=function(b){for(var c=false,e=[],d=0,f=null,h=0,g=0,i=0;h<b.length;){if(b[h][0]==0){e[d++]=h;g=i;i=0;f=b[h][1]}else{i+=b[h][1].length;if(f!==null&&f.length<=g&&f.length<=i){b.splice(e[d-1],0,[-1,f]);b[e[d-1]+1][0]=1;d--;d--;h=d>0?e[d-1]:-1;i=g=0;f=null;c=true}}h++}c&&this.diff_cleanupMerge(b);this.diff_cleanupSemanticLossless(b)};",!
	Write "a.diff_cleanupSemanticLossless=function(b){function c(s,r){if(!s||!r)return 5;var q=0;if(s.charAt(s.length-1).match(e)||r.charAt(0).match(e)){q++;if(s.charAt(s.length-1).match(d)||r.charAt(0).match(d)){q++;if(s.charAt(s.length-1).match(f)||r.charAt(0).match(f)){q++;if(s.match(h)||r.match(g))q++}}}return q}for(var e=/[^a-zA-Z0-9]/,d=/\s/,f=/[\r\n]/,h=/\n\r?\n$/,g=/^\r?\n\r?\n/,i=1;i<b.length-1;){if(b[i-1][0]==0&&b[i+1][0]==0){var k=b[i-1][1],j=b[i][1],l=b[i+1][1],m=this.diff_commonSuffix(k,j);if(m){var n=",!
	Write "j.substring(j.length-m);k=k.substring(0,k.length-m);j=n+j.substring(0,j.length-m);l=n+l}m=k;n=j;for(var o=l,p=c(k,j)+c(j,l);j.charAt(0)===l.charAt(0);){k+=j.charAt(0);j=j.substring(1)+l.charAt(0);l=l.substring(1);var t=c(k,j)+c(j,l);if(t>=p){p=t;m=k;n=j;o=l}}if(b[i-1][1]!=m){if(m)b[i-1][1]=m;else{b.splice(i-1,1);i--}b[i][1]=n;if(o)b[i+1][1]=o;else{b.splice(i+1,1);i--}}}i++}};",!
	Write "a.diff_cleanupEfficiency=function(b){for(var c=false,e=[],d=0,f="""",h=0,g=false,i=false,k=false,j=false;h<b.length;){if(b[h][0]==0){if(b[h][1].length<this.Diff_EditCost&&(k||j)){e[d++]=h;g=k;i=j;f=b[h][1]}else{d=0;f=""""}k=j=false}else{if(b[h][0]==-1)j=true;else k=true;if(f&&(g&&i&&k&&j||f.length<this.Diff_EditCost/2&&g+i+k+j==3)){b.splice(e[d-1],0,[-1,f]);b[e[d-1]+1][0]=1;d--;f="""";if(g&&i){k=j=true;d=0}else{d--;h=d>0?e[d-1]:-1;k=j=false}c=true}}h++}c&&this.diff_cleanupMerge(b)};",!
	Write "a.diff_cleanupMerge=function(b){b.push([0,""""]);for(var c=0,e=0,d=0,f="""",h="""",g;c<b.length;)switch(b[c][0]){case 1:d++;h+=b[c][1];c++;break;case -1:e++;f+=b[c][1];c++;break;case 0:if(e!==0||d!==0){if(e!==0&&d!==0){g=this.diff_commonPrefix(h,f);if(g!==0){if(c-e-d>0&&b[c-e-d-1][0]==0)b[c-e-d-1][1]+=h.substring(0,g);else{b.splice(0,0,[0,h.substring(0,g)]);c++}h=h.substring(g);f=f.substring(g)}g=this.diff_commonSuffix(h,f);if(g!==0){b[c][1]=h.substring(h.length-g)+b[c][1];h=h.substring(0,h.length-g);f=",!
	Write "f.substring(0,f.length-g)}}if(e===0)b.splice(c-e-d,e+d,[1,h]);else d===0?b.splice(c-e-d,e+d,[-1,f]):b.splice(c-e-d,e+d,[-1,f],[1,h]);c=c-e-d+(e?1:0)+(d?1:0)+1}else if(c!==0&&b[c-1][0]==0){b[c-1][1]+=b[c][1];b.splice(c,1)}else c++;e=d=0;h=f="""";break}b[b.length-1][1]===""""&&b.pop();e=false;for(c=1;c<b.length-1;){if(b[c-1][0]==0&&b[c+1][0]==0)if(b[c][1].substring(b[c][1].length-b[c-1][1].length)==b[c-1][1]){b[c][1]=b[c-1][1]+b[c][1].substring(0,b[c][1].length-b[c-1][1].length);b[c+1][1]=b[c-1][1]+b[c+",!
	Write "1][1];b.splice(c-1,1);e=true}else if(b[c][1].substring(0,b[c+1][1].length)==b[c+1][1]){b[c-1][1]+=b[c+1][1];b[c][1]=b[c][1].substring(b[c+1][1].length)+b[c+1][1];b.splice(c+1,1);e=true}c++}e&&this.diff_cleanupMerge(b)};a.diff_xIndex=function(b,c){var e=0,d=0,f=0,h=0,g;for(g=0;g<b.length;g++){if(b[g][0]!==1)e+=b[g][1].length;if(b[g][0]!==-1)d+=b[g][1].length;if(e>c)break;f=e;h=d}if(b.length!=g&&b[g][0]===-1)return h;return h+(c-f)};",!
	Write "a.diff_prettyHtml=function(b){for(var c=[],e=0,d=0;d<b.length;d++){var f=b[d][0],h=b[d][1],g=h.replace(/&/g,""&amp;"").replace(/</g,""&lt;"").replace(/>/g,""&gt;"").replace(/\n/g,""&para;<BR>"");switch(f){case 1:c[d]='<INS STYLE=""background:#E6FFE6;"" TITLE=""i='+e+'"">'+g+""</INS>"";break;case -1:c[d]='<DEL STYLE=""background:#FFE6E6;"" TITLE=""i='+e+'"">'+g+""</DEL>"";break;case 0:c[d]='<SPAN TITLE=""i='+e+'"">'+g+""</SPAN>"";break}if(f!==-1)e+=h.length}return c.join("""")};",!
	Write "a.diff_text1=function(b){for(var c=[],e=0;e<b.length;e++)if(b[e][0]!==1)c[e]=b[e][1];return c.join("""")};a.diff_text2=function(b){for(var c=[],e=0;e<b.length;e++)if(b[e][0]!==-1)c[e]=b[e][1];return c.join("""")};a.diff_levenshtein=function(b){for(var c=0,e=0,d=0,f=0;f<b.length;f++){var h=b[f][0],g=b[f][1];switch(h){case 1:e+=g.length;break;case -1:d+=g.length;break;case 0:c+=Math.max(e,d);d=e=0;break}}c+=Math.max(e,d);return c};",!
	Write "a.diff_toDelta=function(b){for(var c=[],e=0;e<b.length;e++)switch(b[e][0]){case 1:c[e]=""+""+encodeURI(b[e][1]);break;case -1:c[e]=""-""+b[e][1].length;break;case 0:c[e]=""=""+b[e][1].length;break}return c.join(""\t"").replace(/\x00/g,""%00"").replace(/%20/g,"" "")};",!
	Write "a.diff_fromDelta=function(b,c){var e=[],d=0,f=0;c=c.replace(/%00/g,""\u0000"");for(var h=c.split(/\t/g),g=0;g<h.length;g++){var i=h[g].substring(1);switch(h[g].charAt(0)){case ""+"":try{e[d++]=[1,decodeURI(i)]}catch(k){throw Error(""Illegal escape in diff_fromDelta: ""+i);}break;case ""-"":case ""="":var j=parseInt(i,10);if(isNaN(j)||j<0)throw Error(""Invalid number in diff_fromDelta: ""+i);i=b.substring(f,f+=j);if(h[g].charAt(0)==""="")e[d++]=[0,i];else e[d++]=[-1,i];break;default:if(h[g])throw Error(""Invalid diff operation in diff_fromDelta: ""+",!
	Write "h[g]);}}if(f!=b.length)throw Error(""Delta length (""+f+"") does not equal source text length (""+b.length+"")."");return e};a.match_main=function(b,c,e){if(b==null||c==null||e==null)throw Error(""Null input. (match_main)"");e=Math.max(0,Math.min(e,b.length));return b==c?0:b.length?b.substring(e,e+c.length)==c?e:this.match_bitap(b,c,e):-1};",!
	Write "a.match_bitap=function(b,c,e){function d(s,r){var q=s/c.length,u=Math.abs(e-r);if(!h.Match_Distance)return u?1:q;return q+u/h.Match_Distance}if(c.length>this.Match_MaxBits)throw Error(""Pattern too long for this browser."");var f=this.match_alphabet(c),h=this,g=this.Match_Threshold,i=b.indexOf(c,e);if(i!=-1){g=Math.min(d(0,i),g);i=b.lastIndexOf(c,e+c.length);if(i!=-1)g=Math.min(d(0,i),g)}var k=1<<c.length-1;i=-1;for(var j,l,m=c.length+b.length,n,o=0;o<c.length;o++){j=0;for(l=m;j<l;){if(d(o,e+l)<=g)j=",!
	Write "l;else m=l;l=Math.floor((m-j)/2+j)}m=l;j=Math.max(1,e-l+1);var p=Math.min(e+l,b.length)+c.length;l=Array(p+2);l[p+1]=(1<<o)-1;for(p=p;p>=j;p--){var t=f[b.charAt(p-1)];l[p]=o===0?(l[p+1]<<1|1)&t:(l[p+1]<<1|1)&t|(n[p+1]|n[p])<<1|1|n[p+1];if(l[p]&k){t=d(o,p-1);if(t<=g){g=t;i=p-1;if(i>e)j=Math.max(1,2*e-i);else break}}}if(d(o+1,e)>g)break;n=l}return i};a.match_alphabet=function(b){for(var c={},e=0;e<b.length;e++)c[b.charAt(e)]=0;for(e=0;e<b.length;e++)c[b.charAt(e)]|=1<<b.length-e-1;return c};",!
	Write "a.patch_addContext=function(b,c){if(c.length!=0){for(var e=c.substring(b.start2,b.start2+b.length1),d=0;c.indexOf(e)!=c.lastIndexOf(e)&&e.length<this.Match_MaxBits-this.Patch_Margin-this.Patch_Margin;){d+=this.Patch_Margin;e=c.substring(b.start2-d,b.start2+b.length1+d)}d+=this.Patch_Margin;(e=c.substring(b.start2-d,b.start2))&&b.diffs.unshift([0,e]);(d=c.substring(b.start2+b.length1,b.start2+b.length1+d))&&b.diffs.push([0,d]);b.start1-=e.length;b.start2-=e.length;b.length1+=e.length+d.length;b.length2+=",!
	Write "e.length+d.length}};",!
	Write "a.patch_make=function(b,c,e){var d;if(typeof b==""string""&&typeof c==""string""&&typeof e==""undefined""){d=b;c=this.diff_main(d,c,true);if(c.length>2){this.diff_cleanupSemantic(c);this.diff_cleanupEfficiency(c)}}else if(b&&typeof b==""object""&&typeof c==""undefined""&&typeof e==""undefined""){c=b;d=this.diff_text1(c)}else if(typeof b==""string""&&c&&typeof c==""object""&&typeof e==""undefined""){d=b;c=c}else if(typeof b==""string""&&typeof c==""string""&&e&&typeof e==""object""){d=b;c=e}else throw Error(""Unknown call format to patch_make."");if(c.length===",!
	Write "0)return[];e=[];b=new patch_obj;var f=0,h=0,g=0,i=d;d=d;for(var k=0;k<c.length;k++){var j=c[k][0],l=c[k][1];if(!f&&j!==0){b.start1=h;b.start2=g}switch(j){case 1:b.diffs[f++]=c[k];b.length2+=l.length;d=d.substring(0,g)+l+d.substring(g);break;case -1:b.length1+=l.length;b.diffs[f++]=c[k];d=d.substring(0,g)+d.substring(g+l.length);break;case 0:if(l.length<=2*this.Patch_Margin&&f&&c.length!=k+1){b.diffs[f++]=c[k];b.length1+=l.length;b.length2+=l.length}else if(l.length>=2*this.Patch_Margin)if(f){this.patch_addContext(b,",!
	Write "i);e.push(b);b=new patch_obj;f=0;i=d;h=g}break}if(j!==1)h+=l.length;if(j!==-1)g+=l.length}if(f){this.patch_addContext(b,i);e.push(b)}return e};a.patch_deepCopy=function(b){for(var c=[],e=0;e<b.length;e++){var d=b[e],f=new patch_obj;f.diffs=[];for(var h=0;h<d.diffs.length;h++)f.diffs[h]=d.diffs[h].slice();f.start1=d.start1;f.start2=d.start2;f.length1=d.length1;f.length2=d.length2;c[e]=f}return c};",!
	Write "a.patch_apply=function(b,c){if(b.length==0)return[c,[]];b=this.patch_deepCopy(b);var e=this.patch_addPadding(b);c=e+c+e;this.patch_splitMax(b);for(var d=0,f=[],h=0;h<b.length;h++){var g=b[h].start2+d,i=this.diff_text1(b[h].diffs),k,j=-1;if(i.length>this.Match_MaxBits){k=this.match_main(c,i.substring(0,this.Match_MaxBits),g);if(k!=-1){j=this.match_main(c,i.substring(i.length-this.Match_MaxBits),g+i.length-this.Match_MaxBits);if(j==-1||k>=j)k=-1}}else k=this.match_main(c,i,g);if(k==-1){f[h]=false;d-=",!
	Write "b[h].length2-b[h].length1}else{f[h]=true;d=k-g;g=j==-1?c.substring(k,k+i.length):c.substring(k,j+this.Match_MaxBits);if(i==g)c=c.substring(0,k)+this.diff_text2(b[h].diffs)+c.substring(k+i.length);else{g=this.diff_main(i,g,false);if(i.length>this.Match_MaxBits&&this.diff_levenshtein(g)/i.length>this.Patch_DeleteThreshold)f[h]=false;else{this.diff_cleanupSemanticLossless(g);i=0;var l;for(j=0;j<b[h].diffs.length;j++){var m=b[h].diffs[j];if(m[0]!==0)l=this.diff_xIndex(g,i);if(m[0]===1)c=c.substring(0,",!
	Write "k+l)+m[1]+c.substring(k+l);else if(m[0]===-1)c=c.substring(0,k+l)+c.substring(k+this.diff_xIndex(g,i+m[1].length));if(m[0]!==-1)i+=m[1].length}}}}}c=c.substring(e.length,c.length-e.length);return[c,f]};",!
	Write "a.patch_addPadding=function(b){for(var c=this.Patch_Margin,e="""",d=1;d<=c;d++)e+=String.fromCharCode(d);for(d=0;d<b.length;d++){b[d].start1+=c;b[d].start2+=c}d=b[0];var f=d.diffs;if(f.length==0||f[0][0]!=0){f.unshift([0,e]);d.start1-=c;d.start2-=c;d.length1+=c;d.length2+=c}else if(c>f[0][1].length){var h=c-f[0][1].length;f[0][1]=e.substring(f[0][1].length)+f[0][1];d.start1-=h;d.start2-=h;d.length1+=h;d.length2+=h}d=b[b.length-1];f=d.diffs;if(f.length==0||f[f.length-1][0]!=0){f.push([0,e]);d.length1+=",!
	Write "c;d.length2+=c}else if(c>f[f.length-1][1].length){h=c-f[f.length-1][1].length;f[f.length-1][1]+=e.substring(0,h);d.length1+=h;d.length2+=h}return e};",!
	Write "a.patch_splitMax=function(b){for(var c=0;c<b.length;c++)if(b[c].length1>this.Match_MaxBits){var e=b[c];b.splice(c--,1);for(var d=this.Match_MaxBits,f=e.start1,h=e.start2,g="""";e.diffs.length!==0;){var i=new patch_obj,k=true;i.start1=f-g.length;i.start2=h-g.length;if(g!==""""){i.length1=i.length2=g.length;i.diffs.push([0,g])}for(;e.diffs.length!==0&&i.length1<d-this.Patch_Margin;){g=e.diffs[0][0];var j=e.diffs[0][1];if(g===1){i.length2+=j.length;h+=j.length;i.diffs.push(e.diffs.shift());k=false}else if(g===",!
	Write "-1&&i.diffs.length==1&&i.diffs[0][0]==0&&j.length>2*d){i.length1+=j.length;f+=j.length;k=false;i.diffs.push([g,j]);e.diffs.shift()}else{j=j.substring(0,d-i.length1-this.Patch_Margin);i.length1+=j.length;f+=j.length;if(g===0){i.length2+=j.length;h+=j.length}else k=false;i.diffs.push([g,j]);if(j==e.diffs[0][1])e.diffs.shift();else e.diffs[0][1]=e.diffs[0][1].substring(j.length)}}g=this.diff_text2(i.diffs);g=g.substring(g.length-this.Patch_Margin);j=this.diff_text1(e.diffs).substring(0,this.Patch_Margin);",!
	Write "if(j!==""""){i.length1+=j.length;i.length2+=j.length;if(i.diffs.length!==0&&i.diffs[i.diffs.length-1][0]===0)i.diffs[i.diffs.length-1][1]+=j;else i.diffs.push([0,j])}k||b.splice(++c,0,i)}}};a.patch_toText=function(b){for(var c=[],e=0;e<b.length;e++)c[e]=b[e];return c.join("""")};",!
	Write "a.patch_fromText=function(b){var c=[];if(!b)return c;b=b.replace(/%00/g,""\u0000"");b=b.split(""\n"");for(var e=0;e<b.length;){var d=b[e].match(/^@@ -(\d+),?(\d*) \+(\d+),?(\d*) @@$/);if(!d)throw Error(""Invalid patch string: ""+b[e]);var f=new patch_obj;c.push(f);f.start1=parseInt(d[1],10);if(d[2]===""""){f.start1--;f.length1=1}else if(d[2]==""0"")f.length1=0;else{f.start1--;f.length1=parseInt(d[2],10)}f.start2=parseInt(d[3],10);if(d[4]===""""){f.start2--;f.length2=1}else if(d[4]==""0"")f.length2=0;else{f.start2--;",!
	Write "f.length2=parseInt(d[4],10)}for(e++;e<b.length;){d=b[e].charAt(0);try{var h=decodeURI(b[e].substring(1))}catch(g){throw Error(""Illegal escape in patch_fromText: ""+h);}if(d==""-"")f.diffs.push([-1,h]);else if(d==""+"")f.diffs.push([1,h]);else if(d=="" "")f.diffs.push([0,h]);else if(d==""@"")break;else if(d!=="""")throw Error('Invalid patch mode ""'+d+'"" in: '+h);e++}}return c};function patch_obj(){this.diffs=[];this.start2=this.start1=null;this.length2=this.length1=0}",!
	Write "patch_obj.prototype.toString=function(){var b,c;b=this.length1===0?this.start1+"",0"":this.length1==1?this.start1+1:this.start1+1+"",""+this.length1;c=this.length2===0?this.start2+"",0"":this.length2==1?this.start2+1:this.start2+1+"",""+this.length2;b=[""@@ -""+b+"" +""+c+"" @@\n""];var e;for(c=0;c<this.diffs.length;c++){switch(this.diffs[c][0]){case 1:e=""+"";break;case -1:e=""-"";break;case 0:e="" "";break}b[c+1]=e+encodeURI(this.diffs[c][1])+""\n""}return b.join("""").replace(/\x00/g,""%00"").replace(/%20/g,"" "")};",!
	Write "window.diff_match_patch=diff_match_patch;window.patch_obj=patch_obj;window.DIFF_DELETE=-1;window.DIFF_INSERT=1;window.DIFF_EQUAL=0;})()",!
	Write "</script>",!
}

}
