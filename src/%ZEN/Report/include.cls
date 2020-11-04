/// 
Class %ZEN.Report.include Extends reportNode [ System = 4 ]
{

/// Classname with XDATA section to include
Property class As %ZEN.Datatype.className;

/// Name of XDATA section to include
Property xdata As %ZEN.Datatype.string;

Storage Default
{
<Data name="includeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^%ZEN.Report.includeD</DataLocation>
<DefaultData>includeDefaultData</DefaultData>
<IdLocation>^%ZEN.Report.includeD</IdLocation>
<IndexLocation>^%ZEN.Report.includeI</IndexLocation>
<StreamLocation>^%ZEN.Report.includeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
