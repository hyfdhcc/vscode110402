Class SYS.Advertising.IsServiceEnabled Extends Predicate
{

Property Service As %String(MAXLEN = 256);

Method Test() As %Boolean
{
}

Storage Default
{
<Data name="IsServiceEnabledDefaultData">
<Subscript>"IsServiceEnabled"</Subscript>
<Value name="1">
<Value>Service</Value>
</Value>
</Data>
<DefaultData>IsServiceEnabledDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
