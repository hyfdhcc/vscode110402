ROUTINE ISCVAR11 [Type=INC]
#; Displays MVBasic variable from debugger, using the COMMON/EQU map
#; if ISCzvarCMD is #defined then this is a command (LANGC11)
#; else this is a function (LANGF11)
#ifdef ISCzvarCMD
#define QUIT(%arg) Quit
#else
#define QUIT(%arg) Quit %arg
#endif
ZVAR(arg) PUBLIC {
	If '$D(arg) Do $ZU(96,3,3) Quit
	For lev=$ZU(41)-1:-1:1 s info=$ZU(41,lev) Quit:$E(info)="B"  Quit:$E(info)="E"
	If lev=1 Write "Debugger not active",! $$$QUIT("")
	Set mvi=$P(info,"^",3)
	If $E(mvi,*-3,*)'=".mvi" Write mvi," is not an MVBasic routine",! $$$QUIT("")
	Set line=+$P($P(info,"^",2),"+",2),mvi=$E(mvi,1,*-4),lev=lev-1
	#; $ZU(41) reports a namespace if it is different than the current routine's
	#; Since LANGC11 runs in %SYS, we replace null with %SYS
	#; Change an implied namespace (as returned from $ZU(41)) into a valid namespace
	If $E(mvi)="|" { Set nsp=$P(mvi,"""",2),mvi=$P(mvi,"|",3) Set:$E(nsp,1,2)="@@" $E(nsp,1,2)="^^" }
	Else { Set nsp="%SYS" }
	If $D(^|nsp|ROUTINE(mvi,"SMAP")) Goto gotmap
	#; If we get the mgr implied namespace, replace with %SYS so it maps to the SYSPROG account
	Set:"^^"_$ZU(12)=nsp nsp="%SYS"
	Set rc=##class(%Studio.Debugger).SourceLine(mvi,line,1,line,0,.nsp,.map)
	If $D(map("MVB",1),data) { Set srcname=$LI(data,1),srcnsp=$LI(data,5) }
	#; No MVB source, might be a generated class routine
	Elseif $D(^|nsp|rMAP(mvi,"INT","CLS")) { Set srcname=mvi_".MVI",srcnsp=nsp }
	Else {
	 Write "Unable to find source routine to create variable map",! Goto gotmap
	}
	If srcname["~" s file=$P(srcname,"~",1),srcname=$P(srcname,"~",2)
	Else  s file=$$$DEFAULTPROGRAMFILE
	Do CreateMap(file,srcname,mvi,nsp,srcnsp)
gotmap ;
	While $E(arg,*)=" " { Set $E(arg,$L(arg))="" }
	Set i=$Find(arg,"("), nam2=$S(i:$E(arg,1,i-2),1:arg), equ=0
	If $D(^|nsp|ROUTINE(mvi,"SMAP",nam2),name) {
		If $D(^(nam2,"E")) {
#ifdef ISCzvarCMD
			Write nam2," is EQUATED to "
			If $D(^("C")) Write ^("E")," which is COMMON "
			Write name,!
#endif
			Set equ=1
#ifdef ISCzvarCMD
		} Else { Write nam2," is COMMON ",name,!
#endif
		}
		Set:i name=name_$E(arg,i-1,*)
	} Else { Set name=arg }
	If name="" $$$QUIT("")
#; Check for valid variable name.
#; If EQUATE result is not valid just quit without an error.
	Set i=$Find(name,"(")
	Try {
		If 'i { Goto:'$ZNAME(name,0,11) badname }
		Else { Set nam2=$E(name,1,i-2) Goto:'$ZNAME(nam2,0,11) badname }
		If $E(name)'="%" { Set ddata=$ZU(44,lev,"~"_name,11)
			If ddata {
#ifdef ISCzvarCMD
				Write arg,$S(ddata#2:" = "_$ZU(43,lev,"~"_name,11), 1:" <ARRAY>")
#else
				Set line=" "_$S(ddata#2:$ZU(43,lev,"~"_name,11), 1:" <ARRAY>")
#endif
				Quit
			}
		}
		Set ddata=$ZU(44,lev,name,11)
		If ddata {
#ifdef ISCzvarCMD
			Write arg,$S(ddata#2:" = "_$ZU(43,lev,name,11), 1:" <ARRAY>")
#else
			Set line=" "_$S(ddata#2:$ZU(43,lev,name,11), 1:" <ARRAY>")
#endif
			Quit
		}
#ifdef ISCzvarCMD
		Write arg," <UNASSIGNED>"
#else
		Set line=" <UNASSIGNED>"
#endif
	} Catch {
#ifdef ISCzvarCMD
		Write:'equ "Error: ",$P($ZE,">"),">"
#else
		Set line=""
#endif
	}
	$$$QUIT($E(line,2,*))
badname Set line=$S('equ:"Invalid name",1:name) $$$QUIT(line)
}
CreateMap(file,pgm,mviname,nsp,srcnsp) PUBLIC {
	#; Set default file name for include files
	Set $$$MVBfilename=file
	#; Skip the preprocessor if we are passed an mvi name
	If $E(pgm,*-3,*)=".MVI" {
		Merge mvi=^|nsp|ROUTINE($E(pgm,1,*-4),0)
		Set equ=$LB("","")
		Goto compile
	}
	#; For cross-namespace access, use the syntax "account,file,section"
	#; which is deciphered in GetProgramSource^%SYS.MV
	If srcnsp'="" { Set srcnsp=$G($$$NAMESPACENames(srcnsp))
		Set:srcnsp'="" file=srcnsp_","_file_$Select(file[",":"",1:",")
	}
	#; If the preprocessor gets a file error, don't leave the error string
	#; pending for the shell to display later
	Set errStr=$$$MVBerrorstr
	Set rc=$PREPROCESS(file_" "_pgm_".MVB",0,mvi,errs,ign,equ) Kill ign
	If rc {
		Write !,"Preprocessor error: ",rc Do errs
		Set $$$MVBerrorstr=errStr
		Quit
	}
compile ;
	If $Data(mvi)=0 Write !,"No output from preprocessor" Quit
	#; Set up compiler emulation based on current account emulation
	Do MVsetupCompileEmu^%SYS.MV
	#; Set up special flag for code generation - assume both X and Z options
	Do $zu(199,7,3)
	Set rc=$COMPILE(mvi,11,errs,ign,ign,com) Kill ign
	#; Clear special code generation flags
	Do $zu(199,7,0)
	If rc {
		Write !,"Compiler error ",rc Do errs
		Quit
	}
	#; Consolidate all the COMMON results
	Kill COM,EQU
	Set clist=$LI(com,2),name="%" Do setcom
	Set nlist=$LI(com,1) For i=1:1:$LL(nlist) Set name="%"_$LI(nlist,i),clist=$LI(com,i+2) Do setcom
	#; Load the EQU table
	Set l1=$LI(equ,1),l2=$LI(equ,2)
	For i=1:1:$LL(l1) Set name=$LI(l1,i),EQU(name)=$LI(l2,i),EQU(name,"E")=""
	Merge ALL=EQU
	#; Resolve COMMON names in the EQU table
	Set nam1="" For  {
		Set nam1=$O(EQU(nam1),1,def) Quit:nam1=""
		Set i=$Find(def,"("), nam2=$S(i:$E(def,1,i-2),1:def)
		If nam2'="" && $D(COM(nam2),nam3) {
			Set ALL(nam1,"E")=def ; save original definition
			If i { Set $E(def,1,i-2)=nam3 } Else { Set def=nam3 }
			Set ALL(nam1)=def,ALL(nam1,"C")=""
		}
	}
	Merge ALL=COM
	#; File the results
	Kill ^|nsp|ROUTINE(mviname,"SMAP")
	Merge ^|nsp|ROUTINE(mviname,"SMAP")=ALL
	Quit
setcom(i) ;
	For i=1:1:$LL(clist) Set nam1=$LI(clist,i),COM(nam1)=name_"."_i,COM(nam1,"C")=""
	Quit
errs ; display the errors
	For i=1:1:$LL(errs) Set x=$LI(errs,i) Write ! For j=1:1:$LL(x) Write "'",$LI(x,j),"' "
	Quit
}