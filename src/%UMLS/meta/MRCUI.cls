/// CUI History
Class %UMLS.meta.MRCUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRCUI, System = 4 ]
{

/// Unique identifier for first concept // MAXLEN = 8
Property CUI1 As %String(MAXLEN = 8);

/// Unique identifier for second concept // MAXLEN = 8
Property CUI2 As %String(MAXLEN = 8);

/// Mapping in current subset // MAXLEN = 1
Property MAPIN As %String(MAXLEN = 1);

/// Reason for mapping // MAXLEN = 4
Property MAPREASON As %String(MAXLEN = 4);

/// Relationship label // MAXLEN = 3
Property REL As %String(MAXLEN = 4);

/// Additional relationship label // MAXLEN = 0
Property RELA As %String(MAXLEN = 1);

/// Last release version in which CUI1 was valid // MAXLEN = 6
Property VER As %String(MAXLEN = 8);

Index XMRCUICUI2 On CUI2 [ SqlName = X_MRCUI_CUI2, Type = index ];

Storage Default
{
<Data name="MRCUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUI1</Value>
</Value>
<Value name="3">
<Value>CUI2</Value>
</Value>
<Value name="4">
<Value>MAPIN</Value>
</Value>
<Value name="5">
<Value>MAPREASON</Value>
</Value>
<Value name="6">
<Value>REL</Value>
</Value>
<Value name="7">
<Value>RELA</Value>
</Value>
<Value name="8">
<Value>VER</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRCUID</DataLocation>
<DefaultData>MRCUIDefaultData</DefaultData>
<ExtentSize>666320</ExtentSize>
<IdLocation>^%UMLS.meta.MRCUID</IdLocation>
<IndexLocation>^%UMLS.meta.MRCUII</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999714:</OutlierSelectivity>
<Selectivity>0.0029%</Selectivity>
</Property>
<Property name="CUI1">
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="CUI2">
<OutlierSelectivity>.066149:</OutlierSelectivity>
<Selectivity>0.0116%</Selectivity>
</Property>
<Property name="MAPIN">
<OutlierSelectivity>.933851:"Y"</OutlierSelectivity>
<Selectivity>6.6149%</Selectivity>
</Property>
<Property name="MAPREASON">
<OutlierSelectivity>.999592:</OutlierSelectivity>
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="REL">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RELA">
<OutlierSelectivity>.999714:</OutlierSelectivity>
<Selectivity>0.0029%</Selectivity>
</Property>
<Property name="VER">
<OutlierSelectivity>.179665:"2013AA"</OutlierSelectivity>
<Selectivity>1.8230%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-17348</BlockCount>
</SQLMap>
<SQLMap name="X_MRCUI_CUI2">
<BlockCount>-3444</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRCUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
