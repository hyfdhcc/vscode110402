Class SYS.Advertising.AdvertisementGenerator Extends %Persistent
{

Method Generate() As %Service.Advertisement [ Abstract ]
{
}

Storage Default
{
<Data name="AdvertisementGeneratorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^SYS("Advertising", "AdvertisementGeneratorD")</DataLocation>
<DefaultData>AdvertisementGeneratorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Advertising", "AdvertisementGeneratorD")</IdLocation>
<IndexLocation>^SYS("Advertising", "AdvertisementGeneratorI")</IndexLocation>
<StreamLocation>^SYS("Advertising", "AdvertisementGeneratorS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
