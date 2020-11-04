ROUTINE %DeepSee [Type=INC]
#; %DeepSee.INC
#; Include file for %DeepSee
 
#define DeepSeeMetaGLVN		^DeepSee.Cubes
#define DeepSeeIndexGLVN	^DeepSee.Index
#define DeepSeeJoinGLVN		^DeepSee.JoinIndex
#define DeepSeeFactGLVN		^DeepSee.Fact
#define DeepSeeDimGLVN		^DeepSee.Dimension
#define DeepSeeBucketsGLVN	^DeepSee.BucketList
#define DeepSeeFiltersGLVN	^DeepSee.Filters
#define DeepSeeRelationGLVN	^DeepSee.FactRelation
#define DeepSeeListingGLVN	^DeepSee.Listing
#define DeepSeeListingBitGLVN	^DeepSee.ListingBit
#define DeepSeeListingGroupGLVN	^DeepSee.ListingGroups
#define DeepSeeSessionGLVN	^DeepSee.Session
#define DeepSeeQMsrGLVN		^DeepSee.QMsrs
#define DeepSeeSharedCalcGLVN	^DeepSee.CalcMbrs

#define DeepSeeAxisGLVN		^DeepSee.Cache.Axis
#define DeepSeeResultsGLVN	^DeepSee.Cache.Results
#define DeepSeeCellsGLVN	^DeepSee.Cache.Cells
#define DeepSeeListingResultsGLVN	^DeepSee.Cache.Listing
#define DeepSeeChartsGLVN	^DeepSee.UI.Charts
#define DeepSeeKPIGLVN		^DeepSee.Cache.KPI
#define DeepSeeQueryNonceGLVN	^DeepSee.Cache.QueryNonce

#define DeepSeeBuildErrorsGLVN	^DeepSee.BuildErrors
#define DeepSeeAgentsGLVN		^DeepSee.Agents
#define DeepSeeAgentLogGLVN		^DeepSee.AgentLog
#define DeepSeeTasksGLVN		^DeepSee.Tasks
#define DeepSeeTaskGroupGLVN 	^DeepSee.TaskGroups
#define DeepSeeActiveTasksGLVN	^DeepSee.ActiveTasks

#; DTB422 - Add macros for update globals
#define DeepSeeUpdateBuffer		^OBJ.DSTIME
#define DeepSeeUpdateQueue		^DeepSee.Update

#define DeepSeeTempSourceId		^CacheTemp.DeepSeeSourceId
#define DeepSeeTempUpdate		^CacheTemp.DeepSeeUpdate

#define DeepSeeElementGLVN	^DeepSee.Elements

#define DeepSeeFunctionGLVN	^DeepSee.Functions

#define DeepSeeDSTIMECheckpointSubscript 1
#; Location of DSTIME non-cube "consumer" classes
#define DeepSeeDSTIMENonCubeConsumers(%consumerClass) $$$DeepSeeUpdateQueue($$$DeepSeeDSTIMECheckpointSubscript,%consumerClass)
#; Location of DSTIME checkpoints for non-cube "consumer" classes
#define DeepSeeDSTIMECheckpoint(%consumerClass,%sourceClass) $$$DeepSeeUpdateQueue($$$DeepSeeDSTIMECheckpointSubscript,%consumerClass,%sourceClass)

#; this expression is executed when a DeepSee session is created
#define DeepSeeInitCode		^DeepSee.InitCode

#; this expression is executed whenever a DeepSee dashboard page is visited
#define DeepSeeAuditCode	^DeepSee.AuditCode

#define DeepSeeIndex(%cube) $G($$$DeepSeeMetaGLVN("cubes",$$$UPPER(%cube),"indexName"),$$$UPPER(%cube))

#; Null value marker
#define DeepSeeNullMarker		"<null>"
#define DeepSeeNullTimeMarker	-1E14

#; For cube versioning. New logical cube names are constructed as cubeName _ $$$dsVersionDelim _ cubeVersion
#define dsVersionDelim			":"

#; DeepSee session object
#define DeepSeeSession		%DeepSeeSession

#; type constants: Used in the following cases:
#;  for member provider objects
#;  for defining signatures for MDX functions
#;  return value of the node.%GetType function

#define dstUnknown			"?"
#define dstDimension		"D"
#define dstHierarchy		"H"
#define dstLevel			"L"
#define dstSet				"S"
#define dstMember			"M"
#define dstInteger			"I"
#define dstValue			"V"
#define dstString			"ST"
#define dstFlag				"F"
#define dstExpression		"E"
#define dstMeasure			"MX"

#; code the calendar type
#define dsCodeCalendar(%c) 		$Case($$$UPPER(%c),"GREGORIAN":"G","HIJRITABULAR":"HT","HIJRIOBSERVED":"HO",:"G")

#; slots for measures in cell cache
#define DeepSeeAggSUM			1
#define DeepSeeAggMIN			2
#define DeepSeeAggMAX			3
#define DeepSeeAggCOUNT			4

#; buckets
#define DeepSeeBitsPerChunk 				64000
#define DeepSeeChunksPerBucket(%cube)		$G($$$DeepSeeMetaGLVN("cubes",%cube,"bucketSize"),8)
#define DeepSeeFactToBucket(%cube,%fact) 	(((%fact\$$$DeepSeeBitsPerChunk)\$$$DeepSeeChunksPerBucket(%cube))+1)

#; short cuts for size of fact table
#define DeepSeeFirstFact(%factTable)	$O($$$DeepSeeFactGLVN($ZCVT(%factTable,"U"),""))
#define DeepSeeLastFact(%factTable)		$G($$$DeepSeeFactGLVN($ZCVT(%factTable,"U")))

#; general purpose macros
#; Pad numeric value with leading zeroes
#define iscPadZero(%text,%n)	$TR($J(%text,%n)," ",0)
#define iscDaysInMonth(%y,%m)	$Case((%m),1:31,2:$S($$$iscIsLeapYear(%y):29,1:28),3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31,:0)
#define iscDaysInYear(%y)		$Case($$$iscIsLeapYear(%y),1:366,:365)
#define iscIsLeapYear(%y)		$S((%y)#4=0:$S('((((%y)#100)=0)&&(((%y)#400)'=0)):1,1:0),1:0)

#define	iscEscapeSQL(%f)		$Replace(%f,"'","''")

#; reference time used for age-based values
#define dsReferenceTime			58440

#define dsEscapeIdent(%ident)	$Replace(%ident,"]","]]")

#; debugging
#define DSWRITE(%str)				WRITE:('$IsObject($G(%request))) %str
#define DSWRITELN(%str)				WRITE:('$IsObject($G(%request))) %str,!
#define DSLOG(%str)					Set ^%ds($I(^%ds))=%str
#define TraceLevel					$g(^ISC.DeepSee.Trace)
#define Trace(%l,%key,%msg)			if ($$$TraceLevel >= %l) { set ^ISC.DeepSee.Trace(%l,$j,%key) = %msg }

#; query statistics
#define dsqStatCompute			1
#define dsqStatCache			2

#define T(%x,%y)					##class(%DeepSee.extensions.StudentDistribution).%T(%x,%y)

#; don't quote identifiers when delimted identifiers turned off
#define quoteIfDelimId(%str) $s($$$DelIds:$$$quote(%str),1:%str)

#; DTB530 - Management of the system process tag [JO2965].
#define dsReadProcessType(%pid)		$ZU(67,10,%pid)
#define dsTagDeepSeeAgent			$ZU(61,10,$ZU(61),$$$DEEPSEEAGENT)