Class %WebStress.Control.ValidData.Response Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

Property OK As %Boolean;

Property Generators As list Of %WebStress.Control.ValidData.Response.Generators;

Storage Default
{
<Data name="ResponseState">
<Subscript>"WebStress.Control.ValidData.Response"</Subscript>
<Value name="1">
<Value>Generators</Value>
</Value>
<Value name="2">
<Value>OK</Value>
</Value>
</Data>
<State>ResponseState</State>
<StreamLocation>^WebStress.ControlA49.ResponseS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
