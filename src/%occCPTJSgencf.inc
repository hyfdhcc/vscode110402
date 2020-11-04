ROUTINE %occCPTJSgencf [Type=INC]

#; definitions for code generated from JS source
#; (for compiler use only)

#include %occCPTHPT


#; return the value of the given global variable
#define JSGETVGLOCF(%var) $$$JSGETVLOCCF(0,%var)

#; return the value of the given local variable in the given static level
#define JSGETVLOCCF(%level1,%var) $$$JSVARCF(%level1,%var)

#; set the given global variable - generates a command
#define JSSETVGLOCF(%var,%value) $$$JSSETVLOCCF(0,%var,%value)

#; set the given global variable - generates an expression
#define JSSETVGLOEXPRCF(%var,%value) ***$$$JSGLOBAL.SetVar(%var,%value)

#; pre-increment/decrement the given global variable - generates an expression
#define JSPREINCVGLOEXPRCF(%var,%offset) ***$$$JSGLOBAL.PreIncVar(%var,%offset)

#; post-increment/decrement the given global variable - generates an expression
#define JSPOSTINCVGLOEXPRCF(%var,%offset) ***$$$JSGLOBAL.PostIncVar(%var,%offset)

#; set the given local variable in the given static level - generates a command
#define JSSETVLOCCF(%level1,%var,%value) Do $$$JSVARCF(%level1,%var).SetTo(world.CodeIndex,%value,world.CurrentFunctionIndex())

#; set the given local variable in the given static level - generates an expression
#define JSSETVLOCEXPRCF(%level,%var,%value) ***$$$JSENVLOC(%level).SetVar(%var,%value)

#; pre-increment/decrement the given local variable in the given static level - generates an expression
#define JSPREINCVLOCEXPRCF(%level,%var,%offset) ***$$$JSENVLOC(%level).PreIncVar(%var,%offset)

#; post-increment/decrement the given local variable in the given static level - generates an expression
#define JSPOSTINCVLOCEXPRCF(%level,%var,%offset) ***$$$JSENVLOC(%level).PostIncVar(%var,%offset)


#; implementation

#; return the value of the given local variable in the given static level
#define JSVARCF(%level1,%var) world.Var(%var,%level1)


#define JSNEWINDET "##class(%CPT.JS.Analyse.Value).%New("""",##class(%CPT.JS.Analyse.Indet).%New())"

#define JSNEWSTRING(%value) "##class(%CPT.JS.Analyse.Value).%New(""string"","_##class(%XSQL.Format).QuoteCos(%value)_")"