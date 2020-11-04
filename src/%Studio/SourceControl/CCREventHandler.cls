/// CCR Event Handlier superclass, this does nothing but provide interface for the real
/// event handler classes to use. Subclass from this and implement the methods
/// you need.<p>
/// The interface methods are all implemented as class methods so that the system
/// can make their handler persistent if they so choose (the would need to fire the 
/// appropriate save logic from within one of the callback methods).<p>
/// During a Refresh call, the same instance of the CCREventHandler class will be used to call 
/// <method>RefreshPrepare</method> as well as <method>RefreshFinalize</method>.  This means that properties can be initilized in Prepare
/// and used in Finalize.<p>
/// During an ItemSet load, the same instance will be used to call <method>ItemSetBeforeLoad</method>, <method>ItemSetAfterLoadToOS</method>. 
/// as well as <method>ItemSetAfterLoadToNS</method>.  This allows properties to be accessed between each of the calls.  
Class %Studio.SourceControl.CCREventHandler Extends %RegisteredObject [ System = 4 ]
{

/// This property is set to 1 if the Refresh is being run interactively and it is safe to prompt the user for input.  
/// If it is not true, do not issue any Read commands as it will hang when Refresh is run from Studio
Property RefreshPrompt As %Boolean [ InitialExpression = 0 ];

/// This method is called by the CCR Refresh logic, after the branch has been synced but before any of the items have been loaded into the namespace. 
/// It is intended for use to do any preparatory work that must be done in a certain order (e.g. creation of csp application definitions, security objects, etc).
/// <p>If <var>abortRefresh</var> is set to 1 before returning to the caller, then the caller will abort the Refresh
Method RefreshPrepare(ByRef abortRefresh As %Boolean) As %Status
{
	Quit $$$OK
}

/// This method is called by the CCR Refresh logic, after the items have been refreshed into the namespace.  It is intended for any additional configuration work which 
/// may be necessary (e.g. initialization of reference tables, building of 3rd party sources, etc)
Method RefreshFinalize() As %Status
{
	Quit $$$OK
}

/// The ID of the %Studio.SourceControl.ItemSet object which is being loaded into the current namespace
Property ItemSetID As %String;

/// When an ItemSet is being loaded, its ItemSet is copied to this property.
Property ItemSetItemList As array Of %String;

/// The Name of the ItemSet being loaded
Property ItemSetName As %String;

/// This method is called during the loading of an ItemSet, before anything from the ItemSet has been loaded to the local disk yet (only the ItemSet object has been created).
/// <p>If <var>abortLoad</var> is set to 1 before returning to the caller, then the caller will abort the ItemSet Load
Method ItemSetBeforeLoad(ByRef abortLoad As %Boolean) As %Status
{
	Quit $$$OK
}

/// This method is called during the loading of an ItemSet, after the contents of the ItemSet have been extracted into the Source workspace, 
/// before they have been loaded into the namespace.
/// <p>If <var>abortLoad</var> is set to 1 before returning to the caller, then the caller will abort the ItemSet Load
Method ItemSetAfterLoadToOS(ByRef abortLoad As %Boolean) As %Status
{
	Quit $$$OK
}

/// This method is called during the loading of an ItemSet, after the contents of the ItemSet have been loaded into the namespace, 
/// and after the ImplementCCR routine has been run
Method ItemSetAfterLoadToNS() As %Status
{
	Quit $$$OK
}

}
