Include (%syJrninc, FILEINC)

/// Example 1 (Restore everything in selected journal files of current Cache system):
/// <example>
/// s RestOref=##class(Journal.Restore).%New()
/// s RestOref.FirstFile="20100107.001"
/// s RestOref.LastFile="20100107.002"
/// s Status=RestOref.Run() 
/// </example>
/// Example 2 (Restore selected globals in selected databases from foreign journal files): 
/// <example>
/// s RestOref=##class(Journal.Restore).%New()
/// s RestOref.FirstFile="/another_system/20100107.001" ;copied from another Cache system
/// s RestOref.LastFile="/another_system/20100107.002" ;copied from another Cache system
/// s RestOref.JournalLog="/another_system/journal.log" ;copied from another Cache system
/// d RestOref.UseJournalLocation("/another_system") ;and so on (where to locate journal files)
/// s Status=RestOref.CheckJournalIntegrity(1) ;optional by itself, but necessary for setting up property SourceDatabases used below
/// s key="" for {
/// 	s SourceDatabase=RestOref.SourceDatabases.GetNext(.key) q:key=""
/// 	w !,SourceDatabase," => " r TargetDatabase
/// 	s Status=RestOref.RedirectDatabase(SourceDatabase,TargetDatabase)
/// 	s Status=RestOref.SelectUpdates(SourceDatabase,GlobalName1)
/// 	s Status=RestOref.SelectUpdates(SourceDatabase,GlobalName2) ;and so on
/// }
/// s Status=RestOref.Run()
/// </example>
Class Journal.Restore Extends %RegisteredObject [ System = 4 ]
{

/// This corresponds to the fromrest parameter in journal restore utility. <br>
/// fromrest is set by the caller of journal restore utility to indicate the type
/// of journal restore (or the type of the caller). For example, ^JCONVERT sets
/// fromrest=8 to instructs journal restore to write out the updates to a file
/// instead of applying them to databases. Some types of restore have their own
/// parameters (e.g., the path of an output file for fromrest=8), so a subclass 
/// for each type seems logical. <br>
/// ^JRNRESTO sets fromrest=0, which is the default here.
Parameter TYPE = 0;

Property StartTime As %TimeStamp [ Private ];

/// Path of a journal history log where the selected journal files are listed <br>
/// Default: the journal history log of local Cache system. <br>
/// Set JournalLog=-1 to override the default without specifying a journal log.
Property JournalLog As %String;

/// A list of directories where the selected journal files are located <br>
/// Required if <property>JournalLog</property> has a non-default value.
Property JournalLocation As list Of %String;

/// 	Set up <property>JournalLocation</property>
Method UseJournalLocation(JournalDirectory As %SysPath) As %Status
{
}

/// The first journal file to process
Property FirstFile As %String [ Required ];

/// The last journal file to process <br>
/// Default: the last journal file listed in the journal history log given by <property>JournalLog</property>
Property LastFile As %String;

/// A list of selected journal files in their <em>current</em> location
Property SelectedFiles As %String [ MultiDimensional, Private ];

/// Get a list of selected journal files using <property>FirstFile</property>,
/// <property>LastFile</property>, <property>JournalLog</property> and 
/// <property>JournalLocation</property>
Method SelectFiles(ByRef SelectedFiles As %String) As %Status [ Internal ]
{
}

/// A list of database directories stored in the selected journal files
/// for verifying the source database directories given in the
/// <property>DatabaseRedirection</property> property if specified
Property SourceDatabases As list Of %String;

/// To check the selected journal files for problems (missing files, corruptions, etc.)<br>
/// Scan <ul><li>
/// 0: look for missing files and inconsistent journal end offsets; </li><li>
/// 1: also collect a list of database directories in the selected journal files and
/// store them in <property>SourceDatabases</property>; </li><li>
/// 2: also perform a more thorough (and more time-consuming) check by going through 
/// every record in the selected journal files, which could detect corruptions in the 
/// middle of a journal file that would otherwise go unnoticed until the read restore.</li></ul>
Method CheckJournalIntegrity(Scan As %Integer = 0) As %Status
{
}

/// An array of SourceDatabase -> TargetDatabase for database redirection <br>
/// If none specified, apply updates to the original databases
/// <EXAMPLE>
/// s JrnRestOref=##class(Journal.Restore).%New()
/// s Status=JrnRestOref.RedirectDatabase(SourceDatabase,TargetDatabase)
/// </EXAMPLE>
Property DatabaseRedirection As %String [ MultiDimensional, Private ];

/// A table of (SourceDatabase,GlobalName) selected to be restored <br>
/// If none specified, restore everything from the selected journal files
/// <EXAMPLE>
/// s JrnRestOref=##class(Journal.Restore).%New()
/// s Status=JrnRestOref.SelectUpdates(SourceDatabase,GlobalName)
/// </EXAMPLE>
Property SelectedUpdates As %String [ MultiDimensional, Private ];

/// Set up journal restore to apply updates of SourceDatabase to TargetDatabase 
/// instead of SourceDatabase itself.<br>
/// Note that for database redirection to take effect, you must also call 
/// SelectUpdates() for <em>each</em> database to be restored, even if you intend
/// to have <em>all</em> databases restored.<br>
/// This method can be called before or after the SelectUpdates() calls.
/// 
Method RedirectDatabase(SourceDatabase As %String, TargetDatabase As %String) As %Status
{
}

/// To select a database or a global in a database to restore <br>
/// If GlobalName is not specified, all globals in SourceDatabase will be restored,
/// unless you also call SelectUpdates(SourceDatabase,GlobalName) (before or after 
/// the call without GlobalName), in which case only the specified global(s) are restored.<br>
/// GlobalName must begin with an alpha, "%", "*" or "?", followed by alphanumerics and
/// "*?."s ("." for dot syntax).
Method SelectUpdates(SourceDatabase As %String, GlobalName As %String = "") As %Status
{
}

/// whether to abort journal restore if an update would have to be skipped due to a 
/// journal-related problem (e.g., journal corruption, missing journal files, etc.)
Property AbortOnJournalError As %Boolean [ InitialExpression = 1 ];

/// whether to abort journal restore if an update would have to be skipped due to a 
/// database-related problem (e.g., a target database is not journaled, cannot be mounted, etc.)
Property AbortOnDatabaseError As %Boolean [ InitialExpression = 0 ];

/// Specify a filter routine such as "^ZJRNFILT" to apply to every selected updates during journal restore 
Property Filter As %String;

/// Specify a routine (or tag) such as "MARKER^ZJRNFILT" to be invoked on journal markers during journal restore 
Property MarkerTrigger As %String;

/// Whether to disable journaling of the applied updates (for performance purpose)
Property DisableJournaling As %Boolean [ InitialExpression = 1 ];

/// If current journal file is among the journal files selected to be processed, 
/// the user has an option to switch journal file or stop journaling system wide. <br>
/// This is necessary if <property>DisableJournaling</property> is NO,
/// as otherwise the applied updates will be journaled in the file that will be
/// dejournaled, resulting in data integrity issues. <br>
/// Even if <property>DisableJournaling</property> is YES, it is still a good 
/// practice to switch journal file so that new updates will go into the new file.
Property SwitchOnCurrentJournal As %Integer [ InitialExpression = 1 ];

/// To roll back incomplete transactions at the end of journal restore
Property RollBack As %Boolean [ InitialExpression = 1 ];

/// To dismount databases whose updates were skipped due to errors 
Property Dismount As %Boolean [ InitialExpression = 0 ];

/// To run journal restore
Method Run() As %Status
{
}

/// To monitor the progress of journal restore
ClassMethod Monitor(StartTime As %TimeStamp, Interval As %Integer = 10) As %Status [ Internal ]
{
}

}
