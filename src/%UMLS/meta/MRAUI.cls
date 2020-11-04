/// AUI History
Class %UMLS.meta.MRAUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRAUI, System = 4 ]
{

/// Unique identifier for first atom // MAXLEN = 9
Property AUI1 As %String(MAXLEN = 16);

/// Unique identifier for second atom // MAXLEN = 9
Property AUI2 As %String(MAXLEN = 16);

/// Unique identifier for first concept // MAXLEN = 8
Property CUI1 As %String(MAXLEN = 8);

/// Unique identifier for second concept // MAXLEN = 8
Property CUI2 As %String(MAXLEN = 8);

/// Mapping in current subset // MAXLEN = 1
Property MAPIN As %String(MAXLEN = 1);

/// Reason for mapping // MAXLEN = 4
Property MAPREASON As %String(MAXLEN = 4);

/// Relationship label // MAXLEN = 0
Property REL As %String(MAXLEN = 1);

/// Additional relationship label // MAXLEN = 0
Property RELA As %String(MAXLEN = 1);

/// Last release version in which CUI1 was valid // MAXLEN = 6
Property VER As %String(MAXLEN = 8);

Index XMRAUICUI2 On CUI2 [ SqlName = X_MRAUI_CUI2, Type = index ];

Storage Default
{
<Data name="MRAUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AUI1</Value>
</Value>
<Value name="3">
<Value>AUI2</Value>
</Value>
<Value name="4">
<Value>CUI1</Value>
</Value>
<Value name="5">
<Value>CUI2</Value>
</Value>
<Value name="6">
<Value>MAPIN</Value>
</Value>
<Value name="7">
<Value>MAPREASON</Value>
</Value>
<Value name="8">
<Value>REL</Value>
</Value>
<Value name="9">
<Value>RELA</Value>
</Value>
<Value name="10">
<Value>VER</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRAUID</DataLocation>
<DefaultData>MRAUIDefaultData</DefaultData>
<ExtentSize>227495</ExtentSize>
<IdLocation>^%UMLS.meta.MRAUID</IdLocation>
<IndexLocation>^%UMLS.meta.MRAUII</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999511:</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="AUI1">
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="AUI2">
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="CUI1">
<Selectivity>0.0081%</Selectivity>
</Property>
<Property name="CUI2">
<Selectivity>0.0085%</Selectivity>
</Property>
<Property name="MAPIN">
<OutlierSelectivity>.999511:"Y"</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="MAPREASON">
<OutlierSelectivity>.999511:"move"</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="REL">
<OutlierSelectivity>.999511:</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="RELA">
<OutlierSelectivity>.999511:</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="VER">
<Selectivity>4.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-8728</BlockCount>
</SQLMap>
<SQLMap name="X_MRAUI_CUI2">
<BlockCount>-1112</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRAUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
