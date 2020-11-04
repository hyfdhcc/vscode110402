ROUTINE %qadctabinc [Type=INC]
	;  %qadctabinc.INC  ;  table/map/node objects (Aviel June/19/97) 7.61
#IF 0   ;
	;-------------------------------------------------------------
	; Description:   Table Filer code compiler
	; Author:        Aviel Klausner
	; Date:          June 19, 1997
	; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
	;
	;  DPV3385 (04/01/2009) - Support NOCHECK for FKeys
	;  DPV3373 (03/17/2009) - DSTIME support in SQL Filer
	;  DPV3212 (06/30/2008) - Implement support for %Counter fields
	;  DPV3131 (03/25/2008) - DD Lookup and Table compiler performance improvements
	;  DPV3116 (02/28/2008) - Support UPDATE & DELETE of Abstract class -> Polymorphic Dispatch
	;  DPV3066 (11/02/2007) - MV: Correct index filing when MVATTRIBUTE not specified
	;  DPV3054 (10/18/2007) - Support Computed Always fields in view query's condition for updatable view.
	;  DPV2975 (07/18/2007) - Support %INSERT/%UPDATE keywords in SqlComputeOnChange
	;  DPV2853 (02/21/2007) - Performance improvements in SQL Filer
	;  DPV2795 (11/20/2006) - Make INSERT of IDENTITY obey $zu(115,11) flag
	;  DPV2792 (11/16/2006) - Support Polymorphic Dispatch
	;  DPV2697 (07/12/2006) - Use $e(...,*) and $e(...,...,*) in SQL code
	;  DPV2672 (06/23/2006) - Add support for statement level triggers
	;  DPV2619 (04/12/2006) - Add support for Global Temporary Tables
	;  DPV2602 (03/01/2006) - Fix FKey referential actions when FKey references same table and same row
	;                         SQL Fix ProdLog 46842: foreign key constraint error when no one referencing table row
	;  DPV2583 (02/01/2006) - Implement MVIndex tables
	;  DPV2536 (10/13/2005) - Support VERSIONLOCATION in SQL Filer
	;  DLP1522 (09/13/2005) - Fix bug when the ROWID name changes in a subclass
	;  DPV2441 (06/06/2005) - SQL Enhancement: Increment %Version field in SQL UPDATE
	;  DPV2420 (04/26/2005) - SQL Enhancement:  Implement %AcquireTableLock/%ReleaseTableLock entry points in SQL filer routines
	;  DPV2393 (03/21/2005) - Move FKey constraint locking and check code into another function if more than 10 Fkeys
	;                         SQL Fix ProdLog 41955: table compilation fails with ERROR #5746: Unable to split the code block, pcode is larger than 32k
	;  DPV2351 (01/28/2005) - Support BitSlice indices in SQL Filer
	;  DPV2326 (11/29/2004) - Implement Build/Purge Indices for %CacheSQLStorage
	;  DPV2266 (08/18/2004) - Fix embedded stream fields
	;                         SQL Fix ProdLog 38375: Cannot delete row with stream in serial field
	;  DPV2242 (06/24/2004) - Make streams work with new stream classes
	;  DPV2124 (11/14/2003) - Add support for ReadOnly fields
	;  DPV2105 (10/29/2003) - Use originating extent when checking a uniqueness constraint
	;  DPV2025 (06/24/2003) - Retain long term lock on old unique constraint value in UPD/DEL
	;  DPV1990 (05/22/2003) - Eliminate ^mdd from table compiler
	;  DPV1964 (03/14/2003) - Eliminate Tcachestorage and Tdefstr
	;  DPV1929 (02/11/2003) - Add Extent name to table node
	;  DPV1924 (01/30/2003) - Add checks to make sure string fields don't contain map piece delimiter characters
	;  DPV1918 (01/22/2003) - Support use of Map Variables in Data Access and Full Row Reference expressions
	;  DPV1849 (10/11/2002) - Add FReference
	;  DPV1844 (10/09/2002) - Fix required checks on serial fields
	;  DPV1751 (06/19/2002) - Implement new Quick* Primary Key functions
	;  DPV1633 (12/13/2001) - Implement Quick* functions
	;  DPV1590 (10/01/2001) - Support more than 999 for length in EndSnList.
	;  DPV1530 (05/22/2001) - Use Immediate unlocks for unique constraint unlocks
	;  DPV1493 (02/09/2001) - Add setting for tables using %CacheStorage
	;  DPV1480 (01/10/2001) - Fix systemassigned constraint setting for %rowid constraint
	;  DPV1441 (11/13/2000) - Support user defined NULL Subscript Markers
	;  DPV1379 (08/29/2000) - Define TRowIDAllocPosition
	;  DPV1361 (08/10/2000) - Fix unique check which uses direct global reference of piece map
	;  DPV1342 (07/17/2000) - Support system generated unique constraints
	;  DPV1334 (07/11/2000) - Support large number of constraints
	;  DPV1310 (05/30/2000) - Schema support
	;  DPV1268 (03/01/2000) - Add Tuniqconcnt
	;  DPV1262 (02/16/2000) - Avoid <STORE> errors in tables with many FKeys
	;  DPV1259 (02/07/2000) - Fix concurrency hole in unique constraint checking.
	;  DPV1247 (01/17/2000) - Change where table's include files are stored
	;  DPV1238 (01/10/2000) - Support SQL names for constraints
	;  DPV1217 (12/13/1999) - Support larger tables
	;  DPV1166 (10/19/1999) - Make unique checks on maps with invalidconditions use a query
	;  DPV1164 (10/15/1999) - Use global structure instead of oar array
	;  DPV1138 (09/07/1999) - Added Munique and Mindexflds for unique constraint checking
	;  DPV1082 (06/07/1999) - Add classname to oar structure
	;  DPV1054 (04/26/1999) - Support streams
	;  DPV1008 (03/18/1999) - Fields call normalize function
	;  DPV998  (03/09/99)   - Parent/Child referential integrity
	;  DPV979  (02/18/99)   - Read only tables.
	;  DPV922  (12/02/98)   - Fix multiple fields mapped to single node
	;  DPV863  (09/10/98)   - Add Constraint support
	;  DPV861  (08/21/98)   - Support LogicalToStorage transformations
	;  AK29X   (06/19/97)   - New filer code - routine created
	;
	;-------------------------------------------------------------
	;                     I N F O R M A T I O N
	;-------------------------------------------------------------
	;
	;  Object definitions for table, field, map and node
	;  For now, objects are stored in oar(), with properties in
	;  lower lever subscripts.  (This may be changed to $LIST)
	;
	;-------------------------------------------------------------
#ENDIF  ;
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;  set an value to the maximum of itself and a new item
#define SetMax(%v,%i) s:$s(%v="":1,1:%v<(%i)) %v=%i
	#;  set an value to the minimum of itself and a new item
#define SetMin(%v,%i) s:$s(%v="":1,1:%v>(%i)) %v=%i
	#;  adds an item to a comma-delimited list
#define AddList(%l,%i) s %l=%l_$e(",",%l'="")_(%i)
	#;  adds an item to a comma-delimited list, if not already there
#define AddUList(%l,%i) s:","_%l_","'[(","_(%i)_",") %l=%l_$e(",",%l'="")_(%i)
	#;  adds an item to a $LIST
#define AddZList(%l,%i) s %l=%l_$lb(%i)
	#;  length of a $LIST
#define LenZList(%l) $ll(%l)
	#;  get an item from a $LIST
#define ItemZList(%l,%p) $li(%l,%p)
	#;  adds an item to a comma-delimited list of items %x, sorted by
	#;      a unique key %i which is a (small) positive integer, but ...
#define AddSnList(%l,%x,%i) s $p(%l,"^",%i)=","_(%x)
	#;  ... this type of list requires post-processing -
	#;      remove all "^" and remove first "," !
#define EndSnList(%l) s %l=$e($tr(%l,"^"),2,*)
	#;  add a field to an SnList sorted by icol
#define AddfldSnList(%l,%f) $$$AddSnList(%l,%f,($$$Ficol(%f)+1))
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;              BASETABLE properties
	#;------------------------------------------------------------
	#;  Table properties are stored in a list format defined as:
	#;
	#;     list element  description
	#;     ------------  -----------------------------------------
	#;           1       Textent       - table's extent
	#;           2       Tbasetabname  - table name
	#;           3       Tmaxcol       - maximum column number ???
	#;           5       Tbased        - UList of all rowid component fields, 
	#;                                   or "".  merging the lists of logical 
	#;                                   and physical based-on fields.
	#;                                   Note:  It MIGHT BE ordered naturally 
	#;                                   as follows:
	#;                                   [<some-logical>...][<parent-ref><physical>...]
	#;                                   [<more-logical>...]
	#;           6       Tgetoldcond   - "if <cond> "  if getold is conditional
	#;                                   (based on the list of field col#, whose 
	#;                                   existance requires running the getold query),
	#;                                   or NULL (for now, only NULL!)
	#;           7       Tgetoldflist  - a "fldSnList" of fields retrieved by getold
	#;                                   NULL means there is no getold query
	#;           8       Tttrigflist   - a "UList" of all triggered fields in the table
	#;           9       Tcompflist    - a "UList" of computed fields "needed-for-INSERT"
	#;          10       Tucomp        - 0/1 if tag ucomp needed for computed fields in UPDATE
	#;          11       Trowid        - Table's RowID
	#;          12       Tparentref    - parent-reference field, or NULL
	#;          13       Tmap0         - master map
	#;          14       Tonenode      - 0/1 if the master map has (at most) one data node
	#;          15       Tfieldvalcode - 0/1, 1 if any field in the table has validation or
	#;                                   additional val code.  used to optimize generated code
	#;          16       Tlog2storcode - 0/1, 1 if any field in the table has LogicalToStorage
	#;                                   code.  used to optimize generated code
	#;          17       Tstor2logcode - 0/1, 1 if any field in the table has StorageToLogical
	#;                                   code.  need to know for getold
	#;          18       TgetoldIsQuery- 0/1, 1 if the getold function uses an SQL query, else 0
	#;          19       TStorageFields- Zlist of all fields which have LogicalToStorage code
	#;          20       TReadOnly     - 0/1, 1 if the table is defined to be read-only
	#;          21       Tparentextent - extent name of parent table or ""
	#;          22       Thaschildren  - 0/1, 1 if the table has children otherwise 0
	#;          23       Tnormalizecode - 0/1, 1 if any field in the table has Normalize() call to make
	#;          24       TDeleteChildQueries - List of DELETE Queries to delete child rows
	#;          25       THasStreams   - 0/1 if table has any fields which use the stream interface or not
	#;          26       Tclassname    - Table's classname
	#;          27       Tbigtable     - TRUE if table has more than 200 fields
	#;          28       Tincludes     - $List format of include files to include in this table
	#;          29       Tfkeycnt      - Number of Fkeys in this table
	#;          30       Tuniqconcnt   - Number of unique constraints which need locking
	#;          31       Tschema       - Table's schema name
	#;          32       TRowIDAllocPosition - tells us where to alocate the RowID value for INSERT
	#;          33       Texprflist    - Texprflist = a "UList" of all fields (except Frowid) in field computed code
	#;          35       Tcollectiontype - For child tables projected via collections, "A"rray, "L"ist, or NULL
	#;          36       TPKeyIsIDKey  - 1 if PKEY is also the IDKEY, otherwise 0
	#;          37       TPKeyCon      - con# of the Primary Key constraint (if there is one)
	#;          38       THasStorageChecks - 1/0 flag.  Do any of the fields require storage validation for delimiters? (DPV1924)
	#;          39       TParentSchema  - Schema name of the Parent table
	#;	    40       TParentHasPKey - 0/1 flag if the table's parent table has a Primary Key constraint
	#;          41       TParentName    - Table Name of the parent table
	#;          42       TReadOnlyFieldList - $List of ReadOnly fields in this table
	#;          43       TCacheStorage  - 1/0 - Does the table use %CacheStorage?
	#;          44       TTableLockReference - lock reference for locking the entre table
	#;          45       TTableVersionField - %Version field if version chcking is on (DPV2441)
	#;          46       TTableVersionLocation - %Version field counter storage location (DPV2536)
	#;          47       TTableType     - Type of table "" or "Base" is basetable, "MVENABLED" for MVENABLED tables (DPV2536,DPV2671)
	#;          48       TTempTableType - Type of temporary table is "" for non-temp table or "GLOBAL TEMPORARY" for GLOBAL TEMPORARY table
	#;	    49	     TStatementTriggerInserted - 0/1: 0 if table needs a inserted transition table for Statement Level triggers
	#;	    50	     TStatementTriggerDeleted - 0/1: 0 if table needs a deleted transition table for Statement Level triggers
	#;	    51	     TStatementTriggerUpdated - 0/1: 0 if table needs a deleted and inserted transition tables for Statement Level triggers
	#;          52       TPolymorphicField - "" or fld number of the x__classname field used to check for polymorphic dispatch.
	#;          53       TRootExtent - 0/1 1 if this table is the root extent, 0 if a subextent
	#;          54       TcompViewflist - a "UList" of computed always fields "needed-for-INSERT into a view"
	#;          55       TAbstract - 0/1 1 if this table is abstract, 0 if it is not
	#;	    56	     TTableCounterFields - $List() structure of any %Counter fields (DPV3212)
	#;	    57       TDSTime - 0/1 1 if DSTIME should be generated for this table
	#;          58       TRoot - If $$$TRootExtent, this is the name of the root extent
	#;	    59       TDSTimeInterval - the number of seconds before the DSTIME value is incremented
	#;	    60	     TUseSysLockEscalation - 1/0 flag.  1 f this table uses system lock escalation
	#;          61       Tgetoldindexflist  - a "fldSnList" of fields retrieved by getoldindex
	#;          62       THasValidateIndex  - 1/0 flag, does this table have any indexes to be Validated
	#;          63       TRowVersionField - fld# of any field that is of type %Library.RowVersion (no more than one per table)
	#;	    64       TMasterMapHasIDJ - 1/0 flag to indicate if there are any iDj map variables in the master map
	#;	    65       TIndexMapHasIDJ - 1/0 flag to indicate if there are any iDj map variables in any index maps
	#;                                   NULL means there is no getold query
	#;          --       Ticomp        - 0/1 if tag icomp needed for computed fields in INSERT
	#;------------------------------------------------------------
#define Textent(%t) $li(%sqltab,1)
#define Tbasetabname(%t) $li(%sqltab,2)
#define Tmaxcol(%t) $li(%sqltab,3)
#define Tbased(%t) $li(%sqltab,5)
#define Tgetoldcond(%t) $li(%sqltab,6)
#define Tgetoldflist(%t) $li(%sqltab,7)
#define Tttrigflist(%t) $li(%sqltab,8)
#define Tcompflist(%t) $li(%sqltab,9)
#define Ticomp(%t) ($$$Tcompflist(%t)'="")
#define Tucomp(%t) $li(%sqltab,10)
#define Trowid(%t) $li(%sqltab,11)
#define Tparentref(%t) $li(%sqltab,12)
#define Tmap0(%t) $li(%sqltab,13)
#define Tonenode(%t) $li(%sqltab,14)
#define Tfieldvalcode(%t) $li(%sqltab,15)
#define Tlog2storcode(%t) $li(%sqltab,16)
#define Tstor2logcode(%t) $li(%sqltab,17)
#define TGetoldIsQuery(%t) $li(%sqltab,18)
#define TStorageFields(%t) $li(%sqltab,19)
#define Treadonly(%t) $li(%sqltab,20)
#define Tparentextent(%t) $li(%sqltab,21)
#define Thaschildren(%t) $li(%sqltab,22)
#define Tnormalizecode(%t) $li(%sqltab,23)
#define TDeleteChildQueries(%t) $li(%sqltab,24)
#define THasStreams(%t) $li(%sqltab,25)
#define Tclassname(%t) $li(%sqltab,26)
#define Tbigtable(%t) $li(%sqltab,27)
#define Tincludes(%t) $li(%sqltab,28)
#define Tfkeycnt(%t) $li(%sqltab,29)
#define Tuniqconcnt(%t) $li(%sqltab,30)
#define Tschema(%t) $li(%sqltab,31)
#define TRowIDAllocPosition(%t) $li(%sqltab,32)
#define Texprflist(%t) $li(%sqltab,33)
#define Tcollectiontype(%t) $li(%sqltab,35)
#define TPKeyIsIDKey(%t) $li(%sqltab,36)
#define TPKeyCon(%t) $li(%sqltab,37)
#define THasStorageChecks(%t) $li(%sqltab,38)
#define TParentSchema(%t) $li(%sqltab,39)
#define TParentHasPKey(%t) $li(%sqltab,40)
#define TParentName(%t) $li(%sqltab,41)
#define TReadOnlyFieldList(%t) $li(%sqltab,42)
#define TCacheStorage(%t) $li(%sqltab,43)
#define TTableLockReference(%t) $li(%sqltab,44)
#define TTableVersionField(%t) $li(%sqltab,45)
#define TTableVersionLocation(%t) $li(%sqltab,46)
#define TTableType(%t) $li(%sqltab,47)
#define TTempTableType(%t) $li(%sqltab,48)
#define TStatementTriggerInserted(%t) $li(%sqltab,49)
#define TStatementTriggerDeleted(%t) $li(%sqltab,50)
#define TStatementTriggerUpdated(%t) $li(%sqltab,51)
#define TPolymorphicField(%t) $li(%sqltab,52)
#define TRootExtent(%t) $li(%sqltab,53)
#define TcompViewflist(%t) $li(%sqltab,54)
#define TAbstract(%t) $li(%sqltab,55)
#define TTableCounterFields(%t) $li(%sqltab,56)
#define TDSTime(%t) $li(%sqltab,57)
#define TRoot(%t) $li(%sqltab,58)
#define TDSTimeInterval(%t) $li(%sqltab,59)
#define TUseSysLockEscalation(%t) $li(%sqltab,60)
#define Tgetoldindexflist(%t) $li(%sqltab,61)
#define THasValidateIndex(%t) $li(%sqltab,62)
#define TRowVersionField(%t) $li(%sqltab,63)
#define TMasterMapHasIDJ(%t) $li(%sqltab,64)
#define TIndexMapHasIDJ(%t) $li(%sqltab,65)
#define TStatementTriggerInsertedCall(%t) %sqltable(%t,"Tins")
#define TStatementTriggerDeletedCall(%t) %sqltable(%t,"Tdel")
#define Tinsconcode(%t,%i) %sqltable(%t,"insconcode",%i)
#define Tinsconcodecnt(%t) %sqltable(%t,"insconcode")
#define Tupdconcode(%t,%i) %sqltable(%t,"updconcode",%i)
#define Tupdconcodecnt(%t) %sqltable(%t,"updconcode")
	#;------------------------------------------------------------
	#;              Tflds - collection of fields within a table
	#;  table.flds(fld)="" - list of fields
	#;  table.fldsef(Extent/Field)=fld - list by Extent/Field of all fields, incl. from ancestors
#define TfldsAdd(%t,%f,%ef) s %sqltable(%t,"flds",%f)="",%sqltable(%t,"fldsef",%ef)=%f
#define TfldsNext(%t,%f) $o(%sqltable(%t,"flds",%f))
#define TfldsNextef(%t,%ef) $o(%sqltable(%t,"fldsef",%ef))
#define TfldsGetef(%t,%ef) $g(%sqltable(%t,"fldsef",%ef))
	#;------------------------------------------------------------
	#;              Tmaps - collection of maps within a table
	#;  table.maps(map) - list of maps
#define TmapsAdd(%t,%m) s %sqltable(%t,"maps",%m)=""
#define TmapsNext(%t,%m) $o(%sqltable(%t,"maps",%m))
	#;------------------------------------------------------------
	#;              Ttrigs - collection of Triggers for a table
	#;  table.trigs(trig) - list of Triggers
#define TtrigAdd(%t,%time,%o,%event) s %sqltable(%t,"trig",%time,%o)=%event s:%event["DELETE" %sqltable(%t,"trig",$$$LOWER($e(%time))_"d")=1 s:%event["INSERT" %sqltable(%t,"trig",$$$LOWER($e(%time))_"i")=1 s:%event["UPDATE" %sqltable(%t,"trig",$$$LOWER($e(%time))_"u")=1
#define TtrigNext(%t,%time,%o,%event) $o(%sqltable(%t,"trig",%time,%o),1,%event)
#define TtrigExist(%t,%time) $d(%sqltable(%t,"trig",%time))
#define TtrigExistBD(%t,%time) $d(%sqltable(%t,"trig","bd"))
#define TtrigExistBI(%t,%time) $d(%sqltable(%t,"trig","bi"))
#define TtrigExistBU(%t,%time) $d(%sqltable(%t,"trig","bu"))
#define TtrigExistAD(%t,%time) $d(%sqltable(%t,"trig","ad"))
#define TtrigExistAI(%t,%time) $d(%sqltable(%t,"trig","ai"))
#define TtrigExistAU(%t,%time) $d(%sqltable(%t,"trig","au"))
#IF 1   ; DPV863+
	#;------------------------------------------------------------
	#;              Tconstraints - collection of Constraints for a table
	#;  table.cnstraints(constraint) - list of Constraints
#define TconsAdd(%t,%c) s %sqltable(%t,"cons",%c)=""
#define TconsNext(%t,%c) $o(%sqltable(%t,"cons",%c))
#ENDIF  ; DPV863-
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;              FIELD properties
	#;------------------------------------------------------------
	#;  Field properties are stored in a list format defined as:
	#;
	#;     list element  description
	#;     ------------  -----------------------------------------
	#;          2        table handle
	#;          3        icol - column#, but only for fields from this
	#;                   table (to the exclusion of physical based-on 
	#;                   fields from ancestor tables)
	#;          4        field name
	#;          5        newvar - variable (expression) for field value, 
	#;                   %d(icol)/subs(fld)
	#;          6        newgvar - same with $g(), if necessary (for INSERT)
	#;          7        oldvar - variable (expression) for old field value, 
	#;                   %e(icol)/subs(fld)
	#;          8        oldgvar - variable (expression) for old field value, 
	#;                   $g(%e(icol))/$g(subs(fld))
	#;          9        datatype - ADT
	#;         10        params - parameters, in list format
	#;         11        changing - expression for whether field is changing in
	#;                   UPDATE, $a(%e,icol), may be used only if Frowid=0,
	#;                   $a(%e) used for an updatable parent-ref field
	#;         12        default - Field's default expression, or NULL
	#;         13        defonly - 0/1/2, 1=must use default,
	#;                   2=it's the rowid, and one of its components is defonly
	#;                   (for now, it's on iff it's rowid/childsub of default structure!
	#;                   - Unless DDL will support PRIMARY KEY/IDENTITY differently)
	#;         14        valid = Field validation Mcode lines sub-$list
	#;         15        advalid = same for field's additional validation code
	#;         16        required - 1/0
	#;         17        unique - 2/1/0   0 -> not unique
	#;                                    1 -> unique
	#;                                    2 -> unique, uses query to determine uniqueness
	#;         18        collex - Field's collation expression in fld3 format, such
	#;                   as "$$ALPHAUP(fld3)", or simply $c(3)_fld_$c(3) for "Exact"
	#;         19        mlf - 0/1/2/3/4/5 if list field, and storage type - 1:$p/2:nodes/3:$list/4:$list collection serialized form of child table/5:array collection serialized form of child table
	#;         20        mlfdel - List Field delimiter
	#;         21        rowid - 0/1/2/3 if 1:rowid/2:logical-based/3:physical-based only
	#;         22        pfrom - for types 2/3, start piece within rowid
	#;         23        pto - for types 2/3, end piece within rowid
	#;         24        pce3del - piece_$c(3)_del used in master map MapData, or NULL
	#;                   (used only if Tonenode, i.e. master map has a single node)
	#;         25        comp - 0/1/2 if computed - 1:virtual/2:triggered
	#;         26        comptag - generated tag to run computation
	#;         27        code = $LIST(lines of code) of computation, using %d
	#;         28        exprflist = a "UList" of fields (except Frowid) in field.code
	#;         29        ftrigflist = for Fcomp=2, a "UList" of triggering fields
	#;         30        log2stor = Logical to Storage MCode lines sub$list
	#;         31        storvar - variable (expression) for field storage value, 
	#;                   %s(icol)/subs(fld), if no %s(icol), use %d(icol)
	#;         32        storgvar - same with $g(), if necessary
	#;         33        FnewvarL2S = Same as Fnewvar, but with LogToStor call
	#;         34        FoldvarL2S = Same as Foldvar, but with LogToStor call
	#;         35        FnewgvarL2S = Same as Fnewgvar, but with LogToStor call
	#;         36        FoldgvarL2S = Same as Foldgvar, but with LogToStor call
	#;         37        stor2log = Storage To Logical MCode lines sub$list
	#;         38        FnewvarS2L = Same as Fnewvar, but with StorToLog call
	#;         39        FoldvarS2L = Same as Foldvar, but with StorToLog call
	#;         40        FnewgvarS2L = Same as Fnewgvar, but with StorToLog call
	#;         41        FoldgvarS2L = Same as Foldgvar, but with StorToLog call
	#;         42        normalize = Field Normalization COS Code lines sub-$list
	#;         43        UseStreamInterface = 1/0 if field uses stram filing interface or not.
	#;         44        FPrivate = 1/0 if the field is PRIVATE
	#;         45        Fcollectiontype = Collection Datatype (if applicable)
	#;         46        Farraycollection = 1/0 if the field is an array collection projected as a single field
	#;         47        FCollectionElementType = 'S'erial, 'P'ersistent, 'D'atatype - used in QuickLoad
	#;         48        FSerialField = 1/0 if the field is a serial collection (DPV1844)
	#;         49        FContainerField = Fld# of the Container field if this field was projected by a serial property (DPV1844)
	#;	   50	     FReference = 1 if the field is a reference, else 0
	#;	   51	     FiDjMapField = iDj value if this is a Map Variable $lb(iDj variable, 1/0 flag, 1 if master map). (DPV1918)
	#;         52        FMapVariableCode = MapVar code for this psuedo field (DPV1918)
	#;         53        FIllegalStorageChars = Validate the field to make sure the storage value does not contain any of these characters (DPV1924)
	#;         54        FxDBCType = xDBC datatype name of the field (DPV1924)
	#;         55        FReadOnly = Read Only Field (1/0) (DPV2124)
	#;         56        FProperty = Name of this field's property (if applicable) (DPV2242)
	#;         57        FOIDType = OIDType of this field
	#;         58        FClassname = Classname that projected this field.  For Serial embedded fields only (DPV2266)
	#;	   59	     FIdentity = 1/0 of this field is an IDENTITY field or not (DPV2795)
	#;	   60	     FCompInsert = 1/0 If the SqlComputeOnChange specifies %%INSERT then 1, else 0
	#;	   61	     FCompUpdate = 1/0 If the SqlComputeOnChange specifies %%UPDATE then 1, else 0
	#;         62	     FMasterMapDataSlot = storage slot number for the field in the mast map, used for MV filing (DPV3066)
	#;	   63	     FCounterLocation = Storage location for counter node (DPV3212)
	#;	   64	     FSreamLocation = Storage location for the stream (DPV3803)
	#;	   65	     FISAContainer = Is this field a container field? (1 or 0) (DPV3904)
	#;	   66	     FCollectionHasChild 1/0 1 if this is a collection field and this collection was also projected as a child table
	#;	FMapPieceDel	For Rowid fields in index maps only.  Used to indicate where the rowid field is mapped to in the map data of the index map
	#;------------------------------------------------------------
#define Ftab(%f) $li(%sqltable(%f),2)
#define Ficol(%f) $li(%sqltable(%f),3)
#define Ffname(%f) $li(%sqltable(%f),4)
#define Fnewvar(%f) $li(%sqltable(%f),5)
#define Fnewgvar(%f) $li(%sqltable(%f),6)
#define Foldvar(%f) $li(%sqltable(%f),7)
#define Foldgvar(%f) $li(%sqltable(%f),8)
#define Fdatatype(%f) $li(%sqltable(%f),9)
#define Fparams(%f) $li(%sqltable(%f),10)
#define Fchanging(%f) $li(%sqltable(%f),11)
#define Fdefault(%f) $li(%sqltable(%f),12)
#define Fdefonly(%f) $li(%sqltable(%f),13)
#define Fvalid(%f) $li(%sqltable(%f),14)
#define Fadvalid(%f) $li(%sqltable(%f),15)
#define Frequired(%f) $li(%sqltable(%f),16)
#define Funique(%f) $li(%sqltable(%f),17)
#define Fcollex(%f) $li(%sqltable(%f),18)
#define Fmlf(%f) $li(%sqltable(%f),19)
#define Fmlfdel(%f) $li(%sqltable(%f),20)
#define Frowid(%f) $li(%sqltable(%f),21)
#define Fpfrom(%f) $li(%sqltable(%f),22)
#define Fpto(%f) $li(%sqltable(%f),23)
#define Fpce3del(%f) $li(%sqltable(%f),24)
#define Fcomp(%f) $li(%sqltable(%f),25)
#define Fcomptag(%f) $li(%sqltable(%f),26)
#define Fcode(%f) $li(%sqltable(%f),27)
#define Fexprflist(%f) $li(%sqltable(%f),28)
#define Fftrigflist(%f) $li(%sqltable(%f),29)
#define Flog2stor(%f) $li(%sqltable(%f),30)
#define Fstorvar(%f) $li(%sqltable(%f),31)
#define Fstorgvar(%f) $li(%sqltable(%f),32)
#define FnewvarL2S(%f) $li(%sqltable(%f),33)
#define FoldvarL2S(%f) $li(%sqltable(%f),34)
#define FnewgvarL2S(%f) $li(%sqltable(%f),35)
#define FoldgvarL2S(%f) $li(%sqltable(%f),36)
#define Fstor2log(%f) $li(%sqltable(%f),37)
#define FnewvarS2L(%f) $li(%sqltable(%f),38)
#define FoldvarS2L(%f) $li(%sqltable(%f),39)
#define FnewgvarS2L(%f) $li(%sqltable(%f),40)
#define Foldgvar2LS(%f) $li(%sqltable(%f),41)
#define Fnormalize(%f) $li(%sqltable(%f),42)
#define FUseStreamInterface(%f) $li(%sqltable(%f),43)
#define Fprivate(%f) $li(%sqltable(%f),44)
#define Fcollectiontype(%f) $li(%sqltable(%f),45)
#define Farraycollection(%f) $li(%sqltable(%f),46)
#define FCollectionElementType(%f) $li(%sqltable(%f),47)
#define FSerialField(%f) $li(%sqltable(%f),48)
#define FContainerField(%f) $li(%sqltable(%f),49)
#define FReference(%f) $li(%sqltable(%f),50)
#define FiDjMapField(%f) $li(%sqltable(%f),51)
#define FMapVariableCode(%f) $li(%sqltable(%f),52)
#define FIllegalStorageChars(%f) $li(%sqltable(%f),53)
#define FxDBCType(%f) $li(%sqltable(%f),54)
#define FReadOnly(%f) $li(%sqltable(%f),55)
#define FProperty(%f) $li(%sqltable(%f),56)
#define FOIDType(%f) $li(%sqltable(%f),57)
#define FClassname(%f) $li(%sqltable(%f),58)
#define FIdentity(%f) $li(%sqltable(%f),59)
#define FCompInsert(%f) $li(%sqltable(%f),60)
#define FCompUpdate(%f) $li(%sqltable(%f),61)
#define FMasterMapDataSlot(%f) $li(%sqltable(%f),62)
#define FCounterLocation(%f) $li(%sqltable(%f),63)
#define FStreamLocation(%f) $li(%sqltable(%f),64)
#define FISAContainer(%f) $li(%sqltable(%f),65)
#define FCollectionHasChild(%f) $li(%sqltable(%f),66)
#define FMapPieceDel(%f,%m) %sqltable(%f,%m)

	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;              MAP properties
	#;------------------------------------------------------------
	#;  Map properties are stored in a list format defined as:
	#;
	#;     list element  description
	#;     ------------  -----------------------------------------
	#;          1        imp
	#;          2        table handle
	#;          3        index = number (0,1,2,...) to uniquely 
	#;                   generate tags for this map, 0 for map0
	#;          4        gref - (master map only) full global reference for the
	#;                   top node, using %d() (Fnewvar) and without the last ")"
	#;          5        snref - map's full reference (similar to $p(^(23),2) ),
	#;                   but with $c(6)Extent$c(5)Field$c(6)'s replaced by $c(3)_fld_$c(3) ,
	#;                   and with each non-constant subscript marked by
	#;                   a preceding and a subsequent $c(4)
	#;          6        mptype = "Full", "Non-NULL", or "Conditional"
	#;          7        scond = Complete code line for testing conditional,
	#;                   using %d(), or NULL
	#;          8        fields - a "fldSnList" of all fields in the map
	#;                   (not including rowid and its based-on fields) 
	#;                   - index maps only
	#;          9        mapsubs - a "fldSnList" of fields in map subscripts
	#;                   - index maps only
	#;          10       topnode = map's top node - always exists
	#;          11       topset - (map0 only) whether to SET top-node on INSERT -
	#;                   either "never", "always", or 'node' to set if %=1
	#;          12       SomeDataRetrieval - set if some map data uses COS retrieval code
	#;                   to get data.  Means optimized getold can't be used
	#;          13       nofilingcode - set to 1 if no filing code is allowed for this map
	#;          14       DataNodeStructure - 'D'elimited or 'L'ist
	#;          15       Lock reference - (master map only)
	#;          16       Same as gref (element 4), but for $Piece maps, omit $G()
	#;          17       Piece map?  1 if this is a Piece map, otherwise 0 or ""
	#;          18       Unique Index (1/0) - For %CacheStorage only
	#;          19       List of index fields - $LB format - For %CacheStorage only
	#;          20       Index Name (SqlName)
	#;          21       Index type "I" or "K" for Index or Key.  For %CacheStorage only
	#;          22       Map has MapSubscripts with overridden invalid conditions 
	#;                   (1/0 flag)  - DPV1166
	#;          23       Map Piece $G reference.  Used for unique/exists checking of piece map.
	#;          24       $List of null markers to use for subscripts in the map.
	#;          25       MPieceDelimiter - characters used by piece delimiters in the subscript levels of this map
	#;          26       MScale - Scale for BitSlice indices
	#;          27       MCollSubfields   K(KEY)/E(ELEMENT) of each field
	#;          28       MCollSubInitialRef   First reference to collection property
	#;	    29       MHasAStream 1/0 flag  1 if this index map has a stream field in he map definition
	#;          30	     MCollSubFieldName - $List of potential collection sub field names  ex. Home(ELEMENTS).ZipCode, this will be ZipCode for this subscript expression position
	#;          31        FI fields - For FI indexes only, same as Mfields, but in order seen in map data
	#;                   (not including rowid and its based-on fields) 
	#;          32        FI mapsubs - For FI indexes only, same as Mmapsubs but ub order seen in map subscripts
	#;          33       Index Name (Object Name)
	#;          34       Index Validation Reference
	#;	    35	     GenerateValidateIndex 1/0 flag, if TRUE, ValidateIndex logic will be generated for this map
	#;------------------------------------------------------------
#define Mimp(%m) $li(%sqltable(%m),1)
#define Mtab(%m) $li(%sqltable(%m),2)
#define Mindex(%m) $li(%sqltable(%m),3)
#define Mmaster(%m) '($$$Mindex(%m))
#define Mgref(%m) $li(%sqltable(%m),4)
#define Msnref(%m) $li(%sqltable(%m),5)
#define Mmptype(%m) $li(%sqltable(%m),6)
#define Mscond(%m) $li(%sqltable(%m),7)
#define Mfields(%m) $li(%sqltable(%m),8)
#define Mmapsubs(%m) $li(%sqltable(%m),9)
#define Mtopnode(%m) $li(%sqltable(%m),10)
#define Mtopset(%m) $li(%sqltable(%m),11)
#define Msomedataret(%m) $li(%sqltable(%m),12)
#define Mnofilingcode(%m) $li(%sqltable(%m),13)
#define MDataNodeStructure(%m) $li(%sqltable(%m),14)
#define MLockReference(%m) $li(%sqltable(%m),15)
#define Mgrefnodollarg(%m) $li(%sqltable(%m),16)
#define Mpiecemap(%m) $li(%sqltable(%m),17)
#define Munique(%m) $li(%sqltable(%m),18)
#define Mindexflds(%m) $li(%sqltable(%m),19)
#define Mname(%m) $li(%sqltable(%m),20)
#define Mindextype(%m) $li(%sqltable(%m),21)
#define MHasInvalidConditionOvr(%m) $li(%sqltable(%m),22)
#define Mpiecegref(%m) $li(%sqltable(%m),23)
#define Mnullmarkers(%m) $li(%sqltable(%m),24)
#define MPieceDelimiter(%m) $li(%sqltable(%m),25)
#define MScale(%m) $li(%sqltable(%m),26)
#define MCollSubfields(%m) $li(%sqltable(%m),27)
#define MCollSubInitialRef(%m) $li(%sqltable(%m),28)
#define MHasAStream(%m) $li(%sqltable(%m),29)
#define MCollSubFieldName(%m) $li(%sqltable(%m),30)
#define MFImapsubs(%m) $li(%sqltable(%m),31)
#define MFIfields(%m) $li(%sqltable(%m),32)
#define MIndexName(%m) $li(%sqltable(%m),33)
#define MIndexValidRef(%m) $li(%sqltable(%m),34)
#define MGenerateValidateIndex(%m) $li(%sqltable(%m),35)
#define MInvalidConditionCode(%m) $li(^||%sql.table(%m),36)
	#;  map.override(op) = user override filing code, for op="i"/"u"/"d"
#define Moverride(%m,%op) %sqltable(%m,"override",%op)
	#;  map.mapien = n - if row is pieced - number of code-lines
	#;      to set it with the value of variable 'node'.
	#;      Use n=1 even if a single line!
#define Mmapien(%m) %sqltable(%m,"mapien")
	#;  map.mapie(1:n) = lines of code, using %d
#define Mmapie(%m,%i) %sqltable(%m,"mapie",%i)
	#;------------------------------------------------------------
	#;  *** Node - defined here for MnodesAdd ***
#define Nquoted(%n) $li(%sqltable(%n),2)
	#;------------------------------------------------------------
	#;              Mnodes - collection of nodes within a map
	#;  map.nodes(node) - list of nodes
	#;  map.nodeq(Nquoted)=node - index on nodes by quoted value
#define MnodesAdd(%m,%n) s %sqltable(%m,"nodes",%n)="",%sqltable(%m,"nodeq",$$$Nquoted(%n))=%n
#define MnodesNext(%m,%n) $o(%sqltable(%m,"nodes",%n))
#define MnodesGetq(%m,%q) $g(%sqltable(%m,"nodeq",%q))
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;              NODE properties
	#;------------------------------------------------------------
	#;  Node properties are stored in a list format defined as:
	#;
	#;     list element  description
	#;     ------------  -----------------------------------------
	#;          1        map = map handle
	#;          2        quoted = quoted node as in the generated code,
	#;                   including the comma (if not offset) and the ")",
	#;                   with +/- if offset, and for the top-node it's simply ")"
	#;          3        ref = complete node reference - master map only
	#;------------------------------------------------------------
#define Nmap(%n) $li(%sqltable(%n),1)
#;  *** #define Nquoted(%n) %sqltable(%n,"quoted")  ;  defined earlier! ***
#IF 0   ; DPV922+
#define Nref(%n) $li(%sqltable(%n),3)
#ELSE   ; DPV922=
#define Nref(%n) $p($li(%sqltable(%n),3),$c(2))
#define NrefSet(%n) $li(%sqltable(%n),3)
#ENDIF  ; DPV922-
	#;  node.mapdata = node data expression, using %d and delimiters
	#;                 for top-node (and maybe others as well?) it is possibly
	#;                 a quoted empty string (or may be missing??)
#define Nmapdata(%n) %sqltable(%n,"mapdata")
	#;  node.offset - 1/0 if offset node
#define Noffset(%n) ("+-"[$e($$$Nquoted(%n)))
	#;  node.flist - a "fldSnList" of all fields in the node - map0 only
	#;      (including rowid?)
#define Nflist(%n) %sqltable(%n,"flist")
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;   Trigger Definitions
	#;  trig.code - $List of trigger code lines.
#define Ttrigcode(%n) %sqltable(%n,"code")
#define Ttrigname(%n) %sqltable(%n,"name")
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	#;              Constraint properties
	#;------------------------------------------------------------
	#;  Constraint properties are stored in a list format defined as:
	#;
	#;     list element  description
	#;     ------------  -----------------------------------------
	#;          1        Constraint Name (Object name)
	#;          2        Constraint Type (PKEY,UNIQUE,FKEY,CHECK, etc)
	#;          3        Contraint Info, info depends on Constraint type
	#;                             For UNIQUE and PKEY constraint, coninfo is a list 
	#;                              of sql field names delimited by commas
	#;                             For FKey constraint, coninfo is a $List structure 
	#;                                1. Foreign Key field name
	#;                                2. Referenced table name (qualified)
	#;                                3. Referenced field names (delimited by commas)
	#;                                4. Referenced key name (object)
	#;                                5. Referenced key name (sql)
	#;                                6. Update Rule
	#;                                7. Delete Rule
	#;                                8. Referenced class name (object)
	#;          4        Constraint Check Uses SQL Query? 1 if yes, 0 if no
	#;          5        Constraint Name (SQL name)
	#;          6        Constraint Lock Reference - for PKEY/UNIQUE constraints
	#;          7        Constraint counter - for PKEY/UNOQUE constraints locking flag
	#;          8        Constraint system assigned? (2/1/0)
	#;                     If a target of a foreign key specifies no key, Dan default
	#;                     the target to the IDKEY, which if not specified, is system
	#;                     assigned (1).  The fake %rowid constraint is 2.  All user-defined
	#;                     constrainst are 0.
	#;          9        Constraint UnLock Reference - for PKEY/UNIQUE constraints
	#;          10       Constraint Lock Reference (old values) - for PKEY/UNIQUE constraints
	#;          11       Constraint originating extent (DPV2105)
	#;          12       Constraint originating schema name (DPV2105)
	#;          13       Constraint originating table name (DPV2105)
	#;          14       Constraint originating columns
	#;          15       Constraint FKey Same table flag 1 if the FKey references the same table
	#;          16       Constraint FKey Same Row Check code - If the same table, a check that can be used in an IF condition to determine if the 
	#;                    FKey references the same row
	#;          17       Is UNIQUE constraint the IDKEY field (single field IDKEY)
	#;          18       NOCHECK flag.  1 means NOCHECK specified, 0 means check the constraint
	#;       Node "c1"   Constraint code1 - for tables with many contraints, place holder for code gen.
	#;       Node "c2"   Constraint code2 - for tables with many contraints, place holder for code gen.
	#;       Node "c3"   Constraint code3 - for tables with many contraints, place holder for code gen.
	#;       Node "c4"   Constraint code4 - for tables with many contraints, place holder for code gen.
	#;------------------------------------------------------------
#define Tconname(%c) $li(%sqltable(%c),1)
#define Tcontype(%c) $li(%sqltable(%c),2)
#define Tconinfo(%c) $li(%sqltable(%c),3)
#define Tconquery(%c) $li(%sqltable(%c),4)
#define Tconsqlname(%c) $li(%sqltable(%c),5)
#define Tconlockref(%c) $li(%sqltable(%c),6)
#define Tconcount(%c) $li(%sqltable(%c),7)
#define TconSystemAssigned(%c) $li(%sqltable(%c),8)
#define Tconunlockref(%c) $li(%sqltable(%c),9)
#define Tconlockrefold(%c) $li(%sqltable(%c),10)
#define TconOrigExtent(%c) $li(%sqltable(%c),11)
#define Tconschema(%c) $li(%sqltable(%c),12)
#define Tcontable(%c) $li(%sqltable(%c),13)
#define TconOrigColumns(%c) $li(%sqltable(%c),14)
#define TconFKeySameTable(%c) $li(%sqltable(%c),15)
#define TconFKeySameRowCheck(%c) $li(%sqltable(%c),16)
#define TconIsIdKeyField(%c) $li(%sqltable(%c),17)
#define TconNoCheck(%c) $li(%sqltable(%c),18)
#define Tconfkeycode1(%c) %sqltable(%c,"c1")
#define Tconfkeycode2(%c) %sqltable(%c,"c2")
#define Tconfkeycode3(%c) %sqltable(%c,"c3")
#define Tconfkeycode4(%c) %sqltable(%c,"c4")
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	 