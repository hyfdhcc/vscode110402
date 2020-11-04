ROUTINE %occCPTJSruntime [Type=INC]

#; definitions for JS runtime
#; - these are intended for use in non-JS code, too (at least until we put calls into Primitive or $SYSTEM.JS)

#; for compiler-generated code and some runtime system code - only
#include %occCPTJSgencode


#; global object
#define JSGLOBAL %Global

#; setup runtime if necessary
#define JSRUNTIME If $Data($$$JSGLOBAL)#10=0 {Kill %Env Do ##class(%CPT.JS.Runtime.GlobalObject).%New()}

#; create an environment
#define JSNEWENV(%functionname) ##class(%CPT.JS.Runtime.Env).%New(%functionname)

#; create a function closure
#define JSNEWFUN(%functionpath,%functionimpl) ##class(%CPT.JS.Runtime.Function).%New(%functionpath,%functionimpl)

#; 'undefined'
#define JSUNDEFINED $$$JSGLOBAL.%Undefined
#define JSISUNDEFINED(%value) ($IsObject(%value) && ($Classname(%value)="%CPT.JS.Runtime.Builtin.Undefined"))

#; 'null'
#define JSNULL $$$JSGLOBAL.%Null
#define JSISNULL(%value) ((%value)=$$$JSNULL)

#; 'this'
#define JSTHIS %This

#; function
#define JSISFUNCTION(%value) ($IsObject(%value) && ($Classname(%value)="%CPT.JS.Runtime.Function"))

#; typeof
#define JSTYPEOF(%value) $$$JS.TypeOf(%value)

#; convert the value for display
#define JSTOSTRING(%value) $$$JS.JSToString(%value)

#; create a JS array
#def1arg JSNEWARRAY(%values) ##class(%CPT.JS.Runtime.Array).%NewArrayExpression(%values)

#; create a JS regex
#define JSNEWREGEX(%source,%flags) ##class(%CPT.JS.Runtime.Regex).%New(%source,%flags)

#; create a standard JS object expression (__proto__=Object.prototype)
#;
#; NOTE: pass an even number of arguments, each pair is property followed by value
#; - this macro must NOT be used when there are NO values
#def1arg JSNEWOBJEXPR(%values) ##class(%CPT.JS.Runtime.Object).%NewObjectExpression("__proto__",$$$JSOBJECT.prototype,%values)

#; create a standard JS object expression (__proto__=Object.prototype)
#; - this macro must be used when there are NO values
#def1arg JSNEWOBJEXPRNP ##class(%CPT.JS.Runtime.Object).%NewObjectExpression("__proto__",$$$JSOBJECT.prototype)

#; create a custom JS object with the given __proto__ property
#define JSNEWCUSTOMOBJ(%protolink) $$$JSOBJECT.create(%protolink)

#; implement 'new'
#def1arg JSNEWEXPRESSION(%args) $$$JS.NewExpression(%args)

#; standard Class.*
#define JSOBJECT $$$JSGETVGLO("Object")
#define JSARRAY $$$JSGETVGLO("Array")
#define JSFUNCTION $$$JSGETVGLO("Function")

#; method call tail to set multiple properties of a JS object
#; NOTE: pass an even number of arguments, each pair is property followed by value
#;
#; e.g. Do myobj.$$$JSSETOBJPROPS("a",3,"b",4)
#def1arg JSSETOBJPROPS(%values) %SetAtMultiple(%values)


#; establish a global variable with methods corresponding to the given class
#define JSLOADCLASS(%globalvar,%classname) Do ##class(%CPT.JS.Runtime.Builtin.ClassObject).LoadClassIntoGlobal(%globalvar,%classname)

#; remove a global variable
#define JSDELETEGLOBAL(%globalvar) Do $$$JSGLOBAL.DeleteVar(%globalvar)
