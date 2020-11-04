ROUTINE MessageBox [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;WDS262   ;02/02/07 David Shambroom, Initial version
#endif
 
 // MessageBox() Flags
 
#define MBOK                       0
#define MBOKCANCEL                 1
#define MBABORTRETRYIGNORE         2
#define MBYESNOCANCEL              3
#define MBYESNO                    4
#define MBRETRYCANCEL              5
#define MBCANCELTRYCONTINUE        6
#define MBICONHAND                 16
#define MBICONQUESTION             32
#define MBICONEXCLAMATION          48
#define MBICONASTERISK             64
#define MBUSERICON                 128
#define MBICONWARNING              48
#define MBICONERROR                16
#define MBICONINFORMATION          64
#define MBICONSTOP                 16
#define MBDEFBUTTON1               0
#define MBDEFBUTTON2               256
#define MBDEFBUTTON3               512
#define MBDEFBUTTON4               768
#define MBAPPLMODAL                0
#define MBSYSTEMMODAL              4096
#define MBTASKMODAL                8192
#define MBHELP                     16384
#define MBNOFOCUS                  32768
#define MBSETFOREGROUND            65536
#define MBDEFAULTDESKTOPONLY       131072
#define MBTOPMOST                  262144
#define MBRIGHT                    524288
#define MBRTLREADING               1048576
#define MBSERVICENOTIFICATION      2097152
 
 // Dialog Box Command IDs
 
#define IDOK                1
#define IDCANCEL            2
#define IDABORT             3
#define IDRETRY             4
#define IDIGNORE            5
#define IDYES               6
#define IDNO                7
#define IDCLOSE             8
#define IDHELP              9
#define IDTRYAGAIN          10
#define IDCONTINUE          11
 