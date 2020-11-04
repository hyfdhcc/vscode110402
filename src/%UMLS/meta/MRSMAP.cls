/// Simple Mappings
Class %UMLS.meta.MRSMAP Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRSMAP, System = 4 ]
{

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// The expression that a mapping is mapped from // MAXLEN = 8
Property FROMEXPR As %String(MAXLEN = 8);

/// The type of expression that a mapping is mapped from // MAXLEN = 4
Property FROMTYPE As %String(MAXLEN = 4);

/// Metathesaurus asserted identifier for mapping // MAXLEN = 11
Property MAPID As %String(MAXLEN = 16);

/// CUI of the map set // MAXLEN = 8
Property MAPSETCUI As %String(MAXLEN = 8);

/// SAB of the map set // MAXLEN = 13
Property MAPSETSAB As %String(MAXLEN = 16);

/// Source asserted identifier for mapping // MAXLEN = 0
Property MAPSID As %String(MAXLEN = 1);

/// Relationship label // MAXLEN = 2
Property REL As %String(MAXLEN = 2);

/// Additional relationship label // MAXLEN = 13
Property RELA As %String(MAXLEN = 16);

/// The expression that a mapping is mapped to // MAXLEN = 242
Property TOEXPR As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

/// The type of expression that a mapping is mapped to // MAXLEN = 23
Property TOTYPE As %String(MAXLEN = 32);

Storage Default
{
<Data name="MRSMAPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CVF</Value>
</Value>
<Value name="3">
<Value>FROMEXPR</Value>
</Value>
<Value name="4">
<Value>FROMTYPE</Value>
</Value>
<Value name="5">
<Value>MAPID</Value>
</Value>
<Value name="6">
<Value>MAPSETCUI</Value>
</Value>
<Value name="7">
<Value>MAPSETSAB</Value>
</Value>
<Value name="8">
<Value>MAPSID</Value>
</Value>
<Value name="9">
<Value>REL</Value>
</Value>
<Value name="10">
<Value>RELA</Value>
</Value>
<Value name="11">
<Value>TOEXPR</Value>
</Value>
<Value name="12">
<Value>TOTYPE</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRSMAPD</DataLocation>
<DefaultData>MRSMAPDefaultData</DefaultData>
<ExtentSize>226872</ExtentSize>
<IdLocation>^%UMLS.meta.MRSMAPD</IdLocation>
<IndexLocation>^%UMLS.meta.MRSMAPI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.99951:</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="CVF">
<OutlierSelectivity>.99951:</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="FROMEXPR">
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="FROMTYPE">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="MAPID">
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="MAPSETCUI">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="MAPSETSAB">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="MAPSID">
<OutlierSelectivity>.99951:</OutlierSelectivity>
<Selectivity>0.0049%</Selectivity>
</Property>
<Property name="REL">
<OutlierSelectivity>.736879:"RQ"</OutlierSelectivity>
<Selectivity>5.2624%</Selectivity>
</Property>
<Property name="RELA">
<OutlierSelectivity>.628411:"mapped_to"</OutlierSelectivity>
<Selectivity>12.3863%</Selectivity>
</Property>
<Property name="TOEXPR">
<Selectivity>0.0443%</Selectivity>
</Property>
<Property name="TOTYPE">
<OutlierSelectivity>.628411:"SDUI"</OutlierSelectivity>
<Selectivity>7.4318%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-11044</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRSMAPS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
