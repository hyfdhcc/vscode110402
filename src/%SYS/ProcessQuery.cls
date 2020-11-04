Include (%sySite, %syPidtab, %sySystem)

/// This class allows manipulation and display of Cache processes running on the system.<br>
/// An instance of the class can be opened by passing the PID (O/S process id) 
/// to the %OpenId Method. The PID is in decimal form ($J) for all platforms.<br><br>
/// NOTE: Previous versions of this class allowed you to call the %OpenId method
/// and pass in either a PID preceded by the letter "P", or a job number preceded
/// by the letter "J". This functionality has been removed from the %OpenId() method, 
/// and moved to the new Open() method which supports this syntax.<br><br>
/// For example, the following open a process with a PID of 2078:<br><br>
/// s Process=##CLASS(%SYS.ProcessQuery).%OpenId("2078")<br>
/// s Process=##CLASS(%SYS.ProcessQuery).Open("P2078")<br>
/// s Process=##CLASS(%SYS.ProcessQuery).Open("2078")<br><br>
/// The following will open Job number 23<br><br>
/// s Process=##CLASS(%SYS.ProcessQuery).Open("J23")<br><br>
/// Performance considerations:<br>
/// When you use %OpenId() to examine a process, several mailbox messages will get sent to 
/// the process to return ALL of the properties for the object. On systems with lots of processes
/// running, and you are collecting data for a lot of processes, this can cause a lot of overhead.
/// The call to each %OpenId() in this case may actually take several seconds to complete.
/// Most of a processes properties can be retrieved without the overhead of a mailbox message. See
/// the description of the individual properties below for which properties require a mailbox message
/// to be sent.<br>
/// If you want to minimize overhead, you should use an SQL statement to select ONLY the data
/// which you want returned. For example, here is some code which loops through all the processes
/// on the system, and retrieves specific data for each process. Note that the properties which 
/// are returned in this example are ones which do not require a mailbox messages to be sent to the
/// process being examined. Note that the %syPidtab.inc file needs to be included in your routine
/// in order for the following code to compile cleanly.<br><br>
/// #include %syPidtab<br>
/// Set Rset = ##class(%ResultSet).%New("%SYS.ProcessQuery:ListPids")<br>
/// d Rset.Execute()<br>
/// While Rset.Next() {<br>
/// 	&sql(SELECT CommandsExecuted,GlobalReferences INTO :CommandsExecuted,:GlobalReferences<br>
///   		FROM %SYS.ProcessQuery <br>
///    	WHERE Pid = :Rset.GetData(1))<br>
/// 	i SQLCODE'=0 w !,"SQL Error "_SQLCODE continue ; 100 means process does not exist (halted)<br>
/// 	w !,Rset.GetData(1)," ",CommandsExecuted," ",GlobalReferences<br>
/// }<br>
/// d Rset.Close()<br><br>
/// Security considerations:<br>
/// Any process can open an instance to their own process by passing the value of $J to
/// the %OpenId() method:<br><br>
/// s Process=##CLASS(%SYS.ProcessQuery).%OpenId($j)<br><br>
/// If you wish to open another process, you must own the %Admin_Manage:Use
/// resource, or have read or write access to the CACHESYS database. To minimize overhead in
/// the %OpenId() method, having the %Admin_Manage:Use privilege is recommended.<br>
/// This class has an SQL table called %SYS.ProcessQuery where you can execute an SQL
/// query to return process data. For example you could execute the following
/// queries:<br><br>
/// Select * from %SYS.ProcessQuery - Return all information about all processes<br>
/// Select * from %SYS.ProcessQuery where NameSpace = 'User" - Return all information about
/// all processes in the USER namespace.<br>
/// Note that in order to run this from an unprivileged user, you may need to grant privileges
/// to that user on the table as follows:<br><br>
/// GRANT SELECT ON %SYS.ProcessQuery TO _PUBLIC<br><br>
/// Notes:<br>
/// Replace _PUBLIC to a specific user or role name if you don't want everyone to have the privilege.<br>
/// This is per-namespace. This needs to be executed in each namespace the table needs to be queried from.<br>
Class %SYS.ProcessQuery Extends (%Persistent, %SYSTEM.Help) [ Inheritance = right, StorageStrategy = Process, System = 4 ]
{

Parameter DEFAULTCONCURRENCY = 0;

/*
---------------------Documentation------------------------------------
CDS2526 07/08/15 Chuck Sorenson, Add disk writes
CDS2451 12/23/14 Chuck Sorenson, Prevent loop in GetCurrentLineAndRoutine
STC2360 11/14/14 Steve Clay, Update %ER display to escape control characters
STC2325 08/29/14 Steve Clay, Add Roles, LoginRoles, and EscalatedRoles as properties to %SYS.ProcessQuery
STC2298 07/15/14 Steve Clay, Fix retrieval of OSUsername for Windows platforms
STC2286 06/02/14 Steve Clay, New ns variable in %SYS.ProcessQuery
STC2282 04/15/14 Steve Clay, Remove $$$ISWINDOWS macro from %SYS.ProcessQuery storage code
SJ2963	04/07/14 Scott Jones, fix $VIEWs of global vector
STC2270 02/26/14 Steve Clay, DisplayPid column in %SYS.ProcessQuery is now type %String for sorting
STC2198 04/18/13 Steve Clay, Display windows telnet devices like windows tcp devices
SML1678 03/26/13 Simon Li, Fix wrong lock state when a job is waiting for acquiring a lock.
STC2185 02/22/13 Steve Clay, Display implied namespaces correctly in some utilities 
STC2177  2/01/13 Steve Clay, Add ##Class(%SYS.ProcessQuery).GetOSUsername() method
STC2172  1/25/13 Steve Clay, Require %Admin_Manage:Use permission for %SYS.ProcessQuery:PPG() query
STC2170  1/24/13 Steve Clay, Retrieve OSUsername property correctly after calling $SYSTEM.Security.Login()
STC2168  1/22/13 Steve Clay, Make process display screen sort PID in numeric order
STC2151 12/06/12 Steve Clay, Add PrivateGlobalBlockCount column and sort to %SYS.ProcessQuery:TopGlobal Query 
STC2142 11/07/12 Steve Clay, Add filter to %SYS.ProcessQuery VariableByJobNumber and VariableByPid queries
STC2117  7/07/12 Steve Clay, Add O/S Username to SMP process display 
RFD762   6/29/12 Rob Davis, Add JournalEntries counter 
STC2102  6/05/12 Steve Clay, Update %SYS.ProcessQuery variable queries
STC2093 05/24/12 Steve Clay, Add MaxRows parameter to %SYS.ProcessQuery:VariableByJobNumber
STC2085  4/24/12 Steve Clay, Add filter to %SYS.ProcessQuery:ControlPanel query
STC2034 12/30/11 Steve Clay, Add SQL locking methods to %SYS.ProcessQuery
SML1428 12/23/11 Simon Li, Display a special state code for processes waiting in $SYSTEM.Socket.Select().
RFD691	11/15/11 Rob Davis, add counters for gloupd, phyrd, and blkalloc
STC2001 10/17/11 Steve Clay, Fix mismatch between internal and external pid on VMS
SAP1514 10/05/11 Steve Pettibone, add pstate for event wait
CDS1966  6/14/11 Chuck Sorenson, support large routines for GetCurrentLine
STC1948  4/28/11 Steve Clay, Update documentation in %SYS.ProcessQuery
STC1947  4/28/11 Steve Clay, %SYS.ProcessQuery:%OpenId now runs faster
WDS384   1/24/11 David Shambroom, Fix JOBEXAMExecute bug
STC1875 12/19/10 Steve Clay, Update %SYS.ProcessQuery to work in a remote namespace
SML1265 12/01/10 Simon Li, Replace ^CacheTemp with private global in system query codes.
RFD578  10/14/10 Rob Davis, add Top query
STC1835  8/23/10 Steve Clay, Do not use macros in SQL retrieval code in %SYS.ProcessQuery
RFD555   8/10/10 Rob Davis, Add port to TCP device name in JOBEXAM query
RFD544  06/15/10 Rob Davis, Enhance JOBEXAMFetch for use by WSMon Process list
STC1782 04/05/10 Steve Clay, Update documentation in %SYS.ProcessQuery:VariableByJobNumber()
RFD502  01/28/10 Rob Davis, add PrincipalDevice property
SOH159  10/17/09 Steven Hobbs, Move classmethods to %SYSTEM.Process
SOH155  10/09/09 Steven Hobbs, Move ThrowError, CallingRoutine, CallingDatabase
			and LanguageMode to %SYSTEM.Process.
SOH153  10/06/09 Steven Hobbs, Implement/Unimplement $ZU(xx,) class methods
SOH152  10/03/09 Steven Hobbs, Replace $ZU(xx,) with class methods
SOH151  10/02/09 Steven Hobbs, Rename SOH150 methods to agree with Config.Miscellaneous names
SOH150  10/01/09 Steven Hobbs, Replace $ZU(67,n) with class methods
GGC322  08/25/09 Greg Cooper, add preliminary Process Private Global query.
RFD468  07/13/09 Rob Davis, Change "lines" to "commands"
SML1066  5/06/09 Simon Li, Set UserName of Mirror process with Location.
STC1571 04/09/09 Steve Clay, Allow %SS to be run by someone with READ access to CACHESYS
CDS1494  1/13/09 Chuck Sorenson, use Set $ZR to restore naked
STC1470 10/17/08 Steve Clay, Prevent possible infinite loop in %SYS.Processquery 
STC1447 09/04/08 Steve Clay, Allow %SYS.ProcessQuery to run in a remote namespace 
STC1369 04/22/08 Steve Clay, Allows owner of CACHESYS resource to run %SS 
STC1280 11/01/07 Steve Clay, Fix documentation in %SYS.ProcessQuery
SML940  10/04/07 Simon Li, Display private variable correctly in Debugger watch windows.
STC1268 10/04/07 Steve Clay, Add ListPids query to %SYS.ProcessQuery
RFD324  10/03/07 Rob Davis, Add GetCPUTime() class method
STC1246 07/17/07 Steve Clay, Allow user without %Admin_Manage to run JOBEXAM
RFD292  04/19/07 Rob Davis, add GetLoginRoutine() method
STC1164 02/05/07 Steve Clay, Fix process query to display executable name correctly 
STC1115 12/06/06 Steve Clay, Speed up 1^%SS display
STC1086 10/04/06 Steve Clay, Display private global useage
STC1085 10/03/06 Steve Clay, Process lines executed don't display correctly 
JO2096  10/03/06 Jeffrey Orlin, add PrivateGlobalBlockCount property for
                 current # of blocks allocated for private global storage
STC1050 - Fix infinite loop if bad job number passed in to %SYS.ProcessQuery
JO2047  08/18/06 Jeffrey Orlin, add environment to last global reference
                 if it is different than the current default namespace for
                 the process and use || if it is a private global reference
                 Updated 8/18/06 to add "W" to view command which pulls up
                 namespace and skip nspace if nslen is zero
STC1000 06/18/06 Steve Clay, Create %SYS.ProcessQuery SQL table.
JO1984  11/16/05 Jeffrey Orlin, use $SYSTEM.Util.CheckSwitch to check switch 10
STC977  03/19/06 Steve Clay, LDAP and User-Defined Authentication 
SML680  2/14/06 Simon Li, Fix ReleaseAllLocks() method.
SML655 12/06/05 Simon Li, VMS PID format consistency.
STC872  07/06/05, Steve Clay, Add CSP session id, UserInfo
CFL1337 06/10/05, Carlos Lopes, add CanReceiveBroadcast
SML592  6/07/05 Simon Li, Use DEFAULTFETCH macro for default fetch routine to
                initialize Row to null string.
SML578 05/20/05, Simon Li, Add more pstatbits for Job State.
GK383   04/26/05 Garen Kotikian, Added ECP process dmn to the process 
		 class system jobs.
STC808 04/24/05 Steve Clay, Add tests for appropriate privileges
SML554  04/22/05 Simon Li, Move 'Username' after 'Pid' for CONTROLPANEL query.
LFT1381 01/12/05 Laura Tillem, set CanBeSuspended() correctly
LFT1316 10/21/04 Laura Tillem, reorg
LFT1264 05/19/04 Laura Tillem, don't call $$$ERROR for no job
LFT1248 04/13/04 Laura Tillem, use $lb instead of "^" for qHandle
LFT1234 03/10/04 Laura Tillem, OSUserNameGet should use $zu(61,11)
LFT1222 02/23/04 Laura Tillem, add Startupxxx properties
LFT1206 02/13/04 Laura Tillem, remove uic property
LFT1211 02/04/04 Laura Tillem, gendoff is 2 bytes
SML425  12/30/03 Simon Li, Replace call to %LM with $SYSTEM.Lock.
LFT1183 12/29/03 Laura Tillem, add Can Be Examined/Suspended/Terminated to
		 CONTROLPANEL query
LFT1179 12/12/03 Laura Tillem, this extends Help also
LFT1176 12/12/03 Laura Tillem, add GetInfo method
LFT1170 11/25/03 Laura Tillem, CanBeExamined/Terminated/Suspended are public
LFT1168 11/20/03 Laura Tillem, use PrincipalName for UserName property
		 and add License User Id to ALLFIELDS query
LFT1167 11/12/03 Laura Tillem, support new pstatebits "CS" and "NL"
LFT1154 10/22/03 Laura Tillem, add DEFAULTCONCURRENCY parameter
LFT1149 10/21/03 Laura Tillem, fix JOBEXAMFetch problems
LFT1132 09/22/03 Laura Tillem, add SS query and combine JOBEXAM, CONTROL
                 PANEL and %SS query Fetches, also fix Terminate to return
                 actual status, also replace VariableByJobNumberExecute
STC471  08/19/03 Steve Clay, Change include file name
STC463  07/31/03 Steve Clay, Add VariableByPid, rename Variable to
				 VariableByJobNumber
STC408  12/17/02 Steve Clay, Change ExecutableName to ClientExecutableName.
STC400  11/21/02 Steve Clay, Fix display of DMNNET
STC398  11/20/02 Steve Clay, Fix undefined in getview
LFT1056 11/05/02 Laura Tillem, make this class final, no subclassing
LFT1048 10/17/02 Laura Tillem, min should be 1 in binary search
STC385 10/11/02, Steve Clay, Cleaned up, hid some properties and methods
STC362 09/17/02, Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
/// Set this to the correct domain.
Parameter DOMAIN = "%Utility";

/// Process can be examined.<br>
/// Flag checked by JOBEXAM and Mgt Portal to see if a process can
/// be examined in detail.
Property CanBeExamined As %Boolean [ ReadOnly, SqlColumnNumber = 20 ];

/// Process can be suspended.<br>
/// Flag checked by JOBEXAM and Mgt Portal to see if a process can
/// be suspended.
Property CanBeSuspended As %Boolean [ ReadOnly, SqlColumnNumber = 21 ];

/// Process can be terminated.<br>
/// Flag checked by JOBEXAM and Mgt Portal to see if a process can
/// be terminated.
Property CanBeTerminated As %Boolean [ ReadOnly, SqlColumnNumber = 22 ];

/// Process can receive broadcast.<br>
/// Flag checked by JOBEXAM and Mgt Portal to see if a process can
/// receive a broadcast. Usually this means they are attached to a terminal.
Property CanReceiveBroadcast As %Boolean [ ReadOnly, SqlColumnNumber = 23 ];

/// Executable name of the process on the client.<br>
/// The name of the Executable or DLL on the client which initiated the connection.
/// It is passed down to the process as part of the initial connection message.
/// This property may be set by the end-user if they are managing their own connections.
Property ClientExecutableName As %String [ SqlColumnNumber = 16 ];

Method ClientExecutableNameSet(Val) As %Status [ Internal ]
{
 s i%ClientExecutableName=Val
 d $zu(61,13,i%JobNumber,Val)
}

/// IP Address of client connected to the process.<br>
/// IP address of the client which initiated the connection.
/// It is passed down to the process as part of the initial connection message.
/// This property may be set by the end-user if they are managing their own connections.
Property ClientIPAddress As %String [ SqlColumnNumber = 9 ];

Method ClientIPAddressSet(Val) As %Status [ Internal ]
{
 s i%ClientIPAddress=Val
 d $zu(61,15,i%JobNumber,Val)
}

/// Node Name of the client connected to the process.<br>
/// Node name of the client which initiated the connection.
/// It is passed down to the process as part of the initial connection message.
/// This property may be set by the end-user if they are managing their own connections.
Property ClientNodeName As %String [ SqlColumnNumber = 10 ];

Method ClientNodeNameSet(Val) As %Status [ Internal ]
{
 s i%ClientNodeName=Val
 d $zu(61,12,i%JobNumber,Val)
}

/// Number of Commands Executed.<br>
/// Total number of commands which the process has executed.
Property CommandsExecuted As %BigInt [ ReadOnly, SqlColumnNumber = 38 ];

/// CSP Session ID of client connected to process.<br>
/// CSP session ID of the client which initiated the connection.
/// It is passed down to the process as part of the initial connection message,
/// and used to manager the CSP session.
Property CSPSessionID As %String [ ReadOnly, SqlColumnNumber = 24 ];

/// Current Device ($i).<br>
/// Current device that the process has open and is USEing via the USE command.
Property CurrentDevice As %String [ ReadOnly, SqlColumnNumber = 11 ];

/// Current Line and Routine.<br>
/// Current line and routine that the process is executing.
/// Returned in +number^routine format.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property CurrentLineAndRoutine As %String [ ReadOnly, SqlColumnNumber = 13 ];

/// Current Source Line being executed.<br>
/// Current line of source code which is being executed by the process. If "",
/// then the source code line is unavailable.<br>
/// This property requires a mailbox message to be sent to the process being examined.
/// If the routine has been modified compared to the pcode being run then this will point to
/// the current routine source rather than the actual source of the code being executed.
Property CurrentSrcLine As %String [ ReadOnly, SqlColumnNumber = 14 ];

/// Additional roles granted to the set of login roles.<br>
Property EscalatedRoles As %String [ Calculated, SqlColumnNumber = 47 ];

Method EscalatedRolesGet() [ Internal ]
{
 i ..LoginRoles=..Roles {
	 q $$$Text("None")
 } else {
	s EscalatedRoles=","_..Roles_","
	f i=1:1:$l(..LoginRoles,",") {
		s EscalatedRoles=$replace(EscalatedRoles,","_$p(..LoginRoles,",",i)_",",",")
	}
 	q $e(EscalatedRoles,2,*-1)
 }
}

/// Number of Global References.<br>
/// Total number of global references the process has made.
Property GlobalReferences As %BigInt [ ReadOnly, SqlColumnNumber = 5 ];

/// Number of Global Updates.<br>
/// Total number of global updates (sets and kills) the process has made.
Property GlobalUpdates As %Integer [ ReadOnly, SqlColumnNumber = 40 ];

/// Number of Physical Database Reads.<br>
/// Total number of times the process has fetched data from disk.
Property GlobalDiskReads As %Integer [ ReadOnly, SqlColumnNumber = 41 ];

/// Number of Database Block Allocations.<br>
/// Total number of new database blocks the process has allocated. An indication of database growth.
Property GlobalBlocks As %Integer [ ReadOnly, SqlColumnNumber = 42 ];

/// Number of Data blocks marked for Write.
Property DataBlockWrites As %Integer [ ReadOnly, SqlColumnNumber = 48 ];

/// In a transaction.<br>
/// If 0, the process is not in a transaction.<br>
/// If >0, the process has executed a tstart command, is in a transaction, and the value 
/// is the offset in the journal file where the transaction has started.
Property InTransaction As %Integer [ ReadOnly, SqlColumnNumber = 25 ];

/// Is a Ghost process.<br>
/// The process has been killed at the O/S level, and has not yet been cleaned
/// up by the CLNDMN process. Until the process is cleaned, their may be outstanding
/// locks or resources which may be unavailable to other processes.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property IsGhost As %Boolean [ ReadOnly, SqlColumnNumber = 26 ];

/// Job number in process table.<br>
/// Used as an index into the job table. May be passed to the Open() method to
/// open an object instance to that process.
Property JobNumber As %Integer [ ReadOnly, SqlColumnNumber = 27 ];

/// Job type.<br>
/// Number which tells what type of process it is.<br>
/// See the %syPidtab.inc include file for a definition of macros for these fields.
/// Only use the defined macros in %syPidtab when referencing these fields. 
/// For example:<br><br>
/// If Process.JobType=$$$WDTYPE w !,"Process is the write daemon"<br>
Property JobType As %Integer [ ReadOnly, SqlColumnNumber = 28 ];

/// Number of Journal Entries.<br>
/// Total number of journaled global updates the process has recorded. An indication of journal file growth.
Property JournalEntries As %Integer [ ReadOnly, SqlColumnNumber = 43 ];

/// Last Global Reference.<br>
/// Last global reference that the process made.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property LastGlobalReference As %String [ ReadOnly, SqlColumnNumber = 15 ];

/// User Id used for license.<br>
/// The User ID which took out the license for the process.
Property LicenseUserId As %String [ ReadOnly, SqlColumnNumber = 29 ];

/// Number of Lines Executed.<br>
/// Total number of lines which the process has executed.
/// NOTE: This property is deprecated, line counts are no longer available and this actually returns the CommandsExecuted.
/// It is left here for backwards compatibility, but should no longer be used.
Property LinesExecuted As %BigInt [ ReadOnly, SqlColumnNumber = 4 ];

/// Location.<br>
/// If a system process, will be the system processes name.<br>
/// If a user process, will be the value of $g(^%IS(0,Job.CurrentDevice),"")
Property Location As %String [ ReadOnly, SqlColumnNumber = 30 ];

/// Login roles.<br>
/// Roles a process has when it initially logs in.<br>
Property LoginRoles As %String [ ReadOnly, SqlColumnNumber = 46 ];

/// Maximum memory able to be used in KB ($ZS).<br>
/// Maximum amount of memory in KB that the process is allowed to use.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property MemoryAllocated As %Integer [ ReadOnly, SqlColumnNumber = 17 ];

/// Memory used in KB (Current $s).<br>
/// Current amount of memory the process has used in KB.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property MemoryUsed As %Integer [ ReadOnly, SqlColumnNumber = 18 ];

/// Peak memory allocated in KB.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property MemoryPeak As %Integer [ ReadOnly, SqlColumnNumber = 44 ];

/// Namespace process is executing in.<br>
Property NameSpace As %String [ ReadOnly, SqlColumnNumber = 2 ];

/// List of open devices.<br>
/// List of devices which the process has opened. Returned as a
/// comma separated string.<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property OpenDevices As %String [ ReadOnly, SqlColumnNumber = 19 ];

/// Operating system username of process.<br>
/// Username given to the process by the operating system when the process
/// is created. When displayed, it is truncated to 16 characters. Note that the real O/S
/// username is only returned when connecting to UNIX or VMS systems; For Windows, it 
/// will return the O/S username for a console process, but for telnet it will return
/// the $USERNAME of the process. For client connections, it contains the O/S username
/// of the client. This field is truncated at 16 characters.
Property OSUserName As %String [ ReadOnly, SqlColumnNumber = 31 ];

/// Process ID.<br>
/// Process ID ($J) given to the process by the O/S, decimal form on all platforms.
Property Pid As %Integer [ ReadOnly, SqlColumnNumber = 32 ];

/// Number of private global database blocks.<br>
/// This property contains the # of database blocks currently 
/// allocated to store process private globals.
Property PrivateGlobalBlockCount As %Integer [ ReadOnly, SqlColumnNumber = 37 ];

/// Number of Process Private Global References.<br>
/// Total number of private global references the process has made.
Property PrivateGlobalReferences As %BigInt [ ReadOnly, SqlColumnNumber = 49 ];

/// Number of Process Private Global Updates.<br>
/// Total number of private global updates (sets and kills) the process has made.
Property PrivateGlobalUpdates As %BigInt [ ReadOnly, SqlColumnNumber = 50 ];

/// Index on Pid field.<br>
/// Uses NextProcess(Pid) to retrieve next process id.
Index IdKey On Pid [ IdKey ];

/// External Process PID.
/// Decimal value for Windows, Unix and Mac, hex for VMS.
Property PidExternal As %String [ ReadOnly, SqlColumnNumber = 7 ];

/// Principal Device ($P).<br>
/// This property requires a mailbox message to be sent to the process being examined.
Property PrincipalDevice As %String [ ReadOnly, SqlColumnNumber = 39 ];

/// Priority.<br>
/// Priority of the process at the O/S level.
Property Priority As %Integer [ ReadOnly, SqlColumnNumber = 33 ];

/// $Roles.<br>
/// Roles a process currently has.<br>
Property Roles As %String [ ReadOnly, SqlColumnNumber = 45 ];

/// Routine currently executing.<br>
/// Name of the routine which the process is currently executing.
Property Routine As %String [ ReadOnly, SqlColumnNumber = 3 ];

/// Startup IP Address of client.<br>
/// IP address of the client as detected on the TCP channel by the server process.
Property StartupClientIPAddress As %String [ ReadOnly, SqlColumnNumber = 34 ];

/// Startup Node Name of client.<br>
/// IP Node name of the client as detected on the TCP channel by the server process.
Property StartupClientNodeName As %String [ ReadOnly, SqlColumnNumber = 35 ];

/// State.<br>
/// Current state of the process as determined by the processes state bits.<br>
/// The following are all the different states a process can be in. The process may 
/// also have a number of different flags within these states which are appended to 
/// the end of the state name:<br>
/// LOCK - Executing a Lock command<br>
/// OPEN - Opening a device<br>
/// CLOS - Closing a device<br>
/// USE  - Using a device<br>
/// READ - Read command<br>
/// WRT  - Write command<br>
/// GET  - Executing a $Get on a global<br>
/// GSET - Setting a global<br>
/// GKLL - Killing a global<br>
/// GORD - $Order on a global<br>
/// GQRY - $Query on a global<br>
/// GDEF - $Data on a global<br>
/// ZF   - Executing a $ZF command<br>
/// HANG - Executing a Hang command<br>
/// JOB  - Executing a Job command<br>
/// EXAM - Executing a variable exam<br>
/// BRD  - Executing a broadcast<br>
/// SUSP - Process is suspended<br>
/// INCR - Executing a $Increment<br>
/// BSET - Set $bitset<br>
/// BGET - get $bitset<br>
/// EVT  - Waiting on event
/// RUN  - Process is running<br><br>
/// Here are the flags which can be appended to the state:<br><br>
/// CS - cluster slave job waiting for net answer<br>
/// NL - Net lock waiting<br>
/// DT - The dead job has open transaction<br>
/// S  - Suspension requested<br>
/// GW - Global Wait<br>
/// NR - Net Read<br>
/// D  -  Dead<br>
/// H  - Halting<br>
/// NH - Netharden<br>
/// N  - Remote network<br>
/// W  - Hibernating<br>
Property State As %String [ ReadOnly, SqlColumnNumber = 6 ];

/// Process Owns switch 10.<br>
/// This property is set to 1 if the process has set switch 10.
Property Switch10 As %Boolean [ ReadOnly, SqlColumnNumber = 36 ];

/// User defined information.<br>
/// This is a user-defined property where the process can set any value into it up
/// to 16 bytes long. The data in it is viewable in JOBEXAM. Note that
/// the information can only be set into one's own process, not into
/// another user's process.
Property UserInfo As %String(MAXLEN = 16) [ SqlColumnNumber = 12 ];

Method UserInfoSet(Val) As %Status [ Internal ]
{
 s i%UserInfo=Val
 d $zu(61,20,i%JobNumber,Val)
}

/// $Username of process.<br>
/// $Username of the process as set by the processes authentication method.
Property UserName As %String [ ReadOnly, SqlColumnNumber = 8 ];

/// Check to see if permissions allow us to open the process.<br>
/// The %SYS.ProcessQuery class is available to all users in all namespaces. 
/// It is intended that
/// any process can open an instance of this class and examine their own properties,
/// but not any other process on the system, unless they own the %Admin_Manage:Use
/// resource, or are in the %SYS namespace.<br>
ClassMethod AllowToOpen(Pid) As %Status [ Internal ]
{
 q:($zu(67,17,Pid)=0) $$$ERROR($$$LoadObjectNotFound,$ClassName(),Pid)  
 i $SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)||$$$IOwnCACHESYSWrite||$$$IOwnCACHESYSRead||(+Pid=+$j) q $$$OK
 q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
}

/// Get the current line and routine for a process.<br>
/// Parameters:<br>
/// JobNumber - Job number of the process<br>
/// Return Value:<br>
/// On success, the method will return the current line and routine of the selected process
/// in +number^routine format. on failure, or if unavailable, it will return ""
ClassMethod GetCurrentLineAndRoutine(JobNumber) As %String [ Internal ]
{
 s $zt="Error"
 i ..AllowToOpen($zu(61,17,JobNumber))'=$$$OK g Error
 s namespace=$zu(61,6,JobNumber) s:$e(namespace,1,2)="@@" namespace="^^"_$e(namespace,3,*) i namespace="" q ""
 s partvec=$zu(61,2,JobNumber),pid=$zu(61,17,JobNumber)
 s plines=$V($$$STPLINES+partvec,pid,"p") i 'plines q ""
 s rouname=$zu(61,5,JobNumber)
 s currc=$V($$$STPCURRC+partvec,pid,"p") i 'currc q ""
 s bufftab=$V($$$STrcBUFFTAB+currc,pid,"p")
 i 'bufftab {
   s op=$V($$$STOP+partvec,pid,"p")-$V($$$STPOBJECT+partvec,pid,"p")-1 
   i op<0 q ""
   s numlines=$V(plines+2,pid,2)
   q:'numlines ""
   s min=1,max=numlines+1 
   f {
     q:(max-min)<2
     s mid=(min+max)\2,xop=$V(mid*2+plines,pid,2) 
     i xop>op { s max=mid }
     elseif xop<op { s min=mid }
     else { s (min,max)=mid }
   }
   s line=min
   q ("+"_line_"^"_rouname)
 } else {
   s bufno=$V($$$STPRBUFNO+partvec,pid,4)
   s op=$V($$$STOP+partvec,pid,"p")-$V(bufno*$$$STPLEN+bufftab,pid,"p")-1 
   i op<0 q ""
   s linbtab=$V($$$STrcLINBUFT+currc,pid,"p")
   s b1nlines=$V($$$STrcB1NLINES+currc,pid,2),b1lines=$V($$$STrcB1LINES+currc,pid,1)
   s max=$V(bufno*4+linbtab,pid,4),oldmax=max
   if bufno { s min=$V(bufno-1*4+linbtab,pid,4) }
   else { s min=2 if max=1 || (op<$V(4+plines,pid,2)) q "+1^"_rouname }
   f {
     s line=min+max\2
     if line<b1nlines { s xop=$V(line*2+plines,pid,2) }
     else {
      s i=line-b1nlines
      s xop=$V($ZB(i,32767,1)*2+$V(i\32768+b1lines+1*$$$STPLEN+bufftab,pid,"p"),pid,2)
     }
     if op<xop { s max = line-1 return:max=oldmax "" s oldmax=max }
     else { s min = line+1 q:min>max }
   }
   q ("+"_line_"^"_rouname)
 }
Error s $ZT=""
  q ""
}

/// Get the current source line for the process.<br>
/// Parameters:<br>
/// JobNumber - Job number of the process<br>
/// Return Value:<br>
/// On success, the method will return the current source line of the selected process.<br>
/// On failure, or if source unavailable, it will return ""
ClassMethod GetCurrentSrcLine(JobNumber) As %String [ Internal ]
{
 s $zt="Error"
 s zr=$zr
 s LineAndRoutine=..GetCurrentLineAndRoutine(JobNumber)
 q:LineAndRoutine="" ""
 s line=+$p(LineAndRoutine,"^",1),rouname=$p(LineAndRoutine,"^",2)
#; If switch 10 is set don't reference a global unless we have it set ourselves
 i '+$SYSTEM.Util.CheckSwitch(10) quit ""
 s nethard=$zu(68,27,0) ; turn off network hardening
 s namespace=$zu(61,6,JobNumber)
 s ret=""
 I $D(^[namespace]ROUTINE(rouname,0,line),ret)
 f  q:(($e(ret)'=$c(9))&($e(ret)'=$c(32)))  s ret=$e(ret,2,*)
 s nethard=$zu(68,27,nethard)
 i $d(zr) s $ZR=zr
 q ret  
Error s $ZT=""
 i $d(nethard) s nethard=$zu(68,27,nethard) 
 i $d(zr) s $ZR=zr
 q ""
}

/// Get the last global reference for the process.<br>
/// Parameters:<br>
/// JobNumber - Job number of the process<br>
/// Return Value:<br>
/// On success, the method will return the last global reference the selected process.<br>
/// On failure, it will return ""
ClassMethod GetLastGlobalReference(JobNumber) As %String [ Internal ]
{
 s $zt="Error"
 i ..AllowToOpen($zu(61,17,JobNumber))'=$$$OK g Error
 o 63:"^^"_$zu(12)
 s GLOB="",pid=$zu(61,17,JobNumber) h 0
 s GVEC=$V($ZU(40,1,11)+$zu(61,2,JobNumber),pid,"J")
 s GBEG=$V(GVEC+$$$STgbeg,pid,"J")
 s GEND=GBEG+$V(GVEC+$$$STgend,pid,2)
 i '(GEND'>GBEG) {
	 s GLOB=$ZU(70,4,$V(GBEG,pid,GBEG-GEND),$ZU(70,1,$V(GVEC+$ZU(40,3,20),pid,1)))
#; ;JO2047+
	 s GSTATE=$V(GVEC+$$$STgstate,pid,1)
	 s PRIVGLOB=$ZBOOLEAN(GSTATE,$$$STGFSPRIVATE,1)  ; 1 = and
	 if PRIVGLOB {
		 s GLOB="||"_GLOB
	 } else {
		 ; If the current namespace is different than the
		 ; namespace for the last global reference, then include
		 ; the namespace in the global reference we display
		 s GREFNS=$V(GVEC+$zu(40,3,18),pid,"P")
		 s NSLEN=$V(GREFNS+$ZU(40,36,4),pid,1)  ;sizeof(nslen) = char
		 if NSLEN {
		    S NSLEN="-"_NSLEN_"W"
		    S NSNAME=$V(GREFNS+$ZU(40,36,5),pid,NSLEN)
		    s curns=$zu(61,6,JobNumber)
		    if curns'=NSNAME {
			   i $e(NSNAME,1,2)="@@" s NSNAME="^^"_$e(NSNAME,3,*)
		       s GLOB="|"""_NSNAME_"""|"_GLOB
		    }
		 }
	 }
		 
#; ;JO2047-
 }
 c 63
 q GLOB
Error s $zt="" 
 c 63
 q ""
}

/// Query the process for some properties.<br>
/// Parameters:<br>
/// Pid - Pid (decimal) of the process<br>
/// Return Value:<br>
/// On success, the method will return the values of $v(-1,Pid)<br>
/// On failure, or if source unavailable, it will return all fields as 0.
ClassMethod GetView(Pid) As %String [ Internal ]
{
 S $ZT="getview1"
 i ..AllowToOpen(Pid)'=$$$OK g getview2
 Q $V(-1,Pid)
getview1 ;
 S $ZT="getview2"
 Q $V(-1,Pid)
getview2 ;
 S $ZT="" 
 q Pid_"^0^0^0^0^0^0,0^0^0,0^0^0^0^0^0^0^0,0^0^0^0"
}

/// Query the process for some properties.<br>
/// Parameters:<br>
/// Pid - Pid (decimal) of the process<br>
/// Return Value:<br>
/// On success, the method will return the $LIST from $v(-1,Pid,2)<br>
/// On failure, or if source unavailable, it will return all fields as 0.
ClassMethod GetViewList(Pid) As %List [ Internal ]
{
 S $ZT="getviewl1"
 i ..AllowToOpen(Pid)'=$$$OK g getviewl2
getviewl1 ;
 S $ZT="getviewl2"
 Q $V(-1,Pid,2)
getviewl2 ;
 S $ZT="" 
 q $LB(Pid,0,0,0,0,0,"0,0",0,"0,0",0,0,0,0,0,0,"0,0",0,0,0)
}

/// Get routine and label specified in process login.<br>
/// <br>
/// Available only for the current process, you can not query
/// another process. If a class method is passed on the command line
/// then 'Label' will be the method name and 'Routine' will be the
/// class name with a trailing '#' to identify it as a class. <br> 
ClassMethod GetLoginRoutine(ByRef Label As %String, ByRef Routine As %String) As %Status
{
 s $zt="Error"
 q $$UsersGetLoginRoutineName^%SYS.SECURITY(.Label,.Routine)
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Get CPU time used for current process.<br>
/// <br>
/// Returns two comma-delimited pieces, "system" CPU time and "user" CPU time 
/// (except on VMS where no separate times are available). Time is returned
/// as milliseconds of CPU time.
ClassMethod GetCPUTime() As %String
{
	q $ZU(171,1)
}

/// This method returns the OSUsername of the process as returned by the operating system.
/// This method differs from the OSUsername property in that it is the actual username assigned to
/// the process by the operating system.
ClassMethod GetOSUsername() As %String
{
 q $V($zu(40,1,19)+($zbitget($zversion(0),1)+1),-1,-$V($zu(40,1,19),-1,1_"w")_"w")
}

/// Kill all process private globals for the calling process.<br>
ClassMethod KillAllPrivateGlobals() As %Status
{
 s $zt="Error"
 d $zu(21,2)
 q $$$OK
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Returns the next process pid on the system.<br>
/// This is like a $order function on processes running on the system, similar to the way
/// $ZJOB works. It differs from $zjob in one respect though. If the pid passed into
/// the function has halted before this call, we will still return the next pid on the
/// system. $zjob would return the first pid on the system in this case. Using $zjob in
/// this way with lots of processes starting and halting could lead to inaccurate results.
/// Flag=1 means pass in and return the internal decimal representation of a VMS pid ($zh(pid))
ClassMethod NextProcess(Pid As %String, Flag As %Integer = 0) As %String
{
#;First see if we pass in "". This means we want the first pid on the system.
 i Pid="" {
	 s NextPid=$s($$$ISVMS:$s(Flag=0:$zh($zu(61,17,1)),1:$zu(61,17,1)),1:$zu(61,17,1))
	 s ^||%SYS.ProcessQuery=NextPid_","_1
	 q NextPid
 }
#;Now see if the pid passed in matches the last pid we returned. If so, then
#;just get the next pid (if there is one.)
 i Pid=$p($g(^||%SYS.ProcessQuery),",",1) {
	s ProcessTableSize=$$$STmaxpid
	s Loc=$p(^||%SYS.ProcessQuery,",",2)+1
	f  {
		i Loc>ProcessTableSize {
			k ^||%SYS.ProcessQuery
			s NextPid=""
			q
		}
		s NextPid=$s($$$ISVMS:$s(Flag=0:$zh($zu(61,17,Loc)),1:$zu(61,17,Loc)),1:$zu(61,17,Loc))
	 	i NextPid'=0 {
			s ^||%SYS.ProcessQuery=NextPid_","_Loc
		 	q
	 	}
	 	s Loc=Loc+1
	}
	q NextPid
 }
#;We have passed in a pid which is not "", and not the same as the last one we
#;returned. Use $zjob to get the one right after it. Convert the VMS hex format to decimal
#;for the call to $zjob.
 s NextPid=$s($$$ISVMS:$zjob($s(Flag=0:$zh(Pid),1:Pid)),1:$zjob(Pid))
#; We passed in the last pid on the system, return ""
 i NextPid="" {
	k ^||%SYS.ProcessQuery
	q ""
 }
#;We have a pid to return. It is either the one immediately following the pid we passed
#;in, or the first pid on the system if the one we passed in does not exist.
 s ^||%SYS.ProcessQuery=NextPid_","_$zu(67,3,$s($$$ISVMS:$s(Flag=0:$zh(NextPid),1:NextPid),1:NextPid))
 q NextPid
}

/// Open an instance to a process.<br>
/// This method will open an instance to a process by passing either
/// a PID or Job number to the method. A Pid can either be directly passed in or
/// prefaced with a "P". A Job number can be passed in prefaced by a "J".<br>
/// The following open an instance to a process with a pid = 2078:<br>
/// s Process=##CLASS(%SYS.ProcessQuery).Open("P2078")<br>
/// s Process=##CLASS(%SYS.ProcessQuery).Open("2078")<br><br>
/// The following will open Job number 23<br><br>
/// s Process=##CLASS(%SYS.ProcessQuery).Open("J23")<br><br>
/// Parameters:<br>
/// Id - Pid or Job number to open<br>
/// Concurrency - Pass -1 or use default<br>
/// sc (by ref)- Status of the Open<br>
/// Return values:<br>
/// On success, the method returns an object handle to the opened process.<br>
/// On failure, the method returns a null string, and an error in sc.
ClassMethod Open(Id As %String, concurrency As %Integer = -1, ByRef sc As %Status = 1) As %ObjectHandle
{
 Quit ..%OpenId($s("Jj"[$e(Id):$zu(61,17,$e(Id,2,$l(Id))),"Pp"[$e(Id):$e(Id,2,$l(Id)),1:Id),concurrency,.sc)
}

/// Translates an internal state flag to an external display.<br>
/// See the State property for what can be returned here.
ClassMethod StateLogicalToDisplay(State) As %String [ Internal ]
{
#; States must be 4 or less long for display
#;SML1428 ; add SLCT for PSTATESELECT state.
 s states="LOCK^OPEN^CLOS^USE^READ^WRT^GGET^GSET^GKLL^GORD^GQRY^GDEF^ZF^HANG^JOB^EXAM^BRD^SUSP^INCR^BSET^BGET^^EVT^SLCT"
 s bits=$p(State,"^",2),State=$p(State,"^",1)
 s ans1=$p(states,"^",State) i ans1="" s ans1="RUN"
 s ans2=""
 #;SML1678+ ; Use $ZB() function to check each pstatebits.
 s bits=+bits
 i $zb(bits,1024,1) s ans2=ans2_"DT" ; The dead job has open transaction 
 i $zb(bits,512,1) s ans2=ans2_"CS"  ; cluster slave job waiting for net answer
 i $zb(bits,256,1) s ans2=ans2_"NL"  ; Net lock waiting
 i $zb(bits,128,1) s ans2=ans2_"S"   ; Suspension requested
 i $zb(bits,64,1) s ans2=ans2_"GW"    ; Global Wait
 i $zb(bits,32,1) s ans2=ans2_"NR"    ; Net Read
 i $zb(bits,16,1) s ans2=ans2_"D"    ; Dead
 i $zb(bits,8,1) s ans2=ans2_"H"    ; Halting
 i $zb(bits,4,1) s ans2=ans2_"NH"   ; Netharden
 i $zb(bits,2,1) s ans2=ans2_"N"  ; Remote network
 i $zb(bits,1,1) s ans2=ans2_"W"        ; Hibernating
 #;SML1678-
 q ans1_ans2
}

/// This callback method is invoked by the <METHOD>%Open</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being opened.
/// 
/// <P>If this method returns an error then the object will not be opened.
Method %OnOpen() As %Status [ Internal, Private ]
{
#;Return an error if we have an empty process slot.
 q:($zu(61,17,i%JobNumber)=0) $$$ERROR($$$LoadObjectNotFound,$ClassName()_".%OnOpen",i%JobNumber)
#;make sure we have permissions to open the process
 q ..AllowToOpen(i%Pid)
}

ClassMethod %SQLAcquireLock(%rowid As %String, s As %Boolean = 0, ByRef unlockref As %String) [ Internal, ProcedureBlock = 0, ServerOnly = 1 ]
{
	l +^%SYS.ProcessQuery(%rowid):10
	i '$t QUIT 0
	q $$$OK
}

ClassMethod %SQLAcquireTableLock(s As %Boolean = 0, ByRef SQLCODE As %Integer, to As %Integer = "") [ Internal, ProcedureBlock = 0, ServerOnly = 1 ]
{
	l +^%SYS.ProcessQuery:10
	i '$T QUIT 0
	q $$$OK
}

ClassMethod %SQLReleaseLock(%rowid As %String, s As %Boolean = 0, i As %Boolean = 0) [ Internal, ProcedureBlock = 0, ServerOnly = 1 ]
{
	l -^%SYS.ProcessQuery(%rowid)
}

ClassMethod %SQLReleaseTableLock(s As %Boolean = 0, i As %Boolean = 0) [ Internal, ProcedureBlock = 0, ServerOnly = 1 ]
{
	l -^%SYS.ProcessQuery
	q $$$OK
}

/// Returns ALL properties for a process<br>
/// This query performs a Select * on %SYS.ProcessQuery SQL query.
/// Note that this query uses a $v(-1,$j) mailbox message to
/// query processes. This causes a lot of overhead, but is necessary in
/// order to return all fields. Use the JOBEXAM, CONTROLPANEL, or SS
/// query for less overhead. 
/// This query will change in future versions as field are added or removed.
Query AllFields() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT * FROM %SYS.ProcessQuery
}

/// Returns fields for the Management Portal display<br>
/// Note that this query does not use a $v(-1,$j) mailbox message to
/// query processes. This avoids unecessary overhead.
/// This query may change in future versions.<br>
/// Parameters:<br>
/// JobNumber - Job number of where to start the query, default = 1 (first job)<br>
/// Filter - Display processes which contain this filter in the line, "" means display all.
/// For example, if Filter="READ", this will only display processes which have the word
/// "READ" in one of the columns.<br>
Query CONTROLPANEL(JobNumber As %Integer = 1, Filter As %String = "") As %Query(ROWSPEC = "Job#:%Integer,Pid:%Integer,DisplayPID:%Integer,Username:%String,Device:%String,Nspace:%String,Routine:%String,Commands:%BigInt,Globals:%BigInt,State:%String,Client Name:%String,EXE Name:%String,IP Address:%String,Can Be Examined:%Boolean,Can Be Suspended:%Boolean,Can Be Terminated:%Boolean,Can Receive Broadcast:%Boolean,PrvGblBlkCnt:%Integer,OSUserName:%String") [ SqlProc ]
{
}

ClassMethod CONTROLPANELExecute(ByRef qHandle As %Binary, JobNumber As %Integer = 1, Filter As %String = "") As %Status [ Internal ]
{
 i '($SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite) q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
 s qHandle="J"_JobNumber_"^CONTROLPANEL^"_Filter
 Quit $$$OK
}

ClassMethod CONTROLPANELFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
#; Set qHandle into something else here for future compatibility
 Quit ..JOBEXAMFetch(.qHandle,.Row,.AtEnd)
}

ClassMethod CONTROLPANELClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 Quit $$$OK
}

/// Same as CONTROLPANEL Query except that Pid column is a %string.
Query CONTROLPANELVMS(JobNumber As %Integer = 1, Filter As %String = "") As %Query(ROWSPEC = "Job#:%Integer,Pid:%String,DisplayPID:%String,Username:%String,Device:%String,Nspace:%String,Routine:%String,Commands:%BigInt,Globals:%BigInt,State:%String,Client Name:%String,EXE Name:%String,IP Address:%String,Can Be Examined:%Boolean,Can Be Suspended:%Boolean,Can Be Terminated:%Boolean,Can Receive Broadcast:%Boolean,PrvGblBlkCnt:%Integer,OSUserName:%String") [ SqlProc ]
{
}

ClassMethod CONTROLPANELVMSExecute(ByRef qHandle As %Binary, JobNumber As %Integer = 1, Filter As %String = "") As %Status [ Internal ]
{
 i '($SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite) q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
 s qHandle="J"_JobNumber_"^CONTROLPANEL^"_Filter
 Quit $$$OK
}

ClassMethod CONTROLPANELVMSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
#; Set qHandle into something else here for future compatibility
 Quit ..JOBEXAMFetch(.qHandle,.Row,.AtEnd)
}

ClassMethod CONTROLPANELVMSClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 Quit $$$OK
}

/// Returns fields for the JOBEXAM display.<br>
/// Note that this query does not use a $v(-1,$j) mailbox message to
/// query processes. This avoids unecessary overhead.
/// This query may change in future versions.<br>
/// Parameters:<br>
/// JobNumber - Job number of where to start the query, default = 1 (first job)
Query JOBEXAM(JobNumber As %Integer = 1) As %Query(ROWSPEC = "Job#:%Integer,Nspace:%String,Routine:%String,Commands:%BigInt,Globals:%BigInt,State:%String,Pid:%String,Current Device:%String") [ SqlProc ]
{
}

ClassMethod JOBEXAMExecute(ByRef qHandle As %Binary, JobNumber As %Integer = 1) As %Status [ Internal ]
{
 i '($SYSTEM.Security.Check($$$AdminOperateResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite) q $$$ERROR($$$OperationRequires,$$$AdminOperateResourceName_":"_$$$PermUseName)
 s qHandle="J"_JobNumber_"^JOBEXAM"
 Quit $$$OK
}

ClassMethod JOBEXAMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
#; Set qHandle into something else here for future compatibility
	s Handle=qHandle,Id=$e(Handle,2,$l(Handle)),Id=$p(Id,"^",1)
	s ProcessTableSize=$$$STmaxpid
Loop	
	s AtEnd=0
#;Quit if we are out of range (e.g. $j passed in accidently)
	i Id>ProcessTableSize {
		s Row=""
		s AtEnd=1
		q $$$OK
	}
	f  {
		s PID=$zu(61,17,Id)
		i PID=0 {
			s Id=Id+1
			i Id>ProcessTableSize {
				s Row=""
				s AtEnd=1
				q
			}
			Continue
		}
		&sql(SELECT ClientExecutableName,CurrentDevice,ClientNodeName,ClientIPAddress,NameSpace,Routine,CommandsExecuted,GlobalReferences,State,Pid,PidExternal,UserName,CanBeExamined,CanBeSuspended,CanBeTerminated,CanReceiveBroadcast,PrivateGlobalBlockCount,JobType,Priority,Location,OSUserName INTO :ClientExecutableName,:CurrentDevice,:ClientNodeName,:ClientIPAddress,:NameSpace,:Routine,:CommandsExecuted,:GlobalReferences,:State,:Pid,:PidExternal,:UserName,:CanBeExamined,:CanBeSuspended,:CanBeTerminated,:CanReceiveBroadcast,:PrivateGlobalBlockCount,:JobType,:Priority,:Location,:OSUserName
        FROM ProcessQuery
        WHERE Pid = :PID)
		i SQLCODE=0 q
		s Id=Id+1
	}
	q:AtEnd $$$OK
	s ClientName=ClientNodeName s:ClientName="" ClientName=ClientIPAddress
	i $e(NameSpace,1,2)="@@" s NameSpace="^^"_$e(NameSpace,3,*)
#;SML1066 ; Setup UserName for Mirror daemon processes.
	if ($e(Location,1,6)="Mirror") s UserName=Location
 	if (CurrentDevice["|TCP|")&(ClientName'="") s Port=":"_$p(CurrentDevice,"|",3),CurrentDevice="|TCP|"_ClientName_Port
 	if $$$ISWINDOWS {
	 	i ((CurrentDevice["|TNT|")&&(ClientName'=""))||(($e(CurrentDevice,$l(CurrentDevice)-$l(Pid)+1,*)=Pid)&&(ClientName'="")&&(CurrentDevice'["|TRM|")) {
	 		s Port=":"_$p($p(CurrentDevice,":",2),"|"),CurrentDevice="|TNT|"_ClientName_Port
	 	}
 	}
	Set Flag=$Piece(qHandle,"^",2)
	Set Filter=$Piece(qHandle,"^",3)
    If Flag="JOBEXAM" {
		s Row=$lb(Id,NameSpace,Routine,CommandsExecuted,GlobalReferences,State,Pid,CurrentDevice)
    } ElseIf Flag="CONTROLPANEL" {
#;SML655+
		s Row=$lb(Id,Pid,PidExternal,UserName,CurrentDevice,NameSpace,Routine,CommandsExecuted,GlobalReferences,State,ClientNodeName,ClientExecutableName,ClientIPAddress,CanBeExamined,CanBeSuspended,CanBeTerminated,CanReceiveBroadcast,PrivateGlobalBlockCount,OSUserName)
		i Filter'="" {
#;Convert the row to a string delimited by $c(13). Then see if the filter is contained
#;in the row.
			s StringRow=$listtostring(Row,$c(13))
			i $zcvt(StringRow,"L")'[$zcvt($p(qHandle,"^",3),"l") {
				s Id=Id+1
				s Row=""
				g Loop
			}
		}
#;SML655-
    } ElseIf Flag="WSMON" {
		s Row=$lb(Pid,UserName,CurrentDevice,NameSpace,Routine,CommandsExecuted,GlobalReferences,State,ClientName,ClientExecutable,ClientIPAddress)
    } Else {;"SS" or "TOP"
    	s Row=$lb(Pid,JobType,CurrentDevice,NameSpace,Routine,CommandsExecuted,GlobalReferences,Priority,UserName,Location)
    }
	s Id=Id+1
	If $Get(Flag)]"" s qHandle="J"_Id_"^"_Flag_"^"_Filter
	Quit $$$OK
}

ClassMethod JOBEXAMClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 Quit $$$OK
}

/// Return PIDS for all processes running on the system.<br>
/// This query returns the internal pid for each process on the system. This pid can
/// then be passed directly to the %OpenId() method, or as an argument to an embedded
/// SQL query which does a SELECT based on the Pid. See the example above for SQL useage.<br>
/// Parameters:<br>
/// JobNumber - Job number of where to start the query, default = 1 (first job)
Query ListPids(JobNumber As %Integer = 1) As %Query(ROWSPEC = "Pid:%String") [ SqlProc ]
{
}

ClassMethod ListPidsExecute(ByRef qHandle As %Binary, JobNumber As %Integer = 1) As %Status [ Internal ]
{
 s qHandle=+JobNumber_"^"
 Quit $$$OK
}

ClassMethod ListPidsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 s JobNumber=+qHandle
 f  {
	s PID=$zu(61,17,JobNumber)
	i PID'=0 {
		s Row=$lb(PID) 
		s qHandle=(JobNumber+1)_"^"
		q
	}
	s JobNumber=JobNumber+1
	i JobNumber<=$$$STmaxpid Continue
	s Row=""
	s AtEnd=1
	q
 }
 q $$$OK
}

ClassMethod ListPidsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 Quit $$$OK
}

/// Returns fields for the %SS display<br>
/// Note that this query does not use a $v(-1,$j) mailbox message to
/// query processes. This avoids unecessary overhead.
/// This query may change in future versions.<br>
/// Parameters:<br>
/// JobNumber - Job number of where to start the query, default = 1 (first job)
Query SS(JobNumber As %Integer = 1) As %Query(ROWSPEC = "Process:%Integer,JobType:%Integer,Device:%String,Namespace:%String,Routine:%String,CPU:%BigInt,Glob:%BigInt,Pr:%Integer,User:%String,Location:%String") [ SqlProc ]
{
}

ClassMethod SSExecute(ByRef qHandle As %Binary, JobNumber As %Integer = 1) As %Status [ Internal ]
{
 i '($SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite!$$$IOwnCACHESYSRead) q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
 s qHandle="J"_JobNumber_"^SS"
 Quit $$$OK
}

ClassMethod SSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
#; Set qHandle into something else here for future compatibility
 Quit ..JOBEXAMFetch(.qHandle,.Row,.AtEnd)
}

ClassMethod SSClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 Quit $$$OK
}

/// Returns the variables of a process<br>
/// Pass VariableName as a null string to return all variables.
/// This query requires the %Admin_Manage:Use permission to execute.
/// Parameters:<br>
/// JobNumber - Job number to query.<br> 
/// NOTE: You may not use this query to examine your own job.<br>
/// VariableName - Variable to return, or ""=All<br>
/// Format - Bit string of how to format the variable data, default = 0 (no formattimg)<br>
/// Bit 0 - Format the data with $c() and $lb() notation<br>
/// Bit 1 - Embed bolded cursor sequences around $c() and $lb() notation<br>
/// MaxRows - Maximum number of rows to return<br>
/// Filter - Filters the data returned (case insensitive). If the variable contains the filter, then return it. ""=no filter<br>
/// This query may change in future versions.
Query VariableByJobNumber(JobNumber, VariableName As %String, Format As %Integer, MaxRows As %Integer, Filter As %String) As %Query(ROWSPEC = "Name:%String,Value:%CacheString") [ SqlProc ]
{
}

ClassMethod VariableByJobNumberExecute(ByRef qHandle As %Binary, JobNumber As %Integer = 1, Variable As %String = "", Format As %Integer = 0, MaxRows As %Integer = 9999999, Filter As %String = "") As %Status [ Internal ]
{
#; Jobnumber^Variable^Index
 s $zt="VariableExecuteE"
 i '($SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite) q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
 i $e(Filter,*)="*" s Filter=$e(Filter,1,*-1)
 s Filter=$zcvt(Filter,"U")
 s RowCount=0
 s Index=$i($$$ISCQUERYTEMP)
 s qHandle=$lb(JobNumber,"",Index)
 s Pid=$zu(61,17,JobNumber)
 i Pid=+$j s $$$ISCQUERYTEMP(Index,"ZZZ")=$lb($$$Text("Cannot examine your own process"),"") q $$$OK
 i +$zu(61,4,JobNumber)=13 s $$$ISCQUERYTEMP(Index,"ZZZ")=$lb($$$Text("Cannot examine callout process"),"") q $$$OK
 s InitialVariable=Variable,SubNodes=0
 i (Variable'="") {
	i Variable'["(" s SubNodes=1
#;If we get a null value, try again
	s Value=$zu(88,2,Pid,Variable) i Value="" h .01 s Value=$zu(88,2,Pid,Variable)
#; Now determine if the variable is a null string or undefined
	i Value="" {
		s Variable1=$e($p(Variable,"(",1),1,$l($p(Variable,"(",1))-1)
		f  s Variable1=$zu(88,1,Pid,Variable1) q:(Variable1=Variable)!(Variable1="")!(Variable1]Variable)
		i Variable1=Variable {
			s Value=""
		} else {
			s Value="<UNDEFINED>"
		}
	}
#;In the future, if we want to filter on the data as well as the variable, we could change the code
#;to do the following here and elsewhere we use the filter:
#; s Row=$lb(Variable,$$Format^%qcr(Value,Format))
#; i $zcvt($listtostring(Row,$c(13)),"U")[Filter {
#;    s $$$ISCQUERYTEMP(Index,Variable)=Row
#;    s RowCount=RowCount+1 i (RowCount>MaxRows) g Exit
#; }
	i $zcvt(Variable,"U")[Filter {
		s $$$ISCQUERYTEMP(Index,Variable)=$lb($$FormatName^%qcr(Variable,Format),$$Format^%qcr(Value,Format))
 		s RowCount=RowCount+1 i (RowCount>MaxRows) g Exit
	}
 }
 i (Variable="")!(SubNodes) {
	f i=1:1 {
		s Variable=$zu(88,1,Pid,Variable)
		q:(Variable="")!((SubNodes=1)&($p(Variable,"(",1)]$p(InitialVariable,"(",1)))
		s Value=$zu(88,2,Pid,Variable) i Value="" h .01 s Value=$zu(88,2,Pid,Variable)
		i $zcvt(Variable,"U")[Filter {
			s $$$ISCQUERYTEMP(Index,Variable)=$lb($$FormatName^%qcr(Variable),$$Format^%qcr(Value,Format))
		 	s RowCount=RowCount+1 i (RowCount>MaxRows) g Exit
		}
	}
 }
 s Variable="~"_InitialVariable,InitialVariable=Variable
 i (Variable'="~") {
	i Variable'["(" s SubNodes=1
	s Value=$S($zu(88,6,Pid,Variable)#2:$zu(88,2,Pid,Variable),1:"<UNDEFINED>")
#;Use $c(1) to make sure it orders after the public variable
	i Value'="<UNDEFINED>" {
		i $zcvt(Variable,"U")[Filter {
#;SML940+ ; we want to put private variable after public variable so put ")" in between variable name and "(".
			s vsub=$p(Variable,"(",1)_")"_$s(Variable["(":"(",1:"")_$p(Variable,"(",2,$l(Variable,"("))
			s $$$ISCQUERYTEMP(Index,$e(vsub,2,*))=$lb($$FormatName^%qcr($e(Variable,2,$l(Variable)))_" (private)",$$Format^%qcr(Value,Format))
#;SML940-
			k:$lg($g($$$ISCQUERYTEMP(Index,$$FormatName^%qcr($e(Variable,2,$l(Variable))))),2)="<UNDEFINED>" $$$ISCQUERYTEMP(Index,$e(Variable,2,$l(Variable)))
	 		s RowCount=RowCount+1 i (RowCount>MaxRows) g Exit
		}
	}
 }
 i (Variable="~")!(SubNodes) {
	f i=1:1 {
		s Variable=$zu(88,1,Pid,Variable)
		q:(Variable="")!((SubNodes=1)&($p(Variable,"(",1)'=$p(InitialVariable,"(",1)))
		s Value=$zu(88,2,Pid,Variable) i Value="" h .01 s Value=$zu(88,2,Pid,Variable)
#;SML940+ ; we want to put private variable after public variable so put ")" in between variable name and "(".
		s vsub=$p(Variable,"(",1)_")"_$s(Variable["(":"(",1:"")_$p(Variable,"(",2,$l(Variable,"("))
		i $zcvt(Variable,"U")[Filter {
			s $$$ISCQUERYTEMP(Index,$e(vsub,2,*))=$lb($$FormatName^%qcr($e(Variable,2,$l(Variable)))_" (private)",$$Format^%qcr(Value,Format))
	 		s RowCount=RowCount+1 i (RowCount>MaxRows) g Exit
		}
#;SML940-
	}
 }
Exit
 Quit $$$OK
VariableExecuteE s $zt=""
 i $g(Variable)="" s $$$ISCQUERYTEMP(Index,"ZZZ")=$lb("ERROR","<NOJOB>") q $$$OK
 s $$$ISCQUERYTEMP(Index,"ZZZ")=$lb("ERROR",$ze)
 i $ze["<NOJOB>" s $$$ISCQUERYTEMP(Index,"ZZZ")=$lb("ERROR","<NOJOB>")
 i $ze["<INTERRUPT>" s $$$ISCQUERYTEMP(Index,"ZZZ")=$lb(Variable,"<INTERRUPT>")
 q $$$OK
}

ClassMethod VariableByJobNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 s JobNumber=$li(qHandle,1),Variable=$li(qHandle,2),Index=$li(qHandle,3)
 s Variable=$o($$$ISCQUERYTEMP(Index,Variable),1,Row)
 i Variable="" s AtEnd=1,Row=""
 s qHandle=$lb(JobNumber,Variable,Index)
 Quit $$$OK
}

ClassMethod VariableByJobNumberClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = VariableByJobNumberExecute ]
{
 s Index=$li(qHandle,3)
 k $$$ISCQUERYTEMP(Index)
 Quit $$$OK
}

/// Returns the variables of a process, PID is decimal value for all platforms.<br>
/// Pass VariableName as a null string to return all variables.
/// This query requires the %Admin_Manage:Use permission to execute.
/// Parameters:<br>
/// Pid - Pid of process to query<br>
/// VariableName - Variable to return, or ""=All<br>
/// Format - Bit string of how to format the variable data, default = 0 (no formattimg)<br>
/// Bit 0 - Format the data with $c() and $lb() notation<br>
/// Bit 1 - Embed bolded cursor sequences around $c() and $lb() notation<br>
/// MaxRows - Maximum number of rows to return<br>
/// Filter - Filters the data returned (case insensitive). If the variable contains the filter, then return it. ""=no filter<br>
/// Note that the fields returned here may change or be removed in future versions.
Query VariableByPid(Pid As %String, VariableName As %String, Format As %Integer, MaxRows As %Integer, Filter As %String) As %Query(ROWSPEC = "Name:%String,Value:%CacheString") [ SqlProc ]
{
}

ClassMethod VariableByPidExecute(ByRef qHandle As %Binary, Pid As %String, Variable As %String = "", Format As %Integer = 0, MaxRows As %Integer = 9999999, Filter As %String = "") As %Status [ Internal ]
{
 i '($SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite) q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
#;SML655 ;s JobNumber=$s($$$ISVMS:$zh(""_Pid),1:Pid)
 s JobNumber=$zu(67,3,+Pid)
 q ..VariableByJobNumberExecute(.qHandle,JobNumber,Variable,Format,MaxRows,Filter)
}

ClassMethod VariableByPidFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
  q ..VariableByJobNumberFetch(.qHandle,.Row,.AtEnd)
}

ClassMethod VariableByPidClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = VariableByPidExecute ]
{
 q ..VariableByJobNumberClose(.qHandle)
}

///     Select information about Process Private Globals.<br><br>
///     The 'filter' parameter can be a variable name definition and/or subscript
/// definition, using * as wildcards. A filter name of '*' will return all 
/// PPG variables for that process id.<br>
///     As an example of using the wildcards, a filter specification of "CUST*(12*,*COOP*" would
/// mean return all PPG variables whose name starts with CUST, that have 2 or more subscripts,
/// the first subscript must start with 12, the second subscript must contain COOP.<br><br>
///     pid can be any valid process id, or -1 for the caller's process.<br><br>
///     options can be one or more of the following characters<br>
///     "N"      Do not return subscripts of a PPG, just return the root name<br>
///     "B"      Return the number of blocks used by the PPG (needs the "N" option)<br>
///     "b"      Returns the number of bytes used by the PPG (needs the "N" option)<br><br>
/// Example<br>
///     set rs=##class(%ResultSet).%New("%SYS.ProcessQuery:PPG")<br>
///     do  rs.Execute("*",$J,"NB")<br>
///     for {<br>
///         q:'rs.Next()<br>
///         w "PPG name "_rs.GetData(1)_" is using "_rs.GetData(3)_" disc blocks",!<br>
///     }<br>
/// This query requires the %Admin_Manage:Use permission to execute.<br>
Query PPG(filter As %String = "*", pid As %Integer = -1, options As %String = "") As %Query(ROWSPEC = "key,name:%String:Subscript Key,value:%String:Subscript key,blocks:%String:Subscript")
{
}

ClassMethod PPGExecute(ByRef qHandle As %Binary, filter As %String = "*", pid As %Integer = -1, options As %String = "") As %Status [ Internal ]
{
	i '($SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)!$$$IOwnCACHESYSWrite) q $$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
	s rc=$$PPGExecute^|"%SYS"|JOBEXAM(.qHandle , filter , pid , options)
	Quit $S(rc=0:$$$OK,1:0)
}

ClassMethod PPGClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
	Quit $$$OK
}

ClassMethod PPGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
	set:($$PPGNext^|"%SYS"|JOBEXAM(.qHandle , .Row)) AtEnd=1
	Quit $$$OK
}

ClassMethod PPGInfo(pid As %Integer) As %String [ Internal ]
{
	#;
    #; Get some initial database information for Process Private Globals
    #; We return a list of details as follows
    #;   Element 1. SFN for the PPG
    #;   Element 2. Non-zero if a big database
    #;   Element 3. Size of database (usually 2048 or 8192)
    #;   Element 4. Name of directory of database.
    #;   Element 5. First block number to start reading the PPG
    #;
    set i=$zu(67,25,pid),sfn=$p(i,"^",1),blk=$p(i,"^",2)
    q:((sfn="")||(blk="")) ""
    set sfn=sfn+0                       // Must be numeric for some calls to work
    set DIRNAM=$p($zu(49,sfn,3),"^",2)
    q:(DIRNAM="") ""
    set info=$zu(49,DIRNAM),isbig=$p(info,",",$$$bigdbpiece),dbsize=$p(info,",",$$$blksizpiece)
	set ret = $lb(sfn , isbig , dbsize , DIRNAM,blk)
	q ret
}

/// Returns the top Processes as measured by the recent activity of either
/// CommandsExecuted or GlobalReferences<br><br>
/// Parameters:<br>
/// Sort - sort by "COMMANDS" (default) or "GLOREFS"<br>
/// Number - number of processes to list. Default is 10 and max is 50<br><br>
/// Note that the evaluation of the actual 'top' process list is handled by the
/// Application Monitor (%MONAPP) using the %Monitor.System.Dashboard2 class. This 
/// is 'on' by default and can be managed using the %MONAPPMGR utility. Also, the 
/// counts of CommandsExecuted and GlobalReferences returned are for the latest sample
/// period and not the total for the life of the process.
Query Top(Sort As %String = "COMMANDS", Number As %Integer = 10) As %Query(ROWSPEC = "Process:%Integer,JobType:%Integer,Device:%String,Namespace:%String,Routine:%String,CPU:%BigInt,Glob:%BigInt,Pr:%Integer,User:%String,Location:%String")
{
}

ClassMethod TopExecute(ByRef qHandle As %Binary, Sort, Number) As %Status [ Internal ]
{
	s Index=$i($$$ISCQUERYTEMP)
	i +$g(Number)=0 s Number=10
	i Number>50 s Number=50
	#; fetch process list from memory
	s list=$ZU(190,12,2,Number),i=1
	i $g(Sort) = "GLOREFS" s first=Number+2,last=(Number*2)+1
	e  s first=2,last=Number+1
	f p=first:1:last {
		s n=$p(list,",",p),i=i+1
		i $g(Sort)="GLOREFS" s $$$ISCQUERYTEMP(Index,i)=$p(n,";")_";"_$p(n,";",3)_";"_$p(n,";",2)
		e  s $$$ISCQUERYTEMP(Index,i)=n
	}
	s qHandle=Index_"^"
	Quit $$$OK
}

ClassMethod TopFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
	s Index=$p(qHandle,"^",1),next=$p(qHandle,"^",2),next=$o($$$ISCQUERYTEMP(Index,next))
	i next="" s AtEnd=1,Row="",qHandle=Index_"^" q $$$OK
	s qHandle=Index_"^"_next,proc=$$$ISCQUERYTEMP(Index,next)
	#; convert PID and call JOBEXAMFetch
	s pid=$p(proc,";")
	i pid="" s Row=$lb(0,"none"),AtEnd=0 q $$$OK
	s job=$zu(67,3,pid),jhandle="J"_job_"^TOP"
	s status=..JOBEXAMFetch(.jhandle,.Row,.AtEnd)
	#; replace commands and glorefs with deltas
	i Row]"" s $list(Row,6)=$p(proc,";",2),$list(Row,7)=$p(proc,";",3)
	q status
}

ClassMethod TopClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 	s Index=$p(qHandle,"^",1)
	Kill $$$ISCQUERYTEMP(Index)
	Quit $$$OK
}

/// Returns the top Processes for certain types of database activity for the next 'n' seconds.
/// The query can be sorted by one of the following properties: 'GlobalReferences', 
/// 'GlobalUpdates', 'GlobalDiskReads', 'GlobalBlocks', or 'PrivateGlobalBlockCount'.<br><br>
/// Parameters:<br>
/// Sort - sort by "REFS", "UPDATES", "READS", "BLOCKS", "PPG". Default is "REFS". <br>
/// Number - number of processes to list. Default is 20.<br>
/// Seconds - number of seconds to wait. Default is 5 seconds.<br><br>
/// The query will fetch the values for all processes, wait for 'n' seconds, and then 
/// fetch the values again. It will return the list of the 'top' processes for the selected 
/// 'Sort' property, and the delta values for properties over that time period. Note that
/// PrivateGlobalBlockCount is returned as the total number used, not a delta.
Query TopGlobal(Sort As %String = "REFS", Number As %Integer = 20, Seconds As %Integer = 5) As %Query(ROWSPEC = "Process:%Integer,User:%String,Namespace:%String,Routine:%String,JobType:%Integer,GloRefs:%BigInt,PhysReads:%Integer,GloUpdates:%Integer,BlkAlloc:%Integer,PPGBlks:%Integer")
{
}

ClassMethod TopGlobalExecute(ByRef qHandle As %Binary, Sort, Number, Seconds) As %Status [ Internal ]
{
#define 4BYTES  4294967295
#define 8BYTES	18446744073709551615

	s Index=$i($$$ISCQUERYTEMP),MaxPid=$$$STmaxpid
	s job=1,Sort=$g(Sort,"REFS"),Number=$g(Number,20),Seconds=$g(Seconds,5)
	s sort=$s(Sort="REFS":1,Sort="READS":2,Sort="UPDATES":3,Sort="BLOCKS":4,Sort="PPG":5,1:1)
	#; first collection
	f job=1:1:MaxPid {
		i $zu(61,17,job)=0 Continue
		s val=""
		#; collect glorefs, phyrd, gloupd, and blkalloc, and ppg. Note PPG is set to 0 in first pass
		#; so we can just return the total used, not the differential.
		f z=9,34,35,36 s val=val_$zu(61,z,job)_";"
		s val=val_"0;" ;PPG
		s $$$ISCQUERYTEMP(Index,"collect",job)=val
	}
	h Seconds
	#; second collection
	f job=1:1:MaxPid {
		i $zu(61,17,job)=0 k $$$ISCQUERYTEMP(Index,"collect",job) Continue
		s oldval=$g($$$ISCQUERYTEMP(Index,"collect",job)) s:oldval="" oldval="0;0;0;0;"
		s (newval,delta)=""
		#; collect glorefs, phyrd, gloupd, and blkalloc
		f z=9,34,35,36 s newval=newval_$zu(61,z,job)_";"
		s newval=newval_$zu(61,33,job)_";"  ;PPG
		f p=1:1:5 {
			s diff=$p(newval,";",p)-$p(oldval,";",p)
			i diff<0 {
				s rollover=$s($p(oldval,";",p)>$$$4BYTES:$$$8BYTES,1:$$$4BYTES)
				s diff=(rollover-$p(oldval,";",p))+$p(newval,";",p)
			}
			s delta=delta_diff_";"			
		}
		s $$$ISCQUERYTEMP(Index,"sort",$p(delta,";",sort),job)=delta
	}
	k $$$ISCQUERYTEMP(Index,"collect")
	#; sort the 'top' processes
	s delta="",cnt=0
	f {
		s job=""
		s delta=$o($$$ISCQUERYTEMP(Index,"sort",delta),-1) q:delta=""
		f  {
			s job=$o($$$ISCQUERYTEMP(Index,"sort",delta,job)) q:job=""
			s cnt=cnt+1,val=$$$ISCQUERYTEMP(Index,"sort",delta,job)
			s PID=$zu(61,17,job),nsp=$zu(61,6,job),user=$zu(61,22,job),type=$zu(61,10,job)
			i $e(nsp,1,2)="@@" s nsp="^^"_$e(nsp,3,*)
			s rtn=$zu(61,5,job)
			s $$$ISCQUERYTEMP(Index,cnt)=$lb(PID,user,nsp,rtn,type,$p(val,";"),$p(val,";",2),$p(val,";",3),$p(val,";",4),$p(val,";",5))
			q:cnt=Number
		}
		q:cnt=Number
	}
	k $$$ISCQUERYTEMP(Index,"sort")
	s qHandle=Index_"^"
	Quit $$$OK
}

ClassMethod TopGlobalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
	$$$DEFAULTFETCHPPG
	q $$$OK
}

ClassMethod TopGlobalClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
 	s Index=$p(qHandle,"^",1)
	Kill $$$ISCQUERYTEMP(Index)
	Quit $$$OK
}

/// Enable journaling within the process, with temporarily elevated role
ClassMethod EnableJournalInt() As %Status [ Internal ]
{
 $$$AddAllRoleTemporary
 D ENABLE^%SYS.NOJRN
 q $$$OK
}

/// Disable journaling within the process, with temporarily elevated role.<br>
/// Returns 1 if journaling was active prior to this; 0 otherwise (i.e., no action taken)
ClassMethod DisableJournalInt() As %Boolean [ Internal ]
{
 $$$AddAllRoleTemporary
 q $$STOP^%SYS.NOJRN()
}

/// Retrieve a snapshot of the execution stack and variables for a process in the same format as JOBEXAM.<br>
/// <br>
/// Parameters:<br>
/// Pid - Process ID ($J) of the process to examine<br>
/// GetVariables - Flag to specify that all variables and their values should be returned<br>
/// Timeout - How long to wait for the process to respond to the request<br>
/// <br>
/// Return Value:<br>
/// On success, the method will return an index of the ^mtemp global (greater than zero).<br>
/// If an error occurs a status code is returned.<br>
/// Note that, like JOBEXAM, the request will time out if the process is not executing commands.<br>
/// <br>
/// The data in the ^mtemp node can be displayed by calling Show^%STACK(index).<br>
/// It is the responsibility of the caller to Kill ^mtemp(index) when finished with the data.<br>
/// <br>
/// The data is returned in these nodes of the ^mtemp(index) global:<br>
/// ("*STACK") = the number of stack levels<br>
/// ("*STACK",0,"V",SpecialVar) = the values of special variables such as $S and $ZE<br>
/// ("*STACK",level,"L") = the text line for this level, as displayed by %STACK or JOBEXAM<br>
/// ("*STACK",level,"S") = the source line for this level, with a tilde inserted in front of the current command<br>
/// ("*STACK",level,"I") = the internal data for this level<br>
/// <br>
/// If variables are requested:<br>
/// ("*LEVEL",level,variable) = the base level of a variable that is visible at this level<br>
/// ("*NAMES",variable,base,level) - this is the same information as *LEVEL in a different format<br>
/// ("*STACK",base,"V",variable) = the value of the variable at its base level<br>
ClassMethod ExamStackByPid(Pid As %String, GetVariables As %Boolean = 0, Timeout As %Integer = 10) As %Status
{
	If '$D(Pid) Quit $$$ERROR($$$RequiredArgumentMissing)
	#; Convert "no variables" boolean arg to special "never" value for %STACK
	Set:'GetVariables GetVariables=-1
	If Pid'=$J {
		Set sub=$$REMSTACK^|"%SYS"|JOBEXAM(Pid,Timeout,GetVariables,0)
		If 'sub Quit $$$ERROR($$$GeneralError,$E(sub,2,*))
	} Else {
		#; don't include this Parameter frame
		Set sub("Lev")=$ZU(41)-1
		Do INT^%STACK(.sub,GetVariables)
	}
	#; Clean the ID node used by REMSTACK
	Kill ^mtemp(sub,"ID")
	Q sub
}

/// Get a $LIST of devices that a process has open.<br>
/// <br>
/// Parameters:<br>
/// Pid - Process ID ($J) of the process to examine<br>
/// <br>
/// Return Value:<br>
/// On success, the method will return a $LIST of devices that are currently open by the process.
/// The principal device is the first item in the list. The current device has an asterisk appended to the name.<br>
/// If an error occurs an empty string is returned.<br>
ClassMethod GetOpenDevices(Pid As %Integer) As %List
{
	Try {
		If $E(Pid)="J" Set Pid=$zu(61,17,$E(Pid,2,*))
		Set devs=$LG(..GetViewList(Pid),3)
		If devs=0 Return ""
		If $E(devs,*)="," Set $E(devs,*)=""
		Return $ListFromString(devs,",")
	} Catch {
		Return ""
	}
}

Storage Process
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Map1">
<Data name="CSPSessionID">
<RetrievalCode> s {*}=$zu(61,14,{1D1})</RetrievalCode>
</Data>
<Data name="CanBeExamined">
<RetrievalCode> 
 s {*}=0
 if $zu(61,17,{1D1})=$j q
 #; $ZU(61,31,job,2) returns true if the job can be examined
 if $ZU(61,31,{1D1},2) s {*}=1
</RetrievalCode>
</Data>
<Data name="CanBeSuspended">
<RetrievalCode> 
s {*}=0
if $zu(61,17,{1D1})=$j q
n State
#; $ZU(61,31,job,3) returns true if the job can be suspended
if $ZU(61,31,{1D1},3) s State=##Class(%SYS.ProcessQuery).StateLogicalToDisplay($zu(61,4,{1D1})) i State'["SUSP" s {*}=1
</RetrievalCode>
</Data>
<Data name="CanBeTerminated">
<RetrievalCode>s {*}=0
if $zu(61,17,{1D1})=$j q
#; $ZU(61,31,job,1) returns true if the job can be terminated
if $ZU(61,31,{1D1},1) s {*}=1
</RetrievalCode>
</Data>
<Data name="CanReceiveBroadcast">
<RetrievalCode> s {*}=($zu(61,10,{1D1})=$$$FOREJOB||($zu(61,10,{1D1})=$$$FORAPPJOB))</RetrievalCode>
</Data>
<Data name="ClientExecutableName">
<RetrievalCode> s {*}=$zu(61,13,{1D1})</RetrievalCode>
</Data>
<Data name="ClientIPAddress">
<RetrievalCode>s {*}=$zu(61,15,{1D1}) </RetrievalCode>
</Data>
<Data name="ClientNodeName">
<RetrievalCode> s {*}=$zu(61,12,{1D1})</RetrievalCode>
</Data>
<Data name="CommandsExecuted">
<RetrievalCode> s {*}=$zu(61,8,{1D1})</RetrievalCode>
</Data>
<Data name="CurrentDevice">
<RetrievalCode> 
s {*}=$zu(61,7,{1D1})
</RetrievalCode>
</Data>
<Data name="CurrentLineAndRoutine">
<RetrievalCode>s {*}=##Class(%SYS.ProcessQuery).GetCurrentLineAndRoutine({1D1})
</RetrievalCode>
</Data>
<Data name="CurrentSrcLine">
<RetrievalCode>s {*}=##Class(%SYS.ProcessQuery).GetCurrentSrcLine({1D1})
</RetrievalCode>
</Data>
<Data name="DataBlockWrites">
<RetrievalCode> s {*}=$zu(61,38,{1D1}) </RetrievalCode>
</Data>
<Data name="GlobalBlocks">
<RetrievalCode> s {*}=$zu(61,36,{1D1}) </RetrievalCode>
</Data>
<Data name="GlobalDiskReads">
<RetrievalCode> s {*}=$zu(61,34,{1D1}) </RetrievalCode>
</Data>
<Data name="GlobalReferences">
<RetrievalCode> s {*}=$zu(61,9,{1D1})</RetrievalCode>
</Data>
<Data name="GlobalUpdates">
<RetrievalCode> s {*}=$zu(61,35,{1D1}) </RetrievalCode>
</Data>
<Data name="InTransaction">
<RetrievalCode> s {*}=$zu(61,19,{1D1})</RetrievalCode>
</Data>
<Data name="IsGhost">
<RetrievalCode> s {*}=$s($zu(61,0,{1D1})=1:1,1:0)</RetrievalCode>
</Data>
<Data name="JobNumber">
<RetrievalCode> s {*}={1D1}</RetrievalCode>
</Data>
<Data name="JobType">
<RetrievalCode> s {*}=$zu(61,10,{1D1})</RetrievalCode>
</Data>
<Data name="JournalEntries">
<RetrievalCode> s {*}=$zu(61,37,{1D1}) </RetrievalCode>
</Data>
<Data name="LastGlobalReference">
<RetrievalCode>s {*}=##Class(%SYS.ProcessQuery).GetLastGlobalReference({1D1})
</RetrievalCode>
</Data>
<Data name="LicenseUserId">
<RetrievalCode>s {*}=$SYSTEM.License.GetUserId({L1})
</RetrievalCode>
</Data>
<Data name="LinesExecuted">
<RetrievalCode> s {*}=$zu(61,8,{1D1})</RetrievalCode>
</Data>
<Data name="Location">
<RetrievalCode> s {*}=""
 n j,zr,cdev
 s j=$zu(61,10,{1D1})
 s cdev=$ZU(61,32,{1D1})  ;%SS process name
 if cdev'="" s {*}=cdev q
 s cdev=$s(j=$$$TASKTYPE:$$$TASKNAME,j=$$$ECPWorker:$$$ECPWorkerNAME,j=$$$NETSRVTYPE:$$$NETSRVTYPENAME,j=$$$NETDMNTYPE:$$$NETDMNTYPENAME,j=$$$JOBSRVTYPE:$$$JOBSRVTYPENAME,j=$$$DBXDMNTYPE:$$$DBXDMNTYPENAME,((j=$$$ECPCliR)!(j=$$$ECPCliW)!(j=$$$ECPSrvR)!(j=$$$ECPSrvW)):$zu(61,12,{1D1}),1:"")
 if cdev'="" s {*}=cdev q
 s cdev=$zu(61,7,{1D1})
#; If switch 10 is set don't reference a global unless we have it set ourselves
 i (cdev="") q
 i '+$SYSTEM.Util.CheckSwitch(10) q
 s zr=$zr
 s {*}=$G(^%IS(cdev,0)) 
 s $zr=zr
   </RetrievalCode>
</Data>
<Data name="LoginRoles">
<RetrievalCode> 
s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
s {*}=$p({1D2},"^",19)
</RetrievalCode>
</Data>
<Data name="MemoryAllocated">
<RetrievalCode> 
s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
s {*}=$p({1D2},"^",11)*2 // GGC736
</RetrievalCode>
</Data>
<Data name="MemoryPeak">
<RetrievalCode> 
s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
s {*}=$p({1D2},"^",17)
</RetrievalCode>
</Data>
<Data name="MemoryUsed">
<RetrievalCode> 
s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
s {*}=$p({1D2},"^",4)
</RetrievalCode>
</Data>
<Data name="NameSpace">
<RetrievalCode> n ns s ns=$zu(61,6,{1D1}) i $e(ns,1,2)="@@" {s {*}="^^"_$e(ns,3,*)} else {s {*}=ns}</RetrievalCode>
</Data>
<Data name="OSUserName">
<RetrievalCode> s {*}=$zu(61,11,{1D1})</RetrievalCode>
</Data>
<Data name="OpenDevices">
<RetrievalCode> 
 n Devices 
 s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
 s Devices=$p({1D2},"^",3)
 i $e(Devices,$l(Devices))="," s Devices=$e(Devices,1,$l(Devices)-1)
 s {*}=Devices
</RetrievalCode>
</Data>
<Data name="PidExternal">
<RetrievalCode> n Pid s Pid=$zu(61,17,{1D1}) s {*}=$s($zversion(1)=1:$zh(Pid),1:Pid)</RetrievalCode>
</Data>
<Data name="PrincipalDevice">
<RetrievalCode> s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
 s {*}=$p($p($p({1D2},"^",3),",",1),"*",1)
</RetrievalCode>
</Data>
<Data name="Priority">
<RetrievalCode> s {*}=$zu(61,21,{1D1})</RetrievalCode>
</Data>
<Data name="PrivateGlobalBlockCount">
<RetrievalCode> s {*}=$zu(61,33,{1D1}) </RetrievalCode>
</Data>
<Data name="PrivateGlobalReferences">
<RetrievalCode> s {*}=$zu(61,39,{1D1})</RetrievalCode>
</Data>
<Data name="PrivateGlobalUpdates">
<RetrievalCode> s {*}=$zu(61,40,{1D1})</RetrievalCode>
</Data>
<Data name="Roles">
<RetrievalCode> 
s:{1D2}="" {1D2}=##Class(%SYS.ProcessQuery).GetView($zu(61,17,{1D1}))
s {*}=$p({1D2},"^",18)
</RetrievalCode>
</Data>
<Data name="Routine">
<RetrievalCode> 
 s {*}=$zu(61,5,{1D1})
 i {*}'="" q
 n j
 s j=$zu(61,10,{1D1})
 n name
 s name=$ZU(61,32,{1D1})  ;%SS display name
 if name'="" s {*}=name q
 s {*}=$s(j=$$$FOREJOB:$$$FOREJOBNAME,j=$$$NETSRVTYPE:$$$NETSRVTYPENAME,j=$$$NETDMNTYPE:$$$NETDMNTYPENAME,j=$$$JOBSRVTYPE:$$$JOBSRVTYPENAME,1:"Unknown"_j)
</RetrievalCode>
</Data>
<Data name="StartupClientIPAddress">
<RetrievalCode> s {*}=$zu(61,24,{1D1})</RetrievalCode>
</Data>
<Data name="StartupClientNodeName">
<RetrievalCode> s {*}=$zu(61,23,{1D1})</RetrievalCode>
</Data>
<Data name="State">
<RetrievalCode> s {*}=##Class(%SYS.ProcessQuery).StateLogicalToDisplay($zu(61,4,{1D1}))</RetrievalCode>
</Data>
<Data name="Switch10">
<RetrievalCode> 
s {*}=0
n sw 
s sw=$SYSTEM.Util.GetSwitch(10) 
i $p(sw,",",2)=$zu(61,17,{1D1}) s {*}=1
</RetrievalCode>
</Data>
<Data name="UserInfo">
<RetrievalCode> s {*}=$zu(61,20,{1D1})</RetrievalCode>
</Data>
<Data name="Username">
<RetrievalCode> s {*}=$zu(61,22,{1D1})</RetrievalCode>
</Data>
<Subscript name="1">
<AccessType>Other</AccessType>
<Accessvar name="1">
<Code> s {1D1}=$zu(67,3,{L1})</Code>
<Variable>{1D1}</Variable>
</Accessvar>
<Accessvar name="2">
<Code> s {1D2}=""</Code>
<Variable>{1D2}</Variable>
</Accessvar>
<Expression>{Pid}</Expression>
<Invalidcondition name="1">
<Expression>##Class(%SYS.ProcessQuery).AllowToOpen({L1})'=1</Expression>
</Invalidcondition>
<NextCode> s {L1}=##Class(%SYS.ProcessQuery).NextProcess({L1},1) q:{L1}=""  i ##Class(%SYS.ProcessQuery).AllowToOpen({L1})'=1 g NEXT</NextCode>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^SYS.ProcessQueryS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
