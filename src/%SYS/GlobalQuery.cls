Include (%syDatabase, %sySystem, %syPrompt, %syDataMove)

Class %SYS.GlobalQuery Extends %SYSTEM.Help [ Abstract, System = 3 ]
{

/*
---------------------Documentation------------------------------------
STC2312 08/12/14 Steve Clay, Fix global wildcard directory lookup
STC2295 06/26/14 Steve Clay, Fix typo in %SYS.GlobalQuery
STC2294 06/18/14 Steve Clay, Fix %GD finding a global ^STC54 when a range of STC4:STC5 was specified
STC2253 10/13/13 Steve Clay, Move Globals implementation
SML1764	08/27/13 Simon Li, Allow %SYS.GlobalQuery.NameSpaceList query to return non-mapped globals.
STC2201 04/22/13 Steve Clay, Remove redundant mapping for detail global directory display
SML1565	10/17/12 Simon Li, Protect namespace table scanning without lock command.
SML1375 07/20/11 Simon Li, Fix Unlock() method used wrong value to compare with system name.
STC1882 01/04/10 Steve Clay, Move global list to %syDatabase
SML1277 12/17/10 Simon Li, Add 'FastFlag' option for %SYS.GlobalQuery:Size query.
SML1265 12/01/10 Simon Li, Replace ^CacheTemp with private global in system query codes.
STC1853 10/28/10 Steve Clay, Uppercase namespace name in %SYS.GlobalQuery:NameSpaceList query
STC1846 09/29/10 Steve Clay, Update system global list in %SYS.GlobalQuery
STC1813 07/06/10 Steve Clay, Update %SYS.GlobalQuery to handle subscripts with "^"
STC1767 3/16/10 Steve Clay, %sqlcq is a system global
STC1768 3/10/10 Steve Clay, Update documentation for %SYS.GlobalQuery:Size() 
SML1073 10/06/08 Simon Li, Support faster Global directory list of a DB.
SML971 12/06/07 Simon Li, Fix namespace directory query to handle multi-item mask for mapped % global.
SML965 11/30/07 Simon Li, Use fast global directory for remote and cleanup duplicate codes of getting global directory.
JLC1102 11/29/07 Jose' Cordeiro, improve collation lookup in DirectoryList
SML925  08/29/07 Simon Li, Fix Global Directory query over DCP network.
RFD309  07/26/07 Rob Davis, Fix <UNDEFINED> error in Size() query
STC1239 07/03/07 Steve Clay, Add rINDEXEXT as "system" global
RFD300	05/25/07 Rob Davis, add documentation for other queries/parameters
SML877  05/22/07 Simon Li, Fix document text for 'Size' query.
STC1223 05/02/07 Steve Clay, Define more globals as "System" globals
GK545	10/02/06 Garen Kotikian, modified GlobalQuery across ECP to view the
		 directory block directly
STC1043 08/11/06 Steve Clay, Fix test for remote job in %GD
STC1028 07/14/06 Steve Clay, Get remote global directory with minimal privileges 
STC1025 07/11/06 Steve Clay, Fix various problems with %GD and Portal global display 
SAP584	05/02/06 Steve Pettibone, add ^rMAP to system globals
STC905  08/23/05 Steve Clay, %GD displays system globals correctly
RJW1161 08/08/05 Ron Watt, Remove journal state column from %SYS.GlobalQuery
RJW1156 07/25/05 Ron Watt, Decision to journal should be based on database attribute.
SML603  6/21/05 Simon Li, Add Wildcards method for %SYS.GD to use.
SML592  6/07/05 Simon Li, Use DEFAULTFETCH macro for default fetch routine to
                initialize Row to null string.
STC832  05/11/05 Steve Clay, Trap and report errors when getting global directory
SML562  05/04/05 Simon Li, Support compatibility for remote 5.0 server/client.
SML554  4/22/05 Simon Li, Add HasData to DirectoryList query.
LFT1432 3/31/05 Laura Tillem, fix getting collation from zu49 value
LFT1426 3/24/05 Laura Tillem, show mapped % globals in NameSpaceList
LFT1413 3/03/05 Laura Tillem, SYS.Global -> %GlobalEdit
LFT1394 1/31/05 Laura Tillem, %Library.BooleanYN -> Security
STC745  01/10/05 Steve Clay, Don't uppercase namespace name
LFT1354 01/07/05 Laura Tillem, replace ^UTILITY
JO1844  12/03/04 Jeffrey Orlin, USEPRIVATEGLOBAL support. A namespace
                or directory name in the querys of "^" means return
                info about private globals.
LFT1344 12/01/04 Laura Tillem, rename to %SYS.GlobalQuery
LFT1340 11/29/04 Laura Tillem, don't use SYS.Database class
LFT1335 11/23/04 Laura Tillem, fix SizeClose
LFT1316 11/11/04 Laura Tillem, reorg %SYSTEM -> SYS
LFT1320 11/02/04 Laura Tillem, %DM -> %SYS.Database, %SYS.GD also
STC666 10/29/04 Steve Clay, merge $SYSTEM.Library.Pattern into here
PWC922 10/27/04 Peter Cudhea, Move several classes to %Library
STC666 10/24/04 Steve Clay, Changes for CACHELIB/CACHESYS split
LFT1285 07/14/04 Laura Tillem, put CFL1104 Format() in $SYSTEM.Library.Util.
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
Parameter DEFAULTCONCURRENCY [ Internal ] = 0;

///  Default Localization Domain
Parameter DOMAIN = "%Utility";

ClassMethod DecodeReplication(Index As %Integer) As %String [ Internal, Private ]
{
#define REPENTLEN 8        
 S Bits32=4294967296
 s addr=Index*$$$REPENTLEN+$$$STNETREPA
 S S=$V(addr,-3,4)+($v(addr+4,-3,4)*Bits32)
 s String=""
 F BITNO=0:1 Q:S=0  S:S#2 String=String_BITNO_"," S S=S\2 
 q $e(String,1,$l(String)-1)
}

ClassMethod Lock(Global, Subscript, Name, Timeout = 0) As %Status [ Internal ]
{
	s $zt="Error"
	Set timeout=0
	If $$GetGlobalPermission^%SYS.SECURITY(.ns,Global,"("_$$$QuoteName(Subscript)_")",2)'["WRITE" Quit $$$ERROR($$$RoutineProtect,Name)
	Set global="^|"_$$$QuoteName(ns)_"|"_Global_"("_$$$QuoteName(Subscript)_")"
	For {
		#; If we get the lock we are done
		Lock +@global:timeout If $test Return $$$OK
		Set user=0,job=""
		Set data=$zutil(156,40,ns,"^"_Global,Subscript)
		Set job=$listget($listget(data,2))
		If job'="" Set user=$zutil(67,11,job)
		If timeout=0 {
			If job'="" {
				If $$$IsISCWorker {
					If $$JobIsWorker^%SYS.WorkQueueMgr(job) {
						#; If we are a worker job and we competing with a lock from another worker job then
						#; allow it to wait up to $$$LockTimout for this other worker to release the lock
						Set timeout=$select(Timeout=0:$$$LockTimeout,1:Timeout)
						Continue
					} Else {
						Set mastergroup=$system.Context.WorkMgr().MasterGroup
						If +mastergroup'=0,$$GroupJob^%SYS.WorkQueueMgr(mastergroup)=$piece(job,":") {
							#; If we are a worker and our master process is the one that owns the lock we do not need to lock it at all
							Return $$$OK
						}
					}
				}
				If Timeout=0 {
					#; If we do not want a timeout and we have details on job with the lock return error
					#; If job="" then process that held the lock may have released it so try again for very short period of time
					Quit 
				}
			}
			Set timeout=$select(Timeout=0:0.00001,1:Timeout)
		} Else {
			#; Exit the loop and report an error
			Quit
		}
	}
	If job'="" Quit $$$ERROR($$$CanNotLockRoutineInfo,Name,user,job)
	Quit $$$ERROR($$$CanNotLockRoutine,Name)
Error Set $zt=""
	Quit $$$ERROR($$$CacheError,$zerror)
}

ClassMethod UnLock(Global, Subscript, IModeLock = 0) As %Status [ Internal ]
{
 s $zt="Error"
 Set ns=$$$GBLDBREF(Global,Subscript)
 Set global="^|"_$$$QuoteName(ns)_"|"_Global_"("_$$$QuoteName(Subscript)_")"
 If IModeLock {
	Lock -@global#"I"
 } else {
	Lock -@global 
 }
 Quit $$$OK
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

ClassMethod DisplayToLogical(%val As %String) As %Library.Boolean [ Internal ]
{
 q $case($zcvt(%val,"U"),$$$GetMsg("%SYSTEM.Library","YES"):1,$$$GetMsg("%SYSTEM.Library","NO"):0,:0)
}

/// Passed a pattern match this returns an COS style pattern and a start and stop point.
ClassMethod Generate(Mask As %String, ByRef Begin As %String, ByRef End As %String, ByRef Pattern As %String, Flag As %Integer) [ Internal ]
{
 #; Mask      - Input,  Wildcard specification
 #; Begin       - Output, AZ style start
 #; End       - Output, AZ style end
 #; Pattern  - Output, Generated pattern
 #; Flag      - Input,  Control flags

 #; Handle A:Z style masks
 If Flag\2#2,Mask[":" Set Begin=$P(Mask,":",1),End=$P(Mask,":",2),Pattern="" Quit

 #; Double up the quotes
 For i=$L(Mask,"""")-1:-1:1 Set Mask=$p(Mask,"""",1,i)_""""""_$p(Mask,"""",i+1,*)

 #; Regular wildcards
 For  Quit:Mask'["**"  Set Mask=$p(Mask,"**",1)_"*"_$p(Mask,"**",2,*)
 Set (Pattern,tPart)="",Begin=$p($TR(Mask,"*?","**"),"*")
 For i=1:1:$Length(Mask) Do
 . If "*?"[$Extract(Mask,i) Do  Quit
 . . If tPart]"" Set Pattern=Pattern_"1"""_tPart_"""",tPart=""
 . . If $Extract(Mask,i)="?" Do  Quit
 . . . Set n=1 For i=i:1:$Length(Mask)-1 Quit:$Extract(Mask,i+1)'="?"  Set n=n+1
 . . . Set Pattern=Pattern_n_"E"
 . . If $Extract(Mask,i)="*" Set Pattern=Pattern_".E" Quit
 . Set tPart=tPart_$E(Mask,i)
 If tPart]"" Set Pattern=Pattern_"1"""_tPart_"""",tPart=""
 If Flag#2=0,Begin_"*"=Mask Set Pattern=""
 Set End=Begin
 Quit
}

ClassMethod LogicalToDisplay(%val As %Library.Boolean) As %String [ Internal ]
{
 q $case(%val,1:$$$GetMsg("%SYSTEM.Library","Yes"),0:$$$GetMsg("%SYSTEM.Library","No"),:%val)
}

/// Returns whether the passed name matches the Pattern array
ClassMethod Matches(Name As %String, ByRef Patterns As %String) As %Boolean [ Internal ]
{
 s Status=0
 s i=$O(Patterns(0,""),1,Work)
 While i'="" {
 	s Pattern=$List(Work),Start=$List(Work,2),End=$List(Work,3)
 	#;The Range STC4:STC5 used to be able to return a global named STC54!
 	i (Pattern'=""&&(Name?@Pattern))||((Start']Name)&&(Name']End)) {
#;If here we have a match on the pattern. Now see if we match any of the
#;"not" patterns If so, set the status back to 0 and get out
		s Status=1
 		s j=$O(Patterns(1,""),1,Work)
 		While j'="" {
 			s Pattern=$List(Work),Start=$List(Work,2),End=$List(Work,3)
 			i (Pattern'=""&&(Name?@Pattern))||((Start']Name)&&(Name']End)) {
				s Status=0
		 		Quit
 			}
 			Set j=$Order(Patterns(1,j),1,Work)
 		}
 		Quit
 	}
 	Set i=$Order(Patterns(0,i),1,Work)
 }
 q Status
}

/// Parses a passed mask into a series of patterns in an array.<br>
/// The resulting array can be passed to the $SYSTEM.Library.Pattern.Matches
/// function along with a Name to determine if the name matches the mask.
/// <br><br>
/// The passed in mask may be a series of masks, each separated by a comma.
/// Valid masks are as follows:
/// <br>
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
ClassMethod Parse(Masks As %String, ByRef Patterns As %String) [ Internal ]
{
 k Patterns
 f i=1:1:$l(Masks,",") {
 	s Mask=$ZStrip($p(Masks,",",i),"<>W")
 	i $e(Mask)="'" {
	 	s Not=1
	 	s Mask=$e(Mask,2,$l(Mask))
 	} else {
	 	s Not=0
 	}
 	d ..Generate(Mask,.Start,.End,.Pattern,3)
	i Not {
 		s Patterns(1,$o(Patterns(1,""),-1)+1)=$lb(Pattern,Start,End)
	} else {
 		s Patterns(0,$o(Patterns(0,""),-1)+1)=$lb(Pattern,Start,End)
	}
 }
}

/// Check whether the input mask has wildcards specified.
/// Return TRUE if there is wildcard otherwise return FALSE.
ClassMethod Wildcards(Mask As %String = "*") As %Boolean [ Internal ]
{
#; Wildcard if mask is '*'.
 q:Mask="*" 1
 d ..Parse(Mask,.pat)
#; Assume thete is no wildcard.
 s rc=0,id=""
 for {
	 s id=$o(pat(0,id))
	 q:id=""
	 s pat=$li(pat(0,id),1)
#; It is wildcard if it is not like 1"globalname".
	 i pat=""!($e(pat,1,2)'="1""")!($l(pat,"""")'=3)!($e(pat,$l(pat))'="""") s rc=1 q
 }
 q rc
}

/// Returns a list of the Globals in a Cache database<br>
/// <br>
/// <b>Parameters:</b> <br>
/// Directory  -  the directory file-spec for a Cache database file (cache.dat). <br>
/// System  -  ECP database server logical name, as defined in the Application Server list.<br>
/// Mask  -  a mask, or comma-separated list of masks, to select globals. Default is "*" for all.<br>
/// SystemGlobals  -  boolean flag to include system globals in the results. Default is "0".<br>
/// Index  -  Internal use only.<br>
/// IgnoreHasData - For faster list of Globals set this to 1 and the HasData column will always be FALSE.<br>
/// <br>
/// Valid masks are as follows:
/// <br>
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
Query DirectoryList(Directory As %String, System As %String, Mask As %String, SystemGlobals As %Boolean, Index As %Integer, IgnoreHasData As %Boolean = 0) As %Query(ROWSPEC = "Name:%String,ResourceName:%String,Permission:%String,Empty:%String,Keep:%String,Collation:%String,PointerBlock:%String,GrowthBlock:%String,HasData:%Boolean,Journal:%String") [ SqlProc ]
{
}

ClassMethod DirectoryListExecute(ByRef qHandle As %Binary, Directory As %String, System As %String = "", Mask As %String = "*", SystemGlobals As %Boolean = 0, Index As %Integer = 0, IgnoreHasData As %Boolean = 0) As %Status [ Internal ]
{
#define LocalSystem "LocalSystem"
 s $zt="DirectoryListExecuteE"
 i Index=0 { 
	s Index=$i($$$ISCQUERYTEMP)
 }
 s SuperMask=Mask
 i 'SystemGlobals {
	i $zcvt(Directory,"L")=$zcvt($zu(12),"L") {
		s SuperMask=Mask_$$$PercentSYSSystemGlobalList
	} else {
		s SuperMask=Mask_$$$SystemGlobalList
	}
 }
 s:$e(Directory,1,2)="^^" Directory=$e(Directory,3,$l(Directory))
#;SML965+  ; Use the new GetDatabaseInfo and GetGlobalDIrectoryInfo to get the directory.
 s:System="" System=$$$LocalSystem
 if System=$$$LocalSystem {
	 s:Directory="^" Directory="~"
	 s remsys=""
	 s NSP=$s(Directory="~":"^",1:"^^"_Directory)
 } Else {
	 s remsys=System
	 s NSP="^"_System_"^"_Directory
 }
 s rc=$$GetDatabaseInfo^%SYS.DATABASE(NSP,.dbinfo)
 i $$$ISERR(rc) Quit rc
 s oldval=$zu(68,7,0)
 k ^||DirectoryList
 s save=$name(^||DirectoryList)
 d $zu(68,7,oldval)
 s rc=$$GetGlobalDirectoryInfoFromDBInfo^%SYS.DATABASE(NSP,dbinfo,save,.tally,0)
 i $$$ISERR(rc) Quit rc
 s ResourceName=$$$getresource(dbinfo)
 d 
 . n $roles s $roles=""
 . s Permission=$tr($$$PermissionLogicalToDisplay($System.Security.Users.ResourcePermissionGet(ResourceName)),"U","")
 s ReadOnly=$Case($$$readonlyattrib(dbinfo),0:0,:1)
 i 'ReadOnly s ReadOnly=$$$readonlystatus(dbinfo)
 i ReadOnly s Permission=$tr(Permission,"W","")
 s Journal=..LogicalToDisplay($s($zb(+$p(dbinfo,",",$$$attribpiece),+$zu(40,8,23),1):0,1:1))
 i SuperMask'="*" d ..Parse(SuperMask,.Patterns)
 #; Get an array with the collation numbers/names
 s st=##class(%Collate).MakeArray(.ColName,0,1,2)
 S NextName=""
 For  S NextName=$o(^||DirectoryList(NextName)) Q:NextName=""  D
 . i SuperMask'="*" q:'..Matches(NextName,.Patterns)
 . s dirinfo=^||DirectoryList(NextName)
 . s PointerBlock=$p(dirinfo,"^",3)
 . s GrowthBlock=$p(dirinfo,"^",2)
 . s Collation=$G(ColName(+$p(dirinfo,"^",5)))
 . s IsKeep=..LogicalToDisplay($Case($zb(+$p(dirinfo,"^",4),$zu(40,0,57),1),$zu(40,0,57):1,:0))
 . s GName=$s(Directory="~":"^||",1:"^|""^"_remsys_"^"_Directory_"""|")_NextName
#;In some older version of %GD, checking to see if the global had data in it using $D(GNAME)
#;was a performance hole (possibly across the network). 
#;So we decided to base the check on the Pointer block being = 0.
#;However, the Kill code does not set the Pointer Block to 0 when the global is killed,
#;so it is not quite accurate, so we switched back to use the $D method. When the kill code
#;gets updated, we can change this back to look at the pointer block.
 . ;s IsEmpty=$case(PointerBlock,0:..LogicalToDisplay(1),:..LogicalToDisplay(0))
#;SML1073 ; Don't check $D() of the global if it is asked to ignore it.
 . s HasData=$s(IgnoreHasData:0,1:$d(@GName)'=0)
 . s IsEmpty=..LogicalToDisplay('HasData)
 . s $$$ISCQUERYTEMP(Index,System,Directory,NextName)=$lb(NextName,ResourceName,Permission,IsEmpty,IsKeep,Collation,PointerBlock,GrowthBlock,HasData,Journal)
 Close 63
 k ^||DirectoryList
#;qHandle=index^system^directory^name
 s qHandle=Index_"^"_System_"^"_Directory_"^"
 q $$$OK
#;SML965-
DirectoryListExecuteE s $zt=""
 c 63
#;Put the error message back into the list of globals we return so the user can see we
#;got some sort of error. If this occurs, there is probably some sort of database degrade
 s $$$ISCQUERYTEMP(Index,System,Directory,"ZZ"_$ze)=$lb("ZZ"_$ze,ResourceName,Permission,IsEmpty,IsKeep,Collation,PointerBlock,GrowthBlock,IsEmpty)
#;qHandle=index^system^directory^name
 s qHandle=Index_"^"_System_"^"_Directory_"^"
 Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod DirectoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 	s Index=$p(qHandle,"^",1)
 	s System=$p(qHandle,"^",2)
 	s Directory=$p(qHandle,"^",3)
 	s Name=$p(qHandle,"^",4,999)
	s Name=$o($$$ISCQUERYTEMP(Index,System,Directory,Name),1,Row)
	i Name="" s AtEnd=1,Row=""
	s qHandle=Index_"^"_System_"^"_Directory_"^"_Name
	Quit $$$OK
}

ClassMethod DirectoryListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DirectoryListExecute ]
{
 s Index=$p(qHandle,"^",1)
 k $$$ISCQUERYTEMP(Index)
 Quit $$$OK
}

/// Returns a list of the Globals in a Cache NameSpace (used for GUI display)<br>
/// <br>
/// <b>Parameters:</b> <br>
/// NameSpace  -  a Cache namespace. Default is current namespace. <br>
/// Mask  -  a mask, or comma-separated list of masks, to select globals. Default is "*" for all.<br>
/// SystemGlobals  -  boolean flag to include system globals in the results. Default is "0".<br>
/// UnavailableDatabases  -  a returned local array of any databases not currently accessible, i.e. array(name)=status.<br>
/// Index  -  Internal use only.<br>
/// IgnoreHasData - For faster list of Globals set this to 1 and the HasData column will always be FALSE.<br>
/// <br>
/// Valid masks are as follows:
/// <br>
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
Query MoveGlobalsList(NameSpace As %String, Mask As %String, SystemGlobals As %Boolean, ByRef UnavailableDatabases As %String, Index2 As %Integer, IgnoreHasData As %Boolean = 0) As %Query(ROWSPEC = "Name:%String,Database:%String,Directory:%String,HasSubscripts:%Boolean,Info:%String,Status:%Integer,MoveName:%String,Abort:%Integer,State:%Integer,StopQ:%Boolean,RestartQ:%Boolean,DeleteQ:%Boolean,RollbackQ:%Boolean,LogQ:%Boolean") [ SqlProc ]
{
}

ClassMethod MoveGlobalsListExecute(ByRef qHandle As %Binary, NameSpace As %String = {$zu(5)}, Mask As %String = "*", SystemGlobals As %Boolean = 0, ByRef UnavailableDatabases As %String, Index2 As %Integer = 0, IgnoreHasData As %Boolean = 0) As %Status [ Internal ]
{
 s $zt="MoveGlobalsExecuteE"
 $$$AddAllRoleTemporary
 s OldNS=$namespace
 s $namespace="%SYS"
 s Rset = ##class(%ResultSet).%New("DataMove.Data:List")
 s Status=Rset.Execute("*",NameSpace)
 i $$$ISERR(Status) q Status
 while Rset.Next() {
#;Filter out the ones we don't want to include in the display
	s Rset1 = ##class(%ResultSet).%New("DataMove.Data:ListGlobals")
 	s Status=Rset1.Execute(Rset.Data("Name"))
 	i $$$ISERR(Status) q
 	s Count=0 
 	s IsRunning=##Class(DataMove.Data).IsRunningCM(Rset.Data("Name"))
 	i '$$$ISOK(Status) ;^^^^^^^
#;This query is in descending order by time (most recent first), so don't overwrite a previous entry.
	while Rset1.Next() {
		i $d(Globals($P(Rset1.Data("Global"),"("),Rset1.Data("Global"))) continue
 		s Info=""
 		s State=Rset.Data("State")
 		i State=$$$Size s Info="Move in progress, calculating size"
 		i State=$$$Copy {
	 		s Info=$$$Text("Move in progress,")_" "
			s Info=Info_Rset1.Data("MBCopied")_"/"_Rset1.Data("MBToCopy")_" "_"MB copied"  ;_" "_Rset1.Data("PctCopied")_"%"
 		}
 		i State=$$$JrnApply {
	 		s Info=$$$Text("Processing journal") ;^^^^_" "_Rset.Data("JRNMBToRestore")_" "_$$$Text("MB to go")
 		}
 		;i State=$$$TranOpen s Info=$$$Text("Waiting for transactions")
 		i State=$$$CPFUpdate s Info=$$$Text("Updating CPF File")
 		i State=$$$CPFUpdateDone s Info=$$$Text("CPF file updated")
 		i State=$$$NSPActivate s Info=$$$Text("Activating namespaces")
 		i State=$$$NSPActivateDone s Info=$$$Text("Namespaces Activated")
 		i State=$$$DeleteSrcGlobals s Info=$$$Text("Deleting old data")
 		i State=$$$Rollback s Info=$$$Text("Rolling back moved data")
		s Stop=+Rset.Data("Stop")
		i Stop s Info=Info_", "_$$$Text("Stop signaled")
		s Status=+Rset.Data("Status")
 		i Status'=1 s Info=Info_", "_$$$Text("Error moving global")
  		i 'IsRunning s Info=Info_" - "_$$$Text("Stopped")
  		i State=$$$NotStarted s Info=$$$Text("Move queued")
#;Now get the links which are enabled
		s Status=..LinksEnabled(IsRunning, State, Status, .StopQ,.RestartQ,.DeleteQ,.RollbackQ,.LogQ)
		i '$$$ISOK(Status) ;^^^^^^
#;Offset is 9 for State, see below
 		s Globals($P(Rset1.Data("Global"),"("),Rset1.Data("Global"))=$lb(Rset1.Data("Global"),Rset1.Data("DstDB"),Rset1.Data("DstDir"),1,Info,Rset.Data("Status"),Rset.Data("Name"),Rset.Data("Stop"),Rset.Data("State"),StopQ,RestartQ,DeleteQ,RollbackQ,LogQ)
	}	
 }
 
 k Rset1
 k Rset
 s $namespace=OldNS
 s Index1=0
 s Index=$i($$$ISCQUERYTEMP)
 s Rset = ##class(%ResultSet).%New("%SYS.GlobalQuery:NameSpaceList")
 s Status=Rset.Execute(NameSpace,Mask,SystemGlobals,Index2,IgnoreHasData)
 i $$$ISERR(Status) q Status
 s StopQ=0
 s RestartQ=0
 s LogQ=0
 s DeleteQ=0
 s Index1=0
 while Rset.Next() {
	s Index1=Index1+1
	s Status=##Class(Config.Databases).DatabasesByDirectory("",Rset.Data("Location"),.DBList)
	i $$$ISOK(Status) {
		s DBName=$lg(DBList,1)
	} else {
		s DBName=""
	}
	s Name=Rset.Data("Name")
	i Name[":" {
		s Sub1=$p($p(Name,":"),"(",2)
		s Sub2=$p($p(Name,":",2),")")
		i Sub1=Sub2 {
			s Name=$p(Name,":")_")"
		} else {
			s Name=$p(Name,":")_"):("_$p(Name,":",2)
		}
	}
	s $$$ISCQUERYTEMP(Index,Index1)=$lb(Name,DBName,Rset.Data("Location"),Rset.Data("HasSubscripts"),"",1,"",0,1,StopQ,RestartQ,DeleteQ,RollbackQ,LogQ)
 	i Rset.Data("Name")'["(" {
 		i $d(Globals(Rset.Data("Name"))) {
	 		s Node=""
	 		f  {
		 		s Node=$o(Globals(Rset.Data("Name"),Node),1,Data) q:Node=""
#;State is offset #9, see above 
 				s State=$li(Data,9)
 				i State=$$$Done continue
				;i Status=$$$Crashed continue
				;i Status=$$$Abort continue

 				s Index1=Index1+1
 
 				s $$$ISCQUERYTEMP(Index,Index1)=Globals(Rset.Data("Name"),Node)
	 		}
 		}
 	}	
 }
 s qHandle=Index_"^"
 q $$$OK
MoveGlobalsExecuteE s $zt=""
 i $d(OldNS) s $namespace=OldNS
 i $d(Index) k $$$ISCQUERYTEMP(Index)
 d BACK^%ETN
 Quit $$$ERROR($$$CacheError,$Zerror)
}

ClassMethod MoveGlobalsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 s Index=$p(qHandle,"^",1)
 s Index1=$p(qHandle,"^",2)
 s Index1=$o($$$ISCQUERYTEMP(Index,Index1),1,Row)
 i Index1="" s AtEnd=1,Row="" q $$$OK
 s qHandle=Index_"^"_Index1
 Quit $$$OK
}

ClassMethod MoveGlobalsListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MoveGlobalsListExecute ]
{
 s Index=$p(qHandle,"^",1)
 k $$$ISCQUERYTEMP(Index)
 Quit $$$OK
}

ClassMethod LinksEnabled(IsRunning As %Boolean, State As %Integer, Status As %Status, ByRef StopQ As %Boolean = 0, ByRef RestartQ As %Boolean = 0, DeleteQ As %Boolean = 0, RollbackQ As %Boolean = 0, LogQ As %Boolean = 0) As %Status [ Internal ]
{
 s $zt="Error"
 #if 0

 ;<!--disable looking at the log if Done, or NotStarted-->
 ;<condition colName="State" predicate="EQ" value="1" cellStyle="disabled" targetCol="Log"/>
 ;<condition colName="State" predicate="EQ" value="2" cellStyle="disabled" targetCol="Log"/>
 ;<!--Enable Delete if not started. If the user Stoped, disable delete-->
 ;<condition colName="State" predicate="EQ" value="2" cellStyle="enabled" targetCol="Delete"/>
 ;<condition colName="Stop"  predicate="EQ" value="1" cellStyle="disabled" targetCol="Delete"/>
 ;<condition colName="Status" predicate="EQ" value="1" cellStyle="disabled" targetCol="Delete"/>
 ;<!--Allow Stop if Size (3),Copying(4),JrnApply(5)-->
 ;<condition colName="State" predicate="EQ" value="1" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="2" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="6" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="7" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="8" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="9" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="10" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="State" predicate="EQ" value="11" cellStyle="disabled" targetCol="Stop"/>
 ;<condition colName="Status" predicate="NEQ" value="1" cellStyle="disabled" targetCol="Stop"/>
#endif 
 i State=$$$Done q $$$OK
 i State=$$$NotStarted {
	 s DeleteQ=1
	 q $$$OK
 }
#;Anything after this can display the log
 s LogQ=1
 i (State=$$$Size)||(State=$$$SizeDone)||(State=$$$Copy)||(State=$$$CopyDone)||(State=$$$JrnApply)||(State=$$$JrnApplyDone)||(State=$$$CPFUpdate)||(State=$$$CPFUpdateDone) {
	i IsRunning {
		s StopQ=1
	} else {
		;s DeleteQ=1
		s RestartQ=1
		s RollbackQ=1
	}
 }
 i (State=$$$NSPActivate) {
	i 'IsRunning {
	 ;^^^This is bad
	}
	 q $$$OK
 }
 i (State=$$$NSPActivateDone)||(State=$$$DeleteSrcGlobals)||(State=$$$Rollback) {
	 i 'IsRunning {
	 	s RestartQ=1
	 	q $$$OK
	 }
 }
 Quit $$$OK
Error s $zt=""
 d BACK^%ETN
 Quit $$$ERROR($$$CacheError,$Zerror)
}

/// Returns a list of the Globals in a Cache NameSpace (used for GUI display)<br>
/// <br>
/// <b>Parameters:</b> <br>
/// NameSpace  -  a Cache namespace. Default is current namespace. <br>
/// Mask  -  a mask, or comma-separated list of masks, to select globals. Default is "*" for all.<br>
/// SystemGlobals  -  boolean flag to include system globals in the results. Default is "0".<br>
/// UnavailableDatabases  -  a returned local array of any databases not currently accessible, i.e. array(name)=status.<br>
/// Index  -  Internal use only.<br>
/// IgnoreHasData - For faster list of Globals set this to 1 and the HasData column will always be FALSE.<br>
/// Mapped - Return all mapped global nodes when set to 1, the default value of this parameter is 1.
/// <br>
/// Valid masks are as follows:
/// <br>
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
Query NameSpaceList(NameSpace As %String, Mask As %String, SystemGlobals As %Boolean, ByRef UnavailableDatabases As %String, Index As %Integer, IgnoreHasData As %Boolean = 0, Mapped As %Boolean = 1) As %Query(ROWSPEC = "Name:%String,Location:%String,ResourceName:%String,Permission:%String,Empty:%String,Keep:%String,Collation:%String,PointerBlock:%String,GrowthBlock:%String,HasData:%Boolean,Journal:%String,LockLocation:%String,HasSubscripts:%Boolean") [ SqlProc ]
{
}

ClassMethod NameSpaceListExecute(ByRef qHandle As %Binary, NameSpace As %String = {$zu(5)}, Mask As %String = "*", SystemGlobals As %Boolean = 0, ByRef UnavailableDatabases As %String, Index As %Integer = 0, IgnoreHasData As %Boolean = 0, Mapped As %Boolean = 1) As %Status [ Internal ]
{
#define LocalSystem "LocalSystem"
#define UnknownSystem "UnknownSystem"
#define DIRSLASH $s($$$ISUNIX:"/",$$$ISVMS:"]",$$$ISWINDOWS:"\",1:"")
 s $zt="NameSpaceListExecuteE"
 k UnavailableDatabases
 s Index2=$i($$$ISCQUERYTEMP)
 s Index1=$i($$$ISCQUERYTEMP)
 i Index=0 { 
	s Index=$i($$$ISCQUERYTEMP)
 }
 #;SML1764+
 i $e(NameSpace)'="^" {
	 s NameSpace=$zcvt(NameSpace,"U")
	 if 'Mapped {
		 #; If don't return mapped global then it would work like DirectoryList query.
		 s sysdir=##class(%SYS.Namespace).GetGlobalDest(NameSpace)
		 #; exit if it is a bad namespace.
		 if sysdir="" goto Exit
		 #; treat this as a directory namespace.
		 s NameSpace="^"_sysdir
	 }
 }
 #;SML1764-
#; First handle an implied namespace.
 i $e(NameSpace)="^" {
#if 0 ;JO1844+
	s System=$p(NameSpace,"^",2) i System="" s System=$$$LocalSystem
	s Directory=$p(NameSpace,"^",3)
#else ;JO1844=
    if NameSpace="^" {
	    ; Looking for private globals
	    s System=$$$LocalSystem
	    s Directory="^"
	    s SystemGlobals=0
    } else {
	   s System=$p(NameSpace,"^",2) i System="" s System=$$$LocalSystem
	   s Directory=$p(NameSpace,"^",3)
	}
#endif ;JO1844-
#; Get the globals in the current default database which pass
#; the mask passed in.
 	Set Rset = ##class(%ResultSet).%New("%SYS.GlobalQuery:DirectoryList")
 	s Status=Rset.Execute(Directory,System,Mask,SystemGlobals,Index2,IgnoreHasData)
 	i $$$ISERR(Status) {
	 	i System=$$$LocalSystem {
	 		s UnavailableDatabases(Directory)=Status
	 	} else {
	 		s UnavailableDatabases("\\"_System_"\"_Directory)=Status
		}		 	
 	} else {
#; Merge in the result before the query is killed
 		m $$$ISCQUERYTEMP(Index1)=$$$ISCQUERYTEMP(Index2)
 	}
 	d Rset.Close()
#;Now get the % Globals in the MGR database and merge them in. Note
#;that we can't use the mask at this point, we have to do it below
#;so we don't get extra stuff (i.e. non-percent) added in.
	i SystemGlobals {
 		Set Rset = ##class(%ResultSet).%New("%SYS.GlobalQuery:DirectoryList")
 		s Status=Rset.Execute($zu(12),$$$LocalSystem,"%*",SystemGlobals,Index2,IgnoreHasData)
 		i $$$ISERR(Status) {
 			s UnavailableDatabases(Directory)=Status
 		} else {
#; Merge in the result before the query is killed
 			m $$$ISCQUERYTEMP(Index1)=$$$ISCQUERYTEMP(Index2)
 		}
 		d Rset.Close()
	}
 	d ..Parse(Mask,.Patterns)
 	s System=$o($$$ISCQUERYTEMP(Index1,""))
 	while (System'="") {
		s Directory=$o($$$ISCQUERYTEMP(Index1,System,""))
		while (Directory'="") {
			s Global=$o($$$ISCQUERYTEMP(Index1,System,Directory,""),1,Row)
			while (Global'="") {
 				i ..Matches(Global,.Patterns) {
					s $$$ISCQUERYTEMP(Index,Global)=$lb($li(Row,1),$case(System,$$$LocalSystem:"",:"\\"_System_"\")_Directory)_$li(Row,2,10)_$lb(Directory)_$lb(0 /* HasSubscripts */)
 				}
				s Global=$o($$$ISCQUERYTEMP(Index1,System,Directory,Global),1,Row)
			}
			s Directory=$o($$$ISCQUERYTEMP(Index1,System,Directory))
		}
	 	s System=$o($$$ISCQUERYTEMP(Index1,System))
 	}
 	g Exit
 }
#; Now handle a real namespace.
 i 'SystemGlobals {
 	i NameSpace="%SYS" {
 		 s SuperMask=Mask_",'%a:%z"
 	} else {
 		i (NameSpace="%CACHELIB") {
 			 s SuperMask=Mask_",'%:%Z"
 		} else {
 			 s SuperMask=Mask_",'%a:%z,'%:%Z"
 		}
 	}
 } else {
	 s SuperMask=Mask
 }
#;SML1565+
 #;Get the namespace information and save the original nsgennum.
 #; If later nsgennum is changed then we have to start it over.
 #; If the namespace is removed in the middle of processing, we
 #; need to handle it to return without any information.
Retry ;
 kill $$$ISCQUERYTEMP(Index)
 s nspinfo=$zu(90,28,2,NameSpace)
 if nspinfo="" goto Exit
 s oldnsgennum=$p(nspinfo,"|",6)
 k gxlatinfo
 do getgxlatarray^%SYS.GXLINFO(.nspinfo,"",.gxlatinfo,0)
 #; Oops, the namespace is removed.
 if '$d(gxlatinfo) goto Exit
 #; Retry when the namespace is changed.
 if $p(nspinfo,"|",6)'=oldnsgennum goto Retry
 s num=$o(gxlatinfo(""),1,gxaltinfo)
 while (num'="") {
	s pat=$list(gxaltinfo,1)
	s EntryInfo=$list(gxaltinfo,2)
	s slmtab=$list(gxaltinfo,3)
#; First, get all the implicit mappings
	s indx=$p(EntryInfo,"|",3),indx2=$p(EntryInfo,"|",6)
	s DirectoryIndex(indx)=indx
	s DirectoryIndex(indx2)=indx2
#; Now see if any % globals are mapped that match the mask
	i $e(pat)="%" {
	  s wildpat=$Case(indx=indx2,1:1,:0)
	  for mi=1:1:$l(Mask,",") {
		s Maskx=$p(Mask,",",mi)
		if ($e(Maskx)="%" || ($e(Maskx)="*")) {
			i $e(Maskx,$l(Maskx))="*" s mask=$e(Maskx,1,$l(Maskx)-1),wildmask=1
			e  s wildmask=0,mask=Maskx
			s masklen=$l(mask),patlen=$l(pat),match=0
			i patlen < masklen {
				i wildpat && ($e(pat,1,patlen)=$e(mask,1,patlen)) s match=1
			}
			i patlen > masklen {
				i wildmask && ($e(pat,1,masklen)=$e(mask,1,masklen)) s match=1
			}
			i patlen=masklen {
				i pat=mask s match=1
			}
			i match {
				i wildpat s pat=pat_"*"
				i 'indx {
					s PercentDirs(indx)=""
					quit
				} else {
					s dirpat=$zu(90,7,indx),mgrdir=$zu(12)
					i dirpat'=mgrdir {
						i $$$ISVMS s libdir=$e(mgrdir,1,$l(mgrdir)-1)_".CACHELIB]"
						e  s libdir=$zu(12)_"cachelib"_$$$DIRSLASH
						i dirpat'=libdir s PercentDirs(indx)="" quit
					}
				}
			}
		}
	  }
	}
#; Now get the replication mappings
	f i=2,5 {
		s RepDirs=..DecodeReplication($p(EntryInfo,"|",i))
		f j=1:1 {
			s RepDir=+$p(RepDirs,",",j)
			q:RepDir=0  
			s DirectoryIndex(RepDir)=RepDir
		}
	}
#; Now get the SLM and SLM Replication directories
	i slmtab'="" {
		s NumSlmMapEntries=$p($li(slmtab,1),"|",1)
		f i=0:1:NumSlmMapEntries-1 {
			s RedirectionPattern=$li(slmtab,i*2+3)
			s DirectoryIndex(+$p(RedirectionPattern,"|",1))=+$p(RedirectionPattern,"|",1)
			s RepDirs=..DecodeReplication(+$p(RedirectionPattern,"|",2))
			f j=1:1 {
				s RepDir=+$p(RepDirs,",",j)
				q:RepDir=0  
				s DirectoryIndex(RepDir)=RepDir
			}
		}
 	}
	s num=$o(gxlatinfo(num),1,gxaltinfo)
 }
#; Add the default global Directory to it 
#; The default global Directory is processed last
 s DirectoryIndex(999999)=$p(nspinfo,"|",2)
#;SML1565-
#; Now for each Directory in the mapping, get all the globals from it
#; by calling the query. Skip over index 0 as it is a placeholder.
 s DirectoryIndex=$o(DirectoryIndex(0),1,Destination)
 while (DirectoryIndex'="") {
	s Directory=$zu(90,7,Destination)
	s System=$zu(90,6,Destination)
	i System=0 {
		s System=$$$LocalSystem
	} else {
		s System=$zu(63,4,System)
		i System="" s System=$$$UnknownSystem
	}
 	Set Rset = ##class(%ResultSet).%New("%SYS.GlobalQuery:DirectoryList")
 	s Status=Rset.Execute(Directory,System,SuperMask,SystemGlobals,Index2,IgnoreHasData)
 	i $$$ISERR(Status) {
	 	i System=$$$LocalSystem {
	 		s UnavailableDatabases(Directory)=Status
	 	} else {
	 		s UnavailableDatabases("\\"_System_"\"_Directory)=Status
		}		 	
 	} else {
#; Merge in the result before the query is killed
 		m $$$ISCQUERYTEMP(Index1)=$$$ISCQUERYTEMP(Index2)
		d Rset.Close()
#; Now find any %globals mapped from the namespace to this directory,
#; using Mask for the query instead of SuperMask
		i DirectoryIndex=999999 s indx=0
		e  s indx=DirectoryIndex
		i $d(PercentDirs(indx)) {
			s Index3=$i($$$ISCQUERYTEMP)
			Set Rset = ##class(%ResultSet).%New("%SYS.GlobalQuery:DirectoryList")
			s Status=Rset.Execute(Directory,System,Mask,SystemGlobals,Index3,IgnoreHasData)
			i '$$$ISERR(Status) m $$$ISCQUERYTEMP(Index1)=$$$ISCQUERYTEMP(Index3)
			d Rset.Close()
			k $$$ISCQUERYTEMP(Index3)
		}
 	}	 		
#;Now build defaults for globals which were not yet created in the databases
#;Note that we can't get defaults for remote globals
#;Default row contains the following:
#;"Location,ResourceName,Permission,Empty,Keep,Collation,PointerBlock,GrowthBlock,Journal"
	i System=$$$LocalSystem {
		s dbinfo=$$$dirinfo(Directory)
		i +dbinfo<0 {
			s DefaultRow(System,Directory)=$lb(Directory,"??","??",..LogicalToDisplay(1),"??","??","0","0","0","??")
		} else {
			s keep=$$$keepstate(dbinfo)
			s resource=$$$getresource(dbinfo)
			s coll=$p(dbinfo,",",$$$colpiece)
			s pntblk=$p(dbinfo,",",$$$gloptrpiece)
			s growblk=$p(dbinfo,",",$$$glogrpiece)
  			s Journal=..LogicalToDisplay($s($zb(+$p(dbinfo,",",$$$attribpiece),+$zu(40,8,23),1):0,1:1))
			s DefaultRow(System,Directory)=$lb(Directory,resource,$$$PermissionLogicalToDisplay($System.Security.Users.ResourcePermissionGet(resource)),..LogicalToDisplay(1),..LogicalToDisplay(keep),##Class(%Library.Collate).LogicalToDisplay(coll),pntblk,growblk,0,Journal)
		}
	} else {
		s DefaultRow(System,Directory)=$lb("\\"_System_"\"_Directory,"??","??",..LogicalToDisplay(1),"??","??","0","0","0","??")
	}
 	s DirectoryIndex=$o(DirectoryIndex(DirectoryIndex),1,Destination)
 }
#; Now get the default Directory and System for the namespace 
#;SML1565
 s DefaultDestination=+$p(nspinfo,"|",2)
 s DefaultDirectory=$zu(90,7,DefaultDestination)
 s DefaultSystem=$zu(90,6,DefaultDestination)
 i DefaultSystem'=0 {
	s DefaultSystem=$zu(63,4,DefaultSystem)
	i DefaultSystem="" s DefaultSystem=$$$UnknownSystem
 } else {
	s DefaultSystem=$$$LocalSystem
 }
#; Now that we have all the directories and globals in them, lets
#; check if the global maps to that Directory at the namespace level.
#; If it does not (i.e. we can't see it) then remove it from the list
 s System=$o($$$ISCQUERYTEMP(Index1,""))
 while (System'="") {
	s Directory=$o($$$ISCQUERYTEMP(Index1,System,""))
	while (Directory'="") {
		s Global=$o($$$ISCQUERYTEMP(Index1,System,Directory,""),1,Row)
		while (Global'="") {
#; First, see if there is a mapping which refers to this global
#;SML1565+
			s num=$o(gxlatinfo(""),1,gxlatinfo),EntryId=0
			while (num'="") {
				if Global']$li(gxlatinfo,1) {
					if Global=$li(gxlatinfo,1) {
						s EntryInfo=$li(gxlatinfo,2),slmtab=$li(gxlatinfo,3)
						if slmtab'=""||$p(EntryInfo,"|",2)||$p(EntryInfo,"|",3)||$p(EntryInfo,"|",4) {
							s EntryId=1
						}
						Quit
					}
					#; The Global collated lower.
					s num=$o(gxlatinfo(num),-1,gxlatinfo)
					if num="" Quit
					s EntryInfo=$li(gxlatinfo,2)
					if $p(EntryInfo,"|",5)||$p(EntryInfo,"|",6)||$p(EntryInfo,"|",7) {
						s EntryId=-1,slmtab=""
					}
					Quit
				}
				#; The Global collated higher.
				s num=$o(gxlatinfo(num),1,gxlatinfo)
			}
#; Now calculate where the lock for this global would go.
			s LockDestination=$s('EntryId:0,EntryId>0:$p(EntryInfo,"|",4),1:$p(EntryInfo,"|",7))
#;SML1565-
			i LockDestination=0 {
				s LockDirectory=DefaultDirectory
				s LockSystem=System
			} else {
				s LockDirectory=$zu(90,7,LockDestination)
				s LockSystem=$zu(90,6,LockDestination)
				i LockSystem'=0 {
					s LockSystem=$zu(63,4,LockSystem)
					i LockSystem="" s LockSystem=$$$UnknownSystem
				} else {
					s LockSystem=$$$LocalSystem
				}
			}
			s LockLocation=$case(LockSystem,$$$LocalSystem:"",:"\\"_LockSystem_"\")_LockDirectory
#; If there is no mapping or replication for this global, then it 
#; must explicitly go in the default database for the namespace. 
#; See if the directory and the system match. If so, create an 
#; entry for it.
			i EntryId=0 {
				i (DefaultDirectory=Directory),(DefaultSystem=System) {
					s $$$ISCQUERYTEMP(Index,Global)=$lb($li(Row,1),$case(DefaultSystem,$$$LocalSystem:"",:"\\"_DefaultSystem_"\")_DefaultDirectory)_$li(Row,2,10)_$lb(LockLocation,$s($li(Row,1)["(":1,1:0 /*HasSubscripts*/))
				}
				g Next	; Next global
			}
#; Now handle mapped globals which are not SLM mapped
			s Found=0
			k CacheTemp
			#;SML1565+
			i slmtab="" {
				s ImplicitDestination=$s('EntryId:0,EntryId>0:$p(EntryInfo,"|",3),1:$p(EntryInfo,"|",6))
			#;SML1565-
				i ImplicitDestination'=0 {
					s ImplicitDirectory=$zu(90,7,ImplicitDestination)
					s ImplicitSystem=$zu(90,6,ImplicitDestination)
					i ImplicitSystem'=0 {
						s ImplicitSystem=$zu(63,4,ImplicitSystem)
						i ImplicitSystem="" s ImplicitSystem=$$$UnknownSystem
					} else {
						s ImplicitSystem=$$$LocalSystem
					}
					i (ImplicitDirectory=Directory),(ImplicitSystem=System) {
						s $$$ISCQUERYTEMP(Index,Global)=$lb($li(Row,1),$case(ImplicitSystem,$$$LocalSystem:"",:"\\"_ImplicitSystem_"\")_ImplicitDirectory)_$li(Row,2,10)_$lb(LockLocation,$s($li(Row,1)["(":1,1:0 /*HasSubscripts*/))
						s Found=1
					} else {
						i $d($$$ISCQUERYTEMP(Index,Global))=0 s CacheTemp(Index,Global)=$lb($li(Row,1))_DefaultRow(ImplicitSystem,ImplicitDirectory)_$lb(LockLocation,$s($li(Row,1)["(":1,1:0 /*HasSubscripts*/))
					}
				}
				#;SML1565
				s ReplicationDestination=$s('EntryId:0,EntryId>0:$p(EntryInfo,"|",2),1:$p(EntryInfo,"|",5))
				i ReplicationDestination'=0 {
					s ReplicationDestinations=..DecodeReplication(ReplicationDestination)
					f j=1:1 {
						s ReplicationDestination=$p(ReplicationDestinations,",",j)
						q:ReplicationDestination=""
						s ReplicationDirectory=$zu(90,7,ReplicationDestination)
						s ReplicationSystem=$zu(90,6,ReplicationDestination)
						i ReplicationSystem'=0 {
							s ReplicationSystem=$zu(63,4,ReplicationSystem)
							i ReplicationSystem="" s ReplicationSystem=$$$UnknownSystem
						} else {
							s ReplicationSystem=$$$LocalSystem
						}
						i (ReplicationDirectory=Directory),(ReplicationSystem=System) {
							s $$$ISCQUERYTEMP(Index,Global_" Replicated")=$lb($li(Row,1)_" (Replicated)",$case(ReplicationSystem,$$$LocalSystem:"",:"\\"_ReplicationSystem_"\")_ReplicationDirectory)_$li(Row,2,10)_$lb(LockLocation,$s($li(Row,1)["(":1,1:0 /*HasSubscripts*/))
							s Found=1
						} else {
							i $d($$$ISCQUERYTEMP(Index,Global_" Replicated"))=0 s CacheTemp(Index,Global_" Replicated")=$lb($li(Row,1)_" (Replicated)")_DefaultRow(ReplicationSystem,ReplicationDirectory)_$lb(LockLocation,$s($li(Row,1)["(":1,1:0 /*HasSubscripts*/))
						}
					}
				}
				i Found m $$$ISCQUERYTEMP(Index)=CacheTemp(Index)
				g Next
			}
#;Now handle SLM mapped globals
#;SML1565
			s DefaultSlmDestination=$s('EntryId:0,EntryId>0:$p(EntryInfo,"|",3),1:$p(EntryInfo,"|",6))
			i DefaultSlmDestination'=0 {
				s DefaultSlmDirectory=$zu(90,7,DefaultSlmDestination)
				s DefaultSlmSystem=$zu(90,6,DefaultSlmDestination)
				i DefaultSlmSystem'=0 {
					s DefaultSlmSystem=$zu(63,4,DefaultSlmSystem)
					i DefaultSlmSystem="" s DefaultSlmSystem=$$$UnknownSystem
				} else {
					s DefaultSlmSystem=$$$LocalSystem
				}
			} else {
				s DefaultSlmDirectory=DefaultDirectory
				s DefaultSlmSystem=DefaultSystem
			}
			#;SML1565+
			s NumSlmMapEntries=$p($li(slmtab,1),"|",1)
		;^^	f i=0:1:NumSlmMapEntries-1 {
			f i=0:1:NumSlmMapEntries-2 {
				#;SML1565+
				s RedirPattern=$li(slmtab,i*2+3)
				s SlmDestination=$p(RedirPattern,"|",1)
				#;SML1565-
				i SlmDestination'=0 {
					s SlmDirectory=$zu(90,7,SlmDestination)
					s SlmSystem=$zu(90,6,SlmDestination)
					i SlmSystem'=0 {
						s SlmSystem=$zu(63,4,SlmSystem)
						i SlmSystem="" s SlmSystem=$$$UnknownSystem
					} else {
						s SlmSystem=$$$LocalSystem
					}
				} else {
					s SlmDirectory=DefaultSlmDirectory
					s SlmSystem=DefaultSlmSystem
				}
				;s Subscript="("_$case(i,0:"BEGIN",:$zu(90,17,SlmTableId,i))_":"_$case(i,NumSlmMapEntries-1:"END",:$zu(90,17,SlmTableId,i+1))_")"
#;Remove any trailing $c(1) so display is ok
#;SML1565+						
				s Subscript=$tr($case(i,0:"",NumSlmMapEntries-1:"",:"("_$li(slmtab,i*2+2)_":")_$case(i,0:"",NumSlmMapEntries-1:"",:$li(slmtab,i*2+4)_")"),$c(1),"")
#; Add the $c(0) here so it will collate before with any replication
				s CollateSubscript="("_$li(slmtab,i*2+2)_$c(0)
#;SML1565-
#;If we have the following mapping in the slm table:
#;  X 	        c:\141u1\mgr\user\
#; 	X(100:200) 	c:\141u1\mgr\newdata\
#; 	X(200:300) 	c:\141u1\mgr\user\ ------->remove this one
#;  X(300:400) 	c:\141u1\mgr\newdata\
#;  Then remove any mappings which map back to the default database (STC2201)
				i (SlmDirectory=DefaultSlmDirectory),(SlmSystem=DefaultSlmSystem),(Subscript'="") continue
				i (SlmDirectory=Directory),(SlmSystem=System) {
					s $$$ISCQUERYTEMP(Index,Global_CollateSubscript)=$lb(Global_Subscript,$case(SlmSystem,$$$LocalSystem:"",:"\\"_SlmSystem_"\")_SlmDirectory)_$li(Row,2,10)_$lb(LockLocation,$s(Subscript["(":1,1:0 /*HasSubscripts*/))
					s Found=1
				} else {
					i $d($$$ISCQUERYTEMP(Index,Global_CollateSubscript))=0 s CacheTemp(Index,Global_CollateSubscript)=$lb(Global_Subscript)_DefaultRow(SlmSystem,SlmDirectory)_$lb(LockLocation,$s(Subscript["(":1,1:0 /*HasSubscripts*/))
				}

				#;SML1565
				s SlmRepDestination=$p(RedirPattern,"|",2)
				i SlmRepDestination'=0 {
					s SlmRepDestinations=..DecodeReplication(SlmRepDestination)
					f j=1:1 {
						s SlmRepDestination=$p(SlmRepDestinations,",",j)
						q:SlmRepDestination=""
						s SlmRepDirectory=$zu(90,7,SlmRepDestination)
						s SlmRepSystem=$zu(90,6,SlmRepDestination)
						i SlmRepSystem'=0 {
							s SlmRepSystem=$zu(63,4,SlmRepSystem)
							i SlmRepSystem="" s SlmRepSystem=$$$UnknownSystem
						} else {
							s SlmRepSystem=$$$LocalSystem
						}
						;s Subscript="("_$case(i,0:"BEGIN",:$zu(90,17,SlmTableId,i))_":"_$case(i,NumSlmMapEntries-1:"END",:$zu(90,17,SlmTableId,i+1))_")"
#;Remove any trailing $c(1) so display is ok
#;SML1565+						
						s Subscript=$tr($case(i,0:"",NumSlmMapEntries-1:"",:"("_$li(slmtab,i*2+2)_":")_$case(i,0:"",NumSlmMapEntries-1:"",:$li(slmtab,i*2+4)_")"),$c(1),"")
#; Add the $c(1) here so replication collates after non-replication
						s CollateSubscript="("_$li(slmtab,i*2+2)_$c(1)
#;SML1565-
						i (SlmRepDirectory=Directory),(SlmRepSystem=System) {
							s $$$ISCQUERYTEMP(Index,Global_CollateSubscript)=$lb(Global_Subscript_" (Replicated)",$case(SlmRepSystem,$$$LocalSystem:"",:"\\"_SlmRepSystem_"\")_SlmRepDirectory)_$li(Row,2,10)_$lb(LockLocation,$s(Subscript["(":1,1:0 /*HasSubscripts*/))
							s Found=1
						} else {
							i $d($$$ISCQUERYTEMP(Index,Global_CollateSubscript))=0 s CacheTemp(Index,Global_CollateSubscript)=$lb(Global_Subscript_" (Replicated)")_DefaultRow(SlmRepSystem,SlmRepDirectory)_$lb(LockLocation,$s(Subscript["(":1,1:0 /*HasSubscripts*/))
						}
					}
				}
			}  ; End For i
			i Found m $$$ISCQUERYTEMP(Index)=CacheTemp(Index)
Next
			s Global=$o($$$ISCQUERYTEMP(Index1,System,Directory,Global),1,Row)
		}
		s Directory=$o($$$ISCQUERYTEMP(Index1,System,Directory))
	}
  	s System=$o($$$ISCQUERYTEMP(Index1,System))
 }
Exit
 k $$$ISCQUERYTEMP(Index1)
#;qHandle=index^name
 s qHandle=Index_"^"
 q $$$OK
NameSpaceListExecuteE s $zt="NameSpaceListExecuteEE"
 k $$$ISCQUERYTEMP(Index1)
 k $$$ISCQUERYTEMP(Index2)
 i $d(Index3) k $$$ISCQUERYTEMP(Index3)
NameSpaceListExecuteEE s $zt=""
 Quit $$$ERROR($$$CacheError,$Zerror)
}

ClassMethod NameSpaceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 	s Index=$p(qHandle,"^",1)
 	s Name=$p(qHandle,"^",2,999)
 	s Name=$o($$$ISCQUERYTEMP(Index,Name),1,Row)
 	i Name="" s AtEnd=1,Row="" q $$$OK
	s qHandle=Index_"^"_Name
	Quit $$$OK
}

ClassMethod NameSpaceListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = NameSpaceListExecute ]
{
 s Index=$p(qHandle,"^",1)
 k $$$ISCQUERYTEMP(Index)
 Quit $$$OK
}

/// Returns a list of Globals in a Cache NameSpace (used for terminal display)<br>
/// <br>
/// <b>Parameters:</b> <br>
/// NameSpace  -  a Cache namespace. Default is current namespace. <br>
/// Mask  -  a mask, or comma-separated list of masks, to select globals. Default is "*" for all.<br>
/// SystemGlobals  -  boolean flag to include system globals in the results. Default is "0".<br>
/// UnavailableDatabases  -  a returned local array of any databases not currently accessible, i.e. array(name)=status.<br>
/// Index  -  Internal use only.<br>
/// <br>
/// Valid masks are as follows:
/// <br>
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
Query NameSpaceListChui(NameSpace As %String, Mask As %String, SystemGlobals As %Boolean, ByRef UnavailableDatabases As %String, Index As %Integer) As %Query(ROWSPEC = "Name:%String,Location:%String,ResourceName:%String,Permission:%String,Empty:%String,Keep:%String,Collation:%String,Ptr:%String,Grth:%String,HasData:%Boolean,Jrn:%String,LockLocation:%String") [ SqlProc ]
{
}

ClassMethod NameSpaceListChuiExecute(ByRef qHandle As %Binary, NameSpace As %String = {$zu(5)}, Mask As %String = "*", SystemGlobals As %Boolean = 0, ByRef UnavailableDatabases As %String, Index As %Integer = 0) As %Status [ Internal ]
{
	q ..NameSpaceListExecute(.qHandle,NameSpace,Mask,SystemGlobals,.UnavailableDatabases,Index)
}

ClassMethod NameSpaceListChuiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
	q ..NameSpaceListFetch(.qHandle,.Row,.AtEnd)
}

ClassMethod NameSpaceListChuiClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = NameSpaceListExecute ]
{
	q ..NameSpaceListClose(.qHandle)
}

/// Returns the size of Globals in a Cache database<br>
/// <br>
/// <b>Parameters:</b> <br>
/// Directory  -  the directory file-spec for a Cache database file (cache.dat). <br>
/// System  -  Currently ignored, pass as a null string. Getting the size of a global in an
/// ECP mounted database is not currently supported. You can get the size for these globals directly
/// on the ECP server itself.<br>
/// Mask  -  a mask, or comma-separated list of masks, to select globals. Default is "*" for all.<br>
/// SystemGlobals  -  boolean flag to include system globals in the results. Default is "0".<br>
/// Index  -  Internal use only.<br>
/// FastFlag  -  Don't return 'Used' count, it would be zero. This is for faster operation.<br>
/// <br>
/// Valid masks are as follows:
/// <br>
/// ABC* - All strings starting with ABC<br>
/// A:D - All strings between A and D<br>
/// A:D,Y* - All strings between A and D, and all strings starting with Y<br>
/// A:D,'C* - All strings between A and D, except those starting with C
Query Size(Directory As %String, System As %String = "", Mask As %String, SystemGlobals As %Boolean, Index As %Integer, FastFlag As %Boolean) As %Query(ROWSPEC = "Name:%String,Allocated MB:%Float:Allocated (MB),Used MB:%Float:Used (MB)") [ SqlProc ]
{
}

ClassMethod SizeExecute(ByRef qHandle As %Binary, Directory As %String, System As %String = "", Mask As %String = "*", SystemGlobals As %Boolean = 0, Index As %Integer = 0, FastFlag As %Boolean = 0) As %Status [ Internal ]
{
#define LocalSystem "LocalSystem"
#define UnknownSystem "UnknownSystem"
 s $zt="SizeExecuteE"
 s System=$$$LocalSystem
 s Index1=$i($$$ISCQUERYTEMP)
 i Index=0 { 
	s Index=$i($$$ISCQUERYTEMP)
 }
 Set Rset = ##class(%ResultSet).%New("%SYS.GlobalQuery:DirectoryList")
#;SML1073 ; use faster global list.
 s Status=Rset.Execute(Directory,System,Mask,SystemGlobals,Index1,1)
 i $$$ISERR(Status) Quit Status
#; Merge in the result before the query is killed
 m $$$ISCQUERYTEMP(Index)=$$$ISCQUERYTEMP(Index1)
 d Rset.Close()
 s qHandle=Index_"^"_System_"^"_Directory_"^"_FastFlag_"^"
 q $$$OK
SizeExecuteE s $zt=""
 Quit $$$ERROR($$$CacheError,$Zerror)
}

ClassMethod SizeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 	s Index=$p(qHandle,"^",1)
	s System=$p(qHandle,"^",2)
	s Directory=$p(qHandle,"^",3)
	s FastFlag=$p(qHandle,"^",4)
	s Name=$p(qHandle,"^",5,999)
	s Name=$o($$$ISCQUERYTEMP(Index,System,Directory,Name),1,Row)
	i Name="" s AtEnd=1,Row="" quit $$$OK
 	s sc=##class(%GlobalEdit).GetGlobalSize(Directory,Name,.Allocated,.Used,FastFlag)
 	i $$$ISERR(sc) Quit sc
	e  s Row=$lb(Name,Allocated,$G(Used,0))
	s qHandle=Index_"^"_System_"^"_Directory_"^"_FastFlag_"^"_Name
	Quit $$$OK
}

ClassMethod SizeClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = SizeExecute ]
{
 s Index=$p(qHandle,"^",1)
 k $$$ISCQUERYTEMP(Index)
 Quit $$$OK
}

Storage GlobalStorage
{
<StreamLocation>^%SYS.GlobalQueryS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
