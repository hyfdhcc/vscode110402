/// Simple Concept, Term and String Attributes
Class %UMLS.meta.MRSAT Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRSAT, System = 4 ]
{

/// Attribute name // MAXLEN = 62
Property ATN As %String(MAXLEN = 64);

/// Unique identifier for attribute // MAXLEN = 11
Property ATUI As %String(MAXLEN = 16);

/// Attribute value // MAXLEN = 15047
Property ATV As %String(COLLATION = "SqlUpper(150)", MAXLEN = 16384);

/// Unique Identifier or code for string in source // MAXLEN = 50
Property CODE As %String(MAXLEN = 64);

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8);

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 16);

/// Metathesaurus asserted unique identifier // MAXLEN = 10
Property METAUI As %String(MAXLEN = 16);

/// Source abbreviation // MAXLEN = 13
Property SAB As %String(MAXLEN = 16);

/// Source asserted attribute identifier // MAXLEN = 36
Property SATUI As %String(MAXLEN = 64);

/// The name of the column in MRCONSO.RRF or MRREL.RRF that contains the identifier to which the attribute is attached // MAXLEN = 4
Property STYPE As %String(MAXLEN = 4);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 16);

/// Suppressible flag // MAXLEN = 1
Property SUPPRESS As %String(MAXLEN = 1);

Index XMRSATATN On ATN [ SqlName = X_MRSAT_ATN, Type = index ];

Index XMRSATCUI On CUI [ SqlName = X_MRSAT_CUI, Type = index ];

Index XMRSATMETAUI On METAUI [ SqlName = X_MRSAT_METAUI, Type = index ];

Index XMRSATPK On ATUI [ PrimaryKey, SqlName = X_MRSAT_PK, Type = index, Unique ];

Index XMRSATSAB On SAB [ SqlName = X_MRSAT_SAB, Type = index ];

Storage Default
{
<Data name="MRSATDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ATN</Value>
</Value>
<Value name="3">
<Value>ATUI</Value>
</Value>
<Value name="4">
<Value>ATV</Value>
</Value>
<Value name="5">
<Value>CODE</Value>
</Value>
<Value name="6">
<Value>CUI</Value>
</Value>
<Value name="7">
<Value>CVF</Value>
</Value>
<Value name="8">
<Value>LUI</Value>
</Value>
<Value name="9">
<Value>METAUI</Value>
</Value>
<Value name="10">
<Value>SAB</Value>
</Value>
<Value name="11">
<Value>SATUI</Value>
</Value>
<Value name="12">
<Value>STYPE</Value>
</Value>
<Value name="13">
<Value>SUI</Value>
</Value>
<Value name="14">
<Value>SUPPRESS</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRSATD</DataLocation>
<DefaultData>MRSATDefaultData</DefaultData>
<ExtentSize>63299281</ExtentSize>
<IdLocation>^%UMLS.meta.MRSATD</IdLocation>
<IndexLocation>^%UMLS.meta.MRSATI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999971:</OutlierSelectivity>
<Selectivity>0.0003%</Selectivity>
</Property>
<Property name="ATN">
<OutlierSelectivity>.102313:"SUBSET_MEMBER"</OutlierSelectivity>
<Selectivity>0.3023%</Selectivity>
</Property>
<Property name="ATV">
<OutlierSelectivity>.062762:900000000000451002</OutlierSelectivity>
<Selectivity>0.0144%</Selectivity>
</Property>
<Property name="CODE">
<OutlierSelectivity>.396263:</OutlierSelectivity>
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0014%</Selectivity>
</Property>
<Property name="CVF">
<OutlierSelectivity>.999971:</OutlierSelectivity>
<Selectivity>0.0003%</Selectivity>
</Property>
<Property name="LUI">
<OutlierSelectivity>.396263:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="METAUI">
<OutlierSelectivity>.140732:</OutlierSelectivity>
<Selectivity>0.0000434607037093468%</Selectivity>
</Property>
<Property name="SAB">
<OutlierSelectivity>.235923:"SNOMEDCT_US"</OutlierSelectivity>
<Selectivity>1.1236%</Selectivity>
</Property>
<Property name="SATUI">
<OutlierSelectivity>.897687:</OutlierSelectivity>
<Selectivity>0.0000015797969242071%</Selectivity>
</Property>
<Property name="STYPE">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="SUI">
<OutlierSelectivity>.396263:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="SUPPRESS">
<OutlierSelectivity>.833459:"N"</OutlierSelectivity>
<Selectivity>8.3270%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-3951136</BlockCount>
</SQLMap>
<SQLMap name="X_MRSAT_ATN">
<BlockCount>-333484</BlockCount>
</SQLMap>
<SQLMap name="X_MRSAT_CUI">
<BlockCount>-341168</BlockCount>
</SQLMap>
<SQLMap name="X_MRSAT_METAUI">
<BlockCount>-369824</BlockCount>
</SQLMap>
<SQLMap name="X_MRSAT_PK">
<BlockCount>-417868</BlockCount>
</SQLMap>
<SQLMap name="X_MRSAT_SAB">
<BlockCount>-277400</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRSATS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
