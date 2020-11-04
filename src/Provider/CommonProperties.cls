Class Provider.CommonProperties Extends %Persistent [ System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Name of the object instance.<br>
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Name of the object instance.<br>
Property NameLowerCase As %String(MAXLEN = 128, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// Enter a description <br>
Property Description As %String(MAXLEN = 256, MINLEN = 0);

Storage Default
{
<Data name="CommonPropertiesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>NameLowerCase</Value>
</Value>
</Data>
<DataLocation>^Provider.CommonPropertiesD</DataLocation>
<DefaultData>CommonPropertiesDefaultData</DefaultData>
<IdLocation>^Provider.CommonPropertiesD</IdLocation>
<IndexLocation>^Provider.CommonPropertiesI</IndexLocation>
<StreamLocation>^Provider.CommonPropertiesS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
