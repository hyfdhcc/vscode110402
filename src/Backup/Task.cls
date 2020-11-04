Include %sySystem

/// A backup task is a backup type and an output device with an optional description.
/// There are a set of system defined tasks which cannot be changed.
Class Backup.Task Extends (%Persistent, %SYSTEM.Help) [ Final, Inheritance = right, StorageStrategy = BackupTaskStorage ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// The name of this task.
Property Name As %String [ ReadOnly ];

/// Type of backup which will be performed.
Property Type As %String(DISPLAYLIST = "/Full/Incremental/Cumulative Incremental", VALUELIST = "/0/1/2");

/// The date and time this backup task was last modified.
Property LastModifiedTime As %String [ ReadOnly ];

/// The date and time this backup task was last run.
Property LastRunTime As %String [ ReadOnly ];

/// The status of this backup task's last run.
/// It can be blank if the task has never been run, or else one of the following
/// statuses: "Running", "Completed", or "Failed".
Property LastRunStatus As %String [ ReadOnly ];

/// Indicates whether the journal file should be switched as part of
/// running the backup.
Property SwitchJournal As %Boolean;

/// User-specified description of this backup task. This is stored in the
/// backup history.
/// 
Property Description As %String(MAXLEN = 256);

/// User-specified output device for this backup task. This can be a 
/// tape device or a directory where the backup files are stored. If this
/// is blank the default is the <i>Backup</i> subdirectory under the
/// directory which contains the CACHESYS database.
Property Device As %SysPath;

/// True if the output device is a tape.
Property DeviceIsTape As %Boolean;

/// Date portion of the filename for the last run of this task. The full
/// filename consists of this property plus the .cbk file extension.
/// <br><br>
/// Log files are located in the <i>Backup</i> subdirectory under the
/// directory that contains the CACHESYS database, and their filenames
/// consist of the LastFile property plus the .log file extension.
Property LastFile As %String(MAXLEN = 256) [ ReadOnly ];

/// Denotes that this is a system task. Certain tasks are defined by the system and cannot be modified.
Property SystemTask As %Boolean [ ReadOnly ];

/// Overrides the default %LoadData method.
Method %LoadData(id As %String, flag As %Boolean) As %Status [ Private ]
{
}

Method %SaveData(id As %String) As %Status [ Private ]
{
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// remove the data when an instance is deleted.
/// 
/// <P>If this method returns an error then the object will not be created.
ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
}

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// <br><br>
/// The name of the new task must be specified as the argument to the
/// %New() method and is resitricted to alphanumeric characters.
/// <br><br>
/// <P>If this method returns an error then the object will not be created.
Method %OnNew(newtask As %CacheString) As %Status [ Private ]
{
}

Method DeviceGet() As %String [ Internal ]
{
}

ClassMethod GetNormalizedDevice(DevicePath As %String = "", DeviceIsTape As %Boolean = 0) As %String [ Internal ]
{
}

ClassMethod GetTimestamp() As %String [ Internal ]
{
}

/// Provides a history of all backup operations that have been executed. The results are in reverse-chronological order.
Query History(DateStart As %String = "", DateEnd As %String = "") As %Query(ROWSPEC = "Type:%String,Databases:%String,Time:%String,Journal:%String,LogFile:%String,Status:%String")
{
}

ClassMethod HistoryExecute(ByRef qHandle As %Binary, TimeStart As %String = "", TimeEnd As %String = "") As %Status
{
}

ClassMethod HistoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HistoryExecute ]
{
}

ClassMethod HistoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HistoryExecute ]
{
}

/// Provides a list of all currently defined tasks. 
/// <br>
/// The four built-in tasks are always returned first,
/// followed by any user-defined tasks.
/// <br><br>
/// LastFile only has a value if a log file exists from the last run of the backup.
/// 
Query List() As %Query(ROWSPEC = "Name:%String,Type:%String,Device:%String,SwitchJournal:%Boolean,Description:%String,LastModifiedTime:%String,LastRunTime:%String,Status:%String,ReadOnly:%Boolean,IsTape:%Boolean,LastLogFile:%String,StatusStr:%String")
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// Returns a list of log files that exist for a specified backup task. If no task is specified,
/// returns a list of all log files for all backup tasks.
Query ListLogFiles(task As %String = "") As %Query(ROWSPEC = "Name:%String,")
{
}

ClassMethod ListLogFilesExecute(ByRef qHandle As %Binary, task As %String = "") As %Status [ Internal ]
{
}

ClassMethod ListLogFilesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListLogFilesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListLogFilesExecute ]
{
}

Storage BackupTaskStorage
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^Backup.BackupTaskS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
