/// Advertises services using the Bonjour protocol
Class %Service.BonjourAdvertiser Extends (%RegisteredObject, Advertiser) [ Inheritance = right, System = 4 ]
{

/// Stores the handle of a %Net.BonjourServiceReference in a process private global for this
/// class. We use process private globals because the Bonjour advertising library binds advertisements
/// to processes, and we want any BonjourAdvertiser to be able to add and remove them. For the latter
/// it needs to be able to look up the service reference.
ClassMethod SetRegistrationMap(name As %String, ref As %Net.BonjourServiceReference) [ Internal ]
{
	Set ^||%Service.BonjourAdvertiser("RegistrationMap", name) = ref.Handle
}

/// Returns the service reference (if any) associated with the named advertisement. Returns
/// an empty string if there is none.
ClassMethod LookupRegistrationMap(name As %String) As %Net.BonjourServiceReference [ Internal ]
{
	Set handle = $G(^||%Service.BonjourAdvertiser("RegistrationMap", name))
	If handle '= "" {
		Set ref = ##class(%Net.BonjourServiceReference).%New()
		Set ref.Handle = handle
		Quit ref
	}
	Else {
		Quit ""
	}
}

/// Advertise the given service advertisement. A service with the same name 
/// is already being advertised, update with the new advertisement.
Method Advertise(advertisement As Advertisement)
{
	Set bonjour = ##class(%Net.Bonjour).%New()
	Set txt = ##class(%Net.BonjourTXTRecord).%New()
	Set key = advertisement.NextKey()
	While key '= "" {
		if (key '= "Port") && (key '= "Type") {
			Do txt.SetAt(advertisement.ValueOf(key), key)
		}
		Set key = advertisement.NextKey(key)
	}
	Set name = advertisement.GetName()
	Set port = advertisement.ValueOf("Port", "1972")
	Set type = advertisement.ValueOf("Type", "_isc-unknown._tcp")
	//Delist any old ad with the same name first
	//TODO: Some kind of change testing or simply update support
	//would be more efficient and potentially more reliable
	Do ..Delist(advertisement)
	//Register the service and save a reference to it
	Do ..SetRegistrationMap(name, bonjour.Register(name, type, port, txt))
}

/// Un-advertise the given service. If the given service is not currently
/// being advertised, does nothing.
Method Delist(advertisement As Advertisement)
{
	Set ref = ..LookupRegistrationMap(advertisement.GetName())
	Do:ref ref.Unregister()
}

}
