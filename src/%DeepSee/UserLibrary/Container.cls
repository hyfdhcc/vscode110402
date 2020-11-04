/// This class provides a way to define folder items (such as dashboards or pivots) within
/// the XData block of class.<br/>
/// This provides a convenient way to define dashboards and other items that are meant to be
/// delivered as part of an application.<br/>
/// Compiling a Container class causes the XML within the Contents section to be processed and
/// any items defined will be loaded into the current namespace.
Class %DeepSee.UserLibrary.Container Extends %RegisteredObject [ Abstract, CompileAfter = %DeepSee.UserLibrary.Utils, System = 4 ]
{

/// This XData section contains the contents of this container.
/// Typically this is an xml document representing a Dashboard or Pivot.
XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee/library" ]
{
}

/// This method causes the contents of this container to be loaded at compilation time.
/// It can also be called directly at a later time.
ClassMethod %Process(pVerbose As %Boolean = 1) As %Status [ CodeMode = objectgenerator, GenerateAfter = %OnLoad ]
{
	Set tSC = $$$OK

	If (%class.Abstract || (%class.Name = "%DeepSee.UserLibrary.Container")) {
		Do %code.WriteLine(" Quit $$$OK")
		Quit $$$OK
	}
	Set tVerbose=1
	If $data(%qstruct),$$$qualifierGetValue(%qstruct,"displaylog")=0 Set tVerbose=0
	Write:tVerbose !
	Set tSC = ##class(%DeepSee.UserLibrary.Utils).%ImportContainer(%class.Name,1,tVerbose)
	If $$$ISERR(tSC) Quit tSC

	// Notify
	Set tSC = ..%OnLoad()

	// Generate code
	Do %code.WriteLine(" Set tSC = ##class(%DeepSee.UserLibrary.Utils).%ImportContainer("""_(%class.Name)_""",1,pVerbose)")
	Do %code.WriteLine(" If $$$ISERR(tSC) Quit tSC")
	Do %code.WriteLine(" Quit ..%OnLoad()")
	Quit tSC
}

/// This method is called immediately after the contents of this container are loaded.
ClassMethod %OnLoad() As %Status
{
	Quit $$$OK
}

}
