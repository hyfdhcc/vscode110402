Class %BI.AttachInfo Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index IDKey On (FormID, RecordID) [ IdKey, Unique ];

Property ChkField As array Of %Boolean;

Property DateField As array Of %String(TRUNCATE = 1);

Property FormID As %String(TRUNCATE = 1);

Property LastUpdate As %String(TRUNCATE = 1);

Property PicField As array Of %BI.AttachedPicture;

Property RecordID As %String(TRUNCATE = 1);

Property TextField As array Of %String(TRUNCATE = 1);

Property UpdateUser As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AttachInfoDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>LastUpdate</Value>
</Value>
<Value name="2">
<Value>UpdateUser</Value>
</Value>
</Data>
<Data name="ChkField">
<Attribute>ChkField</Attribute>
<Structure>subnode</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="DateField">
<Attribute>DateField</Attribute>
<Structure>subnode</Structure>
<Subscript>"D"</Subscript>
</Data>
<Data name="PicField">
<Attribute>PicField</Attribute>
<Structure>subnode</Structure>
<Subscript>"P"</Subscript>
</Data>
<Data name="TextField">
<Attribute>TextField</Attribute>
<Structure>subnode</Structure>
<Subscript>"T"</Subscript>
</Data>
<DataLocation>^BI.AttachInfoD</DataLocation>
<DefaultData>AttachInfoDefaultData</DefaultData>
<IdLocation>^BI.AttachInfoD</IdLocation>
<IndexLocation>^BI.AttachInfoI</IndexLocation>
<StreamLocation>^BI.AttachInfoS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
