ROUTINE ISCHasFile [Type=INC]
 ;ISCHasFile.INC   -- check if a file exists HYY021
#ifndef ISCHasFile
#define ISCHasFile
  
HasFile(f) Q ''$zu(78,22,f) ;1: file exists 0: not
  
#endif ISCHasFile