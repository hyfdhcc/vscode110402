/// A reference to a registered Bonjour service that can be used
/// to update the registration or remove it.
Class %Net.BonjourServiceReference Extends %RegisteredObject [ System = 4 ]
{

Property Handle As %Integer;

/// Unregister this service
Method Unregister()
{
	Do ##class(BonjourLibrary).Delist(..Handle)
}

}
