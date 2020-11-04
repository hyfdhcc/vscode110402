Include (%syDatabase, %sySecurity, %sySystem, %syPrompt, %occErrors)

Class %Library.GlobalEdit Extends (%Persistent, %SYSTEM.Help) [ Inheritance = right, StorageStrategy = GlobalStorage, System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC2497  2/10/16 Steve Clay, Encode EndKey Global correctly if Start and End node are the same in GetGlobalSizeBySubscript() 
SML2195 11/24/15 Simon Li, Document change of %GlobalEdit.GetGlobalSize().
STC2410  4/28/15 Steve Clay, %Library.GlobalEdit.KillRange with END subscript now kills to end of global
STC2396  4/07/15 Steve Clay, Add audit flag to $zu(98)
STC2382  1/20/15 Steve Clay, Handle BEGIN and END better in %Library.GlobalEdit.KillRange()
SML1968 11/04/14 Simon Li, Support %-global for DataMove.
STC2342  9/19/14 Steve Clay, Fix Property Does not exist error in %Library.GlobalEdit
STC2340  9/18/14 Steve Clay, Update to handle $c(1) in starting node subscripts correctly 
STC2328  9/02/14 Steve Clay, %Library.GlobalEdit::GetGlobalSizeBySubscript updated to handle range of ^X:^X
STC2323  8/27/14 Steve Clay, Fix <FUNCTION> error in %Library.GlobalEdit:KillRange()
STC2300  7/16/14 Steve Clay, %Library.GlobalEdit methods KillRange() and GetGlobalSizeBySubscript()
                 support BEGIN and END Keywords
STC2289  6/11/14 Steve Clay, %Library.GlobalEdit:KillRange() now supports starting subscript of ""
STC2283  4/23/14 Steve Clay, %GlobalEdit.KillRange() handles more ranges now
STC2279  4/04/14 Steve Clay, %Library.GlobalEdit.KillRanges() Now deletes top level node
SJ2958	 4/02/14 Scott Jones, don't use $VIEW to peek into internal structures!
STC2274  3/13/14 Steve Clay, %GlobalEdit.KillRange() Does not return error if global not found
STC2272  3/02/14 Steve Clay, %GlobalEdit.DeleteDirectoryEntry() method
STC2267  2/13/14 Steve Clay %GlobalEdit.KillRange() doesn't delete full range in some cases
SML1729  6/25/13 Simon Li, Check readonly due to fail to create cache.lck and
                 honor readonly mirrored DB in primary.
STC2215  6/11/13 Steve Clay, %Library.GlobalEdit.KillRange() 
STC2204  5/02/13 Steve Clay, Add %Library.GlobalEdit.GetGlobalSizeBySubscript() method 
JLC1625  7/04/12 Jose' Cordeiro, allow collation as external name or internal
                 number in Create()
JO2542	 4/18/12 Jeffrey Orlin, update error message in Comact() if we fail to get
                 the lock
JO2541	 4/17/12 Jeffrey Orlin, use $zu(49) directly to retrieve the db block size
                 in Compact() rather than ##class(SYS.Database) because this class is 
                 a %Library class so it can be called outside of CACHESYS (so it can't
                 use SYS.Database).
SML1457  2/15/12 Simon Li, Fix COS codes to get global vector address.
SML1370  7/11/11 Simon Li, Document change of %GlobalEdit.GetSize().
JO2427   5/02/11 Jeffrey Orlin, change the lock .Compact() acquires on the global
                 being compacted to a lock in %SYS so we can compact globals in
                 a mirrored database on the backup.
SML1323 03/16/11 Simon Li, Allow creating new global in a not yet mounted DB.
SJ2636 12/06/10	Scott Jones, add option to stop after any error for CheckGlobalIntegrity
SML1156 8/17/09 Simon Li, Support faster option for %GlobalEdit.GetGlobalSize().
SML790 11/14/06 Simon Li, Fix Global Compact get <SYNTAX> error.
SML736 07/11/06 Simon Li, Change $e(x,n,999) to $e(x,n,*).
LRS1039 5/31/06 Lee Smith, Increased DIRLEN changes
SML669  1/04/06 Simon Li, Use $zu(167,6) to update global directory info.
RJW1156 7/26/05 Ron Watt, Decision to journal should be based on database attribute.
STC778  3/21/05 Steve clay, Fix PROTECT error in global edit 
LFT1413 2/23/05 Laura Tillem, rename this to %Library.GlobalEdit
LFT1394 1/31/05 Laura Tillem, %Library.BooleanYN -> Security
LFT1320 11/09/4 Laura Tillem, %DM -> %SYS.DATABASE, also %SYS.GXLINF1
PWC923 11/08/04 Peter Cudhea, Created %Library.Function, %Library.Utility,
                and %Sys.System classes.
STC666 10/29/04 Steve Clay, merge $SYSTEM.Library.Pattern into here
PWC922 10/27/04 Peter Cudhea, Move several classes to %Library
STC666 10/24/04 Steve Clay, Changes for CACHELIB/CACHESYS split
LFT1316 10/21/04 Laura Tillem, reorg %SYSTEM -> SYS
LFT1285 07/14/04 Laura Tillem, put CFL1104 Format() in $SYSTEM.Library.Utility.
LFT1284 07/14/04 Laura Tillem, add Exists parameter to Create method
CFL1104 07/08/04 Carlos Lopes, return global sizes in float format
CFL1096 07/07/04 Carlos Lopes, add Find query. Moved it to %Global class.
LFT1276 06/25/04 Laura Tillem, add Integrity query and methods
PWC863  05/14/04 Peter Cudhea, Database and Global Classes work with long directory names
LFT1241 04/05/04 Laura Tillem, allow namespace parameter to Create
STC530	02/26/04 Steve Clay, Better handling of dismounted database
LFT1224 02/26/04 Laura Tillem, fix LockLocation 
LFT1220 02/18/04 Laura Tillem, fix RemJob handling
LFT1210 02/04/04 Laura Tillem, add rINDEXSQL to system global list
LFT1185 01/08/04 Laura Tillem, use DirectoryList query in GetName
LFT1184 01/02/04 Laura Tillem, change %32Bits to Bits32
LFT1173 12/16/03 Laura Tillem, add gsize functions
LFT1159 12/07/03 Laura Tillem, use system global class for some functions
LFT1154 10/22/03 Laura Tillem, add DEFAULTCONCURRENCY parameter
STC477	09/08/03 Steve Clay, Initial version.
-------------------End Documentation----------------------------------
*/
Parameter DEFAULTCONCURRENCY = 0;

/// Collation of the global.
Property Collation As %Library.Collate;

/// Directory global is located in.
Property Directory As %SysPath [ ReadOnly ];

/// Block size of the database the global is in.
Property DatabaseBlockSize As %Integer(VALUELIST = ",2048,4096,8192,16384,32768,65536") [ InitialExpression = {$$$8k}, ReadOnly ];

/// Global directory entry exists.
Property Exists As Security.Datatype.BooleanYN [ ReadOnly ];

/// First data block of the global.<br>
/// Note referencing this property causes a $D(global) and I/O to occur.
Property FirstDataBlock As %Integer [ Calculated ];

/// Growth block for the global.
Property GrowthBlock As %Integer;

/// Keep global directory attributes when deleted.
Property IsKeep As Security.Datatype.BooleanYN;

/// Global contains no data.
Property IsEmpty As Security.Datatype.BooleanYN [ ReadOnly ];

/// Name of the global.
Property Name As %String;

/// Top pointer block of the global.
Property PointerBlock As %Integer;

/// Current permission on the global.
/// This is the "RW" value that the process who has this 
/// instance open has access to it.
Property Permission As Security.Datatype.Permission [ ReadOnly ];

/// Resource name of the global.
Property ResourceName As %String [ ReadOnly ];

/// System name where global resides.
Property System As %String [ ReadOnly ];

ClassMethod GetName(Directory, Prompt, Value, Obj, Min, Max, Help, Flag, Timeout) As %Integer [ Internal ]
{
 s $zt="ERROR"    
 f  {
	s Value1=$g(Value)
	s Status=##Class(%Library.Prompt).GetArray(Prompt,.Value1,$lb("%SYS.GlobalQuery:DirectoryList",Directory),.Min,.Max,.Help,.Flag,.Timeout)
 	i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse)||(Value1="") q
#; Validate global specification. 
 	i '..IsValidName(Value1) w !!,Value1_" is not a legal name, please re-enter" continue

#; If here, we have a valid directory specification, and
#; the directory exists. Lets get an object handle to it
	s Gbl=##Class(%GlobalEdit).Open(Value1,Directory,,,.Status)

	i $zb(+Flag,$$$MustExistMask,1) {
		i $$$ISERR(Status) {
			w ! d $SYSTEM.Status.DisplayError(Status) w !
			Continue
		}
		s Obj=Gbl
		s Value=Value1
		q
	}
#;If here, the global must not exist, i.e. we are going to create a new one.
	i $$$ISOK(Status) {
		w !!,"Global "_Value1_" already exists, please re-enter",!
		Continue
	}
 	k %objlasterror
 	s Gbl=##Class(%GlobalEdit).%New(Directory)
	i $d(%objlasterror) {
		w ! d $SYSTEM.Status.DisplayError(%objlasterror) w !
		Continue
	}
 	k %objlasterror
	s Gbl.Name=Value1
	i $d(%objlasterror) {
		w ! d $SYSTEM.Status.DisplayError(%objlasterror) w !
		Continue
	}
	s Obj=Gbl
	s Value=Value1
 	q
 }
 q Status
ERROR s $zt=""
 i $ze["<INTERRUPT>" q $$$CtrlCResponse
 ztrap $ZE
}

ClassMethod LoadFields(Field, Obj, New) [ Internal ]
{
#define Name 1
#define Directory 2
#define Collation 3
#define GrowthBlock 4
#define PointerBlock 5
#define ResourceName 6
#define IsKeep 7
#define Permission 8

 s Field=Obj
 s Field($$$Collation,"Caption")="Collation"
 s Field($$$Collation,"Prompt")="Collation type?"
 s Field($$$Collation,"Property")="Collation"
 i 'New s Field($$$Collation,"ReadOnly")=""

 s Field($$$Directory,"Caption")="Directory"
 s Field($$$Directory,"Property")="Directory"
 s Field($$$Directory,"ReadOnly")=""
 
 s Field($$$GrowthBlock,"Caption")="Growth block"
 s Field($$$GrowthBlock,"Prompt")="Growth block?"
 s Field($$$GrowthBlock,"Property")="GrowthBlock"

 s Field($$$Name,"Caption")="Name"
 s Field($$$Name,"Property")="Name"
 s Field($$$Name,"ReadOnly")=""
 
 s Field($$$PointerBlock,"Caption")="Pointer block"
 s Field($$$PointerBlock,"Prompt")="Pointer block?"
 s Field($$$PointerBlock,"Property")="PointerBlock"
 i 'New s Field($$$PointerBlock,"ReadOnly")=""
 
 s Field($$$IsKeep,"Caption")="Preserve attributes"
 s Field($$$IsKeep,"Prompt")="Preserve attributes on delete?"
 s Field($$$IsKeep,"Property")="IsKeep"

 s Field($$$Permission,"Caption")="Permission"
 s Field($$$Permission,"Property")="Permission"
 s Field($$$Permission,"ReadOnly")=""
 
 s Field($$$ResourceName,"Caption")="Resource Name"
 s Field($$$ResourceName,"Prompt")="Resource Name?"
 s Field($$$ResourceName,"Property")="ResourceName"
 s Field($$$ResourceName,"ReadOnly")=""
 q $$$OK
}

ClassMethod GrowthBlockPrompt(Prompt, Obj)
{
 s $zt="ERROR"
 f  {
	s Value=Obj.GrowthBlockLogicalToDisplay(Obj.GrowthBlock)
	s Status=##Class(%Library.Prompt).GetNumber(Prompt,.Value,,,,$$$TrapCtrlCMask)
 	i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse) q
 	k %objlasterror
	s Obj.GrowthBlock=Obj.GrowthBlockDisplayToLogical(Value)
	i $d(%objlasterror) w ! d $SYSTEM.Status.DisplayError(%objlasterror) w ! Continue
	q
 }
 q Status
ERROR s $zt=""
 i $ze["<INTERRUPT>" q $$$CtrlCResponse
 ztrap $ZE
}

ClassMethod PointerBlockPrompt(Prompt, Obj)
{
 s $zt="ERROR"
 f  {
	s Value=Obj.PointerBlockLogicalToDisplay(Obj.PointerBlock)
	s Status=##Class(%Library.Prompt).GetNumber(Prompt,.Value,,,,$$$TrapCtrlCMask)
 	i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse) q
 	k %objlasterror
	s Obj.PointerBlock=Obj.PointerBlockDisplayToLogical(Value)
	i $d(%objlasterror) w ! d $SYSTEM.Status.DisplayError(%objlasterror) w ! Continue
	q
 }
 q Status
ERROR s $zt=""
 i $ze["<INTERRUPT>" q $$$CtrlCResponse
 ztrap $ZE
}

ClassMethod CollationPrompt(Prompt, Obj)
{
 s $zt="ERROR"    
 f  {
	s Value=Obj.CollationLogicalToDisplay(Obj.Collation)
	s Status=##Class(%Library.Prompt).GetArray(Prompt,.Value,$lb("%Library.Collate:CollationList"),,,,$$$TrapCtrlCMask+$$$MatchArrayMask+$$$InitialDisplayMask)
 	i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse) q
 	k %objlasterror
	s Obj.Collation=Obj.CollationDisplayToLogical(Value)
	i $d(%objlasterror) w ! d $SYSTEM.Status.DisplayError(%objlasterror) w ! Continue
	q
 }
 q Status
ERROR s $zt=""
 i $ze["<INTERRUPT>" q $$$CtrlCResponse
 ztrap $ZE
}

ClassMethod IsKeepPrompt(Prompt, Obj)
{
 s $zt="ERROR"
 f  {
	s Value=Obj.IsKeep
	s Status=##Class(%Library.Prompt).GetYesNo(Prompt,.Value,,$$$TrapCtrlCMask)
 	i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse) q
 	k %objlasterror
	s Obj.IsKeep=Value
	i $d(%objlasterror) w ! d $SYSTEM.Status.DisplayError(%objlasterror) w ! Continue
	q
 }
 q Status
ERROR s $zt=""
 i $ze["<INTERRUPT>" q $$$CtrlCResponse
 ztrap $ZE
}

/// Return the space used, and the space allocated, in a global.
/// including big string blocks^^^
/// 'Allocated' - total size, in MB, of blocks allocated for the global.<br>
/// 'Used' - total used data, in MB, for the global.<br>
/// 'fast' - TRUE : faster return, it won't return the value of 'Used'.<br>
/// FALSE - slower return,, it returns values for both 'Allocated' and 'Used'.
Method GetSize(ByRef Allocated As %Integer, ByRef Used As %Integer, fast As %Boolean = 0) As %Integer [ Internal ]
{
 s $zt="GetSizeE"
 o 63:"^^"_i%Directory 
 s blk=i%PointerBlock
 s (Bytes,Count)=0
 s blksiz=i%DatabaseBlockSize
 s big='(blksiz=$$$2k)
 i blk {
	 if fast {
		 s rc=$$INTbrief^%GSIZE(blk,big)
		 s Count=+rc
	 } else {
		 f  q:'blk  v blk s type=$case(i%DatabaseBlockSize,$$$2k:$$$type2k,:$$$type) q:(type=8!(type=12))  s blk=$v(2,-5)
		 s rc=$$INTdetail^%GSIZE(blk,big,blksiz)
		 s Count=$p(rc,",",2),Bytes=+rc
	 }
	 /* We don't need to close 63 here because it is clased in %GSIZE. */
 }
 s Allocated=Count*i%DatabaseBlockSize/$$$megabyte,Allocated=##Class(%Library.Utility).FormatMB(Allocated) 
 i 'fast s Used=Bytes/$$$megabyte,Used=##Class(%Library.Utility).FormatMB(Used)
 q $$$OK
GetSizeE s $zt=""
 c 63
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Validate the passed name is legal for a global name.
ClassMethod IsValidName(Name As %String) As %Boolean [ CodeMode = expression, Internal ]
{
$zname(Name,3)
}

ClassMethod InvalidateGlobalVector(Name As %String = "", Directory As %String = "") As %Status [ Internal ]
{
 i Name="" {
	i Directory="" {
		  d $zu(154) 
		  q $$$OK
	}
	q $$$ERROR($$$NotALegalName,"")	
 }
 i Directory'="" s Directory=##Class(%Library.File).NormalizeDirectory(Directory) 
 i $e(Name)="^" s Name=$e(Name,2,$l(Name))
 i $D(@("^|""^^"_Directory_"""|"_Name)) 
 Do $Zutil(154)
 q $$$OK
}

/// Open an instance of a global.
ClassMethod Open(Name As %String, Directory As %String = {$zu(12,"")}, System As %String = "", concurrency As %Integer = -1, ByRef sc As %Status = {$$$OK}) As %ObjectHandle
{
	Set return = ..%OpenId($lb(Name,Directory,System),.concurrency,.sc)
	q return
}

Method %LoadData(id As %String) As %Status [ Internal, Private ]
{
 s $zt="%LoadDataE"
 s Name=$li(id,1) s:$e(Name)="^" Name=$e(Name,2,$l(Name))
 i '..IsValidName(Name) q $$$ERROR($$$NotALegalName,i%Name)
 s Directory=$li(id,2) s:$e(Directory,1,2)="^^" Directory=$e(Directory,3,$l(Directory))
 s System=$li(id,3)
 i System'="" g Remote
 s x=$zu(49,Directory)
 If x<-3 Quit $$$ERROR($$$DatabaseNotAvailable)
 i x=-3 q $$$ERROR($$$DatabaseNameInvalid)
 i x=-2 q $$$ERROR($$$DatabaseDoesNotExist,Directory)
 i (+x=-1) || (+x=$$$SFNUNDEF) Quit $$$ERROR($$$DatabaseNotAvailable)
#;SML669+
 s rc=$zu(167,6,7,Directory,Name)
 if +rc=-1 q $$$ERROR($$$NotALegalName,Name)
 if +rc=-2 q $$$ERROR($$$GlobalNotFound,Name)
 if +rc=-3 q $$$ERROR($$$DatabaseNotAvailable)
 ; rc is Keep^Collation,Growth^Pointer
 s i%DatabaseBlockSize=+$p(x,",",$$$blksizpiece) ;block size
 s i%ResourceName=$$$getresource(x)
 s i%Permission=$System.Security.Users.ResourcePermissionGet(i%ResourceName)
 s i%Name=Name
 s i%Directory=Directory
 s i%System=""
 s i%PointerBlock=$p(rc,"^",4)
 s i%GrowthBlock=$p(rc,"^",3)
 s i%Collation=$p(rc,"^",2)
 s i%IsKeep=$p(rc,"^",1)
 s i%IsEmpty=$case(i%PointerBlock,0:1,:0)
 s i%Exists=1
 q $$$OK
#;SML669-
Remote s $zt=""
 Quit $$$ERROR($$$UnexpectedError,"<UNSUPPORTED>")
%LoadDataE s $zt=""
 c 63
 Quit $$$ERROR($$$CacheError,$Zerror)
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 s $zt="%SaveDataE"
 i i%System'="" g Remote
 s x=$zu(49,i%Directory)
 If x<-3 Quit $$$ERROR($$$DatabaseNotAvailable)
 i x=-3 q $$$ERROR($$$DatabaseNameInvalid)
 i x=-2 q $$$ERROR($$$DatabaseDoesNotExist,i%Directory)
 #;SML1323 ; Allow never mounted DB.
 i (+x=-1) Quit $$$ERROR($$$DatabaseNotAvailable)
 i 'i%Exists {
	i '..IsValidName(i%Name) q $$$ERROR($$$NotALegalName,i%Name)
	Set rc=$zu(178,"^^"_i%Directory,i%Name,i%Collation,-1,0,i%IsKeep,i%PointerBlock,i%GrowthBlock)
	i rc=-2 q $$$ERROR($$$GlobalIsRemote,i%Name)
	i rc=-1 q $$$ERROR($$$GlobalExists,i%Name)
	i rc'=1 q $$$ERROR($$$CannotCreateGlobal,i%Name)
 }
 s DirectoryBlock=+$p(x,",",$$$glodirpiece) ;glodir
 s DatabaseBlockSize=+$p(x,",",$$$blksizpiece) ;block size
 i i%Exists {
#;SML669+
#;Get the global info in directory block to compare with data in the class.
#;if no change we don't need to update the directory block. 
    s rc=$zu(167,6,7,i%Directory,i%Name)
    if +rc=-1 q $$$ERROR($$$NotALegalName,i%Name)
    if +rc=-2 q $$$ERROR($$$GlobalNotFound,i%Name)
    if +rc=-3 q $$$ERROR($$$DatabaseNotAvailable)
    if ((i%GrowthBlock'=$p(rc,"^",3))||(i%IsKeep'=$p(rc,"^",1))) {
        #; Update the directory block, only modify Keep and Growth.
        s rc=$zu(167,6,7,i%Directory,i%Name,i%IsKeep,$p(rc,"^",2),i%GrowthBlock,$p(rc,"^",4))
        if +rc=-1 q $$$ERROR($$$NotALegalName,i%Name)
        if +rc=-2 q $$$ERROR($$$GlobalNotFound,i%Name)
        if +rc=-3 q $$$ERROR($$$DatabaseNotAvailable)
        if +rc=-4 q $$$ERROR($$$BadParameter)
        d ..InvalidateGlobalVector(i%Name,i%Directory)
    }
#;SML669-
 }
 s Status=..%LoadData($lb(i%Name,i%Directory,i%System))
 i $$$ISERR(Status) q Status
 q $$$OK
Remote
 Quit $$$ERROR($$$UnexpectedError,"<UNSUPPORTED>")
%SaveDataE s $zt=""
 c 63
 Quit $$$ERROR($$$CacheError,$Zerror)
}

/// Compact a global.
/// <br>
/// PercentFull - How full each data page should be, 50-100<br>
/// MbProcessed - How many MB of the global was processed<br>
/// MbCompressed - How many MB was it compressed to<br>
/// MbToCompress - How many MB of the global to compress in this call (0=ALL)<br>
/// LastGlobalReference - Last reference, "" = completed<br><br>
/// Typical useage is as follows, which compacts the data pages
/// to 80%full, and returns the amount of data processed, and the size it was compacted to:<br><br>
/// s x=##Class(%GlobalEdit).Open("X",dbdirectory)<br>
/// s t=x.Compact(80,.CurrSize,.NewSize)<br><br>
/// Note that this function can be called repeatedly for the same global so that
/// it can be done in chunks by using the last two parameters. The following example
/// does 10MB chunks of the global at a time and accumulates and displays a status:<br><br>
/// s x=##Class(%GlobalEdit).Open("X",dbdirectory)<br>
/// s TotalCurrSize=0,TotalNewSize=0<br>
/// do {<br>
/// s t=x.Compact(80,.CurrSize,.NewSize,10,.LastReference)<br>
/// s TotalCurrSize=TotalCurrSize+CurrSize<br>
/// s TotalNewSize=TotalNewSize+NewSize<br>
/// w !,"Global "_x.Name_" processed="_TotalCurrSize_", compacted to="_TotalNewSize<br>
/// } while LastReference'=""<br>
Method Compact(PercentFull As %Integer = 90, ByRef MbProcessed As %Float, ByRef MbCompressed As %Float, MbToCompress As %Integer = 0, ByRef LastGlobalReference As %String = "") As %Status
{
#;The number of MB compacted in each $zu(98) call
#define MBPerZU98Call 32
 s $ZT="ERROR"
#; Initialize return values
 s MbProcessed=0
 s MbCompressed=0
#;Internal counters
 s BlocksProcessed=0
 s BlocksCompressed=0
#;Get the block size of the database, and calculate how many of the blocks
#;are in one MB
#;JO2541+
 s info=$ZU(49,i%Directory)
 #;These are errors generated by (SYS.Database).%LoadData(). We can't
 #; use SYS.Database here because this is a %Library class which can
 #; be run from outside of %SYS so it doesn't have access to SYS.Database.
 I +info<-3 Quit $$$ERROR($$$DatabaseNotAvailable)
 I +info=-3 q $$$ERROR($$$DatabaseNameInvalid)
 I +info=-2 q $$$ERROR($$$DatabaseDoesNotExist,i%Directory)
 #;SML1729 ; If this is read-only because it is a mirrored db and we're not the primary, then let the operation proceed 
 I $$$mirrordbnowrite(info)||$$$readonlyattrib(info)||($$$readonlystatus(info)&&($SYSTEM.Mirror.IsPrimary()||'$$$mirrored(info))) Quit $$$ERROR($$$ReadOnlyFileSystem)
 s BlockSize=+$p(info,",",$$$blksizpiece)
 s BlocksPerMb=$case(BlockSize,2048:512,4096:256,8192:128,16384:64,32768:32,:16)
#;JO2541-
#;If we passed in how much of the global we want to compress in MB, calculate
#;how many blocks that is
 s BlocksToCompress=$s(MbToCompress<0:0,1:MbToCompress\1)
 i BlocksToCompress'=0 s BlocksToCompress=BlocksPerMb*BlocksToCompress
 s PercentFull=$s(PercentFull<50:50,PercentFull>100:100,1:PercentFull\1)
#;While compacting the database, we want the number of lines/global references
#;to move, and we want to be able to respond to CTRL/C, resjob, etc. So we will
#;continuously call $zu(98) compacting only a "small" amount of data for each call.
 s BlocksPerRound=BlocksPerMb*$$$MBPerZU98Call
#;Now get the starting global reference where we will start compacting. It is either
#;the name of the global object we have open, or an entire global reference, returned
#;in the LastGlobalReference variable from a prior call to this method on the same global
#;if we are doing chunks of this global at a time. If we are calling this repeatedly
#;for the same global (i.e. doing it in chunks) make sure that the LastGlobalReference
#;passed in is the same name as the global object we have open.
#;Tack on an implied namespace if necessary
 s NameSpace="^|"""_"^^"_i%Directory_"""|"
 if (LastGlobalReference'=""),($e($p(LastGlobalReference,"|",3),1,$l(i%Name))=i%Name) {
	s GRef=LastGlobalReference
 } else {
	s GRef=NameSpace_i%Name
 }
 s LastGlobalReference=""
#;Form a lock reference. We only allow one process access to a single global at a time.
#;JO2427+
#;Use ^%GCOMPACT(<dir>,<globnam>) so that we can let gcompact run on
#;globals in mirrored databses on the mirror backup where we can't take out
#;locks in the database because we're not the primary
 s LockRef="^%GCOMPACT("""_i%Directory_""","""_i%Name_""")"
#;JO2427-
#;$zu(98) will compact starting at the current reference in the global vector.
 i $d(@GRef) {
	#;JO2542+
	l +@LockRef:5 
	i '$t {
		s owner=^$LOCK(LockRef,"OWNER")
		if owner="" {
			; Try parent lock, maybe its a truncate/defrag/return space
			s owner=^$LOCK($Name(^%GCOMPACT(i%Directory)),"OWNER")
		}
		if owner="" {
			; Not sure who owns the lock, use a generic message
			q $$$ERROR($$$UnexpectedError,"Lock not granted")
		} else {
			quit $$$ERROR($$$MaintOperationInProgress,owner)
		}
	}
	#;JO2542-
	s BatchMode=$zu(68,25,1)
	s Audit=1
	f  {
#; If I didn't pass in the number of blocks to compress, then we just do the max for
#; each $zu(98) call. Otherwise, do the min(BlocksPerRound,BlocksToCompress)
 		i BlocksToCompress=0 {
 			s Status=$zu(98,PercentFull,BlocksPerRound,Audit)
 		} else {
	 		s Status=$zu(98,PercentFull,$Case(BlocksPerRound>BlocksToCompress,0:BlocksPerRound,1:BlocksToCompress),Audit)
 		}
 		s Audit=0 ; only audit the first call
#;SML790  should get all rest pieces of ":" for return in case ":" is in the subscript.
 		s Code=$p(Status,":",2,$l(Status,":"))
  		i +Status'=1 q
 		s BlocksProcessed=BlocksProcessed+$p(Code,",",1)
 		s BlocksCompressed=BlocksCompressed+$p(Code,",",2)
 		s MbProcessed=##Class(%Library.Utility).FormatMB(BlocksProcessed/BlocksPerMb)
		s MbCompressed=##Class(%Library.Utility).FormatMB(BlocksCompressed/BlocksPerMb)
 		s LastGlobalReference=$p(Code,",",3,$$$MaxStringLength)
#;If the last reference is "", then we are done!
		i LastGlobalReference="" q
#;Carefull here, the last reference may not contain the namespace which we need for
#;the correct $D(ref)
		i $e(LastGlobalReference,1,2)'="^|" s LastGlobalReference=NameSpace_$e(LastGlobalReference,2,*)
		i BlocksToCompress'=0 {
			s BlocksToCompress=BlocksToCompress-BlocksPerRound
			i BlocksToCompress<=0 q
		}
		i $d(@LastGlobalReference)
 	}	
	d $zu(68,25,BatchMode)
	l -@LockRef
 	i +Status'=1 {
		if (Code=1) {
			s msg="GCOMPACT detected that there were insufficient free global"
			s msg=msg_$C(13,10)_" buffers to start compacting a bottom pointer block."
			s msg=msg_$C(13,10)_" Try again when the system is not so busy or increase the"
			s msg=msg_$C(13,10)_" size of the global buffer pool."
 		} 
 		if (Code=2) {
	 		s msg="GCOMPACT detected that a write daemon panic occured while it"
	 		s msg=msg_$C(13,10)_" was running. Try again when the system is not so busy."
 		} 
 		if '((Code=1)||(Code=2)) {
	 		s msg="Unknown error code ("_Code_") returned from $ZU(98)."
	 		s msg=msg_$C(13,10)_"GCOMPACT aborted."
 		}
	 	q $$$ERROR($$$UnexpectedError,msg)
 	}
 }
 q $$$OK
ERROR s $ZT=""
 i $d(LockRef) l -@LockRef
 i $d(BatchMode) d $zu(68,25,BatchMode)
 Quit $$$ERROR($$$CacheError,$Zerror)
}

/// Compact a global.<br>
/// See the method Compact for details on parameters.
ClassMethod CompactGlobal(Name As %String, Directory As %String = {$zu(12,"")}, PercentFull As %Integer = 90, ByRef MbProcessed As %Integer, ByRef MbCompressed As %Integer, MbToCompress As %Integer = 0, ByRef LastGlobalReference As %String = "") As %Status
{
 s $zt="ERROR"
 s Gbl=##Class(%GlobalEdit).Open(Name,Directory,,,.Status)
 i '$$$ISOK(Status) q Status
 q Gbl.Compact(PercentFull,.MbProcessed,.MbCompressed,MbToCompress,.LastGlobalReference)
ERROR s $zt=""
 Quit $$$ERROR($$$CacheError,$Zerror)
}

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
Method %OnNew(initvalue As %CacheString) As %Status [ Private ]
{
 s $zt="%OnNewE"
 s Directory=$g(initvalue)
 i Directory="" {
	 s Directory=$zu(12,"")
 } else {
	 s Directory=##Class(%Library.File).NormalizeDirectory(Directory)
 }
 s x=$zu(49,Directory)
 If x<-3 Quit $$$ERROR($$$DatabaseNotAvailable)
 i x=-3 q $$$ERROR($$$DatabaseNameInvalid)
 i x=-2 q $$$ERROR($$$DatabaseDoesNotExist,Directory)
 #;SML1323 ; Allow never mounted DB.
 i (+x=-1) Quit $$$ERROR($$$DatabaseNotAvailable)
 s i%Collation=+$p(x,",",$$$colpiece) ;col
 s i%Directory=Directory
 s i%Exists=0
 s i%GrowthBlock=+$p(x,",",$$$glogrpiece) ;ggrow
 s i%IsKeep=$zb(+$p(x,",",17),$zu(40,8,24),1)>0
 s i%IsEmpty=1
 s i%PointerBlock=+$p(x,",",$$$gloptrpiece) ;gptr
 s i%Permission=$System.Security.Users.ResourcePermissionGet($$$getresource(x))
 s i%ResourceName=$$$getresource(x)
 s i%System=""
 q $$$OK
%OnNewE s $zt=""
 Quit $$$ERROR($$$CacheError,$Zerror)
}

/// This checks the integrity of a global.  The return value contains information about the global 
Method CheckIntegrity(Silent As %Boolean) As %Status
{
 s $zt="CheckE"
 s rc=$$CheckGlobalIntegrity^%SYS.DATABASE(i%Directory,i%Name,$$$errmaxperglobal,.glototblks,.glopntblks,.glototbytes,.glopntbytes,.globigblks,.globigbytes,.globigstrings,.datasize)
 Quit rc
CheckE
 s $zt=""
 Quit $$$ERROR($$$CacheError,$Zerror)
}

/// This checks the integrity of a single global.  The return value contains information about the global 
ClassMethod CheckGlobalIntegrity(Directory As %String = "", Name As %String, StopAfterAnyError As %Boolean) As %Status [ PublicList = errorreturn ]
{
 Set $zt="CheckGloE"
 New errorreturn
 Quit $$CheckGlobalIntegrity^%SYS.DATABASE(Directory,Name,$s($g(StopAfterAnyError):1,1:$$$errmaxperglobal))
CheckGloE
 Set $zt=""
 Quit $$$ERROR($$$CacheError,$Zerror)
}

Method CollationSet(Arg As %String) As %Status
{
 Set col=-1
 If Arg?1.3N {
	Set col=+Arg
	Do GetNLSCollations^%SYS.Access(.array,1,0,0)
	If '$D(array(col)) Set col=-1
 } ElseIf Arg?1.A1N {
	Do GetNLSCollations^%SYS.Access(.array,1,0,1)
	If $D(array(Arg),status) Set col=+$LI(status,3)
 }
 If col<0 Quit $$$ERROR($$$BadParameter)
 If i%Exists Quit $$$ERROR($$$CannotModifyProperty)
 Set i%Collation=col
 Quit $$$OK
}

/// Create a global with specified characteristics. Parameter Namespace can be a namespace or a directory.  If it is a namespace global mapping rules will apply.
ClassMethod Create(Namespace As %String = "", Name As %String, Collation As %String, GrowthBlock As %Integer, PointerBlock As %Integer, Keep As %Boolean, JournalState As %Integer, ByRef Exists As %Boolean) As %Status
{
 Set $Ztrap="errCreate"
 If Namespace="" Set Namespace=$zu(12,"")
 If $Extract(Namespace,1,2)="^^" {
    Set dir=$Extract(Namespace,3,$Length(Namespace)),Namespace=dir
 } Else { 
   Set $Ztrap="errNs" 
   Set index=$zu(90,3,1,$zcvt(Namespace,"U"))
   If index s dir=$p($$getdest^%SYS.GXLINF1($zcvt(Namespace,"U"),Name),"^",2)
 }
afterNs If $Get(dir)="" Set dir=Namespace
#;Save view buffer
 Set blksiz=$$$getblksiz($$$dirinfo(dir))
 Set (Exists,noviewbuf)=0
 Set $Ztrap="errView"
 Set viewbuf=$View(0,0,-blksiz)
afterView
 Set glob=##class(%GlobalEdit).Open(Name,dir,,,.rc)
 If $$$ISERR(rc) {
    Set glob=##class(%GlobalEdit).%New(dir)
    If glob="" Quit %objlasterror
    Set glob.Name=Name
    #; Collation can be set only for a new global
    If $Data(Collation) {
	    Kill %objlasterror
	    Set glob.Collation=Collation
	    If $D(%objlasterror) Quit %objlasterror
    }
 } Else { Set Exists=1 }
 If $Data(Keep) Set glob.IsKeep=Keep
 If $Get(PointerBlock) Set glob.PointerBlock=PointerBlock
 If $Get(GrowthBlock) Set glob.GrowthBlock=GrowthBlock
 Set rc=glob.%Save() 
 If 'noviewbuf Open 63:"^^"_dir View 0:0:-blksiz:viewbuf
 Quit rc
errNs
 Set $zt="errCreate",$ze=""
 Goto afterNs
errView
 Set $zt="errCreate",$ze=""
 Set noviewbuf=1 Goto afterView
errCreate
 Set $Ztrap="" Quit $$$ERROR($$$CacheError,$Zerror)
}

Method FirstDataBlockGet() As %Integer
{
 Quit $s($d(@("^|"_"""^^"_i%Directory_"""|"_i%Name)):+$lg($zu(208),24),1:0) ;SJ2958
}

/// Delete a directory entry for a global if the global does not exist.<br>
/// This should be called with Switch 10 set if the global is possibly being accessed by users.<br>
/// <br>
/// Parameters:
/// <br>
/// Directory - Directory where the global lives.<br>
/// Global - Name of the global to delete the directory entry for.<br>
/// Note: You must have write access to the database to delete the directory entry.<br>
ClassMethod DeleteDirectoryEntry(Directory, Global) As %Status
{
#;Change to the implied namespace and see if the global exists.
#;If not, then clear the keep bit and kill the global. This needs
#;to be called while switch 10 is set so no Set to the global happens
#;between the $D and the Kill.
 s Status=$$$OK
 Try {
 	#;SML1968+
 	i '$d(@("^|""^^"_Directory_"""|"_Global)) {
 		i $zu(167,6,1,Directory,Global,0)
 		k @("^|""^^"_Directory_"""|"_Global)
 	}
 } catch {
	#;SML1968-
 	s Status=$$$ERROR($$$CacheError,$ze)
 }
 q Status
}

/// Get size of this global<br>
/// 'Allocated' - total size, in MB, of blocks allocated for the global.<br>
/// 'Used' - total used data, in MB, for the global.<br>
/// 'fast' - TRUE : faster return, it won't return the value of 'Used'.<br>
/// FALSE - slower return,, it returns values for both 'Allocated' and 'Used'.
ClassMethod GetGlobalSize(Directory As %String, GlobalName As %String, ByRef Allocated As %Integer, ByRef Used As %Integer, fast As %Boolean = 0) As %Status
{
 s $zt="ERROR"
 s Obj=##Class(%GlobalEdit).Open(GlobalName,Directory,,,.Status)
 i '$$$ISOK(Status) q Status
 q Obj.GetSize(.Allocated,.Used,fast)
ERROR s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Return the size of a global or range of nodes in a global.<br>
/// This method will return the size of a global based on the number
/// of database blocks the global resides in.<br><br>
/// Parameters:<br>
/// Directory - Directory where global is located.<br>
/// StartNode - Staring node of global. Note that you can specify ^GLOBAL(BEGIN) to mean the start of the global.
/// You can also specify ^GLOBAL("XXX"_$c(1)_"*next)" to mean start counting after global ^GLOBAL("XXX").<br>
/// EndNode - End Node of global. The returned sizes do not include the EndNode. Note that you can specify ^GLOBAL(END)
/// to mean through the end of the global.<br>
/// Size - Maximum number of MB to count. If the size of the global exceeds this value, 
/// calculation stops, and an error is returned. If undefined or set to 0, then the entire range is counted.
/// Return Values: <br>
/// The array Size returns the amount of data in both blocks and MB, for each
/// level of the global, as well as the size of big string data, and a total. 
/// If the global does not exist, an error will be returned, and the sizes will all be set to 0.
/// If any other error occurs, sizes will not be set.<br>
/// Size=Total size in MB of the global range<br>
/// Size("Blocks","1")=# Blocks in level 1<br>
/// Size("Blocks","2")=# Blocks in level 2<br>
/// Size("Blocks","3")=# Blocks in level 3<br>
/// Size("Blocks","BigStrings")=# Big String Blocks<br>
/// Size("Blocks","Total")=Total # Blocks in global range<br>
/// Size("MB","1")=# MB in level 1<br>
/// Size("MB","2")=# MB in level 2<br>
/// Size("MB","3")=# MB in level 3<br>
/// Size("MB","BigStrings")=# Big String MB<br>
/// Size("MB","Total")=Total # MB in global range<br><br>
/// Examples:<br><br>
/// Find the size of global ^DATA<br>
/// s Status=##Class(%GlobalEdit).GetGlobalSizeBySubscript("c:\132u1\mgr\user\","DATA","",.Size)<br><br>
/// Find the size of data ^DATA("Jones")<br>
/// s x=##Class(%GlobalEdit).GetGlobalSizeBySubscript("c:\132u1\mgr\user\","DATA(""Jones"")","",.Size)<br><br>
/// Find the size of data between nodes ^DATA("Jones") up to but not including ^DATA("Smith","zzzzz")<br>
/// s x=##Class(%GlobalEdit).GetGlobalSizeBySubscript("c:\132u1\mgr\user\","DATA(""Jones"")","DATA(""Smith"",""zzzzz"")",.Size)<br><br>
/// Find the size of all the data after after node ^X(500)<br>
/// s x=##Class(%GlobalEdit).GetGlobalSizeBySubscript("c:\db1\","^X(500"_$c(1)_"*next)","^X(END)",.Size)<br><br>
/// Find the size of all the data from the beginning of the global up to but not including ^X(500)<br>
/// s x=##Class(%GlobalEdit).GetGlobalSizeBySubscript("c:\db1\","^X(BEGIN)","^X(500)",.Size)<br><br>
ClassMethod GetGlobalSizeBySubscript(Directory As %String, StartNode As %String, EndNode As %String = "", ByRef Size As %String = 0)
{
#;This is the same definition as below. Change it here and there!
#define EncodeKey(%GblRef,%Rule,%Key) i $e(%GblRef)="^" {s ISCNewGblRef=$e(%GblRef,2,*)} else {s ISCNewGblRef=%GblRef} s %Key=$p(ISCNewGblRef,"(") f i=1:1:$ql("^"_ISCNewGblRef) { s %Key=%Key_$c(0)_$zu(70,2,$qs("^"_ISCNewGblRef,i),+%Rule)}
 s $zt="Error"
 s MaxSize=Size
 k Size
 s Status=$$$OK
 s Count=0
 i EndNode="" s EndNode=StartNode
 s GloName=$p(StartNode,"(")
 i GloName'=$p(EndNode,"(") q $$$ERROR($$$GblNamesMustBeTheSame,StartNode,EndNode)
 s Info=$zu(49,Directory)
 i Info<-1 q $$$ERROR($$$DatabaseDoesNotExist,Directory)
 i Info=-1 q $$$ERROR($$$DatabaseIsDismounted,Directory)
 s BlockSize=$$$getblksiz(Info)
 s Info=$zu(167,6,7,Directory,GloName)
 i (+Info<0) {
	i Info=-2 {
		s Status=$$$OK
		f i=1:1:3 s Level("Blocks",i)=0
		s Level("Blocks","BigStrings")=0
		s Level=2
		g Exit
	} else {
		s Status=$$$ERROR($$$UnableToGetDirInfo,GloName,Info)
	}
	q Status
 }
 s Block=+$p(Info,"^",4)
#;If block=0, we have a directory entry for the global, but no data yet 
 i Block=0 {
	f i=1:1:3 s Level("Blocks",i)=0
	s Level("Blocks","BigStrings")=0
	s Level=2
	g Exit
 }
 s Collation=+$p(Info,"^",2)
 s Rule=$zu(70,1,Collation)
#;Now allow StartNode to use ^X(BEGIN) and ^X(10_$c(1)_"*next)", and EndNode to be ^X(END)
 s NextRangeUsed=0
 i StartNode["(BEGIN)" s StartNode=$replace(StartNode,"BEGIN","""""")
#;If we specify (END), we want to calculate all the globals at this level. We could have a global with
#;a subscript like ^X($c(65535)_"A"). So lets just get a string with 200 $c(65535) concatenated together.
 i EndNode["(END)" {
 	i $$$IsUnicode {
		s $p(EndRange,$c(65535),201)=""
 	} else {
		s $p(EndRange,$c(255),201)=""
 	}
	s EndNode=$replace(EndNode,"END",""""_EndRange_"""")
 }
 i StartNode[($c(1)_"*next)") {
	s StartNode=$replace(StartNode,$c(1)_"*next","")
	s NextRangeUsed=1
 }
 i EndNode[($c(1)_"*next)") {
 	i $$$IsUnicode {
		s $p(EndRange,$c(65535),201)=""
 	} else {
		s $p(EndRange,$c(255),201)=""
 	}
	s EndNode=$replace(EndNode,$c(1)_"*next",","""_EndRange_"""")
 }
 $$$EncodeKey(StartNode,Rule,StartKey)
 i NextRangeUsed s StartKey=StartKey_$c(0)
 $$$EncodeKey(EndNode,Rule,EndKey)
#;Bump endkey so "]" works
 i StartNode=EndNode s EndKey=EndKey_$c(1)
 i StartKey]EndKey q $$$ERROR($$$GblEndNodeAfterBeginNode,EndNode,StartNode)
 o 63:"^^"_Directory
 s Level=1,Level("Blocks",Level)=0
#;First count all the pointer blocks
 f  {
 	v Block
 	s Count=Count+1
 	s Type=$$$type q:(Type=6!(Type=70))
 	f i=1:1 {
		s StartNodeKey=$v(2*i-1,-6)
#;Get the block previous to the one we are looking at for the down pointer
		i ((StartNodeKey]StartKey))||(StartNodeKey="") {
			s NextLevelBlock=$v(2*(i-1),-5)
 			q
 		}
 		i StartKey=StartNodeKey {
			s NextLevelBlock=$v(2*i,-5)
 			q
 		}
 	}
	s Level("Blocks",Level)=Level("Blocks",Level)+1
#;We are at the first page in the level we are starting to count. Now follow right links until end
 	f  {
		s Block=$$$link
 		i Block=0 {
			s Block=NextLevelBlock
			s Level=Level+1,Level("Blocks",Level)=0
			q
 		}
 		v Block
 		s Count=Count+1
 		i (MaxSize'=0),(((Count*BlockSize)/(1024*1024))>MaxSize) {
	 		s Status=$$$ERROR($$$GeneralError,"Size calculation for "_StartNode_":"_EndNode_" in "_Directory_" exceeds maximum value of "_MaxSize)
	 		q
 		}
 		s StartNodeKey=$v(1,-6)
 		i EndKey]StartNodeKey s Level("Blocks",Level)=Level("Blocks",Level)+1
 		s NextPageKey=$v(-1,-6)
 		i NextPageKey]EndKey {
			s Block=NextLevelBlock
			s Level=Level+1,Level("Blocks",Level)=0
			q
 		}
 	}
 	i '$$$ISOK(Status) q
 }
 i '$$$ISOK(Status) q Status
#;We are now at the bottom pointer level.
#;
 s Level("Blocks",Level+1)=0
 s Level("Blocks","BigStrings")=0
 s DataPage=""
 f {
	v Block
	s Count=Count+1
 	i (MaxSize'=0),(((Count*BlockSize)/(1024*1024))>MaxSize) {
	 	s Status=$$$ERROR($$$GeneralError,"Size calculation for "_StartNode_":"_EndNode_" in "_Directory_" exceeds maximum value of "_MaxSize)
		q
 	}
	k BigStringPtr
	s Found=0
 	f i=1:1 {
		s StartNodeKey=$v(2*i-1,-6)
		q:StartNodeKey=""
#;We save the previous data page block number so we can look down at
#;the data block level to see if the global range started on the previous page.		
		i StartKey]StartNodeKey s DataPage=$v(2*i,-6)
		i ((StartNodeKey]StartKey)||(StartKey=StartNodeKey))&&(EndKey]StartNodeKey) {
 			s Level("Blocks",Level+1)=Level("Blocks",Level+1)+1
 			s Count=Count+1
  			i (MaxSize'=0),(((Count*BlockSize)/(1024*1024))>MaxSize) {
	 			s Status=$$$ERROR($$$GeneralError,"Size calculation for "_StartNode_":"_EndNode_" in "_Directory_" exceeds maximum value of "_MaxSize)
				q
 			}
			s Found=1
 			s Data=$v(2*i,-6)
 			i $p(Data,",")=1 s BigStringPtr($p(Data,",",2))="" 			
 		} else {
		 	q:StartNodeKey]EndKey 
		}
 	}
 	i '$$$ISOK(Status) q
	i StartNodeKey]EndKey {
		s Block=0
	} else {
		s Block=$$$link
	}
#;Check the previous data page now.
	i DataPage'="" {
		v +$p(DataPage,",",2)
	 	f i=1:1 {
			s StartNodeKey=$v(2*i-1,-6)
			q:StartNodeKey=""
			i ((StartNodeKey]StartKey)||(StartKey=StartNodeKey))&&(EndKey]StartNodeKey) {
 				s Level("Blocks",Level+1)=Level("Blocks",Level+1)+1
 				s Found=1
#;If there is a big string in the data page, add it to the big string check 				
 				i +DataPage s BigStringPtr(+$p(DataPage,",",2))=""
 				q
			}
 		}
 		s DataPage=""
 	}
	q:Found=""
 	s Level("Blocks",Level)=Level("Blocks",Level)+1
#;Now get the big string blocks	For the pointer page we just worked on
	s BigBlock=""
	f  {
		s BigBlock=$o(BigStringPtr(BigBlock)) q:BigBlock=""
		v BigBlock
		s Count=Count+1
	 	i (MaxSize'=0),(((Count*BlockSize)/(1024*1024))>MaxSize) {
			s Status=$$$ERROR($$$GeneralError,"Size calculation exceeds maximum value of "_MaxSize_", calculation ending")
			q
 		}
		f i=1:1 {
			s StartNodeKey=$v(2*i-1,-6)
			q:StartNodeKey=""
			i ((StartNodeKey]StartKey)||(StartKey=StartNodeKey))&&(EndKey]StartNodeKey) {
	 			s Data=$v(2*i,-6)
	  			If $a(Data)'=$$$gdviewbiguni(1),($a(Data)'=$$$gdviewbigcompact(1)),($a(Data)'=$$$gdviewbigbin(1)) Continue
 				s Level("Blocks","BigStrings")=Level("Blocks","BigStrings")+$p(Data,",",2)
	 		}
		}
	}
	i '$$$ISOK(Status) q
 	i Block=0 q
 }
Exit
 i Level("Blocks",Level+1)=0 f i=1:1:Level s Level("Blocks",i)=0
 s i="" f  s i=$o(Level("Blocks",i)) q:i=""  s Level("MB",i)=$fn(Level("Blocks",i)*BlockSize/(1024*1024),"",2)
 s i="" f  s i=$o(Level("Blocks",i)) q:i="Total"  s Level("Blocks","Total")=$g(Level("Blocks","Total"))+Level("Blocks",i),Level("MB","Total")=$g(Level("MB","Total"))+Level("MB",i)
 s Level=Level("MB","Total")
 m Size=Level
 q Status
Error s $zt=""
 s Status=$$$ERROR($$$CacheError,$ze)
 d BACK^%ETN
 q Status
}

/// Kill a subscripted range of a single global in a single database.<br>
/// This method will kill a range of globals node of a single global in a single database. The starting
/// and ending global name must be the same. When a range is specified, the global is killed from the
/// starting node up to but not including the ending node. The exception to this is if the starting and 
/// ending node is the same then that global is killed. The start and end nodes must not contain namespace
/// specifications. Process private globals are not supported. Note that this method ignores all namespace
/// specifications.<br>
/// Parameters:<br>
/// Directory - Location of global to kill.<br>
/// StartingNode - First node of global range to kill. Note that you can specify ^GLOBAL(BEGIN) to mean the start of the global.
/// You can also specify ^GLOBAL("XXX"_$c(1)_"*next)" to mean start deleting after global ^GLOBAL("XXX").<br>
/// 
/// EndingNode - Ending node of global range to kill, up to, but not including this node. Note that you can specify 
/// ^GLOBAL(END) to mean through the end of the global.<br><br>
/// Examples:<br>
/// Kill nodes between ^X(1,5) and ^X(1,50), not including ^X(1,50)<br>
/// s x=##Class(%GlobalEdit).KillRange("c:\db1\","^X(1,5),"^X(1,50)")<br><br>
/// Kill node ^X(500) and all subnodes<br>
/// s x=##Class(%GlobalEdit).KillRange("c:\db1\","^X(500),"^X(500)")<br><br>
/// Kill everything after node ^X(500)<br>
/// s x=##Class(%GlobalEdit).KillRange("c:\db1\","^X(500"_$c(1)_"*next)","^X(END)")<br><br>
/// Kill everything from the beginning of the node up to but not including ^X(500)<br>
/// s x=##Class(%GlobalEdit).KillRange("c:\db1\","^X(BEGIN)","^X(500)")<br><br>
ClassMethod KillRange(Directory As %String, StartingNode As %String, EndingNode As %String) As %Status
{
#;This is the same definition as Above. Change it here and there!
#define EncodeKey(%GblRef,%Rule,%Key) i $e(%GblRef)="^" {s ISCNewGblRef=$e(%GblRef,2,*)} else {s ISCNewGblRef=%GblRef} s:$e(ISCNewGblRef)="|" ISCNewGblRef=$p(ISCNewGblRef,"|",3) s %Key=$p(ISCNewGblRef,"(") f i=1:1:$ql("^"_ISCNewGblRef) { s %Key=%Key_$c(0)_$zu(70,2,$qs("^"_ISCNewGblRef,i),+%Rule)}
 s $zt="Error"
 #;SML1968+ ; If th nodes are explicit reference then change them to implicit reference.
 s StartNode=$s($e(StartingNode,2)="|":"^"_$p(StartingNode,"|",3,*),1:StartingNode)
 s EndNode=$s($e(EndingNode,2)="|":"^"_$p(EndingNode,"|",3,*),1:EndingNode)
 #;SML1968-
 s Info=$zu(49,Directory)
 i Info<-1 {
	s Status=$$$ERROR($$$DatabaseDoesNotExist,Directory)
	q Status
 }
 i Info=-1 {
	s Status=$$$ERROR($$$DatabaseIsDismounted,Directory)
	q Status
 }
#;Nodes must start with "^", and must not have a namespace or directory specification
 i $p(StartNode,"(")'=$p(EndNode,"(") q $$$ERROR($$$MGBLStartAndEndGlobalDiffer)
 i ($e(StartNode)'="^")||("|["[$e(StartNode,2)) q $$$ERROR($$$GlobalReferenceInvalid,StartNode)
 i ($e(EndNode)'="^")||("|["[$e(EndNode,2)) q $$$ERROR($$$GlobalReferenceInvalid,EndNode)
#;Make sure the global node exists 
 s GloName=$p(StartNode,"(")
 s Info=$zu(167,6,7,Directory,GloName)
 i (+Info<0) {
	i Info=-2 q $$$OK  ; Don't return $$$ERROR($$$GlobalNotFound,GloName)
	q $$$ERROR($$$MGBLUnableToGetDirInfo,Directory,GloName,Info)
 }
 s Rule=$zu(70,1,+$p(Info,"^",2))
#;Now allow StartNode to use ^X(BEGIN) and ^X(10_$c(1)_"*next)", and EndNode to be ^X(END)
 s StartNextRangeUsed=0
 i StartNode=(GloName_"(BEGIN)") s StartNode=$replace(StartNode,"BEGIN","""""")
#;If we specify (END), we want to delete all the globals at this level. We could have a global with
#;a subscript like ^X($c(65535)_"A"). We need to special case for this and store this knowledge
#;in the variable ENDSpecified. If set to 1, then we only quit the delete loop below if we $order
#;through the global, and return a "".
 s ENDSpecified=0
 i EndNode=(GloName_"(END)") {
 	s ENDSpecified=1
 	i $$$IsUnicode {
		s EndRange=$c(65535)
 	} else {
		s EndRange=$c(255)
 	}
	s EndNode=$replace(EndNode,"END",""""_EndRange_"""")
 }
 i $e(StartNode,*-6,*)=($c(1)_"*next)"){
	s StartNode=$replace(StartNode,$c(1)_"*next","")
	s StartNextRangeUsed=1
 }
 i $e(EndNode,*-6,*)=($c(1)_"*next)") {
 	s ENDSpecified=1
 	i $$$IsUnicode {
		s EndRange=$c(65535)
 	} else {
		s EndRange=$c(255)
 	}
	s EndNode=$replace(EndNode,$c(1)_"*next",","""_EndRange_"""")
 }
#;Handle the same start and end subscript first
 i StartNode=EndNode {
	 #;SML1968
	 k @("^|""^^"_Directory_"""|"_$e(StartNode,2,*))
	 q $$$OK
 }
 $$$EncodeKey(StartNode,Rule,StartKey)
 $$$EncodeKey(EndNode,Rule,EndKey)
 #;SML1968+ ; Make StartNode as explicit reference.
 s StartNode="^|""^^"_Directory_"""|"_$e(StartNode,2,*)
 i StartKey]EndKey q $$$ERROR($$$GblEndNodeAfterBeginNode,EndNodeParam,StartNodeParam)
 #;SML1968-
#;Now adjust the StartNode if we passed in $c(1)_"*next" to the first node after it. If there is no node, or
#;we are past the Ending node, then we are done.
 i StartNextRangeUsed {
	s StartNode=$q(@StartNode)
	i StartNode="" q $$$OK
 	$$$EncodeKey(StartNode,Rule,StartKey)
 	i StartKey]EndKey q $$$OK
 }	 
#;First, find the level at which the wedge start and end nodes have the same level of subscripts. If
#;no subscripts on the first reference, set Level to 1, and we'll use a first subscript on the first
#;level="", and handle the top level with a zkill later.
 s StartNumSubs=$ql(StartNode)
 s EndNumSubs=$ql(EndNode)
 i StartNumSubs<EndNumSubs {
	 s SubLevel=StartNumSubs+1
 } else {
	 s SubLevel=EndNumSubs
 }
#;Now find the first level where the begin subscript is not = end subscript
 f i=1:1:SubLevel i $qs(StartNode,i)'=$qs(EndNode,i) q
 s SubLevel=i
#;Get the ending subscript on this level. We want to kill everything between the start and end
#;subscript on this level
 s EndSub=$qs(EndNode,SubLevel)
#;Construct the starting node at this level
 #;SML1968
 s Node="^|""^^"_Directory_"""|"_$e($qs(StartNode,0),2,*)_"("
 f i=1:1:SubLevel s Node=Node_""""_$qs(StartNode,i)_""""_","
 s Node=$e(Node,1,*-1)_")"
#;Kill the start node (But not anything under it.) Protect against null subscript error if the ending range
#;had more subscripts than the beginning range. ^X(""):^X("xxx") could also have been passed in.
 try {zk @StartNode} catch {}
#;Now prune the wedge, until we meet the subscript at the same level on the ending node. 
 f  {
	 s Next=$o(@Node) q:(Next="")
#;Keep Looping until we get to the end of the global if (END) specified
	 i 'ENDSpecified q:(Next]]EndSub)||(Next=EndSub)
	 k @$zr
 }
#; handle ^x(1,4):^x(10,5) where ^x(10) has data
 i (Next=EndSub),(SubLevel<EndNumSubs) zk @$zr
#;The entire middle of the wedge is now gone. Lets prune stuff below the common
#;level on the left side now, if there are more levels.
 f i=SubLevel+1:1:StartNumSubs {
	s Node=$e(Node,1,*-1)_","_""""_$qs(StartNode,i)_""""_")"
	zk @Node
	f  {
		s Next=$o(@Node) q:Next=""
		k @$zr
	}
 }
#;Now kill everything under the starting node. Protect against ^test:^test(10,1) where we have a null subscript ^test("")
 try {k @Node} catch {}
 f i=SubLevel+1:1:EndNumSubs {
	#;SML1968
	s Node="^|""^^"_Directory_"""|"_$e($qs(EndNode,0),2,*)_"("
#;For each level, rebuild the node up to this level -1, and then add "" for this level
 	f j=1:1:i-1 s Node=Node_""""_$qs(EndNode,j)_""""_","
	s Node=$e(Node,1,*-1)_","_""""_""""_")"
	s EndSub=$qs(EndNode,i)
	f  {
		s Next=$o(@Node) q:(Next]]EndSub)||(Next=EndSub)||(Next="")
		k @$zr
	}
	i (Next=EndSub),(i<EndNumSubs) zk @$zr
 }
#;Sanity check here
 s NextNode=$q(@StartNode)
 i NextNode'="" {
	$$$EncodeKey(NextNode,Rule,NextNodeKey)
	#;SML1968 ; Remove switch to old NS.
	i EndKey]NextNodeKey q $$$ERROR($$$GeneralError,"Kill range is no good - StartNode:"_StartNodeParam_" EndNode:"_EndNodeParam_" Node:"_NextNode)
 }
 q $$$OK
Error s $zt=""
 #;SML1968 ;i $d(OldNS) zn OldNS
 s Status=$$$ERROR($$$CacheError,$ze)
 d BACK^%ETN
 q Status
}

Method GrowthBlockSet(Arg As %String) As %Status
{
 If (+Arg'=Arg) q $$$ERROR($$$BadParameter)
 Set i%GrowthBlock=+Arg
 q $$$OK
}

Method IsKeepSet(Arg As %Boolean) As %Status
{
 i (Arg=0)!(Arg=1) {
	 s i%IsKeep=Arg
	 q $$$OK
 }
 Quit $$$ERROR($$$BadParameter)
}

/// Set the Global name.
/// <br>
/// If prefaced by a "^" strip it off
Method NameSet(Arg As %String) As %Status
{
 i i%Exists q $$$ERROR($$$CannotModifyProperty)
 s:$e(Arg)="^" Arg=$e(Arg,2,$l(Arg))
#;Let the name be set if it is invalid. Rarely is the set
#;actually tested for correctness in the user's code. We'll test again 
#;before we actually save the global. This allows the error message in 
#;%SaveData to actually return the correct error
 s Status=$$$OK
 s i%Name=Arg
 i '..IsValidName(i%Name) s Status=$$$ERROR($$$NotALegalName,Arg)
 q Status
}

Method PointerBlockSet(Arg As %String) As %Status
{
 i i%Exists q $$$ERROR($$$CannotModifyProperty)
 If (+Arg'=Arg) q $$$ERROR($$$BadParameter)
 Set i%PointerBlock=+Arg
 q $$$OK
}

Storage GlobalStorage
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^Library.GlobalEditS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
