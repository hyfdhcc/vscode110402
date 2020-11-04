ROUTINE %occCPTJSgendb [Type=INC]

#; code-generator debugging

#include %occCPTHPT

#; final component of current class name
#define SHORTCLASS $Piece($Classname(),".",$Length($Classname(),"."))

#; final component of given class name
#define SHORTCLASSFOR(%class) $Piece($Classname(%class),".",$Length($Classname(%class),"."))

#if $$$HPTDEBUGENABLED

#; output debugging string using Context
#define GENDB(%message) Write Context.MessageIndent(),$$$SHORTCLASS,": ",%message,!

#define JSTRAP(%message) Write !,"TRAP: ",%message,! BREAK  $$$CPTTHROW("Compiler Error: "_%message)

#define JSBREAK If 1 {BREAK}
#; - avoid problems with spaces after BREAK

#else

#define GENDB(%message)
#define JSTRAP(%message) $$$CPTTHROW("Compiler Error: "_%message)
#define JSBREAK

#endif


#if $$$WITHTRACESCANTREE
#define TRACESCANTREE(%props) Kill %objlasterror Set tracescantree=##class(%CPT.JS.Generate.TraceScanTree).%New($This,ScanType,%props) If '$IsObject(tracescantree) {$$$ThrowStatus(%objlasterror)}
#else
#define TRACESCANTREE(%props)
#endif

#define CHECKCODELINE $$$HPTASSERT(CodeContext=..#CODELINE)
#define CHECKCODEEXPRESSION $$$HPTASSERT(CodeContext=..#CODEEXPRESSION)
#define CHECKNORESULT(%line) Set checknoresult=(%line) $$$HPTASSERT(checknoresult="")
#; - do NOT remove the intermediate 'checknoresult'! - if you do, no MAC code is generated in non-debug mode

