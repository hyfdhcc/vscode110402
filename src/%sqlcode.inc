ROUTINE %sqlcode [Type=INC]
#if 0    ;---------------------------------------------------------------------
%sqlcode ; Description:   Function which returns a Message associated with 
	;                a SQLCODE...
	; Author:        Michael Pantaleo
	; Date Started:  6/4/92
	; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
	;  DPV3079 (12/10/2007) - SQL Error localization
	;  DPV2849 (01/25/2007) - More 999 -> $$$MaxStringLength changes
	;  DPV903  (11/05/98) - Some Cache' SQL cleanup
	;  MRP262  (06/04/92) - Initial Creation of entire routine
#endif	;---------------------------------------------------------------------
 
sqlcode(code) ; Return SQLCODE Message...
 #;---------------------------------------------------------------------
 #; code      -  The SQLCODE
 #;---------------------------------------------------------------------
 #;
 QUIT:$g(code)="" "" QUIT $$$FormatMessage(,"%SqlCode","SqlCode"_$zabs(code),,)
 