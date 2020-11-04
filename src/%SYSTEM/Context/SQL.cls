Class %SYSTEM.Context.SQL Extends %RegisteredObject
{

/// Cached Query Lock Timeout
Property CQLockTimeout As %Integer;

/// RTC is an array of trigger names used for statement level recursive trigger call checking.<br>
/// RTC = recursive trigger check
Property RTC As %CacheString [ MultiDimensional ];

Property TSQLAnsiNulls As %Integer;

Property TSQLAnsiPadding As %Integer;

Property TSQLAnsiWarnings As %Integer;

Property TSQLCaseInsCompare As %Integer;

Property TSQLNoCount As %Integer;

Property TSQLQuotedIdentifier As %Integer;

Property contextStack As %String(MAXLEN = "") [ MultiDimensional ];

/// pushState will push the current state of the Context.SQL singleton onto the contextStack. 
/// This method is not normally invoked directly. It is normally called by a utility class method to push a context. 
Method pushState() As %Status
{
	set tPtr = i%contextStack + 1
	set i%contextStack(tPtr,1) = ..CQLockTimeout
	merge i%contextStack(tPtr,2) = ..RTC
	set i%contextStack(tPtr,3) = ..TSQLAnsiNulls
	set i%contextStack(tPtr,4) = ..TSQLAnsiPadding
	set i%contextStack(tPtr,5) = ..TSQLAnsiWarnings
	set i%contextStack(tPtr,6) = ..TSQLCaseInsCompare
	set i%contextStack(tPtr,7) = ..TSQLQuotedIdentifier
		// When any new properties are added to this class make sure to handle them appropriately here and
		// also in popContext
	// set i%contextStack(tPtr,8) = 
	set i%contextStack = tPtr
	quit $$$OK
}

/// popState will restore the state of the Context.SQL singleton from the top of the contextStack and remove 
/// the top stack element. 
/// This method is not normally invoked directly. It is normally called by a utility class method to pop a context. 
Method popState() As %Status
{
	if i%contextStack {
		set tPtr = i%contextStack
		set i%CQLockTimeout = i%contextStack(tPtr,1)
		kill i%RTC merge i%RTC = i%contextStack(tPtr,2)
		set i%TSQLAnsiNulls = i%contextStack(tPtr,3)
		set i%TSQLAnsiPadding = i%contextStack(tPtr,4)
		set i%TSQLAnsiWarnings = i%contextStack(tPtr,5)
		set i%TSQLCaseInsCompare = i%contextStack(tPtr,6)
		set i%TSQLQuotedIdentifier = i%contextStack(tPtr,7)
			// When any new properties are added to this class make sure to handle them appropriately here and
			// also in popContext
		// set i%contextStack(tPtr,8) = 
		set i%contextStack = tPtr - 1
		kill i%contextStack(tPtr)
	}
	quit $$$OK
}

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	set tSC=$$$OK
	try {
		set i%contextStack = 0
		set i%CQLockTimeout = $g(^%SYS("sql","server","cq lock timeout"),120)
		set tSetting = $$$ucase($Get(^%SYS("tsql","SET","ANSI_NULLS"),0))
		set i%TSQLAnsiNulls = $Case(tSetting,"OFF":0,"ON":1,:''tSetting)
		set i%TSQLAnsiPadding = 0
		set i%TSQLAnsiWarnings = 0
		set tSetting = $$$ucase($Get(^%SYS("tsql","SET","CASEINSCOMPARE"),0))
		set i%TSQLCaseInsCompare = $Case(tSetting,"OFF":0,"ON":1,:''tSetting)
		set i%TSQLNoCount = 0
		set tSetting = $$$ucase($Get(^%SYS("tsql","SET","QUOTED_IDENTIFIER"),0))
		set i%TSQLQuotedIdentifier = $Case(tSetting,"OFF":0,"ON":1,:''tSetting)
	}
	catch(ex) {
		set tSC = ex.AsStatus()
	}
	QUIT tSC
}

}
