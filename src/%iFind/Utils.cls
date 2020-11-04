Include %IFInclude

/// This class offers a number of utility methods for working with %iFind
Class %iFind.Utils Extends %iFind.FindUtils [ System = 4 ]
{

/// <p>Normalizes the supplied <var>pSearchString</var> into an unambiguous combination of atomic
/// search strings, combined with AND, OR and NOT operators and appropriately surrounded by
/// parentheses for clarifying operator precedence.</p>
/// <example language="SQL">SELECT %iFind.NormalizeSearchString('abc or (def* and not xyz)')</example>
/// <p>See also <method>TestSearchString</method></p>
ClassMethod NormalizeSearchString(pSearchString As %String, Output pSC As %Status) As %String [ SqlName = NormalizeSearchString, SqlProc ]
{
	set pSC = ..TestSearchString(pSearchString, .tNormalized)
	quit tNormalized
}

/// <p>Validates whether the supplied <var>pSearchString</var> is correct according to iFind search
/// syntax rules, returning a <class>%Status</class> object capturing the correctness ($$$OK if the
/// supplied string is valid, an error code if it is not).</p>
/// <example language="SQL">SELECT %iFind.TestSearchString('abc or (def* and not xyz)')</example>
/// <p>This method will also return a cleaned and unambiguous version of the search string through
/// the <var>pNormalized</var> output argument. See also <method>NormalizeSearchString</method>.</p>
/// 
ClassMethod TestSearchString(pSearchString As %String, Output pNormalizedString As %String, Output pDidYouMean As %String) As %Status [ SqlName = TestSearchString, SqlProc ]
{
	set tSC = $$$OK, pNormalizedString = "", pDidYouMean = ""
	try {
		// parse input (throws error on failure)
		do ParseMulti^%IFParser(pSearchString, .tSearchTree)
		
		set pNormalizedString = $$FormatTree^%IFParser(.tSearchTree)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	
	if $$$ISERR(tSC) {
		set tErrorCode = $system.Status.GetErrorCodes(tSC)
		if (tErrorCode = $system.Status.GetErrorCodes($$$ERROR($$$IFSyntaxBrackets))) {
			quit:$$TryAlternative(pSearchString_")") tSC
			quit:$$TryAlternative("("_pSearchString) tSC
		}
		
	}
	
	quit tSC
	
TryAlternative(tString)
	set tOK = 0
	try {
		do ParseMulti^%IFParser(tString)
		set tOK = 1
	} catch { }
	set:tOK pDidYouMean = tString
	quit tOK
}

/// Rebuild the all iFind indices on the system (in all namespaces), optionally filtered to index class
/// <var>indexType</var>
ClassMethod RebuildFullIndices(indexType As %String = "") [ Internal ]
{
	set result=##class(%ResultSet).%New("%SYS.Namespace:List")
	set sc=result.Execute(0,0)
	$$$THROWSTATUS(sc)
	while (result.Next()) {
		set nsp = result.GetData(1)
		set status = result.GetData(2)
		continue:status=0
		
		do ..RebuildFullIndicesInNamespace(nsp,indexType)
	}
}

/// Rebuild all iFind indices in the specified namespace, defaulting to the current namespace.
/// Optionally filter indices to index class <var>indexType</var>
ClassMethod RebuildFullIndicesInNamespace(namespace As %String = {$namespace}, indexType As %String = "")
{
	// Clean all ^ISC.IF globals in namespace
	
	set currentNamespace = $namespace
	if (namespace'=currentNamespace) && ('##class(%SYS.Namespace).Exists(namespace)) {
		THROW ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Namespace: "_namespace_" does not exists"))
	}
	
	k indices
	set result=##class(%ResultSet).%New("%iFind.Utils:GetIndicesInNamespace")
	set sc=result.Execute(namespace, indexType)
	$$$THROWSTATUS(sc)
	while (result.Next()) {
		set schema=result.GetData(2), class=result.GetData(3), index=result.GetData(4)
		set indices(schema_"."_class)=$g(indices(schema_"."_class))_$lb(index)
	}
	set result=""
	
	zn:(namespace'=currentNamespace) namespace
	
	// Purge indices
	set class=""
	for {
		set class=$o(indices(class),1,indexList)
		q:class=""
		
		set sc=$classmethod(class,"%PurgeIndices",indexList)
		$$$THROWSTATUS(sc)
	}
	
	// Clean globals
	set name="^ISC.IF"
	for {
		set name=$o(^$GLOBAL(name))
		q:name=""
		q:$e(name,1,$length("^ISC.IF."))'="^ISC.IF."
		
		k @name
	}
	
	// Rebuild indices
	set class=""
	for {
		set class=$o(indices(class),1,indexList)
		q:class=""
		
		set sc=$classmethod(class,"%BuildIndices",indexList)
		$$$THROWSTATUS(sc)
	}
	
	zn:currentNamespace'=namespace currentNamespace
}

/// returns all iFind indices in the namespace
Query GetIndicesInNamespace(namespace As %String = {$namespace}, indexType As %String = "") As %Query(ROWSPEC = "namespace:%String,schema:%String,class:%String,index:%String,typeClass:%String") [ SqlProc ]
{
}

ClassMethod GetIndicesInNamespaceExecute(ByRef qHandle As %Binary, namespace As %String = {$namespace}, indexType As %String = "") As %Status [ Internal ]
{
	k qHandle
	
	set currentNamespace = $namespace
	if (namespace'=currentNamespace) {
		if ('##class(%SYS.Namespace).Exists(namespace)) {
			quit $$$OK
		}
		zn namespace
	}
	
	&sql(declare curs cursor for select parent, name, TypeClass from %Dictionary.CompiledIndex WHERE TypeClass %STARTSWITH '%iFind')
	&sql(open curs)
	
	for {
		&sql(fetch curs into :className, :indexName, :tTypeClass)
		quit:SQLCODE=100
		
		continue:(indexType'="")&&(tTypeClass'=indexType)
		
		set qHandle($i(qHandle))=$lb(namespace,$piece(className,".",1,$l(className,".")-1),$piece(className,".",$length(className,".")),indexName,tTypeClass)
	}
	
	set qHandle=0
	
	&sql(close curs)

	zn:(namespace'=currentNamespace) currentNamespace

	Quit $$$OK
}

ClassMethod GetIndicesInNamespaceClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetIndicesInNamespaceExecute ]
{
	Quit $$$OK
}

ClassMethod GetIndicesInNamespaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetIndicesInNamespaceExecute ]
{
	set Row=""
	set AtEnd=0
	
	set idx=$o(qHandle(qHandle),1,data)
	if (idx="") {
		set AtEnd=1
	} else {
		set Row=data
		set qHandle=idx
	}
	
	Quit $$$OK
}

/// Returns all iFind indices in <var>class</var>
Query GetIndicesInClass(namespace As %String = {$namespace}, class As %String) As %Query(ROWSPEC = "namespace:%String,schema:%String,class:%String,index:%String,typeClass:%String") [ SqlProc ]
{
}

ClassMethod GetIndicesInClassExecute(ByRef qHandle As %Binary, namespace As %String = {$namespace}, class As %String, indexType As %String = "%iFind.Index") As %Status [ Internal ]
{
	k qHandle
	
	set currentNamespace = $namespace
	if (namespace'=currentNamespace) && ('##class(%SYS.Namespace).Exists(namespace)) {
		quit $$$OK
	}
	zn:(namespace'=currentNamespace) namespace
	
	set fqn = $$$UPPER(class)
	&sql(declare curs2 cursor for select parent, name, TypeClass from %Dictionary.CompiledIndex where UPPER(parent)=:fqn AND TypeClass %STARTSWITH '%iFind')
	&sql(open curs2)
	
	for {
		&sql(fetch curs2 into :className, :indexName, :tIndexType)
		quit:SQLCODE=100
		
		set qHandle($i(qHandle))=$lb(namespace,$piece(className,".",1,$l(className,".")-1),$piece(className,".",$length(className,".")),indexName,tIndexType)
	}
	
	set qHandle=0
	
	&sql(close curs2)

	zn:(namespace'=currentNamespace) currentNamespace

	Quit $$$OK
}

ClassMethod GetIndicesInClassClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetIndicesInClassExecute ]
{
	Quit $$$OK
}

ClassMethod GetIndicesInClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetIndicesInClassExecute ]
{
	set Row=""
	set AtEnd=0
	
	set idx=$o(qHandle(qHandle),1,data)
	if (idx="") {
		set AtEnd=1
	} else {
		set Row=data
		set qHandle=idx
	}
	
	Quit $$$OK
}

/// returns all indices of a type in the complete system
Query GetIndices(indexType As %String = "") As %Query(ROWSPEC = "namespace:%String,schema:%String,class:%String,index:%String,typeClass:%String") [ Internal ]
{
}

ClassMethod GetIndicesExecute(ByRef qHandle As %Binary, indexType As %String = "") As %Status [ Internal ]
{
	k qHandle
	
	set sc=$$$OK
	set result=##class(%ResultSet).%New("%SYS.Namespace:List")
	set sc=result.Execute(0,0)
	quit:$$$ISERR(sc) $$$OK
	while (result.Next()) {
		set nsp = result.GetData(1)
		set status = result.GetData(2)
		continue:status=0
		
		set result2=##class(%ResultSet).%New("%iFind.Utils:GetIndicesInNamespace")
		set sc=result2.Execute(nsp)
		quit:$$$ISERR(sc)
		while (result2.Next()) {
			set qHandle($i(qHandle))=$lb(result2.GetData(1),result2.GetData(2),result2.GetData(3),result2.GetData(4),result2.GetData(5))
		}
		set result2=""
	}
	set result=""
	
	set qHandle=0
	
	Quit $$$OK
}

ClassMethod GetIndicesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetIndicesExecute ]
{
	Quit $$$OK
}

ClassMethod GetIndicesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetIndicesExecute ]
{
	set Row=""
	set AtEnd=0
	
	set idx=$o(qHandle(qHandle),1,data)
	if (idx="") {
		set AtEnd=1
	} else {
		set Row=data
		set qHandle=idx
	}
	
	Quit $$$OK
}

/// <p>Utility function to retrieve words "similar" to the supplied search string, that have occurred
/// in indexing results for this namespace. For the <var>pSearchValue</var> argument, the same 
/// syntax is available as for regular word search in an iFind search call, where now the matching
/// words rather than records containing them will be retrieved. Composite search syntax (AND, OR, NOT)
/// is not supported.</p>
/// <p><var>pSearchOption</var> supports the same values as for a regular iFind search ($$$IFSEARCHNORMAL,
/// $$$IFSEARCHSTEMMED, $$$IFSEARCHDECOMPOUNDED, $$$IFSEARCHPATTERN and $$$IFSEARCHFUZZY), although
/// in the case of stemmed or decompounded search, the results will be limited to those word forms
/// having been indexed by an iFind index with stemming resp decompounding enabled in this namespace.
/// For these two options, the <var>pLanguage</var> argument is also required (but ignored for other
/// search modes).</p>
/// <p>The <var>pStrippedWordsOnly</var> flag can be used to only retrieve words that have been stripped
/// of all leading and trailing punctuation (default) or include all actual forms as encountered
/// by iFind indices in this namespace given their respective punctuation-stripping settings.</p>
/// <p>Note that this method only retrieves words appearing in indices whose shared data is stored
/// namespace-wide (the default). See also the IFINDSHAREDSTORAGELOCATION parameter in 
/// <class>%iFind.Index.Basic</class>.</p>
Query FindWords(pSearchValue As %String, pSearchOption As %String = {$$$IFSEARCHNORMAL}, pStrippedWordsOnly As %Boolean = 1, pLanguage As %String = "en") As %Query(ROWSPEC = "WordId:%Integer,Word:%String") [ SqlName = FindWords, SqlProc ]
{
}

/// <p>Utility function to retrieve entities "similar" to the supplied search string, that have occurred
/// in indexing results for this namespace. For the <var>pSearchValue</var> argument, the same 
/// syntax is available as for regular word search in an iFind search call for each word "position"
/// in the supplied search string. For example, the following request will retrieve entities such as
/// "matched words", "matching word" and "all matching words":</p>
/// <example language="SQL">CALL %iFind.FindEntities('match* word*')</example>
/// <p>Composite search syntax (AND, OR, NOT) is not supported, but you can use a lone asterisk to 
/// accept <i>any</i> at a given position.</p>
/// <p><var>pSearchOption</var> supports the same values as for a regular iFind search ($$$IFSEARCHNORMAL,
/// $$$IFSEARCHSTEMMED, $$$IFSEARCHDECOMPOUNDED, $$$IFSEARCHPATTERN and $$$IFSEARCHFUZZY), although
/// in the case of stemmed or decompounded search, the results will be limited to those entity forms
/// having been indexed by an iFind index with stemming resp decompounding enabled in this namespace.
/// For these two options, the <var>pLanguage</var> argument is also required (but ignored for other
/// search modes).</p>
/// <p>The <var>pStrippedEntitiesOnly</var> flag can be used to only retrieve entities that have been stripped
/// of all (per-word) leading and trailing punctuation (default) or include all actual entities as encountered
/// by iFind indices in this namespace given their respective punctuation-stripping settings.</p>
/// <p>To filter or sort these results according to a particular index, the (Analytic) index will have
/// to have its IFINDADVANCED parameter set to 2, so this procedure's results can be JOINed to the
/// generated "EntSpread" table. For example, with a table <tt>Experiment.IFData</tt> and iFind
/// index <tt>iText</tt>:</p>
/// <example language="SQL">SELECT
/// 	e.EntityId, e.Entity, s.Spread 
/// FROM 
/// 	%iFind.FindEntities('a*') e 
/// 	JOIN Experiment_IFData.IFData_iText_EntSpread s 
/// 		ON e.EntityId = s.EntityId
/// ORDER BY Spread DESC</example>
/// <p>Note that this method only retrieves entities appearing in indices whose shared data is stored
/// namespace-wide (the default). See also the IFINDSHAREDSTORAGELOCATION parameter in 
/// <class>%iFind.Index.Basic</class>.</p>
Query FindEntities(pSearchValue As %String, pSearchOption As %String = {$$$IFSEARCHNORMAL}, pStrippedEntitiesOnly As %Boolean = 1, pLanguage As %String = "en") As %Query(ROWSPEC = "EntityId:%Integer,Entity:%String") [ SqlName = FindEntities, SqlProc ]
{
}

/// Internal utility method for retrieving the default set of index parameters
ClassMethod GetDefaultIndexParams(Output pParams) [ Internal ]
{
	// %iFind.Index.Basic
	set pParams("LANGUAGE")="en"
	set pParams("INDEXOPTION")=0
	set pParams("LOWER")=1
	set pParams("KEEPCHARS")=$$$STRIPKEEP
	set pParams("USERDICTIONARY")=""
	set pParams("STEMMINGCONFIG")=""
	set pParams("COMPILEDVERSION")=$system.Version.GetNumber()
	set pParams("IFINDMAPPINGS")=0
	set pParams("IFINDSHAREDDATALOCATION")="NAMESPACE"
	set pParams("RANKERCLASS")=$$$IFDEFAULTRANKER
	
	// %iFind.Index.Semantic
	set pParams("IFINDATTRIBUTES")=0
	set pParams("IFINDADVANCEDSQLPREFIX")=""
	
	// %iFind.Index.Analytic
	set pParams("IFINDADVANCED")=0 // deprecated
	quit $$$OK
}

/// <p>This SQL function returns a score for how well record <var>pRecordId</var> matches the supplied search
/// string <var>pSearchString</var>, according to the ranker implementation <var>pRankerClass</var>.
/// This method can be invoked through SQL directly to override the default ranker class used by
/// the Rank procedure that's generated automatically on the iFind-indexed class.</p>
/// <example language="SQL">SELECT %ID, 
/// 	Title,
/// 	FullText,
/// 	%iFind.Rank('%iFind.Rank.TFIDF', 'SomePackage.TheTable', 'MyIndex', %ID, 'cocktail* OR (hammock AND NOT bees)') As Rank
/// FROM SomePackage.TheTable
/// WHERE %ID %FIND search_index(MyIndex, 'cocktail* OR (hammock AND NOT bees)')
/// ORDER BY 4 DESC</example>
/// <p>See also <class>%iFind.Rank.Abstract</class>.</p>
ClassMethod Rank(pRankerClass As %String = {$$$IFDEFAULTRANKER}, pClassName As %String, pIndexName As %String, pRecordId As %CacheString, pSearchString As %String, pSearchOptions As %String = {$$$IFSEARCHNORMAL}, Output pSC As %Status) As %Float [ SqlName = Rank, SqlProc ]
{
	set pSC = $$$OK, tScore = 0
	try {
		quit:'$d(pRecordId)
		
		set pSC = $system.Context.iFind().GetRanker(.tRanker, pRankerClass, pClassName, pIndexName, pSearchString, pSearchOptions)
		quit:$$$ISERR(pSC)
		
		set tScore = tRanker.GetRecordScore(pRecordId, .pSC)
		quit:$$$ISERR(pSC)
		
	} catch (ex) {
		set %sqlcontext.%SQLCODE = ex.AsSQLCODE()
		set %sqlcontext.%Message = ex.AsSQLMessage()
		throw ex
	}
	if $$$ISERR(pSC) {
		set %sqlcontext.%SQLCODE = $system.Status.StatusToSQLCODE(pSC, .tMessage)
		set %sqlcontext.%Message = tMessage
		$$$ThrowStatus(pSC)
	}
	quit tScore
}

/// <p>This SQL procedure returns a marked-up version of <var>pText</var>, in which all matches of the
/// supplied <var>pSearchString</var> are highlighted using <var>pTags</var>.</p>
/// <example language="SQL">SELECT %iFind.Highlight('Great cocktails by the pool, but the bees were a bit of a bummer.', 'cocktail* OR (hammock AND NOT bees)')</example>
/// <p><var>pTags</var> is a comma-separated list of tags to use for highlighting. If only a single one
/// is supplied, it will be used to highlight all matches of search terms. If a second one is supplied,
/// it will be used for all terms in a NOT node of the search tree (such as 'bees' in the above example),
/// while the first will be used for all other terms.</p> 
/// <p><var>pLimit</var> can be used to limit the text to a maximum number of hits rather than returning
/// the entire, highlighted text. <var>pSearchOption</var> can be used as in other iFind search operations,
/// for example to also mark fuzzy matches or stem matches.</p>
ClassMethod Highlight(pText As %String, pSearchString As %String, pSearchOption As %String = {$$$IFSEARCHNORMAL}, pTags As %String = {$$$IFDEFAULTHLTAGS}, pLimit As %Integer = 0, pLanguage As %String = "en", Output pSC As %Status) As %String [ SqlName = Highlight, SqlProc ]
{
	set pSC = $$$OK, tString = ""
	try {
		#dim tIndexer As %iKnow.Indexer
		do ($system.Context.iFind()).GetIndexer(pLanguage, .tDirectInput, .tIndexer)
		if '$isobject($g(tIndexer)) { set pSC = $g(%objlasterror) quit }
		
		do ##class(%iFind.Utils).GetDefaultIndexParams(.tParams)
		set tParams("LANGUAGE") = pLanguage
		if (pSearchOption'=0) {
			if +pSearchOption {
				set tParams("INDEXOPTION") = +pSearchOption
			} else {
				set tParams("TRANSFORMATIONSPEC") = pSearchOption
			}
		}
		
		set pSC = tIndexer.BufferString(pText)
		quit:$$$ISERR(pSC)
		
		set tRecordId = 0
		do ##class(%iFind.Filer.Transient).FileIndex(tDirectInput, tIndexer, "", "", tRecordId, .tParams)
		
		set tString = ..HighlightInternal("^||%IF.Transient", "^||%IF.Transient", "%iFind.Find.Transient", tRecordId, pText, pSearchString, pSearchOption, pTags, pLimit, .tParams, .pSC)
		quit:$$$ISERR(pSC)
		
		kill ^||%IF.Transient
		
	} catch (ex) {
		set %sqlcontext.%SQLCODE = ex.AsSQLCODE()
		set %sqlcontext.%Message = ex.AsSQLMessage()
		throw ex
	}
	if $$$ISERR(pSC) {
		set %sqlcontext.%SQLCODE = $system.Status.StatusToSQLCODE(pSC, .tMessage)
		set %sqlcontext.%Message = tMessage
		$$$ThrowStatus(pSC)
	}
	quit tString
}

/// Internal helper method, do not invoke directly.
ClassMethod HighlightInternal(pIndexLocation As %String, pDataLocation As %String, pFinderClass As %String, pRecordID As %CacheString, pFullText As %String, pSearchString As %String, pSearchOption As %String = {$$$IFSEARCHNORMAL}, pTags As %String = {$$$IFDEFAULTHLTAGS}, pLimit As %Integer = 0, ByRef pParams, Output pSC As %Status) As %String [ Internal ]
{
#define ENDTAG(%t) $s($l(%t)=2:$e(%t,2), 1:$e(%t,1)_"/"_$p($e(%t,2,*-1)," ",1)_$e(%t,*))
#define WRAPTAG(%s,%t) set %s = $s($l(%t)=2:$e(%t,1)_%s_$e(%t,2), 1:%t_%s_$$$ENDTAG(%t))
#define VerifyWord continue:tHasSpaces&&($zstrip($e(tFullText,tEndPos)_$e(tFullText,tStartPos-1),"*PWC",,$g(pParams("STRIPKEEP")))'="")

	set pSC = $$$OK, tString = ""
	try {
		if $piece(pSearchOption,":",1)=$$$IFSEARCHPATTERN {
			set pSC = $$$ERROR($$$GeneralError, "Highlighting regular expressions is currently not supported")
			quit
		}
		
		set tFragmentPadding = $piece(pLimit,":",2), pLimit = $piece(pLimit,":",1)
		set:'tFragmentPadding tFragmentPadding = 20
		
		set tMainTag = $piece(pTags,",",1), tNegTag = $piece(pTags,",",2)
		set:tMainTag="" tMainTag = $piece($$$IFDEFAULTHLTAGS,",",1)
		set:tNegTag="" tNegTag = tMainTag
		
		if $g(pParams("LOWER")) {
			set pSearchString = $$$LOWER(pSearchString)
			set tFullText = $$$LOWER(pFullText)
		}
		
		// BDB688
		set tLanguage = $g(pParams("LANGUAGE"))
		set tHasSpaces = (tLanguage'="ja")
		
		// first we'll parse the query
		do ParseMulti^%IFParser(pSearchString, .tSearchTree, tLanguage)
		
		// now find all relevant words at each node
		set tHasPunctuation = 0
		set tNode = ""
		for {
			set tNode = $order(tSearchTree(tNode))
			quit:tNode=""
			
			// track negatives
			set tChildNode = ""
			for {
				set tChildNode = $order(tSearchTree(tNode,"ch",tChildNode),1,tChildNegated)
				quit:tChildNode=""
				set:tChildNegated tNegatives(tChildNode) = '$g(tNegatives(tChildNode))
			}
			
			// now loop through the actual leaves
			set tLeafIndex = ""
			for {
				set tLeafIndex = $order(tSearchTree(tNode,"s",tLeafIndex), 1, tLeafString)
				quit:tLeafIndex=""
				
				// check if this leaf is negated
				set tLeafNegated = $g(tSearchTree(tNode,"s",tLeafIndex,"n"))
				set:$g(tNegatives(tNode)) tLeafNegated = 'tLeafNegated
				set tNegativeLeaves(tNode,tLeafIndex) = tLeafNegated
				
				// now retrieve all relevant word or entity IDs per position
				set tOperator1 = $g(tSearchTree(tNode,"s",tLeafIndex,1))
				set tOperator2 = $g(tSearchTree(tNode,"s",tLeafIndex,2))
				set tOperators = tOperator1_tOperator2
				set tLeafPunctuation = 0
				
				if $f(tOperators,"{")+$f(tOperators,"<")+$f(tOperators,">") {
					
					// track punctuation
					for i = 1:1:$l(tLeafString," ") {
						set tWordString = $piece(tLeafString," ",i)
						set:'tLeafPunctuation tLeafPunctuation = (tWordString'=$zstrip(tWordString,"<>P",,pParams("KEEPCHARS")))
						quit:tLeafPunctuation
					}

					
					// semantic search, so look for entities
					set tLeafWords(tNode,tLeafIndex)="e"
					kill tParsedLeafString
					merge tParsedLeafString = tSearchTree(tNode,"s",tLeafIndex)
					do $classmethod(pFinderClass,"GetEntityBits",.tEntityBits,.tParsedLeafString,pSearchOption,$g(pParams("LANGUAGE"),"en"),.pParams)
					
					// and set them aside
					set tChunk = ""
					for {
						set tChunk = $order(tEntityBits(tChunk),1,tBits)
						quit:tChunk=""
						
						// restrict to the ones actually appearing in this record
						set tBits = $bitlogic(tBits & @pIndexLocation@($$$IFGLOBALSUBCLEAN,pRecordID,tChunk))
						
						set tPos = 0
						for {
							set tPos = $bitfind(tBits, 1, tPos+1)
							quit:'tPos
							$$$IFGETIDOFFPOS(tEntId,tChunk,tPos)
						
							set tAllEntities(tEntId,+tLeafNegated)=""
						}
					}
					
				} else {
					// non-semantic: fetch words
					set tLeafWords(tNode,tLeafIndex) = $length(tLeafString," ")
					for i = 1:1:tLeafWords(tNode,tLeafIndex) {
						set tWordString = $piece(tLeafString," ",i)
						
						// track if we need to worry about punctuation
						set:'tLeafPunctuation tLeafPunctuation = (tWordString'=$zstrip(tWordString,"<>P",,pParams("KEEPCHARS")))
						
						// restore wildcards
						set:(i=1)&&$f(tOperator1,"*") tWordString = "*"_tWordString
						set:(i=tLeafWords(tNode,tLeafIndex))&&$f(tOperator2,"*") tWordString = tWordString_"*"
						
						// register full-word wildcards for this position
						if tWordString="?" {
							set tLeafWords(tNode,tLeafIndex,i)=$lb(1,1)
							continue
						} elseif ($e(tWordString)="[") && ($e(tWordString,*)="]") {
							set tLeafWords(tNode,tLeafIndex,i)=$lb(+$e($piece(tWordString,"-",1),2,*),+$e($piece(tWordString,"-",2),1,*-1))
							continue
						}
						
						kill tTree, tParsedWordString
						// BDB688 - language logic has already been applied, no need to resubmit
						do Parse^%IFParser(tWordString, .tTree)
						merge tParsedWordString = tTree(1)
						do $classmethod(pFinderClass,"GetWordBits",.tWordBits,.tParsedWordString,pSearchOption,$g(pParams("LANGUAGE"),"en"),.pParams)
						
						// and save them
						set tChunk = ""
						for {
							set tChunk = $order(tWordBits(tChunk),1,tBits)
							quit:tChunk=""
							set tPos = 0
							for {
								set tPos = $bitfind(tBits, 1, tPos+1)
								quit:'tPos
								$$$IFGETIDOFFPOS(tWordId,tChunk,tPos)
							
								set tAllWords(tWordId)=""
								set tLeafWords(tNode,tLeafIndex,i,tWordId)=""
							}
						}
					}
				}
				set:tLeafPunctuation tHasPunctuation = 1
			}
			quit:$$$ISERR(pSC)
		}
		quit:$$$ISERR(pSC)
		
		
		// now prune the lists by removing all the ones that don't actually appear in this record
		set tWordId=""
		for {
			set tWordId = $order(tAllWords(tWordId))
			quit:tWordId=""
			continue:$d(@pIndexLocation@($$$IFGLOBALSUBWORDPOS,pRecordID,tWordId))
			kill tAllWords(tWordId)
		}
		
		// fetch entities and store them in fake leaf nodes, so we can leverage positional
		// highlighting (there is no way to highlight entities individually)
		set tEntId = ""
		for {
			set tEntId = $order(tAllEntities(tEntId))
			quit:tEntId=""
			set tEntWords = @($$$DataLocationN("EntityW",pDataLocation))@(tEntId)
			kill tEntLeaf
			set (tEntLength,tEntLeaf) = $ll(tEntWords)
			for i = 1:1:tEntLength {
				set tWordId = +$lg(tEntWords,i)
				set tEntLeaf(i,tWordId)=""
				set tAllWords(tWordId)=""
			}
			if $d(tAllEntities(tEntId,0)) { // non-negative
				merge tLeafWords(-1,tEntId) = tEntLeaf
			}
			if $d(tAllEntities(tEntId,1)) { // negative
				merge tLeafWords(-2,tEntId) = tEntLeaf
			}
		}
			
		// fetch words & lengths
		set tWordId = ""
		for {
			set tWordId = $order(tAllWords(tWordId))
			quit:tWordId=""
			set tWord = @($$$DataLocationN("WordD",pDataLocation))@(tWordId)
			// skip the non-stripped ones too, if the search string didn't contain them
			if ('tHasPunctuation) && ($zstrip(tWord,"<>P",,pParams("KEEPCHARS"))'=tWord) {
				kill tAllWords(tWordId) 
			} else {
				set tAllWords(tWordId) = tWord
				set tWordLengths(tWordId) = $l(tWord)
			}
		}
		
		// now let's loop through the leaf nodes we have data for and highlight one by one
		set tNode=""
		for {
			set tNode = $order(tLeafWords(tNode))
			quit:tNode=""
			
			set tLeaf=""
			for {
				set tLeaf = $order(tLeafWords(tNode,tLeaf),1,tWordCount)
				quit:tLeaf=""
				
				set tTag = $s($g(tNegativeLeaves(tNode,tLeaf))||(tNode=-2):tNegTag, 1:tMainTag)
				set tOperators = $g(tSearchTree(tNode,"s",tLeaf,1))_$g(tSearchTree(tNode,"s",tLeaf,2))
				
				if (tWordCount=1) {
					
					// if this is a simple single-word question, we can go ahead and mark the
					// positions that should be highlighted
					set tWordId = ""
					for {
						set tWordId = $order(tLeafWords(tNode,tLeaf,1,tWordId))
						quit:tWordId=""
						
						continue:'$d(tAllWords(tWordId),tWord)
						set tEndPos = 0
						for {
							set tEndPos = $find(tFullText, tWord, tEndPos)
							quit:'tEndPos
							
							// check if this is the actual word
							set tStartPos = tEndPos-tWordLengths(tWordId)
							$$$VerifyWord
							
							set tHighlightPos(tStartPos,$i(tHighlightPos(tStartPos))) = tTag
							set tHighlightPos(tEndPos,$i(tHighlightPos(tEndPos))) = $$$ENDTAG(tTag)
							if pLimit {
								set tLastEndPos = $g(tHighlightPos(tStartPos,"e"))
								set:tEndPos>tLastEndPos tHighlightPos(tStartPos,"e") = tEndPos
							}
						}
					}
					
					
				} else {
					
					// first initialize the list of valid start/end positions, based on the 
					// first position words
					kill tValidPositions
					set tWordId = ""
					for {
						set tWordId = $order(tLeafWords(tNode,tLeaf,1,tWordId))
						quit:tWordId=""
						
						continue:'$d(tAllWords(tWordId),tWord)
						set tEndPos = 0
						for {
							set tEndPos = $find(tFullText, tWord, tEndPos)
							quit:'tEndPos
							
							// check if this is the actual word
							set tStartPos = tEndPos-tWordLengths(tWordId)
							$$$VerifyWord
							
							set tValidPositions(tStartPos, tEndPos)=""
						}
					}
					
					// now loop through the remaining word positions, validating and updating 
					// the list each time
					set (tMinWilds,tMaxWilds)=0
					for tWordPos = 2:1:tWordCount {
						kill tNewValidPositions
						if $d(tLeafWords(tNode,tLeaf,tWordPos),tWilds)#10 {
							set tMinWilds = tMinWilds+$lg(tWilds,1)
							set tMaxWilds = tMaxWilds+$lg(tWilds,2)
							continue
						}
						
						set tVStartPos = ""
						for {
							set tVStartPos = $order(tValidPositions(tVStartPos))
							quit:tVStartPos=""
							
							set tVEndPos = ""
							for {
								set tVEndPos = $order(tValidPositions(tVStartPos, tVEndPos))
								quit:tVEndPos=""
						
								set tWordId = ""
								for {
									set tWordId = $order(tLeafWords(tNode,tLeaf,tWordPos,tWordId))
									quit:tWordId=""
									
									continue:'$d(tAllWords(tWordId),tWord)
									set tEndPos = tVEndPos
									for {
										set tEndPos = $find(tFullText, tWord, tEndPos)
										quit:'tEndPos
										
										// check if this is the actual word
										set tStartPos = tEndPos-tWordLengths(tWordId)
										$$$VerifyWord
										
										set tBetween = $e(tFullText,tVEndPos,tStartPos-1)
										if '(tMinWilds+tMaxWilds) {
											// check if what was between this word and the previous end
											// are still only irrelevant characters
											quit:$zstrip(tBetween,"*PWC",,$g(pParams("KEEPCHARS")))'=""
										} else {
											// if there are wildcards, we'll try to count words based on whitespace
											set tBetween = $zstrip(tBetween,"<>PWC",,$g(pParams("KEEPCHARS")))
											set tBetween = $zstrip($tr(tBetween,$c(9,10,13),"   "),"=W")
											set tWCWords = $s(tBetween="":0,1:$l(tBetween," "))
											quit:(tWCWords>tMaxWilds)
											continue:tWCWords<tMinWilds
										}
										
										set tNewValidPositions(tVStartPos,tEndPos)=""
									}
								}
							}
						}
						
						// now take the current valid positions as our next set
						kill tValidPositions
						merge tValidPositions = tNewValidPositions
						kill tNewValidPositions
						
						// also reset wildcards
						set (tMinWilds,tMaxWilds)=0
					}
					
					// whatever's still left in tValidPositions can be highlighted
					set tStartPos = ""
					for {
						set tStartPos = $order(tValidPositions(tStartPos))
						quit:tStartPos=""
						set tEndPos=""
						for {
							set tEndPos = $order(tValidPositions(tStartPos, tEndPos))
							quit:tEndPos=""
							
							set tHighlightPos(tStartPos,$i(tHighlightPos(tStartPos))) = tTag
							set tHighlightPos(tEndPos,$i(tHighlightPos(tEndPos))) = $$$ENDTAG(tTag)
							if pLimit {
								set tLastEndPos = $g(tHighlightPos(tStartPos,"e"))
								set:tEndPos>tLastEndPos tHighlightPos(tStartPos,"e") = tEndPos
							}
						}
					}
				}
			}
		}
		
		
		if pLimit {
			
			// if we need to worry about pLimit, we'll first look for the fragment boundaries
			set tOriginalPos = "", tLimit=pLimit
			for {
				set tOriginalPos = $order(tHighlightPos(tOriginalPos),1,tTagCount)
				quit:tOriginalPos=""
				
				// skip if this one has no registered end positions (and is only about endings itself)
				continue:'$d(tHighlightPos(tOriginalPos,"e"),tLastEndPos)
					
				// refine fragment start positions to capture entire words
				set tStartFragment = tOriginalPos-tFragmentPadding
				for {
					set tChar = $e(pFullText,tStartFragment)
					quit:$zstrip(tChar,"*WCP","-")=""
					set tStartFragment = tStartFragment-1
				}
				set tEndFragment = tLastEndPos+tFragmentPadding
				for {
					set tChar = $e(pFullText,tEndFragment)
					quit:$zstrip(tChar,"*WCP","-")=""
					set tEndFragment = tEndFragment+1
				}
				set tLimit = tLimit-1
				quit:tLimit<0
				
				set tFragments(tStartFragment) = tEndFragment
			}
			
			// now loop through the fragments and clean up overlapping ones
			set tStartFragment = "", (tPrevStartFragment,tPrevEndFragment)=0
			for {
				set tStartFragment = $order(tFragments(tStartFragment),1,tEndFragment)
				quit:tStartFragment=""
				
				if tStartFragment<tPrevEndFragment {
					kill tFragments(tStartFragment)
					set tFragments(tPrevStartFragment) = tEndFragment
				}
				set tPrevStartFragment=tStartFragment, tPrevEndFragment=tEndFragment
			}
			
			// now we can highlight individual fragments without worries
			set tStartFragment = "", tString=""
			for {
				set tStartFragment = $order(tFragments(tStartFragment),1,tEndFragment)
				quit:tStartFragment=""
				
				set:tStartFragment>1 tString = tString _ "..."
				
				set tOriginalPos = tStartFragment, tPrevPos=tStartFragment
				for {
					set tOriginalPos = $order(tHighlightPos(tOriginalPos),1,tTagCount)
					quit:tOriginalPos=""
					quit:tOriginalPos>tEndFragment
					
					// add the text since the previous tag
					set tString = tString _ $e(pFullText,tPrevPos,tOriginalPos-1)
					
					for i = 1:1:tTagCount {
						set tString = tString _ tHighlightPos(tOriginalPos,i)
					}
					
					set tPrevPos = tOriginalPos
				}
				set tString = tString_$e(pFullText,tPrevPos,tEndFragment)
				
			}
			
		} else {
			
			// now do the actual highlighting
			set tOriginalPos = "", tPrevPos=0, tString=""
			for {
				set tOriginalPos = $order(tHighlightPos(tOriginalPos),1,tTagCount)
				quit:tOriginalPos=""
				
				// add the text since the previous tag
				set tString = tString _ $e(pFullText,tPrevPos,tOriginalPos-1)
				
				for i = 1:1:tTagCount {
					set tString = tString _ tHighlightPos(tOriginalPos,i)
				}
				
				set tPrevPos = tOriginalPos
			}
			set tString = tString_$e(pFullText,tPrevPos,*)
			
		}
		
	} catch ex {
		set pSC = ex.AsStatus()
	}
	quit tString
}

/// Either return a simple string through pTransformed, or an array of compounding words
ClassMethod ApplyTransformation(Output pTransformed As %String, ByRef pString, pSpec As %String, pLanguage As %String = "") [ Internal ]
{
	set tSC = $$$OK
	try {
		kill pTransformed
		set tTransformationClass = $piece(pSpec,":",1)
		set tTransformationClass = $case(tTransformationClass, $$$IFSEARCHSTEMMED:"%iFind.Transformation.Stemmer", $$$IFSEARCHDECOMPOUNDED:"%iFind.Transformation.Decompounder", :tTransformationClass)
		do $classmethod(tTransformationClass, "Transform", .pTransformed, .pString, $piece(pSpec,":",2,*), pLanguage)
	} catch ex {
		set tSC = ex.AsStatus()
	}
	if $$$ISERR(tSC) { $$$ThrowStatus(tSC) }
}

/// Helper method override for %iFind.FindUtils
ClassMethod GetIndexParams(Output pParams) [ Internal, Private ]
{
	quit ..GetDefaultIndexParams(.pParams)
}

/// Parse the TRANSFORMATIONSPEC value from the supplied index parameters,
/// taking care of interpreting INDEXOPTION and STEMMINGCONFIG for legacy classes.
ClassMethod GetTransformationSpecFromParams(ByRef pIndexParams, pSearchLanguage As %String = "") As %String [ Internal ]
{
	// first check if TRANSFORMATIONSPEC is explicitly stated
	set tSpec = $g(pIndexParams("TRANSFORMATIONSPEC"))
	quit:(tSpec'="") tSpec
	
	// INDEXOPTION=1: stemming
	if $g(pIndexParams("INDEXOPTION"))>=1 {
		set tSpec = "%iFind.Transformation.Stemmer:"_$s(pSearchLanguage'="":pSearchLanguage, 1:$g(pIndexParams("LANGUAGE")))_":"_$g(pIndexParams("STEMMINGCONFIG"))
	}
	
	// INDEXOPTION=2: add decompounding
	if $g(pIndexParams("INDEXOPTION"))=2 {
		set tSpec = tSpec _ ";%iFind.Transformation.Decompounder:"_$s(pSearchLanguage'="":pSearchLanguage, 1:$g(pIndexParams("LANGUAGE")))_":"_$g(pIndexParams("STEMMINGCONFIG"))
	}
	
	quit tSpec
}

}
