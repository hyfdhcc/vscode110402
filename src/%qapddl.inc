ROUTINE %qapddl [Type=INC]
	;  %qaqpddl.inc - include file for DDL parse tree mtd
#IF 0   ;
	;-------------------------------------------------------------
	; Description:   API for mtd(), the DDL parse tree objects
	; Author:        Aviel Klausner
	; Date:          February 14, 1996
	; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
	;
	;  DPV3361 (02/17/2009) - Enhancements for CALL support
	;  DPV3300 (10/22/2008) - Implement LOCK/UNLOCK TABLE statements
	;  DPV3263 (09/22/2008) - Support MySQL DDL Script file import
	;  DPV3083 (12/13/2007) - Remove FetchODBC methods
	;  DPV2672 (06/23/2006) - Add support for statement level triggers
	;  DPV2619 (04/12/2006) - Add support for Global Temporary Tables
	;  DPV2532 (10/11/2005) - Fix CALL with expressions passed as arguments
	;                         SQL Fix ProdLog 46406: Compiling SQL: <UNDEFINED>davalue+2^%qaqcpr
	;  DPV1824 (09/10/2002) - Fix checking of trigger schema name
	;  DPV1823 (09/06/2002) - Use Keyname as KeyId for key constraints
	;  DPV1626 (12/05/2001) - Add support for CREATE BITMAP INDEX through DDL
	;  DPV1591 (10/01/2001) - Change SetTriggerSchema to SetTriggerPackage
	;  DPV1560 (07/03/2001) - Support code > 32K for CREATE PROC/QUERY/METH/FUNC/TRIGGER
	;  DPV1509 (03/16/2001) - Implement CALL statement for embedded SQL
	;  DPV1504 (03/07/2001) - Implement CRAETE TRIGGER
	;  DPV1486 (01/19/2001) - Implement CREATE FUNCTION/METHOD/PROCEDURE/QUERY
	;  DPV1458 (11/28/2000) - New macros for renaming a constraint/key
	;  DPV1240 (01/20/2000) - Support Foriegn Key referential actions
	;  DPV1121 (08/13/1999) - Support IDENTITY Columns
	;  DPV1038 (04/14/1999) - Support UNIQUE indices
	;  DPV876  (10/09/98)   - Support CREATE/DROP User
	;  DPV863  (08/25/98)   - Add support for Constraints (NOT YET COMPLETE!)
	;  DPV796  (12/19/97)   - DDL Enhancements for OMNUS 7 client
	;  DPV785  (12/01/97)   - DDL Map extentions
	;  DPV731  (05/05/97)   - macro to delete field from field order
	;  AK280   (02/14/96)   - Routine created
	;
	;-------------------------------------------------------------
	;                     I N F O R M A T I O N
	;-------------------------------------------------------------
	;
	;  This include file, ^%qaqpddl.inc, defines the API for accessing
	;  the objects in the DDL parse tree, which in the current
	;  implementation is stored in the local array mtd().
	;  This file should be included with every routine that accesses
	;  the DDL parse tree, including parsing (^%qaqpddl), analysis, and
	;  code generation (^%aaaddl).
	;  The API was designed to allow future changes to the parse
	;  tree data structure as well as changes to the way its data is
	;  used in a program, without need to change the API itself.
	;  The API includes 3 objects - tables, fields within a table,
	;  and keys within a table.  Each object is identified by an
	;  object handle, which may be used as input to API calls.
	;  The object handles may not be interpreted or used otherwise,
	;  or assumed to contain any meaningful information!
	;  In addition, there is an object for the DDL statement itself.
	;  There are 2 types of API calls - expressions and commands.
	;  The expression calls may appear as atomic expressions
	;  (i.e. they can follow an operator).  The command calls are also
	;  atomic (SET's), without any control commands such as IF, so
	;  they may appear anywhere within a line.
	;-------------------------------------------------------------
#ENDIF  ;
	;  #INCLUDE %msql should precede this in the containing file!
	;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	;-----------------------------------------------------------
	;  mtd - DDL parse tree objects API - DDL, table, field, key
	;------ DDL Statement ------
	;  (only a single object)
	;  make a new DDL entry (break into 2 methods??)
#define DSET(%o,%t) s mtd("ddl","op")=%o,mtd("ddl","name")=%t
	;  DDL operation
#define Dop mtd("ddl","op")
	;  DDL table
#define Dtab mtd("ddl","name")
	;  DDL index
#define Dindex mtd("ddl","name")
	;------ Table ------
	;  In this implementation,  table-handle = alphaup(table-name)
	;  make a new entry for table named %n (%N=a-up) and return the
	;      table handle in %t
	;  *** who checks if not exist already? (incl. CREATE twice)
#define Tmake(%N,%n,%t) s %t=%N,mtd("table",%t,"name")=%n
	;  get table handle for given TNAME, add entry if not there!
#define Tgetid(%N,%t) s %t=%N s:'$D(mtd("table",%t)) mtd("table",%t,"name")=%t
	;  table handle of next table - start and end with NULL
#define nextab(%t) $O(mtd("table",%t))
	;  table name in a-up (in this implementation - the handle itself)
#define TNAME(%t) (%t)
	;  table actual name
#define tname(%t) mtd("table",%t,"name")
	;  set table operation = "create"/"alter"/"delete"
#define TSETop(%t,%x) s mtd("table",%t,"op")=%x $$$DSET(%x,%t)
	;  set table operation only
#define TSETopItself(%t,%x) s mtd("table",%t,"op")=%x
	;  set table operation into a list (Only used for ALTER)
#define TSETopItselfList(%t,%x) s mtd("table",%t,"op")=$s($g(mtd("table",%t,"op"))="alter":"",1:$g(mtd("table",%t,"op")))_$e(",",$g(mtd("table",%t,"op"))'=""&($g(mtd("table",%t,"op"))'="alter"))_%x
	;  table operation
#define Top(%t) $g(mtd("table",%t,"op"))
	;  set table description
#define TSETdesc(%t,%x) s mtd("table",%t,"desc")=%x
	;  table description (or NULL)
#define tdesc(%t) $g(mtd("table",%t,"desc"))
	;  set global name for table
#define TSETfile(%t,%x) s mtd("table",%t,"file")=%x
	;  global name to use for table (or NULL)
#define tfile(%t) $g(mtd("table",%t,"file"))
	;  set approximate number of row in table
#define TSETnumr(%t,%x) s mtd("table",%t,"numrows")=%x
	;  approximate number of row in table (or NULL)
#define tnumrows(%t) $g(mtd("table",%t,"numrows"))
	;  set routine name for table
#define TSETrtn(%t,%x) s mtd("table",%t,"routine")=%x
	;  routine name to use for table
#define troutine(%t) $g(mtd("table",%t,"routine"))
	;  set the flag that says the table's rowid field is public
#define TSETpublicrowid(%t,%x) s mtd("table",%t,"publicrowid")=%x
	;  is the table's rowid public?
#define tpublicrowid(%t) $g(mtd("table",%t,"publicrowid"))
	;  set table drop behavior
#define TSETbehave(%t,%x) s mtd("table",%t,"behave")=%x
	;  table drop behavior (or NULL)
#define tbehave(%t) $g(mtd("table",%t,"behave"))
	;  set table drop if exists
#define TSETifexists(%t,%x) s mtd("table",%t,"ifexists")=%x
	;  table drop behavior (or NULL)
#define tifexists(%t) $g(mtd("table",%t,"ifexists"))
	; set table delete data flag
#define TSETdeldata(%t,%x) s mtd("table",%t,"deldata")=%x
	; table delete data flag
#define tdeldata(%t) $g(mtd("table",%t,"deldata"))
	; Set table IDENTITY Column name
#define TSETIdentity(%t,%f) s mtd("table",%t,"identity")=%f
	; table's identity column
#define tIdentity(%t) $g(mtd("table",%t,"identity"))
	; Set table Temporary Type (g)lobal, (l)ocal, ""
#define TSETTempType(%t,%f) s mtd("table",%t,"temp")=%f
	; table's temporary type
#define tTempType(%t) $g(mtd("table",%t,"temp"))
	; Set table Lock Mode (s)hare, (e)xclusive
#define TSETLockMode(%t,%f) s mtd("table",%t,"lock")=%f
	; table's lock mode
#define tLockMode(%t) $g(mtd("table",%t,"lock"))
	; Set table Unlock Mode (i)mmediate
#define TSETUnlockMode(%t,%f) s mtd("table",%t,"unlock")=%f
	; table's unlock mode
#define tUnlockMode(%t) $g(mtd("table",%t,"unlock"))
	; Set table Lock Timeout
#define TSETLockTimeout(%t,%f) s mtd("table",%t,"lock timeout")=%f
	; table's lock timeout
#define tLockTimeout(%t) $g(mtd("table",%t,"lock timeout"))
	;------ Table - see more stuff after Key object! ------
	;------ Field (within table) ------
	;  In this implementation,  field-handle = alphaup(field-name)
	;  make a new entry within table %t for field named %n (%N=a-up)
	;      and return the field handle in %f
	;  *** who checks if not exist already? (incl. CREATE twice)
#define Fmake(%t,%N,%n,%f) s %f=%N,mtd("table",%t,"field",%f,"name")=%n,mtd("table",%t,"fieldord")=$g(mtd("table",%t,"fieldord"))+1,mtd("table",%t,"fieldord",mtd("table",%t,"fieldord"))=%f
	;  get fld handle for given FNAME in table %t, add entry if not there!
#define Fgetid(%t,%N,%f,%k) s %f=%N s:'$d(mtd("table",%t,"field",%f)) mtd("table",%t,"field",%f,"name")=%f,mtd("table",%t,"fieldord")=$g(mtd("table",%t,"fieldord"))+1,mtd("table",%t,"fieldord",mtd("table",%t,"fieldord"))=$s(%k:"%key%",1:"")_%f
	;  field handle of next field in the table
#define nextfld(%t,%i,%f) s %i=$o(mtd("table",%t,"fieldord",%i)),%f=$s(%i="":"",1:mtd("table",%t,"fieldord",%i))
#define KillFieldOrderNode(%t,%i) k mtd("table",%t,"fieldord",%i)
	;  field name in alpha-up (here it's the handle itself)
#define FNAME(%t,%f) (%f)
	;  field actual name
#define fname(%t,%f) mtd("table",%t,"field",%f,"name")
	;  set field datatype (in string form, e.g. "DEC(5,2)" or "CHAR")
#define FSETtype(%t,%f,%x) s mtd("table",%t,"field",%f,"datatype")=%x
	;  field data type, or NULL if field not declared yet/here
#define datatype(%t,%f) $g(mtd("table",%t,"field",%f,"datatype"))
	;  set field collation (%ALPHAUP/%UPPER/%EXACT)
#define FSETcoll(%t,%f,%x) s mtd("table",%t,"field",%f,"collate")=%x
	;  field collation function, or NULL
#define collate(%t,%f) $g(mtd("table",%t,"field",%f,"collate"))
	;  set flag to delete data of column with column is dropped
#define FSETdeldata(%t,%f,%x) s mtd("table",%t,"field",%f,"deldata")=%x
	;  delete data of column with column is dropped?
#define fdeldata(%t,%f) $g(mtd("table",%t,"field",%f,"deldata"))
	;  mark field as multi-line field
#define FSETmlf(%t,%f) s mtd("table",%t,"field",%f,"multiline")=""
	;  multi-line field?
#define multiline(%t,%f) $d(mtd("table",%t,"field",%f,"multiline"))
	;  set field default
#define FSETdef(%t,%f,%x) s mtd("table",%t,"field",%f,"default")=%x
	;  field default
#define default(%t,%f) $g(mtd("table",%t,"field",%f,"default"))
	;  set field description
#define FSETdesc(%t,%f,%x) s mtd("table",%t,"field",%f,"desc")=%x
	;  field description
#define fdesc(%t,%f) $g(mtd("table",%t,"field",%f,"desc"))
	;  mark field as required
#define FSETreq(%t,%f,%v) s mtd("table",%t,"field",%f,"required")=%v
	;  whether field is required
#define required(%t,%f) $g(mtd("table",%t,"field",%f,"required"))
	;  mark field as unique/primary ("U"/"P") (Note - SET is missing!)
#define FSETuniq(%t,%f,%x) mtd("table",%t,"field",%f,"unique")=%x
	;  whether field is unique or primary ("U"/"P"), NULL if none
#define funique(%t,%f) $g(mtd("table",%t,"field",%f,"unique"))
	;  mark field as Identity column
#define FSETIdentity(%t,%f) s $li(mtd("table",%t,"field",%f,"identity"))=%f
	;  whether field is identity column or not
#define fIdentity(%t,%f) $lg($g(mtd("table",%t,"field",%f,"identity")))
	;  Define Identity field seed
#define FSETIdentitySeed(%t,%f,%x) s $li(mtd("table",%t,"field",%f,"identity"),2)=%f
	;  Get seed for Identity field
#define fIdentitySeed(%t,%f) $lg($g(mtd("table",%t,"field",%f,"identity")),2)
	;  Define Identity field increment
#define FSETIdentityIncrement(%t,%f,%x) s $li(mtd("table",%t,"field",%f,"identity"),3)=%f
	;  Get increment for Identity field
#define fIdentityIncrement(%t,%f) $lg($g(mtd("table",%t,"field",%f,"identity")),3)
	;  ?? if field is designative reference, TNAME of referenced table
#define fdestab(%t,%f) $g(mtd("table",%t,"field",%f,"desigtab"))
	;  mark field as transient
#define FSETtransient(%t,%f,%v) s mtd("table",%t,"field",%f,"transient")=%v
	;  whether field is transient
#define transient(%t,%f) $g(mtd("table",%t,"field",%f,"transient"))
	;  mark field as calculated
#define FSETcalculated(%t,%f,%v) s mtd("table",%t,"field",%f,"calculated")=%v
	;  whether field is calculated
#define calculated(%t,%f) $g(mtd("table",%t,"field",%f,"calculated"))
	;  field's compute code
#define FSETcomputecode(%t,%f,%v) s mtd("table",%t,"field",%f,"computecode")=%v
	;  get field's compute code
#define computecode(%t,%f) $g(mtd("table",%t,"field",%f,"computecode"))
	;  field's compute on change fields
#define FSETcomputeonchange(%t,%f,%v) s mtd("table",%t,"field",%f,"computeonchange")=%v
	;  get field's compute on change fields
#define computeonchange(%t,%f) $g(mtd("table",%t,"field",%f,"computeonchange"))
	;------ Key (within table) ------
#IF 0	; DPV1823+
	;  In this implementation,
	;      key-handle = comma-list(field-handle) [ * n ]
	;  #fields in the key
#define ksize(%t,%k) $S(%k="":0,1:$L(%k,","))
	;  assign a new keyid %k for the given field list %f in table %t
#define Knewid(%t,%f,%k) s %k=%f s:$D(mtd("table",%t,"key",%k)) mtd("table",%t,"key",%k)=$g(mtd("table",%t,"key",%k))+1,%k=%k_"*"_mtd("table",%t,"key",%k)
	;  set key type %x (P/U/F/R) and constraint name %c
#define KSET(%t,%k,%x,%c) s mtd("table",%t,"key",%k,"type")=%x s:$$$ksize(%t,%k)=1&("PU"[%x) $$$FSETuniq(%t,$P(%k,"*"),%x) s:$g(%c)'="" mtd("table",%t,"key",%k,"name")=%c
	;  *** Note:  Kmake was broken down to 2 because it's too long
	;  make a new key entry within table %t for key with field
	;      list %f, and return the key handle in %k
	;  also set key type %x (P/U/F/R) and constraint name %c
	;  key handle is the field list, possibly appended with *n
#define Kmake(%t,%f,%x,%c,%k) $$$Knewid(%t,%f,%k) $$$KSET(%t,%k,%x,%c)
	;  key handle of next key
#define nextkey(%t,%k) $O(mtd("table",%t,"key",%k))
	;  list of field names in key in alpha-up
	;  (*** check usage consistency - is it field names or handles?)
	;  (in this implementation it's the prefix of the key handle)
#define KLIST(%t,%k) $P(%k,"*")
	;  full key name in alpha-up, e.g. "TAB2(FLD3,FLD5)"
#define tkname(%t,%k) ($$$TNAME(%t)_"("_$$$KLIST(%t,%k)_")")
	;  constraint name, if given
#define consname(%t,%k) $g(mtd("table",%t,"key",%k,"name"))
	;  Set constraint name
#define KSETconsname(%t,%k,%n) s mtd("table",%t,"key",%k,"name")=%n
	;  key type - "P", "U", "F", or "R" (referenced)
#define ktype(%t,%k) $E(mtd("table",%t,"key",%k,"type"))
	;  for foreign key, set the referenced table handle
#define KSETrtab(%t,%k,%x) s mtd("table",%t,"key",%k,"desigtab")=%x
	;  if foreign key, referenced table handle
#define kdestab(%t,%k) $g(mtd("table",%t,"key",%k,"desigtab"))
	;  for foreign key, set the referenced key handle
#define KSETrkey(%t,%k,%x) s mtd("table",%t,"key",%k,"foreignkey")=%x
	;  if foreign key, referenced key handle if given
#define kdeskey(%t,%k) $g(mtd("table",%t,"key",%k,"foreignkey"))
	;  if foreign key, list of referenced field names if given
#define forflist(%t,%k) $$$KLIST($$$kdestab(%t,%k),$$$kdeskey(%t,%k))
	;  for foreign key, set match type if given
#define KSETmatch(%t,%k,%x) s mtd("table",%t,"key",%k,"match")=%x
	;  if foreign key, match type
#define kmatch(%t,%k) $g(mtd("table",%t,"key",%k,"match"))
	;  for foreign key, set the triggered action for UPDATE/DELETE
#define KSETtrig(%t,%k,%op,%x) s mtd("table",%t,"key",%k,"trigact",%op)=%x
	;  if foreign key, referential triggered action
	;      (CASCADE/NULL/DEFAULT) for %op=UPDATE/DELETE, if given
#define ktrigact(%t,%k,%op) $g(mtd("table",%t,"key",%k,"trigact",%op))
	;------ Table - more definitions (uses Key methods)! ------
	;  set table primary key
#define TSETprim(%t,%k) s mtd("table",%t,"primary")=%k s:$$$ksize(%t,%k)=1 mtd("table",%t,"primfield")=$$$KLIST(%t,%k)
	;  key handle of table's primary key, if defined
#define primary(%t) $g(mtd("table",%t,"primary"))
	;  field handle of table's primary key, if it's a single field
#define primf(%t) $g(mtd("table",%t,"primfield"))
	;  set size of table's primary key (in referenced table)
#define TSETpsize(%t,%x) s mtd("table",%t,"primsize")=%x
	;  size of table's primary key (or NULL)
#define primsize(%t) $g(mtd("table",%t,"primsize"))
#ELSE	; DPV1823=
	;  In this implementation,
	;      key-handle = constraint name	//comma-list(field-handle) [ * n ]
	;  #fields in the key
#define ksize(%t,%k) $S(%k="":0,1:$L(%k,","))
	;  assign a new keyid %k for the given field list %f in table %t
	//#define Knewid(%t,%f,%k) s %k=%f s:$D(mtd("table",%t,"key",%k)) mtd("table",%t,"key",%k)=$g(mtd("table",%t,"key",%k))+1,%k=%k_"*"_mtd("table",%t,"key",%k)
	;  set key type %x (P/U/F/R) and constraint name %c
#define KSET(%t,%k,%x,%c,%f) s mtd("table",%t,"key",%c,"type")=%x s:$$$ksize(%t,%k)=1&&("PU"[%x) $$$FSETuniq(%t,%k,%x),mtd("table",%t,"key",%c,"name")=%c,mtd("table",%t,"key",%c,"flist")=%f
	;  *** Note:  Kmake was broken down to 2 because it's too long
	;  make a new key entry within table %t for key with field
	;      list %f, and return the key handle in %k
	;  also set key type %x (P/U/F/R) and key field list, possibly appended with *n
	;  key handle is the constraint name
#define Kmake(%t,%f,%x,%c,%k) s %k=%c $$$KSET(%t,%k,%x,%c,%f)
	;  key handle of next key
#define nextkey(%t,%k) $O(mtd("table",%t,"key",%k))
	;  list of field names in key in alpha-up
	;  (*** check usage consistency - is it field names or handles?)
	;  (in this implementation it's the prefix of the key handle)
#define KLIST(%t,%k) $g(mtd("table",%t,"key",%k,"flist"))
	;  constraint name, if given
#define consname(%t,%k) $g(mtd("table",%t,"key",%k,"name"))
	;  Set constraint name
#define KSETconsname(%t,%k,%n) s mtd("table",%t,"key",%k,"name")=%n
	;  key type - "P", "U", "F", or "R" (referenced)
#define ktype(%t,%k) $E(mtd("table",%t,"key",%k,"type"))
	;  for foreign key, set the referenced table handle
#define KSETrtab(%t,%k,%x) s mtd("table",%t,"key",%k,"desigtab")=%x
	;  if foreign key, referenced table handle
#define kdestab(%t,%k) $g(mtd("table",%t,"key",%k,"desigtab"))
	;  for foreign key, set the referenced key handle
#define KSETrkey(%t,%k,%x) s mtd("table",%t,"key",%k,"foreignkey")=%x
	;  if foreign key, referenced key handle if given
#define kdeskey(%t,%k) $g(mtd("table",%t,"key",%k,"foreignkey"))
	;  if foreign key, list of referenced field names if given
#define forflist(%t,%k) $$$KLIST($$$kdestab(%t,%k),$$$kdeskey(%t,%k))
	;  for foreign key, set match type if given
#define KSETmatch(%t,%k,%x) s mtd("table",%t,"key",%k,"match")=%x
	;  if foreign key, match type
#define kmatch(%t,%k) $g(mtd("table",%t,"key",%k,"match"))
	;  for foreign key, set the triggered action for UPDATE/DELETE
#define KSETtrig(%t,%k,%op,%x) s mtd("table",%t,"key",%k,"trigact",%op)=%x
	;  if foreign key, referential triggered action
	;      (CASCADE/NULL/DEFAULT) for %op=UPDATE/DELETE, if given
#define ktrigact(%t,%k,%op) $g(mtd("table",%t,"key",%k,"trigact",%op))
#ENDIF	; DPV1823-
	;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	; ------ Class Parameter definitions ------
	; make parameter handle
#define Pmake(%N,%n) s mtd("parameter",%N,"name")=%n
	; parameter name in a-up (in this implementation - the handle itself)
#define PNAME(%t) (%t)
	; set index's name
#define PSETname(%i,%x) s mtd("parameter",%i,"name")=%x
	; what is the parameter name?
#define pname(%i) $g(mtd("parameter",%i,"name"))
	; set the parameter's table name
#define PSETtable(%i,%x) s mtd("parameter",%i,"table")=%x
	; what is the parameter's table name?
#define ptable(%i) $g(mtd("parameter",%i,"table"))
	; set the parameter's default value
#define PSETdefault(%i,%x) s mtd("parameter",%i,"default")=%x
	; what is the parameter's default value?
#define pdefault(%i) $g(mtd("parameter",%i,"default"))
	;  parameter handle of next parameter
#define nextparameter(%i) $O(mtd("parameter",%i))
	;---------------------------------------------------------------------
	; ------ Index definitions ------
	; make index handle
#define Imake(%N,%n,%t) s %t=%N,mtd("index",%t,"name")=%n
	;  get index handle for given INAME, add entry if not there!
#define Igetid(%N,%t) s %t=%N s:'$d(mtd("index",%t)) mtd("index",%t,"name")=%t
	; set index operation "create index"/"drop index"
#define ISETop(%i,%x) s mtd("index",%i,"op")=%x $$$DSET(%x,%i)
	; table name in a-up (in this implementation - the handle itself)
#define INAME(%t) (%t)
	; what is the index operation?
#define iop(%i) $g(mtd("index",%i,"op"))
	; set index's name
#define ISETname(%i,%x) s mtd("index",%i,"name")=%x
	; what is the index name?
#define iname(%i) $g(mtd("index",%i,"name"))
	; set the index table's name
#define ISETtable(%i,%x) s mtd("index",%i,"table")=%x
	; what is the index table's name?
#define itable(%i) $g(mtd("index",%i,"table"))
	; set a field into the index definition
#define ISETfield(%i,%c,%F) s mtd("index",%i,"fields",%c)=%F
	; set a field into the index definition
#define ISETDataField(%i,%c,%F) s mtd("index",%i,"datafields",%c)=%F
	;  index handle of next index
#define nextindex(%i) $O(mtd("index",%i))
	; what is the next field index number?
#define NextIndexField(%i,%c) $o(mtd("index",%i,"fields",%c))
	; given a index handle and order number, what is the field name?
#define IndexField(%i,%c) mtd("index",%i,"fields",%c)
	; what is the next data field index number?
#define NextIndexDataField(%i,%c) $o(mtd("index",%i,"datafields",%c))
	; given a index handle and order number, what is the data field name?
#define IndexDataField(%i,%c) mtd("index",%i,"datafields",%c)
	; set index's unique flag
#define ISETunique(%i,%x) s mtd("index",%i,"unique")=%x
	; is the index unique?
#define iunique(%i) +$g(mtd("index",%i,"unique"))
	; set index's bitmap flag
#define ISETbitmap(%i,%x) s mtd("index",%i,"bitmap")=%x
	; is the index a bitmap index?
#define ibitmap(%i) +$g(mtd("index",%i,"bitmap"))
	; set index's bitslice flag
#define ISETbitslice(%i,%x) s mtd("index",%i,"bitslice")=%x
	; is the index a bitslice index?
#define ibitslice(%i) +$g(mtd("index",%i,"bitslice"))
	; set index's bitmapextent flag
#define ISETbitmapextent(%i,%x) s mtd("index",%i,"bitmapextent")=%x
	; is the index a bitmapextent index?
#define ibitmapextent(%i) +$g(mtd("index",%i,"bitmapextent"))
	;---------------------------------------------------------------------
	;   Map Definitions
	; Are Maps defined for this table?
#DEFINE TableHasMaps(%t) ''$d(mtd("table",%t,"map"))
	; Map handle of next map in the table
#DEFINE MapMake(%t,%N,%n,%m) s %m=%N,mtd("table",%t,"map",%m,"name")=%n
	; Get the next map for a table
#DEFINE nextmap(%t,%m) $o(mtd("table",%t,"map",%m))
	; what is the map's name?
#DEFINE mapname(%t,%m) $g(mtd("table",%t,"map",%m,"name"))
	; Set the map's File Specification
#DEFINE MSETfile(%t,%m,%f) s mtd("table",%t,"map",%m,"file")=%f
	; Get the map's File Specification
#DEFINE mapfile(%t,%m) $g(mtd("table",%t,"map",%m,"file"))
	; Set the map's Row Specification
#DEFINE MSETrow(%t,%m,%r) s mtd("table",%t,"map",%m,"row")=%r
	; Get the map's Row Specification
#DEFINE maprow(%t,%m) $g(mtd("table",%t,"map",%m,"row"))
	; Set the map's RowID Specification
#DEFINE MSETrowid(%t,%m,%r) s mtd("table",%t,"map",%m,"rowid")=%r
	; Get the map's RowID Specification
#DEFINE maprowid(%t,%m) $g(mtd("table",%t,"map",%m,"rowid"))
	; Set the map's Index Map Populate Type
#DEFINE MSETindextype(%t,%m,%v) s mtd("table",%t,"map",%m,"indextype")=%v
	; Get the map's Index Map Populate Type
#DEFINE mapindextype(%t,%m) $g(mtd("table",%t,"map",%m,"indextype"))
	; Define this map as the master map
#DEFINE MSETmaster(%t,%m) s mtd("table",%t,"map",%m,"master")=""
	; Is this the master map (1 or 0)
#DEFINE mapmaster(%t,%m) ''$d(mtd("table",%t,"map",%m,"master"))
	; Set the map's Structure type (%LIST or %DELIMTED)
#DEFINE MSETstructure(%t,%m,%v) s mtd("table",%t,"map",%m,"structure")=%v
	; Get the map's Index Map Populate Type
#DEFINE mapstructure(%t,%m) $g(mtd("table",%t,"map",%m,"structure"))
	; Define a new (next) access path specification
#DEFINE AllocateNewAccessPath(%t,%m,%o) s %o=$g(mtd("table",%t,"map",%m,"accesspath"))+1,mtd("table",%t,"map",%m,"accesspath")=%o
	; Get the next Access Path item
#DEFINE nextaccesspath(%t,%m,%o) $o(mtd("table",%t,"map",%m,"accesspath",%o))
	; Set the map access type for access path specification item %o
#DEFINE MSETaccesstype(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"accesspath",%o,"type")=%v
	; Get the map access type for access path specification item %o
#DEFINE mapaccesstype(%t,%m,%o) $g(mtd("table",%t,"map",%m,"accesspath",%o,"type"))
	; Set the map access type delimiter (For PIECE) for access path 
	; specification item %o
#DEFINE MSETaccesstypedel(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"accesspath",%o,"typedel")=%v
	; Get the map access type delimiter (For PIECE) for access path 
	; specification item %o
#DEFINE mapaccesstypedel(%t,%m,%o) $g(mtd("table",%t,"map",%m,"accesspath",%o,"typedel"))
	; Set the map access specification expression for the access path 
	; specification item %o
#DEFINE MSETaccessexpr(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"accesspath",%o,"expr")=%v
	; Get the map access specification expression for the access path 
	; specification item %o
#DEFINE mapaccessexpr(%t,%m,%o) $g(mtd("table",%t,"map",%m,"accesspath",%o,"expr"))
	; Set the map access specification range values for the access path 
	; specification item %o
#DEFINE MSETaccessrange(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"accesspath",%o,"range")=%v
	; Get the map access specification range values for the access path 
	; specification item %o
#DEFINE mapaccessrange(%t,%m,%o) $g(mtd("table",%t,"map",%m,"accesspath",%o,"range"))
	; Define a new (next) access path specification
#DEFINE AllocateNewMapDataField(%t,%m,%o) s %o=$g(mtd("table",%t,"map",%m,"mapdata"))+1,mtd("table",%t,"map",%m,"mapdata")=%o 
	; Get the next Map Data item
#DEFINE nextmapdata(%t,%m,%o) $o(mtd("table",%t,"map",%m,"mapdata",%o))
	; Set the map data node for map data item %o
#DEFINE MSETmapdatanode(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"mapdata",%o,"node")=%v
	; Get the map data node for map data item %o
#DEFINE mapdatanode(%t,%m,%o) $g(mtd("table",%t,"map",%m,"mapdata",%o,"node"))
	; Set the map data delimiter for map data item %o
#DEFINE MSETmapdatadel(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"mapdata",%o,"del")=%v
	; Get the map data delimiter for map data item %o
#DEFINE mapdatadel(%t,%m,%o) $g(mtd("table",%t,"map",%m,"mapdata",%o,"del"))
	; Set the map data piece for map data item %o
#DEFINE MSETmapdatapiece(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"mapdata",%o,"piece")=%v
	; Get the map data piece for map data item %o
#DEFINE mapdatapiece(%t,%m,%o) $g(mtd("table",%t,"map",%m,"mapdata",%o,"piece"))
	; Set the map data column for map data item %o
#DEFINE MSETmapdatacol(%t,%m,%o,%v) s mtd("table",%t,"map",%m,"mapdata",%o,"col")=%v
	; Get the map data column for map data item %o
#DEFINE mapdatacol(%t,%m,%o) $g(mtd("table",%t,"map",%m,"mapdata",%o,"col"))
	;---------------------------------------------------------------------
	;   Constraint Definitions
	; Get Constraint Counter
#DEFINE GetConstraintCount $i(mtd("constraint"))
	; make Constraint handle
#DEFINE Cmake(%c,%n) s $li(mtd("constraint",%c),1)=%n
	; what is the Constraint's Name
#DEFINE Cname(%c) $li(mtd("constraint",%c),1)
	; Rename a constraint
#DEFINE Crename(%o,%n) m mtd("constraint",%n)=mtd("constraint",%o) k mtd("constraint",%o)
	; set Constraint Type
#DEFINE CSETtype(%c,%x) s $li(mtd("constraint",%c),2)=%x
	; what is the Constraint Type?
#DEFINE Ctype(%c) $li(mtd("constraint",%c),2)
	; set Constraint Info (except for FKEYs)
#DEFINE CSETinfo(%c,%x) s $li(mtd("constraint",%c),3)=%x
	; set Constraint Info for FKEYs - Foreign Key Attribute(s)
#DEFINE CSETinfoFKEYFlds(%c,%x) s $li(mtd("constraint",%c),3)=%x
	; set Constraint Info for FKEYs - Referenced Table
#DEFINE CSETinfoFKEYRefTab(%c,%x) s $li(mtd("constraint",%c),4)=%x
	; set Constraint Info for FKEYs - Referenced Field(s)
#DEFINE CSETinfoFKEYRefFlds(%c,%x) s $li(mtd("constraint",%c),5)=%x
	; set Constraint Info for FKEYs - Referencial Action for UPDATE
#DEFINE CSETinfoFKEYRAUpdate(%c,%x) s $li(mtd("constraint",%c),6)=%x
	; set Constraint Info for FKEYs - Referencial Action for UPDATE
#DEFINE CSETinfoFKEYRADelete(%c,%x) s $li(mtd("constraint",%c),7)=%x
	; what is the Constraint's Info (except for FKEY's)?
#DEFINE Cinfo(%c) $li(mtd("constraint",%c),3)
	; get Constraint Info for FKEYs - Foreign Key Attribute(s)
#DEFINE CinfoFKEYFlds(%c) $lg(mtd("constraint",%c),3)
	; get Constraint Info for FKEYs - Referenced Table
#DEFINE CinfoFKEYRefTab(%c) $lg(mtd("constraint",%c),4)
	; get Constraint Info for FKEYs - Referenced Field(s)
#DEFINE CinfoFKEYRefFlds(%c) $lg(mtd("constraint",%c),5)
	; get Constraint Info for FKEYs - Referencial Action for UPDATE
#DEFINE CinfoFKEYRAUpdate(%c) $lg(mtd("constraint",%c),6)
	; get Constraint Info for FKEYs - Referencial Action for UPDATE
#DEFINE CinfoFKEYRADelete(%c) $lg(mtd("constraint",%c),7)
	;  table handle of next table - start and end with NULL
#DEFINE nextcon(%c) $o(mtd("constraint",%c))
	;
	; ------ User definitions ------
	;
	; make User handle
#define MakeUser(%N,%n,%t) s %t=%N,mtd("user",%t,"name")=%n
	; set User operation "create user"/"drop user"
#define SetUserOperation(%u,%x) s mtd("user",%u,"op")=%x $$$DSET(%x,%u)
	; what is User's operation
#define UserOperation(%u) $g(mtd("user",%u,"op"))
	; set User's name
#define SetUserName(%u,%x) s mtd("user",%u,"name")=%x
	; what is the User name?
#define UserName(%u) $g(mtd("user",%u,"name"))
	; set User's password
#define SetUserPassword(%u,%x) s mtd("user",%u,"password")=%x
	; what is the User Password?
#define UserPassword(%u) $g(mtd("user",%u,"password"))
	; Set DROP USER, CASCADE
#define SetUserDropCascade(%u,%c) s mtd("user",%u,"drop cascade")=%c
	; For DROP USER, CASCADE?
#define UserDropCascade(%u) $g(mtd("user",%u,"drop cascade"))
	;
	; ------ Function/Method/Procedure/Query definitions ------
	;
	; make Proc handle
#define MakeProc(%P,%p,%t) s %t=%P,mtd("proc",%t,"name")=%p
	; get Proc name
#define ProcName(%p) $g(mtd("proc",%p,"name"))
	; set Proc type "create method" or "create query"
#define SetProcType(%p,%x) s mtd("proc",%p,"type")=%x $$$DSET(%x,%p)
	; what is Proc's type
#define ProcType(%p) $g(mtd("proc",%p,"type"))
	; set Proc parameter list
#define SetProcParams(%p,%x) s mtd("proc",%p,"params")=%x
	; what is Proc's parameter list
#define ProcParams(%p) $g(mtd("proc",%p,"params"))
	; set Proc return datatype
#define SetProcReturnType(%p,%x) s mtd("proc",%p,"returntype")=%x
	; what is Proc's Return Type
#define ProcReturnType(%p) $g(mtd("proc",%p,"returntype"))
	; set ReturnsResultSets flag
#define SetProcReturnResultSets(%p,%x) s mtd("proc",%p,"returnresultsets")=%x
	; what is Proc's ReturnResultSets flag
#define ProcReturnResultSets(%p) $g(mtd("proc",%p,"returnresultsets"))
	; set Proc ContainId
#define SetProcContainId(%p,%x) s mtd("proc",%p,"containid")=%x
	; what is Proc's ContainId
#define ProcContainId(%p) $g(mtd("proc",%p,"containid"))
	; set Proc SelectMode
#define SetProcSelectMode(%p,%x) s mtd("proc",%p,"selectmode")=%x
	; what is Proc's SelectMode
#define ProcSelectMode(%p) $g(mtd("proc",%p,"selectmode"))
	; set Proc ClassName
#define SetProcClassName(%p,%x) s mtd("proc",%p,"classname")=%x
	; what is Proc's ClassName
#define ProcClassName(%p) $g(mtd("proc",%p,"classname"))
	; set Proc Procedure flag
#define SetProcProcedure(%p,%x) s mtd("proc",%p,"procedure")=%x
	; what is Proc's Procedure flag
#define ProcProcedure(%p) $g(mtd("proc",%p,"procedure"))
	; set Proc RowSpec
#define SetProcRowSpec(%p,%x) s mtd("proc",%p,"rowspec")=%x
	; what is Proc's RowSpec
#define ProcRowSpec(%p) $g(mtd("proc",%p,"rowspec"))
	; set Proc Method Code
#define SetProcMethodCode(%p,%x) f i=1:1:%x { s mtd("proc",%p,"methodcode",i)=%x(i) k %x(i) }
	; what is Proc's Method Code
#define ProcMethodCode(%p,%line) $g(mtd("proc",%p,"methodcode",%line))
	; Set Proc's Method Code line count
#define SetProcMethodCodeLineCount(%p,%x) s mtd("proc",%p,"methodcode")=%x
	; what is Proc's Method Code line count
#define ProcMethodCodeLineCount(%p) $g(mtd("proc",%p,"methodcode"))
	; set Proc GETINFO Parameter declaration
#define SetProcGetInfoParams(%p,%x) s mtd("proc",%p,"getinfoparams")=%x
	; what is Proc's GETINFO Parameter declaration
#define ProcGetInfoParams(%p) $g(mtd("proc",%p,"getinfoparams"))
	; set Proc EXECUTE Parameter declaration
#define SetProcExecuteParams(%p,%x) s mtd("proc",%p,"executeparams")=%x
	; what is Proc's EXECUTE Parameter declaration
#define ProcExecuteParams(%p) $g(mtd("proc",%p,"executeparams"))
	; set Proc FETCH Parameter declaration
#define SetProcFetchParams(%p,%x) s mtd("proc",%p,"fetchparams")=%x
	; what is Proc's FETCH Parameter declaration
#define ProcFetchParams(%p) $g(mtd("proc",%p,"fetchparams"))
	; set Proc FETCHROWS Parameter declaration
#define SetProcFetchRowsParams(%p,%x) s mtd("proc",%p,"fetchrowsparams")=%x
	; what is Proc's FETCHROWS Parameter declaration
#define ProcFetchRowsParams(%p) $g(mtd("proc",%p,"fetchrowsparams"))
	; set Proc CLOSE Parameter declaration
#define SetProcCloseParams(%p,%x) s mtd("proc",%p,"closeparams")=%x
	; what is Proc's CLOSE Parameter declaration
#define ProcCloseParams(%p) $g(mtd("proc",%p,"closeparams"))
	
	; set Proc GETINFO Code
#define SetProcGetInfoCode(%p,%x) f i=1:1:%x { s mtd("proc",%p,"getinfocode",i)=%x(i) k %x(i) }
	; what is Proc's GETINFO Code
#define ProcGetInfoCode(%p,%line) $g(mtd("proc",%p,"getinfocode",%line))
	; Set Proc's GETINFO Code line count
#define SetProcGetInfoCodeLineCount(%p,%x) s mtd("proc",%p,"getinfocode")=%x
	; what is Proc's GETINFO Code line count
#define ProcGetInfoCodeLineCount(%p) $g(mtd("proc",%p,"getinfocode"))
	
	; set Proc EXECUTE Code
#define SetProcExecuteCode(%p,%x) f i=1:1:%x { s mtd("proc",%p,"executecode",i)=%x(i) k %x(i) }
	; what is Proc's EXECUTE Code
#define ProcExecuteCode(%p,%line) $g(mtd("proc",%p,"executecode",%line))
	; Set Proc's EXECUTE Code line count
#define SetProcExecuteCodeLineCount(%p,%x) s mtd("proc",%p,"executecode")=%x
	; what is Proc's EXECUTE Code line count
#define ProcExecuteCodeLineCount(%p) $g(mtd("proc",%p,"executecode"))
	
	; set Proc FETCH Code
#define SetProcFetchCode(%p,%x) f i=1:1:%x { s mtd("proc",%p,"fetchcode",i)=%x(i) k %x(i) }
	; what is Proc's FETCH Code
#define ProcFetchCode(%p,%line) $g(mtd("proc",%p,"fetchcode",%line))
	; Set Proc's FETCH Code line count
#define SetProcFetchCodeLineCount(%p,%x) s mtd("proc",%p,"fetchcode")=%x
	; what is Proc's FETCH Code line count
#define ProcFetchCodeLineCount(%p) $g(mtd("proc",%p,"fetchcode"))
	
	; set Proc FETCHROWS Code
#define SetProcFetchRowsCode(%p,%x) f i=1:1:%x { s mtd("proc",%p,"fetchrowscode",i)=%x(i) k %x(i) }
	; what is Proc's FETCHROWS Code
#define ProcFetchRowsCode(%p,%line) $g(mtd("proc",%p,"fetchrowscode",%line))
	; Set Proc's FETCHROWS Code line count
#define SetProcFetchRowsCodeLineCount(%p,%x) s mtd("proc",%p,"fetchrowscode")=%x
	; what is Proc's FETCHROWS Code line count
#define ProcFetchRowsCodeLineCount(%p) $g(mtd("proc",%p,"fetchrowscode"))
	
	; set Proc CLOSE Code
#define SetProcCloseCode(%p,%x) f i=1:1:%x { s mtd("proc",%p,"closecode",i)=%x(i) k %x(i) }
	; what is Proc's CLOSE Code
#define ProcCloseCode(%p,%line) $g(mtd("proc",%p,"closecode",%line))
	; Set Proc's CLOSE Code line count
#define SetProcCloseCodeLineCount(%p,%x) s mtd("proc",%p,"closecode")=%x
	; what is Proc's CLOSE Code line count
#define ProcCloseCodeLineCount(%p) $g(mtd("proc",%p,"closecode"))
	
	; set Proc Final flag
#define SetProcFinal(%p,%x) s mtd("proc",%p,"final")=%x
	; what is Proc's Final flag
#define ProcFinal(%p) $g(mtd("proc",%p,"final"))
	; set Proc Private flag
#define SetProcPrivate(%p,%x) s mtd("proc",%p,"private")=%x
	; what is Proc's Private flag
#define ProcPrivate(%p) $g(mtd("proc",%p,"private"))
	; set Proc Query Type
#define SetProcQueryType(%p,%x) s mtd("proc",%p,"querytype")=%x
	; what is Proc's Query Type flag
#define ProcQueryType(%p) $g(mtd("proc",%p,"querytype"))
	;
	; ------ Trigger definitions ------
	;
	; make Trigger handle
#define MakeTrigger(%N,%n,%t) s %t=%N,mtd("trigger",%t,"name")=%n
	; set trigger operation "create trigger"/"drop trigger"
#define SetTriggerop(%t,%x) s mtd("trigger",%t,"op")=%x $$$DSET(%x,%t)
	; what is the trigger operation?
#define Triggerop(%t) $g(mtd("trigger",%t,"op"))
	; set Trigger's name
#define SetTriggerName(%t,%x) s mtd("trigger",%t,"name")=%x
	; get Trigger name
#define TriggerName(%t) $g(mtd("trigger",%t,"name"))
	; set Trigger's Schema specified in trigger name
#define SetTriggerTrigSchema(%t,%x) s mtd("trigger",%t,"trigschema")=%x
	; get Trigger schema specified in trigger name
#define TriggerTrigSchema(%t) $g(mtd("trigger",%t,"trigschema"))
	; set Trigger's Schema specified in table name
#define SetTriggerTabSchema(%t,%x) s mtd("trigger",%t,"tabschema")=%x
	; get Trigger schema specified in table name
#define TriggerTabSchema(%t) $g(mtd("trigger",%t,"tabschema"))
	; set Trigger's time (before/after)
#define SetTriggerTime(%t,%x) s mtd("trigger",%t,"time")=%x
	; get Trigger time
#define TriggerTime(%t) $g(mtd("trigger",%t,"time"))
	; set Trigger's event (INSERT/UPDATE/DELETE)
#define SetTriggerEvent(%t,%x) s mtd("trigger",%t,"event")=%x
	; get Trigger event
#define TriggerEvent(%t) $g(mtd("trigger",%t,"event"))
	; set Trigger's update field list
#define SetTriggerUpdateFields(%t,%x) s mtd("trigger",%t,"updatefields")=%x
	; get Trigger update field list
#define TriggerUpdateFields(%t) $g(mtd("trigger",%t,"updatefields"))
	; set Trigger's level (ROW or STATEMENT)
#define SetTriggerLevel(%t,%x) s mtd("trigger",%t,"level")=%x
	; get Trigger level
#define TriggerLevel(%t) $g(mtd("trigger",%t,"level"))
	; set Trigger's order
#define SetTriggerOrder(%t,%x) s mtd("trigger",%t,"order")=%x
	; get Trigger order
#define TriggerOrder(%t) $g(mtd("trigger",%t,"order"))
	; set Trigger's table
#define SetTriggerTable(%t,%x) s mtd("trigger",%t,"table")=%x
	; get Trigger table
#define TriggerTable(%t) $g(mtd("trigger",%t,"table"))
	; set Trigger's Old Correlation Name
#define SetTriggerOldName(%t,%x) s mtd("trigger",%t,"oldname")=%x
	; get Trigger Old Correlation Name
#define TriggerOldName(%t) $g(mtd("trigger",%t,"oldname"))
	; set Trigger's New Correlation Name
#define SetTriggerNewName(%t,%x) s mtd("trigger",%t,"newname")=%x
	; get Trigger New Correlation Name
#define TriggerNewName(%t) $g(mtd("trigger",%t,"newname"))
	; set Trigger's Language
#define SetTriggerLanguage(%t,%x) s mtd("trigger",%t,"language")=%x
	; get Trigger Language
#define TriggerLanguage(%t) $g(mtd("trigger",%t,"language"))
	; set Trigger Code
#define SetTriggerCode(%t,%x) f i=1:1:%x { s mtd("trigger",%t,"code",i)=%x(i) k %x(i) }
	; get Trigger code
#define TriggerCode(%t,%line) $g(mtd("trigger",%t,"code",%line))
	; Set Trigger Code line count
#define SetTriggerCodeLineCount(%t,%x) s mtd("trigger",%t,"code")=%x
	; get Trigger Code line count
#define TriggerCodeLineCount(%t) $g(mtd("trigger",%t,"code"))
	;
	; ------ CALL definitions ------
	;
	; make CALL handle
#define MakeCall(%N,%n,%t) s %t=%N,mtd("call",%t)=%n
	; set Call operation
#define SetCallop(%t,%x) s mtd("call",%t,"op")=%x $$$DSET(%x,%t)
	; what is the call operation?
#define Callop(%t) $g(mtd("call",%t,"op"))
	; set Call's context object - optional
#define SetCallContextObject(%t,%x) s mtd("call",%t,"cobj")=%x
	; what is Call's context object - optional
#define CallContextObject(%t) $g(mtd("call",%t,"cobj"))
	; set Call operation
#define SetCalllvars(%t,%x) s mtd("call",%t,"lvars")=%x
	; what are the Call lvars?
#define Calllvars(%t) $g(mtd("call",%t,"lvars"))
	; set Call's code
#define SetCallCode(%t,%x) s mtd("call",%t,"code",$i(mtd("call",%t,"code")))=%x
	; get Call's code line count
#define CallCodeLineCount(%t) $g(mtd("call",%t,"code"))
	; get Call's code
#define CallCode(%t,%line) $g(mtd("call",%t,"code",%line))
	; set Call's class
#define SetCallClass(%t,%x) s mtd("call",%t,"class")=%x
	; what is Call's class
#define CallClass(%t) $g(mtd("call",%t,"class"))
	; set Call's method
#define SetCallMethod(%t,%x) s mtd("call",%t,"method")=%x
	; what is Call's method
#define CallMethod(%t) $g(mtd("call",%t,"method"))

	; ------ DATABASE definitions ------
	;
	; make DATABASE handle
#define MakeDatabase(%N,%n,%t) s %t=%N,mtd("db",%t)=%n
	; get Database name
#define DatabaseName(%t) $g(mtd("db",%t))
	; set Database operation
#define SetDatabaseOperation(%t,%x) s mtd("db",%t,"op")=%x $$$DSET(%x,%t)
	; what is the database operation?
#define DatabaseOperation(%t) $g(mtd("db",%t,"op"))
	; set Database's directory
#define SetDatabaseDirectory(%t,%x) s mtd("db",%t,"directory")=%x
	; what is Databases's directory
#define DatabaseDirectory(%t) $g(mtd("db",%t,"directory"))
	; set Database's Encrupted flag
#define SetEncryptedDB(%t,%x) s mtd("db",%t,"encrypted")=%x
	; what is the Database's encrypted flag?
#define EncryptedDB(%t) $g(mtd("db",%t,"encrypted"))
	; set Database's global journal state
#define SetGlobalJournalState(%t,%x) s mtd("db",%t,"global journal state")=%x
	; get Database's global journal state
#define GlobalJournalState(%t) $g(mtd("db",%t,"global journal state"))
	; set flag to determine if we retain the database's files upon drop
#define SetRetainFiles(%t,%x) s mtd("db",%t,"retain")=%x
	; what is flag to determine if we retain the database's files upon drop?
#define RetainFiles(%t) $g(mtd("db",%t,"retain"))
	