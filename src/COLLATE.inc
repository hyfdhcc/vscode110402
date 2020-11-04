ROUTINE COLLATE [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;PWC921 10/19/04 Peter Cudhea, Rename %COLLATE to COLLATE
DKA212   ;11/19/93, Keith Avery: Created this include file
#endif  /*=====================End Maintenance======================*/
 
#define COLLATENAME(%index)   $$NAME^COLLATE(%index)
#define COLLATEABBREV(%index) $$ABBREV^COLLATE(%index)
#define COLLATEINDEX(%abbrev,%default) $$INDEX^COLLATE(%abbrev,%default)
#define DEFAULTCOLLATION      1