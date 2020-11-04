ROUTINE %occMetaInfo [Type=INC]
#;
#define HASH(%string,%hash)       $s(%string="":"",$l(%string>100):%string,1:$get(%hash(%string),%string))
#define PUSH                      $lb("")
#define POP                       $lb()
#define VALUE(%value)             $lb(%value)
#;
#define languageCpp              "cpp"
#;
#define modeCppALLMODES               $lb("gen","genwd","gru","lcb","dyn")
#define modeCppCodeGen                "gen"
#define modeCppCodeGenWithDescription "genwd"
#define modeCppCodeGenUpdate          "gru"
#define modeCppLight                  "lcb"
#define modeCppDynamic                "dyn"
#;
#define subnode(%language,%mode)  %language_"-"_%mode
#;
#define metaCATEGORYclass          1
#define metaCATEGORYproperty       2
#define metaCATEGORYmethod		   3
#define metaCATEGORYargument       4
#define metaCATEGORYquery          5
#define metaCATEGORYindex          6
#define metaCATEGORYstorage        7
#define metaCATEGORYhashtable     10
#;
#define metaXXXXhash                      99
#;
#define metaCLASSclassname                11
#define metaCLASSclientname               14
#define metaCLASSclasstype                12
#define metaCLASSprimarysuperClassname    13
#define metaCLASSprimarysuperClientname   15
#define metaCLASSglobalname               16
#define metaCLASSdescription             122
#define metaCLASStimestamp                98
#define metaCLASSissystem                126
#;
#define metaPROPtypeClassname             21
#define metaPROPtypeClientname           101
#define metaPROPtypeClienttype            22
#define metaPROPtypeCollection            23
#define metaPROPtypeElementClassname      24
#define metaPROPtypeElementClientname    102
#define metaPROPtypeElementClienttype     25
#define metaPROPtypeClasstype            107
#define metaPROPcomslot                   26
#define metaPROPgetexists                 27
#define metaPROPgetdirect                 28
#define metaPROPsetexists                 29
#define metaPROPsetdirect                 30
#define metaPROPclientname                31
#define metaPROPinitialexpression        108
#define metaPROPnotswizzled              119
#define metaPROPidslot                   120
#define metaPROPexistsinsuper            121
#define metaPROPdescription              123
#define metaPROPissystem                 127
#;
#define metaMETHrettypeClassname          41
#define metaMETHrettypeclientname        103
#define metaMETHrettypeClienttype         42
#define metaMETHrettypeCollection         43
#define metaMETHrettypeElementClassname   44
#define metaMETHrettypeElementclientname 104
#define metaMETHrettypeElementClienttype  45
#define metaMETHclassmethod               46
#define metaMETHfirstarghasdef            47
#define metaMETHclientname                48
#define metaMETHexistsinsuper            118
#define metaMETHdescription              124
#define metaMETHissystem                 128
#;
#define metaARGtypeClassname              51
#define metaARGtypeClientname            105
#define metaARGtypeClienttype             52
#define metaARGtypeCollection             53
#define metaARGtypeElementClassname       54
#define metaARGtypeElementClientname     106
#define metaARGtypeElementClienttype      55
#define metaARGordinal                    56
#define metaARGbyref                      57
#define metaARGhasdefault                 58
#define metaARGdefaultvalue               59
#define metaARGclientname                 60
#;
#define metaQUERYparamcount               61
#define metaQUERYsqlname                  62
#define metaQUERYargshavedefault          63
#define metaQUERYclientname               64
#define metaQUERYexistsinsuper            65
#define metaQUERYdescription             125
#define metaQUERYissystem                129
#;
#define metaINDEXtype                    109
#define metaINDEXunique                  110
#define metaINDEXglobal                  111
#define metaINDEXindex                   112
#define metaINDEXnumkeysub               113
#define metaINDEXkey                     114
#define metaINDEXproperties              115
#define metaINDEXdataproperties          116
#;
#define metaSTORAGEserialization         117
#;
#define metaFIRSTUNUSEDKEYWORD           130
#;
#define enumCLASSTYPEnone          0
#define enumCLASSTYPEdatatype      1
#define enumCLASSTYPEpersistent    2
#define enumCLASSTYPEserial        3
#define enumCLASSTYPEstream        4
#define enumCLASSTYPEview          5
#define enumCLASSTYPEunknown      -1
#;
#define enumCOLLECTIONnone         0
#define enumCOLLECTIONarray        1
#define enumCOLLECTIONlist         2
#define enumCOLLECTIONrelationship 3
#define enumCOLLECTIONunknown     -1
#;
 