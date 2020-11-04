/// Source-asserted history
Class %UMLS.meta.MRHIST Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRHIST, System = 4 ]
{

/// CONCEPTSTATUS (if history relates to a SNOMED CT concept) or DESCRIPTIONSTATUS (if history relates to a SNOMED CT atom or "description") // MAXLEN = 0
Property CHANGEKEY As %String(MAXLEN = 1);

/// Source asserted code for type of change // MAXLEN = 0
Property CHANGETYPE As %String(MAXLEN = 1);

/// SNOMED CT CONCEPTSTATUS or DESCRIPTIONSTATUS value after the change took place // MAXLEN = 0
Property CHANGEVAL As %String(MAXLEN = 1);

/// Unique identifier for concept // MAXLEN = 0
Property CUI As %String(MAXLEN = 1);

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// Explanation of change, if present // MAXLEN = 0
Property REASON As %String(MAXLEN = 1);

/// Source abbreviation // MAXLEN = 0
Property SAB As %String(MAXLEN = 1);

/// Source asserted unique identifier // MAXLEN = 0
Property SOURCEUI As %String(MAXLEN = 1);

/// Release date or version number of a source // MAXLEN = 0
Property SVER As %String(MAXLEN = 1);

Index XMRHISTCUI On CUI [ SqlName = X_MRHIST_CUI, Type = index ];

Index XMRHISTSAB On SAB [ SqlName = X_MRHIST_SAB, Type = index ];

Index XMRHISTSOURCEUI On SOURCEUI [ SqlName = X_MRHIST_SOURCEUI, Type = index ];

Storage Default
{
<Data name="MRHISTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CHANGEKEY</Value>
</Value>
<Value name="3">
<Value>CHANGETYPE</Value>
</Value>
<Value name="4">
<Value>CHANGEVAL</Value>
</Value>
<Value name="5">
<Value>CUI</Value>
</Value>
<Value name="6">
<Value>CVF</Value>
</Value>
<Value name="7">
<Value>REASON</Value>
</Value>
<Value name="8">
<Value>SAB</Value>
</Value>
<Value name="9">
<Value>SOURCEUI</Value>
</Value>
<Value name="10">
<Value>SVER</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRHISTD</DataLocation>
<DefaultData>MRHISTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRHISTD</IdLocation>
<IndexLocation>^%UMLS.meta.MRHISTI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRHISTS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
