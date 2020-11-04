ROUTINE %occCPTJSgencode [Type=INC]

#; definitions for code generated from JS source
#; (for compiler use only)

#include %occCPTHPT


#; to make the MAC code a little shorter
#define JS ##class(%CPT.JS.Runtime.Primitive)


#if $$$JSDEBUGSTACK

#; push local frame
#define JSPUSHFRAME(%functionname) Set jsautoframe=##class(%CPT.JS.Runtime.Debug.LocalFrame).%New(%functionname) New %Env

#else

#; push local frame
#define JSPUSHFRAME(%functionname) New %Env

#endif

#define JSDBENV %EnvDB


#; return the scope for the given static level
#define JSENVLOC(%level) %Env(%level)

#; return the value of the given global variable
#define JSGETVGLO(%var) $$$JSGLOBAL.GetVar(%var)

#; return the value of the given local variable in the given static level
#define JSGETVLOC(%level,%var) $$$JSENVLOC(%level).GetVar(%var)

#; set the given global variable - generates a command
#define JSSETVGLO(%var,%value) Do $$$JSGLOBAL.SetVar(%var,%value)

#; set the given global variable - generates an expression
#define JSSETVGLOEXPR(%var,%value) $$$JSGLOBAL.SetVar(%var,%value)

#; pre-increment/decrement the given global variable - generates an expression
#define JSPREINCVGLOEXPR(%var,%offset) $$$JSGLOBAL.PreIncVar(%var,%offset)

#; post-increment/decrement the given global variable - generates an expression
#define JSPOSTINCVGLOEXPR(%var,%offset) $$$JSGLOBAL.PostIncVar(%var,%offset)

#; set the given local variable in the given static level - generates a command
#define JSSETVLOC(%level,%var,%value) Do $$$JSENVLOC(%level).SetVar(%var,%value)

#; set the given local variable in the given static level - generates an expression
#define JSSETVLOCEXPR(%level,%var,%value) $$$JSENVLOC(%level).SetVar(%var,%value)

#; pre-increment/decrement the given local variable in the given static level - generates an expression
#define JSPREINCVLOCEXPR(%level,%var,%offset) $$$JSENVLOC(%level).PreIncVar(%var,%offset)

#; post-increment/decrement the given local variable in the given static level - generates an expression
#define JSPOSTINCVLOCEXPR(%level,%var,%offset) $$$JSENVLOC(%level).PostIncVar(%var,%offset)


#; optimized

#; return the value of the given local variable in the current level (optimized)
#define JSGETVLOCopt(%var) %var

#; set the given local variable in the current level - generates a command (optimized)
#define JSSETVLOCopt(%var,%value) Set %var=%value

#; set the given local variable in the given static level - generates an expression (optimized)
#define JSSETVLOCEXPRopt(%var,%value) $$%JSSet(%value,.%var)

#; pre-increment/decrement the given local variable in the given static level - generates an expression (optimized)
#define JSPREINCVLOCEXPRopt(%var,%offset) $$$JS.PreInc(.%var,%offset)

#; post-increment/decrement the given local variable in the given static level - generates an expression (optimized)
#define JSPOSTINCVLOCEXPRopt(%var,%offset) $$$JS.PostInc(.%var,%offset)


#; set property
#define JSSETPROP(%base,%prop,%value) $$$JS.SetProp(%base,%prop,%value)

#; pre-increment/decrement property
#define JSPREINCPROP(%base,%prop,%offset) $$$JS.PreIncProp(%base,%prop,%offset)

#; post-increment/decrement property
#define JSPOSTINCPROP(%base,%prop,%offset) $$$JS.PostIncProp(%base,%prop,%offset)

#define JSSIMPLETYPEOF(%value) $$$JS.SimpleTypeOf(%value)

#; ignores objects at the moment
#define JSPLUS(%a,%b) $$$JS.Plus(%a,%b)

#; equality operations (stubs for now)
#define JSEQEQ(%a,%b) ((%a)=(%b))
#define JSNEQEQ(%a,%b) ((%a)'=(%b))
#define JSEQEQEQ(%a,%b) ((%a)=(%b))
#define JSNEQEQEQ(%a,%b) ((%a)'=(%b))

#; convert to boolean
#define JSTOBOOL(%value) $$$JS.ToBool(%value)

#; logical not
#define JSLOGNOT(%value) ('$$$JSTOBOOL(%value))

#; is %value equal to NaN (not as easy as it sounds)
#; - NaN is not equal to 0 but it is both >=0 and <=0
#define JSISNAN(%value) ((%value'=0) && (%value>=0) && (%value<=0))

#; binary 'in' operator (not 'for..in')
#define JSIN(%value,%collection) %collection.%HasAtWithProto(%value)

#; escape code which may contain "~"s for passing through CodeStream
#define JSESCAPECODE(%code) $Replace(%code,"~","~~")

#; like JSESCAPECODE but for a $List
#define JSESCAPECODELIST(%codelist) $ListFromString($$$JSESCAPECODE($ListToString(%codelist,$Char(1))),$Char(1))
