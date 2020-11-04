Include (%IKInclude, %IKPublic)

///  This class represents a domain registered in this namespace.
/// <p>When creating a domain, you should pass a value for <property>Name</property>
/// to its <method>%New</method> method.</p>
Class %iKnow.Domain Extends %Persistent [ Final, StorageStrategy = iKnowStorage, System = 4 ]
{

///  The automatically generated ID for this domain, which is unique across namespaces
Property Id As %Integer [ ReadOnly ];

///  The name of this domain, which should be unique within the namespace (case-insensitive)
Property Name As %String [ ReadOnly ];

/// Stores the iKnow data structure version number for this domain.
Property Version As %String [ InitialExpression = {$$$IKCURRENTVERSION}, ReadOnly ];

/// Describes which data structures are built and maintained when adding data to the domain.
/// This propery is for internal use only.
Property BuildFlags As %String [ Internal, ReadOnly ];

/// The name of the Domain Definition class managing this domain, if any.
/// See also <class>%iKnow.DomainDefinition</class>.
Property DefinitionClass As %String [ Calculated, ReadOnly, SqlComputeCode = { set {*} = ##class(%iKnow.Domain).%OpenId({Id}).GetParameter($$$IKPDEFINITIONCLASS)}, SqlComputed ];

Index PKINDEX On Id [ IdKey, PrimaryKey, Unique ];

Index NameIndex On Name [ Unique ];

///  Shorthand method to get the domain ID for a specific domain name, creating it if it does not
///  yet exist in this namespace.
ClassMethod GetOrCreateId(name As %String, sortField As %Integer = {$$$SORTBYFREQUENCY}, Output sc As %Status = {$$$OK}) As %Integer
{
    Set sc=$$$OK
    Set domain=$s(..Exists(name):..Open(name, .sc),1:..Create(name, sortField, .sc))
    If domain="" {
        // TODO: treat $ze thrown
    }
    Set id=domain.Id, domain=""
    Quit id
}

///  Creates a domain with the specified domain name in the given namespace. If no value is
///  supplied for <var>sortField</var>, it will assume the system-wide defaults. <var>buildFlags</var>
///  is either of "ALL" or "MINIMAL". An empty value will assume the system default.
///  <p><b>Deprecated</b>: use <method>%New</method> instead (supplying only the <var>name</var> parameter)</p>
ClassMethod Create(name As %String, sortField As %Integer = -1, Output sc As %Status = {$$$OK}, buildFlags As %String = "") As %iKnow.Domain
{
	set tDomain = ..%New(name, buildFlags)
	
	if ($g(tDomain)="") {
		// something went wrong, so capture the error and quit
		set sc = %objlasterror
		quit ""
	}
	
	// save
	set sc = tDomain.%Save()
	quit:$$$ISERR(sc) ""
	
	// try to set the sort field parameter
	if (sortField '= -1) {
		set sc = tDomain.SetParameter("SortField", sortField)
	}
	
	quit tDomain
}

///  Opens a domain object with the specified name
///  <p><b>Deprecated</b>: use <method>NameIndexOpen</method> instead</p>
ClassMethod Open(name As %String, Output sc As %Status = {$$$OK}) As %iKnow.Domain
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,"")
    quit ..NameIndexOpen(name)
}

///  Opens a domain object with the specified ID
///  <p><b>Deprecated</b>: use <method>%OpenId</method> instead</p>
ClassMethod OpenId(id As %Integer, Output sc As %Status = {$$$OK}) As %iKnow.Domain
{
	set sc = $$$OK
	$$$CHECKLICENSER(sc,"")
    quit ..PKINDEXOpen(id)
}

///  Checks whether a domain with the given name already exists within the namespace
///  <p><b>Deprecated</b>: use <method>NameIndexExists</method> instead</p>
ClassMethod Exists(name As %String) As %Boolean
{
    quit ..NameIndexExists(name)
}

/// Instantiates a new Domain object iwth the given domain name.
/// <var>pBuildFlags</var> is either of "ALL" or "MINIMAL". An emtpy value will result in the
/// system default being used.
Method %OnNew(pName As %String, pBuildFlags As %String = "") As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
		$$$CHECKLICENSEX(tSC)
		$$$IKCHECKPRIVADMINX(tSC)
		$$$IKCHECKNOTNULLX(pName,tSC)
		$$$IKCHECKSTRINGLENGTHX(pName,tSC)
		
		// check for name uniqueness right away, as it's a read-only propery
		// and the index is only validated after %OnBeforeSave() otherwise
		if ..NameIndexExists(pName) {
			set tSC = $$$ERROR($$$IKDomainExists, pName)
			quit
		}
		
        set i%Name = pName
        set i%Version = $$$IKCURRENTVERSION
        
        // BDB354 - translate build flag string to flag sequence
        set:pBuildFlags="" pBuildFlags = $$$DEFBUILDFLAGS
        set tBuildFlags = $$$IKBUILDFLAGSFLAGS(pBuildFlags)
        for i = 1:1:$l(tBuildFlags) {
	        if $case($a(tBuildFlags,i), $$$IKBFNEVER:0, $$$IKBFINIT:0, $$$IKBFBATCH:0, $$$IKBFALWAYS:0, :1) {
		        set tSC = $$$ERROR($$$IKIllegalDomainParamVal, "BuildFlags", pBuildFlags)
		        quit
	        }
        }
        quit:$$$ISERR(tSC)
        
        set i%BuildFlags = tBuildFlags
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	
	quit tSC
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	$$$IKCHECKPRIVADMIN
	
	set tSC = $$$OK
	try {
        if (insert) {
	        set tDomainId = $s(..Id:..Id, 1:($o(^ISC.IK.Sys.DomainD(""),-1)+1))
	        while 1 {
		        if '$d(^ISC.IK.Sys.DomainD(tDomainId)) {
			        lock +^ISC.IK.Sys.DomainD(tDomainId):0
			        quit:$test
		        }
		        set tDomainId = tDomainId+1
	        }
	        set i%Id = tDomainId
        } else {
        	$$$IKCHECKDOMMGRX(..Id,tSC)
        }
	} catch (ex) {
		set tSC = ex.AsStatus()
		lock:$g(tDomainId) -^ISC.IK.Sys.DomainD(tDomainId)
	}
	quit tSC
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
        
        if (insert) {
	        lock -^ISC.IK.Sys.DomainD(i%Id)
	        
	        // Setup default metadata fields
	        set tSC = ##class(%iKnow.Queries.MetadataAPI).AddField(i%Id, "DateIndexed", $lb($$$MDOPEQUAL, $$$MDOPNOTEQUAL, $$$MDOPSMALLER, $$$MDOPSMALLEROREQUAL, $$$MDOPLARGER, $$$MDOPLARGEROREQUAL),$$$MDDTDATE)
	        quit:$$$ISERR(tSC)
        
	        // Ensure there's a default configuration
	        do ##class(%iKnow.Configuration).CreateDefaultConfig()
        }
        
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

///  This method will drop all sources and subsequent indexes from this domain
Method DropData(dropMetadataDefinitions As %Boolean = 0, dropDictionaries As %Boolean = 0, dropTempGlobals As %Boolean = 1, dropBlackLists As %Boolean = 1, dropMetricDefinitions As %Boolean = 0) As %Status
{
	set tSC = $$$OK
	try {
		$$$IKCHECKPRIVADMINX(tSC)
	
		if (..%IsModified()) {
			set tSC = $$$ERROR($$$IKObjectModified, "Domain")
			quit
		}
		
		$$$IKCHECKDOMMGRX(..Id,tSC)
		
		// BDB572 - check if we should disable journalling and track if we need to restore it afterwards
		$$$IKDisableJournal(..Id)
		
	    If (dropTempGlobals) {
	        Set loader = ##class(%iKnow.Source.Loader).%New(..Id)
	        Set tSC = loader.ClearTemps(1)
	        Quit:$$$ISERR(tSC)
	        set loader = ""
	        
	        set tSC = ##class(%iKnow.Filters.Filter).ClearCachedFilters(..Id)
	        quit:$$$ISERR(tSC)
	    }
	    
	    set domainId = i%Id
	    $$$IKLOCKLOADX(domainId,tSC)
	    $$$IKLOCKUPGRX(domainId,tSC)
	    
	    Merge lst=^$GLOBAL
	    if $d(lst)<2 { // fallback if ^$GLOBAL fails
		    set tRS = ##class(%ResultSet).%New()
		    set tRS.ClassName = "%SYS.GlobalQuery", tRS.QueryName = "NameSpaceList"
		    set tSC = tRS.%Execute($namespace, "ISC.IK*", 1)
		    quit:$$$ISERR(tSC)
		    while tRS.%Next() {
			    set lst("^"_tRS.%GetData(1))=""
		    }
	    }
	    
	    // System globals that should never be dropped
	    Set nok=$lb("^ISC.IK.Sys.Params","^ISC.IK.Sys.Costs","^ISC.IK.Sys.DomainD","^ISC.IK.Sys.DomainI",
	    	        "^ISC.IK.Sys.ConfigD","^ISC.IK.Sys.ConfigI","^ISC.IK.Sys.ListerD","^ISC.IK.Sys.ListerI",
			"^ISC.IK.Sys.ListerAlias","^ISC.IK.Sys.ConverterD","^ISC.IK.Sys.ConverterI","^ISC.IK.Sys.NSParams",
			"^ISC.IK.Sys.ProcessorD","^ISC.IK.Sys.ProcessorI","^ISC.IK.Sys.UserDictD","^ISC.IK.Sys.UserDictI",
			"^ISC.IK.Sys.UserDictEntry","^ISC.IK.Sys.DictFormatD","^ISC.IK.Sys.DictFormatI","^ISC.IK.Sys.Definition",
			"^ISC.IK.Sys.StemmerConfigI", "^ISC.IK.Sys.StemmerConfigD")
	    For n=1:1:$ll(nok) {
		  Kill lst($li(nok,n))
	    }
	    // metadata globals
	    Kill:'dropMetadataDefinitions lst("^ISC.IK.Mdt.Field"),lst("^ISC.IK.Mdt.FieldId")
	    
	    // dictionary globals
	    set tHasDictionaries = ($d(^ISC.IK.Mat.DictElementId(domainId))>1)
	    If 'dropDictionaries {
	        Set nok=$lb("^ISC.IK.Mat.DictId","^ISC.IK.Mat.Dict","^ISC.IK.Mat.DictToItem",
		            "^ISC.IK.Mat.DictItemId","^ISC.IK.Mat.DictItemURI","^ISC.IK.Mat.DictItemTerms",
			    "^ISC.IK.Mat.DictTermId","^ISC.IK.Mat.DictTermElems","^ISC.IK.Mat.DictElementId","^ISC.IK.Mat.DictElement",
			    "^ISC.IK.Mat.DictElemString","^ISC.IK.Mat.DictFormatId","^ISC.IK.Mat.DictFormat",
			    "^ISC.IK.Mat.DictFormatElements","^ISC.IK.Mat.DictToFormat","^ISC.IK.Mat.Profile",
			    "^ISC.IK.Mat.DictMatchStatus", "^ISC.IK.Mat.EntUniToDictElem", "^ISC.IK.Mat.DictElemStringId")
			For n=1:1:$ll(nok) { Kill lst($li(nok,n)) }
	    }
	    
	    // blacklists
	    set tHasBlacklists = ($d(^ISC.IK.BlackListElements(domainId))>1)
	    kill:'dropBlackLists lst("^ISC.IK.BlackListId"), lst("^ISC.IK.BlackList"), lst("^ISC.IK.BlackListElements")
	    
	    // BDB572 - leave EntUni globals only in place if we're not dropping dictionaries or blacklists
	    // 			AND they are actually in use!
	    if ('dropDictionaries && tHasDictionaries) || ('dropBlackLists && tHasBlacklists) {
	    	kill lst("^ISC.IK.EntUniId"), lst("^ISC.IK.EntUni"), lst("^ISC.IK.EntUniHash"), lst("^ISC.IK.DataLoaded")
	    }
	    			
	    // metrics
	   	kill:'dropMetricDefinitions lst("^ISC.IK.Mtr.MetricId"), lst("^ISC.IK.Mtr.Metric"), lst("^ISC.IK.Mtr.MetricTarget")
	   	
	   	
	    Set glob="^ISC.IK"
	    For {
	        set glob=$o(lst(glob))
	        quit:$e(glob,1,7)'="^ISC.IK"
	        
	        set prefix = $e(glob,1,8)
	        
	        // these are taken care of earlier
	        continue:prefix="^ISC.IKT" 
	        continue:prefix="^ISC.IKS"
	        
	        if (prefix="^ISC.IK.") || (prefix="^ISC.IKV") || (prefix="^ISC.IKL") {
		        kill @glob@(domainId)
	        }
	    }
	    
	    if 'dropDictionaries || 'dropBlackLists {
		    // restore ^ISC.IK.EntUniDetails
		    set x = $sortbegin(^ISC.IK.EntUniDetails(domainId))
		    set entUniId = "", zeroes = $lb(0,0,0,0,0,0,0)
		    for {
			    set entUniId = $order(^ISC.IK.EntUniId(domainId,entUniId))
			    quit:entUniId=""
			    set ^ISC.IK.EntUniDetails(domainId, entUniId) = zeroes
		    }
		    set x = $sortend(^ISC.IK.EntUniDetails(domainId))
	    }
	    
	    // BDB608 - reset ^ISC.IK.DomainDetails
	    set ^ISC.IK.DomainDetails(domainId) = $lb(0,0,0,0,0,0,0,0,0,0)
	    
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	
	$$$IKRestoreJournal // BDB572
    
    if $g(domainId) {
	    $$$IKDOMAINCHANGED(domainId)
   	 	$$$IKUNLOCKLOAD(domainId)
   	 	$$$IKUNLOCKUPGR(domainId)
    }
    
    quit tSC
}

///  Utility method to delete a domain from the system, including its data, settings
///  and system global entries. 
///  <p><b>Deprecated</b>: use <method>%DeleteId</method> instead (accepts domain ID)</p>
ClassMethod Delete(domainName As %String) As %Status
{
	set dom = ..Open(domainName)
	quit:dom="" $$$ERROR($$$IKDomainNotExists, domainName)
	quit ..%DeleteId(dom.Id)
}

///  Utility method to delete a domain from the system, including its data, settings
///  and system global entries. 
/// <p><b>Deprecated</b>: use <method>%DeleteId</method> instead</p>
ClassMethod DeleteId(domainId As %Integer) As %Status
{
	$$$IKCHECKDOMMGR(domainId)
	quit ..%DeleteId(domainId)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	$$$IKCHECKPRIVADMIN
	
	set tSC = $$$OK
	try {
		set tDomain = ..%Open(oid)
		if '$isobject(tDomain) { set tSC = $$$ERROR($$$IKNoDomainWithId, oid)  quit  }
		
		$$$IKCHECKDOMMGRX(tDomain.Id,tSC)
		
		set tSC = tDomain.DropData(1, 1, 1, 1, 1)
		quit:$$$ISERR(tSC)
		
		// BDB563 - drop associated tables
		set tPackageName = tDomain.GetParameter($$$IKPPACKAGE)
		if (tPackageName'="") {
			set tSC = ##class(%iKnow.Tables.Utils).DropDomainTables(tPackageName)
			quit:$$$ISERR(tSC)
		}
    	
		// drop this domain's settings
		kill ^ISC.IK.Sys.Params(tDomain.Id)
		
		// BDB608 - drop additional details
		kill ^ISC.IK.DomainDetails(tDomain.Id)
		
		set tDomain=""
	
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Returns the current namespace-wide value for a domain parameter if there is one registered.
/// See <method>GetParameter</method> for more details on how to fetch the current
/// APPLICABLE parameter for a domain, as this method does not take any domain-specific
/// settings or hardcoded defaults into account.
ClassMethod GetSystemParameter(paramName As %String) As %String
{
	$$$IKCHECKPRIVREAD
	
	// BDB321 - also accept macro names
	set:$e(paramName,1,6)="$$$IKP" paramName = $system.iKnow.GetDomainParameterName(paramName)
	
	quit:(paramName="") $$$ERROR($$$IKIllegalDomainParameter, paramName)
	
	quit $g(^ISC.IK.Sys.NSParams(paramName))
}

/// Removes a namespace-level default parameter value for the given parameter name.
ClassMethod UnsetSystemParameter(paramName As %String) As %Status
{
	$$$IKCHECKPRIVADMIN
	
	// BDB321 - also accept macro names
	set:$e(paramName,1,6)="$$$IKP" paramName = $system.iKnow.GetDomainParameterName(paramName)
	
	quit:'$$$IKALLOWUSERSET(paramName) $$$ERROR($$$IKIllegalDomainParameter, paramName)
	quit:(paramName="") $$$ERROR($$$IKIllegalDomainParameter, paramName)
	
	if $$$IKONLYCHANGEWHENEMPTY(paramName) {
		quit:$d(^ISC.IK.DataLoaded)>9 $$$ERROR($$$IKEmptyDomainParamForSys, paramName)
	}
	
	kill ^ISC.IK.Sys.NSParams(paramName)
	quit $$$OK
}

/// Registers a domain parameter at the namespace level, for all domains in the current namespace.
/// If there is already a value registered, call <method>UnsetSystemParameter</method>
/// first to explicitly clear the current value.
ClassMethod SetSystemParameter(paramName As %String, paramValue As %String) As %Status
{
	$$$IKCHECKPRIVADMIN
	
	// BDB321 - also accept macro names
	set:$e(paramName,1,6)="$$$IKP" paramName = $system.iKnow.GetDomainParameterName(paramName)
	
	quit:(paramName="") $$$ERROR($$$IKIllegalDomainParameter, paramName)
	
	set currentValue = ..GetSystemParameter(paramName)
	quit:currentValue'="" $$$ERROR($$$IKSysParameterSet, currentValue)
	
	set tSC = ..CheckParameterValue(paramName, $g(paramValue), "")
	quit:$$$ISERR(tSC) tSC
	
	set ^ISC.IK.Sys.NSParams(paramName) = paramValue
	quit $$$OK
}

ClassMethod CheckParameterValue(paramName As %String, paramValue As %String, domain As %iKnow.Domain = "") As %Status [ Internal, Private ]
{
	quit:'$$$IKALLOWUSERSET(paramName) $$$ERROR($$$IKIllegalDomainParameter, paramName)
	
	if ($$$IKONLYCHANGEWHENEMPTY(paramName)) {
		if $isobject(domain) {
			quit:'domain.IsEmpty() $$$ERROR($$$IKDomainNonEmptyForParam, paramName)
		} else {
			quit:$d(^ISC.IK.DataLoaded)>9 $$$ERROR($$$IKEmptyDomainParamForSys, paramName)
		}
	}
	
	// parameter-specific checks
	set tDomainId = $s($isobject(domain):domain.Id, 1:0)
	if (paramName = $$$IKPMETADATAAPI) {
		
		quit:'##class(%Dictionary.CompiledClass).%ExistsId(paramValue) $$$ERROR($$$CompiledClassDoesNotExist, paramValue)
		
		if '$classmethod(paramValue, "%Extends", "%iKnow.Queries.MetadataI") {
			quit $$$ERROR($$$InvalidArgument)
		}
		
	} elseif (paramName = $$$IKPLANGUAGEFIELDNAME) && $isobject(domain) {
		
		quit:'##class(%iKnow.Queries.MetadataAPI).GetFieldId(domain.Id, paramValue) $$$ERROR($$$IKMDFieldDoesNotExistE, paramValue)
		
	} elseif (paramName = $$$IKPMATDEFAULTPROFILE) {
		
		if $isobject(paramValue) {
			quit:paramValue.%IsModified() $$$ERROR($$$IKMatProfileModified)
			set paramValue = paramValue.DomainId _":"_ paramValue.Name
		}
		quit:'$isobject(##class(%iKnow.Matching.MatchingProfile).GetProfileByName($s($isobject(domain):domain.Id, 1:0), paramValue)) $$$ERROR($$$IKMatProfileDoesNotExist, paramValue, $s($isobject(domain):domain.Id, 1:0))
		
	} elseif (paramName = $$$IKPDEFAULTCONFIG) {
		
		quit:'##class(%iKnow.Configuration).NameIndexExists(paramValue) $$$ERROR($$$IKConfigurationNotFound, paramValue)
		
	} elseif (paramName = $$$IKPSORTFIELD) {
		
		quit:(paramValue'=$$$SORTBYFREQUENCY)&&(paramValue'=$$$SORTBYSPREAD) $$$ERROR($$$IKIllegalDomainParamVal, paramName, paramValue)
		
	} elseif (paramName = $$$IKPMATSTANDARDIZEDFORM) {
		
		set tUseStemming = ($$$GETPARAM(tDomainId,$$$IKPSTEMMING,0)'=0)
		
		if (paramValue = $$$IKPMATSTANDARDIZEDFORMSTEMMING) {
			
			if 'tUseStemming {
				quit $$$ERROR($$$GeneralError, "Stemming should be enabled through the $$$IKPSTEMMING parameter for this option")
			}
			
		} elseif tUseStemming {
			
			quit $$$ERROR($$$GeneralError, "Standardized form matching is no longer available as a separate option when using stemming")
			
		} elseif (paramValue '= $$$IKPMATSTANDARDIZEDFORMTEXT)
			 && (paramValue '= $$$IKPMATSTANDARDIZEDFORMSTEMMING)
			 && '##class(%Dictionary.CompiledMethod).%ExistsId($p(paramValue,":",1)_"||"_$p(paramValue,":",1)) {
			quit $$$ERROR($$$IKIllegalDomainParamVal, paramName, paramValue)	
		}
		
	} elseif (paramName = $$$IKPSTEMMING) { // BDB600
		
		if '$lf($lb(0,1,"",$$$DEFAULTCONFIG),paramValue) && // system values
				'##class(%iKnow.Stemming.Configuration).NameIndexExists(paramValue) && // saved configs
				'##class(%Dictionary.CompiledClass).%ExistsId($piece(paramValue,":",1)) { // explicit configs
			quit $$$ERROR($$$GeneralError, "Stemming configuration '"_paramValue_"' does not exist")
		}
		
		// check if compatible with domain version
		if $isobject(domain) {
			$$$IKCHECKVERSIONATLEAST(tDomainId,$$$IKVERSIONSTEMMING)
		}
		
		if $$$GETPARAMNODEF(tDomainId,$$$IKPMATSTANDARDIZEDFORM)'="" {
			quit $$$ERROR($$$GeneralError, "Standardized form matching cannot be combined with $$$IKPSTEMMING")
		}
		
		if '$isobject(domain) && ($d(^ISC.IK.Mat.DictElementId(0))>1) { // BDB623
			quit $$$ERROR($$$GeneralError, "Cannot change namespace default for stemming if cross-domain dictionaries indexing results are present.")
		}
		
	}
	
	quit $$$OK
}

///  Sets a domain-specific parameter, overriding the system default
Method SetParameter(paramName As %String, paramValue As %String) As %Status
{
	$$$IKCHECKPRIVADMIN
	
	quit:..%IsModified() $$$ERROR($$$IKObjectModified, "Domain")
	$$$IKCHECKDOMMGR(..Id)
	
	// BDB321 - also accept macro names
	set:$e(paramName,1,6)="$$$IKP" paramName = $system.iKnow.GetDomainParameterName(paramName)
	
	set tSC = ..CheckParameterValue(paramName, $g(paramValue), $this)
	quit:$$$ISERR(tSC) tSC
	
    set ^ISC.IK.Sys.Params(..Id, paramName) = paramValue
    quit $$$OK
}

///  Unsets a domain-specific parameter, so it will use the system default again
Method UnsetParameter(paramName As %String) As %Status
{
	quit:..%IsModified() $$$ERROR($$$IKObjectModified, "Domain")
	$$$IKCHECKDOMMGR(..Id)
	
	// BDB321 - also accept macro names
	set:$e(paramName,1,6)="$$$IKP" paramName = $system.iKnow.GetDomainParameterName(paramName)
	
	quit:'$$$IKALLOWUSERSET(paramName) $$$ERROR($$$IKIllegalDomainParameter, paramName)
	
	quit:$$$IKONLYCHANGEWHENEMPTY(paramName)&&'..IsEmpty() $$$ERROR($$$IKDomainNonEmptyForParam, paramName)
	
    kill ^ISC.IK.Sys.Params(..Id, paramName)
    quit $$$OK
}

///  Returns the value used for parameter <var>paramName</var> for this domain. This can be a
/// domain-specific override (<var>definedAt</var> = "DOMAIN"), a namespace-wide default
/// (<var>definedAt</var> = "NAMESPACE") or the hardcoded default (<var>definedat</var> = "DEFAULT")  
Method GetParameter(paramName As %String, Output definedAt As %String = "DOMAIN") As %String
{
	$$$IKCHECKPRIVREAD
	
	quit:..%IsModified() ""
	
	// BDB321 - also accept macro names
	set:$e(paramName,1,6)="$$$IKP" paramName = $system.iKnow.GetDomainParameterName(paramName)
	
	if $d(^ISC.IK.Sys.Params(..Id, paramName), value) {
		set definedAt = "DOMAIN"
	} elseif $d(^ISC.IK.Sys.NSParams(paramName), value) {
		set definedAt = "NAMESPACE"
	} else {
		set definedAt = "DEFAULT"
		set value = $$$GETPARAMDEFAULT(paramName)
	}
    quit value
}

///  Utility query to retrieve a list of all registered Domains
/// <p><b>Deprecated</b>: Please use normal SQL queries to approach this class.</p>
Query GetAllDomains(pCurrentNamespaceOnly As %Boolean = 0, pIncludeRemote As %Boolean = 0) As %Query(ROWSPEC = "domainId:%Integer,domainName:%String,namespace:%String,version:%String") [ SqlProc ]
{
}

ClassMethod GetAllDomainsExecute(ByRef qHandle As %Binary, pCurrentNamespaceOnly As %Boolean = 0, pIncludeRemote As %Boolean = 0) As %Status [ Internal ]
{
	set tSC = $$$OK
	try {
		$$$CHECKLICENSEX(tSC)
		$$$IKCHECKPRIVREADX(tSC)
	
		kill tNamespaces
		if pCurrentNamespaceOnly {
			set tNamespaces($namespace) = ""
		} else {
			do List^%SYS.NAMESPACE(.tNamespaces,0,pIncludeRemote)
			quit:$$$ISERR(tSC)
		}
		
		kill ^||%IK.DomainList
		set tNamespace = ""
		for {
			set tNamespace = $order(tNamespaces(tNamespace))
			quit:tNamespace=""
			continue:$e(tNamespace,1,2)="^^"
			
			try {
				continue:'$d(^[tNamespace]ISC.IK.Sys.DomainD)
			} catch (ex) {
				continue // skip the ones we cannot connect to
			}
			
			set tDomainId = ""
			for {
				set tDomainId = $order(^[tNamespace]ISC.IK.Sys.DomainD(tDomainId), 1, tDomainInfo)
				quit:tDomainId=""
				
				set ^||%IK.DomainList($i(^||%IK.DomainList)) = $lb(tDomainId, $li(tDomainInfo,1), tNamespace, $li(tDomainInfo,3))
			}
		}
		
   		set qHandle = $lb("")
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
    quit tSC
}

ClassMethod GetAllDomainsClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetAllDomainsExecute ]
{
	kill ^||%IK.DomainList
  	quit $$$OK
}

ClassMethod GetAllDomainsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetAllDomainsExecute ]
{
	set tSC = $$$OK
	try {
		set Row=""
		set tIndex = $order(^||%IK.DomainList($lg(qHandle,1)),1,Row)
		set qHandle = $lb(tIndex)
		set AtEnd = (tIndex="")
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// This method has been deprecated. There is no need for "registering" or otherwise marking
/// domains that have been imported from globals or data files.
ClassMethod RegisterImportedDomain(domainId As %Integer) As %Status
{
	quit $$$OK
}

///  Returns whether or not a domain is empty. If there are any entities or remnants of (virtual)
///  sources, this method will return false.
Method IsEmpty() As %Boolean
{
	quit:..%IsModified() 1
	
	quit:(##class(%iKnow.Queries.EntityAPI).GetCountByDomain(..Id,,,,1)>0) 0
	quit:(##class(%iKnow.Queries.SourceAPI).GetCountByDomain(..Id)>0) 0
	quit:($d(^ISC.IKV.SrcId(..Id))>1) 0
	quit 1
}

/// This method renames an existing domain named <var>pFrom</var> to <var>pTo</var>, 
/// if there isn't already a domain with that name in this namespace. The domain ID does
/// not change.
ClassMethod Rename(pFrom As %String, pTo As %String) As %Status
{
	$$$CHECKLICENSE
	$$$IKCHECKPRIVADMIN
	
	set tSC = $$$OK
	try {
        lock +^ISC.IK.Sys.DomainD:2
    	if '$test { set tSC = $$$ERROR($$$IKFailedLockDomain, name)  goto err }
    	
		if '..NameIndexExists(pFrom) { set tSC = $$$ERROR($$$IKDomainNotExists, pFrom)  goto err }
		if ..NameIndexExists(pTo) && ($$$UPPER(pFrom)'=$$$UPPER(pTo)) { set tSC = $$$ERROR($$$IKDomainExists, pTo)  goto err }
		
		set tDomainId = ..NameIndexOpen(pFrom).Id
		$$$IKCHECKDOMMGRX(tDomainId,tSC)
		
		// update local globals
		kill ^ISC.IK.Sys.DomainI($$$UPPER(pFrom))
		set $li(^ISC.IK.Sys.DomainD(tDomainId),1) = pTo
		set ^ISC.IK.Sys.DomainI($$$UPPER(pTo)) = tDomainId
		
		// BDB557 - Update any orefs of the corresponding domain
		set tObj = ..%OpenId(tDomainId)
		set tSC = tObj.%Reload()
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
		goto err
	}
	lock -^ISC.IK.Sys.DomainD
	quit tSC
	
err
	lock -^ISC.IK.Sys.DomainD
    $$$IKERROR(0,sc,..%ClassName(1)_":Rename")
	quit tSC
}

/// <p>Returns an array <var>pParams</var> containing all the domain parameters registered
/// for this instance in the form: pParams(<i>paramName</i>) = <i>paramValue</i>.</p>
/// NOTE: this might include parameters that cannot be modified by end users, but will not
/// include values defined at the namespace level.
Method GetParameters(Output pParams) As %Status
{
	$$$IKCHECKPRIVREAD
	
	quit:..%IsModified() $$$ERROR($$$IKObjectModified, "Domain")
	
	set tSC = $$$OK
	try {
		kill pParams
		merge pParams = ^ISC.IK.Sys.Params(..Id)
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// <p>Returns the current version of this Caché instance, which is the version of any
/// newly created domain in this instance. Domains already created in this instance
/// before it was last upgraded or which were imported from other instances through other
/// means, may have earlier versions. To check the version of a particular domain, use
/// the <property>Version</property> property of a <class>%iKnow.Domain</class> instance.</p>
ClassMethod GetCurrentSystemVersion() As %String
{
	quit $$$IKCURRENTVERSION
}

/// Is used to get the value of an unknown property, redirecting to the domain parameter.
Method %DispatchGetProperty(Property As %String) [ ServerOnly = 1 ]
{
	set tValue = ..GetParameter(Property, .tDefinedAt)
	quit:tDefinedAt="DOMAIN" tValue
	quit ""
}

/// is used to set the value of an unknown property, redirecting to the domain parameter.
Method %DispatchSetProperty(Property As %String, Val) [ ServerOnly = 1 ]
{
	quit ..SetParameter(Property, Val)
}

Method %ConstructClone(deep As %Boolean = 0, ByRef cloned As %String, location As %String) As %RegisteredObject [ ServerOnly = 0 ]
{
	quit "" // not supported!
}

ClassMethod %DeleteExtent(concurrency As %Integer = -1, ByRef deletecount, ByRef instancecount, pInitializeExtent As %Integer = 1) As %Status [ ServerOnly = 0 ]
{
	quit $$$ERROR($$$MethodNotImplemented,"%iKnow.Domain:%DeleteExtent")
}

ClassMethod %KillExtentData() As %Status [ Private, ServerOnly = 1 ]
{
	quit $$$ERROR($$$MethodNotImplemented,"%iKnow.Domain:%KillExtentData")
}

/// This method assigns <var>pDomainId</var> as this domain's desired <property>Id</property> property,
/// if no value has been set so far. If the value is already taken when calling this method, an error
/// will be returned. If the value has already been taken by the time this domain object is saved,
/// the next available ID value will be assigned.
Method AssignId(pDomainId As %Integer) As %Status [ Internal ]
{
	quit:..Id $$$ERROR($$$GeneralError, "ID for this domain has already been set")
	quit:..%ExistsId(pDomainId) $$$ERROR($$$GeneralError, "ID already taken")
	set i%Id = pDomainId
	quit $$$OK
}

Storage iKnowStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MainMap">
<Data name="BuildFlags">
<Piece>4</Piece>
</Data>
<Data name="Name">
<Piece>1</Piece>
</Data>
<Data name="Version">
<Piece>3</Piece>
</Data>
<Global>^ISC.IK.Sys.DomainD</Global>
<Subscript name="1">
<Expression>{Id}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="NameIndex">
<Data name="Id"/>
<Global>^ISC.IK.Sys.DomainI</Global>
<RowIdSpec name="1">
<Expression>{Id}</Expression>
<Field>Id</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>$$$UPPER({Name})</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^ISC.IK.Sys.DomainS</StreamLocation>
<Type>%Library.CacheSQLStorage</Type>
}

}
