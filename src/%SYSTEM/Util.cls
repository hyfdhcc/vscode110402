Include %sySite

/// The <class>%SYSTEM.Util</class> class provides an interface for managing
/// Cach&eacute; utility functions.<br>
/// 
/// <p>You can use it via the special <b>$SYSTEM</b> object:<br>
/// <p>
/// <p>You can call help to get a list of all entrypoints:<br>
/// <p>
/// Do $SYSTEM.Util.Help()
Class %SYSTEM.Util Extends Help [ Abstract, System = 4 ]
{

/*
---------------------Documentation------------------------------------
RJF202  11/13/15 Ray Fucillo, documentation updates
STC2369 12/09/14 Steve Clay, New $SYSTEM.Util.JavaDirectory() method 
CDS2393  6/06/14 Chuck Sorenson, Add decimal GUID and hex<->decimal conversions
JPL1647  6/04/14 John Lambert, Support System method to reverse MVR collation
RJW2002  1/20/12 Ron Watt, Add $System.Util.GetSessionId and $System.Util.GetOSVersionInfo on Windows
RJW1958 10/05/11 Ron Watt, API to clear SYSLOG without restarting Cache.
SML1331 03/29/11 Simon Li, Update SetSwitch method document for switch 10 and 11.
STC1923 03/27/10 Steve Clay, Update documentation in %SYSTEM.Util
SOH179 12/03/09 Steven Hobbs, Add Local/UTC with ZTIMEZONE conversions
SOH148  9/25/09 Steven Hobbs, Add $System.Util.Collation
SOH126  6/29/09 Steven Hobbs, Remove IsDaylightTime, replace GMT with UTC
SOH125  6/22/09 Steven Hobbs, $System.Util.IsDST API
RJW1709 09/15/09, Ron Watt, $System.Util.IsDaylightTime() function to test for daylight savings time. 
HYY1399 07/14/08, Huayong Yang, document Compress and Decompress methods
SML1017 04/15/08, Simon Li,Add class document for RoutineBufferSize methods.
SML738 07/14/06, Simon Li,Add class document for SetSwitch/GetSwitch/CheckSwitch methods.
PWC923 11/03/04 Peter Cudhea, Created %Library.Function, %Library.Utility,
                and %Sys.System classes.
CFL1114 07/30/04, Carlos Lopes, enhance Replace method
GK333  07/29/04, Garen Kotikian, add Cache instance GUID. 
SML471 07/09/04, Simon Li, Move CleanDeadJob metheod to here.
CFL1098 07/06/04, Carlos Lopes, add Replace method
LFT1235 6/04/04, Laura Tillem, add TempDirectory
SAP177	5/11/04, Steve Pettibone, modify setbatch to SetBatch, change logic
SAP176	5/11/04, Steve Pettibone, document methods and return codes
SAP168	5/10/04, Steve Pettibone, add severity to WriteToConsoleLog
HYY883 03/04/04, Huayong Yang, add APIs for setting/clearing switches
LRS714 08/20/03, Lee Smith, implement NullDevice method
STC464 08/05/03, Steve Clay, Add WriteToConsoleLog
LRS671 03/25/03, Lee Smith, implement GetEnviron method
LRS626 08/30/02, Lee Smith, initial version with InstallDirectory,
                 ManagerDirectory, and BinaryDirectory methods
-------------------End Documentation----------------------------------
*/
/// Returns the location of the installation directory, i.e. that which is displayed by ccontrol on Unix and VMS, where the .cpf configuration file is kept.
ClassMethod InstallDirectory() As %String
{
}

/// Returns the location of the manager directory, where the CACHESYS database and runtime files are kept.
ClassMethod ManagerDirectory() As %String
{
}

/// Returns the location of the binaries directory, where executables, DLL's, shared libraries, scripts, etc are kept.
ClassMethod BinaryDirectory() As %String
{
}

/// Returns the location of the Java Home directory.<br>
/// This method returns the location of the Java Home directory on your system. The return
/// value has been normalized, and is suitable for passing to $zf(-1) or $zf(-2).<br>
/// The location of the Java Home directory which is returned is determined in the 
/// following order:<br>
/// 1) The directory location returned by the configuration parameter JavaHome in the Cache.CPF file.<br>
/// 2) The directory location returned by the environment variable "JAVA_HOME".<br>
/// 3) If none of the above, a null string.<br>
/// Example:<br>
/// s JavaHome=$SYSTEM.Util.JavaHomeDirectory()<br>
ClassMethod JavaHomeDirectory() As %String
{
 s JavaHome=$$GetJavaHome^%SYS.CONFIG()
 i JavaHome'="" q ##Class(%File).NormalizeFilenameWithSpaces(##class(%File).NormalizeDirectory(JavaHome))
 s JavaHome=$System.Util.GetEnviron("JAVA_HOME")
 if JavaHome="" q ""
 q ##Class(%File).NormalizeFilenameWithSpaces(##class(%File).NormalizeDirectory(JavaHome))
}

/// Returns the path name of the Java executable, which can be used to build a command line.<br>
/// This method returns the pathname of the Java executable, which can be used to build a 
/// command line on your system. The return
/// value has been normalized, and is suitable for passing to $zf(-1) or $zf(-2).<br>
/// The method uses the return value from the JavaHomeDirectory() method, appends the 
/// subdirectory "bin" to it, and then adds the Java executable name to the end. If the 
/// JavaHomeDirectory() method returns "", then it is assumed that the Java executable location
/// is in the process path, and the return value of the method is simply the
/// Java executable name.<br><br>
/// Notes:<br>
/// This method does not test for the existence of the Java executable. It assumes it is located in
/// the "bin" directory if JavaHomeDirectory() returns a non-null value, otherwise it must be 
/// in the path of the process executing the method.<br>
/// Example:<br>
/// s JavaExe=$SYSTEM.Util.JavaExe()<br>
/// s Status=$zf(-1,JavaExe_" -version")<br>
ClassMethod JavaExe() As %String
{
 s JavaExe=""
 s JavaHome=..JavaHomeDirectory()
 if JavaHome'="" {
	s JavaExe=##Class(%File).NormalizeFilenameWithSpaces(##class(%File).NormalizeDirectory(##class(%File).SubDirectoryName(JavaHome,"bin"))_$S($$$ISWINDOWS:"java.exe",$$$ISVMS:"java.exe",1:"java"))
 } else {
 	s JavaExe=$S($$$ISWINDOWS:"java.exe",$$$ISVMS:"java.exe",1:"java")
 }
 q JavaExe
}

/// Returns the value of an environment variable.
ClassMethod GetEnviron(VariableName As %String) As %String
{
}

/// Sets or clears batch mode for the calling process, or the one identified by <parameter>pid</parameter>
/// <p>
/// Processes that will access large portions of a database may be set into batch mode to limit their
/// impact on other (non-batch mode) processes running on the system. In particular, batch mode
/// processes are prevented from overwhelming the database cache with the database blocks that they
/// read or modify. 
/// <p>
/// <b>Parameters</b>
/// <p>
/// <parameter>flag</parameter> : 1 sets batch mode; 0 clears batch mode
/// <p>
/// <parameter>pid</parameter> : (optional) target pid; if null or omitted target is the calling process
/// <p>
/// <b>Return Value</b>
/// <p>
/// Returns the old value of the batch flag, or -1 if error
ClassMethod SetBatch(flag As %Integer, pid As %Integer = "") As %Integer
{
}

/// Creates and returns a globally unique identifier. 
/// <br>
/// A GUID is a 16 byte (128 bit) globally unique identifier.
ClassMethod CreateGUID() As %String
{
}

/// Creates and returns the decimal representation of a globally unique identifier. 
/// <br>
/// A GUID is a 16 byte (128 bit) globally unique identifier.
ClassMethod CreateDecimalGUID() As %String
{
	Quit ..HexToDecimal($TR($SYSTEM.Util.CreateGUID(),"-"))
}

/// Returns the number of virtual CPUs (also known as logical CPUs or threads) on the system.
/// <br>
/// For more details see <class>%SYSTEM.CPU</class>. 
ClassMethod NumberOfCPUs() As %Integer
{
}

/// Sets the system-wide job priority delta to the specified number.
/// <br>
/// The priority of any jobbed process on the system = priority of parent + system job priority.
/// <br>
/// The new jobprio value is returned
/// <p>
/// Note: changing priority is almost never needed and can compromise system stability
ClassMethod JobPrio(jprio As %Integer) As %Integer
{
}

/// Returns the priority of the current process or another process.
ClassMethod GetPrio(pid As %Integer = "") As %Integer
{
}

/// Adjusts the priority of the current process or another process up or down by delta amount.
/// <br>
/// The new priority is returned.
/// <p>
/// Note: changing process priority is almost never needed and can compromise system stability
ClassMethod SetPrio(delta As %Integer, pid As %Integer = "") As %String
{
}

/// Returns a list of the number of global buffers for each buffer size.
ClassMethod GlobalBuffers() As %List
{
}

/// Returns the value of one system switch, or the values of all switches.
/// <br><br>
/// When the SwitchNumber is not specified, <method>GetSwitch</method> returns one value containing the state of all system switches.
/// <br>
/// Each system switch is represented by a bit in this value, with switch 0 as the least significant bit and switch 31 as the most significant.
/// <br>
/// For example:<br>
/// Switch 0 -> 1<br>
/// Switch 1 -> 2<br>
/// Switch 2 -> 4<br>
/// ...<br>
/// Switch 31 -> 0x80000000<br><br>
/// 
/// When the SwitchNumber is specified (0 to 31), <method>GetSwitch</method> returns the state of the specific switch represented by SwitchNumber.<br>
/// 
/// The return value is 1 if this switch is set, or 0 if it is cleared.<br>
/// 
/// For switch 10 and 11, it also returns the PID of the job that set this switch in the '1,PID' format.<br><br>
/// 
/// Switch Definitions - <br><br>
/// 
/// Switches 0 to 7 are not used by the system and are reserved for the user.<br>
/// 
/// Switch 8 (0x100)   : Inhibits responding to network request for DCP, DDP and DTM. It does not block ECP traffic.<br>
/// 
/// Switch 9 (0x200)   : Inhibits new network signons, this only apply for DCP.<br>
/// 
/// Switch 10(0x400)   : Inhibits all global and lock access except by the job setting this switch.<br>
/// 
/// Switch 11(0x800)   : Inhibits all global and lock access except by the job setting this switch. This overrides switch 10 and is reserved for use by the system (should only be set by the system).<br>
/// 
/// Switch 12(0x1000)  : Inhibits new users to signon the system.<br>
/// 
/// Switch 13(0x2000)  : Inhibits sets, kills, and zsaves.<br>
/// 
/// Switch 14(0x4000)  : Inhibits access to globals and routines.<br>
/// 
/// Switch 15(0x8000)  : Allow network references from peers, even if switch 10,13, or 14 would normally prevent the access.<br>
/// 
/// Switch 16(0x10000) : Used in ^SHUTDOWN only.<br>
/// 
/// Switch 17(0x20000) : Used internally by system to skip waiting in journal synch.<br>
/// 
/// Switch 18(0x40000) : Used internally by system to disable pausing processes in gblkrd() if the queue for a block gets too long.<br>
/// 
/// Switch 19(0x80000) : Inhibits TSTART.<br>
/// 
ClassMethod GetSwitch(SwitchNumber As %Integer) As %Integer
{
}

/// Sets the value of a system switch.
/// <br><br>
/// When one parameter is specified, <method>SetSwitch(SwitchValue)</method> sets the value of all system switches to <parameter>SwitchValue</parameter>.<br>
/// It returns the original value of all switches.<br>
/// This is not recommended to be used by users.<br><br>
/// 
/// When two parameters are specified, <method>SetSwitch(SwitchNumber,SwitchValue)</method> sets the value of the specific switch <parameter>SwitchNumber</parameter> to <parameter>SwitchValue</parameter>.<br>
/// It returns the original switch value.<br>
/// To set switch 10 or (11 in cluster), if the switch was set then the <method>SetSwitch</method> won't do anything and the original value with the owner PID is returned in '1,PID' format..<br>
/// To clear switch 10 or (11 in cluster), if the switch was cleared or was set by different process then the <method>SetSwitch</method> won't do anything and the original value is returned.<br>
/// <br>
/// See <method>GetSwitch</method> for a definition of the switches.
ClassMethod SetSwitch(SwitchNumber As %Integer, SwitchValue As %Integer) As %Integer
{
}

/// Check if this job could be blocked by the specific switch represented by 'SwitchNumber'.
/// <br>
/// Returns 1 if the job could pass this check (not blocked), returns 0 if this job will be blocked.<br>
/// 
/// For switch 10 and 11, if the job could not pass this test it also returns the PID of the job who set this switch in the '0,PID' format.
ClassMethod CheckSwitch(SwitchNumber As %Integer) As %Integer
{
}

/// Returns the largest routine buffer size that been configured.
ClassMethod RoutineBufferSize() As %Integer
{
}

/// Returns information about the routine buffers that have been allocated.
/// <br>
/// The return value is a comma-delimited string with a value for each possible buffer size. The pieces
/// correspond to buffer sizes 2K,4K,8K,16K,32K,64K.
/// <br><br>
/// If <parameter>Arg</parameter> is 0 or is omitted, the values are the amount of memory, in MegaBytes,
/// allocated for each buffer size.
/// <br>
/// If <parameter>Arg</parameter> is 1, the values are the number of buffers
/// allocated for each buffer size.
ClassMethod RoutineBuffers(Arg As %Integer) As %String
{
}

/// Returns the compressed form of a given string.
/// <br>
/// A Cache compressed string is a ZLIB compressed data block (as defined in RFC 1950) 
/// with a Cache-proprietary wrapper. Use <method>Decompress</method> to decompress it.
ClassMethod Compress(OriginalString As %String) As %String
{
}

/// Returns the original form of a Cache compressed string (see <method>Compress</method>).
ClassMethod Decompress(CompressedString As %String) As %String
{
}

/// Determines whether $HOROLOG includes a daylight saving time adjustment.
/// <p>
/// <parameter>TimeStamp</parameter> is a UTC time stamp value (same format as $ZTIMESTAMP).
/// If <parameter>TimeStamp</parameter> is not specified, the current time is used with
/// $HOROLOG adjusted by the $ZTIMEZONE special variable.
/// <p>
/// The return value reports whether the corresponding $HOROLOG time is adjusted by an additional DST hour.
/// <p>
/// Changes to $ZTIMEZONE will change the value of $HOROLOG but the time
/// zone rules do not change.  The time zone rules are always those used
/// by the operating system on which the Cache process is running. The
/// time zone rules of the Cache process will be applied to the local time.
/// <p>
/// The UTC time stamp is converted to a time_t value (taking into account
/// adjustments to $ztimezone) which is then used as input to call the C
/// Programming Language standard library routine localtime().  The
/// tm_isdst element of the returned tm struct is examined to determine if
/// the daylight savings time is in effect. <br>
/// 
/// Return Values:  <br>
///     0 - DST is not in effect. <br>
///     1 - DST is in effect. <br>
///    -1 - It cannot be determined if DST is in effect. 
ClassMethod IsDST(TimeStamp As %String) As %Integer
{
}

/// Converts UTC time to Local time.
/// <p>
/// <b>Parameter</b>
/// <p>
/// <parameter>TimeStamp</parameter> : A string representing a UTC time in the same format as
/// that returned by $ZTIMESTAMP.
/// <p>
/// <b>Return Value</b>
/// <p>
/// A string representing the corresponding Local time in the same format
/// as that returned by $HOROLOG.
/// <p>
/// <b>Note:</b>  This method only supports dates between January 1, 1970 and
/// January 18, 2038.  Dates outside this range will give an
/// &lt;ILLEGAL VALUE&gt; error.
/// <p>
/// <b>Note:  $ZTIMEZONE Warning</b>
/// <p>
/// This function is unusual in that it adjusts the Local time by any
/// changes made to the $ZTIMEZONE special variable.  Use of the $ZTIMEZONE
/// variable is limited to a few special situations.  $ZTIMEZONE affects
/// the value returned by $HOROLOG but most other date/time features and
/// functions (including $ZDATETIME and $ZDATETIMEH) ignore $ZTIMEZONE
/// changes.  Even though changing $ZTIMEZONE will change the value of
/// returned by $HOROLOG, the time zone rules do not change.  The time zone
/// rules are always those used by the operating system on which the process
/// is running.
/// The $ZTIMEZONE special variable will probably become a legacy feature
/// in future versions of the system.  If possible, applications should
/// avoid changing $ZTIMEZONE and should use $ZDATETIMEH(timestamp,-3)
/// to convert UTC time to Local time.
ClassMethod UTCtoLocalWithZTIMEZONE(TimeStamp As %String) As %String
{
	quit $ZUTIL(193,TimeStamp)
}

/// Converts Local time to UTC time.
/// <p>
/// <b>Parameter</b>
/// <p>
/// <parameter>h</parameter> : A string representing Local time in the same format as
/// that returned by $HOROLOG.
/// <p>
/// <b>Return Value</b>
/// <p>
/// A string representing the corresponding UTC time in the same format
/// as that returned by $ZTIMESTAMP.
/// <p>
/// <b>Note:</b>  This method only supports dates between December 31, 1969 and
/// January 18, 2038.  Dates outside this range will give an
/// &lt;ILLEGAL VALUE&gt; error.
/// <p>
/// <b>Note:  $ZTIMEZONE Warning</b>
/// <p>
/// This method is unusual in that it adjusts the Local time by any
/// changes made to the $ZTIMEZONE special variable.  Use of the $ZTIMEZONE
/// variable is limited to a few special situations.  $ZTIMEZONE affects
/// the value returned by $HOROLOG but most other date/time features and
/// functions (including $ZDATETIME and $ZDATETIMEH) ignore $ZTIMEZONE
/// changes.  Even though changing $ZTIMEZONE will change the value
/// returned by $HOROLOG, the time zone rules do not change.  The time zone
/// rules are always those used by the operating system on which the process
/// is running.
/// The $ZTIMEZONE special variable will probably become a legacy feature
/// in future versions of the system.  If possible, applications should
/// avoid changing $ZTIMEZONE and should use $ZDATETIME(h,-3)
/// to convert Local time to UTC time.
ClassMethod LocalWithZTIMEZONEtoUTC(h As %String) As %String
{
	quit $ZUTIL(193,h,1)
}

/// Performs collation conversion.
/// <p>
/// Parameters
/// <p>
/// <parameter>String</parameter> : An expression specifying a string or number to be converted
/// to a specified collation type.
/// <p> 
/// <parameter>flag</parameter> : An integer code used to specify the desired collation type.
/// Valid values are 0 through 9.
/// <p>
/// <parameter>len</parameter> : Optional -- The truncation length in characters, specified as an
/// integer. Truncation is performed on the collation-converted string.
/// This option can only be used with flag values of 7, 8, or 9. A decimal
/// len value is truncated to its integer part. A negative or nonnumeric
/// len value is treated as 0. 
/// <p>
/// Description
/// <p>
/// Collation applies the collation type specified in flag to string. The
/// following flag values are supported:<br>
/// <br>
/// 
/// 0 - EXACT     : Returns string unchanged. Does not convert NULLs. Corresponds
/// to the Cache SQL %EXACT function.<p> 
/// 
/// 1 - SPACE     : Appends a blank to beginning of string.<p> 
/// 
/// 2 - MVR       : Returns its argument converted to the MultiValue collation 
/// sequence.  It is used when a string contains both numeric and non-numeric 
/// characters.  It divides the expression string into substrings, each 
/// substring containing either all numeric or all non-numeric characters. 
/// The numeric substrings are sorted in signed numeric order. The non-numeric 
/// substrings are sorted in case-sensitive ASCII collation sequence.<p> 
/// 
/// 3 - PLUS      : Converts numerics and numeric strings to canonical numbers.
/// A nonnumeric string is returned as 0.<p> 
/// 
/// 4 - MINUS     : Converts numerics and numeric strings to canonical numbers and
/// prepends a minus sign. A nonnumeric string is returned as 0.<p>
/// 
/// 5 - UPPER     : Converts letters to uppercase. Corresponds to the Cache SQL %UPPER
/// function.<p> 
/// 
/// 6 - ALPHAUP   : Removes leading, trailing, and embedded blanks.
/// Removes all punctuation characters, except commas (,) and question marks (?).
/// Converts letters to uppercase. Corresponds to the Cache SQL %ALPHAUP
/// function.<p>
/// 
/// 7 - SQLUPPER  : Removes trailing blanks. Converts letters to uppercase.
/// Appends a blank to beginning of string. Corresponds to the
/// Cache SQL %SQLUPPER function.<p> 
/// 
/// 8 - SQLSTRING : Removes trailing blanks. Appends a blank to beginning of
/// string. Corresponds to the Cache SQL %SQLSTRING function.<p>
/// 
/// 9 - STRING    : Removes leading, trailing, and embedded blanks. Removes all
/// punctuation characters, except commas (,). Converts letters to uppercase.
/// Appends a blank to beginning of string. Corresponds to the
/// Cache SQL %STRING function.<p>
/// 
/// Several of these collation conversions append a blank to the string. This
/// forces numerics and the empty string to be collated as strings.
/// <p>
/// 
/// Numerics are converted to canonical form: leading and trailing zeros are
/// removed, as is a trailing decimal point. Multiple plus and minus signs
/// are resolved; if the resulting sign is a plus sign, it is removed.
/// <p>
/// 
/// The MINUS collation type appends a minus sign to the supplied sign before
/// canonical resolution. Thus the MINUS collation of a negative number is
/// a positive number. PLUS and MINUS resolve mixed numeric strings
/// (such as "7dwarves") by truncating the string at the first nonnumeric
/// character. PLUS and MINUS resolve nonnumeric strings by assigning them
/// a value of 0.
/// 
ClassMethod Collation(String As %String, flag As %Integer, len As %Integer) As %String
{
}

/// Performs reverse collation conversion.
/// <p>
/// Parameters
/// <p>
/// <parameter>String</parameter> : An expression specifying a collated string to be converted
/// back to POSSIBLE original value.
/// <p> 
/// <parameter>flag</parameter> : An integer code used to specify the desired collation type.
/// Valid value is 2.
/// <p>
/// Description
/// <p>
/// RevCollation applies the collation type specified in flag to string. The
/// following flag values are supported:<br>
/// <br>
/// 
/// 2 - MVR       : Returns its argument converted from the MultiValue collation 
/// sequence.  It is used when a string contains both numeric and non-numeric 
/// characters.  It divides the expression string into substrings, each 
/// substring containing either all numeric or all non-numeric characters. 
/// The numeric substrings are sorted in signed numeric order. The non-numeric 
/// substrings are sorted in case-sensitive ASCII collation sequence. The result 
/// can differ from the original due to sign and leading zero suppression applied
/// during the conversion to MVR collation.<p> 
/// 
ClassMethod RevCollation(String As %String, flag As %Integer) As %String
{
}

/// Purges existing error report records from SYSLOG.
ClassMethod PurgeSYSLOG() As %Numeric
{
}

///  Returns MajorVersion.MinorVersion.BuildNumber on Windows.<br>
///  Returns an unimplemented error on Unix or VMS.
ClassMethod GetOSVersionInfo() As %String
{
}

///  Returns the session Id on Windows.
///  <br>
///  If arg = 0 or no argument, returns the physical console Session Id or 0xffffffff if there is no session attached to the physical console.  The physical console is the monitor, keyboard, and mouse. 
///  <br>
///  If arg = 1, returns the session Id of the current process.  On error, returns -GetLastError().
///  <br>
///  Returns an unimplemented error on Unix or VMS.
ClassMethod GetSessionId(arg As %Integer) As %Numeric
{
}

/// Converts a hexadecimal string to a decimal string.
ClassMethod HexToDecimal(hex As %String) As %String
{
	If $tr(hex,"0123456789abcdefABCDEF")'="" Do $ZUTIL(96,3,78,1)
	Set decimal=""
	For i=1:1:$l(hex) {
		; multiply by 16
		For j=1:1:4 Set decimal=..mpadd(decimal,decimal)
		; add next digit
		Set decimal=..mpadd(decimal,$lb($zh($e(hex,i))))
	}
	Quit ..mp2dec(decimal)
}

/// Converts a decimal string to a hexadecimal string.
ClassMethod DecimalToHex(decimal As %String) As %String
{
	If $tr(decimal,"0123456789")'="" Do $ZUTIL(96,3,78,1)
	Set hex=""
	For i=1:1:$l(decimal) {
		; multiply by 10
		Set times2=..mpaddx(hex,hex), times4=..mpaddx(times2,times2)
		Set hex=..mpaddx(times4,times4)
		Set hex=..mpaddx(hex,times2)
		; add next digit
		Set hex=..mpaddx(hex,$lb($e(decimal,i)))
	}
	Quit ..mp2hex(hex)
}

/// Add two multiple-precision integers, represented as a list of
/// base 1,000,000,000 integers, least significant first
ClassMethod mpadd(x, y) [ Internal, Private ]
{
	#define base 1000000000
	s max=$ll(x),lly=$ll(y) s:lly>max max=lly
	s carry=0,ret=""
	f i=1:1:max {
		s sum=$lg(x,i)+$lg(y,i)+carry
		s ret=ret_$lb(sum#$$$base)
		s carry=sum\$$$base
	}
	s:carry ret=ret_$lb(carry)
	q ret
}

/// Add two multiple-precision hex integers, represented as a list of
/// base 0x1000000 integers, least significant first
ClassMethod mpaddx(x, y) [ Internal, Private ]
{
	#define basex 16777216
	s llx=$ll(x),lly=$ll(y) s max=$S(lly>llx:lly,1:llx)
	s carry=0,ret=""
	f i=1:1:max {
		s sum=$S(i>llx:0,1:$ZH($lg(x,i))) + $S(i>lly:0,1:$ZH($lg(y,i))) + carry
		s ret=ret_$lb($ZH(sum#$$$basex))
		s carry=sum\$$$basex
	}
	s:carry ret=ret_$lb($ZH(carry))
	q ret
}

/// Convert multiple-precision integer to decimal string
ClassMethod mp2dec(x) [ Internal, Private ]
{
	#define digits 9
	s ret=""
	f i=$ll(x):-1:1 s ret=ret_$j($li(x,i),$$$digits)
	s ret=$zstrip($tr(ret," ",0),"<",0)
	q ret
}

/// Convert multiple-precision hex integer to hex string
ClassMethod mp2hex(x) [ Internal, Private ]
{
	#define digitsx 6
	s ret=""
	f i=$ll(x):-1:1 s ret=ret_$j($li(x,i),$$$digitsx)
	s ret=$zstrip($tr(ret," ",0),"<",0)
	q ret
}

/// Returns the configured frame stack size, in bytes.<br>
/// This is the size that will be used for any new processes that are created.
ClassMethod GetFrameStackSize() As %Integer
{
}

/// Sets the configured frame stack size, in bytes, for new processes.<br>
/// If <parameter>size</parameter> is 0, the system default size is set.<br>
/// Returns the previous configured value.
ClassMethod SetFrameStackSize(size As %Integer) As %Integer
{
}

/// Performs validation of the routine buffers in memory
/// <p>
/// <b>Parameters</b>
/// <p>
/// <parameter>flag</parameter> : 1 = stop if an error is found. Default is 0.
/// <p>
/// <parameter>numbuf</parameter> : For a big-endian system, specifies the number
/// of buffers to allocate as a work area. Routines larger than this will not be
/// checked. Default is 8. Little-endian systems do not allocate a work area.
/// <p>
/// <b>Return value</b>
/// <p>
/// The return value is a $LIST with at least one element.<br>
/// The first element is the number of buffers (routines) that were checked.<br>
/// If errors are found, there will be one list element for each error.<br>
/// If <parameter>numbuf</parameter> is specified, there will be one element with the size of the largest routine found.
/// If this value is larger than <parameter>numbuf</parameter> on a big-endian system then at least one routine was skipped.
/// <p>
/// Each error is itself a $LIST with these elements:<br>
/// <dl>
/// <dd>The buffer number.
/// <dd>The routine name.
/// <dd>The error code.
/// <dd>Additional information specific to the error code.
/// </dl>
/// <p>
/// Error code 1 is a crc error. The additional information is the expected crc value and the actual value.
ClassMethod ValidateRoutineBuffers(flag As %Integer, numbuf As %Integer)
{
}

}
