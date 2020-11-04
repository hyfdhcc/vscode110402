Include %IKInclude

///  <p>This API groups a number of utility and maintenance operations and queries.</p>
Class %iKnow.Utils.MaintenanceAPI Extends %iKnow.Queries.AbstractAPI [ System = 4 ]
{

///  <p>Adds a string as a new entity to the domain with frequency and spread equal to 0, returning the
///  ID of the new entity. If the string already exists as an entity in the domain, this method will
///  simply return its ID.</p>
///  <p><var>pLanguage</var> is only used when this domain is enabled for stemming.</p>
///  <p>Note: This method is intended for internal use only.</p>
ClassMethod AddEntity(domainId As %Integer, value As %String, Output sc As %Status = {$$$OK}, pLanguage As %String = "en") As %Integer [ Internal ]
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
	$$$IKCHECKDOMMGRR(domainId,sc,-1)
	
	// normalize value
	set value = $$$IKNORMALIZE(value)
	
	// first check if the entity already exists
	if ($length(value)>$$$IKHASHSIZE) {
		set entUniId = "", hash = $zcrc(value,7)
		for {
			set entUniId = $order(^ISC.IK.EntUniHash(domainId, hash, entUniId))
			quit:entUniId=""
			quit:(value=^ISC.IK.EntUniId(domainId,entUniId))
		}
		set entUniId=+entUniId
	} else {
		set entUniId = +$g(^ISC.IK.EntUni(domainId, " "_value))
	}
	quit:entUniId entUniId
	
	// we should lock for LOAD, as that's the lock taken by BuildGlobals' EntUni additions
	$$$IKLOCKLOADR(domainId,sc,-1)
	
	// test again, it might have been added between the first check and the lock
	if ($length(value)>$$$IKHASHSIZE) {
		set entUniId = "", hash = $zcrc(value,7)
		for {
			set entUniId = $order(^ISC.IK.EntUniHash(domainId, hash, entUniId))
			quit:entUniId=""
			quit:(value=^ISC.IK.EntUniId(domainId,entUniId))
		}
		set entUniId=+entUniId
	} else {
		set entUniId = +$g(^ISC.IK.EntUni(domainId, " "_value))
	}
	if (entUniId) {
		$$$IKUNLOCKLOAD(domainId)
		quit entUniId
	}
	
	set tTLevel = $tlevel
	try {
		tstart
    
		set entUniId = $i(^ISC.IK.EntUniId(domainId))
		set ^ISC.IK.EntUniId(domainId, entUniId) = value
		set ^ISC.IK.EntUniDetails(domainId, entUniId) = $lb(0,0,0,0,0,0,0)
		$$$MARKDATALOADED(domainId)
		
		if ($length(value)>$$$IKHASHSIZE) {
			set ^ISC.IK.EntUniHash(domainId, $zcrc(value,7), entUniId) = ""
		} else {
			set ^ISC.IK.EntUni(domainId, " "_value) = entUniId
		}
		
		// BDB522 - update stemming data
		if $$$GETPARAMNODEF(domainId,$$$IKPSTEMMING) {
			set tLangId = $lf($$$IKLANGUAGES, pLanguage)
			if 'tLangId {
				set tSC = $$$ERROR($$$IKLanguageDoesNotExist,pLanguage)
				quit
			}
			set tStemmed = ##class(%iKnow.Queries.EntityAPI).GetBaseForm(domainId,value, pLanguage, .tSC)
			quit:$$$ISERR(tSC)
			if tStemmed=value {
				set tStemUniId = entUniId
			} else {
				set tStemUniId = ..AddEntity(domainId, tStemmed, .tSC)
				quit:$$$ISERR(tSC)
			}
			set $bit(^ISC.IK.EntUniActual(domainId,tStemUniId,entUniId),tLangId)=1
			set $bit(^ISC.IK.EntUniBase(domainId,entUniId,tStemUniId),tLangId)=1
			
			// verify if this is a new representation form
			set tCurrentRepId = $g(^ISC.IK.EntUniRep(domainId,tStemUniId,tLangId))
			if (tCurrentRepId'=tStemUniId) {
				set tCurrentRepString = ^ISC.IK.EntUniId(domainId,tCurrentRepId)
				set tCurrentDist = ##class(%iKnow.Queries.EntityAPI).GetLevenshteinDistance(tCurrentRepString,tStemmed,.tSC)
				quit:$$$ISERR(tSC)
				set tNewDist = ##class(%iKnow.Queries.EntityAPI).GetLevenshteinDistance(value,tStemmed,.tSC)
				quit:$$$ISERR(tSC)
				if (tCurrentDist > tNewDist) {
					set ^ISC.IK.EntUniRep(domainId,tStemUniId,tLangId) = entUniId
				}
			}
		}
	
		tcommit
	} catch (e) {
		set sc = e.AsStatus(), entUniId = -1
	}
	trollback:($tlevel>tTLevel) 1
		
	$$$IKUNLOCKLOAD(domainId)
	
	quit entUniId
}

// BLACKLIST API

///  <p>Create a new BlackList entry with the given name and description</p>
ClassMethod CreateBlackList(domainId As %Integer, name As %String, description As %String = "", Output sc As %Status = {$$$OK}) As %Integer
{
	quit ..CreateBlackListInternal(domainId, name, description,, .sc)
}

ClassMethod CreateBlackListInternal(domainId As %Integer, name As %String, description As %String = "", mgrClass As %String = "", Output sc As %Status = {$$$OK}) As %Integer [ Internal ]
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
		$$$IKCHECKDOMMGRR(domainId,sc,-1)
	} else {
		$$$IKXDOMBLVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKNOTNULLR(name,sc,-1)
	$$$IKCHECKSTRINGLENGTHR(name,sc,-1)
	
	// BDB397 - case insensitive names
	set tNameIndex = $s('domainId||$$$IKVERSIONATLEAST(domainId,$$$IKVERSIONCASEINSENSITIVENAMES):$$$UPPER(name), 1:name)
	$$$IKCHECKIDNOTEXISTSR(^ISC.IK.BlackList,domainId,tNameIndex,$$$IKBlackListExists,sc,-1)
	
	$$$IKLOCKR(domainId,^ISC.IK.BlackListId,sc,-1)
	
	// check again, somebody might have added a BL with this name in the meantime
	if $d(^ISC.IK.BlackList(domainId, tNameIndex)) {
		$$$IKUNLOCK(domainId,^ISC.IK.BlackListId)
		set sc = $$$ERROR($$$IKBlackListExists, name)
		quit -1
	}
	
	set tTLevel = $tlevel
	try {
		tstart
		set blackListId = $i(^ISC.IK.BlackListId(domainId))
		set ^ISC.IK.BlackListId(domainId, blackListId) = $lb(name, description, mgrClass)
		set ^ISC.IK.BlackList(domainId, tNameIndex) = blackListId
		
		// BDB386 - store version info for cross-domain blacklists
		set:'domainId ^ISC.IK.BlackListId = xDomVersion
		
		tcommit
	} catch (ex) {
		set sc = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	
	$$$IKUNLOCK(domainId,^ISC.IK.BlackListId)
	
	quit blackListId
}

Parameter DropBlackListEXP [ Internal ] = 1;

///  Drops a BlackList (entities part of the list will not be deleted from the domain)
ClassMethod DropBlackList(domainId As %Integer, blackListId As %Integer) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTS(domainId)
		$$$IKCHECKDOMMGR(domainId)
	} else {
		$$$IKXDOMBLVERSION(xDomainVersion)
	}
	$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist)
	
	// BDB386 - check blacklist manager
	set tMgrClass = $lg(details,5)
	$$$IKCHECKMGR("BlackList",blackListId,tMgrClass)
	
	$$$IKLOCK(domainId,^ISC.IK.BlackListId)
	set tTLevel = $tlevel
	try {
		tstart
		kill ^ISC.IK.BlackListElements(domainId, blackListId)
		kill ^ISC.IK.BlackList(domainId, $$$UPPER($li(details,1)))
		kill ^ISC.IK.BlackListId(domainId, blackListId)
		
		// BDB386 - if this was the last cross-domain one, drop version info
		if 'domainId && ($d(^ISC.IK.BlackListId(0))<10) {
			zkill ^ISC.IK.BlackListId
		}
		
		tcommit
	} catch (ex) {
		set sc = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	$$$IKUNLOCK(domainId,^ISC.IK.BlackListId)
	quit $$$OK
}

Parameter ClearBlackListEXP [ Internal ] = 1;

/// Clears the contents of a single BlackList.
ClassMethod ClearBlackList(pDomainId As %Integer, pBlackListId As %Integer) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTS(pDomainId)
		$$$IKCHECKDOMMGR(pDomainId)
	} else {
		$$$IKXDOMBLVERSION(xDomainVersion)
	}
	$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,pDomainId,pBlackListId,tDetails,$$$IKBlackListDoesNotExist)
	
	// BDB386 - check blacklist manager
	set tMgrClass = $lg(tDetails,5)
	$$$IKCHECKMGR("BlackList",pBlackListId,tMgrClass)
	
	kill ^ISC.IK.BlackListElements(pDomainId,pBlackListId)
	
	quit $$$OK
}

///  Finds the BlackList ID corresponding to the supplied name.
ClassMethod GetBlackListId(domainId As %Integer, name As %String, Output sc As %Status = {$$$OK}) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVREADR(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
	} else {
		$$$IKXDOMBLVERSIONR(xDomainVersion,sc,-1)
	}
	$$$IKCHECKSTRINGLENGTHR(name,sc,-1)
	
	// BDB397 - case insensitive names
	set tNameIndex = $s('domainId||$$$IKVERSIONATLEAST(domainId,$$$IKVERSIONCASEINSENSITIVENAMES):$$$UPPER(name), 1:name)
	quit $g(^ISC.IK.BlackList(domainId, tNameIndex))
}

/// Returns whether or not there are any blacklists in the domain
ClassMethod HasBlackLists(pDomainId As %Integer) As %Boolean
{
	quit ($d(^ISC.IK.BlackListId(pDomainId))>=10)
}

Parameter GetBlackListsRT = "blackListId:%Integer,name:%String,description:%String";

///  Retrieves a list of all the BlackLists registered in this domain.
ClassMethod GetBlackLists(ByRef result, domainId As %Integer, pIncludeCrossDomain As %Boolean = 0) As %Status
{
	$$$IKQBEGINTRY(result,"",tSC)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSX(domainId,tSC)
	}
    if ('domainId || pIncludeCrossDomain) {
	    $$$IKXDOMBLVERSIONX(xDomVersion,tSC)
	}
	
	set blackListId = "", i = 0
	for {
		set blackListId = $order(^ISC.IK.BlackListId(domainId, blackListId),1,d)
		quit:blackListId=""
		$$$IKQADDRESULT(result,$i(i),$lb(+blackListId) _ $li(d,1,2))
	}
	
	if (pIncludeCrossDomain && domainId) {
		set blackListId = ""
		for {
			set blackListId = $order(^ISC.IK.BlackListId(0, blackListId),1,d)
			quit:blackListId=""
			$$$IKQADDRESULT(result,$i(i),$lb(-blackListId) _ $li(d,1,2))
		}
	}
	$$$IKQENDCATCH(result,"",tSC)
}

Parameter GetBlackListElementsRT = "entUniId:%Integer,entity:%String";

///  Retrieves a list of all the strings in the specified BlackList
ClassMethod GetBlackListElements(ByRef result, domainId As %Integer, blackListId As %Integer) As %Status
{
	$$$IKQBEGINTRY(result,"",tSC)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSX(domainId,tSC)
	} else {
		$$$IKXDOMBLVERSIONX(xDomVersion,tSC)
	}
	$$$IKCHECKIDEXISTSX(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist,tSC)
	set entUniId = "", i=0
	for {
		set entUniId = $order(^ISC.IK.BlackListElements(domainId, blackListId, entUniId),1,d)
		quit:entUniId=""
		
		if (domainId) {
			$$$IKQADDRESULT(result,$i(i),$lb(+entUniId, ^ISC.IK.EntUniId(domainId, entUniId)))
		} else {
			$$$IKQADDRESULT(result,$i(i),$lb("",entUniId))
		}
	}
	$$$IKQENDCATCH(result,"",tSC)
}

/// Returns whether or not the BlackList identified by <var>blackListId</var> contains the
/// supplied entity.
ClassMethod BlacklistContainsElement(domainId As %Integer, blackListId As %Integer, entUniId As %Integer, Output pSC As %Status = {$$$OK}) As %Boolean
{
	set pSC = $$$OK
	$$$IKCHECKPRIVREADR(pSC,0)
	if (blackListId>0) {
		$$$CHECKDOMAINEXISTSR(domainId,pSC,0)
		set tDomainId = domainId
	} else {
		$$$IKXDOMBLVERSION(xDomVersion)
		set entUniId = ##class(%iKnow.Queries.EntityAPI).GetValue(domainId, entUniId)
		quit:entUniId<=0 0
		set domainId=0, blackListId=$zabs(blackListId)
	}
	$$$IKCHECKIDEXISTSR(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist,pSC,0)
	quit $data(^ISC.IK.BlackListElements(domainId,blackListId,entUniId))
}

/// Returns whether or not the BlackList identified by <var>blackListId</var> contains the
/// supplied entity.
ClassMethod BlacklistContainsString(domainId As %Integer, blackListId As %Integer, entity As %String, Output pSC As %Status = {$$$OK}) As %Boolean
{
	set pSC = $$$OK
	$$$IKCHECKPRIVREADR(pSC,0)
	if (blackListId>0) {
		$$$CHECKDOMAINEXISTSR(domainId,pSC,0)
		set tDomainId = domainId
		set entity = ##class(%iKnow.Queries.EntityAPI).GetId(domainId, entity)
	} else {
		$$$IKXDOMBLVERSION(xDomVersion)
		$$$IKCHECKSTRINGLENGTH(entity)
		set domainId=0, blackListId=$zabs(blackListId)
	}
	$$$IKCHECKIDEXISTSR(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist,pSC,0)
	quit $data(^ISC.IK.BlackListElements(domainId,blackListId,entity))
}

Parameter AddEntityToBlackListEXP [ Internal ] = 1;

///  Adds an existing entity (by ID) to a BlackList.
/// For cross-domain blacklists, use <method>AddStringToBlackList</method>
ClassMethod AddEntityToBlackList(domainId As %Integer, blackListId As %Integer, entUniId As %Integer) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	$$$CHECKDOMAINEXISTS(domainId)
	$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist)
	
	// BDB386 - check blacklist manager
	set tMgrClass = $lg(details,5)
	$$$IKCHECKMGR("BlackList",blackListId,tMgrClass)
	
	set ^ISC.IK.BlackListElements(domainId, blackListId, entUniId) = ""
	quit $$$OK
}

Parameter AddStringToBlackListEXP [ Internal ] = 1;

///  Adds a string to a BlackList, adding it as an entity if it didn't exist in the domain before.
ClassMethod AddStringToBlackList(domainId As %Integer, blackListId As %Integer, string As %String) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	$$$IKCHECKNOTNULL(string)
	if (domainId'=0) {
		set entUniId = ..AddEntity(domainId, string, .tSC)
		quit:$$$ISERR(tSC) tSC
		quit ..AddEntityToBlackList(domainId, blackListId, entUniId)
	} else {
		$$$IKXDOMBLVERSION(xDomVersion)
		$$$IKCHECKSTRINGLENGTH(string)
		$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,0,$zabs(blackListId),details,$$$IKBlackListDoesNotExist)
		
		// BDB386 - check blacklist manager
		set tMgrClass = $lg(details,5)
		$$$IKCHECKMGR("BlackList",blackListId,tMgrClass)
		
		set ^ISC.IK.BlackListElements(0, $zabs(blackListId), string) = ""
		quit $$$OK
	}
}

Parameter RemoveEntityFromBlackListEXP [ Internal ] = 1;

///  Removes an entity (by ID) from a BlackList (but not from the domain)
/// For cross-domain blacklists, use <method>RemoveStringFromBlackList</method>
ClassMethod RemoveEntityFromBlackList(domainId As %Integer, blackListId As %Integer, entUniId As %Integer) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	$$$CHECKDOMAINEXISTS(domainId)
	$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist)
	
	// BDB386 - check blacklist manager
	set tMgrClass = $lg(details,5)
	$$$IKCHECKMGR("BlackList",blackListId,tMgrClass)
	
	kill ^ISC.IK.BlackListElements(domainId, blackListId, entUniId)
	quit $$$OK
}

Parameter RemoveStringFromBlackListEXP [ Internal ] = 1;

///  Removes a string from a BlackList (but not from the domain)
ClassMethod RemoveStringFromBlackList(domainId As %Integer, blackListId As %Integer, string As %String) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTS(domainId)
		$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,domainId,blackListId,details,$$$IKBlackListDoesNotExist)
		
		// BDB386 - check blacklist manager
		set tMgrClass = $lg(details,5)
		$$$IKCHECKMGR("BlackList",blackListId,tMgrClass)
		
		set entUniId = +##class(%iKnow.Queries.EntityAPI).GetId(domainId, string)
		quit:entUniId<=0
		kill ^ISC.IK.BlackListElements(domainId, blackListId, entUniId)
		quit $$$OK
	} else {
		$$$IKXDOMBLVERSION(xDomVersion)
		$$$IKCHECKSTRINGLENGTH(string)
		$$$IKCHECKIDEXISTS(^ISC.IK.BlackListId,0,$zabs(blackListId),details,$$$IKBlackListDoesNotExist)
		
		// BDB386 - check blacklist manager
		set tMgrClass = $lg(details,5)
		$$$IKCHECKMGR("BlackList",blackListId,tMgrClass)
	
		kill ^ISC.IK.BlackListElements(0, $zabs(blackListId), string)
		quit $$$OK
	}
}

/// Internal method building the required data structures for runtime blacklist use.
ClassMethod BuildBlackList(pDomainId As %Integer, pBlacklistSpec As %String, vSrcId As %Integer = 0) [ Internal ]
{
	set tSC = $$$OK
	try {
		$$$IKCLEANBLACKLIST
		set ^||%IK.BlackLists=0
		quit:(pBlacklistSpec="")
		set ^||%IK.BlackLists=1 
		
		// if this is a SQL query
		if ($e(pBlacklistSpec,1,6)="SELECT") {
			
			#dim tResult As %SQL.StatementResult
			set tStatement = ##class(%SQL.Statement).%New()
			set tSC = tStatement.%Prepare(pBlacklistSpec)
			quit:$$$ISERR(tSC)
			
			// check if this is really a SELECT statement
			if (tStatement.%Metadata.statementType'=1) {
				set tSC = $$$ERROR($$$GeneralError, "Only regular SELECT statements are supported for populating blacklists")
				quit
			}
			
			// derive column to fetch
			set tHasIDs = $d(tStatement.%Metadata.columnIndex("ENTUNIID"),tColInfo)
			if (tHasIDs) {
				set tColNumber = $lg(tColInfo,1)
			} elseif $d(tStatement.%Metadata.columnIndex("ENTITY"),tColInfo) {
				set tColNumber = $lg(tColInfo,1)
			} elseif $d(tStatement.%Metadata.columnIndex("ENTITYVALUE"),tColInfo) {
				set tColNumber = $lg(tColInfo,1)
			} elseif $d(tStatement.%Metadata.columnIndex("VALUE"),tColInfo) {
				set tColNumber = $lg(tColInfo,1)
			} else {
				set tColNumber = 1
			}
			
			if 'tHasIDs {
				kill ^||%IKT.BlackListStrings
				set x = $sortbegin(^||%IKT.BlackListStrings)
			}
			
			set tResult = tStatement.%Execute()
			while tResult.%Next() {
				if tHasIDs {
					set tEntUniId = tResult.%GetData(tColNumber)
					set:tEntUniId ^||%IK.BlackLists(tEntUniId)=""
				} else {
					set tStringValue = tResult.%GetData(tColNumber)
					continue:(tStringValue="")||($l(tStringValue)>$$$IKHASHSIZE)
					set ^||%IKT.BlackListStrings(" "_tStringValue)=""
				}
			}
			quit:tHasIDs
			
			set x = $sortend(^||%IKT.BlackListStrings)
			set tStringValue=""
			for {
				set tStringValue = $order(^||%IKT.BlackListStrings(tStringValue))
				quit:tStringValue=""
				continue:'$d(^ISC.IK.EntUni(pDomainId,tStringValue),tEntUniId)
				set ^||%IK.BlackLists(tEntUniId)=""
			}
			
		} else { 
		
			// regular ID or list of IDs
			$$$IKENSURELISTNUM(pBlacklistSpec)
			
			set ptr=0  
			while $listnext(pBlacklistSpec,ptr,tBlackListId) {
				continue:'tBlackListId 
				set tBLDomainId = $s((tBlackListId<0):0, 1:pDomainId), tBlackListId=$zabs(tBlackListId) 
				continue:'$d(^ISC.IK.BlackListElements(tBLDomainId, tBlackListId))  
				if ('vSrcId && tBLDomainId) { 
					merge ^||%IK.BlackLists = ^ISC.IK.BlackListElements(tBLDomainId, tBlackListId) 
				} else {
					merge tBlackListElements = ^ISC.IK.BlackListElements(tBLDomainId, tBlackListId)
					set e="" 
					for {
						set (e,tEntUniId) = $o(tBlackListElements(e),1,tValue) 
						quit:e=""
						
						// for cross-domain BLs, the subscript is the string value
						if 'tBLDomainId { set tEntUniId = $g(^ISC.IK.EntUni(pDomainId," "_e))  continue:'tEntUniId }
						
						// for virtual sources, we still need to translate to actual entity IDs
						if vSrcId { set tEntUniId = $g(^ISC.IKV.RealEntUniMap(tBLDomainId,vSrcId,e))  continue:'tEntUniId }
						
						set ^||%IK.BlackLists(tEntUniId) = tValue 
					} 
				} 
			} 
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	kill ^||%IKT.BlackListStrings
	if $$$ISERR(tSC) $$$ThrowStatus(tSC)
}

// USER DICTIONARY API

///  <p>This method creates a User Dictionary with a given <var>name</var> and optional <var>description</var> and
///  returns the created user dictionary ID afterwards. This method will return -1 if an error occurred,
///  which is passed by reference as <var>sc</var>.</p>
///  <p><b>Deprecated</b>: please use %New() in <class>%iKnow.UserDictionary</class></p>
ClassMethod CreateUserDictionary(name As %String, description As %String = "", Output sc As %Status) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKNOTNULLR(name,sc,-1)
	$$$IKCHECKSTRINGLENGTHR(name,sc,-1)
	
	set tUserDict = ##class(%iKnow.UserDictionary).%New(name,description)
	
	if tUserDict="" {
		set sc = %objlasterror
		quit -1
	}
	
	set sc = tUserDict.%Save()
	quit:$$$ISERR(sc) -1
	
	quit tUserDict.Id
}

Parameter DropUserDictionaryEXP [ Internal ] = 1;

///  This method drops the User Dictionary identified by the supplied <var>userDictId</var>,
///  including all its entries.
///  <p><b>Deprecated</b>: please use %DeleteId() in <class>%iKnow.UserDictionary</class></p>
ClassMethod DropUserDictionary(userDictId As %Integer) As %Status
{
	quit ##class(%iKnow.UserDictionary).%DeleteId(userDictId)
}

///  Returns the ID corresponding to the supplied User Dictionary <var>name</var>.
///  <p><b>Deprecated</b>: please use NameIndexOpen() <class>%iKnow.UserDictionary</class></p>
ClassMethod GetUserDictionaryId(name As %String) As %Integer
{
	$$$CHECKLICENSER(tSC,-1)
	
	set tUserDict = ##class(%iKnow.UserDictionary).NameIndexOpen(name)
	quit:tUserDict="" ""
	quit tUserDict.Id
}

Parameter GetUserDictionariesRT = "userDictId:%Integer,name:%String,description:%String";

///  Returns a list of all the User Dictionaries in this namespace.
///  <p><b>Deprecated</b>: please use <class>%iKnow.UserDictionary</class></p>
ClassMethod GetUserDictionaries(ByRef result) As %Status
{
	$$$IKQBEGINTRY(result,"",tSC)
	
	set id = ""
	for {
		set id = $order(^ISC.IK.Sys.UserDictD(id),1,tData)
		quit:id=""
		$$$IKQADDRESULT(result,$i(i),$lb(id)_tData)
	}
	
	$$$IKQENDCATCH(restult,"",tSC)
}

Parameter AddUserDictionaryEntryEXP [ Internal ] = 1;

///  <p>Adds a single entry to a User Dictionary at <var>position</var>. If <var>position</var> <= 0 (default),
///  it is added at the bottom of the list, otherwise at the requested position, shifting
///  existing entries down if it was already taken.</p>
///  <p><b>Deprecated</b>: please use AddEntry() in <class>%iKnow.UserDictionary</class></p>
ClassMethod AddUserDictionaryEntry(userDictId As %Integer, rewriteFrom As %String, rewriteTo As %String, ByRef position As %Integer = 0) As %Status
{
	$$$CHECKLICENSE
	
	set tUserDict = ##class(%iKnow.UserDictionary).%OpenId(userDictId)
	quit:tUserDict="" $$$ERROR($$$IKNoUserDictWithId, userDictId)
	
	quit tUserDict.AddEntry(rewriteFrom, rewriteTo, position)
}

Parameter RemoveUserDictionaryEntryEXP [ Internal ] = 1;

///  <p>Removes the User Dictionary entry registered at <var>position</var>. This method will
///  not impact the order or position of any remaning entries.</p>
///  <p><b>Deprecated</b>: please use RemoveEntry() in <class>%iKnow.UserDictionary</class></p>
ClassMethod RemoveUserDictionaryEntry(userDictId As %Integer, position As %Integer) As %Status
{
	$$$CHECKLICENSE
	
	set tUserDict = ##class(%iKnow.UserDictionary).%OpenId(userDictId)
	quit:tUserDict="" $$$ERROR($$$IKNoUserDictWithId, userDictId)
	
	quit tUserDict.RemoveEntry(position)
}

Parameter GetUserDictionaryEntriesRT = "position:%Integer,rewriteFrom:%String,rewriteTo:%String";

///  <p>Returns the contents of a User Dictionary.</p>
///  <p><b>Deprecated</b>: please use GetEntries() in <class>%iKnow.UserDictionary</class></p>
ClassMethod GetUserDictionaryEntries(ByRef result, userDictId As %Integer) As %Status
{
	$$$IKQBEGINTRY(result,"",tSC)
	$$$CHECKLICENSEX(tSC)
	
	set tUserDict = ##class(%iKnow.UserDictionary).%OpenId(userDictId)
	if (tUserDict="") { set tSC = $$$ERROR($$$IKNoUserDictWithId, userDictId) quit }
	
	set tSC = tUserDict.GetEntries(.tEntries)
	quit:$$$ISERR(tSC)
	
	set tPos = ""
	for {
		set tPos = $order(tEntries(tPos),1,tData)
		quit:tPos=""
		$$$IKQADDRESULT(result,$i(i),$lb(tPos)_tData)
	}
	
	$$$IKQENDCATCH(result,"",tSC)
}

}
