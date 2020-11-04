Include %sySystem

/// This class provides an overview of the system "health", with all of the critical
/// metrics and statuses gathered as properties in one class. It essentially contains
/// all of the data that's available on the Dashboard in the System Management Portal. 
/// Each property is a different metric or status. 
/// <br><br>
/// Most of the data is collected by an instance of the Cache Application Monitor running
/// in the %SYS namespace. You must have the %Monitor.System.Dashboard classes "active"
/// to collect the data (see ^%MONAPPMGR for details).
/// <br><br>
/// A class may be instantiated by calling the class method 'Sample', and then the current
/// value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s ref=##class(SYS.Stats.Dashboard).Sample()
/// w ref.GloRefsPerSec ; display number of global references per second
/// </example>
/// 
Class SYS.Stats.Dashboard Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// Most recently measured number of Global references per second.
Property GloRefsPerSec As %Numeric;

/// Number of Global references since system startup.
Property GloRefs As %Integer;

/// Number of Global Sets and Kills since system startup.
Property GloSets As %Integer;

/// Number of routine loads and saves since system startup.
Property RouRefs As %Integer;

/// Number of logical block requests since system startup.
Property LogicalReads As %Integer;

/// Number of physical block read operations since system startup.
Property DiskReads As %Integer;

/// Number of physical block write operations since system startup
Property DiskWrites As %Integer;

/// Most recently measured cache efficiency (Global references / (physical reads + writes))
Property CacheEfficiency As %Numeric;

/// Summary status of ECP application servers connected to this system.
Property ECPAppServer As %String;

/// Most recently measured ECP application server traffic in bytes/second.
Property ECPAppSrvRate As %Numeric;

/// Summary status of ECP data servers this system is connected to.
Property ECPDataServer As %String;

/// Most recently measured ECP data server traffic in bytes/second.
Property ECPDataSrvRate As %Numeric;

/// Summary status of shadow connections on this data source. Values from SYS.Shadowing class queries.
Property ShadowSource As %String;

/// Summary status of shadows configured on this shadow server. Values from SYS.Shadowing class queries.
Property ShadowServer As %String;

/// Elapsed time since this system was started.
Property SystemUpTime As %String;

/// Date and time of last system backup.
Property LastBackup As %String;

/// Indicates whether there is a reasonable amount of diskspace available for database files.
/// Possible values are "Normal", "Warning" (<5MB) or "Troubled" (<2MB)
Property DatabaseSpace As %String;

/// Indicates the current status of the database journaling.
/// Possible values are "Normal", "Disabled", "Suspended", "Frozen", "Paused", "Unknown".
Property JournalStatus As %String;

/// Indicates whether there is a reasonable amount of diskspace available for journal files.
/// Possible values are "Normal", "Warning" (<250MB) or "Troubled" (<50MB)
Property JournalSpace As %String;

/// Number of entries written to the system journal since system startup.
Property JournalEntries As %Integer;

/// Indicates the current status of the system Lock Table based on percentage used.
/// Possible values are "Normal", "Warning" (>85%) or "Troubled" (>95%)
Property LockTable As %String;

/// Indicates the current status of the system Write Daemon.
/// Possible values are "Normal" or "Troubled" (based on lack of movement in queue)
Property WriteDaemon As %String;

/// Most recent number of running processes.
Property Processes As %Integer;

/// Most recent number of CSP sessions.
Property CSPSessions As %Integer;

/// Number of serious alerts that have been raised.
Property SeriousAlerts As %Integer;

/// Number of application errors that have been logged.
Property ApplicationErrors As %Integer;

/// Maximum allowed license units for this system.
Property LicenseLimit As %Integer;

/// Text description of license type for this system.
Property LicenseType As %String;

/// Current count of license units being used.
Property LicenseCurrent As %Numeric;

/// Highest count of license units used.
Property LicenseHigh As %Numeric;

/// License usage as a percentage of available license units.
Property LicenseCurrentPct As %Numeric;

/// Highest license usage as a percentage of available license units.
Property LicenseHighPct As %Numeric;

/// Instantiate the class and fill in current values for all properties.
ClassMethod Sample() As SYS.Stats.Dashboard
{
}

}
