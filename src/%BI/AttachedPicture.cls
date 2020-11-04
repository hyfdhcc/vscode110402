Class %BI.AttachedPicture Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Picture As %GlobalBinaryStream;

Storage Default
{
<Data name="AttachedPictureState">
<Attribute>listnode</Attribute>
<Subscript>"%BI.AttachedPicture"</Subscript>
<Value name="1">
<Value>Picture</Value>
</Value>
</Data>
<State>AttachedPictureState</State>
<StreamLocation>^BI.AttachedPictureS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
