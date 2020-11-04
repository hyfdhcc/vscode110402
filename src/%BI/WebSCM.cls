Class %BI.WebSCM Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

///   Short cuts selected
Property Shortcuts As array Of %String(TRUNCATE = 1);

Storage Default
{
<Data name="Shortcuts">
<Attribute>Shortcuts</Attribute>
<Structure>subnode</Structure>
<Subscript>"S"</Subscript>
</Data>
<Data name="WebSCMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BI.WebSCMD</DataLocation>
<DefaultData>WebSCMDefaultData</DefaultData>
<IdLocation>^BI.WebSCMD</IdLocation>
<IndexLocation>^BI.WebSCMI</IndexLocation>
<StreamLocation>^BI.WebSCMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
