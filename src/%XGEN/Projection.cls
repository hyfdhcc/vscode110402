/// Internal.<br/>
/// Projection class used by <class>%XGEN.AbstractElement</class> classes.<br/>
/// This is used to clean up the Studio Assist schema generated for XGEN classes.
Class %XGEN.Projection Extends %Projection.AbstractProjection [ System = 3 ]
{

/// Delete the StudioAssist schema information related to this document.
ClassMethod PurgeSASchema(pClassName As %String)
{
	#; delete the SA schema global for our namespace
	#; find what Document we belong to, as it knows what XMLNS we
	#; belong to.
	Set tXGENDOC = $$$comMemberKeyGet(pClassName,$$$cCLASSparameter,"XGENDOCUMENT",$$$cPARAMdefault)
	If (tXGENDOC'="") {
		Set tXMLNS = $$$comMemberKeyGet(tXGENDOC,$$$cCLASSparameter,"XMLNAMESPACE",$$$cPARAMdefault)
		If (tXMLNS'="") {
			Kill ^ISC.SASchema(tXMLNS)
		}
	}
}

/// This is called when a component class is compiled.
ClassMethod CreateProjection(pClassName As %String, ByRef parameters As %String) As %Status
{
 	Set $ZT="Trap",tSC=$$$OK
	Do {
		Do ..PurgeSASchema(pClassName)
	} While (0)
Exit
	Quit tSC
Trap
 	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

/// This is called when a component class is removed.
ClassMethod RemoveProjection(pClassName As %String, ByRef parameters As %String, recompile As %Boolean) As %Status
{
 	Set $ZT="Trap",tSC=$$$OK
	Do {
		Do ..PurgeSASchema(pClassName)
	} While(0)
Exit
  	Quit tSC
Trap
 	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

}
