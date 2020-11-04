Include (%ZEN.Utils, %MojoVersion, %occErrors)

/// Utility methods used by Zen Mojo.
Class %ZEN.Mojo.Utils Extends %RegisteredObject [ System = 2 ]
{

Parameter DOMAIN = "%ZEN";

ClassMethod GetZenMojoVersion() As %String
{
	quit $$$ZenMojoMajorVersion _ "." _ $$$ZenMojoMinorVersion _ "." _ $$$ZenMojoBuildVersion
}

/// Prints all Zen Mojo version strings on the current device.
ClassMethod %PrintVersion() As %Status
{
	
	#dim tStatement As %SQL.Statement
	#dim tRS As %SQL.StatementResult
	#dim tSC As %Status = $$$OK
	#dim documentationVersion As %String = ""
	
	w !, "Zen Mojo version " _ ..GetZenMojoVersion(),!
	
	w !, "Page Managers",!
	
	// Get Page Manager Version
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare("SELECT parent,InitialExpression As version FROM %Dictionary.CompiledProperty WHERE Name = 'version' AND parent->Super = '%ZEN.Mojo.Plugin.basePageManager'")
	if $$$ISERR(tSC) Quit tSC
	
	set tRS = statement.%Execute()
	
	while tRS.%Next() {
	
		w !, tRS.%Get("version") _ " : " _ tRS.%Get("parent")
		
	}
	
	w !,!, "Helper Plugins",!
	
	// Get Helper Plugin Version
	set statement = ##class(%SQL.Statement).%New()
	set tSC = statement.%Prepare("SELECT parent,InitialExpression As version FROM %Dictionary.CompiledProperty WHERE Name = 'version' AND parent->Super = '%ZEN.Mojo.Plugin.baseHelperPlugin'")
	if $$$ISERR(tSC) Quit $$$OK
	
	set tRS = statement.%Execute()
	
	while tRS.%Next() {
	
		w !, tRS.%Get("version") _ " : " _ tRS.%Get("parent")
		
	}
	
	try {
		
		set documentationVersion = ##class(%ZEN.Mojo.PluginDocumentation.Application).#VERSION
		
		w !,!, "Plugin Documentation installed: "_ documentationVersion
		
	} catch e {
		
		w !,!, "Plugin Documentation not installed."
		
	}
	
	
	quit tSC
}

/// Prepare and execute an SQL query and place the results 
/// into a collection of objects for JSON transport.<br/>
/// Note: Replace this when we have the ability to "flow" json output into the normal
/// output stream.
ClassMethod %GetObjectsForSQL(pSQL As %String, Output pList As %Library.ListOfObjects, pMaxRows As %Integer = 100, Output pRowCount As %String, pIncludeEmpty As %Boolean = 0, pSelectMode As %Integer = 1, pArgs...) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pRowCount = 0
		Set pList = ##class(%Library.ListOfObjects).%New()

		Set tStatement = ##class(%SQL.Statement).%New()
		Set tStatement.%SelectMode = pSelectMode

		Set tSC = tStatement.%Prepare(pSQL)
		If $$$ISERR(tSC) Quit

		Set tRS = tStatement.%Execute(pArgs...)

		// get col names
		Set tMetadata = tRS.%GetMetaData()
		Set tColumnMeta = tMetadata.columns
		Set tColCount = tColumnMeta.Count()
		For c = 1:1:tColCount {
			Set tColInfo = tColumnMeta.GetAt(c)
			Set tColName(c) = tColInfo.colName
		}

		If (pIncludeEmpty) {
			Set tEmptyItem = ##class(%ZEN.proxyObject).%New()
			Do pList.Insert(tEmptyItem)
			For i = 1:1:tColCount {
				Set $property(tEmptyItem,tColName(i)) = ""
			}
			Set pRowCount = pRowCount + 1
		}

		While (tRS.%Next(.tSC)) {
			If $$$ISERR(tSC) Quit
 			If (pMaxRows) && (pRowCount >= pMaxRows) {
	 			Set pRowCount = pRowCount _ "+"
	 			Quit
 			}
 			Set pRowCount = pRowCount + 1

			Set tRecord = ##class(%ZEN.proxyObject).%New()
			Do pList.Insert(tRecord)

			For c = 1:1:tColCount {
				Set $property(tRecord,tColName(c)) = tRS.%GetData(c)
			}
		}
		If $$$ISOK(tSC) && (tRS.%SQLCODE '= 0) && (tRS.%SQLCODE '= 100) {
			Set tSC = $$$ERROR($$$SQLCode,tRS.%SQLCODE,tRS.%Message)
			Quit
		}
	}
	Catch(ex) {
		Set pList = ""
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

/// Helper method to execute an SQL statement and convert it to a list of proxy objects.
ClassMethod %SQLToProxy(pSQL As %String, Output pObject As %ZEN.proxyObject, pIncludeEmpty As %Boolean = 0, pArgs...) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pObject = ##class(%ZEN.proxyObject).%New()
		
		Set tSC = ..%GetObjectsForSQL(pSQL,.tChildren,0,,pIncludeEmpty,,pArgs...)
		If $$$ISERR(tSC) Quit

		Set tChildren = $select($IsObject($get(tChildren)): tChildren, 1: ##class(%ListOfObjects).%New())
		Set pObject.children = tChildren
		Set pObject.rowCount = tChildren.Count()
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Creates an offline html version of a Zen Mojo page
/// pClassName: Classname of the Zen Mojo page.
/// 				Includes package name, excludes extension.
/// pFileName:	Returns the name of the file that gets generated
/// pVerbose:	Writes information to the current device if true
ClassMethod CreateOfflinePage(pClassName As %String, ByRef pFileName As %String = "", pVerbose As %Boolean = 1) As %Status
{
	
	#Dim io,tSC,tErrorCount,openedFile
	#Dim tDir,tHTMLFile,tFilename,encoding,tPackage
	#Dim e As %Exception.AbstractException
	
	Set io = $IO
	Set tSC = $$$OK
	Set tErrorCount = 0
	Set tHTMLFile = ""
	Set openedFile = 0

	try {

		// not using star syntax to support older versions
		if ($EXTRACT(pClassName,$L(pClassName)-3,$L(pClassName))=".cls") {
			// remove the class extension
			set pClassName = $EXTRACT(pClassName,0,$L(pClassName)-4)
		}

		if (##class(%Dictionary.CompiledClass).%ExistsId(pClassName) '= 1) {
			// class does not exist
			Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$ClassDoesNotExist,pClassName))
		}

		Set tPackage = $P(pClassName,".",1,$L(pClassName,".")-1)
		Set tDir = ##class(%ZEN.Utils).%GetPhysicalIncludeDirectory(tPackage,.tSC)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus(tSC)
		Set tDir = ##class(%File).NormalizeDirectory(tDir)

		set tFilename = pClassName

		If (tFilename="") {
			Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Invalid or missing file name"))
		}

		Set tHTMLFile = tDir_tFilename_".html"
		
		Open tHTMLFile:"WNS":0 Else  Throw $$$ERROR($$$FileCanNotOpen,tHTMLFile)
		set openedFile = 1
		
		Use io
		
		#; prefix
		Use tHTMLFile
		
		#; fake the session and csp stuff for now
		set %session = ##class(%CSP.Session).%New($Random(9999999999))
		set %session.AppTimeout = 60*15
		set %request = ##class(%CSP.Request).%New()
		set %response = ##class(%CSP.Response).%New()
		
		do ##class(%ZEN.Controller).%Cleanup()
		
		set page = $zobjclassmethod(pClassName,"%CreatePage")
		if ('$ISO(page)) {
			Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unable to create page " _ pClassName))
		}
		set %page = page
		
		do %page.%OnAfterCreatePage()
		
		#; materialize any composite elements on this page
		If $D(%page.%CompositeList) {
			Set tSC = ##class(%ZEN.Controller).%MaterializeComposites()
			If $$$ISERR(tSC) {
				Set %page.error = $system.Status.GetErrorText(tSC)
				Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
			}
		}
		
		#; see if we need to call any %OnAfterAddToPage callbacks
		If $D(%page.%NotifyList) {
			Set tSC = ##class(%ZEN.Controller).%NotifyComponents()
			If $$$ISERR(tSC) {
				Set %page.error = $system.Status.GetErrorText(tSC)
				Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
			}
		}
		
		do %page.%DrawHTMLPage(1)
		kill %page
		
		kill %session
		kill %request
		kill %response
		
		#; ending
		Use io
		If ($G(encoding)'="") {
			$$$SETIO(encoding)
			Kill encoding
		}
		
		Close:(tHTMLFile'="") tHTMLFile
		
		set pFileName = tHTMLFile
		w:pVerbose !,"Generated file: " _tHTMLFile,!
	
	} catch e {
		Use io
		If $G(encoding)'="" {
			$$$SETIO(encoding)
		}
		if (openedFile) {
			Close:(tHTMLFile'="") tHTMLFile
		}
		set tSC = e.AsStatus()
	}
	
	Quit tSC
}

ClassMethod %CreateLocalizationFiles(pPageClass As %Dictionary.CacheClassname = "", pOutputDirectory As %String = "", pLanguages As %List = "", pFlags As %String = "", pFile As %String = "", ByRef pGet As %Boolean = 0) As %Status
{
	Set tStatus = $$$OK
	Try {
		Set tRef = ""
		If (pPageClass = "") || '$$$comClassDefined(pPageClass) {
			Set tStatus = $$$ERROR($$$ClassDoesNotExist,pPageClass)
			Quit
		}
		If '$classmethod(pPageClass,"%Extends","%ZEN.Mojo.abstractPage") {
			Set tStatus = $$$ERROR($$$GeneralError,"Must be a subclass of %ZEN.Mojo.abstractPage")
			Quit
		}
		Set tStatus = $$$qualifierParse("Compiler",.pFlags,.qstruct)
		If $$$ISERR(tStatus) {
			Quit
		}

		New %session, %request, %response, %page, %application

		Set %session = ##class(%CSP.Session).%New($Random(9999999999))
		Set %session.AppTimeout = 60*15
		Set %request = ##class(%CSP.Request).%New()
		Set %response = ##class(%CSP.Response).%New()

		Set tPage = $classmethod(pPageClass,"%CreatePage")

		Set tClasses(pPageClass) = ""
		If $IsObject($get(%application)) {
			Set tClasses($classname(%application)) = ""
		}

		If 'tPage.templateDispatchMode {
			#; add initial template
			if (tPage.#TEMPLATECLASS '= "") { 
				set tClasses(tPage.#TEMPLATECLASS) = ""
			}

			#; Find templates via page callbacks
			Set tStatus = tPage.%OnGetTemplateList(.tTemplates,1)
			If $$$ISERR(tStatus) {
				Quit
			}

			Set tKey = ""
			For {
				Set tKey = $order(tTemplates(tKey),1,tTemplateInfo)
				If (tKey = "") {
					Quit
				}
				Set tClass = $LG(tTemplateInfo,2)
				If (tClass '= "") {
					Set tClasses(tClass) = ""
				}
			}

			Set tStatus = tPage.%OnGetSubtemplateList(.tSubTemplates,1)
			If $$$ISERR(tStatus) {
				Quit
			}

			Set tKey = ""
			For {
				Set tKey = $order(tSubTemplates(tKey),1,tSubTemplateInfo)
				If (tKey = "") {
					Quit
				}
				Set tClass = $LG(tSubTemplateInfo,2)
				If (tClass '= "") {
					Set tClasses(tClass) = ""
				}
			}
		}
		Else {
			Set tBaseTemplateXMLNamespace = tPage.templateDispatchBaseNamespace
			If (tBaseTemplateXMLNamespace = "") && (pFile = "") && $$$qualifierGetValue(qstruct,"displaylog") {
				Write !,$$$FormatText($$$Text("Could not identify templateDispatchNamespace for page '%1'"),pPageClass)
			}
			Else {
				If ($extract(tBaseTemplateXMLNamespace,*) '= "/") {
					Set tBaseTemplateXMLNamespace = tBaseTemplateXMLNamespace _ "/"
				}
				Set tXMLExtensions = tPage.#PROVIDERLIST _ ",events"
				For i=1:1:$length(tXMLExtensions,",") {
					Set tXMLExtension = $piece(tXMLExtensions,",",i)
					If (tXMLExtension = "") {
						Continue
					}
					Set tXMLExtensionNamespace = tBaseTemplateXMLNamespace _ tXMLExtension
					Set tClass = ""
					For {
						Set tClass = $order(^oddXML("-ns",tXMLExtensionNamespace,tClass))
						If (tClass = "") {
							Quit
						}
						Set tClasses(tClass) = ""
					}
				}
			}
		}

		Set tRef = $increment(^||ISC.ZenMojo.JSStrings)

		Set tClass = ""
		For {
			Set tClass = $order(tClasses(tClass))
			If (tClass = "") {
				Quit
			}
			#; Ensure the class exists, has been compiled, and supports localization
			If ##class(%Dictionary.CompiledClass).%ExistsId(tClass) && $classmethod(tClass,"%Extends","%ZEN.Mojo.localizableObject") {
				Set tStatus = $classmethod(tClass,"%GetMojoJSStrings",tRef)
				If $$$ISERR(tStatus) {
					Quit
				}
			}
		}
		If $$$ISERR(tStatus) {
			Quit
		}

		If $LV(pLanguages) && $LL(pLanguages) {
			For i=1:1:$LL(pLanguages) {
				Set tLanguage = $LG(pLanguages,i)
				If (tLanguage '= "") {
					Set tLanguages(tLanguage) = ""
				}
			}
		}
		Else {
			Set tDomain = ""
			For {
				Set tDomain = $order(^||ISC.ZenMojo.JSStrings(tRef,"txt",tDomain))
				If (tDomain = "") {
					Quit
				}
				Set tLanguageData = ##class(%Library.MessageDictionary).GetLanguages(tDomain)
				For i=1:1:tLanguageData.Count() {
					Set tLanguage = tLanguageData.GetAt(i)
					If (tLanguage '= "") {
						Set tLanguages(tLanguage) = ""
					}
				}
			}
		}

		If '$data(tLanguages) {
			If $$$qualifierGetValue(qstruct,"displaylog") && (pFile = "") {
				Write !,$$$Text("Not generating localization files as no languages were detected")
			}
			Quit
		}

		Set tPackage = $piece(pPageClass,".",1,$length(pPageClass,".")-1)
		Set tURL = ""
		Set tDirectory = ##class(%ZEN.Utils).%GetPhysicalIncludeDirectory(tPackage,.tStatus,.tURL)
		If $$$ISERR(tStatus) {
			Quit
		}
		If (tDirectory = "") {
			If $$$qualifierGetValue(qstruct,"displaylog") && (pFile = "") {
				Write !,$$$Text("Not generating localization files as output directory couldn't be determined")
			}
			Quit
		}

		Set tDisplayLog = $$$qualifierGetValue(qstruct,"displaylog")
		Set tFiles = ""
		Set tLanguage = ""
		For {
			Set tLanguage = $order(tLanguages(tLanguage))
			If (tLanguage = "") {
				Quit
			}

			Set tFilename = ..%GetLocalizationFilename(pPageClass,tLanguage,tDirectory)
			If ( pFile = "") {
				Set tStatus = ..%WriteLocalizationFile(pPageClass,tFilename,tLanguage,tRef,tDisplayLog)
				If $$$ISERR(tStatus) {
					Quit
				}
				Set tFiles = tFiles _ $listbuild("*/" _ $piece(tFilename,tDirectory,2))
			}
			Else {
				If (tFilename [ pFile) {
					Set pGet = 1
					Quit
				}
			}

		}
		If (tURL '= "") && $listlength(tFiles) {
			Set tClearStatus = ##class(%CSP.Routine).ClearGatewayCache(tURL _ "/file.js",tFiles)
			If $$$ISERR(tClearStatus) {
				Set tStatus = $$$ADDSC(tStatus,tClearStatus)
			}
		}
		If $$$ISERR(tStatus) {
			Quit
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $get(tRef) {
		Kill ^||ISC.ZenMojo.JSStrings(tRef)
	}
	Quit tStatus
}

ClassMethod %GetLocalizationFilename(pPageClass As %Dictionary.CacheClassname = "", pLanguage As %String = "en", pDirectory As %String = {$select($get(pPageClass)'="": ##class(%ZEN.Utils).%GetPhysicalIncludeDirectory($piece(pPageClass,".",1,$length(pPageClass,"."))), 1: "")}) As %String
{
	If (pPageClass = "") {
		Quit ""
	}
	Set tFilename = $translate(pPageClass,"%.","__")_"__"_$translate($zconvert(pLanguage,"L"),"%.-","___")_".js"
	If (pDirectory '= "") {
		Set tFilename = ##class(%Library.File).NormalizeFilename(tFilename,pDirectory)
	}
	Quit tFilename
}

ClassMethod %WriteLocalizationFile(pClassname As %Dictionary.CacheClassname, pFilename As %String, pLanguage As %String, pRef As %Integer, pVerbose As %Boolean = 0) As %Status [ Private ]
{
	Set tStatus = $$$OK
	Try {
		
		If pVerbose {
			Write !,$$$FormatText($$$Text("Generating localization for language '%1' in file '%2'"),pLanguage,pFilename)
		}
		
		Set tStream = ##class(%Stream.FileCharacter).%New()
		Set tStatus = tStream.LinkToFile(pFilename)
		If $$$ISERR(tStatus) Quit

		Set tStatus = tStream.TranslateTableSet("UTF8")
		If $$$ISERR(tStatus) Quit
		Set tStream.LineTerminator = $char(10)
		// Write BOM to give browsers an explicit indication of UTF-8 encoding
		Set tStream.BOM = $char(239,187,191)

		Set tStatus = tStream.WriteLine()
		If $$$ISERR(tStatus) Quit
		Set tStatus = tStream.WriteLine("/* Localization in "_pLanguage_" for "_pClassname_" */")
		If $$$ISERR(tStatus) Quit
		Set tStatus = tStream.WriteLine()
		If $$$ISERR(tStatus) Quit
		Set tStatus = tStream.WriteLine("if (!window._zenTEXT) { window._zenTEXT = {}; }")
		If $$$ISERR(tStatus) Quit
		Set tStatus = tStream.WriteLine()
		If $$$ISERR(tStatus) Quit

		Set tDomain = ""
		For {
			Set tDomain = $order(^||ISC.ZenMojo.JSStrings(pRef,"txt",tDomain))
			If (tDomain = "") Quit
			Set tIsPercentDomain = ($extract(tDomain,1) = "%")
			Set tTextID = ""
			For {
				Set tTextID = $order(^||ISC.ZenMojo.JSStrings(pRef,"txt",tDomain,tTextID),1,tTextData)
				If (tTextID = "") Quit
				Set tText = $LG(tTextData)
				Set tLocText = $select(tIsPercentDomain: $get(^%qCacheMsg(tDomain,pLanguage,tTextID),tText), 1: $get(^CacheMsg(tDomain,pLanguage,tTextID),tText))
				Set tStatus = tStream.WriteLine("window._zenTEXT['"_$zconvert(tDomain,"O","JS")_"\/"_$zconvert(tText,"O","JS")_"']='"_$zconvert(tLocText,"O","JS")_"';")
				If $$$ISERR(tStatus) Quit
			}
			If $$$ISERR(tStatus) Quit
		}
		If $$$ISERR(tStatus) Quit
		
		Set tStatus = tStream.%Save()
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

/// Returns a list of include files (CSS and JS files) which are required by a Zen Mojo page.
ClassMethod GetIncludeFiles(pClassName As %String, ByRef pIncludeFiles As %ListOfDataTypes) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	#dim %page As %ZEN.Mojo.basePage
	
	try {
		
		set pIncludeFiles = ##class(%Library.ListOfDataTypes).%New()
		
		#; fake the session and csp stuff for now
		set %session = ##class(%CSP.Session).%New($Random(9999999999))
		set %session.AppTimeout = 60*15
		set %request = ##class(%CSP.Request).%New()
		set %response = ##class(%CSP.Response).%New()
		
		do ##class(%ZEN.Controller).%Cleanup()
		
		set page = $zobjclassmethod(pClassName,"%CreatePage")
		if ('$ISO(page)) {
			Throw $$$ERROR($$$GeneralError,"Unable to create page " _ pClassName)
		}
		set %page = page
		
		do %page.%OnAfterCreatePage()
		
		Set tSC = ##class(%ZEN.Controller).%MaterializeComposites()
		
		#; directory containing user generated js/css files (if any)
		If ((%page.%UserPackageList'="")||(%page.UserSVGPackageList'="")) {
			Set tUserDir = $$getDefaultApp^%SYS.cspServer2($ZU(5)) _ "/"
		}
		
		#; Get CSS level
		Do %page.%DetermineCSSLevel()
		
		If ('+%page.#INLINESVG) {
			do pIncludeFiles.Insert("ZEN_SVGComponent.css")
		}
		
		#; assemble list of *modules* by walking the list of component classes
		Kill tModules
		Set tDepth = $O(%page.%ComponentClasses(""))
		While (tDepth '= "") {
			Set tClass = $O(%page.%ComponentClasses(tDepth,""))
			While (tClass '= "") {
				Do $zobjclassmethod(tClass,"%GetIncludeInfo",.tModules,,,.tInline)
				If (tInline) {
					// mark class as inline
					Set %page.%ComponentClasses(tDepth,tClass) = tInline
				}

				If ('%page.%ComponentClasses(tDepth,tClass)) {
					#; get include files for this component
					#; list will be in %zenIncludeJS and %zenIncludeCSS
					#; n.b., component imports and includes should be handled by %GetIncludeFiles
					Do $zobjclassmethod(tClass,"%GetIncludeFiles","HTML")
				}

				Set tClass = $O(%page.%ComponentClasses(tDepth,tClass))
			}
			Set tDepth = $O(%page.%ComponentClasses(tDepth))
		}
		
		#; walk over include list
		#; %zenIncludeCSS is indexed by depth,order,pkg,filename.

		Kill tVisited
		Set tDepth = $O(%zenIncludeCSS(""))
		While (tDepth'="") {
			Set tOrder = $O(%zenIncludeCSS(tDepth,""))
			While (tOrder'="") {
				Set tPkg = $O(%zenIncludeCSS(tDepth,tOrder,""))
				While (tPkg'="") {
					Set tFile = $O(%zenIncludeCSS(tDepth,tOrder,tPkg,""))
					While (tFile'="") {
						If ('$D(tVisited(tFile))) {
							Set tVisited(tFile) = ""
							// .cssx files have to be renamed as .css2 or .css3 as appropriate
							Set tExt = $P(tFile,".",$L(tFile,"."))
							If (tExt="cssx") {
								Set tFile2 = $P(tFile,".",1,$L(tFile,".")-1)
								If (%page.cssLevel>=3) {
									Set tFile2 = tFile2 _ "_3.css"
								}
								Else {
									Set tFile2 = tFile2 _ ".css"
								}
								do pIncludeFiles.Insert(tFile2)
							}
							Else {
								do pIncludeFiles.Insert(tFile)
							}
						}
						Set tFile = $O(%zenIncludeCSS(tDepth,tOrder,tPkg,tFile))
					}
					Set tPkg = $O(%zenIncludeCSS(tDepth,tOrder,tPkg))
				}
				Set tOrder = $O(%zenIncludeCSS(tDepth,tOrder))
			}
			Set tDepth = $O(%zenIncludeCSS(tDepth))
		}
		
		#; inject CSS includes for USERPACKAGES
		#; (this is for backwards compatability)
		For p=1:1:$L(%page.%UserPackageList,",") {
			Set tPack = $P(%page.%UserPackageList,",",p)
			If (tPack '= "") {
				Set tFile = tUserDir _ $TR(tPack,".%","_")_".css"
				If ('$D(tVisited(tFile))) {
					Set tVisited(tFile) = ""
					do pIncludeFiles.Insert(tFile)
				}
			}
		}
		
		Set tSVGClassList = ""
		Set tDepth = $O(%page.%ComponentClasses(""))
		While (tDepth '= "") {
			Set tClass = $O(%page.%ComponentClasses(tDepth,""),1,tFlag)
			While (tClass '= "") {
				If (tClass '= $zobjclass(%page)) {
					#; skip *this* class to make sure it gets rendered last
					If (tFlag) {
						//Do $zobjclassmethod(tClass,"%DrawStyleHTML",%page.cssLevel)
					}
					If $zobjclassmethod(tClass,"%IsA","%ZEN.SVGComponent.svgComponent") {
						#; add to list of SVG classes
						Set tSVGClassList = tSVGClassList _ $S(tSVGClassList="":"",1:",") _ tClass
					}
				}
				Set tClass = $O(%page.%ComponentClasses(tDepth,tClass),1,tFlag)
			}
			Set tDepth = $O(%page.%ComponentClasses(tDepth))
		}

		#; additional CSS includes specified by the page
		#; do these *after* the application
		If ((%page.cssLevel>=3)&&(%page.#CSS3INCLUDES'="")) {
			For n = 1:1:$L(%page.#CSS3INCLUDES,",") {
				Set tFile = $P(%page.#CSS3INCLUDES,",",n)
				If (tFile '= "") {
					do pIncludeFiles.Insert(tFile)
				}
			}
		}
		Else {
			For n = 1:1:$L(%page.#CSSINCLUDES,",") {
				Set tFile = $P(%page.#CSSINCLUDES,",",n)
				If (tFile '= "") {
					do pIncludeFiles.Insert(tFile)
				}
			}
		}

		#; update SVG class list (put page class at end of list)
		Set tSVGClassList = tSVGClassList //_ $S(tSVGClassList="":"",1:",") _ $classname()
		Set %page.SVGClassList = tSVGClassList
		
		// include zenutils at top of page to simplify detection of it!
		do pIncludeFiles.Insert("zenutils.js")
		
		#; additional javascript includes
		Set tSysJSIncludes = "cspxmlhttp.js,cspbroker.js"
		If (%page.dragAndDrop) {
			#; include js for drag and drop
			Set tSysJSIncludes = tSysJSIncludes _ "," _ "zenCSLM.js"
		}
		Set tJSIncludes = %page.#JSINCLUDES

		For n = 1:1:$L(tSysJSIncludes,",") {
			Set tFile = $P(tSysJSIncludes,",",n)
			If (tFile '= "") {
				do pIncludeFiles.Insert(tFile)
			}
		}

		#; process list of js includes
		Kill tVisited
		Set tDepth = $O(%zenIncludeJS(""))
		While (tDepth'="") {
			Set tOrder = $O(%zenIncludeJS(tDepth,""))
			While (tOrder'="") {
				Set tPkg = $O(%zenIncludeJS(tDepth,tOrder,""))
				While (tPkg'="") {
					Set tFile = $O(%zenIncludeJS(tDepth,tOrder,tPkg,""))
					While (tFile'="") {
						Set tType = $LG(%zenIncludeJS(tDepth,tOrder,tPkg,tFile),1)
						If ('$D(tVisited(tFile))) {
							Set tVisited(tFile) = ""
							do pIncludeFiles.Insert(tFile)
						}
						Set tFile = $O(%zenIncludeJS(tDepth,tOrder,tPkg,tFile))
					}
					Set tPkg = $O(%zenIncludeJS(tDepth,tOrder,tPkg))
				}
				Set tOrder = $O(%zenIncludeJS(tDepth,tOrder))
			}
			Set tDepth = $O(%zenIncludeJS(tDepth))
		}

		#; inject includes for USERPACKAGES
		#; (this is for backwards compatability)
		For p=1:1:$L(%page.%UserPackageList,",") {
			Set tPack = $P(%page.%UserPackageList,",",p)
			If (tPack '= "") {
				Set tFile = tUserDir _ $TR(tPack,".%","_")_".js"
				If ('$D(tVisited(tFile))) {
					Set tVisited(tFile) = ""
					do pIncludeFiles.Insert(tFile)
				}
			}
		}
		If (%page.useSVG) {
			For p=1:1:$L(%page.UserSVGPackageList,",") {
				Set tPack = $P(%page.UserSVGPackageList,",",p)
				If (tPack '= "") {
					Set tFile = tUserDir _ $TR(tPack,".%","_")_".js"
					If ('$D(tVisited(tFile))) {
						Set tVisited(tFile) = ""
						do pIncludeFiles.Insert(tFile)
					}
				}
			}
		}

		#; write out additional script tags
		For n = 1:1:$L(tJSIncludes,",") {
			Set tFile = $P(tJSIncludes,",",n)
			If (tFile '= "") {
				do pIncludeFiles.Insert(tFile)
			}
		}
		
		#; loop over the include files and remove online references
		
		for i=1:1:pIncludeFiles.Count() {
			set temp = pIncludeFiles.GetAt(i)
			if ( $EXTRACT(temp,1,4) = "http") {
				do pIncludeFiles.RemoveAt(i)
			}
		}
		
	} catch e {
		set tSC = e.AsStatus()
	}
	Quit tSC
}

/// Packages most of the required files for a Zen Mojo application
/// and copies them into a target folder.
/// Some dependencies cannot be resolved automatically. All
/// JSINCLUDES and CSSINCLUDES the page and the application
/// include must be copied manually.
/// The same is true for any other external dependency as
/// e.g. images.
/// 
/// pClassName:		The classname of a Zen Mojo page, without extension.
/// pTargetFolder:	The target folder all files are copied to.
ClassMethod CreateOfflineBundle(pClassName As %String, pTargetFolder As %String) As %Status
{
	
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	#dim tFileName As %String = ""
	
	try {
		
		set tSC = ..CreateOfflinePage(.pClassName,.tFileName,0)
		Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unable to create offline version of " _ pClassName _ ". Error: " _ $SYSTEM.Status.GetOneStatusText(tSC)))
		
		set pTargetFolder = ##class(%File).NormalizeDirectory(pTargetFolder)
		// w "pTargetFolder: ", pTargetFolder, !
		if ('##class(%File).DirectoryExists(pTargetFolder)) {
			set tSC = ##class(%File).CreateDirectoryChain(pTargetFolder)
			Throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"The supplied target folder did not exist and there was a problem to create it: " _ pTargetFolder))
		}
		
		set status = ##class(%File).CopyFile(tFileName,pTargetFolder_pClassName_".html",1)
		if (status = 0) {
			Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unable to move file "_tFileName_" to "_pTargetFolder))
		}
		
		set tSC = ..GetIncludeFiles(pClassName,.tIncludes)
		
		set rootDir = $SYSTEM.Util.InstallDirectory()
		set rootDir = ##class(%File).NormalizeDirectory(rootDir)
		
		Set tUserDir = rootDir_"/"_$$getDefaultApp^%SYS.cspServer2($ZU(5)) _ "/"
		set brokerDir = rootDir_"/csp/broker"
		
		set tUserDir = ##class(%File).NormalizeDirectory(tUserDir)
		set brokerDir = ##class(%File).NormalizeDirectory(brokerDir)
		//w tUserDir,!
		//w brokerDir,!
		
		for i=1:1:tIncludes.Count() {
			set temp = tIncludes.GetAt(i)
			set subDir = ""
			
			// Check if there's a subfolder
			if ($LOCATE(temp,"/")>0){
				set subDir = $PIECE(temp,"/")
			}
			
			// Copy subfolder
			if (subDir '= ""){
				set tFolder = (brokerDir_subDir)
				set status = ##class(%File).CopyDir(tFolder,pTargetFolder_subDir,1)

				if ('status) {
					Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unable to move folder " _subDir_ " to "_pTargetFolder))
				}
			}
			
			else{
			
				// Start copying from broker directory
				set tFile = (brokerDir_temp)

				if (##class(%File).Exists(tFile)) {
					set status = ##class(%File).CopyFile(tFile,pTargetFolder_temp,1)
					if ('status) {
						Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unable to move file " _temp_ " to "_pTargetFolder))
					}
				}
			
				// now copy from the user directory
				set tFile = (tUserDir_temp)

				if (##class(%File).Exists(tFile)) {
					set status = ##class(%File).CopyFile(tFile,pTargetFolder_temp,1)
					if ('status) {
						Throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Unable to move file " _temp_ " to "_pTargetFolder))
					}
				}
				
			}
		}
		
	} catch e {
		set tSC = e.AsStatus()
	}
	
	Quit tSC
}

}
