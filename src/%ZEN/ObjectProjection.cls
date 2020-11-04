/// Projection class used by <class>%ZEN.Component.object</class> classes.
/// This is used to manage post-compilation actions for Zen components.
Class %ZEN.ObjectProjection Extends %Projection.AbstractProjection [ System = 3 ]
{

/// Add the Zen class, <var>pClass</var> to the post-compilation queue.
/// <var>pFlag</var> is a csv-list indicating what kind of post-compile action are needed:<br>
/// "schema" - XML schema for Studio needs to be regenerated.<br>
/// "HTML" - HTML include files (CSS and js) need to be regenerated.<br>
/// "SVG" - SVG include files (CSS and js) need to be regenerated.<br>
ClassMethod %QueueClass(pClass As %String, pFlag As %String) As %Status
{
	Set tSC = $$$OK

	#; add class to post-compile queue(s)
	For n = 1:1:$L(pFlag,",") {
		Set tFlag = $P(pFlag,",",n)
		Set:tFlag'="" ^CacheTemp.ZENQueue(%ISCName,pClass,tFlag) = ""
	}
	Quit tSC
}

/// Execute the various post-compilation actions for the Zen library.
ClassMethod EndCompile(qstruct) As %Status
{
	Set tSC = $$$OK
	Set $ZTRAP = "Trap"
	Do {
		Set tSchema = 0

		#; assemble list of work to do
		Set tClass = $O(^CacheTemp.ZENQueue(%ISCName,""))
		While (tClass '= "") {
			Set tPkg = $P(tClass,".",1,$L(tClass,".")-1)
	
			#; find modules this class belongs to (by package)
			Do $zobjclassmethod(tClass,"%GetIncludeInfo",.tModules)

			Set tFlag = $O(^CacheTemp.ZENQueue(%ISCName,tClass,""))
			While (tFlag '= "") {
				If (tFlag = "schema") {
					Set tSchema = 1
				}
				If ((tFlag = "HTML")||(tFlag = "SVG")) {
					Set tPackages(tPkg) = ""
				}
				Set tFlag = $O(^CacheTemp.ZENQueue(%ISCName,tClass,tFlag))
			}
			Set tClass = $O(^CacheTemp.ZENQueue(%ISCName,tClass))
		}
	
		#; clear queue	
		Kill ^CacheTemp.ZENQueue(%ISCName)

		#; perform actions

		#; include files
		Set tDisplay=$$$qualifierGetValue(qstruct,"displaylog")
		Set tKey = $O(tPackages(""))
		While (tKey '= "") {
			Do QueueGroup^%SYS.WorkQueueMgr(%ISCWorkGroup,"##class(%ZEN.ObjectProjection).CreateIncludes",tKey,.tModules,tDisplay)
			Set tKey = $O(tPackages(tKey))
		}
		Set tSC=$$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,,,%ISCWorkGroup)
		If $$$ISERR(tSC) Quit

		#; schemas
		If (tSchema) {
			Set tSC = ##class(%ZEN.Utils).%InvalidateSchema()
			If $$$ISERR(tSC) Quit
		}

	} While(0)
Exit
	Quit tSC
Trap
 	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod CreateIncludes(pKey As %String, ByRef pModules As %String, pDisplay As %Boolean = 1) As %Status
{
	$$$SuspendErrorCount
	Quit ##class(%ZEN.Utils).%GenerateIncludeFilesForModules(pKey,.pModules,,pDisplay)
}

/// This is called when a component class is compiled.
ClassMethod CreateProjection(pClassName As %String, ByRef parameters As %String, modified As %String) As %Status
{
 	Set $ZT="Trap",tSC=$$$OK
	Do {
		Set tActions = $parameter(pClassName,"POSTCOMPILEACTIONS")
		If (tActions '= "") {
			Set tSC = ..%QueueClass(pClassName,tActions)
			If $$$ISERR(tSC) Quit
		}
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
		#; it would be nice to delete the associated include files for this
		#; class, but that is hard to do with no class to call!

	} While(0)
Exit
  	Quit tSC
Trap
 	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

}
