Include %syConfig

/// This class allows you to modify and view the [Miscellaneous] section of the CPF file through
/// programmatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters, or use Object syntax to open and directly manipulate the config
/// objects.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.Miscellaneous).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("NodeNameInPid")
/// Properties("NodeNameInPid")=0
/// %SYS>s Properties("NodeNameInPid")=1
/// %SYS>s Status=##Class(Config.Miscellaneous).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.Miscellaneous).Open()
/// %SYS>w Obj.NodeNameInPid
/// 1
/// %SYS>s Obj.NodeNameInPid=0
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
/// <EXAMPLE>
/// s x=##Class(Config.Miscellaneous).Get(.Properties)
/// </EXAMPLE>
/// Examples: Modify the NodeNameInPid parameter to 1.<br>
/// <EXAMPLE>
/// s Status=##Class(Config.Miscellaneous).Get(.Properties)
/// i '$$$ISOK(Status) q Status
/// s Properties("NodeNameInPid")=1
/// s Status=##Class(Config.Miscellaneous).Modify(.Properties)
/// i '$$$ISOK(Status) q Status
/// </EXAMPLE>
/// <br>
/// Example: Open the active configuration and get the value of the NodeNameInPid Parameter.<br>
/// <EXAMPLE>
/// s Obj=##Class(Config.Miscellaneous).Open(,,.Status)
/// i '$$$ISOK(Status) q Status
/// s NodeNameInPid=Obj.NodeNameInPid
/// </EXAMPLE>
Class Config.Miscellaneous Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// List of properties which may or may not be in the CPF file.<br>
/// They have a corresponding %Boolean
/// property to determine if they are in the file or not.<br>
Parameter PROPERTIESMAYBEINCPF = "DX";

/// This setting modifies the behavior of Caché when DisconnectErr is enabled.<br>
/// 0 - The process receives a <DSCON> error at the next read or write command.<br>
/// 1 - The process receives an asynchronous <DSCON> error at the time a disconnect occurs on the device. This error will occur at the next command executed. Hang commands will be interrupted. <br>
/// AsyncDisconnectError is only applicable to Telnet connections on Windows. It has no effect on any other device type or operating system. If DisconnectErr is set to 0 (false), then AsyncDisconnectError has no effect. 
Property AsyncDisconnectErr As %Boolean [ InitialExpression = 0, Required ];

/// Enable processes to receive asynchronous errors.<br>
/// 0 - Processes cannot receive asynchronous errors.<br>
/// 1 - Processes can receive asynchronous errors.<br>
/// This setting applies to ECP networking. 
Property AsynchError As %Boolean [ InitialExpression = 1, Required ];

/// Process action when debug BREAK command executed.<br>
/// 0 - Breaks are ignored.<br>
/// 1 - Breaks are taken.<br>
Property BreakMode As %Boolean [ InitialExpression = 1, Required ];

/// Controls whether the system resource statistics are updated or not (seize, nseize, 
/// aseize, bseize).<br>
/// 0 - Statistics are not collected<br>
/// 1 - Statistics are collected.<br>
Property CollectResourceStats As %Boolean [ InitialExpression = 0, Required ];

/// Enable a process to receive disconnect errors.<br>
/// This setting conditions how a process responds to a disconnect of the principal 
/// I/O device. <br>
/// Be aware that when error on disconnect is enabled, a process continues to execute after 
/// its principal device has been disconnected. It is the responsibility of the application to 
/// detect the disconnect condition and exit gracefully. Use care when enabling error on disconnect. 
/// The application must be prepared to recognize the <DSCON> error and handle it appropriately 
/// in error traps. Error on disconnect is only applicable to TCP devices and to terminal devices 
/// where a disconnect can be recognized. Examples are modem controlled terminals and Windows 
/// Telnet, Windows LAT, and Windows local cterm (TRM:) connections. Error on disconnect is only 
/// applicable to the principal device.
/// 0 - Process exits without reporting an error to the application when a disconnect is detected.<br>
/// 1 - Process receives a <DSCON> error when a disconnect is detected during a Write or Read command.<br>
Property DisconnectErr As %Boolean [ InitialExpression = 0, Required ];

/// Sets $X update mode for escape sequences system-wide.<br>
/// You can control the way the system updates $X when writing a string containing an escape sequence. 
/// Default behaviors for various system implementations are as follows: <br>
/// UNIX - parses the ANSI standard escape sequence and counts the rest of the non-escape 
/// characters in the string against $X. <br>
/// VMS - Do not count any more characters in the string against $X as soon as they encounter an 
/// escape character ($CHAR(27)). <br>
/// Open M [DSM] - Counts all characters in a string, including the escape character, against $X.<br>
/// Open M [DTM] and Open M [MSM] - Count all characters except for the escape character against $X.<br>
/// A numeric code that controls a nondefault, consistent, system-wide way of updating $X.<br>
/// 0 - Use UNIX default behavior on system. <br>
/// 1 = Use Open M [DSM] default behavior on system.<br> 
/// 2 = Use Open M [DTM]/Open M [MSM] default behavior on system.<br> 
/// 3 = Use OpenVMS Alpha default behavior on system. <br>
/// The default behavior on UNIX zero (0).<br> 
/// The default behavior on VMS is three (3).<br>
Property DX As %Boolean [ InitialExpression = 0 ];

Property DXPresent As %Boolean [ InitialExpression = 0, Internal ];

/// Enable large stack space for long strings.<br>
/// 0 - String stack is not enlarged.<br>
/// 1 - System increases the size of the string stack by approximately 50 times to accommodate operations involving larger strings.<br>
/// Note: Enabling this option may affect performance. Memory is often a precious resource and allocating it to the stack comes at the expense of other uses. Retuning of the system may be needed to maintain performance. 
Property EnableLongStrings As %Boolean [ InitialExpression = 1, Required ];

/// Create a file if it does not exist when called with Write or Read/Write.<br>
/// When 0 (false) and a file is opened for writing that does not exist, a new file is not created 
/// unless the N parameter was provided with the OPEN command.<br>
/// When 1 (true) and a file is opened for writing that does not exist, a new file is created.<br>
Property FileMode As %Boolean [ InitialExpression = 0, Required ];

/// Enable KILL of an unsubscripted global.<br>
/// 0 - KILL of an unsubscripted global results in a <PROTECT> error.
/// 1 - KILL of an unsubscripted global is allowed, so you can kill all subscripts of a global with a single kill instead if killing them individually. 
Property GlobalKillEnabled As %Boolean [ InitialExpression = 1, Required ];

/// Enables or disables $DOUBLE returning INF and NAN values system-wide.<br>
/// This property sets the $DOUBLE function return value behavior system-wide. 
/// If 0, $DOUBLE returns INF (infinity), -INF, and NAN (Not A Number) for unresolvable IEEE 
/// floating point conversions. If 1, $DOUBLE generates Caché errors for unresolvable IEEE 
/// floating point conversions. The property controls the issuing of INF, -INF, and NAN when 
/// a $DOUBLE numeric operation cannot be resolved to a numeric value. It does not control
/// the issuing of INF, -INF, and NAN in all cases. $DOUBLE always returns INF, -INF, or 
/// NAN when you supply one of these strings as the input value, regardless of this property.
/// Mathematical operations on $DOUBLE numbers that result in an INF, -INF, or NAN are controlled 
/// by this property. These include arithmetic operations, exponentiation, and logarithmic and 
/// trigonometric functions. <br>
/// 0 - $DOUBLE returns INF, -INF, or NAN when given an unresolvable numeric expression. <br>
/// 1 - $DOUBLE generates Caché <MAXNUMBER>, <ILLEGAL VALUE>, and <DIVIDE> errors when given an unresolvable numeric expression.
Property IEEEError As %Boolean [ InitialExpression = 1 ];

/// Enable command line recall for READ commands. <br>
/// Read line recall is only used by terminal devices.<br>
/// The OPEN command sets the read line recall mode for a terminal. You can specify the 
/// R protocol (enable) or the N protocol (disable). If neither protocol is specified, 
/// OPEN takes its setting from the current default established by %SYS.ProcessQuery.LineRecall,
/// this property. The USE command can specify the R protocol (enable) or the N protocol (disable) 
/// to change the OPEN mode. If neither protocol is specified, USE takes its setting from the 
/// initial OPEN mode value.
/// An implicit open of an active device, such as issuing a BREAK command, reopens the device 
/// in the same mode as the initial OPEN command. 
/// Modifying this property does not override an OPEN or USE setting for an active terminal. 
/// To change read line recall for an already open terminal device, you must explicitly reopen 
/// the device. You can use this property  or %SYS.ProcessQuery.LineRecall to change the default, 
/// then issue an OPEN 0 command, which reopens the active terminal device, applying the current 
/// default. See Terminal I/O in Caché I/O Device Guide for details on using protocols. <br><br>
/// Read Line Recall<br>
/// Read line recall mode provides line recall of editable lines as input for READ operations 
/// from a terminal. These recallable lines include both previous READ input lines and previous 
/// command lines. Echoing of input lines is a necessary precondition for read line recall. 
/// The system supports read line recall for both variable-length terminal reads (READ var) 
/// and fixed-length terminal reads (READ var#n). The system does not support read line recall 
/// for single-character terminal reads (READ *var). For a fixed-length terminal read, the 
/// recalled line is truncated to one character less than the number of characters specified in 
/// the READ. This final READ character position is reserved for typing a line termination 
/// character, specifying an edit character, or adding one more data character. 
/// When read line recall is active, you can provide input to a READ by using the Up Arrow and 
/// Down Arrow keys to recall a previous terminal input line. You can then use the Left Arrow,
/// Right Arrow, Home, and End keys to position the cursor for editing the recalled line. 
/// You can use the Backspace key to delete a character, Ctrl-X to delete the entire line, 
/// or Ctrl-U to delete all of the line to the left of the cursor. 
/// When read line recall is not active, the four Arrow keys, the Home key, and the End key 
/// all issue a line termination character. You can use the Backspace key to delete a single 
/// input character, and Ctrl-X (or Ctrl-U) to delete the entire input line. Read line recall 
/// can be deactivated by using the -R protocol, or by specifying the N, I, S, or T protocols, 
/// as described in the Terminal I/O chapter of the Caché I/O Device Guide. <br><br>
/// 0 - Command line recall is not enabled.<br>
/// 1 - Command line recall is enabled.<br>
Property LineRecall As %Boolean [ InitialExpression = 1, Required ];

/// Enable logging for transaction rollbacks.<br>
/// 0 - Do not log transaction rollbacks.<br>
/// 1 - Log transaction rollbacks to the console log file.<br>
Property LogRollback As %Boolean [ InitialExpression = 0, Required ];

/// Sets MVBasic handling of undefined variables system-wide.<br>
/// This property function defines MVBasic behavior when it encounters a reference to an 
/// undefined variable. By default, if an MVBasic routine references an undefined variable, 
/// The system generates an <UNDEFINED> error. You can change this default behavior to have 
/// the system substitute an empty string for an undefined variable, without signaling an error.<br> 
/// 0 - issue an <UNDEFINED> error for an undefined variable.<br>
/// 1 - substitute the empty string for an undefined variable.<br>
Property MVDefined As %Boolean [ InitialExpression = 0 ];

/// Behavior when there is a reference to the special variable $JOB. <br>
/// 0 - $JOB returns only the process ID number. 
/// 1 - $JOB returns the process ID number of the current process, concatenated to the nodename.
Property NodeNameInPid As %Boolean [ InitialExpression = 0, Required ];

/// Enable null subscript references.<br>
/// 0 - Throw <SUBSCRIPT> error when referencing a null subscript.<br>
/// 1 - Null subscript references do not throw an error.<br>
Property NullSubscripts As %Boolean [ InitialExpression = 0, Required ];

/// When switching namespace to the same namespace via $zu(5) or ZN, clear global vectors.<br>
/// 0 - Switching to the same namespace is a NOOP.<br>
/// 1 - Switching to the same namespace clears the globals vector cache.<br>
Property OldZU5 As %Boolean [ InitialExpression = 0, Required ];

/// The read/write mode you want used when opening sequential files and no mode is specified in the OPEN command.<br>
/// 0 - Read<br>
/// 1 - Read-Write<br>
Property OpenMode As %Integer(MAXVAL = 1, MINVAL = 0, VALUELIST = ",0,1") [ InitialExpression = 0, Required ];

/// When to pop $ZTRAP error handlers off the stack.<br><br>
/// When a $ZTRAP error handler is invoked by the system, that error handler remains on the stack of
/// established error handlers. Therefore, if an error occurs when the error handler is executing,
/// that error handler attempts to invoke itself, receives the same error again and enters an
/// infinite loop, unless that error handler explicitly sets $ZTRAP to a new value.<br>
/// When a $ZTRAP error handler is invoked in DSM, the error handler is removed from the stack. 
/// Therefore, if an error occurs while the error handler is executing, that error is handled 
/// by the previous error handler on the stack.<br><br>
/// 0 - Normal behavior: A $ZTRAP error handler stays active when the error handler is invoked.<br>
/// 1 - Pop the $ZTRAP error handler off the stack when an error is triggered (DSM compatibility mode). <br>
Property PopError As %Boolean [ InitialExpression = 0, Required ];

/// Result of $NAME and $QUERY when an extended global reference is the argument.<br>
/// 0 - Return the global with an extended reference. <br>
/// 1 - Return the global without reference to where it is on the network. <br>
Property RefInKind As %Boolean [ InitialExpression = 0, Required ];

/// Enables or disables lowercase "e" as scientific notation symbol system-wide.<br>
/// 0 - Disable lowercase "e".<br>
/// 1 - Enable lowercase "e".<br>
Property ScientificNotation As %Boolean [ InitialExpression = 1 ];

/// Behavior when the system encounters an unexpected end-of-file when reading a sequential file.<br>
/// 0 - Throw an <ENDOFFILE> error.<br>
/// 1 - Set the special variable $ZEOF to indicate that you have reached the end of the file. <br>
Property SetZEOF As %Boolean [ InitialExpression = 0, Required ];

/// Write ^SYSLOG errors to the console log file at shutdown.<br>
/// 0 - Do not write ^SYSLOG errors.<br>
/// 1 - Write ^SYSLOG errors.<br>
Property ShutDownLogErrors As %Boolean [ InitialExpression = 0, Required ];

/// Sets $ZF process deletion behavior for OpenVMS STOP/ID system-wide.<br>
/// Using the OpenVMS STOP/ID command to delete a process can cause your 
/// system to fail. For this reason, the system on OpenVMS systems prevent you 
/// from deleting processes with STOP/ID.
/// For processes that are executing $ZF functions, you may need to be able to delete 
/// a process from OpenVMS. Set this value to 0 if you need to terminate processes in a $ZF function.<br>
/// 0 - Enable deletion of Caché processes with STOP/ID.<br>
/// 1 - Disable deletion of Caché processes with STOP/ID.<br>
Property StopID As %Boolean [ InitialExpression = 0 ];

/// Behavior of the current working O/S directory when changing namespaces.<br>
/// 0 - When you change namespaces, the current working directory is changed to the directory of the default database of the new namespace. However, if this dataset is remote (networked to a different system), the current working directory is left unchanged.<br>
/// 1 - When you change namespaces, the current working directory remains unaltered no matter what namespace you switch to.<br>
Property SwitchOSdir As %Boolean [ InitialExpression = 0, Required ];

/// Synchronize TCOMMIT with the corresponding journal write operation.<br>
/// 0 - TCOMMIT does not wait for the write operation to complete. <br>
/// 1 - TCOMMIT does not complete until the journal data write operation completes. Note that setting this
/// property to 1 will have performance implications.<br>
Property SynchCommit As %Boolean [ InitialExpression = 0, Required ];

/// Suppress Telnet NUL at end-of-line system-wide.<br>
/// This property disables or enables the issuance of a NUL character (ASCII 0) following a CR 
/// character (ASCII 13) at end-of-line during Telnet transmission on Windows systems only. It has
/// no affect of Unix or VMS systems. On output, a Telnet network virtual terminal (NVT) 
/// performs the following default end-of-line behavior: either issues a CR 
/// (carriage return character) followed by a LF (linefeed character), or issues a CR 
/// (carriage return character) followed by a NUL character (if no LF is issued). <br>
/// 0 - do not suppress NUL. <br>
/// 1 - suppress NUL. <br>
Property TelnetNUL As %Boolean [ InitialExpression = 0 ];

/// Enable the <MAXNUMBER> error on numeric overflow.<br>
/// When the system encounters a number larger than 9223372036854775807 E127 (or smaller than -9223372036854775808 E127) it throws the <MAXNUMBER> error. <br>
/// 0 - <MAXNUMBER> error is thrown.<br> 
/// 1 - <MAXNUMBER> error is suppressed.<br> 
Property TruncateOverflow As %Boolean [ InitialExpression = 0, Required ];

/// ObjectScript response to undefined variables.<br>
/// 0 - Always throw an <UNDEFINED> error.<br>
/// 1 - If the undefined variable has subscripts, return a null string, but if the undefined variable is single-valued, throw an <UNDEFINED> error.<br>
/// 2 - Always return a null string.<br>
Property Undefined As %Integer(MAXVAL = 2, MINVAL = 0, VALUELIST = ",0,1,2") [ InitialExpression = 0, Required ];

/// Enable the Nagle algorithm for Telnet (Windows only).<br>
/// 0 - Nagle algorithm is disabled.<br>
/// 1 - Nagle algorithm is enabled.<br>
Property UseNagleAlgorithm As %Boolean [ InitialExpression = 0, Required ];

/// Enable $VIEW command to examine data outside of Cache memory area.<br>
/// 0 - $VIEW command throws an error.<br>
/// 1 - $view command does not throw an error.<br>
Property ViewPastData As %Boolean [ InitialExpression = 0, Required ];

/// Determines how the ZALLOCATE (ZA) and ZDEALLOCATE (ZD) commands behave, according to Caché rules or DSM-11 rules.<br>
/// 0 - Caché rules, which means that ZA and ZD behave exactly like LOCK + and LOCK -.<br>
/// 1 - DSM-11 rules, which means that ZA locks can only be unlocked by ZD and LOCK + locks can only be unlocked by LOCK.<br>
Property ZaMode As %Boolean [ InitialExpression = 0, Required ];

/// $ZDATE response to an invalid value. <br>
/// 0 - The valid range is from 0 through 2980013, inclusive, which corresponds to dates from 
/// 12/31/1840 through 12/31/9999. This range can be restricted by setting the $ZDATE mindate 
/// and maxdate parameters. If the date is invalid, the error message <ILLEGAL VALUE> or 
/// <VALUE OUT OF RANGE> will be generated. The behavior can be overridden by supplying an 
/// erropt to the $ZDATE call. <br>
/// 1 - (ISM compatibility) The valid range is from 1 through 94232, inclusive, which corresponds to dates from 01/01/1841 
/// through 12/30/2098. This date range is set for any $ZDATE function call which has three or 
/// fewer parameters. If a $ZDATE function call has more than three parameters, the valid date 
/// range is taken either from the $ZDATE mindate and maxdate parameters (if specified) or 
/// from the date range established for the current locale. If the date is invalid, 
/// $ZDATE will return the null string if you submit an invalid date. This behavior is set for 
/// any $ZDATE function call, regardless of the number of parameters. 
Property ZDateNull As %Boolean [ InitialExpression = 0, Required ];

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

Storage Default
{
<Data name="MiscellaneousDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AsyncDisconnectErr</Value>
</Value>
<Value name="3">
<Value>AsynchError</Value>
</Value>
<Value name="4">
<Value>BreakMode</Value>
</Value>
<Value name="5">
<Value>CollectResourceStats</Value>
</Value>
<Value name="6">
<Value>Comments</Value>
</Value>
<Value name="7">
<Value>DisconnectErr</Value>
</Value>
<Value name="8">
<Value>DX</Value>
</Value>
<Value name="9">
<Value>DXPresent</Value>
</Value>
<Value name="10">
<Value>EnableLongStrings</Value>
</Value>
<Value name="11">
<Value>FileMode</Value>
</Value>
<Value name="12">
<Value>GlobalKillEnabled</Value>
</Value>
<Value name="13">
<Value>IEEEError</Value>
</Value>
<Value name="14">
<Value>LineRecall</Value>
</Value>
<Value name="15">
<Value>LogRollback</Value>
</Value>
<Value name="16">
<Value>MVDefined</Value>
</Value>
<Value name="17">
<Value>NodeNameInPid</Value>
</Value>
<Value name="18">
<Value>NullSubscripts</Value>
</Value>
<Value name="19">
<Value>OldZU5</Value>
</Value>
<Value name="20">
<Value>OpenMode</Value>
</Value>
<Value name="21">
<Value>PopError</Value>
</Value>
<Value name="22">
<Value>RefInKind</Value>
</Value>
<Value name="23">
<Value>ScientificNotation</Value>
</Value>
<Value name="24">
<Value>SetZEOF</Value>
</Value>
<Value name="25">
<Value>ShutDownLogErrors</Value>
</Value>
<Value name="26">
<Value>StopID</Value>
</Value>
<Value name="27">
<Value>SwitchOSdir</Value>
</Value>
<Value name="28">
<Value>SynchCommit</Value>
</Value>
<Value name="29">
<Value>TelnetNUL</Value>
</Value>
<Value name="30">
<Value>TruncateOverflow</Value>
</Value>
<Value name="31">
<Value>Undefined</Value>
</Value>
<Value name="32">
<Value>UseNagleAlgorithm</Value>
</Value>
<Value name="33">
<Value>ViewPastData</Value>
</Value>
<Value name="34">
<Value>ZaMode</Value>
</Value>
<Value name="35">
<Value>ZDateNull</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MiscellaneousDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
