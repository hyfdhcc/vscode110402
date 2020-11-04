ROUTINE %occCPTJSA [Type=INC]

#define JSANEWINDET ##class(%CPT.JS.Analyse.Value).%New("",##class(%CPT.JS.Analyse.Indet).%New())

#define JSANEWSAFE(%name) ##class(%CPT.JS.Analyse.SafeBuiltin).%New(%name)

#define JSANEWUNDEF ##class(%CPT.JS.Analyse.Value).%New("undefined","")

#define JSAISVORF(%v) $$$HPTASSERT(($Classname(%v)="%CPT.JS.Analyse.Value") || ($Classname(%v)="%CPT.JS.Analyse.Function"))
