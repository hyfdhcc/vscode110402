ROUTINE %occCPTmeasure [Type=INC]

#; edit these and recompile
#define PBGTIMES 0
#define COUNTERENABLE 0
#define TIMERENABLE 0


#define MEASUREQ(%X) ##class(%XSQL.Format).QuoteCos(%X)

#define MEASURECM ##safeexpression($$$MEASUREQ(%classname)_"_"":""_"_$$$MEASUREQ(%methodname))

#define COUNTERTYPEMETHOD "method"


#if $$$COUNTERENABLE

#define COUNTMETHOD If $I(^||%cptcounters($$$COUNTERTYPEMETHOD,$$$MEASURECM)) {}

#define COUNTMETHODACTION(%action) If $I(^||%cptcounters($$$COUNTERTYPEMETHOD,$$$MEASURECM,%action)) {}

#else

#define COUNTMETHOD

#define COUNTMETHODACTION(%action)

#endif


#if $$$TIMERENABLE

#define TIMEMETHOD Set occcpttimer=##class(%CPT.TimeScope).%New($$$MEASURECM)

#else

#define TIMEMETHOD

#endif

