/// Temporary Report Preview Utilities
Class %DeepSee.Report.UI.reportPreviewer Extends %ZEN.Component.component [ LegacyInstanceContext, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property winTitle As %String [ InitialExpression = "Report_Preview" ];

Property winFeatures As %String [ InitialExpression = "height=480,left=16,resizeable,scrollbars,top=16,width=640" ];

Property modeFlag As %String [ InitialExpression = "$MODE=pdf" ];

Property debugModeFlag As %String [ InitialExpression = "$MODE=pdf&$REPORTNAME=" ];

Property tempDir As %String;

Property homeDir As %String;

Property hostName As %String;

Property portNumber As %String;

Property dirName As %String [ InitialExpression = "/csp/samples/" ];

Property packageName As %String [ InitialExpression = "MyApp." ];

Property reportName As %String [ InitialExpression = "ReportWriterTest" ];

Property dataSource As %String [ InitialExpression = "dataSource.xml" ];

Property errorOnCollect As %ZEN.Datatype.caption [ InitialExpression = "Error collecting live data for report preview" ];

Property collectorLbl As %ZEN.Datatype.caption [ InitialExpression = "Data collection class: " ];

Property errorLbl As %ZEN.Datatype.caption [ InitialExpression = "Error: " ];

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<<div></div>>
}

/// Return the temp directory for this system.
ClassMethod GetTempDir() As %String [ ZenMethod ]
{
#ifndef SYSTempDir
#define	SYSTempDir			^%SYS("TempDir")
#endif
	Quit $$$SYSTempDir
}

ClassMethod GetSystemHomeDir() As %String [ ZenMethod ]
{
	Quit $System.Util.InstallDirectory()
}

/// Return the temp directory for this system.
ClassMethod GetSystemTempDir() As %String [ ZenMethod ]
{
	Quit ##class(%SYS.System).TempDirectory()
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._debug = false;
	
	var l = window.location;
	this.portNumber = l.port;
	this.hostName = l.hostname;
	this.dirName = l.pathname.substring(0,l.pathname.indexOf('%'));
	this.homeDir = this.GetSystemHomeDir();
	this.tempDir = this.GetTempDir();
}

ClassMethod MakeRandomFileName(ext As %String = "", directory As %String = "") As %String [ ZenMethod ]
{
	quit ##class(%FileStreamAdaptor).NewFileName(ext,directory)
}

ClassMethod DeleteTempFile(fileName As %String) [ ZenMethod ]
{
	Do ##class(%File).Delete(fileName)
}

/// Return a string representing an array of the class properties that have ZENURL 
/// parameters set for them
ClassMethod GetClassProperties(className As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set rValue = ""
	
	Set:className'="" cdef=##class(%ClassDefinition).%OpenId(className)
	If (cdef=$$$NULLOREF) QUIT "ERROR"
	Set tmp=$property(cdef,"Properties")
	For i=1:1:tmp.Count() {
		Set pObj = "["
		Set item=tmp.GetAt(i)
		Set pCount = item.Parameters.Count()
		if (pCount>0) {  ;# if no parameters skip it and move on
			Set pObj = pObj_item.Name
			Set pFound = 0
			Set idx = 1
			Set pName = ""
			while (idx<=pCount) {
				Set pVal=item.Parameters.GetNext(.pName)
				if (pName="ZENURL") {
					Set pObj = "["_item.Name_":"_pVal
					Set pFound = 1
				}	
				Set idx = idx+1
			}
			if (pFound=1) {
				Set rValue = rValue_pObj
			}					
		}
	}
	Quit rValue
}

ClassMethod GenerateDataSet(clsName As %String, fileName As %String, pStr As %String = "") As %Status [ ZenMethod ]
{
	Set tProps = ..GetClassProperties(clsName)
	Set obj = $System.OBJ.New(clsName)
	If (pStr'="") {
 	 	Set delim = $EXTRACT(pStr) // first character is delimiter
 	 	Set pCount = $LENGTH(pStr,delim)
 	 	For i=2:2:pCount {
 			Set pName = $PIECE(pStr,delim,i)
 			Set pValue = $PIECE(pStr,delim,i+1)
 			// The property and value may be ether a COS property or
 			// if it begins with a '?' a ZENURL property value sort out which is which
			Set tIdx = $Find(pName,"?")
			If (tIdx = 2) {
				Set pName = ":"_$PIECE(pName,"?",2)
				// Now we need to figure out which Property this ZENURL belongs
				Set tNum=$LENGTH(tProps,"[")
				Set tPart=1
				For tReps=tNum:-1:1 {
					Set tNVP=$PIECE(tProps,"[",tPart)
					If ($FIND(tNVP,pName)>2) {
						Set $PROPERTY(obj,$PIECE(tNVP,":",1)) = pValue
					}
					Set tPart=tPart+1
   				}
			}
			Else {
	 			SET $PROPERTY(obj,pName) = pValue
			}
 	 	}
	}
 	Set Status= obj.GenerateReport(fileName,0) 
	Quit Status
}

ClassMethod GetDSS(fileName As %String) As %String [ ZenMethod ]
{
	Set obj = $System.OBJ.New(fileName)
	Set model = obj.GetReportDSS()
	Quit model
}

ClientMethod getServerHomeDir() [ Language = javascript ]
{
	if (!this.systemHomeDir) this.systemHomeDir = this.GetSystemHomeDir();
	return(this.systemHomeDir);
}

ClientMethod getServerTempDir() [ Language = javascript ]
{
	if (!this.systemTempDir) this.systemTempDir = this.GetSystemTempDir();
	return(this.systemTempDir);
}

ClientMethod getServerFileDelimiter() [ Language = javascript ]
{
	if (this.fileDelimiter) return(this.fileDelimiter);
	var s2 = this.getServerHomeDir();
	this.fileDelimiter = s2.charAt(s2.length-1);
	return(this.fileDelimiter);
}

ClientMethod makeXMLFileName(name) [ Language = javascript ]
{
	var dir = this.getServerTempDir();
	var sep = this.getServerFileDelimiter();
	if (dir.charAt(dir.length-1)==sep) sep=""; // trap VMS case
	if (!name) {
		name = this.MakeRandomFileName('xml',dir);
		return(dir+sep+name);
	}
	return(dir+sep+name+'.xml');
}

ClassMethod GetTempFileName() As %String [ ZenMethod ]
{
	Set dir = ..GetSystemTempDir()
	Set home = ..GetSystemHomeDir()
	Set name = ..MakeRandomFileName("xml",dir)
	Quit ##class(%File).NormalizeFilename(name,dir)
}

/// Show a preview.
ClientMethod preview(className, dataSrc) [ Language = javascript ]
{
	var winURL = "";
	///Check the data source to see if it is a file or a class reference
	if (!dataSrc) winURL = className+'.cls?'+this.modeFlag;
	else {
		var m = this.GetDSS(dataSrc);
		var l = m.split(',');
		var df = null;
		var dc = null;
		var ll = l.length;
		var cnt = 0;
		var i = 0;
		while (i<ll && cnt<2) {
			var itm = l[i];
			if (itm.indexOf("dataFileName:")>=0) {
				df = itm.split(':')[1].split('"')[1];
				cnt++;
			}
			if (itm.indexOf("dataCollector:")>=0) {
				dc = itm.split(':')[1].split('"')[1];
				cnt++;
			}
			i++;
		}
		if (df && df.length>0) {
			df = 'http://'+window.location.host+df;
			winURL = className+'.cls?'+this.modeFlag+'&$DATASOURCE='+df;
		}
		else {
			df = this.makeXMLFileName();
			var status = this.GenerateDataSet(dc,df);
			if (status!=1) {
				var msg = status.split(String.fromCharCode(1))[2];
				var p1 = this.errorOnCollect;
				var p2 = this.collectorLbl;
				var p3 = this.errorLbl;
				alert(p1+"\n"+p2+dc+"\n"+p3+msg); 
				return(null);
			}
			winURL = className+'.cls?'+this.modeFlag+'&$DATASOURCE='+df;
		}
	}
	// if its a class, run the related report in XLM mode to create a temp file
	// then use the file (original or temp) to drive this report
	
	//TODO THIS SHOULD BE MODEL AWARE TO FOLLOW LINKED REFERENCES
	//var winURL = 'http://'+this.hostName+':'+this.portNumber+this.dirName+className+'.cls?'+this.modeFlag+'&$DATASOURCE='+dataSrc;
	window.open(winURL,this.winTitle,this.winFeatures);
	return(true);
}

/// Collect data and return the URL for viewing the report.
ClientMethod execute(className, dataSrc, pStr, debug) [ Language = javascript ]
{
	var modeFlag = this.modeFlag;
	if (debug) modeFlag = this.debugModeFlag+debug;
	var winURL = "";
	///Check the data source to see if it is a file or a class reference
	if (!dataSrc) winURL = className+'.cls?'+modeFlag;
	else {
		var m = this.GetDSS(dataSrc);
		var l = m.split(',');
		var df = null;
		var dc = null;
		var ll = l.length;
		var cnt = 0;
		var i = 0;
		while (i<ll && cnt<2) {
			var itm = l[i];
			if (itm.indexOf("dataFileName:")>=0) {
				df = itm.split(':')[1].split('"')[1];
				cnt++;
			}
			if (itm.indexOf("dataCollector:")>=0) {
				dc = itm.split(':')[1].split('"')[1];
				cnt++;
			}
			i++;
		}
		if (df && df.length>0) {
			df = 'http://'+window.location.host+df;
			winURL = className+'.cls?'+modeFlag+'&$DATASOURCE='+df;
		}
		else {
			df = this.makeXMLFileName();
			var status = this.GenerateDataSet(dc,df,pStr);
			if (status!=1) {
				var msg = status.split(String.fromCharCode(1))[2];
				var p1 = this.errorOnCollect;
				var p2 = this.collectorLbl;
				var p3 = this.errorLbl;
				alert(p1+"\n"+p2+dc+"\n"+p3+msg); 
				return(null);
			}
			winURL = className+'.cls?'+modeFlag+'&$DATASOURCE='+df;
			df = df.split("\\").join("\\\\");
			setTimeout('zenPage.getComponentById("'+this.id+'").DeleteTempFile("'+df+'");',3000);
		}
	}
	// if its a class, run the related report in XLM mode to create a temp file
	// then use the file (original or temp) to drive this report
	
	//TODO THIS SHOULD BE MODEL AWARE TO FOLLOW LINKED REFERENCES
	//var winURL = 'http://'+this.hostName+':'+this.portNumber+this.dirName+className+'.cls?'+this.modeFlag+'&$DATASOURCE='+dataSrc;
	return(winURL);
}

ClientMethod refreshDataSource() [ Language = javascript ]
{
	var fullName = this.packageName+this.reportName;
	var rptURI = this.dirName+this.reportName+'.xml';
	var outName = this.homeDir+this.dirName+this.tempDir+this.dataSource;
	var test = this.ReallyRefreshDataSource(fullName,rptURI,this.hostName,this.portNumber,outName)
	return(test);
}

Method ReallyRefreshDataSource(pClassName As %String, pURI As %String, pServerName As %String, pServerPort As %String, pOutFileName As %String) As %Status [ ZenMethod ]
{
	;	Set tNS = $NAMESPACE
	;	ZNSPACE "SAMPLES"
	Set %request=##class(%CSP.Request).%New()
 	Set %request.URL = pURI
	Set %request.CgiEnvs("SERVER_NAME")=pServerName
 	Set %request.CgiEnvs("SERVER_PORT")=pServerPort
 	Set report = $System.OBJ.New(pClassName)
 	Set tSC = report.GenerateReport(pOutFileName,0)
	;	ZNSPACE tNS
 	Quit tSC
}

ClassMethod GeneratePresentationReport(pClassName As %String, pStr As %String = "", pOutFileName As %String, pRptObj As %DeepSee.Report.dataPresenter = "", log As %Boolean = 0, renderServer As %String = "") As %Status [ ZenMethod ]
{
	Set tmpDirty = 0

	If (pRptObj="") {
		Set report = $System.OBJ.New(pClassName)
	}
	Else {
		Set report = pRptObj
	}
	If (report="") {
		Quit ""
	}
	Set dssClass = $PARAMETER(report,"DSSCLASS")
	If (dssClass="") {
		//winURL = className+'.cls?'+this.modeFlag;
	}
	Else {
		Set dssModel = ..GetDSS(dssClass)

		Set ll = $LENGTH(dssModel,",")
		Set df = ""
		Set dc = ""
	 	For i=1:1:ll {
 			Set item = $PIECE(dssModel,",",i)
			If ($FIND(item,"dataFileName:")=14) {
				Set df = $EXTRACT(item,15,*-1)
			}
			If ($FIND(item,"dataCollector:")=15) {
				Set dc = $EXTRACT(item,16,*-1)
			}
 	 	}
 	 	If ($LENGTH(df)<3) {
	 	 	Set df = ..GetTempFileName()
	 	 	Set tSC = ..GenerateDataSet(dc,df,pStr)
	 	 	Set tmpDirty = 1
 	 	}
 		If (tSC = $$$OK ) {
	 		Set report.Datasource = df
 			Set tSC = report.GenerateReport(pOutFileName,2,log,renderServer)
 			Set report.Datasource = ""
 			If (tmpDirty = 1) {
		 		Do ..DeleteTempFile(df)
 			}
 		}
	}
 	Quit tSC
}

}
