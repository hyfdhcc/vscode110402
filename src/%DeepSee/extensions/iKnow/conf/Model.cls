Class %DeepSee.extensions.iKnow.conf.Model Extends (%SerialObject, %XML.Adaptor) [ System = 4 ]
{

Property MDField As %String(XMLPROJECTION = "ATTRIBUTE");

Property FactType As %EnumString(VALUELIST = ",entity,crc", XMLPROJECTION = "ATTRIBUTE") [ InitialExpression = "entity" ];

Property Values As %String(MAXLEN = 1024);

Property FactName As %String;

Property FactClass As %String;

Property FactTable As %String;

Property InputColumns As %String;

Property AllColumns [ MultiDimensional ];

Property TransformationType As %Integer [ InitialExpression = 2 ];

Property NullReplacement As %Double [ InitialExpression = -4 ];

Property EntityRestriction As %String;

Property SourceRestriction As %String;

Method FactNameGet() As %String [ ServerOnly = 1 ]
{
	#dim name As %String
	set name = i%FactName
	
	if (name '= "") {
		Quit name
	}
	 
	set name = "Fact"_..MDField_"Def"
	set i%FactName = name
	Quit name
}

Method FactTableGet() As %String [ ServerOnly = 1 ]
{
	#dim name As %String
	set name = i%FactTable
	
	if (name '= "") {
		Quit name
	}
	 
	set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..FactClass)
	Quit:cDef="" name

	set name = cDef.SqlSchemaName_"."_cDef.SqlTableName
	Quit name
}

Storage Default
{
<Data name="ModelState">
<Value name="1">
<Value>MDField</Value>
</Value>
<Value name="2">
<Value>Values</Value>
</Value>
<Value name="3">
<Value>FactName</Value>
</Value>
<Value name="4">
<Value>FactClassName</Value>
</Value>
<Value name="5">
<Value>FactTableName</Value>
</Value>
<Value name="6">
<Value>InputColumns</Value>
</Value>
<Value name="7">
<Value>TransformationType</Value>
</Value>
<Value name="8">
<Value>NullReplacement</Value>
</Value>
<Value name="9">
<Value>FactClass</Value>
</Value>
<Value name="10">
<Value>FactTable</Value>
</Value>
<Value name="11">
<Value>EntityRestriction</Value>
</Value>
<Value name="12">
<Value>SourceRestriction</Value>
</Value>
<Value name="13">
<Value>FactType</Value>
</Value>
</Data>
<State>ModelState</State>
<StreamLocation>^%DeepSee.extensions3B20.ModelS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
