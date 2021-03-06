Include %syDataCheck

/// A list of global subscript ranges describing the entire key space of a single global.
/// Objects of this class are the list header with properties for the list metadata.  The
/// <QUERY>ListElements</QUERY> query provides the list elements as rows.
/// <p>
/// The RangeList is used to store results of the check and also the include/exclude
/// subscript ranges to check (see <PROPERTY>ListSet</PROPERTY> property for more info)
/// <p>
/// RangeList objects that store results are maintained by the DataCheck destination
/// system and should not be modified.
/// <p>
/// To create/edit a global selection RangeList as part of configuring a DataCheck
/// destination system, the sequence is as follows.  Note that the system must be
/// configured to use global selection RangeLists in order for this to have an effect:
/// <br> 1. To create a new RangeList object, passing the appropriate arguments to the 
/// %New() constructor (see <METHOD>%OnNew</METHOD>); then call <METHOD>SetCollation</METHOD>.
/// To edit an existing RangeList object, you can open through the <INDEX>MainIndex</INDEX>
/// with the <METHOD>MainIndexOpen</METHOD> method.
/// <br> 2. Call <METHOD>Insert</METHOD> repeatedly, setting the desired ranges to state
/// $$$RangeStateExcluded, with the rest being $$$RangeStateIncluded.
/// <br> 3. Call <METHOD>%Save</METHOD> to save the object.
/// 
Class SYS.DataCheck.RangeList Extends %Persistent
{

/// DataCheck system name that this RangeList belongs to
Property SystemName As SystemName [ ReadOnly, Required ];

/// Counter used as part of the composite id
Property Counter As %Counter [ Internal ];

Index IdIndex On (SystemName, Counter) [ IdKey ];

/// The set of RangeLists that this object is a member of.
/// Integer values 1 and higher are the set of results generated by the DataCheck system
/// and incremented each time the system starts a new set of results.  The currently active
/// set of results is returned by <METHOD>GetActiveResultsListSet</METHOD>.  A value of "%GS"
/// ($$$RangeListSetGlobalSelection) indicates that this object is a member of the set of 
/// configured subscript ranges to include / exclude from the check.
Property ListSet As %String(COLLATION = "EXACT") [ Required ];

/// Database referenced by this RangeList
Property Database As LocalDatabase [ ReadOnly, Required ];

/// Global name referenced by this RangeList
Property GlobalName As GlobalReference [ ReadOnly, Required ];

/// Collation of global or -1 if unknown
Property Collation As %Integer [ InitialExpression = -1, ReadOnly ];

/// EleNum of first element in the list
Property FirstEleNum As %Integer(MINVAL = 0) [ Internal, Private ];

/// Array of modified elements and their data <br>
///   ..Modified(elenum)=ele
Property Modified [ Internal, MultiDimensional, Private, Transient ];

/// Array of cached elements and, if not in the modified array, their data. <br>
///   ..Cached(elenum,"cnt") stores the count of cache reservations on the element<br>
///   ..Cached(elenum,"e") if exists, stores the element itself.
/// <p>
/// If a cached element has been modified then the "e" node will not exists and instead
/// the element is to be found in ..Modified(elenum). When reading elements, therefore,
/// it is important to pick them up from the ..Modified array first, then from the
/// ..Cached array (as an optimization), and finally from the global.
Property Cached [ Internal, MultiDimensional, Private, Transient ];

/// Array of elements EleNum to delete
Property Removed [ Internal, MultiDimensional, Private, Transient ];

/// Maintains an internal cache reservation on a few elements
Property InternalCacheToken [ Internal, MultiDimensional, Private, Transient ];

/// Index of the last newly created element.  Note: this is not necessarily the end of
/// the list or even a valid element.
Property LastUsedEleNum As %Integer(MINVAL = 0) [ InitialExpression = 0, Internal, Private ];

/// Count of elements in the range list
Property EleCount As %Integer [ Internal, Private ];

/// Count of elements in the $$$RangeStateMatched or $$$RangeStateExcluded state
Property MatchedCount As %Integer [ Internal ];

/// Count of elements in the $$$RangeStateUnknown state
Property UnknownCount As %Integer [ Internal ];

/// One of the following constants, defined for convenience in %syDataCheck.inc:
/// <li> 1 - $$$RangeStateMatched - the entire global, less any excluded ranges, was found to be matched</li>
/// <li> 0 - $$$RangeStateUnknown - the entire global has not been checked yet, but no discrepancies found</li>
/// <li>-1 - $$$RangeStateUnmatched - some ranges have discrepancies</li>
Property AggregateState As RangeState [ Calculated, SqlComputeCode = {s {AggregateState}=##class(SYS.DataCheck.RangeList).GetAggregateState({EleCount},{MatchedCount},{UnknownCount})}, SqlComputed ];

/// If an unexpected error occurs while updating the rangelist in methods like 
/// Init() and Insert(), it can leave the rangelist elements in an invalid state.
/// These methods trap unexpected errors and record them as a status code in ErrorStatus.
/// The ErrorStatus is checked in %OnAddToSaveSet and other important methods and 
/// fails if the ErrorStatus is not $$$OK.  The object must be reloaded, thus
/// discarding the invalid changes in order to clear the error status.
Property ErrorStatus As %Status [ InitialExpression = {$$$OK}, Internal, Private, Transient ];

Property Version As %Integer [ Internal, Private ];

Parameter VERSIONPROPERTY As STRING [ Internal ] = "Version";

Index MainIndex On (SystemName, ListSet, Database, GlobalName) [ Unique ];

Index StateIndex On (SystemName, ListSet, AggregateState);

/// Constructor for RangeList
/// <p>
/// Input Parameters:
/// <li>systemname: name of the DataCheck destination system
/// <li>set: set that this rangelist is a member of; see <PROPERTY>ListSet</PROPERTY>
/// <li>database: The local database path for non-mirror DataCheck configurations; the mirror 
/// database name, in :mirror:<i>mirrorname</i>:<i>mirrorDBname</i> format, for mirrored
/// DataCheck configurations.
/// <li>globalname: name of the global that this rangelist represents (leading ^ is optional)
/// <p>
/// IMPORTANT: The creator of a global selection RangeList is responsible for ensuring that 
/// the database is specified correctly, and for non-mirror DataCheck configurations, that
/// it has a mapping specified in the DataCheck configuration.
Method %OnNew(systemname As %String, set As %String, database As LocalDatabase, globalname As %String) As %Status
{
}

/// (Re)Initializes the list with specified state, removing list elements
/// and resets <PROPERTY>Collation</PROPERTY> to -1.  Caller must
/// call <METHOD>%Save()</METHOD> to save.  Caller must set the collation
/// with the <METHOD>SetCollation</METHOD> method before calling <METHOD>Insert</METHOD>
/// <p>
/// Input Parameters:
/// <li>state: initial state of the list
Method Init(state As RangeState = {$$$RangeStateUnknown}) [ Internal ]
{
}

/// Inserts a new range into the range list, merging and splitting with existing
/// ranges as appropriate.  Caller must call <METHOD>%Save()</METHOD> to save. 
/// <p>
/// Input Parameters:
/// <li>gloref1: beginning of the range to insert (inclusive) </li>
/// <li>gloref2: end of range to insert (exclusive) </li>
/// <li>state: state of the range to insert </li>
/// <li>cachetoken: (optional) A token returned from a previous call to Insert().
/// See below for more detail. </li>
/// Output Parameters:
/// <li>sc: %Status returned from this call.  If an error occurs that is not
/// simply the result of invalid input, the RangeList needs to be reloaded to 
/// return to a valid state; in this case subsequent calls to Insert or attempts
/// to save the RangeList will result in $$$DCRangeListErrorStatus errors.
/// <p>
/// Returns: Returns a "cachetoken" that reserves some of the list elements in a 
/// cache to optimize the next insert.  Caller must maintain this cachetoken as
/// described below.  If the status in 'sc' is not $$$OK, the cachetoken shall be
/// null.
/// <p>
/// The cachetoken returned from a call to Insert() should be passed in to the
/// next call to Insert() that is to act on a nearby part of the list.  Each call
/// to Insert() that is passed a token will: start a linear scan of the list from
/// elements referenced in the passed cachetoken (assuming those elements are
/// still cached and haven't be removed by intervening modifications to the list);
/// release the cache reservation on the elements that the token references; and
/// return a new cachetoken with an updated cache reservation.  If an Insert()
/// call is not known to be acting on a region of the list near to a cachetoken
/// that the caller has from a previous Insert() call, the caller should instead
/// pass a null cachetoken.  When no cachetoken is passed, Insert() will evaluate
/// all cached elements to determine an optimal starting location.
/// <p>
/// The caller is responsible for releasing the cache reservation for any
/// cachetoken returned from Insert() that is not used in a later Insert() call.
/// The cache reservation should be released by passing the unused cachetoken 
/// to <METHOD>ReleaseCacheToken()</METHOD> or by closing the RangeList object.
Method Insert(gloref1 As GlobalReference, gloref2 As GlobalReference = "", state As RangeState, cachetoken As %List = "", Output sc As %Status) As %List
{
}

/// Same as <METHOD>Insert</METHOD> except that no validation of input parameters
/// is performed, and errors are thrown to the caller rather than returned in the
/// output parameter.
Method InsertFast(gloref1 As GlobalReference, gloref2 As GlobalReference = "", state As RangeState, cachetoken As %List = "") As %List [ Internal ]
{
}

/// Takes as argument a cachetoken returned from Insert(), duplicates the reservations
/// of the cached elements and returns a duplicate cachetoken.
Method DuplicateCacheToken(cachetoken As %List) As %List [ Internal ]
{
}

/// Takes as argument a cachetoken returned from <METHOD>Insert</METHOD> and releases the cache
/// reservation of the cached elements.
Method ReleaseCacheToken(cachetoken As %List)
{
}

/// Takes as argument a cachetoken and releases the cache reservation, not retaining
/// any internal cacheing of it.
Method ReallyReleaseCacheToken(cachetoken As %List) [ Internal, Private ]
{
}

/// Sets the <PROPERTY>Collation</PROPERTY> to the value of the 'col' parameter
/// if specified.  If no value is specified, obtains it from the local system by 
/// looking at the global referenced by this RangeList object, if it exists, or 
/// from the default for the database referenced by this RangeList object.
/// Throws an exception if it was already set to a valid collation.
/// Caller must call <METHOD>%Save()</METHOD> to save. 
Method SetCollation(col As %Integer)
{
}

ClassMethod LockBySystem(systemname As %String, shared As %Boolean = 0) As %Status [ Internal ]
{
}

ClassMethod UnlockBySystem(systemname As %String, shared As %Boolean = 0, immediate As %Boolean = 0) As %Status [ Internal ]
{
}

/// Outputs this rangelist to the current device
Method Output() [ Internal ]
{
}

/// Given a DataCheck system name, returns the ListSet of the currently active set of results
ClassMethod GetActiveResultsListSet(systemname As %String) As %String
{
}

/// Given a DataCheck system name and a list set, returns the date and time in $horolog format
/// when the check whose results are stored in that list set began.  Returns null if the set
/// does not exist.
ClassMethod GetListSetStartTime(systemname As %String, listset As %String) As %String
{
}

/// Given a DataCheck system name and a list set, returns the date and time in $horolog format 
/// when all pending DataCheck queries finished, with the specified list set was the active one.  
/// Returns null if there are queries pending and the specified list set is the active one, or
/// if the specified list set does not exist.  If the specified list set is the active one, the
/// value may change from non-null back to null if new queries are run. 
ClassMethod GetListSetEndTime(systemname As %String, listset As %String) As %String
{
}

ClassMethod SetListSetStartTime(systemname As %String, listset As %String, value As %String) [ Internal ]
{
}

ClassMethod SetListSetEndTime(systemname As %String, listset As %String, value As %String) [ Internal ]
{
}

/// Don't allow the save if an error occurred on Insert()
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private, ServerOnly = 1 ]
{
}

/// Saves the modified elements and deletes the removed elements. 
/// Doing this on after save ensures that the lock on the rangelist object
/// has been acquired and that version mismatches / validation has been resolved
/// before modifying any elements since the elements will be modified without locking
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private, ServerOnly = 1 ]
{
}

/// Delete all elements in this list when deleting the list
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private, ServerOnly = 1 ]
{
}

Trigger DeleteTrigger [ Event = DELETE, Internal ]
{
}

/// Subroutine of Insert(). Removes the element that follows 'ele'
/// On return, 'nextele' and 'prevele' are updated. 'ele' doesn't
/// currently need to be passed by reference but should be (hence
/// the note in the signature) so that RemoveEle could signal
/// that the element has been removed in the element data itself
/// if necessary in the future.  Callers should not depend on
/// anything in 'ele' after RemoveEle is called.
Method RemoveEle(ByRef ele As %List, ByRef prevele As %List, ByRef nextele As %List) As %List [ Internal, Private ]
{
}

/// Subroutine of Insert(). Inserts a new element it in the list
/// with prevele as its previous ele and nextele as the ele that follows it.
/// Sets its gloref and state. Returns the new element. On return, 'nextele'
/// and 'prevele' are updated. Callers must them pass by reference.
Method NewEle(ByRef prevele As %List, ByRef nextele As %List, gloref As GlobalReference, state As RangeState) As %List [ Internal, Private ]
{
}

/// Subroutine of Insert(); modifies an existing element with a new state.
/// 'ele' must be passed by reference and is updated on return. 
Method ChangeEleState(ByRef ele As %List, newelestate As RangeState) [ Internal, Private ]
{
}

/// Establishes a cache reservation on up to three elements. 
/// The elements should be passed by reference although currently
/// they are not modified by this function.
Method CacheEles(ByRef ele1 As %List, ByRef ele2 As %List, ByRef ele3 As %List) As %List [ Internal, Private ]
{
}

Method DumpArrays()
{
}

/// Subroutine of Insert(). Starting with the cachetoken, if provided, finds the 
/// existing element that begins the range where the global reference specified 
/// as 'gloref' collates. Returns that element. On return, nextele is the element
/// following the returned element or null if the returned element is last in the
/// list. On return, prevele may or may not be set, but if it is, its the element
/// preceding the returned element in the list.
/// <p>
/// The search for the beginning of the list is optimized to start with any valid
/// element in the cachetoken.  If all the elements in the cachetoken have been 
/// removed, or a null cachetoken has been provided (as is the case on first insert)
/// then any elements in memory are evaluated to start with the one closest to the
/// specified 'gloref' before finally resorting to scanning the list linearly
/// from the beginning.
Method GetStartingEle(cachetoken As %List, gloref As GlobalReference, Output nextele As %List, Output prevele As %List) As %List [ Internal, Private ]
{
}

/// Subroutine of ListElementsExecute() used to setup the process private global.
/// Returns the index into ^||%DataCheck.Temp used
Method SetupListGlobal() As %Integer [ Internal ]
{
}

ClassMethod GetAggregateState(elecount As %Integer, matchedcount As %Integer, unknowncount As %Integer) As RangeState [ CodeMode = expression, Internal, SqlProc ]
{
}

/// The ListElements query fetches as rows each subscript range in the rangelist in collation order.
/// Each subscript range is the global reference inclusive of the 'From' column up to but excluding
/// the global reference in the 'To' column.  If 'To' is null or "[end]" in display mode, the range
/// extends to the end of the global.
/// <p>
/// Input Parameters:
/// <li>systemname: name of the DataCheck system
/// <li>set: ListSet to query (see <PROPERTY>ListSet</PROPERTY> property)
/// <li>database: path of the database local to this system
/// <li>global: name of the global
/// <li>rl: (optional) If an object is passed in this parameter, it will be assumed to be the
/// RangeList object for which elements should be returned and the other input parameters
/// will be ignored.  This parameter also serves as an output parameter to return the 
/// RangeList object opened if no object was passed in.
/// <p>
/// Output Parameters:
/// <li>rl: (optional) If no object was passed in as an input parameter (see above), then the output
/// of this parameter is the RangeList object that was opened, or null if no RangeList
/// object exists (in this case no rows will be found).  If an object was passed as an
/// input parameter, it is not modified.
Query ListElements(systemname As %String, set As %String, database As LocalDatabase, global As GlobalReference, ByRef rl As RangeList) As %Query(ROWSPEC = "From:SYS.DataCheck.GlobalReference,To:SYS.DataCheck.GlobalReference,State:SYS.DataCheck.RangeState")
{
}

ClassMethod ListElementsExecute(ByRef qHandle As %Binary, systemname As %String, set As %String, database As LocalDatabase, global As GlobalReference, ByRef rl As RangeList) As %Status [ Internal ]
{
}

ClassMethod ListElementsClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = OneRangeListExecute ]
{
}

ClassMethod ListElementsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = OneRangeListExecute ]
{
}

Storage Default
{
<CounterLocation>^SYS.DataCheck.RangeListC</CounterLocation>
<Data name="RangeListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ListSet</Value>
</Value>
<Value name="3">
<Value>Database</Value>
</Value>
<Value name="4">
<Value>GlobalName</Value>
</Value>
<Value name="5">
<Value>Collation</Value>
</Value>
<Value name="6">
<Value>FirstEleNum</Value>
</Value>
<Value name="7">
<Value>LastUsedEleNum</Value>
</Value>
<Value name="8">
<Value>EleCount</Value>
</Value>
<Value name="9">
<Value>MatchedCount</Value>
</Value>
<Value name="10">
<Value>UnknownCount</Value>
</Value>
<Value name="11">
<Value>Version</Value>
</Value>
</Data>
<DataLocation>^SYS.DataCheck.RangeListD</DataLocation>
<DefaultData>RangeListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.DataCheck.RangeListD</IdLocation>
<IndexLocation>^SYS.DataCheck.RangeListI</IndexLocation>
<StreamLocation>^SYS.DataCheck.RangeListS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
