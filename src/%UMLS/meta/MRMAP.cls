/// Mappings
Class %UMLS.meta.MRMAP Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRMAP, System = 4 ]
{

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// The expression that a mapping is mapped from // MAXLEN = 15
Property FROMEXPR As %String(MAXLEN = 16);

/// Metathesaurus identifier for the entity being mapped from // MAXLEN = 15
Property FROMID As %String(MAXLEN = 16);

/// Restriction applicable to the entity being mapped from // MAXLEN = 0
Property FROMRES As %String(MAXLEN = 1);

/// Machine processible rule applicable to the entity being mapped from // MAXLEN = 0
Property FROMRULE As %String(MAXLEN = 1);

/// Source asserted identifier for the entity being mapped from // MAXLEN = 0
Property FROMSID As %String(MAXLEN = 1);

/// The type of expression that a mapping is mapped from // MAXLEN = 4
Property FROMTYPE As %String(MAXLEN = 4);

/// Mapping attribute name (for future use) // MAXLEN = 6
Property MAPATN As %String(MAXLEN = 8);

/// Mapping attribute value (for future use) // MAXLEN = 1
Property MAPATV As %String(MAXLEN = 1);

/// Metathesaurus asserted identifier for mapping // MAXLEN = 11
Property MAPID As %String(MAXLEN = 16);

/// Order in which mappings in a subset should be applied // MAXLEN = 2
Property MAPRANK As %String(MAXLEN = 2);

/// Restriction applicable to this mapping // MAXLEN = 186
Property MAPRES As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

/// Machine processible rule applicable to this mapping // MAXLEN = 145
Property MAPRULE As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

/// CUI of the map set // MAXLEN = 8
Property MAPSETCUI As %String(MAXLEN = 8);

/// SAB of the map set // MAXLEN = 13
Property MAPSETSAB As %String(MAXLEN = 16);

/// Source asserted identifier for mapping // MAXLEN = 36
Property MAPSID As %String(MAXLEN = 64);

/// Map subset identifier used to identify a subset of related mappings within a map set // MAXLEN = 3
Property MAPSUBSETID As %String(MAXLEN = 4);

/// Type of mapping // MAXLEN = 9
Property MAPTYPE As %String(MAXLEN = 16);

/// Relationship label // MAXLEN = 2
Property REL As %String(MAXLEN = 2);

/// Additional relationship label // MAXLEN = 23
Property RELA As %String(MAXLEN = 32);

/// The expression that a mapping is mapped to // MAXLEN = 242
Property TOEXPR As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

/// Metathesaurus identifier for the entity being mapped to // MAXLEN = 15
Property TOID As %String(MAXLEN = 16);

/// Restriction applicable to the entity being mapped to // MAXLEN = 0
Property TORES As %String(MAXLEN = 1);

/// Machine processible rule applicable to the entity being mapped to // MAXLEN = 0
Property TORULE As %String(MAXLEN = 1);

/// Source asserted identifier for the entity being mapped to // MAXLEN = 0
Property TOSID As %String(MAXLEN = 1);

/// The type of expression that a mapping is mapped to // MAXLEN = 23
Property TOTYPE As %String(MAXLEN = 32);

Index XMRMAPMAPSETCUI On MAPSETCUI [ SqlName = X_MRMAP_MAPSETCUI, Type = index ];

Storage Default
{
<Data name="MRMAPDefaultData">
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
<Value>FROMID</Value>
</Value>
<Value name="5">
<Value>FROMRES</Value>
</Value>
<Value name="6">
<Value>FROMRULE</Value>
</Value>
<Value name="7">
<Value>FROMSID</Value>
</Value>
<Value name="8">
<Value>FROMTYPE</Value>
</Value>
<Value name="9">
<Value>MAPATN</Value>
</Value>
<Value name="10">
<Value>MAPATV</Value>
</Value>
<Value name="11">
<Value>MAPID</Value>
</Value>
<Value name="12">
<Value>MAPRANK</Value>
</Value>
<Value name="13">
<Value>MAPRES</Value>
</Value>
<Value name="14">
<Value>MAPRULE</Value>
</Value>
<Value name="15">
<Value>MAPSETCUI</Value>
</Value>
<Value name="16">
<Value>MAPSETSAB</Value>
</Value>
<Value name="17">
<Value>MAPSID</Value>
</Value>
<Value name="18">
<Value>MAPSUBSETID</Value>
</Value>
<Value name="19">
<Value>MAPTYPE</Value>
</Value>
<Value name="20">
<Value>REL</Value>
</Value>
<Value name="21">
<Value>RELA</Value>
</Value>
<Value name="22">
<Value>TOEXPR</Value>
</Value>
<Value name="23">
<Value>TOID</Value>
</Value>
<Value name="24">
<Value>TORES</Value>
</Value>
<Value name="25">
<Value>TORULE</Value>
</Value>
<Value name="26">
<Value>TOSID</Value>
</Value>
<Value name="27">
<Value>TOTYPE</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRMAPD</DataLocation>
<DefaultData>MRMAPDefaultData</DefaultData>
<ExtentSize>602018</ExtentSize>
<IdLocation>^%UMLS.meta.MRMAPD</IdLocation>
<IndexLocation>^%UMLS.meta.MRMAPI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="CVF">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="FROMEXPR">
<Selectivity>0.0020%</Selectivity>
</Property>
<Property name="FROMID">
<Selectivity>0.0020%</Selectivity>
</Property>
<Property name="FROMRES">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="FROMRULE">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="FROMSID">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="FROMTYPE">
<Selectivity>24.9999%</Selectivity>
</Property>
<Property name="MAPATN">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="MAPATV">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="MAPID">
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="MAPRANK">
<OutlierSelectivity>.795103:</OutlierSelectivity>
<Selectivity>10.2448%</Selectivity>
</Property>
<Property name="MAPRES">
<OutlierSelectivity>.999141:</OutlierSelectivity>
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="MAPRULE">
<OutlierSelectivity>.999141:</OutlierSelectivity>
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="MAPSETCUI">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="MAPSETSAB">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="MAPSID">
<OutlierSelectivity>.795962:</OutlierSelectivity>
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="MAPSUBSETID">
<OutlierSelectivity>.38488:</OutlierSelectivity>
<Selectivity>4.7317%</Selectivity>
</Property>
<Property name="MAPTYPE">
<OutlierSelectivity>.782646:</OutlierSelectivity>
<Selectivity>2.7169%</Selectivity>
</Property>
<Property name="REL">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="RELA">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="TOEXPR">
<Selectivity>0.0266%</Selectivity>
</Property>
<Property name="TOID">
<Selectivity>0.0211%</Selectivity>
</Property>
<Property name="TORES">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="TORULE">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="TOSID">
<OutlierSelectivity>.999699:</OutlierSelectivity>
<Selectivity>0.0030%</Selectivity>
</Property>
<Property name="TOTYPE">
<OutlierSelectivity>.710481:"SDUI"</OutlierSelectivity>
<Selectivity>5.7904%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-49668</BlockCount>
</SQLMap>
<SQLMap name="X_MRMAP_MAPSETCUI">
<BlockCount>-2644</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRMAPS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
