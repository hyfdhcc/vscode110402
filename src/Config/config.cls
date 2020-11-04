Include (%syConfig, ISCFILEDIR, %syEMS)

/// This class allows you to modify and view the [config] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters, or use Object sytax to open and directly manipulate the config
/// objects.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.config).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("MaxServers")
/// Properties("MaxServers")=2
/// %SYS>s Properties("MaxServers")=3
/// %SYS>s Status=##Class(Config.config).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.config).Open()
/// %SYS>w Obj.MaxServers
/// 3
/// %SYS>s Obj.MaxServers=4
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.config Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// List of properties which are in the class but not in the CPF file.<br>
/// These are properties which are combined with other properties to create
/// a property in the CPF file.
Parameter PROPERTIESNOTINCPF = "ConsoleFile,globals2kb,globals4kb,globals8kb,globals16kb,globals32kb,globals64kb,LineRecallEntries,LineRecallBuffer,LockSharedMemory,LockTextSegment,OsType,Platform,synctypePresent,VMSConsoleTerminal,ZFString,ZFSize";

/// List of properties which may or may not be in the CPF file.<br>
/// They have a corresponding %Boolean
/// property to determine if they are in the file or not. For example, the property
/// "Asyncwij" will have a %Boolean "AsyncwijPresent" property associated with it.<br>
Parameter PROPERTIESMAYBEINCPF = "Asyncwij,Edstrategy,maxglorecord,Maxprocesses,synctype,usedirectio,useresidentmem,wdparm,wdstrategy,wduseasyncio,jrnbufs";

/// List of properties in the CPF file which are constructed from multiple different 
/// properties in this class.<br>
Parameter PROPERTIESCOMBINEDINCPF = "globals,console,history,memlock,overview,zfheap";

/// List of properties which do not require a restart to activate
Parameter PROPERTIESACTIVATENORESTART = "bbsiz,ConsoleFile,LibPath,LineRecallBuffer,LineRecallEntries,locksiz,MaxServers,netjob,VMSConsoleTerminal,wijdir,ZFSize,ZFString";

/// Controls  how writes to the WIJ file on systems which support asynchronous
/// WIJ I/O.<br> Zero disables asynchronous writes. A non-zero value represents the # of I/O
/// buffers the system should use when writing to the WIJ. 1 and 2 are the same and indicate
/// 2 buffers. The maximum value is constrained by the maximum number of writes the system
/// was built to support.
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property Asyncwij As %Integer(MAXVAL = 128, MINVAL = 0) [ InitialExpression = 0, Internal ];

Property AsyncwijPresent As %Boolean [ InitialExpression = 0, Internal ];

/// Maximum amount of memory a process can use (in KB).<br>
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property bbsiz As %Integer(MAXVAL = 2147483647, MINVAL = 128) [ InitialExpression = 262144 ];

/// CPF file representation of console=VMSConsoleTerminal,ConsoleFile.<br>
Property console As %String(MAXLEN = 300) [ InitialExpression = ",", ReadOnly ];

/// Location of the cconsole.log file.<br>
/// Null means the MGR directory.<br>
/// This is the second piece of the CPF parameter console=VMSConsoleTerminal,ConsoleFile
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property ConsoleFile As %SysPath(MAXLEN = 256, MINLEN = 0);

Method ConsoleFileSet(Val) As %Status [ Internal ]
{
}

/// Modifying this property will require a restart of the system to make it active.
Property Edstrategy As %Integer(MAXVAL = 256, MINVAL = -2147483648) [ InitialExpression = 0, Internal ];

Property EdstrategyPresent As %Integer [ InitialExpression = 0, Internal ];

/// Size of journal buffer pool in MBs. Modifying this property will require a restart of the system to make it active.
Property jrnbufs As %Integer(MAXVAL = 1024, MINVAL = 0) [ InitialExpression = 0, Internal ];

Property jrnbufsPresent As %Integer [ InitialExpression = 0, Internal ];

/// Maximum number of entries you want to store in the SYSLOG log file.<br>
/// The log file will expire old entries when this limit is reached.
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property errlog As %Integer(MINVAL = 10) [ InitialExpression = 500 ];

/// List of configured sizes (in MBytes) for the global caches.<br>
/// Element #1 corresponds to 2KB blocks (deprecated, always 0 now).<br>
/// Element #2 corresponds to 4KB blocks.<br>
/// Element #3 corresponds to 8KB blocks.<br>
/// Element #4 corresponds to 16KB blocks.<br>
/// Element #5 corresponds to 32KB blocks.<br>
/// Element #6 corresponds to 64KB blocks.<br>
Property globals As %String [ InitialExpression = "0,0,0,0,0,0", ReadOnly ];

/// Number of 2KB buffers in MB.<br>
/// DEPRECATED: Always set to 0 now.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property globals2kb As %Integer(MINVAL = 0) [ InitialExpression = 0, Internal ];

Method globals2kbSet(Val) As %Status [ Internal ]
{
}

/// Number of 4KB buffers in MB.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property globals4kb As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

Method globals4kbSet(Val) As %Status [ Internal ]
{
}

/// Number of 8KB buffers in MB.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property globals8kb As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

Method globals8kbSet(Val) As %Status [ Internal ]
{
}

/// Number of 16KB buffers in MB.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property globals16kb As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

Method globals16kbSet(Val) As %Status [ Internal ]
{
}

/// Number of 32KB buffers in MB.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property globals32kb As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

Method globals32kbSet(Val) As %Status [ Internal ]
{
}

/// Number of 64KB buffers in MB.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property globals64kb As %Integer(MINVAL = 0) [ InitialExpression = 0 ];

Method globals64kbSet(Val) As %Status [ Internal ]
{
}

/// Generic Memory Heap Size (in KB).<br>
/// This is the place from where the Lock
/// table, the NLS tables and the PID table are allocated. The absolute minimum value is
/// 2048KB. If you specify a big Lock Table, the minimum value will increase so that there's
/// always room for it. If you are using an Asian locale you may want to add an extra MB (1024KB).
/// <br><br>
/// Note: the maximum value for 32-bit system is 4194240.
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property gmheap As %Integer(MAXVAL = 1073741760, MINVAL = 2048) [ InitialExpression = 21184 ];

ClassMethod gmheapIsValid(Val) As %Status [ Internal ]
{
}

/// CPF file representation of history=LineRecallEntries,LineRecallBuffer.<br>
Property history As %String [ InitialExpression = "32,1024", ReadOnly ];

/// Number of bytes allocated for each InterJob Communication Device.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property ijcbuff As %Integer(MAXVAL = 8192, MINVAL = 512) [ InitialExpression = 512 ];

/// The number of InterJob Communication devices.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property ijcnum As %Integer(MAXVAL = 256, MINVAL = 0) [ InitialExpression = 16 ];

/// On Unix systems this sets the LD_LIBRARY_PATH environment variable to set 
/// search paths for third-party shared libraries. Ignored on Windows and VMS.
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property LibPath As %String(MAXLEN = 1024);

/// The size in bytes of the command line/read line buffer.<br>
/// This is the second piece of the CPF parameter history=LineRecallEntries,LineRecallBuffer
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property LineRecallBuffer As %Integer(MAXVAL = 8192, MINVAL = 0) [ InitialExpression = 1024 ];

Method LineRecallBufferSet(Val) As %Status [ Internal ]
{
}

/// The number of entries held in the command line/read line recall buffer.<br>
/// This is the first piece of the CPF parameter history=LineRecallEntries,LineRecallBuffer
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property LineRecallEntries As %Integer(MAXVAL = 256, MINVAL = 0) [ InitialExpression = 32 ];

Method LineRecallEntriesSet(Val) As %Status [ Internal ]
{
}

/// Lock control structures in memory to improve access time.<br>
/// Makes up part of the CPF parameter memlock=.
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property LockSharedMemory As %Boolean [ InitialExpression = 0 ];

Method LockSharedMemorySet(Val) As %Status [ Internal ]
{
}

/// Lock global buffers in memory to improve access time.<br>
/// Makes up part of the CPF parameter memlock=
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property LockTextSegment As %Boolean [ InitialExpression = 0 ];

Method LockTextSegmentSet(Val) As %Status [ Internal ]
{
}

/// The amount of memory allocated on your system for locks, in bytes.<br>
/// The maximum value depends on the gmheap size and not exceeding gmheap size. Memory is allocated in multiples
/// of 64k (65536 bytes) chunks. If you enter a value which is not on a 64k boundary, the
/// value will be rounded to the next higher 64k boundry.
/// Increase the gmheap size if you need more room for the Lock Table.
/// <br><br>
/// Note: the maximum value for 32-bit system is 2147418112.
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property locksiz As %Integer(MAXVAL = 1099511562240, MINVAL = 196608) [ InitialExpression = 1179648 ];

ClassMethod locksizIsValid(Val) As %Status [ Internal ]
{
}

/// Number of global module trace table entries.<br>
Property maxglorecord As %Integer(MINVAL = 200000) [ InitialExpression = 200000, Internal ];

Property maxglorecordPresent As %Boolean [ InitialExpression = 0, Internal ];

/// On USEU2 systems this sets an upper limit on the number of jobs we will
/// allow at any one time.<br>
/// Zero is the default value which means that we do not limit the # of jobs.
/// Any other value sets an upper limit on the job # we'll assign to an incoming
/// job. This means that if the value is reduced while the system is running, until
/// the jobs which have higher pidtab slot #'s exit, we may allow more jobs than
/// requested. <br><br>
/// This can be changed on the running system with $ZU(11,2,<newvalue>).
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property Maxprocesses As %Integer(MAXVAL = 65535, MINVAL = 0) [ InitialExpression = 128, Internal ];

Property MaxprocessesPresent As %Boolean [ InitialExpression = 0, Internal ];

/// Maximum number of clients that can access this server simultaneously.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property MaxServerConn As %Integer(MAXVAL = 254, MINVAL = 0) [ InitialExpression = 1 ];

/// Maximum number of ECP servers that can be accessed from this system.<br>
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active if memory is available in the shared memory heap.
Property MaxServers As %Integer(MAXVAL = 254, MINVAL = 0) [ InitialExpression = 2 ];

/// When checked, this allows you to lock control structures in memory to improve access time.<br>
/// CPF file representation of memlock=
Property memlock As %Integer [ InitialExpression = 0, ReadOnly ];

/// Allows jobs from remote connections to run on your server.<br>
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property netjob As %Boolean [ InitialExpression = 1 ];

/// Enter the maximum number of collation tables. This instructs Caché to reserve space for that many tables at startup.<sp>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property nlstab As %Integer(MAXVAL = 64, MINVAL = 0) [ InitialExpression = 50 ];

Property OsType As %String [ InitialExpression = "Windows", Internal, Required ];

Method OsTypeSet(Val) As %Status [ Internal ]
{
}

Property overview As %String [ InitialExpression = "Windows (Intel)~Windows", ReadOnly ];

/// Path string appended to the PATH= environment variable for system processes. 
/// This is valid for Unix systems only.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property Path As %String(MAXLEN = 1024) [ Internal ];

/// Directory to store the cluster image journal.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property pijdir As %SysPath(MAXLEN = 256, MINLEN = 0);

Property Platform As %String [ InitialExpression = "Windows (Intel)", Internal, Required ];

Method PlatformSet(Val) As %Status [ Internal ]
{
}

/// Number of MB allocated for caching routine buffers.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property routines As %String [ InitialExpression = 0 ];

/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property synctype As %String [ Internal ];

Property synctypePresent As %Boolean [ InitialExpression = 0, Internal ];

/// Maximum size in bytes of the device table.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property udevtabsiz As %Integer(MAXVAL = 65535, MINVAL = 0) [ InitialExpression = 24576 ];

/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property usedirectio As %String [ Internal ];

Property usedirectioPresent As %Integer [ InitialExpression = 0, Internal ];

/// VMS system resident memory name.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property useresidentmem As %String(MAXLEN = 128, MINLEN = 0);

Property useresidentmemPresent As %Boolean [ InitialExpression = 0, Internal ];

/// Number of global vectors. If you access many distinct globals, you may find that<br>
/// increasing the number of global vectors improves system performance.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property vectors As %Integer(MAXVAL = 32, MINVAL = 2) [ InitialExpression = 32 ];

/// Location of the VMS console terminal.<br>
/// This is the first piece of the CPF parameter console=VMSConsoleTerminal,ConsoleFile
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property VMSConsoleTerminal As %SysPath(MAXLEN = 256, MINLEN = 0);

Method VMSConsoleTerminalSet(Val) As %Status [ Internal ]
{
}

/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property wdparm As %String [ Internal ];

Property wdparmPresent As %Integer [ InitialExpression = 0, Internal ];

/// For systems with multiple write daemons this parameter controls how work is
/// assigned when writing blocks back to the database files. <br>
/// 0 - When databases are mounted they are assigned to write
/// daemons based on their physical device with all files for a given device getting
/// assigned to the same write daemon.<br><br>
/// 1 - (Default) On every write daemon cycle the system tracks how many blocks
/// are being written to each volume and assigns the volumes to the write daemons
/// to spread out the work as much as possible.
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property wdstrategy As %Integer(MAXVAL = 1, MINVAL = 0) [ InitialExpression = 0, Internal ];

Property wdstrategyPresent As %Integer [ InitialExpression = 0, Internal ];

/// On Unix systems this means the wd uses async I/O to write to databases.<br> 
/// If a database cannot be opened for direct I/O we fail to mount it. 
/// When set to 0 we use writev() to write blocks back to the databases.
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property wduseasyncio As %Integer(MAXVAL = 1, MINVAL = 0) [ InitialExpression = 0, Internal ];

Property wduseasyncioPresent As %Integer [ InitialExpression = 0, Internal ];

/// Enter the directory for the Write Image Journal file into this text box.<br>
/// <br><br>
/// Modifying this property does not require an instance restart to activate the change except on cluster members.
Property wijdir As %SysPath(MAXLEN = 256, MINLEN = 0);

Method wijdirSet(Directory As %SysPath) As %Status [ Internal ]
{
}

/// The total number of bytes allocated in virtual memory for $ZF input and output parameters, including strings.<br>
/// This is the second piece of the CPF parameter zfheap=ZFString,ZFSize
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property ZFSize As %Integer(MAXVAL = 270336, MINVAL = 0) [ InitialExpression = 0 ];

Method ZFSizeSet(Val) As %Status [ Internal ]
{
}

/// Number of bytes allocated for the each output byte array or string parameter on the $ZF heap.<br>
/// This is the First piece of the CPF parameter zfheap=ZFString,ZFSize
/// <br><br>
/// Modifying this property does not require a restart of the system to make it active.
Property ZFString As %Integer(MAXVAL = 32767, MINVAL = 0) [ InitialExpression = 0 ];

Method ZFStringSet(Val) As %Status [ Internal ]
{
}

/// CPF file representation of zfheap=ZFString,ZFSize
Property zfheap As %String [ InitialExpression = "0,0", Internal, ReadOnly ];

/// Callback called from the Create method which handles the setting of properties
/// which are constructed from a different property.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, ByRef Props As %String) [ Internal ]
{
}

/// Get the console.log file name being used by the system.<br>
/// This will always return a filename. If a %Status error is returned,
/// the name of the file returned will be $zu(12)_cconsole.log. Note that this will
/// return the cconsole.log file the system currently has open, not the one
/// which is defined in the CPF file and not yet activated. <br>
ClassMethod GetConsoleFileName(ByRef Status As %Status) As %String
{
}

ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Special handling for EMS. We can't use IsModified() so we compare against the $System values.
ClassMethod EMSLoad(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Answers the question "Does the property require a restart?"
ClassMethod NoRestartOnActivate(Property As %String) As %Boolean
{
}

/// Updates MaxServerConn to 14 when JoinCluster=1.
ClassMethod UpdateMaxServerConn(CPFFile As %String, Flags As %Integer) As %Status [ Internal ]
{
}

ClassMethod %OnBeforeSaveCallBack(insert As %Integer, Obj As %ObjectHandle) As %Status [ Internal, Private ]
{
}

/// Called from %Save().<br>
/// Validate that the database being created has all its parameters set correctly.<br>
/// Any error returned here will abort the creation of the database.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

Storage Default
{
<Data name="configDefaultData">
<Value name="1">
<Value>Comments</Value>
</Value>
<Value name="2">
<Value>Asyncwij</Value>
</Value>
<Value name="3">
<Value>AsyncwijPresent</Value>
</Value>
<Value name="4">
<Value>bbsiz</Value>
</Value>
<Value name="5">
<Value>console</Value>
</Value>
<Value name="6">
<Value>ConsoleFile</Value>
</Value>
<Value name="7">
<Value>Edstrategy</Value>
</Value>
<Value name="8">
<Value>EdstrategyPresent</Value>
</Value>
<Value name="9">
<Value>errlog</Value>
</Value>
<Value name="10">
<Value>globals</Value>
</Value>
<Value name="11">
<Value>globals2kb</Value>
</Value>
<Value name="12">
<Value>globals4kb</Value>
</Value>
<Value name="13">
<Value>globals8kb</Value>
</Value>
<Value name="14">
<Value>globals16kb</Value>
</Value>
<Value name="15">
<Value>globals32kb</Value>
</Value>
<Value name="16">
<Value>globals64kb</Value>
</Value>
<Value name="17">
<Value>gmheap</Value>
</Value>
<Value name="18">
<Value>history</Value>
</Value>
<Value name="19">
<Value>ijcbuff</Value>
</Value>
<Value name="20">
<Value>ijcnum</Value>
</Value>
<Value name="21">
<Value>LibPath</Value>
</Value>
<Value name="22">
<Value>LineRecallBuffer</Value>
</Value>
<Value name="23">
<Value>LineRecallEntries</Value>
</Value>
<Value name="24">
<Value>LockSharedMemory</Value>
</Value>
<Value name="25">
<Value>LockTextSegment</Value>
</Value>
<Value name="26">
<Value>locksiz</Value>
</Value>
<Value name="27">
<Value>maxglorecord</Value>
</Value>
<Value name="28">
<Value>maxglorecordPresent</Value>
</Value>
<Value name="29">
<Value>Maxprocesses</Value>
</Value>
<Value name="30">
<Value>MaxprocessesPresent</Value>
</Value>
<Value name="31">
<Value>MaxServerConn</Value>
</Value>
<Value name="32">
<Value>MaxServers</Value>
</Value>
<Value name="33">
<Value>memlock</Value>
</Value>
<Value name="34">
<Value>netjob</Value>
</Value>
<Value name="35">
<Value>nlstab</Value>
</Value>
<Value name="36">
<Value>OsType</Value>
</Value>
<Value name="37">
<Value>overview</Value>
</Value>
<Value name="38">
<Value>pijdir</Value>
</Value>
<Value name="39">
<Value>Platform</Value>
</Value>
<Value name="40">
<Value>routines</Value>
</Value>
<Value name="41">
<Value>synctype</Value>
</Value>
<Value name="42">
<Value>synctypePresent</Value>
</Value>
<Value name="43">
<Value>udevtabsiz</Value>
</Value>
<Value name="44">
<Value>usedirectio</Value>
</Value>
<Value name="45">
<Value>usedirectioPresent</Value>
</Value>
<Value name="46">
<Value>useresidentmem</Value>
</Value>
<Value name="47">
<Value>useresidentmemPresent</Value>
</Value>
<Value name="48">
<Value>vectors</Value>
</Value>
<Value name="49">
<Value>VMSConsoleTerminal</Value>
</Value>
<Value name="50">
<Value>wdparm</Value>
</Value>
<Value name="51">
<Value>wdparmPresent</Value>
</Value>
<Value name="52">
<Value>wdstrategy</Value>
</Value>
<Value name="53">
<Value>wdstrategyPresent</Value>
</Value>
<Value name="54">
<Value>wduseasyncio</Value>
</Value>
<Value name="55">
<Value>wduseasyncioPresent</Value>
</Value>
<Value name="56">
<Value>wijdir</Value>
</Value>
<Value name="57">
<Value>ZFSize</Value>
</Value>
<Value name="58">
<Value>ZFString</Value>
</Value>
<Value name="59">
<Value>zfheap</Value>
</Value>
<Value name="60">
<Value>Path</Value>
</Value>
<Value name="61">
<Value>jrnbufs</Value>
</Value>
<Value name="62">
<Value>jrnbufsPresent</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>configDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
