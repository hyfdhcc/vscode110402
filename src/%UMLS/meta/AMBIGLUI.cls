/// Ambiguous term identifiers
Class %UMLS.meta.AMBIGLUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = AMBIGLUI, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 16);

Index XAMBIGLUILUI On LUI [ SqlName = X_AMBIGLUI_LUI, Type = index ];

Storage Default
{
<Data name="AMBIGLUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUI</Value>
</Value>
<Value name="3">
<Value>LUI</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.AMBIGLUID</DataLocation>
<DefaultData>AMBIGLUIDefaultData</DefaultData>
<ExtentSize>251957</ExtentSize>
<IdLocation>^%UMLS.meta.AMBIGLUID</IdLocation>
<IndexLocation>^%UMLS.meta.AMBIGLUII</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999535:</OutlierSelectivity>
<Selectivity>0.0046%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0007%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0051%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-3864</BlockCount>
</SQLMap>
<SQLMap name="X_AMBIGLUI_LUI">
<BlockCount>-1364</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.AMBIGLUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
