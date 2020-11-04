///  Main entry point for managing Dictionary contents to be used by the Matching APIs
Class %iKnow.Matching.DictionaryAPI Extends %iKnow.Queries.AbstractAPI [ System = 4 ]
{

///  Creates a Dictionary and returns its ID.
ClassMethod CreateDictionary(domainId As %Integer, name As %String, description As %String = "", defaultLanguage As %String = "en", defaultProfileId As %Integer = "", Output sc As %Status = {$$$OK}) As %Integer
{
	quit ..CreateDictionaryInternal(domainId, name, description, defaultLanguage, defaultProfileId,, .sc)
}

ClassMethod CreateDictionaryInternal(domainId As %Integer, name As %String, description As %String = "", defaultLanguage As %String = "en", defaultProfileId As %Integer = "", mgrClass As %String = "", Output sc As %Status = {$$$OK}) As %Integer [ Internal ]
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
		$$$IKCHECKDOMMGRR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKNOTNULLR(name,sc,-1)
	$$$IKCHECKSTRINGLENGTHR(name,sc,-1)
	
	// BDB397 - case insensitive names
	set tNameIndex = $s('domainId||$$$IKVERSIONATLEAST(domainId,$$$IKVERSIONCASEINSENSITIVENAMES):$$$UPPER(name), 1:name)
	$$$IKCHECKIDNOTEXISTSR(^ISC.IK.Mat.Dict,domainId,tNameIndex,$$$IKDictExists,sc,-1)
	
    set languageId = $listfind($$$IKLANGUAGES, defaultLanguage)
    if ('languageId) {
	    set sc = $$$ERROR($$$InvalidArgument, "defaultLanguage")
	    quit -1
    }
    if (defaultProfileId) {
	    quit:##class(%iKnow.Matching.MatchingProfile).GetProfile(domainId, defaultProfileId,.sc)=""
    }
	
	$$$IKLOCKR(domainId,^ISC.IK.Mat.DictId,sc,-1)
	
	// check again if it wasn't added in the meantime
	if $d(^ISC.IK.Mat.Dict(domainId,tNameIndex)) {
		$$$IKUNLOCK(domainId,^ISC.IK.Mat.DictId)
		set sc = $$$ERROR($$$IKDictExists, name)
		quit -1
	}
	
	set tTLevel = $tlevel
	try {
		tstart
	    set dictId = $i(^ISC.IK.Mat.DictId(domainId))
   		set ^ISC.IK.Mat.DictId(domainId, dictId) = $lb(name, description, languageId, defaultProfileId, mgrClass)
   		set ^ISC.IK.Mat.Dict(domainId, tNameIndex) = dictId
   		set:domainId ^ISC.IK.Mat.DictMatchStatus(domainId, dictId) = $lb(0,0,0)
   		
   		// BDB385 - store version number for cross-domain dictionaries
   		set:($g(^ISC.IK.Mat.DictId)="")&&'domainId ^ISC.IK.Mat.DictId = $$$IKCURRENTVERSION
   		
		tcommit
   		
   		// BDB624 - trigger customizations
   		set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE), 1:"")
   		if (tTablesPackage'="") && $classmethod(tTablesPackage_".Dictionary","%HasCustomizations") {
	   		set tSC = $classmethod(tTablesPackage_".Dictionary", "%BuildCustomFields", dictId, dictId)
	   		quit:$$$ISERR(tSC)
	   		set tSC = $classmethod(tTablesPackage_".Dictionary", "%BuildCustomIndices", 0, dictId, dictId)
	   		quit:$$$ISERR(tSC)
   		}
	} catch(ex) {
		set sc = ex.AsStatus(), dictId=-1
	}
	trollback:($tlevel>tTLevel) 1
	
	$$$IKUNLOCK(domainId,^ISC.IK.Mat.DictId)
	
    quit dictId
}

///  Looks up the Dictionary ID corresponding to the supplied Dictionary name.
ClassMethod GetDictionaryId(domainId As %Integer, name As %String, Output sc As %Status = {$$$OK}) As %Integer
{
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVREADR(sc,-1)
	set sc = $$$OK
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKNOTNULLR(name,sc,-1)
	$$$IKCHECKSTRINGLENGTHR(name,sc,-1)
	
	// BDB397 - case insensitive names
	set tNameIndex = $s('domainId||$$$IKVERSIONATLEAST(domainId,$$$IKVERSIONCASEINSENSITIVENAMES):$$$UPPER(name), 1:name)
	quit $g(^ISC.IK.Mat.Dict(domainId, tNameIndex))
}

/// Returns whether or not there are any dictionaries in the domain
ClassMethod HasDictionaries(pDomainId As %Integer) As %Boolean
{
	quit ($d(^ISC.IK.Mat.DictId(pDomainId))>=10)
}

Parameter DropDictionaryEXP [ Internal ] = 1;

///  Deletes a Dictionary and all related items, terms, elements and matches.
ClassMethod DropDictionary(domainId As %Integer, dictId As %Integer) As %Status
{
	set tSC = $$$OK, tTLevel = $tlevel
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTS(domainId)
		$$$IKCHECKDOMMGR(domainId)
	} else {
		$$$IKXDOMDICTVERSION(xDomVersion)
	}
	$$$IKCHECKIDEXISTS(^ISC.IK.Mat.DictId,domainId,+dictId,dictDetails,$$$IKDictionaryDoesNotExist)
	
	// BDB385 - check manager class
	set tMgrClass = $lg(dictDetails,5)
	$$$IKCHECKMGR("Dictionary",dictId,tMgrClass)
	
	$$$IKLOCK(domainId,^ISC.IK.Mat.DictId)
	
	try {
		tstart
	    // first delete all items within
	    set dictItemId = ""
	    for {
	        set dictItemId = $order(^ISC.IK.Mat.DictToItem(domainId, dictId, dictItemId))
	        quit:dictItemId=""
        
	        set tSC = ..DropDictionaryItem(domainId, dictItemId)
	        quit:$$$ISERR(tSC)
	    }
	    quit:$$$ISERR(tSC)

	    // remove all dictionary-level match results
	    if (domainId) {
		    kill ^ISC.IK.Mat.DictMatchStatus(domainId, dictId)
		    kill ^ISC.IK.Mat.DictToMatchBit(domainId, dictId)
	    	kill ^ISC.IK.Mat.DictToSrcMatchedBit(domainId, dictId)
	    } else {
		    
		    // BDB385 - for cross-domain dictionaries, remove results in all domains
		    set d = ""
		    for {
			  	set d = $order(^ISC.IK.Mat.DictMatchStatus(d))
			  	quit:d=""
			  	 
			    kill ^ISC.IK.Mat.DictMatchStatus(d, -dictId)
			    kill ^ISC.IK.Mat.DictToMatchBit(d, -dictId)
		    	kill ^ISC.IK.Mat.DictToSrcMatchedBit(d, -dictId)
		    }
	    }
	    
	    // remove dictionary format references
	    kill ^ISC.IK.Mat.DictToFormat(domainId, dictId)	    

	    // now remove the dict entry
	    // BDB624 - verify if we need to sync customizations and go through the object
	    set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE), 1:"") 
	    if (tTablesPackage'="") && $classmethod(tTablesPackage_".Dictionary","%HasCustomizations") {
		    new %ikSafeDelete
		    set %ikSafeDelete = 1
		    set tSC = $classmethod(tTablesPackage_".Dictionary", "%DeleteId", dictId, 0)
		    quit:$$$ISERR(tSC)
	    } else {
		    kill ^ISC.IK.Mat.Dict(domainId, $$$UPPER($li(dictDetails,1)))
		    kill ^ISC.IK.Mat.DictId(domainId, dictId)
	    }
	    kill ^ISC.IK.Mat.DictToItem(domainId, dictId)
	    
	    // BDB385 - also drop version info if this was the last cross-domain dictionary
	    if 'domainId && ($d(^ISC.IK.Mat.DictId(0))<10) {
		    zkill ^ISC.IK.Mat.DictId
	    }
	    
		tcommit
	} catch(ex) {
		set tSC = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	$$$IKUNLOCK(domainId,^ISC.IK.Mat.DictId)

    quit tSC
}

///  Creates a Dictionary Item and returns its ID.
ClassMethod CreateDictionaryItem(domainId As %Integer, dictId As %Integer, name As %String, ByRef URI As %String, defaultLanguage As %String = "en", Output sc As %Status = {$$$OK}) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
		$$$IKCHECKDOMMGRR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKNOTNULLR(name,sc,-1)
	$$$IKCHECKIDEXISTSR(^ISC.IK.Mat.DictId,domainId,+dictId,dictDetails,$$$IKDictionaryDoesNotExist,sc,-1)
	if $g(URI)'="" {
		$$$IKCHECKSTRINGLENGTHR(URI,sc,-1)
		$$$IKCHECKIDNOTEXISTSR(^ISC.IK.Mat.DictItemURI,domainId,URI,$$$IKDictItemURIExists,sc,-1)
	}
	
	// BDB385 - check manager class
	set tMgrClass = $lg(dictDetails,5)
	$$$IKCHECKMGRR("Dictionary",dictId,tMgrClass,sc,-1)
	
    set languageId = $listfind($$$IKLANGUAGES, defaultLanguage)
    if ('languageId) { set sc = $$$ERROR($$$InvalidArgument, "defaultLanguage")  quit -1 }
	
	$$$IKLOCKR(domainId,^ISC.IK.Mat.DictItemId,sc,-1)
	
	// BDB440: if no URI was supplied, generate one
	if $g(URI)="" {
		set tBaseURI = ":"_dictId_":"_$e(name,1,50), URI = tBaseURI, tDeDup=0
		while $d(^ISC.IK.Mat.DictItemURI(domainId,URI)) {
			set URI = tBaseURI_":"_$i(tDeDup)
		}
	}	
	// otherwise, check again if it wasn't added in the meantime
	elseif $d(^ISC.IK.Mat.DictItemURI(domainId,URI)) {
		$$$IKUNLOCK(domainId,^ISC.IK.Mat.DictItemId)
		set sc = $$$ERROR($$$IKDictItemURIExists, URI)
		quit -1
	}
	
	set tTLevel = $tlevel
	try {
		tstart
	    set dictItemId = $i(^ISC.IK.Mat.DictItemId(domainId))
	    set ^ISC.IK.Mat.DictItemId(domainId, dictItemId) = $lb(dictId, name, URI, languageId)
	    set ^ISC.IK.Mat.DictItemURI(domainId, URI) = dictItemId
	    set ^ISC.IK.Mat.DictToItem(domainId, dictId, dictItemId) = ""
	    
		tcommit
   		
   		// BDB624 - trigger customizations
   		set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE), 1:"")
   		if (tTablesPackage'="") && $classmethod(tTablesPackage_".DictionaryItem","%HasCustomizations") {
	   		set tSC = $classmethod(tTablesPackage_".DictionaryItem", "%BuildCustomFields", dictItemId, dictItemId)
	   		quit:$$$ISERR(tSC)
	   		set tSC = $classmethod(tTablesPackage_".DictionaryItem", "%BuildCustomIndices", 0, dictItemId, dictItemId)
	   		quit:$$$ISERR(tSC)
   		}
	} catch(ex) {
		set sc = ex.AsStatus(), dictItemId=-1
	}
	trollback:($tlevel>tTLevel) 1
	
	$$$IKUNLOCK(domainId,^ISC.IK.Mat.DictItemId)
	
    quit dictItemId
}

///  Looks up the Dictionary Item ID corresponding to the supplied Dictionary Item URI.
ClassMethod GetDictionaryItemIdByURI(domainId As %Integer, URI As %String, Output sc As %Status = {$$$OK}) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVREADR(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKNOTNULLR(URI,sc,-1)
	$$$IKCHECKSTRINGLENGTHR(URI,sc,-1)
	quit $g(^ISC.IK.Mat.DictItemURI(domainId, URI))
}

Parameter DropDictionaryItemEXP [ Internal ] = 1;

///  Deletes a Dictionary Item with all related terms, elements and matches.
ClassMethod DropDictionaryItem(domainId As %Integer, dictItemId As %Integer) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTS(domainId)
		$$$IKCHECKDOMMGR(domainId)
	} else {
		$$$IKXDOMDICTVERSION(xDomVersion)
	}
	$$$IKCHECKIDEXISTS(^ISC.IK.Mat.DictItemId,domainId,+dictItemId,item,$$$IKDictItemDoesNotExist)
	
	// BDB385 - check manager class
	set tDictId = $li(item,1), tMgrClass = $lg(^ISC.IK.Mat.DictId(domainId,tDictId),5)
	$$$IKCHECKMGR("Dictionary",tDictId,tMgrClass)
	
	// BDB624 - check if there are any customizations to sync
	set tHasTermCustomizations = 0, tHasItemCustomizations = 0
	set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE),1:"")
	if (tTablesPackage'="") { 
		new %ikSafeDelete set %ikSafeDelete = 1 
		set tHasTermCustomizations = $classmethod(tTablesPackage_".DictionaryTerm","%HasCustomizations")
		set tHasItemCustomizations = $classmethod(tTablesPackage_".DictionaryItem","%HasCustomizations")
	}
	
	$$$IKLOCK(domainId,^ISC.IK.Mat.DictItemId)
	
	set tSC = $$$OK, tTLevel = $tlevel
	try {
		tstart
	    set dictId = $list(item,1)
	    
	    set tSC = ##class(%iKnow.Matching.MatchingAPI).InvalidateMatchingResultsInternal(domainId, dictId, dictItemId, 2)
	    quit:$$$ISERR(tSC)

	    // drop all terms
	    set terms = $g(^ISC.IK.Mat.DictItemTerms(domainId, dictItemId)), ptr1=0
	    while $listnext(terms,ptr1,dtId) {
		    if tHasTermCustomizations {
			    set tSC = $classmethod(tTablesPackage_".DictionaryTerm", "%DeleteId", dtId, 0)
			    quit:$$$ISERR(tSC)
		    } else {
		        kill ^ISC.IK.Mat.DictTermId(domainId, dtId)
		    }
	    }
	    quit:$$$ISERR(tSC)
	    kill ^ISC.IK.Mat.DictItemTerms(domainId, dictItemId)
    
	    // drop the item itself
	    if tHasItemCustomizations {
		    set tSC = $classmethod(tTablesPackage_".DictionaryItem", "%DeleteId", dictItemId, 0)
		    quit:$$$ISERR(tSC)
	    } else {
		    kill ^ISC.IK.Mat.DictItemId(domainId, dictItemId)
	    }
	    kill ^ISC.IK.Mat.DictItemURI(domainId, $list(item, 3))
	    kill ^ISC.IK.Mat.DictToItem(domainId, $list(item, 1), dictItemId)
		tcommit
	} catch(ex) {
		set tSC = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	
	$$$IKUNLOCK(domainId,^ISC.IK.Mat.DictItemId)

    quit tSC
}

///  Shorthand method for creating a Dictionary Item and Term using the Item's name. Returns the Items ID.
ClassMethod CreateDictionaryItemAndTerm(domainId As %Integer, dictId As %Integer, name As %String, ByRef URI As %String, language As %String = "en", Output sc As %Status = {$$$OK}) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
    set dictItemId = ..CreateDictionaryItem($g(domainId), $g(dictId), $g(name), .URI, $g(language), .sc)
    quit:$$$ISERR(sc) -1
	set dictTermId = ..CreateDictionaryTerm($g(domainId), dictItemId, $g(name), $g(language), .sc)
	quit:$$$ISERR(sc) -1
	quit dictItemId
}

///  <p>Creates a Dictionary Term and returns its ID.</p>
///  <p>If <var>isProcessed</var> is 1 (default 0), the term will be marked as processed upon creation
///  and no Dictionary Elements will be created. This parameter is for internal use only and deprecated in 2013.1.</p>
ClassMethod CreateDictionaryTerm(domainId As %Integer, dictItemId As %Integer, string As %String, language As %String = "en", Output sc As %Status = {$$$OK}, isProcessed As %Boolean = 0) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
		$$$IKCHECKDOMMGRR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKIDEXISTS(^ISC.IK.Mat.DictItemId,domainId,+dictItemId,dictItem,$$$IKDictItemDoesNotExist)
	
	// BDB385 - check manager class
	set tDictId = $li(dictItem,1), tMgrClass = $lg(^ISC.IK.Mat.DictId(domainId,tDictId),5)
	$$$IKCHECKMGRR("Dictionary",tDictId,tMgrClass,sc,-1)
	
	set languageId = ""
    set:language'="" languageId = $listfind($$$IKLANGUAGES, language)
    if ('languageId && 'isProcessed) { set sc = $$$ERROR($$$InvalidArgument, "language")  quit -1 }
    
    $$$IKLOCK(domainId_"|"_dictItemId,^ISC.IK.Mat.DictItemId)
	
	set tTLevel = $tlevel
	try {
	    // first look if the term already exists
	    set terms = $g(^ISC.IK.Mat.DictItemTerms(domainId,dictItemId)), ptr=0, dictTermId=0
	    while $listnext(terms, ptr, termId) {
		    if ($lg($g(^ISC.IK.Mat.DictTermId(domainId,termId)),3)=string) {
			    set dictTermId = termId
			    quit
		    }
	    }
	    quit:dictTermId
    
		tstart
		
	    set dictTermId = $i(^ISC.IK.Mat.DictTermId(domainId))
	    set dictId = $list(dictItem, 1)
	    set tDomVersion = $s(domainId:$$$IKVERSION(domainId), 1:xDomVersion)
		if '(tDomVersion>=$$$IKVERSIONMATCHING20131) {
		    set ^ISC.IK.Mat.DictTermId(domainId, dictTermId) = $lb(dictId, dictItemId, string, languageId, $s(isProcessed:$$$DTPROCESSED, 1:$$$DTUNPROCESSED))
		} else {
		    set ^ISC.IK.Mat.DictTermId(domainId, dictTermId) = $lb(dictId, dictItemId, string, languageId)
		}

	    // add to DI terms list
	    set ^ISC.IK.Mat.DictItemTerms(domainId, dictItemId)=$g(^ISC.IK.Mat.DictItemTerms(domainId, dictItemId))_$lb(dictTermId)
		tcommit
   		
   		// BDB624 - trigger customizations
   		set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE), 1:"")
   		if (tTablesPackage'="") && $classmethod(tTablesPackage_".DictionaryTerm","%HasCustomizations") {
	   		set tSC = $classmethod(tTablesPackage_".DictionaryTerm", "%BuildCustomFields", dictTermId, dictTermId)
	   		quit:$$$ISERR(tSC)
	   		set tSC = $classmethod(tTablesPackage_".DictionaryTerm", "%BuildCustomIndices", 0, dictTermId, dictTermId)
	   		quit:$$$ISERR(tSC)
   		}
	} catch(ex) {
		set sc = ex.AsStatus(), dictTermId = -1
	}
	trollback:($tlevel>tTLevel) 1
	$$$IKUNLOCK(domainId_"|"_dictItemId,^ISC.IK.Mat.DictItemId)
    quit dictTermId
}

Parameter DropDictionaryTermEXP [ Internal ] = 1;

///  Drops a single Dictionary Term and its matching results
ClassMethod DropDictionaryTerm(domainId As %Integer, dictTermId As %String) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVWRITE
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTS(domainId)
		$$$IKCHECKDOMMGR(domainId)
	} else {
		$$$IKXDOMDICTVERSION(xDomVersion)
	}
	$$$IKCHECKIDEXISTS(^ISC.IK.Mat.DictTermId,domainId,+dictTermId,term,$$$IKDictTermDoesNotExist)
	
	// BDB385 - check manager class
	set tDictId = $li(term,1), tMgrClass = $lg(^ISC.IK.Mat.DictId(domainId,tDictId),5)
	$$$IKCHECKMGR("Dictionary",tDictId,tMgrClass)
	
	set dictId = $list(term,1), dictItemId = $list(term,2)
	$$$IKLOCK(domainId_"|"_dictItemId,^ISC.IK.Mat.DictItemId)
	
	set tSC = $$$OK, tTLevel = $tlevel
	try {
		tstart
	    
	    set tSC = ##class(%iKnow.Matching.MatchingAPI).InvalidateMatchingResultsInternal(domainId, dictId, dictItemId, 2, dictTermId)
	    quit:$$$ISERR(tSC)
	    
	    // BDB624 - verify if we need to sync customizations and go through the object
	    set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE), 1:"") 
	    if (tTablesPackage'="") && $classmethod(tTablesPackage_".DictionaryTerm","%HasCustomizations") {
		    new %ikSafeDelete
		    set %ikSafeDelete = 1
		    set tSC = $classmethod(tTablesPackage_".DictionaryTerm", "%DeleteId", dictTermId, 0)
		    quit:$$$ISERR(tSC)
	    } else {
		    kill ^ISC.IK.Mat.DictTermId(domainId, dictTermId)
	    }
	    
	    // drop from ^ISC.IK.Mat.DictItemTerms
	    set terms = $g(^ISC.IK.Mat.DictItemTerms(domainId,dictItemId))
	    set newTerms = "", ptr=0
	    while $listnext(terms,ptr,t) {
		    continue:(t=dictTermId)
		    set newTerms = newTerms _ $lb(t)
	    }
	    set ^ISC.IK.Mat.DictItemTerms(domainId,dictItemId) = newTerms
	    
		tcommit
	} catch(ex) {
		set tSC = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	
	$$$IKUNLOCK(domainId_"|"_dictItemId,^ISC.IK.Mat.DictItemId)

    quit tSC
}

///  Creates a Dictionary Format instance of the supplied <i>formatClass</i> and returns its ID.
ClassMethod CreateDictionaryFormat(domainId As %Integer, formatClass As %String, formatParams As %List = "", Output sc As %Status = {$$$OK}) As %Integer
{
	set sc = $$$OK, dictFormatId=-1
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
		$$$IKCHECKDOMMGRR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKNOTNULLR(formatClass,sc,-1)
	if (##class(%Dictionary.CompiledClass).%OpenId(formatClass)="") { set sc = $$$ERROR($$$IKDFClassDoesNotExist, formatClass)  quit -1 }
	
	// BDB440: verify parameters
	set sc = $classmethod(formatClass, "TestParams", formatParams, domainId)
	quit:$$$ISERR(sc) -1
	
	set tTLevel = $tlevel
	try {
		
		// derive or define formatClassId
		if '$d(^ISC.IK.Sys.DictFormatI(formatClass), formatClassId) {
			
			$$$IKLOCKGX(^ISC.IK.Sys.DictFormatD,sc)
			
			// check again after acquiring the lock
			tstart
			if '$d(^ISC.IK.Sys.DictFormatI(formatClass), formatClassId) {
				set formatClassId = $i(^ISC.IK.Sys.DictFormatD)
				set ^ISC.IK.Sys.DictFormatD(formatClassId) = formatClass
				set ^ISC.IK.Sys.DictFormatI(formatClass) = formatClassId
			}
			$$$IKUNLOCKG(^ISC.IK.Sys.DictFormatD)
			
		} else {
			tstart
		}
		
	    // check if the format already exists
	    set formatParamsHash = $zcrc(formatParams, 7)
	    set dictFormatId = ""
	    for {
		    set dictFormatId = $order(^ISC.IK.Mat.DictFormat(domainId, formatClassId, formatParamsHash, dictFormatId))
		    quit:dictFormatId=""
		    
		    set params = $lg(^ISC.IK.Mat.DictFormatId(domainId, dictFormatId),2)
		    quit:$ls(params,formatParams)
	    }
	    
	    // if there still is no dictFormatId, we'll have to create a new one
	    if (dictFormatId="") {
		    set dictFormatId = $i(^ISC.IK.Mat.DictFormatId(domainId))
			set ^ISC.IK.Mat.DictFormatId(domainId, dictFormatId) = $lb(formatClassId, formatParams)
			set ^ISC.IK.Mat.DictFormat(domainId, formatClassId, formatParamsHash, dictFormatId) = ""
	    }
	    
		tcommit
	} catch(ex) {
		set sc = ex.AsStatus(), dictFormatId = -1
	}
	trollback:($tlevel>tTLevel) 1
	$$$IKUNLOCKG(^ISC.IK.Sys.DictFormatD)
	
	quit +dictFormatId
}

/// Shorthand method to create a Dictionary Term composed of a single Dictionary Format of type
/// <class>%iKnow.Matching.Formats.RegularExpression</class>, matching <var>pRegularExpression</var> and
/// optionally producing output by replacing the matched parts of an entity with <var>pReplace</var>.
ClassMethod CreateRegularExpression(pDomainId As %Integer, pDictItemId As %Integer, pRegularExpression As %String, pReplace As %String = "", Output pSC As %Status) As %Integer
{
	quit ..CreateDictionaryTermFormat(pDomainId, pDictItemId, "%iKnow.Matching.Formats.RegularExpression", $lb(pRegularExpression, pReplace), .pSC)
}

///  Creates a Dictionary Term composed of a single Dictionary Format and returns the Terms ID.
ClassMethod CreateDictionaryTermFormat(domainId As %Integer, dictItemId As %Integer, formatClass As %String, formatParams As %List = "", Output sc As %Status = {$$$OK}) As %Integer
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,-1)
	$$$IKCHECKPRIVWRITER(sc,-1)
	if (domainId'=0) {
		$$$CHECKDOMAINEXISTSR(domainId,sc,-1)
		$$$IKCHECKDOMMGRR(domainId,sc,-1)
	} else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,sc,-1)
	}
	$$$IKCHECKIDEXISTSR(^ISC.IK.Mat.DictItemId,domainId,+dictItemId,dictItem,$$$IKDictItemDoesNotExist,sc,-1)
	
	// BDB385 - check manager class
	set tDictId = $li(dictItem,1), tMgrClass = $lg(^ISC.IK.Mat.DictId(domainId,tDictId),5)
	$$$IKCHECKMGRR("Dictionary",tDictId,tMgrClass,sc,-1)
	
	set tTLevel = $tlevel
	try {
		tstart
	    set dictTermId = $i(^ISC.IK.Mat.DictTermId(domainId))
	    set dictId = $list(dictItem, 1)
		if $$$IKVERSIONBEFORE(domainId,$$$IKVERSIONMATCHING20131) {
		    set ^ISC.IK.Mat.DictTermId(domainId, dictTermId) = $lb(dictId, dictItemId, formatClass _ "[" _ $lts(formatParams) _ "]", "", $$$DTPROCESSED)
		} else {
		    set ^ISC.IK.Mat.DictTermId(domainId, dictTermId) = $lb(dictId, dictItemId, formatClass _ "[" _ $lts(formatParams) _ "]", "")
		}
		
	    // get format id and store element
	    set dfId = ..CreateDictionaryFormat(domainId, formatClass, formatParams, .sc)
	    if $$$ISERR(sc) { set dictTermId = -1  quit }
	    set deId = ..CreateDictionaryElement(domainId, $$$DEFORMAT, dictTermId, dfId, $$$DMPOSUNDEFINED, $$$DMROLEUNDEFINED, $$$DMSCOREUNDEFINED, 1, 0, sc)
	    if $$$ISERR(sc) { set dictTermId = -1  quit }

	    // add to DI terms list
	  	set ^ISC.IK.Mat.DictItemTerms(domainId, dictItemId)=$g(^ISC.IK.Mat.DictItemTerms(domainId, dictItemId))_$lb(dictTermId)
		tcommit
   		
   		// BDB624 - trigger customizations
   		set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE), 1:"")
   		if (tTablesPackage'="") && $classmethod(tTablesPackage_".DictionaryTerm","%HasCustomizations") {
	   		set tSC = $classmethod(tTablesPackage_".DictionaryTerm", "%BuildCustomFields", dictTermId, dictTermId)
	   		quit:$$$ISERR(tSC)
	   		set tSC = $classmethod(tTablesPackage_".DictionaryTerm", "%BuildCustomIndices", 0, dictTermId, dictTermId)
	   		quit:$$$ISERR(tSC)
   		}
	} catch(ex) {
		set sc = ex.AsStatus(), dictTermId = -1
	}
	trollback:($tlevel>tTLevel) 1

    quit dictTermId
}

///  Creates a Dictionary Element
/// NOTE: if $$$IKPSTANDARDIZEDFORM="Stem", the input is assumed to be stemmed already
ClassMethod CreateDictionaryElement(domainId As %Integer, type As %String = {$$$DETERM}, dictTermId As %Integer, value As %String, position As %Integer = {$$$DMPOSUNDEFINED}, role As %Integer = {$$$DMROLEUNDEFINED}, matchScore As %Integer = {$$$DMSCOREUNDEFINED}, nbOfEntries As %Integer = -1, useTransaction As %Boolean = 1, elementWeight As %Numeric = 1, Output sc As %Status = {$$$OK}) As %Integer [ Internal ]
{
	//$$$CHECKLICENSER(sc,-1) // not required for Internal methods
	set sc = $$$OK, tTLevel = $tlevel
	//$$$CHECKDOMAINEXISTSR(domainId,sc,-1) // not required for Internal methods
	$$$IKCHECKIDEXISTSR(^ISC.IK.Mat.DictTermId,domainId,+dictTermId,dictTerm,$$$IKDictTermDoesNotExist,sc,-1)
	
	try {
		tstart:useTransaction
	    // derive dictId
	    set dictId = $list(dictTerm, 1)

	    set dictElementId = $i(^ISC.IK.Mat.DictElementId(domainId))

	    // derive the number of entries if not specified
	    if (nbOfEntries = -1) {
	        set elems = $g(^ISC.IK.Mat.DictTermElems(domainId, dictTermId))
	        set nbOfEntries = $listlength(elems)+1
	        for i = 1:1:(nbOfEntries-1) {
	            set $list(^ISC.IK.Mat.DictElementId(domainId, $list(elems, i)), 8) = nbOfEntries
	        }
	    }

	    // store in the other DE-based globals
	    if (type = $$$DETERM) {
        
	        // treat case sensitivity
	        //$$$IKCONVERTMATCHINGCASE(domainId,value)
	        set value = $$$IKNORMALIZE(value)
	        set tStandardizedForm = $$$GETPARAMNODEF(domainId,$$$IKPMATSTANDARDIZEDFORM)
	        if (tStandardizedForm'="") && (tStandardizedForm'=$$$IKPMATSTANDARDIZEDFORMSTEMMING) {
	        	set value = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(value, $li($$$IKLANGUAGES, $li(dictTerm,4)), tStandardizedForm)
	        }
        	
        	set deStringId = ..GetDictElemStringId(domainId, value)
        	
	        set ^ISC.IK.Mat.DictElement(domainId, deStringId, dictElementId) = dictId
	        set ^ISC.IK.Mat.DictElementId(domainId, dictElementId) = $lb(+dictId, +dictTermId, type, deStringId, +position, +role, +matchScore, nbOfEntries)
        
	    } else {
		    set dictFormatId = value
	        set ^ISC.IK.Mat.DictFormatElements(domainId, dictFormatId, dictElementId) = dictId
	        set ^ISC.IK.Mat.DictElementId(domainId, dictElementId) = $lb(+dictId, +dictTermId, type, dictFormatId, +position, +role, +matchScore, nbOfEntries)
	    	set ^ISC.IK.Mat.DictToFormat(domainId, dictId, dictFormatId) = "" 
	    }
	    
	    // we only store weights if they're not equal to 1 to save space
	    if (elementWeight'=1) {
		    set $list(^ISC.IK.Mat.DictElementId(domainId, dictElementId), 9) = elementWeight
	    }
        
	    set ^ISC.IK.Mat.DictTermElems(domainId, dictTermId) = $g(^ISC.IK.Mat.DictTermElems(domainId, dictTermId)) _ $lb(dictElementId)
		tcommit:useTransaction
	} catch(ex) {
		set sc = ex.AsStatus(), dictElementId = -1
	}
	trollback:($tlevel>tTLevel) 1

    quit dictElementId
}

Parameter GetDictionariesRT = "dictId:%Integer,name:%String,description:%String,defaultLanguage:%String";

///  Returns all Dictionaries in this domain.
///  If <var>pIncludeCrossDomain</var> = 1, any cross-domain dictionaries registered in "domain 0"
///  are also included in the result, using a negative value for their ID.
ClassMethod GetDictionaries(ByRef result, domainId As %Integer, page As %Integer = 1, pageSize As %Integer = 10, pIncludeCrossDomain As %Boolean = 0) As %Status
{
    $$$IKQBEGINTRY(result,"",tSC)
    if (domainId'=0) {
		$$$CHECKDOMAINEXISTSX(domainId,tSC)
    }
    if 'domainId {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
    } elseif (pIncludeCrossDomain) {
	    $$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
	    $$$IKXDOMDICTCOMPATIBLEX(xDomVersion,$$$IKVERSION(domainId),tSC)
	}

	$$$IKSETPAGINGVARS(page,pageSize,usePaging,first,last,i)

    set dictId = ""
    for {
        set dictId = $order(^ISC.IK.Mat.DictId(domainId, dictId), 1, d)
        quit:dictId=""
            
        set i = i+1
        $$$IKCHECKPAGING(usePaging,first,last,i)
                                
        $$$IKQADDRESULT(result,i,$lb(+dictId) _ $li(d,1,2) _ $lb($li($$$IKLANGUAGES,$li(d,3))))
    }

	if (pIncludeCrossDomain && domainId) {
	    set dictId = ""
	    for {
	        set dictId = $order(^ISC.IK.Mat.DictId(0, dictId), 1, d)
	        quit:dictId=""
	            
	        set i = i+1
	        $$$IKCHECKPAGING(usePaging,first,last,i)
	                                
	        $$$IKQADDRESULT(result,i,$lb(-dictId) _ $li(d,1,2) _ $lb($li($$$IKLANGUAGES,$li(d,3))))
	    }
	}
	
	$$$IKQENDCATCH(result,"",tSC)
}

Parameter GetDictionaryItemsRT = "dictItemId:%Integer,name:%String,URI:%String,defaultLanguage:%String";

///  Returns all Dictionary Items for the given Dictionary ID.
ClassMethod GetDictionaryItems(ByRef result, domainId As %Integer, dictId As %Integer, page As %Integer = 1, pageSize As %Integer = 10) As %Status
{
    $$$IKQBEGINTRY(result,"",tSC)
    if (domainId'=0) {
		$$$CHECKDOMAINEXISTSX(domainId,tSC)
    } else {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
	}
	$$$IKCHECKIDEXISTSX(^ISC.IK.Mat.DictId,domainId,+dictId,dictInfo,$$$IKDictionaryDoesNotExist,tSC)
	
	$$$IKSETPAGINGVARS(page,pageSize,usePaging,first,last,i)

    set diId = ""
    for {
        set diId = $order(^ISC.IK.Mat.DictToItem(domainId, dictId, diId))
        quit:diId=""
        
            
	    set i = i+1
	    $$$IKCHECKPAGING(usePaging,first,last,i)
	        
        set d = ^ISC.IK.Mat.DictItemId(domainId, diId)
        $$$IKQADDRESULT(result,i,$lb(+diId) _ $li(d,2,3) _ $lb($li($$$IKLANGUAGES,$li(d,4))))
    }
	$$$IKQENDCATCH(result,"",tSC)
}

Parameter GetDictionaryItemsAndTermsRT = "dictItemId:%Integer,name:%String,URI:%String,dictTermId:%Integer,string:%String,language:%String,isProcessed:%Boolean";

///  Returns all Dictionary Items and their Terms for the given Dictionary ID.
ClassMethod GetDictionaryItemsAndTerms(ByRef result, domainId As %Integer, dictId As %Integer, page As %Integer = 1, pageSize As %Integer = 10) As %Status
{
    $$$IKQBEGINTRY(result,"",tSC)
    if (domainId'=0) {
		$$$CHECKDOMAINEXISTSX(domainId,tSC)
    } else {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
	}
	$$$IKCHECKIDEXISTSX(^ISC.IK.Mat.DictId,domainId,+dictId,dictInfo,$$$IKDictionaryDoesNotExist,tSC)
	
	$$$IKSETPAGINGVARS(page,pageSize,usePaging,first,last,i)

    set diId = ""
    for {
        set diId = $order(^ISC.IK.Mat.DictToItem(domainId, dictId, diId))
        quit:diId=""
        
        set di = $lb(+diId) _ $li(^ISC.IK.Mat.DictItemId(domainId, diId),2,3)
        set terms = $g(^ISC.IK.Mat.DictItemTerms(domainId, diId))
        continue:terms=""
        
        set ptr = 0
        while ($listnext(terms, ptr, dtId)) {
            
	        set i = i+1
	        $$$IKCHECKPAGING(usePaging,first,last,i)
	        
            set d = ^ISC.IK.Mat.DictTermId(domainId,dtId)
            $$$IKQADDRESULT(result,i,di _ $lb(dtId, $li(d,3), $li($$$IKLANGUAGES,$li(d,4)), $lg(d,5)=$$$DTPROCESSED))
        }
    }
	$$$IKQENDCATCH(result,"",tSC)
}

Parameter GetDictionaryTermsByItemRT = "dictTermId:%Integer,string:%String,language:%String,isProcessed:%Boolean";

///  Returns all the Dictionary Terms for the given Dictionary Item ID.
ClassMethod GetDictionaryTermsByItem(ByRef result, domainId As %Integer, dictItemId As %Integer, page As %Integer = 1, pageSize As %Integer = 10) As %Status
{
	$$$IKQBEGINTRY(result,"",tSC)
    if (domainId'=0) {
		$$$CHECKDOMAINEXISTSX(domainId,tSC)
    } else {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
	}
	$$$IKCHECKIDEXISTSX(^ISC.IK.Mat.DictItemId,domainId,+dictItemId,details,$$$IKDictItemDoesNotExist,tSC)
	
	$$$IKSETPAGINGVARS(page,pageSize,usePaging,first,last,i)
	set ptr = 0, terms = $g(^ISC.IK.Mat.DictItemTerms(domainId, dictItemId))
	while ($listnext(terms, ptr, dtId)) {
		set i = i+1
		$$$IKCHECKPAGING(usePaging,first,last,i)
		
		set d = ^ISC.IK.Mat.DictTermId(domainId,dtId)
		$$$IKQADDRESULT(result,i,$lb(dtId, $li(d,3), $s($li(d,4):$li($$$IKLANGUAGES,$li(d,4)),1:""), $lg(d,5)=$$$DTPROCESSED))
	}
	$$$IKQENDCATCH(result,"",tSC)
}

Parameter DropAllDictionaryDataEXP [ Internal ] = 1;

/// Drops all dictionary data, including matching results. 
/// This method will fail if there are managed dictionaries in this domain.
ClassMethod DropAllDictionaryData(domainId As %Integer) As %Status
{
	set tSC = $$$OK
	try {
		$$$CHECKLICENSEX(tSC)
		$$$IKCHECKPRIVWRITEX(tSC)
		if (domainId'=0) {
			$$$CHECKDOMAINEXISTSX(domainId,tSC)
			$$$IKCHECKDOMMGRX(domainId,tSC)
	    } else {
			$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
		}
		
		// BDB385 - check manager class
		set tDictId = ""
		for {
			set tDictId = $order(^ISC.IK.Mat.DictId(domainId,tDictId), 1, tDictInfo)
			quit:tDictId=""
			
			set tMgrClass = $lg(^ISC.IK.Mat.DictId(domainId,tDictId),5)
			$$$IKCHECKMGRX("Dictionary",tDictId,tMgrClass,tSC)
		}
		quit:$$$ISERR(tSC)
		
		if (domainId) {
			set tSC = ##class(%iKnow.Matching.MatchingAPI).InvalidateMatchingResults(domainId,"",2)
		} else {
			set tXDictIds = ##class(%iKnow.Matching.MatchingAPI).GetAllDictsAsList(0)
			set tDomainId = ""
			for {
				set tDomainId = $order(^ISC.IK.Mat.DictMatchStatus(tDomainId))
				quit:tDomainId=""
				continue:'tDomainId
				
				set tSC = ##class(%iKnow.Matching.MatchingAPI).InvalidateMatchingResults(tDomainId,tXDictIds,1)
				quit:$$$ISERR(tSC)
			}
		}
		quit:$$$ISERR(tSC)
		
		set tGlobs = $lb(
	        "^ISC.IK.Mat.DictId",
	        "^ISC.IK.Mat.Dict",
	        "^ISC.IK.Mat.DictToItem",
	        "^ISC.IK.Mat.DictItemId",
	        "^ISC.IK.Mat.DictItemURI",
	        "^ISC.IK.Mat.DictItemTerms",
	        "^ISC.IK.Mat.DictTermId",
	        "^ISC.IK.Mat.DictTermElems",
	        "^ISC.IK.Mat.DictElementId",
	        "^ISC.IK.Mat.DictElement",
	        "^ISC.IK.Mat.DictElemString",
	        "^ISC.IK.Mat.DictElemStringId",
	        "^ISC.IK.Mat.DictFormatId",
	        "^ISC.IK.Mat.DictFormat",
	        "^ISC.IK.Mat.DictFormatElements",
	        "^ISC.IK.Mat.DictToFormat",
	        "^ISC.IK.Mat.DictMatchStatus"
	    )
	    set ptr = 0
	    while $listnext(tGlobs,ptr,tGlob) {
		    kill @tGlob@(domainId)
	    }
	    
	    // BDB385 - also kill root node with cross-domain version info
	    zkill:'domainId ^ISC.IK.Mat.DictId
	    
	    // BDB624 - purge custom indices
		set tTablesPackage = $s(domainId:$$$GETPARAMNODEF(domainId,$$$IKPPACKAGE),1:"")
		if (tTablesPackage'="") {
			do $classmethod(tTablesPackage_".Dictionary", "%PurgeIndices")
			do $classmethod(tTablesPackage_".DictionaryItem", "%PurgeIndices")
			do $classmethod(tTablesPackage_".DictionaryTerm", "%PurgeIndices")
		}
	    
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Returns whether or not a given Dictionary Term <var>pTermId</var> contains at least one
/// Dictionary Format element.
ClassMethod ContainsFormat(pDomainId As %Integer, pTermId As %Integer, Output pSC As %Status = {$$$OK}) As %Boolean [ Internal ]
{
	set pSC = $$$OK, tContainsFormat = 0
	try {
		//$$$CHECKDOMAINEXISTSX(pDomainId,pSC) // internal, so don't check
		set tElems = $g(^ISC.IK.Mat.DictTermElems(pDomainId, pTermId)), ptr = 0
		while $listnext(tElems,ptr,tElemId) {
			if ($lg($g(^ISC.IK.Mat.DictElementId(pDomainId,tElemId)),3)=$$$DEFORMAT) {
				set tContainsFormat = 1
				quit
			}
		}
	} catch (ex) {
		set pSC = ex.AsStatus()
	}
	quit tContainsFormat
}

Parameter GetTermElementsRT [ Internal ] = "dictElemId:%Integer,type:%Integer,valueId:%Integer,value:%String,position:%Integer,role:%Integer,minMatchScore:%Numeric,scoreMultiplier:%Numeric";

/// Retrieves the elements corresponding to a given <var>pDictionaryTermId</var>.
ClassMethod GetTermElements(ByRef pResult, pDomainId As %Integer, pDictionaryTermId As %Integer) As %Status [ Internal ]
{
	$$$IKQBEGINTRY(pResult,"",tSC)
    if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSX(pDomainId,tSC)
    } else {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
	}
	
	set ptr=0, tElems=$g(^ISC.IK.Mat.DictTermElems(pDomainId, pDictionaryTermId))
	while $listnext(tElems,ptr,tElemId) {
		set tElem = $g(^ISC.IK.Mat.DictElementId(pDomainId, tElemId))
		if ($li(tElem,3)=$$$DETERM) {
			set tValue = ##class(%iKnow.Queries.EntityAPI).GetValueInternal(pDomainId,$li(tElem,4))
		} else {
			set tSC = ..GetFormatDetails(pDomainId, $li(tElem,4), .tClass, .tParams)
			quit:$$$ISERR(tSC)
			set tValue = tClass_"["_$lts(tParams)_"]"
		}
		set tData = $lb(tElemId) _ $li(tElem,3,4) _ $lb(tValue) _ $li(tElem,5,7) _ $lb($lg(tElem,9,1))
		$$$IKQADDRESULT(pResult,$i(tCount),tData)
	}
	
	$$$IKQENDCATCH(pResult,"",tSC)
}

/// Retrieves the Dictionary format class and parameters for a given <var>pDictionaryFormatId</var>
ClassMethod GetFormatDetails(pDomainId As %Integer, pDictionaryFormatId As %Integer, Output pFormatClass As %String, Output pFormatParams As %List) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVREAD
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTS(pDomainId)
	} else {
		$$$IKXDOMDICTVERSION(xDomVersion)
	}
	set tFormat = $g(^ISC.IK.Mat.DictFormatId(pDomainId, +pDictionaryFormatId))
	set pFormatClass = $g(^ISC.IK.Sys.DictFormatD(+$lg(tFormat,1)))
	set pFormatParams = $lg(tFormat,2)
	quit $$$OK
}

ClassMethod GetDictionaryCount(pDomainId As %Integer, Output pSC As %Status = {$$$OK}) As %Integer
{
	$$$IKQBEGINR("",pSC,-1)
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSR(pDomainId,pSC,-1)
    } else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,pSC,-1)
	}
	
	set tDictId = "", tCount=0
	for {
		set tDictId = $order(^ISC.IK.Mat.DictId(pDomainId,tDictId))
		quit:tDictId=""
		set x = $i(tCount)
	}
	$$$IKQEND("",tCount)
}

ClassMethod GetItemCount(pDomainId As %Integer, pDictIds As %List = "", Output pSC As %Status) As %Integer
{
	$$$IKQBEGINR("",pSC,-1)
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSR(pDomainId,pSC,-1)
    } else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,pSC,-1)
	}
	
	$$$IKENSURELISTABS(pDictIds)
	set tCount=0
	if pDictIds'="" {
		set ptr=0
		while $listnext(pDictIds,ptr,tDictId) {
			set tDictItemId = ""
			for {
				set tDictItemId = $order(^ISC.IK.Mat.DictToItem(pDomainId, tDictId, tDictItemId))
				quit:tDictItemId=""
				set x = $i(tCount)
			}
		}
	} else {
		set tDictItemId = ""
		for {
			set tDictItemId = $order(^ISC.IK.Mat.DictItemId(pDomainId,tDictItemId))
			quit:tDictItemId=""
			set x = $i(tCount)
		}
	}
	$$$IKQEND("",tCount)
}

ClassMethod GetTermCount(pDomainId As %Integer, pDictIds As %List = "", Output pSC As %Status = {$$$OK}) As %Integer
{
	$$$IKQBEGINR("",pSC,-1)
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSR(pDomainId,pSC,-1)
    } else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,pSC,-1)
	}
	
	$$$IKENSURELISTABS(pDictIds)
	set tDictTermId="", tCount=0
	for {
		set tDictTermId = $order(^ISC.IK.Mat.DictTermId(pDomainId,tDictTermId),1,tTerm)
		quit:tDictTermId=""
		continue:(pDictIds'="")&&'$lf(pDictIds,$li(tTerm,1))
		set x = $i(tCount)
	}
	$$$IKQEND("",tCount)
}

ClassMethod GetTermCountByItem(pDomainId As %Integer, pDictItemIds As %List = "", Output pSC As %Status = {$$$OK}) As %Integer
{
	$$$IKQBEGINR("",pSC,-1)
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSR(pDomainId,pSC,-1)
    } else {
		$$$IKXDOMDICTVERSIONR(xDomVersion,pSC,-1)
	}
	
	$$$IKENSURELISTABS(pDictItemIds)
	
	set tDictTermId = "", tCount = 0
	for {
		set tDictTermId = $order(^ISC.IK.Mat.DictTermId(pDomainId,tDictTermId),1,tTerm)
		quit:tDictTermId=""
		continue:(pDictItemIds'="")&&'$lf(pDictItemIds,$li(tTerm,2))
		set x = $i(tCount)
	}
	$$$IKQEND("",tCount)
}

Parameter GetItemsByNameRT = "dictId:%Integer,dictName:%String,itemId:%Integer,itemName:%String,URI:%String,language:%String";

/// Note: <var>pFilter</var> is ignored when looking at cross-domain dictionaries
ClassMethod GetItemsByName(ByRef pResult, pDomainId As %Integer, pString As %String, pPage As %Integer = 1, pPageSize As %Integer = 10, pFilter As %iKnow.Filters.Filter = "", pDictIds As %List = "", pMode As %Integer = {$$$USEPARTS}, pCheck As %String(VALUELIST="NAME,URI") = "NAME", pLang As %String = "en") As %Status
{
	$$$IKQBEGINTRY(pResult,"^||%IK.Items,^||%IK.Matches",tSC)
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSX(pDomainId,tSC)
		$$$IKQFILTEROBJECTX(pDomainId,pFilter,tSC)
	} else {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
		set pFilter=""
	}
	$$$IKSETPAGINGVARS(pPage,pPageSize,tUsePaging,tFirst,tLast,tCount)
	$$$IKENSURELISTABS(pDictIds)
	
	set pString = $$$IKNORMALIZE(pString)
	set tUseStandardizedForm = $$$GETPARAMNODEF(pDomainId,$$$IKPMATSTANDARDIZEDFORM)
	set:tUseStandardizedForm'="" pString = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(pString, pLang, tUseStandardizedForm)
	
	set tStringLength = $length(pString)
	
	if $isobject(pFilter) && (pFilter.Selectivity<0.1) {
		
		set tOff=""
		for {
			set tOff = pFilter.GetNextSourceFilterOffset(tOff, .tBits)
			quit:tOff=""
			
			set tPos=0
			for {
				set tPos = $bitfind(tBits,1,tPos+1)
				quit:'tPos
				$$$IKGETIDOFFPOS(tSrcId,tOff,tPos)
				merge ^||%IK.Matches = ^ISC.IK.Mat.SrcToMatch(pDomainId,tSrcId)
			}
		}
		
		set tMatchId=""
		for {
			set tMatchId = $order(^||%IK.Matches(tMatchId))
			quit:tMatchId=""
			
			set ^||%IK.Items($li(^ISC.IK.Mat.MatchId(pDomainId,tMatchId),2))= ""
		}
		
		set tItemId=""
		for {
			set tItemId = $order(^||%IK.Items(tItemId))
			quit:tItemId=""
			
			set tItem = ^ISC.IK.Mat.DictItemId(pDomainId, tItemId)
			continue:(pDictIds'="")&&'$lf(pDictIds,$li(tItem,1))
			
			set tItemName = $$$IKNORMALIZE($li(tItem, $case(pCheck, "NAME":2, "URI":3)))
			set:(tUseStandardizedForm'="")&&(pCheck="NAME") tItemName = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(tItemName, $lg(tItem,4,pLang), tUseStandardizedForm)
			if (pMode=$$$USENGRAMS) {
				continue:'$find(tItemName,pString)
			} else {
				set tPos = $find(tItemName,pString)
				continue:'tPos
				continue:$zstrip($e(tItemName,tPos-tStringLength-1),"*PWC")'=""
				continue:(pMode=$$$USEWORDS)&&($zstrip($e(tItemName,tPos),"*PWC")'="")
			}
			
			set x = $i(tCount)
			$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
			$$$IKQADDRESULT(pResult,tCount,$lb($li(tItem,1),$li(^ISC.IK.Mat.DictId(pDomainId,$li(tItem,1))),+tItemId)_$li(tItem,2,4))
		}
		
	} else {
		
		set tItemId = ""
		for {
			set tItemId = $order(^ISC.IK.Mat.DictItemId(pDomainId,tItemId),1,tItem)
			quit:tItemId=""
			
			continue:(pDictIds'="")&&'$lf(pDictIds,$li(tItem,1))
			
			set tItemName = $$$IKNORMALIZE($li(tItem, $case(pCheck, "NAME":2, "URI":3)))
			set:(tUseStandardizedForm'="")&&(pCheck="NAME") tItemName = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(tItemName, $lg(tItem,4,pLang), tUseStandardizedForm)
			if (pMode=$$$USENGRAMS) {
				continue:'$find(tItemName,pString)
			} else {
				set tPos = $find(tItemName,pString)
				continue:'tPos
				continue:$zstrip($e(tItemName,tPos-tStringLength-1),"*PWC")'=""
				continue:(pMode=$$$USEWORDS)&&($zstrip($e(tItemName,tPos),"*PWC")'="")
			}
			
			if $isobject(pFilter) {
				set tItems(tItemId) = tItem
			} else {
				set x = $i(tCount)
				$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
				$$$IKQADDRESULT(pResult,tCount,$lb($li(tItem,1),$li(^ISC.IK.Mat.DictId(pDomainId,$li(tItem,1))),+tItemId)_$li(tItem,2,4))
			}
		}
		quit:'$isobject(pFilter)
		
		set tItemId="" 
		for {
			set tItemId=$order(tItems(tItemId),1,tItem)
			quit:tItemId=""
			
			set tMatchId=""
			for {
				set tMatchId = $order(^ISC.IK.Mat.DictItemToMatch(pDomainId,tItemId,tMatchId))
				quit:tMatchId=""
				
				set tMatch = ^ISC.IK.Mat.MatchId(pDomainId,tMatchId)
				set tTargetType = $li(tMatch,4), tTargetId = $li(tMatch,5)
				set tSrcId = ##class(%iKnow.Matching.MatchingAPI).GetSourceIdForMatchTarget(pDomainId,tTargetType,tTargetId)
				continue:'pFilter.IsFiltered(tSrcId)
				
				set x = $i(tCount)
				$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
				$$$IKQADDRESULT(pResult,tCount,$lb($li(tItem,1),$li(^ISC.IK.Mat.DictId(pDomainId,$li(tItem,1))),+tItemId)_$li(tItem,2,4))
				quit
			}
		}
	}
	
	$$$IKQENDCATCH(pResult,"^||%IK.Items,^||%IK.Matches",tSC)
}

Parameter GetTermsByNameRT = "dictId:%Integer,dictName:%String,itemId:%Integer,itemName:%String,URI:%String,termId:%Integer,term:%String,language:%String";

/// Note: <var>pFilter</var> is ignored when looking at cross-domain dictionaries
ClassMethod GetTermsByName(ByRef pResult, pDomainId As %Integer, pString As %String, pPage As %Integer = 1, pPageSize As %Integer = 10, pFilter As %iKnow.Filters.Filter = "", pDictIds As %List = "", pMode As %Integer = {$$$USEPARTS}, pLang As %String = "en") As %Status
{
	$$$IKQBEGINTRY(pResult,"^||%IK.Items,^||%IK.Matches,^||%IK.Terms",tSC)
	if (pDomainId'=0) {
		$$$CHECKDOMAINEXISTSX(pDomainId,tSC)
		$$$IKQFILTEROBJECTX(pDomainId,pFilter,tSC)
	} else {
		$$$IKXDOMDICTVERSIONX(xDomVersion,tSC)
		set pFilter=""
	}
	$$$IKSETPAGINGVARS(pPage,pPageSize,tUsePaging,tFirst,tLast,tCount)
	$$$IKENSURELISTNUM(pDictIds)
	
	set pString = $$$IKNORMALIZE(pString)
	set tUseStandardizedForm = $$$GETPARAMNODEF(pDomainId,$$$IKPMATSTANDARDIZEDFORM)
	set:tUseStandardizedForm'="" pString = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(pString, pLang, tUseStandardizedForm)
	
	set tStringLength = $length(pString)
	
	if $isobject(pFilter) && (pFilter.Selectivity<0.1) {
		
		set tOff=""
		for {
			set tOff = pFilter.GetNextSourceFilterOffset(tOff, .tBits)
			quit:tOff=""
			
			set tPos=0
			for {
				set tPos = $bitfind(tBits,1,tPos+1)
				quit:'tPos
				$$$IKGETIDOFFPOS(tSrcId,tOff,tPos)
				merge ^||%IK.Matches = ^ISC.IK.Mat.SrcToMatch(pDomainId,tSrcId)
			}
		}
		
		set tMatchId=""
		for {
			set tMatchId = $order(^||%IK.Matches(tMatchId))
			quit:tMatchId=""
			
			set ^||%IK.Terms($li(^ISC.IK.Mat.MatchId(pDomainId,tMatchId),3))= ""
		}
		
		set tTermId=""
		for {
			set tTermId = $order(^||%IK.Terms(tTermId))
			quit:tTermId=""
			
			set tTerm = ^ISC.IK.Mat.DictTermId(pDomainId, tTermId)
			set tDictId=$li(tTerm,1), tItemId=$li(tTerm,2)
			continue:(pDictIds'="")&&'$lf(pDictIds,tDictId)
			
			set tTermName = $$$IKNORMALIZE($li(tTerm, 3))
			set:(tUseStandardizedForm'="") tTermName = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(tTermName, $lg(tTerm,4,pLang), tUseStandardizedForm)
			if (pMode=$$$USENGRAMS) {
				continue:'$find(tTermName,pString)
			} else {
				set tPos = $find(tTermName,pString)
				continue:'tPos
				continue:$zstrip($e(tTermName,tPos-tStringLength-1),"*PWC")'=""
				continue:(pMode=$$$USEWORDS)&&($zstrip($e(tTermName,tPos),"*PWC")'="")
			}
			
			set x = $i(tCount)
			$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
			$$$IKQADDRESULT(pResult,tCount,$lb(tDictId,$li(^ISC.IK.Mat.DictId(pDomainId,tDictId)),tItemId)_$li(^ISC.IK.Mat.DictItemId(pDomainId,tItemId),2,3)_$lb(+tTermId)_$li(tTerm,2,4))
		}
		
	} else {
		
		set tTermId = ""
		for {
			set tTermId = $order(^ISC.IK.Mat.DictTermId(pDomainId,tTermId),1,tTerm)
			quit:tTermId=""
			
			set tDictId=$li(tTerm,1), tItemId=$li(tTerm,2)
			continue:(pDictIds'="")&&'$lf(pDictIds,tDictId)
			
			set tTermName = $$$IKNORMALIZE($li(tTerm, 3))
			set:(tUseStandardizedForm'="") tTermName = ##class(%iKnow.Matching.MatchingAPI).StandardizedForm(tTermName, $lg(tTerm,4,pLang), tUseStandardizedForm)
			if (pMode=$$$USENGRAMS) {
				continue:'$find(tTermName,pString)
			} else {
				set tPos = $find(tTermName,pString)
				continue:'tPos
				continue:$zstrip($e(tTermName,tPos-tStringLength-1),"*PWC")'=""
				continue:(pMode=$$$USEWORDS)&&($zstrip($e(tTermName,tPos),"*PWC")'="")
			}
			
			if $isobject(pFilter) {
				set tTerms(tTermId) = tTerm
			} else {
				set x = $i(tCount)
				$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
				$$$IKQADDRESULT(pResult,tCount,$lb(tDictId,$li(^ISC.IK.Mat.DictId(pDomainId,tDictId)),tItemId)_$li(^ISC.IK.Mat.DictItemId(pDomainId,tItemId),2,3)_$lb(+tTermId)_$li(tTerm,2,4))
			}
		}
		quit:'$isobject(pFilter)
		
		set tTermId="" 
		for {
			set tTermId=$order(tTerms(tTermId),1,tTerm)
			quit:tTermId=""
			
			set tMatchId="", tDictId=$li(tTerm,1), tItemId=$li(tTerm,2)
			for {
				set tMatchId = $order(^ISC.IK.Mat.DictItemToMatch(pDomainId,tItemId,tMatchId))
				quit:tMatchId=""
				
				set tMatch = ^ISC.IK.Mat.MatchId(pDomainId,tMatchId)
				continue:$li(tMatch,3)'=tTermId
				set tTargetType = $li(tMatch,4), tTargetId = $li(tMatch,5)
				set tSrcId = ##class(%iKnow.Matching.MatchingAPI).GetSourceIdForMatchTarget(pDomainId,tTargetType,tTargetId)
				continue:'pFilter.IsFiltered(tSrcId)
				
				set x = $i(tCount)
				$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
				$$$IKQADDRESULT(pResult,tCount,$lb(tDictId,$li(^ISC.IK.Mat.DictId(pDomainId,tDictId)),tItemId)_$li(^ISC.IK.Mat.DictItemId(pDomainId,tItemId),2,3)_$lb(+tTermId)_$li(tTerm,2,4))
				quit
			}
		}
	}
	
	$$$IKQENDCATCH(pResult,"",tSC)
}

/// Returns an identifier for the string value <var>pString</var> of a dictionary element.
/// If this string exists as a real Unique Entity, the corresponding entUniId is returned. 
/// Otherwise, the string is added to ^ISC.IK.Mat.DictElemStringId (if it didn't exist already)
/// and the corresponding dictElemStringId is returned.
/// In either case, a lookup entry in ^ISC.IK.Mat.DictElemString is added if it didn't exist already.
ClassMethod GetDictElemStringId(pDomainId As %Status, pString As %String, Output pSC As %Status = {$$$OK}) As %Integer [ Internal ]
{
	set pSC = $$$OK, tDEStringId = ""
	try {
		set tIndex = " "_pString
		
		if pDomainId && $d(^ISC.IK.EntUni(pDomainId, tIndex), tDEStringId) {
			set:'$d(^ISC.IK.Mat.DictElemString(pDomainId, tIndex)) ^ISC.IK.Mat.DictElemString(pDomainId, tIndex) = tDEStringId
			quit
		}
		
		set tDEStringId = $g(^ISC.IK.Mat.DictElemString(pDomainId, tIndex))
		quit:tDEStringId
		
		$$$IKLOCKX(pDomainId,^ISC.IK.Mat.DictElemStringId,pSC)
		set tDEStringId = $g(^ISC.IK.Mat.DictElemString(pDomainId, tIndex))
		quit:tDEStringId
		
		set tTLevel = $tlevel
		try {
			tstart
			set tDEStringId = $i(^ISC.IK.Mat.DictElemStringId(pDomainId))
			set ^ISC.IK.Mat.DictElemStringId(pDomainId, tDEStringId) = pString
			set ^ISC.IK.Mat.DictElemString(pDomainId, tIndex) = -tDEStringId
			tcommit
		} catch (ex) {
			set pSC = ex.AsStatus()
		}
		trollback:($tlevel>tTLevel) 1
		
		set tDEStringId = -tDEStringId
		
	} catch (ex) {
		set pSC = ex.AsStatus()
	}
	$$$IKUNLOCK(pDomainId,^ISC.IK.Mat.DictElemStringId)
	
	quit tDEStringId
}

}
