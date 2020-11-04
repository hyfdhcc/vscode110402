ROUTINE mvfioflags [Type=INC]
#ifndef	MVFIOFLAGSINC
#define	MVFIOFLAGSINC
#;
#; THIS FILE MUST BE KEPT IN SYNC WITH kernel/common/h/mvfioflags.h
#; -----------------------------------------------------------------------------------
#; define the types so that they can be changed
#;
#define	MVFIOTypeRemote	-4
#;
#; Initial value for an uninitialized file object
#define MVFIOTypeUndef  99
#; Left for CREATE or WRITESEQ
#define	MVFIOTypeSeqNotOpen -3
#;
#define MVFIOTypeSeq	-2
#define MVFIOTypeDir	-1
#define	MVFIOTypeInode	0
#define	MVFIOTypeAnode	1
#define	MVFIOTypeCnode	2
#define MVFIOTypeIndex 32768
#;
#define	MVFIOSelTypeArray 0
#define MVFIOSelTypeFile 1
#define	MVFIOSelTypeIndex 2
#;
#; Index type flags, we have:
#; Index on a single value field
#; Index on a multivalue field (ELEMENT only)
#; Index on a multivalue field with the MV position (ELEMENT,KEY)
#;
#; These are ORd for the file type and kept in a seperate
#; slot once resolved into an index type select variable.
#;
#define	MVFIOSelIndSingle	1
#define	MVFIOSelIndMV		2
#define	MVFIOSelIndMVKey	4
#;
#; Error return codes
#;
#; The base error message number for MVFIO errors. MVFIO errors
#; start at this base and increment from here.
#;
#define	MVFIOEBase		5000
#;
#; Record lock was attempted but the record was already locked and we were told
#; not to wait.
#;
#define	MVFIOELocked		5000
#;
#; Could not create the directories involved in a directory file.
#; 
#define	MVFIOEDir		5001
#;
#; Could not find the specified file
#; 
#define	MVFIOENoFile		5002
#;
#; Invalid #MVFIOORef passed to function. The #MVFIOORef passed to the function
#; was not a valid MV file handle, or the ORef was missing.
#; 
#define	MVFIOEBadORef		5003
#;
#; Bad file record. There was something wrong with the VOC record describing
#; the file
#; 
#define	MVFIOEBadVocItem	5004
#;
#; MVFIOReadNext() reached the end of the supplied SelectDesc pointer.
#; 
#define	MVFIOESelectFin		5005
#;
#; UPDATE was specified to MVFIOWrite() but the item already exists
#define	MVFIOEWriteExists	5009
#;
#;  - MVFIOReadRecord() did not locate the specified item
#; 
#define	MVFIOEItemNoExist	5010
#;
#; MVFIOCreate() found that the DICT section of the file already exists
#define	MVFIOEDictExists	5011
#;
#; MVFIOCreate() found that the specified DATA section of the file already
#; exists
#define	MVFIOEDataExists	5012
#;
#; Unable to locate the S.ACCOUNT global or more likely, an entry in it   
#define	MVFIOENoAccount		5013
#;
#; Unable to create new object reference  
#define	MVFIOEORefCreate	5014
#;
#; Requested Attribute/value/sub-value etc does not exist 
#define	MVFIOENoElement		5015
#;
#; Format error in a Q pointer
#define	MVFIOEQFormat		5016
#;
#; A specified global for a file section does not exist or is corrupt  
#define	MVFIOEBadGlobal		5017
#;
#; A global organization type was defined that is not yet supported
#define	MVFIOEUnsupported	5018
#;
#; A select list type is unknown to us. This evil is not wanted here!
#define	MVFIOEBadSelList	5019
#;
#; INSERT was specified to MVFIO_Write() but the item did not exist.
#define	MVFIOEEWriteNoExist	5020
#;
#; A specified global has no organisation indicator in the default subscript
#define	MVFIOEBadGType		5021
#;
#; MATREAD or MATWRITE related functions were not supplied with a valid array
#define	MVFIOENotArray		5022
#;
#; Q pointer dereference has found an endless loop 
#define	MVFIOEQpointerLoop	5023
#;
#; Item did not exist and is locked 
#define	MVFIOELockedNoExist	5024
#;
#; Protect error, permissions not allowed for global
#define MVFIOProtect		5030
#;
#; MVIOCTL operation codes
#;
#define MVIOCTLBinaryOn 	1
#define MVIOCTLBinaryOff 	2
#;
#;
#; -----------------------------------------------------------------------------------
#; Flag definitions for controlling the functions.
#;
#;
#; Open flags...
#;
#; Tell MVFIOopen() to open the DICT of the file regardless of the file spec.
#; There is no harm in setting this flag even if the file space already
#; contains "DICT file" as we parse out the DICT part anyway, so you do not end
#; up with DICT DICT which is invalid.
#; 
#define	MVFIOOpenDict		1
#;
#; Tell the MVOPEN C code where we originated the call. If from COS then we
#; throw errors and stuff, if from MVBASIC, we trap errors and set the ON ERROR
#; flags, the runtime code will then take the appropriate branches or abort if
#; no ON ERROR clause.
#;
#define	MVFIOOpenMVBASIC	2
#;
#; OPEN should accept file names in D3 format
#;
#define	MVFIOOpenD3		4
#;
#; OPEN should not use triggers
#;
#define	MVFIOOpenNOTRIG		8
#;
#;
#; Locking flags
#;
#;
#; Do not wait for a LOCK if it is already held by someone else and we are
#; trying to lock it. Instead return immediately with #MVFIOELocked
#; 
#define	MVFIOLockNoWait		4
#;
#; Wait for a record lock if attempting to lock and the lock is already held
#; by someone else. This is for documentation purposes as this is the default.
#; 
#define	MVFIOLockWait		0
#;
#; Indicate that we do not wish to take a lock, but we wish to respect
#; a lock if there is one already there. This is stupid behavior inherited
#; from UniVerse, but we will probably need it.
#; 
#define	MVFIORespectLock	8
#;
#; Take a lock on an entire file.
#define	MVFIOLockFile		16
#;
#; Indicate that a write or read of a specific attribute is requested. In
#; practice the entire record is read (read and written) and the data is
#; extracted or inserted into the record. Repeated READV access to the same
#; record may be more efficient if the caller caches the record, for instance
#; as per the $MVGET() function for SQL access.
#; 
#define	MVFIOAttrRW		32
#;
#; Indicate that we wish to take a shared lock onthe item, before doing
#; the signified operation (READ, READV, or MATREAD)
#; 
#define	MVFIOSharedLock		64
#;
#; Indicate that we wish to LOCK the item for update, before doing
#; the signified operation (READ, OPEN,etc(
#; 
#define	MVFIOTakeLock		128
#;
#; Indicator (for runtime) that a failed read should NULL the target record
#define	MVFIOReadENull		256
#;
#; Indicate that a MVFIOWrite() should act as an INSERT and fail if the record
#; exists.
#define	MVFIOWriteInsert	4096
#;
#; Indicate that a MVFIOWrite() should act as an UPDATE and fail if the record
#; does NOT exist already
#define	MVFIOWriteUpdate	8192
#;
#; Wait for a record lock for the specified number of seconds before failing
#; and returning with #MVFIO_ELOCKED
#;
#define	MVFIOLockTime		65536
#;
#; Indicator for trigger routine that it has to push both the record and a
#; flag for the conditional SET
#;
#define	MVFIOCondSet		131072
#;
#endif
 