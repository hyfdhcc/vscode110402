Class %DeepSee.Report.Model.Link Extends Stylable [ System = 4 ]
{

Parameter XMLNAME = "link";

Property destination As %String(MAXLEN = "", XMLPROJECTION = "ATTRIBUTE");

Property internal As %Boolean(XMLPROJECTION = "ATTRIBUTE");

Property name As %String(MAXLEN = "", XMLPROJECTION = "ATTRIBUTE");

Storage Default
{
<Data name="LinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>destination</Value>
</Value>
<Value name="3">
<Value>internal</Value>
</Value>
<Value name="4">
<Value>name</Value>
</Value>
</Data>
<DataLocation>^%DeepSee.Report.Model.LinkD</DataLocation>
<DefaultData>LinkDefaultData</DefaultData>
<IdLocation>^%DeepSee.Report.Model.LinkD</IdLocation>
<IndexLocation>^%DeepSee.Report.Model.LinkI</IndexLocation>
<StreamLocation>^%DeepSee.Report.Model.LinkS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
