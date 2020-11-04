ROUTINE JRNERR [Type=INC]
#ifndef JRNERRINC
#define JRNERRINC
 
#if 0   /*=======================Maintenance========================*/
#;HYY1675 8/11/11 Huayong Yang, add JErrSysFreezeOnError
#;JO2141 07/20/09 Jeffrey Orlin, add jerrmirorrprimary/JErrMirrorPrimary
#;HYY905 04/06/04 Huayong Yang, add jerrshdwconflict
#;HYY859 01/15/04 Huayong Yang, add JErrAccess and JErrOpenWt
#;HYY194 08/20/98 Huayong Yang: create this file
#endif  /*=====================End Maintenance======================*/
 
 ;jerror code used in JRNSTART, JRNSWTCH, and JRNSTOP
#define jerrmisc -1
#define jerrlock -2
#define jerrjrn -3
#define jerrdir -4
#define JErrMisc(%e) ($$$jerrmisc_","_%e)
#define JErrLock(%l) ($$$jerrlock_",unable to lock "_$s(%l="":"^%SYS(""JOURNAL"")",1:%l))
#define JErrJrnOff ($$$jerrjrn_",Not journaling")
#define JErrJrnOn ($$$jerrjrn_",Already journaling")
#define JErrDir(%e) ($$$jerrdir_","_%e)
								#;HYY859+
#define jerracc -5
#define jerrowt -6
#define JErrAccess(%jrnf) ($$$jerracc_",Access to journal file "_%jrnf_" denied")
#define JErrOpenWt(%jrnf) ($$$jerrowt_",Unable to open journal file "_%jrnf_" for write access")
								#;HYY859-
								#;HYY905+
#define jerrshdwconflict -7
								#;HYY905-
 #;JO2141+								
#define jerrmirrorprimary -8
#define JErrMirrorPrimary ($$$jerrmirrorprimary_",Cannot stop journaling on the primary mirror member")
 #;JO2141-
								#;HYY1675+
#define jerrsysfreezeonerror -9
#define JErrSysFreezeOnError ($$$jerrsysfreezeonerror_",Cannot stop journaling when the system is set to freeze on error")
								#;HYY1675-
  
#endif ;JRNERRINC