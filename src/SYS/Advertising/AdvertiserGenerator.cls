Class SYS.Advertising.AdvertiserGenerator Extends %Persistent
{

Method Generate() As %Service.Advertiser [ Abstract ]
{
}

Storage Default
{
<Data name="AdvertiserGeneratorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^SYS("Advertising", "AdvertiserGeneratorD")</DataLocation>
<DefaultData>AdvertiserGeneratorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Advertising", "AdvertiserGeneratorD")</IdLocation>
<IndexLocation>^SYS("Advertising", "AdvertiserGeneratorI")</IndexLocation>
<StreamLocation>^SYS("Advertising", "AdvertiserGeneratorS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
