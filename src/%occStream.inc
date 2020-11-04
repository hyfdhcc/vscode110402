ROUTINE %occStream [Type=INC]
#define modeREADNODATA 0
#define modeREADNOTCHANGED 1
#define modeREADCHANGED 2
#define modeWRITE 3
#define modeREADBUFFER 4
#define modeWRITEJUSTSAVED 5

#define modeREADNORMAL 0
#define modeREADLINE 1
#define modeWRITENORMAL 0
#define modeWRITEAPPEND 1

#define streamGlobal "^CacheStream"
#define streamInitTmpGlobal Set i%TempGbl="^||%CacheStream("_$increment(^||%CacheStream)_")"
#define streamTmpGlobalDefault	(i%TempGbl=""||($extract(i%TempGbl,1,16)="^||%CacheStream("))