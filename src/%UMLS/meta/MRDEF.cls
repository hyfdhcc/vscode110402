/// Definitions
Class %UMLS.meta.MRDEF Extends %Persistent [ DdlAllowed, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for attribute // MAXLEN = 11
Property ATUI As %String(MAXLEN = 16);

/// Unique identifier for atom // MAXLEN = 9
Property AUI As %String(MAXLEN = 16);

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8);

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// Definition // MAXLEN = 10258
Property DEF As %String(COLLATION = "SqlUpper(150)", MAXLEN = 16384);

/// Source abbreviation // MAXLEN = 11
Property SAB As %String(MAXLEN = 16);

/// Source asserted attribute identifier // MAXLEN = 10
Property SATUI As %String(MAXLEN = 16);

/// Suppressible flag // MAXLEN = 1
Property SUPPRESS As %String(MAXLEN = 1);

Index XMRDEFAUI On AUI [ SqlName = X_MRDEF_AUI, Type = index ];

Index XMRDEFCUI On CUI [ SqlName = X_MRDEF_CUI, Type = index ];

Index XMRDEFPK On ATUI [ PrimaryKey, SqlName = X_MRDEF_PK, Type = index, Unique ];

Index XMRDEFSAB On SAB [ SqlName = X_MRDEF_SAB, Type = index ];

Storage Default
{
<Data name="MRDEFDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ATUI</Value>
</Value>
<Value name="3">
<Value>AUI</Value>
</Value>
<Value name="4">
<Value>CUI</Value>
</Value>
<Value name="5">
<Value>CVF</Value>
</Value>
<Value name="6">
<Value>DEF</Value>
</Value>
<Value name="7">
<Value>SAB</Value>
</Value>
<Value name="8">
<Value>SATUI</Value>
</Value>
<Value name="9">
<Value>SUPPRESS</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRDEFD</DataLocation>
<DefaultData>MRDEFDefaultData</DefaultData>
<ExtentSize>202346</ExtentSize>
<IdLocation>^%UMLS.meta.MRDEFD</IdLocation>
<IndexLocation>^%UMLS.meta.MRDEFI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999481:</OutlierSelectivity>
<Selectivity>0.0052%</Selectivity>
</Property>
<Property name="AUI">
<Selectivity>0.0005%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0007%</Selectivity>
</Property>
<Property name="CVF">
<OutlierSelectivity>.999481:</OutlierSelectivity>
<Selectivity>0.0052%</Selectivity>
</Property>
<Property name="DEF">
<Selectivity>0.0014%</Selectivity>
</Property>
<Property name="SAB">
<OutlierSelectivity>.417346:"NCI"</OutlierSelectivity>
<Selectivity>1.5747%</Selectivity>
</Property>
<Property name="SATUI">
<OutlierSelectivity>.991846:</OutlierSelectivity>
<Selectivity>0.0005%</Selectivity>
</Property>
<Property name="SUPPRESS">
<OutlierSelectivity>.999481:"N"</OutlierSelectivity>
<Selectivity>0.0052%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-32524</BlockCount>
</SQLMap>
<SQLMap name="X_MRDEF_AUI">
<BlockCount>-1608</BlockCount>
</SQLMap>
<SQLMap name="X_MRDEF_CUI">
<BlockCount>-1488</BlockCount>
</SQLMap>
<SQLMap name="X_MRDEF_PK">
<BlockCount>-1336</BlockCount>
</SQLMap>
<SQLMap name="X_MRDEF_SAB">
<BlockCount>-892</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRDEFS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
