Include (%IKInclude, %IKPublic)

/// Main class for retrieving proximity information sources.
Class %iKnow.Semantics.ProximityAPI Extends %RegisteredObject [ System = 4 ]
{

Parameter GetProfileBySourceIdRT = "entUniId:%Integer,entity:%String,score:%Integer";

/// Returns the proximity profile for a given entity identified by <var>pEntUniId</var> in source <var>pSrcId</var>.
ClassMethod GetProfileBySourceId(ByRef pResult, pDomainId As %Integer, pEntUniId As %Integer, pSrcId As %Integer, pPage As %Integer = 1, pPageSize As %Integer = 10) As %Status
{
	$$$IKQBEGINTRY(pResult,"^||%IK.Prox",tSC)
	$$$CHECKLICENSEX(tSC)
	if (pSrcId<0) && (pDomainId=0) { } else { $$$CHECKDOMAINEXISTSX(pDomainId,tSC) }
	$$$CHECKASRCIDEXISTSX(pDomainId,pSrcId,tSrcDetails,vSrcId,tSC)
	$$$IKSETPAGINGVARS(pPage,pPageSize,tUsePaging,tFirst,tLast,tCount)
	quit:'pEntUniId
	
	// note that SP data is only stored once, whith lowest entity first, so we'll need two passes
	set gSrcDist = $s(vSrcId:$name(^ISC.IKV.SP.SrcDist(pDomainId,vSrcId)), 1:$name(^ISC.IK.SP.SrcDist(pDomainId,pSrcId)))
	set x = $sortbegin(^||%IK.Prox)
	set tOtherEntUniId = ""
	for {
		set tOtherEntUniId = $order(@gSrcDist@(tOtherEntUniId))
		quit:tOtherEntUniId=""
		quit:tOtherEntUniId>=pEntUniId
		continue:'$d(@gSrcDist@(tOtherEntUniId,pEntUniId),tDistance)
		set ^||%IK.Prox(-tDistance,tOtherEntUniId)=""
	}
	set tOtherEntUniId=""
	for {
		set tOtherEntUniId = $order(@gSrcDist@(pEntUniId,tOtherEntUniId),1,tDistance)
		quit:tOtherEntUniId=""
		set ^||%IK.Prox(-tDistance,tOtherEntUniId)=""
	}
	set x = $sortend(^||%IK.Prox)
	
	// now resort
	set tDistance=""
	for {
		set tDistance = $order(^||%IK.Prox(tDistance))
		quit:tDistance=""
		set tOtherEntUniId=""
		for {
			set tOtherEntUniId = $order(^||%IK.Prox(tDistance,tOtherEntUniId))
			quit:tOtherEntUniId=""
			set tCount = tCount+1
			$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
			$$$IKQADDRESULT(pResult,tCount,$lb(+tOtherEntUniId,##class(%iKnow.Queries.EntityAPI).GetValueInternal(pDomainId,tOtherEntUniId,vSrcId),-tDistance))
		}
		quit:tUsePaging&&(tCount>tLast)
	}
	
	$$$IKQENDCATCH(pResult,"^||%IK.Prox",tSC)
}

Parameter GetProfileBySourceRT = "entUniId:%Integer,entity:%String,score:%Integer";

/// Returns the proximity profile for a given entity <var>pEntity</var> in source <var>pExtId</var>.
ClassMethod GetProfileBySource(ByRef pResult, pDomainId As %Integer, pEntity As %String, pExternalId As %String, pPage As %Integer = 1, pPageSize As %Integer = 10) As %Status
{
	set tSrcId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(pDomainId, pExternalId, .tSC)
	quit:$$$ISERR(tSC) tSC
	set tEntUniId = ##class(%iKnow.Queries.EntityAPI).GetIdInternal(pDomainId, pEntity)
	quit:'tEntUniId $$$OK
	quit ..GetProfileBySourceId(.pResult, pDomainId, tEntUniId, tSrcId, pPage, pPageSize)
}

Parameter GetProfileRT = "entUniId:%Integer,entity:%String,score:%Integer";

/// Returns the proximity profile for the entity <var>pEntity</var>. This profile is calculated based
/// on the aggregated distance to <var>pEntity</var> in all paths in the domain (when <var>pFilter</var>=""),
/// optionally constrained to all paths in a specific set of sources (when <var>pFilter</var>!="")
ClassMethod GetProfile(ByRef pResult, pDomainId As %Integer, pEntity As %String, pPage As %Integer = 1, pPageSize As %Integer = 10, pFilter As %iKnow.Filters.Filter = "") As %Status
{
	$$$IKQBEGINTRY(pResult,"",tSC)
	$$$CHECKDOMAINEXISTSX(pDomainId,tSC)
	quit:$g(pEntity)=""
	
	set tEntUniId = ##class(%iKnow.Queries.EntityAPI).GetIdInternal(pDomainId, pEntity)
	quit:'tEntUniId
	
	set tSC = ..GetProfileById(.pResult, pDomainId, tEntUniId, pPage, pPageSize, pFilter)
	
	$$$IKQENDCATCH(pResult,"",tSC)
}

Parameter GetProfileByIdRT = "entUniId:%Integer,entity:%String,score:%Integer";

/// Returns the proximity profile for the entity represented by <var>pEntUniId</var>. See also <method>GetProfile</method>
ClassMethod GetProfileById(ByRef pResult, pDomainId As %Integer, pEntUniId As %Integer, pPage As %Integer = 1, pPageSize As %Integer = 10, pFilter As %iKnow.Filters.Filter = "") As %Status
{
	$$$IKQBEGINTRY(pResult,"^||%IK.Prox",tSC)
	$$$CHECKDOMAINEXISTSX(pDomainId,tSC)
	
	if (pFilter="") {
		set gAggregates = $name(^ISC.IK.SP.Value(pDomainId,pEntUniId))
	} else {
		$$$IKQFILTEROBJECTX(pDomainId,pFilter,tSC)
		set tJobN = +$job, gAggregates = $name(^CacheTemp.ISC.IK.Prox(tJobN))
		kill ^CacheTemp.ISC.IK.Prox(tJobN)
		if pFilter.FilteredSourceCount<1000 {
			set tOffset = ""
			for {
				set tOffset = pFilter.GetNextSourceFilterOffset(tOffset, .tBits)
				quit:tOffset=""
				do ..GetProfileByIdJob(pDomainId,pEntUniId,tOffset,tBits,tJobN)
			}
		} else {
			#dim tWorkMgr As %SYSTEM.WorkMgr
			set tWorkMgr = $system.WorkMgr.Initialize("/multicompile=1", .tSC)
			quit:$$$ISERR(tSC)
			
			set tOffset = ""
			for {
				set tOffset = pFilter.GetNextSourceFilterOffset(tOffset, .tBits)
				quit:tOffset=""
				
				set tSC = tWorkMgr.Queue("##class(%iKnow.Semantics.ProximityAPI).GetProfileByIdJob",pDomainId,pEntUniId,tOffset,tBits,tJobN)
				quit:$$$ISERR(tSC)
			}
			
			set tSC = tWorkMgr.WaitForComplete()
			quit:$$$ISERR(tSC)
		}
	}
	
	set x = $sortbegin(^||%IK.Prox)
	set tTargetId = ""
	for {
		set tTargetId = $order(@gAggregates@(tTargetId),1,tValue)
		quit:tTargetId=""
		
		set ^||%IK.Prox(-tValue,tTargetId)=""
	}
	set x = $sortend(^||%IK.Prox)
	kill:$g(tJobN) ^CacheTemp.ISC.IK.Prox(tJobN)
	
	$$$IKSETPAGINGVARS(pPage,pPageSize,tUsePaging,tFirst,tLast,tCount)
	set tValue="", tCount=""
	for {
		set tValue = $order(^||%IK.Prox(tValue))
		quit:tValue=""
		set tTargetId=""
		for {
			set tTargetId = $order(^||%IK.Prox(tValue,tTargetId))
			quit:tTargetId=""
			set tCount = tCount+1
			$$$IKCHECKPAGING(tUsePaging,tFirst,tLast,tCount)
			
			$$$IKQADDRESULT(pResult,tCount,$lb(+tTargetId, ##class(%iKnow.Queries.EntityAPI).GetValueInternal(pDomainId, tTargetId), -tValue))
			
			quit:tUsePaging&&(tCount>tLast)
		}
		quit:tUsePaging&&(tCount>tLast)
	}
	
	$$$IKQENDCATCH(pResult,"^||%IK.Prox,^CacheTemp.ISC.IK.Prox(+$g(tJobN))",tSC)
}

ClassMethod GetProfileByIdJob(pDomainId As %Integer, pEntUniId As %Integer, pOffset As %Integer, pBits As %CacheString, pJobID As %Integer) As %Status [ Internal ]
{
	set tPos = 0
	for {
		set tPos = $bitfind(pBits,1,tPos+1)
		quit:'tPos
		$$$IKGETIDOFFPOS(tSrcId,pOffset,tPos)
		
		merge tProx = ^ISC.IK.SP.SrcDist(pDomainId,tSrcId,pEntUniId)
		set tTargetId = ""
		for {
			set tTargetId = $order(tProx(tTargetId),1,tValue)
			quit:tTargetId=""
			set x = $i(^CacheTemp.ISC.IK.Prox(pJobID,tTargetId),tValue)
		}
		kill tProx
	}
	
	quit $$$OK
}

///  <p>Returned column summary for <method>GetClustersBySource</method>.</p>
Parameter GetClustersBySourceRT [ Internal ] = "entid:%Integer,entity:%String,score:%Numeric";

/// <p>Clusters a document to a set of proximity terms that best identify the documents content.</p>
ClassMethod GetClustersBySource(ByRef result, domainid As %Integer, srcid As %Integer, page As %Integer = 1, pagesize As %Integer = 10) As %Status [ Internal ]
{
	$$$IKQBEGINTRY(result,"^||%IK.ProxSum,^||%IK.Topics",tSC)
	$$$CHECKDOMAINEXISTSX(domainid,tSC)
	$$$CHECKSRCIDEXISTSX(domainid,srcid,tSC)
	$$$IKSETPAGINGVARS(page,pagesize,usePaging,first,last,count)

	set offset=""
	for {
		set offset=$o(^ISC.IK.SrcToEntUniBit(domainid,srcid,offset),1,bitstring)
		q:offset=""
		
		set pos=0
		for {
			set pos=$bitfind(bitstring,1,pos+1)
			q:pos=0
			
			$$$IKGETIDOFFPOS(uniId,offset,pos)
			set avgConRelSemDom = ($lg(^ISC.IK.EntSrcDetails(domainid,srcid,uniId),3)+$lg(^ISC.IK.EntSrcDetails(domainid,srcid,uniId),4))/2
			
			set topic=""
			for {
				set topic=$o(^ISC.IK.SP.Value(domainid,uniId,topic),1,val)
				q:topic=""
				
				set ^||%IK.ProxSum(topic)=$get(^||%IK.ProxSum(topic),0)+avgConRelSemDom
			}
		}
	}
	
	k ^||%IK.Topics
	set topic=""
	for {
		set topic=$o(^||%IK.ProxSum(topic),1,val)
		q:topic=""
		
		set ^||%IK.Topics(-val)=$lb(topic,^ISC.IK.EntUniId(domainid,topic),val)
	}
	k ^||%IK.ProxSum
	set val=""
	for {
		set val=$o(^||%IK.Topics(val),1,data)
		q:val=""
		
		set count=count+1
		$$$IKCHECKPAGING(usePaging,first,last,count)
		
		$$$IKQADDRESULT(result,count,data)
	}
	$$$IKQENDCATCH(result,"^||%IK.ProxSum,^||%IK.Topics",tSC)
}

///  <p>Returned column summary for <method>GetProfileForEntity</method>.</p>
Parameter GetProfileForEntityRT [ Internal ] = "entId:%Integer,entity:%String,proximity:%Numeric";

/// <p>Returns the proximity profile for a specified entity.</p>
/// <p>The proximity profile are those elements that most likely occur in close relationship to the provided entity within the sources in a domain.</p>
ClassMethod GetProfileForEntity(ByRef result, domainid As %Integer, entId As %Integer, page As %Integer = 1, pagesize As %Integer = 10) As %Status [ Internal ]
{
	$$$IKQBEGINTRY(result,"^||%IK.Prof,^||%IK.ProfCnt,^||%IK.ProfOrd",tSC)
	$$$CHECKDOMAINEXISTSX(domainid,tSC)
	$$$IKSETPAGINGVARS(page,pagesize,usePaging,first,last,count)
	
	set target = ""
	for {
		set target=$o(^ISC.IK.SP.Value(domainid,entId,target),1,dist)
		q:target=""
		
		set ^||%IK.Prof(target)=$g(^||%IK.Prof(target),0)+dist
		set ^||%IK.ProfCnt(target)=$g(^||%IK.ProfCnt(target),0)+1
	}
	
	k ^||%IK.ProfOrd
	set target=""
	for {
		set target=$o(^||%IK.Prof(target),1,dist)
		q:target=""
		
		set sum=^||%IK.ProfCnt(target)
		
		set ^||%IK.ProfOrd(-(dist/sum),target)=(dist/sum)
	}
	//k ^||%IK.Prof, ^||%IK.ProfCnt
	
	set ord=""
	for {
		set ord=$o(^||%IK.ProfOrd(ord))
		q:ord=""
		
		set target=""
		for {
			set target=$o(^||%IK.ProfOrd(ord,target),1,prox)
			q:target=""
			
			set count=count+1
			$$$IKCHECKPAGING(usePaging,first,last,count)
			
			$$$IKQADDRESULT(result,count,$lb(target,^ISC.IK.EntUniId(domainid,target),prox))
		}
		$$$IKCHECKPAGING(usePaging,first,last,count)
	}
	$$$IKQENDCATCH(result,"^||%IK.Prof,^||%IK.ProfCnt,^||%IK.ProfOrd",tSC)
}

}
