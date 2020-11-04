/// A generic concrete implementation of %Service.Advertisement
Class %Service.GenericAdvertisement Extends (%RegisteredObject, %Service.Advertisement) [ Inheritance = right, System = 4 ]
{

Property Name As %String;

Property Properties As array Of %String;

/// Returns the name of the service being advertised
Method GetName() As %String
{
	Quit ..Name
}

/// Given "", returns the first key present in.
/// Given a key, returns the next key present. Returns ""
/// if there are no further keys.
Method NextKey(key As %String = "") As %String
{
	Quit ..Properties.Next(key)
}

/// Given a key, returns the value present, or default if not found.
Method ValueOf(key As %String, default As %String = "") As %String
{
	If ..Properties.IsDefined(key) {
		Quit ..Properties.GetAt(key)
	}
	Else {
		Quit default
	}
}

}
