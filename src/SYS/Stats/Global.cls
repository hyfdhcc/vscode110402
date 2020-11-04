Include (%sySystem, %syDatabase)

/// This class represents system metrics captured for globals. Each property is a different metric. 
/// A class may be instantiated by calling the class method 'Sample', and then the current
/// value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s ref=##class(SYS.Stats.Global).Sample()
/// w ref.RefLocal ; display number of local global references
/// </example>
///  
/// System stats for Global activity
Class SYS.Stats.Global Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// Local global references. The count of all global accesses to a local database.
Property RefLocal As %Integer;

/// Local global update references. The count of local global references that are Sets, Kills, or $Increments.
Property RefUpdateLocal As %Integer;

/// Private global references. The count of all process private global accesses.
Property RefPrivate As %Integer;

/// Private global update references. The count of private global references that are Sets, Kills, or $Increments.
Property RefUpdatePrivate As %Integer;

/// Remote global references. The count of all global accesses to a remote database..
Property RefRemote As %Integer;

/// Remote global update references. The count of remote global references that are Sets, Kills, or $Increments.
Property RefUpdateRemote As %Integer;

/// Logical block requests. The number of database blocks read by the global database code.
Property LogicalBlocks As %Integer;

/// Physical block reads. The number of physical database blocks read from disk.
Property PhysBlockReads As %Integer;

/// Physical block writes. The number of physical database blocks written to disk.
Property PhysBlockWrites As %Integer;

/// Global Throttle Count. The number of jobs required to wait for the throttle on this configuration.
Property ThrottleCnt As %Integer;

/// Global Throttle Current. The number of jobs currently counted as 'in global' for this configuration. 
Property ThrottleCur As %Integer;

/// Global Throttle Maximum. The maximum number of jobs to allow 'in global' on this configuration. 
Property ThrottleMax As %Integer;

/// Global Update Count. The number of users currently doing global updates (ijucnt) in this configuration. 
Property UpdateCnt As %Integer;

/// Global Update Lock. An indicator that the Write Demon has suspended global updates (1/0) in this configuration. 
Property UpdateLock As %Boolean;

/// Journal Entries. Number of journal records created, one for each database modification (Set , Kill, etc.) or transaction event (TStart, TCommit) or other event that is saved to the journal.
Property JrnEntries As %Integer;

/// Journal Block Writes. Number of 64-KB journal blocks written to the journal file.
Property JrnBlocks As %Integer;

/// Indicates whether the system Write Daemon is running ('1') or not ('0')
Property WDWake As %Integer;

/// The number of blocks waiting to be written by the Write Daemon
Property WDQueueSize As %Integer;

/// Instantiate the class and fill in current values for all properties.
ClassMethod Sample() As SYS.Stats.Global
{
}

/// Fetch PhysBlockReads and PhysBlockWrites collected for each Cache database.
/// <br><br>
/// You may pass a $LIST of databases (directories) in 'Names' to select specific databases.
Query ByDatabase(Names As %List = "") As %Query(ROWSPEC = "Database:%String,PhysBlockReads:%Integer,PhysBlockWrites:%Integer")
{
}

ClassMethod ByDatabaseExecute(ByRef qHandle As %Binary, Names As %List = "") As %Status [ Internal ]
{
}

ClassMethod ByDatabaseClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ByDatabaseExecute ]
{
}

ClassMethod ByDatabaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ByDatabaseExecute ]
{
}

}
