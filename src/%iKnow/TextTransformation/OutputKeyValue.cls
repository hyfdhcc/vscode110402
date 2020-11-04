/// This class represents a key-value pair identified when executing a TT model.
Class %iKnow.TextTransformation.OutputKeyValue Extends %SerialObject [ System = 4 ]
{

Property Header As %String(MAXLEN = 1000);

Property Key As %String(MAXLEN = 1000);

Property Value As %String(MAXLEN = 2000);

Property Location As OutputLocation;

Index HeaderIdx On Header;

Index KeyIdx On Key;

Storage Default
{
<Data name="OutputKeyValueState">
<Value name="1">
<Value>Header</Value>
</Value>
<Value name="2">
<Value>Key</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
<Value name="4">
<Value>Location</Value>
</Value>
</Data>
<State>OutputKeyValueState</State>
<StreamLocation>^%iKnow.Text16EC.OutputKeyValueS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
