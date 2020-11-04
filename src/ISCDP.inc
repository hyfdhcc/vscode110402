ROUTINE ISCDP [Type=INC]
#;/*======================Documentation=======================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;LFT1203 01/30/04 Laura Tillem, add DPR(x) to allow dots in routine names
#;/*====================End Documentation=====================*/
;;depunctuate function
#ifndef ISCDP
#define ISCDP
 
DP(x) Q $TR(x," !@#$%^&*()_-+={[}]:;,.?/|\'""~`")
 
DPR(x) Q $TR(x," !@#$%^&*()_-+={[}]:;,?/|\'""~`")
#endif