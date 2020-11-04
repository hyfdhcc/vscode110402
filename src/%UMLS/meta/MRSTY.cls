/// Semantic Types
Class %UMLS.meta.MRSTY Extends %Persistent [ System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8, SELECTIVITY = 1);

/// Unique identifier of Semantic type // MAXLEN = 4
Property TUI As %String(MAXLEN = 4);

/// Semantic type tree number // MAXLEN = 14
Property STN As %String(MAXLEN = 100, SELECTIVITY = "1.00000%");

/// Semantic type // MAXLEN = 41
Property STY As %String(MAXLEN = 100, SELECTIVITY = "1.00000%");

/// Unique identifier for attribute // MAXLEN = 11
Property ATUI As %String(MAXLEN = 11);

/// Content view flag // MAXLEN = 4
Property CVF As %Integer;

Index iCUI On CUI;

Index iSTY On STY [ Type = bitmap ];

Index iTUI On TUI [ Type = bitmap ];

Index iSTN On STN [ Type = bitmap ];

Index PK On ATUI [ PrimaryKey, Unique ];

Storage Default
{
<Data name="MRSTYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUI</Value>
</Value>
<Value name="3">
<Value>TUI</Value>
</Value>
<Value name="4">
<Value>STN</Value>
</Value>
<Value name="5">
<Value>STY</Value>
</Value>
<Value name="6">
<Value>ATUI</Value>
</Value>
<Value name="7">
<Value>CVF</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRSTYD</DataLocation>
<DefaultData>MRSTYDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRSTYD</IdLocation>
<IndexLocation>^%UMLS.meta.MRSTYI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRSTYS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
