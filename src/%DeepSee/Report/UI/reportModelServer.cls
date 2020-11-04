/// Abstract Report Model File Utilities
Class %DeepSee.Report.UI.reportModelServer Extends %ZEN.Component.component [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zenESVG.js";

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<<div></div>>
}

/// Receive a chuck of a client text stream submission
ClassMethod ReceiveFragment(outputFile As %String, src As %ZEN.proxyObject) As %Status [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse
		
	Set tSC = $$$OK
	If ('tDisabled) {
		Set $ZTrap = "SaveFileError"
		If (src.part=1) {
			Open outputFile:("NW")
		}
		Else {
			Open outputFile:("AW")
		}
		Use outputFile
		$$$SETIO("UTF8")
		Write src.code
		Close outputFile
	}
	Else {
		Set tSC=$$$ERROR($$$GeneralError,76)
	}		
	Quit tSC
	
SaveFileError
	Set $ZTrap=""
	Set tSC=$$$ERROR($$$GeneralError,$ZE)
	quit tSC
}

/// Load and compile the given temp file
ClassMethod ImportXML(fileName) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse
		
	Set tSC = $$$OK
	If ('tDisabled) {
		Set tSC = $system.OBJ.Load(fileName,"fck-d")
		If (tSC = $$$OK) Do ..DeleteTempFile(fileName)
		If (tSC = $$$OK) {
			Set jsStatus = 1
		}
		Else {
			Set jsStatus = ""
			Set err = ""
			Do DecomposeStatus^%apiOBJ(tSC,.err,"-d")
			For i=1:1:err {
				Set jsStatus = jsStatus_"|"_err(i)
			}
		}
	}
	Else {
		Set jsStatus = "0"
	}
 	Quit jsStatus
}

/// Load the DCR section of the given named file and return the underlying model
ClassMethod GetDCR(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse
		
	If ('tDisabled) {
		Set obj = $System.OBJ.New(fileName)
		Set model = obj.GetReportDCR()
	}
	Else {
		Set model = ""
	}
	Quit model
}

/// Load the DSS section of the given named file and return the underlying model
ClassMethod GetDSS(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
	
		Set obj = $System.OBJ.New(fileName)
		Set model = obj.GetReportDSS()
	}
	Else {
		Set model = ""
	}
	Quit model
}

/// Load the DPR section of the given named file and return the underlying model
ClassMethod GetDPR(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Set obj = $System.OBJ.New(fileName)
		Set model = obj.GetReportModel()
	}
	Else {
		Set model = ""
	}
	Quit model
}

/// Load the Query Interface section of the given named file and return the underlying model
ClassMethod GetQueryInterface(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Set obj = $System.OBJ.New(fileName)
		Set model = obj.GetQueryInterfaceModel()
	}
	Else {
		Set model = ""
	}
	Quit model
}

/// Return the DSS Home of the current DPR
ClassMethod GetDPRDSSHome(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Set obj = $System.OBJ.New(fileName)
		Set m = obj.GetDSSHome()
	}
	Else {
		Set m = ""
	}
	Quit m
}

/// Return the DSSClass upon which the current DPR is based
ClassMethod GetDPRDSSClass(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Set obj = $System.OBJ.New(fileName)
		Set m = obj.GetDSSClass()
	}
	Else {
		Set m = ""
	}
	Quit m
}

/// Generate data for a time stamp as a string for file generation purposes
ClassMethod GetTimeStampInfo() As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Set str = $System.Version.Format(4)_"|"_$zdt($h,3)_"|"_$ZTIMESTAMP
	}
	Else {
		Set str = ""
	}
	Quit str
}

/// Return the temp directory for this system.
ClassMethod GetSystemTempDir() As %String [ ZenMethod ]
{
	Quit ##class(%SYS.System).TempDirectory()
}

/// Return the system install directory of this instance
ClassMethod GetSystemHomeDir() As %String [ ZenMethod ]
{
	Quit $System.Util.InstallDirectory()
}

/// Delete the given temp file
ClassMethod DeleteTempFile(fileName As %String) As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Do ##class(%File).Delete(fileName)
	}
}

/// Get the normalized directory name of the CSP base folder used for serving up Zen Applications
ClassMethod GetCSPDirectory() As %String [ ZenMethod ]
{
	Set mgr = ##class(%File).ManagerDirectory()
	Set cspDir = ##class(%File).NormalizeDirectory("../CSP",mgr)
	quit cspDir
}

/// Generate a random but legal and available file name for the creation of external temp files
ClassMethod MakeRandomFileName(ext As %String = "", directory As %String = "") As %String [ ZenMethod ]
{
	Set tUse = $$CheckReportFormatDefAccess^%qdsUtils()
	Set tDisabled = 'tUse		
	If ('tDisabled) {
		Set name = ##class(%FileStreamAdaptor).NewFileName(ext,directory)
	}
	Else {
		Set name = ""
	}
	Quit name
}

ClassMethod GetReportSuperClasses() As %String [ ZenMethod ]
{
	Set json = ##class(%DeepSee.Report.Config.configData).GetDefaultSuperClasses()
	Quit json
}

/* LOCAL WRAPPER FUNCTIONS TO AVOID EXCESS TRIPS TO THE SERVER */
ClientMethod getServerTempDir() [ Language = javascript ]
{
	if (!this.systemTempDir) this.systemTempDir = this.GetSystemTempDir();
	return(this.systemTempDir);
}

ClientMethod getServerHomeDir() [ Language = javascript ]
{
	if (!this.systemHomeDir) this.systemHomeDir = this.GetSystemHomeDir();
	return(this.systemHomeDir);
}

ClientMethod getCSPDir() [ Language = javascript ]
{
	if (!this.cspDir) this.cspDir = this.GetCSPDirectory();
	return(this.cspDir);
}

ClientMethod getServerFileDelimiter() [ Language = javascript ]
{
	if (this.fileDelimiter) return(this.fileDelimiter);
	var s2 = this.getServerHomeDir();
	this.fileDelimiter = s2.charAt(s2.length-1);
	return(this.fileDelimiter);
}

// =============

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._debug = false;
	this.jsModel = null;
}

/// Return the formal name(s) of the immediate superclass based on the current model's
/// type definition
ClientMethod getReportSuperClass() [ Language = javascript ]
{
	var userPrefs = this.GetReportSuperClasses();
	var validDefaults = false;
	var clsObj = null;
	if (userPrefs) {
		var a = eval(userPrefs);
		if (a.length) {
			clsObj = a[0];
			var o = a[1];
			if (o) {
				for (p in o) clsObj[p] = o[p]; // Namespace overrides
			}
			validDefaults = true;
		}
	}
	if (!validDefaults || !this.jsModel) return('%DeepSee.Report.reportPage');
	switch(this.jsModel.type) {
		case "DCR":
			return(clsObj.dcrClass+','+clsObj.dssClass);
		case "DSS":
			return(clsObj.dssClass);
		case "DPR":
			return(clsObj.dprClass);
		case "SQLDSS":
			return(clsObj.sqlClass);
	}	
	return(clsObj.defaultClass);
}

/// Return the default processing mode based on the current model's type
ClientMethod getReportOutputMode() [ Language = javascript ]
{
	if (!this.jsModel) return("toXSLFO");
	if (this.jsModel.type=="DPR") return("pdf");
	return("xml");
}

/// Get the package name of the current report (this value can only be set at the
/// time of report creation via createNewDCR, createNewDSS, or createNewDPR)
ClientMethod getReportPackageName() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.package);
	}
	return(null);
}

/// Get the Cache class name of the current report (this value can only be set at the
/// time of report creation via createNewDCR, createNewDSS, or createNewDPR)
ClientMethod getReportClassName() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.objClass);
	}
	return(null);
}

/// Get the full Cache name of the current report.  This is a concatenation of the
/// the package name and the class name and is read only.
ClientMethod getReportSystemName() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.sysName);
	}
	return(null);
}

/// Return the semantic name of the current report
ClientMethod getReportName() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.name);
	}
	return(null);
}

/// Set the semantic name of the current report.  This is the human readable
/// textual name, as opposed to the lexical class and system names.
ClientMethod setReportName(n) [ Language = javascript ]
{
	if (this.jsModel) {
		this.jsModel.name = n;
	}
}

/// Return the descriptor of the current report
ClientMethod getReportDescription() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.desc);
	}
	return(null);
}

/// Set the descriptor of the current report
ClientMethod setReportDescription(s) [ Language = javascript ]
{
	if (this.jsModel) {
		this.jsModel.desc = s;
	}
}

/// Get the name of application associated with the current report.
ClientMethod getReportApplication() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.appName);
	}
	return(null);
}

/// Set the name of application associated with the current report.
ClientMethod setReportApplication(s) [ Language = javascript ]
{
	if (this.jsModel) {
		this.jsModel.appName = s;
	}
}

/// Get the name of data source associated with the current report.
ClientMethod getReportDataSource() [ Language = javascript ]
{
	if (this.jsModel) {
		return(this.jsModel.dataSrc);
	}
	return(null);
}

/// Set the name of data source associated with the current report.
ClientMethod setReportDataSource(s) [ Language = javascript ]
{
	if (this.jsModel) {
		this.jsModel.dataSrc = s;
	}
}

/// Set the properties section of the current model to the given array of
/// property objects
ClientMethod setDCRPropertiesSection(prop) [ Language = javascript ]
{
	if (this.jsModel.type!='DCR') return;
	var l = prop.length;
	this.jsModel.prop = [];
	for (var i=0;i<l;i++) {
		this.jsModel.prop[i] = prop[i];
	}
}

/// Return the properties section of the current model, if it is a 
/// DCR type report and null otherwise.
ClientMethod getDCRPropertiesSection() [ Language = javascript ]
{
	if (!this.jsModel) return(null);
	if (this.jsModel.type!='DCR') return(null);
	return(this.jsModel.prop);
}

/// Return the methods section of the current model, if it is a 
/// DCR type report and null otherwise.
ClientMethod getDCRMethodsSection() [ Language = javascript ]
{
	if (!this.jsModel) return(null);
	if (this.jsModel.type!='DCR') return(null);
	return(this.jsModel.meth);
}

/// Set the methods section of the current model, assuming it is a 
/// DCR type report and no-op otherwise.
ClientMethod setDCRMethodsSection(m) [ Language = javascript ]
{
	if (this.jsModel.type!='DCR') return(null);
	if (!this.jsModel) return(null);
	this.jsModel.meth=[];
	var jsM = this.jsModel.meth;
	var ml = m.length;
	for (var i=0;i<ml;i++) {
		jsM.push(m[i]);
	}
}

/// Return the data tree section of the current model, if it is a 
/// DCR type report and null otherwise.
ClientMethod getDCRDataTree() [ Language = javascript ]
{
	if (!this.jsModel) return(null);
	if (this.jsModel.type!='DCR') return(null);
	return(this.jsModel.tree);
}

/// Set the data tree section of the current model, assuming it is a 
/// DCR type report and no-op otherwise.
ClientMethod setDCRDataTree(tree) [ Language = javascript ]
{
	if (this.jsModel.type!='DCR') return;
	if (!this.jsModel) return;
	this.jsModel.tree = tree;
}

/// Return the SQL section of the current model, if it is a 
/// DCR type report and null otherwise.
ClientMethod getDCRSQL() [ Language = javascript ]
{
	if (!this.jsModel) return(null);
	if (this.jsModel.type!='DCR') return(null);
	return(this.jsModel.sql);
}

/// Set the SQL section of the current model assuming it is a 
/// DCR type report and no-op otherwise.
ClientMethod setDCRSQL(sqlObj) [ Language = javascript ]
{
	if (this.jsModel.type!='DCR') return;
	if (!this.jsModel) return;
	this.jsModel.sql=sqlObj;
}

/// Extract a javascript object represeting the Data Set Schema
/// from the current abstract model, assuming the active model is
/// a DSS type structure.
ClientMethod getDSSObject() [ Language = javascript ]
{
	if (!this.jsModel) return(null);
	if (this.jsModel.type!='DSS') return(null);
	return(this.decodeDSSNode(this.jsModel));
}

ClientMethod decodeDSSNode(o) [ Language = javascript ]
{
	var n = {}
	switch(o.t) {
		case 'r': n.nodeType = "root";
			break;
		case 'i': n.nodeType = "item";
			break;
		case 'a': n.nodeType = "attribute";
			break;
		case 'g': n.nodeType = "group";
			break;
	}
	n.nodeName = o.n;
	if (o.dataFileName) n.dataFileName=o.dataFileName;
	if (o.dataCollector) n.dataCollector=o.dataCollector;
	if (o.onExtractData) n.onExtractData=o.onExtractData;
	if (o.onGetDataAge) n.onGetDataAge=o.onGetDataAge;
	if (o.a) {
		n.attr=[];
		var al = o.a.length;
		for (var i=0;i<al;i++) {
			n.attr.push(this.decodeDSSNode(o.a[i]));
		}
	}
	if (o.i) {	
		n.item=[];
		var il = o.i.length;
		for (var i=0;i<il;i++) {
			n.item.push(this.decodeDSSNode(o.i[i]));
		}
	}
	return(n);
}

ClientMethod encodeDSSNode(o) [ Language = javascript ]
{
	var n = {}
	switch(o.nodeType) {
		case 'root': n.t = "r";
			break;
		case 'item': n.t = "i";
			break;
		case 'attribute': n.t = "a";
			break;
		case 'group': n.t = "g";
			break;
	}
	n.n = o.nodeName;
	if (o.dataFileName) n.dataFileName=o.dataFileName;
	if (o.dataCollector) n.dataCollector=o.dataCollector;
	if (o.onExtractData) n.onExtractData=o.onExtractData;
	if (o.onGetDataAge) n.onGetDataAge=o.onGetDataAge;
	if (o.attr && o.attr.length>0) {
		n.a=[];
		var al = o.attr.length;
		for (var i=0;i<al;i++) {
			if (o.attr[i]) n.a.push(this.encodeDSSNode(o.attr[i]));
		}
	}
	if (o.item && o.item.length>0) {	
		n.i=[];
		var il = o.item.length;
		for (var i=0;i<il;i++) {
			if (o.item[i]) n.i.push(this.encodeDSSNode(o.item[i]));
		}
	}
	return(n);
}

/// Create a new DCR type report model 
ClientMethod createNewDCR(headerInfo) [ Language = javascript ]
{
	var h = headerInfo;
	if (!h) {
		h={};
		h.pkgName="";
		h.clsName="";
		h.appName="";
		h.rptName="";
		h.desc="";
	}
	this.jsModel = {
		package:h.pkgName,
		objClass:h.clsName,
		appName:h.appName,
		sysName:h.pkgName+"."+h.clsName,
		name:h.rptName,
		desc:h.desc,
		type:"DCR",
		dataSrc:"",
		sql:{src:"",fld:[],w:"",ob:[],p:[]},
		prop:[],
		meth:[],
		tree:{t:"gp",n:"_root",k:[	{t:"at",n:"runTime",e:"$ZDT($H,3)"},
			{t:"at",n:"runBy",e:"$UserName"}]}
	};
	
	return(this.jsModel);
				
	//SQL objects:
	//{src:"ZENApp_Report.Invoice",fld:["ID","Customer","Num","SalesRep","SaleDate"],w:"(Month(SaleDate) = ?) OR (? IS NULL)",ob:["SalesRep","SaleDate"],p:["..Month","..Month"]},

	//Property objects:
	//{n:"ReportAuthor",d:"Author of Report",t:"%String",i:"BOB",z:"AUTHOR"}
	//{n:"Month",d:"Month (1 to 12) to run this report for. "" for all months.",t:"%Integer",p:[{n:"MAXVAL",v:"12"},{n:"MINVAL",v:"1"}],z:"MONTH"}

	//Method objects:
	//{n:"GetMonth",d:"Return a formatted version of the month property.",t:"%String",b:"\tIf (..Month="") Quit "ALL"\n\n\t#; convert to month name:\n\tSet tDT = "2006-"_$TR($J(..Month,2)," ","0")_"-01"\n\tSet tDT = $ZDTH(tDT,3) // convert to $H\n\tSet tDT = $ZDT(tDT,5) // convert to MMM format\n\tQuit $E(tDT,1,3)"}
	//{n:"NewMethod1",d:"",a:[{n:"Arg1",t:"%String",d:"fred"}],t:"",b:""}
}

/// Create a new DSS type report model based on an external SQL Query 
ClientMethod createNewSQLDSS(headerInfo) [ Language = javascript ]
{
	var h = headerInfo;
	if (!h) {
		h={};
		h.pkgName="";
		h.clsName="";
		h.appName="";
		h.rptName="";
		h.desc="";
	}
	this.jsModel = {
		package:h.pkgName,
		objClass:h.clsName,
		appName:h.appName,
		sysName:h.pkgName+"."+h.clsName,
		name:h.rptName,
		desc:h.desc,
		type:"SQLDSS",
		queryInfo:{},
		dataSrc:"",
		dss:{}
	};
	if (!this.jsModel.name) this.jsModel.name = "unnamedDSS";
	var o={};
	o.n = this.jsModel.name;
	o.t = 'r';
	o.dataFileName = '';
	o.dataCollector = this.jsModel.sysName;
	o.onExtractData = '';
	o.onGetDataAge = '';
	this.jsModel.dss = o;

	return(this.jsModel);
}

/// Create a new DSS type report model 
ClientMethod createNewDSS(headerInfo) [ Language = javascript ]
{
	var h = headerInfo;
	if (!h) {
		h={};
		h.pkgName="";
		h.clsName="";
		h.appName="";
		h.rptName="";
		h.desc="";
	}
	this.jsModel = {
		package:h.pkgName,
		objClass:h.clsName,
		appName:h.appName,
		sysName:h.pkgName+"."+h.clsName,
		name:h.rptName,
		desc:h.desc,
		type:"DSS",
		dataSrc:"",
		dss:{}
	};
	if (!this.jsModel.name) this.jsModel.name = "unnamedDSS";
	var o={};
	o.n = this.jsModel.name;
	o.t = 'r';
	o.dataFileName = '';
	o.dataCollector = '';
	o.onExtractData = '';
	o.onGetDataAge = '';
	this.jsModel.dss = o;

	return(this.jsModel);
}

/// Create a new DPR type report model 
ClientMethod createNewDPR(headerInfo) [ Language = javascript ]
{
	var h = headerInfo;
	if (!h) {
		h={};
		h.pkgName="";
		h.clsName="";
		h.appName="";
		h.rptName="";
		h.desc="";
	}
	this.jsModel = {
		package:h.pkgName,
		objClass:h.clsName,
		appName:h.appName,
		sysName:h.pkgName+"."+h.clsName,
		name:h.rptName,
		desc:h.desc,
		type:"DPR",
		dssHome:"linked",
		dssClass:""
	};
	
	return(this.jsModel);
}

ClientMethod setZRSBody(src) [ Language = javascript ]
{
	this.zrsBody = src;
}

/// Set the methods section of the current model, assuming it is a 
/// DPR type report and no-op otherwise.
ClientMethod setDPRMethodsSection(m) [ Language = javascript ]
{
	if (this.jsModel.type!='DPR') return(null);
	if (!this.jsModel) return(null);
	this.jsModel.meth=[];
	var jsM = this.jsModel.meth;
	var ml = m.length;
	for (var i=0;i<ml;i++) {
		jsM.push(m[i]);
	}
}

ClientMethod getQueryInfo(clsName) [ Language = javascript ]
{
	var model = this.GetQueryInterface(clsName);
	if (model) {
		var o = ZLM.jsonParse(model,true);
		return(o);
	}
	return(null);
}

/// Set the reportSource for the report.
ClientMethod setReportSource(cls, reportType) [ Language = javascript ]
{
	this.jsModel = {};
	if (cls) {
		this.reportSource = cls;
		var model = {};
		switch(reportType) {
			case 'DCR':
				model = this.GetDCR(cls);
				break;
			case 'DSS':
			case 'SQLDSS':
				model = this.GetDSS(cls);
				break;
			case 'DPR':
				model = this.GetDPR(cls);
				break;
		}
		var m = this.jsModel;
		if (model) {
			var obj=ESVG.jsonParseValue(model);
			m = obj.obj;
			m.type=reportType;
			if (reportType=="DPR") { // get additional settings
				m.dssClass = this.GetDPRDSSClass(cls);
				m.dssHome = this.GetDPRDSSHome(cls);
			}
		}
		var cA = cls.split(".");
		var clsName = cA.pop();
		var pkgName = cA.join(".");
		m.package = pkgName;
		m.objClass = clsName;
		m.sysName=cls;
		this.jsModel = m;
	}
	return(this.jsModel);
}

/// Copy the current (client-side) model to a json string for short term back-up purposes
ClientMethod backupModel() [ Language = javascript ]
{
	if (!this.jsModel) return(null);
	return(ZLM.jsonStringify(this.jsModel));
}

/// Reset the model based on a previously saved json back-up string.
ClientMethod restoreBackupModel(jsonStr) [ Language = javascript ]
{
	if (jsonStr) this.jsModel = ZLM.jsonParse(jsonStr);
	return(this.jsModel);
}

ClientMethod convertRDToDSS(cls, xData) [ Language = javascript ]
{
	var xRoot = ESVG.xmlParse(xData);
	if (!xRoot) return(null);
	if (ESVG.xmlGetChildByNodeName(xRoot,"group")==null) return(null);
	var o = this.convertRDNodeToDSS(cls,xRoot.firstChild);
	if (o) return(this.decodeDSSNode(o));
	return(null);
}

ClientMethod convertRDNodeToDSS(cls, n) [ Language = javascript ]
{
	if (!n) return(null);
	var o={};
	var nameNode = n.getAttributeByName("name");
	if (nameNode) {
		o.n = nameNode.nodeValue;
		if (o.n=="") {
			if (n.nodeName=="group") o.n = "group";
			else o.n = "unnamed";
		}
	}
	else {
		if (n.nodeName=="group") o.n = "group";
		else o.n = "item";
	}
	
	if (n.nodeName=="report") {
		o.t = 'r';
		o.dataFileName = '';
		o.dataCollector = cls;
		o.onExtractData = '';
		o.onGetDataAge = '';
	}
	else if (n.nodeName=="group") {
		o.t = 'g';
		isGroup = true;
	}
	else if (n.nodeName=="attribute") {
		o.t = 'a';
		return(o);
	}
	else if (n.nodeName=="aggregate" || n.nodeName=='element') {
		o.t = 'i';
		return(o);
	}
	else return(null);
	// if we're still here n must be some sort of container
	o.a = [];
	o.i = [];
	for (var k = n.firstChild;k!=null;k=k.nextSibling) {
		var kObj = this.convertRDNodeToDSS(cls,k);
		if (kObj) {
			if (kObj.t == 'a') o.a.push(kObj);
			else o.i.push(kObj);
		}
	}		
	return(o);
}

/// Given a valid DCR JSON object, generate a DSS
ClientMethod convertDCRToDSS(cls, node) [ Language = javascript ]
{
	var o={};
	if (node.t=='gp') {
		if (node.n=='_root') { // special node
			o.t='r';
			var name = cls.split('.');
			name = name[name.length-1];
			o.n=name+"Data";
			o.dataFileName='';
			o.dataCollector=cls;
			o.onExtractData='';
			o.onGetDataAge='';
		}
		else {
			o.t='g';
			o.n=node.n;			
		}
		o.a=[];
		o.i=[];
		var l = node.k.length;
		for (var i=0;i<l;i++) {
			var k = node.k[i];
			var kn = this.convertDCRToDSS(cls,k);
			if (k.t=='at') o.a.push(kn);
			else o.i.push(kn);
		}
		return(o);
	}
	if (node.t=='at') {
		o.t='a';
		o.n=node.n;
		return(o);
	}
	if (node.t=='ag' || node.t=='el') {
		o.t='i';
		o.n=node.n;
		return(o);
	}
	return(null);
}

ClientMethod exportDSS(node) [ Language = javascript ]
{
}

ClientMethod exportReportDef(node) [ Language = javascript ]
{
	var s = ""
	if (node.t=='at') {
		s+='<attribute name="'+this.sanitizeXMLString(node.n)+'" ';
		if (node.e) s+='expression="'+this.sanitizeXMLString(node.e)+'" ';
		if (node.f) {
			if (node.f.indexOf('->')>0) s+='field="'+this.sanitizeXMLString(node.f.split('->').join('_'))+'" ';
			else s+='field="'+this.sanitizeXMLString(node.f)+'" ';
		}
		s+='/>\n';
		return(s);
	}
	if (node.t=='ag') {
		s+='<aggregate name="'+this.sanitizeXMLString(node.n)+'" ';
		if (node.o) s+='type="'+this.sanitizeXMLString(node.o)+'" ';
		if (node.f) {
			if (node.f.indexOf('->')>0) s+='field="'+this.sanitizeXMLString(node.f.split('->').join('_'))+'" ';
			else s+='field="'+this.sanitizeXMLString(node.f)+'" ';
		}
		s+='/>\n';		
		return(s);
	}
	if (node.t=='el') {
		s+='<element name="'+this.sanitizeXMLString(node.n)+'" ';
		if (node.e) s+='expression="'+this.sanitizeXMLString(node.e)+'" ';
		if (node.f) {
			if (node.f.indexOf('->')>0) s+='field="'+this.sanitizeXMLString(node.f.split('->').join('_'))+'" ';
			else s+='field="'+this.sanitizeXMLString(node.f)+'" ';
		}
		if (node.st) {
			if (node.st.indexOf("%Stream")>=0) s+='fieldType="stream" ';
		}
		s+='/>\n';
		return(s);
	}
	if (node.t=='gp') {
		s+='<group name="'+this.sanitizeXMLString(node.n)+'" ';
		if (node.br) s+='breakOnField="'+this.sanitizeXMLString(node.br.split('->').join("_"))+'" ';
		s+='>\n';
		for (var i=0;i<node.k.length;i++) {
			s+=this.exportReportDef(node.k[i]);
		}		
		s+='</group>\n';
		return(s);
	}
}

/// Given a string to be exported as an XML attribute setting
/// Replace all instances of '&' with '&amp;'
/// Replace all instances of '"' with '&quot;'
/// Replace all instances of "'" with '&apos;'
/// Replace all instances of '<' with '&lt;'
/// Replace all instances of '>' with '&gt;'
ClientMethod sanitizeXMLString(origStr) [ Language = javascript ]
{
	if (!origStr || !(origStr.split)) return(origStr)
	var str = origStr.split("&").join('&amp;');
	str = str.split('"').join('&quot;');
	str = str.split("'").join('&apos;');
	str = str.split("<").join('&lt;');
	str = str.split(">").join('&gt;');
	return(str);
}

/// un-escape an XML string previously encoded with sanitize XMLString
ClientMethod humanizeXMLString(origStr) [ Language = javascript ]
{
	if (!origStr || !(origStr.split)) return(origStr)
	var str = origStr.split('&gt;').join(">");
	str = str.split('&lt;').join("<");
	str = str.split('&apos;').join("'");
	str = str.split('&quot;').join('"');
	str = str.split('&amp;').join('&');
	return(str);
}

ClientMethod exportAsXML(jsonOnly) [ Language = javascript ]
{
	var m = this.jsModel;
	var ts = this.GetTimeStampInfo();
	ts = ts.split('|');;
	var s=[];
	// Create Header section
	s.push('<?xml version="1.0" encoding="UTF-8"?>');
	s.push('<Export generator="Cache" version="24" zv="'+ts[0]+'" ts="'+ts[1]+'">');
	s.push('<Class name="'+this.getReportSystemName()+'">');
	s.push('<Description>');
	s.push(this.sanitizeXMLString(m["desc"])+'</Description>');
	s.push('<Super>'+this.getReportSuperClass()+'</Super>');
	s.push('<TimeChanged>'+ts[2]+'</TimeChanged>');
	s.push('<TimeCreated>'+ts[2]+'</TimeCreated>');

	if (m.appName && m.appName.length>0 && !jsonOnly) { 
		s.push('<Parameter name="APPLICATION">');
		s.push('<Default>'+m.appName+'</Default>');
		s.push('</Parameter>');
	}

	// Create Property section
	if (m.prop && !jsonOnly) {  //DCRs
		for (var i=0;i<m.prop.length;i++) {
			var p = m.prop[i];
			s.push('<Property name="'+this.sanitizeXMLString(p.n)+'">');
			s.push('<Description>');
			s.push(this.sanitizeXMLString(p.d)+'</Description>');
			s.push('<Type>'+p.t+'</Type>');			
			if (p.i) {
				var ie = p.i;
				if (ie.charAt(0)=='{' && ie.charAt(ie.length-1)=='}') {
					ie = ie.substring(1,ie.length-1);
					s.push('<InitialExpression>'+this.sanitizeXMLString(ie)+'</InitialExpression>');
				}
				else {
					s.push('<InitialExpression>"'+this.sanitizeXMLString(ie)+'"</InitialExpression>');
				}
			}
			if (p.z) s.push('<Parameter name="ZENURL" value="'+p.z+'"/>');
			if (p.p) {
				for (var j=0;j<p.p.length;j++) {
					var n = p.p[j];
					s.push('<Parameter name="'+this.sanitizeXMLString(n.n)+'" value="'+this.sanitizeXMLString(n.v)+'"/>');
				}
			}
			s.push('</Property>');
		}
	}

	if (m.queryInfo && m.queryInfo.QPARMS) {  // SQLDSS
		for (var i=0;i<m.queryInfo.QPARMS.length;i++) {
			var p = m.queryInfo.QPARMS[i];
			s.push('<Property name="'+this.sanitizeXMLString(p.pName)+'">');
			s.push('<Description>');
			s.push(this.sanitizeXMLString(p.pDesc)+'</Description>');
			s.push('<Type>'+p.pType+'</Type>');
			if (p.pDefault) {
				var ie = p.Default;
				if (ie.charAt(0)=='{' && ie.charAt(ie.length-1)=='}') {
					ie = ie.substring(1,ie.length-1);
					s.push('<InitialExpression>'+this.sanitizeXMLString(ie)+'</InitialExpression>');
				}
				else {
					s.push('<InitialExpression>"'+this.sanitizeXMLString(ie)+'"</InitialExpression>');
				}
			}
			s.push('<Parameter name="ZENURL" value="'+this.sanitizeXMLString(p.pURL)+'"/>');
			if (p.pParam) {
				for (var j=0;j<p.pParam.length;j++) {
					var n = p.pParam[j];
					s.push('<Parameter name="'+this.sanitizeXMLString(n.n)+'" value="'+this.sanitizeXMLString(n.v)+'"/>');
				}
			}
			s.push('</Property>');
		}
	}

	// more boilerplate
	s.push('<Parameter name="DEFAULTMODE">');
	s.push('<Default>'+this.getReportOutputMode()+'</Default>');
	s.push('</Parameter>');
	s.push('<Parameter name="XSLTMODE">');
	s.push('<Default>server</Default>');
	s.push('</Parameter>');
	
	if (m.type=="DPR") {
		s.push('<Parameter name="DSSHOME">');
		s.push('<Default>'+this.sanitizeXMLString(m.dssHome)+'</Default>');
		s.push('</Parameter>');
		s.push('<Parameter name="DSSCLASS">');
		s.push('<Default>'+this.sanitizeXMLString(m.dssClass)+'</Default>');
		s.push('</Parameter>');
	}
	
	if (m.dataSource) {
		src.push('<Parameter name="DATASOURCE">');
		src.push('<Default>'+this.sanitizeXMLString(dataSource)+'</Default>');
		src.push('</Parameter>');
	}
	
	if (m.type=="DCR") {
		// Create the DCR section
		s.push('<XData name="ReportDCR">');
		s.push('<Data><![CDATA[');
		s.push('<reportDCR>');
		s.push('<![CDATA[');
		s.push(ESVG.jsonEncode(m));
		s.push(']]]]><![CDATA[></reportDCR>');
		s.push(']]></Data>');
		s.push('</XData>');
	}
	
	if (m.type=="DCR" || m.type=="DSS" || m.type=="SQLDSS") {
		// Create the DSS section
		s.push('<XData name="ReportDSS">');
		s.push('<Data><![CDATA[');
		s.push('<reportDSS>');
		s.push('<![CDATA[');
		if (m.type=="DCR") s.push(ESVG.jsonEncode(this.convertDCRToDSS(m.sysName,m.tree)));
		else s.push(ESVG.jsonEncode(this.encodeDSSNode(m.dss)));
		s.push(']]]]><![CDATA[></reportDSS>');
		s.push(']]></Data>');
		s.push('</XData>');
	}
	
	if (m.type=="DPR") {
		// Create the DPS section
		s.push('<XData name="ReportModel">');
		s.push('<Data><![CDATA[');
		s.push('<reportModel>');
		s.push('<![CDATA[');
		var tmpMeth = m.meth; // Don't export DPR methods as JSON
		delete m.meth; 
		s.push(ESVG.jsonEncode(m));
		m.meth = tmpMeth;
		s.push(']]]]><![CDATA[></reportModel>');
		s.push(']]></Data>');
		s.push('</XData>');
	}

	if (m.type=="SQLDSS") {
		// Create the SQLDSS Query Interface section
		s.push('<XData name="QueryInterfaceModel">');
		s.push('<Data><![CDATA[');
		s.push('<qiModel>');
		s.push('<![CDATA[');
		
		var newM = {};
		newM.headerInfo = {}
		if (m.pkgName) newM.headerInfo.package=m.pkgName;
		if (m.clsName) newM.headerInfo.objClass=m.clsName;
		if (m.appName) newM.headerInfo.appName=m.appName;
		if (m.pkgName && m.clsName) newM.headerInfo.sysName=m.pkgName+"."+m.clsName;
		if (m.rptName) newM.headerInfo.name=m.rptName;
		if (m.desc) newM.headerInfo.desc=m.desc;
		newM.headerInfo.type="SQLDSS";
		if (m.dataSrc) newM.headerInfo.dataSrc=m.dataSrc;
		
		for (p in m.queryInfo) newM[p]=m.queryInfo[p];

		s.push(ESVG.jsonEncode(newM));
		s.push(']]]]><![CDATA[></qiModel>');
		s.push(']]></Data>');
		s.push('</XData>');
	}
	
	// Render ReportDefinition Section
	if (m.type == "DCR") {
		s.push('<XData name="ReportDefinition">');
		s.push('<Description>');
		s.push('XML that defines the contents of this report.</Description>');
		s.push('<XMLNamespace>http://www.intersystems.com/zen/report/definition</XMLNamespace>');
		s.push('<Data><![CDATA[');
		s.push('<report xmlns="http://www.intersystems.com/zen/report/definition"');
		var iName = m.objClass+"Data";
		if (iName.indexOf('.')>0) iName = iName.substring(m.name.lastIndexOf('.')+1);
		s.push('name="'+iName+'"');
		s.push("sql='SELECT "+this.sanitizeXMLString(m.sql.fld.join(',')));

		s.push('\tFROM '+this.sanitizeXMLString(m.sql.src));
		if (m.sql.w && m.sql.w.length>0) {
			var whereClause = m.sql.w.split('"'); // double up any stray string delimiters
			whereClause = whereClause.join('""');
			s.push('\tWHERE '+this.sanitizeXMLString(whereClause));
		}
		if (m.sql.ob && m.sql.ob.length>0) {
			var ob = m.sql.ob;
			var obl = ob.length;
			var obf = [];
			for (var i=0;i<obl;i++) {
				obf[i] = ob[i].split('->').join('_'); 
			}
			s.push('\tORDER BY '+this.sanitizeXMLString(obf.join(',')));
		}
		s.push("'>");
		if (m.sql.p) {
			for (var i=0;i<m.sql.p.length;i++) {
				s.push('<parameter expression="'+this.sanitizeXMLString(m.sql.p[i])+'"/>');
			}
		}

		if (!jsonOnly) {
			for (var i=0;i<m.tree.k.length;i++) {
				 var str=this.exportReportDef(m.tree.k[i]);
					s.push(str);
			}		
		}
	
		s.push('</report>');
		s.push(']]></Data>');
		s.push('</XData>');
	}
	
	if (m.type=="SQLDSS") { // render the report definition pretty much as is
		s.push('<XData name="ReportDefinition">');
		s.push('<Description>');
		s.push('XML that defines the contents of this report.</Description>');
		s.push('<XMLNamespace>http://www.intersystems.com/zen/report/definition</XMLNamespace>');
		s.push('<Data><![CDATA[');
		if (m.reportDef) s.push(m.reportDef);
		s.push(']]></Data>');
		s.push('</XData>');		
	}
	
	if (m.type=="DPR") {
		var data = this.zrsBody;
		s.push('<XData name="ReportDisplay">');
		s.push('<XMLNamespace>http://www.intersystems.com/zen/report/display</XMLNamespace>');
		s.push('<Data>');
		s.push('<![CDATA[');
		s.push('<report xmlns="http://www.intersystems.com/zen/report/display"');
		s.push('name="'+this.sanitizeXMLString(m.dssName)+'">');
		
		for (var i=0;i<data.length;i++) {
			if (data[i]==']]>') s.push(']]]]><![CDATA[>');
			else s.push(data[i]);
		}
		
		s.push('</report>');
		s.push(']]></Data>');
		s.push('</XData>');
	}

	// Render Methods
	if (m.meth && !jsonOnly) {
		var l = m.meth.length;
		for (var i=0;i<l;i++) {
			n=m.meth[i];
			s.push('<Method name="'+this.sanitizeXMLString(n.n)+'">');
			if (!n.d) n.d="";
			s.push('<Description>');
			s.push(this.sanitizeXMLString(n.d)+'</Description>');
			if (n.a) {
				var spec = "";
				for (var j=0;j<n.a.length;j++) {
					if (j>0) spec+=',';
					var a=n.a[j];
					spec+=a.n
					if (a.t && a.t.length>0) spec+=':'+a.t;
					if (a.d) spec+='='+a.d;
				}
				s.push('<FormalSpec><![CDATA['+spec+']]></FormalSpec>');
			}
			if (n.t && n.t.length>0) s.push('<ReturnType>'+this.sanitizeXMLString(n.t)+'</ReturnType>');
			if (n.b && n.b.length>0) {
				s.push('<Implementation><![CDATA[');
				var q=n.b.split('\\n');
				q = q.join('\n');
				q = q.split('\\t');
				q = q.join('\t');
				s.push(q);
				s.push(']]></Implementation>');
			}
			s.push('</Method>');
		}
	}
	s.push('</Class>');
	s.push('</Export>');
	return(s);
}

/* EXPORT TO FILE UTILITIES */
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

ClientMethod exportXMLtoFile(name) [ Language = javascript ]
{
	var maxData = 4000;
	if (zenIsIE) maxData = 2000;

	var fileName=this.makeXMLFileName(name);
	var src = this.exportAsXML(0);
	// At this point the full source should be in 'source'
	var obj = new zenProxy();
	var part = 1;
	var s=""
	for (var i=0;i<src.length;i++) {
		var nxtLine = src[i];
		if (nxtLine) {
			if (s.length+nxtLine.length<maxData) {
				s+=nxtLine+"\r\n";
			}
			else {
				obj.part = part++;
				obj.code = s;
				var well = this.ReceiveFragment(fileName,obj);
				s=nxtLine+"\r\n";
			}
		}
	}
	obj.part = part++;
	obj.code = s;
	var well = this.ReceiveFragment(fileName,obj);
	return(fileName);
}

}
