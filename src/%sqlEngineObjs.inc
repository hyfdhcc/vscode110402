ROUTINE %sqlEngineObjs [Type=INC]
#; These "root" objects should always be initialized with these macros, lest
#; how they're created from the underlying arrays is changed (e.g., the
#; Alg object didn't used to track the query it was associated with) 
#define oXalg ##class(%SQL.Engine.Objects.Alg).%New(##class(%SQL.Engine.Objects.Mts).%New().Query(m))
#define oXasl ##class(%SQL.Engine.Objects.Asl).%New()
#define oXmt ##class(%SQL.Engine.Objects.Mt).%New()
#define oXmts ##class(%SQL.Engine.Objects.Mts).%New()
#; Most of the other ASL code uses variables instead of macros for these
#; values. Annoying to drag variables into methods and procedure blocks, so
#; they're defined here.
#define aslPREKEY 1
#define aslKEY 2
#define aslPOSTKEY 3
#define aslACTION 4

