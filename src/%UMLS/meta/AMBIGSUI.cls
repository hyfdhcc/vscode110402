/// Ambiguous string identifiers
Class %UMLS.meta.AMBIGSUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = AMBIGSUI, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 16);

Index XAMBIGSUISUI On SUI [ SqlName = X_AMBIGSUI_SUI, Type = index ];

Storage Default
{
<Data name="AMBIGSUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUI</Value>
</Value>
<Value name="3">
<Value>SUI</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.AMBIGSUID</DataLocation>
<DefaultData>AMBIGSUIDefaultData</DefaultData>
<ExtentSize>186969</ExtentSize>
<IdLocation>^%UMLS.meta.AMBIGSUID</IdLocation>
<IndexLocation>^%UMLS.meta.AMBIGSUII</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.99946:</OutlierSelectivity>
<Selectivity>0.0054%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0011%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0089%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-2868</BlockCount>
</SQLMap>
<SQLMap name="X_AMBIGSUI_SUI">
<BlockCount>-1016</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.AMBIGSUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
