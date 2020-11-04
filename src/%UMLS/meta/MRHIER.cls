/// Computable hierarchies
Class %UMLS.meta.MRHIER Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRHIER, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for atom // MAXLEN = 9
Property AUI As %String(MAXLEN = 16, SELECTIVITY = 1.5);

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8);

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// The context number if the atom has multiple contexts // MAXLEN = 4
Property CXN As %String(MAXLEN = 4);

/// Source asserted hierarchical number or code of context member (if it exists) // MAXLEN = 47
Property HCD As %String(MAXLEN = 64);

/// Unique identifier for parent atom // MAXLEN = 9
Property PAUI As %String(MAXLEN = 16);

/// Path to root // MAXLEN = 370
Property PTR As %String(COLLATION = "SqlUpper(150)", MAXLEN = 512);

/// Additional relationship label // MAXLEN = 17
Property RELA As %String(MAXLEN = 32);

/// Source abbreviation // MAXLEN = 11
Property SAB As %String(MAXLEN = 16, SELECTIVITY = "10.00000%");

Index XMRHIERAUI On AUI [ SqlName = X_MRHIER_AUI, Type = index ];

Index XMRHIERCUI On CUI [ SqlName = X_MRHIER_CUI, Type = index ];

Index XMRHIERPAUI On PAUI [ SqlName = X_MRHIER_PAUI, Type = index ];

Index XMRHIERPTR On PTR [ SqlName = X_MRHIER_PTR, Type = index ];

Index XMRHIERSAB On SAB [ SqlName = X_MRHIER_SAB, Type = bitmap ];

Storage Default
{
<Data name="MRHIERDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AUI</Value>
</Value>
<Value name="3">
<Value>CUI</Value>
</Value>
<Value name="4">
<Value>CVF</Value>
</Value>
<Value name="5">
<Value>CXN</Value>
</Value>
<Value name="6">
<Value>HCD</Value>
</Value>
<Value name="7">
<Value>PAUI</Value>
</Value>
<Value name="8">
<Value>PTR</Value>
</Value>
<Value name="9">
<Value>RELA</Value>
</Value>
<Value name="10">
<Value>SAB</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRHIERD</DataLocation>
<DefaultData>MRHIERDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRHIERD</IdLocation>
<IndexLocation>^%UMLS.meta.MRHIERI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRHIERS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
