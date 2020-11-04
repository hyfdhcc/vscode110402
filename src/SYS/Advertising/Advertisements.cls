/// Manages the advertisement of instance services
/// TODO: Needs a better name so as not to conflict with %Service.Advertisement
Class SYS.Advertising.Advertisements Extends %Persistent
{

Property AdvertisementGenerator As AdvertisementGenerator;

Property AdvertiserGenerator As AdvertiserGenerator;

Property Active As Predicate;

/// Generate an Advertisement from the
/// AdvertisementGenerator and advertise or delist it with an Advertiser generated from the
/// AdvertiserGenerator based on the current value of the Active predicate
Method Advertise()
{
}

/// Advertise or delist all saved instances of this class. See the Advertise() method for details
ClassMethod AdvertiseAll()
{
}

/// Meant to be run as a job, this method refreshes all advertisements every given number
/// of seconds (default is 3)
ClassMethod Server(seconds As %Integer = 3)
{
}

/// Creates a "standard" advertisement object  
ClassMethod SimpleServiceAdvertisement(advertisementGenerator As AdvertisementGenerator, requiredService As %String, advertiserClassName As %String) As Advertisements
{
}

Storage Default
{
<Data name="AdvertisementsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdvertisementGenerator</Value>
</Value>
<Value name="3">
<Value>AdvertiserGenerator</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^SYS.Adverti14DF.AdvertisementsD</DataLocation>
<DefaultData>AdvertisementsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.Adverti14DF.AdvertisementsD</IdLocation>
<IndexLocation>^SYS.Adverti14DF.AdvertisementsI</IndexLocation>
<StreamLocation>^SYS.Adverti14DF.AdvertisementsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
