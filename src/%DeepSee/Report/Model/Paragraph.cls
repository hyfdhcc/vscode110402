Class %DeepSee.Report.Model.Paragraph Extends Stylable [ System = 4 ]
{

Parameter XMLNAME = "p";

Property content As %String(XMLPROJECTION = "CONTENT");

Storage Default
{
<Data name="ParagraphDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>content</Value>
</Value>
</Data>
<DataLocation>^%DeepSee.ReportC2F3.ParagraphD</DataLocation>
<DefaultData>ParagraphDefaultData</DefaultData>
<IdLocation>^%DeepSee.ReportC2F3.ParagraphD</IdLocation>
<IndexLocation>^%DeepSee.ReportC2F3.ParagraphI</IndexLocation>
<StreamLocation>^%DeepSee.ReportC2F3.ParagraphS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
