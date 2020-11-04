ROUTINE ISCDIRFULL [Type=INC]
;ISCDIRFULL.INC   provide full directory name extrinsic function
 
#ifndef ISCDIRFULL
#define ISCDIRFULL
 
DIRFULL(dir) Q $ZU(12,dir)
 
#endif