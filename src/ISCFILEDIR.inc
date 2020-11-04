ROUTINE ISCFILEDIR [Type=INC]
 ;ISCFILEDIR.INC -- file/dir operations     ;HYY1762 06/05/12
#if 0   /*=======================Maintenance========================*/
#;HYY1999 04/05/15 Huayong Yang, eliminate daily limit of 999 journal files
#;HYY1762 06/05/12 Huayong Yang, add GetJrnFileName()
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;HYY1269 10/05/06 Huayong Yang, create directory w/ right group permission
#;HYY618 04/30/02 Huayong Yang, allow a directory to be created recursively
#;RAM798 03/02/99 Rick Miller, changed all $$GetDirEXISTS() calls to
#;                $$GetDirOrSpecEXISTS() in order to support a Cache' virtual
#;                volume in a Unix raw disk partition.
#;STC200 02/26/99 Steve Clay, Remove site is macro
#;SML003 01/07/99 Simon Li: handle ' ' in path for $ZF(-1) and $ZF(-2).
#;HYY194 08/20/94 Huayong Yang: move part of JO1036 over here
#;JO1036 05/14/98 Jeffrey Orlin: Change the way we interpret director names
#;                we get as input from the user. Specifically all directory
#;                names must end in a "]". If the closing bracket is omitted
#;                we treat the input as a logical name that must resolve to
#;                a directory spec ending in "]". Otherwise this is an error.
#;                The implication of this is that "user" does not mean the
#;                subdirectory user on VMS, it means the logical name "user"
#;                "[.user]" would mean the subdirectory user. 
#;JAO979 10/17/97 Jeffrey Orlin: VMS corrections
#;HYY124 08/26/97 Huayong Yang: optimize jrnshort (OSVMS only)
#;HYY038 02/03/97 Huayong Yang: correct file name manipulation on OSVMS
#;HYY024 01/08/97 Huayong Yang: GJrnPrefix
#;HYY021 01/03/97 Huayong Yang: creation
#endif  /*=====================End Maintenance======================*/
  
#ifndef ISCFILEDIR
#define ISCFILEDIR
  
#include SITE
#include FILEINC
#include BITWISE  ;JO1036 Interface to $ZBOOLEAN()
  
 ; append delimiter if necessary
FIXDIR(dir) ;procedure, dir is passed by reference
 Q:dir=""
 ; CheckDirVALID() returns the canonical directory spec if
 ; the directory is valid or NULL if it isn't.
 i $$$ISVMS d
 . n x
 . s x=$$ChkDirVALID(dir)
 . i x'="" s dir=x
 i '$$$ISVMS Q:$A(dir,$L(dir))=$A($$$DIRSLASH)
 i '$$$ISVMS s dir=dir_$$$DIRSLASH
 Q
fixdir(dir) ;function
 Q:dir="" ""
 ; CheckDirVALID() returns the canonical directory spec if
 ; the directory is valid or NULL if it isn't.
 i $$$ISVMS d  q dir
 . n x
 . s x=$$ChkDirVALID(dir)
 . i x'="" s dir=x
 Q:$A(dir,$L(dir))=$A($$$DIRSLASH) dir
 Q dir_$$$DIRSLASH
basename(f) ;similar to basename on UNIX
 Q $P(f,$$$DIRSLASH,1,$L(f,$$$DIRSLASH)-1)_$$$DIRSLASH
appdir(d1,d2) ;use $zu(12,d2) to append d2 to canonic dir
 i $$$ISVMS S $E(d1,$L(d1))="."_d2_"]"
 i '$$$ISVMS S d1=d1_d2
 Q d1
VALIDIR(dir) ;validate directory dir and create it if dir doesn't exist
 ; returns:  0 = directory was invalid or could not be created
 ;           1 = directory is valid and (now) exists
 new flag
 s flag=1
 g vdir2
 ;
validir(dir,flag) ;validate directory dir and optionally create it if it
 ; doesn't exist (flag = 1, means create, not 1 means return an
 ; error status if it doesn't exist).
 ; Returns: 0 - failed, dir is invalid or doesn't exist/create failed
 ;          1 - success
 ;
vdir2 ; VALIDIR(dir) comes here with flag set to 1
 ;
#if 0   ;RAM798+
 quit:$$ChkDirEXISTS(dir)'="" 1   ; dir is valid and exists
#else   ;RAM798=
 quit:$$ChkDirOrSpecEXISTS(dir)'="" 1   ; dir is valid and exists
#endif  ;RAM798-
 quit:$$ChkDirVALID(dir)="" 0    ; dir is not valid
 ; Directory name is valid but it doesn't exist, create it
 i flag'=1 q 0  ; flag says don't create, return failure
 ;
 new x
 set x=$$mkdir(dir)  ; returns 0 for success, 1 for failure
 q:x=1 0  ; failed to create
 ;
 ; Now, check again to make sure it exists
#if 0   ;RAM798+
 quit:$$ChkDirEXISTS(dir)="" 0   ; it doesn't we failed
#else   ;RAM798=
 quit:$$ChkDirOrSpecEXISTS(dir)="" 0   ; it doesn't we failed
#endif  ;RAM798-
 q 1  ; success
mkdir(dir) ;create a new directory
								#;HYY1269+
 i $$$ISVMS q:$$ChkDirVALID(dir)="" 1  ; dir is invalid, return failure
 #; CreateDirectoryChain() returns 1 for success and 0 for failure, whereas
 #; mkdir() is expected to return 1 for failure and 0 for success (Unix style).
 q '##class(%Library.File).CreateDirectoryChain(dir)
								#;HYY1269-
  
jrnshort(jf,short) ;get/set short form of a journal file name FIXME HYY1999
         N (jf,short)
         S len=$L($P(jf,";"))
         Q:$G(short)="" $E(jf,len-11,len) ;"GET" form
         S $E(jf,len-11,len)=short ;"SET" form
         Q jf
 #;Use $$$GETJRNPREFIX (%syJrninc) to retrieve the current prefix
 #;Use GJrnPrefix() below to extract the prefix field from an existing journal file name
GJrnPrefix(jf) ;extract prefix from the journal file name jf
         N (jf)
         S fname=$P(jf,$$$DIRSLASH,$L(jf,$$$DIRSLASH))       
         Q $$$JrnNamePrefix(fname)
	 							#;HYY1762+
 #;Extract journal file name from 'path' given in possibly non-native OS format
 #;A journal file name is assumed not to contain "/", "]" or "\".
 #;In fact, currently it contains only alphanumerics, "_"s, "-"s and a ".".
 #;"/" and "\" are invalid in a Windows file name.
GetJrnFileName(path) { 
	i $f(path,"/") q $p(path,"/",$l(path,"/")) ;presumably a Unix path
	if $f(path,"\") q $p(path,"\",$l(path,"\")) ;presumably a Windows path
	s vmsfile=$p(path,"]",2) i vmsfile="" q path ;a name only, not a path
	q $p(vmsfile,";") ;return name from a VMS path without trailing ";"
}
	 							#;HYY1762-
 #;HYY194+ adapted from JO1036
 ; Call this when VALIDIR() returns failure for either curdir or altdir. 
 ; Return an appropriate message to display on the screen.
dirinvalidmsg(dir1,dir2) 
 n valid1,valid2,cnt,msg
 s valid1=$$VALIDIR(dir1),valid2=$$VALIDIR(dir2)
 s cnt=valid1+valid2 ; cnt = 0 if both invalid, 1 if one is valid
 s msg="The following journaling "
 s:cnt msg=msg_"directory is" 
 s:'cnt msg=msg_"directories are"
 s msg=msg_" not valid"_$C(13,10)
 s:'valid1 msg=msg_"     "_dir1_$C(13,10)
 s:'valid2 msg=msg_"     "_dir2_$C(13,10)
 q msg
 #;HYY194-
   
#include ISCChkDir
        
#endif ISCFILEDIR       