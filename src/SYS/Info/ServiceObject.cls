Class SYS.Info.ServiceObject Extends SYS.Info.Object
{

Property URN As %String(MAXLEN = 256, XMLNAME = "urn", XMLPROJECTION = "ATTRIBUTE");

Property Description As %String(MAXLEN = 256, XMLNAME = "description");

Property URL As %String(MAXLEN = 256, XMLNAME = "url");

ClassMethod CreateFromAdvertisement(advertisement As %Service.Advertisement) As ServiceObject
{
}

/// This parameter provides the default XMLNAME for the class. If it is
/// empty then the class name will be used to construct a default XML name.
/// 
/// The default XMLNAME is used as the top level tag 
/// when exporting objects and the export context
/// did not provide an XML container name.
Parameter XMLNAME = "service";

Storage Default
{
<Data name="Properties">
<Attribute>Properties</Attribute>
<Structure>subnode</Structure>
<Subscript>"SYS.Info.ServiceObject.Properties"</Subscript>
</Data>
<Data name="ServiceObjectDefaultData">
<Subscript>"ServiceObject"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>URI</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Enabled</Value>
</Value>
<Value name="6">
<Value>URL</Value>
</Value>
<Value name="7">
<Value>URN</Value>
</Value>
</Data>
<DefaultData>ServiceObjectDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
