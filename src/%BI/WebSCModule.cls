Class %BI.WebSCModule Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter EXTENTSIZE = 200;

Property Name As %String(MAXLEN = 2000, TRUNCATE = 1) [ Required ];

Property Param As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Param2 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Groupings As array Of %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1) [ Required ];

Property Descr As %String(MAXLEN = 2000);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Name,Param,Type,Param2 FROM %BI.WebSCModule ORDER BY Name
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="Groupings">
<Attribute>Groupings</Attribute>
<Structure>subnode</Structure>
<Subscript>"G"</Subscript>
</Data>
<Data name="WebSCModuleDefaultData">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Param</Value>
</Value>
<Value name="4">
<Value>Param2</Value>
</Value>
<Value name="5">
<Value>Desc</Value>
</Value>
<Value name="6">
<Value>Descr</Value>
</Value>
</Data>
<DataLocation>^BI.WebSCModuleD</DataLocation>
<DefaultData>WebSCModuleDefaultData</DefaultData>
<ExtentSize>200</ExtentSize>
<IdLocation>^BI.WebSCModuleD</IdLocation>
<IndexLocation>^BI.WebSCModuleI</IndexLocation>
<Property name="Name"/>
<Property name="Param"/>
<Property name="Param2"/>
<Property name="Type"/>
<StreamLocation>^BI.WebSCModuleS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
