ROUTINE LANGCbasic [Type=INC]
#if 0   /*=======================Maintenance========================*/
SJ1440 10/16/03	Scott Jones, rewrote and placed Basic commands here
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
#endif  /*====================End Documentation=====================*/
 
#ifndef %LANGCbasic
#define %LANGCbasic
#; Intialize the random number generator with a seed value
RANDOMIZE(SEED)	Do $ZU(165,0,$G(SEED)) Quit  ; DAS377
 
#; ERASEARRAY Method
#; Kill subnodes without touching the value itself
ERASEARRAY(GLVN) public { Set var=""
 For  { Set var=$O(@GLVN@(var)) Quit:var=""  Kill @GLVN@(var) }
}
 
#; ERASEARRAYR Method 
#; Kill subnodes without touching the value itself
#; GLVN is an array passed by reference
ERASEARRAYR(GLVN,SUBS) public { Set var="",SUBS=$G(SUBS)
 If SUBS="" { For  Set var=$O(GLVN(var)) Q:var=""  Kill GLVN(var) }
 Else { For  Set var=$O(@SUBS@(var)) Q:var=""  Kill @SUBS@(var) }
 }
 
#; COPY method
#; Kill DEST without destroying global directory entry then copy SRC into DEST
COPY(DEST,SRC) public {
 If $E(DEST)'="^" { Kill @DEST } Else { Do ERASEARRAY(DEST) ZKILL @DEST }
 Merge @DEST=@SRC
}
 
#; COPYR method
#; SRC is an array passed by reference
#; Kill DEST without destroying global directory entry then copy SRC into DEST
COPYR(DEST,SRC) public {
 If $E(DEST)'="^" { Kill @DEST } Else { Do ERASEARRAY(DEST) ZKILL @DEST }
 Merge @DEST=SRC
 }
#endif /* %LANGCbasic */