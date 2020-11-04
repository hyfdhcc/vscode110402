ROUTINE %GlobalInReadOnlyDB [Type=INC]
#IF 0  ;-------------------------------------------------------
	; Description:    Function to determine if a global is mapped to a read-only database
	; Author:         David Van De Griek
	; Date Started:   03/08/2007
	;
	;  DPV2873 (03/08/2007) - Change logic for GlobalInReadOnlyDB
	;                         SQL Fix ProdLog 56681:  Test for Read only DB is incorrect
	; 
	;-------------------------------------------------------
#ENDIF	;
 
GlobalInReadOnlyDB(global="^",subscript="") [] PUBLIC {
	Set dest=$$GetGlobalSourceDatabase^%SYS.SECURITY($select(subscript="":"^"_global,1:"^"_global_"("""_subscript_""")"))
	do GetNSInfo^%SYS.NAMESPACE(dest,.info)
	QUIT $g(info("ReadOnly"))=1
}
 