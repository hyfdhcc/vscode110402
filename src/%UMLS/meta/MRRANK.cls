/// Concept Name Ranking
Class %UMLS.meta.MRRANK Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRRANK, System = 4 ]
{

/// Termgroup ranking // MAXLEN = 4
Property RANK As %String(MAXLEN = 4);

/// Source abbreviation // MAXLEN = 15
Property SAB As %String(MAXLEN = 16);

/// Suppressible flag // MAXLEN = 1
Property SUPPRESS As %String(MAXLEN = 1);

/// Term type in source // MAXLEN = 11
Property TTY As %String(MAXLEN = 16);

Index XMRRANKPK On (SAB, TTY) [ PrimaryKey, SqlName = X_MRRANK_PK, Type = index, Unique ];

Storage Default
{
<Data name="MRRANKDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RANK</Value>
</Value>
<Value name="3">
<Value>SAB</Value>
</Value>
<Value name="4">
<Value>SUPPRESS</Value>
</Value>
<Value name="5">
<Value>TTY</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRRANKD</DataLocation>
<DefaultData>MRRANKDefaultData</DefaultData>
<ExtentSize>797</ExtentSize>
<IdLocation>^%UMLS.meta.MRRANKD</IdLocation>
<IndexLocation>^%UMLS.meta.MRRANKI</IndexLocation>
<Property name="%%CLASSNAME">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RANK">
<Selectivity>0.1255%</Selectivity>
</Property>
<Property name="SAB">
<OutlierSelectivity>.072773:"NCI"</OutlierSelectivity>
<Selectivity>0.6223%</Selectivity>
</Property>
<Property name="SUPPRESS">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="TTY">
<OutlierSelectivity>.141782:"PT"</OutlierSelectivity>
<Selectivity>0.3054%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-16</BlockCount>
</SQLMap>
<SQLMap name="X_MRRANK_PK">
<BlockCount>-8</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRRANKS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
