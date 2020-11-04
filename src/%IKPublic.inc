ROUTINE %IKPublic [Type=INC]
//////////////////////
/// CONFIG MACRO's ///
//////////////////////
#define DEFAULTCONFIG           "DEFAULT"

///////////////////////
/// GENERAL QUERIES ///
///////////////////////

/// Values for "setop" parameter
#define UNION 1
#define INTERSECT 2

/// Values for "aggtype" parameter
#define AGGSUM 1
#define AGGAVG 2
#define AGGMIN 3
#define AGGMAX 4

/// Values for "sorttype" parameter
#define SORTBYDOMAINDEFAULT -1
#define SORTBYFREQUENCY 0
#define SORTBYSPREAD 1
/// only for matching-based queries:
#define SORTBYSCORE 2 

/// Values for "filtermode" parameter
#define FILTERONLY 1
#define FILTERFREQ 3
#define FILTERSPREAD  5
#define FILTERALL 7
#define FILTERFREQANDSORT 11
#define FILTERSPREADANDSORT 13
#define FILTERALLANDSORT 15

/// Values for %iKnow.Filters.GroupFilter groupLogic parameter
#define GROUPFILTERAND 1
#define GROUPFILTEROR 2

/// Values for %iKnow.Queries.EntityAPI.GetSimilar mode
#define USEDOMAINDEFAULT -1
#define USEPARTS 0
#define USENGRAMS 1
#define USEWORDS 2

/// Values for "positionstomatch" parameter
#define USEPOSM 	1 
#define USEPOSR 	2 
#define USEPOSMR 	3 
#define USEPOSS 	4 
#define USEPOSMS 	5 
#define USEPOSRS 	6 
#define USEPOSALL 	7

/// Wildcard value for *CrcByMask queries
#define WILDCARD "*"

/// Values for "enttype" parameter
#define ENTTYPEANY -1
#define ENTTYPECONCEPT 0
#define ENTTYPERELATION 1
#define ENTTYPENONREL 2
#define ENTTYPEPATHREL 3

/// Values for SourceAPI.GetSimilar() "algorithm" parameter
#define SIMSRCSIMPLE "SIMPLE"
#define SIMSRCEQUIVS "EQUIVALENTS"
#define SIMSRCDOMENTS "DOMINANTENTITIES"

/// Values for EntityAPI.GetNewBySource() "algorithm" parameter
#define NEWENTSIMPLE "SIMPLE"

///////////////////////////
/// SIMPLE METADATA API ///
///////////////////////////

/// Metadata filter operators
#define MDOPEQUAL "="
#define MDOPNOTEQUAL "!="
#define MDOPSMALLER "<"
#define MDOPSMALLEROREQUAL "<="
#define MDOPLARGER ">"
#define MDOPLARGEROREQUAL ">="
#define MDOPBETWEEN "BETWEEN"
#define MDOPISNULL "IS NULL"
#define MDOPISNOTNULL "IS NOT NULL"

/// The separator used for BETWEEN and other complex operators
#define MDVALSEPARATOR ";"

/// Shorthand for use in AddField() or UpdateField() calls
#define MDALLOPERATORS $lb($$$MDOPEQUAL,$$$MDOPNOTEQUAL,$$$MDOPSMALLER,$$$MDOPSMALLEROREQUAL,$$$MDOPLARGER,$$$MDOPLARGEROREQUAL,$$$MDOPBETWEEN,$$$MDOPISNULL,$$$MDOPISNOTNULL)

/// BDB123 accept alternatives as well
#define MDOPSMALLEROREQUAL2 "=<"
#define MDOPLARGEROREQUAL2 "=>"

/// Metadata data types
#define MDDTSTRING "STRING"
#define MDDTNUMBER "NUMBER"
#define MDDTDATE   "DATE"

/// Metadata storage types
#define MDSTNORMAL 0
#define MDSTBITMAP 1
#define MDSTCOMPRESS 2
#define MDSTCOMPRESSBITMAP 3


//////////////////////////
/// SMART MATCHING API ///
//////////////////////////

/// Match targets
#define DMTARGETENTITY 0
#define DMTARGETCRC 1
#define DMTARGETPATH 2
#define DMTARGETSENT 3

/// Dictionary Term status values
#define DTPROCESSED 0
#define DTUNPROCESSED -1

/// Dictionary Element types
#define DETERM 0
#define DEFORMAT 1

/// Dictionary Element reserved values for position/role/type
#define DMPOSUNDEFINED -1
#define DMROLEUNDEFINED -1
#define DMSCOREUNDEFINED -1

/// All cross-domain dicitonaries
#define ALLXDOMDICTIONARIES "XDOM"


////////////////////////
/// MATCHING PROFILE ///
////////////////////////

#define MPROFDONTCARE 0
#define MPROFSUBSTRACT 1
#define MPROFSUBSTRACTANDDIVIDE 2

#define MPROFANYGAP 1
#define MPROFEVERYGAP 2
#define MPROFEVERYGAPPOSITION 3

#define MPROFNONORMALIZE 0
#define MPROFNORMALIZE 1


/////////////////////////
/// DOMAIN PARAMETERS ///
/////////////////////////

/// Please refer to the documentation before using any of these!

///  Domain parameters: System
/// ---------------------------

#define IKPJOBS "Jobs"
#define	IKPMAXJOBS	24

#define IKPMULTIPLIER "Multiplier"

/// Whether or not !NGrams should be generated for this domain (enables NGram search in 
/// EntityAPI.GetSimilar()
#define IKPENABLENGRAMS "EnableNgrams"

/// Whether or not to use the Simple External ID feature, in which localRef = fullRef = externalId
#define IKPSIMPLEEXTIDS "SimpleExtIds"

/// Which %iKnow.Queries.MetadataI implementation to use for this domain.
#define IKPMETADATAAPI "MetadataAPI"
#define	IKPDEFMETADATAAPI	"%iKnow.Queries.MetadataAPI"

/// Which default sort field to use ($$$SORTBYFREQUENCY or $$$SORTBYSPREAD), used for
/// building certain globals.
#define IKPSORTFIELD "SortField"
#define	IKPDEFSORTFIELD		$$$SORTBYFREQUENCY


/// The %iKnow.DomainDefinition class managing this domain
#define IKPDEFINITIONCLASS "DefinitionClass"


/// If this parameter is set, the domain can only be edited through the "manager"
/// registered as this parameters value. This can be a %iKnow.DomainDefinition class or a
/// DeepSee cube name.
/// This is an internal parameter which should not be set by custom code.
#define IKPMANAGEDBY "ManagedBy"


/// This parameter controls whether or not the domain contains stemmed data. A value of 1 implies
/// every entity occurrence refers to the "base form" of that entity in that sentence, as a 
/// result of stemming.
/// To customize default stemming behavior (cf %iKnow.Stemming.DefaultStemmer), you can also specify
/// the name of a custom stemming configuration (cf %iKnow.Stemming.StemmingConfig) as a value for
/// this parameter.
#define IKPSTEMMING "Stemming"

#define IKPPACKAGE "Package"


///  Domain Parameters: Loading
/// ----------------------------

/// Displays progress indicators during the load process.
#define IKPSTATUS "Status"

/// Use this parameter to register a default configuration (by name) for use when loading
/// data into this domain. This domain default can be overridden by specifying a
/// configuration to the Lister or Loader objects as part of the loading process.
#define IKPDEFAULTCONFIG "DefaultConfig"

/// Skips checking whether an external ID already exists in the Processor.ProcessListElement()
#define IKPSKIPEXTIDCHECK "SkipExtIdCheck"

/// If set to 1, Processor.ProcessListElement() will no longer log individual errors in
/// ISC.IKL.Failed for every source it runs into for which the External ID already exists.
/// This is the recommended setting when scanning a location for new files.
#define IKPIGNOREDUPLICATEEXTIDS "IgnoreDuplicateExtIds"
#define IKPIGNOREDUPEXTIDS $$$IKPIGNOREDUPLICATEEXTIDS

/// If set to 1, the Loader will no longer throw an error if the batch it's processing is empty.
/// (default is to throw $$$IKNothingToProcess)
#define IKPIGNOREEMPTYBATCH "IgnoreEmptyBatch"

/// If set to the name of an existing metadata field that is populated during the loading
/// procedure, the system will use the metadata fields value (if set) as the language to
/// be used for processing this source and thereby overriding ALI.
/// WARNING: for this to work properly, you have to make sure the language value retrieved
/// here, corresponds to one of the ISO codes of the supported languages ($$$IKLANGUAGES)
/// AND this language has been loaded through the current Configuration object. 
#define IKPLANGUAGEFIELDNAME "LanguageFieldName"

/// If set to 1, batch and direct loads, updates, deletes will never be journalled
#define IKPDISABLEJOURNALLING "DisableJournalling"
#define IKPDEFDISABLEJOURNALLING 1

#define IKPENABLEPREFETCH "EnablePrefetch"


///  Domain Parameters: Matching
/// -----------------------------

/// Only detect full matches (100% entity-level match) and ignore all partial and scattered
/// variations. Default is 0.
#define IKPFULLMATCHONLY "FullMatchOnly"

/// Only detect and store matches at the entity level, never cascade to CRC or path level.
/// Default is 0
/// WARNING: this can significantly overgenerate match results
#define IKPENTITYLEVELMATCHONLY "EntityLevelMatchOnly"
#define IKPENTLEVELMATCHONLY $$$IKPENTITYLEVELMATCHONLY

/// Use this parameter to limit the number of matches found for a specific target (entity
/// occurrence, CRC, path or sentence) to the top N so that the match score of the worst
/// quality match for this target is greater or equal to the score of the best quality match
/// minus !MatchScoreMargin. Setting it to -1 (default) disables this feature and ensures
/// all matches for each target (satisfying the matching profile) are returned. 
#define IKPMATCHSCOREMARGIN "MatchScoreMargin"
#define	IKPDEFMATCHSCOREMARGIN	-1

/// This parameter controls whether or not to skip single relationships and path-relvants
/// in the first round of matching. The default setting is 1 and yields a significant
/// performance improvement, but will not catch single-entity matches that comprise of a single
/// relationship or path-relevant. Only set this parameter to 0 if you know your dictionaries contain
/// terms that comprise of just a single relationship or path-relevant.
#define IKPMATSKIPRELATIONS "MAT:SkipRelations"
#define IKPMATSKIPRELS $$$IKPMATSKIPRELATIONS
#define	IKPDEFMATSKIPRELATIONS	1
#define	IKPDEFMATSKIPRELS	$$$IKPDEFMATSKIPRELATIONS

/// Use this parameter to register a default profile (by name) for use when matching sources
/// against dictionaries in this domain. For cross-domain profiles, prepend the profile
/// name with "0:" (zero-colon), otherwise the name will be looked up within the set of
/// profiles registered for this domain only. This domain default can be overridden by
/// specifying a matching profile as part of the call to MatchSources() or MatchSource()
#define IKPMATDEFAULTPROFILE "MAT:DefaultProfile"

/// This parameter controls Standardized Form matching, which means entities are standardized
/// through a standardization function defined by the parameter value, before they are matched to
/// Dictionary Elements, which are also standardized at the time they are created.
/// Possible values are:
///		- "": no standardization (default)
///		- "%Text": %Text Standardize() function
///		- "Stem": default in-engine stemming
///	If another value is specified, it's assumed to be in the form "classname:methodname",
/// referring to a custom standardization function that takes a %String as its first argument and
/// a language code as an (optional) second argument, which returns the standardized form of
/// the input string.
#define IKPMATSTANDARDIZEDFORM "MAT:StandardizedForm"
#define IKPMATSTANDARDIZEDFORMTEXT "%Text"
#define IKPMATSTANDARDIZEDFORMSTEMMING "Stem"

/// This parameter controls whether or not matching should happen based on NGrams rather than words
/// It is only recommended for space-less languages such as Japanese
#define IKPMATCHNGRAMS "MAT:NGrams"


///  Domain parameters: Queries
/// ----------------------------

/// This parameter dictates whether or not to use the Filter Cache feature. If set to 1
/// (default), filtering results will be cached in ^CacheTemp globals so they can be reused
/// across queries and processes. If you anticipate a lot of updates to the domain (source
/// additions & metadata changes) or if query invocations are unlikely to often reuse the
/// same filter criteria, switch this off.
#define IKPENABLEFILTERCACHE "EnableFilterCache"
#define	IKPDEFENABLEFILTERCACHE	1

/// This parameter is used as part of the %iKnow.Queries.EntityAPI.GetTop() query to filter
/// meaninglessly short concepts from the result. It defaults to 3.
#define IKPMINTOPCONCEPTLENGTH "QUERY:MinTopConceptLength"
#define	IKPDEFMINTOPCONCEPTLENGTH	3

/// This parameter defines what to do if a data structure required to serve a particular query's
/// results is not present or not up-to-date
#define IKPQUERYBUILDPOLICY "QUERY:BuildPolicy"
#define IKQBPERROR "ERROR"
#define IKQBPASIS "ASIS"
#define IKPDEFQUERYBUILDPOLICY $$$IKQBPASIS



///  Domain parameters: DeepSee
/// ----------------------------

/// This parameter marks domains managed by DeepSee, containing data from an "iKnow measure".
/// This parameter is to be used internally only and cannot be changed by end custom code.
#define IKPDEEPSEEDOMAIN "DeepSeeDomain"

/// With this parameter, users can identify a particular Term List to be used as a BlackList
/// in all iKnow queries issued by DeepSee, including those issued from the Entity Dimension
/// and the ones behind the Entity Analysis window.
/// In an iKnow-managed domain, specify the name of the BlackList itself.
/// WARNING: Use with caution! This parameter directly impacts analysis results and might
/// hide results that are *presumably* less-relevant as per the opinion of the BlackList author
#define IKPDSBLACKLIST "DS:BlackList"

/// [ADVANCED USE]
/// This parameter can be used to override the default set of globals generated for a DeepSee-
/// managed domain. When changing this value for an existing cube, the contents of the domain will
/// be erased and a cube rebuild is required afterwards.
#define IKPDSBUILDFLAGS "DS:BuildFlags"

/// These parameters are for use by DeepSee-managed domains only and should never be 
/// set or changed by end custom code.
#define IKPDSCUBE "DS:CubeName"
#define IKPDSMEASURE "DS:MeasureName"


///  Domain parameters: Debug
/// --------------------------

#define IKPENABLEDEBUG "EnableDebug"
#define IKPENABLETIMINGS "EnableTimings"
#define IKPSAVETEMP "SaveTemp"
#define IKPSAVELIST "SaveList"
#define IKPDEBUGWAIT "DebugWait"


////////////////////////
/// Filter constants ///
////////////////////////

#define IKFSOURCE	0
#define IKFENTUNI	1
#define IKFENTOCC	2
#define IKFCRCUNI	3
#define IKFCRCOCC	4
#define IKFPATH		5
#define IKFENTOCCC	6
#define IKFENTOCCR	7
#define IKFCCUNI	8
#define IKFCCCOMBI	9
#define IKFSTEMUNI	10

/////////////////
/// Semantics ///
/////////////////

/// Dominance

#define	SDCONCEPT		0
#define	SDRELATION		1
#define SDCRC			2
#define SDPATH			3
#define SDAGGREGATE		4
#define SDSTEMCONCEPT	5
#define SDSTEMRELATION	6

/// Keep old names until DominanceAPI has been redone
#define	SDENTITY		$$$SDCONCEPT
#define SDFULL			$$$SDAGGREGATE

#define SDSORTDOMINANCE	0
#define SDSORTLENGTH	1
#define SDSORTTEXTORDER	2

#define SDALL			0
#define SDABOVEAVERAGE	1

#define SDDOMINANCE 	0
#define SDPROFILE		1

#define SDCRCBLACKLISTALL	1
#define SDCRCBLACKLISTANY	2

/// Equivalents
#define SEMANUAL			0
#define SEPROXIMITY			1


//////////////////////
/// CUSTOM METRICS ///
//////////////////////

/// Metric context types
#define IKMTRTYPEDOMAIN	"domain"
#define IKMTRTYPESOURCE	"source"
#define	IKMTRTYPEGROUP "group"

/// Metric target types
#define IKMTRENTITY	"entity"
#define IKMTRCC		"cc"
#define IKMTRCRC	"crc"
#define IKMTRPATH	"path"
#define IKMTRSENTENCE	"sentence"
#define IKMTRSOURCE	"source"


//////////////////
/// ATTRIBUTES ///
//////////////////

#define IKATTNEGATION	  1
#define IKATTTIME		  2
#define IKATTMODIFIER	  3
#define IKATTNONSEMANTIC  4
#define IKATTSENPOSITIVE  5
#define IKATTSENNEGATIVE  6
#define IKATTENTITYVECTOR 7
#define IKATTTOPIC        8

#define IKATTLVLANY		-1
#define IKATTLVLENTOCC  0
#define IKATTLVLPATH	1
#define IKATTLVLSENT	2