Class %DeepSee.extensions.iKnow.conf.Data Extends (%SerialObject, %XML.Adaptor) [ System = 4 ]
{

Property Package As %String(XMLPROJECTION = "ATTRIBUTE");

Property Domain As %String(XMLPROJECTION = "ATTRIBUTE");

Property SourceClass As %String [ InitialExpression = "Source" ];

Property EntityClass As %String [ InitialExpression = "Term" ];

Property CrcClass As %String [ InitialExpression = "CRC" ];

Property MDClass As %String [ InitialExpression = "SourceMetadata" ];

Property OccurenceClass As %String [ InitialExpression = "Occurrence" ];

Property CrcOccurenceClass As %String [ InitialExpression = "CRCOccurrence" ];

Property UsageClass As %String [ InitialExpression = "Usage" ];

Property CrcUsageClass As %String [ InitialExpression = "CRCUsage" ];

Property SourceTable As %String;

Property TermTable As %String;

Property CrcTable As %String;

Property MDTable As %String;

Property OccurenceTable As %String;

Property CrcOccurenceTable As %String;

Property UsageTable As %String;

Property CrcUsageTable As %String;

Property MinSpread As %Double;

Property Sloppy As %Boolean [ InitialExpression = 0 ];

Method SourceClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%SourceClass
}

Method EntityClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%EntityClass
}

Method CrcClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%CrcClass
}

Method MDClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%MDClass
}

Method UsageClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%UsageClass
}

Method CrcUsageClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%CrcUsageClass
}

Method OccurenceClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%OccurenceClass
}

Method CrcOccurenceClassGet() As %String [ ServerOnly = 1 ]
{
	Quit ..Package_"."_i%CrcOccurenceClass
}

Method DomainGet() As %String [ ServerOnly = 1 ]
{
	#dim domain As %String
	set domain = i%Domain
	
	if (domain '= "") {
		Quit domain
	}
	 
	set i%Domain = i%Package
	Quit i%Domain
}

Method PackageGet() As %String [ ServerOnly = 1 ]
{
	#dim package As %String
	set package = i%Package
	
	if (package '= "") {
		Quit package
	}
	 
	set i%Package = i%Domain
	Quit i%Package
}

Method GetTableNames() As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..SourceClass)
		set ..SourceTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..EntityClass)
		set ..TermTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..UsageClass)
		set ..UsageTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..OccurenceClass)
		set ..OccurenceTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..MDClass)
		set ..MDTable = cDef.SqlSchemaName_"."_cDef.SqlTableName

		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..CrcClass)
		set ..CrcTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..CrcUsageClass)
		set ..CrcUsageTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(..CrcOccurenceClass)
		set ..CrcOccurenceTable = cDef.SqlSchemaName_"."_cDef.SqlTableName
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Storage Default
{
<Data name="DataState">
<Value name="1">
<Value>Package</Value>
</Value>
<Value name="2">
<Value>Domain</Value>
</Value>
<Value name="3">
<Value>SourceClass</Value>
</Value>
<Value name="4">
<Value>EntityClass</Value>
</Value>
<Value name="5">
<Value>MDClass</Value>
</Value>
<Value name="6">
<Value>OccurenceClass</Value>
</Value>
<Value name="7">
<Value>UsageClass</Value>
</Value>
<Value name="8">
<Value>SourceTable</Value>
</Value>
<Value name="9">
<Value>TermTable</Value>
</Value>
<Value name="10">
<Value>MDTable</Value>
</Value>
<Value name="11">
<Value>OccurenceTable</Value>
</Value>
<Value name="12">
<Value>UsageTable</Value>
</Value>
<Value name="13">
<Value>CrcClass</Value>
</Value>
<Value name="14">
<Value>CrcOccurenceClass</Value>
</Value>
<Value name="15">
<Value>CrcUsageClass</Value>
</Value>
<Value name="16">
<Value>CrcTable</Value>
</Value>
<Value name="17">
<Value>CrcOccurenceTable</Value>
</Value>
<Value name="18">
<Value>CrcUsageTable</Value>
</Value>
<Value name="19">
<Value>MinSpread</Value>
</Value>
<Value name="20">
<Value>Sloppy</Value>
</Value>
</Data>
<State>DataState</State>
<StreamLocation>^%DeepSee.extensions.i3B20.DataS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
