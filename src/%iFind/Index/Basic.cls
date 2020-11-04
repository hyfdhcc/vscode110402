Include (%IFInclude, %IKInclude)

IncludeGenerator (%IFInclude, %IKInclude)

/// <p>This index class provides text search capabilities to perform word-level searches through text in the
/// %String or %Stream properties being indexed, for persistent classes with regular Cach&eacute; storage.</p>
/// 
/// <h2>Defining an iFind index</h2>
/// <p>An iFind index can be defined in the class as follows:</p>
/// <example language="UDL">Class ThePackage.MyClass Extends %Persistent
/// {
/// 	Property MyStringProperty As %String;
/// 	
/// 	Index MyBasicIndex On (MyStringProperty) As %iFind.Index.Basic;
/// }</example>
/// <p>A number of <a href="#Anchor_Parameters">parameters</a> can be configured in order to refine
/// the indexing behavior, such as whether to support case-sensitive search (<parameter>LOWER</parameter>),
/// which language to use when indexing the text (<parameter>LANGUAGE</parameter>)
/// or whether to enable stemming or decompounding (<parameter>INDEXOPTION</parameter>).</p>
/// 
/// <h2>Querying an iFind index</h2>
/// <p>Classes with an iFind index can subsequently be queried in SQL using the following syntax:</p>
/// <example language="SQL">SELECT * FROM ThePackage.MyClass WHERE %ID %FIND search_index(MyBasicIndex, 'interesting')</example>
/// <p>This will return all the records containing the word "interesting". The following table lists a
/// few sample search strings illustrating more advanced iFind search syntax.</p>
/// <table class="DetailTable" cellpadding="0" cellspacing="0">
/// <tr><th width="250">Search string</th><th>What will be retrieved</th></tr>
/// <tr><td width="250">structure</td><td>All records containing the word "structure"</td></tr>
/// <tr><td width="250">logical structure</td><td>All records containing both the words "logical" and "structure" (implicit AND)</td></tr>
/// <tr><td width="250">logical structure*</td><td>Same, but with anything that starts with "structure" (wildcard search)</td></tr>
/// <tr><td width="250">(logical structure)</td><td>All records containing the word "structure" right behind "logical" (positional search)</td></tr>
/// <tr><td width="250">(logical ? structure)</td><td>All records containing the words "logical" and "structure" with exactly one search in between (positional search)</td></tr>
/// <tr><td width="250">(logical [0-5] structure)</td><td>Positional again, but with up to 5 words between</td></tr>
/// </table>
/// <p>It's also possible to use AND, OR and NOT, as well as parentheses to combine words into more
/// complex search strings, other than the implicit AND which is the default behavior for multi-word search:</p>
/// <table class="DetailTable" cellpadding="0" cellspacing="0">
/// <tr><th width="250">Search string</th><th>What will be retrieved</th></tr>
/// <tr><td width="250">Fixed</td><td>All records containing the word "fixed"</td></tr>
/// <tr><td width="250">Fixed and stored</td><td>All records containing "fixed" and "stored"</td></tr>
/// <tr><td width="250">Fixed and not stored</td><td>All records containing "fixed" but not "stored"</td></tr>
/// <tr><td width="250">Fixed and not (stored procedure)</td><td>All records containing "fixed" but not the positional string "stored procedure"</td></tr>
/// <tr><td width="250">fixed and ((stored procedure) or (default parameters))</td><td>All records containing "fixed" and either "stored procedure" or "default parameters"</td></tr>
/// <tr><td width="250">Fixed and \not</td><td>All records containing the words "fixed" and "not"</td></tr>
/// <tr><td width="250">Fixed \and \not</td><td>All records containing "fixed", "and" and "not"</td></tr>
/// <tr><td width="250">not generated</td><td>All records not containing "generated"</td></tr>
/// <tr><td width="250">\not generated</td><td>Implicit AND of "not" and "generated"</td></tr>
/// <tr><td width="250">(\not generated)</td><td>Positional search for the word sequence "not generated"</td></tr>
/// </table>
/// <p>Besides the name of the iFind index and the search string, the search_index() function supports
///  two more optional parameters: <blockquote><pre>search_index(<i>index_name</i>, <i>search_string</i> [, <i>search_option</i> [, <i>search_language</i>]]</pre></blockquote></p>
///  <p>The <i>search_option</i> defines whether to search for exact occurrences of words in the search string
///  (<i>search_option</i>=0), which is the default, to look for words that correspond to the same
/// "normalized" form, based on a particular transformation. For example, stemming will normalize
/// conjugated words to their base form and allow you to search for any conjugated form that corresponds
/// to the same base form. Similarly, decompounding will normalize words even further by splitting up 
/// compound words in the atomic words it consists of (see also <class>%iKnow.Stemming.DecompoundUtils</class>).
/// The following values can be used for <i>search_option</i>:
/// <ul>
/// <li><i>search_option</i> = 0 will perform a regular search, without any transformations. This is the default.</li>
/// <li><i>search_option</i> = 1 is a shorthand for stemmed search, using the default stemmer for the
/// current language (see also <class>%iKnow.Stemmer</class>), optionally overridden by the <parameter>STEMMINGCONFIG</parameter></li>
/// <li><i>search_option</i> = 2 is a shorthand for decompounded search, relying on the same settings as stemming described in the previous bullet</li>
/// <li><i>search_option</i> = 3 is a shorthand for fuzzy search, which will match any word that has at most 2 characters
/// differing from the search term. (Note that this is not a transformation, strictly speaking).</li>
/// <li><i>search_option</i> = '3:<i>n</i>' will also perform fuzzy search, but the maximum edit distance (different characters) is now <i>n</i></li>
/// <li><i>search_option</i> = 4 will perform a regular expression search</li>
/// <li><i>search_option</i> = '*' is a shorthand for searching based on all the transformations defined for this index</li>
/// <li><i>search_option</i> = '<i>string</i>' will perform the tranformation identified by <i>string</i> (see also <parameter>TRANSFORMATIONSPEC</parameter>)</li>
/// </ul>
/// Which values are available for a given index depends on the values of the <parameter>INDEXOPTION</parameter>
/// or <parameter>TRANSFORMATIONSPEC</parameter> parameters.</p>
///  <p>The <i>search_language</i> argument enables filtering records to those in a particular language,
///  in cases where the indexed property contains text in multiple languages (<parameter>LANGUAGE</parameter> = "*").
///  This language is also passed on to an eventual word transformation method when <i>search_option</i> != 0.</p>
Class %iFind.Index.Basic Extends (%Library.FunctionalIndex, %Library.CacheEmbedded) [ EmbeddedClass = %iFind.Find.Basic, System = 2 ]
{

Parameter FILER [ Internal ] = "%iFind.Filer.Basic";

/// Language to use when indexing records. 
/// Use "*" to enable automatic language detection. 
Parameter LANGUAGE As STRING = "en";

/// Advanced indexing options to use when processing records.
/// <ul><li>0 = Do not store compounds or stems</li>
/// <li>1 = Store word-level stems</li>
/// <li>2 = Store word-level compounds and stems</li></ul>
/// <p>See also <class>%iKnow.Stemmer</class> and <class>%iKnow.Stemming.DecompoundUtils</class>.</p>
Parameter INDEXOPTION [ Constraint = "0,1,2" ] = 0;

/// Whether or not to convert content to lowercase before indexing. 
/// When set to 1 (default), searches are always case-insensitive. 
/// When set to 0, searching will be case-sensitive.
Parameter LOWER As BOOLEAN = 1;

/// <p>This parameter controls which user dictionary should be used to rewrite or annotate text before
/// it is processed by the iKnow engine. See also the section on 
/// <a href="/csp/docbook/DocBook.UI.Page.cls?KEY=GIKNOW_domain#GIKNOW_domain_udict">User Dictionaries</a> 
/// in the iKnow documentation.</p>
/// <p>This parameter is for advanced use only and empty by default.</p>
Parameter USERDICTIONARY As STRING;

/// <p>This parameter can be used to override the default stemming implementation when 
/// <parameter>INDEXOPTION</parameter> &gt; 0. To do so, set this parameter to a saved
/// <class>%iKnow.Stemming.Configuration</class> instance. This parameter has no effect if 
/// <parameter>INDEXOPTION</parameter> = 0.</p>
/// <p>This parameter is for advanced use only and empty by default.</p>
Parameter STEMMINGCONFIG As STRING;

/// <p>This parameter controls which characters are retained at the start and end of a word when calculating
/// the "stripped" version of a word that will be indexed along with the original word as it appeared in the text.</p>
Parameter KEEPCHARS As STRING = {$$$STRIPKEEP};

/// <p>The <class>%iFind.Rank.Abstract</class> implementation to use for ranking search results
/// using the auto-generated rank SQL procedure "[package name].[class name]_[index name]Rank"</p>
Parameter RANKERCLASS As STRING = {$$$IFDEFAULTRANKER};

/// <p>When this parameter is set to 1, additional SQL projections will be created upon compiling
/// the class. These are accessible as read-only tables in a package named [<i>package_name</i>]_[<i>class_name</i>]
/// and have names starting with [<i>class_name</i>]_[<i>index_name</i>] (which can be overridden
/// through <parameter>IFINDADVANCEDSQLPREFIX</parameter>).<p>
/// <p>By default, the following mappings are generated for an %iFind.Index.Basic index:</p>
/// <ul>
/// <li><b>[<i>class_name</i>]_[<i>index_name</i>]_WordRec</b>: stores which words appear in each
/// record in this index. See also <class>%iFind.Index.AbstractWordRec</class>.</li>
/// <li><b>[<i>class_name</i>]_[<i>index_name</i>]_WordSpread</b>: stores the total number of records
/// in which this word appears in this index. See also <class>%iFind.Index.AbstractWordSpread</class>.</li>
/// <li><b>[<i>class_name</i>]_[<i>index_name</i>]_WordPos</b> stores which word occurs at which position
/// in a record, so it can be joined to the AttributePos table. See also <class>%iFind.Index.AbstractWordPos</class>.</li>
/// </ul>
/// <p>Additional classes will be generated automatically, based on your index class and parameters.
/// See the class reference for subclasses for more details.<p>
Parameter IFINDMAPPINGS As BOOLEAN = 0;

/// <p>When generating SQL projections of iFind index data using the <parameter>IFINDMAPPINGS</parameter>),
/// this parameter overrides the naming of those classes, using this parameter's value instead of the default
/// [<i>class_name</i>]_[<i>index_name</i>] prefix. The projections will still be created in the 
/// [<i>package_name</i>]_[<i>class_name</i>] package.</p>
Parameter IFINDADVANCEDSQLPREFIX As STRING;

/// This parameter enables specifying whether words, entities and similar data should be written
/// to the shared %iFind.Word, %iFind.Entity and similar tables (<parameter>IFINDSHAREDDATALOCATION</parameter>="NAMESPACE",
/// default), or whether it should be stored in index-specific tables (<parameter>IFINDSHAREDDATALOCATION</parameter>="INDEX").
/// In the latter case, mappings will be generated for these tables if <parameter>IFINDMAPPINGS</parameter>
/// is set to 1.
Parameter IFINDSHAREDDATALOCATION As STRING [ Constraint = "NAMESPACE,INDEX" ];

/// <p>This parameter defines the word transformation(s) to apply to input text, such as stemming, decompounding
/// and other operations for "normalizing" words, so searches can scan these normalized forms rather
/// than the literal forms. <br/>This parameter cannot be set in conjunction with the <parameter>INDEXOPTION</parameter>
/// and/or <parameter>STEMMINGCONFIG</parameter> parameters, which are shorthands for configuring stemming
/// and decompounding options and overriding the default configurations for those.<br />
/// This parameter also allows using custom transformations by specifying the name of a class that
/// inherits from <class>%iFind.Transformation.Abstract</class>, optionally followed by a colon and 
/// string that will be passed onto the Transform method of the transformation class if it accepts
/// any parameters.</p>
Parameter TRANSFORMATIONSPEC As STRING;

/// 	Inserts the iFind index for the row
/// THROW: This method throws exceptions.
ClassMethod InsertIndex(pID As %CacheString, pArg... As %Binary) [ CodeMode = generator, ServerOnly = 1 ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit $$$OK")
			quit $$$OK
		}
		
		// BDB646 - check iKnow license flag
		if (%property'="") && ($$iKnow^%SYS.LICENSE()=0) {
			throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$IKLicenseError))
		}
	
		if $get($$$EXTIDXGLOBAL($$$pEXT,%class,%property,$$$IFGLOBALINDEXLOC)) = "" { do ##class(%Compiler.iFind.Index).GenerateGlobalNames(%class,%property) } 
		set tIndexLocation = $$$EXTIDXGLOBAL($$$pEXT,%class,%property,$$$IFGLOBALINDEXLOC)
		set tIndexLocationQ = $$$QUOTE(tIndexLocation)

		// Parse index properties
		do parseIndexProperties^%occStorageCompiler(%class,%property,.prop,.issubval)
		
			// Get index property names and types
		set propNames = prop
		for p=1:1:prop {
			set propNames(p) = $listbuild(prop(p),$get($$$EXTPROPtype($$$pEXT,%class,prop(p))))
		}

		set tIndex = ##class(%Dictionary.CompiledIndex).IDKEYOpen(%class,%property)
		if $isobject(tIndex) {									
			set tKey = ""
			set tIndexProperty = tIndex.PropertyCollection.GetNext(.tKey)
			set tIndexVars=""
			
			while $isobject(tIndexProperty) {
				set tIndexVars = tIndexVars_"pArg("_tIndexProperty.Name_"),"
				set tIndexProperty = tIndex.PropertyCollection.GetNext(.tKey)
			}
		}

		// BDB541 - get index parameters
		$$$GENERATE($char(9)_"do .."_%property_"GetIndexParams(.tParams)")
		
		
		// resolve filer
		set filer=$get(%parameter("FILER"))
		set:filer="" filer="%iFind.Filer.Basic"
		
		// BDB593 - use NoEngine filer when we can
		// BDB688 - never use NoEngine for Japanese
		set tNoEngine = (filer="%iFind.Filer.Basic") && ($g(%parameter("USERDICTIONARY"))="") && ($g(%parameter("LANGUAGE"))'="*") && ($g(%parameter("LANGUAGE"))'[",") && ($g(%parameter("LANGUAGE"))'="ja")
		set:tNoEngine filer = "%iFind.Filer.NoEngine", %parameter("FILER")=filer, %parameter("FILER:NoIndex")=1
		
		// BDB675 - if this class customizes storage, we need to create a separate filer class
		set tSharedDataLocation = $g(%parameter("IFINDSHAREDDATALOCATION"))
		set:tSharedDataLocation="" tSharedDataLocation = "NAMESPACE"
		if tSharedDataLocation'="NAMESPACE" {
			try {
				set tFilerClassName = ##class(%iFind.Index.ClassGenerator.Abstract).GenerateClassName(%class,%property_"Filer",.tHasLock,.tSC)
				quit:$$$ISERR(tSC)
				if tFilerClassName="" { set tSC = $$$ERROR($$$GeneralError,"Unable to create filer class") quit }
				
				set tFilerClass = ##class(%Dictionary.ClassDefinition).%New()
				set tFilerClass.Name = tFilerClassName
				set tFilerClass.Super = filer
				set tFilerClass.Hidden = 1
				set tFilerClass.ProcedureBlock = 1
				set tFilerClass.GeneratedBy = %class_".CLS"
				set tFilerClass.Description = "INTERNAL CLASS - DO NOT INVOKE"
				
				set tParam = ##class(%Dictionary.ParameterDefinition).%New()
				set tParam.Name = "INDEXLOCATIONSHARED"
				$$$GetSharedLocation(tSharedDataLocation,tIndexLocation,tSharedDataLocationGlo)
				set tParam.Default = tSharedDataLocationGlo
				do tFilerClass.Parameters.Insert(tParam)
				
				set tSC = tFilerClass.%Save()
				quit:$$$ISERR(tSC)
				
				// register as dependent class and queue for compilation
				$$$comClassArraySet(%class,$$$cCLASSclasses,tFilerClassName_".CLS","")
				do QueueClass^%occCompile(tFilerClassName)
				
			} catch (ex) {
				set tSC = ex.AsStatus()
			}
			set:$g(tHasLock) x = $$UnlockOneClass^%occLock(tFilerClassName,3,1)
			if $$$ISERR(tSC) { 
				set:$d(tFilerClassName)&&$$$defClassDefined(tFilerClassName) x = $$Delete^%apiOBJ(tFilerClassName,"-d")
				$$$ThrowStatus(tSC)
			}
			
			set (filer,%parameter("FILER")) = tFilerClassName
		}
		
		
		if (propNames=1) {
			if 'tNoEngine {
				$$$GENERATE($char(9)_"set tLanguage = tParams(""LANGUAGE"")")
				$$$GENERATE($char(9)_"do ($system.Context.iFind()).GetIndexer(tLanguage,.tDirect,.tIndexer)")
				
				if ($g(%parameter("USERDICTIONARY"))'="") {
					$$$GENERATE($c(9,9)_"if (tIndexer.UserDictionaryName'=tParams(""USERDICTIONARY"")) {")
					$$$GENERATE($c(9,9,9)_"do tIndexer.ClearUserDictionary()")
					$$$GENERATE($c(9,9,9)_"if (tParams(""USERDICTIONARY"")'="""") {")
					$$$GENERATE($c(9,9,9,9)_"set tUserDict=##class(%iKnow.UserDictionary).OpenByName(tParams(""USERDICTIONARY""))")
					$$$GENERATE($c(9,9,9,9)_"do tIndexer.LoadUserDictionary(tParams(""USERDICTIONARY""), tUserDict)")
					$$$GENERATE($c(9,9,9,9)_"do tIndexer.SetUserDictionary(tParams(""USERDICTIONARY""))")
					$$$GENERATE($c(9,9,9)_"}")
					$$$GENERATE($c(9,9)_"}")
				} else {
					$$$GENERATE($c(9,9)_"do:(tIndexer.UserDictionaryName'="""") tIndexer.ClearUserDictionary()")
				}
			}
			
	    	if ($$$comClassKeyGet($list(propNames(1),2),$$$cCLASSsqlcategory)=$$$cCLASSSQLCATEGORYSTRING) {
		    	if tNoEngine {
			    	$$$GENERATE($char(9)_"do ##class("_filer_").FileIndexString("_$extract(tIndexVars,1,*-1)_","_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	} else {
					$$$GENERATE($char(9)_"do tIndexer.exBufferString("_$extract(tIndexVars,1,*-1)_")")
					$$$GENERATE($char(9)_"do ##class("_filer_").FileIndex(tDirect,tIndexer,"_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	}
			}
			elseif $$$getClassType($list(propNames(1),2))=$$$cCLASSCLASSTYPESTREAM {
				
				
				// test for calculated stream example ^oddDEF("User.Expand","a","Text",23)	= 	1
				// or test for ^oddDEF("User.Expand","a","Text",45) cPROPsqlcomputed 
				if ($$$defMemberKeyDefined(%class,$$$cCLASSproperty,$list(propNames(1),1),$$$cPROPcalculated))
				||($$$defMemberKeyDefined(%class,$$$cCLASSproperty,$list(propNames(1),1),$$$cPROPsqlcomputed)) {
				
					 $$$GENERATE($char(9)_"set tStream="_ $extract(tIndexVars,1,*-1))
				}
				else {
				   $$$GENERATE($char(9)_"set tStream = ##class("_%class_")."_$list(propNames(1),1)_"Open("_$extract(tIndexVars,1,*-1)_")")
				}
				$$$GENERATE($char(9)_"if tStream '= $$$NULLOREF {")
				if tNoEngine {
			    	$$$GENERATE($char(9,9)_"do ##class("_filer_").FileIndexStream(tStream,"_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	} else {
					$$$GENERATE($char(9,9)_"do tIndexer.exBufferStream(tStream)")
					$$$GENERATE($char(9,9)_"do ##class("_filer_").FileIndex(tDirect,tIndexer,"_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	}
				$$$GENERATE($char(9)_"}")
			}
			else {
				throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Invalid datatype: "_$list(propNames(1),2)))
			}
		}
		else {
			throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Too many properties "))
		}
	}
	quit $$$OK
}

/// Updates the iFind index for the row
ClassMethod UpdateIndex(pID As %CacheString, pArg... As %Binary) [ CodeMode = generator, GenerateAfter = InsertIndex, ServerOnly = 1 ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit $$$OK")
			quit $$$OK
		}
		
		// Parse index properties
		do parseIndexProperties^%occStorageCompiler(%class,%property,.prop,.issubval)
		
		// Get index property names and types
		set propNames = prop
		for p=1:1:prop {
			set propNames(p)=$listbuild(prop(p),$get($$$EXTPROPtype($$$pEXT,%class,prop(p))))
		}
		
		set tIndex = ##class(%Dictionary.CompiledIndex).IDKEYOpen(%class,%property)
		if $isobject(tIndex) {			
			set tKey = ""
			set tIndexProperty = tIndex.PropertyCollection.GetNext(.tKey)
			set tIndexVars=""
			while $isobject(tIndexProperty) {
				set tIndexVars = tIndexVars_"pArg("_tIndexProperty.Name_"),"
				set tIndexProperty = tIndex.PropertyCollection.GetNext(.tKey)
			}
		}

		set tIndexLocation = $$$EXTIDXGLOBAL($$$pEXT,%class,%property,$$$IFGLOBALINDEXLOC)
		set tIndexLocationMLS = $select(tIndexLocation="":"",$extract(tIndexLocation,*) = ")":$extract(tIndexLocation,1,*-1)_",",1:tIndexLocation_"(")
		set tIndexLocationQ = $$$QUOTE(tIndexLocation)

		// BDB541 - get index parameters
		$$$GENERATE($char(9)_"do .."_%property_"GetIndexParams(.tParams)")
		
		
		// BDB675 - Filer has been resolved in InsertIndex
		set filer=$get(%parameter("FILER"))
		set tNoEngine = $g(%parameter("FILER:NoIndex"),0)
		
		if (propNames=1) {
			
			// BDB676
			$$$GENERATE($char(9)_"do ##class("_filer_").Delete(pID,"_tIndexLocationQ_",.tParams)")
				
			if 'tNoEngine {
				$$$GENERATE($char(9)_"set tLanguage = tParams(""LANGUAGE"")")
				$$$GENERATE($char(9)_"do ($system.Context.iFind()).GetIndexer(tLanguage,.tDirect,.tIndexer)")
				
				if ($g(%parameter("USERDICTIONARY"))'="") {
					$$$GENERATE($c(9,9)_"if (tIndexer.UserDictionaryName'=tParams(""USERDICTIONARY"")) {")
					$$$GENERATE($c(9,9,9)_"do tIndexer.ClearUserDictionary()")
					$$$GENERATE($c(9,9,9)_"if (tParams(""USERDICTIONARY"")'="""") {")
					$$$GENERATE($c(9,9,9,9)_"set tUserDict=##class(%iKnow.UserDictionary).OpenByName(tParams(""USERDICTIONARY""))")
					$$$GENERATE($c(9,9,9,9)_"do tIndexer.LoadUserDictionary(tParams(""USERDICTIONARY""), tUserDict)")
					$$$GENERATE($c(9,9,9,9)_"do tIndexer.SetUserDictionary(tParams(""USERDICTIONARY""))")
					$$$GENERATE($c(9,9,9)_"}")
					$$$GENERATE($c(9,9)_"}")
				} else {
					$$$GENERATE($c(9,9)_"do:(tIndexer.UserDictionaryName'="""") tIndexer.ClearUserDictionary()")
				}
			}
			
	    	if ($$$comClassKeyGet($list(propNames(1),2),$$$cCLASSsqlcategory)=$$$cCLASSSQLCATEGORYSTRING) {
		    	if tNoEngine {
			    	$$$GENERATE($char(9)_"do ##class("_filer_").FileIndexString("_$extract(tIndexVars,1,*-1)_","_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	} else {
					$$$GENERATE($char(9)_"do tIndexer.exBufferString("_$extract(tIndexVars,1,*-1)_")")
					$$$GENERATE($char(9)_"do ##class("_filer_").FileIndex(tDirect,tIndexer,"_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	}
			}
			elseif $$$getClassType($list(propNames(1),2))=$$$cCLASSCLASSTYPESTREAM {
				
				// test for calculated stream example ^oddDEF("User.Expand","a","Text",23)	= 	1
				// or test for ^oddDEF("User.Expand","a","Text",45) cPROPsqlcomputed 
				if ($$$defMemberKeyDefined(%class,$$$cCLASSproperty,$list(propNames(1),1),$$$cPROPcalculated))
				||($$$defMemberKeyDefined(%class,$$$cCLASSproperty,$list(propNames(1),1),$$$cPROPsqlcomputed))
				{
					 $$$GENERATE($char(9)_"set tStream="_ $extract(tIndexVars,1,*-1))
				}
				else {
				   $$$GENERATE($char(9)_"set tStream = ##class("_%class_")."_$list(propNames(1),1)_"Open("_$extract(tIndexVars,1,*-1)_")")
				}
				$$$GENERATE($char(9)_"if tStream '= $$$NULLOREF {")
				if tNoEngine {
			    	$$$GENERATE($char(9,9)_"do ##class("_filer_").FileIndexStream(tStream,"_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	} else {
					$$$GENERATE($char(9,9)_"do tIndexer.exBufferStream(tStream)")
					$$$GENERATE($char(9,9)_"do ##class("_filer_").FileIndex(tDirect,tIndexer,"_$$$QUOTE(%property)_"," _ tIndexLocationQ_",pID,.tParams)")
		    	}
				$$$GENERATE($char(9)_"}")
			}
			else {
				throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Invalid datatype: "_$list(propNames(1),2)))
			}
		}
		else {
			throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"To many properties "))
		}		
	}
	quit $$$OK
}

/// 		Deletes the iFind index for the row
ClassMethod DeleteIndex(pID As %CacheString, pArg... As %Binary) [ CodeMode = generator, GenerateAfter = InsertIndex, ServerOnly = 1 ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit $$$OK")
			quit $$$OK
		}
		
		// BDB675 - Filer has been resolved in InsertIndex
		set filer=$get(%parameter("FILER"))
		
		if $Get($$$EXTIDXGLOBAL($$$pEXT,%class,%property,$$$IFGLOBALINDEXLOC)) = "" { do ##class(%Compiler.iFind.Index).GenerateGlobalNames(%class,%property) } 
		set tIndexLocationQ = $$$QUOTE($$$EXTIDXGLOBAL($$$pEXT,%class,%property,$$$IFGLOBALINDEXLOC))
		//set %codemode = $$$cMETHCODEMODEEXPRESSION
		$$$GENERATE($c(9)_"do .."_%property_"GetIndexParams(.tParams)")
		$$$GENERATE($c(9)_"do ##class("_filer_").Delete(pID,"_tIndexLocationQ_",.tParams)")
	}
	quit $$$OK
}

/// 		Purges the iFind index
ClassMethod PurgeIndex() [ CodeMode = generator, GenerateAfter = InsertIndex, ServerOnly = 1 ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit $$$OK")
			quit $$$OK
		}
		
		set tIndexLocation = $$$EXTIDXGLOBAL($$$pEXT,%class,%property,$$$IFGLOBALINDEXLOC)
		$$$GENERATE($c(9)_"set settings=$g("_tIndexLocation_")")
		$$$GENERATE($c(9)_"kill "_tIndexLocation)
		$$$GENERATE($c(9)_"set:settings'="""" "_tIndexLocation_"=settings")
	}
	quit $$$OK
}

ClassMethod SortBeginIndex() [ ServerOnly = 1 ]
{
	quit $$$OK
}

ClassMethod SortEndIndex() [ ServerOnly = 1 ]
{
	quit $$$OK
}

/// 		Searches for matches based on the iFind index
ClassMethod Find(pSearch As %Library.Binary, pOption As %Integer = 0, pLanguage As %String = "") As %Library.Binary [ CodeMode = generator, PublicList = (SQLCODE, %msg), ServerOnly = 1, SqlProc ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		
		$$$GENERATE($char(9)_"try {")
		$$$GENERATE($char(9,9)_"set tSearcher = .."_%pqname_"Embedded()")
		$$$GENERATE($char(9,9)_"do tSearcher.PrepareFind(pSearch,pOption,pLanguage)")
		$$$GENERATE($char(9)_"}")
		$$$GENERATE($char(9)_"catch tException {")
		$$$GENERATE($char(9,9)_"set %sqlcontext.%SQLCODE = tException.AsSQLCODE(), %sqlcontext.%Message = tException.AsSQLMessage()")
		$$$GENERATE($char(9,9)_"THROW tException")
		$$$GENERATE($char(9)_"}")
		$$$GENERATE($char(9)_"quit tSearcher")
	}
	quit $$$OK
}

/// This method will normalize the query of %iFind.Find.Basic based on the dictionary defined %iFind.Index.Basic
ClassMethod Normalize(pQuery As %String = "", pLanguage As %String = "") As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	Set st = $$$OK
	try {
		quit:%mode="method"
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit
		}
		
		$$$GENERATE($char(9,9)_"set normalizedResult = pQuery")
		if ($g(%parameter("USERDICTIONARY"))'="")
		{
			$$$GENERATE($c(9,9)_"do .."_%property_"GetIndexParams(.tParams)")
			$$$GENERATE($c(9,9)_"if (tParams(""USERDICTIONARY"")'="""") {")
			$$$GENERATE($c(9,9,9)_"do ($system.Context.iFind()).GetIndexer(pLanguage,.tDirect,.tIndexer)")
			$$$GENERATE($c(9,9,9)_"do tIndexer.ClearUserDictionary()")
			$$$GENERATE($c(9,9,9)_"set tUserDict=##class(%iKnow.UserDictionary).OpenByName(tParams(""USERDICTIONARY""))")
			$$$GENERATE($c(9,9,9)_"do tIndexer.LoadUserDictionary(tParams(""USERDICTIONARY""), tUserDict)")
			$$$GENERATE($c(9,9,9)_"do tIndexer.SetUserDictionary(tParams(""USERDICTIONARY""))")
			$$$GENERATE($c(9,9,9)_"set st=tIndexer.Normalize(pQuery,.normalizedResult,pLanguage)")
			$$$GENERATE($c(9,9)_"}")
		}
		$$$GENERATE($c(9,9)_"quit normalizedResult")	
	}
	catch(ex)
	{
		Set st = ex.AsStatus()
	}
	quit st
}

/// Internal helper method for retrieving runtime index parameter values
ClassMethod GetIndexParams(Output pParams) As %Status [ CodeMode = generator, Internal, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
		quit:%mode="method"
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit $$$OK")
			quit
		}
		
		$$$GENERATE($char(9)_"kill pParams")
		$$$GENERATE($char(9)_"set pParams(""COMPILEDVERSION"")="_$$$QUOTE($system.Version.GetNumber()))
		
		// first write simple parameters
		set tParam = ""
		for {
			set tParam = $order(%parameter(tParam),1,tParamValue)
			quit:tParam=""
			
			// skip internal ones
			continue:tParam="FILER"
			
			// skip customizable ones
			continue:tParam="LANGUAGE"
			continue:tParam="LOWER"
			continue:tParam="INDEXOPTION"
			continue:tParam="USERDICTIONARY"
			continue:tParam="STEMMINGCONFIG"
			continue:tParam="KEEPCHARS"
			continue:tParam="TRANSFORMATIONSPEC"
			
			$$$GENERATE($c(9)_"set pParams("_$$$QUOTE(tParam)_") = "_$$$QUOTE(tParamValue))
		}
		
		
		// LANGUAGE (default: "en", fallback: "*")
		set tLanguage = $get(%parameter("LANGUAGE"))
		if (tLanguage = "") || (tLanguage = "*") {
			
			// use Automatic Language Identification
			$$$GENERATE($char(9)_"set pParams(""LANGUAGE"") = ""*""")
			
		} elseif $$$IFGetLangId(tLanguage) || ($l(tLanguage)=2) {
			
			// when a known language is being supplied, use it
			$$$GENERATE($char(9)_"set pParams(""LANGUAGE"") = "_$$$QUOTE(tLanguage))
			
		} else {
			
			// if not, we're looking at custom code
			$$$GENERATE($char(9)_"try {")
			$$$GENERATE($char(9,9)_"set pParams(""LANGUAGE"") = "_$$ResolveNames(tLanguage))
			$$$GENERATE($char(9,9)_"if '$$$IFGetLangId(pParams(""LANGUAGE"")) { set pParams(""LANGUAGE"") = ""*"" }")
			$$$GENERATE($char(9)_"} catch { set pParams(""LANGUAGE"") = ""*"" }")
		}


		// LOWER (default: 1)
		set tLower = $g(%parameter("LOWER"))
		set:tLower="" tLower = 1
		if (tLower=0) || (tLower=1) {
			$$$GENERATE($c(9)_"set pParams(""LOWER"") = "_tLower)
		} else {
			$$$GENERATE($c(9)_"try {")
			$$$GENERATE($c(9,9)_"set pParams(""LOWER"") = "_$$ResolveNames(tLower))
			$$$GENERATE($c(9,9)_"set:(pParams(""LOWER"")'=0)&&(pParams(""LOWER"")'=1) pParams(""LOWER"") = 1")
			$$$GENERATE($c(9)_"} catch (ex) { set pParams(""LOWER"") = 1 }")
		}
		

		// INDEXOPTION (default: 0)
		set tIndexOption = $g(%parameter("INDEXOPTION"))
		set:tIndexOption="" tIndexOption = 0
		if (tIndexOption=0) || (tIndexOption=1) || (tIndexOption=2) {
			$$$GENERATE($c(9)_"set pParams(""INDEXOPTION"") = "_tIndexOption)
		} else {
			$$$GENERATE($c(9)_"try {")
			$$$GENERATE($c(9,9)_"set pParams(""INDEXOPTION"") = "_$$ResolveNames(tIndexOption))
			$$$GENERATE($c(9,9)_"set:(pParams(""INDEXOPTION"")'=0)&&(pParams(""INDEXOPTION"")'=1)&&(pParams(""INDEXOPTION"")'=2) pParams(""INDEXOPTION"") = 0")
			$$$GENERATE($c(9)_"} catch (ex) { set pParams(""INDEXOPTION"") = 0 }")
		}
		
		
		// USERDICTIONARY (default: "")
		set tUserDictionary = $g(%parameter("USERDICTIONARY"))
		if ($e(tUserDictionary)="{") && ($e(tUserDictionary,*)="}") {
			
			// if wrapped with {}, this is customization code
			$$$GENERATE($c(9)_"try {")
			$$$GENERATE($c(9,9)_"set pParams(""USERDICTIONARY"") = "_$$ResolveNames(tUserDictionary))
			$$$GENERATE($c(9)_"} catch (ex) { set pParams(""USERDICTIONARY"") = """" }")
			
		} else {
			
			// otherwise, this is just the name of / path to the user dictionary itself
			$$$GENERATE($c(9)_"set pParams(""USERDICTIONARY"") = "_$$$QUOTE(tUserDictionary))
		}
		
		
		// STEMMINGCONFIG (default: "")
		set tStemmingConfig = $g(%parameter("STEMMINGCONFIG"))
		if ($e(tStemmingConfig)="{") && ($e(tStemmingConfig,*)="}") {
			
			// if wrapped with {}, this is customization code
			$$$GENERATE($c(9)_"try {")
			$$$GENERATE($c(9,9)_"set pParams(""STEMMINGCONFIG"") = "_$$ResolveNames(tStemmingConfig))
			$$$GENERATE($c(9)_"} catch (ex) { set pParams(""STEMMINGCONFIG"") = """" }")
			
		} else {
			
			// otherwise, this is just the name of / path to the stemming config itself
			$$$GENERATE($c(9)_"set pParams(""STEMMINGCONFIG"") = "_$$$QUOTE(tStemmingConfig))
		}
		
		
		
		// BDB594
		// KEEPCHARS (default: $$$STRIPKEEP)
		set tKeepChars = $g(%parameter("KEEPCHARS"))
		if ($e(tKeepChars)="{") && ($e(tKeepChars,*)="}") {
			
			// if wrapped with {}, this is customization code
			$$$GENERATE($c(9)_"try {")
			$$$GENERATE($c(9,9)_"set pParams(""KEEPCHARS"") = "_$$ResolveNames(tKeepChars))
			$$$GENERATE($c(9)_"} catch (ex) { set pParams(""KEEPCHARS"") = """" }")
			
		} else {
			
			// otherwise, this is just a sequence of characters
			$$$GENERATE($c(9)_"set pParams(""KEEPCHARS"") = "_$$$QUOTE(tKeepChars))
		}
		
		
		// BDB675 - TRANSFORMATIONSPEC (default = "")
		set tTransformationSpec = $g(%parameter("TRANSFORMATIONSPEC"))
		if (tTransformationSpec'="") && ((tIndexOption'=0) || (tStemmingConfig'="")) {
			set tSC = $$$ERROR($$$GeneralError, "'TRANSFORMATIONSPEC' index parameter cannot be used when 'INDEXOPTION' or 'STEMMINGCONFIG' is set")
			quit
		}
		if ($e(tTransformationSpec)="{") && ($e(tTransformationSpec,*)="}") {
			
			// if wrapped with {}, this is customization code
			$$$GENERATE($c(9)_"try {")
			$$$GENERATE($c(9,9)_"set pParams(""TRANSFORMATIONSPEC"") = "_$$ResolveNames(tTransformationSpec))
			$$$GENERATE($c(9)_"} catch (ex) { set pParams(""TRANSFORMATIONSPEC"") = """" }")
			
		} else {
			
			// otherwise, this is just the name of / path to the transformation spec itself
			$$$GENERATE($c(9)_"set pParams(""TRANSFORMATIONSPEC"") = "_$$$QUOTE(tTransformationSpec))
		}
		
		$$$GENERATE($c(9)_"quit $$$OK")

	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	throw:$$$ISERR(tSC) ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"Error processing index parameters",tSC))
	quit $$$OK
	
ResolveNames(tString) // strips wrapping {} and replaces {%INDEX} and {%CLASS}
	set tString = $replace(tString,"{%CLASS}",$$$QUOTE(%class))
	set tString = $replace(tString,"{%INDEX}",$$$QUOTE(%property))
	set:($e(tString)="{")&&($e(tString)="{") tString = $e(tString,2,*-1)
	quit tString
}

/// Utility method stripping punctuation characters from the start and end of a word, according to 
/// the value of the <parameter>KEEPCHARS</parameter> index parameter for this index.
ClassMethod StripCharacters(pWord As %String) As %String [ CodeMode = generator ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		$$$GENERATE($char(9)_"do .."_%property_"GetIndexParams(.tParams)")
		$$$GENERATE($char(9)_"quit $zstrip(pWord,""<>P"",,tParams(""KEEPCHARS""))")
	}
	quit $$$OK
}

/// Returns the Word ID for <var>pWord</var>, after stripping off any punctuation at the start and end of
/// the word, according to the value of <parameter>KEEPCHARS</parameter> for this index.
ClassMethod StrippedWordId(pWord As %String) As %String [ CodeMode = generator ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		
		$$$GetIndexLocations(%class,%property,tIndexLocation,tDataLocation,"")
		$$$GENERATE($char(9)_"do .."_%property_"GetIndexParams(.tParams)")
   		$$$GENERATE($char(9)_"set tWord = $zstrip(pWord,""<>P"",,tParams(""KEEPCHARS""))")
   		$$$GENERATE($char(9)_"quit $s(tWord="""":"""", 1:$g("_$$$DataLocation("WordI",tDataLocation)_""" ""_tWord)))")
	}
	quit $$$OK
}

/// Returns the Entity ID for <var>pEntity</var>, after stripping off any punctuation at the start and end of
/// the words making up the entity, according to the value of <parameter>KEEPCHARS</parameter> for this index.
ClassMethod StrippedEntityId(pEntity As %String) As %String [ CodeMode = generator ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		
		$$$GetIndexLocations(%class,%property,tIndexLocation,tDataLocation,"")
		$$$GENERATE($char(9)_"do .."_%property_"GetIndexParams(.tParams)")
		$$$GENERATE($char(9)_"set tNumWords = $length(pEntity,"" ""), tHasStripped=0")
		$$$GENERATE($char(9)_"kill tStrippedWords")
		$$$GENERATE($char(9)_"for i = 1:1:tNumWords {")
		$$$GENERATE($char(9)_"	set tWord = $piece(pEntity,"" "",i)")
		$$$GENERATE($char(9)_"	set tStrippedWords(i)=$zstrip(tWord,""<>P"",,tParams(""KEEPCHARS""))")
		$$$GENERATE($char(9)_"	set:'tHasStripped tHasStripped=(tStrippedWords(i)'=tWord)")
		$$$GENERATE($char(9)_"}")
		$$$GENERATE($char(9)_"set tEntityKey=""""")
		$$$GENERATE($char(9)_"for i = 1:1:tNumWords {")
		$$$GENERATE($char(9)_"	set tWord = tStrippedWords(i)")
		$$$GENERATE($char(9)_"	continue:tWord=""""")
		$$$GENERATE($char(9)_"	if '$d("_$$$DataLocation("WordI",tDataLocation)_""" ""_tWord),tWordId) {")
		$$$GENERATE($char(9)_"		return pOriginalId")
		$$$GENERATE($char(9)_"	}")
		$$$GENERATE($char(9)_"	set:tEntityKey'="""" tEntityKey=tEntityKey_"",""")
		$$$GENERATE($char(9)_"	set tEntityKey=tEntityKey_tWordId")
		$$$GENERATE($char(9)_"}")
		$$$GENERATE($char(9)_"quit $s(tEntityKey="""":"""", 1:$g("_$$$DataLocation("EntityI",tDataLocation)_"tEntityKey)))")
	}
	quit $$$OK
}

/// Return an instance of the embedded Find class, initialized with the index' parameters
ClassMethod Embedded() As %RegisteredObject [ CodeMode = generator, ServerOnly = 1 ]
{
	if %mode'="method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		
		$$$comMemberKeyGetLvar(embeddedclass,%class,$$$cCLASSindex,%pqname,$$$cXXXXembeddedname)
		$$$GENERATE($char(9)_"do .."_%pqname_"GetIndexParams(.tParams)")
		$$$GENERATE($char(9)_"quit ##class("_embeddedclass_").%New(.tParams)")
	}
	quit $$$OK
}

/// <p>This SQL procedure returns the score expressing how well the record identified by <var>pRecordID</var>
/// matches <var>pSearchString</var>, based on the ranking algorithm defined by <parameter>RANKERCLASS</parameter>.</p>
/// <example language="SQL">SELECT %ID, 
/// 	Title,
/// 	FullText,
/// 	SomePackage.TheTable_MyIndexRank(%ID, 'cocktail* OR (hammock AND NOT bees)')
/// FROM SomePackage.TheTable
/// WHERE %ID %FIND search_index(MyIndex, 'cocktail* OR (hammock AND NOT bees)')
/// ORDER BY 4 DESC</example>
/// <p><var>pSearchOption</var> can be used as in other iFind search operations,
/// for example to also accept fuzzy matches or stem matches when calculating the rank score.</p>
ClassMethod Rank(pRecordID As %CacheString, pSearchString As %String, pSearchOption As %String = {$$$IFSEARCHNORMAL}) As %Float [ CodeMode = generator, PublicList = (SQLCODE, %msg), ServerOnly = 1, SqlProc ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		
		$$$GENERATE($char(9)_"quit ##class(%iFind.Utils).Rank("_$$$QUOTE(%parameter("RANKERCLASS"))_","_$$$QUOTE(%class)_","_$$$QUOTE(%pqname)_",pRecordID,pSearchString,pSearchOption)")
	}
	quit $$$OK
}

/// <p>This SQL procedure returns the text indexed by <var>pRecordID</var>, in which all matches of the
/// supplied <var>pSearchString</var> are highlighted using <var>pTags</var>.</p>
/// <example language="SQL">SELECT %ID, 
/// 	Title,
/// 	SomePackage.TheTable_MyIndexHighlight(%ID, 'cocktail* OR (hammock AND NOT bees)')
/// FROM SomePackage.TheTable
/// WHERE %ID %FIND search_index(MyIndex, 'cocktail* OR (hammock AND NOT bees)')
/// ORDER BY 4 DESC</example>
/// <p><var>pTags</var> is a comma-separated list of tags to use for highlighting. If only a single one
/// is supplied, it will be used to highlight all matches of search terms. If a second one is supplied,
/// it will be used for all terms in a NOT node of the search tree (such as 'bees' in the above example),
/// while the first will be used for all other terms.</p> 
/// <p><var>pLimit</var> can be used to limit the text to a maximum number of hits rather than returning
/// the entire, highlighted text. <var>pSearchOption</var> can be used as in other iFind search operations,
/// for example to also mark fuzzy matches or stem matches.</p>
ClassMethod Highlight(pRecordID As %CacheString, pSearchString As %String, pSearchOption As %String = {$$$IFSEARCHNORMAL}, pTags As %String = {$$$IFDEFAULTHLTAGS}, pLimit As %Integer = 0, Output pSC As %Status) As %String [ CodeMode = generator, ForceGenerate, GenerateAfter = InsertIndex, PublicList = (SQLCODE, %msg), ServerOnly = 1, SqlProc ]
{
	if %mode '= "method" {
		
		// BDB682 - exit if we don't need an extent
		if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
			$$$GENERATE($c(9)_"quit """"")
			quit $$$OK
		}
		
		
		$$$GENERATE($char(9)_"set pSC=$$$OK, tFullText = .."_%property_"GetStringValue(pRecordID)")
		$$$GetIndexLocations(%class,%property,tIndexLocation,tDataLocation,"")
		$$$comMemberKeyGetLvar(tFinderClass,%class,$$$cCLASSindex,%property,$$$cXXXXembeddedname)
		$$$GENERATE($char(9)_"do .."_%property_"GetIndexParams(.tParams)")
		$$$GENERATE($char(9)_"quit ##class(%iFind.Utils).HighlightInternal("_$$$QUOTE(tIndexLocation)_","_$$$QUOTE(tDataLocation)_","_$$$QUOTE(tFinderClass)_", pRecordID, tFullText, pSearchString, pSearchOption, pTags, pLimit, .tParams, .pSC)")
	}
	quit $$$OK
}

ClassMethod GetStringValue(pRecordID As %CacheString) As %String [ CodeMode = generator, Internal, ServerOnly = 1 ]
{
	if %mode = "method" quit $$$OK
	
	if $$$defClassKeyGet(%class,$$$cCLASSnoextent) {
		$$$GENERATE($c(9)_"quit """"")
		quit $$$OK
	}
		
	$$$GENERATE($char(9)_"set pSC=$$$OK, tObj = ##class("_%class_").%OpenId(pRecordID,,.pSC)")
	$$$GENERATE($char(9)_"quit:tObj=$$$NULLOREF """"")
	
	do parseIndexProperties^%occStorageCompiler(%class,%property,.prop,.issubval)
	set tPropType = $get($$$EXTPROPtype($$$pEXT,%class,prop(1)))
	$$$GENERATE($char(9)_"set tFullText=""""")
	if ($$$comClassKeyGet(tPropType,$$$cCLASSsqlcategory)=$$$cCLASSSQLCATEGORYSTRING) {
		$$$GENERATE($char(9)_"set tFullText = tObj."_prop(1))
	} else { // stream
		$$$GENERATE($char(9)_"quit:tObj."_prop(1)_"=$$$NULLOREF """"")
		$$$GENERATE($char(9)_"set tFullText=""""")
		$$$GENERATE($char(9)_"do tObj."_prop(1)_".Rewind()")
		$$$GENERATE($char(9)_"while 'tObj."_prop(1)_".AtEnd {")
		$$$GENERATE($char(9,9)_"set tLen=32656, tFullText = tFullText_tObj."_prop(1)_".Read(.tLen, .pSC)")
		$$$GENERATE($char(9,9)_"quit:$$$ISERR(pSC)")
		$$$GENERATE($char(9)_"}")
		$$$GENERATE($char(9)_"quit:$$$ISERR(pSC) """"")
	}
	$$$GENERATE($char(9)_"quit tFullText")
	quit $$$OK
}

}
