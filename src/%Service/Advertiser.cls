/// An Advertiser receives requests to list and de-list service advertisements.
Class %Service.Advertiser [ Abstract, System = 4 ]
{

/// Advertise the given service advertisement. A service with the same name 
/// is already being advertised, update with the new advertisement.
Method Advertise(advertisement As Advertisement) [ Abstract ]
{
}

/// Un-advertise the given service. If the given service is not currently
/// being advertised, does nothing.
Method Delist(advertisement As Advertisement) [ Abstract ]
{
}

}
