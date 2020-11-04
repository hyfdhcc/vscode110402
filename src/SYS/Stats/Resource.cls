Include %sySystem

/// This class represents detailed system metrics captured for 'seizes' of system
/// resources. Each instance of the class represents a different resource which controls
/// access to a different part of the system code. Examples are 'Pid' for the internal process
/// table, 'Lock' for locking structures, 'Stat' for statistics, etc.
/// <br><br>
/// The current values for each class instance may be fetched using the Query
/// 'Sample', and then the current value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s sz="Name,Seize,Nseize,Aseize,Bseize,BusySet" ; list of properties
/// s rset=##class(%ResultSet).%New("SYS.Stats.Resource:Sample")
/// d rset.Execute()
/// s len=$l(sz,",")
/// ; list all resources and related seize counts
/// while rset.Next() {
/// 	f i=1:1:len w rset.Data($p(sz,",",i)) w:i<len ","
/// 	w !
/// }
/// </example>
/// <br>
/// Metrics for Cache system resource contention
Class SYS.Stats.Resource Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// The name of the resource.
Property Name As %String;

/// Number of Seizes
Property Seize As %Integer;

/// Number of Nseizes
Property Nseize As %Integer;

/// Number of Aseizes
Property Aseize As %Integer;

/// Number of Bseizes
Property Bseize As %Integer;

/// Number of BusySet
Property BusySets As %Integer;

/// Sample counters for all Resource / SeizeTypes
Query Sample() As %Query(ROWSPEC = "Name:%String,Seize:%Integer,Nseize:%Integer,Aseize:%Integer,Bseize:%Integer,BusySet:%Integer")
{
}

ClassMethod SampleExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod SampleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SampleExecute ]
{
}

ClassMethod SampleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SampleExecute ]
{
}

/// Sample counters for all Resource / SeizeTypes. Same as "Sample" query except numbers
/// are formatted with separator characters.
Query Display() As %Query(ROWSPEC = "Name:%String,Seize:%String,Nseize:%String,Aseize:%String,Bseize:%String,BusySet:%String")
{
}

ClassMethod DisplayExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod DisplayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisplayExecute ]
{
}

ClassMethod DisplayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisplayExecute ]
{
}

/// Sample counters for all Resource / SeizeTypes. Same as "Display" query except we've added
/// "sort" columns, whih are the same number without formatting. The UI uses these extra columns
/// to sort the display, as integers with "," separators get sorted as strings.
Query DisplaySort() As %Query(ROWSPEC = "Name:%String,Seize:%String,SeizeSort:%Integer,Nseize:%String,NseizeSort:%Integer,Aseize:%String,AseizeSort:%Integer,Bseize:%String,BseizeSort:%Integer,BusySet:%String,BusySetSort:%Integer")
{
}

ClassMethod DisplaySortExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod DisplaySortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisplaySortExecute ]
{
}

ClassMethod DisplaySortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisplaySortExecute ]
{
}

/// Instantiate the class for a specific resource and fill in current values for all properties.
/// 'Index' is an integer from 1 to 'n' used to reference a specific resource. An index greater
/// than 'n' returns a blank resource Name. To find a specific resource Name, you would loop through
/// the Resource list starting at 1 until you find the Name (or reach a blank Name).
/// <br><br>
/// Allows for XML output of a single Resource instance.
ClassMethod Sample(Index As %Integer) As SYS.Stats.Resource
{
}

}
