ROUTINE %occFlag [Type=INC]
#;
#; managing flags
#;
#define flagAPPLICATION       "a"
#define flagSUBCLASSES        "b"
#define flagCOMPILE           "c"
#define flagDISPLAY           "d"
#define flagDELETEEXTENT      "e"
#define flagFORCE             "f"
#define flagCHECKSCHEMA       "i"
#define flagKEEPSOURCE        "k"
#define flagLOCK              "l"
#define flagOPTIMIZE          "o"
#define flagPERCENT           "p"
#define flagSQLONLY           "q"
#define flagRECURSIVE         "r"
#define flagSYSTEM            "s"
#define flagUPDATELIST        "t"
#define flagUPDATE            "u"
#define flagKEEPVALID         "v"
#define flagRELATEDCLASSES    "y"
#;
#define hasflag(%flags,%flag)    (%flags[%flag)
#define systemdefaultflags       "dli"
#define FormatFlag(%flag)        $$FormatFlag^%occSystem(%flag)
#define AddFlag(%flags,%flag)    $$ModifyFlag^%occSystem(%flags,"+"_%flag)
#define RemoveFlag(%flags,%flag) $$ModifyFlag^%occSystem(%flags,"-"_%flag)
#define OptimizeLevel(%flags)    +$e(%flags,$f(%flags,$$$flagOPTIMIZE))
 