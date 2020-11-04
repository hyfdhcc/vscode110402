ROUTINE ISCmsub [Type=INC]
;ISCmsub.INC    extrinsic function to return next ^mtemp() subscript
 
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#; LFT1313 10/07/4, Laura Tillem, kill ^mtemp node after assigning index
#; CLN051  10/07/4, Laura Tillem, clean #if 0
#; LRS251 08/14/98, Lee Smith, change ^mtemp global usage per AK327
#; LFT567 07/06/98, Laura Tillem, detach from dbms
#; JMB001 08/16/96, John Basile  Check existence of mtemp to cause <PROTECT>
#endif  /*=====================End Maintenance======================*/      
  
#ifndef ISCmsub
#define ISCmsub
  
#; LRS251+
 ; %msub - Assigns unique subscript in ^mtemp(%msub) and returns it.
 ;         Caller should kill ^mtemp(%msub) when done.
#if 0  ;LFT1313+
%msub() Q $I(^mtemp)
#else   ;LFT1313=
%msub() New x Set x=$I(^mtemp) Kill ^mtemp(x) Quit x
#endif  ;LFT1313-
#; LRS251-
  
#endif