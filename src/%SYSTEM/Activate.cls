Include %occInclude

/// The <class>%SYSTEM.Activate</class> class provides an interface to the 
/// Cache Activate API
Class %SYSTEM.Activate Extends Help [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Available() As %Boolean [ CodeMode = expression ]
{
$$$isWINDOWS
}

/// Initialize prepares the Activate subsystem for use. Must be called prior
/// to using any Activate Objects
ClassMethod Initialize() As %Status
{
	Quit $$Initialize^%occActivate()
}

/// LoadTypeLibrary loads the COM typelibrary specifed by the Filename parameter.
/// The created files are placed into the package defined by the parameter Package
/// in the current namespace. Flags is an optional parameter which controls the 
/// compilation of the generated classes. See documentation for %apiOBJ for a full 
/// description of the meaning of the Flags parameter
ClassMethod LoadTypeLibrary(Filename, Package, Flags) As %Status
{
	Quit $$LoadTypeLibrary^%occActivate(Filename,Package,$G(Flags))
}

/// Uninitialize tears down the Activate subsystem, reclaiming memory and system
/// resources. Call following last use of any Activate Objects
ClassMethod Uninitialize() As %Status
{
	Quit $$Uninitialize^%occActivate()
}

}
