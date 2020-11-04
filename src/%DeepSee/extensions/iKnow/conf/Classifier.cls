Class %DeepSee.extensions.iKnow.conf.Classifier Extends (%SerialObject, %XML.Adaptor) [ System = 4 ]
{

Property Name As %String(XMLPROJECTION = "ATTRIBUTE");

Property ClassifierClass As %String;

Property ClassifierTable As %String;

Property SpreadThreshold As %Double [ InitialExpression = 0.04 ];

Property columns As %String [ InitialExpression = "cz1:100,-cz1:50" ];

Property reftables As %String(MAXLEN = 256);

Property MaxPC As %Integer [ InitialExpression = 20 ];

Property ErrorOnMaxPC As %Integer [ InitialExpression = 1 ];

Property CorrespondenceType As %EnumString(VALUELIST = ",frequency,spread,contrib") [ InitialExpression = "spread" ];

Property MinSourceLength As %Integer [ InitialExpression = 10 ];

Property DimReductionMargin As %Double [ InitialExpression = 0.9 ];

Property UseMahalanobisDistance As %Boolean;

Property EqualProbabilities As %Boolean [ InitialExpression = 0 ];

Property TargetValue As %String;

Property DimReduction As %EnumString(VALUELIST = ",none,pca,gda") [ InitialExpression = "pca" ];

Property TrainingSetPredicate As %String [ InitialExpression = "(c.%ID # 3) > 0" ];

Method ClassifierTableGet() As %String [ ServerOnly = 1 ]
{
	#dim name As %String
	set name = i%ClassifierTable
	
	if (name '= "") {
		Quit name
	}
	 
	set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..ClassifierClass)
	Quit:cDef="" name

	set name = cDef.SqlSchemaName_"."_cDef.SqlTableName
	Quit name
}

Storage Default
{
<Data name="ClassifierState">
<Value name="1">
<Value>ClassifierClass</Value>
</Value>
<Value name="2">
<Value>ClassifierTable</Value>
</Value>
<Value name="3">
<Value>SpreadThreshold</Value>
</Value>
<Value name="4">
<Value>columns</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>MaxPC</Value>
</Value>
<Value name="7">
<Value>CorrespondenceType</Value>
</Value>
<Value name="8">
<Value>MinSourceLength</Value>
</Value>
<Value name="9">
<Value>DimReductionMargin</Value>
</Value>
<Value name="10">
<Value>UseMahalanobisDistance</Value>
</Value>
<Value name="11">
<Value>EqualProbabilities</Value>
</Value>
<Value name="12">
<Value>TargetValue</Value>
</Value>
<Value name="13">
<Value>DimReduction</Value>
</Value>
<Value name="14">
<Value>reftables</Value>
</Value>
<Value name="15">
<Value>GDA</Value>
</Value>
<Value name="16">
<Value>TrainingSetPredicate</Value>
</Value>
<Value name="17">
<Value>ErrorOnMaxPC</Value>
</Value>
</Data>
<State>ClassifierState</State>
<StreamLocation>^%DeepSee.extens3B20.ClassifierS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
