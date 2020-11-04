Include (%sySystem, %syPrompt, %occErrors, %occUtility)

Class %Library.Device Extends %SYSTEM.Help [ Abstract, System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC2373 12/16/14 Steve Clay, Better error in %Library.Device
SOH146   9/09/09 Steven Hobbs, Add Broadcast, SetFFBS, ReDirectIO, ChangePrincipal, InstalledPrinters
STC1484 11/05/08 Steve Clay, Don't prompt for overwrite on VMS in %IS when both "W" and "N" are specified. 
STC1464 10/08/08 Steve clay, Don't prompt in %IS when not really overwriting a file 
STC1399 05/19/08 Steve Clay, (%Library.Device).Get() returns correct failure error 
STC1184 03/01/07 Steve Clay, Throw <NOTOPEN> error in OUT^%IS when IOP passed in 
STC1169 02/06/07 Steve Clay, Allow right margin of 0 for terminal
SML796 11/30/06 Simon Li, remove usage of $$$quote macro by MAK1927, use $$quote() instead.
STC1034 07/20/06 Steve Clay, Fix defaults for RMS device open 
SML736  07/11/06 Simon Li, Change $e(x,n,999) to $e(x,n,*).
STC1014 06/19/06 Steve Clay, Fix help text 
LRS1005 12/07/05 Lee Smith, fix <UNDEFINED> error in Get() when IOP is set
LFT1400 02/06/05 Laura Tillem, fix use of Prompt parameter
CFL1218 01/07/05 Carlos Lopes, fix open parameter the keyword syntax is used
PWC922 10/27/04 Peter Cudhea, Rename this class to %Library.Device
LRS771 05/21/04 Lee Smith, document new $System.Device methods
LFT1256 5/04/04 Use global variable %POP to communicate with %ISSPL
SML450 03/03/04 Simon Li, Add GetPrinters method to return printers in the Windows system.
STC476 09/10/03 Steve Clay, Moved code here from %IS
LFT1120 8/20/03 Laura Tillem, confirm if overwriting a file
CLN051 08/15/03 Laura Tillem
LFT1080 3/24/03 Laura Tillem, fix device param adjustment after failure
APJ950 05/25/00 Phil Johnson, Fix bug when trying to open a file that 
                doesn't exist
APJ675 08/13/99 Phil Johnson, Add file header info for save/restore 
                format checking
STC200 02/20/99 Steve Clay, Cleaned
DAW008 10/23/97 Add quotes around IOPARs
JMO011 07/11/97 Joseph Onorato, Changed two instances of timeout
          on opens from one second to five second to solve
          network problem at Lahey Hitchcock
LRS179 07/02/97 Lee Smith, fix protocol string parsing for NLS
JMO010 06/24/97 Joseph Onorato, allow use of file names without file
          extent for M/WNT
STC118 06/19/96 Steve Clay. CLEANED. For NT add in test for |TNT|,|LAT|,|TRM|
JAO659 03/07/94 Jeffrey Orlin, for OSVMS, in CHOICE, see if the answer
          is the same as $I and if so, set %ANS to null. This way
          if we don't have any info on this particular device, we'll
          go off to VTRMCK and see if it matchs one of our patterns
JFP032 11/24/93 John Paladino, Added spool var's to exclusive new list
CMB017 06/17/93 Chris Buck, only write ! if non-interactive
DKA168 02/11/93 Keith Avery, fixed <UNDEFINED> when asking for help
AHS055 10/25/92 Amir Shokrollahi, fixed the bug with %IS acting opposite
                to the response for Rewind:
BEB454 08/04/92 Ben Bishop, add IPC as a terminal type for right margin
BEB447 08/04/92 Ben Bishop, file device recall using ZGetDev.inc
BEB443 07/17/92 Ben Bishop, macro version of %IS w/ many changes
AHS036 04/10/92 Amir Shokrollahi, changed CURRENT to call $ZU(22) to
                set ZBS and ZFF.
DKA022 10/26/90 Keith Avery.  Set "TERM" as default for "/dev/pt" devices.
DKA019 07/25/90 Keith Avery.  Set "TERM" as default for "/dev/pts" devices.
-------------------End Documentation----------------------------------
*/
/// Get and open an INPUT or OUTPUT device.<br>
/// Input Parameters:<br>
/// Prompt - Prompt to be displayed<br>
/// Value - Default value <br>
/// Help - Array of help text<br>
/// Flag - From %syPrompt.inc<br>
///      - $$$DisableBackupCharMask - Disable entry of the backup character<br>
///      - $$$TrapCtrlCMask - Trap CTRL/C and return CTRL/C status<br>
///      - $$$EnableQuitCharMask - Enable quit and return Quit status<br>
///      - $$$DisableHelpCharMask - Disable entry of the help character<br>
///      - $$$TrapErrorMask - Trap errors and return error status<br>
/// TimeOut - Timeout for prompt<br>
/// IOFlag - Mask containing one of the following values<br>
///        - 1= Get input or output device (Default)<br>
///        - 2= Get input device<br>
///        - 4= Get output device<br>
/// 	       - 8= Open passed in Value without prompting<br>
/// <br>
/// Output parameters:<br>
/// Status - One of the following from %syPrompt:<br>
/// $$$SuccessResponse - Successful entry, Value contains valid open device<br>
/// $$$BackupResponse - Backup character entered<br>
/// $$$QuitResponse - Quit character entered if $$$EnableQuitCharMask set<br>
/// $$$CtrlCResponse - CTRL/C entered if $$$TrapCtrlCMask set<br>
/// $$$ErrorResponse - Error during entry if $$$TrapErrorMask set<br>
/// $$$HelpResponse - Help character entered if $$$DisableHelpCharMask set <br>
/// <br>
/// Value - Open device name<br>
/// IOSL - Number of lines per screen<br>
/// IOM - Right margin<br>
/// IOBS - Backspace character<br>
/// IOPAR - IO parameters<br>
/// IOT - Device type<br>
/// IOST - Expanded device type<br>
/// ANS - Device typed in by user<br>
/// RMSDF - Default RMS parameters<br>
/// IODOC - Spool file name<br>
/// IODES - Spool file description<br>
/// <br><br>
/// Typical usage is as follows:
/// s Status=##Class(%Library.Device).Get("Device:",.Value,,$$$TrapCtrlCMask+$$$EnableQuitCharMask,,IOFlag,.IOSL,.IOM)<br>
/// i (Status=$$$CtrlCResponse)||(Status=$$$QuitResponse) q<br>
/// i (Status=$$$BackupResponse) g PreviousPrompt<br>
/// use Value<br>
/// w !,"Right margin is "_IOM<br>
/// w !,"Lines per page is "_IOSL<br> 
/// close Value<br>
ClassMethod Get(Prompt As %String, ByRef Value As %String, ByRef Help As %String, Flag As %Integer = 0, Timeout As %Integer = 0, IOFlag As %Integer = 1, ByRef IOSL As %String, ByRef IOM As %Integer, ByRef IOF As %String, ByRef IOBS As %String, ByRef IOPAR As %String, ByRef IOT As %String, ByRef IOST As %String, ByRef ANS As %String, ByRef RMSDF As %String, ByRef IODOC As %String, ByRef IODES As %String)
{
#define NoDeviceSelected s (Value,IOSL,IOM,IOPAR,IOT,IOF,IOBS,IOST,ANS,RMSDF,IODOC,IODES)=""
#define SETIO i $V(0)\2#2=0 {S TMP=$I U IO S IO=$I U TMP} 
 New %POP
 s MSYS=$$$Site ;which platform?
 i $zb(+IOFlag,8,1) s IOP=Value
#; Get device read/write
 i $zb(+IOFlag,1,1) {
	S:$g(RMSDF)="" RMSDF="""RW"""
	d B
	i Status=$$$SuccessResponse s Value=IO
	q Status
 }
#; Get device IN
 i $zb(+IOFlag,2,1) {
 	S:$g(RMSDF)="" RMSDF="""R"""
 	while (1) {
 		d B
		i Status'=$$$SuccessResponse q
	 	I IOT'="SPL",IOT'=3 {
		 	s Value=IO
	 		Q
 		}
 		i $D(IOP) {
	 		s Status=$$$QuitResponse
	 		q
 		}
  		W " [You can't read from this device]"
 	}
	q Status
 }
#; Get Device OUT
 i $zb(+IOFlag,4,1) {
 	S:$g(RMSDF)="" RMSDF="""WNS"""
 	while (1) {
 		d B
		i Status'=$$$SuccessResponse q
		I IOT'="MT",IOT'="BT" {
			s Value=IO
			q
		}
		U IO 
 		I $ZA\4#2 {
			U 0 
 			i $D(IOP) {
	 			s Status=$$$QuitResponse
	 			q
 			}
	 		W " [Tape is write-locked]" ;^^G OUT
 		}
 		U 0 
 		s Value=IO
 		Q
   	}
	q Status
 }
 q $$$QuitResponse
 
B s $ZT="ERROR"
 s Status=$$$SuccessResponse
 S IOPAR="" 
#;If the device is passed in, bypass the prompts
 I $D(IOP) S (ANS,Device)=IOP G CHOICE
#;Don't prompt if current device piece 4 is 1^^^
 S DeviceData=$G(^%IS($I,1)) 
 I $P(DeviceData,"^",4)=1 {
	D INFO 
	O IO:IOM 
	s IOOPEN=1
	$$$SETIO
	q
 }
RD s $ZT="ERROR"
 s Device=$g(Value)
 s prompt=$Case($g(Prompt),"":"Device:",:Prompt)
 s Status=##Class(%Library.Prompt).GetString(prompt,.Device,,,.Help,Flag,Timeout)
 i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse)||(Status=$$$QuitResponse) $$$NoDeviceSelected q
 I $ZCVT(Device,"u")="A" S C=$P(DeviceData,"^",7) S:C]"" Device=C
 s ANS=Device
 ;
CHOICE S:"0"[Device Device=$I 
 S DeviceData=$G(^%IS(Device,1)) ;device information
 ;
 ; If Device is $I then set it to NULL and we'll go to VTRMCHK
 ; if we don't have any info about this particular device
 ;
 i $$$ISVMS {
 . S TMP=$ZCVT(Device,"u")
 . S:$E(TMP,1)'="_" TMP="_"_TMP    ; $I has _ on the front 
 . S:TMP'[":" TMP=TMP_":" S:TMP=$I Device=""
 }
#;Set the device the user answered here
 I DeviceData="" {
	i "0"[ANS d ..VirtualTermCheck(.Device,.DeviceData)
	i DeviceData="" { ;check virtual terminal
		i Device'[".",(MSYS'="M/UX"),(MSYS'="M/WNT") {
			i $D(IOP) $$$NoDeviceSelected q
			W *7,"  [not in the device table]" G RD ;don't know terminal type
		}
 		S:IOPAR="" IOPAR=RMSDF
 		S IOT="RMS",IO=Device,IOST=IOT,IOF="#",IOSL=66,IOBS="*8",IOM=132
 		D PARS 
		i (Status=$$$CtrlCResponse)||(Status=$$$QuitResponse) $$$NoDeviceSelected q
		i (Status=$$$BackupResponse) g RD
 		i ##class(%Library.File).Exists(Device) && (IOPAR["W") && ('$D(IOP)) {
        	i ((IOPAR["N") && '($$$ISVMS)) || ((IOPAR'["N") && (IOPAR'["A")) {
	 			s OverWrite=1
				s Status=##Class(%Library.Prompt).GetYesNo(Device_" already exists, do you want to overwrite it?",.OverWrite,,Flag,Timeout)
  				i (Status=$$$CtrlCResponse)||(Status=$$$QuitResponse) $$$NoDeviceSelected q
				i (OverWrite=0)||(Status=$$$BackupResponse) g RD
        	}
 		}
	 	O IO:(IOPAR:/OBUFSIZE=32000):2
	 	i '$t {
		 	i $D(IOP) s Status=$$$ErrorResponse $$$NoDeviceSelected q
		 	W *7,"  [unavailable]"
	 		g RD
 		}
		s IOOPEN=1
 		Q
	}
 }
INFO S IO=$P(DeviceData,"^"),IOT=$P(DeviceData,"^",2),IOST=$P(DeviceData,"^",3),IOPAR=$P(DeviceData,"^",6)
 S IOF="#",IOSL=66,IOBS="*8",IOM=132 ;default information
 I IOST]"" S TMP=$G(^%IS(0,"SUB",IOST)) I TMP]"" DO
 . S IOM=+TMP,IOF=$P(TMP,"^",2),IOSL=$P(TMP,"^",3),IOBS=$P(TMP,"^",4)
#;quit out if we are not prompting
 I $P(DeviceData,"^",4)=1 q
 I IOT="SPL" {
	I RMSDF="""R""" Q  ;select a spool device ^^^?
 	I IOPAR?1"(".E1")" S IOPAR=$E(IOPAR,2,$L(IOPAR)-1)
 	I $P(IOPAR,":")]"" S IODOC=$P(IOPAR,":")
 	I $P(IOPAR,":",2)]"" S IOPGM=$P(IOPAR,":",2)
 	S IODES=$G(IODES) I IODES="" S IODES=$G(^%IS(Device,0))
 	C 2 
#;Use global variable to communicate with %ISSPL
 	s %POP=0 D ^%ISSPL I %POP S %POP=0 G RD
 	K IODOC,IODES,IOPGM,IOSPL 
 	$$$SETIO 
 	q
 }
 I IOT'="MT",IOT'="BT",IOT'="SDP",IOT'="OTH",IOT'="IPC" {
 	O IO:"":5 ;try and open the device -- for 5 seconds
 	i '$t {
	 	i $D(IOP) s Status=$$$ErrorResponse $$$NoDeviceSelected q 
	 	W *7,"  [unavailable]"
	 	g RD
 	}
	s IOOPEN=1
 }
 I (IOT="TRM")||(IOT="IPC") {
	 i '($D(IOP)!$P(DeviceData,"^",4)) {
 		s Status=##Class(%Library.Prompt).GetNumber("Right margin:",.IOM,0,511,,Flag,Timeout)
  		i (Status=$$$CtrlCResponse)||(Status=$$$QuitResponse) $$$NoDeviceSelected q
		i (Status=$$$BackupResponse) g RD
		w !
	 }
 }
 i IOT'="TRM" {
	d PARS ;other devices need to specify parameters
	i (Status=$$$CtrlCResponse)||(Status=$$$QuitResponse) $$$NoDeviceSelected q
	i (Status=$$$BackupResponse) g RD
 	i '$D(IOP) w !
 }
 S TMP=""""_IO_""""
 I IOT="TRM",IOM]"" S TMP=TMP_":"_IOM ;add margin if defined
 I IOT'="TRM",IOPAR]"" S TMP=TMP_":"_IOPAR ;add non-terminal parameters
 I IOT="MT"!(IOT="BT") C IO k IOOPEN ;need to re-open mag-tapes in right format
#;Open the device with the correct parameters
 O @TMP 
 s IOOPEN=1
 i $d(IOP) $$$SETIO q
 I (IOT="MT")!(IOT="BT") {
	s Rewind=0
 	s Status=##Class(%Library.Prompt).GetYesNo("Rewind?",.Rewind,,Flag,Timeout)
  	i (Status=$$$CtrlCResponse)||(Status=$$$QuitResponse) $$$NoDeviceSelected q
	i (Status=$$$BackupResponse) c IO k IOOPEN g RD
	i Rewind S TMP=$I U IO W *-5 U TMP
 }
 $$$SETIO
 Q
PARS Q:$D(IOP)  Q:$P(DeviceData,"^",4)  ;skip w/ defaults or no prompt selected
 I IOT="RMS",IOPAR["R" D  ;try to set io parameters based on what's in the file
 . i '##class(%Library.File).Exists(IO) Q
 . S fmt=..GetFileFormat(IO) Q:fmt=""
 . I IOPAR["S" S IOPAR=$TR(IOPAR,"S",fmt) Q
 . I IOPAR["V" S IOPAR=$TR(IOPAR,"V",fmt) Q
 . s IOPAR=$e(IOPAR,1,$F(IOPAR,"R")-1)_fmt_$e(IOPAR,$f(IOPAR,"R"),*)
 . ;S IOPAR=$E(IOPAR,1,$L(IOPAR)-2)_fmt_$C(34)_")"
 s Help1(1)= "Parameters{:RecordLength{Terminators}}"
 s Help1(2)="Parameters are as follows:"
 s Help1(3)="R - Open for read"
 s Help1(4)="W - Open for write"
 s Help1(5)="N - Create New file (used with Write)"
 s Help1(6)="S - Stream record mode"
 s Help1(7)="V - Variable length record mode"
 s Help1(8)="U - Undefined record mode"
 s Help1(9)="F - Fixed record length mode. Must also specify the record length parameter."
 s Help1(10)="D - Delete file on close"
 s Help1(11)="L - Locked exclusive access"
 s Help1(12)="A - Open for Append"
 s Help1(13)="Terminators: Used to terminate reads for Stream (S) record mode"
 s Status=##Class(%Library.Prompt).GetString("Parameters?",.IOPAR,,,.Help1,Flag,Timeout)
 i (Status=$$$CtrlCResponse)||(Status=$$$BackupResponse)||(Status=$$$QuitResponse) q
 I IOPAR]"" Set IOPAR=$$quote(IOPAR)
 Q
ERROR S $ZT="" 
#;If the value is passed in, and we are getting an output device, throw an error to mimic
#;the behavior in the old OUT^%IS (also set POP=0)
 i $zb(+IOFlag,12,1),($ze["NOTOPEN") ztrap $ze
 i $ze["<FUNCTION" w !,"   [Error: Invalid parameter]" s IOPAR="" g RD
 U 0 w !,$ZE
 i $D(IOP) c:$D(IOOPEN) IO s Status=$$$QuitResponse q
 i $ZE["<INT" c:$D(IOOPEN) IO G RD
 i $ZE["<MAGT" DO  c:$D(IOOPEN) IO G RD
 . U IO S TMP=$ZA,TMP=$S(TMP\64#2=0:"tape not online",1:"$ZA="_TMP)
 . U 0 W !,"   [Magtape error: "_TMP_"]"
 W !,"   [Error: "_$P($ZE,">")_"> ]"
 G RD
quote(iopar) ;
 Set r=""
 If iopar?1"(".E1")" Set iopar=$e(iopar,2,$l(iopar)-1)
 Set par=$l(iopar,":")
 For i=1:1:par {
	 Set p=$p(iopar,":",i)
	 If $e(p)'="""",$e(p)'="/" Set p=""""_p_""""
	 If $e(p)="""" {
		 Set p1=$e(p,2,$l(p)-1)
		 For j=1:2:$l(p1,"\") Set $p(p1,"\",j)=$zcvt($p(p1,"\",j),"U")
		 Set p=""""_p1_""""
	 }
	 Set $p(r,":",i)=p
 }
 Quit "("_r_")"
}

/// Get current device info from %IS global.<br>
/// Get current device info from %IS global and set default 
/// FormFeed and Backspace strings for the process based on 
/// information in the %IS global.
/// <br>
/// Return Values:<br>
/// IO - Device name<br>
/// SL - Number of screen lines of the device<br>
/// RM - Right margin of the device<br>
/// FF - Form feed character of the device<br>
/// BS - Back space character of the device<br>
/// SUB - Device subtype<br>
/// XY - XY cursor positioning string<br>
/// 
/// This method replaces the CURRENT^%IS call.
ClassMethod GetCurrent(ByRef IO As %String, ByRef SL As %String, ByRef RM As %String, ByRef FF As %String, ByRef BS As %String, ByRef SUB As %String, ByRef XY As %String)
{
 n %X
 s IO=$I
 S DeviceData=$G(^%IS($I,1)) i DeviceData="" d ..VirtualTermCheck(.Device,.DeviceData)
 S FF="#",SL=24,BS="*8",RM=80,SUB="",XY="",ZFF=$C(12),ZBS=$C(8,32,8)
 S A=$P(DeviceData,"^",3) I A]"",$G(^%IS(0,"SUB",A))]"" DO  ;
 . S SUB=A,A=^%IS(0,"SUB",SUB),FF=$P(A,"^",2),RM=+A,SL=$P(A,"^",3)
 . S BS=$P(A,"^",4),XY=$P(A,"^",5),ZFF=$P(A,"^",8),ZBS=$P(A,"^",9)
 . I ZFF]"" S ZFF=$$VALUE(ZFF)
 . I ZBS]"" S ZBS=$$VALUE(ZBS)
 I $ZU(22,0,ZFF,ZBS) ;set the new value
 O $I:RM Q
VALUE(x) S $ZT="VALERR" X ("S %X="_x) q %X
VALERR w $ze Q $G(%X)
}

/// Try to return the internal Cache file format of the file.<br>
/// This method is only used by this class.
ClassMethod GetFileFormat(File) As %String [ Internal, Private ]
{
#define goISMBLK 7
 Set $zt="ERROR"
#;APJ834+
 Open File:("UR":1024):2 If '$t Quit ""
#;APJ834-
#;'$$$NOFULLNLS
 Use File Use:$ZU(96,18,2,"RAW")!1 0
 Use File Read x
 If x["~Format=" s fmt=$P($p($p(x,"~Format=",2),"~"),".",2)
 Else  If x["~%GOF~" s fmt=$$$goISMBLK
 Else  If x["~%ROMF" s fmt="Object"
ERROR Close File
 Quit $g(fmt)
}

/// Return the Back Space string for the process principal device.<br>
ClassMethod GetBackSpace() As %String
{
#; Implemented in system code
 q $System.Device.GetBackSpace()
}

/// Return the Clear Screen (Form Feed) string for the process principal device.<br>
ClassMethod GetClearScreen() As %String
{
#; Implemented in system code
 q $System.Device.GetClearScreen()
}

/// Return the write mnemonic space routine directory for the current device.<br>
ClassMethod GetMnemonicDirectory() As %String
{
#; Implemented in system code
 q $System.Device.GetMnemonicDirectory()
}

/// Return the write mnemonic space routine name for the current device.<br>
ClassMethod GetMnemonicRoutine() As %String
{
#; Implemented in system code
 q $System.Device.GetMnemonicRoutine()
}

/// Return the name of the null device for the platform.<br>
ClassMethod GetNullDevice() As %String
{
#; Implemented in system code
 q $System.Device.GetNullDevice()
}

/// Return a list of printers that the system recognizes.<br><br>
/// This method is supported only for Windows platform, for non Windows platform it always returns a null string.<br><br>
/// It returns a null string when there is no printer recognized by the system.<br>
/// Use $LISTLENGTH function to get number of printers in the returned list. 
/// Use $LIST function to get each printer name in the list. 
/// Note that you need to add "|PRN|" at beginning of each printer name in 
/// order to use OPEN command to open the printer device.
ClassMethod GetPrinters() As %List
{
#; For non Windows platform, we always return null string.
 q:'$$$ISWINDOWS ""
 s num=$zu(158,0)
 q:num=0 ""
 s result=""
 for i=1:1:num s result=result_$LB($zu(158,1,i))
 q result
}

/// Return the read terminator string for the current device.<br>
/// Does not apply to some devices.
ClassMethod GetReadTerminators() As %String
{
#; Implemented in system code
 q $System.Device.GetReadTerminators()
}

/// Return the right margin setting for the current device.<br>
/// This only applies to terminals.
ClassMethod GetRightMargin() As %Integer
{
#; Implemented in system code
 q $SYSTEM.Device.GetRightMargin()
}

/// Returns an integer which specifies the type of device.<br>
/// 0 - sequential file<br>
/// 1 - terminal <br>
/// 2 - spool device (device #2)<br>
/// 3 - magnetic tape (device numbers 47-50)<br>
/// 4 - system operator's console (device 1)<br>
/// 5 - pseudo-device (device numbers 20-46)<br>
/// 6 - Null device<br>
/// 7 - spooled virtual console<br>
/// 8 - IJC device (devices 224-255)<br>
/// 9 - TCP device<br>
/// 11 - NetBIOS NTI device<br>
/// 12 - Named Pipe device<br>
/// 13 - Memory-mapped device<br>
/// 14 - XDEV extensible device<br>
ClassMethod GetType() As %Integer
{
#; Implemented in system code
 q $ZU(96,14)
}

/// Return the Device name and its parameters if a terminal.<br>
/// This method is only used by this class.
ClassMethod VirtualTermCheck(ByRef Device As %String, ByRef DeviceData As %String) [ Internal ]
{
#;Check for virtual terminal, if $I is not in %IS table.
 I $$$Site="M/UX" {
#;unix default terminal type
#;no longer limited to /dev/tty or /dev/pt
	S Device="TERM",DeviceData=$G(^%IS(Device,1))
 	Q  
 }
#; If the tty is not in the %IS table, it's probably a network device.
#; It should probably just be put in the table, but for now we will
#; just do what M/VX does, in case anything out there depends on this.
 S Device="TERM" I $ZCVT($I,"u")?1"VT".E,$D(^%IS("VT0:")) S Device="VT0:"
 E  I $ZCVT($I,"u")?1"RTA".E,$D(^%IS("RT0:")) S Device="RT0:"
 E  I $ZCVT($I,"u")?1"LTA".E,$D(^%IS("LT0:")) S Device="LT0:"
 E  I $ZCVT($I,"u")?1"|LAT|".E,$D(^%IS("|LAT|")) s Device="|LAT|"
 E  I $ZCVT($I,"u")?1"|TNT|".E,$D(^%IS("|TNT|")) s Device="|TNT|"
 E  I $ZCVT($I,"u")?1"|TRM|".E,$D(^%IS("|TRM|")) s Device="|TRM|"
#;default terminal types
 S DeviceData=$G(^%IS(Device,1))
 q
}

/// Description<br><br>
/// The Broadcast class method has two syntactic forms. The first
/// sends a message to the specified terminal, and can optionally
/// time out. The second sends a message to the operator console
/// (specified by the null string), and also logs the message.<br>
/// <br> 
/// Broadcast(terminal,message) passes the message to the specified terminal. If you
/// specify your own principal device, your message appears on your terminal screen.<br>
/// <br>
/// Broadcast("",message) passes the message to the operator console, logging it in the
/// console log file. By default, the console log file is cconsole.log, which can be
/// accessed via the System Management Portal System Logs option. This default console log
/// file location is configurable. Go to the Management Portal, select 
/// [Home] > [System Administration] > [Configuration] > [Additional Settings] > [Advanced Memory]. 
/// View and edit the current setting of ConsoleFile.
/// By default this setting is blank, routing console messages to
/// cconsole.log in the MGR directory. If you change this setting, you must restart the system
/// for this change to take effect.<br>
/// Broadcast does not add any carriage control to the message it sends. To include any
/// carriage control (carriage returns or line feeds), you must include them in the message,
/// using $CHAR(10) and $CHAR(13).<br>
/// <br>
/// Broadcast returns 1 if successful; 0 if not successful.<br>
/// <br>
/// Parameters<br><br>
/// terminal<br>
/// The device name of the terminal to which you want to send a message, specified as a
/// quoted string. Specify the null string ("") to send the message to the system console.<br>
/// <br>
/// message<br>
/// The message to send, specified as a quoted string.<br>
/// <br>
/// level<br>
/// Optional<br>
///   when used with named terminal only ? A timeout in seconds. If Broadcast is not able
/// to send the message during the period of the timeout, it ceases attempts to send the
/// message after the timeout expires.<br>
///   when used with operator console only ? The log level you want to assign to the message.<br>
/// <br>
/// You can use the following values:<br>
/// 0 = Send the message to the following locations: Operator console log file, Caché console.<br>
/// 1 = Send the message to the following locations: Operator console log file, Caché console,
/// System-wide operator console facility.<br>
/// 
ClassMethod Broadcast(terminal As %String, message As %String, level As %Integer = 0) As %Status
{
	q $zu(9,terminal,message,level)
}

/// The SetFFBS class method specifies the form feed or backspace
/// control code sequence used by printers.<br>
/// <br>
/// Parameters<br>
/// ff : The new value for the form feed control code sequence.
/// If omitted, the system default, as defined for Device 0,
/// is used.  May not be omitted if the bs parameter is present.<br>
/// bs : The new value for the backspace control code sequence.
/// If omitted, the system default, as defined for
/// Device 0, is used.<br>
/// <br>
/// Description<br>
/// This function is used to change the form feed and backspace control
/// code sequences.<br>
/// SetFFBS(ff,bs) sets form feed control sequence to ff and backspace
/// control sequence to bs.<br>
/// SetFFBS(ff) sets form feed control sequence to ff and backspace
/// control sequence to system default.<br>
/// SetFFBS() sets the printer form feed and backspace control
/// sequences to system default.<br>
/// 
ClassMethod SetFFBS(ff As %String, bs As %String) As %Status
{
	if $d(bs) { do $zu(22,0,ff,bs)  q $$$OK}
	if '$d(ff) { do $zu(22,0)  q $$$OK}
	do $zu(22,0,ff)  q $$$OK
}

/// The ReDirectIO() class method returns the status of the I/O
/// redirection switch for the current device.<br>
/// <br>
/// The ReDirectIO(n) class method sets the I/O redirection
/// switch for the current device according to the boolean value n.
/// It returns the previous setting of this switch.<br>
/// 
ClassMethod ReDirectIO(n As %Boolean) As %Boolean
{
	quit:'$d(n) $zu(82,12)
	quit $zu(82,12,n)
}

/// The ChangePrincipal() class method makes the current device (last
/// device specified in a USE command) be the principal I/O
/// device (referenceable by USE 0 or USE $PRINCIPAL.) This method
/// makes the current device the principal I/O device, while leaving
/// the former principal I/O device open, and thus capable of being 
/// used explicitly by name.<br>
/// <br>
/// ChangePrincipal() takes no arguments. It returns 1 on success,
/// 0 on failure.<br> 
/// 
ClassMethod ChangePrincipal() As %Status
{
 quit $zu(132)
}

/// The InstalledPrinters() class method returns the number of printers
/// currently installed on your system, counting from 1.<br> 
/// <br>
/// The InstalledPrinters(n) method, where 1 <= n <= InstalledPrinters(),
/// returns the pathname of the printer currently installed on your
/// system that corresponds to n. The system counts printers from 1, and
/// assigns a sequential integer to each. If n is a number that does
/// not correspond to a printer, the system issues a <FUNCTION> error.<br>
/// 
ClassMethod InstalledPrinters(n As %Integer) As %DataType
{
	q:'$d(n) $zu(158,0)
	q $zu(158,1,n)
}

}
