/// A description of a service provided by a server
/// It is presented with a name and type, as well as key/value pairs
/// Advertisements with the same name are assumed to be advertising
/// the same service.
Class %Service.Advertisement [ Abstract, System = 4 ]
{

/// Returns the descriptive name of the service being advertised
/// This name should be appropriate to display to a user in a selection menu
/// It also must be unique amongst advertisements being advertised by the same
/// %Service.Advertiser
Method GetName() As %String [ Abstract ]
{
}

/// Given "", returns the first key present in.
/// Given a key, returns the next key present. Returns ""
/// if there are no further keys.
Method NextKey(key As %String = "") As %String [ Abstract ]
{
}

/// Given a key, returns the value present, or default if not found.
Method ValueOf(key As %String, default As %String = "") As %String [ Abstract ]
{
}

}
