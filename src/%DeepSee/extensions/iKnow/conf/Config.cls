Class %DeepSee.extensions.iKnow.conf.Config Extends (%SerialObject, %XML.Adaptor) [ System = 4 ]
{

Property data As Data(XMLPROJECTION = "ELEMENT");

Property model As Model(XMLPROJECTION = "ELEMENT");

Property models As list Of Model(XMLITEMNAME = "model");

Property classifier As Classifier(XMLPROJECTION = "ELEMENT");

Method GetOccurenceTable() As %String
{
	if (..model.FactType = "crc") {
		Quit ..data.CrcOccurenceTable
	}
	
	Quit ..data.OccurenceTable
}

Method GetUsageTable() As %String
{
	if (..model.FactType = "crc") {
		Quit ..data.CrcUsageTable
	}
	
	Quit ..data.UsageTable
}

Method GetUsageClass() As %String
{
	if (..model.FactType = "crc") {
		Quit ..data.CrcUsageClass
	}
	
	Quit ..data.UsageClass
}

Method GetEntityClass() As %String
{
	if (..model.FactType = "crc") {
		Quit ..data.CrcClass
	}
	
	Quit ..data.EntityClass
}

Method GetEntityTable() As %String
{
	if (..model.FactType = "crc") {
		Quit ..data.CrcTable
	}
	
	Quit ..data.TermTable
}

Method GetIndexOpenMtd() As %String
{
	if (..model.FactType = "crc") {
		Quit "CrcIdxOpen"
	}
	
	Quit "EntityIdxOpen"
}

Method GetIndexExistsMtd() As %String
{
	if (..model.FactType = "crc") {
		Quit "CrcIdxExists"
	}
	
	Quit "EntityIdxExists"
}

Method GetQAPI() As %String
{
	if (..model.FactType = "crc") {
		Quit "%iKnow.Queries.CrcQAPI"
	}
	
	Quit "%iKnow.Queries.EntityQAPI"
}

Storage Default
{
<Data name="ConfigState">
<Value name="1">
<Value>data</Value>
</Value>
<Value name="2">
<Value>model</Value>
</Value>
<Value name="3">
<Value>classifier</Value>
</Value>
<Value name="4">
<Value>models</Value>
</Value>
</Data>
<State>ConfigState</State>
<StreamLocation>^%DeepSee.extensions3B20.ConfigS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
