ROUTINE %syPrompt [Type=INC]
#;%syPrompt.INC
#ifndef %syPromptinc
#define %syPromptinc
#if 0   /*=======================Maintenance========================*/
#;SML2207 12/09/15 Simon Li, Warn users when Maximum DB size is reduced.
#;SML1662  3/05/13 Simon Li, Add NoReadOnlyDB and NoDismountedDB flags for GetDirectory.
#;SML862  5/11/07 Simon Li, Check .EXT or .DAT exist when create secondary DB.
#;JLC1004 4/19/07 Jose' Cordeiro, Add MaxInt
#;SML819  2/15/07 Simon Li, Add DBExistOK.
#;SML565  5/06/05 Simon Li, Add DBNonexistOK.
#;LFT1135 10/07/03 Laura Tillem, allow Q in QuitString
#;STC476 09/08/03 Steve Clay, Add additional masks
#;STC472 08/24/03 Steve Clay, Initial version
#endif  /*=====================End Maintenance======================*/
 
#define HelpChar "?"
#define HelpContextChar "?H"
#define BackupChar "^"
#define QuitChar "Quit"
#define QuitString "EXIT,STOP,QUIT,HALT,Q,"
#define NullChar """"""
#define DefaultPrompt "=>"
#;Number of spaces to print on each line before help text is displayed
#define HelpTab 2
 
#define DisableHelpCharMask 1
#define DisableBackupCharMask 2
#define EnableQuitCharMask 4
#define TrapCtrlCMask 8
#define TrapErrorMask 16
#define MatchArrayMask 32
#define MatchExactArrayMask 64
#define InitialDisplayMask 128
#define ObjectMustExist 256
#define AllowNullMask 512
#define EnableMultipleSelectionMask 1024
#define DisableHelpContextCharMask 2048
#;Object must exist 
#define MustExistMask 8192
#;used by $SYSTEM.Database.Get
#define CreateDirectoryMask 16384
#;SML565+
#;If the directory does not exist, just return the directory name.
#;No object will be returned. This must be set with MustExistMask.
#define DBNonexistOK 32768
#;SML565-
#;SML819+
#;If the directory exists, ask user whether it is ok to use
#;this directory for the new DB.
#define DBExistOK 65536
#;SML819-
#;SML862+
#;Tell SYS.Database.GetDirectory() this is creating primary DB.
#define CreatePrimaryDB 131072
#;Tell SYS.Database.GetDirectory() this is creating secondary DB.
#define CreateSecondaryDB 262144
#;SML862-
#;SML1662+
#;Tell SYS.Database.GetDirectory() don't include read-only DB.
#define NoReadOnlyDB 524288
#;Tell SYS.Database.GetDirectory() don't include dismounted DB.
#define NoDismountedDB 1048576
#;SML1662-
#;SML2207 ; For GetNumer() to accept incremental/decremental value from default.
#define AllowIncrementalNumber 2097152
 
#;Number of lines per page of display
#define LinesPerPage 20	
 
#; Common return values from $SYSTEM.Prompt class methods 
#define ErrorResponse -1
#define CtrlCResponse 0
#define SuccessResponse 1
#define BackupResponse 2
#define QuitResponse 3
#define HelpResponse 4
#define HelpContextResponse 5
 
#Define Yes "Yes"
#Define No "No"
#Define YesUpperCase "YES"
#Define NoUpperCase "NO"
 
#define	MaxInt	2147483647
 
#endif %syPromptinc 
 