ROUTINE ISCzzdump [Type=INC]
#;/*=======================Maintenance=============================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;SJ1280 12/10/00, Scott Jones: zzdump.INC creation
#;/*=====================End Maintenance============================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef ISCzzdump
#define ISCzzdump
 ;+
 ; ZZDUMP command
 ;-
ZZDUMP(x) public { Ztrap:'$D(x) $$$APPERROR($$$ERSYNTX) Set $ZT="zzderr"
#; c is number of characters per line
#; d is number of hexadecimal digits per character code
 If $ZISWIDE(x) { Set c=8,d=4 } Else { Set c=16,d=2 }
 For i=0:c:$Length(x)-1 {
    Set s=$Extract(x,i+1,i+c),n=$Length(s)
    Write !,$TR($J($ZHEX(i),4)," ","0")_": "
    For j=1:1:n {
       Write $TR($J($ZHEX($A(s,j)),d)," ","0")_" "
       Set:$E(s,j)?1C $E(s,j)="."
    }
    Write ?62,s
 }
 Quit
zzderr Set $ZT="" Ztrap $$$APPERROR($$$LASTERROR)
}
#endif