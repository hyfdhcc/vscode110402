ROUTINE %occCPTconfig [Type=INC]

#; Whether or not tracing is output when HPTTRACE is set in the configuration
#define HPTDEBUGENABLED 0
#; - set that to 0 for production


#; Whether or not parse tree static metadata is looked up dynamically
#define HPTDYNMETADATA 0
#; - set that to 0 for production


#; How many times to loop around a single position and stack-size before aborting
#define HPTMAXTIMESSEEN 20
#; - that should be plenty


#; Whether or not assertions are enabled
#define CPTASSERTIONS 0
#; - set that to 0 for production


#; Whether or not ScanTree is traced
#define WITHTRACESCANTREE 0
#; - set that to 0 for production


#; Whether or not to save pushed environments in a debugging stack
#define JSDEBUGSTACK 0
#; - set that to 0 for production
