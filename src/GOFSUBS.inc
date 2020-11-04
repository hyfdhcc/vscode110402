ROUTINE GOFSUBS [Type=INC]
 ; Device selection file for %GOF,%GIF
 ; needs GOFIO defined as INPUT or OUTPUT (default)
#if 0   /*=======================Maintenance========================*/
LFT1175  ;12/12/03, Laura Tillem, limit gof output to 255 files
STC242   ;04/13/00, Steve Clay: Remove unused code to solve NOLINE
STC200   ;02/26/99, Steve Clay: rmeoved site is macro
LRS273   ;10/16/98, Lee Smith: rename "BIN" translation to "RAW"
SJ1180   ;10/06/97, Scott Jones, made support Cache' 3.0
VGG195   ; 6/19/95, Vadim Goldin: cleaned up old features
DKA234   ; 2/13/95, Keith Avery: Corrected write-enable warning for 1st volume.
         ;          Reset current device before displaying BOT error.
         ;          Corrected misspelling of "byts".
AN143    ;12/06/94, Arvind Narayan, VMS platforms must use MTunload (W *-13)
         ;          for multi-volume operations at the end of a volume.
AHS133   ; 7/06/94, Amir Shokrollahi, added a warning message for
         ;          write protected tapes.
MJF042   ; 5/25/94, Mike Franklin. various 5.10 bug fixes
         ;          - added parameters (IOPAR) to an OPEN
         ;          - prevent same RMS name from being reused on output
         ;          - prevent >255 volumes
         ;          - add error trapping to mount() subroutines
MJF013   ;11/05/93, Mike Franklin. 
#endif  /*=====================End Maintenance======================*/
 
#ifndef gofdev
  #define gofdev
  #ifndef GOFIO
     #define GOFIO "OUTPUT"
  #elseif $$$GOFIO'="OUTPUT"&($$$GOFIO'="INPUT")
     #define GOFIO "OUTPUT"
  #endif
  #if $$$GOFIO="OUTPUT"
     #define DEVTAG OUTPUT
  #else
     #define DEVTAG INPUT
  #endif
 
#if $$$GOFIO="INPUT" ; input routines
mount() Set bufstr="" ; mount tape, check if on line/BOT.
mnt Set $zt="mounterr^"_$zn ; quits with 0/1 (failure/success)
 Close IO Xecute ("Open IO:"_IOPAR) ; open new device/file
 Use IO Use:$$$SetXltRAW!1 0
 Quit:IOT="RMS" 1 ; successful 'mounting' file
 New za Use IO Write *$$$MTrewind Set za=$za Use 0
 If za\$$$MTonl#2=0 Write !,"Tape unit OFFLINE." Quit 0
 If za\$$$MTbot#2=0 Write !,"Tape unit not at BEGINNING OF TAPE." ;not fatal
 If za\$$$MTrdy#2=1 Write !,"Tape unit reports NOT READY." Quit 0
 Quit 1
 
mounterr Set $zt="" Use 0 Write !!,"An error occurred while attempting to open the"
 Write " next volume: ",!?5,$ze Set $ze=""
 Quit:'$$ask("Press RETURN to try again, or STOP to quit",.x) 0
 Goto mnt
 
#else ; Output subroutines
#if 0   ;STC242+
#;Note that I have commented out this section of code since itdoesn't appear to be used anywhere
#;and is causing a <NOLINE> error with the call to wout()
#; Begin each tape/file volume (comment, date/time, volume)
volhead() Set volume=volume+1
 If volume>255 Set %gofmsg="Exceeded volume limit of 255." Quit 0
 Set $e(header(1),6)=$c(volume)
 Set bytes=$l(header(0))+$l(header(1))+$l(header(2))
 Quit:'$$wout(header(0)) 0 Quit:'$$wout(header(1)) 0 Quit:'$$wout(header(2)) 0
 Quit 1
#endif  ;STC242-        
mount() ;mount a new file
 ;cases: IOT="MT" have them mount a new tape, rewind, write enabled
 ;IOT="BT" same as MT?
 ;IOT="RMS" close first file, compute next file?
 ;IOT= diskette same as MT?
 Use 0 Set bufstr=""
 If IOT="MT"!(IOT="BT") Write !!,"Volume ",volume,": end of media",! d  q $$mountmag
 . u IO
 . i $$$ISVMS  Write *$$$MTunload 
 . i '$$$ISVMS Write *$$$MTrewind
 . Close IO
#;LFT1175+
 If volume>254 Do  Quit 0
 . Use 0 Write !!,?5,"*** ERROR: Maximum volume number (255) exceeded"
#;LFT1175-
 If IOT'="RMS" Do  Quit 0
#if $$$FILETYPE="GOF"
 . If 'write Set %gofmsg="Cannot mount next instance of '"_IOT_"' device type."
#else
 . If 'write Set %romfmsg="Cannot mount next instance of '"_IOT_"' device type."
#endif
 . Else  Write !!,"Cannot mount next instance of '"_IOT_"' device type",!
 If write Use 0 Write:$x>39 ! Write ?40 Write $j($fn(gblocks,","),10)," data block"
 If  Write $e("s",gblocks'=1)," written (partial)"
 If  Write !?5,"File '"_IO_"' (Volume ",$j(volume,3),") size limit reached."
 Close IO Set POP=0,rmsnames($$UC(IO))="" ; keep track of names used
mountr Set:'$d(IO("F")) IO="" ; IO("F") contains auto-continue code, if any
 Do NEXT^%IO Quit:POP 0
 If $d(rmsnames($$UC(IO))) Do  Goto mountr:'$d(IO("F"))
 . If $d(IO("F")) Write !!,"The file ",IO," has already been used, and will now be overwritten" Quit
 . Write !!,"That file has already been used. Please select another file name"
 . Write !,"or enter STOP to quit",!
 Quit 1
mountmag() ; mount a mag tape or cartridge tape
 Use 0 Write !!,"The tape should now be rewinding."
mountask Use 0 Write !!,"Please mount the tape for Volume ",volume+1,"."
 Write !,"Be sure that this new tape is ON LINE and WRITE ENABLED."
 If volume=0 Use 0 Do
 . Write !!,"WARNING: If this volume is NOT write enabled, stop the" 
 . Write !,"         utility now and restart it with a write enabled tape!" 
 Set POP='$$ask("Press RETURN when the tape is correctly mounted",x)
#if $$$FILETYPE="GOF"
 If POP Write !!,"Stopping" Set:'write %gofmsg="User termination during requested tape mount" Quit $s(%gofmsg="":1,1:%gofmsg)
#else 
 If POP Write !!,"Stopping" Set:'write %romfmsg="User termination during requested tape mount" Quit $s(%romfmsg="":1,1:%romfmsg)
#endif
 Set $zt="mnterr^"_$zn
 Xecute ("Open IO:"_IOPAR) Use IO Set za=$$$SetXltRAW,za=$za,ok=1 Use 0
 If za\$$$MTonl#2=0 Write !,"Not ON-LINE!" Set ok=0
 If za\$$$MTwrt#2=1 Write !,"Not WRITE ENABLED!" Set ok=0
 If ok Use IO Write *$$$MTrewind Set za=$za Use 0 ;rewind it
 If ok,za\$$$MTbot#2=0 Write !,"Not at BEGINNING OF TAPE!" Set ok=0
 Close IO If 'ok Write !,"Enter 'STOP' to quit this utility..." Goto mountask
 Xecute ("Open IO:"_IOPAR)
 Use IO Use:$$$SetXltRAW!1 0
 Quit 1
 
mnterr   Set $zt="" Use 0
 Write !!,"An error has occurred while attempting to mount the tape: ",$ze
 Set $ze="" Write !,"To exit from this utility, enter STOP"
 Goto mountask
 
#endif ; mount for input/output
 
device() ;set the defaults, and select an output device. quits 0/1 fail/succeed
 Kill IO Set IO="" ;define defaults for I/O device types
#;
#if $$$GOFIO="OUTPUT"
 For df="MT","BT" Do
 . Set IO("DF",df,"FM")=$$$TAPEformW,IO("DF",df,"RL")=$$$TAPErec
 . Set IO("DF",df,"BL")=$$$TAPEblk,IO("DF",df,"RW")="Y"
 Set IO("DF","RMS","FM")="*!"_$$$RMSDFW ;RMS files with size limits
#else ; GOFIO="INPUT"
 For df="MT","BT" Do
 . Set IO("DF",df,"FM")=$$$TAPEformR,IO("DF",df,"RL")=$$$TAPErec
 . Set IO("DF",df,"BL")=$$$TAPEblk,IO("DF",df,"RW")="Y"
 Set IO("DF","RMS","FM")=$$$RMSDFR ;RMS files
#endif ; GOFIO="OUTPUT
#;
dask Do $$$DEVTAG^%IO Use 0 Quit:POP 0
 If IOT="TRM" Write *7,!,"Cannot use TERMINAL devices.",! Quit 0
 If (IOT="MT")!(IOT="BT")!(IOT="RMS")
 Else  Write *7,!,"Cannot use '"_IOT_" type devices yet.",! Goto dask
#if $$$GOFIO="OUTPUT"
 Set iosize=$g(IO("SZ"))
 If iosize,iosize'>(64*1024) Write *7,!,"Maximum media size must be more than 64k bytes",! Goto dask
#endif
 Use IO Use:$$$SetXltRAW!1 0
 Quit 1
#;
ask(prompt,var,default,control,p1,p2) ;'var' returns value, func. returns 0/1
 Set default=$g(default),p1=$g(p1),p2=$g(p2),control=$g(control)
ask1 Write !,$g(prompt),": " Write:default'="" default,"=> "
 Hang 0 Read var If var="",default'="" Set var=default
 Quit:$$STOP(var) 0
 If control["y"!(control["Y") Do  Goto ask1:var=""
 . Set var=$tr($e(var),"yn","YN") Quit:var="Y"!(var="N")
 . Write "  Please enter Yes or No" Set var=""
 If control["n"!(control["N"),var<p1&(p1'="")!(var>p2&(p2'="")) Do  Goto ask1
 . Write " [ please enter a number " If p1="",p2="" Write " ]" Quit
 . If p1'="",p2'="" Write "between ",p1," and ",p2," ]" Quit
 . Write:p1'="" "greater than ",p1 Write:p2'="" "less than ",p2 Write " ]"
 Quit 1
#endif ; #ifdef gofdev