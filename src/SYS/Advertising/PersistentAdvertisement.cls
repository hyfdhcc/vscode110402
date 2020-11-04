/// A persistent advertisement
Class SYS.Advertising.PersistentAdvertisement Extends (AdvertisementGenerator, %Service.GenericAdvertisement) [ Inheritance = right ]
{

/// A persistent advertisement can serve as its own generator, by generating itself
Method Generate() As %Service.Advertisement
{
}

Storage Default
{
<Data name="PersistentAdvertisementDefaultData">
<Subscript>"PersistentAdvertisement"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
</Data>
<Data name="Properties">
<Attribute>Properties</Attribute>
<Structure>subnode</Structure>
<Subscript>"SYS.Advertising.PersistentAdvertisement.Properties"</Subscript>
</Data>
<DefaultData>PersistentAdvertisementDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
