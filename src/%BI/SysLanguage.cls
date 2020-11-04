Class %BI.SysLanguage Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property LanguageName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="SysLanguageDefaultData">
<Attribute>LanguageName</Attribute>
<Structure>node</Structure>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LanguageName</Value>
</Value>
</Data>
<DataLocation>^BI.LanguageD</DataLocation>
<DefaultData>SysLanguageDefaultData</DefaultData>
<IdLocation>^BI.LanguageD</IdLocation>
<IndexLocation>^BI.LanguageI</IndexLocation>
<StreamLocation>^BI.LanguageS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
