Include %syConfig

/// This class contains information about the conversions carried out on the CPf file
/// when either the system is upgraded, or the Config.CPF.Convert() method is run on
/// a CPF file.<br>
/// Conversion details are stored as comments in the CPF file in this section.<br>
/// These comments can be removed or edited at any time.
Class Config.Conversions Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Last time the CPF file was converted.<br>
Property LastConvertTime As %String(MAXLEN = 32, MINLEN = 1) [ InitialExpression = {$zdatetime($h,3)}, Required ];

Storage Default
{
<Data name="ConversionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comments</Value>
</Value>
<Value name="3">
<Value>LastConvertTime</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>configDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
