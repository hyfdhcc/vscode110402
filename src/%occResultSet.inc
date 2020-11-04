ROUTINE %occResultSet [Type=INC]
#define ExecuteActualList(%query)		##expression($$ExecuteActualList^%SYS.ResultSet(%query))
#define ResultSet(%query)				If '$isobject($get(%sqlcontext)) { Set %sqlcontext=##class(%ProcedureContext).%New() } Do %sqlcontext.NewResultSet(%sqlcontext.Prepare(%query$$$ExecuteActualList(%query)))
 