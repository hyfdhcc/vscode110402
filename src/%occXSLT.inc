ROUTINE %occXSLT [Type=INC]
#; XSLT/XPATH definitions
#; 
#; XPATH DOM - Node Types
#define UNKNOWN                  0
#define ELEMENT                  1
#define ATTRIBUTE                2
#define TEXT                     3
#define CDATASECTION             4
#define ENTITYREFERENCE          5
#define ENTITY                   6
#define PROCESSINGINSTRUCTION    7
#define COMMENT                  8
#define DOCUMENT                 9
#define DOCUMENTTYPE             10
#define DOCUMENTFRAGMENT         11
#define NOTATION                 12
 
#; XPATH Result Types
#define XPATHVALUE               1
#define XPATHDOM                 2
 
#; XPATH Processor control flags
#; 
#; Specify this flag if you want the processor to perform validation
#define XPATHFLGVALIDATION                    1
 
#; Specify this flag if you want the processor to process namespaces
#define XPATHFLGNAMESPACES                    2
 
#; Specify this flag if you want the prossor to include ignorable whitespace
#define XPATHFLGINCLUDEIGNORABLEWHITESPACE    4
 
#; Define the JOB private global
#define JobPrivateGlobalTop ^||CacheTemp
#define JobPrivateGlobalRef ^||CacheTemp