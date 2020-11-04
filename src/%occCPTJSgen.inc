ROUTINE %occCPTJSgen [Type=INC]

#; definitions for the JS code-generator
#; - these definitions are for use within the generator code, not in the generated code

#include %occCPTcommon


#define QUITONSCANTYPEDECLARE If ScanType=..#SCANDECLARE {Quit}
#; - we might have to use that shortcut less when we introduce FunctionExpressions


#define TAB $Char(9)
#define GENCODE(%code) Set sc=Stream.Write(%code) If $$$ISERR(sc) {$$$ThrowStatus(sc)}


#; symbol types
#define SYMBOLFORMAL 1
#define SYMBOLEXPR 2
#define SYMBOLVAR 3
#define SYMBOLFUNCTION 4
#define SYMBOLPENDINGFUNCTION 5
#define SYMBOLGLOBAL 6

#; name roles
#define NAMEROLEDEC 1
#define NAMEROLEDECSET 2
#define NAMEROLESET 3
#define NAMEROLEGET 4


#define GLOBALSCOPENAME "__global__"

