/// Generates an advertiser by calling the %New() method of an %Service.Advertiser class with
/// a given name
Class SYS.Advertising.AdvertiserByName Extends AdvertiserGenerator
{

Property ClassName As %String(MAXLEN = 256);

Method Generate() As %Service.Advertiser
{
}

Storage Default
{
<Data name="AdvertiserByNameDefaultData">
<Subscript>"AdvertiserByName"</Subscript>
<Value name="1">
<Value>ClassName</Value>
</Value>
</Data>
<DefaultData>AdvertiserByNameDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
