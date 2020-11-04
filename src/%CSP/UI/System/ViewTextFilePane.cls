/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>This pane displays text file content.
Class %CSP.UI.System.ViewTextFilePane Extends %CSP.Util.Pane [ System = 4 ]
{

/// Display content of the file
Method DrawBODY(pInstance As PageInstance) As %Status
{

	&html<<DIV class="Text1">#(##class(%CSP.Page).EscapeHTML(..LocalizeText(..Text)))#</DIV>>
	Merge tID = pInstance.IDValues
	Do ..DrawCommandForm(pInstance)
	Set mgrdir = $zu(12)
	Set delim = $E(mgrdir,$L(mgrdir))
	Set type = $G(%request.Data("$TYPE",1))
	If type = "",%request.PageName["Routine" Set type="rtn"
	Set Wild="*.log"

	Set filename = $G(tID(1))
	If filename = "" Set filename = $G(%request.Data("RemoteFileName",1))
	If filename = "cconsole.log"!(%request.PageName [ "ConsoleLog") {
		Set alertslog = mgrdir_"alerts.log"
		Set filename = ##Class(Config.config).GetConsoleFileName(.Status)
	} Else {
		If filename="integ.txt" Set filename = mgrdir_"integ.txt",Wild="*.txt"
	}
	Set BrowserPage = ##class(%CSP.Page).Link("/csp/sys/UtilFileSelect.csp")
	Set ViewPage = ##class(%CSP.Page).Link("/csp/sys/exp/UtilSysViewLog.csp")
	Set refreshpage = $G(%request.Data("refreshpage",1),$G(%request.CgiEnvs("HTTP_REFERER")))
	Set refreshpage = ##class(%CSP.Portal.Utils).GetValidatedLink(refreshpage)
	// Show Last Log requires to build up the filename
	If type = "BackupLog" {
		Set filename = $zu(12)_"Backup"_delim_$G(tID(1))_"_"_$G(tID(2))_".log"
	} ElseIf type = "rtn" {
		Set namespace = $G(%request.Data("$NAMESPACE",1),$zu(5))
		Set filename = $G(tID(2))
	}
	Set lblFileName = $$$TextHTML("File name")
	Set lblSearch1 = $$$TextHTML("Search and highlight a string")
	Set lblBrowse = $$$TextHTML("Browse...")
	Set lblView = $$$TextHTML("View File")
	Set lblSearch2 = $$$TextHTML("Search")
	Set lblRefresh = $$$TextHTML("Clear Highlight")
	Set lblGoBottom = $$$TextHTML("[Goto Bottom]")
	Set lblGoTop = $$$TextHTML("[Goto Top]")
	Set lblFileNot = $$$TextHTML("File does not exist.")
	Set lblPleaseSelect = $$$TextHTML("Please enter or select a filename to view.")
	Set lblCancel = $$$TextHTML("Cancel")
 	&html<<form name="textForm" action="#(ViewPage)#" method="post">>
	&html<<input type="hidden" name="refreshpage" id="refreshpage" value='#($zconvert(refreshpage,"O","HTML"))#'>>

 	If $G(tID(1)) '= "cconsole.log" {
	 	If type'="rtn" {
		 	&html<<h2>#(lblFileName)#: <input name="RemoteFileName" id="RemoteFileName" size="50" value="#(filename)#">
			<input type="button" name="RemoteBrowse" value="#(lblBrowse)#" onclick="launchPopupWindow('#(BrowserPage)#&Wizard=Open&Wild=#(Wild)#');">
			<input type="submit" value="#(lblView)#"></h2>>
	 	} Else {
		 	&html<<h2>#(lblFileName)#: <a name="top"><input type="hidden" name="RemoteFileName" id="RemoteFileName" value="#(filename)#">#($ZCVT(filename,"O","HTML"))#</a>>
	 	}
 	} Else {
	 	&html<<h2>#(lblFileName)#: #($ZCVT(filename,"O","HTML"))#</h2>>	
 	}
 	&html<<h2>
 	#(lblSearch1)#: <input type="text" size="20" name="searchText" id="searchText" onkeypress="return IfReturnPressed(event);"><input type="button" value="#(lblSearch2)#" onclick="startSearch();">
	<input type="button" value="#(lblRefresh)#" onclick="document.location.reload();">>
	If refreshpage '= "" &html<<input type="button" name="btnCancel" id="btnCancel" value="#(lblCancel)#" onClick="self.document.location.href='#(refreshpage)#'">>
 	&html<&nbsp;&nbsp;<a href="#bottom" class="footerlinks">#(lblGoBottom)#</a></h2>
 	</form>
 	<hr noshade size="1">>
 	If type '= "rtn" {
	  If filename '= "" {
		#; when we are displaying cconsolelog, we check to see if the alerts.log exists. If yes
		#; then we display the alerts.log first.
		If $G(alertslog) '= "",##class(%File).Exists(alertslog) {
			&html<<h1 style="color:red">#($$$FormatText($$$Text("ALERTS From %1"),alertslog))#</h1><div style="color:red">>
			Do ..DrawLogContent(alertslog)
			&html<</div><hr noshade size="1">>
		}
	 	If ##class(%File).Exists(filename) {
			Do ..DrawLogContent(filename)
	 	} Else {
		 	&html<<div class="ErrorBox">#(lblFileNot)#</div>>	
	 	}
 	  } Else {
	 	&html<<h2>#(lblPleaseSelect)#</h2>>		
 	  }
 	} Else {
	 	// handle routine
	 	If namespace '= "",namespace'=$zu(5) ZN namespace
	 	If ##class(%RoutineMgr).Exists(filename) {
		 	Set stream = ##class(%RoutineMgr).%New(filename)
		 	#;YSD2549 Set tSC = stream.OpenStream(filename)
		 	#;YSD2549 If $$$ISERR(tSC) {
			 If '$IsObject(stream) {
			 	&html<<div class="ErrorBox">#($$$FormatText($$$Text("Cannot open %1"),filename))#</div>>		
		 	} Else {
		 		&html<<pre>>
	 			While 'stream.Code.AtEnd {
 					Write $ZCVT(stream.Code.Read(10000),"O","HTML")
	 			}
				&html<</pre>
				<br>&nbsp;<br>>
				Kill stream	
		 	}
	 	} Else {
		  &html<<div class="ErrorBox">#(lblFileNot)#</div>>	
	 	}
 	}
 	&html<<a href="#top" class="footerlinks">#(lblGoTop)#</a><a name="bottom"></a>>
	Quit $$$OK
}

Method DrawLogContent(filename As %String)
{
	Set showAll = $G(%request.Data("showAll",1))
 	Set stream = ##class(%Stream.FileCharacter).%New()
 	Set stream.Filename = filename
 	Set max = 1048576
 	Set size = stream.Size
 	If size > 1048576 {
	 	Set dispSize = $FN(size/1024/1024,",",1)_ "MB"
 	} ElseIf size > 1024 {
 		Set dispSize = $FN(size/1024,",",1)_" KB"
 	} Else {
	 	Set dispSize = size_" bytes"
 	}
 	&html<#($$$FormatText($$$Text("File size: %1"),dispSize))#>
 	If showAll="",size > max {
		&html<<br/>#($$$TextHTML("NOTE: File is bigger than 1MB - only the last 1MB is displayed."))#>
		Set hlpMsg = $$$Text("Large file will take longer time to load!")
		Set link = ##class(%CSP.Page).Link("UtilSysConsoleLog.csp",,1)_"$ID1=cconsole.log&showAll=1"
	 	&html<<a href="#(link)#" title="#(hlpMsg)#">(#($$$TextHTML("show entire file"))#)</a>	 	
	 	>
	 	Do stream.MoveTo(size - max)
 	}
	&html<<pre>>
 	While 'stream.AtEnd {
 		Set line = stream.ReadLine()
 		&html<#($ZCVT(line,"O","HTML"))#>
	}
	&html<</pre>
	<br>&nbsp;<br>>
	Kill stream
}

/// Draw javascript functions for search
Method DrawHEAD(pInstance As PageInstance) As %Status
{
	&html<
	<script language="javascript">
	function getFocus()
	{
		document.getElementById("searchText").focus();
	}
function startSearch()
{
	var searchText = document.getElementById("searchText").value;
	if (searchText == "") {
		alert('#($$$Text("Please enter the string you want to search."))#');
		getFocus();
	} else {
		var textColor = "red";
		var bgColor = "yellow";
	    var highlightStartTag = "<font style='color:" + textColor + "; background-color:" + bgColor + ";'>";
	    var highlightEndTag = "</font>";
		var treatAsPhrase = true //document.getElementById("treatAsPhrase").checked;
		highlightSearchTerms(searchText, treatAsPhrase, true, highlightStartTag, highlightEndTag);
		document.getElementById("searchText").value = searchText;
		getFocus();
	}
}
	/*
 * This is sort of a wrapper function to the doHighlight function.
 * It takes the searchText that you pass, optionally splits it into
 * separate words, and transforms the text on the current web page.
 * Only the "searchText" parameter is required; all other parameters
 * are optional and can be omitted.
 */
function highlightSearchTerms(searchText, treatAsPhrase, warnOnFailure, highlightStartTag, highlightEndTag)
{
  // if the treatAsPhrase parameter is true, then we should search for 
  // the entire phrase that was entered; otherwise, we will split the
  // search string so that each word is searched for and highlighted
  // individually
  if (treatAsPhrase) {
    searchArray = [searchText];
  } else {
    searchArray = searchText.split(" ");
  }
  if (!document.body || typeof(document.body.innerHTML) == "undefined") {
    if (warnOnFailure) {
      alert('#($$$Text("Unable to perform search on this page."))#');
    }
    return false;
  }
  
  var bodyText = document.body.innerHTML;
  for (var i = 0; i != searchArray.length; i++) {
    bodyText = doHighlight(bodyText, searchArray[i], highlightStartTag, highlightEndTag);
  }
  
  document.body.innerHTML = bodyText;
  return true;

}
function doHighlight(bodyText, searchTerm, highlightStartTag, highlightEndTag) 
{
  // the highlightStartTag and highlightEndTag parameters are optional
  if ((!highlightStartTag) || (!highlightEndTag)) {
    highlightStartTag = "<font style='color:blue; background-color:yellow;'>";
    highlightEndTag = "</font>";
  }
  
  // find all occurences of the search term in the given text,
  // and add some "highlight" tags to them (we're not using a
  // regular expression search, because we want to filter out
  // matches that occur within HTML tags and script blocks, so
  // we have to do a little extra validation)
  var newText = "";
  var i = -1;
  var lcSearchTerm = searchTerm.toLowerCase();
  var lcBodyText = bodyText.toLowerCase();
    
  while (bodyText.length > 0) {
    i = lcBodyText.indexOf(lcSearchTerm, i+1);
    if (i < 0) {
      newText += bodyText;
      bodyText = "";
    } else {
      // skip anything inside an HTML tag
      if (bodyText.lastIndexOf(">", i) >= bodyText.lastIndexOf("<", i)) {
        // skip anything inside a <script> block
        if (lcBodyText.lastIndexOf("/script>", i) >= lcBodyText.lastIndexOf("<script", i)) {
          newText += bodyText.substring(0, i) + highlightStartTag + bodyText.substr(i, searchTerm.length) + highlightEndTag;
          bodyText = bodyText.substr(i + searchTerm.length);
          lcBodyText = bodyText.toLowerCase();
          i = -1;
        }
      }
    }
  }
  
  return newText;
}
// generic function called from /csp/sys/UtilFileSelect.csp
function update(remotefile)
{
	document.getElementById("RemoteFileName").value = remotefile;
}
function IfReturnPressed(evnt)
{
	var appName = navigator.appName.substring(0,9);
	if ((appName != "Microsoft")&&(evnt.which == 13)||(appName == "Microsoft")&&(evnt.keyCode == 13)) {
		startSearch();
		return false;
	} else {
		return true;
	}
}
  	</script>>
	Quit $$$OK
}

}
