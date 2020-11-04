/// This class is used internally by Cach&eacute;.<br>
/// This internal utility class provides an API for serving
/// StudioAssist Schemas (SASchema) for use by Studio.
Class %Studio.SASchemaUtil Extends %RegisteredObject [ System = 3 ]
{

Parameter DELIMITER = ":";

ClassMethod getSchemaDefinition(pSchemaNameSpace As %String, Output pOutput As %String) As %Status
{
	Kill pOutput
	Lock +^ISC.SASchema(pSchemaNameSpace):0 Else  Quit $$$OK
	Set tSC = ..loadSchema(pSchemaNameSpace,0,0,.tIsSpawned)
	If 'tIsSpawned merge pOutput=^ISC.SASchema(pSchemaNameSpace,"data")
	Lock -^ISC.SASchema(pSchemaNameSpace)
	quit tSC
}

/// return the SASchema definition to the Studio
ClassMethod getSchemaDefinitionIntoCacheTemp(pSchemaNameSpace As %String, pIndex As %String) As %Status
{
	Kill ^CacheTemp(pIndex)
	Lock +^ISC.SASchema(pSchemaNameSpace):0 Else  Quit $$$OK
	Set tSC = ..loadSchema(pSchemaNameSpace,0,0,.tIsSpawned)
	If 'tIsSpawned merge ^CacheTemp(pIndex)=^ISC.SASchema(pSchemaNameSpace,"data")
	Lock -^ISC.SASchema(pSchemaNameSpace)
	quit tSC
}

/// load the SASchema into the ^ISC.SASchema global
ClassMethod loadSchema(pSchemaNameSpace As %String, pForce As %Boolean = 0, pForeground As %Boolean = 0, ByRef pIsSpawned As %Boolean = 0) As %Status
{
	set tSC=..getSchemaMoniker(pSchemaNameSpace,.tMonikerType,.tMonikerName,.tMonikerData) if $$$ISERR(tSC) quit tSC

	if tMonikerType'="sasclass" quit $$$ERROR($$$SchemaMonikerTypeInvalid,pSchemaNameSpace,tMonikerType)
	;
	; check for global cache
	if (pForce)||('$d(^ISC.SASchema(pSchemaNameSpace))) {
		Set tIsUpToDate=0
	} else {
		set tIsUpToDate=$classmethod(tMonikerName,"IsUpToDate",$g(^ISC.SASchema(pSchemaNameSpace,"hash")),tMonikerData)
	}
	if tIsUpToDate quit $$$OK

	// call method to create schema information
	If (pForeground) {
		Set tSC = ..%GenerateSchema(pSchemaNameSpace,tMonikerName,tMonikerData)
	} Else {
		JOB ##class(%Studio.SASchemaUtil).%GenerateSchema(pSchemaNameSpace,tMonikerName,tMonikerData)
		Set pIsSpawned = 1
	}
	quit tSC
}

/// returns if the SASchema is up-to-date
ClassMethod isSchemaUpToDate(pSchemaNameSpace As %String) As %Boolean
{
	set tSC=..getSchemaMoniker(pSchemaNameSpace,.tMonikerType,.tMonikerName,.tMonikerData) if $$$ISERR(tSC) quit 0
	if tMonikerType'="sasclass" quit 0
	if '$d(^ISC.SASchema(pSchemaNameSpace)) quit 0
	quit $classmethod(tMonikerName,"IsUpToDate",$g(^ISC.SASchema(pSchemaNameSpace,"hash")),tMonikerData)
}

/// Do the actual work of generating Schema information.
ClassMethod %GenerateSchema(pSchemaNameSpace As %String, pMonikerName As %String, pMonikerData As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Lock +^ISC.SASchema(pSchemaNameSpace):10 Else  Set tSC=$$$ERROR($$$LockFailedToAcquireExclusive,$name(^ISC.SASchema(pSchemaNameSpace))) Quit
		Set tStream=##class(%GlobalCharacterStream).%New()
		Set tSC = $classmethod(pMonikerName,"OutputToStream",tStream,.tChecksum,pMonikerData)
		If $$$ISERR(tSC) Quit
		Set tSC = ..readSASchemaFromStream(tStream,pSchemaNameSpace,$g(tChecksum))
		Lock -^ISC.SASchema(pSchemaNameSpace)
	}
	Catch(ex) {
		Lock -^ISC.SASchema(pSchemaNameSpace)
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod getSchemaMoniker(pSchemaSpec As %String, Output pMonikerType, pMonikerName, pMonikerData, Output pRootClasses As %String) As %String
{
	set tMoniker=$g(^ISC.SASchema(pSchemaSpec),$g(^%ISC.SASchema(pSchemaSpec),""))
	if (tMoniker="") {
		#; JMD231
		#; if schema is not registered in the global
		#; give class-based schemas a chance to see if there is a class available

		#; loop over sub-classes of %Studio.SASchemaClass
		#; loop over pages
		Set tRS = ##class(%ResultSet).%New("%Dictionary.ClassDefinition.SubclassOf")
		Set tSC = tRS.%Execute("%Studio.SASchemaClass")
		If $$$ISERR(tSC) Quit tSC
	
		Set tFound = 0
		While (tRS.%Next(.tSC)) {
			#; Skip abstract classes
			Set tName = $G(tRS.Data("Name"))

			Set tAbstract = +$$$comClassKeyGet(tName,$$$cCLASSabstract)
			If ('tAbstract) {
				#; test XMLNAMESPACE parameter
				If (pSchemaSpec = $$$comMemberKeyGet(tName,$$$cCLASSparameter,"XMLNAMESPACE",$$$cPARAMdefault)) {
					Set tFound = 1
					Set pMonikerType = "sasclass"
					Set pMonikerName = tName
					Set pMonikerData = ""
					$$$comMemberKeyGetLvar(pRootClasses,tName,$$$cCLASSparameter,"ROOTCLASSES",$$$cPARAMdefault)
					Quit
				}
			}
		}
		If $$$ISERR(tSC) Quit tSC
		If (tFound) Quit $$$OK
		quit $$$ERROR($$$SchemaDefinitionDoesNotExist,pSchemaSpec)
	}
	set pMonikerType=$p(tMoniker,":",1),tMoniker=$p(tMoniker,":",2,999)
	set pMonikerName=$p(tMoniker,"!",1)
	set pMonikerData=$p(tMoniker,"!",2,999)
	$$$comMemberKeyGetLvar(pRootClasses,pMonikerName,$$$cCLASSparameter,"ROOTCLASSES",$$$cPARAMdefault)
	quit $$$OK
}

/// Used to return the correlated object from an Xdata block
ClassMethod returnCorrelated(xdata As %Dictionary.XDataDefinition, ByRef sc As %Status) As %RegisteredObject [ Internal ]
{
	Set sc=$$$OK
	If '$isobject(xdata) Set sc=$$$ERROR($$$GeneralError,"No XData object passed") Quit ""
	If xdata.XMLNamespace="" Set sc=$$$ERROR($$$GeneralError,"XData has no XMLNamespace") Quit ""
	Set sc=..getSchemaMoniker(xdata.XMLNamespace,,,,.rootclasses) If $$$ISERR(sc) Quit ""
	If rootclasses=""||(rootclasses'[":") Set sc=$$$ERROR($$$GeneralError,"XMLNamespace does not have ROOTCLASSES defined") Quit ""
	Set xmlreader=##class(%XML.Reader).%New()
	Set stream=xdata.Data
	If stream.Size=0 Set sc=$$$ERROR($$$GeneralError,"No contents in XData") Quit ""
	Do stream.Rewind()
	Set sc=xmlreader.OpenStream(stream) If $$$ISERR(sc) Quit ""
	For i=1:1:$length(rootclasses,",") {
		Set item=$zstrip($piece(rootclasses,",",i),"<>W") If item="" Continue
		Do xmlreader.Correlate($piece(item,":",2),$piece(item,":"))
	}
	#; there should only be one top level element defined
	Do xmlreader.Next(.obj,.sc) If $$$ISERR(sc) Quit ""
	If '$IsObject(obj) Set sc=$$$ERROR($$$GeneralError,"No top level element defined in XData block.") Quit ""
	Quit obj
}

ClassMethod readSASchemaFromStream(pStream, pSchemaNameSpace, pChecksum) As %Status
{
	do pStream.Rewind()
	; kill all the subnodes of ^ISC.SASchema
	set sub="" for  set sub=$o(^ISC.SASchema(pSchemaNameSpace,sub)) quit:sub=""  kill ^ISC.SASchema(pSchemaNameSpace,sub)
	; set each datanode to 30K
	for lineCnt=1:1 {
		quit:pStream.AtEnd
		if lineCnt=1 {
			set lineTxt="# start checksum section"_$c(13,10)_"!checksum:"_pChecksum_$c(13,10)
			set lineTxt=lineTxt_pStream.Read(30000-$l(lineTxt))
		} else {
			set lineTxt=pStream.Read(30000)
		}
		set ^ISC.SASchema(pSchemaNameSpace,"data",lineCnt)=lineTxt
	}
	set ^ISC.SASchema(pSchemaNameSpace,"data")=lineCnt-1
	; set the checksum node
	set ^ISC.SASchema(pSchemaNameSpace,"hash")=pChecksum
	quit $$$OK
}

/// Purge the cached SASchema information for the given schema namespace.
ClassMethod purge(pSchemaNameSpace As %String) As %Status
{
	if $g(pSchemaNameSpace)="" quit $$$OK
	set sub="" for  set sub=$o(^ISC.SASchema(pSchemaNameSpace,sub)) quit:sub=""  kill ^ISC.SASchema(pSchemaNameSpace,sub)
	quit $$$OK
}

/// Purge all cached SASchema information
ClassMethod purgeAll() As %Status
{
	set ns="" for  set ns=$o(^ISC.SASchema(ns)) quit:ns=""  do ..purge(ns)
	quit $$$OK
}

}
