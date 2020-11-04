Include %sySystem

/// Information about databases used by a Cache instance. The List() query is used
/// by the SYS.WSMon.Service.EnumDatabase() Web method, to provide details on all databases.
/// The Sample() method can be used to Get information about a specific database.
Class SYS.WSMon.wsDatabase Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// The name given to the Cache database
Property Name As %String;

/// The path and file name of of the database.
Property Directory As %String;

/// The amount of disk space (in MB) allocated for this database.
Property SizeAllocated As %Integer;

/// An indicator whether this database is currently mounted.
Property Mounted As %Boolean;

/// An indicator whether this database is mounted with only read access.
Property ReadOnly As %Boolean;

/// An indicator whether this database is monted with cluster access.
Property Cluster As %Boolean;

/// The available space (in MB) in this database.
/// Note that the %Monitor FreeSpace property in Cache must be active.
Property FreeSpace As %Integer;

/// Sample counters for all Databases
Query List() As %Query(ROWSPEC = "Name:%String,Directory:%String,SizeAllocated:%Integer,Mounted:%Boolean,ReadOnly:%Boolean,Cluster:%Boolean,FreeSpace:%Integer")
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SampleExecute ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SampleExecute ]
{
}

/// Instantiate the class and fill in current values for all properties.
/// 'index' is an integer index into the database list.
ClassMethod Sample(index) As SYS.WSMon.wsDatabase
{
}

}
