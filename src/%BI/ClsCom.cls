Class %BI.ClsCom Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property ClassName As %String(TRUNCATE = 1);

Property Field As array Of %BI.ClsComFld;

Query ByCls(cls) As %SQLQuery(CONTAINID = 1)
{
	SELECT ID
	FROM %BI.ClsCom
	WHERE ClassName=:cls
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,ClassName
	FROM %BI.ClsCom
	ORDER BY ClassName
}

Storage Default
{
<Data name="ClsComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BaseClass</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
</Data>
<Data name="Field">
<Attribute>Field</Attribute>
<Structure>subnode</Structure>
<Subscript>"Field"</Subscript>
</Data>
<DataLocation>^BI.ClsComD</DataLocation>
<DefaultData>ClsComDefaultData</DefaultData>
<IdLocation>^BI.ClsComD</IdLocation>
<IndexLocation>^BI.ClsComI</IndexLocation>
<StreamLocation>^BI.ClsComS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
