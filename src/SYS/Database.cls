Include (%sySystem, %sySecurity, %syDatabase, %syPrompt, %syAudit, %syJrninc, %occErrors, ISCQUIEDEF, %syEMS, %ems)

///  Manages Database Operations.<br>
///  <br>
///  To Create a new database with the system defaults do the following:<br>
///  <br>
///  Set db=##Class(SYS.Database).%New()<br>
///  Set db.Directory=Directory<br>
///  Set status=db.%Save()<br>
///  <br>
///  To modify an existing Database, do the following:
///  <br>
///  Set db=##Class(SYS.Database).%OpenId(Directory)<br>
///  //Set the property you want to modify:<br>
///  Set db.ExpansionSize=100<br>
///  Set status=db.%Save()<br>
///  <br>
///  Properties which can be set for database creation are:<br>
///  &nbsp&nbsp&nbsp Directory<br>
///  &nbsp&nbsp&nbsp BlockSize<br>
///  &nbsp&nbsp&nbsp EncryptedDB<br>
///  &nbsp&nbsp&nbsp EncryptionKeyID<br>
///  &nbsp&nbsp&nbsp Size<br>
///  &nbsp&nbsp&nbsp ExpansionSize<br>
///  &nbsp&nbsp&nbsp MaxSize<br>
///  &nbsp&nbsp&nbsp MirrorDBName<br>
///  &nbsp&nbsp&nbsp MirrorSetName<br>
///  &nbsp&nbsp&nbsp GlobalJournalState<br>
///  &nbsp&nbsp&nbsp NewGlobalCollation<br>
///  &nbsp&nbsp&nbsp NewGlobalIsKeep<br>
///  &nbsp&nbsp&nbsp NewGlobalGrowthBlock<br>
///  &nbsp&nbsp&nbsp NewGlobalPointerBlock<br>
///  &nbsp&nbsp&nbsp ClusterMountMode<br>
///  &nbsp&nbsp&nbsp ResourceName<br>
///  <br>
///  Properties which can be modified for an already created database are:<br>
///  &nbsp&nbsp&nbsp ReadOnly<br>
///  &nbsp&nbsp&nbsp Size<br>
///  &nbsp&nbsp&nbsp ExpansionSize<br>
///  &nbsp&nbsp&nbsp MaxSize<br>
///  &nbsp&nbsp&nbsp GlobalJournalState<br>
///  &nbsp&nbsp&nbsp NewGlobalCollation<br> 
///  &nbsp&nbsp&nbsp NewGlobalIsKeep<br>
///  &nbsp&nbsp&nbsp NewGlobalGrowthBlock<br>
///  &nbsp&nbsp&nbsp NewGlobalPointerBlock<br>
///  &nbsp&nbsp&nbsp ClusterMountMode<br>
///  &nbsp&nbsp&nbsp ResourceName<br>
///  <br>
///  Read-only properties which are managed by the system and cannot be modified are:<br>
///  &nbsp&nbsp&nbsp Expanding<br>
///  &nbsp&nbsp&nbsp LastExpansionTime<br>
///  &nbsp&nbsp&nbsp Mounted<br>
///  &nbsp&nbsp&nbsp ReadOnlyMounted<br>
///  &nbsp&nbsp&nbsp ClusterMounted<br>
///  &nbsp&nbsp&nbsp Mirrored<br>
///  &nbsp&nbsp&nbsp MirrorNoWrite<br>
///  &nbsp&nbsp&nbsp MirrorActivationRequired<br>
///  &nbsp&nbsp&nbsp MirrorFailoverDB<br>
///  &nbsp&nbsp&nbsp InActiveMirror<br>
///  &nbsp&nbsp&nbsp MirrorObsolete<br>
Class SYS.Database Extends (%Persistent, %SYSTEM.Help) [ Final, Inheritance = right, StorageStrategy = DBStorage, System = 4 ]
{

///  Default Localization Domain
Parameter DOMAIN = "%Utility";

///  ISM for old version ISM format, CACHE for Cache format
Property BlockFormat As %String [ InitialExpression = "CACHE", Internal ];

///  Current number of blocks
Property Blocks As %Integer [ InitialExpression = 0, Internal, ReadOnly ];

///  Block size in bytes of the database. <br>
///  Either 2048, 4096, 8192, 16384, 32768, or 65536
Property BlockSize As %Integer(VALUELIST = ",2048,4096,8192,16384,32768,65536") [ InitialExpression = {$$$8k} ];

///  Number of blocks per map
Property BlocksPerMap As %Integer [ InitialExpression = 0, Internal, ReadOnly ];

///  Database is currently cluster mounted 
Property ClusterMounted As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Database is configured to be mounted in cluster mode<br>
///  If this property is set then this database has to be mounted explicitly.
Property ClusterMountMode As %Boolean [ InitialExpression = 0 ];

Property CurrentMaps As %Integer [ Internal, ReadOnly ];

///  Directory containing the database
Property Directory As %SysPath;

///  Block where Global directory starts.<br>
///  3 for >2k pages<br>
///  2 or other for 2k pages. New 2k db's can only be 2.
Property DirectoryBlock As %Integer [ InitialExpression = 3, Internal, ReadOnly ];

///  Database is encrypted
Property EncryptedDB As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

///  Database encryption key ID
Property EncryptionKeyID As %String(MAXLEN = 63, MINLEN = 2);

///  Database is expanding.
Property Expanding As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Size in MB to Expand by. <br>
///  0 - Use system defaults (recommended)
Property ExpansionSize As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

///  0 - Database is not marked as full
///  <br>
///  1 - Database is marked as full
Property Full As %Boolean [ InitialExpression = 0, Internal ];

///  Last time database expanded, converted to local time.
Property LastExpansionTime As %String [ InitialExpression = 0, ReadOnly ];

///  Maximum size in MB, 0=unlimited (recommended).
Property MaxSize As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

///  Database is marked as mirrored
Property Mirrored As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Mirror set name of this mirrored database. 
Property MirrorSetName As %String;

///  Database name identified in mirror set
Property MirrorDBName As %String;

///  Database has a status of mirrored-no-write which means it is mounted
///  read-only so it cannot be written to.
Property MirrorNoWrite As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Database has a status of activation-required which means it is mounted
///  but there is a problem or it needs to be activated before use.
Property MirrorActivationRequired As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Mirror Database is obsolete due to the database's GUID mismatched with
///  GUID in mirror journal file directory block during dejournaling.
Property MirrorObsolete As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Mirrored Database is on failover members
Property MirrorFailoverDB As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Mirrored Database is created by %New instead of 'Added' to existing DB.
Property MirrorDBCreatedNew As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Mirrored Database is running for CatchupDB.
Property MirrorDBCatchup As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Mirrored Database is paused for dejournaling.
Property MirrorDBPaused As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Database has a status of InActiveMirror which means either we're
///  the primary and the db is read/write and available for use or we're
///  an active backup and the db is being replayed to by the mirror
///  dejournal jobs to keep it updated with changes occurring on the primary.
Property InActiveMirror As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Database is mounted.
Property Mounted As %Boolean [ InitialExpression = 0, ReadOnly ];

///  Default collation for new globals.
Property NewGlobalCollation As %Library.Collate [ InitialExpression = {##Class(%Library.Collate).GetSystemDefaultNumber()} ];

///  Default growth block for new globals.
Property NewGlobalGrowthBlock As %Integer(MINVAL = 50) [ InitialExpression = 50 ];

///  Default Keep value for New globals.
Property NewGlobalIsKeep As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

///  Number of DB configured to this DB diretcory. Only used by Cluster platforms.
Property NumberOfConfigDB As %Integer [ InitialExpression = 0, Internal, ReadOnly ];

///  Journal setting for database.
///  <br>
///  2 - No<br>
///  3 - Yes<br>
Property GlobalJournalState As %Library.JournalState;

///  Block where the index pointer starts.
Property NewGlobalPointerBlock As %Integer(MINVAL = 6) [ InitialExpression = 16 ];

///  Database attribute in label says Read Only.
Property ReadOnly As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

///  Database is mounted for read only
Property ReadOnlyMounted As %Boolean [ InitialExpression = 0, ReadOnly ];

///  0 - Do not reinitialize an existing database.
///  <br>
///  1 - Reinitialize an existing db
Property Reinitialize As %Boolean [ InitialExpression = 0, Internal ];

///  Requesting Size of the DB, though the DB might be created with smaller size.
Property RequestSize As %Integer [ InitialExpression = 0, Internal ];

///  Resource name for the database.
Property ResourceName As %String [ InitialExpression = "%DB_%DEFAULT" ];

///  System File number.
Property SFN As %Integer [ Internal, ReadOnly ];

///  Size in MB.
Property Size As %Integer(MINVAL = 1) [ InitialExpression = 1 ];

///  Database is created but not formatted.
Property Skeleton As %Boolean [ InitialExpression = 0, Internal, ReadOnly ];

///  0 - Force allocation of unused blocks.
///  <br>
///  1 - Do not force allocation of unused blocks (used by cachetemp)
Property SparseDB As %Boolean [ InitialExpression = 0, Internal ];

Method BlockSizeSet(val As %Integer) As %Status [ Internal ]
{
}

Method ClusterMountModeSet(val As %Integer) As %Status [ Internal ]
{
}

Method ClusterMountedSet(val As %Integer) As %Status [ Internal ]
{
}

Method EncryptedDBSet(val As %Integer) As %Status [ Internal ]
{
}

Method ExpansionSizeSet(val As %Integer) As %Status [ Internal ]
{
}

///  Disable journaling for Database.
Method DisableJournaling() As %Status
{
}

///  Enable journaling for Database.
Method EnableJournaling(val As %Integer) As %Status
{
}

Method GlobalJournalStateSet(val As %Integer) As %Status [ Internal ]
{
}

Method MaxSizeSet(val As %Integer) As %Status [ Internal ]
{
}

Method NewGlobalCollationSet(val As %Integer) As %Status [ Internal ]
{
}

Method NewGlobalGrowthBlockSet(val As %Integer) As %Status [ Internal ]
{
}

Method NewGlobalIsKeepSet(val As %Integer) As %Status [ Internal ]
{
}

Method NewGlobalPointerBlockSet(val As %Integer) As %Status [ Internal ]
{
}

Method ReadOnlySet(val As %Integer) As %Status [ Internal ]
{
}

Method SizeSet(val As %Integer) As %Status [ Internal ]
{
}

Method %OnValidateObject() As %Status [ Internal ]
{
}

///  Overrides the default %LoadData method.
Method %LoadData(id As %String, flag As %Boolean) As %Status [ Internal, Private ]
{
}

///  Overrides the default %SaveData method.
Method %SaveData(id As %String) As %Status [ Internal, Private ]
{
}

/// Return the status of the database.<br>
///  Parameters:<br>
///  Internal - True(default): return plan text of the status. False: return text with current language setting (for displaying).<br>
///  <br>
/// Possible returned texts:<br>
/// Unmounted<br>
/// Dismounted<br>
/// Expanding<br>
/// ClusterMounted/R<br>
/// ClusterMounted/RW<br>
/// Mounted/R<br>
/// Mounted/RW<br>
Method GetStatus(Internal As %Boolean = 1) As %String
{
}

ClassMethod AuditJournalStateChange(db As SYS.Database) As %Status
{
}

///  Prompt for block size.
ClassMethod BlockSizePrompt(Prompt, Obj) [ Internal ]
{
}

///  This checks to see if this configuration allows creating block sizes other than the default, which is 8k.
ClassMethod CheckBlockSizeAllowed(Size As %String) As %Boolean
{
}

///  This checks to see if this configuration can enable a certain block size.<br>
///  valid sizes are:<br>
///  4096,8192,16384,32768,65536<br>
ClassMethod CheckBlockSizeAvailable(Size As %String) As %Boolean [ Internal ]
{
}

Method CheckIntegrity() As %Status
{
}

///  Scans CACHE.DAT for any wide characters.<br>
///  This method is useful if you have a database mounted on a 16 bit system,
///  and you wish to move that database to an 8 bit system. Scanning the
///  database before you move it for wide characters (16 bit characters) will allow you to
///  fix the global references so you can avoid <WIDECHAR> errors after you move the database
///  to the 8 bit system.<br>
///  Parameters:<br>
///  Directory - Database directory to check for wide characters<br>
///  Global - Mask of globals to check, "*"=default.<br>
///  Valid masks are as follows:
///  <br>
///  ABC* - All globals starting with ABC<br>
///  A:D - All globals between A and D<br>
///  A:D,Y* - All globals between A and D, and all globals starting with Y<br>
///  A:D,'C* - All globals between A and D, except those starting with C
///  Return Values:<br>
///  Globals (byref) - Array of global nodes which contain wide characters.<br>
///  Note: The maximum number of nodes returned is 5,000 so <STORE> errors can be avoided.
ClassMethod CheckForWideCharacters(Directory As %String, Mask As %String = "*", ByRef GlobalNodes) As %Status
{
}

///  Prompt for changing explicit mounting attribute
ClassMethod ClusterMountModePrompt(Prompt, Obj) [ Internal ]
{
}

///  Compact all or selected globals in a database.<br>
///  When GloSel does not exist ($D(GloSel)=0) all globals in the database will be compacted.
///  Otherwise the array of GloSel contains the globals to be compacted.<br>
///  <br>
///  If a global that was selected for compaction is deleted before that global is processed,
///  the global is ignored as if it had not been specified. If detailed progress information is
///  being displayed (global names and compaction level), the global name will be displayed
///  on a blank line, without any compaction details.
Method Compact(PercentFull As %Integer = 90, ByRef MbProcessed As %Integer, ByRef MbCompressed As %Integer, Display As %Boolean, Device As %String, ByRef GloSel As %String) As %Status
{
}

///  Compact all globals in a database.
ClassMethod CompactDatabase(Directory As %String, PercentFull As %Integer = 90, ByRef MbProcessed As %Integer, ByRef MbCompressed As %Integer, Display As %Boolean, Device As %String) As %Status
{
}

///  Copy a database to another directory.<br>
///  This method will copy a source database to a newly created destination database, 
///  and optionally replace the source database with the destination database
///  after the copy completes. The main
///  use of this method is to change the blocksize of a database. The destination
///  database which is created will be created with its pages fully packed, all free
///  space removed, and blocks re-ordered. Globals which were created with old ISM collation
///  values of 0-4 will be created with collation 5 (Cache' Standard) when they are copied.
///  Globals which have old ISM collations of 128 and 129 will be created with a
///  collation of 133. <br><br>
///  Mirrored databases can be copied however the resulting copy will not be 
///  mirrored.<br><br>
///  NOTE: This method is only for use with a local database, it does not work across ECP or
///  on cluster mounted databases. If the database is a cluster mounted database, it must
///  be mounted privately before using this method on it.<br><br>
///  Parameters:<br>
///  SrcDir - Source database directory to copy. This must be a valid database which is
///  mounted on the system. During the copy operation, the Source database will be
///  set to read only.<br>
///  DstDir - New destination database directory to be created. This must be a valid 
///  directory specification
///  for the system. If the directory does not exist, it will be created. If DstDir is not
///  specified, then a directory named "cvt" will be created under the source directory. The
///  device where the destination directory specified must have enough free space on it 
///  to accommodate the copy. If the destination database already exists, the method will
///  return a failure.<br>
///  BlockSize - If the block size is specified, the newly created database will be created
///  with this size of database blocks. If the block size is not specified, the new database
///  will be created with the same block size of the source database. If the source database is
///  a 2KB database, the destination database will be created with the system default size.
///  The block size specified must be a valid database block size allowed by the system as specified
///  in the Config.Startup.AllowedBlockSizes property, and must have global buffers allocated for
///  that size or larger in the Config.config class.<br>
///  Msg (by ref) - Array of success and error messages returned by the method.<br>
///  Flags - Bit string specifying the following options (Default = 0):<br>
///  Bit 0 - Display progress messages.<br>
///  Bit 1 - Do not set the source directory to read only.<br>
///  Bit 2 - If the destination database already exists, do not generate an error.<br>
///  Bit 3 - Unused.<br>
///  Bit 4 - Replace the source database with the destination database after the copy completes.
///  If the source database is cluster mounted or mirrored, this option is not allowed.<br>
///  WARNING: If you are replacing the source database with the destination database, you MUST
///  make a backup of your source database before running this method.<br>
///  Bit 5 - Set switch 10 (freeze reads and write on the system) for the duration of the copy.
///  Setting this bit will allow the source database to be copied and replaced by the
///  destination database while avoiding having any processes trying to write to the database 
///  error with a protect error.<br>
///  Bit 6 - Write the global sets to the journal file. If the Source database is set to not be
///  journaled, then the sets will not be journaled even if this bit is set.<br>
///  Bit 7 - If the original database is encrypted, do not encrypt the copy.<br>
///  Bit 8 - Create the destination database and all the copied globals with the passed in collation.<br>
///  Collation - The destination database is created with this collation if bit 8 is set in the
///  Flags parameter. All globals which are copied here will be created with this collation. The
///  globals collation in the source database will be ignored. The ^COLLATE routine will give a list
///  of the available collations on the system. The collation must be loaded and active on the
///  system to use this parameter. Note that the system globals such as the routine and 
///  objects globals will contain to be set to collation 5 (Cache' standard.)
///  <br><br>
///  Examples:<br>
///  Make a copy of the prod database into the test directory.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\","c:\test\")<br><br>
///  Make a copy of the prod database into the prod\cvt directory with a block size of 16384.
///  Messages and errors are returned in the Msg array.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\",,16384,.Msg)<br><br>
///  Make a copy of the prod database into the prod\cvt directory with a block size of 16384.
///  After the database is copied, delete the prod database and replace it with 
///  the prod\cvt database. Success and error messages are displayed to the screen.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\",,16384,.Msg,1+16)<br><br>
///  Make a copy of the prod database into the prod\cvt directory with a block size of 16384.
///  Write all the global sets into the journal.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\","c:\test\,16384,.Msg,64)<br><br>
///  Combine 2 different databases into one test database.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\","c:\test\,,.Msg,4)<br>
///  s x=##Class(SYS.Database).Copy("c:\prod1\","c:\test\,,.Msg,4)<br><br>
///  Copy the source to the destination, change the blocksize to 32768, then replace 
///  the source with the destination. Processes on the system will be frozen while 
///  the copy runs. This is useful if you want to do this and not have any processes 
///  which write to the database error with a protect error.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\","c:\test\,32768,.Msg,16+32)<br><br>
///  Change the CACHESYS database to use an 8192 block size. Freeze the system while
///  the database is copied. This is useful to convert the CACHESYS database while
///  the system is up and running.<br>
///  s x=##Class(SYS.Database).Copy($zu(12),,8192,.Msg,16+32)<br><br>
///  Change the collation of all the globals to Danish.<br>
///  s x=##Class(SYS.Database).Copy("c:\prod\","c:\test\",8192,.Msg,256,15)<br><br>
ClassMethod Copy(SrcDir As %String, DstDir As %String = "", BlockSize As %Integer = 0, ByRef Msg As %String, Flags As %Integer = 0, Collation As %Integer = 5) As %Status
{
}

///  Compact all globals in a database, using a background job.
ClassMethod JobCompactDatabase(Directory As %String, PercentFull As %Integer = 90, ByRef LogFile As %String) As %Status
{
}

///  Background routine for compacting a database.
ClassMethod JobCompact(Directory As %String, PercentFull As %Integer = 90, LogFile As %String) As %Status
{
}

///  Check the state of a background database compaction.<br>
///  State = 0-(in progress), 1-(finished), 2-(no compaction logged)
ClassMethod DBCompactStatus(Directory As %String, ByRef State As %Integer, ByRef LogFile As %String) As %Status
{
}

///  Create a database. This assumes the Directory has been created. The Directory can be a relative or absolute path. The Size is in MB. Only the Directory is required.
ClassMethod CreateDatabase(Directory As %String, Size As %Integer = 1, BlockSize As %Integer = {$$$DefaultDatabaseBlockSize}, EncryptedDB As %Boolean = 0, Resource As %String = "%DB_%DEFAULT", GlobalJournalState As %Integer, MirrorDBName As %String = "", MirrorSetName As %String = "") As %Status
{
}

///  Create all the necessary system globals in a database.
ClassMethod CreateDefaultGlobals(Directory As %String) As %Status [ Internal ]
{
}

///  Set the default Cache' system globals in a database to have the correct 
///  Cache Standard collation.<br>
///  Bit 0 - If not set, only diagnose errors and do not modify the database
///  Bit 1 - Do not set switch 10 during the operation
///  Bit 2 - Do not print message array to principal device
ClassMethod FixDefaultGlobalCollation(Directory As %String, Flags As %Integer = 0, ByRef Messages As %String) As %Status
{
}

///  Create a global in a directory with the default unicode collation.<br>
ClassMethod CreateGlobal(Directory As %String, Name As %String) As %Status [ Internal ]
{
}

///  Delete a database.
Method Delete() As %Status
{
}

///  Delete a database.
ClassMethod DeleteDatabase(Directory As %String) As %Status
{
}

///  Overrides the directory set method
Method DirectorySet(Arg As %String) As %Status [ Internal ]
{
}

///  Dismount a database.
Method Dismount() As %Status
{
}

///  Dismount a database.
ClassMethod DismountDatabase(Directory As %String) As %Status
{
}

///  Prompt for changing encrypted database attribute
ClassMethod EncryptedDBPrompt(Prompt, Obj) [ Internal ]
{
}

ClassMethod ExpansionSizeIsValid(Value, BlockSize = 0) As %Status [ Internal ]
{
}

///  Prompt for expansion size.
ClassMethod ExpansionSizePrompt(Prompt, Obj) [ Internal ]
{
}

Method FindMapBlock(map, bigval) As %Integer [ Internal ]
{
}

///  Return number of MB of free space in a database.
ClassMethod GetDatabaseFreeSpace(Directory As %String, ByRef FreeSpace As %Integer) As %Status
{
}

///  Prompt for a directory.
ClassMethod GetDirectory(Prompt, Value, Obj, Min, Max, Help, Flag, Timeout) As %Integer
{
}

///  Calculate remaining free space in a database.
ClassMethod GetFreeSpace(Directory As %String, ByRef FreeSpace As %Integer, ByRef FreeBlocks As %Integer) As %Status
{
}

///  This runs an integrity check on all or selected databases.
///  For selected databases pass a list of directory names.
ClassMethod IntegrityCheck(Dirnames As %String) As %String
{
}

///  Load field info for editing.
ClassMethod LoadFields(Field, Obj, Old) [ Internal ]
{
}

ClassMethod MaxSizeIsValid(Value) As %Status [ Internal ]
{
}

///  prompt for max size.
ClassMethod MaxSizePrompt(Prompt, Obj) [ Internal ]
{
}

///  Modifies parameters of a database.
ClassMethod ModifyDatabase(Directory As %String, Size As %Integer, Resource As %String, GlobalJournalState As %Integer) As %Status
{
}

///  Mount a database
///  <br><br>
///  Uses Readonly, ClusterMountMode and Mirrored properties
///  <br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>readonly</parameter> defaults to 0 (not readonly). When True causes
///  the database which would normally be mounted read-write to be mounted read-only. 
///  Normally a database is only mounted read-only if is not writeable (due to protection 
///  or filesystem issues) or if the internal database read-only property is set. 
///  <li><parameter>cluster</parameter> defaults to 0 (private mount). This is ignored on
///  non-cluster members. On a cluster member setting this to 1 causes the database to be
///  mounted for clustered (shared) access. If the system is not a cluster member, 
///  this will cause the system to try to join the cluster.
///  <li><parameter>mirrorcatchup</parameter> defaults to 1 (start catchup). This parameter is ignored
///  if the system is not a mirror member or if the database being mounted is not a 
///  mirrored database. When set to 1 database catchup is started when a mirrored database
///  is successfully mounted. If the current system is an async member which has stopped
///  dejournaling, catchup will run up to the point that dejournaling was stopped (for example, the
///  database will be made "as current" as the other mirrored databases). Otherwise catchup
///  will apply as much journal data as possible and try to link the database into the
///  active dejournaling system. When set to 0 catchup is not started after the mount
///  and must be started manually later. When mounting several mirrored databases it is
///  best to not start catchup as part of the mount but rather start catchup for all the
///  databases using the ^MIRROR utility after they have all been mounted. This is much
///  more efficient as catchup will make a single pass through the journal files to cover
///  all the databases rather than running though the journal files for each database.
///  </ul>
///  <br>
Method Mount(readonly As %Boolean = 0, cluster As %Boolean = 0, mirrorcatchup As %Boolean = 1) As %Status
{
}

///  Mount a database.
ClassMethod MountDatabase(Directory As %String, readonly As %Boolean = 0, cluster As %Boolean = 0, mirrorcatchup As %Boolean = 1) As %Status
{
}

///  Rearranges global blocks within the database specified by <Parameter>Directory</Parameter> so that all of the data blocks for a given global 
///  are in consecutive sequence and packed to at least 70% full. The operation does not place big string blocks or pointer blocks from a global
///  in sequence, but it does locate them in a contiguous area.
///  <p>
///  Defragment requires enough free space at the end of the database file to temporarily store all data blocks.
///  If there is insufficient free space at the end, the database will expand as necessary. You may be able to create
///  additional free space at the end by first running <Method>FileCompact</Method>. Following the defragmentation
///  you can return unused space at the end of the database file with <Method>ReturnUnusedSpace</Method>.
///  <p>
///  This method is not available on VMS
ClassMethod Defragment(Directory As %String) As %Status
{
}

///  Moves free space distributed throughout the database file to its end. You can then return the free space 
///  to the file system using <Method>ReturnUnusedSpace</Method>.
///  <p>
///  FileCompact starts at the end of the database file, moving in-use blocks into free space at the beginning. It stops 
///  when there is no more free space available, or there is at least <Parameter>TargetFree</Parameter> MB of free space
///  at the end of the file. Specifying 0 for <Parameter>TargetFree</Parameter> reports the amount of free space located
///  at the end of the file without moving any blocks.
///  <p>
///  This method is not available on VMS
///  <p>
///  Input Parameters:
///  <li><parameter>Directory</parameter> - the database directory</li>
///  <li><parameter>TargetFree</parameter> - the desired amount of free space (in MB) at the end of the database.</li>
///  <p>
///  Output Parameters:
///  <li><parameter>ActualFree</parameter> - returns the total amount of free space (in MB) at the end of the database.</li>
ClassMethod FileCompact(Directory As %String, TargetFree As %Integer = 0, ByRef ActualFree As %Integer) As %Status
{
}

///  Free blocks at the end of the CACHE.DAT file are returned to the physical filesystem, and
///  the file is shortened.
///  <p> 
///  <parameter>TargetSize</parameter> is the desired size in MB of the resulting file.  Specify 0 to return all available freespace at the
///  end of the file.  On success, <parameter>ReturnSize</parameter> is set to the new file size in MB.
///  <p>
///  Fails and returns error status if a conflicting database operation is in progress in the same database. 
///  Conflicting operations include expansion, backup, defragmentation, compaction and ReturnUnusedSpace.
///  <p>
///  Note: Since freespace is not returned all at once when a global is killed, but rather done in the
///  background, there may be a delay following the kill before the space is available to be returned.
///  <p>
///  This method is not available on VMS
ClassMethod ReturnUnusedSpace(Directory As %String, TargetSize As %Integer = 0, ByRef ReturnSize As %Integer) As %Status
{
}

///  prompt for default collation.
ClassMethod NewGlobalCollationPrompt(Prompt, Obj) [ Internal ]
{
}

///  Prompt to preserver global attributes on deletion.
ClassMethod NewGlobalIsKeepPrompt(Prompt, Obj) [ Internal ]
{
}

Method GlobalJournalStateGet() As %JournalState [ CodeMode = expression ]
{
}

///  prompt for global journal state.
ClassMethod GlobalJournalStatePrompt(Prompt, Obj)
{
}

///  prompt for mirror database name
ClassMethod MirrorDBNamePrompt(Prompt, Obj) [ Internal ]
{
}

///  prompt for mirror set name
ClassMethod MirrorSetNamePrompt(Prompt, Obj) [ Internal ]
{
}

///  Prompt for new global's pointer block.
ClassMethod NewGlobalPointerBlockPrompt(Prompt, Obj) [ Internal ]
{
}

///  Prompt for new global's pointer block.
ClassMethod NewGlobalGrowthBlockPrompt(Prompt, Obj) [ Internal ]
{
}

///  Packages the errors from $zu(27)
ClassMethod PackZU27Error(rc As %String) As %Status [ Internal ]
{
}

///  Prompt for changing read only attribute
ClassMethod ReadOnlyPrompt(Prompt, Obj) [ Internal ]
{
}

///  prompt for database resource name
ClassMethod ResourceNamePrompt(Prompt, Obj) [ Internal ]
{
}

///  This class method starts a job that checks the integrity of globals in one or more databases.<br>
/// <br>
///  The parameters are:<br>
/// <br>
///   <li><parameter>Filename</parameter> - File to store results in</li>
///   <li><parameter>dirlist</parameter>  - Optional $list of directories that contain databases to check,
///             by default all databases are checked.</li>
///   <li><parameter>gbllist</parameter>  - Optional $list of globals to check,if specified then dirlist must contain a single database.</li>
///   <li><parameter>StopAfterAnyError</parameter> - set true to stop on error.</li>
ClassMethod SilentIntegrityCheck(Filename As %String, dirlist As %String, gbllist As %String = "", StopAfterAnyError As %Boolean = 0) As %Status
{
}

///  Prompt for database size.
ClassMethod SizePrompt(Prompt, Obj) [ Internal ]
{
}

///  This displays the contents of a file containing the output from a previous call to
///  ##class(SYS.Database).SilentIntegrityCheck(filename) on the current device
ClassMethod ViewIntegrityLog(Filename As %String) As %Status
{
}

///  Provides detail of all local databases (mounted or dismounted) in the systems SFN table.
///  <br><br>
///  Parameters:<br>
///  Mask="*" or $lb(directory1,directory2,...)<br>
///  Notes:<br>
///  Databases which are never mounted are not returned by this query. For example, if the databases in Config.Databases were not mounted at startup, they won't be returned in this query.<br>
///  The Status field is the mount status of the database, and how it is mounted, e.g. "Mounted/RW"<br>
Query Detail(Mask As %String, Unused As %Boolean) As %Query(ROWSPEC = "Directory:%String,MirrorDBName:%String,MaxSize:%Integer,Size:%Integer,Status:%String,BlockSize:%String,ClusterMountMode:%String,ClusterMounted:%String,ExpansionSize:%String,LastExpansionTime:%String,Mounted:%String,NewGlobalCollation:%String,NewGlobalGrowthBlock:%String,NewGlobalIsKeep:%String,GlobalJournalState:%String,NewGlobalPointerBlock:%String,ReadOnly:%String,ResourceName:%String,MountedReadOnly:%Integer,EncryptedDB:%String,EncryptionKeyID:%String")
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Mask As %String = "*", Unused As %Boolean = 0) As %Status [ Internal ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

///  Provides a freespace list of all local databases mounted in this configuration.
///  <br><br>
///  Note that calculating the free space may take a while.<br>
///  Parameters:<br>
///  Mask="*" or $lb(directory1,directory2,...)<br>
///  For the FreeSpace Report, You can also enter the following in order to select by database name:<br>
///  <var>"String,String1"</var> - Any name matching one of these elements<br>
///  <var>"String*"</var> - Any Name starting with "String"<br>
///  <var>"String,String1*,String2"</var> - Any Name matching one of these elements, or starting with "String1"<br>
///  Notes:
///  Databases which are not mounted are not returned by this query.<br>
Query FreeSpace(Mask As %String = "*", Unused As %Boolean) As %Query(ROWSPEC = "DatabaseName:%String,Directory:%String,MaxSize:%String,Size:%String,ExpansionSize:%String,Available:%String,Free:%Float:% Free,DiskFreeSpace:%String,Status:%String,SizeInt:%Integer,AvailableNum:%Integer,DiskFreeSpaceNum:%Integer,ReadOnly:%Boolean") [ SqlProc ]
{
}

ClassMethod FreeSpaceExecute(ByRef qHandle As %Binary, Mask As %String = "*", Unused As %Boolean = 0) As %Status [ Internal ]
{
}

ClassMethod FreeSpaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod FreeSpaceClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = FreeSpaceExecute ]
{
}

///  This runs an integrity check of all local databases mounted in this configuration.<br><br>
///  <br><br>
///  Note that calculating the integrity may take a while.<br>
///  Parameters:<br>
///  Mask="*" or $lb(directory1,directory2,...)<br>
///  Filename - Filename to write Integrity output to<br>
///  Notes:
///  Databases which are not mounted are not returned by this query.<br>
Query Integrity(Mask As %String, Filename As %String) As %Query(ROWSPEC = "Directory:%String,Status:%Boolean") [ SqlProc ]
{
}

ClassMethod IntegrityExecute(ByRef qHandle As %Binary, Mask As %String, Filename As %String) As %Status [ Internal ]
{
}

ClassMethod IntegrityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = IntegrityExecute ]
{
}

ClassMethod IntegrityClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = IntegrityExecute ]
{
}

///  Provides a list of all local databases (mounted or dismounted) in the systems SFN table.
///  <br><br>
///  Parameters:<br>
///  Mask="*" or $lb(directory1,directory2,...)<br>
///  Notes:<br>
///  The Status field is the mount status of the database, and how it is mounted, e.g. "Mounted/RW"<br>
///  Databases which are never mounted are not returned by this query. For example, if the databases in Config.Databases were not mounted at startup, they won't be returned in this query.<br>
Query List(Mask As %String, Unused As %Boolean) As %Query(ROWSPEC = "Directory:%String,MaxSize:%String,Size:%Integer,Status:%String,Resource:%String,Encrypted:%Boolean,StateInt:%String,Mirrored:%Boolean,SFN:%String") [ SqlProc ]
{
}

///  Common routine for database queries.
///  <br><br>
///  Parameters:<br>
///  Mask="*" or $lb(directory names)<br>
///  Flag - Internal use only<br>
///  Flag=0 - Return List columns <Default><br>
///  Flag=1 - Return FreeSpace columns (this may take a while to execute)<br>
///  Flag=2 - Return Detail columns<br>
///  Flag=3 - Return Integrity columns (this may take a while to execute)<br>
///  Flag=4 - Return Compact columns<br>
///  Filename - Used for Integrity Query only
ClassMethod ListExecute(ByRef qHandle As %Binary, Mask As %String = "*", Unused As %Boolean = 0, Flag As %Integer = 0, Filename As %String) As %Status [ Internal ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Parameter DEFAULTCONCURRENCY = 0;

///  Returns a list of all remote databases for the passed server mounted on this configuration.
///  <br><br>
Query RemoteDatabaseList(Serverxname As %String = {ServerxName}) As %Query(ROWSPEC = "RemoteDirectory:%String:Remote Directory,DBStatus:%String,DBName:%String") [ SqlProc ]
{
}

ClassMethod RemoteDatabaseListExecute(ByRef qHandle As %Binary, Server As %String = "") As %Status [ Internal ]
{
}

ClassMethod RemoteDatabaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = RemoteDatabaseListExecute ]
{
}

ClassMethod RemoteDatabaseListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = RemoteDatabaseListExecute ]
{
}

Query RemoteDatabaseListSMP(RemoteServer As %String, HowToLoad As %Integer = 1) As %Query(ROWSPEC = "Name:%String,Directory:%String") [ Internal ]
{
}

ClassMethod RemoteDatabaseListSMPExecute(ByRef qHandle As %Binary, RemoteServer As %String, HowToLoad As %Integer = 1) As %Status [ Internal ]
{
}

ClassMethod RemoteDatabaseListSMPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = RemoteDatabaseListSMPExecute ]
{
}

ClassMethod RemoteDatabaseListSMPClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = RemoteDatabaseListSMPExecute ]
{
}

///  Returns a list of globals on the passed server and directory.
///  <br><br>
Query RemoteGlobalList(Serverxname As %String = {ServerxName}, Serverxdir As %String = {Serverxdir}) As %Query(ROWSPEC = "Global:%String:Global")
{
}

ClassMethod RemoteGlobalListExecute(ByRef qHandle As %Binary, Server As %String = "", Dir As %String = "") As %Status [ Internal ]
{
}

ClassMethod RemoteGlobalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = RemoteDatabaseListExecute ]
{
}

ClassMethod RemoteGlobalListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = RemoteDatabaseListExecute ]
{
}

///  Used for formatting database and global sizes in MB, GB, or TB
ClassMethod FormatSizes(val As %Float, RoundDown As %Integer = 0) As %Float
{
}

///  This is a quick query for list of databases.<br><br>
///  Mask="*" or $lb(directory1,directory2,...)<br>
///  Returns SFN, directory, Read Only status, Resource Name, Block size and Collation.<br>
Query CompactLocalList(Mask As %String) As %Query(ROWSPEC = "Directory:%String,SFN:%Integer,ReadOnly:%Integer,Resource:%String,BlockSize:%Integer,Collation:%Integer") [ SqlProc ]
{
}

ClassMethod CompactLocalListExecute(ByRef qHandle As %Binary, Mask As %String = "*") As %Status [ Internal ]
{
}

ClassMethod CompactLocalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = CompactLocalListExecute ]
{
}

ClassMethod CompactLocalListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = CompactLocalListExecute ]
{
}

ClassMethod CanDatabaseBeMirrored(Directory As %String) As %Boolean [ Internal ]
{
}

///  Check whether the database directory path is configured as a system database (the DB name as CACHESYS, CACHELIB, CACHE, CACHETEMP, CACHEAUDIT).
ClassMethod IsSystemDB(Directory As %String) As %Boolean
{
}

///  This method will clear the MirrorFailoverDB flag in this mirrored DB.
ClassMethod ClearMirrorFailoverDB(Directory As %String) As %Status
{
}

///  This method takes the return string from $ZU(49) and populates the
///  various class parameters with the values. This method only processes
///  zu(49) parameters which come from the characteristics of the database, 
///  not its current state. For instance, the sfn is set to SFN_UNDEF, the
///  cluster mount mode is not processed, the mirror state is not considered.
///  This is because depending on who calls this method, we may or may not want
///  that information (yet) so we leave it to the caller to deal with.
Method ParseZU49Info(x As %String, setupMirrorFields As %Boolean) As %Status [ Internal ]
{
}

Storage DBStorage
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^SYS.DatabaseS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
