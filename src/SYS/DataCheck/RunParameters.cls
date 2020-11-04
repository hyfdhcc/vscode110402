/// Dynamic parameters for the running system.  An instance of this class is referenced 
/// by each <CLASS>Destination</CLASS> and affects the behavior of both systems involved 
/// in the check.  The RunParameters object defines the performance characteristics and 
/// what to check.  Changes that are saved while the system is running will take immediate
/// effect unless otherwise specified.
Class SYS.DataCheck.RunParameters Extends %Persistent
{

/// Name of the DataCheck Destination system that uses this object.
/// Set upon creating the destination object and should not be changed.
/// 
Property SystemName As SystemName [ Required ];

Index IdIndex On SystemName [ IdKey ];

/// The minimum number of nodes to traverse in a query.  This is the granularity,
/// in number of global nodes, with which the system will isolate discrepant global ranges.
/// A value of 1 means that the system will isolate discrepancies down to a single
/// node.  Higher values give vastly better performance through unmatched sections.
Property MinimumQuerySize As %Integer(MINVAL = 1) [ InitialExpression = 32 ];

/// If true use the per-database selection mask defined in the 
/// <PROPERTY>GlobalSelectionMask</PROPERTY> array to choose which globals to check.
/// If false, check all globals in all directories.
/// <p>
/// Changes take effect next time a new check is begun (ie on entering the 'Check' phase).
/// 
Property UseGlobalSelectionMask As %Boolean [ InitialExpression = 0 ];

/// If true use the RangeList objects from the set of Global Selection RangeLists
/// to define additional subscript ranges to include/exclude.
/// If false ignore the Global Selection RangeLists
/// <p>
/// Changes take effect next time a new check is begun (ie on entering the 'Check' phase).
/// 
Property UseGlobalSelectionRangeLists As %Boolean [ InitialExpression = 0 ];

/// An array of strings used to determine the set of global names to check
/// in each database.  It is keyed by <CLASS>LocalDatabase</CLASS>, which is the
/// local database path for non-mirror DataCheck configurations and the mirror 
/// database name for mirrored DataCheck configurations.  Keys should be normalized
/// using ##class(SYS.DataCheck.LocalDatabase).Normalize() before being inserted.
/// The value is a mask, or comma-separated list of masks, to select globals.
/// If the value is not defined for a database, it defaults to select all globals.
/// <p>
/// IMPORTANT: Callers that modify this array are responsible for ensuring that
/// the database is specified correctly, and for non-mirror DataCheck 
/// configurations, that it has a mapping specified in the DataCheck configuration.
/// <p>
/// Example masks are as follows:<br> 
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
/// <p>
/// Changes take effect next time a new check is begun (ie on entering the 'Check' phase).
/// 
Property GlobalSelectionMask As array Of %String(MAXLEN = 32767);

/// Default value for <property>GlobalSelectionMask</property> for databases
/// not defined in that array.  Applies only when UseGlobalSelectionMask is true.
/// <p>
/// Changes take effect next time a new check is begun (ie on entering the 'Check' phase).
/// 
Property DefaultGlobalSelectionMask As %String(MAXLEN = 32767) [ InitialExpression = "*" ];

/// An integer between 1 and 10 to control how much of the system
/// resources (CPU, disk I/O, database cache) the DataCheck system may use.
/// The implementation may differ over time as software and hardware 
/// characteristics evolve.  The setting can be changed dynamically to tune
/// DataCheck activity up or down.  The characteristics of every system are
/// different, but the following general meanings apply:
/// 
/// <li>A throttle setting of 1 uses no more resources than one process for
/// performing DataCheck queries.  In other words, it uses at most one CPU and
/// does only one disk I/O at a time.  Whether the resources used are primary CPU
/// or primarily disk I/O depends on whether the data is in buffers already and can
/// vary as the check progresses.</li>
/// <li>As the throttle is raised up to 8, more system resources are consumed at
/// each step.  For systems with large amounts of resources (many CPUs, etc), 
/// each interval is scaled to increase resource consumption by, very roughly, the  
/// same multiplicative factor, such that at a throttle setting of 8, DataCheck
/// uses a large portion of system resources.  This takes into account the number
/// of CPUs and other factors.  At a throttle setting of 8 the system is still
/// expected to be responsive to a light load of application activity, and settings
/// of 6, 7, or 8 may be an appropriate on a typical system at off-peak hours 
/// (weekends or overnights for example).</li>
/// <li>A throttle setting of 9 is like 8, but allows DataCheck jobs to use the
/// entire buffer pool (unsets the batch flag).</li>
/// <li>A throttle setting of 10 attempts to utilize nearly all system resources 
/// for completing the check.</li>
/// 
Property Throttle As %Integer(MAXVAL = 10, MINVAL = 1) [ InitialExpression = 2 ];

/// Defaults to 0 and is not typically modified; it can be adjusted for fine-tuning
/// the throttle.  This parameter is specific to the details of the throttle
/// implementation.  It may  change or become defunct in the future if the throttle
/// implementation changes.  
/// <p>
/// When set to a non-zero number, overrides the heuristic for determining the 
/// number of worker jobs to use.  It is the number of jobs to run at throttle
/// setting of 8, which represents the highest number of DataCheck jobs that can 
/// run while still allowing the system to be responsive to a light load of
/// application activity.  When Throttle8Jobs is zero, its value is implicitly 
/// taken as the number of CPUs (on the smaller of the two systems being checked,
/// if their CPU counts are not the same).
/// <p>
/// The number of jobs used for throttle settings 1-8 is calculated based on this
/// parameter as Throttle8Jobs^((Throttle-1)/7) rounded to the nearest integer, or 
/// throttle itself, whichever is greater, but not to exceed Throttle8Jobs.
/// A throttle setting of 9 uses the same number of jobs as 8, but is allowed
/// to use the entire buffer pool.  A throttle setting of 10 will not user fewer
/// jobs than Throttle8Jobs, but may use more depending on the number of CPUs.
/// 
Property Throttle8Jobs As %Integer [ Internal ];

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
}

Storage Default
{
<Data name="GlobalSelectionMask">
<Attribute>GlobalSelectionMask</Attribute>
<Structure>subnode</Structure>
<Subscript>"GlobalSelectionMask"</Subscript>
</Data>
<Data name="RunParametersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MinimumQuerySize</Value>
</Value>
<Value name="3">
<Value>UseGlobalSelectionMask</Value>
</Value>
<Value name="4">
<Value>UseGlobalSelectionRangeLists</Value>
</Value>
<Value name="5">
<Value>Throttle</Value>
</Value>
<Value name="6">
<Value>DefaultGlobalSelectionMask</Value>
</Value>
<Value name="7">
<Value>Throttle8Jobs</Value>
</Value>
</Data>
<DataLocation>^SYS.DataCheck.RunParametersD</DataLocation>
<DefaultData>RunParametersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.DataCheck.RunParametersD</IdLocation>
<IndexLocation>^SYS.DataCheck.RunParametersI</IndexLocation>
<StreamLocation>^SYS.DataCheck.RunParametersS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
