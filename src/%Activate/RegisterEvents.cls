Class %Activate.RegisterEvents Extends %RegisteredObject [ Abstract, System = 3 ]
{

/// This method is called to register an event handler objects
/// to receive events
Method %RegisterHandler(pHandler As %RegisteredObject)
{
	Do pHandler.%Advise($this.%IDispatchPtr)
}

/// This method is called to unregister
Method %UnRegisterHandler(pHandler As %RegisteredObject)
{
	Do pHandler.%UnAdvise()
}

}
