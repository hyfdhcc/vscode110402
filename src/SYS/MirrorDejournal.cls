Class SYS.MirrorDejournal Extends %Library.SystemBase [ Not Final ]
{

Parameter %MODULENAME [ Internal ] = 8;

/// For use in <METHOD>RunFilter</METHOD>.  True when dejournaling is occurring
/// as part of a manual database catchup operation; false when dejournaling is 
/// occurring automatically during normal mirror operation.<br>
Property InCatchupDB As %Boolean;

/// Function called after mirror connection is established to primary member by dejournal reader daemon.
Method DejournalReader(SharedID As %CPP.Integer, JournalPos As %CPP.Integer, FileName As %CPP.String, MirrorFileCount As %CPP.LongLong, Validate As %CPP.Integer) As %String [ Final, Internal, Language = cpp ]
{
}

/// Function called before mirror connection is established to primary member.
/// After journal file is retrieved from primary and is applied to mirrored databases.
Method DejournalProcessFile(SharedID As %CPP.Integer, StartPos As %CPP.Integer, FileName As %CPP.String, MirrorFileCount As %CPP.LongLong) As %String [ Final, Internal, Language = cpp ]
{
}

/// Function called by SYS.Mirror.CatchupDB() method, to restore mirror journal records to mirrored databases.
Method CatchupProcessFile(SharedID As %CPP.Integer, StartPos As %CPP.Integer, StopPos As %CPP.Integer) As %String [ Final, Internal, Language = cpp ]
{
}

/// When mirror dejournal filtering is enabled, this method is called for every
/// record that is about to be dejournaled.  To implement a dejournal filter, 
/// override this method and add the code that is to be executed when mirror
/// journal files are dejournaled.
/// <p>
/// Arguments as follows will be passed to this method providing information
/// about the record:<br>
/// <li>MirrorDBName - The mirrored database name of the journal record, in the
/// format of :mirror:MIRRORNAME:MIRRORDBNAME</li>
/// <li>GlobalReference - Global reference in the form of MyGlobal(subscripts), 
/// without the leading ^</li>
/// <li>RecordType - Type of journal record; values are "S" for SET, "s" for 
/// SET $BIT, "K" for KILL, and "k" for ZKILL</li>
/// <li>Address - Offset of the record in the journal file</li>
/// <p>
/// Return 1 to indicate that the record is to be dejournaled or 0 to request that
/// it be skipped.  Skipping the record in this way is only allowed if the 
/// FailoverDB flag in the database is cleared, meaning that it is a read-write
/// mirror database.  If the FailoverDB flag in the database is set, the return
/// value is ignored, and the record is dejournaled.  The RunFilter code executes
/// for each record regardless of the state of the FailoverDB flag; it can perform
/// any operations that do not modify the read-only mirrored databases.
/// <p>
/// Other information about the journal record can be extracted as needed by using
/// the value of Address in macros provided by the <b>%syJrnRecord</b> include
/// file.  In particular:
/// <li>$$$JRNPID(Address) - returns the process ID, or if it is a multi-threaded
/// callin process, returns the composite job ID.</li>
/// <li>$$$JRNTSTAMP(Address) - returns the timestamp of the journal record in
/// $HOROLOG format.</li>
/// <li>$$$JRNNEWVAL(Address) - returns the value of the SET record for RecordType
/// "S" only; throws an error on other record types.</li>
/// <p>
/// If errors are thrown from this method (ie an error occurs and is not 
/// handled within the method itself), mirror dejournaling will abort.
/// <p>
/// Dejournaling to mirrored databases occurs both as part of normal mirror
/// operation and as part of manual catchup.  The two types of dejournaling can
/// occur concurrently (in different processes) and manual catchup can be working
/// with substantially older journal records.  Implementations of RunFilter that 
/// need to be sensitive to this difference can inspect the value of
/// <PROPERTY>InCatchupDB</PROPERTY>.<br>
Method RunFilter(MirrorDBName As %String, GlobalReference As %String, RecordType As %String, Address As %Integer) As %Integer [ Language = cpp ]
{
}

}
